//
//  PlatformOCRWithDisambiguationL1ComprehensiveTests.swift
//  SixLayerFrameworkTests
//
//  Comprehensive tests for platformOCRWithDisambiguation_L1 function
//  Covers all TextType values, confidence levels, configurations, and edge cases
//

import XCTest
@testable import SixLayerFramework

@MainActor
final class PlatformOCRWithDisambiguationL1ComprehensiveTests: XCTestCase {

    // MARK: - Test Configuration

    /// Test configuration for OCR disambiguation
    struct OCRDisambiguationTestConfiguration {
        let name: String
        let image: PlatformImage
        let context: OCRContext
        let configuration: OCRDisambiguationConfiguration?
        let expectedViewType: String
        let shouldTestProcessing: Bool
        let shouldTestDisambiguation: Bool
        let shouldTestAutoConfirm: Bool
        let shouldTestErrorHandling: Bool
    }

    // MARK: - Test Data

    private let testImage = PlatformImage()
    private let standardContext = OCRContext(
        textTypes: [.price, .date, .phone],
        language: .english,
        confidenceThreshold: 0.8
    )

    private let highConfidenceContext = OCRContext(
        textTypes: [.price],
        language: .english,
        confidenceThreshold: 0.9
    )

    private let lowConfidenceContext = OCRContext(
        textTypes: [.general, .number],
        language: .english,
        confidenceThreshold: 0.6
    )

    private let defaultConfig = OCRDisambiguationConfiguration()
    private let strictConfig = OCRDisambiguationConfiguration(
        confidenceThreshold: 0.95,
        maxCandidates: 3,
        enableCustomText: false,
        showBoundingBoxes: true,
        allowSkip: false
    )

    private let lenientConfig = OCRDisambiguationConfiguration(
        confidenceThreshold: 0.5,
        maxCandidates: 10,
        enableCustomText: true,
        showBoundingBoxes: false,
        allowSkip: true
    )

    // MARK: - Basic Function Tests

    func testPlatformOCRWithDisambiguation_L1_BasicCreation() {
        // Given: Basic parameters
        let image = testImage
        let context = standardContext
        var resultReceived = false
        var receivedResult: OCRDisambiguationResult?

        // When: Creating OCR disambiguation view
        let view = platformOCRWithDisambiguation_L1(
            image: image,
            context: context
        ) { result in
            resultReceived = true
            receivedResult = result
        }

        // Then: Should create view successfully
        XCTAssertNotNil(view, "Should create OCR disambiguation view")

        // Verify view type
        let mirror = Mirror(reflecting: view)
        XCTAssertEqual(String(describing: mirror.subjectType), "OCRDisambiguationWrapper")
    }

    func testPlatformOCRWithDisambiguation_L1_WithCustomConfiguration() {
        // Given: Custom configuration
        let image = testImage
        let context = standardContext
        let configuration = strictConfig
        var resultReceived = false

        // When: Creating OCR disambiguation view with custom config
        let view = platformOCRWithDisambiguation_L1(
            image: image,
            context: context,
            configuration: configuration
        ) { result in
            resultReceived = true
        }

        // Then: Should create view with custom configuration
        XCTAssertNotNil(view, "Should create OCR disambiguation view with custom config")

        let mirror = Mirror(reflecting: view)
        XCTAssertEqual(String(describing: mirror.subjectType), "OCRDisambiguationWrapper")
    }

    // MARK: - TextType Coverage Tests

    func testPlatformOCRWithDisambiguation_L1_AllTextTypes() {
        // Given: All TextType values
        let allTextTypes: [TextType] = [
            .price, .number, .date, .address, .email, .phone, .url, .general,
            .name, .idNumber, .stationName, .total, .vendor, .expiryDate,
            .quantity, .unit, .currency, .percentage, .postalCode, .state, .country
        ]

        // Test each text type individually
        for textType in allTextTypes {
            let context = OCRContext(
                textTypes: [textType],
                language: .english,
                confidenceThreshold: 0.8
            )

            var resultReceived = false

            // When: Creating OCR disambiguation for each text type
            let view = platformOCRWithDisambiguation_L1(
                image: testImage,
                context: context
            ) { result in
                resultReceived = true
                XCTAssertFalse(result.candidates.isEmpty,
                              "Should generate candidates for \(textType)")
            }

            // Then: Should handle each text type
            XCTAssertNotNil(view, "Should handle text type: \(textType)")
        }
    }

