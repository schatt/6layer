import Testing


import SwiftUI
import ViewInspector
@testable import SixLayerFramework

/// Simple Test: Check if ANY accessibility identifier modifier is applied
@MainActor
open class SimpleAccessibilityTest: BaseTestClass {@Test func testManualAccessibilityIdentifierWorks() {
        // Test manual accessibility identifier to make sure ViewInspector works
        let testView = Button("Test") { }
            .accessibilityIdentifier("manual-test-id")
        
        #expect(hasAccessibilityIdentifier(
            testView, 
            expectedIdentifier: "manual-test-id", 
            componentName: "ManualAccessibilityIdentifier"
        ), "Manual accessibility identifier should work")
        print("✅ Manual accessibility identifier works")
    }
    
    @Test func testAutomaticAccessibilityIdentifierModifierApplied() {
        // Test if the modifier is applied at all
        let testView = Button("Test") { }
            .automaticAccessibilityIdentifiers()
        
        // Should look for automatic accessibility identifier: "SimpleTest.button.Test"
        #expect(hasAccessibilityIdentifier(
            testView, 
            expectedPattern: "SimpleTest.main.element.*", 
            componentName: "AutomaticAccessibilityIdentifierModifier"
        ), "Should have some accessibility identifier")
        
        // Check if ANY accessibility identifier modifier is present
        do {
            let inspectedView = try testView.inspect()
            let accessibilityID = try inspectedView.accessibilityIdentifier()
            print("🔍 Found accessibility ID: '\(accessibilityID)'")
            #expect(accessibilityID != "", "Should have some accessibility identifier")
        } catch {
            print("🔍 Error inspecting view: \(error)")
            Issue.record("Should be able to inspect view: \(error)")
        }
    }
    
    // MARK: - Helper Methods
    
    // No longer needed - using shared hasAccessibilityIdentifier function
}
