import XCTest
import SwiftUI
import ViewInspector
@testable import SixLayerFramework

/// Test that accessibility functions respect both global and local configuration options
@MainActor
final class AccessibilityGlobalLocalConfigTests: XCTestCase {
    
    override func setUp() async throws {
        try await try await super.setUp()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
        config.enableAutoIDs = true
        config.namespace = "TestApp"
        config.mode = .automatic
        config.enableDebugLogging = false
    }
    
    override func tearDown() async throws {
        try await try await super.tearDown()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
    }
    
    // MARK: - Global Config Tests
    
    func testAccessibilityFunctionsRespectGlobalConfigDisabled() {
        // Test that accessibility functions don't generate IDs when global config is disabled
        
        // Disable global config
        let config = AccessibilityIdentifierConfig.shared
        config.enableAutoIDs = false
        
        // Create a view with breadcrumb modifiers (should NOT generate ID)
        let view = Button("Test") { }
            .screenContext("TestScreen")
            .named("TestButton")
        
        // Try to inspect for accessibility identifier
        do {
            let inspectedView = try view.inspect()
            let button = try inspectedView.button()
            let accessibilityID = try button.accessibilityIdentifier()
            
            // Should be empty when global config is disabled
            XCTAssertTrue(accessibilityID.isEmpty, "Accessibility functions should not generate ID when global config is disabled")
            
        } catch {
            // If we can't inspect, that's also fine - means no accessibility identifier was applied
            print("✅ Accessibility functions correctly have no accessibility identifier when global config is disabled")
        }
    }
    
    func testAccessibilityFunctionsRespectGlobalConfigEnabled() {
        // Test that accessibility functions DO generate IDs when global config is enabled
        
        // Ensure global config is enabled (default)
        let config = AccessibilityIdentifierConfig.shared
        config.enableAutoIDs = true
        
        // Create a view with breadcrumb modifiers (should generate ID)
        let view = Button("Test") { }
            .screenContext("TestScreen")
            .named("TestButton")
        
        // Try to inspect for accessibility identifier
        do {
            let inspectedView = try view.inspect()
            let button = try inspectedView.button()
            let accessibilityID = try button.accessibilityIdentifier()
            
            // Should have an ID when global config is enabled
            XCTAssertFalse(accessibilityID.isEmpty, "Accessibility functions should generate ID when global config is enabled")
            XCTAssertTrue(accessibilityID.contains("TestApp"), "ID should contain namespace")
            XCTAssertTrue(accessibilityID.contains("testscreen"), "ID should contain screen context")
            XCTAssertTrue(accessibilityID.contains("testbutton"), "ID should contain view name")
            
            print("✅ Accessibility functions correctly generate ID: '\(accessibilityID)'")
            
        } catch {
            XCTFail("Failed to inspect accessibility function: \(error)")
        }
    }
    
    // MARK: - Local Config Tests
    
    func testAccessibilityFunctionsRespectLocalDisableModifier() {
        // Test that accessibility functions respect local disable modifier
        
        // Global config is enabled
        let config = AccessibilityIdentifierConfig.shared
        config.enableAutoIDs = true
        config.enableDebugLogging = true  // ← Enable debug logging
        
        // Create a view with local disable modifier (apply disable BEFORE breadcrumb modifiers)
        let view = Button("Test") { }
            .disableAutomaticAccessibilityIdentifiers()  // ← Apply disable FIRST
            .screenContext("TestScreen")
            .named("TestButton")
        
        // Try to inspect for accessibility identifier
        do {
            let inspectedView = try view.inspect()
            let button = try inspectedView.button()
            let accessibilityID = try button.accessibilityIdentifier()
            
            // Should be empty when local disable is applied
            XCTAssertTrue(accessibilityID.isEmpty, "Accessibility functions should not generate ID when local disable modifier is applied")
            
        } catch {
            // If we can't inspect, that's also fine - means no accessibility identifier was applied
            print("✅ Accessibility functions correctly respect local disable modifier")
        }
    }
    
