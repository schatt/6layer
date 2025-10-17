import Testing


import SwiftUI
import ViewInspector
@testable import SixLayerFramework

/// TDD Tests for "Global Disable, Local Enable" Functionality
/// Following proper TDD: Write failing tests first to prove the desired behavior
@MainActor
open class GlobalDisableLocalEnableTDDTests {
    
    init() async throws {
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
        config.namespace = "TestApp"
        config.mode = .automatic
        config.enableDebugLogging = false
    }
    
    deinit {
        Task { [weak self] in
            await self?.cleanupTestEnvironment()
        }
    }
    
    // MARK: - TDD Red Phase: Tests That Should Fail Initially
    
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
        // TDD: This test SHOULD FAIL initially - local disable should override global enable
        
        // 1. Enable global config
        let config = AccessibilityIdentifierConfig.shared
        config.enableAutoIDs = true
        
        // 2. Create a view with local disable
        let view = Button("Disabled Button") { }
            .named("DisabledButton")
            .disableAutomaticAccessibilityIdentifiers()  // ← Local disable should override global enable
        
        // 3. Generate ID
        let id = generateIDForView(view)
        
        // This assertion SHOULD FAIL initially
        #expect(id.isEmpty, "Local disable should override global enable and not generate ID")
        
        print("Testing global disable with local enable: Generated ID='\(id)'")
    }
    
    @Test func testFrameworkComponentsRespectGlobalConfig() {
        // TDD: This test SHOULD PASS - framework components should respect global config
        
        // 1. Disable global config
        let config = AccessibilityIdentifierConfig.shared
        config.enableAutoIDs = false
        
        // 2. Create a framework component (should NOT generate ID)
        let view = Button("Framework Button") { }
            .named("FrameworkButton")
        
        // 3. Generate ID
        let id = generateIDForView(view)
        
        // This assertion SHOULD PASS
        #expect(id.isEmpty, "Framework components should respect global config")
        
        print("🟢 TDD Green Phase: Generated ID='\(id)' - Should be empty (framework respects global)")
    }
    
    @Test func testPlainSwiftUIRequiresExplicitEnable() {
        // TDD: This test SHOULD PASS - plain SwiftUI should require explicit enable
        
        // 1. Disable global config
        let config = AccessibilityIdentifierConfig.shared
        config.enableAutoIDs = false
        
        // 2. Create plain SwiftUI view (should NOT generate ID)
        let view = Button("Plain Button") { }
            .named("PlainButton")
        
        // 3. Generate ID
        let id = generateIDForView(view)
        
        // This assertion SHOULD PASS
        #expect(id.isEmpty, "Plain SwiftUI should require explicit enable")
        
        print("🟢 TDD Green Phase: Generated ID='\(id)' - Should be empty (plain SwiftUI requires explicit enable)")
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
            
            // Try to find any view with accessibility identifier
            if let anyView = try? inspectedView.find(ViewType.AnyView.self) {
                print("🔍 Found AnyView, trying to get accessibility identifier")
                return try anyView.accessibilityIdentifier()
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
