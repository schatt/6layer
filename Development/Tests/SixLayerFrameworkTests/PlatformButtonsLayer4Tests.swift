import XCTest
import SwiftUI
@testable import SixLayerFramework
import ViewInspector

/// Tests for PlatformButtonsLayer4.swift
/// 
/// BUSINESS PURPOSE: Ensure all button Layer 4 components generate proper accessibility identifiers
/// TESTING SCOPE: All components in PlatformButtonsLayer4.swift
/// METHODOLOGY: Test each component on both iOS and macOS platforms as required by mandatory testing guidelines
@MainActor
final class PlatformButtonsLayer4Tests: XCTestCase {
    
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
    
    // MARK: - platformPrimaryButton_L4 Tests
    
    func testPlatformPrimaryButtonL4GeneratesAccessibilityIdentifiersOnIOS() async {
        let view = platformPrimaryButton_L4(
            title: "Test Button",
            action: {}
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*platformprimarybutton_l4", 
            platform: .iOS,
            componentName: "platformPrimaryButton_L4"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformPrimaryButton_L4 should generate accessibility identifiers on iOS")
    }
    
    func testPlatformPrimaryButtonL4GeneratesAccessibilityIdentifiersOnMacOS() async {
        let view = platformPrimaryButton_L4(
            title: "Test Button",
            action: {}
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*platformprimarybutton_l4", 
            platform: .macOS,
            componentName: "platformPrimaryButton_L4"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformPrimaryButton_L4 should generate accessibility identifiers on macOS")
    }
    
    // MARK: - platformSecondaryButton_L4 Tests
    
    func testPlatformSecondaryButtonL4GeneratesAccessibilityIdentifiersOnIOS() async {
        let view = platformSecondaryButton_L4(
            title: "Test Button",
            action: {}
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*platformsecondarybutton_l4", 
            platform: .iOS,
            componentName: "platformSecondaryButton_L4"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformSecondaryButton_L4 should generate accessibility identifiers on iOS")
    }
    
    func testPlatformSecondaryButtonL4GeneratesAccessibilityIdentifiersOnMacOS() async {
        let view = platformSecondaryButton_L4(
            title: "Test Button",
            action: {}
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*platformsecondarybutton_l4", 
            platform: .macOS,
            componentName: "platformSecondaryButton_L4"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformSecondaryButton_L4 should generate accessibility identifiers on macOS")
    }
}

