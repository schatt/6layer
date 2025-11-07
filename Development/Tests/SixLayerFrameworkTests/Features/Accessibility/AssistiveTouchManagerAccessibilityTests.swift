import Testing


import SwiftUI
@testable import SixLayerFramework
/// BUSINESS PURPOSE: Accessibility tests for AssistiveTouchManager.swift classes
/// Ensures AssistiveTouchManager classes generate proper accessibility identifiers
/// for automated testing and accessibility tools compliance
@Suite("Assistive Touch Manager Accessibility")
open class AssistiveTouchManagerAccessibilityTests: BaseTestClass {
    
    // MARK: - AssistiveTouchManager Tests
    
    /// BUSINESS PURPOSE: Validates that views using AssistiveTouchManager generate proper accessibility identifiers
    /// Tests views with .assistiveTouchEnabled() modifier which uses AssistiveTouchManager
    @Test func testAssistiveTouchManagerGeneratesAccessibilityIdentifiersOnIOS() {
        runWithTaskLocalConfig {
            // Given: A view with .assistiveTouchEnabled() modifier (which uses AssistiveTouchManager)
            let view = Button("Test Button") { }
                .assistiveTouchEnabled()
                .automaticAccessibilityIdentifiers()
            
            // When & Then: Should generate accessibility identifiers
            let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
                view,
                expectedPattern: "SixLayer.main.ui.*",
                platform: SixLayerPlatform.iOS,
                componentName: "AssistiveTouchEnabled"
            )
            
            #expect(hasAccessibilityID, "View with .assistiveTouchEnabled() (using AssistiveTouchManager) should generate accessibility identifiers on iOS")
        }
    }
    
    /// BUSINESS PURPOSE: Validates that views using AssistiveTouchManager generate proper accessibility identifiers
    /// Tests views with .assistiveTouchEnabled() modifier which uses AssistiveTouchManager
    @Test func testAssistiveTouchManagerGeneratesAccessibilityIdentifiersOnMacOS() {
        runWithTaskLocalConfig {
            // Given: A view with .assistiveTouchEnabled() modifier (which uses AssistiveTouchManager)
            let view = Button("Test Button") { }
                .assistiveTouchEnabled()
                .automaticAccessibilityIdentifiers()
            
            // When & Then: Should generate accessibility identifiers
            let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
                view,
                expectedPattern: "SixLayer.main.ui.*",
                platform: SixLayerPlatform.macOS,
                componentName: "AssistiveTouchEnabled"
            )
            
            #expect(hasAccessibilityID, "View with .assistiveTouchEnabled() (using AssistiveTouchManager) should generate accessibility identifiers on macOS")
        }
    }
}
