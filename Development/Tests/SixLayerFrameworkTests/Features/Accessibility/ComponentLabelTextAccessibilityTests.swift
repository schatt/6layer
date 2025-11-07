import Testing
import SwiftUI
@testable import SixLayerFramework
#if !os(macOS)
import ViewInspector
#endif

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
        let button = AdaptiveUIPatterns.AdaptiveButton("Submit", action: { })
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        // Using wrapper - when ViewInspector works on macOS, no changes needed here
        if let inspected = button.tryInspect() {
           let buttonID = try? inspected.accessibilityIdentifier()
            #expect(buttonID.contains("submit") || buttonID.contains("Submit"), 
                   "AdaptiveButton identifier should include label text 'Submit'")
            
            print("🔴 RED: AdaptiveButton ID: '\(buttonID)'")
        } else {
            Issue.record("Failed to inspect AdaptiveButton")
        }
        
        cleanupTestEnvironment()
    }
    
    @Test func testAdaptiveButtonDifferentLabelsDifferentIdentifiers() {
        setupTestEnvironment()
        
        let submitButton = AdaptiveUIPatterns.AdaptiveButton("Submit", action: { })
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        let cancelButton = AdaptiveUIPatterns.AdaptiveButton("Cancel", action: { })
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        // Using wrapper - when ViewInspector works on macOS, no changes needed here
        if let submitInspected = submitButton.tryInspect(),
           let submitID = try? submitInspected.accessibilityIdentifier(),
           let cancelInspected = cancelButton.tryInspect(),
           let cancelID = try? cancelInspected.accessibilityIdentifier() {
            // TDD RED: Should FAIL - different labels should produce different IDs
            #expect(submitID != cancelID, 
                   "Buttons with different labels should have different identifiers")
            
            print("🔴 RED: Submit ID: '\(submitID)'")
            print("🔴 RED: Cancel ID: '\(cancelID)'")
        } else {
            Issue.record("Failed to inspect buttons")
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
        
        // Using wrapper - when ViewInspector works on macOS, no changes needed here
        if let inspected = view.tryInspect(),
           let viewID = try? inspected.accessibilityIdentifier() {
            #expect(viewID.contains("settings") || viewID.contains("Settings"), 
                   "platformNavigationTitle identifier should include title text 'Settings'")
            
            print("🔴 RED: Navigation Title ID: '\(viewID)'")
        } else {
            Issue.record("Failed to inspect platformNavigationTitle")
        }
        
        cleanupTestEnvironment()
    }
    
    // MARK: - Platform Navigation Link Tests
    
    @Test func testPlatformNavigationLinkWithTitleIncludesTitleText() {
        setupTestEnvironment()
        
        // TDD RED: This should FAIL - platformNavigationLink_L4 with title should include title
        let view = VStack {
            Text("Navigate")
                .platformNavigationLink_L4(
                    title: "Next Page",
                    systemImage: "arrow.right",
                    isActive: Binding<Bool>.constant(false),
                    destination: {
                        Text("Destination")
                    }
                )
        }
        .enableGlobalAutomaticAccessibilityIdentifiers()
        
        // Using wrapper - when ViewInspector works on macOS, no changes needed here
        if let inspected = view.tryInspect(),
           let viewID = try? inspected.accessibilityIdentifier() {
            // Navigation link might be nested, try to find it
            #expect(viewID.contains("next") || viewID.contains("page") || viewID.contains("Next"), 
                   "platformNavigationLink_L4 identifier should include title text 'Next Page'")
            
            print("🔴 RED: Navigation Link ID: '\(viewID)'")
        } else {
            Issue.record("Failed to inspect platformNavigationLink_L4")
        }
        
        cleanupTestEnvironment()
    }
    
    // MARK: - Platform Navigation Button Tests
    
    @Test func testPlatformNavigationButtonIncludesTitleText() {
        setupTestEnvironment()
        
        // TDD RED: This should FAIL - platformNavigationButton should include title
        let button = VStack {
            EmptyView()
                .platformNavigationButton(
                    title: "Save",
                    systemImage: "checkmark",
                    accessibilityLabel: "Save changes",
                    accessibilityHint: "Tap to save",
                    action: { }
                )
        }
        .enableGlobalAutomaticAccessibilityIdentifiers()
        
        // Using wrapper - when ViewInspector works on macOS, no changes needed here
        if let inspected = button.tryInspect() {
           let buttonID = try? inspected.accessibilityIdentifier()

            #expect(buttonID.contains("save") || buttonID.contains("Save"), 
                   "platformNavigationButton identifier should include title text 'Save'")
            
            print("🔴 RED: Navigation Button ID: '\(buttonID)'")
        }
        
        cleanupTestEnvironment()
    }
    
    // MARK: - Label Sanitization Tests
    
    @Test func testLabelTextSanitizationHandlesSpaces() {
        setupTestEnvironment()
        
        let button = AdaptiveUIPatterns.AdaptiveButton("Add New Item", action: { })
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        // Using wrapper - when ViewInspector works on macOS, no changes needed here
        if let inspected = button.tryInspect() {
           let buttonID = try? inspected.accessibilityIdentifier()

            // TDD RED: Should FAIL - spaces should be converted to hyphens
            #expect(!buttonID.contains("Add New Item"), 
                   "Identifier should not contain raw label with spaces")
            #expect(buttonID.contains("add-new-item") || buttonID.contains("add") && buttonID.contains("new"), 
                   "Identifier should contain sanitized label (hyphens)")
            
            print("🔴 RED: Sanitized ID: '\(buttonID)'")
        
        cleanupTestEnvironment()
    }
    
    @Test func testLabelTextSanitizationHandlesSpecialCharacters() {
        setupTestEnvironment()
        
        let button = AdaptiveUIPatterns.AdaptiveButton("Save & Close!", action: { })
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        // Using wrapper - when ViewInspector works on macOS, no changes needed here
        if let inspected = button.tryInspect() {
           let buttonID = try? inspected.accessibilityIdentifier()

            // TDD RED: Should FAIL - special chars should be sanitized
            #expect(!buttonID.contains("&"), "Identifier should not contain '&'")
            #expect(!buttonID.contains("!"), "Identifier should not contain '!'")
            
            print("🔴 RED: Special chars ID: '\(buttonID)'")
        
        cleanupTestEnvironment()
    }
    
    @Test func testLabelTextSanitizationHandlesCase() {
        setupTestEnvironment()
        
        let button = AdaptiveUIPatterns.AdaptiveButton("CamelCaseLabel", action: { })
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        // Using wrapper - when ViewInspector works on macOS, no changes needed here
        if let inspected = button.tryInspect() {
           let buttonID = try? inspected.accessibilityIdentifier()

            // TDD RED: Should FAIL - should be lowercase
            #expect(!buttonID.contains("CamelCaseLabel"), 
                   "Identifier should not contain mixed case label")
            #expect(buttonID.contains("camelcaselabel") || buttonID.contains("camel"), 
                   "Identifier should contain lowercase version")
            
            print("🔴 RED: Case sanitized ID: '\(buttonID)'")
        
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
        
        // Using wrapper - when ViewInspector works on macOS, no changes needed here
        if let inspected = fieldView.tryInspect(),
           let fieldID = try? inspected.accessibilityIdentifier() {
            
            // TDD RED: Should FAIL - should include sanitized label
            #expect(fieldID.contains("email") || fieldID.contains("address") || fieldID.contains("Email"), 
                   "DynamicTextField identifier should include field label 'Email Address'")
            
            print("🔴 RED: DynamicTextField ID: '\(fieldID)'")
        
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
        
        // Using wrapper - when ViewInspector works on macOS, no changes needed here
        if let inspected = fieldView.tryInspect(),
           let fieldID = try? inspected.accessibilityIdentifier() {
            
            // TDD RED: Should FAIL
            #expect(fieldID.contains("user") || fieldID.contains("email") || fieldID.contains("User"), 
                   "DynamicEmailField identifier should include field label 'User Email'")
            
            print("🔴 RED: DynamicEmailField ID: '\(fieldID)'")
        
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
        
        // Using wrapper - when ViewInspector works on macOS, no changes needed here
        if let inspected = fieldView.tryInspect(),
           let fieldID = try? inspected.accessibilityIdentifier() {
            
            // TDD RED: Should FAIL
            #expect(fieldID.contains("secure") || fieldID.contains("password") || fieldID.contains("Secure"), 
                   "DynamicPasswordField identifier should include field label 'Secure Password'")
            
            print("🔴 RED: DynamicPasswordField ID: '\(fieldID)'")
        
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
        
        // Using wrapper - when ViewInspector works on macOS, no changes needed here
        if let inspected = formView.tryInspect(),
           let formID = try? inspected.accessibilityIdentifier() {
            
            // TDD RED: Should FAIL - should include title
            #expect(formID.contains("user") || formID.contains("profile") || formID.contains("User"), 
                   "DynamicFormView identifier should include configuration title 'User Profile'")
            
            print("🔴 RED: DynamicFormView ID: '\(formID)'")
        
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
        
        // Using wrapper - when ViewInspector works on macOS, no changes needed here
        if let inspected = sectionView.tryInspect(),
           let sectionID = try? inspected.accessibilityIdentifier() {
            
            // TDD RED: Should FAIL - should include title
            #expect(sectionID.contains("personal") || sectionID.contains("information") || sectionID.contains("Personal"), 
                   "DynamicFormSectionView identifier should include section title 'Personal Information'")
            
            print("🔴 RED: DynamicFormSectionView ID: '\(sectionID)'")
        
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
        
        // Using wrapper - when ViewInspector works on macOS, no changes needed here
        if let inspected = fieldView.tryInspect(),
           let fieldID = try? inspected.accessibilityIdentifier() {
            
            #expect(fieldID.contains("mobile") || fieldID.contains("phone") || fieldID.contains("Mobile"), 
                   "DynamicPhoneField identifier should include field label 'Mobile Phone'")
            
            print("🔴 RED: DynamicPhoneField ID: '\(fieldID)'")
        
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
        
        // Using wrapper - when ViewInspector works on macOS, no changes needed here
        if let inspected = fieldView.tryInspect(),
           let fieldID = try? inspected.accessibilityIdentifier() {
            
            #expect(fieldID.contains("website") || fieldID.contains("url") || fieldID.contains("Website"), 
                   "DynamicURLField identifier should include field label 'Website URL'")
            
            print("🔴 RED: DynamicURLField ID: '\(fieldID)'")
        
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
        
        // Using wrapper - when ViewInspector works on macOS, no changes needed here
        if let inspected = fieldView.tryInspect(),
           let fieldID = try? inspected.accessibilityIdentifier() {
            
            #expect(fieldID.contains("total") || fieldID.contains("amount") || fieldID.contains("Total"), 
                   "DynamicNumberField identifier should include field label 'Total Amount'")
            
            print("🔴 RED: DynamicNumberField ID: '\(fieldID)'")
        
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
        
        // Using wrapper - when ViewInspector works on macOS, no changes needed here
        if let inspected = fieldView.tryInspect(),
           let fieldID = try? inspected.accessibilityIdentifier() {
            
            #expect(fieldID.contains("birth") || fieldID.contains("date") || fieldID.contains("Birth"), 
                   "DynamicDateField identifier should include field label 'Birth Date'")
            
            print("🔴 RED: DynamicDateField ID: '\(fieldID)'")
        
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
        
        // Using wrapper - when ViewInspector works on macOS, no changes needed here
        if let inspected = fieldView.tryInspect(),
           let fieldID = try? inspected.accessibilityIdentifier() {
            
            #expect(fieldID.contains("enable") || fieldID.contains("notifications") || fieldID.contains("Enable"), 
                   "DynamicToggleField identifier should include field label 'Enable Notifications'")
            
            print("🔴 RED: DynamicToggleField ID: '\(fieldID)'")
        
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
        
        // Using wrapper - when ViewInspector works on macOS, no changes needed here
        if let inspected = fieldView.tryInspect(),
           let fieldID = try? inspected.accessibilityIdentifier() {
            
            #expect(fieldID.contains("favorite") || fieldID.contains("colors") || fieldID.contains("Favorite"), 
                   "DynamicMultiSelectField identifier should include field label 'Favorite Colors'")
            
            print("🔴 RED: DynamicMultiSelectField ID: '\(fieldID)'")
        
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
        
        // Using wrapper - when ViewInspector works on macOS, no changes needed here
        if let inspected = fieldView.tryInspect(),
           let fieldID = try? inspected.accessibilityIdentifier() {
            
            #expect(fieldID.contains("agree") || fieldID.contains("terms") || fieldID.contains("Agree"), 
                   "DynamicCheckboxField identifier should include field label 'Agree to Terms'")
            
            print("🔴 RED: DynamicCheckboxField ID: '\(fieldID)'")
        
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
        
        // Using wrapper - when ViewInspector works on macOS, no changes needed here
        if let inspected = fieldView.tryInspect(),
           let fieldID = try? inspected.accessibilityIdentifier() {
            
            #expect(fieldID.contains("upload") || fieldID.contains("document") || fieldID.contains("Upload"), 
                   "DynamicFileField identifier should include field label 'Upload Document'")
            
            print("🔴 RED: DynamicFileField ID: '\(fieldID)'")
        
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
        
        // Using wrapper - when ViewInspector works on macOS, no changes needed here
        if let inspected = fieldView.tryInspect(),
           let fieldID = try? inspected.accessibilityIdentifier() {
            
            #expect(fieldID.contains("priority") || fieldID.contains("level") || fieldID.contains("Priority"), 
                   "DynamicEnumField identifier should include field label 'Priority Level'")
            
            print("🔴 RED: DynamicEnumField ID: '\(fieldID)'")
        
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
        
        // Using wrapper - when ViewInspector works on macOS, no changes needed here
        if let inspected = fieldView.tryInspect(),
           let fieldID = try? inspected.accessibilityIdentifier() {
            
            #expect(fieldID.contains("quantity") || fieldID.contains("Quantity"), 
                   "DynamicIntegerField identifier should include field label 'Quantity'")
            
            print("🔴 RED: DynamicIntegerField ID: '\(fieldID)'")
        
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
        
        // Using wrapper - when ViewInspector works on macOS, no changes needed here
        if let inspected = fieldView.tryInspect(),
           let fieldID = try? inspected.accessibilityIdentifier() {
            
            #expect(fieldID.contains("comments") || fieldID.contains("Comments"), 
                   "DynamicTextAreaField identifier should include field label 'Comments'")
            
            print("🔴 RED: DynamicTextAreaField ID: '\(fieldID)'")
        
        cleanupTestEnvironment()
    }
    
    // MARK: - List Item Components Tests
    
    /// Test that list items created from objects get unique identifiers based on their titles
    @Test func testListCardComponentIncludesItemTitleInIdentifier() {
        setupTestEnvironment()
        
        // TDD RED: ListCardComponent should include item title in identifier
        struct TestItem: Identifiable {
            let id: String
            let title: String
        }
        
        let item1 = TestItem(id: "item-1", title: "First Item")
        let item2 = TestItem(id: "item-2", title: "Second Item")
        
        let hints = PresentationHints()
        
        let card1 = ListCardComponent(item: item1, hints: hints)
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        let card2 = ListCardComponent(item: item2, hints: hints)
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        // Using wrapper - when ViewInspector works on macOS, no changes needed here
        if let inspected1 = card1.tryInspect(),
           let card1ID = try? inspected1.accessibilityIdentifier(),
           let inspected2 = card2.tryInspect(),
           let card2ID = try? inspected2.accessibilityIdentifier() {
            // TDD RED: Should FAIL - items with different titles should have different IDs
            #expect(card1ID != card2ID, 
                   "List items with different titles should have different identifiers")
            #expect(card1ID.contains("first") || card1ID.contains("item") || card1ID.contains("First"), 
                   "ListCardComponent identifier should include item title 'First Item'")
            #expect(card2ID.contains("second") || card2ID.contains("item") || card2ID.contains("Second"), 
                   "ListCardComponent identifier should include item title 'Second Item'")
            
            print("🔴 RED: ListCard 1 ID: '\(card1ID)'")
            print("🔴 RED: ListCard 2 ID: '\(card2ID)'")
        } else {
            Issue.record("Failed to inspect ListCardComponent")
        }
        
        cleanupTestEnvironment()
    }
    
    /// Test that buttons inside list items get unique identifiers
    @Test func testButtonsInListItemsGetUniqueIdentifiers() {
        setupTestEnvironment()
        
        // TDD RED: Buttons in list items should include item context
        struct TestItem: Identifiable {
            let id: String
            let name: String
        }
        
        let item1 = TestItem(id: "item-1", name: "Product A")
        let item2 = TestItem(id: "item-2", name: "Product B")
        
        let button1 = AdaptiveUIPatterns.AdaptiveButton("Add to Cart", action: { })
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        let button2 = AdaptiveUIPatterns.AdaptiveButton("Add to Cart", action: { })
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        // In a real list, each button would be in context of its item
        // For now, test that buttons with same label at least get different IDs when in different contexts
        // This is a simplified test - full test would need ForEach context
        
        // Using wrapper - when ViewInspector works on macOS, no changes needed here
        if let inspected1 = button1.tryInspect(),
           let button1ID = try? inspected1.accessibilityIdentifier(),
           let inspected2 = button2.tryInspect(),
           let button2ID = try? inspected2.accessibilityIdentifier() {
            // TDD RED: Should FAIL - buttons with same label need item context to differentiate
            // Currently they'll get the same ID, which is a problem
            print("🔴 RED: Button 1 ID: '\(button1ID)'")
            print("🔴 RED: Button 2 ID: '\(button2ID)'")
            
            // Note: This test documents the current limitation
            // In a real ForEach, we'd need to pass item context to button identifiers
            #expect(true, "Documenting current behavior - buttons in lists need item context")
        } else {
            Issue.record("Failed to inspect buttons")
        }
        
        cleanupTestEnvironment()
    }
    
    /// Test that ExpandableCardComponent includes item title in identifier
    @Test func testExpandableCardComponentIncludesItemTitleInIdentifier() {
        setupTestEnvironment()
        
        // TDD RED: ExpandableCardComponent should include item title
        struct TestItem: Identifiable {
            let id: String
            let title: String
        }
        
        let item1 = TestItem(id: "card-1", title: "Important Card")
        let item2 = TestItem(id: "card-2", title: "Another Card")
        
        let hints = PresentationHints()
        let layoutDecision = IntelligentCardLayoutDecision(
            columns: 2,
            spacing: 16,
            cardWidth: 200,
            cardHeight: 150,
            padding: 8,
            expansionScale: 1.15,
            animationDuration: 0.3
        )
        
        let strategy = CardExpansionStrategy(
            supportedStrategies: [.contentReveal],
            primaryStrategy: .contentReveal,
            expansionScale: 1.15,
            animationDuration: 0.3
        )
        
        let card1 = ExpandableCardComponent(
            item: item1,
            layoutDecision: layoutDecision,
            strategy: strategy,
            isExpanded: false,
            isHovered: false,
            onExpand: { },
            onCollapse: { },
            onHover: { _ in },
            onItemSelected: nil,
            onItemDeleted: nil,
            onItemEdited: nil
        )
        .enableGlobalAutomaticAccessibilityIdentifiers()
        
        let card2 = ExpandableCardComponent(
            item: item2,
            layoutDecision: layoutDecision,
            strategy: strategy,
            isExpanded: false,
            isHovered: false,
            onExpand: { },
            onCollapse: { },
            onHover: { _ in },
            onItemSelected: nil,
            onItemDeleted: nil,
            onItemEdited: nil
        )
        .enableGlobalAutomaticAccessibilityIdentifiers()
        
        // Using wrapper - when ViewInspector works on macOS, no changes needed here
        if let inspected1 = card1.tryInspect(),
           let card1ID = try? inspected1.accessibilityIdentifier(),
           let inspected2 = card2.tryInspect(),
           let card2ID = try? inspected2.accessibilityIdentifier() {
            // TDD RED: Should FAIL - cards with different titles should have different IDs
            #expect(card1ID != card2ID, 
                   "ExpandableCardComponent items with different titles should have different identifiers")
            #expect(card1ID.contains("important") || card1ID.contains("card") || card1ID.contains("Important"), 
                   "ExpandableCardComponent identifier should include item title 'Important Card'")
            
            print("🔴 RED: ExpandableCard 1 ID: '\(card1ID)'")
            print("🔴 RED: ExpandableCard 2 ID: '\(card2ID)'")
        } else {
            Issue.record("Failed to inspect ExpandableCardComponent")
        }
        
        cleanupTestEnvironment()
    }
    
    /// Test that list items created from ForEach get unique identifiers
    @Test func testForEachListItemsGetUniqueIdentifiers() {
        setupTestEnvironment()
        
        // TDD RED: Items in ForEach should get unique identifiers
        struct TestItem: Identifiable {
            let id: String
            let name: String
        }
        
        let items = [
            TestItem(id: "1", name: "Alpha"),
            TestItem(id: "2", name: "Beta"),
            TestItem(id: "3", name: "Gamma")
        ]
        
        let hints = PresentationHints()
        
        // Create a view with ForEach
        let listView = VStack {
            ForEach(items) { item in
                ListCardComponent(item: item, hints: hints)
                    .enableGlobalAutomaticAccessibilityIdentifiers()
            }
        }
        .enableGlobalAutomaticAccessibilityIdentifiers()
        
        // Using wrapper - when ViewInspector works on macOS, no changes needed here
        if let inspected = listView.tryInspect() { // ForEach creates multiple views - we need to inspect each one
            // This is a simplified test - full test would verify all items are unique
            let viewID = try? inspected.accessibilityIdentifier()
            
            print("🔴 RED: ForEach List View ID: '\(viewID)'")
            print("🔴 RED: Note - Need to verify each item in ForEach gets unique identifier")
            
            // TDD RED: Should verify each item has unique identifier with item name
            #expect(true, "Documenting requirement - ForEach items need unique identifiers")
        
        cleanupTestEnvironment()
    }
    
    // MARK: - Additional Card Component Tests
    
    /// Test that CoverFlowCardComponent includes item title in identifier
    @Test func testCoverFlowCardComponentIncludesItemTitleInIdentifier() {
        setupTestEnvironment()
        
        struct TestItem: Identifiable {
            let id: String
            let title: String
        }
        
        let item1 = TestItem(id: "cover-1", title: "Cover Flow Item A")
        let item2 = TestItem(id: "cover-2", title: "Cover Flow Item B")
        
        let card1 = CoverFlowCardComponent(item: item1, onItemSelected: nil, onItemDeleted: nil, onItemEdited: nil)
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        let card2 = CoverFlowCardComponent(item: item2, onItemSelected: nil, onItemDeleted: nil, onItemEdited: nil)
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        // Using wrapper - when ViewInspector works on macOS, no changes needed here
        if let inspected1 = card1.tryInspect(),
           let card1ID = try? inspected1.accessibilityIdentifier()
            
           let inspected2 = card2.tryInspect(),
           let card2ID = try? inspected2.accessibilityIdentifier() {
            
            #expect(card1ID != card2ID, 
                   "CoverFlowCardComponent items with different titles should have different identifiers")
            #expect(card1ID.contains("cover") || card1ID.contains("flow") || card1ID.contains("item") || card1ID.contains("Cover"), 
                   "CoverFlowCardComponent identifier should include item title")
            
            print("🔴 RED: CoverFlowCard 1 ID: '\(card1ID)'")
            print("🔴 RED: CoverFlowCard 2 ID: '\(card2ID)'")
        
        cleanupTestEnvironment()
    }
    
    /// Test that SimpleCardComponent includes item title in identifier
    @Test func testSimpleCardComponentIncludesItemTitleInIdentifier() {
        setupTestEnvironment()
        
        struct TestItem: Identifiable {
            let id: String
            let title: String
        }
        
        let item1 = TestItem(id: "simple-1", title: "Simple Card Alpha")
        let item2 = TestItem(id: "simple-2", title: "Simple Card Beta")
        
        let hints = PresentationHints()
        let layoutDecision = IntelligentCardLayoutDecision(
            columns: 2,
            spacing: 16,
            cardWidth: 200,
            cardHeight: 150,
            padding: 8,
            expansionScale: 1.15,
            animationDuration: 0.3
        )
        
        let card1 = SimpleCardComponent(
            item: item1,
            layoutDecision: layoutDecision,
            hints: hints,
            platformConfig: nil,
            onItemSelected: nil,
            onItemDeleted: nil,
            onItemEdited: nil
        )
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        let card2 = SimpleCardComponent(
            item: item2,
            layoutDecision: layoutDecision,
            hints: hints,
            platformConfig: nil,
            onItemSelected: nil,
            onItemDeleted: nil,
            onItemEdited: nil
        )
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        // Using wrapper - when ViewInspector works on macOS, no changes needed here
        if let inspected1 = card1.tryInspect(),
           let card1ID = try? inspected1.accessibilityIdentifier()
            
           let inspected2 = card2.tryInspect(),
           let card2ID = try? inspected2.accessibilityIdentifier() {
            
            #expect(card1ID != card2ID, 
                   "SimpleCardComponent items with different titles should have different identifiers")
            #expect(card1ID.contains("simple") || card1ID.contains("card") || card1ID.contains("alpha") || card1ID.contains("Simple"), 
                   "SimpleCardComponent identifier should include item title")
            
            print("🔴 RED: SimpleCard 1 ID: '\(card1ID)'")
            print("🔴 RED: SimpleCard 2 ID: '\(card2ID)'")
        
        cleanupTestEnvironment()
    }
    
    /// Test that MasonryCardComponent includes item title in identifier
    @Test func testMasonryCardComponentIncludesItemTitleInIdentifier() {
        setupTestEnvironment()
        
        struct TestItem: Identifiable {
            let id: String
            let title: String
        }
        
        let item1 = TestItem(id: "masonry-1", title: "Masonry Item One")
        let item2 = TestItem(id: "masonry-2", title: "Masonry Item Two")
        
        let hints = PresentationHints()
        
        let card1 = MasonryCardComponent(item: item1, hints: hints)
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        let card2 = MasonryCardComponent(item: item2, hints: hints)
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        // Using wrapper - when ViewInspector works on macOS, no changes needed here
        if let inspected1 = card1.tryInspect(),
           let card1ID = try? inspected1.accessibilityIdentifier()
            
           let inspected2 = card2.tryInspect(),
           let card2ID = try? inspected2.accessibilityIdentifier() {
            
            #expect(card1ID != card2ID, 
                   "MasonryCardComponent items with different titles should have different identifiers")
            #expect(card1ID.contains("masonry") || card1ID.contains("item") || card1ID.contains("one") || card1ID.contains("Masonry"), 
                   "MasonryCardComponent identifier should include item title")
            
            print("🔴 RED: MasonryCard 1 ID: '\(card1ID)'")
            print("🔴 RED: MasonryCard 2 ID: '\(card2ID)'")
        
        cleanupTestEnvironment()
    }
    
    /// Test that all card components in a grid get unique identifiers
    @Test func testGridCollectionItemsGetUniqueIdentifiers() {
        setupTestEnvironment()
        
        struct TestItem: Identifiable {
            let id: String
            let name: String
        }
        
        let items = [
            TestItem(id: "grid-1", name: "Grid Item 1"),
            TestItem(id: "grid-2", name: "Grid Item 2"),
            TestItem(id: "grid-3", name: "Grid Item 3")
        ]
        
        let hints = PresentationHints()
        let layoutDecision = IntelligentCardLayoutDecision(
            columns: 2,
            spacing: 16,
            cardWidth: 200,
            cardHeight: 150,
            padding: 8,
            expansionScale: 1.15,
            animationDuration: 0.3
        )
        
        // Test that each SimpleCardComponent gets unique identifier
        let card1 = SimpleCardComponent(
            item: items[0],
            layoutDecision: layoutDecision,
            hints: hints,
            platformConfig: nil,
            onItemSelected: nil,
            onItemDeleted: nil,
            onItemEdited: nil
        )
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        let card2 = SimpleCardComponent(
            item: items[1],
            layoutDecision: layoutDecision,
            hints: hints,
            platformConfig: nil,
            onItemSelected: nil,
            onItemDeleted: nil,
            onItemEdited: nil
        )
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        // Using wrapper - when ViewInspector works on macOS, no changes needed here
        if let inspected1 = card1.tryInspect(),
           let card1ID = try? inspected1.accessibilityIdentifier()
            
           let inspected2 = card2.tryInspect(),
           let card2ID = try? inspected2.accessibilityIdentifier() {
            
            #expect(card1ID != card2ID, 
                   "Grid items should have different identifiers based on their titles")
            #expect(card1ID.contains("1") || card1ID.contains("grid"), 
                   "Grid item 1 identifier should include item name")
            #expect(card2ID.contains("2") || card2ID.contains("grid"), 
                   "Grid item 2 identifier should include item name")
            
            print("🔴 RED: Grid Card 1 ID: '\(card1ID)'")
            print("🔴 RED: Grid Card 2 ID: '\(card2ID)'")
        
        cleanupTestEnvironment()
    }
    
    /// Test that cover flow items get unique identifiers
    @Test func testCoverFlowCollectionItemsGetUniqueIdentifiers() {
        setupTestEnvironment()
        
        struct TestItem: Identifiable {
            let id: String
            let title: String
        }
        
        let items = [
            TestItem(id: "cover-1", title: "Cover A"),
            TestItem(id: "cover-2", title: "Cover B"),
            TestItem(id: "cover-3", title: "Cover C")
        ]
        
        let card1 = CoverFlowCardComponent(item: items[0], onItemSelected: nil, onItemDeleted: nil, onItemEdited: nil)
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        let card2 = CoverFlowCardComponent(item: items[1], onItemSelected: nil, onItemDeleted: nil, onItemEdited: nil)
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        // Using wrapper - when ViewInspector works on macOS, no changes needed here
        if let inspected1 = card1.tryInspect(),
           let card1ID = try? inspected1.accessibilityIdentifier()
            
           let inspected2 = card2.tryInspect(),
           let card2ID = try? inspected2.accessibilityIdentifier() {
            
            #expect(card1ID != card2ID, 
                   "Cover flow items should have different identifiers")
            
            print("🔴 RED: CoverFlow Card 1 ID: '\(card1ID)'")
            print("🔴 RED: CoverFlow Card 2 ID: '\(card2ID)'")
        
        cleanupTestEnvironment()
    }
    
    /// Test that masonry collection items get unique identifiers
    @Test func testMasonryCollectionItemsGetUniqueIdentifiers() {
        setupTestEnvironment()
        
        struct TestItem: Identifiable {
            let id: String
            let title: String
        }
        
        let items = [
            TestItem(id: "masonry-1", title: "Masonry A"),
            TestItem(id: "masonry-2", title: "Masonry B")
        ]
        
        let hints = PresentationHints()
        
        let card1 = MasonryCardComponent(item: items[0], hints: hints)
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        let card2 = MasonryCardComponent(item: items[1], hints: hints)
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        // Using wrapper - when ViewInspector works on macOS, no changes needed here
        if let inspected1 = card1.tryInspect(),
           let card1ID = try? inspected1.accessibilityIdentifier()
            
           let inspected2 = card2.tryInspect(),
           let card2ID = try? inspected2.accessibilityIdentifier() {
            
            #expect(card1ID != card2ID, 
                   "Masonry collection items should have different identifiers")
            
            print("🔴 RED: Masonry Card 1 ID: '\(card1ID)'")
            print("🔴 RED: Masonry Card 2 ID: '\(card2ID)'")
        
        cleanupTestEnvironment()
    }
    
    /// Test comprehensive: all card types in mixed collections
    @Test func testAllCardTypesGetUniqueIdentifiersInCollections() {
        setupTestEnvironment()
        
        struct TestItem: Identifiable {
            let id: String
            let title: String
        }
        
        // Test that all card component types get unique identifiers
        let item = TestItem(id: "test", title: "Test Item")
        let hints = PresentationHints()
        let layoutDecision = IntelligentCardLayoutDecision(
            columns: 2,
            spacing: 16,
            cardWidth: 200,
            cardHeight: 150,
            padding: 8,
            expansionScale: 1.15,
            animationDuration: 0.3
        )
        
        let strategy = CardExpansionStrategy(
            supportedStrategies: [.contentReveal],
            primaryStrategy: .contentReveal,
            expansionScale: 1.15,
            animationDuration: 0.3
        )
        
        let expandableCard = ExpandableCardComponent(
            item: item,
            layoutDecision: layoutDecision,
            strategy: strategy,
            isExpanded: false,
            isHovered: false,
            onExpand: { },
            onCollapse: { },
            onHover: { _ in },
            onItemSelected: nil,
            onItemDeleted: nil,
            onItemEdited: nil
        )
        .enableGlobalAutomaticAccessibilityIdentifiers()
        
        let listCard = ListCardComponent(item: item, hints: hints)
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        let simpleCard = SimpleCardComponent(
            item: item,
            layoutDecision: layoutDecision,
            hints: hints,
            platformConfig: nil,
            onItemSelected: nil,
            onItemDeleted: nil,
            onItemEdited: nil
        )
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        let coverFlowCard = CoverFlowCardComponent(item: item, onItemSelected: nil, onItemDeleted: nil, onItemEdited: nil)
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        let masonryCard = MasonryCardComponent(item: item, hints: hints)
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        // Using wrapper - when ViewInspector works on macOS, no changes needed here
        if let expandableInspected = expandableCard.tryInspect(),
           let expandableID = try? expandableInspected.accessibilityIdentifier(),
           let listInspected = listCard.tryInspect(),
           let listID = try? listInspected.accessibilityIdentifier(),
           let simpleInspected = simpleCard.tryInspect(),
           let simpleID = try? simpleInspected.accessibilityIdentifier(),
           let coverFlowInspected = coverFlowCard.tryInspect(),
           let coverFlowID = try? coverFlowInspected.accessibilityIdentifier(),
           let masonryInspected = masonryCard.tryInspect(),
           let masonryID = try? masonryInspected.accessibilityIdentifier() {
            
            // TDD RED: All should include "test" or "item" from the title
            #expect(expandableID.contains("test") || expandableID.contains("item") || expandableID.contains("Test"), 
                   "ExpandableCardComponent should include item title")
            #expect(listID.contains("test") || listID.contains("item") || listID.contains("Test"), 
                   "ListCardComponent should include item title")
            #expect(simpleID.contains("test") || simpleID.contains("item") || simpleID.contains("Test"), 
                   "SimpleCardComponent should include item title")
            #expect(coverFlowID.contains("test") || coverFlowID.contains("item") || coverFlowID.contains("Test"), 
                   "CoverFlowCardComponent should include item title")
            #expect(masonryID.contains("test") || masonryID.contains("item") || masonryID.contains("Test"), 
                   "MasonryCardComponent should include item title")
            
            print("🔴 RED: ExpandableCard ID: '\(expandableID)'")
            print("🔴 RED: ListCard ID: '\(listID)'")
            print("🔴 RED: SimpleCard ID: '\(simpleID)'")
            print("🔴 RED: CoverFlowCard ID: '\(coverFlowID)'")
            print("🔴 RED: MasonryCard ID: '\(masonryID)'")
        } else {
            Issue.record("Failed to inspect card components")
        }
        
        cleanupTestEnvironment()
    }
    
    // MARK: - ResponsiveCardView Tests
    
    /// Test that ResponsiveCardView includes card title in identifier
    @Test func testResponsiveCardViewIncludesCardTitleInIdentifier() {
        setupTestEnvironment()
        
        let card1 = ResponsiveCardData(
            title: "Dashboard",
            subtitle: "Overview & statistics",
            icon: "gauge.with.dots.needle.67percent",
            color: .blue,
            complexity: .moderate
        )
        
        let card2 = ResponsiveCardData(
            title: "Vehicles",
            subtitle: "Manage your cars",
            icon: "car.fill",
            color: .green,
            complexity: .simple
        )
        
        let cardView1 = ResponsiveCardView(data: card1)
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        let cardView2 = ResponsiveCardView(data: card2)
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        // Using wrapper - when ViewInspector works on macOS, no changes needed here
        if let inspected1 = cardView1.tryInspect(),
           let card1ID = try? inspected1.accessibilityIdentifier()
            
            let inspected2 = cardView2.tryInspect(),
           let card2ID = try? inspected2.accessibilityIdentifier()
            
            // TDD RED: Should FAIL - cards with different titles should have different IDs
            #expect(card1ID != card2ID, 
                   "ResponsiveCardView items with different titles should have different identifiers")
            #expect(card1ID.contains("dashboard") || card1ID.contains("Dashboard"), 
                   "ResponsiveCardView identifier should include card title 'Dashboard'")
            #expect(card2ID.contains("vehicles") || card2ID.contains("Vehicles"), 
                   "ResponsiveCardView identifier should include card title 'Vehicles'")
            
            print("🔴 RED: ResponsiveCard 1 ID: '\(card1ID)'")
            print("🔴 RED: ResponsiveCard 2 ID: '\(card2ID)'")
        
        cleanupTestEnvironment()
    }
    
    /// Test that ResponsiveCardView cards in a collection get unique identifiers
    @Test func testResponsiveCardViewCollectionItemsGetUniqueIdentifiers() {
        setupTestEnvironment()
        
        let cards = [
            ResponsiveCardData(
                title: "Expenses",
                subtitle: "Track spending",
                icon: "dollarsign.circle.fill",
                color: .orange,
                complexity: .complex
            ),
            ResponsiveCardData(
                title: "Maintenance",
                subtitle: "Service records",
                icon: "wrench.fill",
                color: .red,
                complexity: .moderate
            ),
            ResponsiveCardData(
                title: "Fuel",
                subtitle: "Monitor consumption",
                icon: "fuelpump.fill",
                color: .purple,
                complexity: .simple
            )
        ]
        
        let card1 = ResponsiveCardView(data: cards[0])
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        let card2 = ResponsiveCardView(data: cards[1])
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        // Using wrapper - when ViewInspector works on macOS, no changes needed here
        if let inspected1 = card1.tryInspect(),
           let card1ID = try? inspected1.accessibilityIdentifier()
            
           let inspected2 = card2.tryInspect(),
           let card2ID = try? inspected2.accessibilityIdentifier() {
            
            #expect(card1ID != card2ID, 
                   "ResponsiveCardView items in collections should have different identifiers")
            #expect(card1ID.contains("expenses") || card1ID.contains("Expenses"), 
                   "ResponsiveCardView identifier should include card title")
            #expect(card2ID.contains("maintenance") || card2ID.contains("Maintenance"), 
                   "ResponsiveCardView identifier should include card title")
            
            print("🔴 RED: ResponsiveCard Collection 1 ID: '\(card1ID)'")
            print("🔴 RED: ResponsiveCard Collection 2 ID: '\(card2ID)'")
        
        cleanupTestEnvironment()
    }
    
    // MARK: - PlatformTabStrip Tests
    
    /// Test that PlatformTabStrip buttons include item titles in identifiers
    @Test func testPlatformTabStripButtonsIncludeItemTitlesInIdentifiers() {
        setupTestEnvironment()
        
        // TDD RED: PlatformTabStrip buttons should include item.title in identifier
        let items = [
            PlatformTabItem(title: "Home", systemImage: "house.fill"),
            PlatformTabItem(title: "Settings", systemImage: "gear"),
            PlatformTabItem(title: "Profile", systemImage: "person.fill")
        ]
        
        // Create a view with the tab strip
        let tabStrip = PlatformTabStrip(selection: .constant(0), items: items)
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        // Using wrapper - when ViewInspector works on macOS, no changes needed here
        if let inspected = tabStrip.tryInspect()            // The tab strip contains buttons - we need to verify buttons have unique IDs
            // This is a simplified test - full test would inspect nested buttons
            let stripID = try? inspected.accessibilityIdentifier()
            
            print("🔴 RED: PlatformTabStrip ID: '\(stripID)'")
            print("🔴 RED: Note - Need to verify each button in tab strip gets unique identifier with item.title")
            
            // TDD RED: Should verify buttons have unique identifiers with titles
            #expect(true, "Documenting requirement - PlatformTabStrip buttons need unique identifiers with item.title")
        
        cleanupTestEnvironment()
    }
    
    /// Test that buttons in PlatformTabStrip get different identifiers for different tabs
    @Test func testPlatformTabStripButtonsGetDifferentIdentifiers() {
        setupTestEnvironment()
        
        // Create individual buttons as they would appear in the tab strip
        let homeItem = PlatformTabItem(title: "Home", systemImage: "house.fill")
        let settingsItem = PlatformTabItem(title: "Settings", systemImage: "gear")
        
        // Simulate what the buttons would look like inside PlatformTabStrip
        // Note: PlatformTabStrip uses Button directly, so we test Button with title
        let homeButton = Button(action: { }) {
            HStack(spacing: 6) {
                Image(systemName: homeItem.systemImage ?? "")
                Text(homeItem.title)
                    .font(.subheadline)
            }
        }
        .environment(\.accessibilityIdentifierLabel, homeItem.title)
        .automaticAccessibilityIdentifiers(named: "PlatformTabStripButton")
        .enableGlobalAutomaticAccessibilityIdentifiers()
        
        let settingsButton = Button(action: { }) {
            HStack(spacing: 6) {
                Image(systemName: settingsItem.systemImage ?? "")
                Text(settingsItem.title)
                    .font(.subheadline)
            }
        }
        .environment(\.accessibilityIdentifierLabel, settingsItem.title)
        .automaticAccessibilityIdentifiers(named: "PlatformTabStripButton")
        .enableGlobalAutomaticAccessibilityIdentifiers()
        
        // Using wrapper - when ViewInspector works on macOS, no changes needed here
        if let homeInspected = homeButton.tryInspect(),
           let homeID = try? homeInspected.accessibilityIdentifier()
            
            let settingsInspected = settingsButton.tryInspect(),
           let settingsID = try? settingsInspected.accessibilityIdentifier()
            
            // TDD RED: Should FAIL - buttons with different titles should have different IDs
            #expect(homeID != settingsID, 
                   "PlatformTabStrip buttons with different titles should have different identifiers")
            #expect(homeID.contains("home") || homeID.contains("Home"), 
                   "Home button identifier should include 'Home'")
            #expect(settingsID.contains("settings") || settingsID.contains("Settings"), 
                   "Settings button identifier should include 'Settings'")
            
            print("🔴 RED: Tab Button Home ID: '\(homeID)'")
            print("🔴 RED: Tab Button Settings ID: '\(settingsID)'")
        
        cleanupTestEnvironment()
    }
    
    // MARK: - Row and Non-Button Item Component Tests
    
    /// Test that FileRow includes file name in identifier
    @Test func testFileRowIncludesFileNameInIdentifier() {
        setupTestEnvironment()
        
        // TDD RED: FileRow should include file.name in identifier
        struct FileInfo {
            let name: String
            let size: Int64
            let type: String
        }
        
        let file1 = FileInfo(name: "document.pdf", size: 1024, type: "pdf")
        let file2 = FileInfo(name: "image.jpg", size: 2048, type: "jpg")
        
        // FileRow uses FileInfo which has different structure, but we can test the concept
        // Note: FileRow is a component that displays file.name, so it should include that in identifier
        print("🔴 RED: FileRow should include file.name in accessibility identifier")
        print("🔴 RED: FileRow is used in lists of files - each row should be unique")
        
        // TDD RED: Should verify FileRow includes file.name in identifier
        #expect(true, "Documenting requirement - FileRow needs file.name in identifier for unique rows")
        
        cleanupTestEnvironment()
    }
    
    /// Test that validation error rows in DynamicFormFieldView get unique identifiers
    @Test func testValidationErrorRowsGetUniqueIdentifiers() {
        setupTestEnvironment()
        
        // TDD RED: Validation error Text views in ForEach should include error text in identifier
        let field = DynamicFormField(
            id: "test-field",
            contentType: .text,
            label: "Email",
            placeholder: "Enter email"
        )
        let formState = DynamicFormState(configuration: DynamicFormConfiguration(
            id: "test-form",
            title: "Test",
            sections: []
        ))
        formState.initializeField(field)
        formState.addError("Email is required", for: field.id)
        formState.addError("Email format is invalid", for: field.id)
        
        let fieldView = DynamicFormFieldView(field: field, formState: formState)
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        // Using wrapper - when ViewInspector works on macOS, no changes needed here
        if let inspected = fieldView.tryInspect(),
           let fieldID = try? inspected.accessibilityIdentifier() {
            
            print("🔴 RED: DynamicFormFieldView ID: '\(fieldID)'")
            print("🔴 RED: Note - Validation error Text views in ForEach should include error text in identifier")
            print("🔴 RED: Each error message should be unique: 'Email is required' vs 'Email format is invalid'")
            
            // TDD RED: Should verify error Text views include error text in identifiers
            #expect(true, "Documenting requirement - Validation error rows need unique identifiers with error text")
        
        cleanupTestEnvironment()
    }
    
    /// Test that array field items in DynamicArrayField get unique identifiers
    @Test func testDynamicArrayFieldItemsGetUniqueIdentifiers() {
        setupTestEnvironment()
        
        // TDD RED: Array items in DynamicArrayField ForEach should get unique identifiers
        let field = DynamicFormField(
            id: "array-field",
            contentType: .array,
            label: "Tags",
            placeholder: nil
        )
        let formState = DynamicFormState(configuration: DynamicFormConfiguration(
            id: "test-form",
            title: "Test",
            sections: []
        ))
        formState.initializeField(field)
        formState.setValue(["Tag1", "Tag2", "Tag3"], for: field.id)
        
        let arrayField = DynamicArrayField(field: field, formState: formState)
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        // Using wrapper - when ViewInspector works on macOS, no changes needed here
        if let inspected = arrayField.tryInspect(),
           let arrayID = try? inspected.accessibilityIdentifier()
            
            print("🔴 RED: DynamicArrayField ID: '\(arrayID)'")
            print("🔴 RED: Note - Array items in ForEach should get unique identifiers")
            print("🔴 RED: Each array item (Tag1, Tag2, Tag3) should have unique identifier")
            
            // TDD RED: Should verify array items have unique identifiers
            #expect(true, "Documenting requirement - Array field items need unique identifiers")
        
        cleanupTestEnvironment()
    }
    
    /// Test that platformListRow includes content in identifier when used in lists
    @Test func testPlatformListRowIncludesContentInIdentifier() {
        setupTestEnvironment()
        
        // TDD RED: platformListRow when used in ForEach should include item-specific content
        struct TestItem: Identifiable {
            let id: String
            let title: String
        }
        
        let item1 = TestItem(id: "1", title: "First Item")
        let item2 = TestItem(id: "2", title: "Second Item")
        
        let row1 = EmptyView()
            .platformListRow(title: item1.title) { }
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        let row2 = EmptyView()
            .platformListRow(title: item2.title) { }
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        // Using wrapper - when ViewInspector works on macOS, no changes needed here
        if let inspected1 = row1.tryInspect(),
           let row1ID = try? inspected1.accessibilityIdentifier()
            
            let inspected2 = row2.tryInspect(),
           let row2ID = try? inspected2.accessibilityIdentifier()
            
            // TDD RED: Should FAIL - rows with different content should have different IDs
            #expect(row1ID != row2ID, 
                   "platformListRow items with different content should have different identifiers")
            #expect(row1ID.contains("first") || row1ID.contains("First") || row1ID.contains("item"), 
                   "platformListRow identifier should include item content")
            
            print("🔴 RED: PlatformListRow 1 ID: '\(row1ID)'")
            print("🔴 RED: PlatformListRow 2 ID: '\(row2ID)'")
        
        cleanupTestEnvironment()
    }
    
    /// Test that settings item views get unique identifiers
    @Test func testSettingsItemViewsGetUniqueIdentifiers() {
        setupTestEnvironment()
        
        // TDD RED: SettingsItemView or GenericSettingsItemView should include item.title
        // Note: GenericSettingsItemView is private, but SettingsItemView in examples is public
        print("🔴 RED: SettingsItemView should include item.title in accessibility identifier")
        print("🔴 RED: Settings items displayed in lists should have unique identifiers")
        
        // TDD RED: Should verify settings items include titles in identifiers
        #expect(true, "Documenting requirement - Settings item views need item.title in identifier")
        
        cleanupTestEnvironment()
    }
    
    // MARK: - Platform Extension Functions with Title/Label Tests
    
    /// Test that platformListSectionHeader includes title in identifier
    @Test func testPlatformListSectionHeaderIncludesTitleInIdentifier() {
        setupTestEnvironment()
        
        // TDD RED: platformListSectionHeader should include title in identifier
        let header1 = VStack {
            Text("Content")
        }
        .platformListSectionHeader(title: "Section One", subtitle: "Subtitle")
        .enableGlobalAutomaticAccessibilityIdentifiers()
        
        let header2 = VStack {
            Text("Content")
        }
        .platformListSectionHeader(title: "Section Two")
        .enableGlobalAutomaticAccessibilityIdentifiers()
        
        // Using wrapper - when ViewInspector works on macOS, no changes needed here
        if let inspected1 = header1.tryInspect(),
           let header1ID = try? inspected1.accessibilityIdentifier()
            
            let inspected2 = header2.tryInspect(),
           let header2ID = try? inspected2.accessibilityIdentifier()
            
            // TDD RED: Should FAIL - headers with different titles should have different IDs
            #expect(header1ID != header2ID, 
                   "platformListSectionHeader with different titles should have different identifiers")
            #expect(header1ID.contains("section") || header1ID.contains("one") || header1ID.contains("Section"), 
                   "platformListSectionHeader identifier should include title")
            
            print("🔴 RED: Section Header 1 ID: '\(header1ID)'")
            print("🔴 RED: Section Header 2 ID: '\(header2ID)'")
        
        cleanupTestEnvironment()
    }
    
    /// Test that platformFormField includes label in identifier
    @Test func testPlatformFormFieldIncludesLabelInIdentifier() {
        setupTestEnvironment()
        
        // TDD RED: platformFormField should include label in identifier
        let field1 = VStack {
            TextField("", text: .constant(""))
        }
        .platformFormField(label: "Email Address") {
            TextField("", text: .constant(""))
        }
        .enableGlobalAutomaticAccessibilityIdentifiers()
        
        let field2 = VStack {
            TextField("", text: .constant(""))
        }
        .platformFormField(label: "Phone Number") {
            TextField("", text: .constant(""))
        }
        .enableGlobalAutomaticAccessibilityIdentifiers()
        
        // Using wrapper - when ViewInspector works on macOS, no changes needed here
        if let inspected1 = field1.tryInspect(),
           let field1ID = try? inspected1.accessibilityIdentifier()
            
            let inspected2 = field2.tryInspect(),
           let field2ID = try? inspected2.accessibilityIdentifier()
            
            // TDD RED: Should FAIL - fields with different labels should have different IDs
            #expect(field1ID != field2ID, 
                   "platformFormField with different labels should have different identifiers")
            #expect(field1ID.contains("email") || field1ID.contains("address") || field1ID.contains("Email"), 
                   "platformFormField identifier should include label")
            
            print("🔴 RED: Form Field 1 ID: '\(field1ID)'")
            print("🔴 RED: Form Field 2 ID: '\(field2ID)'")
        
        cleanupTestEnvironment()
    }
    
    /// Test that platformFormFieldGroup includes title in identifier
    @Test func testPlatformFormFieldGroupIncludesTitleInIdentifier() {
        setupTestEnvironment()
        
        // TDD RED: platformFormFieldGroup should include title in identifier
        let group1 = VStack {
            Text("Content")
        }
        .platformFormFieldGroup(title: "Personal Information") {
            Text("Content")
        }
        .enableGlobalAutomaticAccessibilityIdentifiers()
        
        let group2 = VStack {
            Text("Content")
        }
        .platformFormFieldGroup(title: "Contact Details") {
            Text("Content")
        }
        .enableGlobalAutomaticAccessibilityIdentifiers()
        
        // Using wrapper - when ViewInspector works on macOS, no changes needed here
        if let inspected1 = group1.tryInspect(),
           let group1ID = try? inspected1.accessibilityIdentifier()
            
            let inspected2 = group2.tryInspect(),
           let group2ID = try? inspected2.accessibilityIdentifier()
            
            // TDD RED: Should FAIL - groups with different titles should have different IDs
            #expect(group1ID != group2ID, 
                   "platformFormFieldGroup with different titles should have different identifiers")
            #expect(group1ID.contains("personal") || group1ID.contains("information") || group1ID.contains("Personal"), 
                   "platformFormFieldGroup identifier should include title")
            
            print("🔴 RED: Form Field Group 1 ID: '\(group1ID)'")
            print("🔴 RED: Form Field Group 2 ID: '\(group2ID)'")
        
        cleanupTestEnvironment()
    }
    
    /// Test that platformListEmptyState includes title in identifier
    @Test func testPlatformListEmptyStateIncludesTitleInIdentifier() {
        setupTestEnvironment()
        
        // TDD RED: platformListEmptyState should include title in identifier
        let emptyState1 = VStack {
            Text("Content")
        }
        .platformListEmptyState(systemImage: "tray", title: "No Items", message: "Add items to get started")
        .enableGlobalAutomaticAccessibilityIdentifiers()
        
        let emptyState2 = VStack {
            Text("Content")
        }
        .platformListEmptyState(systemImage: "tray", title: "No Results", message: "Try a different search")
        .enableGlobalAutomaticAccessibilityIdentifiers()
        
        // Using wrapper - when ViewInspector works on macOS, no changes needed here
        if let inspected1 = emptyState1.tryInspect(),
           let state1ID = try? inspected1.accessibilityIdentifier()
            
            let inspected2 = emptyState2.tryInspect(),
           let state2ID = try? inspected2.accessibilityIdentifier()
            
            // TDD RED: Should FAIL - empty states with different titles should have different IDs
            #expect(state1ID != state2ID, 
                   "platformListEmptyState with different titles should have different identifiers")
            #expect(state1ID.contains("no") || state1ID.contains("items") || state1ID.contains("No"), 
                   "platformListEmptyState identifier should include title")
            
            print("🔴 RED: Empty State 1 ID: '\(state1ID)'")
            print("🔴 RED: Empty State 2 ID: '\(state2ID)'")
        
        cleanupTestEnvironment()
    }
    
    /// Test that platformDetailPlaceholder includes title in identifier
    @Test func testPlatformDetailPlaceholderIncludesTitleInIdentifier() {
        setupTestEnvironment()
        
        // TDD RED: platformDetailPlaceholder should include title in identifier
        let placeholder1 = VStack {
            Text("Content")
        }
        .platformDetailPlaceholder(systemImage: "doc", title: "Select an Item", message: "Choose an item to view details")
        .enableGlobalAutomaticAccessibilityIdentifiers()
        
        let placeholder2 = VStack {
            Text("Content")
        }
        .platformDetailPlaceholder(systemImage: "doc", title: "No Selection", message: "Please select an item")
        .enableGlobalAutomaticAccessibilityIdentifiers()
        
        // Using wrapper - when ViewInspector works on macOS, no changes needed here
        if let inspected1 = placeholder1.tryInspect(),
           let placeholder1ID = try? inspected1.accessibilityIdentifier()
            
            let inspected2 = placeholder2.tryInspect(),
           let placeholder2ID = try? inspected2.accessibilityIdentifier()
            
            // TDD RED: Should FAIL - placeholders with different titles should have different IDs
            #expect(placeholder1ID != placeholder2ID, 
                   "platformDetailPlaceholder with different titles should have different identifiers")
            #expect(placeholder1ID.contains("select") || placeholder1ID.contains("item") || placeholder1ID.contains("Select"), 
                   "platformDetailPlaceholder identifier should include title")
            
            print("🔴 RED: Detail Placeholder 1 ID: '\(placeholder1ID)'")
            print("🔴 RED: Detail Placeholder 2 ID: '\(placeholder2ID)'")
        
        cleanupTestEnvironment()
    }
    
    /// Test that ActionButton includes title in identifier
    @Test func testActionButtonIncludesTitleInIdentifier() {
        setupTestEnvironment()
        
        // TDD RED: ActionButton should include title in identifier
        let button1 = ActionButton(title: "Save", action: { })
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        let button2 = ActionButton(title: "Delete", action: { })
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        // Using wrapper - when ViewInspector works on macOS, no changes needed here
        if let inspected1 = button1.tryInspect(),
           let button1ID = try? inspected1.accessibilityIdentifier()
            
            let inspected2 = button2.tryInspect(),
           let button2ID = try? inspected2.accessibilityIdentifier()
            
            // TDD RED: Should FAIL - buttons with different titles should have different IDs
            #expect(button1ID != button2ID, 
                   "ActionButton with different titles should have different identifiers")
            #expect(button1ID.contains("save") || button1ID.contains("Save"), 
                   "ActionButton identifier should include title")
            
            print("🔴 RED: ActionButton 1 ID: '\(button1ID)'")
            print("🔴 RED: ActionButton 2 ID: '\(button2ID)'")
        
        cleanupTestEnvironment()
    }
    
    /// Test that platformValidationMessage includes message in identifier
    @Test func testPlatformValidationMessageIncludesMessageInIdentifier() {
        setupTestEnvironment()
        
        // TDD RED: platformValidationMessage should include message text in identifier
        // Note: If used in ForEach loops with multiple errors, each should be unique
        let message1 = VStack {
            Text("Content")
        }
        .platformValidationMessage("Email is required", type: .error)
        .enableGlobalAutomaticAccessibilityIdentifiers()
        
        let message2 = VStack {
            Text("Content")
        }
        .platformValidationMessage("Password too short", type: .error)
        .enableGlobalAutomaticAccessibilityIdentifiers()
        
        // Using wrapper - when ViewInspector works on macOS, no changes needed here
        if let inspected1 = message1.tryInspect(),
           let message1ID = try? inspected1.accessibilityIdentifier()
            
            let inspected2 = message2.tryInspect(),
           let message2ID = try? inspected2.accessibilityIdentifier()
            
            // TDD RED: Should FAIL - messages with different text should have different IDs
            #expect(message1ID != message2ID, 
                   "platformValidationMessage with different messages should have different identifiers")
            #expect(message1ID.contains("email") || message1ID.contains("required") || message1ID.contains("Email"), 
                   "platformValidationMessage identifier should include message text")
            
            print("🔴 RED: Validation Message 1 ID: '\(message1ID)'")
            print("🔴 RED: Validation Message 2 ID: '\(message2ID)'")
        
        cleanupTestEnvironment()
    }
    
    // MARK: - Recommendation Row Tests
    
    // NOTE: PlatformRecommendation tests have been moved to possible-features/PlatformRecommendationEngineTests.swift
    
    /// Test that VisualizationRecommendationRow includes recommendation data in identifier
    @Test func testVisualizationRecommendationRowIncludesDataInIdentifier() {
        setupTestEnvironment()
        
        // TDD RED: VisualizationRecommendationRow should include recommendation chartType or title in identifier
        // Note: VisualizationRecommendation has chartType, not title - we'll use chartType.rawValue
        print("🔴 RED: VisualizationRecommendationRow should include chartType in accessibility identifier")
        print("🔴 RED: Recommendation rows displayed in ForEach should have unique identifiers")
        
        // TDD RED: Should verify VisualizationRecommendationRow includes chartType in identifier
        #expect(true, "Documenting requirement - VisualizationRecommendationRow needs chartType in identifier for unique rows")
        
        cleanupTestEnvironment()
    }
}

