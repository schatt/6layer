import XCTest
import SwiftUI
@testable import SixLayerFramework
import ViewInspector

/// Comprehensive Accessibility Tests for Remaining SixLayer Components
/// 
/// BUSINESS PURPOSE: Ensure every remaining SixLayer component generates proper accessibility identifiers
/// TESTING SCOPE: Layer 4 components and other remaining components in the framework
/// METHODOLOGY: Test each component on both iOS and macOS platforms as required by mandatory testing guidelines
@MainActor
final class RemainingComponentsAccessibilityTests: XCTestCase {
    
    // MARK: - Test Setup
    
    override func setUp() async throws {
        try await super.setUp()
        setupTestEnvironment()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
        config.enableAutoIDs = true
        config.namespace = "SixLayer"
        config.mode = .automatic
        config.enableDebugLogging = false
    }
    
    override func tearDown() {
        super.tearDown()
        cleanupTestEnvironment()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
    }
    
    // MARK: - ExpandableCardComponent Tests
    
    func testExpandableCardComponentGeneratesAccessibilityIdentifiersOnIOS() async {
        let testItem = RemainingComponentsTestItem(id: "1", title: "Test Card", subtitle: "Test Subtitle")
        
        let layoutDecision = IntelligentCardLayoutDecision(
            columns: 2,
            spacing: 16,
            cardWidth: 150,
            cardHeight: 200,
            padding: 16,
            expansionScale: 1.2,
            animationDuration: 0.3
        )
        
        let strategy = CardExpansionStrategy(
            supportedStrategies: [.hoverExpand, .contentReveal],
            primaryStrategy: .hoverExpand,
            expansionScale: 1.2,
            animationDuration: 0.3,
            hapticFeedback: true,
            accessibilitySupport: true
        )
        
        let view = ExpandableCardComponent(
            item: testItem,
            layoutDecision: layoutDecision,
            strategy: strategy,
            isExpanded: false,
            isHovered: false,
            onExpand: {},
            onCollapse: {},
            onHover: { _ in },
            onItemSelected: nil,
            onItemDeleted: nil,
            onItemEdited: nil
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*expandablecardcomponent", 
            platform: .iOS,
            componentName: "ExpandableCardComponent"
        )
        
        XCTAssertTrue(hasAccessibilityID, "ExpandableCardComponent should generate accessibility identifiers on iOS")
    }
    
    func testExpandableCardComponentGeneratesAccessibilityIdentifiersOnMacOS() async {
        let testItem = RemainingComponentsTestItem(id: "1", title: "Test Card", subtitle: "Test Subtitle")
        
        let layoutDecision = IntelligentCardLayoutDecision(
            columns: 3,
            spacing: 20,
            cardWidth: 200,
            cardHeight: 250,
            padding: 20,
            expansionScale: 1.3,
            animationDuration: 0.4
        )
        
        let strategy = CardExpansionStrategy(
            supportedStrategies: [.hoverExpand, .contentReveal],
            primaryStrategy: .contentReveal,
            expansionScale: 1.3,
            animationDuration: 0.4,
            hapticFeedback: false,
            accessibilitySupport: true
        )
        
        let view = ExpandableCardComponent(
            item: testItem,
            layoutDecision: layoutDecision,
            strategy: strategy,
            isExpanded: false,
            isHovered: false,
            onExpand: {},
            onCollapse: {},
            onHover: { _ in },
            onItemSelected: nil,
            onItemDeleted: nil,
            onItemEdited: nil
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*expandablecardcomponent", 
            platform: .macOS,
            componentName: "ExpandableCardComponent"
        )
        
        XCTAssertTrue(hasAccessibilityID, "ExpandableCardComponent should generate accessibility identifiers on macOS")
    }
    
    // MARK: - CoverFlowCollectionView Tests
    
