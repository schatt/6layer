//
//  OCRService.swift
//  SixLayerFramework
//
//  OCR Service - Business Logic Layer
//  Proper separation of concerns with async/await patterns
//

import Foundation
import SwiftUI

#if canImport(Vision)
import Vision
#endif

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

// MARK: - OCR Error Types

/// OCR-specific error types
public enum OCRError: Error, LocalizedError {
    case visionUnavailable
    case invalidImage
    case noTextFound
    case processingFailed
    case unsupportedPlatform
    
    public var errorDescription: String? {
        switch self {
        case .visionUnavailable:
            return "Vision framework is not available on this platform"
        case .invalidImage:
            return "The provided image is invalid or cannot be processed"
        case .noTextFound:
            return "No text was found in the image"
        case .processingFailed:
            return "OCR processing failed"
        case .unsupportedPlatform:
            return "OCR is not supported on this platform"
        }
    }
}

// MARK: - OCR Service Protocol

/// Protocol defining OCR service capabilities
public protocol OCRServiceProtocol {
    /// Process an image for text recognition
    func processImage(
        _ image: PlatformImage,
        context: OCRContext,
        strategy: OCRStrategy
    ) async throws -> OCRResult
    
    /// Check if OCR is available on current platform
    var isAvailable: Bool { get }
    
    /// Get platform-specific OCR capabilities
    var capabilities: OCRCapabilities { get }
}

// MARK: - OCR Capabilities

/// Platform-specific OCR capabilities
public struct OCRCapabilities {
    public let supportsVision: Bool
    public let supportedLanguages: [OCRLanguage]
    public let supportedTextTypes: [TextType]
    public let maxImageSize: CGSize
    public let processingTimeEstimate: TimeInterval
    
    public init(
        supportsVision: Bool,
        supportedLanguages: [OCRLanguage],
        supportedTextTypes: [TextType],
        maxImageSize: CGSize,
        processingTimeEstimate: TimeInterval
    ) {
        self.supportsVision = supportsVision
        self.supportedLanguages = supportedLanguages
        self.supportedTextTypes = supportedTextTypes
        self.maxImageSize = maxImageSize
        self.processingTimeEstimate = processingTimeEstimate
    }
}

// MARK: - OCR Service Implementation

/// Main OCR service implementation
public class OCRService: OCRServiceProtocol {
    
    // MARK: - Properties
    
    public var isAvailable: Bool {
        return isVisionOCRAvailable()
    }
    
    public var capabilities: OCRCapabilities {
        return getOCRCapabilities()
    }
    
    // MARK: - Initialization
    
    public init() {}
    
    // MARK: - Public Methods
    
    /// Process an image for text recognition
    public func processImage(
        _ image: PlatformImage,
        context: OCRContext,
        strategy: OCRStrategy
    ) async throws -> OCRResult {
        
        guard isAvailable else {
            throw OCRError.visionUnavailable
        }
        
        guard let cgImage = getCGImage(from: image) else {
            throw OCRError.invalidImage
        }
        
        return try await performVisionOCR(
            cgImage: cgImage,
            context: context,
            strategy: strategy
        )
    }
    
    // MARK: - Private Methods
    
