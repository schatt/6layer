//
//  PlatformOCRSemanticLayer1.swift
//  SixLayerFramework
//
//  Layer 1: Semantic OCR Functions (DEPRECATED)
//  Cross-platform OCR intent and text extraction interfaces
//  This file is deprecated - use OCRService instead
//

import SwiftUI
import Foundation

// MARK: - Layer 1: Semantic OCR Functions (DEPRECATED)

/// Cross-platform semantic OCR intent interface
/// Provides intelligent text recognition based on purpose and context
/// 
/// **DEPRECATED**: Use `OCRService.processImage()` instead
@available(*, deprecated, message: "Use OCRService.processImage() instead")
@ViewBuilder
public func platformOCRIntent_L1(
    image: PlatformImage,
    textTypes: [TextType],
    onResult: @escaping (OCRResult) -> Void
) -> some View {
    // Return empty view and call result asynchronously
    EmptyView()
        .onAppear {
            let fallbackResult = OCRResult(
                extractedText: "OCR processing failed: Use OCRService.processImage() instead",
                confidence: 0.0,
                boundingBoxes: [],
                textTypes: [:],
                processingTime: 0.0,
                language: .english
            )
            onResult(fallbackResult)
        }
}

/// Cross-platform semantic text extraction interface
/// Provides intelligent text extraction based on context and requirements
/// 
/// **DEPRECATED**: Use `OCRService.processImage()` instead
@available(*, deprecated, message: "Use OCRService.processImage() instead")
@ViewBuilder
public func platformTextExtraction_L1(
    image: PlatformImage,
    context: OCRContext,
    onResult: @escaping (OCRResult) -> Void
) -> some View {
    // Return empty view and call result asynchronously
    EmptyView()
        .onAppear {
            let fallbackResult = OCRResult(
                extractedText: "Text extraction failed: Use OCRService.processImage() instead",
                confidence: 0.0,
                boundingBoxes: [],
                textTypes: [:],
                processingTime: 0.0,
                language: context.language
            )
            onResult(fallbackResult)
        }
}

/// Cross-platform semantic document analysis interface
/// Provides intelligent document analysis based on document type
/// 
/// **DEPRECATED**: Use `OCRService.processImage()` instead
@available(*, deprecated, message: "Use OCRService.processImage() instead")
@ViewBuilder
public func platformDocumentAnalysis_L1(
    image: PlatformImage,
    documentType: DocumentType,
    onResult: @escaping (OCRResult) -> Void
) -> some View {
    // Return empty view and call result asynchronously
    EmptyView()
        .onAppear {
            let fallbackResult = OCRResult(
                extractedText: "Document analysis failed: Use OCRService.processImage() instead",
                confidence: 0.0,
                boundingBoxes: [],
                textTypes: [:],
                processingTime: 0.0,
                language: .english
            )
            onResult(fallbackResult)
        }
}

// MARK: - Migration Notice

/// This file has been deprecated in favor of the new OCR service architecture.
/// 
/// **New Usage:**
/// ```swift
/// let service = OCRServiceFactory.create()
/// let result = try await service.processImage(image, context: context, strategy: strategy)
/// ```
/// 
/// **Benefits of New Architecture:**
/// - Proper separation of business logic from UI
/// - Testable with unit tests
/// - Modern async/await patterns
/// - Better error handling
/// - Improved performance