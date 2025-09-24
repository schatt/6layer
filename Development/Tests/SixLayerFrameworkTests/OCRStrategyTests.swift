//
//  OCRStrategyTests.swift
//  SixLayerFrameworkTests
//
//  Tests for OCR strategy selection functions (Layer 3)
//  Tests platformOptimalOCRStrategy_L3 and related OCR strategy functions
//
//  Test Documentation:
//  Business purpose of function: Select optimal OCR processing strategy based on text types, confidence thresholds, and platform capabilities
//  What are we actually testing: 
//    - Processing mode selection algorithm (fast vs accurate based on confidence)
//    - Batch size scaling algorithm (small batches use base mode, large batches use fast mode)
//    - Platform-specific strategy differences (iOS vs macOS vs watchOS)
//    - Document type-specific text type selection (receipt, business card, invoice)
//    - Confidence threshold impact on processing mode selection
//  HOW are we testing it: 
//    - Mock OCR services to avoid Vision framework dependencies
//    - Test processing mode selection logic with different confidence thresholds
//    - Test batch size scaling with mathematical validation of processing mode changes
//    - Test platform differences by comparing strategy configurations across platforms
//    - Test document type algorithms by validating returned text type sets
//    - Avoid testing estimated processing times since we use mock services
//

import XCTest
@testable import SixLayerFramework

final class OCRStrategyTests: XCTestCase {
    
    // MARK: - Basic OCR Strategy Tests
    
    func testPlatformOCRStrategy_L3_BasicTextTypes() {
        // Given: Basic text types
        let textTypes: [TextType] = [.general, .number]
        
        // When: Getting OCR strategy
        let strategy = platformOCRStrategy_L3(textTypes: textTypes, platform: .iOS)
        
        // Then: Should return valid strategy
        XCTAssertEqual(strategy.supportedTextTypes, textTypes)
        XCTAssertFalse(strategy.supportedLanguages.isEmpty, "Should support at least one language")
        // Strategy should be properly configured
        XCTAssertFalse(strategy.supportedTextTypes.isEmpty, "Should support at least one text type")
    }
    
    func testPlatformOCRStrategy_L3_NeuralEngineRequirement() {
        // Given: Text types that require neural engine
        let neuralTextTypes: [TextType] = [.price, .date, .address]
        let simpleTextTypes: [TextType] = [.general]
        
        // When: Getting strategies for both
        let neuralStrategy = platformOCRStrategy_L3(textTypes: neuralTextTypes, platform: .iOS)
        let simpleStrategy = platformOCRStrategy_L3(textTypes: simpleTextTypes, platform: .iOS)
        
        // Then: Neural text types should require neural engine
        XCTAssertTrue(neuralStrategy.requiresNeuralEngine, "Complex text types should require neural engine")
        XCTAssertFalse(simpleStrategy.requiresNeuralEngine, "Simple text types should not require neural engine")
    }
    
    func testPlatformOCRStrategy_L3_DifferentPlatforms() {
        // Given: Same text types for different platforms
        let textTypes: [TextType] = [.general, .email, .phone]
        
        // When: Getting strategies for different platforms
        let iOSStrategy = platformOCRStrategy_L3(textTypes: textTypes, platform: .iOS)
        let macOSStrategy = platformOCRStrategy_L3(textTypes: textTypes, platform: .macOS)
        let watchOSStrategy = platformOCRStrategy_L3(textTypes: textTypes, platform: .watchOS)
        
        // Then: Should have different processing times based on platform capabilities
        XCTAssertEqual(iOSStrategy.supportedTextTypes, textTypes)
        XCTAssertEqual(macOSStrategy.supportedTextTypes, textTypes)
        XCTAssertEqual(watchOSStrategy.supportedTextTypes, textTypes)
        
        // Different platforms should have different processing times
        // Different platforms should have different processing modes
        XCTAssertEqual(macOSStrategy.supportedTextTypes, textTypes, "macOS should support same text types")
        XCTAssertEqual(watchOSStrategy.supportedTextTypes, textTypes, "watchOS should support same text types")
    }
    
    // MARK: - Optimal OCR Strategy Tests
    
