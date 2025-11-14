import Testing


import SwiftUI
@testable import SixLayerFramework
/// Tests for ResponsiveLayout.swift
/// 
/// BUSINESS PURPOSE: Ensure ResponsiveLayout generates proper accessibility identifiers
/// TESTING SCOPE: All components in ResponsiveLayout.swift
/// METHODOLOGY: Test each component on both iOS and macOS platforms as required by mandatory testing guidelines
@Suite("Responsive Layout")
@MainActor
open class ResponsiveLayoutTests: BaseTestClass {
    
@Test func testResponsiveLayoutGeneratesAccessibilityIdentifiersOnIOS() async {
        runWithTaskLocalConfig {

            let view = ResponsiveLayout.adaptiveGrid {
                platformPresentContent_L1(content: "Test Content", hints: PresentationHints())
            }
        
            let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
                view, 
                expectedPattern: "SixLayer.*ui", 
                platform: .iOS,
                componentName: "ResponsiveLayout"
            )
            
            // TODO: ViewInspector Detection Issue - VERIFIED: ResponsiveLayout.adaptiveGrid DOES have .automaticCompliance() 
            // modifier applied in Framework/Sources/Components/Views/ResponsiveLayout.swift:148.
            // The test needs to be updated to handle ViewInspector's inability to detect these identifiers reliably.
            // This is a ViewInspector limitation, not a missing modifier issue.
            #expect(hasAccessibilityID, "ResponsiveLayout should generate accessibility identifiers on iOS (modifier verified in code)")
        }
    }

    
    @Test func testResponsiveLayoutGeneratesAccessibilityIdentifiersOnMacOS() async {
        runWithTaskLocalConfig {

            let view = ResponsiveLayout.adaptiveGrid {
                platformPresentContent_L1(content: "Test Content", hints: PresentationHints())
            }
        
            let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
                view, 
                expectedPattern: "SixLayer.*ui", 
                platform: .macOS,
                componentName: "ResponsiveLayout"
            )
            
            // TODO: ViewInspector Detection Issue - VERIFIED: ResponsiveLayout.adaptiveGrid DOES have .automaticCompliance() 
            // modifier applied in Framework/Sources/Components/Views/ResponsiveLayout.swift:148.
            // The test needs to be updated to handle ViewInspector's inability to detect these identifiers reliably.
            // This is a ViewInspector limitation, not a missing modifier issue.
            #expect(hasAccessibilityID, "ResponsiveLayout should generate accessibility identifiers on macOS (modifier verified in code)")
        }
    }

}

