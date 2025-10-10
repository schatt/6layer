import XCTest
import SwiftUI
@testable import SixLayerFramework
import ViewInspector

/// Tests for PlatformStylingLayer4.swift
/// 
/// BUSINESS PURPOSE: Ensure all styling Layer 4 components generate proper accessibility identifiers
/// TESTING SCOPE: All components in PlatformStylingLayer4.swift
/// METHODOLOGY: Test each component on both iOS and macOS platforms as required by mandatory testing guidelines
@MainActor
final class PlatformStylingLayer4Tests: XCTestCase {
    
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
    
    // MARK: - platformStyledContainer_L4 Tests
    
    func testPlatformStyledContainerL4GeneratesAccessibilityIdentifiersOnIOS() async {
        let view = platformStyledContainer_L4(
            content: {
                Text("Test Content")
            }
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*platformstyledcontainer_l4", 
            platform: .iOS,
            componentName: "platformStyledContainer_L4"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformStyledContainer_L4 should generate accessibility identifiers on iOS")
    }
    
    func testPlatformStyledContainerL4GeneratesAccessibilityIdentifiersOnMacOS() async {
        let view = platformStyledContainer_L4(
            content: {
                Text("Test Content")
            }
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*platformstyledcontainer_l4", 
            platform: .macOS,
            componentName: "platformStyledContainer_L4"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformStyledContainer_L4 should generate accessibility identifiers on macOS")
    }
}