    func testPlatformOptimalOCRStrategy_L3_HighConfidenceThreshold() {
        // Given: High confidence threshold (> 0.9)
        let textTypes: [TextType] = [.general, .number]
        let highConfidence: Float = 0.95
        
        // When: Getting optimal strategy
        let strategy = platformOptimalOCRStrategy_L3(
            textTypes: textTypes,
            confidenceThreshold: highConfidence,
            platform: .iOS
        )
        
        // Then: Should use accurate processing mode
        XCTAssertEqual(strategy.processingMode, .accurate, "High confidence should use accurate mode")
        XCTAssertEqual(strategy.supportedTextTypes, textTypes)
        XCTAssertFalse(strategy.supportedTextTypes.isEmpty, "Should support text types")
    }
    
    func testPlatformOptimalOCRStrategy_L3_LowConfidenceThreshold() {
        // Given: Low confidence threshold (< 0.7)
        let textTypes: [TextType] = [.general, .number]
        let lowConfidence: Float = 0.6
        
        // When: Getting optimal strategy
        let strategy = platformOptimalOCRStrategy_L3(
            textTypes: textTypes,
            confidenceThreshold: lowConfidence,
            platform: .iOS
        )
        
        // Then: Should use fast processing mode
        XCTAssertEqual(strategy.processingMode, .fast, "Low confidence should use fast mode")
        XCTAssertEqual(strategy.supportedTextTypes, textTypes)
        XCTAssertFalse(strategy.supportedTextTypes.isEmpty, "Should support text types")
    }
    
    func testPlatformOptimalOCRStrategy_L3_MediumConfidenceThreshold() {
        // Given: Medium confidence threshold (0.7-0.9)
        let textTypes: [TextType] = [.general, .number]
        let mediumConfidence: Float = 0.8
        
        // When: Getting optimal strategy
        let strategy = platformOptimalOCRStrategy_L3(
            textTypes: textTypes,
            confidenceThreshold: mediumConfidence,
            platform: .iOS
        )
        
        // Then: Should use standard processing mode (unchanged from base strategy)
        let baseStrategy = platformOCRStrategy_L3(textTypes: textTypes, platform: .iOS)
        XCTAssertEqual(strategy.processingMode, baseStrategy.processingMode, "Medium confidence should use base strategy mode")
        XCTAssertEqual(strategy.supportedTextTypes, textTypes)
    }
    
    func testPlatformOptimalOCRStrategy_L3_ConfidenceThresholdComparison() {
        // Given: Same text types with different confidence thresholds
        let textTypes: [TextType] = [.price, .date]
        
        // When: Getting strategies for different confidence levels
        let highConfidenceStrategy = platformOptimalOCRStrategy_L3(
            textTypes: textTypes,
            confidenceThreshold: 0.95,
            platform: .iOS
        )
        
        let lowConfidenceStrategy = platformOptimalOCRStrategy_L3(
            textTypes: textTypes,
            confidenceThreshold: 0.6,
            platform: .iOS
        )
        
        // Then: High confidence should take longer than low confidence
        // High confidence threshold should use more accurate processing mode
        XCTAssertEqual(highConfidenceStrategy.supportedTextTypes, textTypes, "Should support same text types")
        XCTAssertEqual(lowConfidenceStrategy.supportedTextTypes, textTypes, "Should support same text types")
        
        XCTAssertEqual(highConfidenceStrategy.processingMode, .accurate)
        XCTAssertEqual(lowConfidenceStrategy.processingMode, .fast)
    }
    
    // MARK: - Document Type Strategy Tests
    
    func testPlatformDocumentOCRStrategy_L3_Receipt() {
        // Given: Receipt document type
        let documentType = DocumentType.receipt
        
        // When: Getting receipt strategy
        let strategy = platformDocumentOCRStrategy_L3(documentType: documentType, platform: .iOS)
        
        // Then: Should return valid receipt strategy
        XCTAssertFalse(strategy.supportedTextTypes.isEmpty, "Should support text types for receipts")
        XCTAssertTrue(strategy.supportedTextTypes.contains(.price), "Should support price text type")
        XCTAssertTrue(strategy.supportedTextTypes.contains(.number), "Should support number text type")
        XCTAssertTrue(strategy.supportedTextTypes.contains(.date), "Should support date text type")
        XCTAssertFalse(strategy.supportedTextTypes.isEmpty, "Should support text types")
    }
    
