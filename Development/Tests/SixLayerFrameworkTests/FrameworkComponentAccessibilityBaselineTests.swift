import XCTest
import SwiftUI
import ViewInspector
@testable import SixLayerFramework

/// TDD Tests for Framework Component Accessibility - Baseline Test
/// First prove the components we KNOW work, then systematically fix the rest
@MainActor
final class FrameworkComponentAccessibilityBaselineTests: XCTestCase {
    
    override func setUp() async throws {
        try await super.setUp()
        config.enableAutoIDs = true
    }
    
    override func tearDown() async throws {
        try await super.tearDown()
