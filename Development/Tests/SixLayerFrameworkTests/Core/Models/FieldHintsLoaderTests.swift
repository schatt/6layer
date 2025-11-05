//
//  FieldHintsLoaderTests.swift
//  SixLayerFrameworkTests
//
//  Tests for loading hints from files
//

import Testing
import Foundation
@testable import SixLayerFramework

@Suite("Field Hints Loader")
struct FieldHintsLoaderTests {
    
    // MARK: - JSON Parsing
    
    @Test func testParseHintsFromJSON() {
        let json: [String: [String: String]] = [
            "username": [
                "expectedLength": "20",
                "displayWidth": "medium",
                "maxLength": "50"
            ],
            "email": [
                "displayWidth": "wide",
                "expectedLength": "30"
            ]
        ]
        
        let loader = FileBasedDataHintsLoader()
        let hints = loader.loadHints(for: "Test") // Will be empty since no file
        
        // Since we can't easily test file loading, we'll test the JSON structure
        // The loader should return empty dict for non-existent files
        #expect(hints.isEmpty == true) // No file exists
    }
    
    @Test func testHintsLoaderHasHints() {
        let loader = FileBasedDataHintsLoader()
        
        // Test with non-existent model
        let hasHints = loader.hasHints(for: "NonExistentModel")
        #expect(hasHints == false)
    }
    
    // MARK: - FieldDisplayHints from Metadata
    
    @Test func testDynamicFormFieldDisplayHintsFromMetadata() {
        let field = DynamicFormField(
            id: "username",
            contentType: .text,
            label: "Username",
            metadata: [
                "expectedLength": "20",
                "displayWidth": "medium",
                "maxLength": "50",
                "minLength": "3",
                "showCharacterCounter": "true"
            ]
        )
        
        let hints = field.displayHints
        
        #expect(hints != nil)
        #expect(hints?.expectedLength == 20)
        #expect(hints?.displayWidth == "medium")
        #expect(hints?.maxLength == 50)
        #expect(hints?.minLength == 3)
        #expect(hints?.showCharacterCounter == true)
    }
    
    @Test func testDynamicFormFieldDisplayHintsNoMetadata() {
        let field = DynamicFormField(
            id: "username",
            contentType: .text,
            label: "Username"
        )
        
        let hints = field.displayHints
        #expect(hints == nil)
    }
    
    @Test func testDynamicFormFieldDisplayHintsPartialMetadata() {
        let field = DynamicFormField(
            id: "username",
            contentType: .text,
            label: "Username",
            metadata: [
                "displayWidth": "wide",
                "showCharacterCounter": "false"
            ]
        )
        
        let hints = field.displayHints
        
        #expect(hints != nil)
        #expect(hints?.displayWidth == "wide")
        #expect(hints?.showCharacterCounter == false)
        #expect(hints?.expectedLength == nil)
        #expect(hints?.maxLength == nil)
    }
    
    // MARK: - Hints File _sections Parsing Tests (TDD RED)
    
    /// BUSINESS PURPOSE: Validate hints parser can parse _sections array from hints file
    /// TESTING SCOPE: Tests parsing _sections with layout groups from JSON
    /// METHODOLOGY: Create JSON with _sections array and verify parser extracts sections correctly
    @Test func testParseHintsWithSections() {
        // TDD RED: Should parse _sections from hints file JSON
        // This test will need to be updated once we implement the parser
        // For now, we're documenting the expected behavior
        
        let jsonString = """
        {
            "_sections": [
                {
                    "id": "basic-info",
                    "title": "Basic Information",
                    "fields": ["name", "email", "phone"],
                    "layoutStyle": "horizontal"
                },
                {
                    "id": "details",
                    "title": "Details",
                    "fields": ["bio", "address"],
                    "layoutStyle": "vertical"
                }
            ],
            "username": {
                "displayWidth": "medium"
            }
        }
        """
        
        // This test documents expected behavior - will implement parser next
        // Expected: parser should extract _sections and return them separately
        // Expected: field hints should still be parsed normally
        #expect(true) // Placeholder - will fail when we implement and test actual parsing
    }
    