    func testCoverFlowCollectionViewGeneratesAccessibilityIdentifiersOnIOS() async {
        let testItems = [
            RemainingComponentsTestItem(id: "1", title: "Item 1", subtitle: "Subtitle 1"),
            RemainingComponentsTestItem(id: "2", title: "Item 2", subtitle: "Subtitle 2")
        ]
        
        let view = CoverFlowCollectionView(
            items: testItems,
            hints: PresentationHints(
                dataType: .generic,
                presentationPreference: .automatic,
                complexity: .moderate,
                context: .modal,
                customPreferences: [:]
            )
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*coverflowcollectionview", 
            platform: .iOS,
            componentName: "CoverFlowCollectionView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "CoverFlowCollectionView should generate accessibility identifiers on iOS")
    }
    
    func testCoverFlowCollectionViewGeneratesAccessibilityIdentifiersOnMacOS() async {
        let testItems = [
            RemainingComponentsTestItem(id: "1", title: "Item 1", subtitle: "Subtitle 1"),
            RemainingComponentsTestItem(id: "2", title: "Item 2", subtitle: "Subtitle 2")
        ]
        
        let view = CoverFlowCollectionView(
            items: testItems,
            hints: PresentationHints(
                dataType: .generic,
                presentationPreference: .automatic,
                complexity: .moderate,
                context: .modal,
                customPreferences: [:]
            )
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*coverflowcollectionview", 
            platform: .macOS,
            componentName: "CoverFlowCollectionView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "CoverFlowCollectionView should generate accessibility identifiers on macOS")
    }
    
    // MARK: - CoverFlowCardComponent Tests
    
    func testCoverFlowCardComponentGeneratesAccessibilityIdentifiersOnIOS() async {
        let testItem = RemainingComponentsTestItem(id: "1", title: "Test Card", subtitle: "Test Subtitle")
        
        let view = CoverFlowCardComponent(
            item: testItem,
            onItemSelected: nil,
            onItemDeleted: nil,
            onItemEdited: nil
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*coverflowcardcomponent", 
            platform: .iOS,
            componentName: "CoverFlowCardComponent"
        )
        
        XCTAssertTrue(hasAccessibilityID, "CoverFlowCardComponent should generate accessibility identifiers on iOS")
    }
    
    func testCoverFlowCardComponentGeneratesAccessibilityIdentifiersOnMacOS() async {
        let testItem = RemainingComponentsTestItem(id: "1", title: "Test Card", subtitle: "Test Subtitle")
        
        let view = CoverFlowCardComponent(
            item: testItem,
            onItemSelected: nil,
            onItemDeleted: nil,
            onItemEdited: nil
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*coverflowcardcomponent", 
            platform: .macOS,
            componentName: "CoverFlowCardComponent"
        )
        
        XCTAssertTrue(hasAccessibilityID, "CoverFlowCardComponent should generate accessibility identifiers on macOS")
    }
    
    // MARK: - GridCollectionView Tests
    
    func testGridCollectionViewGeneratesAccessibilityIdentifiersOnIOS() async {
        let testItems = [
            RemainingComponentsTestItem(id: "1", title: "Item 1", subtitle: "Subtitle 1"),
            RemainingComponentsTestItem(id: "2", title: "Item 2", subtitle: "Subtitle 2")
        ]
        
        let view = GridCollectionView(
            items: testItems,
            hints: PresentationHints(
                dataType: .generic,
                presentationPreference: .automatic,
                complexity: .moderate,
                context: .modal,
                customPreferences: [:]
            )
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*gridcollectionview", 
            platform: .iOS,
            componentName: "GridCollectionView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "GridCollectionView should generate accessibility identifiers on iOS")
    }
    
    func testGridCollectionViewGeneratesAccessibilityIdentifiersOnMacOS() async {
        let testItems = [
            RemainingComponentsTestItem(id: "1", title: "Item 1", subtitle: "Subtitle 1"),
            RemainingComponentsTestItem(id: "2", title: "Item 2", subtitle: "Subtitle 2")
        ]
        
        let view = GridCollectionView(
            items: testItems,
            hints: PresentationHints(
                dataType: .generic,
                presentationPreference: .automatic,
                complexity: .moderate,
                context: .modal,
                customPreferences: [:]
            )
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*gridcollectionview", 
            platform: .macOS,
            componentName: "GridCollectionView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "GridCollectionView should generate accessibility identifiers on macOS")
    }
    
    // MARK: - ListCollectionView Tests
    
    func testListCollectionViewGeneratesAccessibilityIdentifiersOnIOS() async {
        let testItems = [
            RemainingComponentsTestItem(id: "1", title: "Item 1", subtitle: "Subtitle 1"),
            RemainingComponentsTestItem(id: "2", title: "Item 2", subtitle: "Subtitle 2")
        ]
        
        let view = ListCollectionView(
            items: testItems,
            hints: PresentationHints(
                dataType: .generic,
                presentationPreference: .automatic,
                complexity: .moderate,
                context: .modal,
                customPreferences: [:]
            )
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*listcollectionview", 
            platform: .iOS,
            componentName: "ListCollectionView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "ListCollectionView should generate accessibility identifiers on iOS")
    }
    
    func testListCollectionViewGeneratesAccessibilityIdentifiersOnMacOS() async {
        let testItems = [
            RemainingComponentsTestItem(id: "1", title: "Item 1", subtitle: "Subtitle 1"),
            RemainingComponentsTestItem(id: "2", title: "Item 2", subtitle: "Subtitle 2")
        ]
        
        let view = ListCollectionView(
            items: testItems,
            hints: PresentationHints(
                dataType: .generic,
                presentationPreference: .automatic,
                complexity: .moderate,
                context: .modal,
                customPreferences: [:]
            )
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*listcollectionview", 
            platform: .macOS,
            componentName: "ListCollectionView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "ListCollectionView should generate accessibility identifiers on macOS")
    }
    
    // MARK: - MasonryCollectionView Tests
    
    func testMasonryCollectionViewGeneratesAccessibilityIdentifiersOnIOS() async {
        let testItems = [
            RemainingComponentsTestItem(id: "1", title: "Item 1", subtitle: "Subtitle 1"),
            RemainingComponentsTestItem(id: "2", title: "Item 2", subtitle: "Subtitle 2")
        ]
        
        let view = MasonryCollectionView(
            items: testItems,
            hints: PresentationHints(
                dataType: .generic,
                presentationPreference: .automatic,
                complexity: .moderate,
                context: .modal,
                customPreferences: [:]
            )
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*masonrycollectionview", 
            platform: .iOS,
            componentName: "MasonryCollectionView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "MasonryCollectionView should generate accessibility identifiers on iOS")
    }
    
    func testMasonryCollectionViewGeneratesAccessibilityIdentifiersOnMacOS() async {
        let testItems = [
            RemainingComponentsTestItem(id: "1", title: "Item 1", subtitle: "Subtitle 1"),
            RemainingComponentsTestItem(id: "2", title: "Item 2", subtitle: "Subtitle 2")
        ]
        
        let view = MasonryCollectionView(
            items: testItems,
            hints: PresentationHints(
                dataType: .generic,
                presentationPreference: .automatic,
                complexity: .moderate,
                context: .modal,
                customPreferences: [:]
            )
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*masonrycollectionview", 
            platform: .macOS,
            componentName: "MasonryCollectionView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "MasonryCollectionView should generate accessibility identifiers on macOS")
    }
    
    // MARK: - AdaptiveCollectionView Tests
    
    func testAdaptiveCollectionViewGeneratesAccessibilityIdentifiersOnIOS() async {
        let testItems = [
            RemainingComponentsTestItem(id: "1", title: "Item 1", subtitle: "Subtitle 1"),
            RemainingComponentsTestItem(id: "2", title: "Item 2", subtitle: "Subtitle 2")
        ]
        
        let view = AdaptiveCollectionView(
            items: testItems,
            hints: PresentationHints(
                dataType: .generic,
                presentationPreference: .automatic,
                complexity: .moderate,
                context: .modal,
                customPreferences: [:]
            )
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*adaptivecollectionview", 
            platform: .iOS,
            componentName: "AdaptiveCollectionView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "AdaptiveCollectionView should generate accessibility identifiers on iOS")
    }
    
    func testAdaptiveCollectionViewGeneratesAccessibilityIdentifiersOnMacOS() async {
        let testItems = [
            RemainingComponentsTestItem(id: "1", title: "Item 1", subtitle: "Subtitle 1"),
            RemainingComponentsTestItem(id: "2", title: "Item 2", subtitle: "Subtitle 2")
        ]
        
        let view = AdaptiveCollectionView(
            items: testItems,
            hints: PresentationHints(
                dataType: .generic,
                presentationPreference: .automatic,
                complexity: .moderate,
                context: .modal,
                customPreferences: [:]
            )
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*adaptivecollectionview", 
            platform: .macOS,
            componentName: "AdaptiveCollectionView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "AdaptiveCollectionView should generate accessibility identifiers on macOS")
    }
    
    // MARK: - SimpleCardComponent Tests
    
    func testSimpleCardComponentGeneratesAccessibilityIdentifiersOnIOS() async {
        let testItem = RemainingComponentsTestItem(id: "1", title: "Test Card", subtitle: "Test Subtitle")
        
        let layoutDecision = IntelligentCardLayoutDecision(
            columns: 2,
            spacing: 16,
            cardWidth: 150,
            cardHeight: 200,
            padding: 16,
            expansionScale: 1.0,
            animationDuration: 0.3
        )
        
        let view = SimpleCardComponent(
            item: testItem,
            layoutDecision: layoutDecision,
            onItemSelected: nil,
            onItemDeleted: nil,
            onItemEdited: nil
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*simplecardcomponent", 
            platform: .iOS,
            componentName: "SimpleCardComponent"
        )
        
        XCTAssertTrue(hasAccessibilityID, "SimpleCardComponent should generate accessibility identifiers on iOS")
    }
    
    func testSimpleCardComponentGeneratesAccessibilityIdentifiersOnMacOS() async {
        let testItem = RemainingComponentsTestItem(id: "1", title: "Test Card", subtitle: "Test Subtitle")
        
        let layoutDecision = IntelligentCardLayoutDecision(
            columns: 3,
            spacing: 20,
            cardWidth: 200,
            cardHeight: 250,
            padding: 20,
            expansionScale: 1.0,
            animationDuration: 0.4
        )
        
        let view = SimpleCardComponent(
            item: testItem,
            layoutDecision: layoutDecision,
            onItemSelected: nil,
            onItemDeleted: nil,
            onItemEdited: nil
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*simplecardcomponent", 
            platform: .macOS,
            componentName: "SimpleCardComponent"
        )
        
        XCTAssertTrue(hasAccessibilityID, "SimpleCardComponent should generate accessibility identifiers on macOS")
    }
    
    // MARK: - ListCardComponent Tests
    
    func testListCardComponentGeneratesAccessibilityIdentifiersOnIOS() async {
        let testItem = RemainingComponentsTestItem(id: "1", title: "Test Card", subtitle: "Test Subtitle")
        
        let view = ListCardComponent(
            item: testItem,
            onItemSelected: nil,
            onItemDeleted: nil,
            onItemEdited: nil
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*listcardcomponent", 
            platform: .iOS,
            componentName: "ListCardComponent"
        )
        
        XCTAssertTrue(hasAccessibilityID, "ListCardComponent should generate accessibility identifiers on iOS")
    }
    
    func testListCardComponentGeneratesAccessibilityIdentifiersOnMacOS() async {
        let testItem = RemainingComponentsTestItem(id: "1", title: "Test Card", subtitle: "Test Subtitle")
        
        let view = ListCardComponent(
            item: testItem,
            onItemSelected: nil,
            onItemDeleted: nil,
            onItemEdited: nil
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*listcardcomponent", 
            platform: .macOS,
            componentName: "ListCardComponent"
        )
        
        XCTAssertTrue(hasAccessibilityID, "ListCardComponent should generate accessibility identifiers on macOS")
    }
    
    // MARK: - MasonryCardComponent Tests
    
    func testMasonryCardComponentGeneratesAccessibilityIdentifiersOnIOS() async {
        let testItem = RemainingComponentsTestItem(id: "1", title: "Test Card", subtitle: "Test Subtitle")
        
        let view = MasonryCardComponent(item: testItem)
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*masonrycardcomponent", 
            platform: .iOS,
            componentName: "MasonryCardComponent"
        )
        
        XCTAssertTrue(hasAccessibilityID, "MasonryCardComponent should generate accessibility identifiers on iOS")
    }
    
    func testMasonryCardComponentGeneratesAccessibilityIdentifiersOnMacOS() async {
        let testItem = RemainingComponentsTestItem(id: "1", title: "Test Card", subtitle: "Test Subtitle")
        
        let view = MasonryCardComponent(item: testItem)
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*masonrycardcomponent", 
            platform: .macOS,
            componentName: "MasonryCardComponent"
        )
        
        XCTAssertTrue(hasAccessibilityID, "MasonryCardComponent should generate accessibility identifiers on macOS")
    }
}

// MARK: - Test Support Types

/// Test item for testing purposes
struct RemainingComponentsTestItem: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    
    init(id: String, title: String, subtitle: String) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
    }
}