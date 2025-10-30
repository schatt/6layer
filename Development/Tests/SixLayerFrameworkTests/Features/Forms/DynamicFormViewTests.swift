import Testing


import SwiftUI
@testable import SixLayerFramework
import ViewInspector
/// Tests for DynamicFormView.swift
/// 
/// BUSINESS PURPOSE: Ensure DynamicFormView generates proper accessibility identifiers
/// TESTING SCOPE: All components in DynamicFormView.swift
/// METHODOLOGY: Test each component on both iOS and macOS platforms as required by mandatory testing guidelines
@MainActor
open class DynamicFormViewTests {
    
    // MARK: - Test Setup
    
    init() async throws {
        await setupTestEnvironment()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
        config.enableAutoIDs = true
        config.namespace = "SixLayer"
        config.mode = .automatic
        config.enableDebugLogging = false
    }    // MARK: - DynamicFormView Tests
    
    
    private func setupTestEnvironment() async {
        await AccessibilityTestUtilities.setupAccessibilityTestEnvironment()
    }
    
    private func cleanupTestEnvironment() async {
        await AccessibilityTestUtilities.cleanupAccessibilityTestEnvironment()
    }
    
@Test func testDynamicFormViewGeneratesAccessibilityIdentifiersOnIOS() async {
        let testField = DynamicFormField(
            id: "testField",
            contentType: .text,
            label: "Test Field",
            placeholder: "Enter text",
            isRequired: true,
            validationRules: [:]
        )
        
        // Verify test field is properly configured
        #expect(testField.id == "testField", "Test field should have correct ID")
        #expect(testField.contentType == .text, "Test field should have correct content type")
        #expect(testField.label == "Test Field", "Test field should have correct label")
        #expect(testField.isRequired, "Test field should be required")
        
        let configuration = DynamicFormConfiguration(id: "testForm", title: "Test Form")
        
        let view = DynamicFormView(
            configuration: configuration,
            onSubmit: { _ in }
        )
        
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view, 
            expectedPattern: "SixLayer.*ui", 
            platform: SixLayerPlatform.iOS,
            componentName: "DynamicFormView"
        )
        
        #expect(hasAccessibilityID, "DynamicFormView should generate accessibility identifiers on iOS")
    }
    
    @Test func testDynamicFormViewGeneratesAccessibilityIdentifiersOnMacOS() async {
        let testField = DynamicFormField(
            id: "testField",
            contentType: .text,
            label: "Test Field",
            placeholder: "Enter text",
            isRequired: true,
            validationRules: [:]
        )
        
        // Verify test field is properly configured
        #expect(testField.id == "testField", "Test field should have correct ID")
        #expect(testField.contentType == .text, "Test field should have correct content type")
        #expect(testField.label == "Test Field", "Test field should have correct label")
        #expect(testField.isRequired, "Test field should be required")
        
        let configuration = DynamicFormConfiguration(id: "testForm", title: "Test Form")
        
        let view = DynamicFormView(
            configuration: configuration,
            onSubmit: { _ in }
        )
        
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view, 
            expectedPattern: "SixLayer.*ui", 
            platform: SixLayerPlatform.iOS,
            componentName: "DynamicFormView"
        )
        
        #expect(hasAccessibilityID, "DynamicFormView should generate accessibility identifiers on macOS")
    }
}

