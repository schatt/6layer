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
            label: label,
            contentType: .text,
            placeholder: placeholder,
            value: value
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
            label: label,
            contentType: .email,
            placeholder: "Enter email",
            value: value
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
            label: label,
            contentType: .password,
            placeholder: "Enter password",
            value: value
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
            label: label,
            contentType: .number,
            value: value
        )
    }

    /// Create a date field
    public func createDateField(
        id: String = "dateField",
        label: String = "Date",
        value: Date = Date()
    ) -> DynamicFormField {
        return DynamicFormField(
            id: id,
            label: label,
            contentType: .date,
            value: value
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
            label: label,
            contentType: .boolean,
            value: value
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
            label: label,
            contentType: .select,
            options: options,
            value: value
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
    public func createFormState(from fields: [DynamicFormField]) -> DynamicFormState {
        let state = DynamicFormState()
        for field in fields {
            state.setValue(field.value, forFieldId: field.id)
        }
        return state
    }

    /// Simulate field input
    public func simulateFieldInput(fieldId: String, value: Any, in state: DynamicFormState) {
        state.setValue(value, forFieldId: fieldId)
    }

    /// Get field value from form state
    public func getFieldValue(from state: DynamicFormState, fieldId: String) -> Any? {
        return state.getValue(forFieldId: fieldId)
    }

    /// Validate form state
    public func validateForm(_ state: DynamicFormState, requiredFields: [String]) -> [String] {
        var errors: [String] = []

        for fieldId in requiredFields {
            if let value = state.getValue(forFieldId: fieldId) {
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
    public func simulateFormSubmission(
        state: DynamicFormState,
        fields: [DynamicFormField],
        onSubmit: ([String: Any]) -> Void
    ) -> [String: Any] {
        var formData: [String: Any] = [:]

        for field in fields {
            if let value = state.getValue(forFieldId: field.id) {
                formData[field.id] = value
            }
        }

        onSubmit(formData)
        return formData
    }

    /// Create form data dictionary from fields and state
    public func createFormData(from fields: [DynamicFormField], state: DynamicFormState) -> [String: Any] {
        var formData: [String: Any] = [:]

        for field in fields {
            if let value = state.getValue(forFieldId: field.id) {
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
    public func populateFormWithTestData(_ state: DynamicFormState, fields: [DynamicFormField]) {
        let testData = generateTestUserData()

        for field in fields {
            if let testValue = testData[field.id] {
                state.setValue(testValue, forFieldId: field.id)
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