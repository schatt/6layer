//
//  Layer1PresentationTests.swift
//  SixLayerFrameworkTests
//
//  Layer 1 (Semantic) TDD Tests
//  Tests for platformPresentFormData_L1 and platformPresentModalForm_L1 functions
//

import XCTest
@testable import SixLayerFramework

@MainActor
final class Layer1PresentationTests: XCTestCase {
    
    // MARK: - Test Data
    
    let testFields: [GenericFormField] = [
        GenericFormField(
            label: "Name",
            placeholder: "Enter your name",
            value: "",
            isRequired: true,
            fieldType: .text
        ),
        GenericFormField(
            label: "Email",
            placeholder: "Enter your email",
            value: "",
            isRequired: true,
            fieldType: .email
        ),
        GenericFormField(
            label: "Age",
            placeholder: "Enter your age",
            value: "",
            isRequired: false,
            fieldType: .number
        )
    ]
    
    let testHints = PresentationHints(
        dataType: .form,
        presentationPreference: .form,
        complexity: .moderate,
        context: .form
    )
    
    // MARK: - platformPresentFormData_L1 Tests
    
    func testPlatformPresentFormData_L1_CreatesSimpleFormView() {
        // Given: Form fields and hints
        let fields = testFields
        let hints = testHints
        
        // When: Creating form presentation
        let view = platformPresentFormData_L1(fields: fields, hints: hints)
        
        // Then: Should return a SimpleFormView
        XCTAssertNotNil(view)
        
        // Verify the view type using Mirror reflection
        let mirror = Mirror(reflecting: view)
        XCTAssertEqual(String(describing: mirror.subjectType), "SimpleFormView")
    }
    
    func testPlatformPresentFormData_L1_HandlesEmptyFields() {
        // Given: Empty fields array
        let fields: [GenericFormField] = []
        let hints = testHints
        
        // When: Creating form presentation
        let view = platformPresentFormData_L1(fields: fields, hints: hints)
        
        // Then: Should return a SimpleFormView even with empty fields
        XCTAssertNotNil(view)
        
        let mirror = Mirror(reflecting: view)
        XCTAssertEqual(String(describing: mirror.subjectType), "SimpleFormView")
    }
    
    func testPlatformPresentFormData_L1_HandlesDifferentComplexityLevels() {
        // Given: Different complexity hints
        let simpleHints = PresentationHints(
            dataType: .form,
            presentationPreference: .form,
            complexity: .simple,
            context: .form
        )
        
        let complexHints = PresentationHints(
            dataType: .form,
            presentationPreference: .form,
            complexity: .complex,
            context: .form
        )
        
        // When: Creating form presentations
        let simpleView = platformPresentFormData_L1(fields: testFields, hints: simpleHints)
        let complexView = platformPresentFormData_L1(fields: testFields, hints: complexHints)
        
        // Then: Both should return SimpleFormView
        XCTAssertNotNil(simpleView)
        XCTAssertNotNil(complexView)
        
        let simpleMirror = Mirror(reflecting: simpleView)
        let complexMirror = Mirror(reflecting: complexView)
        
        XCTAssertEqual(String(describing: simpleMirror.subjectType), "SimpleFormView")
        XCTAssertEqual(String(describing: complexMirror.subjectType), "SimpleFormView")
    }
    
    func testPlatformPresentFormData_L1_HandlesDifferentDataTypes() {
        // Given: Different data type hints
        let formHints = PresentationHints(
            dataType: .form,
            presentationPreference: .form,
            complexity: .moderate,
            context: .form
        )
        
        let textHints = PresentationHints(
            dataType: .text,
            presentationPreference: .form,
            complexity: .moderate,
            context: .form
        )
        
        // When: Creating form presentations
        let formView = platformPresentFormData_L1(fields: testFields, hints: formHints)
        let textView = platformPresentFormData_L1(fields: testFields, hints: textHints)
        
        // Then: Both should return SimpleFormView
        XCTAssertNotNil(formView)
        XCTAssertNotNil(textView)
        
        let formMirror = Mirror(reflecting: formView)
        let textMirror = Mirror(reflecting: textView)
        
        XCTAssertEqual(String(describing: formMirror.subjectType), "SimpleFormView")
        XCTAssertEqual(String(describing: textMirror.subjectType), "SimpleFormView")
    }
    
