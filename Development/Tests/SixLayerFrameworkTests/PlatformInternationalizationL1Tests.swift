import XCTest
import SwiftUI
@testable import SixLayerFramework
import ViewInspector

/// Tests for PlatformInternationalizationL1.swift
/// 
/// BUSINESS PURPOSE: Ensure all internationalization Layer 1 functions generate proper accessibility identifiers
/// TESTING SCOPE: All functions in PlatformInternationalizationL1.swift
/// METHODOLOGY: Test each function on both iOS and macOS platforms as required by mandatory testing guidelines
@MainActor
final class PlatformInternationalizationL1Tests: XCTestCase {
    
    // MARK: - Test Setup
    
    override func setUp() {
        super.setUp()
        setupTestEnvironment()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
        config.enableAutoIDs = true
        config.namespace = "SixLayer"
        config.mode = .automatic
        config.enableDebugLogging = false
    }
    
    override func tearDown() {
        super.tearDown()
        cleanupTestEnvironment()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
    }
    
    // MARK: - platformPresentLocalizedContent_L1 Tests
    
    func testPlatformPresentLocalizedContentL1GeneratesAccessibilityIdentifiersOnIOS() async {
        let hints = InternationalizationHints()
        
        let view = platformPresentLocalizedContent_L1(
            content: Text("Test Localized Content"),
            hints: hints
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*platformpresentlocalizedcontent_l1", 
            platform: .iOS,
            componentName: "platformPresentLocalizedContent_L1"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformPresentLocalizedContent_L1 should generate accessibility identifiers on iOS")
    }
    
    func testPlatformPresentLocalizedContentL1GeneratesAccessibilityIdentifiersOnMacOS() async {
        let hints = InternationalizationHints()
        
        let view = platformPresentLocalizedContent_L1(
            content: Text("Test Localized Content"),
            hints: hints
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*platformpresentlocalizedcontent_l1", 
            platform: .macOS,
            componentName: "platformPresentLocalizedContent_L1"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformPresentLocalizedContent_L1 should generate accessibility identifiers on macOS")
    }
    
    // MARK: - platformPresentLocalizedText_L1 Tests
    
    func testPlatformPresentLocalizedTextL1GeneratesAccessibilityIdentifiersOnIOS() async {
        let hints = InternationalizationHints()
        
        let view = platformPresentLocalizedText_L1(text: "Test Localized Text", hints: hints)
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*platformpresentlocalizedtext_l1", 
            platform: .iOS,
            componentName: "platformPresentLocalizedText_L1"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformPresentLocalizedText_L1 should generate accessibility identifiers on iOS")
    }
    
    func testPlatformPresentLocalizedTextL1GeneratesAccessibilityIdentifiersOnMacOS() async {
        let hints = InternationalizationHints()
        
        let view = platformPresentLocalizedText_L1(text: "Test Localized Text", hints: hints)
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*platformpresentlocalizedtext_l1", 
            platform: .macOS,
            componentName: "platformPresentLocalizedText_L1"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformPresentLocalizedText_L1 should generate accessibility identifiers on macOS")
    }
}
