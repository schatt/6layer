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
                DynamicFormSection(id: "section1", title: "Section 1", fields: [ocrField, regularField])
            ]
        )

        let configWithoutOCR = DynamicFormConfiguration(
            id: "test-form-no-ocr",
            title: "Form without OCR",
            sections: [
                DynamicFormSection(id: "section1", title: "Section 1", fields: [regularField])
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
            sections: [DynamicFormSection(id: "section1", title: "Fuel Information", fields: [gallonsField, priceField])]
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
            sections: [DynamicFormSection(id: "section1", title: "OCR Section", fields: [ocrField])]
        )

        let configWithoutOCR = DynamicFormConfiguration(
            id: "form-without-ocr",
            title: "Form without OCR",
            sections: [DynamicFormSection(id: "section1", title: "Regular Section", fields: [regularField])]
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
            sections: [DynamicFormSection(id: "section1", title: "Numbers", fields: [field1, field2])]
        )

        let formState = DynamicFormState(configuration: config)

        // OCR results with multiple numbers (different confidence levels)
        let ocrResults: [OCRDataCandidate] = [
            OCRDataCandidate(text: "10.5", boundingBox: CGRect(x: 10, y: 10, width: 40, height: 20), confidence: 0.95, suggestedType: .number, alternativeTypes: [.number]),
            OCRDataCandidate(text: "25.3", boundingBox: CGRect(x: 50, y: 10, width: 40, height: 20), confidence: 0.90, suggestedType: .number, alternativeTypes: [.number]),
            OCRDataCandidate(text: "5.1", boundingBox: CGRect(x: 100, y: 10, width: 30, height: 20), confidence: 0.85, suggestedType: .number, alternativeTypes: [.number])
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

    // MARK: - Calculated Fields Tests

    @Test func testDynamicFormFieldCanBeConfiguredAsCalculated() async {
        // TDD: DynamicFormField should support calculated fields
        // 1. Field should accept isCalculated, calculationFormula, calculationDependencies
        // 2. Field should store these values correctly
        // 3. Calculated fields should be identifiable and processed differently

        let calculatedField = DynamicFormField(
            id: "price_per_gallon",
            contentType: .number,
            label: "Price per Gallon",
            isCalculated: true,
            calculationFormula: "total_price / gallons",
            calculationDependencies: ["total_price", "gallons"]
        )

        // Should store calculation configuration correctly
        #expect(calculatedField.isCalculated == true, "Field should be marked as calculated")
        #expect(calculatedField.calculationFormula == "total_price / gallons", "Field should store calculation formula")
        #expect(calculatedField.calculationDependencies == ["total_price", "gallons"], "Field should store calculation dependencies")
    }

    @Test func testCalculatedFieldDefaultsToNotCalculated() async {
        // TDD: DynamicFormField should default to not calculated
        // 1. Regular fields should not be calculated by default
        // 2. Calculation properties should be nil by default

        let regularField = DynamicFormField(
            id: "regular-field",
            contentType: .text,
            label: "Regular Field"
        )

        // Should default to not calculated
        #expect(regularField.isCalculated == false, "Field should default to not calculated")
        #expect(regularField.calculationFormula == nil, "Calculation formula should be nil by default")
        #expect(regularField.calculationDependencies == nil, "Calculation dependencies should be nil by default")
    }

    @Test func testFormStateCanCalculateFieldFromOtherFields() async {
        // TDD: DynamicFormState should calculate field values from other fields
        // 1. Should evaluate calculation formulas using other field values
        // 2. Should set calculated field values automatically
        // 3. Should handle basic arithmetic operations

        let config = DynamicFormConfiguration(
            id: "fuel-calculation-test",
            title: "Fuel Calculation Test",
            sections: [DynamicFormSection(id: "section1", title: "Fuel Data", fields: [])]
        )

        let formState = DynamicFormState(configuration: config)

        // Set input values
        formState.setValue("47.93", for: "total_price")
        formState.setValue("15.5", for: "gallons")

        // Test calculation: price_per_gallon = total_price / gallons
        let result = formState.calculateFieldValue(
            formula: "total_price / gallons",
            dependencies: ["total_price", "gallons"]
        )

        // Should calculate: 47.93 ÷ 15.5 ≈ 3.092
        #expect(result != nil, "Should return a calculated result")
        if let calculatedValue = result {
            #expect(abs(calculatedValue - 3.092258064516129) < 0.0001, "Should calculate price per gallon correctly")
        }
    }

    @Test func testFormStateCanAutoCalculateFieldsWhenDependenciesChange() async {
        // TDD: DynamicFormState should auto-calculate fields when dependencies change
        // 1. When dependency fields are set, calculated fields should update automatically
        // 2. Multiple calculations should work together
        // 3. Calculations should be re-evaluated when dependencies change

        let config = DynamicFormConfiguration(
            id: "auto-calc-test",
            title: "Auto Calculation Test",
            sections: [DynamicFormSection(id: "section1", title: "Data", fields: [])]
        )

        let formState = DynamicFormState(configuration: config)

        // Set initial values
        formState.setValue("15.5", for: "gallons")
        formState.setValue("47.93", for: "total_price")

        // Simulate calculated field update
        let pricePerGallon = formState.calculateFieldValue(
            formula: "total_price / gallons",
            dependencies: ["total_price", "gallons"]
        )

        #expect(pricePerGallon != nil, "Should calculate price per gallon")
        if let price = pricePerGallon {
            #expect(abs(price - 3.092258064516129) < 0.0001, "Price per gallon should be calculated correctly")
        }

        // Change a dependency and recalculate
        formState.setValue("20.0", for: "gallons")  // Changed from 15.5 to 20.0

        let newPricePerGallon = formState.calculateFieldValue(
            formula: "total_price / gallons",
            dependencies: ["total_price", "gallons"]
        )

        #expect(newPricePerGallon != nil, "Should recalculate with new dependency value")
        if let newPrice = newPricePerGallon {
            #expect(abs(newPrice - 2.3965) < 0.0001, "Should recalculate price per gallon with new gallons value")
        }
    }

    @Test func testOCRSystemCanDetermineMissingFieldAndCalculateIt() async {
        // TDD: OCR system should identify missing fields and calculate them from available data
        // 1. Given 2 of 3 related values, should calculate the third
        // 2. Should handle different combinations (gallons+price→total, gallons+total→price, price+total→gallons)
        // 3. Should prioritize OCR-extracted values over calculated ones

        let config = DynamicFormConfiguration(
            id: "ocr-calculation-test",
            title: "OCR Calculation Test",
            sections: [DynamicFormSection(id: "section1", title: "Fuel Data", fields: [])]
        )

        let formState = DynamicFormState(configuration: config)

        // Scenario 1: OCR finds gallons (15.5) and total price ($47.93), calculate price per gallon
        formState.setValue("15.5", for: "gallons")    // From OCR
        formState.setValue("47.93", for: "total_price") // From OCR

        let scenario1Result = formState.calculateMissingFieldFromOCR(
            availableFields: ["gallons", "total_price"],
            possibleFormulas: [
                "price_per_gallon": "total_price / gallons",
                "total_price": "gallons * price_per_gallon",
                "gallons": "total_price / price_per_gallon"
            ]
        )

        #expect(scenario1Result != nil, "Should calculate missing field in scenario 1")
        if let result = scenario1Result {
            #expect(result.fieldId == "price_per_gallon", "Should identify price_per_gallon as missing")
            #expect(abs(result.calculatedValue - 3.092258064516129) < 0.0001, "Should calculate correct price per gallon")
        }

        // Scenario 2: OCR finds gallons (15.5) and price per gallon (3.091), calculate total price
        formState.setValue("15.5", for: "gallons")    // From OCR
        formState.setValue("3.091", for: "price_per_gallon") // From OCR

        let scenario2Result = formState.calculateMissingFieldFromOCR(
            availableFields: ["gallons", "price_per_gallon"],
            possibleFormulas: [
                "price_per_gallon": "total_price / gallons",
                "total_price": "gallons * price_per_gallon",
                "gallons": "total_price / price_per_gallon"
            ]
        )

        #expect(scenario2Result != nil, "Should calculate missing field in scenario 2")
        if let result = scenario2Result {
            #expect(result.fieldId == "total_price", "Should identify total_price as missing")
            #expect(abs(result.calculatedValue - 47.9105) < 0.0001, "Should calculate correct total price")
        }

        // Scenario 3: OCR finds total price ($47.93) and price per gallon ($3.091), calculate gallons
        formState.setValue("47.93", for: "total_price") // From OCR
        formState.setValue("3.091", for: "price_per_gallon") // From OCR

        let scenario3Result = formState.calculateMissingFieldFromOCR(
            availableFields: ["total_price", "price_per_gallon"],
            possibleFormulas: [
                "price_per_gallon": "total_price / gallons",
                "total_price": "gallons * price_per_gallon",
                "gallons": "total_price / price_per_gallon"
            ]
        )

        #expect(scenario3Result != nil, "Should calculate missing field in scenario 3")
        if let result = scenario3Result {
            #expect(result.fieldId == "gallons", "Should identify gallons as missing")
            #expect(abs(result.calculatedValue - 15.506308637981235) < 0.0001, "Should calculate correct gallons")
        }
    }

    @Test func testOCRCalculationHandlesAllThreeFieldsPresent() async {
        // TDD: OCR system should handle when all three fields are present
        // 1. Should not calculate when all fields are available
        // 2. Could optionally validate consistency between calculated and OCR values

        let config = DynamicFormConfiguration(
            id: "all-present-test",
            title: "All Fields Present Test",
            sections: [DynamicFormSection(id: "section1", title: "Data", fields: [])]
        )

        let formState = DynamicFormState(configuration: config)

        // All three fields present from OCR
        formState.setValue("15.5", for: "gallons")
        formState.setValue("47.93", for: "total_price")
        formState.setValue("3.091", for: "price_per_gallon")

        let result = formState.calculateMissingFieldFromOCR(
            availableFields: ["gallons", "total_price", "price_per_gallon"],
            possibleFormulas: [
                "price_per_gallon": "total_price / gallons",
                "total_price": "gallons * price_per_gallon",
                "gallons": "total_price / price_per_gallon"
            ]
        )

        // Should return nil when all fields are present (nothing to calculate)
        #expect(result == nil, "Should not calculate when all fields are present")
    }

    // MARK: - Calculation Groups Tests

    @Test func testDynamicFormFieldCanBelongToMultipleCalculationGroups() async {
        // TDD: DynamicFormField should support belonging to multiple calculation groups
        // 1. Field should store multiple calculation groups
        // 2. Groups should have priorities for calculation order
        // 3. Each group should specify its formula and dependent fields

        let calculationGroups = [
            CalculationGroup(
                id: "group1",
                formula: "total = price * quantity",
                dependentFields: ["price", "quantity"],
                priority: 1
            ),
            CalculationGroup(
                id: "group2",
                formula: "total = base_price + tax",
                dependentFields: ["base_price", "tax"],
                priority: 2
            )
        ]

        let field = DynamicFormField(
            id: "total",
            contentType: .number,
            label: "Total Amount",
            calculationGroups: calculationGroups
        )

        // Should store multiple calculation groups
        #expect(field.calculationGroups?.count == 2, "Field should have 2 calculation groups")

        // Should maintain priority ordering
        #expect(field.calculationGroups?[0].priority == 1, "First group should have priority 1")
        #expect(field.calculationGroups?[1].priority == 2, "Second group should have priority 2")

        // Should store formulas and dependencies correctly
        #expect(field.calculationGroups?[0].formula == "total = price * quantity", "Group 1 should have correct formula")
        #expect(field.calculationGroups?[0].dependentFields == ["price", "quantity"], "Group 1 should have correct dependencies")
    }

    @Test func testCalculationGroupsCanCalculateFieldWithNoConflicts() async {
        // TDD: Calculation groups should calculate field values without conflicts
        // 1. When multiple groups can calculate the same field and agree, use high confidence
        // 2. When only one group can calculate the field, use that result

        let config = DynamicFormConfiguration(
            id: "calculation-groups-test",
            title: "Calculation Groups Test",
            sections: []
        )

        let formState = DynamicFormState(configuration: config)

        // Set up field with multiple calculation groups that should agree
        let calculationGroups = [
            CalculationGroup(
                id: "multiply",
                formula: "result = a * b",
                dependentFields: ["a", "b"],
                priority: 1
            ),
            CalculationGroup(
                id: "add_multiply",
                formula: "result = a + (a * (b - 1))",
                dependentFields: ["a", "b"],
                priority: 2
            )
        ]

        // Set input values: a=2, b=3
        // Group 1: result = 2 * 3 = 6
        // Group 2: result = 2 + (2 * (3-1)) = 2 + (2*2) = 2 + 4 = 6 (same result)
        formState.setValue("2", for: "a")
        formState.setValue("3", for: "b")

        let result = formState.calculateFieldFromGroups(
            fieldId: "result",
            calculationGroups: calculationGroups
        )

        // Should return a result with high confidence (groups agree)
        #expect(result != nil, "Should calculate result when groups agree")
        if let calcResult = result {
            #expect(calcResult.calculatedValue == 6.0, "Should calculate correct result")
            #expect(calcResult.confidence == .high, "Should have high confidence when groups agree")
        }
    }

    @Test func testCalculationGroupsDetectConflictsAndMarkLowConfidence() async {
        // TDD: Calculation groups should detect conflicting calculations and mark low confidence
        // 1. When multiple groups calculate different values for the same field, mark as very low confidence
        // 2. Should still provide the first (highest priority) calculated value

        let config = DynamicFormConfiguration(
            id: "conflict-test",
            title: "Conflict Detection Test",
            sections: []
        )

        let formState = DynamicFormState(configuration: config)

        // Set up conflicting calculation groups
        let calculationGroups = [
            CalculationGroup(
                id: "multiply",
                formula: "result = a * b",
                dependentFields: ["a", "b"],
                priority: 1
            ),
            CalculationGroup(
                id: "divide",
                formula: "result = a / b",
                dependentFields: ["a", "b"],
                priority: 2
            )
        ]

        // Set input values: a=6, b=2
        // Group 1 (priority 1): result = 6 * 2 = 12
        // Group 2 (priority 2): result = 6 / 2 = 3
        // Conflict: 12 vs 3
        formState.setValue("6", for: "a")
        formState.setValue("2", for: "b")

        let result = formState.calculateFieldFromGroups(
            fieldId: "result",
            calculationGroups: calculationGroups
        )

        // Should return result but with very low confidence due to conflict
        #expect(result != nil, "Should still return result even with conflicts")
        if let calcResult = result {
            #expect(calcResult.calculatedValue == 12.0, "Should return highest priority result (12)")
            #expect(calcResult.confidence == .veryLow, "Should have very low confidence when groups conflict")
        }
    }

    @Test func testCalculationGroupsRespectPriorityOrder() async {
        // TDD: Calculation groups should calculate in priority order
        // 1. Higher priority groups (lower number) should be calculated first
        // 2. If multiple groups can calculate, use the highest priority result

        let config = DynamicFormConfiguration(
            id: "priority-test",
            title: "Priority Order Test",
            sections: []
        )

        let formState = DynamicFormState(configuration: config)

        // Set up groups with different priorities
        let calculationGroups = [
            CalculationGroup(
                id: "low_priority",
                formula: "result = a + b",
                dependentFields: ["a", "b"],
                priority: 1
            ),
            CalculationGroup(
                id: "high_priority",
                formula: "result = a * b",
                dependentFields: ["a", "b"],
                priority: 2
            )
        ]

        // Set input values: a=3, b=2
        // Low priority (1): result = 3 + 2 = 5
        // High priority (2): result = 3 * 2 = 6
        formState.setValue("3", for: "a")
        formState.setValue("2", for: "b")

        let result = formState.calculateFieldFromGroups(
            fieldId: "result",
            calculationGroups: calculationGroups
        )

        // Both groups can calculate (same dependencies), so should detect conflict
        #expect(result != nil, "Should calculate result")
        if let calcResult = result {
            #expect(calcResult.calculatedValue == 5.0, "Should use highest priority calculation (5)")
            #expect(calcResult.confidence == .veryLow, "Should have very low confidence (groups conflict)")
        }
    }

    @Test func testCalculationGroupsHandlePartialDataAvailability() async {
        // TDD: Calculation groups should only calculate when all dependent fields are available
        // 1. If a group is missing required fields, skip that group
        // 2. If no groups can calculate, return nil

        let config = DynamicFormConfiguration(
            id: "partial-data-test",
            title: "Partial Data Test",
            sections: []
        )

        let formState = DynamicFormState(configuration: config)

        let calculationGroups = [
            CalculationGroup(
                id: "needs_all_fields",
                formula: "result = a * b * c",
                dependentFields: ["a", "b", "c"],
                priority: 1
            ),
            CalculationGroup(
                id: "needs_two_fields",
                formula: "result = a + b",
                dependentFields: ["a", "b"],
                priority: 2
            )
        ]

        // Set only a and b (missing c)
        formState.setValue("2", for: "a")
        formState.setValue("3", for: "b")

        let result = formState.calculateFieldFromGroups(
            fieldId: "result",
            calculationGroups: calculationGroups
        )

        // Should use the group that has all required fields (a + b = 5)
        #expect(result != nil, "Should calculate using available group")
        if let calcResult = result {
            #expect(calcResult.calculatedValue == 5.0, "Should calculate a + b = 5")
            #expect(calcResult.confidence == .high, "Should have high confidence")
        }
    }

    // MARK: - OCR Field Hints Tests

    @Test func testDynamicFormFieldCanHaveOCRFieldHints() async {
        // TDD: DynamicFormField should support OCR field hints for better OCR mapping
        // 1. Field should store OCR hints array
        // 2. Hints should be used to identify fields in OCR text
        // 3. Multiple hints per field should be supported

        let ocrHints = ["gallons", "gal", "fuel quantity", "liters", "litres"]

        let field = DynamicFormField(
            id: "fuel_quantity",
            contentType: .number,
            label: "Fuel Quantity",
            supportsOCR: true,
            ocrHints: ocrHints
        )

        // Should store OCR hints correctly
        #expect(field.ocrHints?.count == 5, "Field should have 5 OCR hints")
        #expect(field.ocrHints?.contains("gallons") ?? false, "Should contain 'gallons' hint")
        #expect(field.ocrHints?.contains("gal") ?? false, "Should contain 'gal' hint")
        #expect(field.ocrHints?.contains("fuel quantity") ?? false, "Should contain 'fuel quantity' hint")
        #expect(field.ocrHints?.contains("liters") ?? false, "Should contain 'liters' hint")
        #expect(field.ocrHints?.contains("litres") ?? false, "Should contain 'litres' hint")
    }

    @Test func testOCRFieldHintsDefaultToNil() async {
        // TDD: OCR hints should default to nil when not specified
        // 1. Fields without OCR hints should have nil ocrHints
        // 2. This ensures backward compatibility

        let field = DynamicFormField(
            id: "regular_field",
            contentType: .text,
            label: "Regular Field"
        )

        // Should default to nil
        #expect(field.ocrHints == nil, "Field without OCR hints should have nil ocrHints")
    }
}

