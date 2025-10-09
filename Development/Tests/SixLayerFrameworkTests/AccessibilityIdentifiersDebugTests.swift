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
    
    func testDirectAutomaticAccessibilityIdentifiersWorks() {
        // Test .automaticAccessibilityIdentifiers() directly
        let testView = Button("Test") { }
            .automaticAccessibilityIdentifiers()
        
        XCTAssertTrue(hasAccessibilityIdentifier(AnyView(testView)), "Direct .automaticAccessibilityIdentifiers() should work")
        print("🔍 Testing direct .automaticAccessibilityIdentifiers()")
    }
    
    func testNamedModifierWorks() {
        // Test .named() modifier
        let testView = Button("Test") { }
            .named("TestButton")
            .automaticAccessibilityIdentifiers()
        
        XCTAssertTrue(hasAccessibilityIdentifier(AnyView(testView)), ".named() + .automaticAccessibilityIdentifiers() should work")
        print("🔍 Testing .named() + .automaticAccessibilityIdentifiers()")
    }
    
    func testAutomaticAccessibilityModifierWorks() {
        // Test AutomaticAccessibilityModifier directly
        let testView = Button("Test") { }
            .modifier(AutomaticAccessibilityModifier(
                accessibilityState: AccessibilitySystemState(),
                platform: .iOS
            ))
        
        XCTAssertTrue(hasAccessibilityIdentifier(AnyView(testView)), "AutomaticAccessibilityModifier should work")
        print("🔍 Testing AutomaticAccessibilityModifier directly")
    }
    
    func testAutomaticAccessibilityExtensionWorks() {
        // Test .automaticAccessibility() extension
        let testView = Button("Test") { }
            .automaticAccessibility()
        
        XCTAssertTrue(hasAccessibilityIdentifier(AnyView(testView)), ".automaticAccessibility() should work")
        print("🔍 Testing .automaticAccessibility() extension")
    }
    
    // MARK: - Helper Methods
    
    private func hasAccessibilityIdentifier(_ view: AnyView) -> Bool {
        do {
            let inspectedView = try view.inspect()
            // Try to find any accessibility identifier modifier
            return try inspectedView.accessibilityIdentifier() != ""
        } catch {
            return false
        }
    }
}
