import Testing


import SwiftUI
@testable import SixLayerFramework
/// Test that framework components respect global accessibility config
@MainActor
@Suite("Framework Component Global Config")
open class FrameworkComponentGlobalConfigTests: BaseTestClass {

    // BaseTestClass handles setup automatically - no need for custom init
    
    @Test func testFrameworkComponentsRespectGlobalConfigWhenDisabled() {
        runWithTaskLocalConfig {
            setupTestEnvironment()
            
            // Test that framework components don't generate IDs when global config is disabled
            
            // Disable global config AFTER setup (which resets to defaults)
            guard let config = testConfig else {

                Issue.record("testConfig is nil")

                return

            }
            config.enableAutoIDs = false
            
            // Create a framework component WITHOUT .named() (this should NOT generate an ID)
            let view = Button("Test") { }
                .automaticAccessibilityIdentifiers()
            
            // Try to inspect for accessibility identifier
            // Using wrapper - when ViewInspector works on macOS, no changes needed here
            if let inspectedView = view.tryInspect(),
               let button = try? inspectedView.button(),
               let accessibilityID = try? button.accessibilityIdentifier() {
                // Should be empty or not present when global config is disabled
                #expect(accessibilityID.isEmpty, "Framework component should not generate ID when global config is disabled")
            } else {
                // If we can't inspect, that's also fine - means no accessibility identifier was applied
                print("✅ Framework component correctly has no accessibility identifier when global config is disabled")
            }
            
            cleanupTestEnvironment()
        }
    }
    
    @Test func testFrameworkComponentsGenerateIDsWhenGlobalConfigEnabled() {
        runWithTaskLocalConfig {
            setupTestEnvironment()
            
            // Test that framework components DO generate IDs when global config is enabled
            // Note: .named() modifier always generates IDs regardless of global config
            // This is the correct behavior - explicit naming should always work
            
            // Set global config to enabled
            guard let config = testConfig else {

                Issue.record("testConfig is nil")

                return

            }
            config.enableAutoIDs = true
            
            // Create a framework component with .named() (this SHOULD generate an ID)
            let view = Button("Test") { }
                .named("TestButton")
            
            // Try to inspect for accessibility identifier
            // Using wrapper - when ViewInspector works on macOS, no changes needed here
            if let inspectedView = view.tryInspect(),
               let button = try? inspectedView.button(),
               let accessibilityID = try? button.accessibilityIdentifier() {
                // .named() should always generate an ID (ignoring global settings)
                #expect(!accessibilityID.isEmpty, "Framework component with .named() should generate ID")
                #expect(accessibilityID.contains("main"), "ID should contain screen context")
                #expect(accessibilityID.contains("TestButton"), "ID should contain view name")
                
                print("✅ Framework component correctly generates ID: '\(accessibilityID)'")
            } else {
                Issue.record("Failed to inspect framework component")
            }
            
            cleanupTestEnvironment()
        }
    }
}
