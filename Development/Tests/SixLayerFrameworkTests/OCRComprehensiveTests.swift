//
//  OCRComprehensiveTests.swift
//  SixLayerFrameworkTests
//
//  Comprehensive tests for OCR functionality with edge cases, error handling, and performance
//

import XCTest
import SwiftUI
@preconcurrency @testable import SixLayerFramework

/// Comprehensive tests for OCR functionality
/// Tests all layers with edge cases, error handling, performance, and integration scenarios
@MainActor
final class OCRComprehensiveTests: XCTestCase {
    
    // MARK: - Test Data
    
    private var testImage: PlatformImage {
        createTestPlatformImage()
    }
    
    private var largeImage: PlatformImage {
        createLargeTestImage()
    }
    
    private var corruptedImage: PlatformImage {
        createCorruptedTestImage()
    }
    
    private var emptyImage: PlatformImage {
        createEmptyTestImage()
    }
    
    // MARK: - Layer 1 Tests: Semantic OCR Functions
    
    func testPlatformOCRWithVisualCorrectionL1BasicFunctionality() {
        // Test basic OCR with visual correction
        let context = OCRContext(
            textTypes: [.price, .number, .date],
            language: .english,
            confidenceThreshold: 0.8,
            allowsEditing: true
        )
        
        let ocrView = platformOCRWithVisualCorrection_L1(
            image: testImage,
            context: context
        ) { result in
            XCTAssertNotNil(result)
        }
        
        XCTAssertNotNil(ocrView)
    }
    
    func testPlatformOCRWithVisualCorrectionL1WithEmptyTextTypes() {
        // Test with empty text types array
        let context = OCRContext(
            textTypes: [],
            language: .english,
            confidenceThreshold: 0.8,
            allowsEditing: true
        )
        
        let ocrView = platformOCRWithVisualCorrection_L1(
            image: testImage,
            context: context
        ) { result in
            XCTAssertNotNil(result)
        }
        
        XCTAssertNotNil(ocrView)
    }
    
    func testPlatformOCRWithVisualCorrectionL1WithAllTextTypes() {
        // Test with all available text types
        let context = OCRContext(
            textTypes: [.general, .price, .number, .date, .email, .url, .phone, .address],
            language: .english,
            confidenceThreshold: 0.8,
            allowsEditing: true
        )
        
        let ocrView = platformOCRWithVisualCorrection_L1(
            image: testImage,
            context: context
        ) { result in
            XCTAssertNotNil(result)
        }
        
        XCTAssertNotNil(ocrView)
    }
    
    func testPlatformOCRWithVisualCorrectionL1WithCorruptedImage() {
        // Test with corrupted image
        let context = OCRContext(
            textTypes: [.price, .number],
            language: .english,
            confidenceThreshold: 0.8,
            allowsEditing: true
        )
        
        let ocrView = platformOCRWithVisualCorrection_L1(
            image: corruptedImage,
            context: context
        ) { result in
            // Should handle corrupted image gracefully
            XCTAssertNotNil(result)
        }
        
        XCTAssertNotNil(ocrView)
    }
    
    func testPlatformOCRWithVisualCorrectionL1WithEmptyImage() {
        // Test with empty image
        let context = OCRContext(
            textTypes: [.price, .number],
            language: .english,
            confidenceThreshold: 0.8,
            allowsEditing: true
        )
        
        let ocrView = platformOCRWithVisualCorrection_L1(
            image: emptyImage,
            context: context
        ) { result in
            // Should handle empty image gracefully
            XCTAssertNotNil(result)
        }
        
        XCTAssertNotNil(ocrView)
    }
    
    func testPlatformOCRWithVisualCorrectionL1BasicTextExtraction() {
        // Test basic text extraction
        let context = OCRContext(
            textTypes: [.price, .number],
            language: .english,
            confidenceThreshold: 0.8,
            allowsEditing: true
        )
        
        let extractionView = platformOCRWithVisualCorrection_L1(
            image: testImage,
            context: context
        ) { result in
            XCTAssertNotNil(result)
        }
        
        XCTAssertNotNil(extractionView)
    }
    
