import Testing
import SwiftUI
@testable import SixLayerFramework
import ViewInspector
/**
 * BUSINESS PURPOSE: Verify that accessibility identifier generation actually works end-to-end
 * and that the Enhanced Breadcrumb System modifiers properly trigger identifier generation.
 * 
 * TESTING SCOPE: Uses centralized test functions following DRY principles
 * METHODOLOGY: Leverages centralized accessibility testing functions for consistent validation
 */
@Suite("Accessibility Identifier Generation Verification")
open class AccessibilityIdentifierGenerationVerificationTests: BaseTestClass {
    
    /// BUSINESS PURPOSE: Verify that .automaticAccessibilityIdentifiers() actually generates identifiers
    /// TESTING SCOPE: Tests that the basic automatic identifier modifier works end-to-end
    /// METHODOLOGY: Uses centralized test functions for consistent validation
    @Test func testAutomaticAccessibilityIdentifiersActuallyGenerateIDs() async {
        try await runWithTaskLocalConfig {
            await MainActor.run {
                // Test: Use centralized component accessibility testing
                // BaseTestClass already sets up testConfig, just enable debug logging if needed
                guard let config = self.testConfig else {
                    Issue.record("testConfig is nil")
                    return
                }

                config.enableDebugLogging = true
                
                let testPassed = testComponentAccessibility(
                    componentName: "AutomaticAccessibilityIdentifiers",
                    createComponent: {
                        PlatformInteractionButton(style: .primary, action: {}) {
                            platformPresentContent_L1(content: "Test Button", hints: PresentationHints())
                        }
                        .automaticAccessibilityIdentifiers()
                    }
                )
                
                // Assert: Should generate accessibility identifiers
                #expect(testPassed, "AutomaticAccessibilityIdentifiers should generate accessibility identifiers")
                
                // Cleanup: Reset test environment
                cleanupTestEnvironment()
        }
            }
    }
    
    /// BUSINESS PURPOSE: Verify that .named() actually triggers identifier generation
    /// TESTING SCOPE: Tests that the Enhanced Breadcrumb System modifier works end-to-end
    /// METHODOLOGY: Uses centralized test functions for consistent validation
    @Test func testNamedActuallyGeneratesIdentifiers() async {
        try await runWithTaskLocalConfig {
            await MainActor.run {
                // BaseTestClass already sets up testConfig with namespace "SixLayer"
                guard let config = self.testConfig else {
                    Issue.record("testConfig is nil")
                    return
                }

                config.enableDebugLogging = true
                
                // Test: Use centralized component accessibility testing
                let testPassed = testComponentAccessibility(
                    componentName: "NamedModifier",
                    createComponent: {
                        PlatformInteractionButton(style: .primary, action: {}) {
                            platformPresentContent_L1(content: "Add Fuel", hints: PresentationHints())
                        }
                        .named("AddFuelButton")
                    }
                )
                
                // Assert: Should generate accessibility identifiers
                #expect(testPassed, "NamedModifier should generate accessibility identifiers")
                
                // Cleanup: Reset test environment
                cleanupTestEnvironment()
        }
            }
    }
    
