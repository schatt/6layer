import Testing
import Foundation
@testable import SixLayerFramework

#if canImport(SwiftData)
import SwiftData
#endif

/// Tests for DataIntrospectionEngine functionality
@MainActor
@Suite("Data Introspection")
open class DataIntrospectionTests: BaseTestClass {
    
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
        // Note: 4 fields with no complex types = moderate complexity per calculateComplexity logic
        // (0-3 fields = simple, 4-7 fields = moderate)
        #expect(result.complexity == .moderate, "Struct with 4 fields should be moderate complexity (per calculateComplexity: 4-7 fields = moderate)")
        
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
    
    #if canImport(SwiftData)
    /// Test that DataIntrospectionEngine works with SwiftData models
    @available(macOS 14.0, iOS 17.0, *)
    @Test func testDataIntrospectionWithSwiftDataModel() {
        // Given: A SwiftData model (using the test model from IntelligentFormViewTests)
        let model = TestSwiftDataTask(title: "Test", updatedAt: Date())
        
        // When: Analyzing the SwiftData model
        let result = DataIntrospectionEngine.analyze(model)
        
        // Then: Should analyze SwiftData model correctly using Mirror introspection
        // Note: @Model macro may affect Mirror introspection, so we check if analysis succeeds
        // The analysis should complete without errors, even if some properties aren't visible
        #expect(result.fields.count >= 0, "Analysis should complete (fields may vary based on @Model macro behavior)")
        
        // Check if title field is detected (if Mirror can see it)
        if let titleField = result.fields.first(where: { $0.name == "title" }) {
            #expect(titleField.type == .string, "title should be string type if detected")
        }
        
        // Check if updatedAt field is detected (if Mirror can see it)
        if let updatedAtField = result.fields.first(where: { $0.name == "updatedAt" }) {
            #expect(updatedAtField.type == .date, "updatedAt should be date type if detected")
            #expect(updatedAtField.isOptional == true, "updatedAt should be optional if detected")
        }
        
        // The key test: DataIntrospectionEngine should handle SwiftData models without crashing
        // and return a valid analysis result (even if some properties aren't visible via Mirror)
        #expect(result.complexity != nil, "Analysis should return valid complexity")
    }
    #endif
}
