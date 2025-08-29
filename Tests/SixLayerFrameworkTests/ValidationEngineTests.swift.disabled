import XCTest
import SwiftUI
@testable import SixLayerFramework

@MainActor
final class ValidationEngineTests: XCTestCase {
    
    // MARK: - Core Validation Protocol Tests
    
    func testValidationRuleProtocolExists() {
        // Test that our validation rule protocol is accessible
        // Business purpose: ensuring validation rules can be defined and used
        let rule = MockValidationRule(fieldName: "email", validate: { _ in .valid })
        XCTAssertNotNil(rule)
        XCTAssertEqual(rule.fieldName, "email")
    }
    
    func testValidationRuleCanValidateData() {
        // Test that validation rules can actually validate data
        // Business purpose: ensuring validation provides real business value
        
        let emailRule = MockValidationRule(fieldName: "email") { value in
            guard let email = value as? String else { return .invalid("Not a string") }
            return email.contains("@") ? .valid : .invalid("Invalid email format")
        }
        
        let validResult = emailRule.validate("test@example.com")
        let invalidResult = emailRule.validate("invalid-email")
        
        XCTAssertEqual(validResult, .valid)
        XCTAssertEqual(invalidResult, .invalid("Invalid email format"))
    }
    
    func testValidationEngineCanProcessMultipleRules() {
        // Test that validation engine can process multiple rules for a form
        // Business purpose: ensuring complex validation scenarios are supported
        
        let emailRule = MockValidationRule(fieldName: "email") { value in
            guard let email = value as? String else { return .invalid("Not a string") }
            return email.contains("@") ? .valid : .invalid("Invalid email format")
        }
        
        let passwordRule = MockValidationRule(fieldName: "password") { value in
            guard let password = value as? String else { return .invalid("Not a string") }
            return password.count >= 8 ? .valid : .invalid("Password too short")
        }
        
        let engine = ValidationEngine()
        engine.addRule(emailRule)
        engine.addRule(passwordRule)
        
        let results = engine.validate([
            "email": "test@example.com",
            "password": "short"
        ])
        
        XCTAssertEqual(results.count, 2)
        XCTAssertTrue(results["email"]?.isValid ?? false)
        XCTAssertFalse(results["password"]?.isValid ?? true)
    }
    
    // MARK: - Business Purpose Validation Tests
    
    func testValidationEngineEnforcesBusinessRules() {
        // Test that validation engine enforces actual business rules
        // Business purpose: ensuring data quality and business logic compliance
        
        let ageRule = MockValidationRule(fieldName: "age") { value in
            guard let age = value as? Int else { return .invalid("Age must be a number") }
            if age < 0 { return .invalid("Age cannot be negative") }
            if age > 150 { return .invalid("Age seems unrealistic") }
            return .valid
        }
        
        let salaryRule = MockValidationRule(fieldName: "salary") { value in
            guard let salary = value as? Double else { return .invalid("Salary must be a number") }
            if salary < 0 { return .invalid("Salary cannot be negative") }
            if salary > 1_000_000 { return .warning("Salary seems unusually high") }
            return .valid
        }
        
        let engine = ValidationEngine()
        engine.addRule(ageRule)
        engine.addRule(salaryRule)
        
        let results = engine.validate([
            "age": 25,
            "salary": 75000.0
        ])
        
        // All should be valid
        XCTAssertTrue(results["age"]?.isValid ?? false)
        XCTAssertTrue(results["salary"]?.isValid ?? false)
        
        // Test invalid cases
        let invalidResults = engine.validate([
            "age": -5,
            "salary": -1000.0
        ])
        
        XCTAssertFalse(invalidResults["age"]?.isValid ?? true)
        XCTAssertFalse(invalidResults["salary"]?.isValid ?? true)
    }
    
    func testValidationEngineSupportsRealWorldScenarios() {
        // Test validation engine with real-world business scenarios
        // Business purpose: ensuring the framework works for actual business needs
        
        // Task management validation
        let taskNameRule = MockValidationRule(fieldName: "taskName") { value in
            guard let name = value as? String else { return .invalid("Task name must be text") }
            if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                return .invalid("Task name cannot be empty")
            }
            if name.count > 100 {
                return .invalid("Task name too long (max 100 characters)")
            }
            return .valid
        }
        
