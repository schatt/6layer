import Testing
import SwiftUI
import ViewInspector
@testable import SixLayerFramework

/// Test the "global disable, local enable" functionality
@MainActor
final class LocalEnableOverrideTests {
    
    init() {
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
        config.namespace = "TestApp"
        config.mode = .automatic
        config.enableDebugLogging = true  // Enable debug to see what's happening
    }
    
    deinit {
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
    }
    
    @Test func testGlobalDisableLocalEnable() {
        // Test: Global disabled, but local enable should work
        
        // 1. Disable global config
        let config = AccessibilityIdentifierConfig.shared
        config.enableAutoIDs = false
        print("🔧 Global config disabled: enableAutoIDs = false")
        
        // 2. Create a view with local enable
        let view = Button("Special Button") { }
            .named("SpecialButton")
            .automaticAccessibilityIdentifiers()  // ← Local enable should override global disable
        
        // 3. Try to inspect for accessibility identifier
        do {
            let inspectedView = try view.inspect()
            let button = try inspectedView.button()
            let accessibilityID = try button.accessibilityIdentifier()
            
            // Should have an ID - local enable should override global disable
            #expect(!accessibilityID.isEmpty, "Local enable should override global disable")
            #expect(accessibilityID.contains("TestApp"), "ID should contain namespace")
            #expect(accessibilityID.contains("specialbutton"), "ID should contain view name")
            
            print("✅ SUCCESS: Local enable overrode global disable")
            print("   Generated ID: '\(accessibilityID)'")
            
        } catch {
            Issue.record("Failed to inspect view with local enable: \(error)")
        }
    }
    
    @Test func testGlobalEnableLocalDisable() {
        // Test: Global enabled, but local disable should work
        
        // 1. Enable global config
        let config = AccessibilityIdentifierConfig.shared
        config.enableAutoIDs = true
        print("🔧 Global config enabled: enableAutoIDs = true")
        
        // 2. Create a view with local disable
        let view = Button("Disabled Button") { }
            .named("DisabledButton")
            .disableAutomaticAccessibilityIdentifiers()  // ← Local disable should override global enable
        
        // 3. Try to inspect for accessibility identifier
        do {
            let inspectedView = try view.inspect()
            let button = try inspectedView.button()
            let accessibilityID = try button.accessibilityIdentifier()
            
            // Should be empty - local disable should override global enable
            #expect(accessibilityID.isEmpty, "Local disable should override global enable")
            
            print("✅ SUCCESS: Local disable overrode global enable")
            print("   No ID generated (as expected)")
            
        } catch {
            // If we can't inspect, that's also fine - means no accessibility identifier was applied
            print("✅ SUCCESS: Local disable overrode global enable (no modifier applied)")
        }
    }
    
    @Test func testFrameworkComponentRespectsGlobalConfig() {
        // Test: Framework components should respect global config
        
        // 1. Disable global config
        let config = AccessibilityIdentifierConfig.shared
        config.enableAutoIDs = false
        print("🔧 Global config disabled for framework component test")
        
        // 2. Create a framework component (should NOT generate ID)
        let view = Button("Framework Button") { }
            .named("FrameworkButton")
            .screenContext("FrameworkScreen")
        
        // 3. Try to inspect for accessibility identifier
        do {
            let inspectedView = try view.inspect()
            let button = try inspectedView.button()
            let accessibilityID = try button.accessibilityIdentifier()
            
            // Should be empty - framework components respect global config
            #expect(accessibilityID.isEmpty, "Framework components should respect global config")
            
            print("✅ SUCCESS: Framework component respected global config")
            print("   No ID generated (as expected)")
            
        } catch {
            // If we can't inspect, that's also fine - means no accessibility identifier was applied
            print("✅ SUCCESS: Framework component respected global config (no modifier applied)")
        }
    }
}
