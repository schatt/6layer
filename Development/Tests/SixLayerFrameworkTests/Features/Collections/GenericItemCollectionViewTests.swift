import Testing


import SwiftUI
@testable import SixLayerFramework
import ViewInspector

/// Tests for GenericItemCollectionView component
/// 
/// BUSINESS PURPOSE: Ensure GenericItemCollectionView generates proper accessibility identifiers
/// TESTING SCOPE: GenericItemCollectionView component from PlatformSemanticLayer1.swift
/// METHODOLOGY: Test component on both iOS and macOS platforms as required by mandatory testing guidelines
@MainActor
final class GenericItemCollectionViewTests {
    
    // MARK: - Test Setup
    
    init() {
        setupTestEnvironment()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
        config.enableAutoIDs = true
        config.namespace = "SixLayer"
        config.mode = .automatic
        config.enableDebugLogging = false
    }
    
    deinit {
        cleanupTestEnvironment()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
    }
    
    // MARK: - GenericItemCollectionView Tests
    
    @Test func testGenericItemCollectionViewGeneratesAccessibilityIdentifiersOnIOS() async {
        let testItems = [
            GenericItemCollectionViewTestItem(id: "item1", title: "Test Item 1"),
            GenericItemCollectionViewTestItem(id: "item2", title: "Test Item 2")
        ]
        
        let view = GenericItemCollectionView(
            items: testItems,
            hints: PresentationHints()
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.main.element.*", 
            platform: .iOS,
            componentName: "GenericItemCollectionView"
        )
        
        #expect(hasAccessibilityID, "GenericItemCollectionView should generate accessibility identifiers on iOS")
    }
    
    @Test func testGenericItemCollectionViewGeneratesAccessibilityIdentifiersOnMacOS() async {
        let testItems = [
            GenericItemCollectionViewTestItem(id: "item1", title: "Test Item 1"),
            GenericItemCollectionViewTestItem(id: "item2", title: "Test Item 2")
        ]
        
        let view = GenericItemCollectionView(
            items: testItems,
            hints: PresentationHints()
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.main.element.*", 
            platform: .macOS,
            componentName: "GenericItemCollectionView"
        )
        
        #expect(hasAccessibilityID, "GenericItemCollectionView should generate accessibility identifiers on macOS")
    }
}

// MARK: - Test Support Types

/// Test item for GenericItemCollectionView testing
struct GenericItemCollectionViewTestItem: Identifiable {
    let id: String
    let title: String
    
    init(id: String, title: String) {
        self.id = id
        self.title = title
    }
}
