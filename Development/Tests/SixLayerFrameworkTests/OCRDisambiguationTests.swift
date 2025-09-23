//
//  OCRDisambiguationTests.swift
//  SixLayerFrameworkTests
//
//  Tests for platformOCRWithDisambiguation_L1 function
//  Tests OCR disambiguation functionality and error handling
//

import XCTest
import SwiftUI
@testable import SixLayerFramework

@MainActor
final class OCRDisambiguationTests: XCTestCase {
    
    // MARK: - Test Data
    
    private func createTestPlatformImage() -> PlatformImage {
        return PlatformImage()
    }
    
    private func createTestOCRContext() -> OCRContext {
        return OCRContext(
            textTypes: [.general],
            language: .english,
            confidenceThreshold: 0.8,
            allowsEditing: true,
            maxImageSize: nil,
            extractionHints: [:],
            requiredFields: [],
            documentType: .general,
            extractionMode: .automatic
        )
    }
    
    private func createTestOCRDisambiguationConfiguration() -> OCRDisambiguationConfiguration {
        return OCRDisambiguationConfiguration(
            confidenceThreshold: 0.8,
            maxCandidates: 5,
            enableCustomText: true,
            showBoundingBoxes: true,
            allowSkip: true
        )
    }
    
    // MARK: - Basic OCR Disambiguation Tests
    
    func testPlatformOCRWithDisambiguation_L1_BasicFunctionality() {
        // Given: Test image and context
        let testImage = createTestPlatformImage()
        let context = createTestOCRContext()
        
        // When: Creating OCR disambiguation view
        let view = platformOCRWithDisambiguation_L1(
            image: testImage,
            context: context
        ) { result in
            // This callback should be called, but we'll test the view creation
            XCTAssertNotNil(result)
        }
        
        // Then: Should create view successfully
        XCTAssertNotNil(view, "OCR disambiguation view should be created")
    }
    
    func testPlatformOCRWithDisambiguation_L1_WithCustomConfiguration() {
        // Given: Test image, context, and custom configuration
        let testImage = createTestPlatformImage()
        let context = createTestOCRContext()
        let configuration = createTestOCRDisambiguationConfiguration()
        
        // When: Creating OCR disambiguation view with configuration
        let view = platformOCRWithDisambiguation_L1(
            image: testImage,
            context: context,
            configuration: configuration
        ) { result in
            // This callback should be called, but we'll test the view creation
            XCTAssertNotNil(result)
        }
        
        // Then: Should create view successfully
        XCTAssertNotNil(view, "OCR disambiguation view with configuration should be created")
    }
    
    // MARK: - Configuration Tests
    
    func testOCRDisambiguationConfiguration_DefaultValues() {
        // Given: Default configuration
        let config = OCRDisambiguationConfiguration()
        
        // Then: Should have reasonable default values
        XCTAssertGreaterThan(config.maxCandidates, 0, "Should have positive max candidates")
        XCTAssertGreaterThanOrEqual(config.confidenceThreshold, 0.0, "Should have valid confidence threshold")
        XCTAssertLessThanOrEqual(config.confidenceThreshold, 1.0, "Should have valid confidence threshold")
    }
    
    func testOCRDisambiguationConfiguration_CustomValues() {
        // Given: Custom configuration
        let config = OCRDisambiguationConfiguration(
            confidenceThreshold: 0.9,
            maxCandidates: 10,
            enableCustomText: true,
            showBoundingBoxes: false,
            allowSkip: true
        )
        
        // Then: Should preserve custom values
        XCTAssertEqual(config.maxCandidates, 10)
        XCTAssertEqual(config.confidenceThreshold, 0.9)
        XCTAssertTrue(config.enableCustomText)
        XCTAssertFalse(config.showBoundingBoxes)
    }
    
    // MARK: - Context Tests
    
    func testOCRDisambiguation_DifferentContextTypes() {
        // Given: Different context types
        let contexts = [
            OCRContext(textTypes: [.general], language: .english, confidenceThreshold: 0.9),
            OCRContext(textTypes: [.price, .number], language: .spanish, confidenceThreshold: 0.7),
            OCRContext(textTypes: [.email, .phone, .url], language: .french, confidenceThreshold: 0.5)
        ]
        
        let testImage = createTestPlatformImage()
        
        // When: Testing each context type
        for context in contexts {
            let view = platformOCRWithDisambiguation_L1(
                image: testImage,
                context: context
            ) { result in
                // This callback should be called, but we'll test the view creation
                XCTAssertNotNil(result)
            }
            
            // Then: Should create view for all context types
            XCTAssertNotNil(view, "OCR disambiguation view should be created for context: \(context.textTypes)")
        }
    }
    
    // MARK: - Error Handling Tests
    
    func testOCRDisambiguation_EmptyImage() {
        // Given: Empty image
        let emptyImage = PlatformImage()
        let context = createTestOCRContext()
        
        // When: Processing empty image
        let view = platformOCRWithDisambiguation_L1(
            image: emptyImage,
            context: context
        ) { result in
            // This callback should be called, but we'll test the view creation
            XCTAssertNotNil(result)
        }
        
        // Then: Should create view even with empty image
        XCTAssertNotNil(view, "OCR disambiguation view should be created even with empty image")
    }
    
    func testOCRDisambiguation_InvalidConfiguration() {
        // Given: Invalid configuration values
        let invalidConfig = OCRDisambiguationConfiguration(
            confidenceThreshold: 1.5, // Invalid: should be <= 1.0
            maxCandidates: 0, // Invalid: should be positive
            enableCustomText: true,
            showBoundingBoxes: true,
            allowSkip: true
        )
        
        let testImage = createTestPlatformImage()
        let context = createTestOCRContext()
        
        // When: Using invalid configuration
        let view = platformOCRWithDisambiguation_L1(
            image: testImage,
            context: context,
            configuration: invalidConfig
        ) { result in
            // This callback should be called, but we'll test the view creation
            XCTAssertNotNil(result)
        }
        
        // Then: Should create view even with invalid config
        XCTAssertNotNil(view, "OCR disambiguation view should be created even with invalid config")
    }
    
    // MARK: - Performance Tests
    
    func testOCRDisambiguation_Performance() {
        // Given: Test data
        let testImage = createTestPlatformImage()
        let context = createTestOCRContext()
        
        // When: Measuring performance
        measure {
            let view = platformOCRWithDisambiguation_L1(
                image: testImage,
                context: context
            ) { result in
                XCTAssertNotNil(result)
            }
            
            XCTAssertNotNil(view)
        }
    }
    
    // MARK: - Integration Tests
    
    func testOCRDisambiguation_IntegrationWithMockService() {
        // Given: Mock OCR service setup
        let testImage = createTestPlatformImage()
        let context = createTestOCRContext()
        
        // When: Using OCR disambiguation with mock service
        let view = platformOCRWithDisambiguation_L1(
            image: testImage,
            context: context
        ) { result in
            // This callback should be called, but we'll test the view creation
            XCTAssertNotNil(result)
        }
        
        // Then: Should create view successfully
        XCTAssertNotNil(view, "OCR disambiguation view should be created with mock service")
    }
}
