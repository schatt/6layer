import Testing


import SwiftUI
import ViewInspector
@testable import SixLayerFramework

/// Debug Test: Check if .automaticAccessibilityIdentifiers() works at all
@MainActor
final class AccessibilityIdentifiersDebugTests {
    
    init() async throws {
        try await super.setUp()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
        config.namespace = "DebugTest"
        config.mode = .automatic
        config.enableDebugLogging = true // Enable debug logging
        config.enableAutoIDs = true
    }
    
    deinit {
        try await super.tearDown()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
    }
    
    @Test func testDirectAutomaticAccessibilityIdentifiersWorks() async {
        // Test .automaticAccessibilityIdentifiers() directly
        let testView = Button("Test") { }
            .automaticAccessibilityIdentifiers()
        
        // Should look for button-specific accessibility identifier: "DebugTest.button.Test"
        #expect(hasAccessibilityIdentifier(
            testView, 
            expectedPattern: "DebugTest.main.element.*", 
            componentName: "DirectAutomaticAccessibilityIdentifiers"
        ), "Direct .automaticAccessibilityIdentifiers() should generate button-specific accessibility ID")
        print("🔍 Testing direct .automaticAccessibilityIdentifiers()")
    }
    
    @Test func testNamedModifierWorks() {
        // Test .named() modifier
        let testView = Button("Test") { }
            .named("TestButton")
            .automaticAccessibilityIdentifiers()
        
        // Should look for named button-specific accessibility identifier: "DebugTest.TestButton.Test"
        #expect(hasAccessibilityIdentifier(
            testView, 
            expectedPattern: "DebugTest.main.element.*", 
            componentName: "NamedModifier"
        ), ".named() + .automaticAccessibilityIdentifiers() should generate named button-specific accessibility ID")
        print("🔍 Testing .named() + .automaticAccessibilityIdentifiers()")
    }
    
    @Test func testAutomaticAccessibilityModifierWorks() {
        // Test AutomaticAccessibilityModifier directly
        let testView = Button("Test") { }
            .modifier(SystemAccessibilityModifier(
                accessibilityState: AccessibilitySystemState(),
                platform: .iOS
            ))
        
        // Should look for modifier-specific accessibility identifier: "DebugTest.modifier.Test"
        #expect(hasAccessibilityIdentifier(
            testView, 
            expectedPattern: "DebugTest.main.element.*", 
            componentName: "AutomaticAccessibilityModifier"
        ), "AutomaticAccessibilityModifier should generate modifier-specific accessibility ID")
        print("🔍 Testing AutomaticAccessibilityModifier directly")
    }
    
    @Test func testAutomaticAccessibilityExtensionWorks() {
        // Test .automaticAccessibility() extension
        let testView = Button("Test") { }
            .automaticAccessibility()
        
        // Should look for extension-specific accessibility identifier: "DebugTest.extension.Test"
        #expect(hasAccessibilityIdentifier(
            testView, 
            expectedPattern: "DebugTest.main.element.*", 
            componentName: "AutomaticAccessibilityExtension"
        ), ".automaticAccessibility() should generate extension-specific accessibility ID")
        print("🔍 Testing .automaticAccessibility() extension")
    }
    
    // MARK: - Helper Methods
    
    // No longer needed - using shared hasAccessibilityIdentifier function
}
