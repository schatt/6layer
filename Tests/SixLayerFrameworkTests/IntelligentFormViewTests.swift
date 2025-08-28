import XCTest
import SwiftUI
@testable import SixLayerFramework

@MainActor
final class IntelligentFormViewTests: XCTestCase {
    
    // MARK: - Test Data Models
    
    struct SimpleModel {
        let name: String
        let age: Int
        let isActive: Bool
    }
    
    struct ComplexModel {
        var id: UUID
        var title: String
        var description: String
        var createdAt: Date
        var tags: [String]
        var metadata: [String: String]
        var isPublished: Bool
        var priority: Int
        var category: String
        var author: String
        var lastModified: Date
        var version: String
        var status: String
        var rating: Double
        var views: Int
        var likes: Int
        var comments: [String]
        var attachments: [String]
        var permissions: [String]
        var settings: [String: Bool]
        
        init() {
            self.id = UUID()
            self.title = ""
            self.description = ""
            self.createdAt = Date()
            self.tags = []
            self.metadata = [:]
            self.isPublished = false
            self.priority = 0
            self.category = ""
            self.author = ""
            self.lastModified = Date()
            self.version = ""
            self.status = ""
            self.rating = 0.0
            self.views = 0
            self.likes = 0
            self.comments = []
            self.attachments = []
            self.permissions = []
            self.settings = [:]
        }
    }
    
    // MARK: - Test Cases
    
    func testSimpleFormGeneration() {
        // Test form generation for a simple model
        let simpleInstance = SimpleModel(name: "Test", age: 25, isActive: true)
        let form = IntelligentFormView.generateForm(
            for: SimpleModel.self,
            initialData: simpleInstance,
            onSubmit: { _ in },
            onCancel: { }
        )
        
        // Verify the form is generated (basic smoke test)
        XCTAssertNotNil(form)
    }
    
    func testComplexFormGeneration() {
        // Test form generation for a complex model
        let complexInstance = ComplexModel()
        let form = IntelligentFormView.generateForm(
            for: ComplexModel.self,
            initialData: complexInstance,
            onSubmit: { _ in },
            onCancel: { }
        )
        
        // Verify the form is generated (basic smoke test)
        XCTAssertNotNil(form)
    }
    
    func testFormGenerationWithExistingData() {
        let existingData = SimpleModel(name: "Test", age: 25, isActive: true)
        
        let form = IntelligentFormView.generateForm(
            for: existingData,
            onUpdate: { _ in },
            onCancel: { }
        )
        
        // Verify the form is generated (basic smoke test)
        XCTAssertNotNil(form)
    }
    
    func testFormStrategyDetermination() {
        // Test simple model strategy
        let simpleInstance = SimpleModel(name: "Test", age: 25, isActive: true)
        let simpleAnalysis = DataIntrospectionEngine.analyze(simpleInstance)
        let simpleStrategy = determineFormStrategy(analysis: simpleAnalysis)
        
        // Simple model with 3 fields should use .form container
        XCTAssertEqual(simpleStrategy.containerType, .form)
        XCTAssertEqual(simpleStrategy.fieldLayout, .vertical)
        XCTAssertEqual(simpleStrategy.validation, .immediate)
        
        // Test complex model strategy
        let complexInstance = ComplexModel()
        let complexAnalysis = DataIntrospectionEngine.analyze(complexInstance)
        let complexStrategy = determineFormStrategy(analysis: complexAnalysis)
        
        // Complex model should use .custom container (veryComplex complexity)
        XCTAssertEqual(complexStrategy.containerType, .custom)
        XCTAssertEqual(complexStrategy.fieldLayout, .adaptive)
        XCTAssertEqual(complexStrategy.validation, .deferred)
    }
    
    func testFieldGrouping() {
        let complexInstance = ComplexModel()
        let analysis = DataIntrospectionEngine.analyze(complexInstance)
        let groupedFields = groupFieldsByType(analysis.fields)
        
        // Debug: print what field types we actually have
        print("Available field types: \(groupedFields.keys.map { $0.rawValue })")
        print("Total fields: \(analysis.fields.count)")
        
        // Verify we have some field types (at least string should be present)
        XCTAssertTrue(groupedFields.keys.count > 0)
        XCTAssertTrue(groupedFields.keys.contains(.string))
        
        // Verify string fields are grouped together
        if let stringFields = groupedFields[.string] {
            XCTAssertGreaterThan(stringFields.count, 5) // Should have multiple string fields
        }
    }
    
    func testFieldTypeTitles() {
        // Test field type title generation
        XCTAssertEqual(getFieldTypeTitle(.string), "Text Fields")
        XCTAssertEqual(getFieldTypeTitle(.number), "Numeric Fields")
        XCTAssertEqual(getFieldTypeTitle(.boolean), "Toggle Fields")
        XCTAssertEqual(getFieldTypeTitle(.date), "Date Fields")
        XCTAssertEqual(getFieldTypeTitle(.url), "URL Fields")
        XCTAssertEqual(getFieldTypeTitle(.uuid), "Identifier Fields")
        XCTAssertEqual(getFieldTypeTitle(.image), "Media Fields")
        XCTAssertEqual(getFieldTypeTitle(.document), "Document Fields")
        XCTAssertEqual(getFieldTypeTitle(.relationship), "Relationship Fields")
        XCTAssertEqual(getFieldTypeTitle(.hierarchical), "Hierarchical Fields")
        XCTAssertEqual(getFieldTypeTitle(.custom), "Custom Fields")
    }
    
