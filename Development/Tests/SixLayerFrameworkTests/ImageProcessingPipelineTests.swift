//
//  ImageProcessingPipelineTests.swift
//  SixLayerFrameworkTests
//
//  Tests for Advanced Image Processing Pipeline
//  Tests the intelligent image processing system that provides
//  enhancement, optimization, and analysis capabilities
//

import XCTest
import SwiftUI
@testable import SixLayerFramework

@MainActor
final class ImageProcessingPipelineTests: XCTestCase {
    
    // MARK: - Test Data
    
    private func createTestImage() -> PlatformImage {
        // Create a simple test image
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
    
    private func createProcessingOptions() -> ProcessingOptions {
        return ProcessingOptions(
            quality: .high,
            enableEnhancement: true,
            enableOptimization: true,
            targetFormat: .jpeg
        )
    }
    
    // MARK: - ImageProcessingPipeline Tests
    
    func testImageProcessingPipeline_ProcessForOCR() async throws {
        // Given
        let image = createTestImage()
        let purpose = ImagePurpose.ocr
        let options = createProcessingOptions()
        
        // When
        let processedImage = try await ImageProcessingPipeline.process(
            image,
            for: purpose,
            with: options
        )
        
        // Then
        XCTAssertNotNil(processedImage)
        XCTAssertNotNil(processedImage.originalImage)
        XCTAssertEqual(processedImage.purpose, purpose)
        XCTAssertNotNil(processedImage.metadata)
    }
    
    func testImageProcessingPipeline_ProcessForFuelReceipt() async throws {
        // Given
        let image = createTestImage()
        let purpose = ImagePurpose.fuelReceipt
        let options = createProcessingOptions()
        
        // When
        let processedImage = try await ImageProcessingPipeline.process(
            image,
            for: purpose,
            with: options
        )
        
        // Then
        XCTAssertNotNil(processedImage)
        XCTAssertEqual(processedImage.purpose, purpose)
        XCTAssertTrue(processedImage.isOptimizedForOCR)
    }
    
    func testImageProcessingPipeline_ProcessForDocument() async throws {
        // Given
        let image = createTestImage()
        let purpose = ImagePurpose.document
        let options = createProcessingOptions()
        
        // When
        let processedImage = try await ImageProcessingPipeline.process(
            image,
            for: purpose,
            with: options
        )
        
        // Then
        XCTAssertNotNil(processedImage)
        XCTAssertEqual(processedImage.purpose, purpose)
        XCTAssertNotNil(processedImage.enhancementResults)
    }
    
    func testImageProcessingPipeline_ProcessForPhoto() async throws {
        // Given
        let image = createTestImage()
        let purpose = ImagePurpose.photo
        let options = createProcessingOptions()
        
        // When
        let processedImage = try await ImageProcessingPipeline.process(
            image,
            for: purpose,
            with: options
        )
        
        // Then
        XCTAssertNotNil(processedImage)
        XCTAssertEqual(processedImage.purpose, purpose)
        XCTAssertNotNil(processedImage.optimizationResults)
    }
    
    func testImageProcessingPipeline_ProcessForThumbnail() async throws {
        // Given
        let image = createTestImage()
        let purpose = ImagePurpose.thumbnail
        let options = ProcessingOptions(
            quality: .medium,
            enableEnhancement: false,
            enableOptimization: true,
            targetFormat: .jpeg
        )
        
        // When
        let processedImage = try await ImageProcessingPipeline.process(
            image,
            for: purpose,
            with: options
        )
        
        // Then
        XCTAssertNotNil(processedImage)
        XCTAssertEqual(processedImage.purpose, purpose)
        XCTAssertTrue(processedImage.isCompressed)
    }
    
    func testImageProcessingPipeline_ProcessForPreview() async throws {
        // Given
        let image = createTestImage()
        let purpose = ImagePurpose.preview
        let options = ProcessingOptions(
            quality: .low,
            enableEnhancement: false,
            enableOptimization: true,
            targetFormat: .jpeg
        )
        
        // When
        let processedImage = try await ImageProcessingPipeline.process(
            image,
            for: purpose,
            with: options
        )
        
        // Then
        XCTAssertNotNil(processedImage)
        XCTAssertEqual(processedImage.purpose, purpose)
        XCTAssertTrue(processedImage.isCompressed)
    }
    
    // MARK: - ImageProcessor Tests
    
    func testImageProcessor_EnhanceImage() async throws {
        // Given
        let image = createTestImage()
        let processor = ImageProcessor()
        let options = EnhancementOptions(
            brightness: 0.1,
            contrast: 0.2,
            sharpness: 0.3,
            saturation: 0.1
        )
        
        // When
        let enhancedImage = try await processor.enhance(image, with: options)
        
        // Then
        XCTAssertNotNil(enhancedImage)
        // Note: PlatformImage doesn't conform to Equatable, so we can't directly compare
    }
    
    func testImageProcessor_AnalyzeImage() async throws {
        // Given
        let image = createTestImage()
        let processor = ImageProcessor()
        
        // When
        let analysis = try await processor.analyze(image)
        
        // Then
        XCTAssertNotNil(analysis)
        XCTAssertNotNil(analysis.qualityScore)
        XCTAssertNotNil(analysis.dimensions)
        XCTAssertNotNil(analysis.colorPalette)
    }
    
    // MARK: - Enhancement Strategy Tests
    
    func testOCREnhancementStrategy_EnhanceImage() async throws {
        // Given
        let image = createTestImage()
        let strategy = OCREnhancementStrategy()
        
        // When
        let enhancedImage = try await strategy.enhance(image)
        
        // Then
        XCTAssertNotNil(enhancedImage)
        XCTAssertTrue(strategy.validate(enhancedImage))
    }
    
    func testOCREnhancementStrategy_DetectTextRegions() async throws {
        // Given
        let image = createTestImage()
        let strategy = OCREnhancementStrategy()
        
        // When
        let textRegions = try await strategy.detectTextRegions(image)
        
        // Then
        XCTAssertNotNil(textRegions)
        // Note: Test image may not have text, so regions could be empty
    }
    
    func testOCREnhancementStrategy_OptimizeForOCR() async throws {
        // Given
        let image = createTestImage()
        let strategy = OCREnhancementStrategy()
        
        // When
        let optimizedImage = try await strategy.optimizeForOCR(image)
        
        // Then
        XCTAssertNotNil(optimizedImage)
        XCTAssertTrue(strategy.validate(optimizedImage))
    }
    
    // MARK: - Performance Tests
    
    func testImageProcessingPerformance() async throws {
        // Given
        let image = createTestImage()
        let purpose = ImagePurpose.ocr
        let options = createProcessingOptions()
        
        // When
        let startTime = CFAbsoluteTimeGetCurrent()
        let processedImage = try await ImageProcessingPipeline.process(
            image,
            for: purpose,
            with: options
        )
        let endTime = CFAbsoluteTimeGetCurrent()
        
        // Then
        XCTAssertNotNil(processedImage)
        let executionTime = endTime - startTime
        XCTAssertLessThan(executionTime, 1.0) // Should complete in under 1 second
    }
    
    func testBatchProcessingPerformance() async throws {
        // Given
        let images = (0..<10).map { _ in createTestImage() }
        let purpose = ImagePurpose.ocr
        let options = createProcessingOptions()
        
        // When
        let startTime = CFAbsoluteTimeGetCurrent()
        let processedImages = try await withThrowingTaskGroup(of: ProcessedImage.self) { group in
            for image in images {
                group.addTask {
                    try await ImageProcessingPipeline.process(image, for: purpose, with: options)
                }
            }
            
            var results: [ProcessedImage] = []
            for try await result in group {
                results.append(result)
            }
            return results
        }
        let endTime = CFAbsoluteTimeGetCurrent()
        
        // Then
        XCTAssertEqual(processedImages.count, images.count)
        let executionTime = endTime - startTime
        XCTAssertLessThan(executionTime, 5.0) // Should complete in under 5 seconds
    }
    
    // MARK: - Error Handling Tests
    
    func testImageProcessingPipeline_InvalidImage() async {
        // Given
        let invalidImage = PlatformImage() // Empty image
        let purpose = ImagePurpose.ocr
        let options = createProcessingOptions()
        
        // When/Then
        do {
            _ = try await ImageProcessingPipeline.process(
                invalidImage,
                for: purpose,
                with: options
            )
            XCTFail("Should have thrown an error for invalid image")
        } catch {
            XCTAssertTrue(error is ImageProcessingError)
        }
    }
    
    func testImageProcessingPipeline_UnsupportedPurpose() async {
        // Given
        let image = createTestImage()
        let purpose = ImagePurpose.ocr
        let options = ProcessingOptions(
            quality: .high,
            enableEnhancement: true,
            enableOptimization: true,
            targetFormat: .unsupported
        )
        
        // When/Then
        do {
            _ = try await ImageProcessingPipeline.process(
                image,
                for: purpose,
                with: options
            )
            XCTFail("Should have thrown an error for unsupported format")
        } catch {
            XCTAssertTrue(error is ImageProcessingError)
        }
    }
    
    // MARK: - Integration Tests
    
    func testImageProcessingPipeline_Integration() async throws {
        // Given
        let image = createTestImage()
        let purposes: [ImagePurpose] = [.ocr, .fuelReceipt, .document, .photo, .thumbnail, .preview]
        
        // When
        var results: [ProcessedImage] = []
        for purpose in purposes {
            let processedImage = try await ImageProcessingPipeline.process(
                image,
                for: purpose,
                with: createProcessingOptions()
            )
            results.append(processedImage)
        }
        
        // Then
        XCTAssertEqual(results.count, purposes.count)
        for (index, result) in results.enumerated() {
            XCTAssertEqual(result.purpose, purposes[index])
            XCTAssertNotNil(result.originalImage)
        }
    }
}
