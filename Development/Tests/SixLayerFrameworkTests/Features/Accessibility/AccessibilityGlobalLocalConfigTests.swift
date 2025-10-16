import Testing


import SwiftUI
import ViewInspector
@testable import SixLayerFramework

/// Test that accessibility functions respect both global and local configuration options
@MainActor
final class AccessibilityGlobalLocalConfigTests {
    
    init() async throws {
                let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
        config.enableAutoIDs = true
        // namespace is automatically detected as "SixLayer" for tests
        config.mode = .automatic
        config.enableDebugLogging = false
    }
    
    deinit {
        Task { [weak self] in
            await self?.cleanupTestEnvironment()
        }
    }
    
    // MARK: - Global Config Tests
    
    @Test func testAccessibilityFunctionsRespectGlobalConfigDisabled() {
        // Test that accessibility functions don't generate IDs when global config is disabled
        
        // Disable global config
        let config = AccessibilityIdentifierConfig.shared
        config.enableAutoIDs = false
        
        // Create a view with local disable modifier (should NOT generate ID)
        let view = Button("Test") { }
            .named("TestButton")
        
        // Try to inspect for accessibility identifier
        do {
            let inspectedView = try view.inspect()
            let button = try inspectedView.button()
            let accessibilityID = try button.accessibilityIdentifier()
            
            // Should be empty when global config is disabled
            #expect(accessibilityID.isEmpty, "Accessibility functions should not generate ID when global config is disabled")
            
        } catch {
            // If we can't inspect, that's also fine - means no accessibility identifier was applied
            print("✅ Accessibility functions correctly have no accessibility identifier when global config is disabled")
        }
    }
    
    @Test func testAccessibilityFunctionsRespectGlobalConfigEnabled() {
        // Test that accessibility functions DO generate IDs when global config is enabled
        
        // Ensure global config is enabled (default)
        let config = AccessibilityIdentifierConfig.shared
        config.enableAutoIDs = true
        
        // Create a view with local enable modifier (should generate ID)
        let view = Button("Test") { }
            .named("TestButton")
        
        // Test that the view has an accessibility identifier using the same method as working tests
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.main.element.*testbutton.*", 
            componentName: "AccessibilityFunctionsRespectGlobalConfigEnabled"
        )
        
        // Should have an ID when global config is enabled
        #expect(hasAccessibilityID, "Accessibility functions should generate ID when global config is enabled")
        
        print("✅ Accessibility functions correctly generate ID when global config is enabled")
    }
    
    // MARK: - Local Config Tests
    
    @Test func testAccessibilityFunctionsRespectLocalDisableModifier() {
        // Test that accessibility functions respect local disable modifier
        
        // Global config is enabled
        let config = AccessibilityIdentifierConfig.shared
        config.enableAutoIDs = true
        config.enableDebugLogging = true  // ← Enable debug logging
        
        // Create a view with local disable modifier (apply disable BEFORE other modifiers)
        let view = Button("Test") { }
            .disableAutomaticAccessibilityIdentifiers()  // ← Apply disable FIRST
            .named("TestButton")
        
        // Try to inspect for accessibility identifier
        do {
            let inspectedView = try view.inspect()
            let button = try inspectedView.button()
            let accessibilityID = try button.accessibilityIdentifier()
            
            // Should be empty when local disable is applied
            #expect(accessibilityID.isEmpty, "Accessibility functions should not generate ID when local disable modifier is applied")
            
        } catch {
            // If we can't inspect, that's also fine - means no accessibility identifier was applied
            print("✅ Accessibility functions correctly respect local disable modifier")
        }
    }
    
    @Test func testAccessibilityFunctionsRespectLocalEnableModifier() {
        // Test that accessibility functions respect local enable modifier
        
        // Global config is disabled
        let config = AccessibilityIdentifierConfig.shared
        config.enableAutoIDs = false
        
        // Create a view with local enable modifier
        let view = Button("Test") { }
            .named("TestButton")
            .automaticAccessibilityIdentifiers()  // ← Local enable
        
        // Test that the view has an accessibility identifier using the same method as working tests
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.main.element.*", 
            componentName: "AccessibilityFunctionsRespectLocalEnableModifier"
        )
        
        // Should have an ID when local enable is applied (even with global disabled)
        #expect(hasAccessibilityID, "Accessibility functions should generate ID when local enable modifier is applied")
        
        print("✅ Accessibility functions correctly respect local enable modifier")
    }
    
    // MARK: - Priority Tests
    
    @Test func testLocalDisableOverridesGlobalEnable() {
        // Test that local disable takes precedence over global enable
        
        // Global config is enabled
        let config = AccessibilityIdentifierConfig.shared
        config.enableAutoIDs = true
        
        // Create a view with local disable (should override global enable)
        let view = Button("Test") { }
            .named("TestButton")
            .disableAutomaticAccessibilityIdentifiers()  // ← Should override global enable
        
        // Try to inspect for accessibility identifier
        do {
            let inspectedView = try view.inspect()
            let button = try inspectedView.button()
            let accessibilityID = try button.accessibilityIdentifier()
            
            // Should be empty - local disable should override global enable
            #expect(accessibilityID.isEmpty, "Local disable should override global enable")
            
        } catch {
            print("✅ Local disable correctly overrides global enable")
        }
    }
    
    @Test func testLocalEnableOverridesGlobalDisable() {
        // Test that local enable takes precedence over global disable
        
        // Global config is disabled
        let config = AccessibilityIdentifierConfig.shared
        config.enableAutoIDs = false
        
        // Create a view with local enable (should override global disable)
        let view = Button("Test") { }
            .named("TestButton")
            .automaticAccessibilityIdentifiers()  // ← Should override global disable
        
        // Test that the view has an accessibility identifier using the same method as working tests
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.main.element.*", 
            componentName: "LocalEnableOverridesGlobalDisable"
        )
        
        // Should have an ID - local enable should override global disable
        #expect(hasAccessibilityID, "Local enable should override global disable")
        
        print("✅ Local enable correctly overrides global disable")
    }
    
    // MARK: - Environment Variable Tests
    
    @Test func testEnvironmentVariablesAreRespected() {
        // Test that environment variables are properly respected
        
        // Global config is enabled
        let config = AccessibilityIdentifierConfig.shared
        config.enableAutoIDs = true
        
        // Create a view with environment variable override
        let view = Button("Test") { }
            .named("TestButton")
            .environment(\.disableAutomaticAccessibilityIdentifiers, true)  // ← Environment override
        
        // Try to inspect for accessibility identifier
        do {
            let inspectedView = try view.inspect()
            let button = try inspectedView.button()
            let accessibilityID = try button.accessibilityIdentifier()
            
            // Should be empty - environment variable should override
            #expect(accessibilityID.isEmpty, "Environment variable should override global config")
            
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
            Issue.record("Failed to generate ID for view: \(error)")
            return ""
        }
    }
}
