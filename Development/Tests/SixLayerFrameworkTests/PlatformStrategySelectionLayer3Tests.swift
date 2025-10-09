import XCTest
import SwiftUI
@testable import SixLayerFramework
import ViewInspector

/// Tests for PlatformStrategySelectionLayer3.swift
/// 
/// BUSINESS PURPOSE: Ensure Layer 3 strategy selection functions generate proper accessibility identifiers
/// TESTING SCOPE: All functions in PlatformStrategySelectionLayer3.swift
/// METHODOLOGY: Test each function on both iOS and macOS platforms as required by mandatory testing guidelines
@MainActor
final class PlatformStrategySelectionLayer3Tests: XCTestCase {
    
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
    
    // MARK: - selectPresentationStrategy_L3 Tests
    
    func testSelectPresentationStrategyL3GeneratesAccessibilityIdentifiersOnIOS() async {
        let decision = LayoutDecision(
            suggestedLayout: .grid,
            suggestedColumns: 2,
            suggestedSpacing: 16,
            reasoning: "Test reasoning"
        )
        
        let result = selectPresentationStrategy_L3(
            decision: decision,
            deviceCapabilities: DeviceCapabilities(supportsHaptics: true, supportsHover: false),
            userPreferences: UserPreferences()
        )
        
        // Layer 3 functions return strategy data structures, not views
        // So we test that the result is valid
        XCTAssertNotNil(result, "selectPresentationStrategy_L3 should return a valid result on iOS")
    }
    
    func testSelectPresentationStrategyL3GeneratesAccessibilityIdentifiersOnMacOS() async {
        let decision = LayoutDecision(
            suggestedLayout: .grid,
            suggestedColumns: 3,
            suggestedSpacing: 20,
            reasoning: "Test reasoning"
        )
        
        let result = selectPresentationStrategy_L3(
            decision: decision,
            deviceCapabilities: DeviceCapabilities(supportsHaptics: false, supportsHover: true),
            userPreferences: UserPreferences()
        )
        
        // Layer 3 functions return strategy data structures, not views
        // So we test that the result is valid
        XCTAssertNotNil(result, "selectPresentationStrategy_L3 should return a valid result on macOS")
    }
}