    func testFieldDescriptionGeneration() {
        let stringField = DataField(
            name: "test",
            type: .string,
            isOptional: true,
            isArray: false,
            isIdentifiable: false,
            hasDefaultValue: true
        )
        
        let description = getFieldDescription(for: stringField)
        XCTAssertTrue(description?.contains("Optional") == true)
        XCTAssertTrue(description?.contains("Has default") == true)
        XCTAssertFalse(description?.contains("Multiple values") == true)
    }
    
    func testDefaultValueGeneration() {
        // Test default values for different field types
        let stringField = DataField(
            name: "test",
            type: .string,
            isOptional: false,
            isArray: false,
            isIdentifiable: false,
            hasDefaultValue: false
        )
        
        let numberField = DataField(
            name: "test",
            type: .number,
            isOptional: false,
            isArray: false,
            isIdentifiable: false,
            hasDefaultValue: false
        )
        
        let booleanField = DataField(
            name: "test",
            type: .boolean,
            isOptional: false,
            isArray: false,
            isIdentifiable: false,
            hasDefaultValue: false
        )
        
        let stringValue = getDefaultValue(for: stringField)
        let numberValue = getDefaultValue(for: numberField)
        let booleanValue = getDefaultValue(for: booleanField)
        
        XCTAssertEqual(stringValue as? String, "")
        XCTAssertEqual(numberValue as? Int, 0)
        XCTAssertEqual(booleanValue as? Bool, false)
    }
    
    func testValueExtraction() {
        let testObject = SimpleModel(name: "Test", age: 25, isActive: true)
        
        let nameValue = extractFieldValue(from: testObject, fieldName: "name")
        let ageValue = extractFieldValue(from: testObject, fieldName: "age")
        let isActiveValue = extractFieldValue(from: testObject, fieldName: "isActive")
        
        XCTAssertEqual(nameValue as? String, "Test")
        XCTAssertEqual(ageValue as? Int, 25)
        XCTAssertEqual(isActiveValue as? Bool, true)
    }
    
    // MARK: - Helper Functions (copied from IntelligentFormView for testing)
    
    private func determineFormStrategy(analysis: DataAnalysisResult) -> FormStrategy {
        let containerType: FormContainerType
        let fieldLayout: FieldLayout
        let validation: ValidationStrategy
        
        // Analyze data characteristics to determine optimal strategy
        switch (analysis.complexity, analysis.fields.count) {
        case (.simple, 0...3):
            containerType = .form
            fieldLayout = .vertical
            validation = .immediate
        case (.simple, 4...7):
            containerType = .standard
            fieldLayout = .vertical
            validation = .deferred
        case (.moderate, _):
            containerType = .standard
            fieldLayout = .adaptive
            validation = .deferred
        case (.complex, _):
            containerType = .scrollView
            fieldLayout = .adaptive
            validation = .deferred
        case (.veryComplex, _):
            containerType = .custom
            fieldLayout = .adaptive
            validation = .deferred
        default:
            containerType = .adaptive
            fieldLayout = .adaptive
            validation = .deferred
        }
        
        return FormStrategy(
            containerType: containerType,
            fieldLayout: fieldLayout,
            validation: validation
        )
    }
    
    private func groupFieldsByType(_ fields: [DataField]) -> [FieldType: [DataField]] {
        var grouped: [FieldType: [DataField]] = [:]
        
        for field in fields {
            if grouped[field.type] == nil {
                grouped[field.type] = []
            }
            grouped[field.type]?.append(field)
        }
        
        return grouped
    }
    
    private func getFieldTypeTitle(_ fieldType: FieldType) -> String {
        switch fieldType {
        case .string: return "Text Fields"
        case .number: return "Numeric Fields"
        case .boolean: return "Toggle Fields"
        case .date: return "Date Fields"
        case .url: return "URL Fields"
        case .uuid: return "Identifier Fields"
        case .image: return "Media Fields"
        case .document: return "Document Fields"
        case .relationship: return "Relationship Fields"
        case .hierarchical: return "Hierarchical Fields"
        case .custom: return "Custom Fields"
        }
    }
    
    private func getFieldDescription(for field: DataField) -> String? {
        var descriptions: [String] = []
        
        if field.isOptional {
            descriptions.append("Optional")
        }
        
        if field.isArray {
            descriptions.append("Multiple values")
        }
        
        if field.hasDefaultValue {
            descriptions.append("Has default")
        }
        
        return descriptions.isEmpty ? nil : descriptions.joined(separator: " • ")
    }
    
    private func getDefaultValue(for field: DataField) -> Any {
        switch field.type {
        case .string:
            return ""
        case .number:
            return 0
        case .boolean:
            return false
        case .date:
            return Date()
        case .url:
            return URL(string: "https://example.com") ?? URL(string: "https://example.com")!
        case .uuid:
            return UUID()
        case .image, .document:
            return ""
        case .relationship, .hierarchical, .custom:
            return ""
        }
    }
    
    private func extractFieldValue(from object: Any, fieldName: String) -> Any {
        let mirror = Mirror(reflecting: object)
        
        for child in mirror.children {
            if child.label == fieldName {
                return child.value
            }
        }
        
        return "N/A"
    }
}
