import Testing


import SwiftUI
@testable import SixLayerFramework
import ViewInspector
/// Tests for ResponsiveLayout.swift
/// 
/// BUSINESS PURPOSE: Ensure ResponsiveLayout generates proper accessibility identifiers
/// TESTING SCOPE: All components in ResponsiveLayout.swift
/// METHODOLOGY: Test each component on both iOS and macOS platforms as required by mandatory testing guidelines
@Suite("Responsive Layout")
@MainActor
open class ResponsiveLayoutTests: BaseTestClass {
    
@Test func testResponsiveLayoutGeneratesAccessibilityIdentifiersOnIOS() async {
        await runWithTaskLocalConfig {

            let view = ResponsiveLayout.adaptiveGrid {
                platformPresentContent_L1(content: "Test Content", hints: PresentationHints())
            }
        
            let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
                view, 
                expectedPattern: "SixLayer.*ui", 
                platform: .iOS,
                componentName: "ResponsiveLayout"
            )
        
            #expect(hasAccessibilityID, "ResponsiveLayout should generate accessibility identifiers on iOS")
        }
    }

    
    @Test func testResponsiveLayoutGeneratesAccessibilityIdentifiersOnMacOS() async {
        await runWithTaskLocalConfig {

            let view = ResponsiveLayout.adaptiveGrid {
                platformPresentContent_L1(content: "Test Content", hints: PresentationHints())
            }
        
            let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
                view, 
                expectedPattern: "SixLayer.*ui", 
                platform: .macOS,
                componentName: "ResponsiveLayout"
            )
        
            #expect(hasAccessibilityID, "ResponsiveLayout should generate accessibility identifiers on macOS")
        }
    }

}

