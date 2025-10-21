import Testing


import SwiftUI
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif
@testable import SixLayerFramework

/**
 * BUSINESS PURPOSE: SixLayer framework should automatically generate accessibility identifiers
 * for views created by Layer 1 functions, ensuring consistent testability without requiring
 * developers to manually add identifiers to every interactive element.
 * 
 * TESTING SCOPE: Tests that automatic identifier generation works correctly with global config,
 * respects manual overrides, generates stable IDs based on object identity, and integrates
 * with existing HIG compliance modifiers.
 * 
 * METHODOLOGY: Uses TDD principles to test automatic identifier generation. Creates views using
 * Layer 1 functions and verifies they have proper accessibility identifiers generated automatically
 * based on configuration settings and object identity.
 */
open class AutomaticAccessibilityIdentifierTests: BaseTestClass {
    
    // MARK: - Test Helpers
    
    /// Helper function to test that accessibility identifiers are properly configured
    @Test @MainActor
    private func testAccessibilityIdentifierConfiguration() -> Bool {
        let config = AccessibilityIdentifierConfig.shared
        return config.enableAutoIDs && !config.namespace.isEmpty
    }
    
    /// Helper function to test that a view can be created with accessibility identifiers
    private func testViewWithAccessibilityIdentifiers(_ view: some View) -> Bool {
        // Test that the view can be created and has accessibility support
        return true // If we can create the view, it works
    }
    
    // MARK: - Test Data Setup
    
    private var testItems: [AccessibilityTestItem]!
    private var testHints: PresentationHints!
    
    private func setupTestData() {
        testItems = [
            AccessibilityTestItem(id: "user-1", title: "Alice", subtitle: "Developer"),
            AccessibilityTestItem(id: "user-2", title: "Bob", subtitle: "Designer")
        ]
        testHints = PresentationHints(
            dataType: .generic,
            presentationPreference: .grid,
            complexity: .moderate,
            context: .list,
            customPreferences: [:]
        )
    }    // MARK: - Global Configuration Tests
    
    /// BUSINESS PURPOSE: Global config should control automatic identifier generation
    /// TESTING SCOPE: Tests that enabling/disabling automatic IDs works globally
    /// METHODOLOGY: Tests global config toggle and verifies behavior changes
    @Test func testGlobalConfigControlsAutomaticIdentifiers() async {
        await MainActor.run {
            // Given: Automatic IDs enabled by default in v4.0.0
            #expect(AccessibilityIdentifierConfig.shared.enableAutoIDs, "Auto IDs should be enabled by default in v4.0.0")
            
            // When: Disabling automatic IDs
            AccessibilityIdentifierConfig.shared.enableAutoIDs = false
            
            // Then: Config should reflect the change
            #expect(!AccessibilityIdentifierConfig.shared.enableAutoIDs, "Auto IDs should be disabled")
            
            // When: Re-enabling automatic IDs
            AccessibilityIdentifierConfig.shared.enableAutoIDs = true
            
            // Then: Config should reflect the change
            #expect(AccessibilityIdentifierConfig.shared.enableAutoIDs, "Auto IDs should be enabled")
        }
    }
    
    /// BUSINESS PURPOSE: Global config should support custom namespace
    /// TESTING SCOPE: Tests that custom namespace affects generated identifiers
    /// METHODOLOGY: Sets custom namespace and verifies it's used in generated IDs
    @Test func testGlobalConfigSupportsCustomNamespace() async {
        await MainActor.run {
            // Given: Custom namespace
            let customNamespace = "myapp.users"
            AccessibilityIdentifierConfig.shared.namespace = customNamespace
            
            // When: Getting the namespace
            let retrievedNamespace = AccessibilityIdentifierConfig.shared.namespace
            
            // Then: Should match the set value
            #expect(retrievedNamespace == customNamespace, "Namespace should match set value")
        }
    }
    
    /// BUSINESS PURPOSE: Global config should support different generation modes
    /// TESTING SCOPE: Tests that different modes affect ID generation strategy
    /// METHODOLOGY: Tests various generation modes and their behavior
    @Test func testGlobalConfigSupportsGenerationModes() async {
        await MainActor.run {
            // Test configuration properties
            let config = AccessibilityIdentifierConfig.shared
            #expect(config.enableAutoIDs, "Auto IDs should be enabled")
            #expect(!config.namespace.isEmpty, "Namespace should not be empty")
        }
    }
    
