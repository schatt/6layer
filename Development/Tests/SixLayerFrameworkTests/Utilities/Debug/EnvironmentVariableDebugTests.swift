import Testing


import SwiftUI
@testable import SixLayerFramework
/// Debug test to understand environment variable propagation
@MainActor
@Suite("Environment Variable Debug")
open class EnvironmentVariableDebugTests: BaseTestClass {

    // BaseTestClass handles setup automatically - no need for custom init
    
    @Test func testEnvironmentVariablePropagation() {
        runWithTaskLocalConfig {
            
            // Test: Does the environment variable get set properly?
            
            // 1. Disable global config
            guard let config = testConfig else {
                Issue.record("testConfig is nil")
                return
            }
            config.enableAutoIDs = false
            print("🔧 Global config disabled: enableAutoIDs = false")
            
            // 2. Create a view with automaticAccessibilityIdentifiers modifier
            let view = Button("Test") { }
                .automaticAccessibilityIdentifiers()  // ← This should set autoIDsEnabled = true
            
            // 3. Try to inspect for accessibility identifier
            // Using wrapper - when ViewInspector works on macOS, no changes needed here
            if let inspectedView = view.tryInspect(),
               let button = try? inspectedView.button(),
               let accessibilityID = try? button.accessibilityIdentifier() {
                print("🔍 Generated ID: '\(accessibilityID)'")
                
                if accessibilityID.isEmpty {
                    print("❌ FAILED: No ID generated - environment variable not working")
                    Issue.record("Environment variable not working - no ID generated")
                } else {
                    print("✅ SUCCESS: Environment variable working - ID generated")
                }
            } else {
                print("❌ FAILED: Could not inspect view")
                Issue.record("Could not inspect view")
            }
        }
    }
    
    @Test func testDirectEnvironmentVariableSetting() {
        runWithTaskLocalConfig {
            // Test: Does setting the environment variable directly work?
            
            // 1. Disable global config
            guard let config = testConfig else {
                Issue.record("testConfig is nil")
                return
            }
            config.enableAutoIDs = false
            print("🔧 Global config disabled: enableAutoIDs = false")
            
            // 2. Create a view with direct environment variable setting
            let view = Button("Test") { }
                .environment(\.globalAutomaticAccessibilityIdentifiers, true)  // ← Direct environment setting
                .modifier(AutomaticAccessibilityIdentifierModifier())
            
            // 3. Try to inspect for accessibility identifier
            // Using wrapper - when ViewInspector works on macOS, no changes needed here
            if let inspectedView = view.tryInspect(),
               let button = try? inspectedView.button(),
               let accessibilityID = try? button.accessibilityIdentifier() {
                print("🔍 Generated ID: '\(accessibilityID)'")
                
                if accessibilityID.isEmpty {
                    print("❌ FAILED: No ID generated - direct environment variable not working")
                    Issue.record("Direct environment variable not working - no ID generated")
                } else {
                    print("✅ SUCCESS: Direct environment variable working - ID generated")
                }
            } else {
                print("❌ FAILED: Could not inspect view")
                Issue.record("Could not inspect view")
            }
        }
    }
}