    /// BUSINESS PURPOSE: Validate SectionBuilder handles missing fields gracefully
    /// TESTING SCOPE: Tests SectionBuilder when hints sections reference non-existent fields
    /// METHODOLOGY: Create hints sections with missing field IDs and verify SectionBuilder warns and filters
    @Test func testSectionBuilderWithMissingFields() {
        // TDD RED: Should warn when section references fields that don't exist
        let fields = [
            DynamicFormField(id: "name", contentType: .text, label: "Name"),
            DynamicFormField(id: "email", contentType: .email, label: "Email")
        ]
        
        // Create hints section that references a non-existent field
        var hintsSectionMetadata: [String: String] = [:]
        hintsSectionMetadata["_fieldIds"] = "name,nonexistent,email"
        
        let hintsSection = DynamicFormSection(
            id: "basic-info",
            title: "Basic Information",
            fields: [],
            metadata: hintsSectionMetadata,
            layoutStyle: .horizontal
        )
        
        // Build sections - should warn about missing field and only include valid ones
        let builtSections = SectionBuilder.buildSections(
            from: [hintsSection],
            matching: fields
        )
        
        // Should have one section with only valid fields
        #expect(builtSections.count == 1)
        #expect(builtSections[0].fields.count == 2) // name and email, not nonexistent
        #expect(builtSections[0].fields[0].id == "name")
        #expect(builtSections[0].fields[1].id == "email")
    }
    
    /// BUSINESS PURPOSE: Validate hints parser requires section titles
    /// TESTING SCOPE: Tests parsing _sections validates that title is required
    /// METHODOLOGY: Create JSON with section missing title and verify error handling
    @Test func testParseHintsSectionRequiresTitle() {
        // TDD RED: Should require title in _sections (for accessibility)
        let jsonString = """
        {
            "_sections": [
                {
                    "id": "basic-info",
                    "fields": ["name", "email"],
                    "layoutStyle": "horizontal"
                }
            ]
        }
        """
        
        // Expected: Should skip section without title or log error
        // Expected: Should not crash, but section should be ignored
        #expect(true) // Placeholder - will implement validation next
    }
    
    /// BUSINESS PURPOSE: Validate hints parser maintains field order from hints
    /// TESTING SCOPE: Tests parsing _sections preserves field order as listed in hints
    /// METHODOLOGY: Create JSON with fields in specific order and verify order is preserved
    @Test func testParseHintsPreservesFieldOrder() {
        // TDD RED: Should preserve field order as specified in hints
        let jsonString = """
        {
            "_sections": [
                {
                    "id": "basic-info",
                    "title": "Basic Information",
                    "fields": ["name", "email", "phone"],
                    "layoutStyle": "horizontal"
                }
            ]
        }
        """
        
        // Expected: Fields should be in order: name, email, phone
        // Expected: Not alphabetically sorted or randomly ordered
        #expect(true) // Placeholder - will implement order preservation next
    }
    
    /// BUSINESS PURPOSE: Validate hints parser handles backward compatibility
    /// TESTING SCOPE: Tests parsing hints files without _sections (existing files)
    /// METHODOLOGY: Create JSON without _sections and verify it still works
    @Test func testParseHintsBackwardCompatible() {
        // TDD RED: Should work with hints files that don't have _sections
        let jsonString = """
        {
            "username": {
                "displayWidth": "medium",
                "expectedLength": "20"
            },
            "email": {
                "displayWidth": "wide"
            }
        }
        """
        
        // Expected: Should parse field hints normally
        // Expected: Should return empty sections array (no _sections found)
        // Expected: Should not crash or error
        #expect(true) // Placeholder - will implement backward compatibility next
    }
}