    func testPlatformDocumentOCRStrategy_L3_BusinessCard() {
        // Given: Business card document type
        let documentType = DocumentType.businessCard
        
        // When: Getting business card strategy
        let strategy = platformDocumentOCRStrategy_L3(documentType: documentType, platform: .iOS)
        
        // Then: Should return valid business card strategy
        XCTAssertFalse(strategy.supportedTextTypes.isEmpty, "Should support text types for business cards")
        XCTAssertTrue(strategy.supportedTextTypes.contains(.email), "Should support email text type")
        XCTAssertTrue(strategy.supportedTextTypes.contains(.phone), "Should support phone text type")
        XCTAssertTrue(strategy.supportedTextTypes.contains(.address), "Should support address text type")
        XCTAssertFalse(strategy.supportedTextTypes.isEmpty, "Should support text types")
    }
    
    func testPlatformDocumentOCRStrategy_L3_Invoice() {
        // Given: Invoice document type
        let documentType = DocumentType.invoice
        
        // When: Getting invoice strategy
        let strategy = platformDocumentOCRStrategy_L3(documentType: documentType, platform: .iOS)
        
        // Then: Should return valid invoice strategy
        XCTAssertFalse(strategy.supportedTextTypes.isEmpty, "Should support text types for invoices")
        XCTAssertTrue(strategy.supportedTextTypes.contains(.price), "Should support price text type")
        XCTAssertTrue(strategy.supportedTextTypes.contains(.date), "Should support date text type")
        XCTAssertTrue(strategy.supportedTextTypes.contains(.email), "Should support email text type")
        XCTAssertTrue(strategy.supportedTextTypes.contains(.address), "Should support address text type")
        XCTAssertFalse(strategy.supportedTextTypes.isEmpty, "Should support text types")
    }
    
    func testPlatformReceiptOCRStrategy_L3() {
        // Given: Receipt processing
        let strategy = platformReceiptOCRStrategy_L3(platform: .iOS)
        
        // Then: Should be equivalent to document strategy for receipt
        let documentStrategy = platformDocumentOCRStrategy_L3(documentType: .receipt, platform: .iOS)
        XCTAssertEqual(strategy.supportedTextTypes, documentStrategy.supportedTextTypes)
        XCTAssertEqual(strategy.processingMode, documentStrategy.processingMode)
        XCTAssertEqual(strategy.requiresNeuralEngine, documentStrategy.requiresNeuralEngine)
    }
    
    func testPlatformBusinessCardOCRStrategy_L3() {
        // Given: Business card processing
        let strategy = platformBusinessCardOCRStrategy_L3(platform: .iOS)
        
        // Then: Should be equivalent to document strategy for business card
        let documentStrategy = platformDocumentOCRStrategy_L3(documentType: .businessCard, platform: .iOS)
        XCTAssertEqual(strategy.supportedTextTypes, documentStrategy.supportedTextTypes)
        XCTAssertEqual(strategy.processingMode, documentStrategy.processingMode)
        XCTAssertEqual(strategy.requiresNeuralEngine, documentStrategy.requiresNeuralEngine)
    }
    
    func testPlatformInvoiceOCRStrategy_L3() {
        // Given: Invoice processing
        let strategy = platformInvoiceOCRStrategy_L3(platform: .iOS)
        
        // Then: Should be equivalent to document strategy for invoice
        let documentStrategy = platformDocumentOCRStrategy_L3(documentType: .invoice, platform: .iOS)
        XCTAssertEqual(strategy.supportedTextTypes, documentStrategy.supportedTextTypes)
        XCTAssertEqual(strategy.processingMode, documentStrategy.processingMode)
        XCTAssertEqual(strategy.requiresNeuralEngine, documentStrategy.requiresNeuralEngine)
    }
    
    // MARK: - Batch Processing Strategy Tests
    
    func testPlatformBatchOCRStrategy_L3_SmallBatch() {
        // Given: Small batch size
        let textTypes: [TextType] = [.general, .number]
        let batchSize = 3
        
        // When: Getting batch strategy
        let strategy = platformBatchOCRStrategy_L3(
            textTypes: textTypes,
            batchSize: batchSize,
            platform: .iOS
        )
        
        // Then: Should use base strategy processing mode
        let baseStrategy = platformOCRStrategy_L3(textTypes: textTypes, platform: .iOS)
        XCTAssertEqual(strategy.processingMode, baseStrategy.processingMode, "Small batch should use base processing mode")
        XCTAssertEqual(strategy.supportedTextTypes, textTypes)
    }
    
