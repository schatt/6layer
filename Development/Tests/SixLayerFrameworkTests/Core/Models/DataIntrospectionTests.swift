//
//  DataIntrospectionTests.swift
//  SixLayerFrameworkTests
//
//  Tests for the Data Introspection Engine
//

import Testing
import SixLayerFramework

final class DataIntrospectionTests {
    
    // MARK: - Test Data Models
    
    struct SimpleModel {
        let name: String
        let age: Int
        let isActive: Bool
    }
    
    struct ModerateModel {
        let id: UUID
        let title: String
        let description: String
        let createdAt: Date
        let priority: Int
        let tags: [String]
        let metadata: [String: String]
    }
    
    struct ComplexModel {
        let id: UUID
        let name: String
        let email: String
        let phone: String?
        let address: Address
        let preferences: UserPreferences
        let history: [Transaction]
        let attachments: [Attachment]
        let relationships: [User]
        let settings: Settings
    }
    
    struct Address {
        let street: String
        let city: String
        let state: String
        let zipCode: String
        let country: String
    }
    
    struct UserPreferences {
        let theme: String
        let notifications: Bool
        let privacy: PrivacyLevel
    }
    
    enum PrivacyLevel: String {
        case `public`, `private`, friends
    }
    
    struct Transaction {
        let id: UUID
        let amount: Double
        let date: Date
        let description: String
    }
    
    struct Attachment {
        let id: UUID
        let filename: String
        let size: Int
        let type: String
    }
    
    struct User {
        let id: UUID
        let name: String
        let email: String
    }
    
    struct Settings {
        let autoSave: Bool
        let syncInterval: Int
        let maxFileSize: Int
    }
    
    // MARK: - Basic Analysis Tests
    
    @Test func testSimpleModelAnalysis() {
        let model = SimpleModel(name: "John", age: 30, isActive: true)
        let analysis = DataIntrospectionEngine.analyze(model)
        
        #expect(analysis.fields.count == 3)
        #expect(analysis.complexity == .simple)
        #expect(!analysis.patterns.hasMedia)
        #expect(!analysis.patterns.hasDates)
        #expect(!analysis.patterns.hasRelationships)
        #expect(!analysis.patterns.isHierarchical)
        
        // Check field types
        let fieldTypes = analysis.fields.map { $0.type }
        #expect(fieldTypes.contains(.string))
        #expect(fieldTypes.contains(.number))
        #expect(fieldTypes.contains(.boolean))
    }
    
    @Test func testModerateModelAnalysis() {
        let model = ModerateModel(
            id: UUID(),
            title: "Test Title",
            description: "Test Description",
            createdAt: Date(),
            priority: 5,
            tags: ["tag1", "tag2"],
            metadata: ["key1": "value1"]
        )
        let analysis = DataIntrospectionEngine.analyze(model)
        
        #expect(analysis.fields.count == 7)
        #expect(analysis.complexity == .moderate)
        #expect(!analysis.patterns.hasMedia)
        #expect(analysis.patterns.hasDates)
        #expect(!analysis.patterns.hasRelationships)
        #expect(analysis.patterns.isHierarchical) // Due to arrays
    }
    
    @Test func testComplexModelAnalysis() {
        let model = ComplexModel(
            id: UUID(),
            name: "John Doe",
            email: "john@example.com",
            phone: "+1234567890",
            address: Address(street: "123 Main St", city: "Anytown", state: "CA", zipCode: "12345", country: "USA"),
            preferences: UserPreferences(theme: "dark", notifications: true, privacy: .private),
            history: [Transaction(id: UUID(), amount: 100.0, date: Date(), description: "Test")],
            attachments: [Attachment(id: UUID(), filename: "test.pdf", size: 1024, type: "pdf")],
            relationships: [User(id: UUID(), name: "Jane", email: "jane@example.com")],
            settings: Settings(autoSave: true, syncInterval: 300, maxFileSize: 1048576)
        )
        let analysis = DataIntrospectionEngine.analyze(model)
        
        #expect(analysis.fields.count >= 10)
        #expect(analysis.complexity == .complex || analysis.complexity == .veryComplex)

        
        #expect(!analysis.patterns.hasMedia) // No actual image/document types
        #expect(analysis.patterns.hasDates)
        #expect(analysis.patterns.hasRelationships)
        #expect(analysis.patterns.isHierarchical)
    }
    
