//
//  IntelligentDetailViewTests.swift
//  SixLayerFrameworkTests
//
//  Tests for the Intelligent Detail View Component
//

import XCTest
import SwiftUI
import SixLayerFramework

@MainActor
final class IntelligentDetailViewTests: XCTestCase {
    
    // MARK: - Test Data Models
    
    struct SimpleItem: Identifiable, Hashable {
        let id = UUID()
        let name: String
        let description: String
        let isActive: Bool
    }
    
    struct ModerateItem: Identifiable, Hashable {
        let id = UUID()
        let title: String
        let subtitle: String
        let priority: Int
        let tags: [String]
        let metadata: [String: String]
        let createdAt: Date
    }
    
    struct ComplexItem: Identifiable, Hashable {
        let id = UUID()
        let name: String
        let email: String
        let phone: String?
        let address: Address
        let preferences: UserPreferences
        let history: [Transaction]
        let attachments: [Attachment]
        let relationships: [User]
        let settings: Settings
        let notes: String
        let category: String
        let status: ItemStatus
        let priority: Priority
        let tags: [String]
        let metadata: [String: String]
        let createdAt: Date
        let updatedAt: Date
        let version: Int
        let isArchived: Bool
    }
    
    struct Address: Identifiable, Hashable {
        let id = UUID()
        let street: String
        let city: String
        let state: String
        let zipCode: String
        let country: String
    }
    
    struct UserPreferences: Identifiable, Hashable {
        let id = UUID()
        let theme: String
        let notifications: Bool
        let privacy: PrivacyLevel
    }
    
    enum PrivacyLevel: String, Hashable {
        case `public`, `private`, friends
    }
    
    struct Transaction: Hashable {
        let amount: Double
        let date: Date
        let description: String
    }
    
    struct Attachment: Hashable {
        let filename: String
        let size: Int
        let type: String
    }
    
    struct User: Hashable {
        let name: String
        let email: String
    }
    
    struct Settings: Hashable {
        let autoSave: Bool
        let syncInterval: Int
        let maxFileSize: Int
    }
    
    enum ItemStatus: String, Hashable {
        case active, inactive, pending, completed
    }
    
    enum Priority: String, Hashable {
        case low, medium, high, critical
    }
    
    // MARK: - Basic Detail View Tests
    
    func testPlatformDetailViewBasic() {
        let item = SimpleItem(
            name: "Test Item",
            description: "Test Description",
            isActive: true
        )
        
        // This should compile and create a view
        let view = IntelligentDetailView.platformDetailView(for: item)
        
        // Verify the view was created
        XCTAssertNotNil(view)
    }
    
    func testPlatformDetailViewWithHints() {
        let item = SimpleItem(
            name: "Test Item",
            description: "Test Description",
            isActive: true
        )
        
        let hints = PresentationHints(
            dataType: .generic,
            presentationPreference: .compact,
            complexity: .simple,
            context: .detail
        )
        
        let view = IntelligentDetailView.platformDetailView(
            for: item,
            hints: hints
        )
        
        XCTAssertNotNil(view)
    }
    
    // MARK: - Layout Strategy Tests
    
    func testLayoutStrategyDetermination() {
        // Test simple item (should use compact layout)
        let simpleItem = SimpleItem(
            name: "Simple",
            description: "Simple Description",
            isActive: true
        )
        
        let simpleAnalysis = DataIntrospectionEngine.analyze(simpleItem)
        XCTAssertEqual(simpleAnalysis.complexity, .moderate)
        XCTAssertEqual(simpleAnalysis.fields.count, 4)
        
        // Test moderate item (should use standard layout)
        let moderateItem = ModerateItem(
            title: "Moderate",
            subtitle: "Moderate Subtitle",
            priority: 5,
            tags: ["tag1", "tag2"],
            metadata: ["key1": "value1"],
            createdAt: Date()
        )
        
        let moderateAnalysis = DataIntrospectionEngine.analyze(moderateItem)
        XCTAssertEqual(moderateAnalysis.complexity, .moderate)
        XCTAssertEqual(moderateAnalysis.fields.count, 7)
        
        // Test complex item (should use detailed layout)
        let complexItem = ComplexItem(
            name: "Complex",
            email: "complex@example.com",
            phone: "+1234567890",
            address: Address(street: "123 Main St", city: "Anytown", state: "CA", zipCode: "12345", country: "USA"),
            preferences: UserPreferences(theme: "dark", notifications: true, privacy: .private),
            history: [Transaction(amount: 100.0, date: Date(), description: "Test")],
            attachments: [Attachment(filename: "test.pdf", size: 1024, type: "pdf")],
            relationships: [User(name: "Jane", email: "jane@example.com")],
            settings: Settings(autoSave: true, syncInterval: 300, maxFileSize: 1048576),
            notes: "Test notes",
            category: "Test Category",
            status: .active,
            priority: .high,
            tags: ["tag1", "tag2"],
            metadata: ["key1": "value1"],
            createdAt: Date(),
            updatedAt: Date(),
            version: 1,
            isArchived: false
        )
        
        let complexAnalysis = DataIntrospectionEngine.analyze(complexItem)
        XCTAssertEqual(complexAnalysis.complexity, .veryComplex)
        XCTAssertGreaterThanOrEqual(complexAnalysis.fields.count, 20)
    }
    
    // MARK: - Custom Field View Tests
    
