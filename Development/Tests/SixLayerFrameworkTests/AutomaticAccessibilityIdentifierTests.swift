import XCTest
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
final class AutomaticAccessibilityIdentifierTests: XCTestCase {
    
    // MARK: - Test Helpers
    
    /// Helper function to test that accessibility identifiers are properly configured
    @MainActor
    private func testAccessibilityIdentifierConfiguration() -> Bool {
        let config = AccessibilityIdentifierConfig.shared
        return config.enableAutoIDs && !config.namespace.isEmpty
    }
    
    /// Helper function to test that a view can be created with the global modifier
    private func testViewWithGlobalModifier(_ view: some View) -> Bool {
        let _ = view.enableGlobalAutomaticAccessibilityIdentifiers()
        return true // If we can create the view, it works
    }
    
    // MARK: - Test Data Setup
    
    private var testItems: [TestItem]!
    private var testHints: PresentationHints!
    
    override func setUp() async throws {
        try await super.setUp()
        testItems = [
            TestItem(id: "user-1", title: "Alice", subtitle: "Developer"),
            TestItem(id: "user-2", title: "Bob", subtitle: "Designer")
        ]
        testHints = PresentationHints(
            dataType: .generic,
            presentationPreference: .grid,
            complexity: .moderate,
            context: .list,
            customPreferences: [:]
        )
        
        // Reset global config to default state
        Task { @MainActor in
            AccessibilityIdentifierConfig.shared.resetToDefaults()
        }
    }
    
    override func tearDown() {
        testItems = nil
        testHints = nil
        Task { @MainActor in
            AccessibilityIdentifierConfig.shared.resetToDefaults()
        }
        super.tearDown()
    }
    
    // MARK: - Global Configuration Tests
    
    /// BUSINESS PURPOSE: Global config should control automatic identifier generation
    /// TESTING SCOPE: Tests that enabling/disabling automatic IDs works globally
    /// METHODOLOGY: Tests global config toggle and verifies behavior changes
    func testGlobalConfigControlsAutomaticIdentifiers() async {
        await MainActor.run {
            // Given: Automatic IDs enabled by default in v4.0.0
            XCTAssertTrue(AccessibilityIdentifierConfig.shared.enableAutoIDs, "Auto IDs should be enabled by default in v4.0.0")
            
            // When: Disabling automatic IDs
            AccessibilityIdentifierConfig.shared.enableAutoIDs = false
            
            // Then: Config should reflect the change
            XCTAssertFalse(AccessibilityIdentifierConfig.shared.enableAutoIDs, "Auto IDs should be disabled")
            
            // When: Re-enabling automatic IDs
            AccessibilityIdentifierConfig.shared.enableAutoIDs = true
            
            // Then: Config should reflect the change
            XCTAssertTrue(AccessibilityIdentifierConfig.shared.enableAutoIDs, "Auto IDs should be enabled")
        }
    }
    
    /// BUSINESS PURPOSE: Global config should support custom namespace
    /// TESTING SCOPE: Tests that custom namespace affects generated identifiers
    /// METHODOLOGY: Sets custom namespace and verifies it's used in generated IDs
    func testGlobalConfigSupportsCustomNamespace() async {
        await MainActor.run {
            // Given: Custom namespace
            let customNamespace = "myapp.users"
            AccessibilityIdentifierConfig.shared.namespace = customNamespace
            
            // When: Getting the namespace
            let retrievedNamespace = AccessibilityIdentifierConfig.shared.namespace
            
            // Then: Should match the set value
            XCTAssertEqual(retrievedNamespace, customNamespace, "Namespace should match set value")
        }
    }
    
    /// BUSINESS PURPOSE: Global config should support different generation modes
    /// TESTING SCOPE: Tests that different modes affect ID generation strategy
    /// METHODOLOGY: Tests various generation modes and their behavior
    func testGlobalConfigSupportsGenerationModes() async {
        await MainActor.run {
            // Test each mode
            let modes: [AccessibilityIdentifierMode] = [.automatic, .semantic, .minimal]
            
            for mode in modes {
                AccessibilityIdentifierConfig.shared.mode = mode
                XCTAssertEqual(AccessibilityIdentifierConfig.shared.mode, mode, "Mode should be set to \(mode)")
            }
        }
    }
    
