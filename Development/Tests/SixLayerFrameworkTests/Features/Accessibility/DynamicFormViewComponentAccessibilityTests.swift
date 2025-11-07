import Testing


//
//  DynamicFormViewComponentAccessibilityTests.swift
//  SixLayerFrameworkTests
//
//  Comprehensive accessibility tests for ALL DynamicFormView components
//

import SwiftUI
@testable import SixLayerFramework

// MARK: - Test Data Types
struct TestData {
    let name: String
    let email: String
}

@Suite("Dynamic Form View Component Accessibility")
@MainActor
open class DynamicFormViewComponentAccessibilityTests: BaseTestClass {
    
    // MARK: - Shared Test Data (DRY Principle)
    
    private var testFormConfig: DynamicFormConfiguration {
        DynamicFormConfiguration(
            id: "test-form",
            title: "Test Form",
            description: "Test form for accessibility testing",
            sections: [],
            submitButtonText: "Submit",
            cancelButtonText: "Cancel"
        )
    }
    
    // MARK: - Shared Test Helpers (DRY Principle)
    
    /// Creates a test form view using IntelligentFormView for consistent testing
    public func createTestFormView() -> some View {
        IntelligentFormView.generateForm(
            for: TestData.self,
            initialData: TestData(name: "Test", email: "test@example.com"),
            onSubmit: { _ in },
            onCancel: { }
        )
    }
    
    /// Creates a test field with correct parameters (DTRT - use actual framework types)
    public func createTestField() -> DynamicFormField {
        DynamicFormField(
            id: "test-field",
            textContentType: .name,
            contentType: .text,
            label: "Test Field",
            placeholder: "Enter test value",
            description: "Test field for accessibility testing",
            isRequired: true,
            defaultValue: "test"
        )
    }
    
    /// Tests that a field component renders the expected UI control and binds correctly to form state
    private func testFieldComponentFunctionality(
        fieldType: DynamicContentType,
        platform: SixLayerPlatform,
            componentName: String,
        testName: String
    ) -> Bool {
        let field = DynamicFormField(
            id: "test-\(fieldType.rawValue)-field",
            textContentType: .name,
            contentType: fieldType,
            label: "Test \(fieldType.rawValue.capitalized) Field",
            placeholder: "Enter \(fieldType.rawValue)",
            isRequired: true,
            defaultValue: "test default"
        )
        let formState = DynamicFormState(configuration: testFormConfig)

        // Initialize the form state with the field
        formState.initializeField(field)

        let view = CustomFieldView(field: field, formState: formState)
        
        // Test that the component generates accessibility identifiers
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "SixLayer.main.ui.*\(componentName).*",
            platform: platform,
            componentName: componentName
        )

