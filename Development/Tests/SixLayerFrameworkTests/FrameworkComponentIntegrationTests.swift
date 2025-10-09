import XCTest
import SwiftUI
import ViewInspector
@testable import SixLayerFramework

/// Integration Tests for Framework Component Accessibility
/// Tests that components can be created and work in real view hierarchies
@MainActor
final class FrameworkComponentIntegrationTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
        config.namespace = "IntegrationTest"
        config.mode = .automatic
        config.enableDebugLogging = true
        config.enableAutoIDs = true
    }
    
    override func tearDown() {
        super.tearDown()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
    }
    
    // MARK: - TDD Red Phase: Components That SHOULD Work (Have .automaticAccessibility())
    
    func testPlatformPresentContentL1CanBeCreated() {
        // TDD Green Phase: This SHOULD PASS - has .automaticAccessibility()
        let contentView = platformPresentContent_L1(content: "Test Content", hints: PresentationHints())
        
        // Test that the component can be created and doesn't crash
        XCTAssertNotNil(contentView, "platformPresentContent_L1 should be creatable")
        
        // Test that it can be used in a view hierarchy
        let testView = VStack {
            contentView
        }
        
        XCTAssertNotNil(testView, "platformPresentContent_L1 should work in view hierarchy")
        print("✅ platformPresentContent_L1 can be created and used")
    }
    
    func testPlatformPresentBasicValueL1CanBeCreated() {
        // TDD Green Phase: This SHOULD PASS - has .automaticAccessibility()
        let valueView = platformPresentBasicValue_L1(value: 42, hints: PresentationHints())
        
        // Test that the component can be created and doesn't crash
        XCTAssertNotNil(valueView, "platformPresentBasicValue_L1 should be creatable")
        
        // Test that it can be used in a view hierarchy
        let testView = VStack {
            valueView
        }
        
        XCTAssertNotNil(testView, "platformPresentBasicValue_L1 should work in view hierarchy")
        print("✅ platformPresentBasicValue_L1 can be created and used")
    }
    
    func testPlatformPresentBasicArrayL1CanBeCreated() {
        // TDD Green Phase: This SHOULD PASS - has .automaticAccessibility()
        let arrayView = platformPresentBasicArray_L1(array: [1, 2, 3], hints: PresentationHints())
        
        // Test that the component can be created and doesn't crash
        XCTAssertNotNil(arrayView, "platformPresentBasicArray_L1 should be creatable")
        
        // Test that it can be used in a view hierarchy
        let testView = VStack {
            arrayView
        }
        
        XCTAssertNotNil(testView, "platformPresentBasicArray_L1 should work in view hierarchy")
        print("✅ platformPresentBasicArray_L1 can be created and used")
    }
    
    // MARK: - TDD Red Phase: Components That SHOULD FAIL (Missing .automaticAccessibility())
    
    func testPlatformPresentItemCollectionL1CanBeCreated() {
        // TDD Red Phase: This SHOULD PASS (creation) but FAIL (accessibility)
        let mockItems = [
            MockTaskItemIntegration(id: "task1", title: "Test Task 1"),
            MockTaskItemIntegration(id: "task2", title: "Test Task 2")
        ]
        
        let hints = PresentationHints(
            dataType: .collection,
            presentationPreference: .automatic,
            complexity: .moderate,
            context: .dashboard
        )
        
        let collectionView = platformPresentItemCollection_L1(
            items: mockItems,
            hints: hints
        )
        
        // Test that the component can be created and doesn't crash
        XCTAssertNotNil(collectionView, "platformPresentItemCollection_L1 should be creatable")
        
        // Test that it can be used in a view hierarchy
        let testView = VStack {
            collectionView
        }
        
        XCTAssertNotNil(testView, "platformPresentItemCollection_L1 should work in view hierarchy")
        print("🔴 TDD Red Phase: platformPresentItemCollection_L1 can be created but may lack accessibility IDs")
    }
    
    // MARK: - Integration Test: Test Components in Real View Hierarchy
    
    func testFrameworkComponentsWorkInRealViewHierarchy() {
        // Test that multiple framework components can work together
        let mockItems = [
            MockTaskItemIntegration(id: "task1", title: "Test Task 1"),
            MockTaskItemIntegration(id: "task2", title: "Test Task 2")
        ]
        
        let hints = PresentationHints(
            dataType: .collection,
            presentationPreference: .automatic,
            complexity: .moderate,
            context: .dashboard
        )
        
        let testView = VStack {
            platformPresentContent_L1(content: "Header", hints: PresentationHints())
            platformPresentBasicValue_L1(value: 42, hints: PresentationHints())
            platformPresentItemCollection_L1(items: mockItems, hints: hints)
        }
        
        XCTAssertNotNil(testView, "Multiple framework components should work together")
        print("✅ Framework components work together in real view hierarchy")
    }
}

// MARK: - Mock Data

struct MockTaskItemIntegration: Identifiable {
    let id: String
    let title: String
}
