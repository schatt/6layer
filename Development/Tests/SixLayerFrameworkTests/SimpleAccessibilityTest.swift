import XCTest
import SwiftUI
import ViewInspector
@testable import SixLayerFramework

/// Simple Test: Check if ANY accessibility identifier modifier is applied
@MainActor
final class SimpleAccessibilityTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
        config.namespace = "SimpleTest"
        config.mode = .automatic
        config.enableDebugLogging = true
        config.enableAutoIDs = true
    }
    
    override func tearDown() {
        super.tearDown()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
    }
    
    func testManualAccessibilityIdentifierWorks() {
        // Test manual accessibility identifier to make sure ViewInspector works
        let testView = Button("Test") { }
            .accessibilityIdentifier("manual-test-id")
        
        XCTAssertTrue(hasAccessibilityIdentifier(testView), "Manual accessibility identifier should work")
        print("✅ Manual accessibility identifier works")
    }
    
    func testAutomaticAccessibilityIdentifierModifierApplied() {
        // Test if the modifier is applied at all
        let testView = Button("Test") { }
            .automaticAccessibilityIdentifiers()
        
        // Check if ANY accessibility identifier modifier is present
        do {
            let inspectedView = try testView.inspect()
            let accessibilityID = try inspectedView.accessibilityIdentifier()
            print("🔍 Found accessibility ID: '\(accessibilityID)'")
            XCTAssertNotEqual(accessibilityID, "", "Should have some accessibility identifier")
        } catch {
            print("🔍 Error inspecting view: \(error)")
            XCTFail("Should be able to inspect view: \(error)")
        }
    }
    
    // MARK: - Helper Methods
    
    private func hasAccessibilityIdentifier<T: View>(_ view: T) -> Bool {
        do {
            let inspectedView = try view.inspect()
            // Try to find any accessibility identifier modifier
            return try inspectedView.accessibilityIdentifier() != ""
        } catch {
            return false
        }
    }
}