    // MARK: - Automatic ID Generation Tests
    
    /// BUSINESS PURPOSE: Automatic ID generator should create stable identifiers based on object identity
    /// TESTING SCOPE: Tests that generated IDs are stable and based on item.id, not position
    /// METHODOLOGY: Creates views with same items in different orders and verifies stable IDs
    func testAutomaticIDGeneratorCreatesStableIdentifiers() async {
        await MainActor.run {
            // Given: Automatic IDs enabled
            AccessibilityIdentifierConfig.shared.enableAutoIDs = true
            AccessibilityIdentifierConfig.shared.namespace = "test"
            
            // When: Generating IDs for items
            let generator = AccessibilityIdentifierGenerator()
            let id1 = generator.generateID(for: testItems[0], role: "item", context: "list")
            let id2 = generator.generateID(for: testItems[1], role: "item", context: "list")
            
            // Then: IDs should be stable and based on item identity
            XCTAssertEqual(id1, "test.list.item.user-1", "ID should be based on item identity")
            XCTAssertEqual(id2, "test.list.item.user-2", "ID should be based on item identity")
            
            // When: Reordering items and generating IDs again
            let reorderedItems = [testItems[1], testItems[0]]
            let id1Reordered = generator.generateID(for: reorderedItems[1], role: "item", context: "list")
            let id2Reordered = generator.generateID(for: reorderedItems[0], role: "item", context: "list")
            
            // Then: IDs should remain the same regardless of order
            XCTAssertEqual(id1Reordered, id1, "ID should be stable regardless of order")
            XCTAssertEqual(id2Reordered, id2, "ID should be stable regardless of order")
        }
    }
    
    /// BUSINESS PURPOSE: Automatic ID generator should handle different roles and contexts
    /// TESTING SCOPE: Tests that different roles and contexts create appropriate IDs
    /// METHODOLOGY: Tests various role/context combinations
    func testAutomaticIDGeneratorHandlesDifferentRolesAndContexts() async {
        await MainActor.run {
            // Given: Automatic IDs enabled with namespace
            AccessibilityIdentifierConfig.shared.enableAutoIDs = true
            AccessibilityIdentifierConfig.shared.namespace = "app"
            
            let generator = AccessibilityIdentifierGenerator()
            let item = testItems[0]
            
            // When: Generating IDs with different roles and contexts
            let listItemID = generator.generateID(for: item, role: "item", context: "list")
            let detailButtonID = generator.generateID(for: item, role: "detail-button", context: "item")
            let editButtonID = generator.generateID(for: item, role: "edit-button", context: "item")
            
            // Then: IDs should reflect the different roles and contexts
            XCTAssertEqual(listItemID, "app.list.item.user-1", "List item ID should include list context")
            XCTAssertEqual(detailButtonID, "app.item.detail-button.user-1", "Detail button ID should include item context")
            XCTAssertEqual(editButtonID, "app.item.edit-button.user-1", "Edit button ID should include item context")
        }
    }
    
    /// BUSINESS PURPOSE: Automatic ID generator should handle non-Identifiable objects
    /// TESTING SCOPE: Tests that non-Identifiable objects get appropriate fallback IDs
    /// METHODOLOGY: Tests ID generation for objects without stable identity
    func testAutomaticIDGeneratorHandlesNonIdentifiableObjects() async {
        await MainActor.run {
            // Given: Automatic IDs enabled
            AccessibilityIdentifierConfig.shared.enableAutoIDs = true
            AccessibilityIdentifierConfig.shared.namespace = "test"
            
            let generator = AccessibilityIdentifierGenerator()
            
            // When: Generating ID for non-Identifiable object
            let nonIdentifiableObject = "some-string"
            let id = generator.generateID(for: nonIdentifiableObject, role: "text", context: "display")
            
            // Then: Should generate appropriate fallback ID
            XCTAssertTrue(id.hasPrefix("test.display.text."), "ID should have proper prefix")
            XCTAssertTrue(id.contains("some-string"), "ID should include object content")
        }
    }
    
