import Testing


import SwiftUI
@testable import SixLayerFramework
import ViewInspector

/// Tests for PlatformStylingLayer4.swift
/// 
/// BUSINESS PURPOSE: Ensure all styling Layer 4 components generate proper accessibility identifiers
/// TESTING SCOPE: All components in PlatformStylingLayer4.swift
/// METHODOLOGY: Test each component on both iOS and macOS platforms as required by mandatory testing guidelines
@MainActor
open class PlatformStylingLayer4Tests {
    
    // MARK: - Test Setup
    
    init() async throws {
        await setupTestEnvironment()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
        config.enableAutoIDs = true
        config.namespace = "SixLayer"
        config.mode = .automatic
        config.enableDebugLogging = false
    }    // MARK: - platformStyledContainer_L4 Tests
    
    
    private func setupTestEnvironment() async {
        await AccessibilityTestUtilities.setupAccessibilityTestEnvironment()
    }
    
    private func cleanupTestEnvironment() async {
        await AccessibilityTestUtilities.cleanupAccessibilityTestEnvironment()
    }
    
@Test func testPlatformStyledContainerL4GeneratesAccessibilityIdentifiersOnIOS() async {
        let view = Text("Test Content")
            .platformStyledContainer_L4(
                content: {
                    Text("Test Content")
                }
            )
        
        let hasAccessibilityID = testAccessibilityIdentifiersCrossPlatform(
            view, 
            expectedPattern: "SixLayer.main.element.*", 
            platform: SixLayerPlatform.iOS,
            componentName: "platformStyledContainer_L4",
            testName: "PlatformTest"
        )
        
        #expect(hasAccessibilityID, "platformStyledContainer_L4 should generate accessibility identifiers on iOS")
    }
    
    @Test func testPlatformStyledContainerL4GeneratesAccessibilityIdentifiersOnMacOS() async {
        let view = Text("Test Content")
            .platformStyledContainer_L4(
                content: {
                    Text("Test Content")
                }
            )
        
        let hasAccessibilityID = testAccessibilityIdentifiersCrossPlatform(
            view, 
            expectedPattern: "SixLayer.main.element.*", 
            platform: .macOS,
            componentName: "platformStyledContainer_L4",
            testName: "PlatformTest"
        )
        
        #expect(hasAccessibilityID, "platformStyledContainer_L4 should generate accessibility identifiers on macOS")
    }
}