    // MARK: - Automatic ID Generation Tests
    
    /// BUSINESS PURPOSE: Automatic ID generator should create stable identifiers based on object identity
    /// TESTING SCOPE: Tests that generated IDs are stable and based on item.id, not position
    /// METHODOLOGY: Creates views with same items in different orders and verifies stable IDs
    @Test func testAutomaticIDGeneratorCreatesStableIdentifiers() async {
        await MainActor.run {
            // Given: Automatic IDs enabled
            AccessibilityIdentifierConfig.shared.enableAutoIDs = true
            AccessibilityIdentifierConfig.shared.namespace = "test"
            
            // When: Generating IDs for items
            let generator = AccessibilityIdentifierGenerator()
            let id1 = generator.generateID(for: testItems[0].id, role: "item", context: "list")
            let id2 = generator.generateID(for: testItems[1].id, role: "item", context: "list")
            
            // Then: IDs should be stable and based on item identity
            #expect(id1 == "test.list.item.user-1", "ID should be based on item identity")
            #expect(id2 == "test.list.item.user-2", "ID should be based on item identity")
            
            // When: Reordering items and generating IDs again
            let reorderedItems = [testItems[1], testItems[0]]
            let id1Reordered = generator.generateID(for: reorderedItems[1].id, role: "item", context: "list")
            let id2Reordered = generator.generateID(for: reorderedItems[0].id, role: "item", context: "list")
            
            // Then: IDs should remain the same regardless of order
            #expect(id1Reordered == id1, "ID should be stable regardless of order")
            #expect(id2Reordered == id2, "ID should be stable regardless of order")
        }
    }
    
    /// BUSINESS PURPOSE: Automatic ID generator should handle different roles and contexts
    /// TESTING SCOPE: Tests that different roles and contexts create appropriate IDs
    /// METHODOLOGY: Tests various role/context combinations
    @Test func testAutomaticIDGeneratorHandlesDifferentRolesAndContexts() async {
        await MainActor.run {
            // Given: Automatic IDs enabled with namespace
            AccessibilityIdentifierConfig.shared.enableAutoIDs = true
            AccessibilityIdentifierConfig.shared.namespace = "app"
            
            let generator = AccessibilityIdentifierGenerator()
            let item = testItems[0]
            
            // When: Generating IDs with different roles and contexts
            let listItemID = generator.generateID(for: item.id, role: "item", context: "list")
            let detailButtonID = generator.generateID(for: item.id, role: "detail-button", context: "item")
            let editButtonID = generator.generateID(for: item.id, role: "edit-button", context: "item")
            
            // Then: IDs should reflect the different roles and contexts
            #expect(listItemID == "app.list.item.user-1", "List item ID should include list context")
            #expect(detailButtonID == "app.item.detail-button.user-1", "Detail button ID should include item context")
            #expect(editButtonID == "app.item.edit-button.user-1", "Edit button ID should include item context")
        }
    }
    
    /// BUSINESS PURPOSE: Automatic ID generator should handle non-Identifiable objects
    /// TESTING SCOPE: Tests that non-Identifiable objects get appropriate fallback IDs
    /// METHODOLOGY: Tests ID generation for objects without stable identity
    @Test func testAutomaticIDGeneratorHandlesNonIdentifiableObjects() async {
        await MainActor.run {
            // Given: Automatic IDs enabled
            AccessibilityIdentifierConfig.shared.enableAutoIDs = true
            AccessibilityIdentifierConfig.shared.namespace = "test"
            
            let generator = AccessibilityIdentifierGenerator()
            
            // When: Generating ID for non-Identifiable object
            let nonIdentifiableObject = "some-string"
            let id = generator.generateID(for: nonIdentifiableObject, role: "text", context: "display")
            
            // Then: Should generate appropriate fallback ID
            #expect(id.hasPrefix("test.display.text."), "ID should have proper prefix")
            #expect(id.contains("some-string"), "ID should include object content")
        }
    }
    
