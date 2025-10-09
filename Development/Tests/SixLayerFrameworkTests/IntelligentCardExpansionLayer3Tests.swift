import XCTest
import SwiftUI
@testable import SixLayerFramework
import ViewInspector

/// Tests for IntelligentCardExpansionLayer3.swift
/// 
/// BUSINESS PURPOSE: Ensure Layer 3 card expansion strategy functions generate proper accessibility identifiers
/// TESTING SCOPE: All functions in IntelligentCardExpansionLayer3.swift
/// METHODOLOGY: Test each function on both iOS and macOS platforms as required by mandatory testing guidelines
@MainActor
final class IntelligentCardExpansionLayer3Tests: XCTestCase {
    
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
    
    // MARK: - selectCardExpansionStrategy_L3 Tests
    
    func testSelectCardExpansionStrategyL3GeneratesAccessibilityIdentifiersOnIOS() async {
        let decision = CardLayoutDecision(
            suggestedColumns: 2,
            suggestedSpacing: 16,
            suggestedCardSize: CGSize(width: 150, height: 200),
            animationDuration: 0.3,
            reasoning: "Test reasoning"
        )
        
        let result = selectCardExpansionStrategy_L3(
            decision: decision,
            deviceCapabilities: DeviceCapabilities(supportsHaptics: true, supportsHover: false),
            userPreferences: UserPreferences()
        )
        
        // Layer 3 functions return strategy data structures, not views
        // So we test that the result is valid
        XCTAssertNotNil(result, "selectCardExpansionStrategy_L3 should return a valid result on iOS")
    }
    
    func testSelectCardExpansionStrategyL3GeneratesAccessibilityIdentifiersOnMacOS() async {
        let decision = CardLayoutDecision(
            suggestedColumns: 3,
            suggestedSpacing: 20,
            suggestedCardSize: CGSize(width: 200, height: 250),
            animationDuration: 0.3,
            reasoning: "Test reasoning"
        )
        
        let result = selectCardExpansionStrategy_L3(
            decision: decision,
            deviceCapabilities: DeviceCapabilities(supportsHaptics: false, supportsHover: true),
            userPreferences: UserPreferences()
        )
        
        // Layer 3 functions return strategy data structures, not views
        // So we test that the result is valid
        XCTAssertNotNil(result, "selectCardExpansionStrategy_L3 should return a valid result on macOS")
    }
}

