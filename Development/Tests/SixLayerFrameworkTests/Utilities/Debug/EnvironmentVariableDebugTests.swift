import Testing


import SwiftUI
@testable import SixLayerFramework
import ViewInspector
/// Debug test to understand environment variable propagation
@MainActor
@Suite("Environment Variable Debug")
open class EnvironmentVariableDebugTests: BaseTestClass {

    override init() {
        super.init()
        // Additional setup for this specific test class
        let config = AccessibilityIdentifierConfig.shared
        config.namespace = "TestApp"
        config.enableDebugLogging = true
    }
    
    @Test func testEnvironmentVariablePropagation() {
        
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
                Issue.record("Environment variable not working - no ID generated")
            } else {
                print("✅ SUCCESS: Environment variable working - ID generated")
            }
            
        } catch {
            print("❌ FAILED: Could not inspect view: \(error)")
            Issue.record("Could not inspect view: \(error)")
        }
    }
    
    @Test func testDirectEnvironmentVariableSetting() {
        // Test: Does setting the environment variable directly work?
        
        // 1. Disable global config
        let config = AccessibilityIdentifierConfig.shared
        config.enableAutoIDs = false
        print("🔧 Global config disabled: enableAutoIDs = false")
        
        // 2. Create a view with direct environment variable setting
        let view = Button("Test") { }
            .environment(\.globalAutomaticAccessibilityIdentifiers, true)  // ← Direct environment setting
            .modifier(AutomaticAccessibilityIdentifierModifier())
        
        // 3. Try to inspect for accessibility identifier
        do {
            let inspectedView = try view.inspect()
            let button = try inspectedView.button()
            let accessibilityID = try button.accessibilityIdentifier()
            
            print("🔍 Generated ID: '\(accessibilityID)'")
            
            if accessibilityID.isEmpty {
                print("❌ FAILED: No ID generated - direct environment variable not working")
                Issue.record("Direct environment variable not working - no ID generated")
            } else {
                print("✅ SUCCESS: Direct environment variable working - ID generated")
            }
            
        } catch {
            print("❌ FAILED: Could not inspect view: \(error)")
            Issue.record("Could not inspect view: \(error)")
        }
    }
}
