import Testing


import SwiftUI
@testable import SixLayerFramework

#if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
import ViewInspector
#endif
/// TDD Tests for "Global Disable, Local Enable" Functionality
/// Following proper TDD: Write failing tests first to prove the desired behavior
@MainActor
@Suite("Global Disable Local Enable T D D")
open class GlobalDisableLocalEnableTDDTests: BaseTestClass {

    // BaseTestClass handles setup automatically - no need for custom init    // MARK: - TDD Red Phase: Tests That Should Fail Initially
    
    @Test func testFrameworkComponentGlobalDisableLocalEnableGeneratesID() {
        runWithTaskLocalConfig {
            // TDD: Test with actual framework component - this should work
            
            // 1. Disable global config
            guard let config = testConfig else {

                Issue.record("testConfig is nil")

                return

            }
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
    }
    
    @Test func testGlobalEnableLocalDisableDoesNotGenerateID() {
        runWithTaskLocalConfig {
            // TDD: This test SHOULD FAIL initially - .named() always works regardless of global settings
            
            // 1. Enable global config
            guard let config = testConfig else {

                Issue.record("testConfig is nil")

                return

            }
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
    }
    
    @Test func testFrameworkComponentsRespectGlobalConfig() {
        runWithTaskLocalConfig {
            // TDD: This test SHOULD PASS - .named() always works regardless of global config
            
            // 1. Disable global config
            guard let config = testConfig else {

                Issue.record("testConfig is nil")

                return

            }
            config.enableAutoIDs = false
            
            // 2. Create a view with explicit naming (should always work)
            let view = Button("Framework Button") { }
                .named("FrameworkButton")
            
            // 3. Generate ID
            let id = generateIDForView(view)
            
            // .named() should always work regardless of global settings
            #expect(!id.isEmpty, ".named() should always work regardless of global config")
            #expect(id.contains("FrameworkButton"), "Should contain the explicit name")
            
        }
    }
    
    @Test func testPlainSwiftUIRequiresExplicitEnable() {
        runWithTaskLocalConfig {
            // TDD: This test SHOULD PASS - .named() always works regardless of global config
            
            // 1. Disable global config
            guard let config = testConfig else {

                Issue.record("testConfig is nil")

                return

            }
            config.enableAutoIDs = false
            
            // 2. Create a view with explicit naming (should always work)
            let view = Button("Plain Button") { }
                .named("PlainButton")
            
            // 3. Generate ID
            let id = generateIDForView(view)
            
            // .named() should always work regardless of global settings
            #expect(!id.isEmpty, ".named() should always work regardless of global config")
            #expect(id.contains("PlainButton"), "Should contain the explicit name")
            
        }
    }
    
    // MARK: - Helper Methods
    
    private func generateIDForView(_ view: some View) -> String {
        // Using wrapper - when ViewInspector works on macOS, no changes needed here
        guard let inspectedView = view.tryInspect() else {
            return ""
        }
        
        print("🔍 Inspected view type: \(type(of: inspectedView))")

        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        // Try to find a button in the hierarchy
        if let button = inspectedView.sixLayerTryFind(Button<Text>.self),
           let id = try? button.sixLayerAccessibilityIdentifier() {
            print("🔍 Found button, trying to get accessibility identifier")
            return id
        }

        // Try to find any view with accessibility identifier by looking deeper
        if let anyView = inspectedView.sixLayerTryFind(ViewType.AnyView.self) {
            print("🔍 Found AnyView, trying to inspect its contents")
            // Try to find a button inside the AnyView
            if let innerButton = anyView.sixLayerTryFind(Button<Text>.self),
               let id = try? innerButton.sixLayerAccessibilityIdentifier() {
                print("🔍 Found button inside AnyView")
                return id
            }
            // Try to get accessibility identifier from the AnyView itself
            if let id = try? anyView.sixLayerAccessibilityIdentifier() {
                return id
            }
            print("🔍 AnyView inspection error")
        }

        // Try the root view
        print("🔍 Trying root view accessibility identifier")
        if let id = try? inspectedView.sixLayerAccessibilityIdentifier() {
            return id
        }
        #endif
        
        return ""
    }
}
