import XCTest
import SwiftUI
@testable import SixLayerFramework
import ViewInspector

/// Tests for CustomItemCollectionView component
/// 
/// BUSINESS PURPOSE: Ensure CustomItemCollectionView generates proper accessibility identifiers
/// TESTING SCOPE: CustomItemCollectionView component from PlatformSemanticLayer1.swift
/// METHODOLOGY: Test component on both iOS and macOS platforms as required by mandatory testing guidelines
@MainActor
final class CustomItemCollectionViewTests: XCTestCase {
    
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
    
    // MARK: - CustomItemCollectionView Tests
    
    func testCustomItemCollectionViewGeneratesAccessibilityIdentifiersOnIOS() async {
        let testItems = [
            CustomItemCollectionViewTestItem(id: "item1", title: "Test Item 1"),
            CustomItemCollectionViewTestItem(id: "item2", title: "Test Item 2")
        ]
        
        let view = GenericItemCollectionView<CustomItemCollectionViewTestItem>(
            items: testItems,
            hints: PresentationHints(
                dataType: .collection,
                presentationPreference: .automatic
            )
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.main.element.*", 
            platform: .iOS,
            componentName: "CustomItemCollectionView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "CustomItemCollectionView should generate accessibility identifiers on iOS")
    }
    
    func testCustomItemCollectionViewGeneratesAccessibilityIdentifiersOnMacOS() async {
        let testItems = [
            CustomItemCollectionViewTestItem(id: "item1", title: "Test Item 1"),
            CustomItemCollectionViewTestItem(id: "item2", title: "Test Item 2")
        ]
        
        let view = GenericItemCollectionView<CustomItemCollectionViewTestItem>(
            items: testItems,
            hints: PresentationHints(
                dataType: .collection,
                presentationPreference: .automatic
            )
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.main.element.*", 
            platform: .macOS,
            componentName: "CustomItemCollectionView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "CustomItemCollectionView should generate accessibility identifiers on macOS")
    }
}

// MARK: - Test Support Types

/// Test item for CustomItemCollectionView testing
struct CustomItemCollectionViewTestItem: Identifiable {
    let id: String
    let title: String
    
    init(id: String, title: String) {
        self.id = id
        self.title = title
    }
}
