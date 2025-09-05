//
//  PlatformOCRTypes.swift
//  SixLayerFramework
//
//  OCR-related types and enums for cross-platform text recognition functionality
//

import Foundation
import SwiftUI

// MARK: - Text Types

/// Types of text that can be recognized by OCR
public enum TextType: String, CaseIterable {
    case price = "price"
    case number = "number"
    case date = "date"
    case address = "address"
    case email = "email"
    case phone = "phone"
    case url = "url"
    case general = "general"
    
    public var displayName: String {
        switch self {
        case .price: return "Price"
        case .number: return "Number"
        case .date: return "Date"
        case .address: return "Address"
        case .email: return "Email"
        case .phone: return "Phone"
        case .url: return "URL"
        case .general: return "General Text"
        }
    }
}

// MARK: - Document Types

/// Types of documents that can be analyzed
public enum DocumentType: String, CaseIterable {
    case receipt = "receipt"
    case invoice = "invoice"
    case businessCard = "business_card"
    case form = "form"
    case license = "license"
    case passport = "passport"
    case general = "general"
    
    public var displayName: String {
        switch self {
        case .receipt: return "Receipt"
        case .invoice: return "Invoice"
        case .businessCard: return "Business Card"
        case .form: return "Form"
        case .license: return "License"
        case .passport: return "Passport"
        case .general: return "General Document"
        }
    }
}

// MARK: - OCR Context

/// Context information for OCR operations
public struct OCRContext {
    public let textTypes: [TextType]
    public let language: OCRLanguage
    public let confidenceThreshold: Float
    public let allowsEditing: Bool
    public let maxImageSize: CGSize?
    
    public init(
        textTypes: [TextType] = [.general],
        language: OCRLanguage = .english,
        confidenceThreshold: Float = 0.8,
        allowsEditing: Bool = true,
        maxImageSize: CGSize? = nil
    ) {
        self.textTypes = textTypes
        self.language = language
        self.confidenceThreshold = confidenceThreshold
        self.allowsEditing = allowsEditing
        self.maxImageSize = maxImageSize
    }
}

// MARK: - OCR Language

/// Supported languages for OCR
public enum OCRLanguage: String, CaseIterable {
    case english = "en"
    case spanish = "es"
    case french = "fr"
    case german = "de"
    case italian = "it"
    case portuguese = "pt"
    case chinese = "zh"
    case japanese = "ja"
    case korean = "ko"
    case arabic = "ar"
    case russian = "ru"
    
    public var displayName: String {
        switch self {
        case .english: return "English"
        case .spanish: return "Spanish"
        case .french: return "French"
        case .german: return "German"
        case .italian: return "Italian"
        case .portuguese: return "Portuguese"
        case .chinese: return "Chinese"
        case .japanese: return "Japanese"
        case .korean: return "Korean"
        case .arabic: return "Arabic"
        case .russian: return "Russian"
        }
    }
}

// MARK: - OCR Result

/// Result of OCR text recognition
public struct OCRResult {
    public let extractedText: String
    public let confidence: Float
    public let boundingBoxes: [CGRect]
    public let textTypes: [TextType: String]
    public let processingTime: TimeInterval
    public let language: OCRLanguage?
    
    public init(
        extractedText: String,
        confidence: Float,
        boundingBoxes: [CGRect] = [],
        textTypes: [TextType: String] = [:],
        processingTime: TimeInterval = 0.0,
        language: OCRLanguage? = nil
    ) {
        self.extractedText = extractedText
        self.confidence = confidence
        self.boundingBoxes = boundingBoxes
        self.textTypes = textTypes
        self.processingTime = processingTime
        self.language = language
    }
    
    /// Whether the OCR result is valid based on confidence threshold
    public var isValid: Bool {
        return confidence >= 0.5
    }
    
    /// Filter the result by confidence threshold
    public func filtered(by threshold: Float) -> OCRResult {
        if confidence >= threshold {
            return self
        } else {
            return OCRResult(
                extractedText: "",
                confidence: confidence,
                boundingBoxes: [],
                textTypes: [:],
                processingTime: processingTime,
                language: language
            )
        }
    }
    
    /// Get text for a specific type
    public func text(for type: TextType) -> String? {
        return textTypes[type]
    }
    
    /// Get all recognized text types
    public var recognizedTextTypes: [TextType] {
        return Array(textTypes.keys)
    }
}

// MARK: - OCR Configuration

/// Configuration for OCR operations
public struct OCRConfiguration {
    public let textTypes: [TextType]
    public let language: OCRLanguage
    public let confidenceThreshold: Float
    public let allowsEditing: Bool
    public let maxImageSize: CGSize?
    public let processingOptions: OCRProcessingOptions
    
    public init(
        textTypes: [TextType] = [.general],
        language: OCRLanguage = .english,
        confidenceThreshold: Float = 0.8,
        allowsEditing: Bool = true,
        maxImageSize: CGSize? = nil,
        processingOptions: OCRProcessingOptions = OCRProcessingOptions()
    ) {
        self.textTypes = textTypes
        self.language = language
        self.confidenceThreshold = confidenceThreshold
        self.allowsEditing = allowsEditing
        self.maxImageSize = maxImageSize
        self.processingOptions = processingOptions
    }
}

// MARK: - OCR Processing Options

/// Options for OCR processing
public struct OCRProcessingOptions {
    public let enableLanguageDetection: Bool
    public let enableTextCorrection: Bool
    public let enableBoundingBoxDetection: Bool
    public let enableTextTypeClassification: Bool
    public let maxProcessingTime: TimeInterval
    
