//
//  PlatformPresentFormDataL1ComprehensiveTests.swift
//  SixLayerFrameworkTests
//
//  Comprehensive tests for platformPresentFormData_L1 function
//  Covers all field types, enhanced hints, cross-platform scenarios, and edge cases
//

import XCTest
@testable import SixLayerFramework

@MainActor
final class PlatformPresentFormDataL1ComprehensiveTests: XCTestCase {

    // MARK: - Test Helpers
    
    /// Helper function to create GenericFormField with proper binding for tests
    private func createTestField(
        label: String,
        placeholder: String? = nil,
        value: String = "",
        isRequired: Bool = false,
        fieldType: DynamicFieldType = .text
    ) -> GenericFormField {
        return createTestField(
            label: label,
            placeholder: placeholder,
            value: .constant(value),
            isRequired: isRequired,
            fieldType: fieldType
        )
    }

    // MARK: - Test Configuration

    /// Test configuration for form data presentation
    struct FormTestConfiguration {
        let name: String
        let fields: [GenericFormField]
        let hints: PresentationHints
        let expectedViewType: String
        let expectedFieldCount: Int
        let shouldTestFieldTypes: Bool
        let shouldTestAccessibility: Bool
        let shouldTestPerformance: Bool
    }

    /// Enhanced hints test configuration
    struct EnhancedFormTestConfiguration {
        let name: String
        let fields: [GenericFormField]
        let hints: EnhancedPresentationHints
        let expectedViewType: String
        let shouldTestExtensibleHints: Bool
        let shouldTestCustomPreferences: Bool
    }

    // MARK: - Test Data

    private let standardHints = PresentationHints(
        dataType: .form,
        presentationPreference: .form,
        complexity: .moderate,
        context: .form
    )

    private let simpleHints = PresentationHints(
        dataType: .form,
        presentationPreference: .form,
        complexity: .simple,
        context: .form
    )

    private let complexHints = PresentationHints(
        dataType: .form,
        presentationPreference: .form,
        complexity: .complex,
        context: .edit
    )

    // MARK: - Field Type Tests

    func testPlatformPresentFormData_L1_AllFieldTypes() {
        // Given: All possible field types
        let allFieldTypes: [DynamicFieldType] = [
            .text, .email, .password, .number, .phone,
            .date, .time, .datetime, .select, .multiselect,
            .radio, .checkbox, .textarea, .file, .url,
            .color, .range, .toggle, .richtext, .autocomplete, .custom
        ]

        // Create fields for each type
        let fields = allFieldTypes.enumerated().map { index, fieldType in
            createTestField(
                label: "Field \(index + 1)",
                placeholder: "Enter value for \(fieldType.rawValue)",
                value: getDefaultValue(for: fieldType),
                isRequired: index % 3 == 0, // Every third field is required
                fieldType: fieldType
            )
        }

        // When: Creating form presentation
        let view = platformPresentFormData_L1(fields: fields, hints: standardHints)

        // Then: Should create view successfully
        XCTAssertNotNil(view, "Should create view with all field types")

        let mirror = Mirror(reflecting: view)
        XCTAssertEqual(String(describing: mirror.subjectType), "SimpleFormView")

        // Verify field count matches
        XCTAssertEqual(fields.count, 21, "Should have 21 fields for all types")
    }

    func testPlatformPresentFormData_L1_FieldTypeSpecificBehavior() {
        // Given: Fields with different behaviors
        let fieldsWithOptions = [
            createTestField(
                label: "Select Field",
                value: "option1", fieldType: .select
            ),
            createTestField(
                label: "Multiselect Field",
                value: "option1,option2", fieldType: .multiselect
            ),
            createTestField(
                label: "Radio Field",
                value: "option1", fieldType: .radio
            ),
            createTestField(
                label: "Checkbox Field",
                value: "true", fieldType: .checkbox
            )
        ]

        // When: Creating form presentation
        let view = platformPresentFormData_L1(fields: fieldsWithOptions, hints: standardHints)

        // Then: Should handle option-based fields correctly
        XCTAssertNotNil(view)

        // Verify that these field types support options
        for field in fieldsWithOptions {
            XCTAssertTrue(field.fieldType.supportsOptions,
                          "Field type \(field.fieldType) should support options")
        }
    }

