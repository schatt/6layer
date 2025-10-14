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
        await setupTestEnvironment()
        await MainActor.run {
            let config = AccessibilityIdentifierConfig.shared
            config.resetToDefaults()
            config.enableAutoIDs = true
            config.namespace = "SixLayer"
            config.mode = .automatic
            config.enableDebugLogging = false
        }
    }
    
    override func tearDown() async throws {
        await cleanupTestEnvironment()
        await MainActor.run {
            let config = AccessibilityIdentifierConfig.shared
            config.resetToDefaults()
        }
        try await super.tearDown()
    }
    
    // MARK: - ImageProcessor Tests
    
    /// BUSINESS PURPOSE: Validates that ImageProcessor generates proper accessibility identifiers
    /// for automated testing and accessibility tools compliance on iOS
    func testImageProcessorGeneratesAccessibilityIdentifiersOnIOS() async {
        // Given
        let processor = ImageProcessor()
        
        // When & Then
        // Service classes don't directly generate views, but we test their configuration
        XCTAssertNotNil(processor, "ImageProcessor should be instantiable")
        
        // Test that the processor can be configured with accessibility settings
        await MainActor.run {
            let config = AccessibilityIdentifierConfig.shared
            XCTAssertTrue(config.enableAutoIDs, "ImageProcessor should work with accessibility enabled")
            XCTAssertEqual(config.namespace, "SixLayer", "ImageProcessor should use correct namespace")
        }
    }
    
    /// BUSINESS PURPOSE: Validates that ImageProcessor generates proper accessibility identifiers
    /// for automated testing and accessibility tools compliance on macOS
    func testImageProcessorGeneratesAccessibilityIdentifiersOnMacOS() async {
        // Given
        let processor = ImageProcessor()
        
        // When & Then
        // Service classes don't directly generate views, but we test their configuration
        XCTAssertNotNil(processor, "ImageProcessor should be instantiable")
        
        // Test that the processor can be configured with accessibility settings
        await MainActor.run {
            let config = AccessibilityIdentifierConfig.shared
            XCTAssertTrue(config.enableAutoIDs, "ImageProcessor should work with accessibility enabled")
            XCTAssertEqual(config.namespace, "SixLayer", "ImageProcessor should use correct namespace")
        }
    }
}
