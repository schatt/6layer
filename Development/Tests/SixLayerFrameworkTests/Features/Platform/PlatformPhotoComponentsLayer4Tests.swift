import Testing


import SwiftUI
@testable import SixLayerFramework
import ViewInspector

/// Tests for PlatformPhotoComponentsLayer4.swift
/// 
/// BUSINESS PURPOSE: Ensure all photo Layer 4 components generate proper accessibility identifiers
/// TESTING SCOPE: All components in PlatformPhotoComponentsLayer4.swift
/// METHODOLOGY: Test each component on both iOS and macOS platforms as required by mandatory testing guidelines
@MainActor
final class PlatformPhotoComponentsLayer4Tests {
    
    // MARK: - Test Setup
    
    init() {
        setupTestEnvironment()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
        config.enableAutoIDs = true
        config.namespace = "SixLayer"
        config.mode = .automatic
        config.enableDebugLogging = false
    }
    
    deinit {
        cleanupTestEnvironment()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
    }
    
    // MARK: - platformCameraInterface_L4 Tests
    
    @Test func testPlatformCameraInterfaceL4GeneratesAccessibilityIdentifiersOnIOS() async {
        let view = platformCameraInterface_L4(
            onImageCaptured: { _ in }
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.main.element.*", 
            platform: .iOS,
            componentName: "platformCameraInterface_L4"
        )
        
        #expect(hasAccessibilityID, "platformCameraInterface_L4 should generate accessibility identifiers on iOS")
    }
    
    @Test func testPlatformCameraInterfaceL4GeneratesAccessibilityIdentifiersOnMacOS() async {
        let view = platformCameraInterface_L4(
            onImageCaptured: { _ in }
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.main.element.*", 
            platform: .macOS,
            componentName: "platformCameraInterface_L4"
        )
        
        #expect(hasAccessibilityID, "platformCameraInterface_L4 should generate accessibility identifiers on macOS")
    }
}

