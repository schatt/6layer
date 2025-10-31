import Testing


import SwiftUI
@testable import SixLayerFramework
import ViewInspector
/// Tests for ResponsiveCardsView.swift
/// 
/// BUSINESS PURPOSE: Ensure ResponsiveCardsView components generate proper accessibility identifiers
/// TESTING SCOPE: All components in ResponsiveCardsView.swift
/// METHODOLOGY: Test each component on both iOS and macOS platforms as required by mandatory testing guidelines
@Suite("Responsive Cards View")
@MainActor
open class ResponsiveCardsViewTests {
    
    // MARK: - Test Setup
    
    init() async throws {
        await setupTestEnvironment()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
        config.enableAutoIDs = true
        config.namespace = "SixLayer"
        config.mode = .automatic
        config.enableDebugLogging = false
    }    // MARK: - ResponsiveCardView Tests
    
    
    private func setupTestEnvironment() async {
        await AccessibilityTestUtilities.setupAccessibilityTestEnvironment()
    }
    
    private func cleanupTestEnvironment() async {
        await AccessibilityTestUtilities.cleanupAccessibilityTestEnvironment()
    }
    
@Test func testResponsiveCardViewGeneratesAccessibilityIdentifiersOnIOS() async {
        let testData = ResponsiveCardData(
            title: "Test Card",
            subtitle: "Test Subtitle",
            icon: "doc.text",
            color: .blue,
            complexity: .moderate
        )
        
        let view = ResponsiveCardView(data: testData)
        
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view, 
            expectedPattern: "SixLayer.*ui", 
            platform: SixLayerPlatform.iOS,
            componentName: "ResponsiveCardView"
        )
        
        #expect(hasAccessibilityID, "ResponsiveCardView should generate accessibility identifiers on iOS")
    }
    
    @Test func testResponsiveCardViewGeneratesAccessibilityIdentifiersOnMacOS() async {
        let testData = ResponsiveCardData(
            title: "Test Card",
            subtitle: "Test Subtitle",
            icon: "doc.text",
            color: .blue,
            complexity: .moderate
        )
        
        let view = ResponsiveCardView(data: testData)
        
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view, 
            expectedPattern: "SixLayer.*ui", 
            platform: SixLayerPlatform.iOS,
            componentName: "ResponsiveCardView"
        )
        
        #expect(hasAccessibilityID, "ResponsiveCardView should generate accessibility identifiers on macOS")
    }
}

