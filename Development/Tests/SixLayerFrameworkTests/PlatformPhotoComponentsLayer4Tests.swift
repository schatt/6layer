import XCTest
import SwiftUI
@testable import SixLayerFramework
import ViewInspector

/// Tests for PlatformPhotoComponentsLayer4.swift
/// 
/// BUSINESS PURPOSE: Ensure all photo Layer 4 components generate proper accessibility identifiers
/// TESTING SCOPE: All components in PlatformPhotoComponentsLayer4.swift
/// METHODOLOGY: Test each component on both iOS and macOS platforms as required by mandatory testing guidelines
@MainActor
final class PlatformPhotoComponentsLayer4Tests: XCTestCase {
    
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
    
    // MARK: - platformCameraInterface_L4 Tests
    
    func testPlatformCameraInterfaceL4GeneratesAccessibilityIdentifiersOnIOS() async {
        let view = platformCameraInterface_L4(
            onCapture: { _ in },
            onCancel: {}
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*platformcamerainterface_l4", 
            platform: .iOS,
            componentName: "platformCameraInterface_L4"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformCameraInterface_L4 should generate accessibility identifiers on iOS")
    }
    
    func testPlatformCameraInterfaceL4GeneratesAccessibilityIdentifiersOnMacOS() async {
        let view = platformCameraInterface_L4(
            onCapture: { _ in },
            onCancel: {}
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*platformcamerainterface_l4", 
            platform: .macOS,
            componentName: "platformCameraInterface_L4"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformCameraInterface_L4 should generate accessibility identifiers on macOS")
    }
}

