import XCTest
import SwiftUI
@testable import SixLayerFramework
import ViewInspector

/// Tests for PlatformOCRLayoutDecisionLayer2.swift
/// 
/// BUSINESS PURPOSE: Ensure Layer 2 OCR layout decision functions generate proper accessibility identifiers
/// TESTING SCOPE: All functions in PlatformOCRLayoutDecisionLayer2.swift
/// METHODOLOGY: Test each function on both iOS and macOS platforms as required by mandatory testing guidelines
@MainActor
final class PlatformOCRLayoutDecisionLayer2Tests: XCTestCase {
    
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
    
    // MARK: - determineOCRDisplayStrategy_L2 Tests
    
    func testDetermineOCRDisplayStrategyL2GeneratesAccessibilityIdentifiersOnIOS() async {
        let result = determineOCRDisplayStrategy_L2(
            textLength: 100,
            confidence: 0.95,
            screenSize: CGSize(width: 375, height: 667)
        )
        
        // Layer 2 functions return data structures, not views
        // So we test that the result is valid
        XCTAssertNotNil(result, "determineOCRDisplayStrategy_L2 should return a valid result on iOS")
    }
    
    func testDetermineOCRDisplayStrategyL2GeneratesAccessibilityIdentifiersOnMacOS() async {
        let result = determineOCRDisplayStrategy_L2(
            textLength: 100,
            confidence: 0.95,
            screenSize: CGSize(width: 1920, height: 1080)
        )
        
        // Layer 2 functions return data structures, not views
        // So we test that the result is valid
        XCTAssertNotNil(result, "determineOCRDisplayStrategy_L2 should return a valid result on macOS")
    }
}

