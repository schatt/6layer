import XCTest
import SwiftUI
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif
@testable import SixLayerFramework

/**
 * BUSINESS PURPOSE: SixLayer framework should automatically generate accessibility identifiers
 * for views created by Layer 1 functions, ensuring consistent testability without requiring
 * developers to manually add identifiers to every interactive element.
 * 
 * TESTING SCOPE: Tests that automatic identifier generation works correctly with global config,
 * respects manual overrides, generates stable IDs based on object identity, and integrates
 * with existing HIG compliance modifiers.
 * 
 * METHODOLOGY: Uses TDD principles to test automatic identifier generation. Creates views using
 * Layer 1 functions and verifies they have proper accessibility identifiers generated automatically
 * based on configuration settings and object identity.
 */
final class AutomaticAccessibilityIdentifierTests: XCTestCase {
    
    // MARK: - Test Helpers
    
    /// Helper function to test that accessibility identifiers are properly configured
    @MainActor
    private func testAccessibilityIdentifierConfiguration() -> Bool {
            config.clearDebugLog()
            
            // Generate some IDs
            let _ = generator.generateID(for: "test1", role: "button", context: "ui")
            let _ = generator.generateID(for: "test2", role: "text", context: "form")
            
            // Check that IDs were not logged
            XCTAssertEqual(config.generatedIDsLog.count, 0)
        }
    }
    
    /// BUSINESS PURPOSE: Debug log should be formatted for readability
    /// TESTING SCOPE: Tests that debug log formatting works correctly
    /// METHODOLOGY: Unit tests for debug log formatting
    func testDebugLogFormatting() async {
        await MainActor.run {
