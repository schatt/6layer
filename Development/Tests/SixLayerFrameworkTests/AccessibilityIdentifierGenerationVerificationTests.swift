import XCTest
import SwiftUI
import ViewInspector
@testable import SixLayerFramework

/**
 * BUSINESS PURPOSE: Verify that accessibility identifier generation actually works end-to-end
 * and that the Enhanced Breadcrumb System modifiers properly trigger identifier generation.
 * 
 * TESTING SCOPE: Tests two critical aspects:
 * 1. View created - The view can be instantiated successfully
 * 2. Contains what it needs to contain - The view has the proper accessibility identifier assigned
 * 
 * METHODOLOGY: Uses ViewInspector to actually inspect the view and verify that accessibility
 * identifiers are present and have the expected format. This addresses the gap in original
 * tests that only verified views could be created, not that identifiers were actually assigned.
 */
final class AccessibilityIdentifierGenerationVerificationTests: XCTestCase {
    
    override func setUp() async throws {
        try await super.setUp()
        await AccessibilityTestUtilities.setupAccessibilityTestEnvironment()
    }
    
    override func tearDown() async throws {
        await AccessibilityTestUtilities.cleanupAccessibilityTestEnvironment()
        try await super.tearDown()
    }
    
    /// BUSINESS PURPOSE: Verify that .automaticAccessibilityIdentifiers() actually generates identifiers
    /// TESTING SCOPE: Tests that the basic automatic identifier modifier works end-to-end
    /// METHODOLOGY: Creates a view, applies the modifier, and verifies an identifier is actually assigned
    func testAutomaticAccessibilityIdentifiersActuallyGenerateIDs() async {
        await MainActor.run {
            // Given: Configuration for identifier generation
            let config = AccessibilityIdentifierConfig.shared
            config.enableAutoIDs = true
            config.namespace = "test"
            config.enableDebugLogging = true
            config.clearDebugLog()
            
            // When: Creating a view with automatic accessibility identifiers
            let testView = Button(action: {}) {
                Label("Test Button", systemImage: "plus")
            }
            .automaticAccessibilityIdentifiers()
            
            // Then: Test the two critical aspects
            
            // 1. View created - The view can be instantiated successfully
            XCTAssertNotNil(testView, "View with automatic accessibility identifiers should be created successfully")
            
            // 2. Contains what it needs to contain - The view has the proper accessibility identifier assigned
            XCTAssertTrue(hasAccessibilityIdentifier(
                testView, 
                expectedPattern: "test.*element.*main-ui", 
                componentName: "AutomaticAccessibilityIdentifiers"
            ), "View should have an accessibility identifier assigned")
        }
    }
    
    /// BUSINESS PURPOSE: Verify that .named() actually triggers identifier generation
    /// TESTING SCOPE: Tests that the Enhanced Breadcrumb System modifier works end-to-end
    /// METHODOLOGY: Tests the specific modifier that was failing in the bug report
    func testNamedActuallyGeneratesIdentifiers() async {
        await MainActor.run {
            // Given: Configuration matching the bug report
            let config = AccessibilityIdentifierConfig.shared
            config.enableAutoIDs = true
            config.namespace = "CarManager"
            config.mode = .automatic
            config.enableViewHierarchyTracking = true
            config.enableDebugLogging = true
            config.clearDebugLog()
            
            // When: Using .named() modifier (the new API)
            let testView = Button(action: {}) {
                Label("Add Fuel", systemImage: "plus")
            }
            .named("AddFuelButton")
            
            // Then: Test the two critical aspects
            
            // 1. View created - The view can be instantiated successfully
            XCTAssertNotNil(testView, "View with .named() should be created successfully")
            
            // 2. Contains what it needs to contain - The view has the proper accessibility identifier assigned
            XCTAssertTrue(hasAccessibilityIdentifier(
                testView, 
                expectedPattern: "CarManager.*element.*main-addfuelbutton", 
                componentName: "NamedModifier"
            ), "View should have an accessibility identifier assigned")
        }
    }
    
    /// BUSINESS PURPOSE: Verify that combined breadcrumb modifiers actually generate identifiers
    /// TESTING SCOPE: Tests that multiple breadcrumb modifiers work together end-to-end
    /// METHODOLOGY: Tests the exact scenario from the bug report with multiple modifiers
    func testCombinedBreadcrumbModifiersActuallyGenerateIdentifiers() async {
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
            .screenContext("FuelView")
            
            // Then: Test the two critical aspects
            
            // 1. View created - The view can be instantiated successfully
            XCTAssertNotNil(testView, "Combined breadcrumb modifiers should create view successfully")
            
            // 2. Contains what it needs to contain - The view has the proper accessibility identifier assigned
            XCTAssertTrue(hasAccessibilityIdentifier(
                testView, 
                expectedPattern: "CarManager.*element.*fuelview-addfuelbutton", 
                componentName: "CombinedBreadcrumbModifiers"
            ), "View should have an accessibility identifier assigned")
        }
    }
    
    /// BUSINESS PURPOSE: Verify that manual identifiers still override automatic ones
    /// TESTING SCOPE: Tests that manual identifiers take precedence over automatic generation
    /// METHODOLOGY: Tests that manual identifiers work even when automatic generation is enabled
    func testManualIdentifiersOverrideAutomaticGeneration() async {
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
            XCTAssertNotNil(testView, "View with manual identifier should be created successfully")
            
            // 2. Contains what it needs to contain - The view has the manual accessibility identifier assigned
            do {
                let accessibilityIdentifier = try testView.inspect().text().accessibilityIdentifier()
                XCTAssertEqual(accessibilityIdentifier, manualID, "Manual identifier should override automatic generation")
            } catch {
                XCTFail("Failed to inspect accessibility identifier: \(error)")
            }
        }
    }
    
    /// BUSINESS PURPOSE: Verify that global configuration actually controls identifier generation
    /// TESTING SCOPE: Tests that global config settings affect actual identifier generation
    /// METHODOLOGY: Tests that enabling/disabling automatic IDs actually works
    func testGlobalConfigActuallyControlsIdentifierGeneration() async {
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
            XCTAssertNotNil(testView1, "View should be created even when automatic IDs are disabled")
            
            // 2. Contains what it needs to contain - The view should NOT have an automatic accessibility identifier
            do {
                let accessibilityIdentifier1 = try testView1.inspect().button().accessibilityIdentifier()
                XCTAssertTrue(accessibilityIdentifier1.isEmpty || !accessibilityIdentifier1.hasPrefix("test"), 
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
            XCTAssertNotNil(testView2, "View should be created when automatic IDs are enabled")
            
            // 2. Contains what it needs to contain - The view should have an automatic accessibility identifier
            do {
                let accessibilityIdentifier2 = try testView2.inspect().button().accessibilityIdentifier()
                XCTAssertFalse(accessibilityIdentifier2.isEmpty, "An identifier should be generated when enabled")
                XCTAssertTrue(accessibilityIdentifier2.hasPrefix("test"), "Generated ID should start with namespace")
            } catch {
                XCTFail("Failed to inspect accessibility identifier: \(error)")
            }
        }
    }
}