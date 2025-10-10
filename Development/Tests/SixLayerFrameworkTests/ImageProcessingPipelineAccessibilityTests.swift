import XCTest
import SwiftUI
import ViewInspector
@testable import SixLayerFramework

/// BUSINESS PURPOSE: Accessibility tests for ImageProcessingPipeline.swift classes
/// Ensures ImageProcessingPipeline classes generate proper accessibility identifiers
/// for automated testing and accessibility tools compliance
final class ImageProcessingPipelineAccessibilityTests: XCTestCase {
    
    override func setUp() async throws {
        try await super.setUp()
        await AccessibilityTestUtilities.setupAccessibilityTestEnvironment()
    }
    
    override func tearDown() async throws {
        try await super.tearDown()
        await AccessibilityTestUtilities.cleanupAccessibilityTestEnvironment()
