import Foundation
import SwiftUI
import Combine

// MARK: - Core Types

/// Protocol defining the core form state management interface
@MainActor
public protocol FormState: ObservableObject {
    /// Dictionary of field states keyed by field name
    var fields: [String: FieldState] { get }
    
    /// Whether all fields in the form are valid
    var isValid: Bool { get }
    
    /// Whether any fields in the form have been modified
    var isDirty: Bool { get }
}

/// Represents the state of a single form field
public struct FieldState {
    /// Current value of the field (can be any type)
    var value: Any
    
    /// Whether the field passes validation
    var isValid: Bool
    
    /// List of validation errors for this field
    var errors: [ValidationError]
    
    /// Whether the field has been modified from its initial value
    var isDirty: Bool
    
    /// Initial value for comparison (used to determine dirty state)
    var initialValue: Any
    
    init(value: Any, isValid: Bool = true, errors: [ValidationError] = [], isDirty: Bool = false) {
        self.value = value
        self.isValid = isValid
        self.errors = errors
        self.isDirty = isDirty
        self.initialValue = value
    }
}

// MARK: - FieldState Equatable Conformance

extension FieldState: Equatable {
    static func == (lhs: FieldState, rhs: FieldState) -> Bool {
        return lhs.isValid == rhs.isValid &&
               lhs.errors == rhs.errors &&
               lhs.isDirty == rhs.isDirty &&
               isEqualValues(lhs.value, rhs.value) &&
               isEqualValues(lhs.initialValue, rhs.initialValue)
    }
    
    private static func isEqualValues(_ lhs: Any, _ rhs: Any) -> Bool {
        // Handle basic types first
        if let lhsString = lhs as? String, let rhsString = rhs as? String {
            return lhsString == rhsString
        }
        if let lhsInt = lhs as? Int, let rhsInt = rhs as? Int {
            return lhsInt == rhsInt
        }
        if let lhsBool = lhs as? Bool, let rhsBool = rhs as? Bool {
            return lhsBool == rhsBool
        }
        if let lhsDouble = lhs as? Double, let rhsDouble = rhs as? Double {
            return lhsDouble == rhsDouble
        }
        
        // Handle optionals by checking if both are nil or both have values
        let lhsMirror = Mirror(reflecting: lhs)
        let rhsMirror = Mirror(reflecting: rhs)
        
        if lhsMirror.displayStyle == .optional && rhsMirror.displayStyle == .optional {
            let lhsChildren = Array(lhsMirror.children)
            let rhsChildren = Array(rhsMirror.children)
            
            if lhsChildren.isEmpty && rhsChildren.isEmpty {
                return true // Both are nil
            } else if !lhsChildren.isEmpty && !rhsChildren.isEmpty {
                // Both have values, compare the unwrapped values
                return isEqualValues(lhsChildren[0].value, rhsChildren[0].value)
            } else {
                return false // One is nil, one has value
            }
        }
        
        // For other types, use reflection-based comparison
        return String(describing: lhs) == String(describing: rhs)
    }
}

/// Represents a validation error for a form field
public struct ValidationError: Equatable, Identifiable {
    /// Unique identifier for the error
    let id = UUID()
    
    /// Name of the field that has the error
    let field: String
    
    /// Human-readable error message
    let message: String
    
    /// Severity level of the error
    let severity: ValidationSeverity
    
    init(field: String, message: String, severity: ValidationSeverity = .error) {
        self.field = field
        self.message = message
        self.severity = severity
    }
}

/// Severity levels for validation errors
public enum ValidationSeverity: Equatable, CaseIterable {
    case info
    case warning
    case error
}

// MARK: - Form State Manager

/// Central coordinator for managing form state
@MainActor
final class FormStateManager: ObservableObject, FormState {
    
    // MARK: - Published Properties
    
    @Published var fields: [String: FieldState] = [:]
    
    // MARK: - Computed Properties
    
    var isValid: Bool {
        fields.values.allSatisfy { $0.isValid }
    }
    
    var isDirty: Bool {
        fields.values.contains { $0.isDirty }
    }
    
    // MARK: - Initialization
    
    init() {}
    
    // MARK: - Field Management
    
    /// Add a new field to the form
    /// - Parameters:
    ///   - name: The name/identifier of the field
    ///   - initialValue: The initial value for the field
    func addField(_ name: String, initialValue: Any) {
        let fieldState = FieldState(value: initialValue)
        fields[name] = fieldState
    }
    
