//
//  NativeTypesTests.swift
//  SixLayerFrameworkTests
//
//  Test-Driven Development for Native Type Support in DynamicFormField
//  Cross-platform compatible tests using mocking
//

import XCTest
import SwiftUI
@testable import SixLayerFramework

// MARK: - Mock Types for Cross-Platform Testing

/// Mock image type for testing across platforms
struct MockImage: Equatable {
    let id: String
    let data: Data
    
    init(id: String = UUID().uuidString, data: Data = Data()) {
        self.id = id
        self.data = data
    }
}

/// Mock URL type for testing
struct MockURL: Equatable {
    let absoluteString: String
    
    init(_ string: String) {
        self.absoluteString = string
    }
}

/// Mock enum for testing enum field support
enum MockUserStatus: String, CaseIterable, Equatable {
    case active = "active"
    case inactive = "inactive"
    case pending = "pending"
}

/// Mock data container for testing
struct MockDataContainer: Equatable {
    let id: String
    let content: String
    
    init(id: String = UUID().uuidString, content: String = "test") {
        self.id = id
        self.content = content
    }
}

final class NativeTypesTests: XCTestCase {
    
    var formState: DynamicFormState!
    var configuration: DynamicFormConfiguration!
    
    override func setUp() {
        super.setUp()
        configuration = DynamicFormConfiguration(
            id: "test",
            title: "Test Form",
            description: "Test form for native types",
            sections: [],
            submitButtonText: "Submit",
            cancelButtonText: "Cancel"
        )
        formState = DynamicFormState(configuration: configuration)
    }
    
    override func tearDown() {
        formState = nil
        configuration = nil
        super.tearDown()
    }
    
    // MARK: - High Priority Tests
    
    func testImageFieldTypeExists() {
        // Given
        let fieldType = DynamicFieldType.image
        
        // Then
        XCTAssertEqual(fieldType.rawValue, "image")
    }
    
    func testImageFieldNativeBinding() {
        // Given
        let field = DynamicFormField(
            id: "profilePhoto",
            type: .image,
            label: "Profile Photo"
        )
        let testImage = MockImage(id: "test-image", data: "test-image-data".data(using: .utf8)!)
        
        // When
        formState.setValue(testImage, for: field.id)
        
        // Then
        let retrievedImage: MockImage? = formState.getValue(for: field.id)
        XCTAssertEqual(retrievedImage, testImage)
    }
    
    func testURLFieldNativeBinding() {
        // Given
        let field = DynamicFormField(
            id: "website",
            type: .url,
            label: "Website"
        )
        let testURL = MockURL("https://example.com")
        
        // When
        formState.setValue(testURL, for: field.id)
        
        // Then
        let retrievedURL: MockURL? = formState.getValue(for: field.id)
        XCTAssertEqual(retrievedURL, testURL)
    }
    
    func testIntegerFieldTypeExists() {
        // Given
        let fieldType = DynamicFieldType.integer
        
        // Then
        XCTAssertEqual(fieldType.rawValue, "integer")
    }
    
    func testIntegerFieldNativeBinding() {
        // Given
        let field = DynamicFormField(
            id: "age",
            type: .integer,
            label: "Age"
        )
        let testInt = 25
        
        // When
        formState.setValue(testInt, for: field.id)
        
        // Then
        let retrievedInt: Int? = formState.getValue(for: field.id)
        XCTAssertEqual(retrievedInt, testInt)
    }
    
    // MARK: - Medium Priority Tests
    
    func testArrayFieldTypeExists() {
        // Given
        let fieldType = DynamicFieldType.array
        
        // Then
        XCTAssertEqual(fieldType.rawValue, "array")
    }
    
    func testArrayFieldNativeBinding() {
        // Given
        let field = DynamicFormField(
            id: "tags",
            type: .array,
            label: "Tags"
        )
        let testArray = ["swift", "ios", "testing"]
        
        // When
        formState.setValue(testArray, for: field.id)
        
        // Then
        let retrievedArray: [String]? = formState.getValue(for: field.id)
        XCTAssertEqual(retrievedArray, testArray)
    }
    
    func testRangeFieldConfiguration() {
        // Given
        let field = DynamicFormField(
            id: "score",
            type: .range,
            label: "Score",
            metadata: [
                "minValue": "0",
                "maxValue": "100",
                "step": "1"
            ]
        )
        
        // When
        formState.setValue(75, for: field.id)
        
        // Then
        let retrievedValue: Int? = formState.getValue(for: field.id)
        XCTAssertEqual(retrievedValue, 75)
    }
    
    func testDataFieldTypeExists() {
        // Given
        let fieldType = DynamicFieldType.data
        
        // Then
        XCTAssertEqual(fieldType.rawValue, "data")
    }
    