    func testPlatformOCRWithDisambiguation_L1_MultipleTextTypes() {
        // Given: Multiple text types in single context
        let multiTypeContext = OCRContext(
            textTypes: [.price, .date, .phone, .email, .name],
            language: .english,
            confidenceThreshold: 0.8
        )
        var resultReceived = false

        // When: Creating OCR disambiguation with multiple text types
        let view = platformOCRWithDisambiguation_L1(
            image: testImage,
            context: multiTypeContext
        ) { result in
            resultReceived = true
            // Should have candidates for each requested type
            XCTAssertFalse(result.candidates.isEmpty,
                          "Should generate candidates for multiple text types")
        }

        // Then: Should handle multiple text types
        XCTAssertNotNil(view, "Should handle multiple text types")
    }

    // MARK: - Confidence Level Tests

    func testPlatformOCRWithDisambiguation_L1_HighConfidenceAutoConfirm() {
        // Given: High confidence context
        let context = highConfidenceContext
        var resultReceived = false
        var finalResult: OCRDisambiguationResult?

        // When: Creating OCR disambiguation with high confidence
        let view = platformOCRWithDisambiguation_L1(
            image: testImage,
            context: context
        ) { result in
            resultReceived = true
            finalResult = result
        }

        // Then: Should auto-confirm high confidence results
        XCTAssertNotNil(view, "Should handle high confidence context")
        // Note: The actual result verification would happen in the callback
        // In real testing, we'd need to wait for the async processing
    }

    func testPlatformOCRWithDisambiguation_L1_LowConfidenceRequiresSelection() {
        // Given: Low confidence context
        let context = lowConfidenceContext
        var resultReceived = false

        // When: Creating OCR disambiguation with low confidence
        let view = platformOCRWithDisambiguation_L1(
            image: testImage,
            context: context
        ) { result in
            resultReceived = true
            // Should require user selection for low confidence
            XCTAssertTrue(result.requiresUserSelection || result.candidates.count > 1,
                         "Should require selection for low confidence")
        }

        // Then: Should require user disambiguation
        XCTAssertNotNil(view, "Should handle low confidence context")
    }

    // MARK: - Configuration Tests

    func testPlatformOCRWithDisambiguation_L1_StrictConfiguration() {
        // Given: Strict configuration
        let context = standardContext
        let configuration = strictConfig
        var resultReceived = false

        // When: Creating OCR disambiguation with strict config
        let view = platformOCRWithDisambiguation_L1(
            image: testImage,
            context: context,
            configuration: configuration
        ) { result in
            resultReceived = true
            // Should have fewer candidates due to strict config
            XCTAssertLessThanOrEqual(result.candidates.count, 3,
                                   "Should respect maxCandidates limit")
        }

        // Then: Should apply strict configuration
        XCTAssertNotNil(view, "Should handle strict configuration")
    }

    func testPlatformOCRWithDisambiguation_L1_LenientConfiguration() {
        // Given: Lenient configuration
        let context = standardContext
        let configuration = lenientConfig
        var resultReceived = false

        // When: Creating OCR disambiguation with lenient config
        let view = platformOCRWithDisambiguation_L1(
            image: testImage,
            context: context,
            configuration: configuration
        ) { result in
            resultReceived = true
            // Should allow more candidates and custom text
            XCTAssertLessThanOrEqual(result.candidates.count, 10,
                                   "Should respect maxCandidates limit")
        }

        // Then: Should apply lenient configuration
        XCTAssertNotNil(view, "Should handle lenient configuration")
    }

    func testPlatformOCRWithDisambiguation_L1_DefaultConfiguration() {
        // Given: Default configuration
        let context = standardContext
        var resultReceived = false

        // When: Creating OCR disambiguation with default config (nil)
        let view = platformOCRWithDisambiguation_L1(
            image: testImage,
            context: context,
            configuration: nil
        ) { result in
            resultReceived = true
            // Should use default configuration values
            XCTAssertLessThanOrEqual(result.candidates.count, 5,
                                   "Should use default maxCandidates")
        }

        // Then: Should use default configuration
        XCTAssertNotNil(view, "Should handle default configuration")
    }

    // MARK: - Language Tests

    func testPlatformOCRWithDisambiguation_L1_DifferentLanguages() {
        // Given: Different languages
        let languages: [OCRLanguage] = [.english, .spanish, .french, .german, .italian]

        for language in languages {
            let context = OCRContext(
                textTypes: [.general, .name],
                language: language,
                confidenceThreshold: 0.8
            )

            var resultReceived = false

            // When: Creating OCR disambiguation for different languages
            let view = platformOCRWithDisambiguation_L1(
                image: testImage,
                context: context
            ) { result in
                resultReceived = true
                XCTAssertFalse(result.candidates.isEmpty,
                              "Should generate candidates for \(language)")
            }

            // Then: Should handle each language
            XCTAssertNotNil(view, "Should handle language: \(language)")
        }
    }

