import XCTest
import SwiftUI
@testable import SixLayerFramework
import ViewInspector

/// Tests for CollectionEmptyStateView component
/// 
/// BUSINESS PURPOSE: Ensure CollectionEmptyStateView generates proper accessibility identifiers
/// TESTING SCOPE: CollectionEmptyStateView component from PlatformSemanticLayer1.swift
/// METHODOLOGY: Test component on both iOS and macOS platforms as required by mandatory testing guidelines
@MainActor
final class CollectionEmptyStateViewTests: XCTestCase {
    
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
    
    // MARK: - CollectionEmptyStateView Tests
    
    func testCollectionEmptyStateViewGeneratesAccessibilityIdentifiersOnIOS() async {
        let view = CollectionEmptyStateView(
            title: "No Items",
            message: "No items to display",
            actionTitle: "Add Item",
            action: {}
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*collectionemptystateview", 
            platform: .iOS,
            componentName: "CollectionEmptyStateView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "CollectionEmptyStateView should generate accessibility identifiers on iOS")
    }
    
    func testCollectionEmptyStateViewGeneratesAccessibilityIdentifiersOnMacOS() async {
        let view = CollectionEmptyStateView(
            title: "No Items",
            message: "No items to display",
            actionTitle: "Add Item",
            action: {}
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*collectionemptystateview", 
            platform: .macOS,
            componentName: "CollectionEmptyStateView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "CollectionEmptyStateView should generate accessibility identifiers on macOS")
    }
}
