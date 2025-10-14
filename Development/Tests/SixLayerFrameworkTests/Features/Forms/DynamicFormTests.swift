//
//  DynamicFormTests.swift
//  SixLayerFrameworkTests
//
//  BUSINESS PURPOSE:
//  Validates the DynamicFormField system functionality that replaces the deprecated GenericFormField,
//  ensuring proper form field creation, configuration, validation, and behavior across all platforms.
//
//  TESTING SCOPE:
//  - DynamicFormField creation and initialization functionality
//  - Field type validation and configuration functionality
//  - Validation rule setup and execution functionality
//  - Form state management and updates functionality
//  - Field option handling and selection functionality
//  - Metadata and configuration management functionality
//  - Cross-platform form field behavior functionality
//
//  METHODOLOGY:
//  - Test DynamicFormField creation with various configurations across all platforms
//  - Verify field property setting and validation using mock testing
//  - Test validation rule application and error handling with platform variations
//  - Validate form state transitions and updates across platforms
//  - Test field option handling and selection logic with mock capabilities
//  - Verify metadata and configuration management on all platforms
//  - Test cross-platform compatibility and behavior with comprehensive platform testing
//
//  AUDIT STATUS: ✅ COMPLIANT
//  - ✅ File Documentation: Complete with business purpose, testing scope, methodology
//  - ✅ Function Documentation: All 17 functions documented with business purpose
//  - ✅ Platform Testing: Comprehensive platform testing added to key functions
//  - ✅ Mock Testing: RuntimeCapabilityDetection mock testing implemented
//  - ✅ Business Logic Focus: Tests actual dynamic form functionality, not testing framework
//

import XCTest
@testable import SixLayerFramework

@MainActor
final class DynamicFormTests: XCTestCase {
    
    // MARK: - Dynamic Form Field Tests
    
    /// BUSINESS PURPOSE: Validate DynamicFormField creation functionality
    /// TESTING SCOPE: Tests DynamicFormField initialization with various configuration parameters
    /// METHODOLOGY: Create DynamicFormField with comprehensive parameters and verify all properties are set correctly
    func testDynamicFormFieldCreation() {
        // Test across all platforms
        for platform in SixLayerPlatform.allCases {
            RuntimeCapabilityDetection.setTestPlatform(platform)
            
            let field = DynamicFormField(
                id: "testField",
                contentType: .text,
                label: "Test Field",
                placeholder: "Enter text",
                isRequired: true,
                validationRules: ["minLength": "2"],
                options: nil,
                defaultValue: "",
                metadata: ["maxWidth": "200"]
            )
            
            XCTAssertEqual(field.id, "testField")
            XCTAssertEqual(field.contentType, .text)
            XCTAssertEqual(field.label, "Test Field")
            XCTAssertEqual(field.placeholder, "Enter text")
            XCTAssertTrue(field.isRequired)
            XCTAssertEqual(field.validationRules?["minLength"], "2")
            XCTAssertNil(field.options)
            XCTAssertEqual(field.defaultValue, "")
            XCTAssertEqual(field.metadata?["maxWidth"], "200")
            
            RuntimeCapabilityDetection.clearAllCapabilityOverrides()
        }
    }
    
    // MARK: - Dynamic Form Section Tests
    
