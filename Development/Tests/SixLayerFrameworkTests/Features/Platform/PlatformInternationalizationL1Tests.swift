import Testing


import SwiftUI
@testable import SixLayerFramework
import ViewInspector
/// Tests for PlatformInternationalizationL1.swift
/// 
/// BUSINESS PURPOSE: Ensure all internationalization Layer 1 functions generate proper accessibility identifiers
/// TESTING SCOPE: All functions in PlatformInternationalizationL1.swift
/// METHODOLOGY: Test each function on both iOS and macOS platforms as required by mandatory testing guidelines
@Suite("Platform Internationalization L")
@MainActor
open class PlatformInternationalizationL1Tests: BaseTestClass {
    
@Test func testPlatformPresentLocalizedContentL1GeneratesAccessibilityIdentifiersOnIOS() async {
        runWithTaskLocalConfig {

            let hints = InternationalizationHints()
        
            let view = platformPresentLocalizedContent_L1(
                content: platformPresentContent_L1(content: "Test Localized Content", hints: PresentationHints()),
                hints: hints
            )
        
            let hasAccessibilityID = testAccessibilityIdentifiersCrossPlatform(
                view, 
                expectedPattern: "SixLayer.main.ui.*", 
                componentName: "platformPresentLocalizedContent_L1",
                testName: "PlatformTest"
            )
        
            #expect(hasAccessibilityID, "platformPresentLocalizedContent_L1 should generate accessibility identifiers on iOS")
        }
    }

    
    @Test func testPlatformPresentLocalizedContentL1GeneratesAccessibilityIdentifiersOnMacOS() async {
        runWithTaskLocalConfig {

            let hints = InternationalizationHints()
        
            let view = platformPresentLocalizedContent_L1(
                content: platformPresentContent_L1(content: "Test Localized Content", hints: PresentationHints()),
                hints: hints
            )
        
            let hasAccessibilityID = testAccessibilityIdentifiersCrossPlatform(
                view, 
                expectedPattern: "SixLayer.main.ui.*", 
                componentName: "platformPresentLocalizedContent_L1",
                testName: "PlatformTest"
            )
        
            #expect(hasAccessibilityID, "platformPresentLocalizedContent_L1 should generate accessibility identifiers on macOS")
        }
    }

    
    // MARK: - platformPresentLocalizedText_L1 Tests
    
    @Test func testPlatformPresentLocalizedTextL1GeneratesAccessibilityIdentifiersOnIOS() async {
        runWithTaskLocalConfig {

            let hints = InternationalizationHints()
        
            let view = platformPresentLocalizedText_L1(text: "Test Localized Text", hints: hints)
            let hasAccessibilityID = testAccessibilityIdentifiersCrossPlatform(
                view, 
                expectedPattern: "SixLayer.main.ui.*", 
                componentName: "platformPresentLocalizedText_L1",
                testName: "PlatformTest"
            )
        
            #expect(hasAccessibilityID, "platformPresentLocalizedText_L1 should generate accessibility identifiers on iOS")
        }
    }

    
    @Test func testPlatformPresentLocalizedTextL1GeneratesAccessibilityIdentifiersOnMacOS() async {
        runWithTaskLocalConfig {

            let hints = InternationalizationHints()
        
            let view = platformPresentLocalizedText_L1(text: "Test Localized Text", hints: hints)
            let hasAccessibilityID = testAccessibilityIdentifiersCrossPlatform(
                view, 
                expectedPattern: "SixLayer.main.ui.*", 
                componentName: "platformPresentLocalizedText_L1",
                testName: "PlatformTest"
            )
        
            #expect(hasAccessibilityID, "platformPresentLocalizedText_L1 should generate accessibility identifiers on macOS")
        }
    }

}
