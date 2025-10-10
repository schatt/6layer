import XCTest
import SwiftUI
import ViewInspector
@testable import SixLayerFramework

/// Debug Test: Check if .automaticAccessibilityIdentifiers() works at all
@MainActor
final class AccessibilityIdentifiersDebugTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
        config.namespace = "DebugTest"
        config.mode = .automatic
        config.enableDebugLogging = true // Enable debug logging
        config.enableAutoIDs = true
    }
    
    override func tearDown() {
        super.tearDown()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
    }
    
    func testDirectAutomaticAccessibilityIdentifiersWorks() async {
        // Test .automaticAccessibilityIdentifiers() directly
        let testView = Button("Test") { }
            .automaticAccessibilityIdentifiers()
        
        // Should look for button-specific accessibility identifier: "DebugTest.button.Test"
        XCTAssertTrue(hasAccessibilityIdentifier(
            testView, 
            expectedPattern: "DebugTest.*button.*Test", 
            componentName: "DirectAutomaticAccessibilityIdentifiers"
        ), "Direct .automaticAccessibilityIdentifiers() should generate button-specific accessibility ID")
        print("🔍 Testing direct .automaticAccessibilityIdentifiers()")
    }
    
    func testNamedModifierWorks() {
        // Test .named() modifier
        let testView = Button("Test") { }
            .named("TestButton")
            .automaticAccessibilityIdentifiers()
        
        // Should look for named button-specific accessibility identifier: "DebugTest.TestButton.Test"
        XCTAssertTrue(hasAccessibilityIdentifier(
            testView, 
            expectedPattern: "DebugTest.*TestButton.*Test", 
            componentName: "NamedModifier"
        ), ".named() + .automaticAccessibilityIdentifiers() should generate named button-specific accessibility ID")
        print("🔍 Testing .named() + .automaticAccessibilityIdentifiers()")
    }
    
    func testAutomaticAccessibilityModifierWorks() {
        // Test AutomaticAccessibilityModifier directly
        let testView = Button("Test") { }
            .modifier(SystemAccessibilityModifier(
                accessibilityState: AccessibilitySystemState(),
                platform: .iOS
            ))
        
        // Should look for modifier-specific accessibility identifier: "DebugTest.modifier.Test"
        XCTAssertTrue(hasAccessibilityIdentifier(
            testView, 
            expectedPattern: "DebugTest.*modifier.*Test", 
            componentName: "AutomaticAccessibilityModifier"
        ), "AutomaticAccessibilityModifier should generate modifier-specific accessibility ID")
        print("🔍 Testing AutomaticAccessibilityModifier directly")
    }
    
    func testAutomaticAccessibilityExtensionWorks() {
        // Test .automaticAccessibility() extension
        let testView = Button("Test") { }
            .automaticAccessibility()
        
        // Should look for extension-specific accessibility identifier: "DebugTest.extension.Test"
        XCTAssertTrue(hasAccessibilityIdentifier(
            testView, 
            expectedPattern: "DebugTest.*extension.*Test", 
            componentName: "AutomaticAccessibilityExtension"
        ), ".automaticAccessibility() should generate extension-specific accessibility ID")
        print("🔍 Testing .automaticAccessibility() extension")
    }
    
    // MARK: - Helper Methods
    
    // No longer needed - using shared hasAccessibilityIdentifier function
}