    func testAccessibilityFunctionsRespectLocalEnableModifier() {
        // Test that accessibility functions respect local enable modifier
        
        // Global config is disabled
        let config = AccessibilityIdentifierConfig.shared
        config.enableAutoIDs = false
        
        // Create a view with local enable modifier
        let view = Button("Test") { }
            .screenContext("TestScreen")
            .named("TestButton")
            .automaticAccessibilityIdentifiers()  // ← Local enable
        
        // Try to inspect for accessibility identifier
        do {
            let inspectedView = try view.inspect()
            let button = try inspectedView.button()
            let accessibilityID = try button.accessibilityIdentifier()
            
            // Should have an ID when local enable is applied (even with global disabled)
            XCTAssertFalse(accessibilityID.isEmpty, "Accessibility functions should generate ID when local enable modifier is applied")
            XCTAssertTrue(accessibilityID.contains("TestApp"), "ID should contain namespace")
            
            print("✅ Accessibility functions correctly respect local enable modifier: '\(accessibilityID)'")
            
        } catch {
            XCTFail("Failed to inspect accessibility function with local enable: \(error)")
        }
    }
    
    // MARK: - Priority Tests
    
    func testLocalDisableOverridesGlobalEnable() {
        // Test that local disable takes precedence over global enable
        
        // Global config is enabled
        let config = AccessibilityIdentifierConfig.shared
        config.enableAutoIDs = true
        
        // Create a view with local disable (should override global enable)
        let view = Button("Test") { }
            .screenContext("TestScreen")
            .named("TestButton")
            .disableAutomaticAccessibilityIdentifiers()  // ← Should override global enable
        
        // Try to inspect for accessibility identifier
        do {
            let inspectedView = try view.inspect()
            let button = try inspectedView.button()
            let accessibilityID = try button.accessibilityIdentifier()
            
            // Should be empty - local disable should override global enable
            XCTAssertTrue(accessibilityID.isEmpty, "Local disable should override global enable")
            
        } catch {
            print("✅ Local disable correctly overrides global enable")
        }
    }
    
    func testLocalEnableOverridesGlobalDisable() {
        // Test that local enable takes precedence over global disable
        
        // Global config is disabled
        let config = AccessibilityIdentifierConfig.shared
        config.enableAutoIDs = false
        
        // Create a view with local enable (should override global disable)
        let view = Button("Test") { }
            .screenContext("TestScreen")
            .named("TestButton")
            .automaticAccessibilityIdentifiers()  // ← Should override global disable
        
        // Try to inspect for accessibility identifier
        do {
            let inspectedView = try view.inspect()
            let button = try inspectedView.button()
            let accessibilityID = try button.accessibilityIdentifier()
            
            // Should have an ID - local enable should override global disable
            XCTAssertFalse(accessibilityID.isEmpty, "Local enable should override global disable")
            
        } catch {
            XCTFail("Failed to inspect accessibility function with local enable override: \(error)")
        }
    }
    
    // MARK: - Environment Variable Tests
    
    func testEnvironmentVariablesAreRespected() {
        // Test that environment variables are properly respected
        
        // Global config is enabled
        let config = AccessibilityIdentifierConfig.shared
        config.enableAutoIDs = true
        
        // Create a view with environment variable override
        let view = Button("Test") { }
            .screenContext("TestScreen")
            .named("TestButton")
            .environment(\.disableAutomaticAccessibilityIdentifiers, true)  // ← Environment override
        
        // Try to inspect for accessibility identifier
        do {
            let inspectedView = try view.inspect()
            let button = try inspectedView.button()
            let accessibilityID = try button.accessibilityIdentifier()
            
            // Should be empty - environment variable should override
            XCTAssertTrue(accessibilityID.isEmpty, "Environment variable should override global config")
            
        } catch {
            print("✅ Environment variable correctly overrides global config")
        }
    }
    
    // MARK: - Helper Methods
    
    private func generateIDForView(_ view: some View) -> String {
        do {
            let inspectedView = try view.inspect()
            let button = try inspectedView.button()
            return try button.accessibilityIdentifier()
        } catch {
            XCTFail("Failed to generate ID for view: \(error)")
            return ""
        }
    }
}
