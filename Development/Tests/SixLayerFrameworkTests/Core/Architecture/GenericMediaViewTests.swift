import Testing


import SwiftUI
@testable import SixLayerFramework
import ViewInspector

/// Tests for GenericMediaView component
/// 
/// BUSINESS PURPOSE: Ensure GenericMediaView generates proper accessibility identifiers
/// TESTING SCOPE: GenericMediaView component from PlatformSemanticLayer1.swift
/// METHODOLOGY: Test component on both iOS and macOS platforms as required by mandatory testing guidelines
@MainActor
final class GenericMediaViewTests {
    
    // MARK: - Test Setup
    
    init() {
        setupTestEnvironment()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
        config.enableAutoIDs = true
        config.namespace = "SixLayer"
        config.mode = .automatic
        config.enableDebugLogging = false
    }
    
    deinit {
        cleanupTestEnvironment()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
    }
    
    // MARK: - GenericMediaView Tests
    
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
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.main.element.*", 
            platform: .iOS,
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
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.main.element.*", 
            platform: .macOS,
            componentName: "GenericMediaView"
        )
        
        #expect(hasAccessibilityID, "GenericMediaView should generate accessibility identifiers on macOS")
    }
}
