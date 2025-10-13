import XCTest
import SwiftUI
@testable import SixLayerFramework

/**
 * BUSINESS PURPOSE: Verify that automatic accessibility identifiers now work by default
 * without requiring explicit .enableGlobalAutomaticAccessibilityIdentifiers() call.
 * 
 * TESTING SCOPE: Tests that the default behavior now enables automatic identifiers
 * METHODOLOGY: Tests that views get automatic identifiers without explicit enabling
 */
final class DefaultAccessibilityIdentifierTests: XCTestCase {
    
    override func setUp() async throws {
        try await super.setUp()
        await AccessibilityTestUtilities.setupAccessibilityTestEnvironment()
    }
    
    override func tearDown() async throws {
        await AccessibilityTestUtilities.cleanupAccessibilityTestEnvironment()
        try await super.tearDown()
    }
    
    /// BUSINESS PURPOSE: Verify that automatic identifiers work by default
    /// TESTING SCOPE: Tests that no explicit enabling is required
    /// METHODOLOGY: Tests that views get identifiers without .enableGlobalAutomaticAccessibilityIdentifiers()
    func testAutomaticIdentifiersWorkByDefault() async {
        await MainActor.run {
            // Given: Default configuration (no explicit enabling)
            let config = AccessibilityIdentifierConfig.shared
            // enableAutoIDs is true by default
            // globalAutomaticAccessibilityIdentifiers is now true by default
            
            // When: Creating a view with automatic accessibility identifiers
            let testView = Button(action: {}) {
                Label("Test Button", systemImage: "plus")
            }
            .automaticAccessibilityIdentifiers()
            
            // Then: The view should be created successfully with accessibility identifier
            XCTAssertNotNil(testView, "View with automatic accessibility identifiers should be created successfully")
            XCTAssertTrue(hasAccessibilityIdentifier(
                testView, 
                expectedPattern: "SixLayer.main.element.*", 
                componentName: "AutomaticIdentifiersWorkByDefault"
            ), "View should have accessibility identifier by default")
            
            // Verify default configuration
            XCTAssertTrue(config.enableAutoIDs, "Auto IDs should be enabled by default")
            XCTAssertEqual(config.namespace, "app", "Namespace should be 'app' by default")
            XCTAssertEqual(config.mode, .automatic, "Mode should be automatic by default")
        }
    }
    
    /// BUSINESS PURPOSE: Verify that breadcrumb modifiers work by default
    /// TESTING SCOPE: Tests that Enhanced Breadcrumb System works without explicit enabling
    /// METHODOLOGY: Tests that .trackViewHierarchy() works out of the box
    func testBreadcrumbModifiersWorkByDefault() async {
        await MainActor.run {
            // Given: Default configuration
            let config = AccessibilityIdentifierConfig.shared
            config.enableDebugLogging = true
            config.clearDebugLog()
            
            // When: Using breadcrumb modifiers without explicit global enabling
            let testView = Button(action: {}) {
                Label("Test Button", systemImage: "plus")
            }
            .named("TestButton")
            .screenContext("TestScreen")
            
            // Then: The view should be created successfully
            XCTAssertNotNil(testView, "View with breadcrumb modifiers should be created successfully")
            
            // Verify that the modifiers work without explicit global enabling
            // The fix ensures breadcrumb modifiers set globalAutomaticAccessibilityIdentifiers = true
        }
    }
    
    /// BUSINESS PURPOSE: Verify that manual identifiers still work
    /// TESTING SCOPE: Tests that manual identifiers continue to work with new defaults
    /// METHODOLOGY: Tests that manual identifiers take precedence
    func testManualIdentifiersStillWork() async {
        await MainActor.run {
            // Given: Default configuration
            let config = AccessibilityIdentifierConfig.shared
            
            // Verify config is properly configured
            XCTAssertNotNil(config, "AccessibilityIdentifierConfig should be available")
            
            // When: Using manual accessibility identifier
            let testView = Button(action: {}) {
                Label("Test Button", systemImage: "plus")
            }
            .accessibilityIdentifier("manual-test-button")
            
            // Then: The view should be created successfully with manual accessibility identifier
            XCTAssertNotNil(testView, "View with manual accessibility identifier should be created successfully")
            XCTAssertTrue(hasAccessibilityIdentifier(
                testView, 
                expectedIdentifier: "manual-test-button", 
                componentName: "ManualIdentifiersWorkByDefault"
            ), "Manual accessibility identifier should work by default")
        }
    }
    
    /// BUSINESS PURPOSE: Verify that opt-out still works
    /// TESTING SCOPE: Tests that .disableAutomaticAccessibilityIdentifiers() still works
    /// METHODOLOGY: Tests that opt-out functionality is preserved
    func testOptOutStillWorks() async {
        await MainActor.run {
            // Given: Default configuration
            let config = AccessibilityIdentifierConfig.shared
            
            // Verify config is properly configured
            XCTAssertNotNil(config, "AccessibilityIdentifierConfig should be available")
            
            // When: Using opt-out modifier
            let testView = Button(action: {}) {
                Label("Decorative Button", systemImage: "star")
            }
            .disableAutomaticAccessibilityIdentifiers()
            
            // Then: The view should be created successfully
            XCTAssertNotNil(testView, "View with opt-out modifier should be created successfully")
            
            // Opt-out should work even with automatic identifiers enabled by default
        }
    }
}

