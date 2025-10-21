import Testing


import SwiftUI
@testable import SixLayerFramework
import ViewInspector

/// Tests for GenericFormView component
/// 
/// BUSINESS PURPOSE: Ensure GenericFormView generates proper accessibility identifiers
/// TESTING SCOPE: GenericFormView component from PlatformSemanticLayer1.swift
/// METHODOLOGY: Test component on both iOS and macOS platforms as required by mandatory testing guidelines
@MainActor
open class GenericFormViewTests {
    
    // MARK: - Test Setup
    
    init() async throws {
        await setupTestEnvironment()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
        config.enableAutoIDs = true
        config.namespace = "SixLayer"
        config.mode = .automatic
        config.enableDebugLogging = false
    }    // MARK: - GenericFormView Tests
    
    
    private func setupTestEnvironment() async {
        await AccessibilityTestUtilities.setupAccessibilityTestEnvironment()
    }
    
    private func cleanupTestEnvironment() async {
        await AccessibilityTestUtilities.cleanupAccessibilityTestEnvironment()
    }
    
@Test func testGenericFormViewGeneratesAccessibilityIdentifiersOnIOS() async {
        let testFields = [
            DynamicFormField(
                id: "field1",
                contentType: .text,
                label: "Test Field 1",
                placeholder: "Enter text",
                isRequired: true,
                validationRules: [:]
            )
        ]
        
        let view = GenericFormView(
            fields: testFields,
            hints: PresentationHints()
        )
        
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view, 
            expectedPattern: "SixLayer.main.element.*", 
            platform: SixLayerPlatform.iOS,
            componentName: "GenericFormView"
        )
        
        #expect(hasAccessibilityID, "GenericFormView should generate accessibility identifiers on iOS")
    }
    
    @Test func testGenericFormViewGeneratesAccessibilityIdentifiersOnMacOS() async {
        let testFields = [
            DynamicFormField(
                id: "field1",
                contentType: .text,
                label: "Test Field 1",
                placeholder: "Enter text",
                isRequired: true,
                validationRules: [:]
            )
        ]
        
        let view = GenericFormView(
            fields: testFields,
            hints: PresentationHints()
        )
        
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view, 
            expectedPattern: "SixLayer.main.element.*", 
            platform: .macOS,
            platform: SixLayerPlatform.iOS,
            componentName: "GenericFormView"
        )
        
        #expect(hasAccessibilityID, "GenericFormView should generate accessibility identifiers on macOS")
    }
}
