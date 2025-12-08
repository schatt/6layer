//
//  HintsGeneratorTests.swift
//  SixLayerFramework
//
//  Tests for the hints generator script functionality
//

import Testing
import Foundation
@testable import SixLayerFramework

@Suite("Hints Generator Tests")
struct HintsGeneratorTests {
    
    /// Test that generated hints can be parsed by DataHintsLoader
    @Test func testGeneratedHintsCanBeParsed() throws {
        // Create a test hints file with type information (simulating generator output)
        let modelName = "GeneratedModel_testGeneratedHintsCanBeParsed"
        let json: [String: Any] = [
            "username": [
                "fieldType": "string",
                "isOptional": false,
                "expectedLength": 20
            ],
            "age": [
                "fieldType": "number",
                "isOptional": false,
                "isArray": false
            ],
            "email": [
                "fieldType": "string",
                "isOptional": true
            ],
            "tags": [
                "fieldType": "string",
                "isArray": true,
                "isOptional": false
            ],
            "isActive": [
                "fieldType": "boolean",
                "isOptional": false,
                "defaultValue": true
            ],
            "balance": [
                "fieldType": "number",
                "isOptional": false,
                "defaultValue": 0
            ]
        ]
        
        let fileManager = FileManager.default
        guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw NSError(domain: "TestError", code: 1, userInfo: ["NSLocalizedDescription": "Could not find documents directory"])
        }
        let hintsDir = documentsURL.appendingPathComponent("Hints")
        try fileManager.createDirectory(at: hintsDir, withIntermediateDirectories: true)
        let uniqueModelName = "\(modelName)_\(UUID().uuidString.prefix(8))"
        let testFile = hintsDir.appendingPathComponent("\(uniqueModelName).hints")
        defer {
            try? fileManager.removeItem(at: testFile)
        }
        
        let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        try data.write(to: testFile, options: .atomic)
        
        // Load using DataHintsLoader
        let loader = FileBasedDataHintsLoader()
        let result = loader.loadHintsResult(for: uniqueModelName)
        
        // Verify all fields are parsed correctly
        #expect(result.fieldHints.count == 6)
        
        let usernameHints = result.fieldHints["username"]
        #expect(usernameHints != nil)
        #expect(usernameHints?.fieldType == "string")
        #expect(usernameHints?.isOptional == false)
        #expect(usernameHints?.expectedLength == 20)
        #expect(usernameHints?.isFullyDeclarative == true)
        
        let ageHints = result.fieldHints["age"]
        #expect(ageHints != nil)
        #expect(ageHints?.fieldType == "number")
        #expect(ageHints?.isOptional == false)
        #expect(ageHints?.isArray == false)
        
        let emailHints = result.fieldHints["email"]
        #expect(emailHints != nil)
        #expect(emailHints?.fieldType == "string")
        #expect(emailHints?.isOptional == true)
        
        let tagsHints = result.fieldHints["tags"]
        #expect(tagsHints != nil)
        #expect(tagsHints?.fieldType == "string")
        #expect(tagsHints?.isArray == true)
        #expect(tagsHints?.isOptional == false)
        
        let isActiveHints = result.fieldHints["isActive"]
        #expect(isActiveHints != nil)
        #expect(isActiveHints?.fieldType == "boolean")
        #expect(isActiveHints?.defaultValue != nil)
        if let defaultValue = isActiveHints?.defaultValue {
            if let boolValue = defaultValue as? Bool {
                #expect(boolValue == true)
            } else if let nsNumber = defaultValue as? NSNumber {
                #expect(nsNumber.boolValue == true)
            }
        }
        
        let balanceHints = result.fieldHints["balance"]
        #expect(balanceHints != nil)
        #expect(balanceHints?.fieldType == "number")
        #expect(balanceHints?.defaultValue != nil)
        if let defaultValue = balanceHints?.defaultValue {
            if let intValue = defaultValue as? Int {
                #expect(intValue == 0)
            } else if let nsNumber = defaultValue as? NSNumber {
                #expect(nsNumber.intValue == 0)
            }
        }
    }
    
    /// Test that generated hints maintain existing display hints
    @Test func testGeneratedHintsPreserveDisplayHints() throws {
        // Simulate generating hints for a model that already has display hints
        let modelName = "ExistingHints_testGeneratedHintsPreserveDisplayHints"
        let existingHints: [String: Any] = [
            "username": [
                "expectedLength": 20,
                "displayWidth": "medium"
            ]
        ]
        
        // Simulate generator adding type info (should preserve display hints)
        let generatedHints: [String: Any] = [
            "username": [
                "fieldType": "string",
                "isOptional": false,
                "expectedLength": 20,  // Preserved
                "displayWidth": "medium"  // Preserved
            ]
        ]
        
        let fileManager = FileManager.default
        guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw NSError(domain: "TestError", code: 1, userInfo: ["NSLocalizedDescription": "Could not find documents directory"])
        }
        let hintsDir = documentsURL.appendingPathComponent("Hints")
        try fileManager.createDirectory(at: hintsDir, withIntermediateDirectories: true)
        let uniqueModelName = "\(modelName)_\(UUID().uuidString.prefix(8))"
        let testFile = hintsDir.appendingPathComponent("\(uniqueModelName).hints")
        defer {
            try? fileManager.removeItem(at: testFile)
        }
        
        let data = try JSONSerialization.data(withJSONObject: generatedHints, options: .prettyPrinted)
        try data.write(to: testFile, options: .atomic)
        
        let loader = FileBasedDataHintsLoader()
        let result = loader.loadHintsResult(for: uniqueModelName)
        
        let usernameHints = result.fieldHints["username"]
        #expect(usernameHints != nil)
        #expect(usernameHints?.fieldType == "string")
        #expect(usernameHints?.isOptional == false)
        #expect(usernameHints?.expectedLength == 20)  // Preserved
        #expect(usernameHints?.displayWidth == "medium")  // Preserved
    }
}
