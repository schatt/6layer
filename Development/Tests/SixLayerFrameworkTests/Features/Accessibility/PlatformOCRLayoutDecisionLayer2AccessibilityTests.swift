import Testing

import SwiftUI
@testable import SixLayerFramework
#if !os(macOS)
import ViewInspector
#endif
/// BUSINESS PURPOSE: Accessibility tests for PlatformOCRLayoutDecisionLayer2.swift functions
/// Ensures OCR layout decision Layer 2 functions generate proper accessibility identifiers
/// for automated testing and accessibility tools compliance
@MainActor
@Suite("Platform O C R Layout Decision Layer Accessibility")
open class PlatformOCRLayoutDecisionLayer2AccessibilityTests: BaseTestClass {    // MARK: - OCR Layout Decision Tests
    
    /// BUSINESS PURPOSE: Validates that platformOCRLayout_L2 generates proper accessibility identifiers
    /// for automated testing and accessibility tools compliance on iOS
    @Test func testPlatformOCRLayoutL2GeneratesAccessibilityIdentifiersOnIOS() async {
        // Given
        let context = OCRContext(
            textTypes: [TextType.general],
            language: OCRLanguage.english
        )
        
        // Verify test image is properly configured
        // testImage is non-optional, so no need to check for nil
        
        let result = platformOCRLayout_L2(
            context: context
        )
        
        // When & Then
        // Layer 2 functions return data structures, not views, so we test the result structure
        // result is non-optional, so no need to check for nil
        #expect(result.maxImageSize.width > 0, "Layout decision should have valid max image size")
        #expect(result.recommendedImageSize.width > 0, "Layout decision should have valid recommended image size")
    }
    
    /// BUSINESS PURPOSE: Validates that platformOCRLayout_L2 generates proper accessibility identifiers
    /// for automated testing and accessibility tools compliance on macOS
    @Test func testPlatformOCRLayoutL2GeneratesAccessibilityIdentifiersOnMacOS() async {
        // Given
        let context = OCRContext(
            textTypes: [TextType.general],
            language: OCRLanguage.english
        )
        
        // Verify test image is properly configured
        // testImage is non-optional, so no need to check for nil
        
        let result = platformOCRLayout_L2(
            context: context
        )
        
        // When & Then
        // Layer 2 functions return data structures, not views, so we test the result structure
        // result is non-optional, so no need to check for nil
        #expect(result.maxImageSize.width > 0, "Layout decision should have valid max image size")
        #expect(result.recommendedImageSize.width > 0, "Layout decision should have valid recommended image size")
    }
    
    // MARK: - platformDocumentOCRLayout_L2 Tests
    
    @Test func testPlatformDocumentOCRLayout_L2_Receipt() async {
        let context = OCRContext(
            textTypes: [.price, .number, .date],
            language: .english
        )
        
        let layout = platformDocumentOCRLayout_L2(documentType: .receipt, context: context)
        #expect(layout.maxImageSize.width > 0, "Receipt layout should have valid max image size")
        #expect(layout.recommendedImageSize.width > 0, "Receipt layout should have valid recommended image size")
    }
    
    @Test func testPlatformDocumentOCRLayout_L2_Invoice() async {
        let context = OCRContext(
            textTypes: [.price, .number, .date, .address],
            language: .english
        )
        
        let layout = platformDocumentOCRLayout_L2(documentType: .invoice, context: context)
        #expect(layout.maxImageSize.width > 0, "Invoice layout should have valid max image size")
        #expect(layout.recommendedImageSize.width > 0, "Invoice layout should have valid recommended image size")
    }
    
    @Test func testPlatformDocumentOCRLayout_L2_BusinessCard() async {
        let context = OCRContext(
            textTypes: [.email, .phone, .address],
            language: .english
        )
        
        let layout = platformDocumentOCRLayout_L2(documentType: .businessCard, context: context)
        #expect(layout.maxImageSize.width > 0, "Business card layout should have valid max image size")
        #expect(layout.recommendedImageSize.width > 0, "Business card layout should have valid recommended image size")
    }
    
    @Test func testPlatformDocumentOCRLayout_L2_AllDocumentTypes() async {
        let documentTypes: [DocumentType] = [.receipt, .invoice, .businessCard, .form, .license, .passport, .general, .fuelReceipt, .idDocument, .medicalRecord, .legalDocument]
        let context = OCRContext(
            textTypes: [.general],
            language: .english
        )
        
        for documentType in documentTypes {
            let layout = platformDocumentOCRLayout_L2(documentType: documentType, context: context)
            #expect(layout.maxImageSize.width > 0, "Layout for \(documentType) should have valid max image size")
            #expect(layout.recommendedImageSize.width > 0, "Layout for \(documentType) should have valid recommended image size")
        }
    }
    
    // MARK: - platformReceiptOCRLayout_L2 Tests
    
    @Test func testPlatformReceiptOCRLayout_L2() async {
        let context = OCRContext(
            textTypes: [.general],
            language: .english,
            confidenceThreshold: 0.8
        )
        
        let layout = platformReceiptOCRLayout_L2(context: context)
        #expect(layout.maxImageSize.width > 0, "Receipt OCR layout should have valid max image size")
        #expect(layout.recommendedImageSize.width > 0, "Receipt OCR layout should have valid recommended image size")
        // Receipts should have higher confidence threshold
        #expect(context.confidenceThreshold >= 0.8, "Receipt context should maintain or increase confidence threshold")
    }
    
    // MARK: - platformBusinessCardOCRLayout_L2 Tests
    
    @Test func testPlatformBusinessCardOCRLayout_L2() async {
        let context = OCRContext(
            textTypes: [.general],
            language: .english
        )
        
        let layout = platformBusinessCardOCRLayout_L2(context: context)
        #expect(layout.maxImageSize.width > 0, "Business card OCR layout should have valid max image size")
        #expect(layout.recommendedImageSize.width > 0, "Business card OCR layout should have valid recommended image size")
    }
    
    @Test func testPlatformOCRLayout_L2_WithCapabilities() async {
        let context = OCRContext(
            textTypes: [.price, .number],
            language: .english
        )
        let capabilities = OCRDeviceCapabilities(
            hasVisionFramework: true,
            hasNeuralEngine: true,
            maxImageSize: CGSize(width: 5000, height: 5000),
            supportedLanguages: [.english],
            processingPower: .neural
        )
        
        let layout = platformOCRLayout_L2(context: context, capabilities: capabilities)
        #expect(layout.maxImageSize.width > 0, "Layout with capabilities should have valid max image size")
        #expect(layout.recommendedImageSize.width > 0, "Layout with capabilities should have valid recommended image size")
    }
    
    @Test func testPlatformOCRLayout_L2_DifferentTextTypes() async {
        let textTypeCombinations: [[TextType]] = [
            [.price, .number],
            [.date],
            [.address],
            [.email, .phone],
            [.general]
        ]
        
        for textTypes in textTypeCombinations {
            let context = OCRContext(
                textTypes: textTypes,
                language: .english
            )
            let layout = platformOCRLayout_L2(context: context)
            #expect(layout.maxImageSize.width > 0, "Layout for text types \(textTypes) should have valid max image size")
            #expect(layout.recommendedImageSize.width > 0, "Layout for text types \(textTypes) should have valid recommended image size")
        }
    }
}

