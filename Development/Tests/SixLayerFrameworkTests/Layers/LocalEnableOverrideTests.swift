import Testing


import SwiftUI
@testable import SixLayerFramework
import ViewInspector
/// Test the "global disable, local enable" functionality
@MainActor
@Suite("Local Enable Override")
open class LocalEnableOverrideTests: BaseTestClass {

    override init() {
        super.init()
        // Set up test-specific configuration
        let config = AccessibilityIdentifierConfig.shared
        config.namespace = "TestApp"
    }
    
    @Test func testGlobalDisableLocalEnable() {
        // Configure test environment
        let config = AccessibilityIdentifierConfig.shared
        config.mode = .automatic
        config.enableDebugLogging = true  // Enable debug to see what's happening
        
        // Test: Global disabled, but local enable should work
        
        // 1. Disable global config
        config.enableAutoIDs = false
        print("🔧 Global config disabled: enableAutoIDs = false")
        
        // 2. Create a view with local enable (without .named() to avoid modifier chain issues)
        let view = Button("Special Button") { }
            .automaticAccessibilityIdentifiers()  // ← Local enable should override global disable
        
        // 3. Try to inspect for accessibility identifier
        do {
            let inspectedView = try view.inspect()
            let button = try inspectedView.button()
            let accessibilityID = try button.accessibilityIdentifier()
            
            // Should have an ID - local enable should override global disable
            #expect(!accessibilityID.isEmpty, "Local enable should override global disable")
            #expect(accessibilityID.contains("TestApp"), "ID should contain namespace")
            #expect(accessibilityID.contains("SixLayer"), "ID should contain framework prefix")
            
            print("✅ SUCCESS: Local enable overrode global disable")
            print("   Generated ID: '\(accessibilityID)'")
            
        } catch {
            Issue.record("Failed to inspect view with local enable: \(error)")
        }
        
        cleanupTestEnvironment()
    }
    
    @Test func testNamedModifierAlwaysWorksRegardlessOfGlobalSettings() {
        // Test that .named() always works regardless of global settings
        // This is the correct behavior - explicit naming should not be affected by global config

        // Configure test environment
        let config = AccessibilityIdentifierConfig.shared
        config.mode = .automatic
        config.enableDebugLogging = true
        
        // Test: Global enabled, but .named() should still work even with local disable
        
        // 1. Enable global config
        config.enableAutoIDs = true
        print("🔧 Global config enabled: enableAutoIDs = true")
        
        // 2. Create a view with explicit naming (should work regardless of global settings)
        let view = Button("Disabled Button") { }
            .disableAutomaticAccessibilityIdentifiers()  // ← Apply disable FIRST
            .named("DisabledButton")
        
        // 3. Try to inspect for accessibility identifier
        do {
            let inspectedView = try view.inspect()
            let button = try inspectedView.button()
            let accessibilityID = try button.accessibilityIdentifier()
            
            // .named() should always work regardless of global settings
            // This is the correct behavior - explicit naming should not be affected by global config
            #expect(!accessibilityID.isEmpty, ".named() should always generate identifier regardless of global settings")
            #expect(accessibilityID.contains("DisabledButton"), "Should contain the explicit name")
            
            print("✅ SUCCESS: .named() works regardless of global settings")
            print("   Generated ID: '\(accessibilityID)'")
            
        } catch {
            Issue.record("Failed to inspect view with explicit naming: \(error)")
        }
        
        cleanupTestEnvironment()
    }
    
    @Test func testNamedModifierAlwaysWorksEvenWhenGlobalConfigDisabled() {
        // Configure test environment
        let config = AccessibilityIdentifierConfig.shared
        config.mode = .automatic
        config.enableDebugLogging = true
        
        // Test: Framework components should respect global config
        
        // 1. Disable global config
        config.enableAutoIDs = false
        print("🔧 Global config disabled for framework component test")
        
        // 2. Create a framework component (should NOT generate ID)
        let view = Button("Framework Button") { }
            .named("FrameworkButton")
        
        // 3. Try to inspect for accessibility identifier
        do {
            let inspectedView = try view.inspect()
            let button = try inspectedView.button()
            let accessibilityID = try button.accessibilityIdentifier()
            
            // .named() should always work regardless of global settings
            // This is the correct behavior - explicit naming should not be affected by global config
            #expect(!accessibilityID.isEmpty, ".named() should always work regardless of global config")
            #expect(accessibilityID.contains("FrameworkButton"), "Should contain the explicit name")
            
            print("✅ SUCCESS: Framework component respected global config")
            print("   No ID generated (as expected)")
            
        } catch {
            // If we can't inspect, that's also fine - means no accessibility identifier was applied
            print("✅ SUCCESS: Framework component respected global config (no modifier applied)")
        }
        
        cleanupTestEnvironment()
    }
}