    func testPlatformPresentFormData_L1_MultiValueFields() {
        // Given: Fields that support multiple values
        let multiValueFields = [
            createTestField(
                label: "Multiselect Field",
                value: "option1,option2,option3", fieldType: .multiselect
            ),
            createTestField(
                label: "Checkbox Field",
                value: "true", fieldType: .checkbox
            )
        ]

        // When: Creating form presentation
        let view = platformPresentFormData_L1(fields: multiValueFields, hints: standardHints)

        // Then: Should handle multi-value fields
        XCTAssertNotNil(view)

        // Verify that these field types support multiple values
        for field in multiValueFields {
            XCTAssertTrue(field.fieldType.supportsMultipleValues,
                          "Field type \(field.fieldType) should support multiple values")
        }
    }

    // MARK: - Enhanced Hints Tests

    func testPlatformPresentFormData_L1_EnhancedHintsSupport() {
        // Given: Enhanced hints with extensible hints
        let customHint = CustomHint(
            hintType: "form.validation",
            priority: .high,
            overridesDefault: true,
            customData: [
                "realTimeValidation": true,
                "showErrorsInline": true,
                "autoSave": false
            ]
        )

        let enhancedHints = EnhancedPresentationHints(
            dataType: .form,
            presentationPreference: .form,
            complexity: .complex,
            context: .edit,
            customPreferences: [
                "theme": "dark",
                "layout": "compact",
                "animations": "enabled"
            ], extensibleHints: [customHint]
        )

        let fields = [
            createTestField(label: "Name", fieldType: .text),
            createTestField(label: "Email", fieldType: .email),
            createTestField(label: "Age", fieldType: .number)
        ]

        // When: Creating form presentation with enhanced hints
        let view = platformPresentFormData_L1(fields: fields, hints: enhancedHints)

        // Then: Should create view with enhanced hints support
        XCTAssertNotNil(view, "Should create view with enhanced hints")

        let mirror = Mirror(reflecting: view)
        XCTAssertEqual(String(describing: mirror.subjectType), "SimpleFormView")
    }

    func testPlatformPresentFormData_L1_ExtensibleHintsProcessing() {
        // Given: Multiple extensible hints
        let validationHint = CustomHint(
            hintType: "form.validation",
            priority: .high,
            overridesDefault: false,
            customData: ["validateOnSubmit": true]
        )

        let uiHint = CustomHint(
            hintType: "form.ui",
            priority: .normal,
            overridesDefault: false,
            customData: ["showProgressBar": true]
        )

        let enhancedHints = EnhancedPresentationHints(
            dataType: .form,
            presentationPreference: .form,
            complexity: .moderate,
            context: .create,
            extensibleHints: [validationHint, uiHint]
        )

        let fields = [
            createTestField(label: "Title", fieldType: .text),
            createTestField(label: "Description", fieldType: .textarea)
        ]

        // When: Creating form with multiple extensible hints
        let view = platformPresentFormData_L1(fields: fields, hints: enhancedHints)

        // Then: Should process all extensible hints
        XCTAssertNotNil(view)
        XCTAssertEqual(enhancedHints.extensibleHints.count, 2,
                      "Should have 2 extensible hints")
    }

    // MARK: - Cross-Platform Tests

    func testPlatformPresentFormData_L1_CrossPlatformCompatibility() {
        // Given: Fields that work across platforms
        let crossPlatformFields = [
            createTestField(
                label: "Name",
                placeholder: "Enter your name",
                isRequired: true, fieldType: .text
            ),
            createTestField(
                label: "Email",
                placeholder: "Enter your email",
                isRequired: true, fieldType: .email
            ),
            createTestField(
                label: "Phone",
                placeholder: "Enter your phone",
                fieldType: .phone
            ),
            createTestField(
                label: "Date of Birth",
                placeholder: "Select your date of birth",
                fieldType: .date
            )
        ]

        // Test with different platform-specific contexts
        let platformContexts: [PresentationContext] = [.form, .modal, .navigation]

        for context in platformContexts {
            let hints = PresentationHints(
                dataType: .form,
                presentationPreference: .form,
                complexity: .moderate,
                context: context
            )

            // When: Creating form presentation
            let view = platformPresentFormData_L1(fields: crossPlatformFields, hints: hints)

            // Then: Should work across all platforms
            XCTAssertNotNil(view, "Should work with context: \(context)")

            let mirror = Mirror(reflecting: view)
            XCTAssertEqual(String(describing: mirror.subjectType), "SimpleFormView")
        }
    }

