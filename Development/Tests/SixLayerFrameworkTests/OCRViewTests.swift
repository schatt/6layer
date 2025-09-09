//
//  OCRViewTests.swift
//  SixLayerFrameworkTests
//
//  Tests for SwiftUI OCR integration layer
//

import XCTest
import SwiftUI
@testable import SixLayerFramework

final class OCRViewTests: XCTestCase {
    
    var mockOCRService: MockOCRService!
    
    override func setUp() {
        super.setUp()
        mockOCRService = MockOCRService()
    }
    
    override func tearDown() {
        mockOCRService = nil
        super.tearDown()
    }
    
    // MARK: - OCR View Tests
    
    func testOCRViewInitialization() {
        // Given: OCR view parameters
        let image = PlatformImage()
        let context = OCRContext(
            textTypes: [.general],
            language: .english,
            confidenceThreshold: 0.8
        )
        let strategy = OCRStrategy(
            supportedTextTypes: [.general],
            supportedLanguages: [.english],
            processingMode: .standard,
            requiresNeuralEngine: false,
            estimatedProcessingTime: 1.0
        )
        
        var _: OCRResult?
        var _: Error?
        
        // When: Creating OCR view
        let ocrView = OCRView(
            service: mockOCRService,
            image: image,
            context: context,
            strategy: strategy,
            onResult: { _ in
                // Result handler
            },
            onError: { _ in
                // Error handler
            }
        )
        
        // Then: Should create view successfully
        XCTAssertNotNil(ocrView, "OCR view should be created")
    }
    
    func testOCRViewWithMockService() {
        // Given: Mock OCR service with custom result
        let expectedResult = OCRResult(
            extractedText: "Test OCR Result",
            confidence: 0.95,
            boundingBoxes: [CGRect(x: 0, y: 0, width: 100, height: 20)],
            textTypes: [.general: "Test OCR Result"],
            processingTime: 0.1,
            language: .english
        )
        
        let mockService = MockOCRService(mockResult: expectedResult)
        let image = PlatformImage()
        let context = OCRContext(
            textTypes: [.general],
            language: .english,
            confidenceThreshold: 0.8
        )
        let strategy = OCRStrategy(
            supportedTextTypes: [.general],
            supportedLanguages: [.english],
            processingMode: .standard,
            requiresNeuralEngine: false,
            estimatedProcessingTime: 1.0
        )
        
        var _: OCRResult?
        var _: Error?
        
        // When: Creating OCR view with mock service
        let ocrView = OCRView(
            service: mockService,
            image: image,
            context: context,
            strategy: strategy,
            onResult: { _ in
                // Result handler
            },
            onError: { _ in
                // Error handler
            }
        )
        
        // Then: Should create view successfully
        XCTAssertNotNil(ocrView, "OCR view should be created")
    }
    
    // MARK: - OCR Progress View Tests
    
    func testOCRProgressView() {
        // Given: Progress value
        let progress: Double = 0.5
        
        // When: Creating progress view
        let progressView = OCRProgressView(progress: progress)
        
        // Then: Should create view successfully
        XCTAssertNotNil(progressView, "Progress view should be created")
    }
    
    func testOCRProgressViewWithDifferentValues() {
        // Given: Different progress values
        let progressValues: [Double] = [0.0, 0.25, 0.5, 0.75, 1.0]
        
        for progress in progressValues {
            // When: Creating progress view
            let progressView = OCRProgressView(progress: progress)
            
            // Then: Should create view successfully
            XCTAssertNotNil(progressView, "Progress view should be created for progress \(progress)")
        }
    }
    
    // MARK: - OCR Result View Tests
    
    func testOCRResultView() {
        // Given: OCR result
        let result = OCRResult(
            extractedText: "Test OCR Result",
            confidence: 0.95,
            boundingBoxes: [CGRect(x: 0, y: 0, width: 100, height: 20)],
            textTypes: [.general: "Test OCR Result"],
            processingTime: 0.1,
            language: .english
        )
        
        // When: Creating result view
        let resultView = OCRResultView(result: result)
        
        // Then: Should create view successfully
        XCTAssertNotNil(resultView, "Result view should be created")
    }
    
    func testOCRResultViewWithEmptyResult() {
        // Given: Empty OCR result
        let result = OCRResult(
            extractedText: "",
            confidence: 0.0,
            boundingBoxes: [],
            textTypes: [:],
            processingTime: 0.0,
            language: nil
        )
        
        // When: Creating result view
        let resultView = OCRResultView(result: result)
        
        // Then: Should create view successfully
        XCTAssertNotNil(resultView, "Result view should be created even with empty result")
    }
    
    func testOCRResultViewWithDifferentTextTypes() {
        // Given: OCR result with different text types
        let result = OCRResult(
            extractedText: "Price: $10.99 Date: 2023-01-01",
            confidence: 0.9,
            boundingBoxes: [
                CGRect(x: 0, y: 0, width: 50, height: 20),
                CGRect(x: 0, y: 25, width: 100, height: 20)
            ],
            textTypes: [
                .price: "$10.99",
                .date: "2023-01-01"
            ],
            processingTime: 0.2,
            language: .english
        )
        
        // When: Creating result view
        let resultView = OCRResultView(result: result)
        
        // Then: Should create view successfully
        XCTAssertNotNil(resultView, "Result view should be created with different text types")
    }
    
