import XCTest
import SwiftUI
@testable import SixLayerFramework
import ViewInspector

/// Tests for IntelligentCardExpansionLayer4.swift
/// 
/// BUSINESS PURPOSE: Ensure Layer 4 card expansion components generate proper accessibility identifiers
/// TESTING SCOPE: All components in IntelligentCardExpansionLayer4.swift
/// METHODOLOGY: Test each component on both iOS and macOS platforms as required by mandatory testing guidelines
@MainActor
final class IntelligentCardExpansionLayer4Tests: XCTestCase {
    
    // MARK: - Test Setup
    
    override func setUp() {
        super.setUp()
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
    
    // MARK: - ExpandableCardCollectionView Tests
    
    func testExpandableCardCollectionViewGeneratesAccessibilityIdentifiersOnIOS() async {
        let testItems = [
            IntelligentCardExpansionLayer4TestItem(id: "item1", title: "Test Item 1"),
            IntelligentCardExpansionLayer4TestItem(id: "item2", title: "Test Item 2")
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
            platform: .iOS,
            componentName: "ExpandableCardCollectionView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "ExpandableCardCollectionView should generate accessibility identifiers on iOS")
    }
    
    func testExpandableCardCollectionViewGeneratesAccessibilityIdentifiersOnMacOS() async {
        let testItems = [
            IntelligentCardExpansionLayer4TestItem(id: "item1", title: "Test Item 1"),
            IntelligentCardExpansionLayer4TestItem(id: "item2", title: "Test Item 2")
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
            platform: .macOS,
            componentName: "ExpandableCardCollectionView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "ExpandableCardCollectionView should generate accessibility identifiers on macOS")
    }
}

// MARK: - Test Support Types

/// Test item for IntelligentCardExpansionLayer4 testing
struct IntelligentCardExpansionLayer4TestItem: Identifiable {
    let id: String
    let title: String
    
    init(id: String, title: String) {
        self.id = id
        self.title = title
    }
}

