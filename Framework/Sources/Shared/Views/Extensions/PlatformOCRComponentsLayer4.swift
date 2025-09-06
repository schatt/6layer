//
//  PlatformOCRComponentsLayer4.swift
//  SixLayerFramework
//
//  Layer 4: OCR Component Implementation
//  Cross-platform OCR components using Vision framework
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

// MARK: - Layer 4: OCR Component Implementation

/// Cross-platform OCR implementation using Vision framework
@ViewBuilder
public func platformOCRImplementation_L4(
    image: PlatformImage,
    context: OCRContext,
    strategy: OCRStrategy,
    onResult: @escaping (OCRResult) -> Void
) -> some View {
    safePlatformOCRImplementation_L4(
        image: image,
        context: context,
        strategy: strategy,
        onResult: onResult,
        onError: { error in
            // Handle error by creating a fallback result
            let fallbackResult = OCRResult(
                extractedText: "OCR processing failed: \(error.localizedDescription)",
                confidence: 0.0,
                boundingBoxes: [],
                textTypes: [:],
                processingTime: 0.0,
                language: context.language
            )
            onResult(fallbackResult)
        }
    )
}

/// Cross-platform text extraction implementation
@ViewBuilder
public func platformTextExtraction_L4(
    image: PlatformImage,
    context: OCRContext,
    layout: OCRLayout,
    strategy: OCRStrategy,
    onResult: @escaping (OCRResult) -> Void
) -> some View {
    safePlatformOCRImplementation_L4(
        image: image,
        context: context,
        strategy: strategy,
        onResult: onResult,
        onError: { error in
            // Handle error by creating a fallback result
            let fallbackResult = OCRResult(
                extractedText: "Text extraction failed: \(error.localizedDescription)",
                confidence: 0.0,
                boundingBoxes: [],
                textTypes: [:],
                processingTime: 0.0,
                language: context.language
            )
            onResult(fallbackResult)
        }
    )
}

/// Cross-platform document analysis implementation
@ViewBuilder
public func platformDocumentAnalysis_L4(
    image: PlatformImage,
    documentType: DocumentType,
    context: OCRContext,
    layout: OCRLayout,
    strategy: OCRStrategy,
    onResult: @escaping (OCRResult) -> Void
) -> some View {
    safePlatformOCRImplementation_L4(
        image: image,
        context: context,
        strategy: strategy,
        onResult: onResult,
        onError: { error in
            // Handle error by creating a fallback result
            let fallbackResult = OCRResult(
                extractedText: "Document analysis failed: \(error.localizedDescription)",
                confidence: 0.0,
                boundingBoxes: [],
                textTypes: [:],
                processingTime: 0.0,
                language: context.language
            )
            onResult(fallbackResult)
        }
    )
}

/// Cross-platform text recognition component
@ViewBuilder
public func platformTextRecognition_L4(
    image: PlatformImage,
    options: TextRecognitionOptions,
    onResult: @escaping (OCRResult) -> Void
) -> some View {
    #if os(iOS)
    iOSTextRecognitionView(
        image: image,
        options: options,
        onResult: onResult
    )
    #elseif os(macOS)
    MacOSTextRecognitionView(
        image: image,
        options: options,
        onResult: onResult
    )
    #else
    Text("Text recognition not available on this platform")
        .foregroundColor(.secondary)
    #endif
}

// MARK: - iOS OCR Implementation

#if os(iOS)
struct iOSOCRView: View {
    let image: PlatformImage
    let context: OCRContext
    let strategy: OCRStrategy
    let onResult: (OCRResult) -> Void
    
    @State private var isProcessing = false
    @State private var progress: Double = 0.0
    @State private var result: OCRResult?
    
    var body: some View {
        VStack {
            if isProcessing {
                OCRProgressView(progress: progress)
            } else if let result = result {
                OCRResultView(result: result, onResult: onResult)
            } else {
                OCRImageView(image: image) {
                    startOCRProcessing()
                }
            }
        }
        .onAppear {
            startOCRProcessing()
        }
    }
    
    private func startOCRProcessing() {
        isProcessing = true
        progress = 0.0
        
        Task {
            do {
                let result = try await performOCRProcessing()
                await MainActor.run {
                    self.result = result
                    self.isProcessing = false
                    self.onResult(result)
                }
            } catch {
                await MainActor.run {
                    self.isProcessing = false
                    // Handle error
                }
            }
        }
    }
    
