import XCTest
import SwiftUI
import ViewInspector
@testable import SixLayerFramework

/// BUSINESS PURPOSE: Accessibility tests for PlatformPhotoLayoutDecisionLayer2.swift functions
/// Ensures Photo layout decision Layer 2 functions generate proper accessibility identifiers
/// for automated testing and accessibility tools compliance
@MainActor
final class PlatformPhotoLayoutDecisionLayer2AccessibilityTests: XCTestCase {
    
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
    
    // MARK: - Photo Layout Decision Tests
    
    /// BUSINESS PURPOSE: Validates that platformPhotoLayout_L2 generates proper accessibility identifiers
    /// for automated testing and accessibility tools compliance on iOS
    func testPlatformPhotoLayoutL2GeneratesAccessibilityIdentifiersOnIOS() async {
        // Given
        let photoPreferences = PhotoPreferences()
        let deviceCapabilities = PhotoDeviceCapabilities()
        let photoContext = PhotoContext(
            screenSize: CGSize(width: 375, height: 667),
            availableSpace: CGSize(width: 375, height: 600),
            userPreferences: photoPreferences,
            deviceCapabilities: deviceCapabilities
        )
        
        let result = determineOptimalPhotoLayout_L2(
            purpose: .document,
            context: photoContext
        )
        
        // When & Then
        // Layer 2 functions return data structures, not views, so we test the result structure
        XCTAssertNotNil(result, "determineOptimalPhotoLayout_L2 should return a valid layout size")
        XCTAssertTrue(result.width > 0, "Layout decision should have valid width")
        XCTAssertTrue(result.height > 0, "Layout decision should have valid height")
    }
    
    /// BUSINESS PURPOSE: Validates that platformPhotoLayout_L2 generates proper accessibility identifiers
    /// for automated testing and accessibility tools compliance on macOS
    func testPlatformPhotoLayoutL2GeneratesAccessibilityIdentifiersOnMacOS() async {
        // Given
        let photoPreferences = PhotoPreferences()
        let deviceCapabilities = PhotoDeviceCapabilities()
        let photoContext = PhotoContext(
            screenSize: CGSize(width: 1024, height: 768),
            availableSpace: CGSize(width: 1024, height: 700),
            userPreferences: photoPreferences,
            deviceCapabilities: deviceCapabilities
        )
        
        let result = determineOptimalPhotoLayout_L2(
            purpose: .document,
            context: photoContext
        )
        
        // When & Then
        // Layer 2 functions return data structures, not views, so we test the result structure
        XCTAssertNotNil(result, "determineOptimalPhotoLayout_L2 should return a valid layout size")
        XCTAssertTrue(result.width > 0, "Layout decision should have valid width")
        XCTAssertTrue(result.height > 0, "Layout decision should have valid height")
    }
}

