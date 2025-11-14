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
        
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view, 
            expectedPattern: "SixLayer.*ui", 
            platform: SixLayerPlatform.iOS,
            componentName: "platformNavigation"
        )
        
        // TODO: ViewInspector Detection Issue - VERIFIED: platformNavigation DOES have .automaticAccessibilityIdentifiers() 
        // modifier applied in Framework/Sources/Layers/Layer4-Component/PlatformNavigationLayer4.swift:29.
        // The test needs to be updated to handle ViewInspector's inability to detect these identifiers reliably.
        // This is a ViewInspector limitation, not a missing modifier issue.
        #expect(hasAccessibilityID, "platformNavigation should generate accessibility identifiers on iOS (modifier verified in code)")
    }
    
    @Test func testCrossPlatformNavigationGeneratesAccessibilityIdentifiersOnMacOS() async {
        let view = Text("Test Navigation")
            .platformNavigation {
                Text("Content")
            }
        
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view, 
            expectedPattern: "SixLayer.*ui", 
            platform: .macOS,
            componentName: "platformNavigation"
        )
        
        // TODO: ViewInspector Detection Issue - VERIFIED: platformNavigation DOES have .automaticAccessibilityIdentifiers() 
        // modifier applied in Framework/Sources/Layers/Layer4-Component/PlatformNavigationLayer4.swift:29.
        // The test needs to be updated to handle ViewInspector's inability to detect these identifiers reliably.
        // This is a ViewInspector limitation, not a missing modifier issue.
        #expect(hasAccessibilityID, "platformNavigation should generate accessibility identifiers on macOS (modifier verified in code)")
    }
}
