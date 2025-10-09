import XCTest
import SwiftUI
@testable import SixLayerFramework
import ViewInspector

/// Tests for PlatformModalsLayer4.swift
/// 
/// BUSINESS PURPOSE: Ensure all modal Layer 4 components generate proper accessibility identifiers
/// TESTING SCOPE: All components in PlatformModalsLayer4.swift
/// METHODOLOGY: Test each component on both iOS and macOS platforms as required by mandatory testing guidelines
@MainActor
final class PlatformModalsLayer4Tests: XCTestCase {
    
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
    
    // MARK: - platformModalContainer_L4 Tests
    
    func testPlatformModalContainerL4GeneratesAccessibilityIdentifiersOnIOS() async {
        let view = platformModalContainer_L4(
            title: "Test Modal",
            content: {
                Text("Test Content")
            }
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*platformmodalcontainer_l4", 
            platform: .iOS,
            componentName: "platformModalContainer_L4"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformModalContainer_L4 should generate accessibility identifiers on iOS")
    }
    
    func testPlatformModalContainerL4GeneratesAccessibilityIdentifiersOnMacOS() async {
        let view = platformModalContainer_L4(
            title: "Test Modal",
            content: {
                Text("Test Content")
            }
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*platformmodalcontainer_l4", 
            platform: .macOS,
            componentName: "platformModalContainer_L4"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformModalContainer_L4 should generate accessibility identifiers on macOS")
    }
}

