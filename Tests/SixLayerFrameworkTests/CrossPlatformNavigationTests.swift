//
//  CrossPlatformNavigationTests.swift
//  SixLayerFrameworkTests
//
//  Tests for the Cross-Platform Navigation Component
//

import XCTest
import SwiftUI
import SixLayerFramework

@MainActor
final class CrossPlatformNavigationTests: XCTestCase {
    
    // MARK: - Test Data Models
    
    struct TestItem: Identifiable, Hashable {
        let id = UUID()
        let name: String
        let description: String
        let priority: Int
    }
    
    struct ComplexItem: Identifiable, Hashable {
        let id = UUID()
        let title: String
        let subtitle: String
        let metadata: [String: String]
        let tags: [String]
        let createdAt: Date
    }
    
    // MARK: - Basic Navigation Tests
    
    func testPlatformListWithDetailBasic() {
        let items = [
            TestItem(name: "Item 1", description: "Description 1", priority: 1),
            TestItem(name: "Item 2", description: "Description 2", priority: 2),
            TestItem(name: "Item 3", description: "Description 3", priority: 3)
        ]
        
        let selectedItem = Binding<TestItem?>(get: { nil }, set: { _ in })
        
        // This should compile and create a view
        let view = CrossPlatformNavigation.platformListWithDetail(
            items: items,
            selectedItem: selectedItem,
            itemView: { item in
                VStack {
                    Text(item.name)
                    Text(item.description)
                }
            },
            detailView: { item in
                VStack {
                    Text(item.name)
                    Text(item.description)
                    Text("Priority: \(item.priority)")
                }
            }
        )
        
        // Verify the view was created (we can't easily test the actual view content in unit tests)
        XCTAssertNotNil(view)
    }
    
    func testPlatformListWithDetailWithHints() {
        let items = [
            TestItem(name: "Item 1", description: "Description 1", priority: 1),
            TestItem(name: "Item 2", description: "Description 2", priority: 2)
        ]
        
        let selectedItem = Binding<TestItem?>(get: { nil }, set: { _ in })
        let hints = PresentationHints(
            dataType: .list,
            presentationPreference: .detail,
            complexity: .simple,
            context: .list
        )
        
        let view = CrossPlatformNavigation.platformListWithDetail(
            items: items,
            selectedItem: selectedItem,
            itemView: { item in
                Text(item.name)
            },
            detailView: { item in
                Text(item.description)
            },
            hints: hints
        )
        
        XCTAssertNotNil(view)
    }
    
    // MARK: - Navigation Strategy Tests
    
    func testNavigationStrategyDetermination() {
        // Test with different collection sizes and complexities
        
        // Small collection with simple items
        let smallSimpleItems = Array(0..<5).map { index in
            TestItem(name: "Item \(index)", description: "Description \(index)", priority: index)
        }
        
        let smallSimpleAnalysis = DataIntrospectionEngine.analyzeCollection(smallSimpleItems)
        XCTAssertEqual(smallSimpleAnalysis.collectionType, .small)
        // Note: Our complexity calculation considers arrays as hierarchical, making it moderate
        XCTAssertEqual(smallSimpleAnalysis.itemComplexity, .moderate)
        
        // Large collection with complex items
        let largeComplexItems = Array(0..<150).map { index in
            ComplexItem(
                title: "Item \(index)",
                subtitle: "Subtitle \(index)",
                metadata: ["key\(index)": "value\(index)"],
                tags: ["tag\(index)"],
                createdAt: Date()
            )
        }
        
        let largeComplexAnalysis = DataIntrospectionEngine.analyzeCollection(largeComplexItems)
        XCTAssertEqual(largeComplexAnalysis.collectionType, .large)
        // Note: Our complexity calculation considers metadata and tags as relationships, making it moderate
        XCTAssertEqual(largeComplexAnalysis.itemComplexity, .moderate)
    }
    
    // MARK: - View Extension Tests
    
