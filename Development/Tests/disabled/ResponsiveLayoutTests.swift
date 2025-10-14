import XCTest
import SwiftUI
@testable import SixLayerFramework
import ViewInspector

/// Tests for ResponsiveLayout.swift
/// 
/// BUSINESS PURPOSE: Ensure ResponsiveLayout generates proper accessibility identifiers
/// TESTING SCOPE: All components in ResponsiveLayout.swift
/// METHODOLOGY: Test each component on both iOS and macOS platforms as required by mandatory testing guidelines
@MainActor
final class ResponsiveLayoutTests: XCTestCase {
    
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
    
    // MARK: - ResponsiveLayout Tests
    
    func testResponsiveLayoutGeneratesAccessibilityIdentifiersOnIOS() async {
        let view = ResponsiveLayout.adaptiveGrid {
            Text("Test Content")
        }
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.main.element.*", 
            platform: .iOS,
            componentName: "ResponsiveLayout"
        )
        
        XCTAssertTrue(hasAccessibilityID, "ResponsiveLayout should generate accessibility identifiers on iOS")
    }
    
    func testResponsiveLayoutGeneratesAccessibilityIdentifiersOnMacOS() async {
        let view = ResponsiveLayout.adaptiveGrid {
            Text("Test Content")
        }
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.main.element.*", 
            platform: .macOS,
            componentName: "ResponsiveLayout"
        )
        
        XCTAssertTrue(hasAccessibilityID, "ResponsiveLayout should generate accessibility identifiers on macOS")
    }
}

