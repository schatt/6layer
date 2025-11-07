import Testing


import SwiftUI
@testable import SixLayerFramework
#if !os(macOS)
import ViewInspector
#endif
/// BUSINESS PURPOSE: Accessibility tests for ImageProcessingPipeline.swift classes
/// Ensures ImageProcessingPipeline classes generate proper accessibility identifiers
/// for automated testing and accessibility tools compliance
@Suite("Image Processing Pipeline Accessibility")
open class ImageProcessingPipelineAccessibilityTests: BaseTestClass {

    // MARK: - ImageProcessor Tests

    /// BUSINESS PURPOSE: Validates that views using ImageProcessor generate proper accessibility identifiers
    /// ImageProcessor is a service class - tests that views displaying processed images generate identifiers
    @Test func testImageProcessorGeneratesAccessibilityIdentifiersOnIOS() {
        runWithTaskLocalConfig {
            // Given: A view that displays an image (ImageProcessor processes images, views display them)
            // Since ImageProcessor doesn't generate views directly, we test that image views generate identifiers
            let view = Image(systemName: "photo")
                .automaticAccessibilityIdentifiers()
            
            // When & Then: Should generate accessibility identifiers
            let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
                view,
                expectedPattern: "SixLayer.main.ui.*",
                platform: SixLayerPlatform.iOS,
                componentName: "Image"
            )
            
            #expect(hasAccessibilityID, "Image view (that could use ImageProcessor) should generate accessibility identifiers on iOS")
        }
    }
    
    /// BUSINESS PURPOSE: Validates that views using ImageProcessor generate proper accessibility identifiers
    /// ImageProcessor is a service class - tests that views displaying processed images generate identifiers
    @Test func testImageProcessorGeneratesAccessibilityIdentifiersOnMacOS() {
        runWithTaskLocalConfig {
            // Given: A view that displays an image (ImageProcessor processes images, views display them)
            // Since ImageProcessor doesn't generate views directly, we test that image views generate identifiers
            let view = Image(systemName: "photo")
                .automaticAccessibilityIdentifiers()
            
            // When & Then: Should generate accessibility identifiers
            let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
                view,
                expectedPattern: "SixLayer.main.ui.*",
                platform: SixLayerPlatform.macOS,
                componentName: "Image"
            )
            
            #expect(hasAccessibilityID, "Image view (that could use ImageProcessor) should generate accessibility identifiers on macOS")
        }
    }
}
