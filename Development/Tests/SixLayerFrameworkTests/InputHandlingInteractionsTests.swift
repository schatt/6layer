import XCTest
import SwiftUI
@testable import SixLayerFramework
import ViewInspector

/// Tests for InputHandlingInteractions.swift
/// 
/// BUSINESS PURPOSE: Ensure PlatformInteractionButton and other input handling components generate proper accessibility identifiers
/// TESTING SCOPE: All components in InputHandlingInteractions.swift
/// METHODOLOGY: Test each component on both iOS and macOS platforms as required by mandatory testing guidelines
@MainActor
final class InputHandlingInteractionsTests: XCTestCase {
    
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
    
    // MARK: - PlatformInteractionButton Tests
    
    func testPlatformInteractionButtonGeneratesAccessibilityIdentifiersOnIOS() async {
        let view = PlatformInteractionButton(style: .primary, action: {}) {
            Text("Test Button")
        }
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*platforminteractionbutton", 
            platform: .iOS,
            componentName: "PlatformInteractionButton"
        )
        
        XCTAssertTrue(hasAccessibilityID, "PlatformInteractionButton should generate accessibility identifiers on iOS")
    }
    
    func testPlatformInteractionButtonGeneratesAccessibilityIdentifiersOnMacOS() async {
        let view = PlatformInteractionButton(style: .primary, action: {}) {
            Text("Test Button")
        }
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*platforminteractionbutton", 
            platform: .macOS,
            componentName: "PlatformInteractionButton"
        )
        
        XCTAssertTrue(hasAccessibilityID, "PlatformInteractionButton should generate accessibility identifiers on macOS")
    }
}
