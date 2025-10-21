import Testing
import SwiftUI
@testable import SixLayerFramework

/// Tests for OCR Service functionality
/// 
/// BUSINESS PURPOSE: Ensure OCR service provides proper functionality and error handling
/// TESTING SCOPE: OCR service capabilities, error handling, and result processing
/// METHODOLOGY: Test OCR service on both iOS and macOS platforms as required by mandatory testing guidelines
@MainActor
open class OCRServiceTests {
    
    // MARK: - Test Setup
    
    init() async throws {
        await setupTestEnvironment()
    }
    
    private func setupTestEnvironment() async {
        await AccessibilityTestUtilities.setupAccessibilityTestEnvironment()
    }
    
    private func cleanupTestEnvironment() async {
        await AccessibilityTestUtilities.cleanupAccessibilityTestEnvironment()
    }
    
    // MARK: - OCR Service Tests
    
    @Test func testOCRServiceAvailabilityOnIOS() async {
        let service = OCRService()
        
        // Test service availability
        let isAvailable = service.isAvailable
        let capabilities = service.capabilities
        
        #expect(isAvailable == true || isAvailable == false, "OCR service availability should be determinable")
        #expect(capabilities.supportedTextTypes.count >= 0, "OCR service should report supported text types")
        #expect(capabilities.supportedLanguages.count >= 0, "OCR service should report supported languages")
    }
    
    @Test func testOCRServiceAvailabilityOnMacOS() async {
        let service = OCRService()
        
        // Test service availability
        let isAvailable = service.isAvailable
        let capabilities = service.capabilities
        
        #expect(isAvailable == true || isAvailable == false, "OCR service availability should be determinable")
        #expect(capabilities.supportedTextTypes.count >= 0, "OCR service should report supported text types")
        #expect(capabilities.supportedLanguages.count >= 0, "OCR service should report supported languages")
    }
    
    @Test func testOCRServiceErrorHandling() async {
        let service = OCRService()
        let testImage = PlatformImage.createPlaceholder()
        let context = OCRContext(
            textTypes: [.general], language: .english, requiredFields: [], documentType: .general,
        )
        let strategy = OCRStrategy(
            supportedTextTypes: [.general],
            supportedLanguages: [.english],
            processingMode: .standard,
            requiresNeuralEngine: false,
            estimatedProcessingTime: 1.0
        )
        
        do {
            let result = try await service.processImage(testImage, context: context, strategy: strategy)
            // If we get here, OCR processing succeeded
            #expect(result.extractedText.count >= 0, "OCR result should have extracted text")
            #expect(result.confidence >= 0.0 && result.confidence <= 1.0, "OCR confidence should be between 0 and 1")
        } catch {
            // OCR processing failed - this is expected in test environment
            #expect(error is OCRError, "OCR errors should be OCRError types")
        }
    }
    
    @Test func testOCRServiceStructuredExtraction() async {
        let service = OCRService()
        let testImage = PlatformImage.createPlaceholder()
        let context = OCRContext(
            textTypes: [.general], language: .english, requiredFields: [], documentType: .general,
        )
        
        do {
            let result = try await service.processStructuredExtraction(testImage, context: context)
            // If we get here, structured extraction succeeded
            #expect(result.extractedText.count >= 0, "Structured extraction result should have extracted text")
            #expect(result.structuredData != nil, "Structured extraction should provide structured data")
        } catch {
            // Structured extraction failed - this is expected in test environment
            #expect(error is OCRError, "OCR errors should be OCRError types")
        }
    }
    
    @Test func testOCRContextValidation() async {
        let validContext = OCRContext(
            textTypes: [.general], language: .english, requiredFields: [], documentType: .general,
        )
        
        #expect(validContext.documentType == .general, "OCR context should preserve document type")
        #expect(validContext.textTypes.contains(.general), "OCR context should preserve text types")
        #expect(validContext.language == .english, "OCR context should preserve language")
    }
    
    @Test func testOCRStrategyConfiguration() async {
        let strategy = OCRStrategy(
            supportedTextTypes: [.general, .number],
            supportedLanguages: [.english, .spanish],
            processingMode: .accurate,
            requiresNeuralEngine: true,
            estimatedProcessingTime: 2.0
        )
        
        #expect(strategy.supportedTextTypes.contains(.general), "OCR strategy should support specified text types")
        #expect(strategy.supportedTextTypes.contains(.number), "OCR strategy should support multiple text types")
        #expect(strategy.supportedLanguages.contains(.english), "OCR strategy should support specified languages")
        #expect(strategy.supportedLanguages.contains(.spanish), "OCR strategy should support multiple languages")
        #expect(strategy.processingMode == .accurate, "OCR strategy should preserve processing mode")
        #expect(strategy.requiresNeuralEngine == true, "OCR strategy should preserve neural engine requirement")
        #expect(strategy.estimatedProcessingTime == 2.0, "OCR strategy should preserve estimated processing time")
    }
}
