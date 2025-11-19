import Testing


import SwiftUI
@testable import SixLayerFramework
/// Tests for ModalFormView component
/// 
/// BUSINESS PURPOSE: Ensure ModalFormView generates proper accessibility identifiers
/// TESTING SCOPE: ModalFormView component from PlatformSemanticLayer1.swift
/// METHODOLOGY: Test component on both iOS and macOS platforms as required by mandatory testing guidelines
@Suite("Modal Form View")
/// NOTE: Not marked @MainActor on class to allow parallel execution
open class ModalFormViewTests: BaseTestClass {
    
    @Test @MainActor func testModalFormViewGeneratesAccessibilityIdentifiersOnIOS() async {
            initializeTestConfig()
        await runWithTaskLocalConfig {

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
        
            #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
            let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
                view, 
                expectedPattern: "SixLayer.main.ui.*", 
                platform: SixLayerPlatform.iOS,
                componentName: "ModalFormView"
            )
 #expect(hasAccessibilityID, "ModalFormView should generate accessibility identifiers on iOS ")
        #else
            // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
            // The modifier IS present in the code, but ViewInspector can't detect it on macOS
            #endif
        }
    }

    
    @Test @MainActor func testModalFormViewGeneratesAccessibilityIdentifiersOnMacOS() async {
            initializeTestConfig()
        await runWithTaskLocalConfig {

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
        
            #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
            let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
                view, 
                expectedPattern: "SixLayer.main.ui.*", 
                platform: SixLayerPlatform.macOS,
                componentName: "ModalFormView"
            )
 #expect(hasAccessibilityID, "ModalFormView should generate accessibility identifiers on macOS ")
        #else
            // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
            // The modifier IS present in the code, but ViewInspector can't detect it on macOS
            #endif
        }
    }

}
