//
//  PlatformOCRStrategySelectionLayer3.swift
//  SixLayerFramework
//
//  Layer 3: OCR Strategy Selection Functions
//  Cross-platform strategy selection for OCR operations
//

import SwiftUI
import Foundation

// MARK: - Layer 3: OCR Strategy Selection Functions

/// Select optimal OCR strategy based on text types and platform
public func platformOCRStrategy_L3(
    textTypes: [TextType],
    platform: Platform = .current
) -> OCRStrategy {
    // Determine if neural engine is needed
    let requiresNeuralEngine = requiresNeuralEngineForTextTypes(textTypes)
    
    // Determine processing mode based on platform and requirements
    let processingMode = determineProcessingModeForPlatform(
        platform: platform,
        requiresNeuralEngine: requiresNeuralEngine
    )
    
    // Get supported languages for platform
    let supportedLanguages = getSupportedLanguagesForPlatform(platform)
    
    // Estimate processing time based on text types and platform
    let estimatedProcessingTime = estimateProcessingTime(
        textTypes: textTypes,
        platform: platform,
        processingMode: processingMode
    )
    
    return OCRStrategy(
        supportedTextTypes: textTypes,
        supportedLanguages: supportedLanguages,
        processingMode: processingMode,
        requiresNeuralEngine: requiresNeuralEngine,
        estimatedProcessingTime: estimatedProcessingTime
    )
}

/// Select OCR strategy for specific document type
public func platformDocumentOCRStrategy_L3(
    documentType: DocumentType,
    platform: Platform = .current
) -> OCRStrategy {
    // Get text types for document type
    let textTypes = getTextTypesForDocumentType(documentType)
    
    // Document-specific neural engine requirements
    let requiresNeuralEngine = requiresNeuralEngineForDocumentType(documentType)
    
    // Document-specific processing mode
    let processingMode = determineProcessingModeForDocumentType(
        documentType: documentType,
        platform: platform
    )
    
    // Get supported languages for platform
    let supportedLanguages = getSupportedLanguagesForPlatform(platform)
    
    // Estimate processing time for document type
    let estimatedProcessingTime = estimateProcessingTimeForDocumentType(
        documentType: documentType,
        platform: platform,
        processingMode: processingMode
    )
    
    return OCRStrategy(
        supportedTextTypes: textTypes,
        supportedLanguages: supportedLanguages,
        processingMode: processingMode,
        requiresNeuralEngine: requiresNeuralEngine,
        estimatedProcessingTime: estimatedProcessingTime
    )
}

/// Select OCR strategy for receipt processing
public func platformReceiptOCRStrategy_L3(
    platform: Platform = .current
) -> OCRStrategy {
    return platformDocumentOCRStrategy_L3(
        documentType: .receipt,
        platform: platform
    )
}

/// Select OCR strategy for business card processing
public func platformBusinessCardOCRStrategy_L3(
    platform: Platform = .current
) -> OCRStrategy {
    return platformDocumentOCRStrategy_L3(
        documentType: .businessCard,
        platform: platform
    )
}

/// Select OCR strategy for invoice processing
public func platformInvoiceOCRStrategy_L3(
    platform: Platform = .current
) -> OCRStrategy {
    return platformDocumentOCRStrategy_L3(
        documentType: .invoice,
        platform: platform
    )
}

// MARK: - Helper Functions

/// Check if neural engine is required for text types
private func requiresNeuralEngineForTextTypes(_ textTypes: [TextType]) -> Bool {
    // Neural engine is beneficial for specific text types
    return textTypes.contains(.price) ||
           textTypes.contains(.date) ||
           textTypes.contains(.email) ||
           textTypes.contains(.phone)
}

/// Check if neural engine is required for document type
private func requiresNeuralEngineForDocumentType(_ documentType: DocumentType) -> Bool {
    switch documentType {
    case .receipt, .invoice:
        return true // Price and date recognition benefit from neural engine
    case .form, .license, .passport:
        return true // Complex document layouts benefit from neural engine
    case .businessCard, .general:
        return false // Simple text recognition doesn't need neural engine
    }
}

/// Determine processing mode for platform
private func determineProcessingModeForPlatform(
    platform: Platform,
    requiresNeuralEngine: Bool
) -> OCRProcessingMode {
    switch platform {
    case .iOS:
        if requiresNeuralEngine {
            return .neural
        } else {
            return .standard
        }
    case .macOS:
        if requiresNeuralEngine {
            return .accurate // macOS doesn't have neural engine, use accurate mode
        } else {
            return .standard
        }
    case .watchOS:
        return .fast // Limited processing power on watchOS
    case .tvOS:
        return .standard // Standard processing for tvOS
    }
}

/// Determine processing mode for document type
private func determineProcessingModeForDocumentType(
    documentType: DocumentType,
    platform: Platform
) -> OCRProcessingMode {
    let baseMode = determineProcessingModeForPlatform(
        platform: platform,
        requiresNeuralEngine: requiresNeuralEngineForDocumentType(documentType)
    )
    
    // Adjust based on document complexity
    switch documentType {
    case .receipt, .invoice:
        return baseMode == .neural ? .neural : .accurate
    case .form, .license, .passport:
        return baseMode == .neural ? .neural : .accurate
    case .businessCard, .general:
        return baseMode
    }
}