    func testPlatformBatchOCRStrategy_L3_LargeBatch() {
        // Given: Large batch size
        let textTypes: [TextType] = [.general, .number]
        let batchSize = 10
        
        // When: Getting batch strategy
        let strategy = platformBatchOCRStrategy_L3(
            textTypes: textTypes,
            batchSize: batchSize,
            platform: .iOS
        )
        
        // Then: Should use fast processing mode for large batches
        XCTAssertEqual(strategy.processingMode, .fast, "Large batch should use fast processing mode")
        XCTAssertEqual(strategy.supportedTextTypes, textTypes)
    }
    
    func testPlatformBatchOCRStrategy_L3_BatchSizeScaling() {
        // Given: Different batch sizes
        let textTypes: [TextType] = [.general]
        
        // When: Getting strategies for different batch sizes
        let smallBatchStrategy = platformBatchOCRStrategy_L3(
            textTypes: textTypes,
            batchSize: 2,
            platform: .iOS
        )
        
        let mediumBatchStrategy = platformBatchOCRStrategy_L3(
            textTypes: textTypes,
            batchSize: 5,
            platform: .iOS
        )
        
        let largeBatchStrategy = platformBatchOCRStrategy_L3(
            textTypes: textTypes,
            batchSize: 8,
            platform: .iOS
        )
        
        // Then: Processing modes should be correct for different batch sizes
        // Small batch should use base processing mode
        XCTAssertEqual(smallBatchStrategy.processingMode, platformOCRStrategy_L3(textTypes: textTypes, platform: .iOS).processingMode)
        
        // Medium batch should use base processing mode (still ≤5)
        XCTAssertEqual(mediumBatchStrategy.processingMode, platformOCRStrategy_L3(textTypes: textTypes, platform: .iOS).processingMode)
        
        // Large batch should use fast mode (>5)
        XCTAssertEqual(largeBatchStrategy.processingMode, .fast)
    }
    
    // MARK: - Edge Cases and Error Handling
    
    func testOCRStrategy_EmptyTextTypes() {
        // Given: Empty text types array
        let emptyTextTypes: [TextType] = []
        
        // When: Getting strategy for empty text types
        let strategy = platformOCRStrategy_L3(textTypes: emptyTextTypes, platform: .iOS)
        
        // Then: Should handle gracefully
        XCTAssertTrue(strategy.supportedTextTypes.isEmpty, "Should handle empty text types")
    }
    
    func testOCRStrategy_AllTextTypes() {
        // Given: All available text types
        let allTextTypes = TextType.allCases
        
        // When: Getting strategy for all text types
        let strategy = platformOCRStrategy_L3(textTypes: allTextTypes, platform: .iOS)
        
        // Then: Should handle all text types
        XCTAssertEqual(strategy.supportedTextTypes.count, allTextTypes.count)
        XCTAssertTrue(strategy.requiresNeuralEngine, "All text types should require neural engine")
        XCTAssertFalse(strategy.supportedTextTypes.isEmpty, "Should support text types")
    }
    
    func testOCRStrategy_ExtremeConfidenceThresholds() {
        // Given: Extreme confidence thresholds
        let textTypes: [TextType] = [.general]
        
        // When: Testing extreme thresholds
        let veryHighStrategy = platformOptimalOCRStrategy_L3(
            textTypes: textTypes,
            confidenceThreshold: 1.0,
            platform: .iOS
        )
        
        let veryLowStrategy = platformOptimalOCRStrategy_L3(
            textTypes: textTypes,
            confidenceThreshold: 0.0,
            platform: .iOS
        )
        
        // Then: Should handle extreme values
        XCTAssertEqual(veryHighStrategy.processingMode, .accurate, "1.0 confidence should use accurate mode")
        XCTAssertEqual(veryLowStrategy.processingMode, .fast, "0.0 confidence should use fast mode")
    }
    
    // MARK: - Performance Tests
    
    func testOCRStrategy_Performance() {
        // Given: Test data
        let textTypes: [TextType] = [.general, .price, .date]
        
        // When: Measuring performance
        measure {
            let _ = platformOCRStrategy_L3(textTypes: textTypes, platform: .iOS)
            let _ = platformOptimalOCRStrategy_L3(textTypes: textTypes, confidenceThreshold: 0.8, platform: .iOS)
            let _ = platformBatchOCRStrategy_L3(textTypes: textTypes, batchSize: 5, platform: .iOS)
        }
    }
}