    private func performOCRProcessing() async throws -> OCRResult {
        return try await withCheckedThrowingContinuation { continuation in
            guard let cgImage = getCGImage(from: image) else {
                continuation.resume(throwing: OCRError.invalidImage)
                return
            }
            
            let request = VNRecognizeTextRequest { request, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let observations = request.results as? [VNRecognizedTextObservation] else {
                    continuation.resume(throwing: OCRError.noTextFound)
                    return
                }
                
                let result = processVisionResults(observations, context: context)
                continuation.resume(returning: result)
            }
            
            // Configure request based on strategy
            configureVisionRequest(request, strategy: strategy)
            
            // Perform request
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            do {
                try handler.perform([request])
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
    
    private func configureVisionRequest(_ request: VNRecognizeTextRequest, strategy: OCRStrategy) {
        request.recognitionLevel = strategy.processingMode == .neural ? .accurate : .fast
        request.usesLanguageCorrection = true
        request.recognitionLanguages = strategy.supportedLanguages.map { $0.rawValue }
    }
    
    private func processVisionResults(_ observations: [VNRecognizedTextObservation], context: OCRContext) -> OCRResult {
        var extractedText = ""
        var boundingBoxes: [CGRect] = []
        var textTypes: [TextType: String] = [:]
        var totalConfidence: Float = 0.0
        
        for observation in observations {
            guard let topCandidate = observation.topCandidates(1).first else { continue }
            
            let text = topCandidate.string
            let confidence = topCandidate.confidence
            
            extractedText += text + "\n"
            totalConfidence += confidence
            
            if context.textTypes.contains(.price) && isPrice(text) {
                textTypes[.price] = text
            }
            if context.textTypes.contains(.date) && isDate(text) {
                textTypes[.date] = text
            }
            if context.textTypes.contains(.email) && isEmail(text) {
                textTypes[.email] = text
            }
            if context.textTypes.contains(.phone) && isPhone(text) {
                textTypes[.phone] = text
            }
            if context.textTypes.contains(.number) && isNumber(text) {
                textTypes[.number] = text
            }
            
            if context.textTypes.contains(.general) && textTypes.isEmpty {
                textTypes[.general] = text
            }
            
            // Convert bounding box to image coordinates
            let boundingBox = observation.boundingBox
            let imageSize = CGSize(width: image.size.width, height: image.size.height)
            let convertedBox = VNImageRectForNormalizedRect(boundingBox, Int(imageSize.width), Int(imageSize.height))
            boundingBoxes.append(convertedBox)
        }
        
        let averageConfidence = observations.isEmpty ? 0.0 : totalConfidence / Float(observations.count)
        
        return OCRResult(
            extractedText: extractedText.trimmingCharacters(in: .whitespacesAndNewlines),
            confidence: averageConfidence,
            boundingBoxes: boundingBoxes,
            textTypes: textTypes,
            processingTime: 0.0, // Will be set by the caller
            language: context.language
        )
    }
}

// MARK: - iOS Text Recognition View

struct iOSTextRecognitionView: View {
    let image: PlatformImage
    let options: TextRecognitionOptions
    let onResult: (OCRResult) -> Void
    
    var body: some View {
        iOSOCRView(
            image: image,
            context: OCRContext(
                textTypes: options.textTypes,
                language: options.language,
                confidenceThreshold: options.confidenceThreshold,
                allowsEditing: options.enableTextCorrection
            ),
            strategy: OCRStrategy(
                supportedTextTypes: options.textTypes,
                supportedLanguages: [options.language],
                processingMode: .standard,
                requiresNeuralEngine: false,
                estimatedProcessingTime: 1.0
            ),
            onResult: onResult
        )
    }
}

// MARK: - iOS Document Analysis View

struct iOSDocumentAnalysisView: View {
    let image: PlatformImage
    let documentType: DocumentType
    let context: OCRContext
    let layout: OCRLayout
    let strategy: OCRStrategy
    let onResult: (OCRResult) -> Void
    
    var body: some View {
        iOSOCRView(
            image: image,
            context: context,
            strategy: strategy,
            onResult: onResult
        )
    }
}

// MARK: - iOS Text Extraction View

struct iOSTextExtractionView: View {
    let image: PlatformImage
    let context: OCRContext
    let layout: OCRLayout
    let strategy: OCRStrategy
    let onResult: (OCRResult) -> Void
    
    var body: some View {
        iOSOCRView(
            image: image,
            context: context,
            strategy: strategy,
            onResult: onResult
        )
    }
}

#endif

// MARK: - macOS OCR Implementation

#if os(macOS)
struct MacOSOCRView: View {
    let image: PlatformImage
    let context: OCRContext
    let strategy: OCRStrategy
    let onResult: (OCRResult) -> Void
    
    @State private var isProcessing = false
    @State private var progress: Double = 0.0
    @State private var result: OCRResult?
    
    var body: some View {
        VStack {
            if isProcessing {
                OCRProgressView(progress: progress)
            } else if let result = result {
                OCRResultView(result: result, onResult: onResult)
            } else {
                OCRImageView(image: image) {
                    startOCRProcessing()
                }
            }
        }
        .onAppear {
            startOCRProcessing()
        }
    }
    
    private func startOCRProcessing() {
        isProcessing = true
        progress = 0.0
        
        Task {
            do {
                let result = try await performOCRProcessing()
                await MainActor.run {
                    self.result = result
                    self.isProcessing = false
                    self.onResult(result)
                }
            } catch {
                await MainActor.run {
                    self.isProcessing = false
                    // Handle error
                }
            }
        }
    }
    
    private func performOCRProcessing() async throws -> OCRResult {
        return try await withCheckedThrowingContinuation { continuation in
            guard let cgImage = getCGImage(from: image) else {
                continuation.resume(throwing: OCRError.invalidImage)
                return
            }
            
            let request = VNRecognizeTextRequest { request, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let observations = request.results as? [VNRecognizedTextObservation] else {
                    continuation.resume(throwing: OCRError.noTextFound)
                    return
                }
                
                let result = processVisionResults(observations, context: context)
                continuation.resume(returning: result)
            }
            
            // Configure request based on strategy
            configureVisionRequest(request, strategy: strategy)
            
            // Perform request
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            do {
                try handler.perform([request])
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
    
    private func configureVisionRequest(_ request: VNRecognizeTextRequest, strategy: OCRStrategy) {
        request.recognitionLevel = strategy.processingMode == .neural ? .accurate : .fast
        request.usesLanguageCorrection = true
        request.recognitionLanguages = strategy.supportedLanguages.map { $0.rawValue }
    }
    
    private func processVisionResults(_ observations: [VNRecognizedTextObservation], context: OCRContext) -> OCRResult {
        // Same implementation as iOS
        var extractedText = ""
        var boundingBoxes: [CGRect] = []
        var textTypes: [TextType: String] = [:]
        var totalConfidence: Float = 0.0
        
        for observation in observations {
            guard let topCandidate = observation.topCandidates(1).first else { continue }
            
            let text = topCandidate.string
            let confidence = topCandidate.confidence
            
            extractedText += text + "\n"
            totalConfidence += confidence
            
            if context.textTypes.contains(.price) && isPrice(text) {
                textTypes[.price] = text
            }
            if context.textTypes.contains(.date) && isDate(text) {
                textTypes[.date] = text
            }
            if context.textTypes.contains(.email) && isEmail(text) {
                textTypes[.email] = text
            }
            if context.textTypes.contains(.phone) && isPhone(text) {
                textTypes[.phone] = text
            }
            if context.textTypes.contains(.number) && isNumber(text) {
                textTypes[.number] = text
            }
            
            if context.textTypes.contains(.general) && textTypes.isEmpty {
                textTypes[.general] = text
            }
            
            // Convert bounding box to image coordinates
            let boundingBox = observation.boundingBox
            let imageSize = CGSize(width: image.size.width, height: image.size.height)
            let convertedBox = VNImageRectForNormalizedRect(boundingBox, Int(imageSize.width), Int(imageSize.height))
            boundingBoxes.append(convertedBox)
        }
        
        let averageConfidence = observations.isEmpty ? 0.0 : totalConfidence / Float(observations.count)
        
        return OCRResult(
            extractedText: extractedText.trimmingCharacters(in: .whitespacesAndNewlines),
            confidence: averageConfidence,
            boundingBoxes: boundingBoxes,
            textTypes: textTypes,
            processingTime: 0.0,
            language: context.language
        )
    }
}

// MARK: - macOS Text Recognition View

struct MacOSTextRecognitionView: View {
    let image: PlatformImage
    let options: TextRecognitionOptions
    let onResult: (OCRResult) -> Void
    
    var body: some View {
        MacOSOCRView(
            image: image,
            context: OCRContext(
                textTypes: options.textTypes,
                language: options.language,
                confidenceThreshold: options.confidenceThreshold,
                allowsEditing: options.enableTextCorrection
            ),
            strategy: OCRStrategy(
                supportedTextTypes: options.textTypes,
                supportedLanguages: [options.language],
                processingMode: .standard,
                requiresNeuralEngine: false,
                estimatedProcessingTime: 1.0
            ),
            onResult: onResult
        )
    }
}

// MARK: - macOS Document Analysis View

struct MacOSDocumentAnalysisView: View {
    let image: PlatformImage
    let documentType: DocumentType
    let context: OCRContext
    let layout: OCRLayout
    let strategy: OCRStrategy
    let onResult: (OCRResult) -> Void
    
    var body: some View {
        MacOSOCRView(
            image: image,
            context: context,
            strategy: strategy,
            onResult: onResult
        )
    }
}

// MARK: - macOS Text Extraction View

struct MacOSTextExtractionView: View {
    let image: PlatformImage
    let context: OCRContext
    let layout: OCRLayout
    let strategy: OCRStrategy
    let onResult: (OCRResult) -> Void
    
    var body: some View {
        MacOSOCRView(
            image: image,
            context: context,
            strategy: strategy,
            onResult: onResult
        )
    }
}

#endif

// MARK: - Shared UI Components

struct OCRProgressView: View {
    let progress: Double
    
    var body: some View {
        VStack {
            ProgressView(value: progress)
                .progressViewStyle(LinearProgressViewStyle())
            Text("Processing... \(Int(progress * 100))%")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

struct OCRResultView: View {
    let result: OCRResult
    let onResult: (OCRResult) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("OCR Result")
                .font(.headline)
            
            Text("Confidence: \(Int(result.confidence * 100))%")
                .font(.caption)
                .foregroundColor(.secondary)
            
            ScrollView {
                Text(result.extractedText)
                    .font(.body)
                    .textSelection(.enabled)
            }
            .frame(maxHeight: 200)
            
            Button("Use Result") {
                onResult(result)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

struct OCRImageView: View {
    let image: PlatformImage
    let onTap: () -> Void
    
    var body: some View {
        VStack {
            Group {
                #if os(iOS)
                Image(uiImage: image.uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                #elseif os(macOS)
                Image(nsImage: image.nsImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                #else
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                #endif
            }
            .frame(maxHeight: 300)
            .onTapGesture {
                onTap()
            }
            
            Text("Tap to process")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Text Type Detection Helpers

private func isPrice(_ text: String) -> Bool {
    let pricePattern = #"\$?\d+\.?\d*"#
    return text.range(of: pricePattern, options: .regularExpression) != nil
}

private func isDate(_ text: String) -> Bool {
    let datePattern = #"\d{1,2}[/-]\d{1,2}[/-]\d{2,4}"#
    return text.range(of: datePattern, options: .regularExpression) != nil
}

private func isEmail(_ text: String) -> Bool {
    let emailPattern = #"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}"#
    return text.range(of: emailPattern, options: .regularExpression) != nil
}

private func isPhone(_ text: String) -> Bool {
    let phonePattern = #"\(?\d{3}\)?[-.\s]?\d{3}[-.\s]?\d{4}"#
    return text.range(of: phonePattern, options: .regularExpression) != nil
}

private func isNumber(_ text: String) -> Bool {
    let numberPattern = #"\d+"#
    return text.range(of: numberPattern, options: .regularExpression) != nil
}

// MARK: - Helper Functions

/// Get CGImage from PlatformImage
private func getCGImage(from image: PlatformImage) -> CGImage? {
    #if os(iOS)
    return image.uiImage.cgImage
    #elseif os(macOS)
    return image.nsImage.cgImage(forProposedRect: nil, context: nil, hints: nil)
    #else
    return nil
    #endif
}

// MARK: - OCR Errors

enum OCRError: Error {
    case invalidImage
    case noTextFound
    case processingFailed
    case unsupportedPlatform
}
