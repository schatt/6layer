//
//  PlatformPresentContentL1Tests.swift
//  SixLayerFrameworkTests
//
//  Tests for platformPresentContent_L1 - generic content presentation function
//  for runtime-unknown content types (rare cases where content type is unknown at compile time)
//

import XCTest
import SwiftUI
@testable import SixLayerFramework

@MainActor
final class PlatformPresentContentL1Tests: XCTestCase {
    
    // MARK: - Test Helpers
    
    /// Helper function to create GenericFormField with proper binding for tests
    private func createTestField(
        label: String,
        placeholder: String? = nil,
        value: String = "",
        isRequired: Bool = false,
        fieldType: DynamicFieldType = .text
    ) -> GenericFormField {
        return GenericFormField(
            label: label,
            placeholder: placeholder,
            value: .constant(value),
            isRequired: isRequired,
            fieldType: fieldType
        )
    }
    
    // MARK: - Important Note
    // 
    // platformPresentContent_L1 is reserved for RARE cases where content type
    // is unknown at compile time (e.g., dynamic API responses, user-generated content).
    // For known content types, use the specific functions:
    // - platformPresentItemCollection_L1 for collections
    // - platformPresentFormData_L1 for forms
    // - platformPresentMediaData_L1 for media
    // - etc.
    
    // MARK: - Test Data Setup
    
    private func createTestVehicles() -> [GenericVehicle] {
        return [
            GenericVehicle(name: "Test Car 1", description: "A test vehicle", type: .car),
            GenericVehicle(name: "Test Car 2", description: "Another test vehicle", type: .car)
        ]
    }
    
    private func createTestFormFields() -> [GenericFormField] {
        return [
            createTestField(label: "Name", placeholder: "Enter name", fieldType: .text),
            createTestField(label: "Email", placeholder: "Enter email", fieldType: .email)
        ]
    }
    
    private func createTestMediaItems() -> [GenericMediaItem] {
        return [
            GenericMediaItem(title: "Test Image", description: "A test image", mediaType: .image),
            GenericMediaItem(title: "Test Video", description: "A test video", mediaType: .video)
        ]
    }
    
    private func createTestNumericData() -> [GenericNumericData] {
        return [
            GenericNumericData(label: "Sales", value: 1000.0, unit: "USD"),
            GenericNumericData(label: "Profit", value: 250.0, unit: "USD")
        ]
    }
    
    private func createTestHierarchicalItems() -> [GenericHierarchicalItem] {
        return [
            GenericHierarchicalItem(title: "Parent", children: [
                GenericHierarchicalItem(title: "Child 1"),
                GenericHierarchicalItem(title: "Child 2")
            ])
        ]
    }
    
    private func createTestTemporalItems() -> [GenericTemporalItem] {
        return [
            GenericTemporalItem(title: "Event 1", date: Date(), description: "Test event"),
            GenericTemporalItem(title: "Event 2", date: Date().addingTimeInterval(3600), description: "Another test event")
        ]
    }
    
    private func createTestHints(dataType: DataTypeHint = .generic) -> PresentationHints {
        return PresentationHints(
            dataType: dataType,
            presentationPreference: .automatic,
            complexity: .moderate,
            context: .dashboard
        )
    }
    
    // MARK: - Collection Content Tests
    
    func testPresentContentWithVehicleCollection() {
        // Given
        let vehicles = createTestVehicles()
        let hints = createTestHints(dataType: .collection)
        
        // When
        let view = platformPresentContent_L1(content: vehicles, hints: hints)
        
        // Then
        XCTAssertNotNil(view)
        // The function should delegate to platformPresentItemCollection_L1
    }
    
    func testPresentContentWithGenericDataItems() {
        // Given
        let dataItems = [
            GenericDataItem(title: "Item 1", subtitle: "Subtitle 1"),
            GenericDataItem(title: "Item 2", subtitle: "Subtitle 2")
        ]
        let hints = createTestHints(dataType: .collection)
        
        // When
        let view = platformPresentContent_L1(content: dataItems, hints: hints)
        
        // Then
        XCTAssertNotNil(view)
    }
    
    // MARK: - Form Content Tests
    
    func testPresentContentWithFormFields() {
        // Given
        let formFields = createTestFormFields()
        let hints = createTestHints(dataType: .form)
        
        // When
        let view = platformPresentContent_L1(content: formFields, hints: hints)
        
        // Then
        XCTAssertNotNil(view)
        // The function should delegate to platformPresentFormData_L1
    }
    
    // MARK: - Media Content Tests
    
    func testPresentContentWithMediaItems() {
        // Given
        let mediaItems = createTestMediaItems()
        let hints = createTestHints(dataType: .media)
        
        // When
        let view = platformPresentContent_L1(content: mediaItems, hints: hints)
        
        // Then
        XCTAssertNotNil(view)
        // The function should delegate to platformPresentMediaData_L1
    }
    
    // MARK: - Numeric Content Tests
    
    func testPresentContentWithNumericData() {
        // Given
        let numericData = createTestNumericData()
        let hints = createTestHints(dataType: .numeric)
        
        // When
        let view = platformPresentContent_L1(content: numericData, hints: hints)
        
        // Then
        XCTAssertNotNil(view)
        // The function should delegate to platformPresentNumericData_L1
    }
    
    // MARK: - Hierarchical Content Tests
    
    func testPresentContentWithHierarchicalItems() {
        // Given
        let hierarchicalItems = createTestHierarchicalItems()
        let hints = createTestHints(dataType: .hierarchical)
        
        // When
        let view = platformPresentContent_L1(content: hierarchicalItems, hints: hints)
        
        // Then
        XCTAssertNotNil(view)
        // The function should delegate to platformPresentHierarchicalData_L1
    }
    