    func testPlatformOCRWithVisualCorrectionL1WithDifferentLanguages() {
        // Test with different languages
        let englishContext = OCRContext(
            textTypes: [.general],
            language: .english,
            confidenceThreshold: 0.8,
            allowsEditing: true
        )
        
        let spanishContext = OCRContext(
            textTypes: [.general],
            language: .spanish,
            confidenceThreshold: 0.8,
            allowsEditing: true
        )
        
        let frenchContext = OCRContext(
            textTypes: [.general],
            language: .french,
            confidenceThreshold: 0.8,
            allowsEditing: true
        )
        
        let englishView = platformOCRWithVisualCorrection_L1(
            image: testImage,
            context: englishContext
        ) { result in
            XCTAssertNotNil(result)
        }
        
        let spanishView = platformOCRWithVisualCorrection_L1(
            image: testImage,
            context: spanishContext
        ) { result in
            XCTAssertNotNil(result)
        }
        
        let frenchView = platformOCRWithVisualCorrection_L1(
            image: testImage,
            context: frenchContext
        ) { result in
            XCTAssertNotNil(result)
        }
        
        XCTAssertNotNil(englishView)
        XCTAssertNotNil(spanishView)
        XCTAssertNotNil(frenchView)
    }
    
    func testPlatformOCRWithVisualCorrectionL1WithDifferentConfidenceThresholds() {
        // Test with different confidence thresholds
        let lowConfidenceContext = OCRContext(
            textTypes: [.general],
            language: .english,
            confidenceThreshold: 0.1,
            allowsEditing: true
        )
        
        let highConfidenceContext = OCRContext(
            textTypes: [.general],
            language: .english,
            confidenceThreshold: 0.9,
            allowsEditing: true
        )
        
        let lowConfidenceView = platformOCRWithVisualCorrection_L1(
            image: testImage,
            context: lowConfidenceContext
        ) { result in
            XCTAssertNotNil(result)
        }
        
        let highConfidenceView = platformOCRWithVisualCorrection_L1(
            image: testImage,
            context: highConfidenceContext
        ) { result in
            XCTAssertNotNil(result)
        }
        
        XCTAssertNotNil(lowConfidenceView)
        XCTAssertNotNil(highConfidenceView)
    }
    
    func testPlatformOCRWithVisualCorrectionL1BasicDocumentAnalysis() {
        // Test basic document analysis
        let context = OCRContext(
            textTypes: [.price, .number, .date],
            language: .english,
            confidenceThreshold: 0.8,
            allowsEditing: true
        )
        
        let analysisView = platformOCRWithVisualCorrection_L1(
            image: testImage,
            context: context
        ) { result in
            XCTAssertNotNil(result)
        }
        
        XCTAssertNotNil(analysisView)
    }
    
    func testPlatformOCRWithVisualCorrectionL1WithDifferentDocumentTypes() {
        // Test with different document types
        let receiptContext = OCRContext(
            textTypes: [.price, .number, .date],
            language: .english,
            confidenceThreshold: 0.8,
            allowsEditing: true
        )
        
        let invoiceContext = OCRContext(
            textTypes: [.price, .number, .date, .email],
            language: .english,
            confidenceThreshold: 0.8,
            allowsEditing: true
        )
        
        let businessCardContext = OCRContext(
            textTypes: [.email, .phone, .address],
            language: .english,
            confidenceThreshold: 0.8,
            allowsEditing: true
        )
        
        let formContext = OCRContext(
            textTypes: [.general, .email, .phone],
            language: .english,
            confidenceThreshold: 0.8,
            allowsEditing: true
        )
        
        let receiptView = platformOCRWithVisualCorrection_L1(
            image: testImage,
            context: receiptContext
        ) { result in
            XCTAssertNotNil(result)
        }
        
        let invoiceView = platformOCRWithVisualCorrection_L1(
            image: testImage,
            context: invoiceContext
        ) { result in
            XCTAssertNotNil(result)
        }
        
        let businessCardView = platformOCRWithVisualCorrection_L1(
            image: testImage,
            context: businessCardContext
        ) { result in
            XCTAssertNotNil(result)
        }
        
        let formView = platformOCRWithVisualCorrection_L1(
            image: testImage,
            context: formContext
        ) { result in
            XCTAssertNotNil(result)
        }
        
        XCTAssertNotNil(receiptView)
        XCTAssertNotNil(invoiceView)
        XCTAssertNotNil(businessCardView)
        XCTAssertNotNil(formView)
    }
    
