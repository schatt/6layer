import XCTest
import SwiftUI
@testable import SixLayerFramework
import ViewInspector

/// Tests for PlatformListsLayer4.swift
/// 
/// BUSINESS PURPOSE: Ensure all list Layer 4 components generate proper accessibility identifiers
/// TESTING SCOPE: All components in PlatformListsLayer4.swift
/// METHODOLOGY: Test each component on both iOS and macOS platforms as required by mandatory testing guidelines
@MainActor
final class PlatformListsLayer4Tests: XCTestCase {
    
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
    
    // MARK: - platformListContainer_L4 Tests
    
    func testPlatformListContainerL4GeneratesAccessibilityIdentifiersOnIOS() async {
        let testItems = [
            PlatformListsLayer4TestItem(id: "1", title: "Test Item 1"),
            PlatformListsLayer4TestItem(id: "2", title: "Test Item 2")
        ]
        
        let view = platformListContainer_L4(items: testItems) { item in
            Text(item.title)
        }
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*platformlistcontainer_l4", 
            platform: .iOS,
            componentName: "platformListContainer_L4"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformListContainer_L4 should generate accessibility identifiers on iOS")
    }
    
    func testPlatformListContainerL4GeneratesAccessibilityIdentifiersOnMacOS() async {
        let testItems = [
            PlatformListsLayer4TestItem(id: "1", title: "Test Item 1"),
            PlatformListsLayer4TestItem(id: "2", title: "Test Item 2")
        ]
        
        let view = platformListContainer_L4(items: testItems) { item in
            Text(item.title)
        }
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*platformlistcontainer_l4", 
            platform: .macOS,
            componentName: "platformListContainer_L4"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformListContainer_L4 should generate accessibility identifiers on macOS")
    }
}

// MARK: - Test Support Types

/// Test item for PlatformListsLayer4 testing
struct PlatformListsLayer4TestItem: Identifiable {
    let id: String
    let title: String
    
    init(id: String, title: String) {
        self.id = id
        self.title = title
    }
}

