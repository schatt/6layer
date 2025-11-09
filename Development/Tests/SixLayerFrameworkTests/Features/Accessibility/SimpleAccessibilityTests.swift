import Testing


import SwiftUI
@testable import SixLayerFramework
/// Simple Test: Check if ANY accessibility identifier modifier is applied
@MainActor
@Suite("Simple Accessibility")
open class SimpleAccessibilityTest: BaseTestClass {    @Test func testFrameworkComponentWithNamedModifier() {
        // Test that framework components work with .named() modifier
        let testView = platformPresentContent_L1(
            content: "Test Content",
            hints: PresentationHints()
        )
        .named("test-component")
        
        #expect(testAccessibilityIdentifiersSinglePlatform(
            testView, 
            expectedPattern: "*.main.ui.test-component", 
            platform: SixLayerPlatform.iOS,
            componentName: "FrameworkComponentWithNamedModifier"
        ), "Framework component with .named() should generate correct ID")
    }
    
    @Test func testAutomaticAccessibilityIdentifierModifierApplied() {
        // Test that framework components automatically apply accessibility identifiers
        let testView = platformPresentBasicValue_L1(
            value: 42,
            hints: PresentationHints()
        )
        
        // Framework component should automatically generate accessibility identifier
        #expect(testAccessibilityIdentifiersSinglePlatform(
            testView, 
            expectedPattern: "SixLayer.main.ui.*", 
            platform: SixLayerPlatform.iOS,
            componentName: "platformPresentBasicValue_L1"
        ), "Framework component should automatically generate accessibility identifiers")
        
        // Check if accessibility identifier is present
        // Using wrapper - when ViewInspector works on macOS, no changes needed here
        #if canImport(ViewInspector) && !os(macOS)
        if let inspectedView = testView.tryInspect(),
           let accessibilityID = try? inspectedView.accessibilityIdentifier() {
            print("🔍 Found accessibility ID: '\(accessibilityID)'")
            #expect(accessibilityID != "", "Framework component should have accessibility identifier")
        } else {
            print("🔍 Error inspecting view")
            Issue.record("Should be able to inspect framework component")
        }
        #else
        Issue.record("ViewInspector not available on this platform (likely macOS)")
        #endif
    }
    
    // MARK: - Helper Methods
    
    // No longer needed - using shared hasAccessibilityIdentifier function
}