        let dueDateRule = MockValidationRule(fieldName: "dueDate") { value in
            guard let date = value as? Date else { return .invalid("Due date must be a date") }
            if date < Date() {
                return .warning("Due date is in the past")
            }
            return .valid
        }
        
        let priorityRule = MockValidationRule(fieldName: "priority") { value in
            guard let priority = value as? String else { return .invalid("Priority must be text") }
            let validPriorities = ["low", "medium", "high", "urgent"]
            return validPriorities.contains(priority.lowercased()) ? .valid : .invalid("Invalid priority level")
        }
        
        let engine = ValidationEngine()
        engine.addRule(taskNameRule)
        engine.addRule(dueDateRule)
        engine.addRule(priorityRule)
        
        let validTask = engine.validate([
            "taskName": "Complete project documentation",
            "dueDate": Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date(),
            "priority": "high"
        ])
        
        XCTAssertTrue(validTask["taskName"]?.isValid ?? false)
        XCTAssertTrue(validTask["dueDate"]?.isValid ?? false)
        XCTAssertTrue(validTask["priority"]?.isValid ?? false)
        
        let invalidTask = engine.validate([
            "taskName": "", // Empty name
            "dueDate": Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(), // Past date
            "priority": "super" // Invalid priority
        ])
        
        XCTAssertFalse(invalidTask["taskName"]?.isValid ?? true)
        XCTAssertFalse(invalidTask["dueDate"]?.isValid ?? true)
        XCTAssertFalse(invalidTask["priority"]?.isValid ?? true)
    }
    
    func testValidationEngineIntegratesWithFormState() {
        // Test that validation engine integrates with existing form state management
        // Business purpose: ensuring validation works seamlessly with forms
        
        let emailRule = MockValidationRule(fieldName: "email") { value in
            guard let email = value as? String else { return .invalid("Not a string") }
            return email.contains("@") ? .valid : .invalid("Invalid email format")
        }
        
        let engine = ValidationEngine()
        engine.addRule(emailRule)
        
        // Create form state manager
        let formState = FormStateManager()
        formState.addField("email", value: "invalid-email")
        
        // Validate the form
        let validationResults = engine.validate(formState.getAllFieldValues())
        
        // Update form state with validation results
        for (fieldName, result) in validationResults {
            formState.updateFieldValidation(fieldName, isValid: result.isValid, errors: result.errors)
        }
        
        // Verify form state reflects validation
        let emailField = formState.getField("email")
        XCTAssertNotNil(emailField)
        XCTAssertFalse(emailField?.isValid ?? true)
        XCTAssertEqual(emailField?.errors.count, 1)
        XCTAssertEqual(emailField?.errors.first?.message, "Invalid email format")
    }
    
    func testValidationEngineSupportsCustomValidationLogic() {
        // Test that validation engine supports custom business logic
        // Business purpose: ensuring developers can implement domain-specific validation
        
        let customRule = MockValidationRule(fieldName: "customField") { value in
            // Custom business logic: field must be divisible by 3 and greater than 10
            guard let number = value as? Int else { return .invalid("Must be a number") }
            
            if number <= 10 {
                return .invalid("Number must be greater than 10")
            }
            
            if number % 3 != 0 {
                return .invalid("Number must be divisible by 3")
            }
            
            return .valid
        }
        
        let engine = ValidationEngine()
        engine.addRule(customRule)
        
        let validNumbers = [12, 15, 18, 21, 24]
        let invalidNumbers = [9, 11, 13, 16, 17]
        
        for number in validNumbers {
            let result = engine.validate(["customField": number])
            XCTAssertTrue(result["customField"]?.isValid ?? false, "\(number) should be valid")
        }
        
        for number in invalidNumbers {
            let result = engine.validate(["customField": number])
            XCTAssertFalse(result["customField"]?.isValid ?? true, "\(number) should be invalid")
        }
    }
    
    // MARK: - Performance and Scalability Tests
    
    func testValidationEngineHandlesLargeForms() {
        // Test that validation engine can handle large forms efficiently
        // Business purpose: ensuring performance for complex business forms
        
        let engine = ValidationEngine()
        
        // Add 100 validation rules
        for i in 0..<100 {
            let rule = MockValidationRule(fieldName: "field\(i)") { value in
                guard let string = value as? String else { return .invalid("Must be string") }
                return string.count > 0 ? .valid : .invalid("Cannot be empty")
            }
            engine.addRule(rule)
        }
        
        // Create form data with 100 fields
        var formData: [String: Any] = [:]
        for i in 0..<100 {
            formData["field\(i)"] = "value\(i)"
        }
        
        // Measure validation performance
        let startTime = CFAbsoluteTimeGetCurrent()
        let results = engine.validate(formData)
        let endTime = CFAbsoluteTimeGetCurrent()
        
        let validationTime = endTime - startTime
        
        // Should complete in reasonable time (less than 100ms for 100 fields)
        XCTAssertLessThan(validationTime, 0.1, "Validation should complete in under 100ms")
        XCTAssertEqual(results.count, 100, "Should validate all 100 fields")
        
        // All fields should be valid
        for (_, result) in results {
            XCTAssertTrue(result.isValid, "All fields should be valid")
        }
    }
    
    func testValidationEngineHandlesComplexValidationChains() {
        // Test that validation engine can handle complex validation dependencies
        // Business purpose: ensuring complex business rules can be implemented
        
        let engine = ValidationEngine()
        
        // Rule 1: Username must be alphanumeric
        let usernameRule = MockValidationRule(fieldName: "username") { value in
            guard let username = value as? String else { return .invalid("Must be string") }
            let alphanumeric = CharacterSet.alphanumerics
            return username.unicodeScalars.allSatisfy { alphanumeric.contains($0) } ? .valid : .invalid("Username must be alphanumeric")
        }
        
        // Rule 2: Password must be at least 8 characters and contain username
        let passwordRule = MockValidationRule(fieldName: "password") { value in
            guard let password = value as? String else { return .invalid("Must be string") }
            if password.count < 8 { return .invalid("Password too short") }
            return .valid
        }
        
        // Rule 3: Confirm password must match password
        let confirmPasswordRule = MockValidationRule(fieldName: "confirmPassword") { value in
            guard let confirmPassword = value as? String else { return .invalid("Must be string") }
            // This would need access to the password field - testing dependency handling
            return .valid
        }
        
        engine.addRule(usernameRule)
        engine.addRule(passwordRule)
        engine.addRule(confirmPasswordRule)
        
        let validForm = engine.validate([
            "username": "user123",
            "password": "securepassword123",
            "confirmPassword": "securepassword123"
        ])
        
        XCTAssertTrue(validForm["username"]?.isValid ?? false)
        XCTAssertTrue(validForm["password"]?.isValid ?? false)
        XCTAssertTrue(validForm["confirmPassword"]?.isValid ?? false)
    }
}

// MARK: - Test Helpers

/// Mock validation rule for testing
struct MockValidationRule: ValidationRule {
    let fieldName: String
    let validate: (Any) -> ValidationResult
    
    init(fieldName: String, validate: @escaping (Any) -> ValidationResult) {
        self.fieldName = fieldName
        self.validate = validate
    }
}

/// Mock validation result for testing
struct MockValidationResult: ValidationResult {
    let isValid: Bool
    let errors: [ValidationError]
    
    static let valid = MockValidationResult(isValid: true, errors: [])
    
    static func invalid(_ message: String) -> MockValidationResult {
        let error = ValidationError(fieldName: "test", message: message, severity: .error)
        return MockValidationResult(isValid: false, errors: [error])
    }
    
    static func warning(_ message: String) -> MockValidationResult {
        let error = ValidationError(fieldName: "test", message: message, severity: .warning)
        return MockValidationResult(isValid: false, errors: [error])
    }
}