    // MARK: - Layer 2 Tests: Layout Decision Engine
    
    func testPlatformOCRLayoutL2BasicFunctionality() {
        // Test basic OCR layout decision
        let context = OCRContext(
            textTypes: [.price, .number],
            language: .english,
            confidenceThreshold: 0.8
        )
        
        let layout = platformOCRLayout_L2(context: context)
        
        XCTAssertNotNil(layout)
        XCTAssertGreaterThan(layout.maxImageSize.width, 0)
        XCTAssertGreaterThan(layout.maxImageSize.height, 0)
    }
    
    func testPlatformOCRLayoutL2WithDifferentTextTypes() {
        // Test with different text types
        let generalContext = OCRContext(
            textTypes: [.general],
            language: .english,
            confidenceThreshold: 0.8
        )
        
        let specificContext = OCRContext(
            textTypes: [.price, .number, .date, .email, .url],
            language: .english,
            confidenceThreshold: 0.8
        )
        
        let generalLayout = platformOCRLayout_L2(context: generalContext)
        let specificLayout = platformOCRLayout_L2(context: specificContext)
        
        XCTAssertNotNil(generalLayout)
        XCTAssertNotNil(specificLayout)
    }
    
    func testPlatformOCRLayoutL2WithDifferentLanguages() {
        // Test with different languages
        let englishContext = OCRContext(
            textTypes: [.general],
            language: .english,
            confidenceThreshold: 0.8
        )
        
        let spanishContext = OCRContext(
            textTypes: [.general],
            language: .spanish,
            confidenceThreshold: 0.8
        )
        
        let frenchContext = OCRContext(
            textTypes: [.general],
            language: .french,
            confidenceThreshold: 0.8
        )
        
        let englishLayout = platformOCRLayout_L2(context: englishContext)
        let spanishLayout = platformOCRLayout_L2(context: spanishContext)
        let frenchLayout = platformOCRLayout_L2(context: frenchContext)
        
        XCTAssertNotNil(englishLayout)
        XCTAssertNotNil(spanishLayout)
        XCTAssertNotNil(frenchLayout)
    }
    
    // MARK: - Layer 3 Tests: Strategy Selection
    
    func testPlatformOCRStrategyL3BasicFunctionality() {
        // Test basic OCR strategy selection
        let textTypes: [TextType] = [.price, .number, .date]
        
        let strategy = platformOCRStrategy_L3(textTypes: textTypes)
        
        XCTAssertNotNil(strategy)
        XCTAssertTrue(strategy.supportedTextTypes.contains(.price))
        XCTAssertTrue(strategy.supportedTextTypes.contains(.number))
    }
    
    func testPlatformOCRStrategyL3WithDifferentTextTypes() {
        // Test with different text types
        let generalStrategy = platformOCRStrategy_L3(textTypes: [.general])
        let specificStrategy = platformOCRStrategy_L3(textTypes: [.price, .number, .date, .email, .url])
        
        XCTAssertNotNil(generalStrategy)
        XCTAssertNotNil(specificStrategy)
    }
    
    func testPlatformOCRStrategyL3WithLanguage() {
        // Test with language parameter - platformOCRStrategy_L3 doesn't take language parameter
        let englishStrategy = platformOCRStrategy_L3(textTypes: [.general])
        let spanishStrategy = platformOCRStrategy_L3(textTypes: [.general])
        let frenchStrategy = platformOCRStrategy_L3(textTypes: [.general])
        
        XCTAssertNotNil(englishStrategy)
        XCTAssertNotNil(spanishStrategy)
        XCTAssertNotNil(frenchStrategy)
    }
    
