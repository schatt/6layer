import Testing


import SwiftUI
@testable import SixLayerFramework
#if !os(macOS)
import ViewInspector
#endif
/// BUSINESS PURPOSE: Accessibility tests for AppleHIGComplianceManager.swift classes
/// Ensures AppleHIGComplianceManager classes generate proper accessibility identifiers
/// for automated testing and accessibility tools compliance
@Suite("Apple HIG Compliance Manager Accessibility")
open class AppleHIGComplianceManagerAccessibilityTests: BaseTestClass {
    // MARK: - AppleHIGComplianceManager Tests
    
    /// BUSINESS PURPOSE: Validates that views using AppleHIGComplianceManager generate proper accessibility identifiers
    /// Tests views with .appleHIGCompliant() modifier which uses AppleHIGComplianceManager
    @Test func testAppleHIGComplianceManagerGeneratesAccessibilityIdentifiersOnIOS() {
        runWithTaskLocalConfig {
            // Given: A view with .appleHIGCompliant() modifier (which uses AppleHIGComplianceManager)
            let view = VStack {
                Text("HIG Compliant Content")
            }
            .appleHIGCompliant()
            .automaticAccessibilityIdentifiers()
            
            // When & Then: Should generate accessibility identifiers
            let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
                view,
                expectedPattern: "SixLayer.main.ui.*",
                platform: SixLayerPlatform.iOS,
                componentName: "AppleHIGCompliant"
            )
            
            #expect(hasAccessibilityID, "View with .appleHIGCompliant() (using AppleHIGComplianceManager) should generate accessibility identifiers on iOS")
        }
    }
    
    /// BUSINESS PURPOSE: Validates that views using AppleHIGComplianceManager generate proper accessibility identifiers
    /// Tests views with .appleHIGCompliant() modifier which uses AppleHIGComplianceManager
    @Test func testAppleHIGComplianceManagerGeneratesAccessibilityIdentifiersOnMacOS() {
        runWithTaskLocalConfig {
            // Given: A view with .appleHIGCompliant() modifier (which uses AppleHIGComplianceManager)
            let view = VStack {
                Text("HIG Compliant Content")
            }
            .appleHIGCompliant()
            .automaticAccessibilityIdentifiers()
            
            // When & Then: Should generate accessibility identifiers
            let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
                view,
                expectedPattern: "SixLayer.main.ui.*",
                platform: SixLayerPlatform.macOS,
                componentName: "AppleHIGCompliant"
            )
            
            #expect(hasAccessibilityID, "View with .appleHIGCompliant() (using AppleHIGComplianceManager) should generate accessibility identifiers on macOS")
        }
    }
}

