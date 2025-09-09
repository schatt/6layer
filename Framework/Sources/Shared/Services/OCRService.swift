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
    
    /// Process an image for structured data extraction
    public func processStructuredExtraction(
        _ image: PlatformImage,
        context: OCRContext
    ) async throws -> OCRResult {
        // Use existing OCR processing
        let baseResult = try await processImage(
            image,
            context: context,
            strategy: OCRStrategy(
                supportedTextTypes: context.textTypes,
                supportedLanguages: [context.language],
                processingMode: .accurate
            )
        )
        
        // Perform structured extraction
        let structuredData = extractStructuredData(from: baseResult, context: context)
        let extractionConfidence = calculateExtractionConfidence(structuredData, context: context)
        let missingFields = findMissingRequiredFields(structuredData, context: context)
        
        return OCRResult(
            extractedText: baseResult.extractedText,
            confidence: baseResult.confidence,
            boundingBoxes: baseResult.boundingBoxes,
            textTypes: baseResult.textTypes,
            processingTime: baseResult.processingTime,
            language: baseResult.language,
            structuredData: structuredData,
            extractionConfidence: extractionConfidence,
            missingRequiredFields: missingFields,
            documentType: context.documentType
        )
    }
    
    // MARK: - Structured Extraction Helper Methods
    
    private func extractStructuredData(from result: OCRResult, context: OCRContext) -> [String: String] {
        var structuredData: [String: String] = [:]
        
        // Get patterns for the document type
        let patterns = getPatterns(for: context.documentType, context: context)
        
        // Extract data using patterns
        for (field, pattern) in patterns {
            if let regex = try? NSRegularExpression(pattern: pattern, options: []) {
                let range = NSRange(location: 0, length: result.extractedText.utf16.count)
                if let match = regex.firstMatch(in: result.extractedText, options: [], range: range) {
                    if let range = Range(match.range, in: result.extractedText) {
                        structuredData[field] = String(result.extractedText[range])
                    }
                }
            }
        }
        
        // Also use text types from the base result
        for (textType, value) in result.textTypes {
            let fieldName = getFieldName(for: textType)
            if !fieldName.isEmpty {
                structuredData[fieldName] = value
            }
        }
        
        return structuredData
    }
    
    private func getPatterns(for documentType: DocumentType?, context: OCRContext) -> [String: String] {
        var patterns: [String: String] = [:]
        
        // Use built-in patterns for known document types
        if let documentType = documentType {
            patterns = BuiltInPatterns.patterns[documentType] ?? [:]
        }
        
        // Override with custom hints if provided
        for (key, value) in context.extractionHints {
            patterns[key] = value
        }
        
        return patterns
    }
    
    private func calculateExtractionConfidence(_ structuredData: [String: String], context: OCRContext) -> Float {
        guard !context.requiredFields.isEmpty else {
            return structuredData.isEmpty ? 0.0 : 1.0
        }
        
        let foundFields = context.requiredFields.filter { structuredData.keys.contains($0) }
        return Float(foundFields.count) / Float(context.requiredFields.count)
    }
    
    private func findMissingRequiredFields(_ structuredData: [String: String], context: OCRContext) -> [String] {
        return context.requiredFields.filter { !structuredData.keys.contains($0) }
    }
    
    private func getFieldName(for textType: TextType) -> String {
        switch textType {
        case .price:
            return "price"
        case .date:
            return "date"
        case .number:
            return "number"
        case .name:
            return "name"
        case .idNumber:
            return "idNumber"
        case .stationName:
            return "stationName"
        case .total:
            return "total"
        case .vendor:
            return "vendor"
        case .expiryDate:
            return "expiryDate"
        case .quantity:
            return "quantity"
        case .unit:
            return "unit"
        case .currency:
            return "currency"
        case .percentage:
            return "percentage"
        case .postalCode:
            return "postalCode"
        case .state:
            return "state"
        case .country:
            return "country"
        case .general:
            return "general"
        case .address:
            return "address"
        case .email:
            return "email"
        case .phone:
            return "phone"
        case .url:
            return "url"
        }
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
    
    // MARK: - Structured Extraction Helper Methods
    
    private func extractStructuredData(from result: OCRResult, context: OCRContext) -> [String: String] {
        var structuredData: [String: String] = [:]
        let text = result.extractedText
        
        // Get patterns based on extraction mode
        let patterns = getPatterns(for: context)
        
        // Apply patterns to extract structured data
        for (fieldName, pattern) in patterns {
            if let regex = try? NSRegularExpression(pattern: pattern, options: []) {
                let range = NSRange(text.startIndex..., in: text)
                if let match = regex.firstMatch(in: text, options: [], range: range) {
                    if let matchRange = Range(match.range(at: 1), in: text) {
                        let extractedValue = String(text[matchRange])
                        structuredData[fieldName] = extractedValue
                    }
                }
            }
        }
        
        return structuredData
    }
    
    private func getPatterns(for context: OCRContext) -> [String: String] {
        var patterns: [String: String] = [:]
        
        switch context.extractionMode {
        case .automatic:
            // Use built-in patterns for document type
            if let builtInPatterns = BuiltInPatterns.patterns[context.documentType] {
                patterns = builtInPatterns
            }
        case .custom:
            // Use custom extraction hints
            patterns = context.extractionHints
        case .hybrid:
            // Combine built-in and custom patterns
            if let builtInPatterns = BuiltInPatterns.patterns[context.documentType] {
                patterns = builtInPatterns
            }
            // Custom patterns override built-in ones
            for (key, value) in context.extractionHints {
                patterns[key] = value
            }
        }
        
        return patterns
    }
    
    private func calculateExtractionConfidence(_ structuredData: [String: String], context: OCRContext) -> Float {
        let totalFields = context.requiredFields.count
        let extractedFields = context.requiredFields.filter { structuredData[$0] != nil }.count
        
        if totalFields == 0 {
            return 1.0 // No required fields, perfect confidence
        }
        
        return Float(extractedFields) / Float(totalFields)
    }
    
    private func findMissingRequiredFields(_ structuredData: [String: String], context: OCRContext) -> [String] {
        return context.requiredFields.filter { structuredData[$0] == nil }
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