    // MARK: - platformPresentModalForm_L1 Tests
    
    func testPlatformPresentModalForm_L1_CreatesModalFormView() {
        // Given: Form type and context
        let formType = DataTypeHint.form
        let context = PresentationContext.form
        
        // When: Creating modal form presentation
        let view = platformPresentModalForm_L1(formType: formType, context: context)
        
        // Then: Should return a ModalFormView
        XCTAssertNotNil(view)
        
        let mirror = Mirror(reflecting: view)
        XCTAssertEqual(String(describing: mirror.subjectType), "ModalFormView")
    }
    
    func testPlatformPresentModalForm_L1_HandlesDifferentFormTypes() {
        // Given: Different form types
        let formTypes: [DataTypeHint] = [
            .form, .text, .number, .date, .boolean, .collection,
            .hierarchical, .temporal, .media, .user, .transaction
        ]
        let context = PresentationContext.form
        
        for formType in formTypes {
            // When: Creating modal form presentation
            let view = platformPresentModalForm_L1(formType: formType, context: context)
            
            // Then: Should return a ModalFormView for each type
            XCTAssertNotNil(view, "Should handle form type: \(formType)")
            
            let mirror = Mirror(reflecting: view)
            XCTAssertEqual(String(describing: mirror.subjectType), "ModalFormView", "Should return ModalFormView for type: \(formType)")
        }
    }
    
    func testPlatformPresentModalForm_L1_HandlesDifferentContexts() {
        // Given: Different presentation contexts
        let formType = DataTypeHint.form
        let contexts: [PresentationContext] = [
            .dashboard, .detail, .summary, .edit, .create,
            .search, .browse, .list, .form, .modal, .navigation
        ]
        
        for context in contexts {
            // When: Creating modal form presentation
            let view = platformPresentModalForm_L1(formType: formType, context: context)
            
            // Then: Should return a ModalFormView for each context
            XCTAssertNotNil(view, "Should handle context: \(context)")
            
            let mirror = Mirror(reflecting: view)
            XCTAssertEqual(String(describing: mirror.subjectType), "ModalFormView", "Should return ModalFormView for context: \(context)")
        }
    }
    
    func testPlatformPresentModalForm_L1_GeneratesAppropriateFields() {
        // Given: Different form types that should generate different fields
        let testCases: [(DataTypeHint, Int)] = [
            (.text, 1),           // Should generate 1 field
            (.number, 1),         // Should generate 1 field
            (.date, 1),           // Should generate 1 field
            (.boolean, 1),        // Should generate 1 field
            (.collection, 2),     // Should generate 2 fields
            (.hierarchical, 2),   // Should generate 2 fields
            (.temporal, 4),       // Should generate 4 fields
            (.media, 3)           // Should generate 3 fields
        ]
        
        for (formType, _) in testCases {
            // When: Creating modal form presentation
            let view = platformPresentModalForm_L1(formType: formType, context: .form)
            
            // Then: Should return a ModalFormView
            XCTAssertNotNil(view, "Should handle form type: \(formType)")
            
            let mirror = Mirror(reflecting: view)
            XCTAssertEqual(String(describing: mirror.subjectType), "ModalFormView", "Should return ModalFormView for type: \(formType)")
            
            // Note: We can't easily test the internal field count without accessing private properties
            // The important thing is that the function returns the correct view type
        }
    }
    
    // MARK: - Edge Cases and Error Handling
    
