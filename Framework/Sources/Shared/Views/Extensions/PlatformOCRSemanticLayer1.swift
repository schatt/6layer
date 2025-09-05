//
//  PlatformOCRSemanticLayer1.swift
//  SixLayerFramework
//
//  Layer 1: Semantic OCR Functions
//  Cross-platform OCR intent and text extraction interfaces
//

import SwiftUI
import Foundation

// MARK: - Layer 1: Semantic OCR Functions

/// Cross-platform semantic OCR intent interface
/// Provides intelligent text recognition based on purpose and context
@ViewBuilder
public func platformOCRIntent_L1(
    image: PlatformImage,
    textTypes: [TextType],
    onResult: @escaping (OCRResult) -> Void
) -> some View {
    // Determine the best OCR strategy based on text types
    let strategy = selectOCRStrategy_L3(textTypes: textTypes)
    
    // Create OCR context
    let context = OCRContext(
        textTypes: textTypes,
        language: .english,
        confidenceThreshold: 0.8
    )
    
    // Use the appropriate OCR implementation
    platformOCRImplementation_L4(
        image: image,
        context: context,
        strategy: strategy,
        onResult: onResult
    )
}

/// Cross-platform semantic text extraction interface
/// Provides intelligent text extraction based on context and requirements
@ViewBuilder
public func platformTextExtraction_L1(
    image: PlatformImage,
    context: OCRContext,
    onResult: @escaping (OCRResult) -> Void
) -> some View {
    // Determine optimal layout for text extraction
    let layout = determineOptimalOCRLayout_L2(context: context)
    
    // Select appropriate strategy
    let strategy = selectOCRStrategy_L3(
        textTypes: context.textTypes,
        language: context.language
    )
    
    // Use text extraction implementation
    platformTextExtraction_L4(
        image: image,
        context: context,
        layout: layout,
        strategy: strategy,
        onResult: onResult
    )
}

/// Cross-platform semantic document analysis interface
/// Provides intelligent document analysis based on document type
@ViewBuilder
public func platformDocumentAnalysis_L1(
    image: PlatformImage,
    documentType: DocumentType,
    onResult: @escaping (OCRResult) -> Void
) -> some View {
    // Determine text types based on document type
    let textTypes = determineTextTypesForDocument(documentType)
    
    // Create specialized context for document type
    let context = OCRContext(
        textTypes: textTypes,
        language: .english,
        confidenceThreshold: 0.9, // Higher confidence for documents
        allowsEditing: true
    )
    
    // Determine optimal layout for document analysis
    let layout = determineOptimalOCRLayout_L2(context: context)
    
    // Select document-specific strategy
    let strategy = selectDocumentAnalysisStrategy_L3(
        documentType: documentType,
        textTypes: textTypes
    )
    
    // Use document analysis implementation
    platformDocumentAnalysis_L4(
        image: image,
        documentType: documentType,
        context: context,
        layout: layout,
        strategy: strategy,
        onResult: onResult
    )
}

/// Cross-platform semantic receipt analysis interface
/// Specialized interface for receipt text extraction and analysis
@ViewBuilder
public func platformReceiptAnalysis_L1(
    image: PlatformImage,
    onResult: @escaping (OCRResult) -> Void
) -> some View {
    // Receipt-specific text types
    let textTypes: [TextType] = [.price, .number, .date, .general]
    
    // Receipt-specific context
    let context = OCRContext(
        textTypes: textTypes,
        language: .english,
        confidenceThreshold: 0.85,
        allowsEditing: true
    )
    
    // Use document analysis for receipts
    platformDocumentAnalysis_L1(
        image: image,
        documentType: .receipt,
        onResult: onResult
    )
}

/// Cross-platform semantic business card analysis interface
/// Specialized interface for business card text extraction
@ViewBuilder
public func platformBusinessCardAnalysis_L1(
    image: PlatformImage,
    onResult: @escaping (OCRResult) -> Void
) -> some View {
    // Business card-specific text types
    let textTypes: [TextType] = [.email, .phone, .address, .general]
    
    // Business card-specific context
    let context = OCRContext(
        textTypes: textTypes,
        language: .english,
        confidenceThreshold: 0.8,
        allowsEditing: true
    )
    
    // Use document analysis for business cards
    platformDocumentAnalysis_L1(
        image: image,
        documentType: .businessCard,
        onResult: onResult
    )
}

// MARK: - Helper Functions

