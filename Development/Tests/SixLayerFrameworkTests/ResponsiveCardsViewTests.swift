import XCTest
import SwiftUI
@testable import SixLayerFramework
import ViewInspector

/// Tests for ResponsiveCardsView.swift
/// 
/// BUSINESS PURPOSE: Ensure ResponsiveCardsView components generate proper accessibility identifiers
/// TESTING SCOPE: All components in ResponsiveCardsView.swift
/// METHODOLOGY: Test each component on both iOS and macOS platforms as required by mandatory testing guidelines
@MainActor
final class ResponsiveCardsViewTests: XCTestCase {
    
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
    
    // MARK: - ResponsiveCardView Tests
    
    func testResponsiveCardViewGeneratesAccessibilityIdentifiersOnIOS() async {
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
            expectedPattern: "SixLayer.*element.*responsivecardview", 
            platform: .iOS,
            componentName: "ResponsiveCardView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "ResponsiveCardView should generate accessibility identifiers on iOS")
    }
    
    func testResponsiveCardViewGeneratesAccessibilityIdentifiersOnMacOS() async {
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
            expectedPattern: "SixLayer.*element.*responsivecardview", 
            platform: .macOS,
            componentName: "ResponsiveCardView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "ResponsiveCardView should generate accessibility identifiers on macOS")
    }
}

