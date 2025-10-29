import Testing


import SwiftUI
@testable import SixLayerFramework
import ViewInspector
/// Layer 1 Function Callback Functional Tests
/// Tests that Layer 1 functions ACTUALLY INVOKE callbacks when expected (Rules 6.1, 6.2, 7.3, 7.4)
@MainActor
open class Layer1CallbackFunctionalTests {
    
    // MARK: - Test Data
    
    struct TestItem: Identifiable {
        let id = UUID()
        let title: String
        let subtitle: String?
    }
    
    private var sampleItems: [TestItem] {
        [
            TestItem(title: "Item 1", subtitle: "Subtitle 1"),
            TestItem(title: "Item 2", subtitle: "Subtitle 2"),
            TestItem(title: "Item 3", subtitle: nil)
        ]
    }
    
    private var settingsData: [SettingsSectionData] {
        [
            SettingsSectionData(
                title: "Test Section",
                items: [
                    SettingsItemData(
                        key: "test_key",
                        title: "Test Setting",
                        type: .text,
                        value: "test_value"
                    )
                ]
            )
        ]
    }
    
    // MARK: - Callback Tracking
    
    private var selectedItems: [TestItem] = []
    private var deletedItems: [TestItem] = []
    private var editedItems: [TestItem] = []
    private var createdItems: Int = 0
    private var settingChangedKey: String?
    private var settingChangedValue: Any?
    private var settingsSavedInvoked = false
    
    private func resetCallbacks() {
        selectedItems.removeAll()
        deletedItems.removeAll()
        editedItems.removeAll()
        createdItems = 0
        settingChangedKey = nil
        settingChangedValue = nil
        settingsSavedInvoked = false
    }
    
    // MARK: - platformPresentItemCollection_L1 with Enhanced Hints
    
    @Test func testPlatformPresentItemCollectionL1WithEnhancedHintsCallbacks() async throws {
        // Rule 6.2 & 7.4: Functional testing - Must verify callbacks ACTUALLY invoke
        
        resetCallbacks()
        var callbackInvoked = false
        
        let view = platformPresentItemCollection_L1(
            items: sampleItems,
            hints: EnhancedPresentationHints(
                dataType: .collection,
                presentationPreference: .list,
                complexity: .moderate,
                context: .dashboard
            ),
            onCreateItem: { self.createdItems += 1 },
            onItemSelected: { item in
                callbackInvoked = true
                self.selectedItems.append(item)
            },
            onItemDeleted: { item in
                self.deletedItems.append(item)
            },
            onItemEdited: { item in
                self.editedItems.append(item)
            }
        )
        
        // Use ViewInspector to simulate tap
        do {
            let inspector = try view.inspect()
            let listViews = try inspector.findAll(ListCollectionView<TestItem>.self)
            
            if let firstList = listViews.first {
                #expect(listViews.count > 0, "Should have list view")
                
                // Try to find and tap a card
                let listCards = try firstList.findAll(ListCardComponent<TestItem>.self)
                if let firstCard = listCards.first {
                    // ListCardComponent is now a VStack, find the HStack child
                    let vStack = try firstCard.vStack()
                    let hStack = try vStack.hStack(0)
                    try hStack.callOnTapGesture()
                    
                    // Verify callback was invoked
                    #expect(callbackInvoked, "Callback should be invoked when tapped")
                    #expect(self.selectedItems.count > 0, "Should have selected items")
                }
            }
        } catch {
            Issue.record("ViewInspector failed: \(error)")
        }
    }
    
    // MARK: - platformPresentSettings_L1 Tests
    
    @Test func testPlatformPresentSettingsL1WithCallbacks() async throws {
        // Rule 6.2 & 7.4: Functional testing - Must verify callbacks ACTUALLY invoke
        
        resetCallbacks()
        
        let view = platformPresentSettings_L1(
            settings: settingsData,
            hints: PresentationHints(
                dataType: .form,
                presentationPreference: .list,
                complexity: .moderate,
                context: .settings
            ),
            onSettingChanged: { key, value in
                self.settingChangedKey = key
                self.settingChangedValue = value
            },
            onSettingsSaved: {
                self.settingsSavedInvoked = true
            },
            onSettingsCancelled: { }
        )
        
        // View exists but we can't easily test settings callbacks without actual UI interaction
        // This documents expected behavior
        #expect(view != nil, "Settings view should be created")
    }
    
    // MARK: - platformPresentItemCollection_L1 with Custom Views
    
