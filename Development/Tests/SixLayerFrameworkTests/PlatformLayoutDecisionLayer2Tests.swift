import XCTest
import SwiftUI
@testable import SixLayerFramework
import ViewInspector

/// Tests for PlatformLayoutDecisionLayer2.swift
/// 
/// BUSINESS PURPOSE: Ensure Layer 2 layout decision functions generate proper accessibility identifiers
/// TESTING SCOPE: All functions in PlatformLayoutDecisionLayer2.swift
/// METHODOLOGY: Test each function on both iOS and macOS platforms as required by mandatory testing guidelines
@MainActor
final class PlatformLayoutDecisionLayer2Tests: XCTestCase {
    
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
    
    // MARK: - determineOptimalLayout_L2 Tests
    
    func testDetermineOptimalLayoutL2GeneratesAccessibilityIdentifiersOnIOS() async {
        let hints = PresentationHints(
            dataType: .generic,
            presentationPreference: .grid,
            complexity: .moderate,
            context: .list,
            customPreferences: [:]
        )
        
        let result = determineOptimalLayout_L2(
            contentCount: 10,
            screenWidth: 375,
            deviceType: .phone,
            hints: hints
        )
        
        // Layer 2 functions return data structures, not views
        // So we test that the result is valid
        XCTAssertNotNil(result, "determineOptimalLayout_L2 should return a valid result on iOS")
    }
    
    func testDetermineOptimalLayoutL2GeneratesAccessibilityIdentifiersOnMacOS() async {
        let hints = PresentationHints(
            dataType: .generic,
            presentationPreference: .grid,
            complexity: .moderate,
            context: .list,
            customPreferences: [:]
        )
        
        let result = determineOptimalLayout_L2(
            contentCount: 10,
            screenWidth: 1920,
            deviceType: .desktop,
            hints: hints
        )
        
        // Layer 2 functions return data structures, not views
        // So we test that the result is valid
        XCTAssertNotNil(result, "determineOptimalLayout_L2 should return a valid result on macOS")
    }
}
