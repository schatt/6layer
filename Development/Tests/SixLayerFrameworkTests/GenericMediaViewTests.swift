import XCTest
import SwiftUI
@testable import SixLayerFramework
import ViewInspector

/// Tests for GenericMediaView component
/// 
/// BUSINESS PURPOSE: Ensure GenericMediaView generates proper accessibility identifiers
/// TESTING SCOPE: GenericMediaView component from PlatformSemanticLayer1.swift
/// METHODOLOGY: Test component on both iOS and macOS platforms as required by mandatory testing guidelines
@MainActor
final class GenericMediaViewTests: XCTestCase {
    
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
    
    // MARK: - GenericMediaView Tests
    
    func testGenericMediaViewGeneratesAccessibilityIdentifiersOnIOS() async {
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
            expectedPattern: "SixLayer.*element.*genericmediaview", 
            platform: .iOS,
            componentName: "GenericMediaView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "GenericMediaView should generate accessibility identifiers on iOS")
    }
    
    func testGenericMediaViewGeneratesAccessibilityIdentifiersOnMacOS() async {
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
            expectedPattern: "SixLayer.*element.*genericmediaview", 
            platform: .macOS,
            componentName: "GenericMediaView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "GenericMediaView should generate accessibility identifiers on macOS")
    }
}