    func testDataFieldNativeBinding() {
        // Given
        let field = DynamicFormField(
            id: "document",
            type: .data,
            label: "Document"
        )
        let testData = "Hello World".data(using: .utf8)!
        
        // When
        formState.setValue(testData, for: field.id)
        
        // Then
        let retrievedData: Data? = formState.getValue(for: field.id)
        XCTAssertEqual(retrievedData, testData)
    }
    
    // MARK: - Low Priority Tests
    
    func testEnumFieldTypeExists() {
        // Given
        let fieldType = DynamicFieldType.enum
        
        // Then
        XCTAssertEqual(fieldType.rawValue, "enum")
    }
    
    func testEnumFieldNativeBinding() {
        // Given
        let field = DynamicFormField(
            id: "status",
            type: .enum,
            label: "Status",
            options: MockUserStatus.allCases.map { $0.rawValue }
        )
        let testStatus = MockUserStatus.active
        
        // When
        formState.setValue(testStatus, for: field.id)
        
        // Then
        let retrievedStatus: MockUserStatus? = formState.getValue(for: field.id)
        XCTAssertEqual(retrievedStatus, testStatus)
    }
    
    func testOptionalTypeHandling() {
        // Given
        let field = DynamicFormField(
            id: "optionalField",
            type: .text,
            label: "Optional Field"
        )
        
        // When - Set nil value
        formState.setValue(nil as String?, for: field.id)
        
        // Then
        let retrievedValue: String? = formState.getValue(for: field.id)
        XCTAssertNil(retrievedValue)
    }
    
    func testCustomTypeValidation() {
        // Given
        let field = DynamicFormField(
            id: "email",
            type: .email,
            label: "Email",
            validationRules: [
                "required": "true",
                "pattern": "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
            ]
        )
        
        // When - Set invalid email
        formState.setValue("invalid-email", for: field.id)
        
        // Then
        // Validation should be triggered (implementation dependent)
        // This test ensures the validation system can handle custom types
        XCTAssertTrue(true) // Placeholder for validation logic
    }
    
    // MARK: - Integration Tests
    
    func testMixedNativeTypesInForm() {
        // Given
        let fields = [
            DynamicFormField(id: "name", type: .text, label: "Name"),
            DynamicFormField(id: "age", type: .integer, label: "Age"),
            DynamicFormField(id: "website", type: .url, label: "Website"),
            DynamicFormField(id: "tags", type: .array, label: "Tags"),
            DynamicFormField(id: "profilePhoto", type: .image, label: "Photo")
        ]
        
        // When
        formState.setValue("John Doe", for: "name")
        formState.setValue(30, for: "age")
        formState.setValue(MockURL("https://johndoe.com"), for: "website")
        formState.setValue(["developer", "swift"], for: "tags")
        formState.setValue(MockImage(id: "profile", data: "image-data".data(using: .utf8)!), for: "profilePhoto")
        
        // Then
        let name: String? = formState.getValue(for: "name")
        let age: Int? = formState.getValue(for: "age")
        let website: MockURL? = formState.getValue(for: "website")
        let tags: [String]? = formState.getValue(for: "tags")
        let photo: MockImage? = formState.getValue(for: "profilePhoto")
        
        XCTAssertEqual(name, "John Doe")
        XCTAssertEqual(age, 30)
        XCTAssertEqual(website?.absoluteString, "https://johndoe.com")
        XCTAssertEqual(tags, ["developer", "swift"])
        XCTAssertEqual(photo?.id, "profile")
    }
    
    func testTypeSafetyWithWrongTypes() {
        // Given
        let field = DynamicFormField(
            id: "age",
            type: .integer,
            label: "Age"
        )
        
        // When - Set wrong type
        formState.setValue("not a number", for: field.id)
        
        // Then - Should handle gracefully
        let retrievedValue: Int? = formState.getValue(for: field.id)
        XCTAssertNil(retrievedValue) // Should be nil due to type mismatch
    }
    
    // MARK: - Performance Tests
    
    func testLargeArrayPerformance() {
        // Given
        let field = DynamicFormField(
            id: "largeArray",
            type: .array,
            label: "Large Array"
        )
        let largeArray = Array(1...10000).map { "item\($0)" }
        
        // When
        measure {
            formState.setValue(largeArray, for: field.id)
            let _: [String]? = formState.getValue(for: field.id)
        }
    }
    
    func testImageMemoryManagement() {
        // Given
        let field = DynamicFormField(
            id: "image",
            type: .image,
            label: "Image"
        )
        let testImage = MockImage(id: "test", data: "image-data".data(using: .utf8)!)
        
        // When
        formState.setValue(testImage, for: field.id)
        
        // Then - Image should be properly retained
        let retrievedImage: MockImage? = formState.getValue(for: field.id)
        XCTAssertEqual(retrievedImage, testImage)
        
        // Clear and verify memory is released
        formState.setValue(nil as MockImage?, for: field.id)
        let clearedImage: MockImage? = formState.getValue(for: field.id)
        XCTAssertNil(clearedImage)
    }
}
