//
//  ImageMetadataIntelligenceTests.swift
//  SixLayerFrameworkTests
//
//  Tests for Image Metadata Intelligence
//  Tests the comprehensive metadata extraction, AI-powered categorization,
//  and smart recommendations system
//

import XCTest
import SwiftUI
@testable import SixLayerFramework

@MainActor
final class ImageMetadataIntelligenceTests: XCTestCase {
    
    // MARK: - Test Data
    
    private func createTestImage() -> PlatformImage {
        #if os(iOS)
        let size = CGSize(width: 100, height: 100)
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { context in
            UIColor.blue.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
        return PlatformImage(uiImage: image)
        #elseif os(macOS)
        let size = NSSize(width: 100, height: 100)
        let image = NSImage(size: size)
        image.lockFocus()
        NSColor.blue.setFill()
        NSRect(origin: .zero, size: size).fill()
        image.unlockFocus()
        return PlatformImage(nsImage: image)
        #endif
    }
    
    // MARK: - ImageMetadataIntelligence Tests
    
    func testImageMetadataIntelligence_ExtractBasicMetadata() async throws {
        // Given
        let image = createTestImage()
        let intelligence = ImageMetadataIntelligence()
        
        // When
        let metadata = try await intelligence.extractMetadata(from: image)
        
        // Then
        XCTAssertNotNil(metadata)
        XCTAssertEqual(metadata.dimensions, image.size)
        XCTAssertNotNil(metadata.fileSize)
        XCTAssertNotNil(metadata.creationDate)
        XCTAssertNotNil(metadata.modificationDate)
    }
    
    func testImageMetadataIntelligence_ExtractEXIFData() async throws {
        // Given
        let image = createTestImage()
        let intelligence = ImageMetadataIntelligence()
        
        // When
        let exifData = try await intelligence.extractEXIFData(from: image)
        
        // Then
        XCTAssertNotNil(exifData)
        XCTAssertNotNil(exifData.cameraMake)
        XCTAssertNotNil(exifData.cameraModel)
        XCTAssertNotNil(exifData.exposureTime)
        XCTAssertNotNil(exifData.iso)
        XCTAssertNotNil(exifData.focalLength)
    }
    
    func testImageMetadataIntelligence_ExtractLocationData() async throws {
        // Given
        let image = createTestImage()
        let intelligence = ImageMetadataIntelligence()
        
        // When
        let locationData = try await intelligence.extractLocationData(from: image)
        
        // Then
        // Note: Test image may not have location data, so this could be nil
        // XCTAssertNotNil(locationData)
    }
    
    func testImageMetadataIntelligence_ExtractColorProfile() async throws {
        // Given
        let image = createTestImage()
        let intelligence = ImageMetadataIntelligence()
        
        // When
        let colorProfile = try await intelligence.extractColorProfile(from: image)
        
        // Then
        XCTAssertNotNil(colorProfile)
        XCTAssertNotNil(colorProfile.colorSpace)
        XCTAssertNotNil(colorProfile.colorGamut)
        XCTAssertNotNil(colorProfile.bitDepth)
    }
    
    func testImageMetadataIntelligence_ExtractTechnicalData() async throws {
        // Given
        let image = createTestImage()
        let intelligence = ImageMetadataIntelligence()
        
        // When
        let technicalData = try await intelligence.extractTechnicalData(from: image)
        
        // Then
        XCTAssertNotNil(technicalData)
        XCTAssertNotNil(technicalData.resolution)
        XCTAssertNotNil(technicalData.compressionRatio)
        XCTAssertNotNil(technicalData.hasAlpha)
        XCTAssertNotNil(technicalData.orientation)
    }
    
    // MARK: - AI-Powered Categorization Tests
    
    func testImageMetadataIntelligence_CategorizeByContent() async throws {
        // Given
        let image = createTestImage()
        let intelligence = ImageMetadataIntelligence()
        
        // When
        let categorization = try await intelligence.categorizeByContent(image)
        
        // Then
        XCTAssertNotNil(categorization)
        XCTAssertNotNil(categorization.primaryCategory)
        XCTAssertNotNil(categorization.confidence)
        XCTAssertNotNil(categorization.tags)
    }
    
    func testImageMetadataIntelligence_CategorizeByPurpose() async throws {
        // Given
        let image = createTestImage()
        let intelligence = ImageMetadataIntelligence()
        
        // When
        let purposeCategorization = try await intelligence.categorizeByPurpose(image)
        
        // Then
        XCTAssertNotNil(purposeCategorization)
        XCTAssertNotNil(purposeCategorization.recommendedPurpose)
        XCTAssertNotNil(purposeCategorization.confidence)
        XCTAssertNotNil(purposeCategorization.alternativePurposes)
    }
    
    func testImageMetadataIntelligence_CategorizeByQuality() async throws {
        // Given
        let image = createTestImage()
        let intelligence = ImageMetadataIntelligence()
        
        // When
        let qualityCategorization = try await intelligence.categorizeByQuality(image)
        
        // Then
        XCTAssertNotNil(qualityCategorization)
        XCTAssertNotNil(qualityCategorization.qualityScore)
        XCTAssertNotNil(qualityCategorization.qualityLevel)
        XCTAssertNotNil(qualityCategorization.issues)
    }
    
    // MARK: - Smart Recommendations Tests
    
    func testImageMetadataIntelligence_GenerateOptimizationRecommendations() async throws {
        // Given
        let image = createTestImage()
        let intelligence = ImageMetadataIntelligence()
        
        // When
        let recommendations = try await intelligence.generateOptimizationRecommendations(for: image)
        
        // Then
        XCTAssertNotNil(recommendations)
        XCTAssertNotNil(recommendations.compressionRecommendations)
        XCTAssertNotNil(recommendations.formatRecommendations)
        XCTAssertNotNil(recommendations.enhancementRecommendations)
    }
    
    func testImageMetadataIntelligence_GenerateAccessibilityRecommendations() async throws {
        // Given
        let image = createTestImage()
        let intelligence = ImageMetadataIntelligence()
        
        // When
        let recommendations = try await intelligence.generateAccessibilityRecommendations(for: image)
        
        // Then
        XCTAssertNotNil(recommendations)
        XCTAssertNotNil(recommendations.altTextSuggestions)
        XCTAssertNotNil(recommendations.contrastRecommendations)
        XCTAssertNotNil(recommendations.voiceOverOptimizations)
    }
    
    func testImageMetadataIntelligence_GenerateUsageRecommendations() async throws {
        // Given
        let image = createTestImage()
        let intelligence = ImageMetadataIntelligence()
        
        // When
        let recommendations = try await intelligence.generateUsageRecommendations(for: image)
        
        // Then
        XCTAssertNotNil(recommendations)
        XCTAssertNotNil(recommendations.recommendedUseCases)
        XCTAssertNotNil(recommendations.performanceConsiderations)
        XCTAssertNotNil(recommendations.storageRecommendations)
    }
    
    // MARK: - Metadata Analysis Tests
    
    func testImageMetadataIntelligence_AnalyzeImageComposition() async throws {
        // Given
        let image = createTestImage()
        let intelligence = ImageMetadataIntelligence()
        
        // When
        let composition = try await intelligence.analyzeImageComposition(image)
        
        // Then
        XCTAssertNotNil(composition)
        XCTAssertNotNil(composition.ruleOfThirds)
        XCTAssertNotNil(composition.symmetry)
        XCTAssertNotNil(composition.balance)
        XCTAssertNotNil(composition.focalPoints)
    }
    
    func testImageMetadataIntelligence_AnalyzeColorDistribution() async throws {
        // Given
        let image = createTestImage()
        let intelligence = ImageMetadataIntelligence()
        
        // When
        let colorDistribution = try await intelligence.analyzeColorDistribution(image)
        
        // Then
        XCTAssertNotNil(colorDistribution)
        XCTAssertNotNil(colorDistribution.dominantColors)
        XCTAssertNotNil(colorDistribution.colorHarmony)
        XCTAssertNotNil(colorDistribution.brightness)
        XCTAssertNotNil(colorDistribution.saturation)
    }
    
    func testImageMetadataIntelligence_AnalyzeTextContent() async throws {
        // Given
        let image = createTestImage()
        let intelligence = ImageMetadataIntelligence()
        
        // When
        let textContent = try await intelligence.analyzeTextContent(image)
        
        // Then
        XCTAssertNotNil(textContent)
        // Note: Test image may not have text content, so some values could be nil
        // XCTAssertNotNil(textContent.hasText)
        // XCTAssertNotNil(textContent.textRegions)
        // XCTAssertNotNil(textContent.languageDetection)
        // XCTAssertNotNil(textContent.readabilityScore)
    }
    
    // MARK: - Performance Tests
    
    func testImageMetadataIntelligence_Performance() async throws {
        // Given
        let image = createTestImage()
        let intelligence = ImageMetadataIntelligence()
        
        // When
        let startTime = CFAbsoluteTimeGetCurrent()
        let metadata = try await intelligence.extractMetadata(from: image)
        let endTime = CFAbsoluteTimeGetCurrent()
        
        // Then
        XCTAssertNotNil(metadata)
        let executionTime = endTime - startTime
        XCTAssertLessThan(executionTime, 2.0) // Should complete in under 2 seconds
    }
    
    func testImageMetadataIntelligence_BatchProcessing() async throws {
        // Given
        let images = (0..<5).map { _ in createTestImage() }
        let intelligence = ImageMetadataIntelligence()
        
        // When
        let startTime = CFAbsoluteTimeGetCurrent()
        let metadataResults = try await withThrowingTaskGroup(of: ComprehensiveImageMetadata.self) { group in
            for image in images {
                group.addTask {
                    try await intelligence.extractMetadata(from: image)
                }
            }
            
            var results: [ComprehensiveImageMetadata] = []
            for try await result in group {
                results.append(result)
            }
            return results
        }
        let endTime = CFAbsoluteTimeGetCurrent()
        
        // Then
        XCTAssertEqual(metadataResults.count, images.count)
        let executionTime = endTime - startTime
        XCTAssertLessThan(executionTime, 5.0) // Should complete in under 5 seconds
    }
    
    // MARK: - Error Handling Tests
    
    func testImageMetadataIntelligence_InvalidImage() async {
        // Given
        let invalidImage = PlatformImage() // Empty image
        let intelligence = ImageMetadataIntelligence()
        
        // When/Then
        do {
            _ = try await intelligence.extractMetadata(from: invalidImage)
            XCTFail("Should have thrown an error for invalid image")
        } catch {
            XCTAssertTrue(error is ImageMetadataError)
        }
    }
    
    func testImageMetadataIntelligence_CorruptedImage() async {
        // Given
        let corruptedData = Data("corrupted".utf8)
        let corruptedImage = PlatformImage(data: corruptedData) ?? PlatformImage()
        let intelligence = ImageMetadataIntelligence()
        
        // When/Then
        do {
            _ = try await intelligence.extractMetadata(from: corruptedImage)
            XCTFail("Should have thrown an error for corrupted image")
        } catch {
            XCTAssertTrue(error is ImageMetadataError)
        }
    }
    
    // MARK: - Integration Tests
    
    func testImageMetadataIntelligence_Integration() async throws {
        // Given
        let image = createTestImage()
        let intelligence = ImageMetadataIntelligence()
        
        // When
        let metadata = try await intelligence.extractMetadata(from: image)
        let categorization = try await intelligence.categorizeByContent(image)
        let recommendations = try await intelligence.generateOptimizationRecommendations(for: image)
        
        // Then
        XCTAssertNotNil(metadata)
        XCTAssertNotNil(categorization)
        XCTAssertNotNil(recommendations)
        
        // Verify integration between components
        XCTAssertEqual(metadata.dimensions, image.size)
        XCTAssertNotNil(categorization.primaryCategory)
        XCTAssertNotNil(recommendations.compressionRecommendations)
    }
}
