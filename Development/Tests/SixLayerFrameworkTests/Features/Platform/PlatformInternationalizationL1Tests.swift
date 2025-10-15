import Testing


import SwiftUI
@testable import SixLayerFramework
import ViewInspector

/// Tests for PlatformInternationalizationL1.swift
/// 
/// BUSINESS PURPOSE: Ensure all internationalization Layer 1 functions generate proper accessibility identifiers
/// TESTING SCOPE: All functions in PlatformInternationalizationL1.swift
/// METHODOLOGY: Test each function on both iOS and macOS platforms as required by mandatory testing guidelines
@MainActor
final class PlatformInternationalizationL1Tests {
    
    // MARK: - Test Setup
    
    init() async throws {
        await setupTestEnvironment()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
        config.enableAutoIDs = true
        config.namespace = "SixLayer"
        config.mode = .automatic
        config.enableDebugLogging = false
    }
    
    deinit {
        Task { [weak self] in
            await self?.cleanupTestEnvironment()
        }
    }
    
    // MARK: - platformPresentLocalizedContent_L1 Tests
    
    
    private func setupTestEnvironment() async {
        await AccessibilityTestUtilities.setupAccessibilityTestEnvironment()
    }
    
    private func cleanupTestEnvironment() async {
        await AccessibilityTestUtilities.cleanupAccessibilityTestEnvironment()
    }
    
@Test func testPlatformPresentLocalizedContentL1GeneratesAccessibilityIdentifiersOnIOS() async {
        let hints = InternationalizationHints()
        
        let view = platformPresentLocalizedContent_L1(
            content: Text("Test Localized Content"),
            hints: hints
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.main.element.*", 
            platform: .iOS,
            componentName: "platformPresentLocalizedContent_L1"
        )
        
        #expect(hasAccessibilityID, "platformPresentLocalizedContent_L1 should generate accessibility identifiers on iOS")
    }
    
    @Test func testPlatformPresentLocalizedContentL1GeneratesAccessibilityIdentifiersOnMacOS() async {
        let hints = InternationalizationHints()
        
        let view = platformPresentLocalizedContent_L1(
            content: Text("Test Localized Content"),
            hints: hints
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.main.element.*", 
            platform: .macOS,
            componentName: "platformPresentLocalizedContent_L1"
        )
        
        #expect(hasAccessibilityID, "platformPresentLocalizedContent_L1 should generate accessibility identifiers on macOS")
    }
    
    // MARK: - platformPresentLocalizedText_L1 Tests
    
    @Test func testPlatformPresentLocalizedTextL1GeneratesAccessibilityIdentifiersOnIOS() async {
        let hints = InternationalizationHints()
        
        let view = platformPresentLocalizedText_L1(text: "Test Localized Text", hints: hints)
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.main.element.*", 
            platform: .iOS,
            componentName: "platformPresentLocalizedText_L1"
        )
        
        #expect(hasAccessibilityID, "platformPresentLocalizedText_L1 should generate accessibility identifiers on iOS")
    }
    
    @Test func testPlatformPresentLocalizedTextL1GeneratesAccessibilityIdentifiersOnMacOS() async {
        let hints = InternationalizationHints()
        
        let view = platformPresentLocalizedText_L1(text: "Test Localized Text", hints: hints)
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.main.element.*", 
            platform: .macOS,
            componentName: "platformPresentLocalizedText_L1"
        )
        
        #expect(hasAccessibilityID, "platformPresentLocalizedText_L1 should generate accessibility identifiers on macOS")
    }
}