    // MARK: - Collection Analysis Tests
    
    @Test func testEmptyCollectionAnalysis() {
        let items: [SimpleModel] = []
        let analysis = DataIntrospectionEngine.analyzeCollection(items)
        
        #expect(analysis.itemCount == 0)
        #expect(analysis.collectionType == .empty)
        #expect(analysis.recommendations.count == 0)
    }
    
    @Test func testSmallCollectionAnalysis() {
        let items = [
            SimpleModel(name: "Item 1", age: 25, isActive: true),
            SimpleModel(name: "Item 2", age: 30, isActive: false),
            SimpleModel(name: "Item 3", age: 35, isActive: true)
        ]
        let analysis = DataIntrospectionEngine.analyzeCollection(items)
        
        #expect(analysis.itemCount == 3)
        #expect(analysis.collectionType == .small)
        #expect(analysis.itemComplexity == .simple)
        #expect(analysis.recommendations.count > 0)
    }
    
    @Test func testLargeCollectionAnalysis() {
        let items = Array(0..<150).map { index in
            SimpleModel(name: "Item \(index)", age: 20 + index, isActive: index % 2 == 0)
        }
        let analysis = DataIntrospectionEngine.analyzeCollection(items)
        
        #expect(analysis.itemCount == 150)
        #expect(analysis.collectionType == .large)
        #expect(analysis.itemComplexity == .simple)
        
        // Should have performance recommendations
        let performanceRecommendations = analysis.recommendations.filter { $0.type == .performance }
        #expect(performanceRecommendations.count > 0)
    }
    
    // MARK: - Field Type Detection Tests
    
    @Test func testFieldTypeDetection() {
        let model = ModerateModel(
            id: UUID(),
            title: "Test",
            description: "Description",
            createdAt: Date(),
            priority: 5,
            tags: ["tag1"],
            metadata: ["key": "value"]
        )
        let analysis = DataIntrospectionEngine.analyze(model)
        
        // Check specific field types
        let idField = analysis.fields.first { $0.name == "id" }
        #expect(idField != nil)
        #expect(idField?.type == .uuid)
        
        let titleField = analysis.fields.first { $0.name == "title" }
        #expect(titleField != nil)
        #expect(titleField?.type == .string)
        
        let priorityField = analysis.fields.first { $0.name == "priority" }
        #expect(priorityField != nil)
        #expect(priorityField?.type == .number)
        
        let tagsField = analysis.fields.first { $0.name == "tags" }
        #expect(tagsField != nil)
        #expect(tagsField?.isArray == true)
    }
    
    // MARK: - Utility Method Tests
    
    @Test func testGetAnalysisSummary() {
        let model = SimpleModel(name: "Test", age: 25, isActive: true)
        let summary = DataIntrospectionEngine.getAnalysisSummary(model)
        
        #expect(summary.contains("Data Analysis Summary"))
        #expect(summary.contains("Fields: 3"))
        #expect(summary.contains("Complexity: simple"))
    }
    
    @Test func testGetFieldNames() {
        let model = SimpleModel(name: "Test", age: 25, isActive: true)
        let fieldNames = DataIntrospectionEngine.getFieldNames(model)
        
        #expect(fieldNames.count == 3)
        #expect(fieldNames.contains("name"))
        #expect(fieldNames.contains("age"))
        #expect(fieldNames.contains("isActive"))
    }
    
    @Test func testHasFieldType() {
        let model = ModerateModel(
            id: UUID(),
            title: "Test",
            description: "Description",
            createdAt: Date(),
            priority: 5,
            tags: ["tag1"],
            metadata: ["key": "value"]
        )
        
        #expect(DataIntrospectionEngine.hasFieldType(model, type: .string))
        #expect(DataIntrospectionEngine.hasFieldType(model, type: .number))
        #expect(DataIntrospectionEngine.hasFieldType(model, type: .uuid))
        #expect(!DataIntrospectionEngine.hasFieldType(model, type: .image))
    }
    
