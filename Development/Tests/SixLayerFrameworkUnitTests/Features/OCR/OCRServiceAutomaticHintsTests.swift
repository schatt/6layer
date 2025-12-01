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
    
    // MARK: - Test: Entity Name Specification
    
    @Test func testEntityNameSpecification() {
        // GIVEN: A context with explicit entityName
        // Projects specify which data model's hints file to use directly
        let context = OCRContext(
            textTypes: [.price, .number],
            language: .english,
            documentType: .fuelReceipt, // For categorization/display purposes
            extractionMode: .automatic,
            entityName: "FuelPurchase" // Directly specifies which .hints file to load
        )
        
        // WHEN: Processing structured extraction
        // The framework should load FuelPurchase.hints based on entityName
        
        // THEN: Context should use the specified entity name
        #expect(context.entityName == "FuelPurchase", 
                "Context should use explicit entityName when provided")
    }
    
    @Test func testEntityNameIsOptional() {
        // GIVEN: A context without entityName (developer doesn't need/want hints)
        let context = OCRContext(
            textTypes: [.price, .number],
            language: .english,
            documentType: .fuelReceipt,
            extractionMode: .automatic
            // entityName is nil - no hints file will be loaded automatically
        )
        
        // WHEN: Processing structured extraction
        // The framework will gracefully handle nil entityName:
        // - Won't load hints file
        // - Won't apply calculation groups
        // - Will still use built-in patterns (if available)
        // - Will still use custom extractionHints (if provided)
        
        // THEN: Should have nil entityName and framework should handle it gracefully
        #expect(context.entityName == nil, 
                "Context should have nil entityName when not explicitly provided")
        // Framework should work normally without hints - developers can opt out
    }
    
    @Test func testExtractionWorksWithoutEntityName() {
        // GIVEN: A context without entityName but with custom extractionHints
        let context = OCRContext(
            textTypes: [.price, .number],
            language: .english,
            documentType: .fuelReceipt,
            extractionMode: .custom, // Using custom mode
            extractionHints: [
                "total": #"Total:\s*([\d.,]+)"#,
                "gallons": #"Gallons:\s*([\d.,]+)"#
            ]
            // entityName is nil - developer doesn't want hints file
        )
        
        // WHEN: Processing structured extraction
        // The framework should still work using custom extractionHints
        
        // THEN: Should work normally without entityName
        #expect(context.entityName == nil, 
                "Context can have nil entityName when using custom extractionHints")
        #expect(!context.extractionHints.isEmpty, 
                "Custom extractionHints should still work without entityName")
    }
    
    // MARK: - Test: Automatic OCR Hints Usage
    
    @Test func testAutomaticOCRHintsUsageInExtraction() async throws {
        // GIVEN: A context with entityName and OCR text containing hints
        let context = OCRContext(
            textTypes: [.price, .number],
            language: .english,
            documentType: .fuelReceipt,
            extractionMode: .automatic,
            entityName: "FuelPurchase" // Specifies which hints file to load
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
        // GIVEN: A context with entityName and partial OCR data
        let context = OCRContext(
            textTypes: [.price, .number],
            language: .english,
            documentType: .fuelReceipt,
            extractionMode: .automatic,
            entityName: "FuelPurchase" // Specifies which hints file to load
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