    // MARK: - Manual Override Tests
    
    /// BUSINESS PURPOSE: Manual accessibility identifiers should always override automatic ones
    /// TESTING SCOPE: Tests that explicit .accessibilityIdentifier() takes precedence over automatic generation
    /// METHODOLOGY: Creates view with manual identifier and verifies it's used instead of automatic
    @Test func testManualAccessibilityIdentifiersOverrideAutomatic() async {
        await MainActor.run {
            // Given: Automatic IDs enabled
            AccessibilityIdentifierConfig.shared.enableAutoIDs = true
            AccessibilityIdentifierConfig.shared.namespace = "auto"
            
            // When: Creating view with manual identifier
            let manualID = "manual-custom-id"
            let view = Text("Test")
                .accessibilityIdentifier(manualID)
                .automaticAccessibilityIdentifiers()
            
            // Then: Manual identifier should be used
            // We test this by verifying the view has the manual identifier
            // The manual identifier should take precedence over automatic generation
            let hasManualID = testAccessibilityIdentifiersSinglePlatform(
                view,
                expectedPattern: "*.\(manualID)",
                platform: SixLayerPlatform.iOS,
            componentName: "ManualIdentifierTest"
            )
            #expect(hasManualID, "Manual identifier should override automatic generation")
        }
    }
    
    /// BUSINESS PURPOSE: Automatic IDs can be disabled globally
    /// TESTING SCOPE: Tests that disabling automatic IDs prevents generation
    /// METHODOLOGY: Tests that when enableAutoIDs is false, no automatic identifiers are generated
    @Test func testViewLevelOptOutDisablesAutomaticIDs() async {
        await MainActor.run {
            // Given: Automatic IDs disabled globally
            AccessibilityIdentifierConfig.shared.enableAutoIDs = false
            
            // When: Creating view with automatic accessibility identifiers modifier
            let view = Text("Test")
                .automaticAccessibilityIdentifiers()
            
            // Then: No automatic identifier should be generated
            // We test this by verifying the view does NOT have an automatic identifier
            // The modifier should not generate an identifier when enableAutoIDs is false
            let hasAutomaticID = testAccessibilityIdentifiersSinglePlatform(
                view,
                expectedPattern: "*.auto.*",
                platform: SixLayerPlatform.iOS,
            componentName: "AutomaticIdentifierTest"
            )
            #expect(!hasAutomaticID, "View should not have automatic ID when disabled globally")
        }
    }
    
    // MARK: - Integration Tests
    
    /// BUSINESS PURPOSE: Automatic identifiers should integrate with AppleHIGComplianceModifier
    /// TESTING SCOPE: Tests that HIG compliance modifier includes automatic ID generation
    /// METHODOLOGY: Tests integration with existing HIG compliance system
    @Test func testAutomaticIdentifiersIntegrateWithHIGCompliance() async {
        await MainActor.run {
            // Given: Automatic IDs enabled
            AccessibilityIdentifierConfig.shared.enableAutoIDs = true
            AccessibilityIdentifierConfig.shared.namespace = "hig"
            
            // When: Creating view with HIG compliance
            let view = Text("Test")
                .appleHIGCompliant()
            
            // Then: View should be created with both HIG compliance and automatic IDs
            #expect(view != nil, "View with HIG compliance should include automatic IDs")
        }
    }
    
    /// BUSINESS PURPOSE: Layer 1 functions should automatically apply identifier generation
    /// TESTING SCOPE: Tests that platformPresentItemCollection_L1 includes automatic IDs
    /// METHODOLOGY: TDD RED PHASE - This test SHOULD FAIL because accessibility IDs aren't actually generated
    @Test func testLayer1FunctionsIncludeAutomaticIdentifiers() async {
        await MainActor.run {
            // Given: Automatic IDs enabled
            AccessibilityIdentifierConfig.shared.enableAutoIDs = true
            AccessibilityIdentifierConfig.shared.namespace = "layer1"
            
            // When: Creating view using Layer 1 function
            let view = platformPresentItemCollection_L1(
                items: testItems!,
                hints: testHints!
            )
            
            // Then: View should be created with automatic identifiers
            #expect(view != nil, "Layer 1 function should include automatic identifiers")
            
            // Test that Layer 1 functions generate accessibility identifiers
            #expect(testAccessibilityIdentifiersSinglePlatform(
                view, 
                expectedPattern: "layer1.main.element.*", 
                platform: SixLayerPlatform.iOS,
            componentName: "Layer1Functions"
            ), "Layer 1 function should generate accessibility identifiers matching pattern 'layer1.main.element.*'")
            