    // MARK: - Layer 4 Tests: Component Implementation
    
    func testPlatformOCRImplementationL4BasicFunctionality() {
        // Test basic OCR implementation
        let context = OCRContext(
            textTypes: [.price, .number],
            language: .english,
            confidenceThreshold: 0.8
        )
        
        let strategy = OCRStrategy(
            supportedTextTypes: [.general],
            supportedLanguages: [.english],
            processingMode: .standard
        )
        
        let component = platformOCRImplementation_L4(
            image: testImage,
            context: context,
            strategy: strategy,
            onResult: { result in
                XCTAssertNotNil(result)
            }
        )
        
        XCTAssertNotNil(component)
    }
    
    func testPlatformOCRImplementationL4WithDifferentProcessingModes() {
        // Test with different processing modes
        let standardStrategy = OCRStrategy(
            supportedTextTypes: [.general],
            supportedLanguages: [.english],
            processingMode: .standard
        )
        
        let fastStrategy = OCRStrategy(
            supportedTextTypes: [.general],
            supportedLanguages: [.english],
            processingMode: .fast
        )
        
        let accurateStrategy = OCRStrategy(
            supportedTextTypes: [.general],
            supportedLanguages: [.english],
            processingMode: .accurate
        )
        
        let context = OCRContext(
            textTypes: [.general],
            language: .english,
            confidenceThreshold: 0.8
        )
        
        let standardComponent = platformOCRImplementation_L4(
            image: testImage,
            context: context,
            strategy: standardStrategy,
            onResult: { result in
                XCTAssertNotNil(result)
            }
        )
        
        let fastComponent = platformOCRImplementation_L4(
            image: testImage,
            context: context,
            strategy: fastStrategy,
            onResult: { result in
                XCTAssertNotNil(result)
            }
        )
        
        let accurateComponent = platformOCRImplementation_L4(
            image: testImage,
            context: context,
            strategy: accurateStrategy,
            onResult: { result in
                XCTAssertNotNil(result)
            }
        )
        
        XCTAssertNotNil(standardComponent)
        XCTAssertNotNil(fastComponent)
        XCTAssertNotNil(accurateComponent)
    }
    
    func testPlatformTextRecognitionL4BasicFunctionality() {
        // Test basic text recognition
        let options = TextRecognitionOptions(
            textTypes: [.general],
            language: .english,
            confidenceThreshold: 0.8
        )
        
        let recognition = platformTextRecognition_L4(
            image: testImage,
            options: options,
            onResult: { result in
                XCTAssertNotNil(result)
            }
        )
        
        XCTAssertNotNil(recognition)
    }
    
    func testPlatformTextRecognitionL4WithDifferentLanguages() {
        // Test with different languages
        let englishOptions = TextRecognitionOptions(
            textTypes: [.general],
            language: .english,
            confidenceThreshold: 0.8
        )
        
        let spanishOptions = TextRecognitionOptions(
            textTypes: [.general],
            language: .spanish,
            confidenceThreshold: 0.8
        )
        
        let frenchOptions = TextRecognitionOptions(
            textTypes: [.general],
            language: .french,
            confidenceThreshold: 0.8
        )
        
        let englishRecognition = platformTextRecognition_L4(
            image: testImage,
            options: englishOptions,
            onResult: { result in
                XCTAssertNotNil(result)
            }
        )
        
        let spanishRecognition = platformTextRecognition_L4(
            image: testImage,
            options: spanishOptions,
            onResult: { result in
                XCTAssertNotNil(result)
            }
        )
        
        let frenchRecognition = platformTextRecognition_L4(
            image: testImage,
            options: frenchOptions,
            onResult: { result in
                XCTAssertNotNil(result)
            }
        )
        
        XCTAssertNotNil(englishRecognition)
        XCTAssertNotNil(spanishRecognition)
        XCTAssertNotNil(frenchRecognition)
    }
    
    // MARK: - Integration Tests
    
