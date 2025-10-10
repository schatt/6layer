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
    
    /// BUSINESS PURPOSE: Verify that .automaticAccessibilityIdentifiers() actually generates identifiers
    /// TESTING SCOPE: Tests that the basic automatic identifier modifier works end-to-end
    /// METHODOLOGY: Creates a view, applies the modifier, and verifies an identifier is actually assigned
    func testAutomaticAccessibilityIdentifiersActuallyGenerateIDs() async {
        await MainActor.run {
            // Given: Configuration for identifier generation