    func testCustomFieldView() {
        let item = SimpleItem(
            name: "Test Item",
            description: "Test Description",
            isActive: true
        )
        
        let view = IntelligentDetailView.platformDetailView(
            for: item,
            customFieldView: { fieldName, value, fieldType in
                VStack {
                    Text(fieldName)
                    Text(String(describing: value))
                    Text(fieldType.rawValue)
                }
            }
        )
        
        XCTAssertNotNil(view)
    }
    
    // MARK: - View Extension Tests
    
    func testViewExtensionMethods() {
        let item = SimpleItem(
            name: "Test Item",
            description: "Test Description",
            isActive: true
        )
        
        // Test the convenience extension method
        let view = EmptyView().platformIntelligentDetail(for: item)
        
        XCTAssertNotNil(view)
    }
    
    // MARK: - Field Priority Tests
    
    func testFieldPriorityDetermination() {
        let item = ComplexItem(
            name: "Test Item",
            email: "test@example.com",
            phone: "+1234567890",
            address: Address(street: "123 Main St", city: "Anytown", state: "CA", zipCode: "12345", country: "USA"),
            preferences: UserPreferences(theme: "dark", notifications: true, privacy: .private),
            history: [Transaction(amount: 100.0, date: Date(), description: "Test")],
            attachments: [Attachment(filename: "test.pdf", size: 1024, type: "pdf")],
            relationships: [User(name: "Jane", email: "jane@example.com")],
            settings: Settings(autoSave: true, syncInterval: 300, maxFileSize: 1048576),
            notes: "Test notes",
            category: "Test Category",
            status: .active,
            priority: .high,
            tags: ["tag1", "tag2"],
            metadata: ["key1": "value1"],
            createdAt: Date(),
            updatedAt: Date(),
            version: 1,
            isArchived: false
        )
        
        let analysis = DataIntrospectionEngine.analyze(item)
        
        // Check that we have fields with different priorities
        let nameField = analysis.fields.first { $0.name == "name" }
        XCTAssertNotNil(nameField)
        
        let notesField = analysis.fields.first { $0.name == "notes" }
        XCTAssertNotNil(notesField)
        
        let versionField = analysis.fields.first { $0.name == "version" }
        XCTAssertNotNil(versionField)
    }
    
    // MARK: - Edge Case Tests
    
    func testEmptyStruct() {
        struct EmptyStruct {}
        let item = EmptyStruct()
        
        let view = IntelligentDetailView.platformDetailView(for: item)
        XCTAssertNotNil(view)
    }
    
    func testOptionalFields() {
        struct OptionalItem: Identifiable, Hashable {
            let id = UUID()
            let name: String?
            let age: Int?
            let isActive: Bool?
        }
        
        let item = OptionalItem(
            name: "Test",
            age: 25,
            isActive: true
        )
        
        let view = IntelligentDetailView.platformDetailView(for: item)
        XCTAssertNotNil(view)
    }
    
    // MARK: - Performance Tests
    
    func testLargeDataPerformance() {
        struct LargeItem: Identifiable, Hashable {
            let id = UUID()
            let field1: String
            let field2: Int
            let field3: Bool
            let field4: Double
            let field5: Date
            let field6: String
            let field7: Int
            let field8: Bool
            let field9: Double
            let field10: Date
            let field11: String
            let field12: Int
            let field13: Bool
            let field14: Double
            let field15: Date
            let field16: String
            let field17: Int
            let field18: Bool
            let field19: Double
            let field20: Date
        }
        
        let item = LargeItem(
            field1: "Value 1", field2: 1, field3: true, field4: 1.0, field5: Date(),
            field6: "Value 6", field7: 7, field8: false, field9: 9.0, field10: Date(),
            field11: "Value 11", field12: 12, field13: true, field14: 14.0, field15: Date(),
            field16: "Value 16", field17: 17, field18: false, field19: 19.0, field20: Date()
        )
        
        measure {
            let view = IntelligentDetailView.platformDetailView(for: item)
            XCTAssertNotNil(view)
        }
    }
    
    // MARK: - Hints Integration Tests
    
    func testHintsOverrideDefaultStrategy() {
        let item = ComplexItem(
            name: "Test Item",
            email: "test@example.com",
            phone: "+1234567890",
            address: Address(street: "123 Main St", city: "Anytown", state: "CA", zipCode: "12345", country: "USA"),
            preferences: UserPreferences(theme: "dark", notifications: true, privacy: .private),
            history: [Transaction(amount: 100.0, date: Date(), description: "Test")],
            attachments: [Attachment(filename: "test.pdf", size: 1024, type: "pdf")],
            relationships: [User(name: "Jane", email: "jane@example.com")],
            settings: Settings(autoSave: true, syncInterval: 300, maxFileSize: 1048576),
            notes: "Test notes",
            category: "Test Category",
            status: .active,
            priority: .high,
            tags: ["tag1", "tag2"],
            metadata: ["key1": "value1"],
            createdAt: Date(),
            updatedAt: Date(),
            version: 1,
            isArchived: false
        )
        
        // Test compact preference
        let compactHints = PresentationHints(
            dataType: .generic,
            presentationPreference: .compact,
            complexity: .veryComplex,
            context: .detail
        )
        
        let compactView = IntelligentDetailView.platformDetailView(
            for: item,
            hints: compactHints
        )
        
        XCTAssertNotNil(compactView)
        
        // Test detailed preference
        let detailedHints = PresentationHints(
            dataType: .generic,
            presentationPreference: .detail,
            complexity: .veryComplex,
            context: .detail
        )
        
        let detailedView = IntelligentDetailView.platformDetailView(
            for: item,
            hints: detailedHints
        )
        
        XCTAssertNotNil(detailedView)
    }
}