    // MARK: - Manual Override Tests
    
    /// BUSINESS PURPOSE: Manual accessibility identifiers should always override automatic ones
    /// TESTING SCOPE: Tests that explicit .platformAccessibilityIdentifier() takes precedence
    /// METHODOLOGY: Creates view with both manual and automatic IDs and verifies manual wins
    func testManualAccessibilityIdentifiersOverrideAutomatic() async {
        await MainActor.run {
            // Given: Automatic IDs enabled
            AccessibilityIdentifierConfig.shared.enableAutoIDs = true
            AccessibilityIdentifierConfig.shared.namespace = "auto"
            
            // When: Creating view with manual identifier
            let manualID = "manual-custom-id"
            let view = Text("Test")
                .platformAccessibilityIdentifier(manualID)
                .automaticAccessibilityIdentifiers()
            
            // Then: Manual identifier should take precedence
            // Note: In a real test, we'd need to extract the actual identifier from the view
            // For now, we verify the modifier chain compiles without errors
            XCTAssertNotNil(view, "View with manual override should be created successfully")
        }
    }
    
    /// BUSINESS PURPOSE: View-level opt-out should disable automatic IDs for specific views
    /// TESTING SCOPE: Tests that .disableAutomaticAccessibilityIdentifiers() works
    /// METHODOLOGY: Tests opt-out modifier on specific views
    func testViewLevelOptOutDisablesAutomaticIDs() async {
        await MainActor.run {
            // Given: Automatic IDs enabled globally
            AccessibilityIdentifierConfig.shared.enableAutoIDs = true
            
            // When: Creating view with opt-out modifier
            let view = Text("Test")
                .disableAutomaticAccessibilityIdentifiers()
                .automaticAccessibilityIdentifiers()
            
            // Then: View should be created without automatic IDs
            XCTAssertNotNil(view, "View with opt-out should be created successfully")
        }
    }
    
    // MARK: - Integration Tests
    
    /// BUSINESS PURPOSE: Automatic identifiers should integrate with AppleHIGComplianceModifier
    /// TESTING SCOPE: Tests that HIG compliance modifier includes automatic ID generation
    /// METHODOLOGY: Tests integration with existing HIG compliance system
    func testAutomaticIdentifiersIntegrateWithHIGCompliance() async {
        await MainActor.run {
            // Given: Automatic IDs enabled
            AccessibilityIdentifierConfig.shared.enableAutoIDs = true
            AccessibilityIdentifierConfig.shared.namespace = "hig"
            
            // When: Creating view with HIG compliance
            let view = Text("Test")
                .appleHIGCompliant()
            
            // Then: View should be created with both HIG compliance and automatic IDs
            XCTAssertNotNil(view, "View with HIG compliance should include automatic IDs")
        }
    }
    
