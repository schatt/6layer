import XCTest
@testable import SixLayerFramework

@MainActor
final class DynamicFormTests: XCTestCase {
    
    // MARK: - Dynamic Form Field Tests
    
    func testDynamicFormFieldCreation() {
        let field = DynamicFormField(
            id: "testField",
            type: .text,
            label: "Test Field",
            placeholder: "Enter text",
            isRequired: true,
            validationRules: ["minLength": "2"],
            options: nil,
            defaultValue: "",
            metadata: ["maxWidth": "200"]
        )
        
        XCTAssertEqual(field.id, "testField")
        XCTAssertEqual(field.type, .text)
        XCTAssertEqual(field.label, "Test Field")
        XCTAssertEqual(field.placeholder, "Enter text")
        XCTAssertTrue(field.isRequired)
        XCTAssertEqual(field.validationRules?["minLength"], "2")
        XCTAssertNil(field.options)
        XCTAssertEqual(field.defaultValue, "")
        XCTAssertEqual(field.metadata?["maxWidth"], "200")
    }
    
    func testDynamicFieldTypeProperties() {
        // Test options support
        XCTAssertTrue(DynamicFieldType.select.supportsOptions)
        XCTAssertTrue(DynamicFieldType.multiselect.supportsOptions)
        XCTAssertTrue(DynamicFieldType.radio.supportsOptions)
        XCTAssertTrue(DynamicFieldType.checkbox.supportsOptions)
        XCTAssertFalse(DynamicFieldType.text.supportsOptions)
        XCTAssertFalse(DynamicFieldType.email.supportsOptions)
        
        // Test multiple values support
        XCTAssertTrue(DynamicFieldType.multiselect.supportsMultipleValues)
        XCTAssertTrue(DynamicFieldType.checkbox.supportsMultipleValues)
        XCTAssertFalse(DynamicFieldType.select.supportsMultipleValues)
        XCTAssertFalse(DynamicFieldType.radio.supportsMultipleValues)
        
        // Test keyboard types (platform-specific)
        #if os(iOS)
        XCTAssertEqual(DynamicFieldType.email.keyboardType, .emailAddress)
        XCTAssertEqual(DynamicFieldType.number.keyboardType, .numberPad)
        XCTAssertEqual(DynamicFieldType.phone.keyboardType, .phonePad)
        XCTAssertEqual(DynamicFieldType.url.keyboardType, .URL)
        XCTAssertEqual(DynamicFieldType.text.keyboardType, .default)
        #else
        XCTAssertEqual(DynamicFieldType.email.keyboardType, "emailAddress")
        XCTAssertEqual(DynamicFieldType.number.keyboardType, "numberPad")
        XCTAssertEqual(DynamicFieldType.phone.keyboardType, "phonePad")
        XCTAssertEqual(DynamicFieldType.url.keyboardType, "URL")
        XCTAssertEqual(DynamicFieldType.text.keyboardType, "default")
        #endif
    }
    
    // MARK: - Dynamic Form Section Tests
    
    func testDynamicFormSectionCreation() {
        let fields = [
            DynamicFormField(id: "field1", type: .text, label: "Field 1"),
            DynamicFormField(id: "field2", type: .email, label: "Field 2")
        ]
        
        let section = DynamicFormSection(
            id: "testSection",
            title: "Test Section",
            description: "A test section",
            fields: fields,
            isCollapsible: true,
            isCollapsed: false,
            metadata: ["order": "1"]
        )
        
        XCTAssertEqual(section.id, "testSection")
        XCTAssertEqual(section.title, "Test Section")
        XCTAssertEqual(section.description, "A test section")
        XCTAssertEqual(section.fields.count, 2)
        XCTAssertTrue(section.isCollapsible)
        XCTAssertFalse(section.isCollapsed)
        XCTAssertEqual(section.metadata?["order"], "1")
    }
    
    func testDynamicFormSectionHelpers() {
        let fields = [
            DynamicFormField(id: "field1", type: .text, label: "Field 1"),
            DynamicFormField(id: "field2", type: .email, label: "Field 2")
        ]
        
        let section = DynamicFormSection(
            id: "testSection",
            title: "Test Section",
            fields: fields
        )
        
        // Test field access
        XCTAssertEqual(section.fields.count, 2)
        XCTAssertEqual(section.fields[0].id, "field1")
        XCTAssertEqual(section.fields[1].id, "field2")
    }
    
    // MARK: - Dynamic Form Configuration Tests
    
