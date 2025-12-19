//
//  FormTestHelper.swift
//  SixLayerTestKit
//
//  Testing utilities for DynamicForm and form interactions
//

import Foundation
import SwiftUI
import SixLayerFramework

/// Helper class for testing DynamicForm and form interactions
public class FormTestHelper {

    // MARK: - Form Creation

    /// Create a DynamicFormField with test data
    public func createTextField(
        id: String = "testField",
        label: String = "Test Field",
        placeholder: String = "Enter text",
        value: String = ""
    ) -> DynamicFormField {
        return DynamicFormField(
            id: id,
            contentType: .text,
            label: label,
            placeholder: placeholder,
            defaultValue: value
        )
    }

    /// Create an email field
    public func createEmailField(
        id: String = "emailField",
        label: String = "Email",
        value: String = ""
    ) -> DynamicFormField {
        return DynamicFormField(
            id: id,
            contentType: .email,
            label: label,
            placeholder: "Enter email",
            defaultValue: value
        )
    }

    /// Create a password field
    public func createPasswordField(
        id: String = "passwordField",
        label: String = "Password",
        value: String = ""
    ) -> DynamicFormField {
        return DynamicFormField(
            id: id,
            contentType: .password,
            label: label,
            placeholder: "Enter password",
            defaultValue: value
        )
    }

    /// Create a number field
    public func createNumberField(
        id: String = "numberField",
        label: String = "Number",
        value: Double = 0
    ) -> DynamicFormField {
        return DynamicFormField(
            id: id,
            contentType: .number,
            label: label,
            defaultValue: String(value)
        )
    }

    /// Create a date field
    public func createDateField(
        id: String = "dateField",
        label: String = "Date",
        value: Date = Date()
    ) -> DynamicFormField {
        let formatter = ISO8601DateFormatter()
        return DynamicFormField(
            id: id,
            contentType: .date,
            label: label,
            defaultValue: formatter.string(from: value)
        )
    }

    /// Create a boolean field
    public func createBooleanField(
        id: String = "booleanField",
        label: String = "Boolean",
        value: Bool = false
    ) -> DynamicFormField {
        return DynamicFormField(
            id: id,
            contentType: .boolean,
            label: label,
            defaultValue: value ? "true" : "false"
        )
    }

    /// Create a select field with options
    public func createSelectField(
        id: String = "selectField",
        label: String = "Select",
        options: [String] = ["Option 1", "Option 2", "Option 3"],
        value: String = ""
    ) -> DynamicFormField {
        return DynamicFormField(
            id: id,
            contentType: .select,
            label: label,
            options: options,
            defaultValue: value
        )
    }

    /// Create a complete form with multiple fields
    public func createTestForm() -> [DynamicFormField] {
        return [
            createTextField(id: "name", label: "Name", value: "John Doe"),
            createEmailField(id: "email", value: "john@example.com"),
            createPasswordField(id: "password"),
            createNumberField(id: "age", value: 30),
            createDateField(id: "birthdate"),
            createBooleanField(id: "newsletter", value: true),
            createSelectField(id: "country", options: ["US", "CA", "UK"])
        ]
    }

    // MARK: - Form State Management

    /// Create a DynamicFormState from fields
    @MainActor
    public func createFormState(from fields: [DynamicFormField]) -> DynamicFormState {
        // Create a section with all fields
        let section = DynamicFormSection(
            id: "test-section",
            title: "Test Section",
            fields: fields
        )
        let configuration = DynamicFormConfiguration(
            id: "test-form",
            title: "Test Form",
            sections: [section]
        )
        let state = DynamicFormState(configuration: configuration)
        for field in fields {
            if let defaultValue = field.defaultValue {
                state.setValue(defaultValue, for: field.id)
            }
        }
        return state
    }

    /// Simulate field input
    @MainActor
    public func simulateFieldInput(fieldId: String, value: Any, in state: DynamicFormState) {
        state.setValue(value, for: fieldId)
    }

    /// Get field value from form state
    @MainActor
    public func getFieldValue(from state: DynamicFormState, fieldId: String) -> Any? {
        return state.getValue(for: fieldId) as Any?
    }

    /// Validate form state
    @MainActor
    public func validateForm(_ state: DynamicFormState, requiredFields: [String]) -> [String] {
        var errors: [String] = []

        for fieldId in requiredFields {
            if let value: Any = state.getValue(for: fieldId) {
                if let stringValue = value as? String, stringValue.isEmpty {
                    errors.append("\(fieldId) is required")
                }
            } else {
                errors.append("\(fieldId) is required")
            }
        }

        return errors
    }

    // MARK: - Form Interaction Simulation

    /// Simulate form submission
    @MainActor
    public func simulateFormSubmission(
        state: DynamicFormState,
        fields: [DynamicFormField],
        onSubmit: ([String: Any]) -> Void
    ) -> [String: Any] {
        var formData: [String: Any] = [:]

        for field in fields {
            if let value: Any = state.getValue(for: field.id) {
                formData[field.id] = value
            }
        }

        onSubmit(formData)
        return formData
    }

    /// Create form data dictionary from fields and state
    @MainActor
    public func createFormData(from fields: [DynamicFormField], state: DynamicFormState) -> [String: Any] {
        var formData: [String: Any] = [:]

        for field in fields {
            // Try to get value as Any to avoid type inference issues
            if let value: Any = state.getValue(for: field.id) {
                formData[field.id] = value
            }
        }

        return formData
    }

    // MARK: - Test Data Generation

    /// Generate test user data
    public func generateTestUserData() -> [String: Any] {
        return [
            "name": TestDataGenerator.randomString(length: 10),
            "email": TestDataGenerator.randomEmail(),
            "phone": TestDataGenerator.randomPhoneNumber(),
            "age": Int.random(in: 18...80),
            "birthdate": TestDataGenerator.randomDate(in: Date.distantPast...Date()),
            "newsletter": Bool.random(),
            "country": ["US", "CA", "UK", "DE", "FR"].randomElement()!
        ]
    }

    /// Populate form state with test data
    @MainActor
    public func populateFormWithTestData(_ state: DynamicFormState, fields: [DynamicFormField]) {
        let testData = generateTestUserData()

        for field in fields {
            if let testValue = testData[field.id] {
                state.setValue(testValue, for: field.id)
            }
        }
    }

    // MARK: - Form Validation Helpers

    /// Create validation rules for testing
    public func createValidationRules() -> [String: (Any) -> Bool] {
        return [
            "email": { value in
                guard let email = value as? String else { return false }
                return email.contains("@") && email.contains(".")
            },
            "phone": { value in
                guard let phone = value as? String else { return false }
                return phone.count >= 10
            },
            "age": { value in
                guard let age = value as? Int else { return false }
                return age >= 18 && age <= 120
            }
        ]
    }

    /// Validate field value against rules
    public func validateField(_ field: DynamicFormField, value: Any, rules: [String: (Any) -> Bool]) -> Bool {
        guard let rule = rules[field.id] else { return true }
        return rule(value)
    }
}