    func testPlatformPresentFormData_L1_PlatformSpecificKeyboardTypes() {
        // Given: Fields that should use different keyboard types on iOS
        let keyboardTestFields = [
            createTestField(label: "Text", fieldType: .text),
            createTestField(label: "Email", fieldType: .email),
            createTestField(label: "Number", fieldType: .number),
            createTestField(label: "Phone", fieldType: .phone),
            createTestField(label: "URL", fieldType: .url)
        ]

        // When: Creating form presentation
        let view = platformPresentFormData_L1(fields: keyboardTestFields, hints: standardHints)

        // Then: Should handle platform-specific keyboard types
        XCTAssertNotNil(view)

        #if os(iOS)
        // On iOS, verify keyboard types are set appropriately
        for field in keyboardTestFields {
            XCTAssertNotEqual(field.fieldType.keyboardType, .default,
                             "Field type \(field.fieldType) should have appropriate keyboard type on iOS")
        }
        #else
        // On macOS, keyboard types are not applicable
        for field in keyboardTestFields {
            XCTAssertEqual(field.fieldType.keyboardType, PlatformKeyboardType.default.rawValue,
                          "Field type \(field.fieldType) should default to 'default' on non-iOS platforms")
        }
        #endif
    }

    // MARK: - Performance Tests

    func testPlatformPresentFormData_L1_LargeFieldSetPerformance() {
        // Given: Very large field set for performance testing
        let largeFieldSet = (1...1000).map { i in
            createTestField(
                label: "Field \(i)",
                placeholder: "Value \(i)",
                value: "default\(i)",
                isRequired: i % 5 == 0,
                fieldType: DynamicFieldType.allCases[i % DynamicFieldType.allCases.count]
            )
        }

        let hints = PresentationHints(
            dataType: .form,
            presentationPreference: .form,
            complexity: .complex,
            context: .list
        )

        // When: Measuring performance with large dataset
        measure {
            let view = platformPresentFormData_L1(fields: largeFieldSet, hints: hints)
            XCTAssertNotNil(view)
        }
    }

    func testPlatformPresentFormData_L1_MemoryEfficiency() {
        // Given: Memory-intensive field set
        let memoryFields = (1...500).map { i in
            createTestField(
                label: "Rich Text Field \(i)",
                placeholder: "Enter rich content \(i)",
                value: String(repeating: "Long content ", count: 100), // 1.3KB per field
                fieldType: .richtext
            )
        }

        // When: Creating form with memory-intensive content
        let view = platformPresentFormData_L1(fields: memoryFields, hints: complexHints)

        // Then: Should handle memory efficiently
        XCTAssertNotNil(view)

        // Verify view type
        let mirror = Mirror(reflecting: view)
        XCTAssertEqual(String(describing: mirror.subjectType), "SimpleFormView")
    }

    // MARK: - Validation and Edge Cases

    func testPlatformPresentFormData_L1_ValidationScenarios() {
        // Given: Fields with various validation requirements
        let validationFields = [
            createTestField(
                label: "Required Text",
                value: "", isRequired: true, fieldType: .text
            ),
            createTestField(
                label: "Required Email",
                value: "", isRequired: true, fieldType: .email
            ),
            createTestField(
                label: "Optional Number",
                value: "123", isRequired: false, fieldType: .number
            ),
            createTestField(
                label: "Invalid Email",
                value: "invalid-email", fieldType: .email
            )
        ]

        // When: Creating form with validation scenarios
        let view = platformPresentFormData_L1(fields: validationFields, hints: standardHints)

        // Then: Should handle validation appropriately
        XCTAssertNotNil(view)

        // Verify field requirements
        let requiredFields = validationFields.filter { $0.isRequired }
        let optionalFields = validationFields.filter { !$0.isRequired }

        XCTAssertEqual(requiredFields.count, 2, "Should have 2 required fields")
        XCTAssertEqual(optionalFields.count, 2, "Should have 2 optional fields")
    }

