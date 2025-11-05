import Testing
import SwiftUI
@testable import SixLayerFramework
import ViewInspector

/// TDD RED PHASE: Tests for label text inclusion in accessibility identifiers
/// These tests SHOULD FAIL until components are updated to include label text
/// 
/// BUSINESS PURPOSE: Ensure all components with String labels include label text in identifiers
/// TESTING SCOPE: All framework components that accept String labels/titles
/// METHODOLOGY: Test each component type, verify label text is included and sanitized
@Suite("Component Label Text Accessibility")
@MainActor
open class ComponentLabelTextAccessibilityTests: BaseTestClass {
    
    // MARK: - AdaptiveButton Tests
    
    @Test func testAdaptiveButtonIncludesLabelText() {
        setupTestEnvironment()
        
        // TDD RED: This should FAIL - AdaptiveButton should include "Submit" in identifier
        let button = AdaptiveButton("Submit", action: { })
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        do {
            let inspected = try button.inspect()
            let buttonID = try inspected.accessibilityIdentifier()
            
            #expect(buttonID.contains("submit") || buttonID.contains("Submit"), 
                   "AdaptiveButton identifier should include label text 'Submit'")
            
            print("🔴 RED: AdaptiveButton ID: '\(buttonID)'")
        } catch {
            Issue.record("Failed to inspect AdaptiveButton: \(error)")
        }
        
