import Testing
import Foundation
@testable import SixLayerFramework

/// Tests for DataIntrospectionEngine functionality
@MainActor
open class DataIntrospectionTests {
    
    @Test func testDataIntrospectionBasicAnalysis() {
        // Given: A simple test struct
        struct TestData {
            let id = UUID()
            let name = "Test"
            let value = 42
            let isActive = true
        }
        
        // When: Analyzing the data
        let result = DataIntrospectionEngine.analyze(TestData())
        
        // Then: Should have analyzed fields correctly
        #expect(result.fields.count == 4, "Should detect 4 fields")
        #expect(result.complexity == .simple, "Simple struct should be simple complexity")
        
        // Check field types
        let idField = result.fields.first { $0.name == "id" }
        let nameField = result.fields.first { $0.name == "name" }
        let valueField = result.fields.first { $0.name == "value" }
        let isActiveField = result.fields.first { $0.name == "isActive" }
        
        #expect(idField?.type == .uuid, "id should be UUID type")
        #expect(nameField?.type == .string, "name should be string type")
        #expect(valueField?.type == .number, "value should be number type")
        #expect(isActiveField?.type == .boolean, "isActive should be boolean type")
    }
    
    @Test func testDataIntrospectionWithOptionalFields() {
        // Given: A struct with optional fields
        struct TestData {
            let name: String
            let age: Int?
            let email: String?
        }
        
        // When: Analyzing the data
        let result = DataIntrospectionEngine.analyze(TestData(name: "John", age: 25, email: nil))
        
        // Then: Should detect optionals correctly
        let ageField = result.fields.first { $0.name == "age" }
        let emailField = result.fields.first { $0.name == "email" }
        
        #expect(ageField?.isOptional == true, "Optional Int should be detected as optional")
        #expect(emailField?.isOptional == true, "Optional String should be detected as optional")
        #expect(result.fields.first { $0.name == "name" }?.isOptional == false, "Non-optional field should not be optional")
    }
    
    @Test func testDataIntrospectionCollectionAnalysis() {
        // Given: A collection of items
        struct Item {
            let id = UUID()
            let title = "Item"
        }
        
        let items = [Item(), Item(), Item()]
        
        // When: Analyzing the collection
        let result = DataIntrospectionEngine.analyzeCollection(items)
        
        // Then: Should analyze collection correctly
        #expect(result.itemCount == 3, "Should count 3 items")
        #expect(result.collectionType == .small, "3 items should be small collection")
        #expect(result.itemComplexity == .simple, "Simple items should have simple complexity")
    }
    
    @Test func testDataIntrospectionUtilityMethods() {
        // Given: Test data
        struct TestData {
            let id = UUID()
            let name = "Test"
            let value = 42
        }
        
        // When: Using utility methods
        let fieldNames = DataIntrospectionEngine.getFieldNames(TestData())
        let hasStringField = DataIntrospectionEngine.hasFieldType(TestData(), type: .string)
        let hasDateField = DataIntrospectionEngine.hasFieldType(TestData(), type: .date)
        
        // Then: Utility methods should work correctly
        #expect(fieldNames.contains("name"), "Should contain name field")
        #expect(fieldNames.contains("value"), "Should contain value field")
        #expect(fieldNames.contains("id"), "Should contain id field")
        #expect(hasStringField == true, "Should detect string field")
        #expect(hasDateField == false, "Should not detect date field")
    }
}