    public init(
        enableLanguageDetection: Bool = true,
        enableTextCorrection: Bool = true,
        enableBoundingBoxDetection: Bool = true,
        enableTextTypeClassification: Bool = true,
        maxProcessingTime: TimeInterval = 30.0
    ) {
        self.enableLanguageDetection = enableLanguageDetection
        self.enableTextCorrection = enableTextCorrection
        self.enableBoundingBoxDetection = enableBoundingBoxDetection
        self.enableTextTypeClassification = enableTextTypeClassification
        self.maxProcessingTime = maxProcessingTime
    }
}

// MARK: - Text Recognition Options

/// Options for text recognition
public struct TextRecognitionOptions {
    public let textTypes: [TextType]
    public let language: OCRLanguage
    public let confidenceThreshold: Float
    public let enableBoundingBoxes: Bool
    public let enableTextCorrection: Bool
    
    public init(
        textTypes: [TextType] = [.general],
        language: OCRLanguage = .english,
        confidenceThreshold: Float = 0.8,
        enableBoundingBoxes: Bool = true,
        enableTextCorrection: Bool = true
    ) {
        self.textTypes = textTypes
        self.language = language
        self.confidenceThreshold = confidenceThreshold
        self.enableBoundingBoxes = enableBoundingBoxes
        self.enableTextCorrection = enableTextCorrection
    }
}

// MARK: - OCR Device Capabilities

/// Device capabilities for OCR operations
public struct OCRDeviceCapabilities {
    public let hasVisionFramework: Bool
    public let hasNeuralEngine: Bool
    public let maxImageSize: CGSize
    public let supportedLanguages: [OCRLanguage]
    public let processingPower: OCRProcessingPower
    
    public init(
        hasVisionFramework: Bool = true,
        hasNeuralEngine: Bool = false,
        maxImageSize: CGSize = CGSize(width: 4000, height: 4000),
        supportedLanguages: [OCRLanguage] = [.english],
        processingPower: OCRProcessingPower = .standard
    ) {
        self.hasVisionFramework = hasVisionFramework
        self.hasNeuralEngine = hasNeuralEngine
        self.maxImageSize = maxImageSize
        self.supportedLanguages = supportedLanguages
        self.processingPower = processingPower
    }
}

// MARK: - OCR Processing Power

/// Processing power levels for OCR
public enum OCRProcessingPower: String, CaseIterable {
    case low = "low"
    case standard = "standard"
    case high = "high"
    case neural = "neural"
    
    public var displayName: String {
        switch self {
        case .low: return "Low Power"
        case .standard: return "Standard"
        case .high: return "High Performance"
        case .neural: return "Neural Engine"
        }
    }
}

// MARK: - OCR Layout

/// Layout information for OCR operations
public struct OCRLayout {
    public let maxImageSize: CGSize
    public let recommendedImageSize: CGSize
    public let processingMode: OCRProcessingMode
    public let uiConfiguration: OCRUIConfiguration
    
    public init(
        maxImageSize: CGSize,
        recommendedImageSize: CGSize,
        processingMode: OCRProcessingMode = .standard,
        uiConfiguration: OCRUIConfiguration = OCRUIConfiguration()
    ) {
        self.maxImageSize = maxImageSize
        self.recommendedImageSize = recommendedImageSize
        self.processingMode = processingMode
        self.uiConfiguration = uiConfiguration
    }
}

// MARK: - OCR Processing Mode

/// Processing modes for OCR
public enum OCRProcessingMode: String, CaseIterable {
    case fast = "fast"
    case standard = "standard"
    case accurate = "accurate"
    case neural = "neural"
    
    public var displayName: String {
        switch self {
        case .fast: return "Fast"
        case .standard: return "Standard"
        case .accurate: return "Accurate"
        case .neural: return "Neural Engine"
        }
    }
}

// MARK: - OCR UI Configuration

/// UI configuration for OCR operations
public struct OCRUIConfiguration {
    public let showProgress: Bool
    public let showConfidence: Bool
    public let showBoundingBoxes: Bool
    public let allowEditing: Bool
    public let theme: OCRTheme
    
    public init(
        showProgress: Bool = true,
        showConfidence: Bool = false,
        showBoundingBoxes: Bool = true,
        allowEditing: Bool = true,
        theme: OCRTheme = .system
    ) {
        self.showProgress = showProgress
        self.showConfidence = showConfidence
        self.showBoundingBoxes = showBoundingBoxes
        self.allowEditing = allowEditing
        self.theme = theme
    }
}

// MARK: - OCR Theme

/// Themes for OCR UI
public enum OCRTheme: String, CaseIterable {
    case system = "system"
    case light = "light"
    case dark = "dark"
    case highContrast = "high_contrast"
    
    public var displayName: String {
        switch self {
        case .system: return "System"
        case .light: return "Light"
        case .dark: return "Dark"
        case .highContrast: return "High Contrast"
        }
    }
}

// MARK: - OCR Strategy

/// Strategy for OCR operations
public struct OCRStrategy {
    public let supportedTextTypes: [TextType]
    public let supportedLanguages: [OCRLanguage]
    public let processingMode: OCRProcessingMode
    public let requiresNeuralEngine: Bool
    public let estimatedProcessingTime: TimeInterval
    
    public init(
        supportedTextTypes: [TextType],
        supportedLanguages: [OCRLanguage],
        processingMode: OCRProcessingMode,
        requiresNeuralEngine: Bool = false,
        estimatedProcessingTime: TimeInterval = 1.0
    ) {
        self.supportedTextTypes = supportedTextTypes
        self.supportedLanguages = supportedLanguages
        self.processingMode = processingMode
        self.requiresNeuralEngine = requiresNeuralEngine
        self.estimatedProcessingTime = estimatedProcessingTime
    }
}





