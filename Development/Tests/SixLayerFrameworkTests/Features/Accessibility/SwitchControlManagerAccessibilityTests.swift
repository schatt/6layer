import Testing


import SwiftUI
@testable import SixLayerFramework
import ViewInspector
/// BUSINESS PURPOSE: Accessibility tests for SwitchControlManager.swift classes
/// Ensures SwitchControlManager classes generate proper accessibility identifiers
/// for automated testing and accessibility tools compliance
@Suite("Switch Control Manager Accessibility")
open class SwitchControlManagerAccessibilityTests: BaseTestClass {
    
    // MARK: - SwitchControlManager Tests
    
    /// BUSINESS PURPOSE: Validates that views using SwitchControlManager generate proper accessibility identifiers
    /// Tests views with .switchControlEnabled() modifier which uses SwitchControlManager
    @Test func testSwitchControlManagerGeneratesAccessibilityIdentifiersOnIOS() {
        runWithTaskLocalConfig {
            // Given: A view with .switchControlEnabled() modifier (which uses SwitchControlManager)
            let view = Button("Test Button") { }
                .switchControlEnabled()
                .automaticAccessibilityIdentifiers()
            
            // When & Then: Should generate accessibility identifiers
            let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
                view,
                expectedPattern: "SixLayer.main.ui.*",
                platform: SixLayerPlatform.iOS,
                componentName: "SwitchControlEnabled"
            )
            
            #expect(hasAccessibilityID, "View with .switchControlEnabled() (using SwitchControlManager) should generate accessibility identifiers on iOS")
        }
    }
    
    /// BUSINESS PURPOSE: Validates that views using SwitchControlManager generate proper accessibility identifiers
    /// Tests views with .switchControlEnabled() modifier which uses SwitchControlManager
    @Test func testSwitchControlManagerGeneratesAccessibilityIdentifiersOnMacOS() {
        runWithTaskLocalConfig {
            // Given: A view with .switchControlEnabled() modifier (which uses SwitchControlManager)
            let view = Button("Test Button") { }
                .switchControlEnabled()
                .automaticAccessibilityIdentifiers()
            
            // When & Then: Should generate accessibility identifiers
            let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
                view,
                expectedPattern: "SixLayer.main.ui.*",
                platform: SixLayerPlatform.macOS,
                componentName: "SwitchControlEnabled"
            )
            
            #expect(hasAccessibilityID, "View with .switchControlEnabled() (using SwitchControlManager) should generate accessibility identifiers on macOS")
        }
    }
}