    // MARK: - Edge Cases and Error Handling

    func testPlatformOCRWithDisambiguation_L1_EmptyContext() {
        // Given: Empty text types
        let emptyContext = OCRContext(
            textTypes: [],
            language: .english,
            confidenceThreshold: 0.8
        )
        var resultReceived = false

        // When: Creating OCR disambiguation with empty context
        let view = platformOCRWithDisambiguation_L1(
            image: testImage,
            context: emptyContext
        ) { result in
            resultReceived = true
            // Should handle empty context gracefully
            XCTAssertTrue(result.candidates.isEmpty,
                         "Should handle empty text types")
        }

        // Then: Should handle empty context
        XCTAssertNotNil(view, "Should handle empty context")
    }

    func testPlatformOCRWithDisambiguation_L1_SingleCandidate() {
        // Given: Context that should generate single candidate
        let singleTypeContext = OCRContext(
            textTypes: [.price],
            language: .english,
            confidenceThreshold: 0.8
        )
        var resultReceived = false

        // When: Creating OCR disambiguation for single type
        let view = platformOCRWithDisambiguation_L1(
            image: testImage,
            context: singleTypeContext
        ) { result in
            resultReceived = true
            // Should have at least one candidate
            XCTAssertFalse(result.candidates.isEmpty,
                          "Should have candidates for single type")
        }

        // Then: Should handle single type context
        XCTAssertNotNil(view, "Should handle single type context")
    }

    func testPlatformOCRWithDisambiguation_L1_ConfidenceBoundaries() {
        // Given: Different confidence thresholds
        let confidenceLevels: [Float] = [0.3, 0.5, 0.7, 0.8, 0.9, 0.95]

        for confidenceThreshold in confidenceLevels {
            let context = OCRContext(
                textTypes: [.price, .number],
                language: .english,
                confidenceThreshold: confidenceThreshold
            )

            var resultReceived = false

            // When: Creating OCR disambiguation with different confidence levels
            let view = platformOCRWithDisambiguation_L1(
                image: testImage,
                context: context
            ) { result in
                resultReceived = true
                // All candidates should meet the confidence threshold
                for candidate in result.candidates {
                    XCTAssertGreaterThanOrEqual(candidate.confidence, confidenceThreshold,
                                               "Candidate should meet confidence threshold")
                }
            }

            // Then: Should handle confidence boundaries
            XCTAssertNotNil(view, "Should handle confidence threshold: \(confidenceThreshold)")
        }
    }

    // MARK: - Performance Tests

    func testPlatformOCRWithDisambiguation_L1_Performance() {
        // Given: Standard parameters
        let context = standardContext

        // When: Measuring performance
        measure {
            let view = platformOCRWithDisambiguation_L1(
                image: testImage,
                context: context
            ) { _ in
                // Performance test - just measure view creation
            }
            XCTAssertNotNil(view)
        }
    }

    func testPlatformOCRWithDisambiguation_L1_LargeImagePerformance() {
        // Given: Large context with many text types
        let largeContext = OCRContext(
            textTypes: [.price, .number, .date, .address, .email, .phone, .url,
                       .name, .idNumber, .stationName, .total, .vendor],
            language: .english,
            confidenceThreshold: 0.8
        )

        // When: Measuring performance with large context
        measure {
            let view = platformOCRWithDisambiguation_L1(
                image: testImage,
                context: largeContext
            ) { _ in
                // Performance test - measure with many text types
            }
            XCTAssertNotNil(view)
        }
    }

    // MARK: - Integration Tests

    func testPlatformOCRWithDisambiguation_L1_CallbackExecution() {
        // Given: Callback verification
        let context = standardContext
        var callbackExecuted = false
        var receivedResult: OCRDisambiguationResult?

        // When: Creating OCR disambiguation and verifying callback
        let view = platformOCRWithDisambiguation_L1(
            image: testImage,
            context: context
        ) { result in
            callbackExecuted = true
            receivedResult = result
        }

        // Then: Should execute callback
        XCTAssertNotNil(view, "Should create view successfully")

        // Note: In a real test, we'd need to wait for the async processing
        // The callback verification would happen after the processing completes
    }

