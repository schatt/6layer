//
//  OCRServiceTests.swift
//  SixLayerFrameworkTests
//
//  Comprehensive tests for the new OCR service architecture
//

import XCTest
@testable import SixLayerFramework

final class OCRServiceTests: XCTestCase {
    
    var ocrService: OCRService!
    var mockOCRService: MockOCRService!
    
    override func setUp() {
        super.setUp()
        ocrService = OCRService()
        mockOCRService = MockOCRService()
    }
    
    override func tearDown() {
        ocrService = nil
        mockOCRService = nil
        super.tearDown()
    }
    
    // MARK: - Service Availability Tests
    
    func testOCRServiceAvailability() {
        // Given: OCR service
        // When: Checking availability
        let isAvailable = ocrService.isAvailable
        
        // Then: Should return appropriate availability based on platform
        #if canImport(Vision)
        #if os(iOS)
        if #available(iOS 11.0, *) {
            XCTAssertTrue(isAvailable, "OCR should be available on iOS 11+")
        } else {
            XCTAssertFalse(isAvailable, "OCR should not be available on older iOS")
        }
        #elseif os(macOS)
        if #available(macOS 10.15, *) {
            XCTAssertTrue(isAvailable, "OCR should be available on macOS 10.15+")
        } else {
            XCTAssertFalse(isAvailable, "OCR should not be available on older macOS")
        }
        #endif
        #else
        XCTAssertFalse(isAvailable, "OCR should not be available without Vision framework")
        #endif
    }
    
    func testOCRCapabilities() {
        // Given: OCR service
        // When: Getting capabilities
        let capabilities = ocrService.capabilities
        
        // Then: Should return appropriate capabilities
        XCTAssertNotNil(capabilities, "Capabilities should not be nil")
        XCTAssertNotNil(capabilities.supportedLanguages, "Supported languages should not be nil")
        XCTAssertNotNil(capabilities.supportedTextTypes, "Supported text types should not be nil")
        XCTAssertGreaterThan(capabilities.maxImageSize.width, 0, "Max image width should be positive")
        XCTAssertGreaterThan(capabilities.maxImageSize.height, 0, "Max image height should be positive")
        XCTAssertGreaterThanOrEqual(capabilities.processingTimeEstimate, 0, "Processing time should be non-negative")
    }
    
    // MARK: - Mock Service Tests
    
    func testMockOCRServiceAvailability() {
        // Given: Mock OCR service
        // When: Checking availability
        let isAvailable = mockOCRService.isAvailable
        
        // Then: Should always be available
        XCTAssertTrue(isAvailable, "Mock OCR service should always be available")
    }
    
    func testMockOCRCapabilities() {
        // Given: Mock OCR service
        // When: Getting capabilities
        let capabilities = mockOCRService.capabilities
        
        // Then: Should return mock capabilities
        XCTAssertTrue(capabilities.supportsVision, "Mock should support Vision")
        XCTAssertFalse(capabilities.supportedLanguages.isEmpty, "Mock should have supported languages")
        XCTAssertFalse(capabilities.supportedTextTypes.isEmpty, "Mock should have supported text types")
        XCTAssertGreaterThan(capabilities.maxImageSize.width, 0, "Mock max image width should be positive")
        XCTAssertGreaterThan(capabilities.processingTimeEstimate, 0, "Mock processing time should be positive")
    }
    
    func testMockOCRProcessing() async throws {
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
        let image = PlatformImage()
        
        // When: Processing image
        let result = try await mockService.processImage(image, context: context, strategy: strategy)
        
        // Then: Should return expected result
        XCTAssertEqual(result.extractedText, expectedResult.extractedText)
        XCTAssertEqual(result.confidence, expectedResult.confidence, accuracy: 0.01)
        XCTAssertEqual(result.boundingBoxes.count, expectedResult.boundingBoxes.count)
        XCTAssertEqual(result.textTypes.count, expectedResult.textTypes.count)
        XCTAssertEqual(result.language, expectedResult.language)
    }
    
    // MARK: - Error Handling Tests
    
    func testOCRServiceWithUnavailableVision() async {
        // Given: OCR service when Vision is not available
        // This test is platform-specific and may not always fail
        // We'll test the error handling path
        
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
        let image = PlatformImage()
        
        // When: Processing image
        do {
            let _ = try await ocrService.processImage(image, context: context, strategy: strategy)
            // If we get here, Vision is available, which is fine
        } catch {
            // If we get an error, it should be a proper OCR error
            XCTAssertTrue(error is OCRError, "Error should be OCRError type")
        }
    }
    
    // MARK: - Service Factory Tests
    
    func testOCRServiceFactory() {
        // Given: OCR service factory
        // When: Creating service
        let service = OCRServiceFactory.create()
        
        // Then: Should return OCR service
        XCTAssertTrue(service is OCRService, "Factory should return OCRService")
    }
    
    func testMockOCRServiceFactory() {
        // Given: OCR service factory
        // When: Creating mock service
        let mockService = OCRServiceFactory.createMock()
        
        // Then: Should return mock service
        XCTAssertTrue(mockService is MockOCRService, "Factory should return MockOCRService")
    }
    
    func testMockOCRServiceFactoryWithResult() {
        // Given: OCR service factory with custom result
        let expectedResult = OCRResult(
            extractedText: "Custom Mock Result",
            confidence: 0.9,
            boundingBoxes: [],
            textTypes: [:],
            processingTime: 0.05,
            language: .english
        )
        
        // When: Creating mock service with result
        let mockService = OCRServiceFactory.createMock(result: expectedResult)
        
        // Then: Should return mock service with custom result
        XCTAssertTrue(mockService is MockOCRService, "Factory should return MockOCRService")
    }
    
    // MARK: - Performance Tests
    
    func testOCRServicePerformance() {
        // Given: OCR service
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
        let image = PlatformImage()
        
        // When: Measuring performance
        measure {
            let expectation = XCTestExpectation(description: "OCR Performance")
            
            Task {
                do {
                    let _ = try await ocrService.processImage(image, context: context, strategy: strategy)
                } catch {
                    // Expected for unavailable Vision
                }
                expectation.fulfill()
            }
            
            wait(for: [expectation], timeout: 5.0)
        }
    }
    
    // MARK: - Integration Tests
    
    func testOCRServiceWithDifferentTextTypes() async throws {
        // Given: Mock OCR service
        let mockService = MockOCRService()
        let image = PlatformImage()
        
        let textTypes: [TextType] = [.price, .date, .email, .phone, .url, .general]
        
        for textType in textTypes {
            // When: Processing with specific text type
            let context = OCRContext(
                textTypes: [textType],
                language: .english,
                confidenceThreshold: 0.8
            )
            let strategy = OCRStrategy(
                supportedTextTypes: [textType],
                supportedLanguages: [.english],
                processingMode: .standard,
                requiresNeuralEngine: false,
                estimatedProcessingTime: 1.0
            )
            
            let result = try await mockService.processImage(image, context: context, strategy: strategy)
            
            // Then: Should process successfully
            XCTAssertNotNil(result, "Result should not be nil for \(textType)")
            XCTAssertFalse(result.extractedText.isEmpty, "Extracted text should not be empty for \(textType)")
        }
    }
    
    func testOCRServiceWithDifferentLanguages() async throws {
        // Given: Mock OCR service
        let mockService = MockOCRService()
        let image = PlatformImage()
        
        let languages: [OCRLanguage] = [.english, .spanish, .french, .german]
        
        for language in languages {
            // When: Processing with specific language
            let context = OCRContext(
                textTypes: [.general],
                language: language,
                confidenceThreshold: 0.8
            )
            let strategy = OCRStrategy(
                supportedTextTypes: [.general],
                supportedLanguages: [language],
                processingMode: .standard,
                requiresNeuralEngine: false,
                estimatedProcessingTime: 1.0
            )
            
            let result = try await mockService.processImage(image, context: context, strategy: strategy)
            
            // Then: Should process successfully
            XCTAssertNotNil(result, "Result should not be nil for \(language)")
            XCTAssertEqual(result.language, language, "Result language should match input language")
        }
    }
    
    func testOCRServiceWithDifferentProcessingModes() async throws {
        // Given: Mock OCR service
        let mockService = MockOCRService()
        let image = PlatformImage()
        
        let processingModes: [OCRProcessingMode] = [.fast, .standard, .accurate]
        
        for mode in processingModes {
            // When: Processing with specific mode
            let context = OCRContext(
                textTypes: [.general],
                language: .english,
                confidenceThreshold: 0.8
            )
            let strategy = OCRStrategy(
                supportedTextTypes: [.general],
                supportedLanguages: [.english],
                processingMode: mode,
                requiresNeuralEngine: false,
                estimatedProcessingTime: 1.0
            )
            
            let result = try await mockService.processImage(image, context: context, strategy: strategy)
            
            // Then: Should process successfully
            XCTAssertNotNil(result, "Result should not be nil for \(mode)")
        }
    }
}
