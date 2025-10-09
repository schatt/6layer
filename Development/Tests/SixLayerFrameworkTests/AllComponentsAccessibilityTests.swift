import XCTest
import SwiftUI
@testable import SixLayerFramework
import ViewInspector

/// Comprehensive Accessibility Tests for ALL SixLayer Components
/// 
/// BUSINESS PURPOSE: Ensure every SixLayer component generates proper accessibility identifiers
/// TESTING SCOPE: All public View components and functions in the framework
/// METHODOLOGY: Test each component to verify accessibility identifier generation
@MainActor
final class AllComponentsAccessibilityTests: XCTestCase {
    
    // MARK: - Test Setup
    
    override func setUp() {
        super.setUp()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
        config.enableAutoIDs = true
        config.namespace = "SixLayer"
        config.mode = .automatic
        config.enableDebugLogging = false
    }
    
    override func tearDown() {
        super.tearDown()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
    }
    
    // MARK: - PlatformInteractionButton Tests
    
    func testPlatformInteractionButtonGeneratesAccessibilityIdentifiers() async {
        let view = PlatformInteractionButton(style: .primary, action: {}) {
            Text("Test Button")
        }
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*platforminteractionbutton", 
            componentName: "PlatformInteractionButton"
        )
        
        XCTAssertTrue(hasAccessibilityID, "PlatformInteractionButton should generate accessibility identifiers")
    }
    
    // MARK: - OCROverlayView Tests
    
    func testOCROverlayViewGeneratesAccessibilityIdentifiers() async {
        let view = OCROverlayView(
            text: "Test OCR Text",
            confidence: 0.95,
            onTap: {}
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*ocroverlayview", 
            componentName: "OCROverlayView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "OCROverlayView should generate accessibility identifiers")
    }
    
    // MARK: - ExpandableCardCollectionView Tests
    
    func testExpandableCardCollectionViewGeneratesAccessibilityIdentifiers() async {
        let testItems = [
            TestItem(id: "item1", title: "Test Item 1"),
            TestItem(id: "item2", title: "Test Item 2")
        ]
        
        let view = ExpandableCardCollectionView(
            items: testItems,
            cardContent: { item in
                Text(item.title)
            }
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*expandablecardcollectionview", 
            componentName: "ExpandableCardCollectionView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "ExpandableCardCollectionView should generate accessibility identifiers")
    }
    
    // MARK: - GenericItemCollectionView Tests
    
    func testGenericItemCollectionViewGeneratesAccessibilityIdentifiers() async {
        let testItems = [
            TestItem(id: "item1", title: "Test Item 1"),
            TestItem(id: "item2", title: "Test Item 2")
        ]
        
        let view = GenericItemCollectionView(
            items: testItems,
            itemContent: { item in
                Text(item.title)
            }
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*genericitemcollectionview", 
            componentName: "GenericItemCollectionView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "GenericItemCollectionView should generate accessibility identifiers")
    }
    
    // MARK: - CustomItemCollectionView Tests
    
    func testCustomItemCollectionViewGeneratesAccessibilityIdentifiers() async {
        let testItems = [
            TestItem(id: "item1", title: "Test Item 1"),
            TestItem(id: "item2", title: "Test Item 2")
        ]
        
        let view = CustomItemCollectionView(
            items: testItems,
            itemContent: { item in
                Text(item.title)
            }
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*customitemcollectionview", 
            componentName: "CustomItemCollectionView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "CustomItemCollectionView should generate accessibility identifiers")
    }
    
    // MARK: - GenericNumericDataView Tests
    
    func testGenericNumericDataViewGeneratesAccessibilityIdentifiers() async {
        let view = GenericNumericDataView(
            data: GenericNumericData(value: 123.45, label: "Test Value", unit: "units")
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*genericnumericdataview", 
            componentName: "GenericNumericDataView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "GenericNumericDataView should generate accessibility identifiers")
    }
    
    // MARK: - GenericFormView Tests
    
    func testGenericFormViewGeneratesAccessibilityIdentifiers() async {
        let view = GenericFormView(
            fields: [
                DynamicFormField(id: "field1", contentType: .text, label: "Test Field")
            ]
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*genericformview", 
            componentName: "GenericFormView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "GenericFormView should generate accessibility identifiers")
    }
    
    // MARK: - GenericMediaView Tests
    
    func testGenericMediaViewGeneratesAccessibilityIdentifiers() async {
        let view = GenericMediaView(
            media: GenericMediaItem(title: "Test Media", url: "https://example.com")
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*genericmediaview", 
            componentName: "GenericMediaView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "GenericMediaView should generate accessibility identifiers")
    }
    
    // MARK: - GenericHierarchicalView Tests
    
    func testGenericHierarchicalViewGeneratesAccessibilityIdentifiers() async {
        let view = GenericHierarchicalView(
            data: HierarchicalData(title: "Test Hierarchy", children: [])
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*generichierarchicalview", 
            componentName: "GenericHierarchicalView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "GenericHierarchicalView should generate accessibility identifiers")
    }
    
    // MARK: - GenericTemporalView Tests
    
    func testGenericTemporalViewGeneratesAccessibilityIdentifiers() async {
        let view = GenericTemporalView(
            data: TemporalData(title: "Test Temporal", timestamp: Date())
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*generictemporalview", 
            componentName: "GenericTemporalView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "GenericTemporalView should generate accessibility identifiers")
    }
    
    // MARK: - ModalFormView Tests
    
    func testModalFormViewGeneratesAccessibilityIdentifiers() async {
        let view = ModalFormView(
            title: "Test Modal",
            fields: [
                DynamicFormField(id: "field1", contentType: .text, label: "Test Field")
            ]
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*modalformview", 
            componentName: "ModalFormView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "ModalFormView should generate accessibility identifiers")
    }
    
    // MARK: - GenericContentView Tests
    
    func testGenericContentViewGeneratesAccessibilityIdentifiers() async {
        let view = GenericContentView(
            content: AnyView(Text("Test Content"))
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*genericcontentview", 
            componentName: "GenericContentView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "GenericContentView should generate accessibility identifiers")
    }
    
    // MARK: - GenericSettingsView Tests
    
    func testGenericSettingsViewGeneratesAccessibilityIdentifiers() async {
        let view = GenericSettingsView(
            settings: [
                SettingsSectionData(
                    title: "General",
                    items: [
                        SettingsItemData(key: "theme", title: "Theme", type: .toggle, value: "dark")
                    ]
                )
            ]
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*genericsettingsview", 
            componentName: "GenericSettingsView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "GenericSettingsView should generate accessibility identifiers")
    }
    
    // MARK: - CustomGridCollectionView Tests
    
    func testCustomGridCollectionViewGeneratesAccessibilityIdentifiers() async {
        let testItems = [
            TestItem(id: "item1", title: "Test Item 1"),
            TestItem(id: "item2", title: "Test Item 2")
        ]
        
        let view = CustomGridCollectionView(
            items: testItems,
            itemContent: { item in
                Text(item.title)
            }
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*customgridcollectionview", 
            componentName: "CustomGridCollectionView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "CustomGridCollectionView should generate accessibility identifiers")
    }
    
    // MARK: - CustomListCollectionView Tests
    
    func testCustomListCollectionViewGeneratesAccessibilityIdentifiers() async {
        let testItems = [
            TestItem(id: "item1", title: "Test Item 1"),
            TestItem(id: "item2", title: "Test Item 2")
        ]
        
        let view = CustomListCollectionView(
            items: testItems,
            itemContent: { item in
                Text(item.title)
            }
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*customlistcollectionview", 
            componentName: "CustomListCollectionView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "CustomListCollectionView should generate accessibility identifiers")
    }
    
    // MARK: - CustomSettingsView Tests
    
    func testCustomSettingsViewGeneratesAccessibilityIdentifiers() async {
        let view = CustomSettingsView(
            title: "Test Settings",
            sections: [
                SettingsSectionData(
                    title: "General",
                    items: [
                        SettingsItemData(key: "theme", title: "Theme", type: .toggle, value: "dark")
                    ]
                )
            ]
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*customsettingsview", 
            componentName: "CustomSettingsView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "CustomSettingsView should generate accessibility identifiers")
    }
    
    // MARK: - CustomMediaView Tests
    
    func testCustomMediaViewGeneratesAccessibilityIdentifiers() async {
        let view = CustomMediaView(
            media: GenericMediaItem(title: "Test Media", url: "https://example.com")
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*custommediaview", 
            componentName: "CustomMediaView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "CustomMediaView should generate accessibility identifiers")
    }
    
    // MARK: - CustomHierarchicalView Tests
    
    func testCustomHierarchicalViewGeneratesAccessibilityIdentifiers() async {
        let view = CustomHierarchicalView(
            data: HierarchicalData(title: "Test Hierarchy", children: [])
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*customhierarchicalview", 
            componentName: "CustomHierarchicalView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "CustomHierarchicalView should generate accessibility identifiers")
    }
    
    // MARK: - CustomTemporalView Tests
    
    func testCustomTemporalViewGeneratesAccessibilityIdentifiers() async {
        let view = CustomTemporalView(
            data: TemporalData(title: "Test Temporal", timestamp: Date())
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*customtemporalview", 
            componentName: "CustomTemporalView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "CustomTemporalView should generate accessibility identifiers")
    }
    
    // MARK: - CustomNumericDataView Tests
    
    func testCustomNumericDataViewGeneratesAccessibilityIdentifiers() async {
        let view = CustomNumericDataView(
            data: GenericNumericData(value: 123.45, label: "Test Value", unit: "units")
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*customnumericdataview", 
            componentName: "CustomNumericDataView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "CustomNumericDataView should generate accessibility identifiers")
    }
    
    // MARK: - CollectionEmptyStateView Tests
    
    func testCollectionEmptyStateViewGeneratesAccessibilityIdentifiers() async {
        let view = CollectionEmptyStateView(
            title: "No Items",
            message: "No items to display",
            actionTitle: "Add Item",
            action: {}
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*collectionemptystateview", 
            componentName: "CollectionEmptyStateView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "CollectionEmptyStateView should generate accessibility identifiers")
    }
    
    // MARK: - Platform-Aware Expandable Card Tests
    
    func testPlatformAwareExpandableCardViewGeneratesAccessibilityIdentifiers() async {
        let testItems = [
            TestItem(id: "item1", title: "Test Item 1"),
            TestItem(id: "item2", title: "Test Item 2")
        ]
        
        let view = PlatformAwareExpandableCardView(
            items: testItems,
            cardContent: { item in
                Text(item.title)
            }
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*platformawareexpandablecardview", 
            componentName: "PlatformAwareExpandableCardView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "PlatformAwareExpandableCardView should generate accessibility identifiers")
    }
}

// MARK: - Test Support Types

struct TestItem: Identifiable {
    let id: String
    let title: String
}
