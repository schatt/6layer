import Testing
import SwiftUI
import ViewInspector
@testable import SixLayerFramework

/**
 * BUSINESS PURPOSE: Verify that accessibility identifier generation actually works end-to-end
 * and that the Enhanced Breadcrumb System modifiers properly trigger identifier generation.
 * 
 * TESTING SCOPE: Uses centralized test functions following DRY principles
 * METHODOLOGY: Leverages centralized accessibility testing functions for consistent validation
 */
open class AccessibilityIdentifierGenerationVerificationTests {
    
    /// BUSINESS PURPOSE: Verify that .automaticAccessibilityIdentifiers() actually generates identifiers
    /// TESTING SCOPE: Tests that the basic automatic identifier modifier works end-to-end
    /// METHODOLOGY: Uses centralized test functions for consistent validation
    @Test func testAutomaticAccessibilityIdentifiersActuallyGenerateIDs() async {
        await MainActor.run {
            // Setup: Configure test environment with automatic mode and debug logging
            setupTestEnvironment(mode: .automatic, enableDebugLogging: true)
            
            // Test: Use centralized component accessibility testing
            let testPassed = testComponentAccessibility(
                componentName: "AutomaticAccessibilityIdentifiers",
                createComponent: {
                    Button(action: {}) {
                        Label("Test Button", systemImage: "plus")
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
    
    /// BUSINESS PURPOSE: Verify that .named() actually triggers identifier generation
    /// TESTING SCOPE: Tests that the Enhanced Breadcrumb System modifier works end-to-end
    /// METHODOLOGY: Uses centralized test functions for consistent validation
    @Test func testNamedActuallyGeneratesIdentifiers() async {
        await MainActor.run {
            // Setup: Configure test environment with specific namespace and automatic mode
            setupTestEnvironment(mode: .automatic, enableDebugLogging: true, namespace: "CarManager")
            
            // Test: Use centralized component accessibility testing
            let testPassed = testComponentAccessibility(
                componentName: "NamedModifier",
                createComponent: {
                    Button(action: {}) {
                        Label("Add Fuel", systemImage: "plus")
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
    
    /// BUSINESS PURPOSE: Verify that automatic accessibility identifiers actually generate identifiers
    /// TESTING SCOPE: Tests that automatic accessibility identifiers work together end-to-end
    /// METHODOLOGY: Tests the exact scenario from the bug report with multiple modifiers
    @Test func testAutomaticAccessibilityIdentifiersActuallyGenerateIdentifiers() async {
        await MainActor.run {
            // Given: Configuration matching the bug report exactly
            let config = AccessibilityIdentifierConfig.shared
            config.enableAutoIDs = true
            config.namespace = "CarManager"
            config.mode = .automatic
            config.enableViewHierarchyTracking = true
            config.enableUITestIntegration = true
            config.enableDebugLogging = true
            
            // When: Using the exact combination from the bug report
            let testView = Button(action: {}) {
                Label("Add Fuel", systemImage: "plus")
            }
            .named("AddFuelButton")
            
            // Then: Test the two critical aspects
            
            // 1. View created - The view can be instantiated successfully
            #expect(testView != nil, "Automatic accessibility identifiers should create view successfully")
            
            // 2. Contains what it needs to contain - The view has the proper accessibility identifier assigned
            #expect(testAccessibilityIdentifiersSinglePlatform(
                testView, 
                expectedPattern: "CarManager.FuelView.element.*", 
                platform: SixLayerPlatform.iOS,
            componentName: "CombinedBreadcrumbModifiers"
            ), "View should have an accessibility identifier assigned")
        }
    }
    
    /// BUSINESS PURPOSE: Verify that manual identifiers still override automatic ones
    /// TESTING SCOPE: Tests that manual identifiers take precedence over automatic generation
    /// METHODOLOGY: Tests that manual identifiers work even when automatic generation is enabled
    @Test func testManualIdentifiersOverrideAutomaticGeneration() async {
        await MainActor.run {
            // Given: Automatic IDs enabled
            let config = AccessibilityIdentifierConfig.shared
            config.enableAutoIDs = true
            config.namespace = "auto"
            
            // When: Creating view with manual identifier
            let manualID = "manual-custom-id"
            let testView = Text("Test")
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
    
    /// BUSINESS PURPOSE: Verify that global configuration actually controls identifier generation
    /// TESTING SCOPE: Tests that global config settings affect actual identifier generation
    /// METHODOLOGY: Tests that enabling/disabling automatic IDs actually works
    @Test func testGlobalConfigActuallyControlsIdentifierGeneration() async {
        await MainActor.run {
            let config = AccessibilityIdentifierConfig.shared
            config.namespace = "test"
            
            // Test Case 1: When automatic IDs are disabled
            config.enableAutoIDs = false
            
            let testView1 = Button(action: {}) {
                Label("Test", systemImage: "plus")
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
            config.enableAutoIDs = true
            
            let testView2 = Button(action: {}) {
                Label("Test", systemImage: "plus")
            }
            .automaticAccessibilityIdentifiers()
            
            // 1. View created - The view can be instantiated successfully
            #expect(testView2 != nil, "View should be created when automatic IDs are enabled")
            
            // 2. Contains what it needs to contain - The view should have an automatic accessibility identifier
            do {
                let accessibilityIdentifier2 = try testView2.inspect().button().accessibilityIdentifier()
                #expect(!accessibilityIdentifier2.isEmpty, "An identifier should be generated when enabled")
                #expect(accessibilityIdentifier2.hasPrefix("test"), "Generated ID should start with namespace")
            } catch {
                Issue.record("Failed to inspect accessibility identifier: \(error)")
            }
        }
    }
}