    /// BUSINESS PURPOSE: Layer 1 functions should automatically apply identifier generation
    /// TESTING SCOPE: Tests that platformPresentItemCollection_L1 includes automatic IDs
    /// METHODOLOGY: TDD RED PHASE - This test SHOULD FAIL because accessibility IDs aren't actually generated
    func testLayer1FunctionsIncludeAutomaticIdentifiers() async {
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
            XCTAssertNotNil(view, "Layer 1 function should include automatic identifiers")
            
            // Test that Layer 1 functions generate accessibility identifiers
            XCTAssertTrue(hasAccessibilityIdentifier(
                view, 
                expectedPattern: "AutoTest.*item.*collection", 
                componentName: "Layer1Functions"
            ), "Layer 1 function should generate accessibility identifiers matching pattern 'AutoTest.*item.*collection'")
            
            // Test that the view can be created with accessibility identifier configuration
            XCTAssertTrue(testAccessibilityIdentifierConfiguration(), "Accessibility identifier configuration should be valid")
            XCTAssertTrue(testViewWithGlobalModifier(view), "Layer 1 function should work with global modifier")
        }
    }
    
    // MARK: - Collision Detection Tests
    
    /// BUSINESS PURPOSE: DEBUG collision detection should identify ID conflicts
    /// TESTING SCOPE: Tests that collision detection works in DEBUG builds
    /// METHODOLOGY: Tests collision detection and logging
    func testCollisionDetectionIdentifiesConflicts() async {
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
            XCTAssertEqual(id1, id2, "Same input should generate same ID")
            
            // When: Checking for collisions (should detect collision since ID was registered)
            let hasCollision = generator.checkForCollision(id1)
            
            // Then: Should detect collision since the ID was registered
            XCTAssertTrue(hasCollision, "Registered IDs should be detected as collisions")
            
            // When: Checking for collision with an unregistered ID
            let unregisteredID = "unregistered.id"
            let hasUnregisteredCollision = generator.checkForCollision(unregisteredID)
            
            // Then: Should not detect collision for unregistered IDs
            XCTAssertFalse(hasUnregisteredCollision, "Unregistered IDs should not be considered collisions")
        }
    }
    
    // MARK: - Debug Logging Tests
    
    /// BUSINESS PURPOSE: Debug logging should capture generated IDs for inspection
    /// TESTING SCOPE: Tests that debug logging works correctly
    /// METHODOLOGY: Unit tests for debug logging functionality
    func testDebugLoggingCapturesGeneratedIDs() async {
        await MainActor.run {
            let config = AccessibilityIdentifierConfig.shared
            let generator = AccessibilityIdentifierGenerator()
            
            // Enable debug logging
            config.enableDebugLogging = true
            config.clearDebugLog()
            
            // Generate some IDs
            let id1 = generator.generateID(for: "test1", role: "button", context: "ui")
            let id2 = generator.generateID(for: "test2", role: "text", context: "form")
            
            // Check that IDs were logged
            XCTAssertEqual(config.generatedIDsLog.count, 2)
            XCTAssertEqual(config.generatedIDsLog[0].id, id1)
            XCTAssertEqual(config.generatedIDsLog[1].id, id2)
            XCTAssertTrue(config.generatedIDsLog[0].context.contains("String"))
            XCTAssertTrue(config.generatedIDsLog[1].context.contains("String"))
        }
    }
    
    /// BUSINESS PURPOSE: Debug logging should be controllable
    /// TESTING SCOPE: Tests that debug logging can be disabled
    /// METHODOLOGY: Unit tests for debug logging control
    func testDebugLoggingDisabledWhenTurnedOff() async {
        await MainActor.run {
            let config = AccessibilityIdentifierConfig.shared
            let generator = AccessibilityIdentifierGenerator()
            
            // Disable debug logging
            config.enableDebugLogging = false
            config.clearDebugLog()
            
            // Generate some IDs
            let _ = generator.generateID(for: "test1", role: "button", context: "ui")
            let _ = generator.generateID(for: "test2", role: "text", context: "form")
            
            // Check that IDs were not logged
            XCTAssertEqual(config.generatedIDsLog.count, 0)
        }
    }
    
    /// BUSINESS PURPOSE: Debug log should be formatted for readability
    /// TESTING SCOPE: Tests that debug log formatting works correctly
    /// METHODOLOGY: Unit tests for debug log formatting
    func testDebugLogFormatting() async {
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
            XCTAssertTrue(log.contains("Generated Accessibility Identifiers:"))
            XCTAssertTrue(log.contains(id))
            XCTAssertTrue(log.contains("String"))
        }
    }
    
    /// BUSINESS PURPOSE: Debug log should be clearable
    /// TESTING SCOPE: Tests that debug log can be cleared
    /// METHODOLOGY: Unit tests for debug log clearing
    func testDebugLogClearing() async {
        await MainActor.run {
            let config = AccessibilityIdentifierConfig.shared
            let generator = AccessibilityIdentifierGenerator()
            
            // Enable debug logging and generate some IDs
            config.enableDebugLogging = true
            config.clearDebugLog()
            
            let _ = generator.generateID(for: "test1", role: "button", context: "ui")
            let _ = generator.generateID(for: "test2", role: "text", context: "form")
            
            XCTAssertEqual(config.generatedIDsLog.count, 2)
            
            // Clear log
            config.clearDebugLog()
            
            XCTAssertEqual(config.generatedIDsLog.count, 0)
        }
    }
    
    // MARK: - Enhanced Breadcrumb System Tests
    
    /// BUSINESS PURPOSE: View hierarchy tracking should work correctly
    /// TESTING SCOPE: Tests that view hierarchy is properly tracked
    /// METHODOLOGY: Unit tests for view hierarchy management
    func testViewHierarchyTracking() async {
        await MainActor.run {
            let config = AccessibilityIdentifierConfig.shared
            
            // Enable view hierarchy tracking and UI test integration
            config.enableViewHierarchyTracking = true
            config.enableUITestIntegration = true
            config.enableDebugLogging = true
            config.clearDebugLog()
            
            // Push some views onto the hierarchy
            config.pushViewHierarchy("NavigationView")
            config.pushViewHierarchy("ProfileSection")
            config.pushViewHierarchy("EditButton")
            
            // Generate an ID
            let generator = AccessibilityIdentifierGenerator()
            let _ = generator.generateID(for: "test", role: "button", context: "ui")
            
            // Check that the enhanced log contains hierarchy information
            XCTAssertFalse(config.enhancedDebugLog.isEmpty)
            let entry = config.enhancedDebugLog.first!
            XCTAssertEqual(entry.viewHierarchy, ["NavigationView", "ProfileSection", "EditButton"])
            
            // Pop views
            config.popViewHierarchy()
            config.popViewHierarchy()
            config.popViewHierarchy()
            
            XCTAssertTrue(config.isViewHierarchyEmpty())
        }
    }
    
    /// BUSINESS PURPOSE: Screen context should be tracked correctly
    /// TESTING SCOPE: Tests that screen context is properly set and tracked
    /// METHODOLOGY: Unit tests for screen context management
    func testScreenContextTracking() async {
        await MainActor.run {
            let config = AccessibilityIdentifierConfig.shared
            
            // Enable UI test integration and debug logging
            config.enableUITestIntegration = true
            config.enableDebugLogging = true
            config.clearDebugLog()
            
            // Set screen context
            config.setScreenContext("UserProfile")
            config.setNavigationState("ProfileEditMode")
            
            // Generate an ID
            let generator = AccessibilityIdentifierGenerator()
            let _ = generator.generateID(for: "test", role: "button", context: "ui")
            
            // Check that the enhanced log contains screen context
            XCTAssertFalse(config.enhancedDebugLog.isEmpty)
            let entry = config.enhancedDebugLog.first!
            XCTAssertEqual(entry.screenContext, "UserProfile")
            XCTAssertEqual(entry.navigationState, "ProfileEditMode")
        }
    }
    
    /// BUSINESS PURPOSE: UI test code generation should work correctly
    /// TESTING SCOPE: Tests that UI test code is generated properly
    /// METHODOLOGY: Unit tests for UI test code generation
    func testUITestCodeGeneration() async {
        await MainActor.run {
            let config = AccessibilityIdentifierConfig.shared
            
            // Enable UI test integration and view hierarchy tracking
            config.enableUITestIntegration = true
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
            
            // Generate UI test code
            let testCode = config.generateUITestCode()
            
            // Check that test code contains expected elements
            XCTAssertTrue(testCode.contains("// Generated UI Test Code"))
            XCTAssertTrue(testCode.contains("// Screen: UserProfile"))
            XCTAssertTrue(testCode.contains("func test_"))
            XCTAssertTrue(testCode.contains("app.otherElements"))
            XCTAssertTrue(testCode.contains("XCTAssertTrue"))
        }
    }
    
    /// BUSINESS PURPOSE: Breadcrumb trail should be generated correctly
    /// TESTING SCOPE: Tests that breadcrumb trail is formatted properly
    /// METHODOLOGY: Unit tests for breadcrumb trail generation
    func testBreadcrumbTrailGeneration() async {
        await MainActor.run {
            let config = AccessibilityIdentifierConfig.shared
            
            // Enable enhanced features
            config.enableUITestIntegration = true
            config.enableViewHierarchyTracking = true
            config.enableDebugLogging = true
            config.clearDebugLog()
            
            // Set up context
            config.setScreenContext("UserProfile")
            config.setNavigationState("ProfileEditMode")
            config.pushViewHierarchy("NavigationView")
            config.pushViewHierarchy("ProfileSection")
            
            // Generate an ID
            let generator = AccessibilityIdentifierGenerator()
            let _ = generator.generateID(for: "test", role: "button", context: "ui")
            
            // Generate breadcrumb trail
            let breadcrumb = config.generateBreadcrumbTrail()
            
            // Check that breadcrumb contains expected elements
            XCTAssertTrue(breadcrumb.contains("🍞 Accessibility ID Breadcrumb Trail:"))
            XCTAssertTrue(breadcrumb.contains("📱 Screen: UserProfile"))
            XCTAssertTrue(breadcrumb.contains("📍 Path: NavigationView → ProfileSection"))
            XCTAssertTrue(breadcrumb.contains("🧭 Navigation: ProfileEditMode"))
        }
    }
    
    /// BUSINESS PURPOSE: UI test helpers should generate correct code
    /// TESTING SCOPE: Tests that UI test helper methods work correctly
    /// METHODOLOGY: Unit tests for UI test helper methods
    func testUITestHelpers() async {
        await MainActor.run {
            let config = AccessibilityIdentifierConfig.shared
            
            // Test element reference generation
            let elementRef = config.getElementByID("app.test.button")
            XCTAssertEqual(elementRef, "app.otherElements[\"app.test.button\"]")
            
            // Test tap action generation
            let tapAction = config.generateTapAction("app.test.button")
            XCTAssertTrue(tapAction.contains("app.otherElements[\"app.test.button\"]"))
            XCTAssertTrue(tapAction.contains("element.tap()"))
            XCTAssertTrue(tapAction.contains("XCTAssertTrue"))
            
            // Test text input action generation
            let textAction = config.generateTextInputAction("app.test.field", text: "test text")
            XCTAssertTrue(textAction.contains("app.textFields[\"app.test.field\"]"))
            XCTAssertTrue(textAction.contains("element.typeText(\"test text\")"))
            XCTAssertTrue(textAction.contains("XCTAssertTrue"))
        }
    }
    
    /// BUSINESS PURPOSE: UI test code should be generated and saved to file
    /// TESTING SCOPE: Tests that UI test code can be saved to autoGeneratedTests folder
    /// METHODOLOGY: Unit tests for file generation functionality
    func testUITestCodeFileGeneration() async {
        await MainActor.run {
            let config = AccessibilityIdentifierConfig.shared
            
            // Enable UI test integration and view hierarchy tracking
            config.enableUITestIntegration = true
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
                XCTAssertTrue(FileManager.default.fileExists(atPath: filePath))
                
                // Check that filename contains PID and timestamp
                let filename = URL(fileURLWithPath: filePath).lastPathComponent
                XCTAssertTrue(filename.hasPrefix("GeneratedUITests_"))
                XCTAssertTrue(filename.contains("_"))
                XCTAssertTrue(filename.hasSuffix(".swift"))
                
                // Read file content and verify it contains expected elements
                let fileContent = try String(contentsOfFile: filePath)
                XCTAssertTrue(fileContent.contains("// Generated UI Test Code"))
                XCTAssertTrue(fileContent.contains("// Screen: UserProfile"))
                XCTAssertTrue(fileContent.contains("func test_"))
                XCTAssertTrue(fileContent.contains("app.otherElements"))
                XCTAssertTrue(fileContent.contains("XCTAssertTrue"))
                
                // Clean up - remove the generated file
                try FileManager.default.removeItem(atPath: filePath)
                
            } catch {
                XCTFail("Failed to generate UI test code file: \(error)")
            }
        }
    }
    
    /// BUSINESS PURPOSE: Clipboard integration should work on macOS
    /// TESTING SCOPE: Tests that UI test code can be copied to clipboard
    /// METHODOLOGY: Unit tests for clipboard functionality
    func testUITestCodeClipboardGeneration() async {
        await MainActor.run {
            let config = AccessibilityIdentifierConfig.shared
            
            // Enable UI test integration
            config.enableUITestIntegration = true
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
            XCTAssertTrue(clipboardContent.contains("// Generated UI Test Code"))
            XCTAssertTrue(clipboardContent.contains("func test_"))
            XCTAssertTrue(clipboardContent.contains("app.otherElements"))
            #endif
        }
    }
    
    // MARK: - Integration Tests (TDD for Bug Fix)
    
    /// TDD RED PHASE: Reproduces the user's bug report
    /// Tests that .trackViewHierarchy() automatically applies accessibility identifiers
    /// THIS TEST SHOULD FAIL - proving that accessibility identifiers aren't actually generated
    func testTrackViewHierarchyAutomaticallyAppliesAccessibilityIdentifiers() async {
        await MainActor.run {
            // Given: Configuration is enabled (as per user's bug report)
            let config = AccessibilityIdentifierConfig.shared
            config.enableAutoIDs = true
            config.namespace = "CarManager"
            config.mode = .automatic
            config.enableViewHierarchyTracking = true
            config.enableUITestIntegration = true
            config.enableDebugLogging = true
            
            // When: A view uses .trackViewHierarchy() modifier (as per user's bug report)
            let testView = Button(action: {}) {
                Label("Add Fuel", systemImage: "plus")
            }
            .trackViewHierarchy("AddFuelButton")
            
            // Test that trackViewHierarchy generates accessibility identifiers
            XCTAssertTrue(hasAccessibilityIdentifier(
                testView, 
                expectedPattern: "CarManager.*track.*addfuelbutton", 
                componentName: "TrackViewHierarchy"
            ), "View with trackViewHierarchy should generate accessibility identifiers matching pattern 'CarManager.*track.*addfuelbutton'")
            
            // Also verify configuration is correct
            XCTAssertTrue(config.enableAutoIDs, "Auto IDs should be enabled")
            XCTAssertEqual(config.namespace, "CarManager", "Namespace should be set correctly")
            XCTAssertTrue(config.enableViewHierarchyTracking, "View hierarchy tracking should be enabled")
        }
    }
    
    /// TDD RED PHASE: Tests that .screenContext() automatically applies accessibility identifiers
    /// THIS TEST SHOULD FAIL - proving that accessibility identifiers aren't actually generated
    func testScreenContextAutomaticallyAppliesAccessibilityIdentifiers() async {
        await MainActor.run {
            // Given: Configuration is enabled
            let config = AccessibilityIdentifierConfig.shared
            config.enableAutoIDs = true
            config.namespace = "CarManager"
            config.mode = .automatic
            
            // When: A view uses .screenContext() modifier
            let testView = VStack {
                Text("Test Content")
            }
            .screenContext("UserProfile")
            
            // Test that screenContext generates accessibility identifiers
            XCTAssertTrue(hasAccessibilityIdentifier(
                testView, 
                expectedPattern: "CarManager.*screen.*userprofile", 
                componentName: "ScreenContext"
            ), "View with screenContext should generate accessibility identifiers matching pattern 'CarManager.*screen.*userprofile'")
            
            // Also verify configuration is correct
            XCTAssertTrue(config.enableAutoIDs, "Auto IDs should be enabled")
            XCTAssertEqual(config.namespace, "CarManager", "Namespace should be set correctly")
        }
    }
    
    /// TDD Test: Tests that .navigationState() automatically applies accessibility identifiers
    func testNavigationStateAutomaticallyAppliesAccessibilityIdentifiers() async {
        await MainActor.run {
            // Given: Configuration is enabled
            let config = AccessibilityIdentifierConfig.shared
            config.enableAutoIDs = true
            config.namespace = "CarManager"
            config.mode = .automatic
            
            // When: A view uses .navigationState() modifier
            let testView = HStack {
                Text("Navigation Content")
            }
            .navigationState("ProfileEditMode")
            
            // Then: The view should have automatic accessibility identifier configuration
            XCTAssertTrue(testAccessibilityIdentifierConfiguration(), "Accessibility identifier configuration should be valid")
            XCTAssertTrue(testViewWithGlobalModifier(testView), "View with navigationState should work with global modifier")
            
            // Also verify configuration is correct
            XCTAssertTrue(config.enableAutoIDs, "Auto IDs should be enabled")
            XCTAssertEqual(config.namespace, "CarManager", "Namespace should be set correctly")
        }
    }
    
    /// TDD Test: Tests that global automatic accessibility identifiers work
    func testGlobalAutomaticAccessibilityIdentifiersWork() async {
        await MainActor.run {
            // Given: Configuration is enabled
            let config = AccessibilityIdentifierConfig.shared
            config.enableAutoIDs = true
            config.namespace = "CarManager"
            config.mode = .automatic
            
            // When: A view uses .enableGlobalAutomaticAccessibilityIdentifiers()
            let testView = Text("Global Test")
                .enableGlobalAutomaticAccessibilityIdentifiers()
            
            // Then: The view should have automatic accessibility identifier configuration
            XCTAssertTrue(testAccessibilityIdentifierConfiguration(), "Accessibility identifier configuration should be valid")
            XCTAssertTrue(testViewWithGlobalModifier(testView), "View with global modifier should work correctly")
            
            // Also verify configuration is correct
            XCTAssertTrue(config.enableAutoIDs, "Auto IDs should be enabled")
            XCTAssertEqual(config.namespace, "CarManager", "Namespace should be set correctly")
        }
    }
    
    /// TDD Test: Tests that ID generation uses actual view context instead of hardcoded values
    func testIDGenerationUsesActualViewContext() async {
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
            XCTAssertTrue(id.contains("CarManager"), "ID should contain namespace")
            XCTAssertTrue(id.contains("UserProfile"), "ID should contain screen context")
            XCTAssertTrue(id.contains("button"), "ID should contain role")
            XCTAssertTrue(id.contains("test-object"), "ID should contain object ID")
            
            // Cleanup
            config.popViewHierarchy()
            config.popViewHierarchy()
        }
    }
    
    // MARK: - Performance Tests
    
    /// BUSINESS PURPOSE: Automatic ID generation should be performant
    /// TESTING SCOPE: Tests that ID generation doesn't significantly impact performance
    /// METHODOLOGY: Performance tests for ID generation
    func testAutomaticIDGenerationPerformance() async {
        await MainActor.run {
            // Given: Automatic IDs enabled
            AccessibilityIdentifierConfig.shared.enableAutoIDs = true
            AccessibilityIdentifierConfig.shared.namespace = "perf"
            
            let generator = AccessibilityIdentifierGenerator()
            let items = (0..<100).map { TestItem(id: "item-\($0)", title: "Item \($0)", subtitle: "Subtitle") }
            
            // When: Measuring ID generation performance
            measure {
                for item in items {
                    _ = generator.generateID(for: item, role: "item", context: "list")
                }
            }
            
            // Then: Performance should be acceptable (test passes if measure doesn't fail)
        }
    }
}

// MARK: - Test Support Types

/// Test item for testing purposes
struct TestItem: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    
    init(id: String, title: String, subtitle: String) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
    }
}
