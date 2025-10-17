import Testing

//
//  ItemCollectionL1Tests.swift
//  SixLayerFrameworkTests
//
//  Tests for item collection L1 functions
//  Tests generic item collection presentation features
//

import SwiftUI
@testable import SixLayerFramework

@MainActor
open class ItemCollectionL1Tests: BaseTestClass {
    
    // MARK: - Test Data
    
    private var sampleItems: [GenericDataItem] = []
    private var sampleHints: PresentationHints = PresentationHints()
    
    override init() {
        sampleItems = createSampleItems()
        sampleHints = PresentationHints()
    }
    
    deinit {
        Task { [weak self] in
            await self?.cleanupTestEnvironment()
        }
    }
    
    // MARK: - Item Collection Tests
    
    @Test func testPlatformPresentItemCollection_L1() {
        // Given
        let items = sampleItems
        
        // When
        let view = platformPresentItemCollection_L1(
            items: items,
            hints: sampleHints
        )
        
        // Then
        #expect(view != nil, "platformPresentItemCollection_L1 should return a view")
    }
    
    @Test func testPlatformPresentItemCollection_L1_WithEmptyItems() {
        // Given
        let items: [GenericDataItem] = []
        
        // When
        let view = platformPresentItemCollection_L1(
            items: items,
            hints: sampleHints
        )
        
        // Then
        #expect(view != nil, "platformPresentItemCollection_L1 with empty items should return a view")
    }
    
    @Test func testPlatformPresentItemCollection_L1_WithSingleItem() {
        // Given
        let items = [sampleItems.first!]
        
        // When
        let view = platformPresentItemCollection_L1(
            items: items,
            hints: sampleHints
        )
        
        // Then
        #expect(view != nil, "platformPresentItemCollection_L1 with single item should return a view")
    }
    
    @Test func testPlatformPresentItemCollection_L1_WithManyItems() {
        // Given
        let items = createManyItems(count: 100)
        
        // When
        let view = platformPresentItemCollection_L1(
            items: items,
            hints: sampleHints
        )
        
        // Then
        #expect(view != nil, "platformPresentItemCollection_L1 with many items should return a view")
    }
    
    // MARK: - Different Hint Types
    
    @Test func testPlatformPresentItemCollection_L1_WithCompactHints() {
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
        #expect(view != nil, "platformPresentItemCollection_L1 with compact hints should return a view")
    }
    
    @Test func testPlatformPresentItemCollection_L1_WithDetailedHints() {
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
        #expect(view != nil, "platformPresentItemCollection_L1 with detailed hints should return a view")
    }
    
    @Test func testPlatformPresentItemCollection_L1_WithGridHints() {
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
        #expect(view != nil, "platformPresentItemCollection_L1 with grid hints should return a view")
    }
    
    @Test func testPlatformPresentItemCollection_L1_WithListHints() {
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
        #expect(view != nil, "platformPresentItemCollection_L1 with list hints should return a view")
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
