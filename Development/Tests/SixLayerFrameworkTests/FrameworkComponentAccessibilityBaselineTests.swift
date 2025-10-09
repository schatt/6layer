import XCTest
import SwiftUI
import ViewInspector
@testable import SixLayerFramework

/// TDD Tests for Framework Component Accessibility - Baseline Test
/// First prove the components we KNOW work, then systematically fix the rest
@MainActor
final class FrameworkComponentAccessibilityBaselineTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
        config.namespace = "FrameworkTest"
        config.mode = .automatic
        config.enableDebugLogging = false
        config.enableAutoIDs = true
    }
    
    override func tearDown() {
        super.tearDown()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
    }
    
    // MARK: - TDD Green Phase: Components That SHOULD Work (Have .automaticAccessibility())
    
    func testPlatformPresentContentL1GeneratesAccessibilityID() {
        // TDD Green Phase: This SHOULD PASS - has .automaticAccessibility()
        let contentView = platformPresentContent_L1(content: "Test Content", hints: PresentationHints())
        assertComponentGeneratesAccessibilityID(contentView, name: "platformPresentContent_L1")
        print("✅ platformPresentContent_L1 generates accessibility ID")
    }
    
    func testPlatformPresentBasicValueL1GeneratesAccessibilityID() {
        // TDD Green Phase: This SHOULD PASS - has .automaticAccessibility()
        let valueView = platformPresentBasicValue_L1(value: 42, hints: PresentationHints())
        assertComponentGeneratesAccessibilityID(valueView, name: "platformPresentBasicValue_L1")
        print("✅ platformPresentBasicValue_L1 generates accessibility ID")
    }
    
    func testPlatformPresentBasicArrayL1GeneratesAccessibilityID() {
        // TDD Green Phase: This SHOULD PASS - has .automaticAccessibility()
        let arrayView = platformPresentBasicArray_L1(array: [1, 2, 3], hints: PresentationHints())
        assertComponentGeneratesAccessibilityID(arrayView, name: "platformPresentBasicArray_L1")
        print("✅ platformPresentBasicArray_L1 generates accessibility ID")
    }
    
    // MARK: - TDD Red Phase: Components That SHOULD FAIL (Missing .automaticAccessibility())
    
    func testPlatformPresentItemCollectionL1GeneratesAccessibilityID() {
        // TDD Red Phase: This SHOULD FAIL - missing .automaticAccessibility()
        let mockItems = [
            MockTaskItemBaseline(id: "task1", title: "Test Task 1"),
            MockTaskItemBaseline(id: "task2", title: "Test Task 2")
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
        
        assertComponentGeneratesAccessibilityID(collectionView, name: "platformPresentItemCollection_L1")
        print("🔴 TDD Red Phase: platformPresentItemCollection_L1 should FAIL - missing .automaticAccessibility()")
    }
    
    // MARK: - Helper Methods
    
    private func assertComponentGeneratesAccessibilityID<T: View>(_ component: T, name: String) {
        XCTAssertTrue(hasAccessibilityIdentifier(component), "\(name) should generate accessibility ID")
    }
    
    private func hasAccessibilityIdentifier<T: View>(_ view: T) -> Bool {
        do {
            let inspectedView = try view.inspect()
            // Try to find any accessibility identifier modifier
            return try inspectedView.accessibilityIdentifier() != ""
        } catch {
            return false
        }
    }
}

// MARK: - Mock Data

struct MockTaskItemBaseline: Identifiable {
    let id: String
    let title: String
}
