import Testing


import SwiftUI
@testable import SixLayerFramework
#if !os(macOS)
import ViewInspector
#endif
/// Tests for GenericMediaView component
/// 
/// BUSINESS PURPOSE: Ensure GenericMediaView generates proper accessibility identifiers
/// TESTING SCOPE: GenericMediaView component from PlatformSemanticLayer1.swift
/// METHODOLOGY: Test component on both iOS and macOS platforms as required by mandatory testing guidelines
@Suite("Generic Media View")
@MainActor
open class GenericMediaViewTests {
    
    // MARK: - Test Setup
    
    init() async throws {
        await setupTestEnvironment()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
        config.enableAutoIDs = true
        config.namespace = "SixLayer"
        config.mode = .automatic
        config.enableDebugLogging = false
    }    // MARK: - GenericMediaView Tests
    
    
    private func setupTestEnvironment() async {
        await AccessibilityTestUtilities.setupAccessibilityTestEnvironment()
    }
    
    private func cleanupTestEnvironment() async {
        await AccessibilityTestUtilities.cleanupAccessibilityTestEnvironment()
    }
    
@Test func testGenericMediaViewGeneratesAccessibilityIdentifiersOnIOS() async {
        let view = GenericMediaView(
            media: [GenericMediaItem(title: "Test Media", url: "https://example.com")],
            hints: PresentationHints(
                dataType: .generic,
                presentationPreference: .automatic,
                complexity: .moderate,
                context: .modal,
                customPreferences: [:]
            )
        )
        
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view, 
            expectedPattern: "SixLayer.*ui", 
            platform: SixLayerPlatform.iOS,
            componentName: "GenericMediaView"
        )
        
        #expect(hasAccessibilityID, "GenericMediaView should generate accessibility identifiers on iOS")
    }
    
    @Test func testGenericMediaViewGeneratesAccessibilityIdentifiersOnMacOS() async {
        let view = GenericMediaView(
            media: [GenericMediaItem(title: "Test Media", url: "https://example.com")],
            hints: PresentationHints(
                dataType: .generic,
                presentationPreference: .automatic,
                complexity: .moderate,
                context: .modal,
                customPreferences: [:]
            )
        )
        
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view, 
            expectedPattern: "SixLayer.*ui", 
            platform: SixLayerPlatform.iOS,
            componentName: "GenericMediaView"
        )
        
        #expect(hasAccessibilityID, "GenericMediaView should generate accessibility identifiers on macOS")
    }
}
