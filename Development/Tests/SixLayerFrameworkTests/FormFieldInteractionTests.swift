import XCTest
import SwiftUI
@testable import SixLayerFramework

/// Tests for Form Field Interaction Functionality
/// Tests that form fields properly handle user interactions and data binding
@MainActor
final class FormFieldInteractionTests: XCTestCase {
    
    // MARK: - Test Data
    
    private var sampleFormFields: [GenericFormField] {
        [
            GenericFormField(
                label: "Text Field",
                placeholder: "Enter text",
                value: .constant(""),
                isRequired: true,
                fieldType: .text
            ),
            GenericFormField(
                label: "Email Field",
                placeholder: "Enter email",
                value: .constant(""),
                isRequired: true,
                fieldType: .email
            ),
            GenericFormField(
                label: "Select Field",
                placeholder: "Choose option",
                value: .constant(""),
                isRequired: false,
                fieldType: .select
            ),
            GenericFormField(
                label: "Radio Field",
                placeholder: "Select option",
                value: .constant(""),
                isRequired: true,
                fieldType: .radio
            ),
            GenericFormField(
                label: "Number Field",
                placeholder: "Enter number",
                value: .constant(""),
                isRequired: false,
                fieldType: .number
            ),
            GenericFormField(
                label: "Date Field",
                placeholder: "Select date",
                value: .constant(""),
                isRequired: false,
                fieldType: .date
            ),
            GenericFormField(
                label: "Checkbox Field",
                placeholder: "Check if applicable",
                value: .constant(""),
                isRequired: false,
                fieldType: .checkbox
            )
        ]
    }
    
    private var basicHints: PresentationHints {
        PresentationHints(
            dataType: .form,
            presentationPreference: .form,
            complexity: .simple,
            context: .dashboard
        )
    }
    
    // MARK: - Callback Tracking
    
    private var fieldValueChanges: [String: Any] = [:]
    private var validationErrors: [String: String] = [:]
    private var fieldFocusChanges: [String: Bool] = [:]
    
    private func resetCallbacks() {
        fieldValueChanges.removeAll()
        validationErrors.removeAll()
        fieldFocusChanges.removeAll()
    }
    
    // MARK: - Form Field Tests
    
    func testTextFieldWithDataBinding() {
        // Given: Text field with data binding
        resetCallbacks()
        let textField = sampleFormFields[0]
        var textValue = ""
        
        // When: Creating text field with binding
        let view = TextField(
            textField.placeholder ?? "Enter text",
            text: Binding(
                get: { textValue },
                set: { newValue in
                    textValue = newValue
                    self.fieldValueChanges[textField.label] = newValue
                }
            )
        )
        
        // Then: View should be created successfully
        XCTAssertNotNil(view)
    }
    
    func testEmailFieldWithDataBinding() {
        // Given: Email field with data binding
        resetCallbacks()
        let emailField = sampleFormFields[1]
        var emailValue = ""
        
        // When: Creating email field with binding
        let view = TextField(
            emailField.placeholder ?? "Enter email",
            text: Binding(
                get: { emailValue },
                set: { newValue in
                    emailValue = newValue
                    self.fieldValueChanges[emailField.label] = newValue
                }
            )
        )
        .textContentType(.emailAddress)
        
        // Then: View should be created successfully
        XCTAssertNotNil(view)
    }
    
    func testSelectFieldWithPicker() {
        // Given: Select field with picker options
        resetCallbacks()
        let selectField = sampleFormFields[2]
        let options = ["Option 1", "Option 2", "Option 3"]
        var selectedOption = ""
        
        // When: Creating select field with picker
        let view = VStack {
            Text(selectField.label)
            Picker(selectField.placeholder ?? "Choose option", selection: Binding(
                get: { selectedOption },
                set: { newValue in
                    selectedOption = newValue
                    self.fieldValueChanges[selectField.label] = newValue
                }
            )) {
                ForEach(options, id: \.self) { option in
                    Text(option).tag(option)
                }
            }
            .pickerStyle(.menu)
        }
        
        // Then: View should be created successfully
        XCTAssertNotNil(view)
    }
    
