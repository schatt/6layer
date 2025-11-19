//
//  FieldHintsOCRExtensionTests.swift
//  SixLayerFrameworkTests
//
//  TDD Tests for OCR hints and calculation groups in .hints files
//

import Testing
import Foundation
@testable import SixLayerFramework

@Suite("Field Hints OCR Extensions")
struct FieldHintsOCRExtensionTests {
    
    // MARK: - OCR Hints Parsing Tests
    
    @Test func testParseOCRHintsFromHintsFile() async throws {
        // Given: A hints file JSON with OCR hints
        let tempDir = FileManager.default.temporaryDirectory
        let testFile = tempDir.appendingPathComponent("FuelReceipt.hints")
        
        let json: [String: Any] = [
            "gallons": [
                "expectedLength": "10",
                "displayWidth": "medium",
                "ocrHints": ["gallons", "gal", "fuel quantity", "liters", "litres"]
            ]
        ]
        
        let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        try data.write(to: testFile)
        
        defer {
            try? FileManager.default.removeItem(at: testFile)
        }
        
        // When: Parsing the hints
        let loader = FileBasedDataHintsLoader()
        let result = loader.loadHintsResult(for: "FuelReceipt")
        
        // Then: OCR hints should be parsed
        let hints = result.fieldHints["gallons"]
        #expect(hints != nil)
        #expect(hints?.ocrHints?.count == 5)
        #expect(hints?.ocrHints?.contains("gallons") == true)
        #expect(hints?.ocrHints?.contains("gal") == true)
        #expect(hints?.ocrHints?.contains("fuel quantity") == true)
    }
    
    @Test func testParseOCRHintsAsStringArray() async throws {
        // Given: OCR hints as array in JSON
        let tempDir = FileManager.default.temporaryDirectory
        let testFile = tempDir.appendingPathComponent("Invoice.hints")
        
        let json: [String: Any] = [
            "price": [
                "ocrHints": ["price", "cost", "amount", "$"]
            ]
        ]
        
        let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        try data.write(to: testFile)
        
        defer {
            try? FileManager.default.removeItem(at: testFile)
        }
        
        // When: Parsing
        let loader = FileBasedDataHintsLoader()
        let result = loader.loadHintsResult(for: "Invoice")
        
        // Then: Should parse as array
        let hints = result.fieldHints["price"]
        #expect(hints?.ocrHints?.count == 4)
    }
    
    @Test func testParseOCRHintsAsCommaSeparatedString() async throws {
        // Given: OCR hints as comma-separated string (alternative format)
        let tempDir = FileManager.default.temporaryDirectory
        let testFile = tempDir.appendingPathComponent("Receipt.hints")
        
        let json: [String: Any] = [
            "total": [
                "ocrHints": "total,amount due,grand total"
            ]
        ]
        
        let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        try data.write(to: testFile)
        
        defer {
            try? FileManager.default.removeItem(at: testFile)
        }
        
        // When: Parsing
        let loader = FileBasedDataHintsLoader()
        let result = loader.loadHintsResult(for: "Receipt")
        
        // Then: Should parse and split by comma
        let hints = result.fieldHints["total"]
        #expect(hints?.ocrHints?.count == 3)
        #expect(hints?.ocrHints?.contains("total") == true)
        #expect(hints?.ocrHints?.contains("amount due") == true)
        #expect(hints?.ocrHints?.contains("grand total") == true)
    }
    
    @Test func testParseOCRHintsMissing() async throws {
        // Given: Field without OCR hints
        let tempDir = FileManager.default.temporaryDirectory
        let testFile = tempDir.appendingPathComponent("User.hints")
        
        let json: [String: Any] = [
            "username": [
                "expectedLength": "20"
            ]
        ]
        
        let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        try data.write(to: testFile)
        
        defer {
            try? FileManager.default.removeItem(at: testFile)
        }
        
        // When: Parsing
        let loader = FileBasedDataHintsLoader()
        let result = loader.loadHintsResult(for: "User")
        
        // Then: OCR hints should be nil
        let hints = result.fieldHints["username"]
        #expect(hints?.ocrHints == nil)
    }
    
    // MARK: - Calculation Groups Parsing Tests
    