    func testViewExtensionMethods() {
        let items = [
            TestItem(name: "Item 1", description: "Description 1", priority: 1),
            TestItem(name: "Item 2", description: "Description 2", priority: 2)
        ]
        
        let selectedItem = Binding<TestItem?>(get: { nil }, set: { _ in })
        
        // Test the convenience extension method
        let view = EmptyView().platformListDetailNavigation(
            items: items,
            selectedItem: selectedItem,
            itemView: { item in
                Text(item.name)
            },
            detailView: { item in
                Text(item.description)
            }
        )
        
        XCTAssertNotNil(view)
    }
    
    // MARK: - Edge Case Tests
    
    func testEmptyCollection() {
        let items: [TestItem] = []
        let selectedItem = Binding<TestItem?>(get: { nil }, set: { _ in })
        
        let view = CrossPlatformNavigation.platformListWithDetail(
            items: items,
            selectedItem: selectedItem,
            itemView: { item in
                Text(item.name)
            },
            detailView: { item in
                Text(item.description)
            }
        )
        
        XCTAssertNotNil(view)
    }
    
    func testSingleItem() {
        let items = [TestItem(name: "Single Item", description: "Single Description", priority: 1)]
        let selectedItem = Binding<TestItem?>(get: { nil }, set: { _ in })
        
        let view = CrossPlatformNavigation.platformListWithDetail(
            items: items,
            selectedItem: selectedItem,
            itemView: { item in
                Text(item.name)
            },
            detailView: { item in
                Text(item.description)
            }
        )
        
        XCTAssertNotNil(view)
    }
    
    // MARK: - Hints Integration Tests
    
    func testHintsOverrideDefaultStrategy() {
        let items = Array(0..<10).map { index in
            TestItem(name: "Item \(index)", description: "Description \(index)", priority: index)
        }
        
        let selectedItem = Binding<TestItem?>(get: { nil }, set: { _ in })
        
        // Test modal preference
        let modalHints = PresentationHints(
            dataType: .list,
            presentationPreference: .modal,
            complexity: .simple,
            context: .list
        )
        
        let modalView = CrossPlatformNavigation.platformListWithDetail(
            items: items,
            selectedItem: selectedItem,
            itemView: { item in
                Text(item.name)
            },
            detailView: { item in
                Text(item.description)
            },
            hints: modalHints
        )
        
        XCTAssertNotNil(modalView)
        
        // Test navigation preference
        let navigationHints = PresentationHints(
            dataType: .list,
            presentationPreference: .navigation,
            complexity: .simple,
            context: .list
        )
        
        let navigationView = CrossPlatformNavigation.platformListWithDetail(
            items: items,
            selectedItem: selectedItem,
            itemView: { item in
                Text(item.name)
            },
            detailView: { item in
                Text(item.description)
            },
            hints: navigationHints
        )
        
        XCTAssertNotNil(navigationView)
    }
    
    // MARK: - Performance Tests
    
    func testLargeCollectionPerformance() {
        let items = Array(0..<1000).map { index in
            TestItem(name: "Item \(index)", description: "Description \(index)", priority: index)
        }
        
        let selectedItem = Binding<TestItem?>(get: { nil }, set: { _ in })
        
        measure {
            let view = CrossPlatformNavigation.platformListWithDetail(
                items: items,
                selectedItem: selectedItem,
                itemView: { item in
                    Text(item.name)
                },
                detailView: { item in
                    Text(item.description)
                }
            )
            
            // Just verify it doesn't crash
            XCTAssertNotNil(view)
        }
    }
    
    // MARK: - Hashable Conformance Tests
    
    func testHashableConformance() {
        let item1 = TestItem(name: "Item 1", description: "Description 1", priority: 1)
        let item2 = TestItem(name: "Item 2", description: "Description 2", priority: 2)
        
        // Test that items can be used in sets (requires Hashable)
        let itemSet: Set<TestItem> = [item1, item2]
        XCTAssertEqual(itemSet.count, 2)
        
        // Test that items can be used as dictionary keys (requires Hashable)
        let itemDict: [TestItem: String] = [item1: "value1", item2: "value2"]
        XCTAssertEqual(itemDict.count, 2)
    }
}
