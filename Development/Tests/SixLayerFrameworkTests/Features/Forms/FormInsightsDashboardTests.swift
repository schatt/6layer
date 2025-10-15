import Testing


import SwiftUI
@testable import SixLayerFramework
import ViewInspector

/// Tests for FormInsightsDashboard.swift
/// 
/// BUSINESS PURPOSE: Ensure FormInsightsDashboard generates proper accessibility identifiers
/// TESTING SCOPE: All components in FormInsightsDashboard.swift
/// METHODOLOGY: Test each component on both iOS and macOS platforms as required by mandatory testing guidelines
@MainActor
final class FormInsightsDashboardTests {
    
    // MARK: - Test Setup
    
    init() async throws {
        await setupTestEnvironment()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
        config.enableAutoIDs = true
        config.namespace = "SixLayer"
        config.mode = .automatic
        config.enableDebugLogging = false
    }
    
    deinit {
        Task { [weak self] in
            await self?.cleanupTestEnvironment()
        }
    }
    
    // MARK: - FormInsightsDashboard Tests
    
    
    override func setupTestEnvironment() async {
        await AccessibilityTestUtilities.setupAccessibilityTestEnvironment()
    }
    
    override func cleanupTestEnvironment() async {
        await AccessibilityTestUtilities.cleanupAccessibilityTestEnvironment()
    }
    
@Test func testFormInsightsDashboardGeneratesAccessibilityIdentifiersOnIOS() async {
        let insights = FormInsights(
            formId: "test-form",
            analytics: nil,
            performance: nil,
            errors: [],
            recommendations: []
        )
        
        // Verify insights are properly configured
        #expect(insights.formId == "test-form", "Insights should have correct form ID")
        #expect(insights.errors.isEmpty, "Insights should have empty errors initially")
        #expect(insights.recommendations.isEmpty, "Insights should have empty recommendations initially")
        
        let view = FormInsightsDashboard()
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.main.element.*", 
            platform: .iOS,
            componentName: "FormInsightsDashboard"
        )
        
        #expect(hasAccessibilityID, "FormInsightsDashboard should generate accessibility identifiers on iOS")
    }
    
    @Test func testFormInsightsDashboardGeneratesAccessibilityIdentifiersOnMacOS() async {
        let insights = FormInsights(
            formId: "test-form",
            analytics: nil,
            performance: nil,
            errors: [],
            recommendations: []
        )
        
        // Verify insights are properly configured
        #expect(insights.formId == "test-form", "Insights should have correct form ID")
        #expect(insights.errors.isEmpty, "Insights should have empty errors initially")
        #expect(insights.recommendations.isEmpty, "Insights should have empty recommendations initially")
        
        let view = FormInsightsDashboard()
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.main.element.*", 
            platform: .macOS,
            componentName: "FormInsightsDashboard"
        )
        
        #expect(hasAccessibilityID, "FormInsightsDashboard should generate accessibility identifiers on macOS")
    }
}

