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

    // MARK: - OCR Integration Tests

    @Test func testDynamicFormFieldCanBeConfiguredWithOCRSupport() async {
        // TDD: DynamicFormField should support OCR configuration
        // 1. Field should accept supportsOCR, ocrHint, and ocrValidationTypes
        // 2. Field should store these values correctly
        // 3. OCR configuration should be accessible for form processing

        let ocrHint = "Scan receipt for total amount"
        let expectedTypes: [TextType] = [.price, .number]

        let field = DynamicFormField(
            id: "receipt-total",
            contentType: .number,
            label: "Total Amount",
            placeholder: "Enter total",
            supportsOCR: true,
            ocrHint: ocrHint,
            ocrValidationTypes: expectedTypes
        )

        // Should store OCR configuration correctly
        #expect(field.supportsOCR == true, "Field should support OCR")
        #expect(field.ocrHint == ocrHint, "Field should store OCR hint")
        #expect(field.ocrValidationTypes == expectedTypes, "Field should store OCR validation types")
    }

    @Test func testDynamicFormFieldDefaultsToNoOCRSupport() async {
        // TDD: DynamicFormField should default to no OCR support
        // 1. Fields without OCR config should default to false
        // 2. OCR-related properties should be nil by default

        let field = DynamicFormField(
            id: "simple-field",
            contentType: .text,
            label: "Simple Field"
        )

        // Should default to no OCR support
        #expect(field.supportsOCR == false, "Field should default to no OCR support")
        #expect(field.ocrHint == nil, "OCR hint should be nil by default")
        #expect(field.ocrValidationTypes == nil, "OCR validation types should be nil by default")
    }

    @Test func testDynamicFormViewRendersOCRButtonForOCREnabledFields() async {
        // TDD: DynamicFormView should show OCR UI for OCR-enabled fields
        // 1. OCR-enabled fields should show an OCR trigger button/icon
        // 2. OCR button should be accessible
        // 3. Non-OCR fields should not show OCR button

        let ocrField = DynamicFormField(
            id: "ocr-field",
            contentType: .text,
            label: "OCR Field",
            supportsOCR: true,
            ocrHint: "Scan text document"
        )

        let regularField = DynamicFormField(
            id: "regular-field",
            contentType: .text,
            label: "Regular Field"
        )

        let testConfig = DynamicFormConfiguration(
            id: "test-form",
            title: "Test Form",
            description: "Test form for OCR",
            sections: [],
            submitButtonText: "Submit",
            cancelButtonText: "Cancel"
        )
        let formState = DynamicFormState(configuration: testConfig)
        formState.initializeField(ocrField)
        formState.initializeField(regularField)

        // Currently this will fail - OCR UI not implemented yet
        // TODO: Implement OCR button rendering in CustomFieldView/DynamicTextField

        let ocrFieldView = CustomFieldView(field: ocrField, formState: formState)
        let regularFieldView = CustomFieldView(field: regularField, formState: formState)

        // OCR field should show OCR button (will fail until implemented)
        do {
            let inspected = try ocrFieldView.inspect()
            // Look for OCR button by finding the HStack that contains both TextField and Button
            let hStack = try inspected.find(ViewType.HStack.self)
            // The HStack should have 2 children: TextField and Button
            #expect(hStack.count == 2, "OCR field HStack should contain TextField and OCR button")
        } catch {
            Issue.record("OCR button not implemented yet: \(error)")
        }

        // Regular field should not show OCR button (no HStack)
        do {
            let inspected = try regularFieldView.inspect()
            // Regular field should not have HStack (just VStack with label and TextField)
            let hStack = try? inspected.find(ViewType.HStack.self)
            #expect(hStack == nil, "Regular field should not have HStack (no OCR button)")
        } catch {
            // Expected - regular field structure is different
        }
    }

    @Test func testOCRWorkflowCanPopulateFormField() async {
        // TDD: OCR workflow should be able to populate form fields
        // 1. OCR results should be able to update form state
        // 2. OCR disambiguation should work with form fields
        // 3. Form should accept OCR-sourced data

        let field = DynamicFormField(
            id: "ocr-test-field",
            contentType: .text,
            label: "OCR Test",
            supportsOCR: true
        )

        let testConfig = DynamicFormConfiguration(
            id: "test-form",
            title: "Test Form",
            description: "Test form for OCR",
            sections: [],
            submitButtonText: "Submit",
            cancelButtonText: "Cancel"
        )
        let formState = DynamicFormState(configuration: testConfig)
        formState.initializeField(field)

        // Simulate OCR result
        let ocrText = "Extracted text from document"
        formState.setValue(ocrText, for: field.id)

        // Field should contain OCR-populated value
        let storedValue: String? = formState.getValue(for: field.id)
        #expect(storedValue == ocrText, "Form field should accept OCR-populated value")
    }

    @Test func testOCRValidationTypesAreUsedForFieldValidation() async {
        // TDD: OCR validation types should influence field validation
        // 1. OCR-enabled fields should validate OCR results against expected types
        // 2. Invalid OCR types should be rejected or flagged
        // 3. Valid OCR types should be accepted

        // Currently this will fail - OCR validation not implemented
        // TODO: Implement OCR type validation in form processing

        let emailField = DynamicFormField(
            id: "email-field",
            contentType: .email,
            label: "Email",
            supportsOCR: true,
            ocrValidationTypes: [.email]
        )

        let testConfig = DynamicFormConfiguration(
            id: "test-form",
            title: "Test Form",
            description: "Test form for OCR",
            sections: [],
            submitButtonText: "Submit",
            cancelButtonText: "Cancel"
        )
        let formState = DynamicFormState(configuration: testConfig)
        formState.initializeField(emailField)

        // Valid OCR result (email type)
        let validEmail = "user@example.com"
        formState.setValue(validEmail, for: emailField.id)

        // Should accept valid email from OCR
        let storedEmail: String? = formState.getValue(for: emailField.id)
        #expect(storedEmail == validEmail, "Should accept valid OCR email")

        // TODO: Test invalid OCR types are rejected
        // This will require implementing OCR type validation logic
    }

    // MARK: - Batch OCR Tests

    @Test func testDynamicFormConfigurationCanGetOCREnabledFields() async {
        // TDD: DynamicFormConfiguration should provide access to OCR-enabled fields
        // 1. Configuration should return all fields that support OCR
        // 2. Should return empty array when no fields support OCR

        let ocrField = DynamicFormField(
            id: "ocr-field",
            contentType: .text,
            label: "OCR Field",
            supportsOCR: true
        )

        let regularField = DynamicFormField(
            id: "regular-field",
            contentType: .text,
            label: "Regular Field"
        )

        let configWithOCR = DynamicFormConfiguration(
            id: "test-form-ocr",
            title: "Form with OCR",
            sections: [
                DynamicFormSection(fields: [ocrField, regularField])
            ]
        )

        let configWithoutOCR = DynamicFormConfiguration(
            id: "test-form-no-ocr",
            title: "Form without OCR",
            sections: [
                DynamicFormSection(fields: [regularField])
            ]
        )

        // Should return OCR-enabled fields
        let ocrFields = configWithOCR.getOCREnabledFields()
        #expect(ocrFields.count == 1, "Should return exactly 1 OCR-enabled field")
        #expect(ocrFields.first?.id == "ocr-field", "Should return the correct OCR field")

        // Should return empty array for no OCR fields
        let noOCRFields = configWithoutOCR.getOCREnabledFields()
        #expect(noOCRFields.isEmpty, "Should return empty array when no OCR fields")
    }

    @Test func testDynamicFormStateCanProcessBatchOCRResults() async {
        // TDD: DynamicFormState should intelligently map OCR results to fields
        // 1. Should match OCR results to fields by text type
        // 2. Should assign highest confidence results first
        // 3. Should avoid duplicate assignments
        // 4. Should use ocrFieldIdentifier when provided

        let gallonsField = DynamicFormField(
            id: "gallons",
            contentType: .number,
            label: "Gallons",
            supportsOCR: true,
            ocrValidationTypes: [.number],
            ocrFieldIdentifier: "fuel-quantity"
        )

        let priceField = DynamicFormField(
            id: "price",
            contentType: .number,
            label: "Price",
            supportsOCR: true,
            ocrValidationTypes: [.price]
        )

        let config = DynamicFormConfiguration(
            id: "receipt-form",
            title: "Fuel Receipt",
            sections: [DynamicFormSection(fields: [gallonsField, priceField])]
        )

        let formState = DynamicFormState(configuration: config)

        // Simulate OCR results from a receipt
        let ocrResults: [OCRDataCandidate] = [
            OCRDataCandidate(
                text: "15.5",
                boundingBox: CGRect(x: 10, y: 10, width: 50, height: 20),
                confidence: 0.95,
                suggestedType: .number,
                alternativeTypes: [.number]
            ),
            OCRDataCandidate(
                text: "$45.99",
                boundingBox: CGRect(x: 10, y: 40, width: 60, height: 20),
                confidence: 0.90,
                suggestedType: .price,
                alternativeTypes: [.price]
            ),
            OCRDataCandidate(
                text: "10.2", // Lower confidence number
                boundingBox: CGRect(x: 20, y: 20, width: 40, height: 20),
                confidence: 0.80,
                suggestedType: .number,
                alternativeTypes: [.number]
            )
        ]

        let ocrEnabledFields = config.getOCREnabledFields()

        // Process batch OCR results
        let assignments = formState.processBatchOCRResults(ocrResults, for: ocrEnabledFields)

        // Should have assigned both fields
        #expect(assignments.count == 2, "Should assign values to both OCR-enabled fields")

        // Should use ocrFieldIdentifier for gallons field
        #expect(assignments["fuel-quantity"] == "15.5", "Should assign highest confidence number to gallons using identifier")
        #expect(assignments["price"] == "$45.99", "Should assign price to price field")

        // Form state should contain the assigned values
        let gallonsValue: String? = formState.getValue(for: "fuel-quantity")
        let priceValue: String? = formState.getValue(for: "price")
        #expect(gallonsValue == "15.5", "Form state should contain gallons value")
        #expect(priceValue == "$45.99", "Form state should contain price value")
    }

    @Test func testDynamicFormViewShowsBatchOCRButtonWhenFieldsSupportOCR() async {
        // TDD: DynamicFormView should show batch OCR button when form has OCR fields
        // 1. Should show "Scan Document" button when any field supports OCR
        // 2. Should not show button when no fields support OCR
        // 3. Button should be properly accessible

        let ocrField = DynamicFormField(
            id: "ocr-field",
            contentType: .text,
            label: "OCR Field",
            supportsOCR: true
        )

        let regularField = DynamicFormField(
            id: "regular-field",
            contentType: .text,
            label: "Regular Field"
        )

        let configWithOCR = DynamicFormConfiguration(
            id: "form-with-ocr",
            title: "Form with OCR",
            sections: [DynamicFormSection(fields: [ocrField])]
        )

        let configWithoutOCR = DynamicFormConfiguration(
            id: "form-without-ocr",
            title: "Form without OCR",
            sections: [DynamicFormSection(fields: [regularField])]
        )

        let viewWithOCR = DynamicFormView(configuration: configWithOCR, onSubmit: { _ in })
        let viewWithoutOCR = DynamicFormView(configuration: configWithoutOCR, onSubmit: { _ in })

        // OCR form should show batch OCR button
        do {
            let inspected = try viewWithOCR.inspect()
            // Should find the batch OCR button
            let ocrButton = try inspected.find(button: "Scan Document")
            #expect(true, "Form with OCR fields should show batch OCR button")
        } catch {
            Issue.record("Batch OCR button not found in OCR-enabled form: \(error)")
        }

        // Non-OCR form should not show batch OCR button
        do {
            let inspected = try viewWithoutOCR.inspect()
            let ocrButton = try? inspected.find(button: "Scan Document")
            #expect(ocrButton == nil, "Form without OCR fields should not show batch OCR button")
        } catch {
            // Expected - no OCR button should exist
        }
    }

    @Test func testBatchOCRResultsHandleMultipleValuesOfSameType() async {
        // TDD: Batch OCR should handle multiple values of the same type intelligently
        // 1. Should assign highest confidence result first
        // 2. Should not assign same result to multiple fields
        // 3. Should handle cases where there are more results than fields

        let field1 = DynamicFormField(
            id: "field1",
            contentType: .number,
            label: "Field 1",
            supportsOCR: true,
            ocrValidationTypes: [.number]
        )

        let field2 = DynamicFormField(
            id: "field2",
            contentType: .number,
            label: "Field 2",
            supportsOCR: true,
            ocrValidationTypes: [.number]
        )

        let config = DynamicFormConfiguration(
            id: "multi-number-form",
            title: "Multiple Numbers",
            sections: [DynamicFormSection(fields: [field1, field2])]
        )

        let formState = DynamicFormState(configuration: config)

        // OCR results with multiple numbers (different confidence levels)
        let ocrResults: [OCRDataCandidate] = [
            OCRDataCandidate(text: "10.5", confidence: 0.95, suggestedType: .number, alternativeTypes: [.number]),
            OCRDataCandidate(text: "25.3", confidence: 0.90, suggestedType: .number, alternativeTypes: [.number]),
            OCRDataCandidate(text: "5.1", confidence: 0.85, suggestedType: .number, alternativeTypes: [.number])
        ]

        let ocrEnabledFields = config.getOCREnabledFields()
        let assignments = formState.processBatchOCRResults(ocrResults, for: ocrEnabledFields)

        // Should assign to both fields
        #expect(assignments.count == 2, "Should assign values to both number fields")

        // Should assign highest confidence to first available field
        #expect(assignments["field1"] == "10.5", "Should assign highest confidence number to field1")
        #expect(assignments["field2"] == "25.3", "Should assign next highest confidence to field2")

        // Should not assign the lowest confidence value
        #expect(assignments.values.contains("5.1") == false, "Should not assign lowest confidence value")
    }
}

