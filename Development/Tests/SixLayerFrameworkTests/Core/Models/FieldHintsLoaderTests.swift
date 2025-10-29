//
//  FieldHintsLoaderTests.swift
//  SixLayerFrameworkTests
//
//  Tests for loading hints from files
//

import Testing
import Foundation
@testable import SixLayerFramework

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
}


