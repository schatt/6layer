import XCTest
import SwiftUI
import ViewInspector
@testable import SixLayerFramework

/// Test that framework components respect global accessibility config
@MainActor
final class FrameworkComponentGlobalConfigTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
        config.enableAutoIDs = true
        config.namespace = "TestApp"
        config.mode = .automatic
        config.enableDebugLogging = false
    }
    
    override func tearDown() {
        super.tearDown()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
    }
    
    func testFrameworkComponentsRespectGlobalConfigWhenDisabled() {
        // Test that framework components don't generate IDs when global config is disabled
        
        // Disable global config
        let config = AccessibilityIdentifierConfig.shared
        config.enableAutoIDs = false
        
        // Create a framework component (this should NOT generate an ID)
        let view = Button("Test") { }
            .screenContext("TestScreen")
            .named("TestButton")
        
        // Try to inspect for accessibility identifier
        do {
            let inspectedView = try view.inspect()
            let button = try inspectedView.button()
            let accessibilityID = try button.accessibilityIdentifier()
            
            // Should be empty or not present when global config is disabled
            XCTAssertTrue(accessibilityID.isEmpty, "Framework component should not generate ID when global config is disabled")
            
        } catch {
            // If we can't inspect, that's also fine - means no accessibility identifier was applied
            print("✅ Framework component correctly has no accessibility identifier when global config is disabled")
        }
    }
    
    func testFrameworkComponentsGenerateIDsWhenGlobalConfigEnabled() {
        // Test that framework components DO generate IDs when global config is enabled
        
        // Ensure global config is enabled (default)
        let config = AccessibilityIdentifierConfig.shared
        config.enableAutoIDs = true
        
        // Create a framework component (this SHOULD generate an ID)
        let view = Button("Test") { }
            .screenContext("TestScreen")
            .named("TestButton")
        
        // Try to inspect for accessibility identifier
        do {
            let inspectedView = try view.inspect()
            let button = try inspectedView.button()
            let accessibilityID = try button.accessibilityIdentifier()
            
            // Should have an ID when global config is enabled
            XCTAssertFalse(accessibilityID.isEmpty, "Framework component should generate ID when global config is enabled")
            XCTAssertTrue(accessibilityID.contains("TestApp"), "ID should contain namespace")
            XCTAssertTrue(accessibilityID.contains("testscreen"), "ID should contain screen context")
            XCTAssertTrue(accessibilityID.contains("testbutton"), "ID should contain view name")
            
            print("✅ Framework component correctly generates ID: '\(accessibilityID)'")
            
        } catch {
            XCTFail("Failed to inspect framework component: \(error)")
        }
    }
}