    func testDynamicFormConfigurationCreation() {
        let sections = [
            DynamicFormSection(
                id: "section1",
                title: "Section 1",
                fields: [
                    DynamicFormField(id: "field1", type: .text, label: "Field 1")
                ]
            )
        ]
        
        let config = DynamicFormConfiguration(
            id: "testForm",
            title: "Test Form",
            description: "A test form",
            sections: sections,
            submitButtonText: "Submit Form",
            cancelButtonText: "Cancel",
            metadata: ["version": "1.0"]
        )
        
        XCTAssertEqual(config.id, "testForm")
        XCTAssertEqual(config.title, "Test Form")
        XCTAssertEqual(config.description, "A test form")
        XCTAssertEqual(config.sections.count, 1)
        XCTAssertEqual(config.submitButtonText, "Submit Form")
        XCTAssertEqual(config.cancelButtonText, "Cancel")
        XCTAssertEqual(config.metadata?["version"], "1.0")
    }
    
    func testDynamicFormConfigurationHelpers() {
        let fields = [
            DynamicFormField(id: "field1", type: .text, label: "Field 1"),
            DynamicFormField(id: "field2", type: .email, label: "Field 2")
        ]
        
        let sections = [
            DynamicFormSection(id: "section1", title: "Section 1", fields: fields)
        ]
        
        let config = DynamicFormConfiguration(
            id: "testForm",
            title: "Test Form",
            sections: sections
        )
        
        // Test all fields access
        let allFields = config.allFields
        XCTAssertEqual(allFields.count, 2)
        XCTAssertEqual(allFields[0].id, "field1")
        XCTAssertEqual(allFields[1].id, "field2")
        
        // Test field lookup
        let field1 = config.getField(by: "field1")
        XCTAssertNotNil(field1)
        XCTAssertEqual(field1?.type, .text)
        
        let field2 = config.getField(by: "field2")
        XCTAssertNotNil(field2)
        XCTAssertEqual(field2?.type, .email)
        
        let nonExistentField = config.getField(by: "nonExistent")
        XCTAssertNil(nonExistentField)
        
        // Test section lookup
        let section1 = config.getSection(by: "section1")
        XCTAssertNotNil(section1)
        XCTAssertEqual(section1?.title, "Section 1")
        
        let nonExistentSection = config.getSection(by: "nonExistent")
        XCTAssertNil(nonExistentSection)
    }
    
    // MARK: - Dynamic Form State Tests
    
    func testDynamicFormStateCreation() {
        let config = DynamicFormConfiguration(
            id: "testForm",
            title: "Test Form",
            sections: []
        )
        
        let state = DynamicFormState(configuration: config)
        
        XCTAssertEqual(state.fieldValues.count, 0)
        XCTAssertEqual(state.fieldErrors.count, 0)
        XCTAssertEqual(state.sectionStates.count, 0)
        XCTAssertFalse(state.isSubmitting)
        XCTAssertFalse(state.isDirty)
        XCTAssertTrue(state.isValid)
    }
    
    func testDynamicFormStateFieldValues() {
        let config = DynamicFormConfiguration(
            id: "testForm",
            title: "Test Form",
            sections: []
        )
        
        let state = DynamicFormState(configuration: config)
        
        // Test setting and getting values
        state.setValue("John", for: "firstName")
        state.setValue(25, for: "age")
        state.setValue(true, for: "isActive")
        
        XCTAssertEqual(state.getValue(for: "firstName") as String?, "John")
        XCTAssertEqual(state.getValue(for: "age") as Int?, 25)
        XCTAssertEqual(state.getValue(for: "isActive") as Bool?, true)
        XCTAssertTrue(state.isDirty)
    }
    
    func testDynamicFormStateValidation() {
        let config = DynamicFormConfiguration(
            id: "testForm",
            title: "Test Form",
            sections: []
        )
        
        let state = DynamicFormState(configuration: config)
        
        // Test error management
        XCTAssertFalse(state.hasErrors(for: "testField"))
        XCTAssertEqual(state.getErrors(for: "testField").count, 0)
        
        state.addError("Field is required", for: "testField")
        XCTAssertTrue(state.hasErrors(for: "testField"))
        XCTAssertEqual(state.getErrors(for: "testField").count, 1)
        XCTAssertTrue(state.getErrors(for: "testField").contains("Field is required"))
        
        state.addError("Field is too short", for: "testField")
        XCTAssertEqual(state.getErrors(for: "testField").count, 2)
        
        state.clearErrors(for: "testField")
        XCTAssertFalse(state.hasErrors(for: "testField"))
        XCTAssertEqual(state.getErrors(for: "testField").count, 0)
        
        state.clearAllErrors()
        XCTAssertEqual(state.fieldErrors.count, 0)
    }
    