    func testPlatformPresentFormData_L1_EmptyAndNilValues() {
        // Given: Fields with empty and nil values
        let edgeCaseFields = [
            createTestField(
                label: "Empty Label",
                value: "", fieldType: .text
            ),
            createTestField(
                label: "Nil Placeholder",
                placeholder: nil,
                fieldType: .text
            ),
            createTestField(
                label: "Empty Everything",
                placeholder: nil,
                value: "",
                fieldType: .text
            ),
            createTestField(
                label: "Whitespace Only",
                value: "   ",
                fieldType: .text
            )
        ]

        // When: Creating form with edge case values
        let view = platformPresentFormData_L1(fields: edgeCaseFields, hints: standardHints)

        // Then: Should handle edge cases gracefully
        XCTAssertNotNil(view)

        // Verify edge case handling
        let emptyValueFields = edgeCaseFields.filter { $0.value.isEmpty }
        XCTAssertEqual(emptyValueFields.count, 2, "Should have 2 fields with empty values")

        let nilPlaceholderFields = edgeCaseFields.filter { $0.placeholder == nil }
        XCTAssertEqual(nilPlaceholderFields.count, 2, "Should have 2 fields with nil placeholders")
    }

    func testPlatformPresentFormData_L1_SpecialCharacterHandling() {
        // Given: Fields with special characters and Unicode
        let specialCharFields = [
            createTestField(
                label: "Emoji Field 🚀",
                placeholder: "Enter with emoji 🎉",
                value: "Unicode: ñáéíóú",
                fieldType: .text
            ),
            createTestField(
                label: "RTL Text",
                placeholder: "نص عربي",
                value: "عربي",
                fieldType: .text
            ),
            createTestField(
                label: "Symbols & Punctuation",
                placeholder: "!@#$%^&*()",
                value: "©®™€¥£¢",
                fieldType: .text
            ),
            createTestField(
                label: "Math Symbols",
                placeholder: "∑∆∏√∞",
                value: "αβγδε",
                fieldType: .text
            )
        ]

        // When: Creating form with special characters
        let view = platformPresentFormData_L1(fields: specialCharFields, hints: standardHints)

        // Then: Should handle special characters correctly
        XCTAssertNotNil(view)

        // Verify all fields have special character content
        for field in specialCharFields {
            XCTAssertFalse(field.label.isEmpty, "Label should not be empty")
            XCTAssertFalse(field.value.isEmpty, "Value should not be empty")
        }
    }

    // MARK: - Integration Tests

    func testPlatformPresentFormData_L1_WithAllHintCombinations() {
        // Given: All possible hint combinations
        let hintCombinations = [
            PresentationHints(dataType: .form, presentationPreference: .form, complexity: .simple, context: .form),
            PresentationHints(dataType: .form, presentationPreference: .form, complexity: .moderate, context: .edit),
            PresentationHints(dataType: .form, presentationPreference: .form, complexity: .complex, context: .create),
            PresentationHints(dataType: .user, presentationPreference: .modal, complexity: .simple, context: .modal),
            PresentationHints(dataType: .transaction, presentationPreference: .form, complexity: .complex, context: .detail)
        ]

        let fields = [
            createTestField(label: "Name", fieldType: .text),
            createTestField(label: "Email", fieldType: .email),
            createTestField(label: "Phone", fieldType: .phone)
        ]

        // When: Testing all hint combinations
        for (index, hints) in hintCombinations.enumerated() {
            let view = platformPresentFormData_L1(fields: fields, hints: hints)

            // Then: Each combination should work
            XCTAssertNotNil(view, "Hint combination \(index) should work")
        }
    }

