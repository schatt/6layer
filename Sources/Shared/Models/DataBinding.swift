import Foundation
import SwiftUI
import Combine

// MARK: - DataBinder

/// Connects UI form fields to data model properties using key paths
@MainActor
final class DataBinder<T> {
    
    // MARK: - Properties
    
    /// The data model being bound
    private var model: T
    
    /// Dictionary of field bindings keyed by field name
    private var bindings: [String: FieldBinding<T>] = [:]
    
    /// Change tracker for monitoring modifications
    private let changeTracker = ChangeTracker()
    
    /// Dirty state manager for tracking unsaved changes
    private let dirtyStateManager = DirtyStateManager()
    
    // MARK: - Initialization
    
    init(_ model: T) {
        self.model = model
    }
    
    // MARK: - Public Interface
    
    /// Bind a form field to a model property
    /// - Parameters:
    ///   - fieldName: The name of the form field
    ///   - keyPath: The key path to the model property
    func bind<Value>(_ fieldName: String, to keyPath: WritableKeyPath<T, Value>) {
        let binding = FieldBinding(keyPath: keyPath)
        bindings[fieldName] = binding
        
        // Initialize change tracking with current value
        let currentValue = model[keyPath: keyPath]
        changeTracker.initializeField(fieldName, value: currentValue)
    }
    
    /// Unbind a form field
    /// - Parameter fieldName: The name of the field to unbind
    func unbind(_ fieldName: String) {
        bindings.removeValue(forKey: fieldName)
        changeTracker.removeField(fieldName)
        dirtyStateManager.markFieldClean(fieldName)
    }
    
    /// Update a bound field's value
    /// - Parameters:
    ///   - fieldName: The name of the field to update
    ///   - value: The new value
    func updateField(_ fieldName: String, value: Any) {
        guard let binding = bindings[fieldName] else { return }
        
        // Get old value for change tracking
        let oldValue = binding.getValue(from: model)
        
        // Update the model
        binding.setValue(value, on: &model)
        
        // Track the change
        changeTracker.trackChange(fieldName, oldValue: oldValue, newValue: value)
        
        // Mark as dirty
        dirtyStateManager.markFieldDirty(fieldName)
    }
    
    /// Get the current value of a bound field
    /// - Parameter fieldName: The name of the field
    /// - Returns: The current value, or nil if not bound
    func getBoundValue(_ fieldName: String) -> Any? {
        guard let binding = bindings[fieldName] else { return nil }
        return binding.getValue(from: model)
    }
    
    /// Check if a field is bound
    /// - Parameter fieldName: The name of the field
    /// - Returns: True if the field is bound, false otherwise
    func hasBinding(for fieldName: String) -> Bool {
        return bindings[fieldName] != nil
    }
    
    /// Get the number of active bindings
    var bindingCount: Int {
        return bindings.count
    }
    
    /// Synchronize all changes and return the updated model
    /// - Returns: The updated model with all changes applied
    func sync() -> T {
        return model
    }
    
    /// Get the underlying model
    var underlyingModel: T {
        return model
    }
    
    /// Check if any fields have unsaved changes
    var hasUnsavedChanges: Bool {
        return dirtyStateManager.isDirty
    }
    
    /// Get all fields with unsaved changes
    var dirtyFields: [String] {
        return dirtyStateManager.dirtyFieldNames
    }
    
    /// Get change details for a specific field
    /// - Parameter fieldName: The name of the field
    /// - Returns: Change details if the field has changes, nil otherwise
    func getChangeDetails(for fieldName: String) -> ChangeDetails? {
        return changeTracker.getChangeDetails(for: fieldName)
    }
    
    /// Revert a field to its original value
    /// - Parameter fieldName: The name of the field to revert
    /// - Returns: The original value, or nil if the field has no changes
    func revertField(_ fieldName: String) -> Any? {
        guard let changeDetails = changeTracker.getChangeDetails(for: fieldName) else { return nil }
        
        // Revert the value
        updateField(fieldName, value: changeDetails.oldValue)
        
        // Clear the change tracking
        _ = changeTracker.revertField(fieldName)
        dirtyStateManager.markFieldClean(fieldName)
        
        return changeDetails.oldValue
    }
    
    /// Clear all unsaved changes
    func clearChanges() {
        changeTracker.clearChanges()
        dirtyStateManager.clearAll()
    }
}

// MARK: - Field Binding

/// Type-erased binding for model properties
public class FieldBinding<T> {
    private let getValueClosure: (T) -> Any
    private let setValueClosure: (Any, inout T) -> Void
    
    init<Value>(keyPath: WritableKeyPath<T, Value>) {
        self.getValueClosure = { model in
            return model[keyPath: keyPath]
        }
        
        self.setValueClosure = { value, model in
            if let typedValue = value as? Value {
                model[keyPath: keyPath] = typedValue
            }
        }
    }
    