    /// Update the value of an existing field
    /// - Parameters:
    ///   - name: The name of the field to update
    ///   - value: The new value for the field
    func updateField(_ name: String, value: Any) {
        guard var fieldState = fields[name] else { return }
        
        fieldState.value = value
        fieldState.isDirty = !isEqual(fieldState.initialValue, value)
        
        fields[name] = fieldState
    }
    
    /// Set validation errors for a field
    /// - Parameters:
    ///   - name: The name of the field
    ///   - error: The validation error to add
    func setFieldError(_ name: String, error: ValidationError) {
        guard var fieldState = fields[name] else { return }
        
        fieldState.errors.append(error)
        fieldState.isValid = false
        
        fields[name] = fieldState
    }
    
    /// Clear all validation errors for a field
    /// - Parameter name: The name of the field
    func clearFieldErrors(_ name: String) {
        guard var fieldState = fields[name] else { return }
        
        fieldState.errors.removeAll()
        fieldState.isValid = true
        
        fields[name] = fieldState
    }
    
    /// Reset the form to its initial state
    func reset() {
        for (name, fieldState) in fields {
            var updatedField = fieldState
            updatedField.value = fieldState.initialValue
            updatedField.errors.removeAll()
            updatedField.isValid = true
            updatedField.isDirty = false
            fields[name] = updatedField
        }
    }
    
    /// Get the current value of a field
    /// - Parameter name: The name of the field
    /// - Returns: The current value, or nil if the field doesn't exist
    func getFieldValue(_ name: String) -> Any? {
        return fields[name]?.value
    }
    
    /// Check if a field exists
    /// - Parameter name: The name of the field
    /// - Returns: True if the field exists, false otherwise
    func hasField(_ name: String) -> Bool {
        return fields[name] != nil
    }
    
    /// Remove a field from the form
    /// - Parameter name: The name of the field to remove
    func removeField(_ name: String) {
        fields.removeValue(forKey: name)
    }
    
    // MARK: - Private Helpers
    
    /// Compare two values for equality, handling different types
    private func isEqual(_ lhs: Any, _ rhs: Any) -> Bool {
        // Handle basic types first
        if let lhsString = lhs as? String, let rhsString = rhs as? String {
            return lhsString == rhsString
        }
        if let lhsInt = lhs as? Int, let rhsInt = rhs as? Int {
            return lhsInt == rhsInt
        }
        if let lhsBool = lhs as? Bool, let rhsBool = rhs as? Bool {
            return lhsBool == rhsBool
        }
        if let lhsDouble = lhs as? Double, let rhsDouble = rhs as? Double {
            return lhsDouble == rhsDouble
        }
        
        // Handle optionals by checking if both are nil or both have values
        let lhsMirror = Mirror(reflecting: lhs)
        let rhsMirror = Mirror(reflecting: rhs)
        
        if lhsMirror.displayStyle == .optional && rhsMirror.displayStyle == .optional {
            let lhsChildren = Array(lhsMirror.children)
            let rhsChildren = Array(rhsMirror.children)
            
            if lhsChildren.isEmpty && rhsChildren.isEmpty {
                return true // Both are nil
            } else if !lhsChildren.isEmpty && !rhsChildren.isEmpty {
                // Both have values, compare the unwrapped values
                return isEqual(lhsChildren[0].value, rhsChildren[0].value)
            } else {
                return false // One is nil, one has value
            }
        }
        
        // For other types, use reflection-based comparison
        return String(describing: lhs) == String(describing: rhs)
    }
}

// MARK: - Extensions

extension FormStateManager {
    /// Get all field names
    var fieldNames: [String] {
        return Array(fields.keys)
    }
    
    /// Get all fields that have errors
    var fieldsWithErrors: [String] {
        return fields.compactMap { name, fieldState in
            fieldState.errors.isEmpty ? nil : name
        }
    }
    
    /// Get all dirty fields
    var dirtyFields: [String] {
        return fields.compactMap { name, fieldState in
            fieldState.isDirty ? name : nil
        }
    }
    
    /// Get the total number of validation errors across all fields
    var totalErrorCount: Int {
        return fields.values.reduce(0) { count, fieldState in
            count + fieldState.errors.count
        }
    }
}