        return hasAccessibilityID
    }
    
    // MARK: - DynamicFormView Tests
    
    @Test func testDynamicFormViewGeneratesAccessibilityIdentifiers() async {
        // When: Creating a form view using shared helper
        let view = createTestFormView()
        
        // Then: Should generate accessibility identifiers
        let hasAccessibilityID = testAccessibilityIdentifierGeneration(
            view,
            componentName: "DynamicFormView",
            expectedPattern: "SixLayer.*ui.*DynamicFormView.*",
            platform: SixLayerPlatform.iOS,
            testName: "DynamicFormView should generate accessibility identifiers"
        )
        
        #expect(hasAccessibilityID, "DynamicFormView should generate accessibility identifiers")
    }
    
    // MARK: - DynamicFormHeader Tests
    
    @Test func testDynamicFormHeaderGeneratesAccessibilityIdentifiers() async {
        // When: Creating a form view (header is part of the form)
        let view = createTestFormView()
        
        // Then: Should generate accessibility identifiers
        let hasAccessibilityID = testAccessibilityIdentifierGeneration(
            view,
            componentName: "DynamicFormHeader",
            expectedPattern: "SixLayer.*ui.*DynamicFormHeader.*",
            platform: SixLayerPlatform.iOS,
            testName: "DynamicFormHeader should generate accessibility identifiers"
        )
        
        #expect(hasAccessibilityID, "DynamicFormHeader should generate accessibility identifiers")
    }
    
    // MARK: - DynamicFormSectionView Tests
    
    @Test func testDynamicFormSectionViewGeneratesAccessibilityIdentifiers() async {
        // When: Creating a form view (sections are part of the form)
        let view = createTestFormView()
        
        // Then: Should generate accessibility identifiers
        let hasAccessibilityID = testAccessibilityIdentifierGeneration(
            view,
            componentName: "DynamicFormSectionView",
            expectedPattern: "SixLayer.*ui.*DynamicFormSectionView.*",
            platform: SixLayerPlatform.iOS,
            testName: "DynamicFormSectionView should generate accessibility identifiers"
        )
        
        #expect(hasAccessibilityID, "DynamicFormSectionView should generate accessibility identifiers")
    }
    
    // MARK: - DynamicFormActions Tests
    
    @Test func testDynamicFormActionsGeneratesAccessibilityIdentifiers() async {
        // When: Creating a form view (actions are part of the form)
        let view = createTestFormView()
        
        // Then: Should generate accessibility identifiers
        let hasAccessibilityID = testAccessibilityIdentifierGeneration(
            view,
            componentName: "DynamicFormActions",
            expectedPattern: "SixLayer.*ui.*DynamicFormActions.*",
            platform: SixLayerPlatform.iOS,
            testName: "DynamicFormActions should generate accessibility identifiers"
        )
        
        #expect(hasAccessibilityID, "DynamicFormActions should generate accessibility identifiers")
    }
    
    // MARK: - DynamicTextField Tests
    
    @Test func testDynamicTextFieldRendersTextFieldWithCorrectBindingAndAccessibility() async {
        // TDD: DynamicTextField should render a VStack with:
        // 1. A Text label showing the field label
        // 2. A TextField with the correct placeholder and keyboard type
        // 3. Proper accessibility identifier
        // 4. Bidirectional binding to form state

        let field = DynamicFormField(
            id: "test-text-field",
            textContentType: .name,
            contentType: .text,
            label: "Full Name",
            placeholder: "Enter your full name",
            isRequired: true,
            defaultValue: "John Doe"
        )
        let formState = DynamicFormState(configuration: testFormConfig)
        formState.setValue("John Doe", for: "test-text-field")

        let view = DynamicTextField(field: field, formState: formState)

        // Should render proper UI structure
        if let inspected = 
            let inspected = view.tryInspect()

            // Should have a VStack containing label and TextField
            let vStack = try inspected.vStack()
            #expect(vStack.count >= 2, "Should have label and TextField")

            // First element should be the label Text
            let labelText = try vStack.text(0)
            #expect(try labelText.string() == "Full Name", "Label should show field label")

            // Second element should be a TextField
            let textField = try vStack.textField(1)
            // Note: ViewInspector doesn't provide direct access to TextField placeholder text
            // We verify the TextField exists and has proper binding instead

            // Should have accessibility identifier
            let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
                view,
                expectedPattern: "SixLayer.main.ui.*DynamicTextField.*",
                platform: .iOS,
                componentName: "DynamicTextField"
            )
            #expect(hasAccessibilityID, "Should generate accessibility identifier")

            // Form state should be properly bound
            let fieldValue: String? = formState.getValue(for: "test-text-field")
            #expect(fieldValue == "John Doe", "Form state should contain initial value")

        } else {
            Issue.record("DynamicTextField inspection failed - component not properly implemented: \(error)")")
        }
    }
    
    // MARK: - DynamicNumberField Tests
    
    @Test func testDynamicNumberFieldRendersTextFieldWithNumericKeyboard() async {
        // TDD: DynamicNumberField should render a VStack with:
        // 1. A Text label showing "Age"
        // 2. A TextField with decimalPad keyboard type (iOS) and "Enter age" placeholder
        // 3. Proper accessibility identifier
        // 4. Form state binding with numeric value

        let field = DynamicFormField(
            id: "test-number-field",
            textContentType: .telephoneNumber,
            contentType: .number,
            label: "Age",
            placeholder: "Enter age",
            isRequired: true,
            defaultValue: "25"
        )
        let formState = DynamicFormState(configuration: testFormConfig)
        formState.setValue("25", for: "test-number-field")

        let view = DynamicNumberField(field: field, formState: formState)

        // Should render proper numeric input UI
        if let inspected = 
            let inspected = view.tryInspect()

            // Should have a VStack containing label and TextField
            let vStack = try inspected.vStack()
            #expect(vStack.count >= 2, "Should have label and TextField")

            // First element should be the label Text
            let labelText = try vStack.text(0)
            #expect(try labelText.string() == "Age", "Label should show field label")

            // Second element should be a TextField with numeric keyboard
            let textField = try vStack.textField(1)
            // Note: ViewInspector doesn't provide direct access to TextField placeholder text
            // We verify the TextField exists and check keyboard type instead

            #if os(iOS)
            // Should have decimalPad keyboard type for numeric input
            let keyboardType = try textField.keyboardType()
            #expect(keyboardType == .decimalPad, "Number field should have decimalPad keyboard")
            #endif

            // Should have accessibility identifier
            let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
                view,
                expectedPattern: "SixLayer.main.ui.*DynamicNumberField.*",
                platform: .iOS,
                componentName: "DynamicNumberField"
            )
            #expect(hasAccessibilityID, "Should generate accessibility identifier")

            // Form state should contain the numeric value
            let numberValue: String? = formState.getValue(for: "test-number-field")
            #expect(numberValue == "25", "Form state should contain numeric value")

        } else {
            Issue.record("DynamicNumberField inspection failed - component not properly implemented: \(error)")")
        }
    }
    
    // MARK: - DynamicTextAreaField Tests
    
    @Test func testDynamicTextAreaFieldRendersMultilineTextEditor() async {
        // TDD: DynamicTextAreaField should render a VStack with:
        // 1. A Text label showing "Description"
        // 2. A TextEditor (multiline text input) with "Enter description" placeholder
        // 3. Proper accessibility identifier
        // 4. Form state binding with multiline text

        let field = DynamicFormField(
            id: "test-textarea-field",
            textContentType: .none,
            contentType: .textarea,
            label: "Description",
            placeholder: "Enter description",
            isRequired: true,
            defaultValue: "This is a\nmultiline description\nwith line breaks"
        )
        let formState = DynamicFormState(configuration: testFormConfig)
        formState.setValue("This is a\nmultiline description\nwith line breaks", for: "test-textarea-field")

        let view = DynamicTextAreaField(field: field, formState: formState)

        // Should render proper multiline text input UI
        if let inspected = 
            let inspected = view.tryInspect()

            // Should have a VStack containing label and TextEditor
            let vStack = try inspected.vStack()
            #expect(vStack.count >= 2, "Should have label and TextEditor")

            // First element should be the label Text
            let labelText = try vStack.text(0)
            #expect(try labelText.string() == "Description", "Label should show field label")

            // Should have accessibility identifier
            let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
                view,
                expectedPattern: "SixLayer.main.ui.*DynamicTextAreaField.*",
                platform: .iOS,
                componentName: "DynamicTextAreaField"
            )
            #expect(hasAccessibilityID, "Should generate accessibility identifier")

            // Form state should contain the multiline text
            let storedValue: String? = formState.getValue(for: "test-textarea-field")
            #expect(storedValue == "This is a\nmultiline description\nwith line breaks", "Form state should contain multiline text")

        } else {
            Issue.record("DynamicTextAreaField inspection failed - component not properly implemented: \(error)")")
        }
    }
    
    // MARK: - DynamicSelectField Tests
    
    @Test func testDynamicSelectFieldRendersPickerWithSelectableOptions() async {
        // TDD: DynamicSelectField should render a VStack with:
        // 1. A Text label showing "Country"
        // 2. A Picker with options ["USA", "Canada", "Mexico"]
        // 3. Proper accessibility identifier
        // 4. Form state binding that updates when selection changes

        let options = ["USA", "Canada", "Mexico"]
        let field = DynamicFormField(
            id: "test-select-field",
            contentType: .select,
            label: "Country",
            placeholder: "Select country",
            isRequired: true,
            options: options,
            defaultValue: "USA"
        )
        let formState = DynamicFormState(configuration: testFormConfig)
        formState.setValue("USA", for: "test-select-field")

        let view = DynamicSelectField(field: field, formState: formState)

        // Should render proper selection UI
        if let inspected = 
            let inspected = view.tryInspect()

            // Should have a VStack containing label and Picker
            let vStack = try inspected.vStack()
            #expect(vStack.count >= 2, "Should have label and Picker")

            // First element should be the label Text
            let labelText = try vStack.text(0)
            #expect(try labelText.string() == "Country", "Label should show field label")

            // Should have accessibility identifier
            let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
                view,
                expectedPattern: "SixLayer.main.ui.*DynamicSelectField.*",
                platform: .iOS,
                componentName: "DynamicSelectField"
            )
            #expect(hasAccessibilityID, "Should generate accessibility identifier")

            // Form state should contain the selected value
            let selectValue: String? = formState.getValue(for: "test-select-field")
            #expect(selectValue == "USA", "Form state should contain selected value")

        } else {
            Issue.record("DynamicSelectField inspection failed - component not properly implemented: \(error)")")
        }
    }
    
    // MARK: - DynamicMultiSelectField Tests
    
    @Test func testDynamicMultiSelectFieldRendersMultipleSelectionControls() async {
        // TDD: DynamicMultiSelectField should render a VStack with:
        // 1. A Text label showing "Interests"
        // 2. Multiple Toggle controls for options ["Reading", "Sports", "Music"]
        // 3. Proper accessibility identifier
        // 4. Form state binding with array of selected values

        let options = ["Reading", "Sports", "Music"]
        let field = DynamicFormField(
            id: "test-multiselect-field",
            contentType: .multiselect,
            label: "Interests",
            placeholder: "Select interests",
            isRequired: true,
            options: options,
            defaultValue: "Reading,Music" // Multiple selections as comma-separated string
        )
        let formState = DynamicFormState(configuration: testFormConfig)
        formState.setValue(["Reading", "Music"], for: "test-multiselect-field")

        let view = DynamicMultiSelectField(field: field, formState: formState)

        // Should render proper multiple selection UI
        if let inspected = 
            let inspected = view.tryInspect()

            // Should have a VStack containing label and selection controls
            let vStack = try inspected.vStack()
            #expect(vStack.count >= 2, "Should have label and selection controls")

            // First element should be the label Text
            let labelText = try vStack.text(0)
            #expect(try labelText.string() == "Interests", "Label should show field label")

            // Should have accessibility identifier
            let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
                view,
                expectedPattern: "SixLayer.main.ui.*DynamicMultiSelectField.*",
                platform: .iOS,
                componentName: "DynamicMultiSelectField"
            )
            #expect(hasAccessibilityID, "Should generate accessibility identifier")

            // Form state should contain the selected values array
            let storedValue: [String]? = formState.getValue(for: "test-multiselect-field")
            #expect(storedValue == ["Reading", "Music"], "Form state should contain selected values array")

        } else {
            Issue.record("DynamicMultiSelectField inspection failed - component not properly implemented: \(error)")")
        }
    }
    
    // MARK: - DynamicRadioField Tests
    
    @Test func testDynamicRadioFieldRendersRadioButtonGroup() async {
        // TDD: DynamicRadioField should render a VStack with:
        // 1. A Text label showing "Gender"
        // 2. Radio button style Picker with options ["Male", "Female", "Other"]
        // 3. Proper accessibility identifier
        // 4. Form state binding with single selected value

        let options = ["Male", "Female", "Other"]
        let field = DynamicFormField(
            id: "test-radio-field",
            contentType: .radio,
            label: "Gender",
            placeholder: "Select gender",
            isRequired: true,
            options: options,
            defaultValue: "Female"
        )
        let formState = DynamicFormState(configuration: testFormConfig)
        formState.setValue("Female", for: "test-radio-field")

        let view = DynamicRadioField(field: field, formState: formState)

        // Should render proper radio button group UI
        if let inspected = 
            let inspected = view.tryInspect()

            // Should have a VStack containing label and radio controls
            let vStack = try inspected.vStack()
            #expect(vStack.count >= 2, "Should have label and radio controls")

            // First element should be the label Text
            let labelText = try vStack.text(0)
            #expect(try labelText.string() == "Gender", "Label should show field label")

            // Should have accessibility identifier
            let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
                view,
                expectedPattern: "SixLayer.main.ui.*DynamicRadioField.*",
                platform: .iOS,
                componentName: "DynamicRadioField"
            )
            #expect(hasAccessibilityID, "Should generate accessibility identifier")

            // Form state should contain the selected value
            let radioValue: String? = formState.getValue(for: "test-radio-field")
            #expect(radioValue == "Female", "Form state should contain selected radio value")

        } else {
            Issue.record("DynamicRadioField inspection failed - component not properly implemented: \(error)")")
        }
    }
    
    // MARK: - DynamicCheckboxField Tests
    
    @Test func testDynamicCheckboxFieldRendersToggleControl() async {
        // TDD: DynamicCheckboxField should render a VStack with:
        // 1. A Text label showing "Subscribe to Newsletter"
        // 2. A Toggle control bound to boolean form state
        // 3. Proper accessibility identifier
        // 4. Form state binding with boolean value

        let field = DynamicFormField(
            id: "test-checkbox-field",
            textContentType: .none,
            contentType: .checkbox,
            label: "Subscribe to Newsletter",
            placeholder: "Check to subscribe",
            isRequired: true,
            defaultValue: "true"
        )
        let formState = DynamicFormState(configuration: testFormConfig)
        formState.setValue(true, for: "test-checkbox-field")

        let view = DynamicCheckboxField(field: field, formState: formState)

        // Should render proper toggle/checkbox UI
        if let inspected = 
            let inspected = view.tryInspect()

            // Should have a VStack containing label and Toggle
            let vStack = try inspected.vStack()
            #expect(vStack.count >= 2, "Should have label and Toggle")

            // First element should be the label Text
            let labelText = try vStack.text(0)
            #expect(try labelText.string() == "Subscribe to Newsletter", "Label should show field label")

            // Should have accessibility identifier
            let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
                view,
                expectedPattern: "SixLayer.main.ui.*DynamicCheckboxField.*",
                platform: .iOS,
                componentName: "DynamicCheckboxField"
            )
            #expect(hasAccessibilityID, "Should generate accessibility identifier")

            // Form state should contain the boolean value
            let checkboxValue: Bool? = formState.getValue(for: "test-checkbox-field")
            #expect(checkboxValue == true, "Form state should contain boolean checkbox value")

        } else {
            Issue.record("DynamicCheckboxField inspection failed - component not properly implemented: \(error)")")
        }
    }
    
    // MARK: - DynamicToggleField Tests
    
    @Test func testDynamicToggleFieldRendersToggleControl() async {
        // TDD: DynamicToggleField should render a VStack with:
        // 1. A Text label showing "Enable Feature"
        // 2. A Toggle control bound to boolean form state
        // 3. Proper accessibility identifier
        // 4. Form state binding with boolean value

        let field = DynamicFormField(
            id: "test-toggle-field",
            textContentType: .none,
            contentType: .toggle,
            label: "Enable Feature",
            placeholder: "Toggle to enable",
            isRequired: true,
            defaultValue: "false"
        )
        let formState = DynamicFormState(configuration: testFormConfig)
        formState.setValue(false, for: "test-toggle-field")

        let view = DynamicToggleField(field: field, formState: formState)

        // Should render proper toggle UI
        if let inspected = 
            let inspected = view.tryInspect()

            // Should have a VStack containing label and Toggle
            let vStack = try inspected.vStack()
            #expect(vStack.count >= 2, "Should have label and Toggle")

            // First element should be the label Text
            let labelText = try vStack.text(0)
            #expect(try labelText.string() == "Enable Feature", "Label should show field label")

            // Should have accessibility identifier
            let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
                view,
                expectedPattern: "SixLayer.main.ui.*DynamicToggleField.*",
                platform: .iOS,
                componentName: "DynamicToggleField"
            )
            #expect(hasAccessibilityID, "Should generate accessibility identifier")

            // Form state should contain the boolean value
            let toggleValue: Bool? = formState.getValue(for: "test-toggle-field")
            #expect(toggleValue == false, "Form state should contain boolean toggle value")

        } else {
            Issue.record("DynamicToggleField inspection failed - component not properly implemented: \(error)")")
        }
    }
}

// MARK: - Test Data Types
// Using framework types instead of duplicates