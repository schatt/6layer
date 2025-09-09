//
//  ImageMetadataTypes.swift
//  SixLayerFramework
//
//  Types and structures for Image Metadata Intelligence
//  Provides comprehensive metadata extraction, AI-powered categorization,
//  and smart recommendations
//

import Foundation
import SwiftUI
import CoreLocation

// MARK: - Comprehensive Image Metadata

/// Comprehensive metadata for images
public struct ComprehensiveImageMetadata: Sendable {
    public let dimensions: CGSize
    public let fileSize: Int64
    public let creationDate: Date?
    public let modificationDate: Date?
    public let exifData: EXIFData?
    public let locationData: LocationData?
    public let colorProfile: ColorProfile?
    public let technicalData: TechnicalData?
    
    public init(
        dimensions: CGSize,
        fileSize: Int64,
        creationDate: Date? = nil,
        modificationDate: Date? = nil,
        exifData: EXIFData? = nil,
        locationData: LocationData? = nil,
        colorProfile: ColorProfile? = nil,
        technicalData: TechnicalData? = nil
    ) {
        self.dimensions = dimensions
        self.fileSize = fileSize
        self.creationDate = creationDate
        self.modificationDate = modificationDate
        self.exifData = exifData
        self.locationData = locationData
        self.colorProfile = colorProfile
        self.technicalData = technicalData
    }
}

// MARK: - EXIF Data

/// EXIF metadata from images
public struct EXIFData: Sendable {
    public let cameraMake: String?
    public let cameraModel: String?
    public let exposureTime: Double?
    public let iso: Int?
    public let focalLength: Double?
    public let aperture: Double?
    public let flash: Bool?
    public let whiteBalance: String?
    public let lensModel: String?
    
    public init(
        cameraMake: String? = nil,
        cameraModel: String? = nil,
        exposureTime: Double? = nil,
        iso: Int? = nil,
        focalLength: Double? = nil,
        aperture: Double? = nil,
        flash: Bool? = nil,
        whiteBalance: String? = nil,
        lensModel: String? = nil
    ) {
        self.cameraMake = cameraMake
        self.cameraModel = cameraModel
        self.exposureTime = exposureTime
        self.iso = iso
        self.focalLength = focalLength
        self.aperture = aperture
        self.flash = flash
        self.whiteBalance = whiteBalance
        self.lensModel = lensModel
    }
}

// MARK: - Location Data

/// Location metadata from images
public struct LocationData: Sendable {
    public let latitude: Double?
    public let longitude: Double?
    public let altitude: Double?
    public let accuracy: Double?
    public let timestamp: Date?
    
    public init(
        latitude: Double? = nil,
        longitude: Double? = nil,
        altitude: Double? = nil,
        accuracy: Double? = nil,
        timestamp: Date? = nil
    ) {
        self.latitude = latitude
        self.longitude = longitude
        self.altitude = altitude
        self.accuracy = accuracy
        self.timestamp = timestamp
    }
}

// MARK: - Color Profile

/// Color profile information
public struct ColorProfile: Sendable {
    public let colorSpace: String?
    public let colorGamut: String?
    public let bitDepth: Int?
    public let hasAlpha: Bool?
    public let iccProfile: Data?
    
    public init(
        colorSpace: String? = nil,
        colorGamut: String? = nil,
        bitDepth: Int? = nil,
        hasAlpha: Bool? = nil,
        iccProfile: Data? = nil
    ) {
        self.colorSpace = colorSpace
        self.colorGamut = colorGamut
        self.bitDepth = bitDepth
        self.hasAlpha = hasAlpha
        self.iccProfile = iccProfile
    }
}

// MARK: - Technical Data

/// Technical image data
public struct TechnicalData: Sendable {
    public let resolution: Double?
    public let compressionRatio: Double?
    public let hasAlpha: Bool?
    public let orientation: Int?
    public let dpi: Double?
    public let colorModel: String?
    
    public init(
        resolution: Double? = nil,
        compressionRatio: Double? = nil,
        hasAlpha: Bool? = nil,
        orientation: Int? = nil,
        dpi: Double? = nil,
        colorModel: String? = nil
    ) {
        self.resolution = resolution
        self.compressionRatio = compressionRatio
        self.hasAlpha = hasAlpha
        self.orientation = orientation
        self.dpi = dpi
        self.colorModel = colorModel
    }
}

// MARK: - Content Categorization

/// AI-powered content categorization
public struct ContentCategorization: Sendable {
    public let primaryCategory: String
    public let confidence: Double
    public let tags: [String]
    public let subcategories: [String]
    
    public init(
        primaryCategory: String,
        confidence: Double,
        tags: [String] = [],
        subcategories: [String] = []
    ) {
        self.primaryCategory = primaryCategory
        self.confidence = confidence
        self.tags = tags
        self.subcategories = subcategories
    }
}

// MARK: - Purpose Categorization

/// Purpose-based categorization
public struct PurposeCategorization: Sendable {
    public let recommendedPurpose: ImagePurpose
    public let confidence: Double
    public let alternativePurposes: [ImagePurpose]
    
    public init(
        recommendedPurpose: ImagePurpose,
        confidence: Double,
        alternativePurposes: [ImagePurpose] = []
    ) {
        self.recommendedPurpose = recommendedPurpose
        self.confidence = confidence
        self.alternativePurposes = alternativePurposes
    }
}

// MARK: - Quality Categorization

/// Quality-based categorization
public struct QualityCategorization: Sendable {
    public let qualityScore: Double
    public let qualityLevel: QualityLevel
    public let issues: [String]
    public let recommendations: [String]
    