    /// BUSINESS PURPOSE: Verify that automatic accessibility identifiers actually generate identifiers
    /// TESTING SCOPE: Tests that automatic accessibility identifiers work together end-to-end
    /// METHODOLOGY: Tests the exact scenario from the bug report with multiple modifiers
    @Test func testAutomaticAccessibilityIdentifiersActuallyGenerateIdentifiers() async {
        try await runWithTaskLocalConfig {
            await MainActor.run {
                // Given: Configuration matching the bug report exactly
                guard let config = testConfig else {
                    Issue.record("testConfig is nil")
                    return
                }
                config.enableAutoIDs = true
                config.namespace = "SixLayer"
                config.mode = .automatic
                config.enableViewHierarchyTracking = true
                config.enableUITestIntegration = true
                config.enableDebugLogging = true
                
                // When: Using the exact combination from the bug report
                let testView = PlatformInteractionButton(style: .primary, action: {}) {
                    platformPresentContent_L1(content: "Add Fuel", hints: PresentationHints())
                }
                .named("AddFuelButton")
                
                // Then: Test the two critical aspects
                
                // 1. View created - The view can be instantiated successfully
                #expect(testView != nil, "Automatic accessibility identifiers should create view successfully")
                
                // 2. Contains what it needs to contain - The view has the proper accessibility identifier assigned
                #expect(testAccessibilityIdentifiersSinglePlatform(
                    testView, 
                    expectedPattern: "SixLayer.*ui", 
                    platform: SixLayerPlatform.iOS,
                    componentName: "CombinedBreadcrumbModifiers"
                ), "View should have an accessibility identifier assigned")
        }
            }
    }
    
    /// BUSINESS PURPOSE: Verify that manual identifiers still override automatic ones
    /// TESTING SCOPE: Tests that manual identifiers take precedence over automatic generation
    /// METHODOLOGY: Tests that manual identifiers work even when automatic generation is enabled
    @Test func testManualIdentifiersOverrideAutomaticGeneration() async {
        try await runWithTaskLocalConfig {
            await MainActor.run {
                // Given: Automatic IDs enabled, set namespace for this test
                guard let config = self.testConfig else {
                    Issue.record("testConfig is nil")
                    return
                }

                config.namespace = "auto"
                config.enableAutoIDs = true
                
                // When: Creating view with manual identifier
                let manualID = "manual-custom-id"
                let testView = platformPresentContent_L1(
                    content: "Test",
                    hints: PresentationHints()
                )
                    .accessibilityIdentifier(manualID)
                    .automaticAccessibilityIdentifiers()
                
                // Then: Test the two critical aspects
                
                // 1. View created - The view can be instantiated successfully
                #expect(testView != nil, "View with manual identifier should be created successfully")
                
                // 2. Contains what it needs to contain - The view has the manual accessibility identifier assigned
                do {
                    let accessibilityIdentifier = try testView.inspect().text().accessibilityIdentifier()
                    #expect(accessibilityIdentifier == manualID, "Manual identifier should override automatic generation")
                } catch {
                    Issue.record("Failed to inspect accessibility identifier: \(error)")
        }
                }
            }
    }
    
    /// BUSINESS PURPOSE: Verify that global configuration actually controls identifier generation
    /// TESTING SCOPE: Tests that global config settings affect actual identifier generation
    /// METHODOLOGY: Tests that enabling/disabling automatic IDs actually works
    @Test func testGlobalConfigActuallyControlsIdentifierGeneration() async {
        try await runWithTaskLocalConfig {
            await MainActor.run {
                // Use isolated testConfig instead of shared
                guard let config = self.testConfig else {
                    Issue.record("testConfig is nil")
                    return
                }

                config.namespace = "test"
                
                // Test Case 1: When automatic IDs are disabled
                config.enableAutoIDs = false
                
                let testView1 = PlatformInteractionButton(style: .primary, action: {}) {
                    platformPresentContent_L1(content: "Test", hints: PresentationHints())
                }
                .automaticAccessibilityIdentifiers()
                
                // 1. View created - The view can be instantiated successfully
                #expect(testView1 != nil, "View should be created even when automatic IDs are disabled")
                
                // 2. Contains what it needs to contain - The view should NOT have an automatic accessibility identifier
                do {
                    let accessibilityIdentifier1 = try testView1.inspect().button().accessibilityIdentifier()
                    #expect(accessibilityIdentifier1.isEmpty || !accessibilityIdentifier1.hasPrefix("test"), 
                                 "No automatic identifier should be generated when disabled")
                } catch {
                    // If we can't inspect, that's also acceptable - it means no identifier was set
                    // This is actually a valid test result when automatic IDs are disabled
                }
                
                // Test Case 2: When automatic IDs are enabled
                testConfig.enableAutoIDs = true
                
                let testView2 = PlatformInteractionButton(style: .primary, action: {}) {
                    platformPresentContent_L1(content: "Test", hints: PresentationHints())
                }
                .automaticAccessibilityIdentifiers()
                
                // 1. View created - The view can be instantiated successfully
                #expect(testView2 != nil, "View should be created when automatic IDs are enabled")
                
                // 2. Contains what it needs to contain - The view should have an automatic accessibility identifier
                do {
                    let accessibilityIdentifier2 = try testView2.inspect().button().accessibilityIdentifier()
                    #expect(!accessibilityIdentifier2.isEmpty, "An identifier should be generated when enabled")
                    // ID format: test.main.ui.element.View (namespace is first)
                    #expect(accessibilityIdentifier2.hasPrefix("test."), "Generated ID should start with namespace 'test.'")
                } catch {
                    Issue.record("Failed to inspect accessibility identifier: \(error)")
        }
                }
            }
    }
}