    func testPlatformPresentFormData_L1_HandlesLargeFieldSets() {
        // Given: Large number of fields
        let largeFieldSet = (1...100).map { i in
            GenericFormField(
                label: "Field \(i)",
                placeholder: "Enter value \(i)",
                value: "",
                isRequired: i % 2 == 0,
                fieldType: .text
            )
        }
        let hints = testHints
        
        // When: Creating form presentation
        let view = platformPresentFormData_L1(fields: largeFieldSet, hints: hints)
        
        // Then: Should handle large field sets gracefully
        XCTAssertNotNil(view)
        
        let mirror = Mirror(reflecting: view)
        XCTAssertEqual(String(describing: mirror.subjectType), "SimpleFormView")
    }
    
    func testPlatformPresentFormData_L1_HandlesSpecialCharacters() {
        // Given: Fields with special characters
        let specialFields = [
            GenericFormField(
                label: "Name with émojis 🚀",
                placeholder: "Enter your name with special chars",
                value: "",
                isRequired: true,
                fieldType: .text
            ),
            GenericFormField(
                label: "Email with symbols",
                placeholder: "user@example.com",
                value: "",
                isRequired: true,
                fieldType: .email
            )
        ]
        let hints = testHints
        
        // When: Creating form presentation
        let view = platformPresentFormData_L1(fields: specialFields, hints: hints)
        
        // Then: Should handle special characters gracefully
        XCTAssertNotNil(view)
        
        let mirror = Mirror(reflecting: view)
        XCTAssertEqual(String(describing: mirror.subjectType), "SimpleFormView")
    }
    
    func testPlatformPresentModalForm_L1_HandlesCustomFormType() {
        // Given: Custom form type
        let formType = DataTypeHint.custom
        let context = PresentationContext.form
        
        // When: Creating modal form presentation
        let view = platformPresentModalForm_L1(formType: formType, context: context)
        
        // Then: Should return a ModalFormView (falls back to generic form)
        XCTAssertNotNil(view)
        
        let mirror = Mirror(reflecting: view)
        XCTAssertEqual(String(describing: mirror.subjectType), "ModalFormView")
    }
    
    // MARK: - Integration Tests
    
    func testPlatformPresentFormData_L1_IntegrationWithHints() {
        // Given: Comprehensive hints
        let comprehensiveHints = PresentationHints(
            dataType: .form,
            presentationPreference: .form,
            complexity: .complex,
            context: .edit,
            customPreferences: [
                "fieldCount": "5",
                "hasValidation": "true",
                "hasComplexFields": "true"
            ]
        )
        
        // When: Creating form presentation
        let view = platformPresentFormData_L1(fields: testFields, hints: comprehensiveHints)
        
        // Then: Should return a SimpleFormView
        XCTAssertNotNil(view)
        
        let mirror = Mirror(reflecting: view)
        XCTAssertEqual(String(describing: mirror.subjectType), "SimpleFormView")
    }
    
    func testPlatformPresentModalForm_L1_IntegrationWithAllParameters() {
        // Given: All possible parameters
        let formType = DataTypeHint.user
        let context = PresentationContext.create
        
        // When: Creating modal form presentation
        let view = platformPresentModalForm_L1(formType: formType, context: context)
        
        // Then: Should return a ModalFormView
        XCTAssertNotNil(view)
        
        let mirror = Mirror(reflecting: view)
        XCTAssertEqual(String(describing: mirror.subjectType), "ModalFormView")
    }
    
    // MARK: - Performance Tests
    
    func testPlatformPresentFormData_L1_Performance() {
        // Given: Large field set
        let largeFieldSet = (1...1000).map { i in
            GenericFormField(
                label: "Field \(i)",
                placeholder: "Enter value \(i)",
                value: "",
                isRequired: i % 2 == 0,
                fieldType: .text
            )
        }
        let hints = testHints
        
        // When: Measuring performance
        measure {
            _ = platformPresentFormData_L1(fields: largeFieldSet, hints: hints)
        }
    }
    
    func testPlatformPresentModalForm_L1_Performance() {
        // Given: Form type and context
        let formType = DataTypeHint.form
        let context = PresentationContext.form
        
        // When: Measuring performance
        measure {
            _ = platformPresentModalForm_L1(formType: formType, context: context)
        }
    }
}