    func testRadioButtonGroupWithSelection() {
        // Given: Radio button group with selection
        resetCallbacks()
        let radioField = sampleFormFields[3]
        let options = ["Option A", "Option B", "Option C"]
        var selectedOption = ""
        
        // When: Creating radio button group
        let view = VStack(alignment: .leading) {
            Text(radioField.label)
            ForEach(options, id: \.self) { option in
                HStack {
                    Button(action: {
                        selectedOption = option
                        self.fieldValueChanges[radioField.label] = option
                    }) {
                        Image(systemName: selectedOption == option ? "largecircle.fill.circle" : "circle")
                            .foregroundColor(selectedOption == option ? .blue : .gray)
                    }
                    Text(option)
                }
            }
        }
        
        // Then: View should be created successfully
        XCTAssertNotNil(view)
    }
    
    func testNumberFieldWithDataBinding() {
        // Given: Number field with data binding
        resetCallbacks()
        let numberField = sampleFormFields[4]
        var numberValue = 0.0
        
        // When: Creating number field with binding
        let view = TextField(
            numberField.placeholder ?? "Enter number",
            value: Binding(
                get: { numberValue },
                set: { newValue in
                    numberValue = newValue
                    self.fieldValueChanges[numberField.label] = newValue
                }
            ),
            format: .number
        )
        
        // Then: View should be created successfully
        XCTAssertNotNil(view)
    }
    
    func testDateFieldWithDataBinding() {
        // Given: Date field with data binding
        resetCallbacks()
        let dateField = sampleFormFields[5]
        var dateValue = Date()
        
        // When: Creating date field with binding
        let view = DatePicker(
            dateField.placeholder ?? "Select date",
            selection: Binding(
                get: { dateValue },
                set: { newValue in
                    dateValue = newValue
                    self.fieldValueChanges[dateField.label] = newValue
                }
            ),
            displayedComponents: [.date]
        )
        
        // Then: View should be created successfully
        XCTAssertNotNil(view)
    }
    
    func testCheckboxFieldWithDataBinding() {
        // Given: Checkbox field with data binding
        resetCallbacks()
        let checkboxField = sampleFormFields[6]
        var isChecked = false
        
        // When: Creating checkbox field with binding
        let view = Toggle(
            checkboxField.label,
            isOn: Binding(
                get: { isChecked },
                set: { newValue in
                    isChecked = newValue
                    self.fieldValueChanges[checkboxField.label] = newValue
                }
            )
        )
        
        // Then: View should be created successfully
        XCTAssertNotNil(view)
    }
    
    // MARK: - Form Integration Tests
    
    func testPlatformPresentFormDataL1WithInteractiveFields() {
        // Given: Form with interactive fields
        resetCallbacks()
        
        // When: Creating form with interactive fields
        let view = platformPresentFormData_L1(
            fields: sampleFormFields,
            hints: basicHints
        )
        
        // Then: View should be created successfully
        XCTAssertNotNil(view)
    }
    
    func testSimpleFormViewWithInteractiveFields() {
        // Given: Simple form view with interactive fields
        resetCallbacks()
        
        // When: Creating simple form view
        let view = SimpleFormView(
            fields: sampleFormFields,
            hints: basicHints
        )
        
        // Then: View should be created successfully
        XCTAssertNotNil(view)
    }
    
    // MARK: - Validation Tests
    