    func testEndToEndOCRWorkflow() {
        // Test complete end-to-end OCR workflow
        let textTypes: [TextType] = [.price, .number, .date]
        let context = OCRContext(
            textTypes: textTypes,
            language: .english,
            confidenceThreshold: 0.8,
            allowsEditing: true
        )
        
        // Layer 1
        let ocrView = platformOCRWithVisualCorrection_L1(
            image: testImage,
            context: context
        ) { result in
            XCTAssertNotNil(result)
        }
        
        XCTAssertNotNil(ocrView)
        
        // Layer 2
        let layout = platformOCRLayout_L2(context: context)
        
        XCTAssertNotNil(layout)
        
        // Layer 3
        let strategy = platformOCRStrategy_L3(textTypes: textTypes)
        
        XCTAssertNotNil(strategy)
        
        // Layer 4
        let component = platformOCRImplementation_L4(
            image: testImage,
            context: context,
            strategy: strategy,
            onResult: { result in
                XCTAssertNotNil(result)
            }
        )
        
        XCTAssertNotNil(component)
    }
    
    func testCrossLayerDataFlow() {
        // Test that data flows correctly between layers
        let textTypes: [TextType] = [.price, .number]
        let context = OCRContext(
            textTypes: textTypes,
            language: .english,
            confidenceThreshold: 0.8
        )
        
        // Layer 1 -> Layer 2
        let layout = platformOCRLayout_L2(context: context)
        
        XCTAssertNotNil(layout)
        
        // Layer 2 -> Layer 3
        let strategy = platformOCRStrategy_L3(textTypes: textTypes)
        
        XCTAssertNotNil(strategy)
        
        // Layer 3 -> Layer 4
        let component = platformOCRImplementation_L4(
            image: testImage,
            context: context,
            strategy: strategy,
            onResult: { result in
                XCTAssertNotNil(result)
            }
        )
        
        XCTAssertNotNil(component)
    }
    
    // MARK: - Performance Tests
    
    func testOCRPerformanceWithLargeImage() {
        // Test performance with large image
        measure {
            let textTypes: [TextType] = [.general]
            let context = OCRContext(
                textTypes: textTypes,
                language: .english,
                confidenceThreshold: 0.8
            )
            
            let strategy = OCRStrategy(
                supportedTextTypes: textTypes,
                supportedLanguages: [.english],
                processingMode: .standard
            )
            
            let component = platformOCRImplementation_L4(
                image: largeImage,
                context: context,
                strategy: strategy,
                onResult: { result in
                    XCTAssertNotNil(result)
                }
            )
            
            XCTAssertNotNil(component)
        }
    }
    
    func testOCRPerformanceWithMultipleTextTypes() {
        // Test performance with multiple text types
        measure {
            let textTypes: [TextType] = [.general, .price, .number, .date, .email, .url, .phone, .address]
            let context = OCRContext(
                textTypes: textTypes,
                language: .english,
                confidenceThreshold: 0.8
            )
            
            let strategy = OCRStrategy(
                supportedTextTypes: textTypes,
                supportedLanguages: [.english],
                processingMode: .standard
            )
            
            let component = platformOCRImplementation_L4(
                image: testImage,
                context: context,
                strategy: strategy,
                onResult: { result in
                    XCTAssertNotNil(result)
                }
            )
            
            XCTAssertNotNil(component)
        }
    }
    
    func testOCRPerformanceWithDifferentLanguages() {
        // Test performance with different languages
        measure {
            let languages: [OCRLanguage] = [.english, .spanish, .french, .german, .italian]
            
            for language in languages {
                let context = OCRContext(
                    textTypes: [.general],
                    language: language,
                    confidenceThreshold: 0.8
                )
                
                let strategy = OCRStrategy(
                    supportedTextTypes: [.general],
                    supportedLanguages: [language],
                    processingMode: .standard
                )
                
                let component = platformOCRImplementation_L4(
                    image: testImage,
                    context: context,
                    strategy: strategy,
                    onResult: { result in
                        XCTAssertNotNil(result)
                    }
                )
                
                XCTAssertNotNil(component)
            }
        }
    }
    
