import XCTest
import SwiftUI
@testable import SixLayerFramework

@MainActor
final class FormStateManagementTests: XCTestCase {
    
    // MARK: - FormState Protocol Tests
    
    func testFormStateProtocolRequirements() {
        // Test that FormState requires ObservableObject conformance
        let formState = MockFormState()
        
        // Verify basic properties exist
        XCTAssertNotNil(formState.fields)
        XCTAssertNotNil(formState.isValid)
        XCTAssertNotNil(formState.isDirty)
        
        // Verify ObservableObject conformance by checking if it can be used as an ObservableObject
        let _: any ObservableObject = formState
    }
    
    func testFormStateInitialization() {
        let formState = MockFormState()
        
        // Verify initial state
        XCTAssertEqual(formState.fields.count, 0)
        XCTAssertTrue(formState.isValid)
        XCTAssertFalse(formState.isDirty)
    }
    
    func testFormStateWithFields() {
        let formState = MockFormState()
        
        // Add some fields
        let nameField = FieldState(value: "", isValid: true, errors: [], isDirty: false)
        let emailField = FieldState(value: "", isValid: true, errors: [], isDirty: false)
        
        formState.fields["name"] = nameField
        formState.fields["email"] = emailField
        
        // Verify fields are added
        XCTAssertEqual(formState.fields.count, 2)
        XCTAssertNotNil(formState.fields["name"])
        XCTAssertNotNil(formState.fields["email"])
    }
    
    // MARK: - FieldState Struct Tests
    
    func testFieldStateInitialization() {
        let fieldState = FieldState(value: "test", isValid: true, errors: [], isDirty: false)
        
        // Verify all properties are set correctly
        XCTAssertEqual(fieldState.value as? String, "test")
        XCTAssertTrue(fieldState.isValid)
        XCTAssertTrue(fieldState.errors.isEmpty)
        XCTAssertFalse(fieldState.isDirty)
    }
    
    func testFieldStateWithErrors() {
        let validationError = ValidationError(field: "email", message: "Invalid email format", severity: .error)
        let fieldState = FieldState(value: "invalid-email", isValid: false, errors: [validationError], isDirty: true)
        
        // Verify error state
        XCTAssertFalse(fieldState.isValid)
        XCTAssertEqual(fieldState.errors.count, 1)
        XCTAssertEqual(fieldState.errors.first?.message, "Invalid email format")
        XCTAssertTrue(fieldState.isDirty)
    }
    
    func testFieldStateValueTypes() {
        // Test different value types
        let stringField = FieldState(value: "hello", isValid: true, errors: [], isDirty: false)
        let intField = FieldState(value: 42, isValid: true, errors: [], isDirty: false)
        let boolField = FieldState(value: true, isValid: true, errors: [], isDirty: false)
        
        XCTAssertEqual(stringField.value as? String, "hello")
        XCTAssertEqual(intField.value as? Int, 42)
        XCTAssertEqual(boolField.value as? Bool, true)
    }
    
    // MARK: - FormStateManager Tests
    
    func testFormStateManagerInitialization() {
        let manager = FormStateManager()
        
        // Verify initial state
        XCTAssertEqual(manager.fields.count, 0)
        XCTAssertTrue(manager.isValid)
        XCTAssertFalse(manager.isDirty)
    }
    
    func testFormStateManagerAddField() {
        let manager = FormStateManager()
        
        // Add a field
        manager.addField("name", initialValue: "")
        
        // Verify field is added
        XCTAssertEqual(manager.fields.count, 1)
        XCTAssertNotNil(manager.fields["name"])
        XCTAssertEqual(manager.fields["name"]?.value as? String, "")
    }
    
    func testFormStateManagerUpdateField() {
        let manager = FormStateManager()
        manager.addField("name", initialValue: "")
        
        // Update field value
        manager.updateField("name", value: "John")
        
        // Verify field is updated
        XCTAssertEqual(manager.fields["name"]?.value as? String, "John")
        XCTAssertTrue(manager.fields["name"]?.isDirty == true)
        XCTAssertTrue(manager.isDirty)
    }
    
    func testFormStateManagerValidation() {
        let manager = FormStateManager()
        manager.addField("email", initialValue: "")
        
        // Add validation error
        let error = ValidationError(field: "email", message: "Invalid email", severity: .error)
        manager.setFieldError("email", error: error)
        
        // Verify validation state
        XCTAssertFalse(manager.fields["email"]?.isValid == true)
        XCTAssertEqual(manager.fields["email"]?.errors.count, 1)
        XCTAssertFalse(manager.isValid)
    }
    
    func testFormStateManagerDirtyState() {
        let manager = FormStateManager()
        manager.addField("name", initialValue: "")
        
        // Initially not dirty
        XCTAssertFalse(manager.isDirty)
        
        // Update field to make it dirty
        manager.updateField("name", value: "John")
        XCTAssertTrue(manager.isDirty)
        
        // Reset to original value
        manager.updateField("name", value: "")
        XCTAssertFalse(manager.isDirty)
    }
    
    func testFormStateManagerReset() {
        let manager = FormStateManager()
        manager.addField("name", initialValue: "")
        manager.updateField("name", value: "John")
        
        // Verify dirty state
        XCTAssertTrue(manager.isDirty)
        
        // Reset form
        manager.reset()
        
        // Verify reset state
        XCTAssertFalse(manager.isDirty)
        XCTAssertEqual(manager.fields["name"]?.value as? String, "")
    }
    
    // MARK: - ValidationError Tests
    
    func testValidationErrorInitialization() {
        let error = ValidationError(field: "email", message: "Invalid format", severity: .warning)
        
        XCTAssertEqual(error.field, "email")
        XCTAssertEqual(error.message, "Invalid format")
        XCTAssertEqual(error.severity, .warning)
    }
    
    func testValidationErrorSeverityLevels() {
        let infoError = ValidationError(field: "name", message: "Info message", severity: .info)
        let warningError = ValidationError(field: "email", message: "Warning message", severity: .warning)
        let errorError = ValidationError(field: "password", message: "Error message", severity: .error)
        
        XCTAssertEqual(infoError.severity, .info)
        XCTAssertEqual(warningError.severity, .warning)
        XCTAssertEqual(errorError.severity, .error)
    }
}

// MARK: - Mock Implementation for Testing

@MainActor
class MockFormState: ObservableObject, FormState {
    @Published var fields: [String: FieldState] = [:]
    
    var isValid: Bool {
        fields.values.allSatisfy { $0.isValid }
    }
    
    var isDirty: Bool {
        fields.values.contains { $0.isDirty }
    }
}