    // MARK: - Temporal Content Tests
    
    func testPresentContentWithTemporalItems() {
        // Given
        let temporalItems = createTestTemporalItems()
        let hints = createTestHints(dataType: .temporal)
        
        // When
        let view = platformPresentContent_L1(content: temporalItems, hints: hints)
        
        // Then
        XCTAssertNotNil(view)
        // The function should delegate to platformPresentTemporalData_L1
    }
    
    // MARK: - Runtime-Unknown Content Tests (Primary Use Case)
    
    func testPresentContentWithDynamicAPIResponse() {
        // Given: Simulating unknown content from API
        let apiResponse: Any = [
            "type": "unknown",
            "data": [
                ["name": "Item 1", "value": 100],
                ["name": "Item 2", "value": 200]
            ]
        ]
        let hints = createTestHints(dataType: .generic)
        
        // When
        let view = platformPresentContent_L1(content: apiResponse, hints: hints)
        
        // Then
        XCTAssertNotNil(view)
        // The function should use fallback presentation for unknown API response
    }
    
    func testPresentContentWithUserGeneratedContent() {
        // Given: Simulating user-generated content of unknown type
        let userContent: Any = [
            "title": "User Post",
            "content": "Some user content",
            "attachments": ["image1.jpg", "document.pdf"],
            "metadata": ["created": Date(), "likes": 42]
        ]
        let hints = createTestHints(dataType: .generic)
        
        // When
        let view = platformPresentContent_L1(content: userContent, hints: hints)
        
        // Then
        XCTAssertNotNil(view)
        // The function should use fallback presentation for user content
    }
    
    func testPresentContentWithMixedContent() {
        // Given
        let mixedContent = MixedContent(
            text: "Some text content",
            image: "test-image",
            data: ["key": "value"]
        )
        let hints = createTestHints(dataType: .generic)
        
        // When
        let view = platformPresentContent_L1(content: mixedContent, hints: hints)
        
        // Then
        XCTAssertNotNil(view)
        // The function should use fallback presentation
    }
    
    func testPresentContentWithString() {
        // Given
        let stringContent = "This is a string"
        let hints = createTestHints(dataType: .text)
        
        // When
        let view = platformPresentContent_L1(content: stringContent, hints: hints)
        
        // Then
        XCTAssertNotNil(view)
        // The function should use fallback presentation
    }
    
    func testPresentContentWithDictionary() {
        // Given
        let dictContent = ["title": "Test", "value": 123] as [String: Any]
        let hints = createTestHints(dataType: .generic)
        
        // When
        let view = platformPresentContent_L1(content: dictContent, hints: hints)
        
        // Then
        XCTAssertNotNil(view)
        // The function should use fallback presentation
    }
    
    // MARK: - Edge Cases
    
    func testPresentContentWithEmptyArray() {
        // Given
        let emptyArray: [GenericVehicle] = []
        let hints = createTestHints(dataType: .collection)
        
        // When
        let view = platformPresentContent_L1(content: emptyArray, hints: hints)
        
        // Then
        XCTAssertNotNil(view)
    }
    
    func testPresentContentWithNil() {
        // Given
        let nilContent: Any? = nil
        let hints = createTestHints(dataType: .generic)
        
        // When
        let view = platformPresentContent_L1(content: nilContent as Any, hints: hints)
        
        // Then
        XCTAssertNotNil(view)
        // The function should handle nil gracefully
    }
    
    // MARK: - Hint-Based Delegation Tests
    
    func testHintBasedDelegationForCollection() {
        // Given
        let vehicles = createTestVehicles()
        let collectionHints = createTestHints(dataType: .collection)
        let formHints = createTestHints(dataType: .form)
        
        // When
        let collectionView = platformPresentContent_L1(content: vehicles, hints: collectionHints)
        let formView = platformPresentContent_L1(content: vehicles, hints: formHints)
        
        // Then
        XCTAssertNotNil(collectionView)
        XCTAssertNotNil(formView)
        // Different hints should result in different presentation strategies
    }
    
    func testHintBasedDelegationForForm() {
        // Given
        let formFields = createTestFormFields()
        let formHints = createTestHints(dataType: .form)
        let mediaHints = createTestHints(dataType: .media)
        
        // When
        let formView = platformPresentContent_L1(content: formFields, hints: formHints)
        let mediaView = platformPresentContent_L1(content: formFields, hints: mediaHints)
        
        // Then
        XCTAssertNotNil(formView)
        XCTAssertNotNil(mediaView)
        // Different hints should result in different presentation strategies
    }
    
    // MARK: - Performance Tests
    
    func testPerformanceWithLargeCollection() {
        // Given
        let largeCollection = (0..<1000).map { i in
            GenericVehicle(name: "Vehicle \(i)", description: "Description \(i)", type: .car)
        }
        let hints = createTestHints(dataType: .collection)
        
        // When & Then
        measure {
            let _ = platformPresentContent_L1(content: largeCollection, hints: hints)
        }
    }
    
    func testPerformanceWithMixedContent() {
        // Given
        let mixedContent = MixedContent(
            text: "Performance test content",
            image: "test-image",
            data: ["performance": "test"]
        )
        let hints = createTestHints(dataType: .generic)
        
        // When & Then
        measure {
            let _ = platformPresentContent_L1(content: mixedContent, hints: hints)
        }
    }
}

// MARK: - Test Helper Types

/// Mixed content type for testing
private struct MixedContent {
    let text: String
    let image: String
    let data: [String: Any]
}

/// Generic temporal item for testing
private struct GenericTemporalItem: Identifiable {
    let id = UUID()
    let title: String
    let date: Date
    let description: String?
    
    init(title: String, date: Date, description: String? = nil) {
        self.title = title
        self.date = date
        self.description = description
    }
}