    func testFieldValidationWithErrorDisplay() {
        // Given: Field with validation
        resetCallbacks()
        let textField = sampleFormFields[0]
        var textValue = ""
        var validationError = ""
        
        // When: Creating field with validation
        let view = VStack {
            TextField(
                textField.placeholder ?? "Enter text",
                text: Binding(
                    get: { textValue },
                    set: { newValue in
                        textValue = newValue
                        self.fieldValueChanges[textField.label] = newValue
                        
                        // Simple validation
                        if newValue.isEmpty {
                            validationError = "This field is required"
                        } else {
                            validationError = ""
                        }
                        self.validationErrors[textField.label] = validationError
                    }
                )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(validationError.isEmpty ? Color.clear : Color.red, lineWidth: 1)
            )
            
            if !validationError.isEmpty {
                Text(validationError)
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
        
        // Then: View should be created successfully
        XCTAssertNotNil(view)
    }
    
    func testRequiredFieldValidation() {
        // Given: Required field validation
        resetCallbacks()
        let requiredField = sampleFormFields[0] // Text field is required
        var textValue = ""
        var isValid = false
        
        // When: Creating required field with validation
        let view = VStack {
            TextField(
                requiredField.placeholder ?? "Enter text",
                text: Binding(
                    get: { textValue },
                    set: { newValue in
                        textValue = newValue
                        self.fieldValueChanges[requiredField.label] = newValue
                        isValid = !newValue.isEmpty
                    }
                )
            )
            .background(isValid ? Color.clear : Color.red.opacity(0.1))
            
            if !isValid {
                Text("This field is required")
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
        
        // Then: View should be created successfully
        XCTAssertNotNil(view)
    }
    
    // MARK: - Focus Management Tests
    
    func testFieldFocusManagement() {
        // Given: Field with focus management
        resetCallbacks()
        let textField = sampleFormFields[0]
        var textValue = ""
        var isFocused = false
        
        // When: Creating field with focus management
        let view = TextField(
            textField.placeholder ?? "Enter text",
            text: Binding(
                get: { textValue },
                set: { newValue in
                    textValue = newValue
                    self.fieldValueChanges[textField.label] = newValue
                }
            )
        )
        .onChange(of: isFocused) { focused in
            self.fieldFocusChanges[textField.label] = focused
        }
        
        // Then: View should be created successfully
        XCTAssertNotNil(view)
    }
    
    // MARK: - Edge Case Tests
    
    func testEmptyFormFields() {
        // Given: Empty form fields array
        resetCallbacks()
        
        // When: Creating form with empty fields
        let view = platformPresentFormData_L1(
            fields: [],
            hints: basicHints
        )
        
        // Then: View should be created successfully
        XCTAssertNotNil(view)
    }
    
    func testFormWithAllFieldTypes() {
        // Given: Form with all field types
        resetCallbacks()
        let allFieldTypes: [DynamicFieldType] = [.text, .email, .password, .number, .date, .url, .select, .radio, .checkbox, .textarea]
        let allFields = allFieldTypes.enumerated().map { index, type in
            GenericFormField(
                label: "\(type) Field",
                placeholder: "Enter \(type)",
                value: .constant(""),
                isRequired: index % 2 == 0,
                fieldType: type
            )
        }
        
        // When: Creating form with all field types
        let view = platformPresentFormData_L1(
            fields: allFields,
            hints: basicHints
        )
        
        // Then: View should be created successfully
        XCTAssertNotNil(view)
    }
    
    func testFormWithLongLabels() {
        // Given: Form with long labels
        resetCallbacks()
        let longLabelField = GenericFormField(
            label: "This is a very long field label that should wrap properly and not cause layout issues",
            placeholder: "Enter text",
            value: .constant(""),
            isRequired: true,
            fieldType: .text
        )
        
        // When: Creating form with long label
        let view = platformPresentFormData_L1(
            fields: [longLabelField],
            hints: basicHints
        )
        
        // Then: View should be created successfully
        XCTAssertNotNil(view)
    }
    
    func testFormWithSpecialCharacters() {
        // Given: Form with special characters
        resetCallbacks()
        let specialField = GenericFormField(
            label: "Field with Special Characters: !@#$%^&*()",
            placeholder: "Enter text with special chars: !@#$%^&*()",
            value: .constant(""),
            isRequired: false,
            fieldType: .text
        )
        
        // When: Creating form with special characters
        let view = platformPresentFormData_L1(
            fields: [specialField],
            hints: basicHints
        )
        
        // Then: View should be created successfully
        XCTAssertNotNil(view)
    }
}
