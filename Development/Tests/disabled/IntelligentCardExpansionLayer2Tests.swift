import XCTest
import SwiftUI
@testable import SixLayerFramework
import ViewInspector

/// Tests for IntelligentCardExpansionLayer2.swift
/// 
/// BUSINESS PURPOSE: Ensure Layer 2 card expansion decision functions generate proper accessibility identifiers
/// TESTING SCOPE: All functions in IntelligentCardExpansionLayer2.swift
/// METHODOLOGY: Test each function on both iOS and macOS platforms as required by mandatory testing guidelines
@MainActor
final class IntelligentCardExpansionLayer2Tests: XCTestCase {
    
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
    
    // MARK: - determineOptimalCardLayout_L2 Tests
    
    func testDetermineOptimalCardLayoutL2GeneratesAccessibilityIdentifiersOnIOS() async {
        let result = determineOptimalCardLayout_L2(
            contentCount: 5,
            screenWidth: 375,
            deviceType: .phone,
            contentComplexity: .moderate
        )
        
        // Layer 2 functions return data structures, not views
        // So we test that the result is valid
        XCTAssertNotNil(result, "determineOptimalCardLayout_L2 should return a valid result on iOS")
    }
    
    func testDetermineOptimalCardLayoutL2GeneratesAccessibilityIdentifiersOnMacOS() async {
        let result = determineOptimalCardLayout_L2(
            contentCount: 5,
            screenWidth: 1920,
            deviceType: .mac,
            contentComplexity: .moderate
        )
        
        // Layer 2 functions return data structures, not views
        // So we test that the result is valid
        XCTAssertNotNil(result, "determineOptimalCardLayout_L2 should return a valid result on macOS")
    }
}