    @Test func testParseCalculationGroupsFromHintsFile() async throws {
        // Given: A hints file with calculation groups
        let tempDir = FileManager.default.temporaryDirectory
        let testFile = tempDir.appendingPathComponent("Order.hints")
        
        let json: [String: Any] = [
            "total": [
                "calculationGroups": [
                    [
                        "id": "multiply",
                        "formula": "total = price * quantity",
                        "dependentFields": ["price", "quantity"],
                        "priority": 1
                    ]
                ]
            ]
        ]
        
        let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        try data.write(to: testFile)
        
        defer {
            try? FileManager.default.removeItem(at: testFile)
        }
        
        // When: Parsing
        let loader = FileBasedDataHintsLoader()
        let result = loader.loadHintsResult(for: "Order")
        
        // Then: Calculation groups should be parsed
        let hints = result.fieldHints["total"]
        #expect(hints != nil)
        #expect(hints?.calculationGroups?.count == 1)
        #expect(hints?.calculationGroups?.first?.id == "multiply")
        #expect(hints?.calculationGroups?.first?.formula == "total = price * quantity")
        #expect(hints?.calculationGroups?.first?.dependentFields == ["price", "quantity"])
        #expect(hints?.calculationGroups?.first?.priority == 1)
    }
    
    @Test func testParseMultipleCalculationGroups() async throws {
        // Given: Field with multiple calculation groups
        let tempDir = FileManager.default.temporaryDirectory
        let testFile = tempDir.appendingPathComponent("Invoice.hints")
        
        let json: [String: Any] = [
            "total": [
                "calculationGroups": [
                    [
                        "id": "multiply",
                        "formula": "total = price * quantity",
                        "dependentFields": ["price", "quantity"],
                        "priority": 1
                    ],
                    [
                        "id": "add_tax",
                        "formula": "total = subtotal + tax",
                        "dependentFields": ["subtotal", "tax"],
                        "priority": 2
                    ]
                ]
            ]
        ]
        
        let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        try data.write(to: testFile)
        
        defer {
            try? FileManager.default.removeItem(at: testFile)
        }
        
        // When: Parsing
        let loader = FileBasedDataHintsLoader()
        let result = loader.loadHintsResult(for: "Invoice")
        
        // Then: Both groups should be parsed
        let hints = result.fieldHints["total"]
        #expect(hints?.calculationGroups?.count == 2)
        #expect(hints?.calculationGroups?.first?.priority == 1)
        #expect(hints?.calculationGroups?.last?.priority == 2)
    }
    
    @Test func testParseCalculationGroupsMissing() async throws {
        // Given: Field without calculation groups
        let tempDir = FileManager.default.temporaryDirectory
        let testFile = tempDir.appendingPathComponent("User.hints")
        
        let json: [String: Any] = [
            "username": [
                "expectedLength": "20"
            ]
        ]
        
        let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        try data.write(to: testFile)
        
        defer {
            try? FileManager.default.removeItem(at: testFile)
        }
        
        // When: Parsing
        let loader = FileBasedDataHintsLoader()
        let result = loader.loadHintsResult(for: "User")
        
        // Then: Calculation groups should be nil
        let hints = result.fieldHints["username"]
        #expect(hints?.calculationGroups == nil)
    }
    
    // MARK: - Combined OCR and Calculation Groups Tests
    
    @Test func testParseOCRAndCalculationGroupsTogether() async throws {
        // Given: Field with both OCR hints and calculation groups
        let tempDir = FileManager.default.temporaryDirectory
        let testFile = tempDir.appendingPathComponent("FuelReceipt.hints")
        
        let json: [String: Any] = [
            "gallons": [
                "expectedLength": "10",
                "ocrHints": ["gallons", "gal", "fuel quantity"],
                "calculationGroups": [
                    [
                        "id": "from_price_total",
                        "formula": "gallons = total_price / price_per_gallon",
                        "dependentFields": ["total_price", "price_per_gallon"],
                        "priority": 1
                    ]
                ]
            ]
        ]
        
        let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        try data.write(to: testFile)
        
        defer {
            try? FileManager.default.removeItem(at: testFile)
        }
        
        // When: Parsing
        let loader = FileBasedDataHintsLoader()
        let result = loader.loadHintsResult(for: "FuelReceipt")
        
        // Then: Both should be parsed
        let hints = result.fieldHints["gallons"]
        #expect(hints?.ocrHints?.count == 3)
        #expect(hints?.calculationGroups?.count == 1)
        #expect(hints?.calculationGroups?.first?.formula == "gallons = total_price / price_per_gallon")
    }
    
    // MARK: - Apply Hints to DynamicFormField Tests
    
