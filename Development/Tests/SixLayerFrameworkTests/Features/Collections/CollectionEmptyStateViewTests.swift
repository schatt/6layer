import Testing
import SwiftUI
@testable import SixLayerFramework
import ViewInspector

/// Tests for CollectionEmptyStateView component
/// 
/// BUSINESS PURPOSE: Ensure CollectionEmptyStateView generates proper accessibility identifiers
/// TESTING SCOPE: CollectionEmptyStateView component from PlatformSemanticLayer1.swift
/// METHODOLOGY: Test component on both iOS and macOS platforms as required by mandatory testing guidelines
@MainActor
final class CollectionEmptyStateViewTests {
    
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
    
    // MARK: - CollectionEmptyStateView Tests
    
    @Test func testCollectionEmptyStateViewGeneratesAccessibilityIdentifiersOnIOS() async {
        let view = CollectionEmptyStateView(
            hints: PresentationHints(
                dataType: .collection,
                presentationPreference: .automatic
            ),
            onCreateItem: {},
            customCreateView: nil
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.main.element.*", 
            platform: .iOS,
            componentName: "CollectionEmptyStateView"
        )
        
        #expect(hasAccessibilityID, "CollectionEmptyStateView should generate accessibility identifiers on iOS")
    }
    
    @Test func testCollectionEmptyStateViewGeneratesAccessibilityIdentifiersOnMacOS() async {
        let view = CollectionEmptyStateView(
            hints: PresentationHints(
                dataType: .collection,
                presentationPreference: .automatic
            ),
            onCreateItem: {},
            customCreateView: nil
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.main.element.*", 
            platform: .macOS,
            componentName: "CollectionEmptyStateView"
        )
        
        #expect(hasAccessibilityID, "CollectionEmptyStateView should generate accessibility identifiers on macOS")
    }
}