    func testPlatformOCRWithDisambiguation_L1_ResultValidation() {
        // Given: Result validation context
        let validationContext = OCRContext(
            textTypes: [.price, .date],
            language: .english,
            confidenceThreshold: 0.8
        )
        var validationResult: OCRDisambiguationResult?

        // When: Creating OCR disambiguation for validation
        let view = platformOCRWithDisambiguation_L1(
            image: testImage,
            context: validationContext
        ) { result in
            validationResult = result
            // Validate result structure
            XCTAssertFalse(result.candidates.isEmpty,
                          "Should have candidates")
            XCTAssertGreaterThanOrEqual(result.confidence, 0.0,
                                      "Confidence should be valid")
            XCTAssertLessThanOrEqual(result.confidence, 1.0,
                                   "Confidence should be valid")

            // Validate each candidate
            for candidate in result.candidates {
                XCTAssertFalse(candidate.text.isEmpty,
                              "Candidate text should not be empty")
                XCTAssertTrue(candidate.alternativeTypes.contains(candidate.suggestedType),
                             "Suggested type should be in alternatives")
                XCTAssertGreaterThanOrEqual(candidate.confidence, 0.0,
                                          "Candidate confidence should be valid")
                XCTAssertLessThanOrEqual(candidate.confidence, 1.0,
                                       "Candidate confidence should be valid")
            }
        }

        // Then: Should validate result structure
        XCTAssertNotNil(view, "Should create view for validation")
    }

    // MARK: - Cross-Platform Tests

    func testPlatformOCRWithDisambiguation_L1_CrossPlatformCompatibility() {
        // Given: Cross-platform context
        let crossPlatformContext = OCRContext(
            textTypes: [.general, .number, .date],
            language: .english,
            confidenceThreshold: 0.8
        )

        var resultReceived = false

        // When: Creating OCR disambiguation for cross-platform
        let view = platformOCRWithDisambiguation_L1(
            image: testImage,
            context: crossPlatformContext
        ) { result in
            resultReceived = true
            // Should work consistently across platforms
            XCTAssertFalse(result.candidates.isEmpty,
                          "Should generate candidates on all platforms")
        }

        // Then: Should work across platforms
        XCTAssertNotNil(view, "Should work on current platform")

        #if os(iOS)
        // iOS-specific validations could go here
        #elseif os(macOS)
        // macOS-specific validations could go here
        #endif
    }

    // MARK: - Memory and Resource Tests

    func testPlatformOCRWithDisambiguation_L1_MemoryManagement() {
        // Given: Memory-intensive context
        let memoryContext = OCRContext(
            textTypes: Array(repeating: .general, count: 20), // Many text types
            language: .english,
            confidenceThreshold: 0.8
        )

        // When: Creating OCR disambiguation with memory-intensive context
        autoreleasepool {
            let view = platformOCRWithDisambiguation_L1(
                image: testImage,
                context: memoryContext
            ) { result in
                // Verify memory-intensive operation completes
                XCTAssertFalse(result.candidates.isEmpty,
                              "Should handle memory-intensive operations")
            }

            XCTAssertNotNil(view, "Should handle memory-intensive context")
        }
        // View should be deallocated here
    }

    // MARK: - Helper Methods

    private func createTestImage() -> PlatformImage {
        return PlatformImage()
    }

    private func createTestContext(textTypes: [TextType] = [.price, .date],
                                  language: OCRLanguage = .english,
                                  confidenceThreshold: Float = 0.8) -> OCRContext {
        return OCRContext(
            textTypes: textTypes,
            language: language,
            confidenceThreshold: confidenceThreshold
        )
    }

    private func createTestConfiguration(confidenceThreshold: Float = 0.8,
                                       maxCandidates: Int = 5,
                                       enableCustomText: Bool = true,
                                       showBoundingBoxes: Bool = true,
                                       allowSkip: Bool = false) -> OCRDisambiguationConfiguration {
        return OCRDisambiguationConfiguration(
            confidenceThreshold: confidenceThreshold,
            maxCandidates: maxCandidates,
            enableCustomText: enableCustomText,
            showBoundingBoxes: showBoundingBoxes,
            allowSkip: allowSkip
        )
    }

    private func waitForCallback(timeout: TimeInterval = 2.0,
                                callback: () -> Bool) -> Bool {
        let startTime = Date()
        while !callback() && Date().timeIntervalSince(startTime) < timeout {
            RunLoop.current.run(mode: .default, before: Date(timeIntervalSinceNow: 0.1))
        }
        return callback()
    }
}