    @Test func testApplyOCRHintsToDynamicFormField() {
        // Given: Hints with OCR hints
        let hints = FieldDisplayHints(
            expectedLength: 10,
            ocrHints: ["gallons", "gal"]
        )
        
        // When: Creating field and applying hints
        var field = DynamicFormField(
            id: "gallons",
            contentType: .number,
            label: "Gallons"
        )
        field = field.applying(hints: hints)
        
        // Then: Field should have OCR hints
        #expect(field.ocrHints?.count == 2)
        #expect(field.ocrHints?.contains("gallons") == true)
        #expect(field.supportsOCR == true) // Should be enabled when OCR hints present
    }
    
    @Test func testApplyCalculationGroupsToDynamicFormField() {
        // Given: Hints with calculation groups
        let calculationGroup = CalculationGroup(
            id: "multiply",
            formula: "total = price * quantity",
            dependentFields: ["price", "quantity"],
            priority: 1
        )
        let hints = FieldDisplayHints(
            expectedLength: 10,
            calculationGroups: [calculationGroup]
        )
        
        // When: Creating field and applying hints
        var field = DynamicFormField(
            id: "total",
            contentType: .number,
            label: "Total"
        )
        field = field.applying(hints: hints)
        
        // Then: Field should have calculation groups
        #expect(field.calculationGroups?.count == 1)
        #expect(field.calculationGroups?.first?.id == "multiply")
        #expect(field.isCalculated == true) // Should be enabled when calculation groups present
    }
    
    @Test func testApplyBothOCRAndCalculationGroupsToField() {
        // Given: Hints with both OCR and calculation groups
        let calculationGroup = CalculationGroup(
            id: "from_price_total",
            formula: "gallons = total_price / price_per_gallon",
            dependentFields: ["total_price", "price_per_gallon"],
            priority: 1
        )
        let hints = FieldDisplayHints(
            expectedLength: 10,
            ocrHints: ["gallons", "gal"],
            calculationGroups: [calculationGroup]
        )
        
        // When: Creating field and applying hints
        var field = DynamicFormField(
            id: "gallons",
            contentType: .number,
            label: "Gallons"
        )
        field = field.applying(hints: hints)
        
        // Then: Field should have both
        #expect(field.ocrHints?.count == 2)
        #expect(field.calculationGroups?.count == 1)
        #expect(field.supportsOCR == true)
        #expect(field.isCalculated == true)
    }
    
    // MARK: - Internationalization Tests
    
    @Test func testParseLanguageSpecificOCRHints() async throws {
        // Given: Hints file with language-specific OCR hints
        let tempDir = FileManager.default.temporaryDirectory
        let testFile = tempDir.appendingPathComponent("FuelReceipt.hints")
        
        let json: [String: Any] = [
            "gallons": [
                "expectedLength": "10",
                "ocrHints": ["gallons", "gal"],  // Default/fallback
                "ocrHints.es": ["galones", "gal"],
                "ocrHints.fr": ["gallons", "litres"]
            ]
        ]
        
        let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        try data.write(to: testFile)
        
        defer {
            try? FileManager.default.removeItem(at: testFile)
        }
        
        // When: Parsing with Spanish locale
        let loader = FileBasedDataHintsLoader()
        let result = loader.loadHintsResult(for: "FuelReceipt", locale: Locale(identifier: "es"))
        
        // Then: Should use Spanish OCR hints
        let hints = result.fieldHints["gallons"]
        #expect(hints != nil)
        #expect(hints?.ocrHints?.count == 2)
        #expect(hints?.ocrHints?.contains("galones") == true)
        #expect(hints?.ocrHints?.contains("gal") == true)
    }
    
    @Test func testParseLanguageSpecificOCRHintsFallbackToDefault() async throws {
        // Given: Hints file with default OCR hints but no language-specific for current locale
        let tempDir = FileManager.default.temporaryDirectory
        let testFile = tempDir.appendingPathComponent("FuelReceipt.hints")
        
        let json: [String: Any] = [
            "gallons": [
                "expectedLength": "10",
                "ocrHints": ["gallons", "gal"],  // Default/fallback
                "ocrHints.es": ["galones", "gal"]  // Only Spanish, no French
            ]
        ]
        
        let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        try data.write(to: testFile)
        
        defer {
            try? FileManager.default.removeItem(at: testFile)
        }
        
        // When: Parsing with French locale (not in file)
        let loader = FileBasedDataHintsLoader()
        let result = loader.loadHintsResult(for: "FuelReceipt", locale: Locale(identifier: "fr"))
        
        // Then: Should fallback to default OCR hints
        let hints = result.fieldHints["gallons"]
        #expect(hints != nil)
        #expect(hints?.ocrHints?.count == 2)
        #expect(hints?.ocrHints?.contains("gallons") == true)
        #expect(hints?.ocrHints?.contains("gal") == true)
    }
    
