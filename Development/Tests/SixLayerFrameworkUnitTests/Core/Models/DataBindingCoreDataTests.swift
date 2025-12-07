//
//  DataBindingCoreDataTests.swift
//  SixLayerFrameworkTests
//
//  TDD Tests for CoreData binding support in DataBinder
//  Addresses Issue #72: IntelligentFormView DataBinder doesn't work with CoreData @NSManaged properties
//
//  FOLLOWING PROPER TDD:
//  1. RED: Test fails when bug exists (KVC binding not implemented)
//  2. GREEN: Test passes after fix (KVC binding implemented)
//  3. REFACTOR: Clean up if needed
//

import Testing
import CoreData
@testable import SixLayerFramework

@Suite("Data Binding Core Data")
/// NOTE: Not marked @MainActor on class to allow parallel execution
struct DataBindingCoreDataTests {
    
    /// BUSINESS PURPOSE: Verify DataBinder can bind to CoreData entities using KVC
    /// TESTING SCOPE: Tests KVC-based binding for @NSManaged properties
    /// METHODOLOGY: Create CoreData entity, bind using KVC method, verify updates work
    @Test @MainActor func testCoreDataBindingWithKVC() throws {
        // GIVEN: A Core Data managed object with @NSManaged properties
        let model = NSManagedObjectModel()
        
        let taskEntity = NSEntityDescription()
        taskEntity.name = "Task"
        
        let titleAttribute = NSAttributeDescription()
        titleAttribute.name = "title"
        titleAttribute.attributeType = .stringAttributeType
        titleAttribute.isOptional = true
        
        let statusAttribute = NSAttributeDescription()
        statusAttribute.name = "status"
        statusAttribute.attributeType = .stringAttributeType
        statusAttribute.isOptional = true
        
        taskEntity.properties = [titleAttribute, statusAttribute]
        model.entities = [taskEntity]
        
        let container = CoreDataTestUtilities.createIsolatedTestContainer(
            name: "TestModel",
            managedObjectModel: model
        )
        
        let context = container.viewContext
        let task = NSManagedObject(entity: taskEntity, insertInto: context)
        task.setValue("Initial Title", forKey: "title")
        task.setValue("pending", forKey: "status")
        
        // WHEN: Binding using KVC method (for CoreData entities)
        let binder = DataBinder(task)
        binder.bindKVC("title")
        binder.bindKVC("status")
        
        // THEN: Verify bindings are established
        #expect(binder.hasBinding(for: "title"))
        #expect(binder.hasBinding(for: "status"))
        #expect(binder.getBoundValue("title") as? String == "Initial Title")
        #expect(binder.getBoundValue("status") as? String == "pending")
        
        // WHEN: Updating fields through binder
        binder.updateField("title", value: "Updated Title")
        binder.updateField("status", value: "completed")
        
        // THEN: Verify values are updated in the model
        #expect(binder.getBoundValue("title") as? String == "Updated Title")
        #expect(binder.getBoundValue("status") as? String == "completed")
        #expect(task.value(forKey: "title") as? String == "Updated Title")
        #expect(task.value(forKey: "status") as? String == "completed")
        
        // Verify change tracking works
        #expect(binder.hasUnsavedChanges)
        #expect(binder.dirtyFields.contains("title"))
        #expect(binder.dirtyFields.contains("status"))
    }
    
    /// BUSINESS PURPOSE: Verify DataBinder auto-detects CoreData and uses KVC
    /// TESTING SCOPE: Tests automatic CoreData detection and KVC binding
    /// METHODOLOGY: Create CoreData entity, use bindAuto method, verify KVC is used
    @Test @MainActor func testCoreDataAutoDetection() throws {
        // GIVEN: A Core Data managed object
        let model = NSManagedObjectModel()
        
        let taskEntity = NSEntityDescription()
        taskEntity.name = "Task"
        
        let titleAttribute = NSAttributeDescription()
        titleAttribute.name = "title"
        titleAttribute.attributeType = .stringAttributeType
        titleAttribute.isOptional = true
        
        taskEntity.properties = [titleAttribute]
        model.entities = [taskEntity]
        
        let container = CoreDataTestUtilities.createIsolatedTestContainer(
            name: "TestModel",
            managedObjectModel: model
        )
        
        let context = container.viewContext
        let task = NSManagedObject(entity: taskEntity, insertInto: context)
        task.setValue("Initial", forKey: "title")
        
        // WHEN: Using auto-detection binding
        let binder = DataBinder(task)
        binder.bindAuto("title")
        
        // THEN: Verify binding works (should use KVC internally)
        #expect(binder.hasBinding(for: "title"))
        
        // Update and verify
        binder.updateField("title", value: "Auto Updated")
        #expect(task.value(forKey: "title") as? String == "Auto Updated")
    }
    
    /// BUSINESS PURPOSE: Verify regular Swift types still use key paths
    /// TESTING SCOPE: Tests that non-CoreData types continue using WritableKeyPath
    /// METHODOLOGY: Create regular struct, bind using key path, verify it works
    @Test @MainActor func testRegularTypesStillUseKeyPaths() {
        // GIVEN: A regular Swift struct
        struct TestModel {
            var name: String
            var age: Int
        }
        
        let model = TestModel(name: "John", age: 30)
        let binder = DataBinder(model)
        
        // WHEN: Binding using key path (regular Swift type)
        binder.bind("name", to: \TestModel.name)
        binder.bind("age", to: \TestModel.age)
        
        // THEN: Verify bindings work
        #expect(binder.hasBinding(for: "name"))
        #expect(binder.hasBinding(for: "age"))
        
        // Update and verify
        binder.updateField("name", value: "Jane")
        binder.updateField("age", value: 25)
        
        #expect(binder.underlyingModel.name == "Jane")
        #expect(binder.underlyingModel.age == 25)
    }
}