/// Determine text types based on document type
private func determineTextTypesForDocument(_ documentType: DocumentType) -> [TextType] {
    switch documentType {
    case .receipt:
        return [.price, .number, .date, .general]
    case .invoice:
        return [.price, .number, .date, .address, .email, .general]
    case .businessCard:
        return [.email, .phone, .address, .general]
    case .form:
        return [.general, .number, .date]
    case .license:
        return [.number, .date, .general]
    case .passport:
        return [.number, .date, .general]
    case .general:
        return [.general]
    }
}

/// Select OCR strategy based on text types
private func selectOCRStrategy_L3(textTypes: [TextType]) -> OCRStrategy {
    // Determine if neural engine is needed
    let requiresNeuralEngine = textTypes.contains(.price) || textTypes.contains(.date)
    
    // Determine processing mode
    let processingMode: OCRProcessingMode = requiresNeuralEngine ? .neural : .standard
    
    // Estimate processing time
    let estimatedTime = requiresNeuralEngine ? 2.0 : 1.0
    
    return OCRStrategy(
        supportedTextTypes: textTypes,
        supportedLanguages: [.english],
        processingMode: processingMode,
        requiresNeuralEngine: requiresNeuralEngine,
        estimatedProcessingTime: estimatedTime
    )
}

/// Select OCR strategy based on text types and language
private func selectOCRStrategy_L3(textTypes: [TextType], language: OCRLanguage) -> OCRStrategy {
    // Determine if neural engine is needed
    let requiresNeuralEngine = textTypes.contains(.price) || textTypes.contains(.date)
    
    // Determine processing mode
    let processingMode: OCRProcessingMode = requiresNeuralEngine ? .neural : .standard
    
    // Estimate processing time based on language complexity
    let baseTime = requiresNeuralEngine ? 2.0 : 1.0
    let languageMultiplier = language == .english ? 1.0 : 1.5
    let estimatedTime = baseTime * languageMultiplier
    
    return OCRStrategy(
        supportedTextTypes: textTypes,
        supportedLanguages: [language],
        processingMode: processingMode,
        requiresNeuralEngine: requiresNeuralEngine,
        estimatedProcessingTime: estimatedTime
    )
}

/// Select document analysis strategy
private func selectDocumentAnalysisStrategy_L3(
    documentType: DocumentType,
    textTypes: [TextType]
) -> OCRStrategy {
    // Document-specific processing requirements
    let requiresNeuralEngine = documentType == .receipt || documentType == .invoice
    
    // Determine processing mode based on document type
    let processingMode: OCRProcessingMode = switch documentType {
    case .receipt, .invoice:
        .accurate
    case .businessCard:
        .standard
    case .form, .license, .passport:
        .neural
    case .general:
        .standard
    }
    
    // Estimate processing time based on document complexity
    let estimatedTime = switch documentType {
    case .receipt:
        1.5
    case .invoice:
        2.5
    case .businessCard:
        1.0
    case .form, .license, .passport:
        3.0
    case .general:
        1.0
    }
    
    return OCRStrategy(
        supportedTextTypes: textTypes,
        supportedLanguages: [.english],
        processingMode: processingMode,
        requiresNeuralEngine: requiresNeuralEngine,
        estimatedProcessingTime: estimatedTime
    )
}

/// Determine optimal OCR layout
private func determineOptimalOCRLayout_L2(context: OCRContext) -> OCRLayout {
    // Determine max image size based on context
    let maxImageSize = context.maxImageSize ?? CGSize(width: 4000, height: 4000)
    
    // Determine recommended size based on text types
    let recommendedSize = determineRecommendedImageSize(for: context.textTypes)
    
    // Determine processing mode based on context
    let processingMode = context.confidenceThreshold > 0.9 ? .accurate : .standard
    
    // Create UI configuration
    let uiConfiguration = OCRUIConfiguration(
        showProgress: true,
        showConfidence: context.confidenceThreshold < 0.8,
        showBoundingBoxes: true,
        allowEditing: context.allowsEditing,
        theme: .system
    )
    
    return OCRLayout(
        maxImageSize: maxImageSize,
        recommendedImageSize: recommendedSize,
        processingMode: processingMode,
        uiConfiguration: uiConfiguration
    )
}

/// Determine recommended image size based on text types
private func determineRecommendedImageSize(for textTypes: [TextType]) -> CGSize {
    // Base size
    var width: CGFloat = 1000
    var height: CGFloat = 1000
    
    // Adjust based on text types
    if textTypes.contains(.price) || textTypes.contains(.number) {
        width = max(width, 1200) // Need more width for numbers
    }
    
    if textTypes.contains(.address) {
        height = max(height, 1200) // Need more height for addresses
    }
    
    if textTypes.contains(.date) {
        width = max(width, 800)
        height = max(height, 600)
    }
    
    return CGSize(width: width, height: height)
}
