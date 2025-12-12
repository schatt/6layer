//
//  ImageProcessingTypes.swift
//  SixLayerFramework
//
//  Types and structures for Advanced Image Processing Pipeline
//  Provides comprehensive image processing capabilities with
//  enhancement, optimization, and analysis features
//

import Foundation
import SwiftUI

// MARK: - Image Purpose

/// Supported purposes for image processing
public enum ImagePurpose: String, CaseIterable, Sendable {
    case ocr = "ocr"                    // Text recognition optimization
    case fuelReceipt = "fuelReceipt"    // Fuel receipt processing
    case odometer = "odometer"          // Odometer reading capture
    case document = "document"          // General document processing
    case photo = "photo"                // General photo enhancement
    case thumbnail = "thumbnail"        // Thumbnail generation
    case preview = "preview"            // UI preview optimization
}

// MARK: - Processing Options

/// Options for image processing
public struct ProcessingOptions: Sendable {
    public let quality: ProcessingQuality
    public let enableEnhancement: Bool
    public let enableOptimization: Bool
    public let targetFormat: ProcessingImageFormat
    
    public init(
        quality: ProcessingQuality,
        enableEnhancement: Bool = true,
        enableOptimization: Bool = true,
        targetFormat: ProcessingImageFormat = .jpeg
    ) {
        self.quality = quality
        self.enableEnhancement = enableEnhancement
        self.enableOptimization = enableOptimization
        self.targetFormat = targetFormat
    }
}

/// Processing quality levels
public enum ProcessingQuality: String, CaseIterable, Sendable {
    case low = "low"
    case medium = "medium"
    case high = "high"
    case maximum = "maximum"
}

/// Supported image formats for processing
public enum ProcessingImageFormat: String, CaseIterable, Sendable {
    case jpeg = "jpeg"
    case png = "png"
    case heic = "heic"
    case unsupported = "unsupported"
}

// MARK: - Processed Image

/// Result of image processing
public struct ProcessedImage: Sendable {
    public let originalImage: PlatformImage
    public let processedImage: PlatformImage
    public let purpose: ImagePurpose
    public let metadata: ProcessedImageMetadata
    public let isOptimizedForOCR: Bool
    public let isCompressed: Bool
    public let enhancementResults: EnhancementResults?
    public let optimizationResults: OptimizationResults?
    
    public init(
        originalImage: PlatformImage,
        processedImage: PlatformImage,
        purpose: ImagePurpose,
        metadata: ProcessedImageMetadata,
        isOptimizedForOCR: Bool = false,
        isCompressed: Bool = false,
        enhancementResults: EnhancementResults? = nil,
        optimizationResults: OptimizationResults? = nil
    ) {
        self.originalImage = originalImage
        self.processedImage = processedImage
        self.purpose = purpose
        self.metadata = metadata
        self.isOptimizedForOCR = isOptimizedForOCR
        self.isCompressed = isCompressed
        self.enhancementResults = enhancementResults
        self.optimizationResults = optimizationResults
    }
}

// MARK: - Image Metadata

/// Metadata for processed images
public struct ProcessedImageMetadata: Sendable {
    public let dimensions: CGSize
    public let fileSize: Int64
    public let qualityScore: Double
    public let colorPalette: [Color]?
    public let processingTime: TimeInterval
    
    public init(
        dimensions: CGSize,
        fileSize: Int64,
        qualityScore: Double,
        colorPalette: [Color]? = nil,
        processingTime: TimeInterval
    ) {
        self.dimensions = dimensions
        self.fileSize = fileSize
        self.qualityScore = qualityScore
        self.colorPalette = colorPalette
        self.processingTime = processingTime
    }
}

// MARK: - Enhancement Results

/// Results of image enhancement
public struct EnhancementResults: Sendable {
    public let brightness: Double
    public let contrast: Double
    public let sharpness: Double
    public let saturation: Double
    public let appliedFilters: [String]
    
    public init(
        brightness: Double,
        contrast: Double,
        sharpness: Double,
        saturation: Double,
        appliedFilters: [String] = []
    ) {
        self.brightness = brightness
        self.contrast = contrast
        self.sharpness = sharpness
        self.saturation = saturation
        self.appliedFilters = appliedFilters
    }
}

// MARK: - Optimization Results

/// Results of image optimization
public struct OptimizationResults: Sendable {
    public let compressionRatio: Double
    public let sizeReduction: Int64
    public let format: ProcessingImageFormat
    public let appliedOptimizations: [String]
    
    public init(
        compressionRatio: Double,
        sizeReduction: Int64,
        format: ProcessingImageFormat,
        appliedOptimizations: [String] = []
    ) {
        self.compressionRatio = compressionRatio
        self.sizeReduction = sizeReduction
        self.format = format
        self.appliedOptimizations = appliedOptimizations
    }
}

// MARK: - Enhancement Options

/// Options for image enhancement
public struct EnhancementOptions: Sendable {
    public let brightness: Double
    public let contrast: Double
    public let sharpness: Double
    public let saturation: Double
    
    public init(
        brightness: Double = 0.0,
        contrast: Double = 0.0,
        sharpness: Double = 0.0,
        saturation: Double = 0.0
    ) {
        self.brightness = brightness
        self.contrast = contrast
        self.sharpness = sharpness
        self.saturation = saturation
    }
}

// MARK: - Image Analysis

/// Results of image analysis
public struct ImageAnalysis: Sendable {
    public let qualityScore: Double
    public let dimensions: CGSize
    public let colorPalette: [Color]?
    public let detectedObjects: [String]?
    public let textRegions: [CGRect]?
    
    public init(
        qualityScore: Double,
        dimensions: CGSize,
        colorPalette: [Color]? = nil,
        detectedObjects: [String]? = nil,
        textRegions: [CGRect]? = nil
    ) {
        self.qualityScore = qualityScore
        self.dimensions = dimensions
        self.colorPalette = colorPalette
        self.detectedObjects = detectedObjects
        self.textRegions = textRegions
    }
}

// MARK: - Processing Errors

/// Errors that can occur during image processing
public enum ImageProcessingError: Error, LocalizedError {
    case invalidImage
    case unsupportedFormat
    case processingFailed(Error)
    case enhancementFailed(Error)
    case optimizationFailed(Error)
    case analysisFailed(Error)
    
    public var errorDescription: String? {
        let i18n = InternationalizationService()
        switch self {
        case .invalidImage:
            return i18n.localizedString(for: "SixLayerFramework.image.invalidImage")
        case .unsupportedFormat:
            return i18n.localizedString(for: "SixLayerFramework.image.unsupportedFormat")
        case .processingFailed(let error):
            let format = i18n.localizedString(for: "SixLayerFramework.image.processingFailed")
            return String(format: format, error.localizedDescription)
        case .enhancementFailed(let error):
            let format = i18n.localizedString(for: "SixLayerFramework.image.enhancementFailed")
            return String(format: format, error.localizedDescription)
        case .optimizationFailed(let error):
            let format = i18n.localizedString(for: "SixLayerFramework.image.optimizationFailed")
            return String(format: format, error.localizedDescription)
        case .analysisFailed(let error):
            let format = i18n.localizedString(for: "SixLayerFramework.image.analysisFailed")
            return String(format: format, error.localizedDescription)
        }
    }
}
