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
    
    // MARK: - Test Data Setup
    
    private func createTestHints() -> PresentationHints {
        return PresentationHints(
            dataType: .generic,
            presentationPreference: .automatic,
            complexity: .moderate,
            context: .dashboard
        )
    }
    
    // MARK: - Basic Functionality Tests
    
    func testPlatformPresentContent_L1_WithString() {
        // Given
        let content = "Hello, World!"
        let hints = createTestHints()
        
        // When
        let view = platformPresentContent_L1(
            content: content,
            hints: hints
        )
        
        // Then
        XCTAssertNotNil(view, "platformPresentContent_L1 should return a view for string content")
    }
    
    func testPlatformPresentContent_L1_WithNumber() {
        // Given
        let content = 42
        let hints = createTestHints()
        
        // When
        let view = platformPresentContent_L1(
            content: content,
            hints: hints
        )
        
        // Then
        XCTAssertNotNil(view, "platformPresentContent_L1 should return a view for number content")
    }
    
    func testPlatformPresentContent_L1_WithArray() {
        // Given
        let content = [1, 2, 3, 4, 5]
        let hints = createTestHints()
        
        // When
        let view = platformPresentContent_L1(
            content: content,
            hints: hints
        )
        
        // Then
        XCTAssertNotNil(view, "platformPresentContent_L1 should return a view for array content")
    }
    
    func testPlatformPresentContent_L1_WithDictionary() {
        // Given
        let content: [String: Any] = ["name": "Test", "value": 123]
        let hints = createTestHints()
        
        // When
        let view = platformPresentContent_L1(
            content: content,
            hints: hints
        )
        
        // Then
        XCTAssertNotNil(view, "platformPresentContent_L1 should return a view for dictionary content")
    }
    
    func testPlatformPresentContent_L1_WithNil() {
        // Given
        let content: Any? = nil
        let hints = createTestHints()
        
        // When
        let view = platformPresentContent_L1(
            content: content as Any,
            hints: hints
        )
        
        // Then
        XCTAssertNotNil(view, "platformPresentContent_L1 should return a view for nil content")
    }
    
    // MARK: - Different Hint Types Tests
    
    func testPlatformPresentContent_L1_WithDifferentDataTypes() {
        // Given
        let content = "Test content"
        let hints = PresentationHints(
            dataType: .text,
            presentationPreference: .automatic,
            complexity: .simple,
            context: .form
        )
        
        // When
        let view = platformPresentContent_L1(
            content: content,
            hints: hints
        )
        
        // Then
        XCTAssertNotNil(view, "platformPresentContent_L1 should return a view with different data type hints")
    }
    
    func testPlatformPresentContent_L1_WithComplexContent() {
        // Given
        let content = PresentationHints(
            dataType: .generic,
            presentationPreference: .automatic,
            complexity: .moderate,
            context: .dashboard
        )
        let hints = createTestHints()
        
        // When
        let view = platformPresentContent_L1(
            content: content,
            hints: hints
        )
        
        // Then
        XCTAssertNotNil(view, "platformPresentContent_L1 should return a view for complex content")
    }
    
    // MARK: - Edge Cases Tests
    
    func testPlatformPresentContent_L1_WithEmptyString() {
        // Given
        let content = ""
        let hints = createTestHints()
        
        // When
        let view = platformPresentContent_L1(
            content: content,
            hints: hints
        )
        
        // Then
        XCTAssertNotNil(view, "platformPresentContent_L1 should return a view for empty string")
    }
    
    func testPlatformPresentContent_L1_WithEmptyArray() {
        // Given
        let content: [Any] = []
        let hints = createTestHints()
        
        // When
        let view = platformPresentContent_L1(
            content: content,
            hints: hints
        )
        
        // Then
        XCTAssertNotNil(view, "platformPresentContent_L1 should return a view for empty array")
    }
    
    func testPlatformPresentContent_L1_WithEmptyDictionary() {
        // Given
        let content: [String: Any] = [:]
        let hints = createTestHints()
        
        // When
        let view = platformPresentContent_L1(
            content: content,
            hints: hints
        )
        
        // Then
        XCTAssertNotNil(view, "platformPresentContent_L1 should return a view for empty dictionary")
    }
    
    // MARK: - Performance Tests
    
    func testPlatformPresentContent_L1_Performance() {
        // Given
        let content = "Performance test content"
        let hints = createTestHints()
        
        // When & Then
        measure {
            let _ = platformPresentContent_L1(
                content: content,
                hints: hints
            )
        }
    }
}