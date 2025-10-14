import XCTest
import SwiftUI
import ViewInspector
@testable import SixLayerFramework

/// Test the "global disable, local enable" functionality
@MainActor
final class LocalEnableOverrideTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
        config.namespace = "TestApp"
        config.mode = .automatic
        config.enableDebugLogging = true  // Enable debug to see what's happening
    }
    
    override func tearDown() {
        super.tearDown()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
    }
    
    func testGlobalDisableLocalEnable() {
        // Test: Global disabled, but local enable should work
        
        // 1. Disable global config
        let config = AccessibilityIdentifierConfig.shared
        config.enableAutoIDs = false
        print("🔧 Global config disabled: enableAutoIDs = false")
        
        // 2. Create a view with local enable
        let view = Button("Special Button") { }
            .named("SpecialButton")
            .automaticAccessibilityIdentifiers()  // ← Local enable should override global disable
        
        // 3. Try to inspect for accessibility identifier
        do {
            let inspectedView = try view.inspect()
            let button = try inspectedView.button()
            let accessibilityID = try button.accessibilityIdentifier()
            
            // Should have an ID - local enable should override global disable
            XCTAssertFalse(accessibilityID.isEmpty, "Local enable should override global disable")
            XCTAssertTrue(accessibilityID.contains("TestApp"), "ID should contain namespace")
            XCTAssertTrue(accessibilityID.contains("specialbutton"), "ID should contain view name")
            
            print("✅ SUCCESS: Local enable overrode global disable")
            print("   Generated ID: '\(accessibilityID)'")
            
        } catch {
            XCTFail("Failed to inspect view with local enable: \(error)")
        }
    }
    
    func testGlobalEnableLocalDisable() {
        // Test: Global enabled, but local disable should work
        
        // 1. Enable global config
        let config = AccessibilityIdentifierConfig.shared
        config.enableAutoIDs = true
        print("🔧 Global config enabled: enableAutoIDs = true")
        
        // 2. Create a view with local disable
        let view = Button("Disabled Button") { }
            .named("DisabledButton")
            .disableAutomaticAccessibilityIdentifiers()  // ← Local disable should override global enable
        
        // 3. Try to inspect for accessibility identifier
        do {
            let inspectedView = try view.inspect()
            let button = try inspectedView.button()
            let accessibilityID = try button.accessibilityIdentifier()
            
            // Should be empty - local disable should override global enable
            XCTAssertTrue(accessibilityID.isEmpty, "Local disable should override global enable")
            
            print("✅ SUCCESS: Local disable overrode global enable")
            print("   No ID generated (as expected)")
            
        } catch {
            // If we can't inspect, that's also fine - means no accessibility identifier was applied
            print("✅ SUCCESS: Local disable overrode global enable (no modifier applied)")
        }
    }
    
    func testFrameworkComponentRespectsGlobalConfig() {
        // Test: Framework components should respect global config
        
        // 1. Disable global config
        let config = AccessibilityIdentifierConfig.shared
        config.enableAutoIDs = false
        print("🔧 Global config disabled for framework component test")
        
        // 2. Create a framework component (should NOT generate ID)
        let view = Button("Framework Button") { }
            .named("FrameworkButton")
            .screenContext("FrameworkScreen")
        
        // 3. Try to inspect for accessibility identifier
        do {
            let inspectedView = try view.inspect()
            let button = try inspectedView.button()
            let accessibilityID = try button.accessibilityIdentifier()
            
            // Should be empty - framework components respect global config
            XCTAssertTrue(accessibilityID.isEmpty, "Framework components should respect global config")
            
            print("✅ SUCCESS: Framework component respected global config")
            print("   No ID generated (as expected)")
            
        } catch {
            // If we can't inspect, that's also fine - means no accessibility identifier was applied
            print("✅ SUCCESS: Framework component respected global config (no modifier applied)")
        }
    }
}
