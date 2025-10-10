import XCTest
import SwiftUI
import ViewInspector
@testable import SixLayerFramework

/// BUSINESS PURPOSE: Accessibility tests for PlatformPhotoComponentsLayer4.swift functions
/// Ensures Photo components Layer 4 functions generate proper accessibility identifiers
/// for automated testing and accessibility tools compliance
final class PlatformPhotoComponentsLayer4AccessibilityTests: XCTestCase {
    
    override func setUp() async throws {
        try await super.setUp()
        await AccessibilityTestUtilities.setupAccessibilityTestEnvironment()
    }
    
    override func tearDown() async throws {
        try await super.tearDown()
        await AccessibilityTestUtilities.cleanupAccessibilityTestEnvironment()
