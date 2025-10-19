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
    private func createTestFormView() -> some View {
        IntelligentFormView.generateForm(
            for: TestData.self,
            initialData: TestData(name: "Test", email: "test@example.com"),
            onSubmit: { _ in },
            onCancel: { }
        )
    }
    
    /// Creates a test form field for consistent testing
    private func createTestField() -> DynamicFormField {
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
    
    /// Tests accessibility identifier generation for a view (DRY helper)
    private func testAccessibilityIdentifierGeneration(
        view: some View,
        componentName: String,
        testName: String
    ) -> Bool {
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view,
            expectedPattern: "*.main.element.*",
            componentName: componentName
        )
        return hasAccessibilityID
    }
    
    /// Tests field accessibility through CustomFieldView (DRY helper for all field types)
    private func testFieldAccessibility(
        fieldType: DynamicContentType,
        componentName: String
    ) -> Bool {
        let field = DynamicFormField(
            id: "test-\(fieldType.rawValue)-field",
            textContentType: .name,
            contentType: fieldType,
            label: "Test \(fieldType.rawValue.capitalized) Field",
            placeholder: "Enter \(fieldType.rawValue)",
            isRequired: true
        )
        let formState = DynamicFormState(configuration: testFormConfig)
        let view = CustomFieldView(field: field, formState: formState)
        
        return testAccessibilityIdentifierGeneration(
            view: view,
            componentName: componentName,
            testName: "\(componentName) should generate accessibility identifiers"
        )
    }
    
    // MARK: - DynamicFormView Tests
    
    @Test func testDynamicFormViewGeneratesAccessibilityIdentifiers() async {
        // When: Creating a form view using shared helper
        let view = createTestFormView()
        
        // Then: Should generate accessibility identifiers
        let hasAccessibilityID = testAccessibilityIdentifierGeneration(
            view: view,
            componentName: "DynamicFormView",
            testName: "DynamicFormView should generate accessibility identifiers"
        )
        
        #expect(hasAccessibilityID, "DynamicFormView should generate accessibility identifiers")
    }
    
    // MARK: - DynamicFormHeader Tests
    
    @Test func testDynamicFormHeaderGeneratesAccessibilityIdentifiers() async {
        // When: Creating a form view using shared helper (which includes header)
        let view = createTestFormView()
        
        // Then: Should generate accessibility identifiers
        let hasAccessibilityID = testAccessibilityIdentifierGeneration(
            view: view,
            componentName: "DynamicFormHeader",
            testName: "DynamicFormHeader should generate accessibility identifiers"
        )
        
        #expect(hasAccessibilityID, "DynamicFormHeader should generate accessibility identifiers")
    }
    
    // MARK: - DynamicFormSectionView Tests
    
    @Test func testDynamicFormSectionViewGeneratesAccessibilityIdentifiers() async {
        // When: Creating a form view using shared helper (which includes sections)
        let view = createTestFormView()
        
        // Then: Should generate accessibility identifiers
        let hasAccessibilityID = testAccessibilityIdentifierGeneration(
            view: view,
            componentName: "DynamicFormSectionView",
            testName: "DynamicFormSectionView should generate accessibility identifiers"
        )
        
        #expect(hasAccessibilityID, "DynamicFormSectionView should generate accessibility identifiers")
    }
    
    // MARK: - DynamicFormFieldView Tests
    
    @Test func testDynamicFormFieldViewGeneratesAccessibilityIdentifiers() async {
        // When: Creating a form view using shared helper (which includes field views)
        let view = createTestFormView()
        
        // Then: Should generate accessibility identifiers
        let hasAccessibilityID = testAccessibilityIdentifierGeneration(
            view: view,
            componentName: "DynamicFormFieldView",
            testName: "DynamicFormFieldView should generate accessibility identifiers"
        )
        
        #expect(hasAccessibilityID, "DynamicFormFieldView should generate accessibility identifiers")
    }
    
    // MARK: - DynamicFormActions Tests
    
    @Test func testDynamicFormActionsGeneratesAccessibilityIdentifiers() async {
        // When: Creating a form view using shared helper (which includes form actions)
        let view = createTestFormView()
        
        // Then: Should generate accessibility identifiers
        let hasAccessibilityID = testAccessibilityIdentifierGeneration(
            view: view,
            componentName: "DynamicFormActions",
            testName: "DynamicFormActions should generate accessibility identifiers"
        )
        
        #expect(hasAccessibilityID, "DynamicFormActions should generate accessibility identifiers")
    }
    
    // MARK: - DynamicTextField Tests
    
    @Test func testDynamicTextFieldGeneratesAccessibilityIdentifiers() async {
        // Given: Test text field configuration
        let field = createTestField()
        let formState = DynamicFormState(configuration: testFormConfig)
        
        // When: Creating CustomFieldView (which handles text fields)
        let view = CustomFieldView(field: field, formState: formState)
        
        // Then: Should generate accessibility identifiers
        let hasAccessibilityID = testAccessibilityIdentifierGeneration(
            view: view,
            componentName: "DynamicTextField",
            testName: "DynamicTextField should generate accessibility identifiers"
        )
        
        #expect(hasAccessibilityID, "DynamicTextField should generate accessibility identifiers")
    }
    
    // MARK: - DynamicNumberField Tests
    
    @Test func testDynamicNumberFieldGeneratesAccessibilityIdentifiers() async {
        // When: Testing number field accessibility through CustomFieldView
        let hasAccessibilityID = testFieldAccessibility(
            fieldType: .number,
            componentName: "DynamicNumberField"
        )
        
        // Then: Should generate accessibility identifiers
        #expect(hasAccessibilityID, "DynamicNumberField should generate accessibility identifiers")
    }
    
    // MARK: - DynamicTextAreaField Tests
    
    @Test func testDynamicTextAreaFieldGeneratesAccessibilityIdentifiers() async {
        // When: Testing textarea field accessibility through CustomFieldView
        let hasAccessibilityID = testFieldAccessibility(
            fieldType: .textarea,
            componentName: "DynamicTextAreaField"
        )
        
        // Then: Should generate accessibility identifiers
        #expect(hasAccessibilityID, "DynamicTextAreaField should generate accessibility identifiers")
    }
    
    // MARK: - DynamicSelectField Tests
    
    @Test func testDynamicSelectFieldGeneratesAccessibilityIdentifiers() async {
        // When: Testing select field accessibility through CustomFieldView
        let hasAccessibilityID = testFieldAccessibility(
            fieldType: .select,
            componentName: "DynamicSelectField"
        )
        
        // Then: Should generate accessibility identifiers
        #expect(hasAccessibilityID, "DynamicSelectField should generate accessibility identifiers")
    }
    
    // MARK: - DynamicMultiSelectField Tests
    
    @Test func testDynamicMultiSelectFieldGeneratesAccessibilityIdentifiers() async {
        // When: Testing multiselect field accessibility through CustomFieldView
        let hasAccessibilityID = testFieldAccessibility(
            fieldType: .multiselect,
            componentName: "DynamicMultiSelectField"
        )
        
        // Then: Should generate accessibility identifiers
        #expect(hasAccessibilityID, "DynamicMultiSelectField should generate accessibility identifiers")
    }
    
    // MARK: - DynamicRadioField Tests
    
    @Test func testDynamicRadioFieldGeneratesAccessibilityIdentifiers() async {
        // When: Testing radio field accessibility through CustomFieldView
        let hasAccessibilityID = testFieldAccessibility(
            fieldType: .radio,
            componentName: "DynamicRadioField"
        )
        
        // Then: Should generate accessibility identifiers
        #expect(hasAccessibilityID, "DynamicRadioField should generate accessibility identifiers")
    }
    
    // MARK: - DynamicCheckboxField Tests
    
    @Test func testDynamicCheckboxFieldGeneratesAccessibilityIdentifiers() async {
        // When: Testing checkbox field accessibility through CustomFieldView
        let hasAccessibilityID = testFieldAccessibility(
            fieldType: .checkbox,
            componentName: "DynamicCheckboxField"
        )
        
        // Then: Should generate accessibility identifiers
        #expect(hasAccessibilityID, "DynamicCheckboxField should generate accessibility identifiers")
    }
    
    // MARK: - DynamicToggleField Tests
    
    @Test func testDynamicToggleFieldGeneratesAccessibilityIdentifiers() async {
        // Given: Test toggle field configuration
        let field = DynamicFormField(
            id: "toggle-field",
            label: "Toggle Field",
            type: .toggle,
            value: "false"
        )
        
        // When: Creating DynamicToggleField
        let formState = DynamicFormState(configuration: testFormConfig)
        let view = DynamicToggleField(field: field, formState: formState)
    @Test func testDynamicToggleFieldGeneratesAccessibilityIdentifiers() async {
        // When: Testing toggle field accessibility through CustomFieldView
        let hasAccessibilityID = testFieldAccessibility(
            fieldType: .toggle,
            componentName: "DynamicToggleField"
        )
        
        // Then: Should generate accessibility identifiers
        #expect(hasAccessibilityID, "DynamicToggleField should generate accessibility identifiers")
    }
    
    // MARK: - DynamicDateField Tests
    
    @Test func testDynamicDateFieldGeneratesAccessibilityIdentifiers() async {
        // Given: Test date field configuration
        let field = DynamicFormField(
            id: "date-field",
            label: "Date Field",
            type: .date,
            value: ""
        )
        
        // When: Creating DynamicDateField
        let formState = DynamicFormState(configuration: testFormConfig)
        let view = DynamicDateField(field: field, formState: formState)
    @Test func testDynamicDateFieldGeneratesAccessibilityIdentifiers() async {
        // When: Testing date field accessibility through CustomFieldView
        let hasAccessibilityID = testFieldAccessibility(
            fieldType: .date,
            componentName: "DynamicDateField"
        )
        
        // Then: Should generate accessibility identifiers
        #expect(hasAccessibilityID, "DynamicDateField should generate accessibility identifiers")
    }
    
    // MARK: - DynamicTimeField Tests
    
    @Test func testDynamicTimeFieldGeneratesAccessibilityIdentifiers() async {
        // Given: Test time field configuration
        let field = DynamicFormField(
            id: "time-field",
            label: "Time Field",
            type: .time,
            value: ""
        )
        
        // When: Creating DynamicTimeField
        let formState = DynamicFormState(configuration: testFormConfig)
        let view = DynamicTimeField(field: field, formState: formState)
    @Test func testDynamicTimeFieldGeneratesAccessibilityIdentifiers() async {
        // When: Testing time field accessibility through CustomFieldView
        let hasAccessibilityID = testFieldAccessibility(
            fieldType: .time,
            componentName: "DynamicTimeField"
        )
        
        // Then: Should generate accessibility identifiers
        #expect(hasAccessibilityID, "DynamicTimeField should generate accessibility identifiers")
    }
    
    // MARK: - DynamicDateTimeField Tests
    
    @Test func testDynamicDateTimeFieldGeneratesAccessibilityIdentifiers() async {
        // Given: Test date-time field configuration
        let field = DynamicFormField(
            id: "datetime-field",
            label: "Date-Time Field",
            type: .datetime,
            value: ""
        )
        
        // When: Creating DynamicDateTimeField
        let formState = DynamicFormState(configuration: testFormConfig)
        let view = DynamicDateTimeField(field: field, formState: formState)
    @Test func testDynamicDateTimeFieldGeneratesAccessibilityIdentifiers() async {
        // When: Testing datetime field accessibility through CustomFieldView
        let hasAccessibilityID = testFieldAccessibility(
            fieldType: .datetime,
            componentName: "DynamicDateTimeField"
        )
        
        // Then: Should generate accessibility identifiers
        #expect(hasAccessibilityID, "DynamicDateTimeField should generate accessibility identifiers")
    }
    
    // MARK: - DynamicColorField Tests
    
    @Test func testDynamicColorFieldGeneratesAccessibilityIdentifiers() async {
        // Given: Test color field configuration
        let field = DynamicFormField(
            id: "color-field",
            label: "Color Field",
            type: .color,
            value: "#000000"
        )
        
        // When: Creating DynamicColorField
        let formState = DynamicFormState(configuration: testFormConfig)
        let view = DynamicColorField(field: field, formState: formState)
    @Test func testDynamicColorFieldGeneratesAccessibilityIdentifiers() async {
        // When: Testing color field accessibility through CustomFieldView
        let hasAccessibilityID = testFieldAccessibility(
            fieldType: .color,
            componentName: "DynamicColorField"
        )
        
        // Then: Should generate accessibility identifiers
        #expect(hasAccessibilityID, "DynamicColorField should generate accessibility identifiers")
    }
    
    // MARK: - DynamicFileField Tests
    
    @Test func testDynamicFileFieldGeneratesAccessibilityIdentifiers() async {
        // Given: Test file field configuration
        let field = DynamicFormField(
            id: "file-field",
            label: "File Field",
            type: .file,
            value: ""
        )
        
        // When: Creating DynamicFileField
        let formState = DynamicFormState(configuration: testFormConfig)
        let view = DynamicFileField(field: field, formState: formState)
    @Test func testDynamicFileFieldGeneratesAccessibilityIdentifiers() async {
        // When: Testing file field accessibility through CustomFieldView
        let hasAccessibilityID = testFieldAccessibility(
            fieldType: .file,
            componentName: "DynamicFileField"
        )
        
        // Then: Should generate accessibility identifiers
        #expect(hasAccessibilityID, "DynamicFileField should generate accessibility identifiers")
    }
    
    // MARK: - DynamicIntegerField Tests
    
    @Test func testDynamicIntegerFieldGeneratesAccessibilityIdentifiers() async {
        // Given: Test integer field configuration
        let field = DynamicFormField(
            id: "integer-field",
            label: "Integer Field",
            type: .integer,
            value: "0"
        )
        
        // When: Creating DynamicIntegerField
        let formState = DynamicFormState(configuration: testFormConfig)
        let view = DynamicIntegerField(field: field, formState: formState)
    @Test func testDynamicIntegerFieldGeneratesAccessibilityIdentifiers() async {
        // When: Testing integer field accessibility through CustomFieldView
        let hasAccessibilityID = testFieldAccessibility(
            fieldType: .integer,
            componentName: "DynamicIntegerField"
        )
        
        // Then: Should generate accessibility identifiers
        #expect(hasAccessibilityID, "DynamicIntegerField should generate accessibility identifiers")
    }
    
    // MARK: - DynamicImageField Tests
    
    @Test func testDynamicImageFieldGeneratesAccessibilityIdentifiers() async {
        // Given: Test image field configuration
        let field = DynamicFormField(
            id: "image-field",
            label: "Image Field",
            type: .image,
            value: ""
        )
        
        // When: Creating DynamicImageField
        let formState = DynamicFormState(configuration: testFormConfig)
        let view = DynamicImageField(field: field, formState: formState)
    @Test func testDynamicImageFieldGeneratesAccessibilityIdentifiers() async {
        // When: Testing image field accessibility through CustomFieldView
        let hasAccessibilityID = testFieldAccessibility(
            fieldType: .image,
            componentName: "DynamicImageField"
        )
        
        // Then: Should generate accessibility identifiers
        #expect(hasAccessibilityID, "DynamicImageField should generate accessibility identifiers")
    }
    
    // MARK: - DynamicURLField Tests
    
    @Test func testDynamicURLFieldGeneratesAccessibilityIdentifiers() async {
        // Given: Test URL field configuration
        let field = DynamicFormField(
            id: "url-field",
            label: "URL Field",
            type: .url,
            value: ""
        )
        
        // When: Creating DynamicURLField
        let formState = DynamicFormState(configuration: testFormConfig)
        let view = DynamicURLField(field: field, formState: formState)
    @Test func testDynamicURLFieldGeneratesAccessibilityIdentifiers() async {
        // When: Testing url field accessibility through CustomFieldView
        let hasAccessibilityID = testFieldAccessibility(
            fieldType: .url,
            componentName: "DynamicURLField"
        )
        
        // Then: Should generate accessibility identifiers
        #expect(hasAccessibilityID, "DynamicURLField should generate accessibility identifiers")
    }
    
    // MARK: - DynamicArrayField Tests
    
    @Test func testDynamicArrayFieldGeneratesAccessibilityIdentifiers() async {
        // When: Testing array field accessibility through CustomFieldView
        let hasAccessibilityID = testFieldAccessibility(
            fieldType: .array,
            componentName: "DynamicArrayField"
        )
        
        // Then: Should generate accessibility identifiers
        #expect(hasAccessibilityID, "DynamicArrayField should generate accessibility identifiers")
    }
    
    // MARK: - DynamicDataField Tests
    
    @Test func testDynamicDataFieldGeneratesAccessibilityIdentifiers() async {
        // When: Testing data field accessibility through CustomFieldView
        let hasAccessibilityID = testFieldAccessibility(
            fieldType: .data,
            componentName: "DynamicDataField"
        )
        
        // Then: Should generate accessibility identifiers
        #expect(hasAccessibilityID, "DynamicDataField should generate accessibility identifiers")
    }
    
    // MARK: - DynamicEnumField Tests
    
    @Test func testDynamicEnumFieldGeneratesAccessibilityIdentifiers() async {
        // When: Testing enum field accessibility through CustomFieldView
        let hasAccessibilityID = testFieldAccessibility(
            fieldType: .enum,
            componentName: "DynamicEnumField"
        )
        
        // Then: Should generate accessibility identifiers
        #expect(hasAccessibilityID, "DynamicEnumField should generate accessibility identifiers")
    }
}

// MARK: - Test Data Types
// Using framework types instead of duplicates
