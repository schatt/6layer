import Testing


import SwiftUI
@testable import SixLayerFramework
import ViewInspector

/// Tests for IntelligentDetailView.swift
/// 
/// BUSINESS PURPOSE: Ensure IntelligentDetailView generates proper accessibility identifiers
/// TESTING SCOPE: All components in IntelligentDetailView.swift
/// METHODOLOGY: Test each component on both iOS and macOS platforms as required by mandatory testing guidelines
@MainActor
open class IntelligentDetailViewTests {
    
    // MARK: - Test Setup
    
    init() async throws {
        await setupTestEnvironment()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
        config.enableAutoIDs = true
        config.namespace = "SixLayer"
        config.mode = .automatic
        config.enableDebugLogging = false
    }    // MARK: - IntelligentDetailView Tests
    
    
    private func setupTestEnvironment() async {
        await AccessibilityTestUtilities.setupAccessibilityTestEnvironment()
    }
    
    private func cleanupTestEnvironment() async {
        await AccessibilityTestUtilities.cleanupAccessibilityTestEnvironment()
    }
    
@Test func testIntelligentDetailViewGeneratesAccessibilityIdentifiersOnIOS() async {
        let testData = TestDataModel(name: "Test Name", value: 42)
        
        let view = IntelligentDetailView.platformDetailView(for: testData)
        
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view, 
            expectedPattern: "SixLayer.main.element.*", 
            platform: .iOS,
            platform: .iOS,
            componentName: "IntelligentDetailView"
        )
        
        #expect(hasAccessibilityID, "IntelligentDetailView should generate accessibility identifiers on iOS")
    }
    
    @Test func testIntelligentDetailViewGeneratesAccessibilityIdentifiersOnMacOS() async {
        let testData = TestDataModel(name: "Test Name", value: 42)
        
        let view = IntelligentDetailView.platformDetailView(for: testData)
        
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view, 
            expectedPattern: "SixLayer.main.element.*", 
            platform: .macOS,
            platform: .iOS,
            componentName: "IntelligentDetailView"
        )
        
        #expect(hasAccessibilityID, "IntelligentDetailView should generate accessibility identifiers on macOS")
    }
}

// MARK: - Test Support Types

/// Test data model for IntelligentDetailView testing
struct TestDataModel {
    let name: String
    let value: Int
}