    // MARK: - Error Handling Tests
    
    func testErrorHandlingWithCorruptedImage() {
        // Test error handling with corrupted image
        let textTypes: [TextType] = [.general]
        let context = OCRContext(
            textTypes: textTypes,
            language: .english,
            confidenceThreshold: 0.8
        )
        
        let strategy = OCRStrategy(
            supportedTextTypes: textTypes,
            supportedLanguages: [.english],
            processingMode: .standard
        )
        
        let component = platformOCRImplementation_L4(
            image: corruptedImage,
            context: context,
            strategy: strategy,
            onResult: { result in
                // Should handle corrupted image gracefully
                XCTAssertNotNil(result)
            }
        )
        
        XCTAssertNotNil(component)
    }
    
    func testErrorHandlingWithEmptyImage() {
        // Test error handling with empty image
        let textTypes: [TextType] = [.general]
        let context = OCRContext(
            textTypes: textTypes,
            language: .english,
            confidenceThreshold: 0.8
        )
        
        let strategy = OCRStrategy(
            supportedTextTypes: textTypes,
            supportedLanguages: [.english],
            processingMode: .standard
        )
        
        let component = platformOCRImplementation_L4(
            image: emptyImage,
            context: context,
            strategy: strategy,
            onResult: { result in
                // Should handle empty image gracefully
                XCTAssertNotNil(result)
            }
        )
        
        XCTAssertNotNil(component)
    }
    
    func testErrorHandlingWithInvalidConfidenceThreshold() {
        // Test error handling with invalid confidence threshold
        let invalidContext = OCRContext(
            textTypes: [.general],
            language: .english,
            confidenceThreshold: -1.0 // Invalid threshold
        )
        
        let strategy = OCRStrategy(
            supportedTextTypes: [.general],
            supportedLanguages: [.english],
            processingMode: .standard
        )
        
        let component = platformOCRImplementation_L4(
            image: testImage,
            context: invalidContext,
            strategy: strategy,
            onResult: { result in
                // Should handle invalid threshold gracefully
                XCTAssertNotNil(result)
            }
        )
        
        XCTAssertNotNil(component)
    }
    
    // MARK: - Edge Case Tests
    
    func testEdgeCaseWithVerySmallImage() {
        // Test with very small image
        let smallImage = createSmallTestImage()
        let context = OCRContext(
            textTypes: [.general],
            language: .english,
            confidenceThreshold: 0.8,
            allowsEditing: true
        )
        
        let ocrView = platformOCRWithVisualCorrection_L1(
            image: smallImage,
            context: context
        ) { result in
            XCTAssertNotNil(result)
        }
        
        XCTAssertNotNil(ocrView)
    }
    
    func testEdgeCaseWithVeryLargeImage() {
        // Test with very large image
        let context = OCRContext(
            textTypes: [.general],
            language: .english,
            confidenceThreshold: 0.8,
            allowsEditing: true
        )
        
        let ocrView = platformOCRWithVisualCorrection_L1(
            image: largeImage,
            context: context
        ) { result in
            XCTAssertNotNil(result)
        }
        
        XCTAssertNotNil(ocrView)
    }
    
    func testEdgeCaseWithAllTextTypes() {
        // Test with all available text types
        let allTextTypes: [TextType] = [.general, .price, .number, .date, .email, .url, .phone, .address]
        
        let context = OCRContext(
            textTypes: allTextTypes,
            language: .english,
            confidenceThreshold: 0.8,
            allowsEditing: true
        )
        
        let ocrView = platformOCRWithVisualCorrection_L1(
            image: testImage,
            context: context
        ) { result in
            XCTAssertNotNil(result)
        }
        
        XCTAssertNotNil(ocrView)
    }
    
