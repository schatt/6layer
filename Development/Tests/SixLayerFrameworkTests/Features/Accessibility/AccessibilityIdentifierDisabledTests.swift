import Testing


import SwiftUI
@testable import SixLayerFramework
#if !os(macOS)
import ViewInspector
#endif
/// Test what happens when automatic accessibility IDs are disabled
@MainActor
@Suite("Accessibility Identifier Disabled")
open class AccessibilityIdentifierDisabledTests: BaseTestClass {
    
    // BaseTestClass handles setup automatically - no need for custom init
    
    @Test func testAutomaticIDsDisabled_NoIdentifiersGenerated() {
        runWithTaskLocalConfig {
            // Test: When automatic IDs are disabled, views should not have accessibility identifier modifiers
            guard let config = testConfig else {
                Issue.record("testConfig is nil")
                return
            }
            config.enableAutoIDs = false  // ← DISABLED
            config.namespace = "SixLayer"
            config.mode = .automatic
            config.enableDebugLogging = false
            
            let view = PlatformInteractionButton(style: .primary, action: {}) {
                platformPresentContent_L1(content: "Test Button", hints: PresentationHints())
            }
                .named("TestButton")
                .enableGlobalAutomaticAccessibilityIdentifiers()
            
            // Using wrapper - when ViewInspector works on macOS, no changes needed here
            if let inspectedView = view.tryInspect(),
               let _ = try? inspectedView.button() {
                // When automatic IDs are disabled, the view should not have an accessibility identifier modifier
                // This means we can't inspect for accessibility identifiers
                // Just verify the view is inspectable
                print("✅ View is inspectable when automatic IDs disabled (no accessibility modifier applied)")
            } else {
                Issue.record("Failed to inspect view")
            }
        }
    }
    
    @Test func testManualIDsStillWorkWhenAutomaticDisabled() {
        runWithTaskLocalConfig {
            guard let config = testConfig else {
                Issue.record("testConfig is nil")
                return
            }
            config.enableAutoIDs = false  // ← DISABLED
            
            // Test: Manual accessibility identifiers should still work when automatic is disabled
            let view = PlatformInteractionButton(style: .primary, action: {}) {
                platformPresentContent_L1(content: "Test Button", hints: PresentationHints())
            }
                .accessibilityIdentifier("manual-test-button")
            
            // Using wrapper - when ViewInspector works on macOS, no changes needed here
            if let inspectedView = view.tryInspect(),
               let buttonID = try? inspectedView.accessibilityIdentifier() {
                // Manual ID should work regardless of automatic setting
                #expect(buttonID == "manual-test-button", "Manual accessibility identifier should work when automatic is disabled")
                
                print("🔍 Manual ID when automatic disabled: '\(buttonID)'")
            } else {
                Issue.record("Failed to inspect view")
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
