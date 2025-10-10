import XCTest
import SwiftUI
import ViewInspector
@testable import SixLayerFramework

/// BUSINESS PURPOSE: Accessibility tests for PlatformPhotoStrategySelectionLayer3.swift functions
/// Ensures Photo strategy selection Layer 3 functions generate proper accessibility identifiers
/// for automated testing and accessibility tools compliance
final class PlatformPhotoStrategySelectionLayer3AccessibilityTests: XCTestCase {
    
    override func setUp() async throws {
        try await super.setUp()
        await AccessibilityTestUtilities.setupAccessibilityTestEnvironment()
    }
    
    override func tearDown() async throws {
        try await super.tearDown()
        await AccessibilityTestUtilities.cleanupAccessibilityTestEnvironment()