        cleanupTestEnvironment()
    }
    
    @Test func testAdaptiveButtonDifferentLabelsDifferentIdentifiers() {
        setupTestEnvironment()
        
        let submitButton = AdaptiveButton("Submit", action: { })
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        let cancelButton = AdaptiveButton("Cancel", action: { })
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        do {
            let submitInspected = try submitButton.inspect()
            let submitID = try submitInspected.accessibilityIdentifier()
            
            let cancelInspected = try cancelButton.inspect()
            let cancelID = try cancelInspected.accessibilityIdentifier()
            
            // TDD RED: Should FAIL - different labels should produce different IDs
            #expect(submitID != cancelID, 
                   "Buttons with different labels should have different identifiers")
            
            print("🔴 RED: Submit ID: '\(submitID)'")
            print("🔴 RED: Cancel ID: '\(cancelID)'")
        } catch {
            Issue.record("Failed to inspect buttons: \(error)")
        }
        
        cleanupTestEnvironment()
    }
    
    // MARK: - Platform Navigation Title Tests
    
    @Test func testPlatformNavigationTitleIncludesTitleText() {
        setupTestEnvironment()
        
        // TDD RED: This should FAIL - platformNavigationTitle should include title in identifier
        let view = VStack {
            Text("Content")
        }
        .platformNavigationTitle("Settings")
        .enableGlobalAutomaticAccessibilityIdentifiers()
        
        do {
            let inspected = try view.inspect()
            let viewID = try inspected.accessibilityIdentifier()
            
            #expect(viewID.contains("settings") || viewID.contains("Settings"), 
                   "platformNavigationTitle identifier should include title text 'Settings'")
            
            print("🔴 RED: Navigation Title ID: '\(viewID)'")
        } catch {
            Issue.record("Failed to inspect platformNavigationTitle: \(error)")
        }
        
        cleanupTestEnvironment()
    }
    
    // MARK: - Platform Navigation Link Tests
    
    @Test func testPlatformNavigationLinkWithTitleIncludesTitleText() {
        setupTestEnvironment()
        
        // TDD RED: This should FAIL - platformNavigationLink_L4 with title should include title
        let view = VStack {
            platformNavigationLink_L4(
                title: "Next Page",
                systemImage: "arrow.right",
                isActive: .constant(false)
            ) {
                Text("Destination")
            }
        }
        .enableGlobalAutomaticAccessibilityIdentifiers()
        
        do {
            let inspected = try view.inspect()
            // Navigation link might be nested, try to find it
            let viewID = try inspected.accessibilityIdentifier()
            
            #expect(viewID.contains("next") || viewID.contains("page") || viewID.contains("Next"), 
                   "platformNavigationLink_L4 identifier should include title text 'Next Page'")
            
            print("🔴 RED: Navigation Link ID: '\(viewID)'")
        } catch {
            Issue.record("Failed to inspect platformNavigationLink_L4: \(error)")
        }
        
        cleanupTestEnvironment()
    }
    
    // MARK: - Platform Navigation Button Tests
    
    @Test func testPlatformNavigationButtonIncludesTitleText() {
        setupTestEnvironment()
        
        // TDD RED: This should FAIL - platformNavigationButton should include title
        let button = VStack {
            platformNavigationButton(
                title: "Save",
                systemImage: "checkmark",
                accessibilityLabel: "Save changes",
                accessibilityHint: "Tap to save",
                action: { }
            )
        }
        .enableGlobalAutomaticAccessibilityIdentifiers()
        
        do {
            let inspected = try button.inspect()
            let buttonID = try inspected.accessibilityIdentifier()
            
            #expect(buttonID.contains("save") || buttonID.contains("Save"), 
                   "platformNavigationButton identifier should include title text 'Save'")
            
            print("🔴 RED: Navigation Button ID: '\(buttonID)'")
        } catch {
            Issue.record("Failed to inspect platformNavigationButton: \(error)")
        }
        
        cleanupTestEnvironment()
    }
    
    // MARK: - Label Sanitization Tests
    
    @Test func testLabelTextSanitizationHandlesSpaces() {
        setupTestEnvironment()
        
        let button = AdaptiveButton("Add New Item", action: { })
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        do {
            let inspected = try button.inspect()
            let buttonID = try inspected.accessibilityIdentifier()
            
            // TDD RED: Should FAIL - spaces should be converted to hyphens
            #expect(!buttonID.contains("Add New Item"), 
                   "Identifier should not contain raw label with spaces")
            #expect(buttonID.contains("add-new-item") || buttonID.contains("add") && buttonID.contains("new"), 
                   "Identifier should contain sanitized label (hyphens)")
            
            print("🔴 RED: Sanitized ID: '\(buttonID)'")
        } catch {
            Issue.record("Failed to inspect button: \(error)")
        }
        
        cleanupTestEnvironment()
    }
    
    @Test func testLabelTextSanitizationHandlesSpecialCharacters() {
        setupTestEnvironment()
        
        let button = AdaptiveButton("Save & Close!", action: { })
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        do {
            let inspected = try button.inspect()
            let buttonID = try inspected.accessibilityIdentifier()
            
            // TDD RED: Should FAIL - special chars should be sanitized
            #expect(!buttonID.contains("&"), "Identifier should not contain '&'")
            #expect(!buttonID.contains("!"), "Identifier should not contain '!'")
            
            print("🔴 RED: Special chars ID: '\(buttonID)'")
        } catch {
            Issue.record("Failed to inspect button: \(error)")
        }
        
        cleanupTestEnvironment()
    }
    
    @Test func testLabelTextSanitizationHandlesCase() {
        setupTestEnvironment()
        
        let button = AdaptiveButton("CamelCaseLabel", action: { })
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        do {
            let inspected = try button.inspect()
            let buttonID = try inspected.accessibilityIdentifier()
            
            // TDD RED: Should FAIL - should be lowercase
            #expect(!buttonID.contains("CamelCaseLabel"), 
                   "Identifier should not contain mixed case label")
            #expect(buttonID.contains("camelcaselabel") || buttonID.contains("camel"), 
                   "Identifier should contain lowercase version")
            
            print("🔴 RED: Case sanitized ID: '\(buttonID)'")
        } catch {
            Issue.record("Failed to inspect button: \(error)")
        }
        
        cleanupTestEnvironment()
    }
    
    // MARK: - DynamicFormField Components Tests
    
    @Test func testDynamicTextFieldIncludesFieldLabel() {
        setupTestEnvironment()
        
        // TDD RED: DynamicTextField should include field.label in identifier
        let field = DynamicFormField(
            id: "test-field",
            contentType: .text,
            label: "Email Address",
            placeholder: "Enter email"
        )
        let formState = DynamicFormState(configuration: DynamicFormConfiguration(
            id: "test-form",
            title: "Test Form",
            sections: []
        ))
        formState.initializeField(field)
        
        let fieldView = DynamicTextField(field: field, formState: formState)
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        do {
            let inspected = try fieldView.inspect()
            let fieldID = try inspected.accessibilityIdentifier()
            
            // TDD RED: Should FAIL - should include sanitized label
            #expect(fieldID.contains("email") || fieldID.contains("address") || fieldID.contains("Email"), 
                   "DynamicTextField identifier should include field label 'Email Address'")
            
            print("🔴 RED: DynamicTextField ID: '\(fieldID)'")
        } catch {
            Issue.record("Failed to inspect DynamicTextField: \(error)")
        }
        
        cleanupTestEnvironment()
    }
    
    @Test func testDynamicEmailFieldIncludesFieldLabel() {
        setupTestEnvironment()
        
        let field = DynamicFormField(
            id: "email-field",
            contentType: .email,
            label: "User Email",
            placeholder: "Enter email"
        )
        let formState = DynamicFormState(configuration: DynamicFormConfiguration(
            id: "test-form",
            title: "Test",
            sections: []
        ))
        formState.initializeField(field)
        
        let fieldView = DynamicEmailField(field: field, formState: formState)
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        do {
            let inspected = try fieldView.inspect()
            let fieldID = try inspected.accessibilityIdentifier()
            
            // TDD RED: Should FAIL
            #expect(fieldID.contains("user") || fieldID.contains("email") || fieldID.contains("User"), 
                   "DynamicEmailField identifier should include field label 'User Email'")
            
            print("🔴 RED: DynamicEmailField ID: '\(fieldID)'")
        } catch {
            Issue.record("Failed to inspect DynamicEmailField: \(error)")
        }
        
        cleanupTestEnvironment()
    }
    
    @Test func testDynamicPasswordFieldIncludesFieldLabel() {
        setupTestEnvironment()
        
        let field = DynamicFormField(
            id: "password-field",
            contentType: .password,
            label: "Secure Password",
            placeholder: "Enter password"
        )
        let formState = DynamicFormState(configuration: DynamicFormConfiguration(
            id: "test-form",
            title: "Test",
            sections: []
        ))
        formState.initializeField(field)
        
        let fieldView = DynamicPasswordField(field: field, formState: formState)
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        do {
            let inspected = try fieldView.inspect()
            let fieldID = try inspected.accessibilityIdentifier()
            
            // TDD RED: Should FAIL
            #expect(fieldID.contains("secure") || fieldID.contains("password") || fieldID.contains("Secure"), 
                   "DynamicPasswordField identifier should include field label 'Secure Password'")
            
            print("🔴 RED: DynamicPasswordField ID: '\(fieldID)'")
        } catch {
            Issue.record("Failed to inspect DynamicPasswordField: \(error)")
        }
        
        cleanupTestEnvironment()
    }
    
    // MARK: - DynamicFormView Tests
    
    @Test func testDynamicFormViewIncludesConfigurationTitle() {
        setupTestEnvironment()
        
        // TDD RED: DynamicFormView should include configuration.title in identifier
        let config = DynamicFormConfiguration(
            id: "user-profile-form",
            title: "User Profile",
            description: "Edit your profile",
            sections: []
        )
        
        let formView = DynamicFormView(configuration: config, onSubmit: { _ in })
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        do {
            let inspected = try formView.inspect()
            let formID = try inspected.accessibilityIdentifier()
            
            // TDD RED: Should FAIL - should include title
            #expect(formID.contains("user") || formID.contains("profile") || formID.contains("User"), 
                   "DynamicFormView identifier should include configuration title 'User Profile'")
            
            print("🔴 RED: DynamicFormView ID: '\(formID)'")
        } catch {
            Issue.record("Failed to inspect DynamicFormView: \(error)")
        }
        
        cleanupTestEnvironment()
    }
    
    // MARK: - DynamicFormSectionView Tests
    
    @Test func testDynamicFormSectionViewIncludesSectionTitle() {
        setupTestEnvironment()
        
        // TDD RED: DynamicFormSectionView should include section.title in identifier
        let section = DynamicFormSection(
            id: "personal-info",
            title: "Personal Information",
            description: "Enter your personal details",
            fields: []
        )
        let formState = DynamicFormState(configuration: DynamicFormConfiguration(
            id: "test-form",
            title: "Test",
            sections: [section]
        ))
        
        let sectionView = DynamicFormSectionView(section: section, formState: formState)
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        do {
            let inspected = try sectionView.inspect()
            let sectionID = try inspected.accessibilityIdentifier()
            
            // TDD RED: Should FAIL - should include title
            #expect(sectionID.contains("personal") || sectionID.contains("information") || sectionID.contains("Personal"), 
                   "DynamicFormSectionView identifier should include section title 'Personal Information'")
            
            print("🔴 RED: DynamicFormSectionView ID: '\(sectionID)'")
        } catch {
            Issue.record("Failed to inspect DynamicFormSectionView: \(error)")
        }
        
        cleanupTestEnvironment()
    }
    
    // MARK: - Additional DynamicField Components Tests
    
    @Test func testDynamicPhoneFieldIncludesFieldLabel() {
        setupTestEnvironment()
        
        let field = DynamicFormField(
            id: "phone-field",
            contentType: .phone,
            label: "Mobile Phone",
            placeholder: "Enter phone number"
        )
        let formState = DynamicFormState(configuration: DynamicFormConfiguration(
            id: "test-form",
            title: "Test",
            sections: []
        ))
        formState.initializeField(field)
        
        let fieldView = DynamicPhoneField(field: field, formState: formState)
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        do {
            let inspected = try fieldView.inspect()
            let fieldID = try inspected.accessibilityIdentifier()
            
            #expect(fieldID.contains("mobile") || fieldID.contains("phone") || fieldID.contains("Mobile"), 
                   "DynamicPhoneField identifier should include field label 'Mobile Phone'")
            
            print("🔴 RED: DynamicPhoneField ID: '\(fieldID)'")
        } catch {
            Issue.record("Failed to inspect DynamicPhoneField: \(error)")
        }
        
        cleanupTestEnvironment()
    }
    
    @Test func testDynamicURLFieldIncludesFieldLabel() {
        setupTestEnvironment()
        
        let field = DynamicFormField(
            id: "url-field",
            contentType: .url,
            label: "Website URL",
            placeholder: "Enter URL"
        )
        let formState = DynamicFormState(configuration: DynamicFormConfiguration(
            id: "test-form",
            title: "Test",
            sections: []
        ))
        formState.initializeField(field)
        
        let fieldView = DynamicURLField(field: field, formState: formState)
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        do {
            let inspected = try fieldView.inspect()
            let fieldID = try inspected.accessibilityIdentifier()
            
            #expect(fieldID.contains("website") || fieldID.contains("url") || fieldID.contains("Website"), 
                   "DynamicURLField identifier should include field label 'Website URL'")
            
            print("🔴 RED: DynamicURLField ID: '\(fieldID)'")
        } catch {
            Issue.record("Failed to inspect DynamicURLField: \(error)")
        }
        
        cleanupTestEnvironment()
    }
    
    @Test func testDynamicNumberFieldIncludesFieldLabel() {
        setupTestEnvironment()
        
        let field = DynamicFormField(
            id: "number-field",
            contentType: .number,
            label: "Total Amount",
            placeholder: "Enter amount"
        )
        let formState = DynamicFormState(configuration: DynamicFormConfiguration(
            id: "test-form",
            title: "Test",
            sections: []
        ))
        formState.initializeField(field)
        
        let fieldView = DynamicNumberField(field: field, formState: formState)
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        do {
            let inspected = try fieldView.inspect()
            let fieldID = try inspected.accessibilityIdentifier()
            
            #expect(fieldID.contains("total") || fieldID.contains("amount") || fieldID.contains("Total"), 
                   "DynamicNumberField identifier should include field label 'Total Amount'")
            
            print("🔴 RED: DynamicNumberField ID: '\(fieldID)'")
        } catch {
            Issue.record("Failed to inspect DynamicNumberField: \(error)")
        }
        
        cleanupTestEnvironment()
    }
    
    @Test func testDynamicDateFieldIncludesFieldLabel() {
        setupTestEnvironment()
        
        let field = DynamicFormField(
            id: "date-field",
            contentType: .date,
            label: "Birth Date",
            placeholder: "Select date"
        )
        let formState = DynamicFormState(configuration: DynamicFormConfiguration(
            id: "test-form",
            title: "Test",
            sections: []
        ))
        formState.initializeField(field)
        
        let fieldView = DynamicDateField(field: field, formState: formState)
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        do {
            let inspected = try fieldView.inspect()
            let fieldID = try inspected.accessibilityIdentifier()
            
            #expect(fieldID.contains("birth") || fieldID.contains("date") || fieldID.contains("Birth"), 
                   "DynamicDateField identifier should include field label 'Birth Date'")
            
            print("🔴 RED: DynamicDateField ID: '\(fieldID)'")
        } catch {
            Issue.record("Failed to inspect DynamicDateField: \(error)")
        }
        
        cleanupTestEnvironment()
    }
    
    @Test func testDynamicToggleFieldIncludesFieldLabel() {
        setupTestEnvironment()
        
        let field = DynamicFormField(
            id: "toggle-field",
            contentType: .toggle,
            label: "Enable Notifications",
            placeholder: nil
        )
        let formState = DynamicFormState(configuration: DynamicFormConfiguration(
            id: "test-form",
            title: "Test",
            sections: []
        ))
        formState.initializeField(field)
        
        let fieldView = DynamicToggleField(field: field, formState: formState)
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        do {
            let inspected = try fieldView.inspect()
            let fieldID = try inspected.accessibilityIdentifier()
            
            #expect(fieldID.contains("enable") || fieldID.contains("notifications") || fieldID.contains("Enable"), 
                   "DynamicToggleField identifier should include field label 'Enable Notifications'")
            
            print("🔴 RED: DynamicToggleField ID: '\(fieldID)'")
        } catch {
            Issue.record("Failed to inspect DynamicToggleField: \(error)")
        }
        
        cleanupTestEnvironment()
    }
    
    @Test func testDynamicMultiSelectFieldIncludesFieldLabel() {
        setupTestEnvironment()
        
        let field = DynamicFormField(
            id: "multiselect-field",
            contentType: .multiselect,
            label: "Favorite Colors",
            placeholder: nil,
            options: ["Red", "Green", "Blue"]
        )
        let formState = DynamicFormState(configuration: DynamicFormConfiguration(
            id: "test-form",
            title: "Test",
            sections: []
        ))
        formState.initializeField(field)
        
        let fieldView = DynamicMultiSelectField(field: field, formState: formState)
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        do {
            let inspected = try fieldView.inspect()
            let fieldID = try inspected.accessibilityIdentifier()
            
            #expect(fieldID.contains("favorite") || fieldID.contains("colors") || fieldID.contains("Favorite"), 
                   "DynamicMultiSelectField identifier should include field label 'Favorite Colors'")
            
            print("🔴 RED: DynamicMultiSelectField ID: '\(fieldID)'")
        } catch {
            Issue.record("Failed to inspect DynamicMultiSelectField: \(error)")
        }
        
        cleanupTestEnvironment()
    }
    
    @Test func testDynamicCheckboxFieldIncludesFieldLabel() {
        setupTestEnvironment()
        
        let field = DynamicFormField(
            id: "checkbox-field",
            contentType: .checkbox,
            label: "Agree to Terms",
            placeholder: nil,
            options: ["I agree"]
        )
        let formState = DynamicFormState(configuration: DynamicFormConfiguration(
            id: "test-form",
            title: "Test",
            sections: []
        ))
        formState.initializeField(field)
        
        let fieldView = DynamicCheckboxField(field: field, formState: formState)
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        do {
            let inspected = try fieldView.inspect()
            let fieldID = try inspected.accessibilityIdentifier()
            
            #expect(fieldID.contains("agree") || fieldID.contains("terms") || fieldID.contains("Agree"), 
                   "DynamicCheckboxField identifier should include field label 'Agree to Terms'")
            
            print("🔴 RED: DynamicCheckboxField ID: '\(fieldID)'")
        } catch {
            Issue.record("Failed to inspect DynamicCheckboxField: \(error)")
        }
        
        cleanupTestEnvironment()
    }
    
    @Test func testDynamicFileFieldIncludesFieldLabel() {
        setupTestEnvironment()
        
        let field = DynamicFormField(
            id: "file-field",
            contentType: .file,
            label: "Upload Document",
            placeholder: nil
        )
        let formState = DynamicFormState(configuration: DynamicFormConfiguration(
            id: "test-form",
            title: "Test",
            sections: []
        ))
        formState.initializeField(field)
        
        let fieldView = DynamicFileField(field: field, formState: formState)
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        do {
            let inspected = try fieldView.inspect()
            let fieldID = try inspected.accessibilityIdentifier()
            
            #expect(fieldID.contains("upload") || fieldID.contains("document") || fieldID.contains("Upload"), 
                   "DynamicFileField identifier should include field label 'Upload Document'")
            
            print("🔴 RED: DynamicFileField ID: '\(fieldID)'")
        } catch {
            Issue.record("Failed to inspect DynamicFileField: \(error)")
        }
        
        cleanupTestEnvironment()
    }
    
    @Test func testDynamicEnumFieldIncludesFieldLabel() {
        setupTestEnvironment()
        
        let field = DynamicFormField(
            id: "enum-field",
            contentType: .enum,
            label: "Priority Level",
            placeholder: nil,
            options: ["Low", "Medium", "High"]
        )
        let formState = DynamicFormState(configuration: DynamicFormConfiguration(
            id: "test-form",
            title: "Test",
            sections: []
        ))
        formState.initializeField(field)
        
        let fieldView = DynamicEnumField(field: field, formState: formState)
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        do {
            let inspected = try fieldView.inspect()
            let fieldID = try inspected.accessibilityIdentifier()
            
            #expect(fieldID.contains("priority") || fieldID.contains("level") || fieldID.contains("Priority"), 
                   "DynamicEnumField identifier should include field label 'Priority Level'")
            
            print("🔴 RED: DynamicEnumField ID: '\(fieldID)'")
        } catch {
            Issue.record("Failed to inspect DynamicEnumField: \(error)")
        }
        
        cleanupTestEnvironment()
    }
    
    @Test func testDynamicIntegerFieldIncludesFieldLabel() {
        setupTestEnvironment()
        
        let field = DynamicFormField(
            id: "integer-field",
            contentType: .integer,
            label: "Quantity",
            placeholder: "Enter quantity"
        )
        let formState = DynamicFormState(configuration: DynamicFormConfiguration(
            id: "test-form",
            title: "Test",
            sections: []
        ))
        formState.initializeField(field)
        
        let fieldView = DynamicIntegerField(field: field, formState: formState)
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        do {
            let inspected = try fieldView.inspect()
            let fieldID = try inspected.accessibilityIdentifier()
            
            #expect(fieldID.contains("quantity") || fieldID.contains("Quantity"), 
                   "DynamicIntegerField identifier should include field label 'Quantity'")
            
            print("🔴 RED: DynamicIntegerField ID: '\(fieldID)'")
        } catch {
            Issue.record("Failed to inspect DynamicIntegerField: \(error)")
        }
        
        cleanupTestEnvironment()
    }
    
    @Test func testDynamicTextAreaFieldIncludesFieldLabel() {
        setupTestEnvironment()
        
        let field = DynamicFormField(
            id: "textarea-field",
            contentType: .textarea,
            label: "Comments",
            placeholder: "Enter comments"
        )
        let formState = DynamicFormState(configuration: DynamicFormConfiguration(
            id: "test-form",
            title: "Test",
            sections: []
        ))
        formState.initializeField(field)
        
        let fieldView = DynamicTextAreaField(field: field, formState: formState)
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        do {
            let inspected = try fieldView.inspect()
            let fieldID = try inspected.accessibilityIdentifier()
            
            #expect(fieldID.contains("comments") || fieldID.contains("Comments"), 
                   "DynamicTextAreaField identifier should include field label 'Comments'")
            
            print("🔴 RED: DynamicTextAreaField ID: '\(fieldID)'")
        } catch {
            Issue.record("Failed to inspect DynamicTextAreaField: \(error)")
        }
        
        cleanupTestEnvironment()
    }
}

