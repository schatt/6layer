import XCTest
import SwiftUI
@testable import SixLayerFramework
import ViewInspector

/// Tests for ResponsiveContainer.swift
/// 
/// BUSINESS PURPOSE: Ensure ResponsiveContainer generates proper accessibility identifiers
/// TESTING SCOPE: All components in ResponsiveContainer.swift
/// METHODOLOGY: Test each component on both iOS and macOS platforms as required by mandatory testing guidelines
@MainActor
final class ResponsiveContainerTests: XCTestCase {
    
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
    
    // MARK: - ResponsiveContainer Tests
    
    func testResponsiveContainerGeneratesAccessibilityIdentifiersOnIOS() async {
        let view = ResponsiveContainer {
            Text("Test Content")
        }
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*responsivecontainer", 
            platform: .iOS,
            componentName: "ResponsiveContainer"
        )
        
        XCTAssertTrue(hasAccessibilityID, "ResponsiveContainer should generate accessibility identifiers on iOS")
    }
    
    func testResponsiveContainerGeneratesAccessibilityIdentifiersOnMacOS() async {
        let view = ResponsiveContainer {
            Text("Test Content")
        }
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*responsivecontainer", 
            platform: .macOS,
            componentName: "ResponsiveContainer"
        )
        
        XCTAssertTrue(hasAccessibilityID, "ResponsiveContainer should generate accessibility identifiers on macOS")
    }
}