    private func performVisionOCR(
        cgImage: CGImage,
        context: OCRContext,
        strategy: OCRStrategy
    ) async throws -> OCRResult {
        
        return try await withCheckedThrowingContinuation { continuation in
            let request = VNRecognizeTextRequest { request, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let observations = request.results as? [VNRecognizedTextObservation] else {
                    continuation.resume(throwing: OCRError.noTextFound)
                    return
                }
                
                let result = self.processVisionResults(
                    observations: observations,
                    context: context,
                    strategy: strategy
                )
                continuation.resume(returning: result)
            }
            
            // Configure request based on strategy
            configureVisionRequest(request, context: context, strategy: strategy)
            
            let handler = VNImageRequestHandler(cgImage: cgImage)
            do {
                try handler.perform([request])
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
    
    private func configureVisionRequest(
        _ request: VNRecognizeTextRequest,
        context: OCRContext,
        strategy: OCRStrategy
    ) {
        // Configure recognition level
        switch strategy.processingMode {
        case .fast:
            request.recognitionLevel = .fast
        case .standard:
            request.recognitionLevel = .accurate
        case .accurate:
            request.recognitionLevel = .accurate
        case .neural:
            request.recognitionLevel = .accurate
        }
        
        // Configure language
        request.recognitionLanguages = [context.language.rawValue]
        
        // Configure text types
        if !strategy.supportedTextTypes.isEmpty {
            // Vision framework automatically detects text types
            // We'll filter results based on our text types
        }
        
        // Configure confidence threshold
        request.minimumTextHeight = 0.01 // Minimum text height
    }
    
    private func processVisionResults(
        observations: [VNRecognizedTextObservation],
        context: OCRContext,
        strategy: OCRStrategy
    ) -> OCRResult {
        
        var extractedText = ""
        var boundingBoxes: [CGRect] = []
        var textTypes: [TextType: String] = [:]
        var totalConfidence: Float = 0.0
        var validObservations = 0
        
        for observation in observations {
            guard let topCandidate = observation.topCandidates(1).first else { continue }
            
            let text = topCandidate.string
            let confidence = topCandidate.confidence
            
            // Check confidence threshold
            guard confidence >= context.confidenceThreshold else { continue }
            
            // Filter by text types if specified
            if !strategy.supportedTextTypes.isEmpty {
                let detectedType = detectTextType(text)
                guard strategy.supportedTextTypes.contains(detectedType) else { continue }
            }
            
            extractedText += text + " "
            boundingBoxes.append(observation.boundingBox)
            textTypes[detectTextType(text)] = text
            
            totalConfidence += confidence
            validObservations += 1
        }
        
        // Calculate average confidence
        let averageConfidence = validObservations > 0 ? totalConfidence / Float(validObservations) : 0.0
        
        return OCRResult(
            extractedText: extractedText.trimmingCharacters(in: .whitespacesAndNewlines),
            confidence: averageConfidence,
            boundingBoxes: boundingBoxes,
            textTypes: textTypes,
            processingTime: 0.0, // Will be set by caller
            language: context.language
        )
    }
    
    private func detectTextType(_ text: String) -> TextType {
        // Simple text type detection
        if text.contains("$") || text.contains("€") || text.contains("£") {
            return .price
        } else if text.allSatisfy({ $0.isNumber || $0 == "." || $0 == "," }) {
            return .number
        } else if text.contains("@") {
            return .email
        } else if text.hasPrefix("http") || text.hasPrefix("www") {
            return .url
        } else if text.range(of: #"\d{1,2}[/-]\d{1,2}[/-]\d{2,4}"#, options: .regularExpression) != nil {
            return .date
        } else {
            return .general
        }
    }
    
    private func getCGImage(from image: PlatformImage) -> CGImage? {
        #if os(iOS)
        return image.uiImage.cgImage
        #elseif os(macOS)
        return image.nsImage.cgImage(forProposedRect: nil, context: nil, hints: nil)
        #else
        return nil
        #endif
    }
    
    private func getOCRCapabilities() -> OCRCapabilities {
        #if canImport(Vision)
        #if os(iOS)
        if #available(iOS 11.0, *) {
            return OCRCapabilities(
                supportsVision: true,
                supportedLanguages: [.english, .spanish, .french, .german, .italian, .portuguese, .chinese, .japanese, .korean, .arabic, .russian],
                supportedTextTypes: TextType.allCases,
                maxImageSize: CGSize(width: 4096, height: 4096),
                processingTimeEstimate: 2.0
            )
        }
        #elseif os(macOS)
        if #available(macOS 10.15, *) {
            return OCRCapabilities(
                supportsVision: true,
                supportedLanguages: [.english, .spanish, .french, .german, .italian, .portuguese, .chinese, .japanese, .korean, .arabic, .russian],
                supportedTextTypes: TextType.allCases,
                maxImageSize: CGSize(width: 8192, height: 8192),
                processingTimeEstimate: 1.5
            )
        }
        #endif
        #endif
        
        return OCRCapabilities(
            supportsVision: false,
            supportedLanguages: [],
            supportedTextTypes: [],
            maxImageSize: .zero,
            processingTimeEstimate: 0.0
        )
    }
}

// MARK: - Mock OCR Service

/// Mock OCR service for testing
public class MockOCRService: OCRServiceProtocol {
    
    public var isAvailable: Bool = true
    
    public var capabilities: OCRCapabilities {
        return OCRCapabilities(
            supportsVision: true,
            supportedLanguages: [.english],
            supportedTextTypes: [.general],
            maxImageSize: CGSize(width: 1000, height: 1000),
            processingTimeEstimate: 0.1
        )
    }
    
    private let mockResult: OCRResult
    
    public init(mockResult: OCRResult? = nil) {
        self.mockResult = mockResult ?? OCRResult(
            extractedText: "Mock OCR Result",
            confidence: 0.95,
            boundingBoxes: [CGRect(x: 0, y: 0, width: 100, height: 20)],
            textTypes: [.general: "Mock OCR Result"],
            processingTime: 0.1,
            language: .english
        )
    }
    
    public func processImage(
        _ image: PlatformImage,
        context: OCRContext,
        strategy: OCRStrategy
    ) async throws -> OCRResult {
        // Simulate processing time
        try await Task.sleep(nanoseconds: UInt64(mockResult.processingTime * 1_000_000_000))
        
        // Create a new result with the language from the context
        let result = OCRResult(
            extractedText: mockResult.extractedText,
            confidence: mockResult.confidence,
            boundingBoxes: mockResult.boundingBoxes,
            textTypes: mockResult.textTypes,
            processingTime: mockResult.processingTime,
            language: context.language
        )
        
        return result
    }
}

// MARK: - OCR Service Factory

/// Factory for creating OCR services
public class OCRServiceFactory {
    
    /// Create an OCR service instance
    public static func create() -> OCRServiceProtocol {
        return OCRService()
    }
    
    /// Create a mock OCR service for testing
    public static func createMock(result: OCRResult? = nil) -> OCRServiceProtocol {
        return MockOCRService(mockResult: result)
    }
}
