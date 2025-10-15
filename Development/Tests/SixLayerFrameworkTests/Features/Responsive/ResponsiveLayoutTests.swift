import Testing


import SwiftUI
@testable import SixLayerFramework
import ViewInspector

/// Tests for ResponsiveLayout.swift
/// 
/// BUSINESS PURPOSE: Ensure ResponsiveLayout generates proper accessibility identifiers
/// TESTING SCOPE: All components in ResponsiveLayout.swift
/// METHODOLOGY: Test each component on both iOS and macOS platforms as required by mandatory testing guidelines
@MainActor
final class ResponsiveLayoutTests {
    
    // MARK: - Test Setup
    
    init() async throws {
        await setupTestEnvironment()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
        config.enableAutoIDs = true
        config.namespace = "SixLayer"
        config.mode = .automatic
        config.enableDebugLogging = false
    }
    
    deinit {
        Task { [weak self] in
            await self?.cleanupTestEnvironment()
        }
    }
    
    // MARK: - ResponsiveLayout Tests
    
    
    private func setupTestEnvironment() async {
        await AccessibilityTestUtilities.setupAccessibilityTestEnvironment()
    }
    
    private func cleanupTestEnvironment() async {
        await AccessibilityTestUtilities.cleanupAccessibilityTestEnvironment()
    }
    
@Test func testResponsiveLayoutGeneratesAccessibilityIdentifiersOnIOS() async {
        let view = ResponsiveLayout.adaptiveGrid {
            Text("Test Content")
        }
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.main.element.*", 
            platform: .iOS,
            componentName: "ResponsiveLayout"
        )
        
        #expect(hasAccessibilityID, "ResponsiveLayout should generate accessibility identifiers on iOS")
    }
    
    @Test func testResponsiveLayoutGeneratesAccessibilityIdentifiersOnMacOS() async {
        let view = ResponsiveLayout.adaptiveGrid {
            Text("Test Content")
        }
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.main.element.*", 
            platform: .macOS,
            componentName: "ResponsiveLayout"
        )
        
        #expect(hasAccessibilityID, "ResponsiveLayout should generate accessibility identifiers on macOS")
    }
}

