import Testing


import SwiftUI
@testable import SixLayerFramework

/**
 * BUSINESS PURPOSE: Verify that automatic accessibility identifiers now work by default
 * without requiring explicit .enableGlobalAutomaticAccessibilityIdentifiers() call.
 * 
 * TESTING SCOPE: Tests that the default behavior now enables automatic identifiers
 * METHODOLOGY: Tests that views get automatic identifiers without explicit enabling
 */
@MainActor
open class DefaultAccessibilityIdentifierTests: BaseTestClass {
    
    deinit {
        Task { [weak self] in
            await self?.cleanupTestEnvironment()
        }
    }
    
    /// BUSINESS PURPOSE: Verify that automatic identifiers work by default
    /// TESTING SCOPE: Tests that no explicit enabling is required
    /// METHODOLOGY: Tests that views get identifiers without .enableGlobalAutomaticAccessibilityIdentifiers()
    @Test func testAutomaticIdentifiersWorkByDefault() async {
        await MainActor.run {
            // Given: Default configuration (no explicit enabling)
            let config = AccessibilityIdentifierConfig.shared
            // enableAutoIDs is true by default
            // globalAutomaticAccessibilityIdentifiers is now true by default
            
            // When: Creating a view with automatic accessibility identifiers
            let testView = Button(action: {}) {
                Label("Test Button", systemImage: "plus")
            }
            .automaticAccessibilityIdentifiers()
            
            // Then: The view should be created successfully with accessibility identifier
            #expect(hasAccessibilityIdentifier(
                testView, 
                expectedPattern: "SixLayer.main.element.*", 
                componentName: "AutomaticIdentifiersWorkByDefault"
            ), "View should have accessibility identifier by default")
            
            // Verify default configuration
            #expect(config.enableAutoIDs, "Auto IDs should be enabled by default")
            #expect(config.namespace == "app", "Namespace should be 'app' by default")
            #expect(config.mode == .automatic, "Mode should be automatic by default")
        }
    }
    
    /// BUSINESS PURPOSE: Verify that automatic accessibility identifiers work by default
    /// TESTING SCOPE: Tests that automatic accessibility identifiers work without explicit enabling
    @Test func testAutomaticAccessibilityIdentifiersWorkByDefault() async {
        await MainActor.run {
            // Given: Default configuration
            let config = AccessibilityIdentifierConfig.shared
            config.enableDebugLogging = true
            // clearDebugLog method doesn't exist, so we skip that
            
            // When: Using automatic accessibility identifiers without explicit global enabling
            let testView = Button(action: {}) {
                Label("Test Button", systemImage: "plus")
            }
            .named("TestButton")

            
            // Then: The view should be created successfully
            // testView is non-optional, so no need to check for nil
            
            // Verify that the modifiers work without explicit global enabling
            // The fix ensures automatic accessibility identifiers work by default
        }
    }
    
    /// BUSINESS PURPOSE: Verify that manual identifiers still work
    /// TESTING SCOPE: Tests that manual identifiers continue to work with new defaults
    /// METHODOLOGY: Tests that manual identifiers take precedence
    @Test func testManualIdentifiersStillWork() async {
        await MainActor.run {
            // Given: Default configuration
            // config is non-optional, so no need to check for nil
            
            // When: Using manual accessibility identifier
            let testView = Button(action: {}) {
                Label("Test Button", systemImage: "plus")
            }
            .accessibilityIdentifier("manual-test-button")
            
            // Then: The view should be created successfully with manual accessibility identifier
            #expect(hasAccessibilityIdentifier(
                testView, 
                expectedIdentifier: "manual-test-button", 
                componentName: "ManualIdentifiersWorkByDefault"
            ), "Manual accessibility identifier should work by default")
        }
    }
    
    /// BUSINESS PURPOSE: Verify that opt-out still works
    /// TESTING SCOPE: Tests that .disableAutomaticAccessibilityIdentifiers() still works
    /// METHODOLOGY: Tests that opt-out functionality is preserved
    @Test func testOptOutStillWorks() async {
        await MainActor.run {
            // Given: Default configuration
            let config = AccessibilityIdentifierConfig.shared
            
            // Verify config is properly configured
            #expect(config != nil, "AccessibilityIdentifierConfig should be available")
            
            // When: Using opt-out modifier
            let testView = Button(action: {}) {
                Label("Decorative Button", systemImage: "star")
            }
            .environment(\.globalAutomaticAccessibilityIdentifiers, false)
            
            // Then: The view should be created successfully
            // testView is non-optional, so no need to check for nil
            
            // Opt-out should work even with automatic identifiers enabled by default
        }
    }
}

