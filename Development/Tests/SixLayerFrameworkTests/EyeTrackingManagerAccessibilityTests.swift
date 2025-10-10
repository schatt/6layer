import XCTest
import SwiftUI
import ViewInspector
@testable import SixLayerFramework

/// BUSINESS PURPOSE: Accessibility tests for EyeTrackingManager.swift classes
/// Ensures EyeTrackingManager classes generate proper accessibility identifiers
/// for automated testing and accessibility tools compliance
final class EyeTrackingManagerAccessibilityTests: XCTestCase {
    
    override func setUp() async throws {
        try await super.setUp()
        await await AccessibilityTestUtilities.setupAccessibilityTestEnvironment()
    }
    
    override func tearDown() async throws {
        await await AccessibilityTestUtilities.cleanupAccessibilityTestEnvironment()
