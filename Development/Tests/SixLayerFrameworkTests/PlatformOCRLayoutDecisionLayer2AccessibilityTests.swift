import XCTest
import SwiftUI
import ViewInspector
@testable import SixLayerFramework

/// BUSINESS PURPOSE: Accessibility tests for PlatformOCRLayoutDecisionLayer2.swift functions
/// Ensures OCR layout decision Layer 2 functions generate proper accessibility identifiers
/// for automated testing and accessibility tools compliance
final class PlatformOCRLayoutDecisionLayer2AccessibilityTests: XCTestCase {
    
    override func setUp() async throws {
        try await super.setUp()
        await AccessibilityTestUtilities.setupAccessibilityTestEnvironment()
    }
    
    override func tearDown() async throws {
        try await super.tearDown()
        await AccessibilityTestUtilities.cleanupAccessibilityTestEnvironment()
