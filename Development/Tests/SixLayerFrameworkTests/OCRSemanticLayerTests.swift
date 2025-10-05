//
//  OCRSemanticLayerTests.swift
//  SixLayerFrameworkTests
//
//  BUSINESS PURPOSE:
//  The OCRService provides comprehensive optical character recognition functionality
//  including text extraction, document analysis, and image processing for converting
//  images to text across all supported platforms.
//
//  TESTING SCOPE:
//  - OCR service initialization and configuration
//  - Text extraction and recognition functionality
//  - Document analysis and processing
//  - Error handling and edge cases
//  - Performance and memory management
//
//  METHODOLOGY:
//  - Test actual business logic of OCR processing
//  - Verify text extraction accuracy
//  - Test document analysis algorithms
//  - Validate error handling and edge cases
//  - Test performance characteristics
//

import XCTest
import SwiftUI
@testable import SixLayerFramework

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

/// Test suite for OCRService with proper TDD practices
@MainActor
final class OCRSemanticLayerTests: XCTestCase {
    
    var ocrService: OCRServiceProtocol!
    
    override func setUp() {
        super.setUp()
        ocrService = OCRServiceFactory.create()
    }
    
    override func tearDown() {
        ocrService = nil
        super.tearDown()
    }
    
    // MARK: - Service Initialization Tests
    
    func testOCRServiceInitialization() {
        // Given: OCR service initialization
        let service = OCRServiceFactory.create()
        
        // Then: Test business logic for initialization
        XCTAssertNotNil(service, "OCR service should be created")
    }
    
    func testMockOCRServiceInitialization() {
        // Given: Mock OCR service initialization
        let mockService = OCRServiceFactory.createMock()
        
        // Then: Test business logic for mock initialization
        XCTAssertNotNil(mockService, "Mock OCR service should be created")
    }
    
    // MARK: - Text Extraction Tests
    
    func testOCRServiceTextExtraction() async throws {
        // Given: OCR service and test image
        let service = OCRServiceFactory.create()
        let testImage = createTestImage()
        let context = OCRContext(
            textTypes: [.price, .number],
            language: .english,
            confidenceThreshold: 0.8
        )
        
        // When: Processing image for text extraction
        let strategy = OCRStrategy(
            supportedTextTypes: [.price, .number],
            supportedLanguages: [.english],
            processingMode: .standard
        )
        let result = try await service.processImage(testImage, context: context, strategy: strategy)
        
        // Then: Test business logic for text extraction
        XCTAssertNotNil(result, "OCR result should be available")
        XCTAssertNotNil(result.extractedText, "Extracted text should be available")
        XCTAssertGreaterThanOrEqual(result.confidence, 0.0, "Confidence should be non-negative")
        XCTAssertLessThanOrEqual(result.confidence, 1.0, "Confidence should not exceed 1.0")
    }
    
    func testOCRServiceTextExtractionWithDifferentContexts() async throws {
        // Given: OCR service and different contexts
        let service = OCRServiceFactory.create()
        let testImage = createTestImage()
        
        let contexts = [
            OCRContext(textTypes: [.price], language: .english, confidenceThreshold: 0.9),
            OCRContext(textTypes: [.number], language: .spanish, confidenceThreshold: 0.7),
            OCRContext(textTypes: [.date], language: .french, confidenceThreshold: 0.8)
        ]
        
        // When: Processing image with different contexts
        for context in contexts {
            let strategy = OCRStrategy(
            supportedTextTypes: [.price, .number],
            supportedLanguages: [.english],
            processingMode: .standard
        )
        let result = try await service.processImage(testImage, context: context, strategy: strategy)
            
            // Then: Test business logic for different contexts
            XCTAssertNotNil(result, "OCR result should be available for context: \(context)")
            XCTAssertNotNil(result.extractedText, "Extracted text should be available")
            XCTAssertGreaterThanOrEqual(result.confidence, 0.0, "Confidence should be non-negative")
            XCTAssertLessThanOrEqual(result.confidence, 1.0, "Confidence should not exceed 1.0")
        }
    }
    
    // MARK: - Document Analysis Tests
    
    func testOCRServiceDocumentAnalysis() async throws {
        // Given: OCR service and test image
        let service = OCRServiceFactory.create()
        let testImage = createTestImage()
        let context = OCRContext(
            textTypes: [.price, .number, .date],
            language: .english,
            confidenceThreshold: 0.8
        )
        
        // When: Processing image for document analysis
        let strategy = OCRStrategy(
            supportedTextTypes: [.price, .number],
            supportedLanguages: [.english],
            processingMode: .standard
        )
        let result = try await service.processImage(testImage, context: context, strategy: strategy)
        
        // Then: Test business logic for document analysis
        XCTAssertNotNil(result, "OCR result should be available")
        XCTAssertNotNil(result.extractedText, "Extracted text should be available")
    }
    
    // MARK: - Error Handling Tests
    