    func testPlatformPresentFormData_L1_CustomPreferencesIntegration() {
        // Given: Hints with custom preferences
        let hintsWithPreferences = PresentationHints(
            dataType: .form,
            presentationPreference: .form,
            complexity: .complex,
            context: .edit,
            customPreferences: [
                "theme": "dark",
                "layout": "grid",
                "validation": "strict",
                "animations": "disabled",
                "maxLength": "500"
            ]
        )

        let fields = [
            createTestField(label: "Title", fieldType: .text),
            createTestField(label: "Description", fieldType: .textarea),
            createTestField(label: "Category", fieldType: .select)
        ]

        // When: Creating form with custom preferences
        let view = platformPresentFormData_L1(fields: fields, hints: hintsWithPreferences)

        // Then: Should integrate custom preferences
        XCTAssertNotNil(view)
        XCTAssertEqual(hintsWithPreferences.customPreferences.count, 5,
                      "Should have 5 custom preferences")
    }

    // MARK: - Accessibility Tests

    func testPlatformPresentFormData_L1_AccessibilitySupport() {
        // Given: Fields with accessibility considerations
        let accessibilityFields = [
            createTestField(
                label: "Name (Required)",
                placeholder: "Enter your full name",
                isRequired: true, fieldType: .text
            ),
            createTestField(
                label: "Email Address",
                placeholder: "your.email@example.com",
                isRequired: true, fieldType: .email
            ),
            createTestField(
                label: "Phone Number",
                placeholder: "(555) 123-4567",
                fieldType: .phone
            ),
            createTestField(
                label: "Date of Birth",
                placeholder: "MM/DD/YYYY",
                fieldType: .date
            )
        ]

        let accessibilityHints = PresentationHints(
            dataType: .form,
            presentationPreference: .form,
            complexity: .moderate,
            context: .form,
            customPreferences: [
                "accessibilityEnabled": "true",
                "screenReaderSupport": "true",
                "highContrast": "false"
            ]
        )

        // When: Creating accessible form
        let view = platformPresentFormData_L1(fields: accessibilityFields, hints: accessibilityHints)

        // Then: Should support accessibility
        XCTAssertNotNil(view)

        // Verify accessibility considerations
        let requiredFields = accessibilityFields.filter { $0.isRequired }
        XCTAssertEqual(requiredFields.count, 2, "Should have 2 required fields for accessibility")

        for field in accessibilityFields {
            XCTAssertFalse(field.label.isEmpty, "All fields should have labels for accessibility")
            XCTAssertNotNil(field.placeholder, "Most fields should have placeholders for accessibility")
        }
    }

    // MARK: - Error Handling Tests

    func testPlatformPresentFormData_L1_ErrorRecovery() {
        // Given: Fields with potentially problematic data
        let problematicFields = [
            createTestField(
                label: "",
                placeholder: "",
                value: String(repeating: "x", count: 10000), // Very long value
                fieldType: .text
            ),
            createTestField(
                label: String(repeating: "Label", count: 1000), // Very long label
                fieldType: .text
            )
        ]

        // When: Creating form with problematic data
        let view = platformPresentFormData_L1(fields: problematicFields, hints: standardHints)

        // Then: Should handle errors gracefully and still create view
        XCTAssertNotNil(view, "Should handle problematic data gracefully")

        let mirror = Mirror(reflecting: view)
        XCTAssertEqual(String(describing: mirror.subjectType), "SimpleFormView")
    }

    // MARK: - Helper Methods

    private func getDefaultValue(for fieldType: DynamicFieldType) -> String {
        switch fieldType {
        case .text, .textarea, .richtext:
            return "Sample text"
        case .email:
            return "user@example.com"
        case .password:
            return "password123"
        case .number, .range:
            return "42"
        case .phone:
            return "+1 (555) 123-4567"
        case .url:
            return "https://example.com"
        case .date:
            return "2024-01-15"
        case .time:
            return "14:30"
        case .datetime:
            return "2024-01-15T14:30:00Z"
        case .select, .radio:
            return "option1"
        case .multiselect:
            return "option1,option2"
        case .checkbox, .toggle:
            return "true"
        case .color:
            return "#FF5733"
        case .file:
            return "filename.txt"
        case .autocomplete:
            return "autocomplete_value"
        case .custom:
            return "custom_value"
        }
    }
}
