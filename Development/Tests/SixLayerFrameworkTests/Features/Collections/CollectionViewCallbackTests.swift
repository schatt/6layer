import Testing


import SwiftUI
import ViewInspector
@testable import SixLayerFramework

/// Tests for Collection View Callback Functionality
/// Tests that collection views properly handle item selection, deletion, and editing callbacks
@MainActor
open class CollectionViewCallbackTests {
    
    // MARK: - Test Data
    
    private var sampleItems: [TestItem] {
        [
            TestItem(id: "1", title: "Item 1", description: "First item"),
            TestItem(id: "2", title: "Item 2", description: "Second item"),
            TestItem(id: "3", title: "Item 3", description: "Third item")
        ]
    }
    
    private var basicHints: PresentationHints {
        PresentationHints(
            dataType: .collection,
            presentationPreference: .cards,
            complexity: .simple,
            context: .dashboard
        )
    }
    
    private var enhancedHints: EnhancedPresentationHints {
        EnhancedPresentationHints(
            dataType: .collection,
            presentationPreference: .cards,
            complexity: .simple,
            context: .dashboard,
            customPreferences: [:],
            extensibleHints: []
        )
    }
    
    // MARK: - Callback Tracking
    
    private var selectedItems: [TestItem] = []
    private var deletedItems: [TestItem] = []
    private var editedItems: [TestItem] = []
    private var createdItems: Int = 0
    
    private func resetCallbacks() {
        selectedItems.removeAll()
        deletedItems.removeAll()
        editedItems.removeAll()
        createdItems = 0
    }
    
    // MARK: - Layer 1 Function Tests
    
    @Test func testPlatformPresentItemCollectionL1WithCallbacks() {
        // Given: Collection view with callbacks
        resetCallbacks()
        
        // When: Creating view with callbacks
        let view = platformPresentItemCollection_L1(
            items: sampleItems,
            hints: basicHints,
            onCreateItem: { self.createdItems += 1 },
            onItemSelected: { item in self.selectedItems.append(item) },
            onItemDeleted: { item in self.deletedItems.append(item) },
            onItemEdited: { item in self.editedItems.append(item) }
        )
        
        // Then: View should be created successfully
        #expect(view != nil)
    }
    
    @Test func testPlatformPresentItemCollectionL1WithoutCallbacks() {
        // Given: Collection view without callbacks
        resetCallbacks()
        
        // When: Creating view without callbacks
        let view = platformPresentItemCollection_L1(
            items: sampleItems,
            hints: basicHints
        )
        
        // Then: View should be created successfully
        #expect(view != nil)
    }
    
    @Test func testPlatformPresentItemCollectionL1WithEnhancedHints() {
        // Given: Collection view with enhanced hints and callbacks
        resetCallbacks()
        
        // When: Creating view with enhanced hints and callbacks
        let view = platformPresentItemCollection_L1(
            items: sampleItems,
            hints: enhancedHints,
            onCreateItem: { self.createdItems += 1 },
            onItemSelected: { item in self.selectedItems.append(item) },
            onItemDeleted: { item in self.deletedItems.append(item) },
            onItemEdited: { item in self.editedItems.append(item) }
        )
        
        // Then: View should be created successfully
        #expect(view != nil)
    }
    
    // MARK: - Collection View Component Tests
    
    @Test func testExpandableCardCollectionViewWithCallbacks() {
        // Given: Expandable card collection view with callbacks
        resetCallbacks()
        
        // When: Creating expandable card collection view
        let view = ExpandableCardCollectionView(
            items: sampleItems,
            hints: basicHints,
            onCreateItem: { self.createdItems += 1 },
            onItemSelected: { item in self.selectedItems.append(item) },
            onItemDeleted: { item in self.deletedItems.append(item) },
            onItemEdited: { item in self.editedItems.append(item) }
        )
        
        // Then: View should be created successfully
        #expect(view != nil)
    }
    
    @Test func testGridCollectionViewWithCallbacks() {
        // Given: Grid collection view with callbacks
        resetCallbacks()
        
        // When: Creating grid collection view
        let view = GridCollectionView(
            items: sampleItems,
            hints: basicHints,
            onCreateItem: { self.createdItems += 1 },
            onItemSelected: { item in self.selectedItems.append(item) },
            onItemDeleted: { item in self.deletedItems.append(item) },
            onItemEdited: { item in self.editedItems.append(item) }
        )
        
        // Then: View should be created successfully
        #expect(view != nil)
    }
    