    func testDynamicFormStateSections() {
        let config = DynamicFormConfiguration(
            id: "testForm",
            title: "Test Form",
            sections: [
                DynamicFormSection(
                    id: "section1",
                    title: "Section 1",
                    isCollapsible: true,
                    isCollapsed: false
                )
            ]
        )
        
        let state = DynamicFormState(configuration: config)
        
        // Test section state management
        XCTAssertFalse(state.isSectionCollapsed("section1"))
        
        state.toggleSection("section1")
        XCTAssertTrue(state.isSectionCollapsed("section1"))
        
        state.toggleSection("section1")
        XCTAssertFalse(state.isSectionCollapsed("section1"))
    }
    
    func testDynamicFormStateReset() {
        let config = DynamicFormConfiguration(
            id: "testForm",
            title: "Test Form",
            sections: []
        )
        
        let state = DynamicFormState(configuration: config)
        
        // Set some state
        state.setValue("John", for: "firstName")
        state.addError("Error", for: "firstName")
        state.toggleSection("section1")
        
        // Verify state is set
        XCTAssertTrue(state.isDirty)
        XCTAssertTrue(state.hasErrors(for: "firstName"))
        XCTAssertTrue(state.isSectionCollapsed("section1"))
        
        // Reset
        state.reset()
        
        // Verify state is reset
        XCTAssertFalse(state.isDirty)
        XCTAssertFalse(state.hasErrors(for: "firstName"))
        XCTAssertFalse(state.isSectionCollapsed("section1"))
    }
    
    // MARK: - Dynamic Form Builder Tests
    
    func testDynamicFormBuilderBasicFlow() {
        var builder = DynamicFormBuilder()
        builder.startSection(id: "personal", title: "Personal Information")
        builder.addField(id: "firstName", type: .text, label: "First Name", isRequired: true)
        builder.addField(id: "lastName", type: .text, label: "Last Name", isRequired: true)
        builder.endSection()
        builder.startSection(id: "contact", title: "Contact Information")
        builder.addField(id: "email", type: .email, label: "Email", isRequired: true)
        builder.addField(id: "phone", type: .phone, label: "Phone")
        let config = builder.build(
            id: "user-form",
            title: "User Registration"
        )
        
        XCTAssertEqual(config.id, "user-form")
        XCTAssertEqual(config.title, "User Registration")
        XCTAssertEqual(config.sections.count, 2)
        XCTAssertEqual(config.sections[0].id, "personal")
        XCTAssertEqual(config.sections[1].id, "contact")
        XCTAssertEqual(config.sections[0].fields.count, 2)
        XCTAssertEqual(config.sections[1].fields.count, 2)
    }
    
    func testDynamicFormBuilderWithValidation() {
        let validationRules = ["minLength": "3", "maxLength": "50", "pattern": "^[a-zA-Z]+$"]
        
        var builder = DynamicFormBuilder()
        builder.startSection(id: "validation", title: "Validation Test")
        builder.addField(
            id: "username",
            type: .text,
            label: "Username",
            isRequired: true,
            validationRules: validationRules
        )
        let config = builder.build(
            id: "validation-form",
            title: "Validation Form"
        )
        
        XCTAssertEqual(config.id, "validation-form")
        XCTAssertEqual(config.title, "Validation Form")
        XCTAssertEqual(config.sections.count, 1)
        XCTAssertEqual(config.sections[0].fields.count, 1)
        
        let field = config.sections[0].fields[0]
        XCTAssertEqual(field.id, "username")
        XCTAssertEqual(field.type, .text)
        XCTAssertEqual(field.validationRules?["minLength"], "3")
        XCTAssertEqual(field.validationRules?["maxLength"], "50")
        XCTAssertEqual(field.validationRules?["pattern"], "^[a-zA-Z]+$")
    }
    
    func testDynamicFormBuilderWithOptions() {
        var builder = DynamicFormBuilder()
        builder.startSection(id: "preferences", title: "Preferences")
        builder.addField(
            id: "theme",
            type: .select,
            label: "Theme",
            options: ["Light", "Dark", "Auto"]
        )
        builder.addField(
            id: "notifications",
            type: .multiselect,
            label: "Notifications",
            options: ["Email", "Push", "SMS"]
        )
        builder.addField(
            id: "newsletter",
            type: .checkbox,
            label: "Subscribe to newsletter"
        )
        let config = builder.build(
            id: "options-form",
            title: "Options Form"
        )
        
        XCTAssertEqual(config.sections.count, 1)
        XCTAssertEqual(config.sections[0].fields.count, 3)
        
        let themeField = config.sections[0].fields[0]
        XCTAssertEqual(themeField.type, .select)
        XCTAssertEqual(themeField.options?.count, 3)
        XCTAssertTrue(themeField.type.supportsOptions)
        
        let notificationsField = config.sections[0].fields[1]
        XCTAssertEqual(notificationsField.type, .multiselect)
        XCTAssertTrue(notificationsField.type.supportsMultipleValues)
    }
    