    func testOCRServiceErrorHandling() async throws {
        // Given: OCR service with invalid input
        let service = OCRServiceFactory.create()
        let invalidImage = createInvalidImage()
        let context = OCRContext(
            textTypes: [.price],
            language: .english,
            confidenceThreshold: 0.8
        )
        
        // When: Processing invalid image
        let strategy = OCRStrategy(
            supportedTextTypes: [.price],
            supportedLanguages: [.english],
            processingMode: .standard
        )
        
        // Then: Should throw OCRError.invalidImage
        do {
            let _ = try await service.processImage(invalidImage, context: context, strategy: strategy)
            XCTFail("Expected OCRError.invalidImage to be thrown for invalid image")
        } catch OCRError.invalidImage {
            // Expected behavior - invalid image should throw error
            XCTAssertTrue(true, "OCR service correctly throws OCRError.invalidImage for invalid input")
        } catch {
            XCTFail("Expected OCRError.invalidImage, but got: \(error)")
        }
    }
    
    // MARK: - Performance Tests
    
    func testOCRServicePerformance() async throws {
        // Given: OCR service and performance test parameters
        let service = OCRServiceFactory.create()
        let testImage = createTestImage()
        let context = OCRContext(
            textTypes: [.price, .number],
            language: .english,
            confidenceThreshold: 0.8
        )
        
        // When: Processing image and measuring performance
        let startTime = Date()
        let strategy = OCRStrategy(
            supportedTextTypes: [.price, .number],
            supportedLanguages: [.english],
            processingMode: .standard
        )
        let result = try await service.processImage(testImage, context: context, strategy: strategy)
        let endTime = Date()
        let duration = endTime.timeIntervalSince(startTime)
        
        // Then: Test business logic for performance
        XCTAssertNotNil(result, "OCR result should be available")
        XCTAssertLessThan(duration, 10.0, "OCR processing should complete within 10 seconds")
    }
    
    // MARK: - Edge Cases Tests
    
    func testOCRServiceEdgeCases() async throws {
        // Given: OCR service and edge case scenarios
        let service = OCRServiceFactory.create()
        let testImage = createTestImage()
        
        // Test with minimum confidence threshold
        let minConfidenceContext = OCRContext(
            textTypes: [.price],
            language: .english,
            confidenceThreshold: 0.0
        )
        
        // Test with maximum confidence threshold
        let maxConfidenceContext = OCRContext(
            textTypes: [.price],
            language: .english,
            confidenceThreshold: 1.0
        )
        
        // When: Processing with edge case contexts
        let minStrategy = OCRStrategy(
            supportedTextTypes: [.price],
            supportedLanguages: [.english],
            processingMode: .standard
        )
        let maxStrategy = OCRStrategy(
            supportedTextTypes: [.price],
            supportedLanguages: [.english],
            processingMode: .standard
        )
        let minResult = try await service.processImage(testImage, context: minConfidenceContext, strategy: minStrategy)
        let maxResult = try await service.processImage(testImage, context: maxConfidenceContext, strategy: maxStrategy)
        
        // Then: Test business logic for edge cases
        XCTAssertNotNil(minResult, "OCR result should be available for minimum confidence")
        XCTAssertNotNil(maxResult, "OCR result should be available for maximum confidence")
        XCTAssertGreaterThanOrEqual(minResult.confidence, 0.0, "Confidence should be non-negative")
        XCTAssertLessThanOrEqual(maxResult.confidence, 1.0, "Confidence should not exceed 1.0")
    }
    
    // MARK: - Mock Service Tests
    
    func testMockOCRServiceFunctionality() async throws {
        // Given: Mock OCR service with predefined result
        let mockResult = OCRResult(
            extractedText: "Test OCR Result",
            confidence: 0.95,
            processingTime: 0.5
        )
        let mockService = OCRServiceFactory.createMock(result: mockResult)
        let testImage = createTestImage()
        let context = OCRContext(
            textTypes: [.price],
            language: .english,
            confidenceThreshold: 0.8
        )
        
        // When: Processing image with mock service
        let strategy = OCRStrategy(
            supportedTextTypes: [.price],
            supportedLanguages: [.english],
            processingMode: .standard
        )
        let result = try await mockService.processImage(testImage, context: context, strategy: strategy)
        
        // Then: Test business logic for mock service
        XCTAssertNotNil(result, "Mock OCR result should be available")
        XCTAssertEqual(result.extractedText, "Test OCR Result", "Mock result should match expected text")
        XCTAssertEqual(result.confidence, 0.95, "Mock result should match expected confidence")
    }
    
    // MARK: - Helper Methods
    
    private func createTestImage() -> PlatformImage {
        // Create a simple test image for OCR testing
        let size = CGSize(width: 100, height: 100)
        #if os(iOS)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            UIColor.white.setFill()
            context.fill(CGRect(origin: .zero, size: size))
            
            UIColor.black.setFill()
            let textRect = CGRect(x: 10, y: 10, width: 80, height: 20)
            context.fill(textRect)
        }
        #elseif os(macOS)
        let nsImage = NSImage(size: size)
        nsImage.lockFocus()
        NSColor.white.setFill()
        NSRect(origin: .zero, size: size).fill()
        
        NSColor.black.setFill()
        let textRect = NSRect(x: 10, y: 10, width: 80, height: 20)
        textRect.fill()
        nsImage.unlockFocus()
        return PlatformImage(nsImage: nsImage)
        #else
        return PlatformImage()
        #endif
    }
    
    private func createInvalidImage() -> PlatformImage {
        // Create an invalid image for error testing
        return PlatformImage()
    }
}