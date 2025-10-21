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
    
    /// Creates a test field with correct parameters (DTRT - use actual framework types)
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
        platform: .iOS,
            platform: .iOS,
            componentName: String,
        testName: String
    ) -> Bool {
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "*.main.element.*",
            platform: .iOS,
            platform: .iOS,
            componentName: componentName
        )
        return hasAccessibilityID
    }
    
    /// Tests field accessibility through CustomFieldView (DRY helper for all field types)
    private func testFieldAccessibility(
        fieldType: DynamicContentType,
        platform: .iOS,
            platform: .iOS,
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
            platform: .iOS,
            platform: .iOS,
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
            platform: .iOS,
            platform: .iOS,
            componentName: "DynamicFormView",
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
            view: view,
            platform: .iOS,
            platform: .iOS,
            componentName: "DynamicFormHeader",
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
            view: view,
            platform: .iOS,
            platform: .iOS,
            componentName: "DynamicFormSectionView",
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
            view: view,
            platform: .iOS,
            platform: .iOS,
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
            platform: .iOS,
            platform: .iOS,
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
            platform: .iOS,
            platform: .iOS,
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
            platform: .iOS,
            platform: .iOS,
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
            platform: .iOS,
            platform: .iOS,
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
            platform: .iOS,
            platform: .iOS,
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
            platform: .iOS,
            platform: .iOS,
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
            platform: .iOS,
            platform: .iOS,
            componentName: "DynamicCheckboxField"
        )
        
        // Then: Should generate accessibility identifiers
        #expect(hasAccessibilityID, "DynamicCheckboxField should generate accessibility identifiers")
    }
    
    // MARK: - DynamicToggleField Tests
    
    @Test func testDynamicToggleFieldGeneratesAccessibilityIdentifiers() async {
        // When: Testing toggle field accessibility through CustomFieldView
        let hasAccessibilityID = testFieldAccessibility(
            fieldType: .toggle,
            platform: .iOS,
            platform: .iOS,
            componentName: "DynamicToggleField"
        )
        
        // Then: Should generate accessibility identifiers
        #expect(hasAccessibilityID, "DynamicToggleField should generate accessibility identifiers")
    }
    
    // MARK: - DynamicDateField Tests
    
    @Test func testDynamicDateFieldGeneratesAccessibilityIdentifiers() async {
        // When: Testing date field accessibility through CustomFieldView
        let hasAccessibilityID = testFieldAccessibility(
            fieldType: .date,
            platform: .iOS,
            platform: .iOS,
            componentName: "DynamicDateField"
        )
        
        // Then: Should generate accessibility identifiers
        #expect(hasAccessibilityID, "DynamicDateField should generate accessibility identifiers")
    }
    
    // MARK: - DynamicTimeField Tests
    
    @Test func testDynamicTimeFieldGeneratesAccessibilityIdentifiers() async {
        // When: Testing time field accessibility through CustomFieldView
        let hasAccessibilityID = testFieldAccessibility(
            fieldType: .time,
            platform: .iOS,
            platform: .iOS,
            componentName: "DynamicTimeField"
        )
        
        // Then: Should generate accessibility identifiers
        #expect(hasAccessibilityID, "DynamicTimeField should generate accessibility identifiers")
    }
    
    // MARK: - DynamicDateTimeField Tests
    
    @Test func testDynamicDateTimeFieldGeneratesAccessibilityIdentifiers() async {
        // When: Testing datetime field accessibility through CustomFieldView
        let hasAccessibilityID = testFieldAccessibility(
            fieldType: .datetime,
            platform: .iOS,
            platform: .iOS,
            componentName: "DynamicDateTimeField"
        )
        
        // Then: Should generate accessibility identifiers
        #expect(hasAccessibilityID, "DynamicDateTimeField should generate accessibility identifiers")
    }
    
    // MARK: - DynamicColorField Tests
    
    @Test func testDynamicColorFieldGeneratesAccessibilityIdentifiers() async {
        // When: Testing color field accessibility through CustomFieldView
        let hasAccessibilityID = testFieldAccessibility(
            fieldType: .color,
            platform: .iOS,
            platform: .iOS,
            componentName: "DynamicColorField"
        )
        
        // Then: Should generate accessibility identifiers
        #expect(hasAccessibilityID, "DynamicColorField should generate accessibility identifiers")
    }
    
    // MARK: - DynamicFileField Tests
    
    @Test func testDynamicFileFieldGeneratesAccessibilityIdentifiers() async {
        // When: Testing file field accessibility through CustomFieldView
        let hasAccessibilityID = testFieldAccessibility(
            fieldType: .file,
            platform: .iOS,
            platform: .iOS,
            componentName: "DynamicFileField"
        )
        
        // Then: Should generate accessibility identifiers
        #expect(hasAccessibilityID, "DynamicFileField should generate accessibility identifiers")
    }
    
    // MARK: - DynamicIntegerField Tests
    
    @Test func testDynamicIntegerFieldGeneratesAccessibilityIdentifiers() async {
        // When: Testing integer field accessibility through CustomFieldView
        let hasAccessibilityID = testFieldAccessibility(
            fieldType: .integer,
            platform: .iOS,
            platform: .iOS,
            componentName: "DynamicIntegerField"
        )
        
        // Then: Should generate accessibility identifiers
        #expect(hasAccessibilityID, "DynamicIntegerField should generate accessibility identifiers")
    }
    
    // MARK: - DynamicImageField Tests
    
    @Test func testDynamicImageFieldGeneratesAccessibilityIdentifiers() async {
        // When: Testing image field accessibility through CustomFieldView
        let hasAccessibilityID = testFieldAccessibility(
            fieldType: .image,
            platform: .iOS,
            platform: .iOS,
            componentName: "DynamicImageField"
        )
        
        // Then: Should generate accessibility identifiers
        #expect(hasAccessibilityID, "DynamicImageField should generate accessibility identifiers")
    }
    
    // MARK: - DynamicURLField Tests
    
    @Test func testDynamicURLFieldGeneratesAccessibilityIdentifiers() async {
        // When: Testing URL field accessibility through CustomFieldView
        let hasAccessibilityID = testFieldAccessibility(
            fieldType: .url,
            platform: .iOS,
            platform: .iOS,
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
            platform: .iOS,
            platform: .iOS,
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
            platform: .iOS,
            platform: .iOS,
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
            platform: .iOS,
            platform: .iOS,
            componentName: "DynamicEnumField"
        )
        
        // Then: Should generate accessibility identifiers
        #expect(hasAccessibilityID, "DynamicEnumField should generate accessibility identifiers")
    }
}

// MARK: - Test Data Types
// Using framework types instead of duplicates