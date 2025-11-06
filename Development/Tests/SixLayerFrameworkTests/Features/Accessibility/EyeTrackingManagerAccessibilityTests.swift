import Testing


import SwiftUI
@testable import SixLayerFramework
import ViewInspector
/// BUSINESS PURPOSE: Accessibility tests for EyeTrackingManager.swift classes
/// Ensures EyeTrackingManager classes generate proper accessibility identifiers
/// for automated testing and accessibility tools compliance
@Suite("Eye Tracking Manager Accessibility")
open class EyeTrackingManagerAccessibilityTests: BaseTestClass {
    
    // MARK: - EyeTrackingManager Tests
    
    /// BUSINESS PURPOSE: Validates that views using EyeTrackingManager generate proper accessibility identifiers
    /// Tests views with EyeTrackingModifier which uses EyeTrackingManager internally
    @Test func testEyeTrackingManagerGeneratesAccessibilityIdentifiersOnIOS() {
        runWithTaskLocalConfig {
            // Given: A view with EyeTrackingModifier (which uses EyeTrackingManager)
            let view = VStack {
                Text("Eye Tracking Content")
            }
            .eyeTrackingEnabled()
            .automaticAccessibilityIdentifiers()
            
            // When & Then: Should generate accessibility identifiers
            let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
                view,
                expectedPattern: "SixLayer.main.ui.*",
                platform: SixLayerPlatform.iOS,
                componentName: "EyeTrackingModifier"
            )
            
            #expect(hasAccessibilityID, "View with EyeTrackingModifier (using EyeTrackingManager) should generate accessibility identifiers on iOS")
        }
    }
    
    /// BUSINESS PURPOSE: Validates that views using EyeTrackingManager generate proper accessibility identifiers
    /// Tests views with EyeTrackingModifier which uses EyeTrackingManager internally
    @Test func testEyeTrackingManagerGeneratesAccessibilityIdentifiersOnMacOS() {
        runWithTaskLocalConfig {
            // Given: A view with EyeTrackingModifier (which uses EyeTrackingManager)
            let view = VStack {
                Text("Eye Tracking Content")
            }
            .eyeTrackingEnabled()
            .automaticAccessibilityIdentifiers()
            
            // When & Then: Should generate accessibility identifiers
            let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
                view,
                expectedPattern: "SixLayer.main.ui.*",
                platform: SixLayerPlatform.macOS,
                componentName: "EyeTrackingModifier"
            )
            
            #expect(hasAccessibilityID, "View with EyeTrackingModifier (using EyeTrackingManager) should generate accessibility identifiers on macOS")
        }
    }
}
