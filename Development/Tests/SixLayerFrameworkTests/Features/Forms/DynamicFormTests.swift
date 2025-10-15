import Testing

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

@testable import SixLayerFramework

@MainActor
final class DynamicFormTests: BaseAccessibilityTestClass {
    
    // MARK: - Dynamic Form Field Tests
    
    /// BUSINESS PURPOSE: Validate DynamicFormField creation functionality
    /// TESTING SCOPE: Tests DynamicFormField initialization with various configuration parameters
    /// METHODOLOGY: Create DynamicFormField with comprehensive parameters and verify all properties are set correctly
    @Test func testDynamicFormFieldCreation() {
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
            
            #expect(field.id == "testField")
            #expect(field.contentType == .text)
            #expect(field.label == "Test Field")
            #expect(field.placeholder == "Enter text")
            #expect(field.isRequired)
            #expect(field.validationRules?["minLength"] == "2")
            #expect(field.options == nil)
            #expect(field.defaultValue == "")
            #expect(field.metadata?["maxWidth"] == "200")
            
            RuntimeCapabilityDetection.clearAllCapabilityOverrides()
        }
    }
    
    // MARK: - Dynamic Form Section Tests
    
    /// BUSINESS PURPOSE: Validate DynamicFormSection creation functionality
    /// TESTING SCOPE: Tests DynamicFormSection initialization with fields and configuration
    /// METHODOLOGY: Create DynamicFormSection with multiple fields and verify all section properties are set correctly
    @Test func testDynamicFormSectionCreation() {
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
        
        #expect(section.id == "testSection")
        #expect(section.title == "Test Section")
        #expect(section.description == "A test section")
        #expect(section.fields.count == 2)
        #expect(section.isCollapsible)
        #expect(!section.isCollapsed)
        #expect(section.metadata?["order"] == "1")
    }
    
    /// BUSINESS PURPOSE: Validate DynamicFormSection helper functionality
    /// TESTING SCOPE: Tests DynamicFormSection field access and helper methods
    /// METHODOLOGY: Create DynamicFormSection and verify field access and helper method functionality
    @Test func testDynamicFormSectionHelpers() {
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
        #expect(section.fields.count == 2)
        #expect(section.fields[0].id == "field1")
        #expect(section.fields[1].id == "field2")
    }
    
    // MARK: - Dynamic Form Configuration Tests
    
    /// BUSINESS PURPOSE: Validate DynamicFormConfiguration creation functionality
    /// TESTING SCOPE: Tests DynamicFormConfiguration initialization with sections and configuration
    /// METHODOLOGY: Create DynamicFormConfiguration with sections and verify all configuration properties are set correctly
    @Test func testDynamicFormConfigurationCreation() {
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
        
        #expect(config.id == "testForm")
        #expect(config.title == "Test Form")
        #expect(config.description == "A test form")
        #expect(config.sections.count == 1)
        #expect(config.submitButtonText == "Submit Form")
        #expect(config.cancelButtonText == "Cancel")
        #expect(config.metadata?["version"] == "1.0")
    }
    
    /// BUSINESS PURPOSE: Validate DynamicFormConfiguration helper functionality
    /// TESTING SCOPE: Tests DynamicFormConfiguration helper methods and field access
    /// METHODOLOGY: Create DynamicFormConfiguration and verify helper method functionality
    @Test func testDynamicFormConfigurationHelpers() {
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
        #expect(allFields.count == 2)
        #expect(allFields[0].id == "field1")
        #expect(allFields[1].id == "field2")
        
        // Test field lookup
        let field1 = config.getField(by: "field1")
        #expect(field1 != nil)
        #expect(field1?.contentType == .text)
        
        let field2 = config.getField(by: "field2")
        #expect(field2 != nil)
        #expect(field2?.contentType == .email)
        
        let nonExistentField = config.getField(by: "nonExistent")
        #expect(nonExistentField == nil)
        
        // Test section lookup
        let section1 = config.getSection(by: "section1")
        #expect(section1 != nil)
        #expect(section1?.title == "Section 1")
        
        let nonExistentSection = config.getSection(by: "nonExistent")
        #expect(nonExistentSection == nil)
    }
    
    // MARK: - Dynamic Form State Tests
    
    /// BUSINESS PURPOSE: Validate DynamicFormState creation functionality
    /// TESTING SCOPE: Tests DynamicFormState initialization with configuration
    /// METHODOLOGY: Create DynamicFormState with configuration and verify initial state properties
    @Test func testDynamicFormStateCreation() {
        // Test across all platforms
        for platform in SixLayerPlatform.allCases {
            RuntimeCapabilityDetection.setTestPlatform(platform)
            
            let config = DynamicFormConfiguration(
                id: "testForm",
                title: "Test Form",
                sections: []
            )
            
            let state = DynamicFormState(configuration: config)
            
            #expect(state.fieldValues.count == 0)
            #expect(state.fieldErrors.count == 0)
            #expect(state.sectionStates.count == 0)
            #expect(!state.isSubmitting)
            #expect(!state.isDirty)
            #expect(state.isValid)
            
            RuntimeCapabilityDetection.clearAllCapabilityOverrides()
        }
    }
    
    /// BUSINESS PURPOSE: Validate DynamicFormState field value management functionality
    /// TESTING SCOPE: Tests DynamicFormState field value setting and retrieval
    /// METHODOLOGY: Set field values in DynamicFormState and verify value management functionality
    @Test func testDynamicFormStateFieldValues() {
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
        
        #expect(state.getValue(for: "firstName") as String? == "John")
        #expect(state.getValue(for: "age") as Int? == 25)
        #expect(state.getValue(for: "isActive") as Bool? == true)
        #expect(state.isDirty)
    }
    
    /// BUSINESS PURPOSE: Validate DynamicFormState validation functionality
    /// TESTING SCOPE: Tests DynamicFormState error management and validation
    /// METHODOLOGY: Add and clear errors in DynamicFormState and verify validation functionality
    @Test func testDynamicFormStateValidation() {
        let config = DynamicFormConfiguration(
            id: "testForm",
            title: "Test Form",
            sections: []
        )
        
        let state = DynamicFormState(configuration: config)
        
        // Test error management
        #expect(!state.hasErrors(for: "testField"))
        #expect(state.getErrors(for: "testField").count == 0)
        
        state.addError("Field is required", for: "testField")
        #expect(state.hasErrors(for: "testField"))
        #expect(state.getErrors(for: "testField").count == 1)
        #expect(state.getErrors(for: "testField").contains("Field is required"))
        
        state.addError("Field is too short", for: "testField")
        #expect(state.getErrors(for: "testField").count == 2)
        
        state.clearErrors(for: "testField")
        #expect(!state.hasErrors(for: "testField"))
        #expect(state.getErrors(for: "testField").count == 0)
        
        state.clearAllErrors()
        #expect(state.fieldErrors.count == 0)
    }
    
    /// BUSINESS PURPOSE: Validate DynamicFormState section management functionality
    /// TESTING SCOPE: Tests DynamicFormState section state management and operations
    /// METHODOLOGY: Toggle section states in DynamicFormState and verify section management functionality
    @Test func testDynamicFormStateSections() {
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
        #expect(!state.isSectionCollapsed("section1"))
        
        state.toggleSection("section1")
        #expect(state.isSectionCollapsed("section1"))
        
        state.toggleSection("section1")
        #expect(!state.isSectionCollapsed("section1"))
    }
    
    /// BUSINESS PURPOSE: Validate DynamicFormState reset functionality
    /// TESTING SCOPE: Tests DynamicFormState reset and state clearing
    /// METHODOLOGY: Set state, reset DynamicFormState, and verify complete state reset functionality
    @Test func testDynamicFormStateReset() {
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
        #expect(state.isDirty)
        #expect(state.hasErrors(for: "firstName"))
        #expect(state.isSectionCollapsed("section1"))
        
        // Reset
        state.reset()
        
        // Verify state is reset
        #expect(!state.isDirty)
        #expect(!state.hasErrors(for: "firstName"))
        #expect(!state.isSectionCollapsed("section1"))
    }
    
    // MARK: - Dynamic Form Builder Tests
    
    /// BUSINESS PURPOSE: Validate DynamicFormBuilder basic flow functionality
    /// TESTING SCOPE: Tests DynamicFormBuilder basic form building workflow
    /// METHODOLOGY: Use DynamicFormBuilder to create form and verify basic building functionality
    @Test func testDynamicFormBuilderBasicFlow() {
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
        
        #expect(config.id == "user-form")
        #expect(config.title == "User Registration")
        #expect(config.sections.count == 2)
        #expect(config.sections[0].id == "personal")
        #expect(config.sections[1].id == "contact")
        #expect(config.sections[0].fields.count == 2)
        #expect(config.sections[1].fields.count == 2)
    }
    
    /// BUSINESS PURPOSE: Validate DynamicFormBuilder validation functionality
    /// TESTING SCOPE: Tests DynamicFormBuilder form building with validation rules
    /// METHODOLOGY: Use DynamicFormBuilder to create form with validation and verify validation functionality
    @Test func testDynamicFormBuilderWithValidation() {
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
        
        #expect(config.id == "validation-form")
        #expect(config.title == "Validation Form")
        #expect(config.sections.count == 1)
        #expect(config.sections[0].fields.count == 1)
        
        let field = config.sections[0].fields[0]
        #expect(field.id == "username")
        #expect(field.contentType == .text)
        #expect(field.validationRules?["minLength"] == "3")
        #expect(field.validationRules?["maxLength"] == "50")
        #expect(field.validationRules?["pattern"] == "^[a-zA-Z]+$")
    }
    
    /// BUSINESS PURPOSE: Validate DynamicFormBuilder options functionality
    /// TESTING SCOPE: Tests DynamicFormBuilder form building with field options
    /// METHODOLOGY: Use DynamicFormBuilder to create form with options and verify options functionality
    @Test func testDynamicFormBuilderWithOptions() {
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
        
        #expect(config.sections.count == 1)
        #expect(config.sections[0].fields.count == 3)
        
        let themeField = config.sections[0].fields[0]
        #expect(themeField.contentType == .select)
        #expect(themeField.options?.count == 3)
        #expect(themeField.contentType == .select)
        
        let notificationsField = config.sections[0].fields[1]
        #expect(notificationsField.contentType == .multiselect)
        #expect(notificationsField.contentType == .multiselect)
    }
    
    /// BUSINESS PURPOSE: Validate DynamicFormBuilder metadata functionality
    /// TESTING SCOPE: Tests DynamicFormBuilder form building with metadata
    /// METHODOLOGY: Use DynamicFormBuilder to create form with metadata and verify metadata functionality
    @Test func testDynamicFormBuilderWithMetadata() {
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
        
        #expect(config.sections.count == 1)
        let section = config.sections[0]
        #expect(section.isCollapsible)
        #expect(!section.isCollapsed)
        
        let field = section.fields[0]
        #expect(field.metadata?["maxWidth"] == "300")
        #expect(field.metadata?["placeholder"] == "Custom placeholder")
    }
    
    /// BUSINESS PURPOSE: Validate DynamicForm complete workflow functionality
    /// TESTING SCOPE: Tests DynamicForm complete end-to-end workflow
    /// METHODOLOGY: Create complete DynamicForm workflow and verify end-to-end functionality
    @Test func testDynamicFormCompleteWorkflow() {
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
        #expect(formData["firstName"] as? String == "John")
        #expect(formData["lastName"] as? String == "Doe")
        #expect(formData["email"] as? String == "john@example.com")
        #expect(formData["theme"] as? String == "Dark")
        #expect(formData["notifications"] as? Bool == true)
        
        // Verify form is valid
        #expect(formState.isValid)
        #expect(formState.isDirty)
    }
    
    // MARK: - Performance Tests
    
    /// BUSINESS PURPOSE: Validate DynamicFormBuilder performance functionality
    /// TESTING SCOPE: Tests DynamicFormBuilder performance with large forms
    /// METHODOLOGY: Measure DynamicFormBuilder performance when creating large forms with many fields
    @Test func testDynamicFormBuilderPerformance() {
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
    @Test func testDynamicFormStatePerformance() {
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

            let _ = state.formData
            let _ = state.isValid
            // Performance test removed - performance monitoring was removed from framework