    @Test func testGetFieldsOfType() {
        let model = ModerateModel(
            id: UUID(),
            title: "Test",
            description: "Description",
            createdAt: Date(),
            priority: 5,
            tags: ["tag1"],
            metadata: ["key": "value"]
        )
        
        let stringFields = DataIntrospectionEngine.getFieldsOfType(model, type: .string)
        #expect(stringFields.count > 0)
        
        let numberFields = DataIntrospectionEngine.getFieldsOfType(model, type: .number)
        #expect(numberFields.count > 0)
        
        let uuidFields = DataIntrospectionEngine.getFieldsOfType(model, type: .uuid)
        #expect(uuidFields.count == 1)
    }
    
    // MARK: - Recommendation Tests
    
    @Test func testRecommendationsForSimpleModel() {
        let model = SimpleModel(name: "Test", age: 25, isActive: true)
        let analysis = DataIntrospectionEngine.analyze(model)
        
        #expect(analysis.recommendations.count > 0)
        
        let layoutRecommendations = analysis.recommendations.filter { $0.type == .layout }
        #expect(layoutRecommendations.count > 0)
        
        // Simple models should recommend compact layouts
        let compactRecommendation = layoutRecommendations.first { $0.description.contains("compact") }
        #expect(compactRecommendation != nil)
    }
    
    @Test func testRecommendationsForComplexModel() {
        let model = ComplexModel(
            id: UUID(),
            name: "John Doe",
            email: "john@example.com",
            phone: "+1234567890",
            address: Address(street: "123 Main St", city: "Anytown", state: "CA", zipCode: "12345", country: "USA"),
            preferences: UserPreferences(theme: "dark", notifications: true, privacy: .private),
            history: [Transaction(id: UUID(), amount: 100.0, date: Date(), description: "Test")],
            attachments: [Attachment(id: UUID(), filename: "test.pdf", size: 1024, type: "pdf")],
            relationships: [User(id: UUID(), name: "Jane", email: "jane@example.com")],
            settings: Settings(autoSave: true, syncInterval: 300, maxFileSize: 1048576)
        )
        let analysis = DataIntrospectionEngine.analyze(model)
        
        #expect(analysis.recommendations.count > 0)
        
        let layoutRecommendations = analysis.recommendations.filter { $0.type == .layout }
        #expect(layoutRecommendations.count > 0)
        
        // Complex models should recommend tabbed or master-detail layouts
        let tabbedRecommendation = layoutRecommendations.first { $0.description.contains("tabbed") || $0.description.contains("master-detail") }
        #expect(tabbedRecommendation != nil)
    }
    
    // MARK: - Edge Case Tests
    
    @Test func testEmptyStruct() {
        struct EmptyStruct {}
        let model = EmptyStruct()
        let analysis = DataIntrospectionEngine.analyze(model)
        
        #expect(analysis.fields.count == 0)
        #expect(analysis.complexity == .simple)
    }
    
    @Test func testOptionalFields() {
        struct OptionalModel {
            let name: String?
            let age: Int?
            let isActive: Bool?
        }
        let model = OptionalModel(name: "Test", age: 25, isActive: true)
        let analysis = DataIntrospectionEngine.analyze(model)
        
        #expect(analysis.fields.count == 3)
        // Note: Our current implementation doesn't detect optionals perfectly
        // This test documents the current behavior
    }
    
    @Test func testIdentifiableDetection() {
        struct IdentifiableModel: Identifiable {
            let id = UUID()
            let name: String
        }
        let model = IdentifiableModel(name: "Test")
        let analysis = DataIntrospectionEngine.analyze(model)
        
        #expect(analysis.fields.count == 2)
        // Check if we detect the id field
        let idField = analysis.fields.first { $0.name == "id" }
        #expect(idField != nil)
        #expect(idField?.type == .uuid)
    }
}
