import Testing


import SwiftUI
@testable import SixLayerFramework
import ViewInspector
/// Tests for DynamicFormView.swift
/// 
/// BUSINESS PURPOSE: Ensure DynamicFormView generates proper accessibility identifiers
/// TESTING SCOPE: All components in DynamicFormView.swift
/// METHODOLOGY: Test each component on both iOS and macOS platforms as required by mandatory testing guidelines
@Suite("Dynamic Form View")
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
        // Given: A DynamicFormView with configuration
        let configuration = DynamicFormConfiguration(
            id: "testForm",
            title: "Test Form",
            description: "A test form for accessibility testing",
            sections: [
                DynamicFormSection(
                    id: "testSection",
                    title: "Test Section",
                    fields: [
                        DynamicFormField(
                            id: "testField",
                            contentType: .text,
                            label: "Test Field",
                            placeholder: "Enter text",
                            isRequired: true
                        )
                    ]
                )
            ]
        )

        let view = DynamicFormView(
            configuration: configuration,
            onSubmit: { _ in /* Test callback */ }
        )

        // When: Testing accessibility identifier generation
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "SixLayer.*ui.*DynamicFormView.*",
            platform: SixLayerPlatform.iOS,
            componentName: "DynamicFormView"
        )

        // Then: Should generate accessibility identifiers
        #expect(hasAccessibilityID, "DynamicFormView should generate accessibility identifiers with component name on iOS")
    }
    
    @Test func testDynamicFormViewGeneratesAccessibilityIdentifiersOnMacOS() async {
        // Given: A DynamicFormView with configuration
        let configuration = DynamicFormConfiguration(
            id: "testForm",
            title: "Test Form",
            description: "A test form for accessibility testing",
            sections: [
                DynamicFormSection(
                    id: "testSection",
                    title: "Test Section",
                    fields: [
                        DynamicFormField(
                            id: "testField",
                            contentType: .text,
                            label: "Test Field",
                            placeholder: "Enter text",
                            isRequired: true
                        )
                    ]
                )
            ]
        )

        let view = DynamicFormView(
            configuration: configuration,
            onSubmit: { _ in /* Test callback */ }
        )

        // When: Testing accessibility identifier generation
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "SixLayer.*ui.*DynamicFormView.*",
            platform: SixLayerPlatform.macOS,
            componentName: "DynamicFormView"
        )

        // Then: Should generate accessibility identifiers
        #expect(hasAccessibilityID, "DynamicFormView should generate accessibility identifiers with component name on macOS")
    }
}

