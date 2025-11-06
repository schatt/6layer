import Testing


import SwiftUI
@testable import SixLayerFramework
import ViewInspector
/// Tests for ModalFormView component
/// 
/// BUSINESS PURPOSE: Ensure ModalFormView generates proper accessibility identifiers
/// TESTING SCOPE: ModalFormView component from PlatformSemanticLayer1.swift
/// METHODOLOGY: Test component on both iOS and macOS platforms as required by mandatory testing guidelines
@Suite("Modal Form View")
@MainActor
open class ModalFormViewTests: BaseTestClass {
    
    @Test func testModalFormViewGeneratesAccessibilityIdentifiersOnIOS() async {
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
        
        let view = withTestConfig(ModalFormView(
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
        ))
        
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view, 
            expectedPattern: "SixLayer.main.ui.*", 
            platform: SixLayerPlatform.iOS,
            componentName: "ModalFormView"
        )
        
        #expect(hasAccessibilityID, "ModalFormView should generate accessibility identifiers on iOS")
    }
    
    @Test func testModalFormViewGeneratesAccessibilityIdentifiersOnMacOS() async {
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
        
        let view = withTestConfig(ModalFormView(
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
        ))
        
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view, 
            expectedPattern: "SixLayer.main.ui.*", 
            platform: SixLayerPlatform.macOS,
            componentName: "ModalFormView"
        )
        
        #expect(hasAccessibilityID, "ModalFormView should generate accessibility identifiers on macOS")
    }
}
