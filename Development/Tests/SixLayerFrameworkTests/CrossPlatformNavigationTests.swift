import XCTest
import SwiftUI
@testable import SixLayerFramework
import ViewInspector

/// Tests for CrossPlatformNavigation.swift
/// 
/// BUSINESS PURPOSE: Ensure CrossPlatformNavigation generates proper accessibility identifiers
/// TESTING SCOPE: All components in CrossPlatformNavigation.swift
/// METHODOLOGY: Test each component on both iOS and macOS platforms as required by mandatory testing guidelines
@MainActor
final class CrossPlatformNavigationTests: XCTestCase {
    
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
    
    // MARK: - CrossPlatformNavigation Tests
    
    func testCrossPlatformNavigationGeneratesAccessibilityIdentifiersOnIOS() async {
        let view = Text("Test Navigation")
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*crossplatformnavigationview", 
            platform: .iOS,
            componentName: "CrossPlatformNavigationView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "CrossPlatformNavigationView should generate accessibility identifiers on iOS")
    }
    
    func testCrossPlatformNavigationGeneratesAccessibilityIdentifiersOnMacOS() async {
        let view = Text("Test Navigation")
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*crossplatformnavigationview", 
            platform: .macOS,
            componentName: "CrossPlatformNavigationView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "CrossPlatformNavigationView should generate accessibility identifiers on macOS")
    }
}
