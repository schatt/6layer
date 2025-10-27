import Testing
import CoreData
@testable import SixLayerFramework

/// TDD Tests for Core Data Introspection Bug
///
/// FOLLOWING PROPER TDD:
/// 1. RED: This test SHOULD FAIL now (demonstrates the bug)
/// 2. GREEN: Implement fix to make test pass
/// 3. REFACTOR: Clean up if needed
///
/// THE BUG: Mirror cannot see @NSManaged properties, so analysis returns empty fields
/// EXPECTED: Should detect Core Data entity properties using NSEntityDescription

@MainActor
struct DataIntrospectionCoreDataTests {
    
    /// RED TEST: This test documents that Core Data entities return empty field analysis
    /// This is the bug - when fixed, this test should pass (detecting title field)
    @Test func testCoreDataEntityReturnsEmptyAnalysis() throws {
        // GIVEN: A Core Data managed object with properties
        let model = NSManagedObjectModel()
        
        let taskEntity = NSEntityDescription()
        taskEntity.name = "Task"
        
        let titleAttribute = NSAttributeDescription()
        titleAttribute.name = "title"
        titleAttribute.attributeType = .stringAttributeType
        titleAttribute.isOptional = true
        
        taskEntity.properties = [titleAttribute]
        model.entities = [taskEntity]
        
        let container = NSPersistentContainer(name: "TestModel", managedObjectModel: model)
        container.persistentStoreDescriptions = [{
            let desc = NSPersistentStoreDescription()
            desc.type = NSInMemoryStoreType
            desc.shouldAddStoreAsynchronously = false
            return desc
        }()]
        container.loadPersistentStores { _, _ in }
        
        let context = container.viewContext
        let task = NSManagedObject(entity: taskEntity, insertInto: context)
        task.setValue("Test Title", forKey: "title")
        
        // WHEN: We analyze the Core Data entity
        let analysis = DataIntrospectionEngine.analyze(task)
        
        // THEN: The bug causes this to return 0 fields (Mirror can't see @NSManaged properties)
        // After fix: Should detect 1 field (title)
        let hasTitleField = analysis.fields.contains { $0.name == "title" }
        
        // THIS TEST WILL FAIL (RED) - documents the bug exists
        #expect(hasTitleField, "BUG: DataIntrospectionEngine should detect Core Data properties. Found \(analysis.fields.count) fields.")
    }
}

