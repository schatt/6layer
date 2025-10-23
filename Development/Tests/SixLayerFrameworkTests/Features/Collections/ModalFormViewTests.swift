import Testing


import SwiftUI
@testable import SixLayerFramework
import ViewInspector

/// Tests for ModalFormView component
/// 
/// BUSINESS PURPOSE: Ensure ModalFormView generates proper accessibility identifiers
/// TESTING SCOPE: ModalFormView component from PlatformSemanticLayer1.swift
/// METHODOLOGY: Test component on both iOS and macOS platforms as required by mandatory testing guidelines
@MainActor
open class ModalFormViewTests {
    
    // MARK: - Helper Methods
    
    private func setupTestEnvironment() async {
        await AccessibilityTestUtilities.setupAccessibilityTestEnvironment()
    }
    
    private func configureAccessibilityIdentifiers() {
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
        config.enableAutoIDs = true
        config.namespace = "SixLayer"
        config.mode = .automatic
        config.enableDebugLogging = false
    }
    
    // MARK: - ModalFormView Tests
    
    private func cleanupTestEnvironment() async {
        await AccessibilityTestUtilities.cleanupAccessibilityTestEnvironment()
    }
    
    @Test func testModalFormViewGeneratesAccessibilityIdentifiersOnIOS() async {
        // Setup test environment
        await setupTestEnvironment()
        configureAccessibilityIdentifiers()
        
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
        
        let view = ModalFormView(
            fields: testFields,
            formType: .generic,
            context: .modal,
            hints: PresentationHints(
                dataType: .generic,
                presentationPreference: .automatic,
                complexity: .moderate,
                context: .modal,
                customPreferences: [:]
            )
        )
        
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view, 
            expectedPattern: "SixLayer.main.element.*", 
            platform: SixLayerPlatform.iOS,
            componentName: "ModalFormView"
        )
        
        #expect(hasAccessibilityID, "ModalFormView should generate accessibility identifiers on iOS")
    }
    
    @Test func testModalFormViewGeneratesAccessibilityIdentifiersOnMacOS() async {
        // Setup test environment
        await setupTestEnvironment()
        configureAccessibilityIdentifiers()
        
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
        
        let view = ModalFormView(
            fields: testFields,
            formType: .generic,
            context: .modal,
            hints: PresentationHints(
                dataType: .generic,
                presentationPreference: .automatic,
                complexity: .moderate,
                context: .modal,
                customPreferences: [:]
            )
        )
        
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view, 
            expectedPattern: "SixLayer.main.element.*", 
            platform: SixLayerPlatform.iOS,
            componentName: "ModalFormView"
        )
        
        #expect(hasAccessibilityID, "ModalFormView should generate accessibility identifiers on macOS")
    }
}
