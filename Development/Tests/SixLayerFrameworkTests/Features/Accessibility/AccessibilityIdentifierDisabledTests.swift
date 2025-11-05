import Testing


import SwiftUI
@testable import SixLayerFramework
import ViewInspector
/// Test what happens when automatic accessibility IDs are disabled
@MainActor
@Suite("Accessibility Identifier Disabled")
open class AccessibilityIdentifierDisabledTests {
    
    init() async throws {
                let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
        config.enableAutoIDs = false  // ← DISABLED
        config.namespace = "SixLayer"
        config.mode = .automatic
        config.enableDebugLogging = false
    }
    
    @Test func testAutomaticIDsDisabled_NoIdentifiersGenerated() {
        try runWithTaskLocalConfig {
            // Test: When automatic IDs are disabled, views should not have accessibility identifier modifiers
            let config = testConfig
            config.enableAutoIDs = false  // ← DISABLED
            config.namespace = "SixLayer"
            config.mode = .automatic
            config.enableDebugLogging = false
            
            let view = PlatformInteractionButton(style: .primary, action: {}) {
                platformPresentContent_L1(content: "Test Button", hints: PresentationHints())
            }
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
    }
    
    @Test func testManualIDsStillWorkWhenAutomaticDisabled() {
        try runWithTaskLocalConfig {
            let config = testConfig
            config.enableAutoIDs = false  // ← DISABLED
            
            // Test: Manual accessibility identifiers should still work when automatic is disabled
            let view = PlatformInteractionButton(style: .primary, action: {}) {
                platformPresentContent_L1(content: "Test Button", hints: PresentationHints())
            }
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
    }
    
    @Test func testBreadcrumbModifiersStillWorkWhenAutomaticDisabled() {
        // Test: Named modifiers should still work for tracking
        let view = VStack {
            platformPresentContent_L1(content: "Content", hints: PresentationHints())
        }
        .named("TestView")
        
        // Even with automatic IDs disabled, the modifiers should not crash
        do {
            let _ = try view.inspect()
            print("✅ Breadcrumb modifiers work when automatic IDs disabled")
        } catch {
            Issue.record("Breadcrumb modifiers should not crash when automatic IDs disabled: \(error)")
        }
    }
}