    func getValue(from model: T) -> Any {
        return getValueClosure(model)
    }
    
    func setValue(_ value: Any, on model: inout T) {
        setValueClosure(value, &model)
    }
}

// MARK: - ChangeTracker

/// Tracks changes to form fields with old and new values
@MainActor
final class ChangeTracker {
    
    // MARK: - Properties
    
    /// Dictionary of field changes keyed by field name
    private var changes: [String: ChangeDetails] = [:]
    
    /// Set of field names that have changes
    private var changedFields: Set<String> = []
    
    // MARK: - Public Interface
    
    /// Check if any fields have changes
    var hasChanges: Bool {
        return !changedFields.isEmpty
    }
    
    /// Get the count of fields with changes
    var changedFieldsCount: Int {
        return changedFields.count
    }
    
    /// Get the total number of changes tracked
    var totalChanges: Int {
        return changes.count
    }
    
    /// Get all field names that have changes
    var changedFieldNames: [String] {
        return Array(changedFields)
    }
    
    /// Initialize tracking for a field
    /// - Parameters:
    ///   - fieldName: The name of the field
    ///   - value: The initial value
    func initializeField(_ fieldName: String, value: Any) {
        // Store initial value for comparison
        changes[fieldName] = ChangeDetails(oldValue: value, newValue: value)
    }
    
    /// Track a change to a field
    /// - Parameters:
    ///   - fieldName: The name of the field
    ///   - oldValue: The previous value
    ///   - newValue: The new value
    func trackChange(_ fieldName: String, oldValue: Any, newValue: Any) {
        changes[fieldName] = ChangeDetails(oldValue: oldValue, newValue: newValue)
        changedFields.insert(fieldName)
    }
    
    /// Get change details for a specific field
    /// - Parameter fieldName: The name of the field
    /// - Returns: Change details if the field has changes, nil otherwise
    func getChangeDetails(for fieldName: String) -> ChangeDetails? {
        return changes[fieldName]
    }
    
    /// Remove tracking for a field
    /// - Parameter fieldName: The name of the field
    func removeField(_ fieldName: String) {
        changes.removeValue(forKey: fieldName)
        changedFields.remove(fieldName)
    }
    
    /// Revert a field's changes
    /// - Parameter fieldName: The name of the field
    /// - Returns: The original value, or nil if no changes
    func revertField(_ fieldName: String) -> Any? {
        guard let changeDetails = changes[fieldName] else { return nil }
        
        // Remove from tracking
        changes.removeValue(forKey: fieldName)
        changedFields.remove(fieldName)
        
        return changeDetails.oldValue
    }
    
    /// Clear all change tracking
    func clearChanges() {
        changes.removeAll()
        changedFields.removeAll()
    }
}

// MARK: - DirtyStateManager

/// Manages the dirty state of form fields (unsaved changes)
@MainActor
final class DirtyStateManager {
    
    // MARK: - Properties
    
    /// Set of field names that are dirty (have unsaved changes)
    private var dirtyFields: Set<String> = []
    
    // MARK: - Public Interface
    
    /// Check if any fields are dirty
    var isDirty: Bool {
        return !dirtyFields.isEmpty
    }
    
    /// Get the count of dirty fields
    var dirtyFieldsCount: Int {
        return dirtyFields.count
    }
    
    /// Get all dirty field names
    var dirtyFieldNames: [String] {
        return Array(dirtyFields)
    }
    
    /// Mark a field as dirty (has unsaved changes)
    /// - Parameter fieldName: The name of the field
    func markFieldDirty(_ fieldName: String) {
        dirtyFields.insert(fieldName)
    }
    
    /// Mark a field as clean (no unsaved changes)
    /// - Parameter fieldName: The name of the field
    func markFieldClean(_ fieldName: String) {
        dirtyFields.remove(fieldName)
    }
    
    /// Check if a specific field is dirty
    /// - Parameter fieldName: The name of the field
    /// - Returns: True if the field is dirty, false otherwise
    func isFieldDirty(_ fieldName: String) -> Bool {
        return dirtyFields.contains(fieldName)
    }
    
    /// Clear all dirty fields
    func clearAll() {
        dirtyFields.removeAll()
    }
    
    /// Get dirty values for all dirty fields
    /// - Returns: Array of dirty field names
    func getDirtyValues() -> [String] {
        return Array(dirtyFields)
    }
}

// MARK: - Supporting Types

/// Represents details about a field change
public struct ChangeDetails {
    /// The previous value of the field
    let oldValue: Any
    
    /// The new value of the field
    let newValue: Any
}
