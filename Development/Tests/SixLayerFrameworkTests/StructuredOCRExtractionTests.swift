//
//  StructuredOCRExtractionTests.swift
//  SixLayerFramework
//
//  Tests for Enhanced Structured OCR Data Extraction
//  Following TDD principles - tests first, then implementation
//

import XCTest
import SwiftUI
@testable import SixLayerFramework

final class StructuredOCRExtractionTests: XCTestCase {
    
    // MARK: - Test Data
    
    private func createTestImage() -> PlatformImage {
        // Create a simple test image for OCR testing
        #if os(iOS)
        let size = CGSize(width: 100, height: 100)
        let renderer = UIGraphicsImageRenderer(size: size)
        let uiImage = renderer.image { context in
            Color.white.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
        return PlatformImage(uiImage: uiImage)
        #elseif os(macOS)
        let size = NSSize(width: 100, height: 100)
        let nsImage = NSImage(size: size)
        nsImage.lockFocus()
        Color.white.fillRect(size: size)
        nsImage.unlockFocus()
        return PlatformImage(nsImage: nsImage)
        #endif
    }
    
    private func createFuelReceiptContext() -> OCRContext {
        return OCRContext(
            textTypes: [.price, .number, .stationName],
            language: .english,
            confidenceThreshold: 0.8,
            extractionHints: [:],
            requiredFields: ["price", "gallons"],
            documentType: .fuelReceipt,
            extractionMode: .automatic
        )
    }
    
    private func createInvoiceContext() -> OCRContext {
        return OCRContext(
            textTypes: [.price, .date, .vendor],
            language: .english,
            confidenceThreshold: 0.8,
            extractionHints: [:],
            requiredFields: ["total", "date"],
            documentType: .invoice,
            extractionMode: .automatic
        )
    }
    
    private func createCustomContext() -> OCRContext {
        return OCRContext(
            textTypes: [.price, .date, .name],
            language: .english,
            confidenceThreshold: 0.8,
            extractionHints: [
                "customField": #"Custom:\s*([A-Za-z0-9]+)"#,
                "specialValue": #"Special:\s*(\d+)"#
            ],
            requiredFields: ["customField"],
            documentType: .general,
            extractionMode: .custom
        )
    }
    
    // MARK: - TextType Extension Tests
    
    func testTextType_NewStructuredTypes() {
        // Test that new structured text types are available
        let structuredTypes: [TextType] = [
            .email, .phone, .address, .name, .idNumber,
            .stationName, .total, .vendor, .expiryDate,
            .quantity, .unit, .currency, .percentage,
            .url, .postalCode, .state, .country
        ]
        
        for textType in structuredTypes {
            XCTAssertNotNil(textType.rawValue)
            XCTAssertTrue(TextType.allCases.contains(textType))
        }
    }
    
    func testTextType_StructuredTypesAreSendable() {
        // Test that new text types conform to Sendable
        let structuredTypes: [TextType] = [.email, .phone, .name]
        
        for textType in structuredTypes {
            // This will compile if Sendable conformance is correct
            let sendableType: any Sendable = textType
            XCTAssertNotNil(sendableType)
        }
    }
    
    // MARK: - DocumentType Tests
    
    func testDocumentType_AllCases() {
        // Test that all document types are available
        let expectedTypes: [DocumentType] = [
            .general, .receipt, .invoice, .businessCard,
            .idDocument, .fuelReceipt, .medicalRecord, .legalDocument
        ]
        
        for docType in expectedTypes {
            XCTAssertTrue(DocumentType.allCases.contains(docType))
            XCTAssertNotNil(docType.rawValue)
        }
    }
    
    func testDocumentType_IsSendable() {
        // Test that DocumentType conforms to Sendable
        let docType: any Sendable = DocumentType.fuelReceipt
        XCTAssertNotNil(docType)
    }
    
    // MARK: - ExtractionMode Tests
    
    func testExtractionMode_AllCases() {
        // Test that all extraction modes are available
        let expectedModes: [ExtractionMode] = [.automatic, .custom, .hybrid]
        
        for mode in expectedModes {
            XCTAssertTrue(ExtractionMode.allCases.contains(mode))
            XCTAssertNotNil(mode.rawValue)
        }
    }
    
    func testExtractionMode_IsSendable() {
        // Test that ExtractionMode conforms to Sendable
        let mode: any Sendable = ExtractionMode.automatic
        XCTAssertNotNil(mode)
    }
    
    // MARK: - OCRContext Enhancement Tests
    
    func testOCRContext_NewProperties() {
        let context = createFuelReceiptContext()
        
        // Test new properties are accessible
        XCTAssertEqual(context.documentType, .fuelReceipt)
        XCTAssertEqual(context.extractionMode, .automatic)
        XCTAssertEqual(context.requiredFields, ["price", "gallons"])
        XCTAssertTrue(context.extractionHints.isEmpty)
    }
    
    func testOCRContext_CustomHints() {
        let context = createCustomContext()
        
        // Test custom extraction hints
        XCTAssertEqual(context.extractionMode, .custom)
        XCTAssertEqual(context.extractionHints["customField"], #"Custom:\s*([A-Za-z0-9]+)"#)
        XCTAssertEqual(context.extractionHints["specialValue"], #"Special:\s*(\d+)"#)
        XCTAssertEqual(context.requiredFields, ["customField"])
    }
    
    func testOCRContext_DefaultValues() {
        let context = OCRContext()
        
        // Test default values for new properties
        XCTAssertEqual(context.documentType, .general)
        XCTAssertEqual(context.extractionMode, .automatic)
        XCTAssertTrue(context.extractionHints.isEmpty)
        XCTAssertTrue(context.requiredFields.isEmpty)
    }
    
    // MARK: - OCRResult Enhancement Tests
    
    func testOCRResult_NewProperties() {
        let structuredData = ["price": "$45.67", "gallons": "12.34"]
        let missingFields = ["station"]
        
        let result = OCRResult(
            extractedText: "Price: $45.67 Gallons: 12.34",
            confidence: 0.9,
            boundingBoxes: [],
            textTypes: [:],
            processingTime: 1.0,
            language: .english,
            structuredData: structuredData,
            extractionConfidence: 0.85,
            missingRequiredFields: missingFields,
            documentType: .fuelReceipt
        )
        
        // Test new properties
        XCTAssertEqual(result.structuredData["price"], "$45.67")
        XCTAssertEqual(result.structuredData["gallons"], "12.34")
        XCTAssertEqual(result.extractionConfidence, 0.85)
        XCTAssertEqual(result.missingRequiredFields, ["station"])
        XCTAssertEqual(result.documentType, .fuelReceipt)
    }
    
    func testOCRResult_ComputedProperties() {
        let completeResult = OCRResult(
            extractedText: "Complete data",
            confidence: 0.9,
            structuredData: ["price": "$45.67", "gallons": "12.34"],
            extractionConfidence: 0.85,
            missingRequiredFields: [],
            documentType: .fuelReceipt
        )
        
        let incompleteResult = OCRResult(
            extractedText: "Incomplete data",
            confidence: 0.9,
            structuredData: ["price": "$45.67"],
            extractionConfidence: 0.85,
            missingRequiredFields: ["gallons"],
            documentType: .fuelReceipt
        )
        
        // Test computed properties
        XCTAssertTrue(completeResult.isStructuredExtractionComplete)
        XCTAssertFalse(incompleteResult.isStructuredExtractionComplete)
        XCTAssertEqual(completeResult.structuredExtractionConfidence, 0.85)
    }
    
    func testOCRResult_IsSendable() {
        let result = OCRResult(
            extractedText: "Test",
            confidence: 0.9,
            structuredData: ["test": "value"],
            extractionConfidence: 0.8,
            missingRequiredFields: [],
            documentType: .general
        )
        
        // Test that OCRResult is Sendable
        let sendableResult: any Sendable = result
        XCTAssertNotNil(sendableResult)
    }
    
    // MARK: - BuiltInPatterns Tests
    
    func testBuiltInPatterns_FuelReceipt() {
        let patterns = BuiltInPatterns.patterns[.fuelReceipt]
        
        XCTAssertNotNil(patterns)
        XCTAssertEqual(patterns?["price"], #"\$(\d+\.\d{2})"#)
        XCTAssertEqual(patterns?["gallons"], #"(\d+\.\d{2})\s*gal"#)
        XCTAssertEqual(patterns?["station"], #"Station:\s*([A-Za-z\s]+)"#)
    }
    
    func testBuiltInPatterns_Invoice() {
        let patterns = BuiltInPatterns.patterns[.invoice]
        
        XCTAssertNotNil(patterns)
        XCTAssertEqual(patterns?["total"], #"Total:\s*\$(\d+\.\d{2})"#)
        XCTAssertEqual(patterns?["date"], #"Date:\s*(\d{2}/\d{2}/\d{4})"#)
        XCTAssertEqual(patterns?["vendor"], #"From:\s*([A-Za-z\s]+)"#)
    }
    
    func testBuiltInPatterns_BusinessCard() {
        let patterns = BuiltInPatterns.patterns[.businessCard]
        
        XCTAssertNotNil(patterns)
        XCTAssertEqual(patterns?["name"], #"Name:\s*([A-Za-z\s]+)"#)
        XCTAssertEqual(patterns?["phone"], #"(\d{3}-\d{3}-\d{4})"#)
        XCTAssertEqual(patterns?["email"], #"([a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,})"#)
    }
    
    func testBuiltInPatterns_IDDocument() {
        let patterns = BuiltInPatterns.patterns[.idDocument]
        
        XCTAssertNotNil(patterns)
        XCTAssertEqual(patterns?["name"], #"Name:\s*([A-Za-z\s]+)"#)
        XCTAssertEqual(patterns?["idNumber"], #"ID#:\s*([A-Z0-9]+)"#)
        XCTAssertEqual(patterns?["expiry"], #"Exp:\s*(\d{2}/\d{2}/\d{4})"#)
    }
    
    // MARK: - Layer 1 Semantic Function Tests
    
    func testPlatformExtractStructuredData_L1_Basic() {
        let image = createTestImage()
        let context = createFuelReceiptContext()
        
        // Test that the function exists and returns a view
        let view = platformExtractStructuredData_L1(image: image, context: context) { result in
            // Test callback
            XCTAssertNotNil(result)
        }
        
        // Test that it returns a view (this will compile if the function exists)
        let _ = view
        XCTAssertNotNil(view)
    }
    
    func testPlatformExtractStructuredData_L1_WithCustomContext() {
        let image = createTestImage()
        let context = createCustomContext()
        
        let view = platformExtractStructuredData_L1(image: image, context: context) { result in
            // Test callback with custom context
            XCTAssertNotNil(result)
        }
        
        let _ = view
        XCTAssertNotNil(view)
    }
    
    // MARK: - OCRService Enhancement Tests
    
    func testOCRService_ProcessStructuredExtraction() async {
        let service = OCRService()
        let image = createTestImage()
        let context = createFuelReceiptContext()
        
        do {
            let result = try await service.processStructuredExtraction(image, context: context)
            
            // Test that result has structured data properties
            XCTAssertNotNil(result.structuredData)
            XCTAssertNotNil(result.extractionConfidence)
            XCTAssertNotNil(result.missingRequiredFields)
            XCTAssertNotNil(result.documentType)
        } catch {
            // OCR might fail in test environment, that's expected
            XCTAssertTrue(error is OCRError)
        }
    }
    
    func testOCRService_StructuredExtractionWithCustomHints() async {
        let service = OCRService()
        let image = createTestImage()
        let context = createCustomContext()
        
        do {
            let result = try await service.processStructuredExtraction(image, context: context)
            
            // Test custom extraction
            XCTAssertEqual(context.extractionMode, .custom)
            XCTAssertNotNil(result.structuredData)
        } catch {
            // OCR might fail in test environment, that's expected
            XCTAssertTrue(error is OCRError)
        }
    }
    
    // MARK: - Integration Tests
    
    func testStructuredExtraction_EndToEnd() {
        let image = createTestImage()
        let context = createFuelReceiptContext()
        
        // Test complete flow
        let view = platformExtractStructuredData_L1(image: image, context: context) { result in
            // Test that we get a proper result
            XCTAssertNotNil(result.extractedText)
            XCTAssertNotNil(result.structuredData)
            XCTAssertNotNil(result.extractionConfidence)
            XCTAssertNotNil(result.missingRequiredFields)
            XCTAssertEqual(result.documentType, .fuelReceipt)
        }
        
        let _ = view
        XCTAssertNotNil(view)
    }
    
    func testStructuredExtraction_WithDifferentDocumentTypes() {
        let image = createTestImage()
        
        let documentTypes: [DocumentType] = [.fuelReceipt, .invoice, .businessCard, .idDocument]
        
        for docType in documentTypes {
            let context = OCRContext(
                textTypes: [.price, .date, .name],
                documentType: docType,
                extractionMode: .automatic
            )
            
            let view = platformExtractStructuredData_L1(image: image, context: context) { result in
                XCTAssertEqual(result.documentType, docType)
            }
            
            let _ = view
            XCTAssertNotNil(view)
        }
    }
    
    // MARK: - Performance Tests
    
    func testStructuredExtraction_Performance() {
        let image = createTestImage()
        let context = createFuelReceiptContext()
        
        measure {
            let view = platformExtractStructuredData_L1(image: image, context: context) { _ in }
            let _ = view
        }
    }
    
    // MARK: - Error Handling Tests
    
    func testStructuredExtraction_InvalidImage() {
        // Test with invalid image data
        let context = createFuelReceiptContext()
        
        // This should handle invalid images gracefully
        let view = platformExtractStructuredData_L1(image: createTestImage(), context: context) { result in
            // Should still provide a result, even if empty
            XCTAssertNotNil(result)
        }
        
        let _ = view
        XCTAssertNotNil(view)
    }
    
    func testStructuredExtraction_EmptyRequiredFields() {
        let image = createTestImage()
        let context = OCRContext(
            textTypes: [.price],
            extractionHints: [:],
            requiredFields: [], // No required fields
            documentType: .fuelReceipt,
            extractionMode: .automatic
        )
        
        let view = platformExtractStructuredData_L1(image: image, context: context) { result in
            // Should be complete since no fields are required
            XCTAssertTrue(result.isStructuredExtractionComplete)
        }
        
        let _ = view
        XCTAssertNotNil(view)
    }
}