    @Test func testListCollectionViewWithCallbacks() {
        // Given: List collection view with callbacks
        resetCallbacks()
        
        // When: Creating list collection view
        let view = ListCollectionView(
            items: sampleItems,
            hints: basicHints,
            onCreateItem: { self.createdItems += 1 },
            onItemSelected: { item in self.selectedItems.append(item) },
            onItemDeleted: { item in self.deletedItems.append(item) },
            onItemEdited: { item in self.editedItems.append(item) }
        )
        
        // Then: View should be created successfully
        #expect(view != nil)
    }
    
    @Test func testListCollectionViewOnItemSelectedCallback() async throws {
        // Rule 6.2 & 7.4: Functional testing - Tests must validate actual behavior
        // CRITICAL: This test verifies that ListCollectionView ACTUALLY INVOKES callbacks when tapped
        
        // Given: Track if callbacks are invoked
        resetCallbacks()
        var callbackInvoked = false
        var receivedItem: TestItem?
        
        let view = ListCollectionView(
            items: sampleItems,
            hints: basicHints,
            onItemSelected: { item in
                callbackInvoked = true
                receivedItem = item
                self.selectedItems.append(item)
            }
        )
        
        // When: Simulating a tap using ViewInspector
        do {
            let inspector = try view.inspect()
            
            // Find the ListCardComponent instances
            let listCardComponents = try inspector.findAll(ListCardComponent<TestItem>.self)
            
            // Then: Verify the view structure
            #expect(listCardComponents.count == sampleItems.count, "Should have cards for each item")
            
            // Get the first card - it's now a VStack, find the HStack child (where onTapGesture is applied)
            if let firstCard = listCardComponents.first {
                let vStack = try firstCard.vStack()
                // VStack contains: HStack at index 0 (the card content), Optional HStack at index 1 (action buttons)
                // Find the first HStack which has the onTapGesture
                let hStack = try vStack.hStack(0)
                try hStack.callOnTapGesture()
                
                // Verify callback was ACTUALLY invoked
                #expect(callbackInvoked, "Callback should be invoked when card is tapped")
                #expect(receivedItem != nil, "Received item should not be nil")
                #expect(receivedItem?.id == sampleItems.first?.id, "Should receive correct item")
                #expect(self.selectedItems.count == 1, "Selected items should contain tapped item")
            }
        } catch {
            // If ViewInspector fails, that's a test infrastructure issue
            Issue.record("ViewInspector failed to inspect ListCollectionView: \(error)")
        }
    }
    
    @Test func testCoverFlowCollectionViewWithCallbacks() {
        // Given: Cover flow collection view with callbacks
        resetCallbacks()
        
        // When: Creating cover flow collection view
        let view = CoverFlowCollectionView(
            items: sampleItems,
            hints: basicHints,
            onCreateItem: { self.createdItems += 1 },
            onItemSelected: { item in self.selectedItems.append(item) },
            onItemDeleted: { item in self.deletedItems.append(item) },
            onItemEdited: { item in self.editedItems.append(item) }
        )
        
        // Then: View should be created successfully
        #expect(view != nil)
    }
    
    @Test func testMasonryCollectionViewWithCallbacks() {
        // Given: Masonry collection view with callbacks
        resetCallbacks()
        
        // When: Creating masonry collection view
        let view = MasonryCollectionView(
            items: sampleItems,
            hints: basicHints,
            onCreateItem: { self.createdItems += 1 },
            onItemSelected: { item in self.selectedItems.append(item) },
            onItemDeleted: { item in self.deletedItems.append(item) },
            onItemEdited: { item in self.editedItems.append(item) }
        )
        
        // Then: View should be created successfully
        #expect(view != nil)
    }
    