    func testDynamicFormBuilderWithMetadata() {
        var builder = DynamicFormBuilder()
        builder.startSection(
            id: "metadata",
            title: "Metadata Test",
            description: "Testing metadata support",
            isCollapsible: true,
            isCollapsed: false
        )
        builder.addField(
            id: "testField",
            type: .text,
            label: "Test Field",
            metadata: ["maxWidth": "300", "placeholder": "Custom placeholder"]
        )
        let config = builder.build(
            id: "metadata-form",
            title: "Metadata Form"
        )
        
        XCTAssertEqual(config.sections.count, 1)
        let section = config.sections[0]
        XCTAssertTrue(section.isCollapsible)
        XCTAssertFalse(section.isCollapsed)
        
        let field = section.fields[0]
        XCTAssertEqual(field.metadata?["maxWidth"], "300")
        XCTAssertEqual(field.metadata?["placeholder"], "Custom placeholder")
    }
    
    func testDynamicFormCompleteWorkflow() {
        var builder = DynamicFormBuilder()
        builder.startSection(id: "personal", title: "Personal Information")
        builder.addField(id: "firstName", type: .text, label: "First Name", isRequired: true)
        builder.addField(id: "lastName", type: .text, label: "Last Name", isRequired: true)
        builder.addField(id: "email", type: .email, label: "Email", isRequired: true)
        builder.endSection()
        builder.startSection(id: "preferences", title: "Preferences", isCollapsible: true)
        builder.addField(id: "theme", type: .select, label: "Theme", options: ["Light", "Dark"])
        builder.addField(id: "notifications", type: .toggle, label: "Enable notifications")
        let config = builder.build(
            id: "user-form",
            title: "User Registration",
            description: "Complete your profile"
        )
        
        // Create form state
        let formState = DynamicFormState(configuration: config)
        
        // Fill out form
        formState.setValue("John", for: "firstName")
        formState.setValue("Doe", for: "lastName")
        formState.setValue("john@example.com", for: "email")
        formState.setValue("Dark", for: "theme")
        formState.setValue(true, for: "notifications")
        
        // Verify form data
        let formData = formState.formData
        XCTAssertEqual(formData["firstName"] as? String, "John")
        XCTAssertEqual(formData["lastName"] as? String, "Doe")
        XCTAssertEqual(formData["email"] as? String, "john@example.com")
        XCTAssertEqual(formData["theme"] as? String, "Dark")
        XCTAssertEqual(formData["notifications"] as? Bool, true)
        
        // Verify form is valid
        XCTAssertTrue(formState.isValid)
        XCTAssertTrue(formState.isDirty)
    }
    
    // MARK: - Performance Tests
    
    func testDynamicFormBuilderPerformance() {
        measure {
            var builder = DynamicFormBuilder()
            for i in 0..<100 {
                builder.startSection(id: "section\(i)", title: "Section \(i)")
                for j in 0..<10 {
                    builder.addField(
                        id: "field\(i)_\(j)",
                        type: .text,
                        label: "Field \(i)-\(j)"
                    )
                }
                builder.endSection()
            }
            let _ = builder.build(id: "perf-form", title: "Performance Form")
        }
    }
    
    func testDynamicFormStatePerformance() {
        let config = DynamicFormConfiguration(
            id: "perf-form",
            title: "Performance Form",
            sections: Array(0..<100).map { i in
                DynamicFormSection(
                    id: "section\(i)",
                    title: "Section \(i)",
                    fields: Array(0..<10).map { j in
                        DynamicFormField(
                            id: "field\(i)_\(j)",
                            type: .text,
                            label: "Field \(i)-\(j)"
                        )
                    }
                )
            }
        )
        
        let state = DynamicFormState(configuration: config)
        
        measure {
            for i in 0..<100 {
                for j in 0..<10 {
                    let fieldId = "field\(i)_\(j)"
                    state.setValue("value\(i)_\(j)", for: fieldId)
                    state.addError("error\(i)_\(j)", for: fieldId)
                }
            }
            
            let _ = state.formData
            let _ = state.isValid
        }
    }
}
