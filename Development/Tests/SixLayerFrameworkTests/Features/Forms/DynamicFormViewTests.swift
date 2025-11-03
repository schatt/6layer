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

    @Test func testDynamicFormViewRendersTitleAndSectionsAndSubmitButton() async {
        // TDD: DynamicFormView should render:
        // 1. Form title from configuration
        // 2. All sections using DynamicFormSectionView
        // 3. Submit button that calls onSubmit callback
        // 4. Proper accessibility identifier

        let section1 = DynamicFormSection(
            id: "personal",
            title: "Personal Information",
            fields: [
                DynamicFormField(id: "name", contentType: .text, label: "Name", placeholder: "Enter name"),
                DynamicFormField(id: "email", contentType: .email, label: "Email", placeholder: "Enter email")
            ]
        )
        let section2 = DynamicFormSection(
            id: "preferences",
            title: "Preferences",
            fields: [
                DynamicFormField(id: "newsletter", contentType: .checkbox, label: "Subscribe to newsletter")
            ]
        )

        let configuration = DynamicFormConfiguration(
            id: "testForm",
            title: "User Registration",
            description: "Please fill out your information",
            sections: [section1, section2],
            submitButtonText: "Register",
            cancelButtonText: "Cancel"
        )

        var submittedData: [String: Any]? = nil
        let view = DynamicFormView(
            configuration: configuration,
            onSubmit: { data in submittedData = data }
        )

        // Should render proper form structure
        do {
            let inspected = try view.inspect()

            // Should have a VStack as root
            let vStack = try inspected.vStack()
            #expect(vStack.count >= 3, "Should have title, sections, and submit button")

            // Should have accessibility identifier
            let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
                view,
                expectedPattern: "SixLayer.main.ui.*DynamicFormView.*",
                platform: .iOS,
                componentName: "DynamicFormView"
            )
            #expect(hasAccessibilityID, "Should generate accessibility identifier")

        } catch {
            Issue.record("DynamicFormView inspection failed - component not properly implemented: \(error)")
        }
    }

    @Test func testDynamicFormSectionViewRendersSectionTitleAndFields() async {
        // TDD: DynamicFormSectionView should render:
        // 1. Section title from section configuration
        // 2. All fields in the section using DynamicFormFieldView
        // 3. Proper accessibility identifier
        // 4. VStack layout with proper alignment

        let section = DynamicFormSection(
            id: "contact",
            title: "Contact Information",
            fields: [
                DynamicFormField(id: "phone", contentType: .phone, label: "Phone", placeholder: "Enter phone"),
                DynamicFormField(id: "address", contentType: .textarea, label: "Address", placeholder: "Enter address")
            ]
        )

        let formState = DynamicFormState(configuration: DynamicFormConfiguration(
            id: "test", title: "Test", sections: [], submitButtonText: "Submit"
        ))

        let view = DynamicFormSectionView(section: section, formState: formState)

        // Should render proper section structure
        do {
            let inspected = try view.inspect()

            // Should have a VStack with leading alignment
            let vStack = try inspected.vStack()
            #expect(vStack.count >= 3, "Should have section title and field views")

            // First element should be the section title
            let titleText = try vStack.text(0)
            #expect(try titleText.string() == "Contact Information", "Should show section title")

            // Should have accessibility identifier
            let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
                view,
                expectedPattern: "SixLayer.main.ui.*DynamicFormSectionView.*",
                platform: .iOS,
                componentName: "DynamicFormSectionView"
            )
            #expect(hasAccessibilityID, "Should generate accessibility identifier")

        } catch {
            Issue.record("DynamicFormSectionView inspection failed - component not properly implemented: \(error)")
        }
    }

    @Test func testDynamicFormFieldViewRendersFieldUsingCustomFieldView() async {
        // TDD: DynamicFormFieldView should render:
        // 1. Field label from field configuration
        // 2. Use CustomFieldView to render the actual field control
        // 3. Proper accessibility identifier
        // 4. Pass form state to the field component

        let field = DynamicFormField(
            id: "username",
            contentType: .text,
            label: "Username",
            placeholder: "Choose a username",
            isRequired: true
        )

        let formState = DynamicFormState(configuration: DynamicFormConfiguration(
            id: "test", title: "Test", sections: [], submitButtonText: "Submit"
        ))

        let view = DynamicFormFieldView(field: field, formState: formState)

        // Should render proper field structure
        do {
            let inspected = try view.inspect()

            // Should have a VStack with leading alignment
            let vStack = try inspected.vStack()
            #expect(vStack.count >= 2, "Should have field label and field control")

            // First element should be the field label
            let labelText = try vStack.text(0)
            #expect(try labelText.string() == "Username", "Should show field label")

            // Should have accessibility identifier
            let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
                view,
                expectedPattern: "SixLayer.main.ui.*DynamicFormFieldView.*",
                platform: .iOS,
                componentName: "DynamicFormFieldView"
            )
            #expect(hasAccessibilityID, "Should generate accessibility identifier")

        } catch {
            Issue.record("DynamicFormFieldView inspection failed - component not properly implemented: \(error)")
        }
    }

    @Test func testFormWizardViewRendersStepsAndNavigation() async {
        // TDD: FormWizardView should render:
        // 1. Current step content using the content closure
        // 2. Navigation controls using the navigation closure
        // 3. Handle step progression (next/previous)
        // 4. Proper accessibility identifier

        let steps = [
            FormWizardStep(id: "step1", title: "Step 1", description: "First step", stepOrder: 1),
            FormWizardStep(id: "step2", title: "Step 2", description: "Second step", stepOrder: 2)
        ]

        let view = FormWizardView(
            steps: steps,
            content: { step, wizardState in
                Text("Content for \(step.title)")
            },
            navigation: { wizardState, onPrevious, onNext, onFinish in
                HStack {
                    Button("Previous", action: onPrevious)
                    Spacer()
                    if wizardState.isLastStep {
                        Button("Finish", action: onFinish)
                    } else {
                        Button("Next", action: onNext)
                    }
                }
            }
        )

        // Should render proper wizard structure
        do {
            let inspected = try view.inspect()

            // Should have a VStack
            let vStack = try inspected.vStack()
            #expect(vStack.count >= 2, "Should have content and navigation")

            // Should have accessibility identifier
            let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
                view,
                expectedPattern: "SixLayer.main.ui.*FormWizardView.*",
                platform: .iOS,
                componentName: "FormWizardView"
            )
            #expect(hasAccessibilityID, "Should generate accessibility identifier")

        } catch {
            Issue.record("FormWizardView inspection failed - component not properly implemented: \(error)")
        }
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

