import Testing


import SwiftUI
@testable import SixLayerFramework
import ViewInspector

/// Tests for IntelligentFormView.swift
/// 
/// BUSINESS PURPOSE: Ensure IntelligentFormView generates proper accessibility identifiers
/// TESTING SCOPE: All components in IntelligentFormView.swift
/// METHODOLOGY: Test each component on both iOS and macOS platforms as required by mandatory testing guidelines
@MainActor
final class IntelligentFormViewTests {
    
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
    
    // MARK: - IntelligentFormView Tests
    
    
    private func setupTestEnvironment() async {
        await AccessibilityTestUtilities.setupAccessibilityTestEnvironment()
    }
    
    private func cleanupTestEnvironment() async {
        await AccessibilityTestUtilities.cleanupAccessibilityTestEnvironment()
    }
    
@Test func testIntelligentFormViewGeneratesAccessibilityIdentifiersOnIOS() async {
        let testData = TestFormDataModel(name: "Test Name", email: "test@example.com")
        
        let view = IntelligentFormView.generateForm(
            for: TestFormDataModel.self,
            initialData: testData
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.main.element.*", 
            platform: .iOS,
            componentName: "IntelligentFormView"
        )
        
        #expect(hasAccessibilityID, "IntelligentFormView should generate accessibility identifiers on iOS")
    }
    
    @Test func testIntelligentFormViewGeneratesAccessibilityIdentifiersOnMacOS() async {
        let testData = TestFormDataModel(name: "Test Name", email: "test@example.com")
        
        let view = IntelligentFormView.generateForm(
            for: TestFormDataModel.self,
            initialData: testData
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.main.element.*", 
            platform: .macOS,
            componentName: "IntelligentFormView"
        )
        
        #expect(hasAccessibilityID, "IntelligentFormView should generate accessibility identifiers on macOS")
    }
}

// MARK: - Test Support Types

/// Test form data model for IntelligentFormView testing
struct TestFormDataModel {
    let name: String
    let email: String
}