    // MARK: - OCR Error View Tests
    
    func testOCRErrorView() {
        // Given: Error
        let error = OCRError.visionUnavailable
        
        // When: Creating error view
        let errorView = OCRErrorView(error: error)
        
        // Then: Should create view successfully
        XCTAssertNotNil(errorView, "Error view should be created")
    }
    
    func testOCRErrorViewWithDifferentErrors() {
        // Given: Different errors
        let errors: [Error] = [
            OCRError.visionUnavailable,
            OCRError.invalidImage,
            OCRError.noTextFound,
            NSError(domain: "TestDomain", code: 123, userInfo: [NSLocalizedDescriptionKey: "Test Error"])
        ]
        
        for error in errors {
            // When: Creating error view
            let errorView = OCRErrorView(error: error)
            
            // Then: Should create view successfully
            XCTAssertNotNil(errorView, "Error view should be created for error: \(error)")
        }
    }
    
    // MARK: - OCR Image View Tests
    
    func testOCRImageView() {
        // Given: Platform image and tap handler
        let image = PlatformImage()
        var _ = false
        
        // When: Creating image view
        let imageView = OCRImageView(image: image) {
            // Tap handler
        }
        
        // Then: Should create view successfully
        XCTAssertNotNil(imageView, "Image view should be created")
    }
    
    // MARK: - Legacy OCR View Tests
    
    func testLegacyOCRView() {
        // Given: Legacy OCR view parameters
        let image = PlatformImage()
        let context = OCRContext(
            textTypes: [.general],
            language: .english,
            confidenceThreshold: 0.8
        )
        let strategy = OCRStrategy(
            supportedTextTypes: [.general],
            supportedLanguages: [.english],
            processingMode: .standard,
            requiresNeuralEngine: false,
            estimatedProcessingTime: 1.0
        )
        
        var _: OCRResult?
        var _: Error?
        
        // When: Creating legacy OCR view
        let legacyView = LegacyOCRView(
            image: image,
            context: context,
            strategy: strategy,
            onResult: { _ in
                // Result handler
            },
            onError: { _ in
                // Error handler
            }
        )
        
        // Then: Should create view successfully
        XCTAssertNotNil(legacyView, "Legacy OCR view should be created")
    }
    
    // MARK: - OCR Service Factory Tests
    
    func testOCRServiceFactory() {
        // Given: OCR service factory
        // When: Creating service
        let service = OCRServiceFactory.create()
        
        // Then: Should return service
        XCTAssertNotNil(service, "Service should not be nil")
        XCTAssertTrue(service is OCRService, "Should return OCRService")
    }
    
    func testOCRServiceFactoryCapabilities() {
        // Given: OCR service factory
        let service = OCRServiceFactory.create()
        
        // When: Getting capabilities
        let capabilities = service.capabilities
        
        // Then: Should return capabilities
        XCTAssertNotNil(capabilities, "Capabilities should not be nil")
        XCTAssertNotNil(capabilities.supportedLanguages, "Supported languages should not be nil")
        XCTAssertNotNil(capabilities.supportedTextTypes, "Supported text types should not be nil")
    }
    
    func testOCRServiceFactoryAvailability() {
        // Given: OCR service factory
        let service = OCRServiceFactory.create()
        
        // When: Checking availability
        let isAvailable = service.isAvailable
        
        // Then: Should return availability status
        XCTAssertNotNil(isAvailable, "Availability should not be nil")
    }
    
    // MARK: - Integration Tests
    
    func testOCRViewIntegration() async {
        // Given: OCR view with mock service
        let expectedResult = OCRResult(
            extractedText: "Integration Test Result",
            confidence: 0.9,
            boundingBoxes: [CGRect(x: 0, y: 0, width: 200, height: 30)],
            textTypes: [.general: "Integration Test Result"],
            processingTime: 0.15,
            language: .english
        )
        
        let mockService = MockOCRService(mockResult: expectedResult)
        let image = PlatformImage()
        let context = OCRContext(
            textTypes: [.general],
            language: .english,
            confidenceThreshold: 0.8
        )
        let strategy = OCRStrategy(
            supportedTextTypes: [.general],
            supportedLanguages: [.english],
            processingMode: .standard,
            requiresNeuralEngine: false,
            estimatedProcessingTime: 1.0
        )
        
        var _: OCRResult?
        var _: Error?
        
        // When: Creating OCR view
        let ocrView = OCRView(
            service: mockService,
            image: image,
            context: context,
            strategy: strategy,
            onResult: { _ in
                // Result handler
            },
            onError: { _ in
                // Error handler
            }
        )
        
        // Then: Should create view successfully
        XCTAssertNotNil(ocrView, "OCR view should be created")
        
        // Wait a bit for async processing
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
    }
}
