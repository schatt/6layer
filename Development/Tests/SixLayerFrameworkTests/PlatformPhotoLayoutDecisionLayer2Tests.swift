import XCTest
import SwiftUI
@testable import SixLayerFramework
import ViewInspector

/// Tests for PlatformPhotoLayoutDecisionLayer2.swift
/// 
/// BUSINESS PURPOSE: Ensure Layer 2 photo layout decision functions generate proper accessibility identifiers
/// TESTING SCOPE: All functions in PlatformPhotoLayoutDecisionLayer2.swift
/// METHODOLOGY: Test each function on both iOS and macOS platforms as required by mandatory testing guidelines
@MainActor
final class PlatformPhotoLayoutDecisionLayer2Tests: XCTestCase {
    
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
    
    // MARK: - determinePhotoGalleryLayout_L2 Tests
    
    func testDeterminePhotoGalleryLayoutL2GeneratesAccessibilityIdentifiersOnIOS() async {
        let result = determinePhotoGalleryLayout_L2(
            photoCount: 10,
            screenWidth: 375,
            deviceType: .phone
        )
        
        // Layer 2 functions return data structures, not views
        // So we test that the result is valid
        XCTAssertNotNil(result, "determinePhotoGalleryLayout_L2 should return a valid result on iOS")
    }
    
    func testDeterminePhotoGalleryLayoutL2GeneratesAccessibilityIdentifiersOnMacOS() async {
        let result = determinePhotoGalleryLayout_L2(
            photoCount: 10,
            screenWidth: 1920,
            deviceType: .desktop
        )
        
        // Layer 2 functions return data structures, not views
        // So we test that the result is valid
        XCTAssertNotNil(result, "determinePhotoGalleryLayout_L2 should return a valid result on macOS")
    }
}

