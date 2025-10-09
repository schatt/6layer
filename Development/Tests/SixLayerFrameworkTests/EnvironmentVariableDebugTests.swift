import XCTest
import SwiftUI
import ViewInspector
@testable import SixLayerFramework

/// Debug test to understand environment variable propagation
@MainActor
final class EnvironmentVariableDebugTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
        config.namespace = "TestApp"
        config.mode = .automatic
        config.enableDebugLogging = true
    }
    
    override func tearDown() {
        super.tearDown()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
    }
    
    func testEnvironmentVariablePropagation() {
        // Test: Does the environment variable get set properly?
        
        // 1. Disable global config
        let config = AccessibilityIdentifierConfig.shared
        config.enableAutoIDs = false
        print("🔧 Global config disabled: enableAutoIDs = false")
        
        // 2. Create a view with automaticAccessibilityIdentifiers modifier
        let view = Button("Test") { }
            .automaticAccessibilityIdentifiers()  // ← This should set autoIDsEnabled = true
        
        // 3. Try to inspect for accessibility identifier
        do {
            let inspectedView = try view.inspect()
            let button = try inspectedView.button()
            let accessibilityID = try button.accessibilityIdentifier()
            
            print("🔍 Generated ID: '\(accessibilityID)'")
            
            if accessibilityID.isEmpty {
                print("❌ FAILED: No ID generated - environment variable not working")
                XCTFail("Environment variable not working - no ID generated")
            } else {
                print("✅ SUCCESS: Environment variable working - ID generated")
            }
            
        } catch {
            print("❌ FAILED: Could not inspect view: \(error)")
            XCTFail("Could not inspect view: \(error)")
        }
    }
    
    func testDirectEnvironmentVariableSetting() {
        // Test: Does setting the environment variable directly work?
        
        // 1. Disable global config
        let config = AccessibilityIdentifierConfig.shared
        config.enableAutoIDs = false
        print("🔧 Global config disabled: enableAutoIDs = false")
        
        // 2. Create a view with direct environment variable setting
        let view = Button("Test") { }
            .environment(\.automaticAccessibilityIdentifiersEnabled, true)  // ← Direct environment setting
            .modifier(AccessibilityIdentifierAssignmentModifier())
        
        // 3. Try to inspect for accessibility identifier
        do {
            let inspectedView = try view.inspect()
            let button = try inspectedView.button()
            let accessibilityID = try button.accessibilityIdentifier()
            
            print("🔍 Generated ID: '\(accessibilityID)'")
            
            if accessibilityID.isEmpty {
                print("❌ FAILED: No ID generated - direct environment variable not working")
                XCTFail("Direct environment variable not working - no ID generated")
            } else {
                print("✅ SUCCESS: Direct environment variable working - ID generated")
            }
            
        } catch {
            print("❌ FAILED: Could not inspect view: \(error)")
            XCTFail("Could not inspect view: \(error)")
        }
    }
}
