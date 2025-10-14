import Testing
import SwiftUI
@testable import SixLayerFramework
import ViewInspector

/// Tests for ResponsiveCardsView.swift
/// 
/// BUSINESS PURPOSE: Ensure ResponsiveCardsView components generate proper accessibility identifiers
/// TESTING SCOPE: All components in ResponsiveCardsView.swift
/// METHODOLOGY: Test each component on both iOS and macOS platforms as required by mandatory testing guidelines
@MainActor
final class ResponsiveCardsViewTests {
    
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
    
    // MARK: - ResponsiveCardView Tests
    
    @Test func testResponsiveCardViewGeneratesAccessibilityIdentifiersOnIOS() async {
        let testData = ResponsiveCardData(
            title: "Test Card",
            subtitle: "Test Subtitle",
            icon: "doc.text",
            color: .blue,
            complexity: .moderate
        )
        
        let view = ResponsiveCardView(data: testData)
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.main.element.*", 
            platform: .iOS,
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
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.main.element.*", 
            platform: .macOS,
            componentName: "ResponsiveCardView"
        )
        
        #expect(hasAccessibilityID, "ResponsiveCardView should generate accessibility identifiers on macOS")
    }
}

