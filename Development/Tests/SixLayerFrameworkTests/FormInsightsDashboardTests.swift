import XCTest
import SwiftUI
@testable import SixLayerFramework
import ViewInspector

/// Tests for FormInsightsDashboard.swift
/// 
/// BUSINESS PURPOSE: Ensure FormInsightsDashboard generates proper accessibility identifiers
/// TESTING SCOPE: All components in FormInsightsDashboard.swift
/// METHODOLOGY: Test each component on both iOS and macOS platforms as required by mandatory testing guidelines
@MainActor
final class FormInsightsDashboardTests: XCTestCase {
    
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
    
    // MARK: - FormInsightsDashboard Tests
    
    func testFormInsightsDashboardGeneratesAccessibilityIdentifiersOnIOS() async {
        let insights = FormInsights(
            formId: "test-form",
            analytics: nil,
            performance: nil,
            errors: [],
            recommendations: []
        )
        
        let view = FormInsightsDashboard(insights: insights)
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*forminsightsdashboard", 
            platform: .iOS,
            componentName: "FormInsightsDashboard"
        )
        
        XCTAssertTrue(hasAccessibilityID, "FormInsightsDashboard should generate accessibility identifiers on iOS")
    }
    
    func testFormInsightsDashboardGeneratesAccessibilityIdentifiersOnMacOS() async {
        let insights = FormInsights(
            formId: "test-form",
            analytics: nil,
            performance: nil,
            errors: [],
            recommendations: []
        )
        
        let view = FormInsightsDashboard(insights: insights)
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*forminsightsdashboard", 
            platform: .macOS,
            componentName: "FormInsightsDashboard"
        )
        
        XCTAssertTrue(hasAccessibilityID, "FormInsightsDashboard should generate accessibility identifiers on macOS")
    }
}

