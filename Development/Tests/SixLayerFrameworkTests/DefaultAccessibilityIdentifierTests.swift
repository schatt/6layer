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
        // Reset global config to default state
        Task { @MainActor in
            AccessibilityIdentifierConfig.shared.resetToDefaults()
        }
    }
    
    override func tearDown() async throws {
        Task { @MainActor in
            AccessibilityIdentifierConfig.shared.resetToDefaults()
        }
        try await super.tearDown()
    }
    
    /// BUSINESS PURPOSE: Verify that automatic identifiers work by default
    /// TESTING SCOPE: Tests that no explicit enabling is required
    /// METHODOLOGY: Tests that views get identifiers without .enableGlobalAutomaticAccessibilityIdentifiers()
    func testAutomaticIdentifiersWorkByDefault() async {
        await MainActor.run {
            // Given: Default configuration (no explicit enabling)
