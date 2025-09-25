//
//  DataBindingTests.swift
//  SixLayerFrameworkTests
//
//  BUSINESS PURPOSE:
//  Validates the data binding system that enables two-way communication between UI components
//  and underlying data models, ensuring proper state synchronization and change tracking.
//
//  TESTING SCOPE:
//  - DataBinder initialization and configuration
//  - Field binding establishment and validation
//  - Two-way data synchronization between UI and model
//  - Change tracking and dirty state management
//  - Field update propagation and validation
//  - Model synchronization and state consistency
//
//  METHODOLOGY:
//  - Test DataBinder initialization with various model types
//  - Verify field binding creation and management
//  - Test bidirectional data flow between UI and model
//  - Validate change tracking and dirty state detection
//  - Test field update propagation and model synchronization
//  - Verify data consistency across binding operations
//
//  QUALITY ASSESSMENT: ✅ GOOD
//  - ✅ Good: Tests actual business logic (data binding behavior, change tracking)
//  - ✅ Good: Verifies two-way data synchronization functionality
//  - ✅ Good: Tests state management and change detection
//  - ✅ Good: Validates model synchronization behavior
//  - 🔧 Minor: Could add more edge cases and error scenarios
//

import XCTest
import SwiftUI
@testable import SixLayerFramework

@MainActor
final class DataBindingTests: XCTestCase {
    
    // MARK: - DataBinder Tests
    
    func testDataBinderInitialization() {
        let testModel = TestModel(name: "John", age: 30, isActive: true)
        let binder = DataBinder(testModel)
        
        // Verify initial state using public properties
        XCTAssertEqual(binder.underlyingModel.name, "John")
        XCTAssertEqual(binder.underlyingModel.age, 30)
        XCTAssertTrue(binder.underlyingModel.isActive)
    }
    
    func testDataBinderBindField() {
        let testModel = TestModel(name: "John", age: 30, isActive: true)
        let binder = DataBinder(testModel)
        
        // Bind a field
        binder.bind("name", to: \TestModel.name)
        
        // Verify binding is established
        XCTAssertTrue(binder.hasBinding(for: "name"))
        XCTAssertEqual(binder.getBoundValue("name") as? String, "John")
    }
    
    func testDataBinderUpdateField() {
        let testModel = TestModel(name: "John", age: 30, isActive: true)
        let binder = DataBinder(testModel)
        binder.bind("name", to: \TestModel.name)
        
        // Update the field
        binder.updateField("name", value: "Jane")
        
        // Verify model is updated through the binder
        XCTAssertEqual(binder.getBoundValue("name") as? String, "Jane")
        XCTAssertEqual(binder.underlyingModel.name, "Jane")
        
        // Verify change tracking
        XCTAssertTrue(binder.hasUnsavedChanges)
        XCTAssertTrue(binder.dirtyFields.contains("name"))
    }
    
    func testDataBinderSyncToModel() {
        let testModel = TestModel(name: "John", age: 30, isActive: true)
        let binder = DataBinder(testModel)
        binder.bind("name", to: \TestModel.name)
        binder.bind("age", to: \TestModel.age)
        
        // Update fields
        binder.updateField("name", value: "Jane")
        binder.updateField("age", value: 25)
        
        // Sync to get updated model
        let updatedModel = binder.sync()
        
        // Verify model is updated
        XCTAssertEqual(updatedModel.name, "Jane")
        XCTAssertEqual(updatedModel.age, 25)
        XCTAssertEqual(updatedModel.isActive, true) // Unchanged
    }
    
    func testDataBinderMultipleBindings() {
        let testModel = TestModel(name: "John", age: 30, isActive: true)
        let binder = DataBinder(testModel)
        
        // Bind multiple fields
        binder.bind("name", to: \TestModel.name)
        binder.bind("age", to: \TestModel.age)
        binder.bind("isActive", to: \TestModel.isActive)
        
        // Verify all bindings exist
        XCTAssertTrue(binder.hasBinding(for: "name"))
        XCTAssertTrue(binder.hasBinding(for: "age"))
        XCTAssertTrue(binder.hasBinding(for: "isActive"))
        XCTAssertEqual(binder.bindingCount, 3)
    }
    
    func testDataBinderUnbindField() {
        let testModel = TestModel(name: "John", age: 30, isActive: true)
        let binder = DataBinder(testModel)
        binder.bind("name", to: \TestModel.name)
        
        // Verify binding exists
        XCTAssertTrue(binder.hasBinding(for: "name"))
        
        // Unbind the field
        binder.unbind("name")
        
        // Verify binding is removed
        XCTAssertFalse(binder.hasBinding(for: "name"))
        XCTAssertEqual(binder.bindingCount, 0)
    }
    
    // MARK: - ChangeTracker Tests
    
    func testChangeTrackerInitialization() {
        let tracker = ChangeTracker()
        
        // Verify initial state
        XCTAssertFalse(tracker.hasChanges)
        XCTAssertEqual(tracker.changedFieldNames.count, 0)
        XCTAssertEqual(tracker.totalChanges, 0)
    }
    
    func testChangeTrackerTrackChange() {
        let tracker = ChangeTracker()
        
        // Track a change
        tracker.trackChange("name", oldValue: "John", newValue: "Jane")
        
        // Verify change is tracked
        XCTAssertTrue(tracker.hasChanges)
        XCTAssertEqual(tracker.changedFieldNames.count, 1)
        XCTAssertEqual(tracker.totalChanges, 1)
        XCTAssertTrue(tracker.changedFieldNames.contains("name"))
    }
    
