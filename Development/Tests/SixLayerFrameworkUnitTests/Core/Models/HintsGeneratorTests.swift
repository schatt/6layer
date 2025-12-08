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
    
    // MARK: - Section Preservation Tests
    
    /// BUSINESS PURPOSE: Validate that generator preserves existing _sections when updating hints
    /// TESTING SCOPE: Tests that _sections are preserved when hints are regenerated
    /// METHODOLOGY: Create hints file with sections, verify sections are preserved after regeneration
    @Test func testGeneratorPreservesExistingSections() throws {
        let modelName = "SectionPreservation_testGeneratorPreservesExistingSections"
        let existingHints: [String: Any] = [
            "username": [
                "fieldType": "string",
                "isOptional": false
            ],
            "email": [
                "fieldType": "string",
                "isOptional": true
            ],
            "_sections": [
                [
                    "id": "basic-info",
                    "title": "Basic Information",
                    "description": "Your account details",
                    "fields": ["username", "email"],
                    "layoutStyle": "vertical",
                    "isCollapsible": true,
                    "isCollapsed": false
                ]
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
        
        // Write existing hints with sections
        let data = try JSONSerialization.data(withJSONObject: existingHints, options: .prettyPrinted)
        try data.write(to: testFile, options: .atomic)
        
        // Load using DataHintsLoader
        let loader = FileBasedDataHintsLoader()
        let result = loader.loadHintsResult(for: uniqueModelName)
        
        // Verify sections are preserved
        #expect(result.sections.count == 1)
        
        let section = result.sections[0]
        #expect(section.id == "basic-info")
        #expect(section.title == "Basic Information")
        #expect(section.description == "Your account details")
        #expect(section.layoutStyle == .vertical)
        #expect(section.isCollapsible == true)
        #expect(section.isCollapsed == false)
        #expect(section.fields.count == 2)
        #expect(section.fields[0].id == "username")
        #expect(section.fields[1].id == "email")
    }
    
    /// BUSINESS PURPOSE: Validate that hints files without sections can still be loaded
    /// TESTING SCOPE: Tests that DataHintsLoader handles missing _sections gracefully
    /// METHODOLOGY: Create hints file without sections, verify fields are still loaded
    /// NOTE: The generator script creates default sections, but this test verifies loader behavior
    @Test func testLoaderHandlesMissingSections() throws {
        let modelName = "DefaultSection_testGeneratorCreatesDefaultSectionWhenNoneExist"
        let hintsWithoutSections: [String: Any] = [
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
        
        // Write hints without sections
        let data = try JSONSerialization.data(withJSONObject: hintsWithoutSections, options: .prettyPrinted)
        try data.write(to: testFile, options: .atomic)
        
        // Note: The generator would add _sections, but for this test we're verifying
        // that when sections are missing, the loader can still work (graceful degradation)
        // The actual default section creation happens in the generator script
        
        // Load using DataHintsLoader (should handle missing sections gracefully)
        let loader = FileBasedDataHintsLoader()
        let result = loader.loadHintsResult(for: uniqueModelName)
        
        // Verify fields are still loaded
        #expect(result.fieldHints.count == 3)
        #expect(result.fieldHints["username"] != nil)
        #expect(result.fieldHints["email"] != nil)
        #expect(result.fieldHints["age"] != nil)
        
        // Sections should be empty (generator would add default, but loader doesn't)
        #expect(result.sections.isEmpty)
    }
    
    /// BUSINESS PURPOSE: Validate that generator preserves section properties including collapsible settings
    /// TESTING SCOPE: Tests that all section properties (isCollapsible, isCollapsed, layoutStyle) are preserved
    /// METHODOLOGY: Create hints with sections having various properties, verify all are preserved
    @Test func testGeneratorPreservesAllSectionProperties() throws {
        let modelName = "SectionProperties_testGeneratorPreservesAllSectionProperties"
        let existingHints: [String: Any] = [
            "username": ["fieldType": "string"],
            "email": ["fieldType": "string"],
            "bio": ["fieldType": "string"],
            "_sections": [
                [
                    "id": "account",
                    "title": "Account",
                    "description": "Account information",
                    "fields": ["username", "email"],
                    "layoutStyle": "horizontal",
                    "isCollapsible": true,
                    "isCollapsed": true
                ],
                [
                    "id": "profile",
                    "title": "Profile",
                    "fields": ["bio"],
                    "layoutStyle": "vertical",
                    "isCollapsible": false
                ]
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
        
        let data = try JSONSerialization.data(withJSONObject: existingHints, options: .prettyPrinted)
        try data.write(to: testFile, options: .atomic)
        
        let loader = FileBasedDataHintsLoader()
        let result = loader.loadHintsResult(for: uniqueModelName)
        
        // Verify both sections are preserved with all properties
        #expect(result.sections.count == 2)
        
        let accountSection = result.sections.first { $0.id == "account" }
        #expect(accountSection != nil)
        #expect(accountSection?.title == "Account")
        #expect(accountSection?.description == "Account information")
        #expect(accountSection?.layoutStyle == .horizontal)
        #expect(accountSection?.isCollapsible == true)
        #expect(accountSection?.isCollapsed == true)
        
        let profileSection = result.sections.first { $0.id == "profile" }
        #expect(profileSection != nil)
        #expect(profileSection?.title == "Profile")
        #expect(profileSection?.description == nil)
        #expect(profileSection?.layoutStyle == .vertical)
        #expect(profileSection?.isCollapsible == false)
        #expect(profileSection?.isCollapsed == false)  // Default when not specified
    }
    
    // MARK: - Generator Script Integration Tests
    
    /// BUSINESS PURPOSE: Validate that generator script creates default section when none exist
    /// TESTING SCOPE: Tests that running the generator on a model without sections creates a default section
    /// METHODOLOGY: Create temp Swift model, run generator script, verify output includes default section
    @Test func testGeneratorScriptCreatesDefaultSection() throws {
        let fileManager = FileManager.default
        let tempDir = fileManager.temporaryDirectory.appendingPathComponent("hints_gen_test_\(UUID().uuidString)")
        try fileManager.createDirectory(at: tempDir, withIntermediateDirectories: true)
        defer {
            try? fileManager.removeItem(at: tempDir)
        }
        
        // Create a simple Swift model file
        let modelFile = tempDir.appendingPathComponent("TestUser.swift")
        let modelContent = """
        struct TestUser {
            let username: String
            let email: String?
            let age: Int
        }
        """
        try modelContent.write(to: modelFile, atomically: true, encoding: .utf8)
        
        // Create output directory
        let outputDir = tempDir.appendingPathComponent("Hints")
        try fileManager.createDirectory(at: outputDir, withIntermediateDirectories: true)
        
        // Find the generator script
        let projectRoot = URL(fileURLWithPath: #file)
            .deletingLastPathComponent() // HintsGeneratorTests.swift
            .deletingLastPathComponent() // Models
            .deletingLastPathComponent() // Core
            .deletingLastPathComponent() // SixLayerFrameworkUnitTests
            .deletingLastPathComponent() // Tests
            .deletingLastPathComponent() // Development
        let scriptPath = projectRoot.appendingPathComponent("scripts/generate_hints_from_models.swift")
        
        guard fileManager.fileExists(atPath: scriptPath.path) else {
            throw NSError(domain: "TestError", code: 1, userInfo: ["NSLocalizedDescription": "Generator script not found at \(scriptPath.path)"])
        }
        
        // Run the generator script
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        process.arguments = ["swift", scriptPath.path, "-model", modelFile.path, "-outputdir", outputDir.path]
        process.currentDirectoryURL = projectRoot
        
        try process.run()
        process.waitUntilExit()
        
        #expect(process.terminationStatus == 0, "Generator script should succeed")
        
        // Verify hints file was created
        let hintsFile = outputDir.appendingPathComponent("TestUser.hints")
        #expect(fileManager.fileExists(atPath: hintsFile.path), "Hints file should be created")
        
        // Load and verify the hints file
        guard let data = try? Data(contentsOf: hintsFile),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw NSError(domain: "TestError", code: 2, userInfo: ["NSLocalizedDescription": "Failed to parse hints file"])
        }
        
        // Verify default section was created
        guard let sections = json["_sections"] as? [[String: Any]] else {
            throw NSError(domain: "TestError", code: 3, userInfo: ["NSLocalizedDescription": "No _sections found in generated hints"])
        }
        
        #expect(sections.count == 1, "Should have one default section")
        
        let defaultSection = sections[0]
        #expect(defaultSection["id"] as? String == "default")
        #expect(defaultSection["title"] as? String == "Form Fields")
        
        guard let fields = defaultSection["fields"] as? [String] else {
            throw NSError(domain: "TestError", code: 4, userInfo: ["NSLocalizedDescription": "No fields in default section"])
        }
        
        #expect(fields.count == 3, "Default section should contain all fields")
        #expect(fields.contains("username"))
        #expect(fields.contains("email"))
        #expect(fields.contains("age"))
    }
    
    /// BUSINESS PURPOSE: Validate that generator script preserves existing sections
    /// TESTING SCOPE: Tests that running the generator preserves existing _sections
    /// METHODOLOGY: Create hints file with sections, run generator, verify sections are preserved
    @Test func testGeneratorScriptPreservesExistingSections() throws {
        let fileManager = FileManager.default
        let tempDir = fileManager.temporaryDirectory.appendingPathComponent("hints_gen_test_\(UUID().uuidString)")
        try fileManager.createDirectory(at: tempDir, withIntermediateDirectories: true)
        defer {
            try? fileManager.removeItem(at: tempDir)
        }
        
        // Create a simple Swift model file
        let modelFile = tempDir.appendingPathComponent("TestUser.swift")
        let modelContent = """
        struct TestUser {
            let username: String
            let email: String?
            let age: Int
        }
        """
        try modelContent.write(to: modelFile, atomically: true, encoding: .utf8)
        
        // Create output directory and existing hints file with sections
        let outputDir = tempDir.appendingPathComponent("Hints")
        try fileManager.createDirectory(at: outputDir, withIntermediateDirectories: true)
        
        let existingHints: [String: Any] = [
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
            "_sections": [
                [
                    "id": "account",
                    "title": "Account Information",
                    "description": "Your account details",
                    "fields": ["username", "email"],
                    "layoutStyle": "vertical",
                    "isCollapsible": true,
                    "isCollapsed": false
                ],
                [
                    "id": "profile",
                    "title": "Profile",
                    "fields": ["age"],
                    "layoutStyle": "horizontal"
                ]
            ]
        ]
        
        let hintsFile = outputDir.appendingPathComponent("TestUser.hints")
        let data = try JSONSerialization.data(withJSONObject: existingHints, options: .prettyPrinted)
        try data.write(to: hintsFile, options: .atomic)
        
        // Find the generator script
        let projectRoot = URL(fileURLWithPath: #file)
            .deletingLastPathComponent() // HintsGeneratorTests.swift
            .deletingLastPathComponent() // Models
            .deletingLastPathComponent() // Core
            .deletingLastPathComponent() // SixLayerFrameworkUnitTests
            .deletingLastPathComponent() // Tests
            .deletingLastPathComponent() // Development
        let scriptPath = projectRoot.appendingPathComponent("scripts/generate_hints_from_models.swift")
        
        guard fileManager.fileExists(atPath: scriptPath.path) else {
            throw NSError(domain: "TestError", code: 1, userInfo: ["NSLocalizedDescription": "Generator script not found at \(scriptPath.path)"])
        }
        
        // Run the generator script (should update field hints but preserve sections)
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        process.arguments = ["swift", scriptPath.path, "-model", modelFile.path, "-outputdir", outputDir.path]
        process.currentDirectoryURL = projectRoot
        
        try process.run()
        process.waitUntilExit()
        
        #expect(process.terminationStatus == 0, "Generator script should succeed")
        
        // Verify hints file still exists and was updated
        #expect(fileManager.fileExists(atPath: hintsFile.path), "Hints file should still exist")
        
        // Load and verify the hints file
        guard let updatedData = try? Data(contentsOf: hintsFile),
              let json = try? JSONSerialization.jsonObject(with: updatedData) as? [String: Any] else {
            throw NSError(domain: "TestError", code: 2, userInfo: ["NSLocalizedDescription": "Failed to parse updated hints file"])
        }
        
        // Verify sections were preserved
        guard let sections = json["_sections"] as? [[String: Any]] else {
            throw NSError(domain: "TestError", code: 3, userInfo: ["NSLocalizedDescription": "_sections not found or not preserved"])
        }
        
        #expect(sections.count == 2, "Should preserve both sections")
        
        // Verify first section properties
        let accountSection = sections.first { $0["id"] as? String == "account" }
        #expect(accountSection != nil)
        #expect(accountSection?["title"] as? String == "Account Information")
        #expect(accountSection?["description"] as? String == "Your account details")
        #expect(accountSection?["layoutStyle"] as? String == "vertical")
        #expect(accountSection?["isCollapsible"] as? Bool == true)
        #expect(accountSection?["isCollapsed"] as? Bool == false)
        
        // Verify second section properties
        let profileSection = sections.first { $0["id"] as? String == "profile" }
        #expect(profileSection != nil)
        #expect(profileSection?["title"] as? String == "Profile")
        #expect(profileSection?["layoutStyle"] as? String == "horizontal")
        
        // Verify field hints were updated (type info added)
        let usernameHints = json["username"] as? [String: Any]
        #expect(usernameHints != nil)
        #expect(usernameHints?["fieldType"] as? String == "string")
    }
}