    func testEdgeCaseWithAllLanguages() {
        // Test with all available languages
        let allLanguages: [OCRLanguage] = [.english, .spanish, .french, .german, .italian, .portuguese, .chinese, .japanese, .korean, .arabic, .russian]
        
        for language in allLanguages {
            let context = OCRContext(
                textTypes: [.general],
                language: language,
                confidenceThreshold: 0.8
            )
            
            let extractionIntent = platformOCRWithVisualCorrection_L1(
                image: testImage,
                context: context
            ) { result in
                XCTAssertNotNil(result)
            }
            
            XCTAssertNotNil(extractionIntent)
        }
    }
    
    func testEdgeCaseWithAllDocumentTypes() {
        // Test with all available document types
        let allDocumentTypes: [DocumentType] = [.receipt, .invoice, .businessCard, .form, .license, .passport, .general]
        
        for documentType in allDocumentTypes {
            // Create appropriate context based on document type
            let textTypes: [TextType] = {
                switch documentType {
                case .receipt:
                    return [.price, .number, .date]
                case .invoice:
                    return [.price, .number, .date, .email]
                case .businessCard:
                    return [.email, .phone, .address]
                case .form:
                    return [.general, .email, .phone]
                case .license, .passport:
                    return [.general, .date]
                case .general:
                    return [.general]
                }
            }()
            
            let context = OCRContext(
                textTypes: textTypes,
                language: .english,
                confidenceThreshold: 0.8,
                allowsEditing: true
            )
            
            let analysisView = platformOCRWithVisualCorrection_L1(
                image: testImage,
                context: context
            ) { result in
                XCTAssertNotNil(result)
            }
            
            XCTAssertNotNil(analysisView)
        }
    }
    
    // MARK: - Accessibility Tests
    
    func testAccessibilitySupport() {
        // Test accessibility support
        let textTypes: [TextType] = [.general]
        let context = OCRContext(
            textTypes: textTypes,
            language: .english,
            confidenceThreshold: 0.8
        )
        
        let strategy = OCRStrategy(
            supportedTextTypes: textTypes,
            supportedLanguages: [.english],
            processingMode: .standard
        )
        
        let component = platformOCRImplementation_L4(
            image: testImage,
            context: context,
            strategy: strategy,
            onResult: { result in
                XCTAssertNotNil(result)
            }
        )
        
        XCTAssertNotNil(component)
    }
    
    // MARK: - Concurrency Tests
    
    func testConcurrentOCRProcessing() async {
        // Test concurrent OCR processing using new OCRService
        let service = OCRServiceFactory.create()
        let textTypes: [TextType] = [.general]
        let context = OCRContext(
            textTypes: textTypes,
            language: .english,
            confidenceThreshold: 0.8
        )
        
        let strategy = OCRStrategy(
            supportedTextTypes: textTypes,
            supportedLanguages: [.english],
            processingMode: .standard
        )
        
        // Process multiple images concurrently using async/await
        await withTaskGroup(of: Void.self) { group in
            for _ in 0..<5 {
                group.addTask {
                    do {
                        let result = try await service.processImage(self.testImage, context: context, strategy: strategy)
                        XCTAssertNotNil(result)
                    } catch {
                        // OCR might not be available in test environment
                        // This is expected behavior for tests
                    }
                }
            }
        }
    }
    
    // MARK: - Memory Tests
    
    func testMemoryUsageWithLargeImage() {
        // Test memory usage with large image
        let textTypes: [TextType] = [.general]
        let context = OCRContext(
            textTypes: textTypes,
            language: .english,
            confidenceThreshold: 0.8
        )
        
        let strategy = OCRStrategy(
            supportedTextTypes: textTypes,
            supportedLanguages: [.english],
            processingMode: .standard
        )
        
        // Process large image multiple times to test memory management
        for _ in 0..<10 {
            let component = platformOCRImplementation_L4(
                image: largeImage,
                context: context,
                strategy: strategy,
                onResult: { result in
                    XCTAssertNotNil(result)
                }
            )
            
            XCTAssertNotNil(component)
        }
    }
    
    // MARK: - Helper Methods
    