    func testChangeTrackerTrackMultipleChanges() {
        let tracker = ChangeTracker()
        
        // Track multiple changes
        tracker.trackChange("name", oldValue: "John", newValue: "Jane")
        tracker.trackChange("age", oldValue: 30, newValue: 25)
        
        // Verify all changes are tracked
        XCTAssertTrue(tracker.hasChanges)
        XCTAssertEqual(tracker.changedFieldNames.count, 2)
        XCTAssertEqual(tracker.totalChanges, 2)
        XCTAssertTrue(tracker.changedFieldNames.contains("name"))
        XCTAssertTrue(tracker.changedFieldNames.contains("age"))
    }
    
    func testChangeTrackerGetChangeDetails() {
        let tracker = ChangeTracker()
        tracker.trackChange("name", oldValue: "John", newValue: "Jane")
        
        // Get change details
        let changeDetails = tracker.getChangeDetails(for: "name")
        
        // Verify change details
        XCTAssertNotNil(changeDetails)
        XCTAssertEqual(changeDetails?.oldValue as? String, "John")
        XCTAssertEqual(changeDetails?.newValue as? String, "Jane")
    }
    
    func testChangeTrackerClearChanges() {
        let tracker = ChangeTracker()
        tracker.trackChange("name", oldValue: "John", newValue: "Jane")
        
        // Verify changes exist
        XCTAssertTrue(tracker.hasChanges)
        
        // Clear changes
        tracker.clearChanges()
        
        // Verify changes are cleared
        XCTAssertFalse(tracker.hasChanges)
        XCTAssertEqual(tracker.changedFieldNames.count, 0)
        XCTAssertEqual(tracker.totalChanges, 0)
    }
    
    func testChangeTrackerRevertField() {
        let tracker = ChangeTracker()
        tracker.trackChange("name", oldValue: "John", newValue: "Jane")
        
        // Verify change is tracked
        XCTAssertTrue(tracker.changedFieldNames.contains("name"))
        
        // Revert the field
        let revertedValue = tracker.revertField("name")
        
        // Verify field is reverted
        XCTAssertEqual(revertedValue as? String, "John")
        XCTAssertFalse(tracker.changedFieldNames.contains("name"))
    }
    
    // MARK: - DirtyStateManager Tests
    
    func testDirtyStateManagerInitialization() {
        let manager = DirtyStateManager()
        
        // Verify initial state
        XCTAssertFalse(manager.isDirty)
        XCTAssertEqual(manager.dirtyFieldNames.count, 0)
    }
    
    func testDirtyStateManagerMarkFieldDirty() {
        let manager = DirtyStateManager()
        
        // Mark field as dirty
        manager.markFieldDirty("name")
        
        // Verify dirty state
        XCTAssertTrue(manager.isDirty)
        XCTAssertEqual(manager.dirtyFieldNames.count, 1)
        XCTAssertTrue(manager.dirtyFieldNames.contains("name"))
    }
    
    func testDirtyStateManagerMarkFieldClean() {
        let manager = DirtyStateManager()
        manager.markFieldDirty("name")
        
        // Verify field is dirty
        XCTAssertTrue(manager.isDirty)
        
        // Mark field as clean
        manager.markFieldClean("name")
        
        // Verify field is clean
        XCTAssertFalse(manager.isDirty)
        XCTAssertEqual(manager.dirtyFieldNames.count, 0)
    }
    
    func testDirtyStateManagerMultipleFields() {
        let manager = DirtyStateManager()
        
        // Mark multiple fields as dirty
        manager.markFieldDirty("name")
        manager.markFieldDirty("age")
        
        // Verify dirty state
        XCTAssertTrue(manager.isDirty)
        XCTAssertEqual(manager.dirtyFieldNames.count, 2)
        XCTAssertTrue(manager.dirtyFieldNames.contains("name"))
        XCTAssertTrue(manager.dirtyFieldNames.contains("age"))
        
        // Mark one field clean
        manager.markFieldClean("name")
        
        // Verify partial clean state
        XCTAssertTrue(manager.isDirty) // Still dirty because age is dirty
        XCTAssertEqual(manager.dirtyFieldNames.count, 1)
        XCTAssertFalse(manager.dirtyFieldNames.contains("name"))
        XCTAssertTrue(manager.dirtyFieldNames.contains("age"))
    }
    
    func testDirtyStateManagerClearAll() {
        let manager = DirtyStateManager()
        manager.markFieldDirty("name")
        manager.markFieldDirty("age")
        
        // Verify dirty state
        XCTAssertTrue(manager.isDirty)
        
        // Clear all dirty fields
        manager.clearAll()
        
        // Verify clean state
        XCTAssertFalse(manager.isDirty)
        XCTAssertEqual(manager.dirtyFieldNames.count, 0)
    }
    
    func testDirtyStateManagerGetDirtyValues() {
        let manager = DirtyStateManager()
        manager.markFieldDirty("name")
        manager.markFieldDirty("age")
        
        // Get dirty values
        let dirtyValues = manager.getDirtyValues()
        
        // Verify dirty values
        XCTAssertEqual(dirtyValues.count, 2)
        XCTAssertTrue(dirtyValues.contains("name"))
        XCTAssertTrue(dirtyValues.contains("age"))
    }
}

// MARK: - Test Data Models

struct TestModel {
    var name: String
    var age: Int
    var isActive: Bool
}

// MARK: - Test Change Details

struct ChangeDetails {
    let oldValue: Any
    let newValue: Any
}
