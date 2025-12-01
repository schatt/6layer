//
//  OCRServiceAutomaticHintsTests.swift
//  SixLayerFrameworkTests
//
//  BUSINESS PURPOSE:
//  Tests automatic hints file loading and calculation group application
//  for structured OCR extraction (Issue #29)
//
//  TESTING SCOPE:
//  - Automatic hints file loading based on documentType
//  - Automatic ocrHints usage in extraction
//  - Automatic calculationGroups application
//
//  METHODOLOGY:
//  TDD approach: Write failing tests first, then implement features

@testable import SixLayerFramework
import Testing

/// Tests for automatic hints file loading in OCR structured extraction
@Suite("OCR Service Automatic Hints")
final class OCRServiceAutomaticHintsTests: BaseTestClass {
    
    // MARK: - Test: DocumentType to Hints File Name Mapping
    
    @Test func testDocumentTypeToEntityNameMapping() {
        // GIVEN: Different document types
        // WHEN: Mapping to entity names (for hints file loading)
        // THEN: Should map correctly to entity names, not DTO names
        // .fuelReceipt -> "FuelPurchase" (entity name)
        // .invoice -> "Expense" (entity name)
        
        let fuelReceiptEntityName = OCRService.entityName(for: .fuelReceipt)
        #expect(fuelReceiptEntityName == "FuelPurchase", 
                "fuelReceipt should map to FuelPurchase entity, got: \(String(describing: fuelReceiptEntityName))")
        
        let invoiceEntityName = OCRService.entityName(for: .invoice)
        #expect(invoiceEntityName == "Expense", 
                "invoice should map to Expense entity, got: \(String(describing: invoiceEntityName))")
        
        let generalEntityName = OCRService.entityName(for: .general)
        #expect(generalEntityName == nil, 
                "general should map to nil (no specific entity), got: \(String(describing: generalEntityName))")
    }
    
    // MARK: - Test: Automatic Hints File Loading
    
    @Test func testAutomaticHintsFileLoadingForFuelReceipt() {
        // GIVEN: A context with documentType but no extractionHints
        let context = OCRContext(
            textTypes: [.price, .number, .date, .stationName, .quantity, .unit],
            language: .english,
            confidenceThreshold: 0.8,
            allowsEditing: true,
            extractionHints: [:], // Empty - should load from hints file
            requiredFields: ["totalCost", "gallons"],
            documentType: .fuelReceipt, // Should automatically load FuelPurchaseDTO.hints
            extractionMode: .automatic
        )
        
        // WHEN: Getting patterns for extraction
        let service = OCRService()
        // Access the private method via a test helper or make it internal for testing
        // For now, we'll test via processStructuredExtraction which should use hints
        
        // THEN: Hints should be loaded and ocrHints converted to patterns
        // This test will fail until we implement automatic hints loading
        // We'll verify by checking that patterns include ocrHints-based patterns
        #expect(Bool(false), "Automatic hints loading not yet implemented - test needs OCRService to load hints automatically")
    }
    
    // MARK: - Test: Automatic OCR Hints Usage
    
    @Test func testAutomaticOCRHintsUsageInExtraction() async throws {
        // GIVEN: A context with documentType and OCR text containing hints
        let context = OCRContext(
            textTypes: [.price, .number],
            language: .english,
            documentType: .fuelReceipt,
            extractionMode: .automatic
        )
        
        // Create a mock OCR result with text that should match ocrHints
        let mockOCRResult = OCRResult(
            extractedText: "Total: 90.22\nGallons: 12.5\nPrice per gallon: 7.22",
            confidence: 0.9,
            boundingBoxes: [],
            textTypes: [:],
            processingTime: 0.1,
            language: .english
        )
        
        // WHEN: Extracting structured data
        let service = OCRService()
        // We need to test the extraction logic - this will require making extractStructuredData testable
        // or creating a test helper
        
        // THEN: Structured data should contain specific field names from ocrHints, not generic ones
        // - "Total" should match ocrHints for "totalCost" -> structuredData["totalCost"] = "90.22"
        // - "Gallons" should match ocrHints for "gallons" -> structuredData["gallons"] = "12.5"
        // - "Price per gallon" should match ocrHints for "pricePerGallon" -> structuredData["pricePerGallon"] = "7.22"
        
        // This test will fail until we implement ocrHints usage
        #expect(Bool(false), "Automatic ocrHints usage not yet implemented - need to convert ocrHints to regex patterns")
    }
    
    // MARK: - Test: Automatic Calculation Groups Application
    
    @Test func testAutomaticCalculationGroupsApplication() async throws {
        // GIVEN: A context with documentType and partial OCR data
        let context = OCRContext(
            textTypes: [.price, .number],
            language: .english,
            documentType: .fuelReceipt,
            extractionMode: .automatic
        )
        
        // Create a mock OCR result with totalCost and gallons, but missing pricePerGallon
        let mockOCRResult = OCRResult(
            extractedText: "Total: 90.22\nGallons: 12.5",
            confidence: 0.9,
            boundingBoxes: [],
            textTypes: [:],
            processingTime: 0.1,
            language: .english
        )
        
        // WHEN: Extracting structured data
        let service = OCRService()
        // The framework should:
        // 1. Extract totalCost = 90.22
        // 2. Extract gallons = 12.5
        // 3. Apply calculation group: pricePerGallon = totalCost / gallons
        // 4. Calculate pricePerGallon = 90.22 / 12.5 = 7.22
        
        // THEN: Structured data should include calculated pricePerGallon
        // structuredData["pricePerGallon"] should be approximately "7.22"
        
        // This test will fail until we implement calculation groups
        #expect(Bool(false), "Automatic calculation groups not yet implemented - need to evaluate formulas from calculationGroups")
    }
    
    // MARK: - Test: OCR Hints to Regex Pattern Conversion
    
    @Test func testOCRHintsToRegexPatternConversion() {
        // GIVEN: OCR hints array
        let ocrHints = ["total", "amount", "sum", "grand total"]
        
        // WHEN: Converting to regex pattern
        // The pattern should match any of the hints followed by optional colon/equals and a number
        // Pattern: (?i)(total|amount|sum|grand total)\s*[:=]?\s*([\d.,]+)
        
        // THEN: Pattern should match "Total: 90.22", "amount 90.22", "sum=90.22", etc.
        // This test will fail until we implement the conversion
        #expect(Bool(false), "OCR hints to regex conversion not yet implemented")
    }
}

