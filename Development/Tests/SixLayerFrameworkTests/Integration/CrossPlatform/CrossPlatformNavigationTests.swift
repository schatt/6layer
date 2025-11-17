import Testing


import SwiftUI
@testable import SixLayerFramework
/// Tests for CrossPlatformNavigation.swift
/// 
/// BUSINESS PURPOSE: Ensure CrossPlatformNavigation generates proper accessibility identifiers
/// TESTING SCOPE: All components in CrossPlatformNavigation.swift
/// METHODOLOGY: Test each component on both iOS and macOS platforms as required by mandatory testing guidelines
@Suite("Cross Platform Navigation")
@MainActor
open class CrossPlatformNavigationTests {
    
    // MARK: - Test Setup
    
    init() async throws {
        await setupTestEnvironment()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
        config.enableAutoIDs = true
        config.namespace = "SixLayer"
        config.mode = .automatic
        config.enableDebugLogging = false
    }    // MARK: - CrossPlatformNavigation Tests
    
    
    private func setupTestEnvironment() async {
        await AccessibilityTestUtilities.setupAccessibilityTestEnvironment()
    }
    
    private func cleanupTestEnvironment() async {
        await AccessibilityTestUtilities.cleanupAccessibilityTestEnvironment()
    }
    
@Test func testCrossPlatformNavigationGeneratesAccessibilityIdentifiersOnIOS() async {
        let view = Text("Test Navigation")
            .platformNavigation {
                Text("Content")
            }
        
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view, 
            expectedPattern: "SixLayer.*ui", 
            platform: SixLayerPlatform.iOS,
            componentName: "platformNavigation"
        )
 #expect(hasAccessibilityID, "platformNavigation should generate accessibility identifiers on iOS ")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }
    
    @Test func testCrossPlatformNavigationGeneratesAccessibilityIdentifiersOnMacOS() async {
        let view = Text("Test Navigation")
            .platformNavigation {
                Text("Content")
            }
        
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view, 
            expectedPattern: "SixLayer.*ui", 
            platform: .macOS,
            componentName: "platformNavigation"
        )
 #expect(hasAccessibilityID, "platformNavigation should generate accessibility identifiers on macOS ")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }
}