/// Get supported languages for platform
private func getSupportedLanguagesForPlatform(_ platform: Platform) -> [OCRLanguage] {
    switch platform {
    case .iOS:
        return [.english, .spanish, .french, .german, .italian, .portuguese, .chinese, .japanese, .korean, .arabic, .russian]
    case .macOS:
        return [.english, .spanish, .french, .german, .italian, .portuguese, .chinese, .japanese, .korean, .arabic, .russian]
    case .watchOS:
        return [.english, .spanish, .french, .german]
    case .tvOS:
        return [.english, .spanish, .french, .german]
    }
}

/// Get text types for document type
private func getTextTypesForDocumentType(_ documentType: DocumentType) -> [TextType] {
    switch documentType {
    case .receipt:
        return [.price, .number, .date, .general]
    case .invoice:
        return [.price, .number, .date, .address, .email, .general]
    case .businessCard:
        return [.email, .phone, .address, .general]
    case .form:
        return [.general, .number, .date, .address]
    case .license:
        return [.number, .date, .general]
    case .passport:
        return [.number, .date, .general]
    case .general:
        return [.general]
    }
}

/// Estimate processing time based on text types and platform
private func estimateProcessingTime(
    textTypes: [TextType],
    platform: Platform,
    processingMode: OCRProcessingMode
) -> TimeInterval {
    // Base processing time
    var baseTime: TimeInterval = 1.0
    
    // Adjust based on text types
    if textTypes.contains(.price) {
        baseTime += 0.5
    }
    if textTypes.contains(.date) {
        baseTime += 0.3
    }
    if textTypes.contains(.email) || textTypes.contains(.phone) {
        baseTime += 0.4
    }
    if textTypes.contains(.address) {
        baseTime += 0.6
    }
    
    // Adjust based on platform capabilities
    let platformMultiplier = getPlatformProcessingMultiplier(platform)
    baseTime *= platformMultiplier
    
    // Adjust based on processing mode
    let modeMultiplier = getProcessingModeMultiplier(processingMode)
    baseTime *= modeMultiplier
    
    return baseTime
}

/// Estimate processing time for document type
private func estimateProcessingTimeForDocumentType(
    documentType: DocumentType,
    platform: Platform,
    processingMode: OCRProcessingMode
) -> TimeInterval {
    let textTypes = getTextTypesForDocumentType(documentType)
    return estimateProcessingTime(
        textTypes: textTypes,
        platform: platform,
        processingMode: processingMode
    )
}

/// Get platform processing multiplier
private func getPlatformProcessingMultiplier(_ platform: Platform) -> Double {
    switch platform {
    case .iOS:
        return 1.0 // Baseline
    case .macOS:
        return 0.8 // Generally faster on macOS
    case .watchOS:
        return 2.0 // Slower on watchOS
    case .tvOS:
        return 1.2 // Slightly slower on tvOS
    }
}

/// Get processing mode multiplier
private func getProcessingModeMultiplier(_ mode: OCRProcessingMode) -> Double {
    switch mode {
    case .fast:
        return 0.5
    case .standard:
        return 1.0
    case .accurate:
        return 1.5
    case .neural:
        return 0.8 // Neural engine is actually faster for supported operations
    }
}

/// Get optimal strategy for confidence threshold
public func platformOptimalOCRStrategy_L3(
    textTypes: [TextType],
    confidenceThreshold: Float,
    platform: Platform = .current
) -> OCRStrategy {
    // Start with base strategy
    var strategy = platformOCRStrategy_L3(textTypes: textTypes, platform: platform)
    
    // Adjust processing mode based on confidence threshold
    if confidenceThreshold > 0.9 {
        strategy = OCRStrategy(
            supportedTextTypes: strategy.supportedTextTypes,
            supportedLanguages: strategy.supportedLanguages,
            processingMode: .accurate,
            requiresNeuralEngine: strategy.requiresNeuralEngine,
            estimatedProcessingTime: strategy.estimatedProcessingTime * 1.5
        )
    } else if confidenceThreshold < 0.7 {
        strategy = OCRStrategy(
            supportedTextTypes: strategy.supportedTextTypes,
            supportedLanguages: strategy.supportedLanguages,
            processingMode: .fast,
            requiresNeuralEngine: strategy.requiresNeuralEngine,
            estimatedProcessingTime: strategy.estimatedProcessingTime * 0.7
        )
    }
    
    return strategy
}

/// Get strategy for batch processing
public func platformBatchOCRStrategy_L3(
    textTypes: [TextType],
    batchSize: Int,
    platform: Platform = .current
) -> OCRStrategy {
    // Start with base strategy
    var strategy = platformOCRStrategy_L3(textTypes: textTypes, platform: platform)
    
    // Adjust for batch processing
    let batchMultiplier = min(2.0, 1.0 + (Double(batchSize) * 0.1))
    let adjustedProcessingTime = strategy.estimatedProcessingTime * batchMultiplier
    
    // Use fast mode for batch processing to improve throughput
    let processingMode: OCRProcessingMode = batchSize > 5 ? .fast : strategy.processingMode
    
    return OCRStrategy(
        supportedTextTypes: strategy.supportedTextTypes,
        supportedLanguages: strategy.supportedLanguages,
        processingMode: processingMode,
        requiresNeuralEngine: strategy.requiresNeuralEngine,
        estimatedProcessingTime: adjustedProcessingTime
    )
}
