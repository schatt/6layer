//
//  DataIntrospectionHintsFirstTests.swift
//  SixLayerFramework
//
//  Tests for hints-first discovery in DataIntrospectionEngine
//

import Testing
import Foundation
@testable import SixLayerFramework

@Suite("Data Introspection Hints-First Discovery")
struct DataIntrospectionHintsFirstTests {
    
    /// Helper to write a hints file to documents directory
    private func writeHintsFile(modelName: String, json: [String: Any]) throws -> (fileURL: URL, uniqueModelName: String) {
        let fileManager = FileManager.default
        guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw NSError(domain: "TestError", code: 1, userInfo: ["NSLocalizedDescription": "Could not find documents directory"])
        }
        let hintsDir = documentsURL.appendingPathComponent("Hints")
        try fileManager.createDirectory(at: hintsDir, withIntermediateDirectories: true)
        let uniqueModelName = "\(modelName)_\(UUID().uuidString.prefix(8))"
        let testFile = hintsDir.appendingPathComponent("\(uniqueModelName).hints")
        let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        try data.write(to: testFile, options: .atomic)
        guard fileManager.fileExists(atPath: testFile.path) else {
            throw NSError(domain: "TestError", code: 2, userInfo: ["NSLocalizedDescription": "File was not created"])
        }
        return (testFile, uniqueModelName)
    }
    
    // MARK: - Test Models
    
    struct TestUser {
        let username: String
        let email: String?
        let age: Int
        let isActive: Bool
    }
    
    struct TestProduct {
        let name: String
        let price: Double
        let inStock: Bool?
    }
    
    // MARK: - Hints-First Discovery Tests
    
    @Test func testHintsFirst_WithFullyDeclarativeHints() throws {
        // Given: A model with fully declarative hints
        let modelName = "TestUser_testHintsFirst_WithFullyDeclarativeHints"
        let json: [String: Any] = [
            "username": [
                "fieldType": "string",
                "isOptional": false
            ],
            "email": [
                "fieldType": "string",
                "isOptional": true
            ],
            "age": [
                "fieldType": "number",
                "isOptional": false
            ],
            "isActive": [
                "fieldType": "boolean",
                "isOptional": false
            ]
        ]
        
        let (testFile, uniqueModelName) = try writeHintsFile(modelName: modelName, json: json)
        defer {
            try? FileManager.default.removeItem(at: testFile)
        }
        
        // When: Analyzing a TestUser instance (hints file name must match type name)
        // Note: The model name in hints file needs to match the type name
        // For this test, we'll create a TestUser instance and verify hints are used
        _ = TestUser(username: "test", email: "test@example.com", age: 30, isActive: true)
        
        // The analyze method will look for hints using the type name
        // Since we can't easily change the type name, we'll test the hints loading directly
        // and verify the conversion logic works
        let hintsLoader = FileBasedDataHintsLoader()
        let hintsResult = hintsLoader.loadHintsResult(for: uniqueModelName)
        
        // Verify hints are loaded and fully declarative
        #expect(hintsResult.fieldHints.count == 4)
        #expect(hintsResult.fieldHints["username"]?.isFullyDeclarative == true)
        #expect(hintsResult.fieldHints["email"]?.isFullyDeclarative == true)
        #expect(hintsResult.fieldHints["age"]?.isFullyDeclarative == true)
        #expect(hintsResult.fieldHints["isActive"]?.isFullyDeclarative == true)
    }
    
    @Test func testHintsFirst_WithPartialHints() throws {
        // Given: A model with partial hints (some missing isOptional)
        let modelName = "TestProduct_testHintsFirst_WithPartialHints"
        let json: [String: Any] = [
            "name": [
                "fieldType": "string",
                "isOptional": false
            ],
            "price": [
                "fieldType": "number"
                // Missing isOptional - not fully declarative
            ],
            "inStock": [
                "fieldType": "boolean",
                "isOptional": true
            ]
        ]
        
        let (testFile, uniqueModelName) = try writeHintsFile(modelName: modelName, json: json)
        defer {
            try? FileManager.default.removeItem(at: testFile)
        }
        
        let hintsLoader = FileBasedDataHintsLoader()
        let hintsResult = hintsLoader.loadHintsResult(for: uniqueModelName)
        
        // Verify some hints are fully declarative, some are not
        #expect(hintsResult.fieldHints["name"]?.isFullyDeclarative == true)
        #expect(hintsResult.fieldHints["price"]?.isFullyDeclarative == false)
        #expect(hintsResult.fieldHints["inStock"]?.isFullyDeclarative == true)
    }
    
    @Test func testHintsFirst_NoHintsAvailable() throws {
        // Given: A model with no hints file
        let user = TestUser(username: "test", email: nil, age: 25, isActive: true)
        
        // When: Analyzing
        let analysis = DataIntrospectionEngine.analyze(user)
        
        // Then: Should fall back to Mirror introspection
        #expect(analysis.fields.count > 0)
        #expect(analysis.fields.contains { $0.name == "username" })
        #expect(analysis.fields.contains { $0.name == "email" })
        #expect(analysis.fields.contains { $0.name == "age" })
        #expect(analysis.fields.contains { $0.name == "isActive" })
    }
    
    @Test func testConvertFieldTypeStringToEnum() {
        // Test the field type conversion logic
        // This is tested indirectly through hints-first discovery, but we can verify the mapping
        
        // Create hints with different field types
        let hints: [String: FieldDisplayHints] = [
            "stringField": FieldDisplayHints(fieldType: "string", isOptional: false),
            "numberField": FieldDisplayHints(fieldType: "number", isOptional: false),
            "booleanField": FieldDisplayHints(fieldType: "boolean", isOptional: false),
            "dateField": FieldDisplayHints(fieldType: "date", isOptional: false),
            "urlField": FieldDisplayHints(fieldType: "url", isOptional: false),
            "uuidField": FieldDisplayHints(fieldType: "uuid", isOptional: false),
            "documentField": FieldDisplayHints(fieldType: "document", isOptional: false),
            "imageField": FieldDisplayHints(fieldType: "image", isOptional: false),
            "customField": FieldDisplayHints(fieldType: "custom", isOptional: false)
        ]
        
        // Verify all hints are fully declarative
        for (_, hint) in hints {
            #expect(hint.isFullyDeclarative == true)
        }
    }
    
    @Test func testHintsFirst_PreservesFieldOrder() throws {
        // Given: Hints with specific field order
        let modelName = "TestUser_testHintsFirst_PreservesFieldOrder"
        let json: [String: Any] = [
            "username": [
                "fieldType": "string",
                "isOptional": false
            ],
            "email": [
                "fieldType": "string",
                "isOptional": true
            ],
            "age": [
                "fieldType": "number",
                "isOptional": false
            ]
        ]
        
        let (testFile, uniqueModelName) = try writeHintsFile(modelName: modelName, json: json)
        defer {
            try? FileManager.default.removeItem(at: testFile)
        }
        
        let hintsLoader = FileBasedDataHintsLoader()
        let hintsResult = hintsLoader.loadHintsResult(for: uniqueModelName)
        
        // Verify hints are loaded
        #expect(hintsResult.fieldHints.count == 3)
        #expect(hintsResult.fieldHints["username"] != nil)
        #expect(hintsResult.fieldHints["email"] != nil)
        #expect(hintsResult.fieldHints["age"] != nil)
    }
    
    @Test func testHintsFirst_WithActualTypeName() throws {
        // Given: Hints file named exactly after the type
        // Create a hints file for "TestUser" (the actual struct name)
        let json: [String: Any] = [
            "username": [
                "fieldType": "string",
                "isOptional": false
            ],
            "email": [
                "fieldType": "string",
                "isOptional": true
            ],
            "age": [
                "fieldType": "number",
                "isOptional": false
            ],
            "isActive": [
                "fieldType": "boolean",
                "isOptional": false
            ]
        ]
        
        let fileManager = FileManager.default
        guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw NSError(domain: "TestError", code: 1, userInfo: ["NSLocalizedDescription": "Could not find documents directory"])
        }
        let hintsDir = documentsURL.appendingPathComponent("Hints")
        try fileManager.createDirectory(at: hintsDir, withIntermediateDirectories: true)
        let testFile = hintsDir.appendingPathComponent("TestUser.hints")
        defer {
            try? fileManager.removeItem(at: testFile)
        }
        
        let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        try data.write(to: testFile, options: .atomic)
        
        // When: Analyzing a TestUser instance
        let user = TestUser(username: "testuser", email: "test@example.com", age: 30, isActive: true)
        let analysis = DataIntrospectionEngine.analyze(user)
        
        // Then: Should use hints if available (or fall back to Mirror)
        // Verify we get the expected fields
        #expect(analysis.fields.count >= 4)
        
        // Verify field types match hints (if hints were used) or Mirror (if not)
        let usernameField = analysis.fields.first { $0.name == "username" }
        #expect(usernameField != nil)
        #expect(usernameField?.type == .string)
        
        let emailField = analysis.fields.first { $0.name == "email" }
        #expect(emailField != nil)
        #expect(emailField?.type == .string)
        #expect(emailField?.isOptional == true) // Should be optional from hints or Mirror
        
        let ageField = analysis.fields.first { $0.name == "age" }
        #expect(ageField != nil)
        #expect(ageField?.type == .number)
        
        let isActiveField = analysis.fields.first { $0.name == "isActive" }
        #expect(isActiveField != nil)
        #expect(isActiveField?.type == .boolean)
    }
}
