import XCTest
import SwiftUI
import ViewInspector
@testable import SixLayerFramework

/// BUSINESS PURPOSE: Accessibility tests for SwitchControlManager.swift classes
/// Ensures SwitchControlManager classes generate proper accessibility identifiers
/// for automated testing and accessibility tools compliance
final class SwitchControlManagerAccessibilityTests: XCTestCase {
    
    @MainActor
    override func setUp() async throws {
        try await super.setUp()
        await AccessibilityTestUtilities.setupAccessibilityTestEnvironment()
    }
    
    @MainActor
    override func tearDown() async throws {
        try await super.tearDown()
        await AccessibilityTestUtilities.cleanupAccessibilityTestEnvironment()