    @Test func testListCollectionViewOnItemDeletedCallback() async throws {
        // Rule 6.2 & 7.4: Functional testing - Must verify callbacks ACTUALLY invoke
        
        var callbackInvoked = false
        var receivedItem: TestItem?
        
        let view = ListCollectionView(
            items: sampleItems,
            hints: basicHints,
            onItemDeleted: { item in
                callbackInvoked = true
                receivedItem = item
                self.deletedItems.append(item)
            }
        )
        
        // When: Simulating delete button tap using ViewInspector
        do {
            let inspector = try view.inspect()
            
            // Find Delete buttons in the view
            let buttons = try inspector.findAll(ViewType.Button.self)
            
            // Find and tap the Delete button
            for button in buttons {
                do {
                    let labelView = try button.labelView()
                    let labelText = try labelView.text().string()
                    
                    if labelText == "Delete" {
                        // Tap the button to invoke its action
                        try button.tap()
                        
                        // Then: Callback should be invoked
                        #expect(callbackInvoked, "Delete callback should be invoked when Delete button is tapped")
                        #expect(receivedItem != nil, "Should receive deleted item")
                        break
                    }
                } catch {
                    // Continue searching
                    continue
                }
            }
            
            if !callbackInvoked {
                Issue.record("Could not find Delete button in view or failed to tap it")
            }
        } catch {
            Issue.record("ViewInspector failed to inspect ListCollectionView: \(error)")
        }
    }
    
    @Test func testListCollectionViewOnItemEditedCallback() async throws {
        // Rule 6.2 & 7.4: Functional testing
        
        var callbackInvoked = false
        var receivedItem: TestItem?
        
        let view = ListCollectionView(
            items: sampleItems,
            hints: basicHints,
            onItemEdited: { item in
                callbackInvoked = true
                receivedItem = item
                self.editedItems.append(item)
            }
        )
        
        // When: Simulating edit button tap using ViewInspector
        do {
            let inspector = try view.inspect()
            
            // Find Edit buttons in the view
            let buttons = try inspector.findAll(ViewType.Button.self)
            
            // Find and tap the Edit button
            for button in buttons {
                do {
                    let labelView = try button.labelView()
                    let labelText = try labelView.text().string()
                    
                    if labelText == "Edit" {
                        // Tap the button to invoke its action
                        try button.tap()
                        
                        // Then: Callback should be invoked
                        #expect(callbackInvoked, "Edit callback should be invoked when Edit button is tapped")
                        #expect(receivedItem != nil, "Should receive edited item")
                        break
                    }
                } catch {
                    // Continue searching
                    continue
                }
            }
            
            if !callbackInvoked {
                Issue.record("Could not find Edit button in view or failed to tap it")
            }
        } catch {
            Issue.record("ViewInspector failed to inspect ListCollectionView: \(error)")
        }
    }
    
    @Test func testAdaptiveCollectionViewWithCallbacks() {
        // Given: Adaptive collection view with callbacks
        resetCallbacks()
        
        // When: Creating adaptive collection view
        let view = AdaptiveCollectionView(
            items: sampleItems,
            hints: basicHints,
            onCreateItem: { self.createdItems += 1 },
            onItemSelected: { item in self.selectedItems.append(item) },
            onItemDeleted: { item in self.deletedItems.append(item) },
            onItemEdited: { item in self.editedItems.append(item) }
        )
        
        // Then: View should be created successfully
        #expect(view != nil)
    }
    
    // MARK: - Card Component Tests
    
    @Test func testExpandableCardComponentWithCallbacks() {
        // Given: Expandable card component with callbacks
        resetCallbacks()
        let item = sampleItems[0]
        let layoutDecision = IntelligentCardLayoutDecision(
            columns: 2,
            spacing: 16,
            cardWidth: 200,
            cardHeight: 150,
            padding: 16
        )
        let strategy = CardExpansionStrategy(
            supportedStrategies: [.hoverExpand, .contentReveal],
            primaryStrategy: .hoverExpand,
            expansionScale: 1.2,
            animationDuration: 0.3,
            hapticFeedback: true,
            accessibilitySupport: true
        )
        
        // When: Creating expandable card component
        let view = ExpandableCardComponent(
            item: item,
            layoutDecision: layoutDecision,
            strategy: strategy,
            isExpanded: false,
            isHovered: false,
            onExpand: { },
            onCollapse: { },
            onHover: { _ in },
            onItemSelected: { item in self.selectedItems.append(item) },
            onItemDeleted: { item in self.deletedItems.append(item) },
            onItemEdited: { item in self.editedItems.append(item) }
        )
        
        // Then: View should be created successfully
        #expect(view != nil)
    }
    
    @Test func testSimpleCardComponentWithCallbacks() {
        // Given: Simple card component with callbacks
        resetCallbacks()
        let item = sampleItems[0]
        let layoutDecision = IntelligentCardLayoutDecision(
            columns: 2,
            spacing: 16,
            cardWidth: 200,
            cardHeight: 150,
            padding: 16
        )
        
        // When: Creating simple card component
        let view = SimpleCardComponent(
            item: item,
            layoutDecision: layoutDecision,
            hints: PresentationHints(),
            onItemSelected: { item in self.selectedItems.append(item) },
            onItemDeleted: { item in self.deletedItems.append(item) },
            onItemEdited: { item in self.editedItems.append(item) }
        )
        
        // Then: View should be created successfully
        #expect(view != nil)
    }
    
