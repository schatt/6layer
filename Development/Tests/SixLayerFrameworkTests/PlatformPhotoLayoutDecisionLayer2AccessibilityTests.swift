import XCTest
import SwiftUI
import ViewInspector
@testable import SixLayerFramework

/// BUSINESS PURPOSE: Accessibility tests for PlatformPhotoLayoutDecisionLayer2.swift functions
/// Ensures Photo layout decision Layer 2 functions generate proper accessibility identifiers
/// for automated testing and accessibility tools compliance
final class PlatformPhotoLayoutDecisionLayer2AccessibilityTests: XCTestCase {
    
    override func setUp() async throws {
        try await super.setUp()
        await await AccessibilityTestUtilities.setupAccessibilityTestEnvironment()
    }
    
    override func tearDown() async throws {
        await await AccessibilityTestUtilities.cleanupAccessibilityTestEnvironment()
