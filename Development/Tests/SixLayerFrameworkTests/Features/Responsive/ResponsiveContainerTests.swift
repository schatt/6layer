import Testing


import SwiftUI
@testable import SixLayerFramework
import ViewInspector

/// Tests for ResponsiveContainer.swift
/// 
/// BUSINESS PURPOSE: Ensure ResponsiveContainer generates proper accessibility identifiers
/// TESTING SCOPE: All components in ResponsiveContainer.swift
/// METHODOLOGY: Test each component on both iOS and macOS platforms as required by mandatory testing guidelines
@MainActor
open class ResponsiveContainerTests {
    
    // MARK: - Test Setup
    
    init() async throws {
        await setupTestEnvironment()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
        config.enableAutoIDs = true
        config.namespace = "SixLayer"
        config.mode = .automatic
        config.enableDebugLogging = false
    }    // MARK: - ResponsiveContainer Tests
    
    
    private func setupTestEnvironment() async {
        await AccessibilityTestUtilities.setupAccessibilityTestEnvironment()
    }
    
    private func cleanupTestEnvironment() async {
        await AccessibilityTestUtilities.cleanupAccessibilityTestEnvironment()
    }
    
@Test func testResponsiveContainerGeneratesAccessibilityIdentifiersOnIOS() async {
        let view = ResponsiveContainer { isHorizontal, isVertical in
            Text("Test Content")
        }
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.main.element.*", 
            platform: .iOS,
            componentName: "ResponsiveContainer"
        )
        
        #expect(hasAccessibilityID, "ResponsiveContainer should generate accessibility identifiers on iOS")
    }
    
    @Test func testResponsiveContainerGeneratesAccessibilityIdentifiersOnMacOS() async {
        let view = ResponsiveContainer { isHorizontal, isVertical in
            Text("Test Content")
        }
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.main.element.*", 
            platform: .macOS,
            componentName: "ResponsiveContainer"
        )
        
        #expect(hasAccessibilityID, "ResponsiveContainer should generate accessibility identifiers on macOS")
    }
}