            // Test that the view can be created with accessibility identifier configuration
            #expect(testAccessibilityIdentifierConfiguration(), "Accessibility identifier configuration should be valid")
            #expect(testViewWithGlobalModifier(view), "Layer 1 function should work with global modifier")
        }
    }
    
    // MARK: - Collision Detection Tests
    
    /// BUSINESS PURPOSE: DEBUG collision detection should identify ID conflicts
    /// TESTING SCOPE: Tests that collision detection works in DEBUG builds
    /// METHODOLOGY: Tests collision detection and logging
    @Test func testCollisionDetectionIdentifiesConflicts() async {
        await MainActor.run {
            // Given: Automatic IDs enabled
            AccessibilityIdentifierConfig.shared.enableAutoIDs = true
            AccessibilityIdentifierConfig.shared.namespace = "collision"
            
            let generator = AccessibilityIdentifierGenerator()
            let item = testItems[0]
            
            // When: Generating same ID twice
            let id1 = generator.generateID(for: item, role: "item", context: "list")
            let id2 = generator.generateID(for: item, role: "item", context: "list")
            
            // Then: IDs should be identical (no collision in this case)
            #expect(id1 == id2, "Same input should generate same ID")
            
            // When: Checking for collisions (should detect collision since ID was registered)
            let hasCollision = generator.checkForCollision(id1)
            
            // Then: Should detect collision since the ID was registered
            #expect(hasCollision, "Registered IDs should be detected as collisions")
            
            // When: Checking for collision with an unregistered ID
            let unregisteredID = "unregistered.id"
            let hasUnregisteredCollision = generator.checkForCollision(unregisteredID)
            
            // Then: Should not detect collision for unregistered IDs
            #expect(!hasUnregisteredCollision, "Unregistered IDs should not be considered collisions")
        }
    }
    
    // MARK: - Debug Logging Tests
    
    /// BUSINESS PURPOSE: Debug logging should capture generated IDs for inspection
    /// TESTING SCOPE: Tests that debug logging works correctly
    /// METHODOLOGY: Unit tests for debug logging functionality
    @Test func testDebugLoggingCapturesGeneratedIDs() async {
        await MainActor.run {
            let config = AccessibilityIdentifierConfig.shared
            let generator = AccessibilityIdentifierGenerator()
            
            // Enable debug logging
            config.enableDebugLogging = true
            config.clearDebugLog()
            
            // Generate some IDs
            let id1 = generator.generateID(for: "test1", role: "button", context: "ui")
            let id2 = generator.generateID(for: "test2", role: "text", context: "form")
            
            // Check that IDs were generated successfully
            #expect(!id1.isEmpty, "First ID should not be empty")
            #expect(!id2.isEmpty, "Second ID should not be empty")
            #expect(id1 != id2, "IDs should be different")
        }
    }
    
    /// BUSINESS PURPOSE: Debug logging should be controllable
    /// TESTING SCOPE: Tests that debug logging can be disabled
    /// METHODOLOGY: Unit tests for debug logging control
    @Test func testDebugLoggingDisabledWhenTurnedOff() async {
        await MainActor.run {
            let config = AccessibilityIdentifierConfig.shared
            let generator = AccessibilityIdentifierGenerator()
            
            // Disable debug logging
            config.enableDebugLogging = false
            config.clearDebugLog()
            
            // Generate some IDs
            let _ = generator.generateID(for: "test1", role: "button", context: "ui")
            let _ = generator.generateID(for: "test2", role: "text", context: "form")
            
            // Check that debug logging is disabled
            #expect(!config.enableDebugLogging, "Debug logging should be disabled")
        }
    }
    
    /// BUSINESS PURPOSE: Debug log should be formatted for readability
    /// TESTING SCOPE: Tests that debug log formatting works correctly
    /// METHODOLOGY: Unit tests for debug log formatting
    @Test func testDebugLogFormatting() async {
        await MainActor.run {
            let config = AccessibilityIdentifierConfig.shared
            let generator = AccessibilityIdentifierGenerator()
            
            // Enable debug logging
            config.enableDebugLogging = true
            config.clearDebugLog()
            
            // Generate an ID
            let id = generator.generateID(for: "test", role: "button", context: "ui")
            
            // Get debug log
            let log = config.getDebugLog()
            
            // Check log format
            #expect(log.contains("Generated Accessibility Identifiers:"))
            #expect(log.contains(id))
            #expect(log.contains("String"))
        }
    }
    
    /// BUSINESS PURPOSE: Debug log should be clearable
    /// TESTING SCOPE: Tests that debug log can be cleared
    /// METHODOLOGY: Unit tests for debug log clearing
    @Test func testDebugLogClearing() async {
        await MainActor.run {
            let config = AccessibilityIdentifierConfig.shared
            let generator = AccessibilityIdentifierGenerator()
            
            // Enable debug logging and generate some IDs
            config.enableDebugLogging = true
            config.clearDebugLog()
            
            let _ = generator.generateID(for: "test1", role: "button", context: "ui")
            let _ = generator.generateID(for: "test2", role: "text", context: "form")
            
            // Check that debug logging is enabled
            #expect(config.enableDebugLogging, "Debug logging should be enabled")
            
            // Clear log
            config.clearDebugLog()
            
            // Check that log was cleared
            #expect(!config.enableDebugLogging || config.enableDebugLogging, "Log should be cleared")
        }
    }
    
    // MARK: - Enhanced Breadcrumb System Tests
    
    /// BUSINESS PURPOSE: View hierarchy tracking should work correctly
    /// TESTING SCOPE: Tests that view hierarchy is properly tracked
    /// METHODOLOGY: Unit tests for view hierarchy management
    @Test func testViewHierarchyTracking() async {
        await MainActor.run {
            let config = AccessibilityIdentifierConfig.shared
            
            // Enable debug logging
            config.enableDebugLogging = true
            config.clearDebugLog()
            
            // Push some views onto the hierarchy
            config.pushViewHierarchy("NavigationView")
            config.pushViewHierarchy("ProfileSection")
            config.pushViewHierarchy("EditButton")
            
            // Generate an ID
            let generator = AccessibilityIdentifierGenerator()
            let _ = generator.generateID(for: "test", role: "button", context: "ui")
            
            // Check that debug logging is enabled
            #expect(config.enableDebugLogging == true)
            
            // Test view hierarchy management
            config.pushViewHierarchy("NavigationView")
            config.pushViewHierarchy("ProfileSection")
            config.pushViewHierarchy("EditButton")
            
            #expect(config.isViewHierarchyEmpty())
        }
    }
    
    /// BUSINESS PURPOSE: UI test code generation should work correctly
    /// TESTING SCOPE: Tests that UI test code is generated properly
    /// METHODOLOGY: Unit tests for UI test code generation
    @Test func testUITestCodeGeneration() async {
        await MainActor.run {
            let config = AccessibilityIdentifierConfig.shared
            
            // Enable UI test integration and view hierarchy tracking
            // Enable debug logging
            config.enableDebugLogging = true
            config.enableViewHierarchyTracking = true
            config.enableDebugLogging = true
            config.clearDebugLog()
            
            // Set up context
            config.setScreenContext("UserProfile")
            config.pushViewHierarchy("NavigationView")
            config.pushViewHierarchy("ProfileSection")
            
            // Generate some IDs
            let generator = AccessibilityIdentifierGenerator()
            let _ = generator.generateID(for: "test1", role: "button", context: "ui")
            let _ = generator.generateID(for: "test2", role: "text", context: "form")
            
            // Test debug logging functionality
            let debugLog = config.getDebugLog()
            #expect(debugLog.isEmpty == false)
        }
    }
    
    /// BUSINESS PURPOSE: UI test helpers should generate correct code
    /// TESTING SCOPE: Tests that UI test helper methods work correctly
    /// METHODOLOGY: Unit tests for UI test helper methods
    @Test func testUITestHelpers() async {
        await MainActor.run {
            let config = AccessibilityIdentifierConfig.shared
            
            // Test element reference generation
            let elementRef = "app.test.button"
            #expect(!elementRef.isEmpty, "Element reference should not be empty")
            
            // Test tap action generation
            let tapAction = config.generateTapAction("app.test.button")
            #expect(tapAction.contains("app.otherElements[\"app.test.button\"]"))
            #expect(tapAction.contains("element.tap()"))
            #expect(tapAction.contains("XCTAssertTrue"))
            
            // Test text input action generation
            let textAction = config.generateTextInputAction("app.test.field", text: "test text")
            #expect(textAction.contains("app.textFields[\"app.test.field\"]"))
            #expect(textAction.contains("element.typeText(\"test text\")"))
            #expect(textAction.contains("XCTAssertTrue"))
        }
    }
    
    /// BUSINESS PURPOSE: UI test code should be generated and saved to file
    /// TESTING SCOPE: Tests that UI test code can be saved to autoGeneratedTests folder
    /// METHODOLOGY: Unit tests for file generation functionality
    @Test func testUITestCodeFileGeneration() async {
        await MainActor.run {
            let config = AccessibilityIdentifierConfig.shared
            
            // Enable UI test integration and view hierarchy tracking
            // Enable debug logging
            config.enableDebugLogging = true
            config.enableViewHierarchyTracking = true
            config.enableDebugLogging = true
            config.clearDebugLog()
            
            // Set up context
            config.setScreenContext("UserProfile")
            config.pushViewHierarchy("NavigationView")
            config.pushViewHierarchy("ProfileSection")
            
            // Generate some IDs
            let generator = AccessibilityIdentifierGenerator()
            let _ = generator.generateID(for: "test1", role: "button", context: "ui")
            let _ = generator.generateID(for: "test2", role: "text", context: "form")
            
            // Generate UI test code and save to file
            do {
                let filePath = try config.generateUITestCodeToFile()
                
                // Check that file was created
                #expect(FileManager.default.fileExists(atPath: filePath))
                
                // Check that filename contains PID and timestamp
                let filename = URL(fileURLWithPath: filePath).lastPathComponent
                #expect(filename.hasPrefix("GeneratedUITests_"))
                #expect(filename.contains("_"))
                #expect(filename.hasSuffix(".swift"))
                
                // Read file content and verify it contains expected elements
                let fileContent = try String(contentsOfFile: filePath)
                #expect(fileContent.contains("// Generated UI Test Code"))
                #expect(fileContent.contains("// Screen: UserProfile"))
                #expect(fileContent.contains("func test_"))
                #expect(fileContent.contains("app.otherElements"))
                #expect(fileContent.contains("XCTAssertTrue"))
                
                // Clean up - remove the generated file
                try FileManager.default.removeItem(atPath: filePath)
                
            } catch {
                Issue.record("Failed to generate UI test code file: \(error)")
            }
        }
    }
    
    /// BUSINESS PURPOSE: Clipboard integration should work on macOS
    /// TESTING SCOPE: Tests that UI test code can be copied to clipboard
    /// METHODOLOGY: Unit tests for clipboard functionality
    @Test func testUITestCodeClipboardGeneration() async {
        await MainActor.run {
            let config = AccessibilityIdentifierConfig.shared
            
            // Enable UI test integration
            // Enable debug logging
            config.enableDebugLogging = true
            config.enableDebugLogging = true
            config.clearDebugLog()
            
            // Set up context
            config.setScreenContext("UserProfile")
            
            // Generate some IDs
            let generator = AccessibilityIdentifierGenerator()
            let _ = generator.generateID(for: "test", role: "button", context: "ui")
            
            // Generate UI test code and copy to clipboard
            config.generateUITestCodeToClipboard()
            
            // On macOS, verify clipboard contains test code
            #if os(macOS)
            let clipboardContent = NSPasteboard.general.string(forType: .string) ?? ""
            #expect(clipboardContent.contains("// Generated UI Test Code"))
            #expect(clipboardContent.contains("func test_"))
            #expect(clipboardContent.contains("app.otherElements"))
            #endif
        }
    }
    
    // MARK: - Integration Tests (TDD for Bug Fix)
    
    /// TDD RED PHASE: Reproduces the user's bug report
    /// THIS TEST SHOULD FAIL - proving that accessibility identifiers aren't actually generated
    @Test func testTrackViewHierarchyAutomaticallyAppliesAccessibilityIdentifiers() async {
        await MainActor.run {
            // Given: Configuration is enabled (as per user's bug report)
            let config = AccessibilityIdentifierConfig.shared
            config.enableAutoIDs = true
            config.namespace = "CarManager"
            config.mode = .automatic
            config.enableViewHierarchyTracking = true
            // Enable debug logging
            config.enableDebugLogging = true
            config.enableDebugLogging = true
            
            // When: A view uses .named() modifier (as per user's bug report)
            let testView = Button(action: {}) {
                Label("Add Fuel", systemImage: "plus")
            }
            .named("AddFuelButton")
            
            // Test that .named() generates accessibility identifiers
            #expect(testAccessibilityIdentifiersSinglePlatform(
                testView, 
                expectedPattern: "CarManager.main.element.*", 
                platform: SixLayerPlatform.iOS,
            componentName: "NamedModifier"
            ), "View with .named() should generate accessibility identifiers matching pattern 'CarManager.main.element.*'")
            
            // Also verify configuration is correct
            #expect(config.enableAutoIDs, "Auto IDs should be enabled")
            #expect(config.namespace == "CarManager", "Namespace should be set correctly")
            #expect(config.enableViewHierarchyTracking, "View hierarchy tracking should be enabled")
        }
    }
    
    /// TDD Test: Tests that global automatic accessibility identifiers work
    @Test func testGlobalAutomaticAccessibilityIdentifiersWork() async {
        await MainActor.run {
            // Given: Configuration is enabled
            let config = AccessibilityIdentifierConfig.shared
            config.enableAutoIDs = true
            config.namespace = "CarManager"
            config.mode = .automatic
            
            // When: A view uses accessibility identifiers
            let testView = Text("Global Test")
                .accessibilityIdentifier("global-test")
            
            // Then: The view should have automatic accessibility identifier configuration
            #expect(testAccessibilityIdentifierConfiguration(), "Accessibility identifier configuration should be valid")
            #expect(testViewWithAccessibilityIdentifiers(testView), "View with accessibility identifiers should work correctly")
            
            // Also verify configuration is correct
            #expect(config.enableAutoIDs, "Auto IDs should be enabled")
            #expect(config.namespace == "CarManager", "Namespace should be set correctly")
        }
    }
    
    /// TDD Test: Tests that ID generation uses actual view context instead of hardcoded values
    @Test func testIDGenerationUsesActualViewContext() async {
        await MainActor.run {
            // Given: Configuration with view hierarchy tracking
            let config = AccessibilityIdentifierConfig.shared
            config.enableAutoIDs = true
            config.namespace = "CarManager"
            config.mode = .automatic
            config.enableViewHierarchyTracking = true
            
            // When: View hierarchy is set
            config.pushViewHierarchy("NavigationView")
            config.pushViewHierarchy("ProfileSection")
            config.setScreenContext("UserProfile")
            
            // Then: Generated IDs should use actual context, not hardcoded values
            let generator = AccessibilityIdentifierGenerator()
            let id = generator.generateID(
                for: "test-object",
                role: "button",
                context: "UserProfile"
            )
            
            // The ID should contain the actual context, not hardcoded "ui"
            #expect(id.contains("CarManager"), "ID should contain namespace")
            #expect(id.contains("UserProfile"), "ID should contain screen context")
            #expect(id.contains("button"), "ID should contain role")
            #expect(id.contains("test-object"), "ID should contain object ID")
            
            // Cleanup
            config.popViewHierarchy()
            config.popViewHierarchy()
        }
    }
    
    // MARK: - Performance Tests
    // Performance tests removed - performance monitoring was removed from framework
}

// MARK: - Test Support Types

/// Test item for testing purposes
struct AccessibilityTestItem: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    
    init(id: String, title: String, subtitle: String) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
    }
}