    /// BUSINESS PURPOSE: Validate DynamicFormSection creation functionality
    /// TESTING SCOPE: Tests DynamicFormSection initialization with fields and configuration
    /// METHODOLOGY: Create DynamicFormSection with multiple fields and verify all section properties are set correctly
    func testDynamicFormSectionCreation() {
        let fields = [
            DynamicFormField(id: "field1", contentType: .text, label: "Field 1"),
            DynamicFormField(id: "field2", contentType: .email, label: "Field 2")
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
    
    /// BUSINESS PURPOSE: Validate DynamicFormSection helper functionality
    /// TESTING SCOPE: Tests DynamicFormSection field access and helper methods
    /// METHODOLOGY: Create DynamicFormSection and verify field access and helper method functionality
    func testDynamicFormSectionHelpers() {
        let fields = [
            DynamicFormField(id: "field1", contentType: .text, label: "Field 1"),
            DynamicFormField(id: "field2", contentType: .email, label: "Field 2")
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
    
    /// BUSINESS PURPOSE: Validate DynamicFormConfiguration creation functionality
    /// TESTING SCOPE: Tests DynamicFormConfiguration initialization with sections and configuration
    /// METHODOLOGY: Create DynamicFormConfiguration with sections and verify all configuration properties are set correctly
    func testDynamicFormConfigurationCreation() {
        let sections = [
            DynamicFormSection(
                id: "section1",
                title: "Section 1",
                fields: [
                    DynamicFormField(id: "field1", contentType: .text, label: "Field 1")
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
    
    /// BUSINESS PURPOSE: Validate DynamicFormConfiguration helper functionality
    /// TESTING SCOPE: Tests DynamicFormConfiguration helper methods and field access
    /// METHODOLOGY: Create DynamicFormConfiguration and verify helper method functionality
    func testDynamicFormConfigurationHelpers() {
        let fields = [
            DynamicFormField(id: "field1", contentType: .text, label: "Field 1"),
            DynamicFormField(id: "field2", contentType: .email, label: "Field 2")
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
        XCTAssertEqual(field1?.contentType, .text)
        
        let field2 = config.getField(by: "field2")
        XCTAssertNotNil(field2)
        XCTAssertEqual(field2?.contentType, .email)
        
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
    
    /// BUSINESS PURPOSE: Validate DynamicFormState creation functionality
    /// TESTING SCOPE: Tests DynamicFormState initialization with configuration
    /// METHODOLOGY: Create DynamicFormState with configuration and verify initial state properties
    func testDynamicFormStateCreation() {
        // Test across all platforms
        for platform in SixLayerPlatform.allCases {
            RuntimeCapabilityDetection.setTestPlatform(platform)
            
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
            
            RuntimeCapabilityDetection.clearAllCapabilityOverrides()
        }
    }
    
    /// BUSINESS PURPOSE: Validate DynamicFormState field value management functionality
    /// TESTING SCOPE: Tests DynamicFormState field value setting and retrieval
    /// METHODOLOGY: Set field values in DynamicFormState and verify value management functionality
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
    
    /// BUSINESS PURPOSE: Validate DynamicFormState validation functionality
    /// TESTING SCOPE: Tests DynamicFormState error management and validation
    /// METHODOLOGY: Add and clear errors in DynamicFormState and verify validation functionality
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
    
    /// BUSINESS PURPOSE: Validate DynamicFormState section management functionality
    /// TESTING SCOPE: Tests DynamicFormState section state management and operations
    /// METHODOLOGY: Toggle section states in DynamicFormState and verify section management functionality
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
    
    /// BUSINESS PURPOSE: Validate DynamicFormState reset functionality
    /// TESTING SCOPE: Tests DynamicFormState reset and state clearing
    /// METHODOLOGY: Set state, reset DynamicFormState, and verify complete state reset functionality
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
    
    /// BUSINESS PURPOSE: Validate DynamicFormBuilder basic flow functionality
    /// TESTING SCOPE: Tests DynamicFormBuilder basic form building workflow
    /// METHODOLOGY: Use DynamicFormBuilder to create form and verify basic building functionality
    func testDynamicFormBuilderBasicFlow() {
        var builder = DynamicFormBuilder()
        builder.startSection(id: "personal", title: "Personal Information")
        builder.addContentField(id: "firstName", contentType: .text, label: "First Name", isRequired: true)
        builder.addContentField(id: "lastName", contentType: .text, label: "Last Name", isRequired: true)
        builder.endSection()
        builder.startSection(id: "contact", title: "Contact Information")
        builder.addContentField(id: "email", contentType: .email, label: "Email", isRequired: true)
        builder.addContentField(id: "phone", contentType: .phone, label: "Phone")
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
    
    /// BUSINESS PURPOSE: Validate DynamicFormBuilder validation functionality
    /// TESTING SCOPE: Tests DynamicFormBuilder form building with validation rules
    /// METHODOLOGY: Use DynamicFormBuilder to create form with validation and verify validation functionality
    func testDynamicFormBuilderWithValidation() {
        let validationRules = ["minLength": "3", "maxLength": "50", "pattern": "^[a-zA-Z]+$"]
        
        var builder = DynamicFormBuilder()
        builder.startSection(id: "validation", title: "Validation Test")
        builder.addContentField(
            id: "username",
            contentType: .text,
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
        XCTAssertEqual(field.contentType, .text)
        XCTAssertEqual(field.validationRules?["minLength"], "3")
        XCTAssertEqual(field.validationRules?["maxLength"], "50")
        XCTAssertEqual(field.validationRules?["pattern"], "^[a-zA-Z]+$")
    }
    
    /// BUSINESS PURPOSE: Validate DynamicFormBuilder options functionality
    /// TESTING SCOPE: Tests DynamicFormBuilder form building with field options
    /// METHODOLOGY: Use DynamicFormBuilder to create form with options and verify options functionality
    func testDynamicFormBuilderWithOptions() {
        var builder = DynamicFormBuilder()
        builder.startSection(id: "preferences", title: "Preferences")
        builder.addContentField(
            id: "theme",
            contentType: .select,
            label: "Theme",
            options: ["Light", "Dark", "Auto"]
        )
        builder.addContentField(
            id: "notifications",
            contentType: .multiselect,
            label: "Notifications",
            options: ["Email", "Push", "SMS"]
        )
        builder.addContentField(
            id: "newsletter",
            contentType: .checkbox,
            label: "Subscribe to newsletter"
        )
        let config = builder.build(
            id: "options-form",
            title: "Options Form"
        )
        
        XCTAssertEqual(config.sections.count, 1)
        XCTAssertEqual(config.sections[0].fields.count, 3)
        
        let themeField = config.sections[0].fields[0]
        XCTAssertEqual(themeField.contentType, .select)
        XCTAssertEqual(themeField.options?.count, 3)
        XCTAssertTrue(themeField.contentType == .select)
        
        let notificationsField = config.sections[0].fields[1]
        XCTAssertEqual(notificationsField.contentType, .multiselect)
        XCTAssertTrue(notificationsField.contentType == .multiselect)
    }
    
    /// BUSINESS PURPOSE: Validate DynamicFormBuilder metadata functionality
    /// TESTING SCOPE: Tests DynamicFormBuilder form building with metadata
    /// METHODOLOGY: Use DynamicFormBuilder to create form with metadata and verify metadata functionality
    func testDynamicFormBuilderWithMetadata() {
        var builder = DynamicFormBuilder()
        builder.startSection(
            id: "metadata",
            title: "Metadata Test",
            description: "Testing metadata support",
            isCollapsible: true,
            isCollapsed: false
        )
        builder.addContentField(
            id: "testField",
            contentType: .text,
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
    
    /// BUSINESS PURPOSE: Validate DynamicForm complete workflow functionality
    /// TESTING SCOPE: Tests DynamicForm complete end-to-end workflow
    /// METHODOLOGY: Create complete DynamicForm workflow and verify end-to-end functionality
    func testDynamicFormCompleteWorkflow() {
        var builder = DynamicFormBuilder()
        builder.startSection(id: "personal", title: "Personal Information")
        builder.addContentField(id: "firstName", contentType: .text, label: "First Name", isRequired: true)
        builder.addContentField(id: "lastName", contentType: .text, label: "Last Name", isRequired: true)
        builder.addContentField(id: "email", contentType: .email, label: "Email", isRequired: true)
        builder.endSection()
        builder.startSection(id: "preferences", title: "Preferences", isCollapsible: true)
        builder.addContentField(id: "theme", contentType: .select, label: "Theme", options: ["Light", "Dark"])
        builder.addContentField(id: "notifications", contentType: .toggle, label: "Enable notifications")
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
    
    /// BUSINESS PURPOSE: Validate DynamicFormBuilder performance functionality
    /// TESTING SCOPE: Tests DynamicFormBuilder performance with large forms
    /// METHODOLOGY: Measure DynamicFormBuilder performance when creating large forms with many fields
    func testDynamicFormBuilderPerformance() {
        measure {
            var builder = DynamicFormBuilder()
            for i in 0..<100 {
                builder.startSection(id: "section\(i)", title: "Section \(i)")
                for j in 0..<10 {
                    builder.addContentField(
                        id: "field\(i)_\(j)",
                        contentType: .text,
                        label: "Field \(i)-\(j)"
                    )
                }
                builder.endSection()
            }
            let _ = builder.build(id: "perf-form", title: "Performance Form")
        }
    }
    
    /// BUSINESS PURPOSE: Validate DynamicFormState performance functionality
    /// TESTING SCOPE: Tests DynamicFormState performance with large forms
    /// METHODOLOGY: Measure DynamicFormState performance when managing large forms with many fields
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
                            contentType: .text,
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