    @Test func testParseLanguageSpecificOCRHintsUsesCurrentLocale() async throws {
        // Given: Hints file with multiple language-specific OCR hints
        let tempDir = FileManager.default.temporaryDirectory
        let testFile = tempDir.appendingPathComponent("FuelReceipt.hints")
        
        let json: [String: Any] = [
            "gallons": [
                "expectedLength": "10",
                "ocrHints": ["gallons", "gal"],  // Default/fallback
                "ocrHints.en": ["gallons", "gal"],
                "ocrHints.es": ["galones", "gal"],
                "ocrHints.fr": ["gallons", "litres"]
            ]
        ]
        
        let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        try data.write(to: testFile)
        
        defer {
            try? FileManager.default.removeItem(at: testFile)
        }
        
        // When: Parsing with English locale
        let loader = FileBasedDataHintsLoader()
        let result = loader.loadHintsResult(for: "FuelReceipt", locale: Locale(identifier: "en"))
        
        // Then: Should use English OCR hints
        let hints = result.fieldHints["gallons"]
        #expect(hints != nil)
        #expect(hints?.ocrHints?.count == 2)
        #expect(hints?.ocrHints?.contains("gallons") == true)
        #expect(hints?.ocrHints?.contains("gal") == true)
    }
    
    @Test func testParseLanguageSpecificOCRHintsBackwardCompatible() async throws {
        // Given: Existing hints file with only default OCR hints (no language-specific)
        let tempDir = FileManager.default.temporaryDirectory
        let testFile = tempDir.appendingPathComponent("FuelReceipt.hints")
        
        let json: [String: Any] = [
            "gallons": [
                "expectedLength": "10",
                "ocrHints": ["gallons", "gal"]  // Only default, no language-specific
            ]
        ]
        
        let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        try data.write(to: testFile)
        
        defer {
            try? FileManager.default.removeItem(at: testFile)
        }
        
        // When: Parsing with any locale
        let loader = FileBasedDataHintsLoader()
        let result = loader.loadHintsResult(for: "FuelReceipt", locale: Locale(identifier: "es"))
        
        // Then: Should use default OCR hints (backward compatible)
        let hints = result.fieldHints["gallons"]
        #expect(hints != nil)
        #expect(hints?.ocrHints?.count == 2)
        #expect(hints?.ocrHints?.contains("gallons") == true)
        #expect(hints?.ocrHints?.contains("gal") == true)
    }
    
    @Test func testParseLanguageSpecificOCRHintsWithCalculationGroups() async throws {
        // Given: Hints file with both language-specific OCR hints and calculation groups
        let tempDir = FileManager.default.temporaryDirectory
        let testFile = tempDir.appendingPathComponent("FuelReceipt.hints")
        
        let json: [String: Any] = [
            "gallons": [
                "expectedLength": "10",
                "ocrHints": ["gallons", "gal"],
                "ocrHints.es": ["galones", "gal"],
                "calculationGroups": [
                    [
                        "id": "from_price_total",
                        "formula": "gallons = total_price / price_per_gallon",
                        "dependentFields": ["total_price", "price_per_gallon"],
                        "priority": 1
                    ]
                ]
            ]
        ]
        
        let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        try data.write(to: testFile)
        
        defer {
            try? FileManager.default.removeItem(at: testFile)
        }
        
        // When: Parsing with Spanish locale
        let loader = FileBasedDataHintsLoader()
        let result = loader.loadHintsResult(for: "FuelReceipt", locale: Locale(identifier: "es"))
        
        // Then: Should have both Spanish OCR hints and calculation groups
        let hints = result.fieldHints["gallons"]
        #expect(hints != nil)
        #expect(hints?.ocrHints?.count == 2)
        #expect(hints?.ocrHints?.contains("galones") == true)
        #expect(hints?.calculationGroups?.count == 1)
        #expect(hints?.calculationGroups?.first?.formula == "gallons = total_price / price_per_gallon")
    }
}