    @Test func testCoverFlowCardComponentWithCallbacks() {
        // Given: Cover flow card component with callbacks
        resetCallbacks()
        let item = sampleItems[0]
        
        // When: Creating cover flow card component
        let view = CoverFlowCardComponent(
            item: item,
            onItemSelected: { item in self.selectedItems.append(item) },
            onItemDeleted: { item in self.deletedItems.append(item) },
            onItemEdited: { item in self.editedItems.append(item) }
        )
        
        // Then: View should be created successfully
        #expect(view != nil)
    }
    
    // MARK: - Empty State Tests
    
    @Test func testEmptyCollectionWithCreateCallback() {
        // Given: Empty collection with create callback
        resetCallbacks()
        
        // When: Creating view with empty collection
        let view = platformPresentItemCollection_L1(
            items: [TestItem]() as [TestItem],
            hints: basicHints,
            onCreateItem: { self.createdItems += 1 }
        )
        
        // Then: View should be created successfully
        #expect(view != nil)
    }
    
    @Test func testEmptyCollectionWithoutCreateCallback() {
        // Given: Empty collection without create callback
        resetCallbacks()
        
        // When: Creating view with empty collection
        let view = platformPresentItemCollection_L1(
            items: [TestItem]() as [TestItem],
            hints: basicHints
        )
        
        // Then: View should be created successfully
        #expect(view != nil)
    }
    
    // MARK: - Backward Compatibility Tests
    
    @Test func testBackwardCompatibilityWithoutNewCallbacks() {
        // Given: Existing code without new callback parameters
        resetCallbacks()
        
        // When: Creating view with old API
        let view = platformPresentItemCollection_L1(
            items: sampleItems,
            hints: basicHints,
            onCreateItem: { self.createdItems += 1 }
        )
        
        // Then: View should be created successfully
        #expect(view != nil)
    }
    
    @Test func testBackwardCompatibilityWithEnhancedHints() {
        // Given: Existing code with enhanced hints but no new callbacks
        resetCallbacks()
        
        // When: Creating view with enhanced hints but old callback API
        let view = platformPresentItemCollection_L1(
            items: sampleItems,
            hints: enhancedHints,
            onCreateItem: { self.createdItems += 1 }
        )
        
        // Then: View should be created successfully
        #expect(view != nil)
    }
    
    // MARK: - Edge Case Tests
    
    @Test func testNilCallbacks() {
        // Given: Collection view with nil callbacks
        resetCallbacks()
        
        // When: Creating view with nil callbacks
        let view = platformPresentItemCollection_L1(
            items: sampleItems,
            hints: basicHints,
            onCreateItem: nil,
            onItemSelected: nil,
            onItemDeleted: nil,
            onItemEdited: nil
        )
        
        // Then: View should be created successfully
        #expect(view != nil)
    }
    
    @Test func testSingleItemCollection() {
        // Given: Collection with single item
        resetCallbacks()
        let singleItem = [sampleItems[0]]
        
        // When: Creating view with single item
        let view = platformPresentItemCollection_L1(
            items: singleItem,
            hints: basicHints,
            onCreateItem: { self.createdItems += 1 },
            onItemSelected: { item in self.selectedItems.append(item) },
            onItemDeleted: { item in self.deletedItems.append(item) },
            onItemEdited: { item in self.editedItems.append(item) }
        )
        
        // Then: View should be created successfully
        #expect(view != nil)
    }
    
    @Test func testLargeCollection() {
        // Given: Collection with many items
        resetCallbacks()
        let largeCollection = (1...100).map { i in
            TestItem(id: "\(i)", title: "Item \(i)", description: "Description \(i)")
        }
        
        // When: Creating view with large collection
        let view = platformPresentItemCollection_L1(
            items: largeCollection,
            hints: basicHints,
            onCreateItem: { self.createdItems += 1 },
            onItemSelected: { item in self.selectedItems.append(item) },
            onItemDeleted: { item in self.deletedItems.append(item) },
            onItemEdited: { item in self.editedItems.append(item) }
        )
        
        // Then: View should be created successfully
        #expect(view != nil)
    }
}
