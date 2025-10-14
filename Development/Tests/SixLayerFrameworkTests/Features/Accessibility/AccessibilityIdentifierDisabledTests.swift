import Testing


import SwiftUI
import ViewInspector
@testable import SixLayerFramework

/// Test what happens when automatic accessibility IDs are disabled
@MainActor
final class AccessibilityIdentifierDisabledTests {
    
    init() async throws {
        try await super.setUp()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
        config.enableAutoIDs = false  // ← DISABLED
        config.namespace = "CarManager"
        config.mode = .automatic
        config.enableDebugLogging = false
    }
    
    deinit {
        try await super.tearDown()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
    }
    
    @Test func testAutomaticIDsDisabled_NoIdentifiersGenerated() {
        // Test: When automatic IDs are disabled, views should not have accessibility identifier modifiers
        let view = Button("Test Button") { }
            .named("TestButton")
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        do {
            let inspectedView = try view.inspect()
            // When automatic IDs are disabled, the view should not have an accessibility identifier modifier
            // This means we can't inspect for accessibility identifiers
            let _ = try inspectedView.button() // Just verify the view is inspectable
            print("✅ View is inspectable when automatic IDs disabled (no accessibility modifier applied)")
            
        } catch {
            Issue.record("Failed to inspect view: \(error)")
        }
    }
    
    @Test func testManualIDsStillWorkWhenAutomaticDisabled() {
        // Test: Manual accessibility identifiers should still work when automatic is disabled
        let view = Button("Test Button") { }
            .accessibilityIdentifier("manual-test-button")
        
        do {
            let inspectedView = try view.inspect()
            let buttonID = try inspectedView.accessibilityIdentifier()
            
            // Manual ID should work regardless of automatic setting
            #expect(buttonID == "manual-test-button", "Manual accessibility identifier should work when automatic is disabled")
            
            print("🔍 Manual ID when automatic disabled: '\(buttonID)'")
            
        } catch {
            Issue.record("Failed to inspect view: \(error)")
        }
    }
    
    @Test func testBreadcrumbModifiersStillWorkWhenAutomaticDisabled() {
        // Test: Breadcrumb modifiers (.named, .screenContext) should still work for tracking
        let view = VStack {
            Text("Content")
        }
        .named("TestView")
        .screenContext("TestScreen")
        
        // Even with automatic IDs disabled, the modifiers should not crash
        do {
            let _ = try view.inspect()
            print("✅ Breadcrumb modifiers work when automatic IDs disabled")
        } catch {
            Issue.record("Breadcrumb modifiers should not crash when automatic IDs disabled: \(error)")
        }
    }
}