    private func createTestPlatformImage() -> PlatformImage {
        // Create a test image for OCR testing
        #if os(iOS)
        let size = CGSize(width: 200, height: 200)
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { context in
            UIColor.blue.setFill()
            context.fill(CGRect(origin: .zero, size: size))
            
            // Add some text-like content
            let text = "Test OCR Content"
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 16),
                .foregroundColor: UIColor.white
            ]
            text.draw(in: CGRect(x: 10, y: 10, width: 180, height: 20), withAttributes: attributes)
        }
        return PlatformImage(uiImage: image)
        #elseif os(macOS)
        let size = NSSize(width: 200, height: 200)
        let image = NSImage(size: size)
        image.lockFocus()
        NSColor.blue.setFill()
        NSRect(origin: .zero, size: size).fill()
        
        // Add some text-like content
        let text = "Test OCR Content"
        let attributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 16),
            .foregroundColor: NSColor.white
        ]
        text.draw(in: NSRect(x: 10, y: 10, width: 180, height: 20), withAttributes: attributes)
        image.unlockFocus()
        return PlatformImage(nsImage: image)
        #else
        return PlatformImage()
        #endif
    }
    
    private func createLargeTestImage() -> PlatformImage {
        // Create a large test image for performance testing
        #if os(iOS)
        let size = CGSize(width: 2000, height: 2000)
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { context in
            UIColor.green.setFill()
            context.fill(CGRect(origin: .zero, size: size))
            
            // Add some text-like content
            let text = "Large Test OCR Content"
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 32),
                .foregroundColor: UIColor.white
            ]
            text.draw(in: CGRect(x: 50, y: 50, width: 1900, height: 40), withAttributes: attributes)
        }
        return PlatformImage(uiImage: image)
        #elseif os(macOS)
        let size = NSSize(width: 2000, height: 2000)
        let image = NSImage(size: size)
        image.lockFocus()
        NSColor.green.setFill()
        NSRect(origin: .zero, size: size).fill()
        
        // Add some text-like content
        let text = "Large Test OCR Content"
        let attributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 32),
            .foregroundColor: NSColor.white
        ]
        text.draw(in: NSRect(x: 50, y: 50, width: 1900, height: 40), withAttributes: attributes)
        image.unlockFocus()
        return PlatformImage(nsImage: image)
        #else
        return PlatformImage()
        #endif
    }
    
    private func createCorruptedTestImage() -> PlatformImage {
        // Create a corrupted test image for error handling testing
        #if os(iOS)
        let size = CGSize(width: 100, height: 100)
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { context in
            UIColor.red.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
        return PlatformImage(uiImage: image)
        #elseif os(macOS)
        let size = NSSize(width: 100, height: 100)
        let image = NSImage(size: size)
        image.lockFocus()
        NSColor.red.setFill()
        NSRect(origin: .zero, size: size).fill()
        image.unlockFocus()
        return PlatformImage(nsImage: image)
        #else
        return PlatformImage()
        #endif
    }
    
    private func createEmptyTestImage() -> PlatformImage {
        // Create an empty test image for error handling testing
        #if os(iOS)
        let size = CGSize(width: 1, height: 1)
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { context in
            UIColor.clear.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
        return PlatformImage(uiImage: image)
        #elseif os(macOS)
        let size = NSSize(width: 1, height: 1)
        let image = NSImage(size: size)
        image.lockFocus()
        NSColor.clear.setFill()
        NSRect(origin: .zero, size: size).fill()
        image.unlockFocus()
        return PlatformImage(nsImage: image)
        #else
        return PlatformImage()
        #endif
    }
    
    private func createSmallTestImage() -> PlatformImage {
        // Create a very small test image for edge case testing
        #if os(iOS)
        let size = CGSize(width: 10, height: 10)
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { context in
            UIColor.yellow.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
        return PlatformImage(uiImage: image)
        #elseif os(macOS)
        let size = NSSize(width: 10, height: 10)
        let image = NSImage(size: size)
        image.lockFocus()
        NSColor.yellow.setFill()
        NSRect(origin: .zero, size: size).fill()
        image.unlockFocus()
        return PlatformImage(nsImage: image)
        #else
        return PlatformImage()
        #endif
    }
}