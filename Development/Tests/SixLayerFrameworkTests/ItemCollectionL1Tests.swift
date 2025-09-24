//
//  ItemCollectionL1Tests.swift
//  SixLayerFrameworkTests
//
//  Tests for item collection L1 functions
//  Tests generic item collection presentation features
//

import XCTest
import SwiftUI
@testable import SixLayerFramework

@MainActor
final class ItemCollectionL1Tests: XCTestCase {
    
    // MARK: - Test Data
    
    private var sampleItems: [GenericDataItem] = []
    private var sampleHints: PresentationHints = PresentationHints()
    
    override func setUp() {
        super.setUp()
        sampleItems = createSampleItems()
        sampleHints = PresentationHints()
    }
    
    override func tearDown() {
        sampleItems = []
        super.tearDown()
    }
    
    // MARK: - Item Collection Tests
    
    func testPlatformPresentItemCollection_L1() {
        // Given
        let items = sampleItems
        
        // When
        let view = platformPresentItemCollection_L1(
            items: items,
            hints: sampleHints
        )
        
        // Then
        XCTAssertNotNil(view, "platformPresentItemCollection_L1 should return a view")
    }
    
    func testPlatformPresentItemCollection_L1_WithEmptyItems() {
        // Given
        let items: [GenericDataItem] = []
        
        // When
        let view = platformPresentItemCollection_L1(
            items: items,
            hints: sampleHints
        )
        
        // Then
        XCTAssertNotNil(view, "platformPresentItemCollection_L1 with empty items should return a view")
    }
    
    func testPlatformPresentItemCollection_L1_WithSingleItem() {
        // Given
        let items = [sampleItems.first!]
        
        // When
        let view = platformPresentItemCollection_L1(
            items: items,
            hints: sampleHints
        )
        
        // Then
        XCTAssertNotNil(view, "platformPresentItemCollection_L1 with single item should return a view")
    }
    
    func testPlatformPresentItemCollection_L1_WithManyItems() {
        // Given
        let items = createManyItems(count: 100)
        
        // When
        let view = platformPresentItemCollection_L1(
            items: items,
            hints: sampleHints
        )
        
        // Then
        XCTAssertNotNil(view, "platformPresentItemCollection_L1 with many items should return a view")
    }
    
    // MARK: - Different Hint Types
    
    func testPlatformPresentItemCollection_L1_WithCompactHints() {
        // Given
        let items = sampleItems
        let hints = PresentationHints(
            dataType: .generic,
            presentationPreference: .compact,
            complexity: .simple,
            context: .dashboard
        )
        
        // When
        let view = platformPresentItemCollection_L1(
            items: items,
            hints: hints
        )
        
        // Then
        XCTAssertNotNil(view, "platformPresentItemCollection_L1 with compact hints should return a view")
    }
    
    func testPlatformPresentItemCollection_L1_WithDetailedHints() {
        // Given
        let items = sampleItems
        let hints = PresentationHints(
            dataType: .generic,
            presentationPreference: .detail,
            complexity: .complex,
            context: .detail
        )
        
        // When
        let view = platformPresentItemCollection_L1(
            items: items,
            hints: hints
        )
        
        // Then
        XCTAssertNotNil(view, "platformPresentItemCollection_L1 with detailed hints should return a view")
    }
    
    func testPlatformPresentItemCollection_L1_WithGridHints() {
        // Given
        let items = sampleItems
        let hints = PresentationHints(
            dataType: .generic,
            presentationPreference: .grid,
            complexity: .moderate,
            context: .browse
        )
        
        // When
        let view = platformPresentItemCollection_L1(
            items: items,
            hints: hints
        )
        
        // Then
        XCTAssertNotNil(view, "platformPresentItemCollection_L1 with grid hints should return a view")
    }
    
    func testPlatformPresentItemCollection_L1_WithListHints() {
        // Given
        let items = sampleItems
        let hints = PresentationHints(
            dataType: .generic,
            presentationPreference: .list,
            complexity: .moderate,
            context: .browse
        )
        
        // When
        let view = platformPresentItemCollection_L1(
            items: items,
            hints: hints
        )
        
        // Then
        XCTAssertNotNil(view, "platformPresentItemCollection_L1 with list hints should return a view")
    }
    
    // MARK: - Performance Tests
    
    func testPlatformPresentItemCollection_L1_Performance() {
        // Given
        let items = sampleItems
        
        // When & Then
        measure {
            let view = platformPresentItemCollection_L1(
                items: items,
                hints: sampleHints
            )
            XCTAssertNotNil(view)
        }
    }
    
    func testPlatformPresentItemCollection_L1_LargeDatasetPerformance() {
        // Given
        let items = createManyItems(count: 1000)
        
        // When & Then
        measure {
            let view = platformPresentItemCollection_L1(
                items: items,
                hints: sampleHints
            )
            XCTAssertNotNil(view)
        }
    }
    
    // MARK: - Helper Methods
    
    private func createSampleItems() -> [GenericDataItem] {
        return [
            GenericDataItem(
                title: "Item 1",
                subtitle: "Subtitle 1",
                data: ["description": "Description 1", "value": "Value 1"]
            ),
            GenericDataItem(
                title: "Item 2",
                subtitle: "Subtitle 2",
                data: ["description": "Description 2", "value": "Value 2"]
            ),
            GenericDataItem(
                title: "Item 3",
                subtitle: "Subtitle 3",
                data: ["description": "Description 3", "value": "Value 3"]
            )
        ]
    }
    
    private func createManyItems(count: Int) -> [GenericDataItem] {
        return (1...count).map { index in
            GenericDataItem(
                title: "Item \(index)",
                subtitle: "Subtitle \(index)",
                data: ["description": "Description \(index)", "value": "Value \(index)"]
            )
        }
    }
}