    public init(
        qualityScore: Double,
        qualityLevel: QualityLevel,
        issues: [String] = [],
        recommendations: [String] = []
    ) {
        self.qualityScore = qualityScore
        self.qualityLevel = qualityLevel
        self.issues = issues
        self.recommendations = recommendations
    }
}

/// Quality levels
public enum QualityLevel: String, CaseIterable, Sendable {
    case excellent = "excellent"
    case good = "good"
    case fair = "fair"
    case poor = "poor"
    case unusable = "unusable"
}

// MARK: - Optimization Recommendations

/// Optimization recommendations
public struct OptimizationRecommendations: Sendable {
    public let compressionRecommendations: [String]
    public let formatRecommendations: [String]
    public let enhancementRecommendations: [String]
    public let sizeRecommendations: [String]
    
    public init(
        compressionRecommendations: [String] = [],
        formatRecommendations: [String] = [],
        enhancementRecommendations: [String] = [],
        sizeRecommendations: [String] = []
    ) {
        self.compressionRecommendations = compressionRecommendations
        self.formatRecommendations = formatRecommendations
        self.enhancementRecommendations = enhancementRecommendations
        self.sizeRecommendations = sizeRecommendations
    }
}

// MARK: - Accessibility Recommendations

/// Accessibility recommendations
public struct AccessibilityRecommendations: Sendable {
    public let altTextSuggestions: [String]
    public let contrastRecommendations: [String]
    public let voiceOverOptimizations: [String]
    public let colorBlindnessConsiderations: [String]
    
    public init(
        altTextSuggestions: [String] = [],
        contrastRecommendations: [String] = [],
        voiceOverOptimizations: [String] = [],
        colorBlindnessConsiderations: [String] = []
    ) {
        self.altTextSuggestions = altTextSuggestions
        self.contrastRecommendations = contrastRecommendations
        self.voiceOverOptimizations = voiceOverOptimizations
        self.colorBlindnessConsiderations = colorBlindnessConsiderations
    }
}

// MARK: - Usage Recommendations

/// Usage recommendations
public struct UsageRecommendations: Sendable {
    public let recommendedUseCases: [String]
    public let performanceConsiderations: [String]
    public let storageRecommendations: [String]
    public let sharingRecommendations: [String]
    
    public init(
        recommendedUseCases: [String] = [],
        performanceConsiderations: [String] = [],
        storageRecommendations: [String] = [],
        sharingRecommendations: [String] = []
    ) {
        self.recommendedUseCases = recommendedUseCases
        self.performanceConsiderations = performanceConsiderations
        self.storageRecommendations = storageRecommendations
        self.sharingRecommendations = sharingRecommendations
    }
}

// MARK: - Image Composition Analysis

/// Image composition analysis
public struct ImageComposition: Sendable {
    public let ruleOfThirds: Double?
    public let symmetry: Double?
    public let balance: Double?
    public let focalPoints: [CGPoint]
    public let leadingLines: [CGLine]
    
    public init(
        ruleOfThirds: Double? = nil,
        symmetry: Double? = nil,
        balance: Double? = nil,
        focalPoints: [CGPoint] = [],
        leadingLines: [CGLine] = []
    ) {
        self.ruleOfThirds = ruleOfThirds
        self.symmetry = symmetry
        self.balance = balance
        self.focalPoints = focalPoints
        self.leadingLines = leadingLines
    }
}

// MARK: - Color Distribution Analysis

/// Color distribution analysis
public struct ColorDistribution: Sendable {
    public let dominantColors: [Color]
    public let colorHarmony: String?
    public let brightness: Double?
    public let saturation: Double?
    public let contrast: Double?
    
    public init(
        dominantColors: [Color] = [],
        colorHarmony: String? = nil,
        brightness: Double? = nil,
        saturation: Double? = nil,
        contrast: Double? = nil
    ) {
        self.dominantColors = dominantColors
        self.colorHarmony = colorHarmony
        self.brightness = brightness
        self.saturation = saturation
        self.contrast = contrast
    }
}

// MARK: - Text Content Analysis

/// Text content analysis
public struct TextContentAnalysis: Sendable {
    public let hasText: Bool
    public let textRegions: [CGRect]
    public let languageDetection: [String]
    public let readabilityScore: Double?
    public let textConfidence: Double?
    
    public init(
        hasText: Bool = false,
        textRegions: [CGRect] = [],
        languageDetection: [String] = [],
        readabilityScore: Double? = nil,
        textConfidence: Double? = nil
    ) {
        self.hasText = hasText
        self.textRegions = textRegions
        self.languageDetection = languageDetection
        self.readabilityScore = readabilityScore
        self.textConfidence = textConfidence
    }
}

// MARK: - CGLine Extension

/// Line representation for composition analysis
public struct CGLine: Sendable {
    public let start: CGPoint
    public let end: CGPoint
    
    public init(start: CGPoint, end: CGPoint) {
        self.start = start
        self.end = end
    }
}

// MARK: - Image Metadata Errors

/// Errors that can occur during metadata extraction
public enum ImageMetadataError: Error, LocalizedError {
    case invalidImage
    case corruptedImage
    case extractionFailed(Error)
    case analysisFailed(Error)
    case categorizationFailed(Error)
    
    public var errorDescription: String? {
        switch self {
        case .invalidImage:
            return "Invalid image provided for metadata extraction"
        case .corruptedImage:
            return "Corrupted image cannot be analyzed"
        case .extractionFailed(let error):
            return "Metadata extraction failed: \(error.localizedDescription)"
        case .analysisFailed(let error):
            return "Image analysis failed: \(error.localizedDescription)"
        case .categorizationFailed(let error):
            return "Image categorization failed: \(error.localizedDescription)"
        }
    }
}
