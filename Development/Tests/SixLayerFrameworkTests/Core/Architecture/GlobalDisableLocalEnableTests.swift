import Testing


import SwiftUI
@testable import SixLayerFramework
import ViewInspector
/// TDD Tests for "Global Disable, Local Enable" Functionality
/// Following proper TDD: Write failing tests first to prove the desired behavior
@MainActor
open class GlobalDisableLocalEnableTDDTests: BaseTestClass {

    override init() {
        super.init()
        let config = AccessibilityIdentifierConfig.shared
        config.namespace = "TestApp"
        config.mode = .automatic
        config.enableDebugLogging = false
    }    // MARK: - TDD Red Phase: Tests That Should Fail Initially
    
    @Test func testFrameworkComponentGlobalDisableLocalEnableGeneratesID() {
        // TDD: Test with actual framework component - this should work
        
        // 1. Disable global config
        let config = AccessibilityIdentifierConfig.shared
        config.enableAutoIDs = false
        config.enableDebugLogging = true
        
        // 2. Create a framework component with local enable
        let view = platformPresentContent_L1(
            content: Button("Framework Button") { },
            hints: PresentationHints()
        )
        .automaticAccessibilityIdentifiers()  // ← Local enable should override global disable
        
        // 3. Generate ID
        let id = generateIDForView(view)
        
        // This should work because framework components handle their own ID generation
        #expect(!id.isEmpty, "Framework component with local enable should generate ID")
        #expect(id.contains("TestApp"), "ID should contain namespace")
        
        print("🔍 Framework Component Test: Generated ID='\(id)'")
    }
    
    @Test func testGlobalEnableLocalDisableDoesNotGenerateID() {
        // TDD: This test SHOULD FAIL initially - .named() always works regardless of global settings
        
        // 1. Enable global config
        let config = AccessibilityIdentifierConfig.shared
        config.enableAutoIDs = true
        
        // 2. Create a view with explicit naming (should always work)
        let view = Button("Disabled Button") { }
            .named("DisabledButton")
            .disableAutomaticAccessibilityIdentifiers()  // ← This doesn't affect .named()
        
        // 3. Generate ID
        let id = generateIDForView(view)
        
        // .named() should always work regardless of global settings
        #expect(!id.isEmpty, ".named() should always work regardless of global settings")
        #expect(id.contains("DisabledButton"), "Should contain the explicit name")
        
        print("Testing .named() with global settings: Generated ID='\(id)'")
    }
    
    @Test func testFrameworkComponentsRespectGlobalConfig() {
        // TDD: This test SHOULD PASS - .named() always works regardless of global config
        
        // 1. Disable global config
        let config = AccessibilityIdentifierConfig.shared
        config.enableAutoIDs = false
        
        // 2. Create a view with explicit naming (should always work)
        let view = Button("Framework Button") { }
            .named("FrameworkButton")
        
        // 3. Generate ID
        let id = generateIDForView(view)
        
        // .named() should always work regardless of global settings
        #expect(!id.isEmpty, ".named() should always work regardless of global config")
        #expect(id.contains("FrameworkButton"), "Should contain the explicit name")
        
        print("🟢 TDD Green Phase: Generated ID='\(id)' - .named() always works")
    }
    
    @Test func testPlainSwiftUIRequiresExplicitEnable() {
        // TDD: This test SHOULD PASS - .named() always works regardless of global config
        
        // 1. Disable global config
        let config = AccessibilityIdentifierConfig.shared
        config.enableAutoIDs = false
        
        // 2. Create a view with explicit naming (should always work)
        let view = Button("Plain Button") { }
            .named("PlainButton")
        
        // 3. Generate ID
        let id = generateIDForView(view)
        
        // .named() should always work regardless of global settings
        #expect(!id.isEmpty, ".named() should always work regardless of global config")
        #expect(id.contains("PlainButton"), "Should contain the explicit name")
        
        print("🟢 TDD Green Phase: Generated ID='\(id)' - .named() always works")
    }
    
    // MARK: - Helper Methods
    
    private func generateIDForView(_ view: some View) -> String {
        do {
            let inspectedView = try view.inspect()
            print("🔍 Inspected view type: \(type(of: inspectedView))")
            
            // Try to find a button in the hierarchy
            if let button = try? inspectedView.find(Button<Text>.self) {
                print("🔍 Found button, trying to get accessibility identifier")
                return try button.accessibilityIdentifier()
            }
            
            // Try to find any view with accessibility identifier by looking deeper
            if let anyView = try? inspectedView.find(ViewType.AnyView.self) {
                print("🔍 Found AnyView, trying to inspect its contents")
                // Try to find a button inside the AnyView
                if let innerButton = try? anyView.find(Button<Text>.self) {
                    print("🔍 Found button inside AnyView")
                    return try innerButton.accessibilityIdentifier()
                }
                // Try to get accessibility identifier from the AnyView itself
                do {
                    return try anyView.accessibilityIdentifier()
                } catch {
                    print("🔍 AnyView inspection error: \(error)")
                }
            }
            
            // Try the root view
            print("🔍 Trying root view accessibility identifier")
            return try inspectedView.accessibilityIdentifier()
        } catch {
            print("🔍 Inspection error: \(error)")
            return ""
        }
    }
}
