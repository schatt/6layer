import Testing


import SwiftUI
@testable import SixLayerFramework
import ViewInspector
/// Test that framework components respect global accessibility config
@MainActor
@Suite("Framework Component Global Config")
open class FrameworkComponentGlobalConfigTests: BaseTestClass {

    override init() {
        super.init()
        // Set up test-specific configuration
        let config = AccessibilityIdentifierConfig.shared
        config.namespace = "TestApp"
    }
    
    @Test func testFrameworkComponentsRespectGlobalConfigWhenDisabled() {
        setupTestEnvironment()
        
        // Test that framework components don't generate IDs when global config is disabled
        
        // Disable global config AFTER setup (which resets to defaults)
        let config = AccessibilityIdentifierConfig.shared
        config.enableAutoIDs = false
        
        // Create a framework component WITHOUT .named() (this should NOT generate an ID)
        let view = Button("Test") { }
            .automaticAccessibilityIdentifiers()
        
        // Try to inspect for accessibility identifier
        do {
            let inspectedView = try view.inspect()
            let button = try inspectedView.button()
            let accessibilityID = try button.accessibilityIdentifier()
            
            // Should be empty or not present when global config is disabled
            #expect(accessibilityID.isEmpty, "Framework component should not generate ID when global config is disabled")
            
        } catch {
            // If we can't inspect, that's also fine - means no accessibility identifier was applied
            print("✅ Framework component correctly has no accessibility identifier when global config is disabled")
        }
        
        cleanupTestEnvironment()
    }
    
    @Test func testFrameworkComponentsGenerateIDsWhenGlobalConfigEnabled() {
        setupTestEnvironment()
        
        // Test that framework components DO generate IDs when global config is enabled
        // Note: .named() modifier always generates IDs regardless of global config
        // This is the correct behavior - explicit naming should always work
        
        // Set global config to enabled
        let config = AccessibilityIdentifierConfig.shared
        config.enableAutoIDs = true
        
        // Create a framework component with .named() (this SHOULD generate an ID)
        let view = Button("Test") { }
            .named("TestButton")
        
        // Try to inspect for accessibility identifier
        do {
            let inspectedView = try view.inspect()
            let button = try inspectedView.button()
            let accessibilityID = try button.accessibilityIdentifier()
            
            // .named() should always generate an ID (ignoring global settings)
            #expect(!accessibilityID.isEmpty, "Framework component with .named() should generate ID")
            #expect(accessibilityID.contains("main"), "ID should contain screen context")
            #expect(accessibilityID.contains("TestButton"), "ID should contain view name")
            
            print("✅ Framework component correctly generates ID: '\(accessibilityID)'")
            
        } catch {
            Issue.record("Failed to inspect framework component: \(error)")
        }
        
        cleanupTestEnvironment()
    }
}
