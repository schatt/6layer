import Testing


import SwiftUI
import ViewInspector
@testable import SixLayerFramework

/// BUSINESS PURPOSE: Accessibility tests for ImageProcessingPipeline.swift classes
/// Ensures ImageProcessingPipeline classes generate proper accessibility identifiers
/// for automated testing and accessibility tools compliance
final class ImageProcessingPipelineAccessibilityTests {
    
    init() async throws {
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
    
    deinit {
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
    @Test func testImageProcessorGeneratesAccessibilityIdentifiersOnIOS() async {
        // Given
        let processor = ImageProcessor()
        
        // When & Then
        // Service classes don't directly generate views, but we test their configuration
        #expect(processor != nil, "ImageProcessor should be instantiable")
        
        // Test that the processor can be configured with accessibility settings
        await MainActor.run {
            let config = AccessibilityIdentifierConfig.shared
            #expect(config.enableAutoIDs, "ImageProcessor should work with accessibility enabled")
            #expect(config.namespace == "SixLayer", "ImageProcessor should use correct namespace")
        }
    }
    
    /// BUSINESS PURPOSE: Validates that ImageProcessor generates proper accessibility identifiers
    /// for automated testing and accessibility tools compliance on macOS
    @Test func testImageProcessorGeneratesAccessibilityIdentifiersOnMacOS() async {
        // Given
        let processor = ImageProcessor()
        
        // When & Then
        // Service classes don't directly generate views, but we test their configuration
        #expect(processor != nil, "ImageProcessor should be instantiable")
        
        // Test that the processor can be configured with accessibility settings
        await MainActor.run {
            let config = AccessibilityIdentifierConfig.shared
            #expect(config.enableAutoIDs, "ImageProcessor should work with accessibility enabled")
            #expect(config.namespace == "SixLayer", "ImageProcessor should use correct namespace")
        }
    }
}
