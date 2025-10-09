import XCTest
import SwiftUI
@testable import SixLayerFramework
import ViewInspector

/// Tests for PlatformNavigationLayer4.swift
/// 
/// BUSINESS PURPOSE: Ensure all navigation Layer 4 components generate proper accessibility identifiers
/// TESTING SCOPE: All components in PlatformNavigationLayer4.swift
/// METHODOLOGY: Test each component on both iOS and macOS platforms as required by mandatory testing guidelines
@MainActor
final class PlatformNavigationLayer4Tests: XCTestCase {
    
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
    
    // MARK: - platformNavigationContainer_L4 Tests
    
    func testPlatformNavigationContainerL4GeneratesAccessibilityIdentifiersOnIOS() async {
        let view = platformNavigationContainer_L4(
            title: "Test Navigation",
            content: {
                Text("Test Content")
            }
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*platformnavigationcontainer_l4", 
            platform: .iOS,
            componentName: "platformNavigationContainer_L4"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformNavigationContainer_L4 should generate accessibility identifiers on iOS")
    }
    
    func testPlatformNavigationContainerL4GeneratesAccessibilityIdentifiersOnMacOS() async {
        let view = platformNavigationContainer_L4(
            title: "Test Navigation",
            content: {
                Text("Test Content")
            }
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*platformnavigationcontainer_l4", 
            platform: .macOS,
            componentName: "platformNavigationContainer_L4"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformNavigationContainer_L4 should generate accessibility identifiers on macOS")
    }
}

