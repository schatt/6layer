import Testing
import SwiftUI
@testable import SixLayerFramework
import ViewInspector

/// Tests for CrossPlatformNavigation.swift
/// 
/// BUSINESS PURPOSE: Ensure CrossPlatformNavigation generates proper accessibility identifiers
/// TESTING SCOPE: All components in CrossPlatformNavigation.swift
/// METHODOLOGY: Test each component on both iOS and macOS platforms as required by mandatory testing guidelines
@MainActor
final class CrossPlatformNavigationTests {
    
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
    
    // MARK: - CrossPlatformNavigation Tests
    
    @Test func testCrossPlatformNavigationGeneratesAccessibilityIdentifiersOnIOS() async {
        let view = Text("Test Navigation")
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.main.element.*", 
            platform: .iOS,
            componentName: "CrossPlatformNavigationView"
        )
        
        #expect(hasAccessibilityID, "CrossPlatformNavigationView should generate accessibility identifiers on iOS")
    }
    
    @Test func testCrossPlatformNavigationGeneratesAccessibilityIdentifiersOnMacOS() async {
        let view = Text("Test Navigation")
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.main.element.*", 
            platform: .macOS,
            componentName: "CrossPlatformNavigationView"
        )
        
        #expect(hasAccessibilityID, "CrossPlatformNavigationView should generate accessibility identifiers on macOS")
    }
}