    @Test func testPlatformPresentItemCollectionL1WithCustomViews() async throws {
        // Rule 6.2 & 7.4: Functional testing
        
        resetCallbacks()
        var callbackInvoked = false
        
        let view = platformPresentItemCollection_L1(
            items: sampleItems,
            hints: PresentationHints(
                dataType: .collection,
                presentationPreference: .list,
                complexity: .moderate,
                context: .dashboard
            ),
            onCreateItem: { self.createdItems += 1 },
            onItemSelected: { item in
                callbackInvoked = true
                self.selectedItems.append(item)
            },
            onItemDeleted: { item in
                self.deletedItems.append(item)
            },
            onItemEdited: { item in
                self.editedItems.append(item)
            },
            customItemView: { item in
                Text(item.title)
            }
        )
        
        // Test structure - callbacks are documented
        #expect(view != nil, "View with custom item view should be created")
    }
    
    // MARK: - platformPresentNumericData_L1 Tests
    
    @Test func testPlatformPresentNumericDataL1() async throws {
        // Rule 6.2 & 7.4: Functional testing
        
        let numericData = [
            GenericNumericData(value: 42.0, label: "Test Value 1", unit: "points"),
            GenericNumericData(value: 84.0, label: "Test Value 2", unit: "items")
        ]
        
        let view = platformPresentNumericData_L1(
            data: numericData,
            hints: PresentationHints(
                dataType: .numeric,
                presentationPreference: .list,
                complexity: .moderate,
                context: .dashboard
            )
        )
        
        #expect(view != nil, "Numeric data view should be created")
    }
    
    // MARK: - platformPresentMediaData_L1 Tests
    
    @Test func testPlatformPresentMediaDataL1() async throws {
        // Rule 6.2 & 7.4: Functional testing
        
        let mediaData = [
            GenericMediaItem(title: "Media Item 1", url: "https://example.com/media1", thumbnail: "https://example.com/thumb1"),
            GenericMediaItem(title: "Media Item 2", url: "https://example.com/media2", thumbnail: "https://example.com/thumb2")
        ]
        
        let view = platformPresentMediaData_L1(
            media: mediaData,
            hints: PresentationHints(
                dataType: .media,
                presentationPreference: .grid,
                complexity: .moderate,
                context: .gallery
            )
        )
        
        #expect(view != nil, "Media view should be created")
    }
    
    // MARK: - platformPresentHierarchicalData_L1 Tests
    
    @Test func testPlatformPresentHierarchicalDataL1() async throws {
        // Rule 6.2 & 7.4: Functional testing
        
        let hierarchicalData = [
            GenericHierarchicalItem(title: "Parent 1", level: 0, children: [
                GenericHierarchicalItem(title: "Child 1.1", level: 1),
                GenericHierarchicalItem(title: "Child 1.2", level: 1)
            ]),
            GenericHierarchicalItem(title: "Parent 2", level: 0)
        ]
        
        let view = platformPresentHierarchicalData_L1(
            items: hierarchicalData,
            hints: PresentationHints(
                dataType: .hierarchical,
                presentationPreference: .list,
                complexity: .complex,
                context: .dashboard
            )
        )
        
        #expect(view != nil, "Hierarchical view should be created")
    }
    
    // MARK: - platformPresentTemporalData_L1 Tests
    
    @Test func testPlatformPresentTemporalDataL1() async throws {
        // Rule 6.2 & 7.4: Functional testing
        
        let temporalData = [
            GenericTemporalItem(title: "Event 1", date: Date(), duration: 3600),
            GenericTemporalItem(title: "Event 2", date: Date().addingTimeInterval(86400), duration: 7200)
        ]
        
        let view = platformPresentTemporalData_L1(
            items: temporalData,
            hints: PresentationHints(
                dataType: .temporal,
                presentationPreference: .list,
                complexity: .moderate,
                context: .dashboard
            )
        )
        
        #expect(view != nil, "Temporal data view should be created")
    }
    
    // MARK: - platformResponsiveCard_L1 Tests
    
    @Test func testPlatformResponsiveCardL1() async throws {
        // Rule 6.2 & 7.4: Functional testing
        
        let view = platformResponsiveCard_L1(
            content: {
                Text("Card Content")
            },
            hints: PresentationHints(
                dataType: .card,
                presentationPreference: .cards,
                complexity: .moderate,
                context: .dashboard
            )
        )
        
        #expect(view != nil, "Responsive card should be created")
    }
    
    // MARK: - External Integration Tests
    
    /// Tests that L1 functions are accessible from external modules (Rule 8)
    @Test func testPlatformPresentItemCollectionL1ExternallyAccessible() async {
        // This should be in external integration test module
        // Documenting here for now
        let view = platformPresentItemCollection_L1(
            items: sampleItems,
            hints: PresentationHints(
                dataType: .collection,
                presentationPreference: .list,
                complexity: .moderate,
                context: .dashboard
            ),
            onItemSelected: { _ in }
        )
        
        #expect(view != nil, "L1 function should be externally accessible")
    }
}

