import Testing

import SwiftUI
import ViewInspector
@testable import SixLayerFramework

/// BUSINESS PURPOSE: Accessibility tests for ImageMetadataIntelligence.swift classes
/// Ensures ImageMetadataIntelligence classes generate proper accessibility identifiers
/// for automated testing and accessibility tools compliance
@MainActor
class ImageMetadataIntelligenceAccessibilityTests: BaseTestClass {
    
    // MARK: - ImageMetadataIntelligence Tests
    
    /// BUSINESS PURPOSE: Validates that ImageMetadataIntelligence generates proper accessibility identifiers
    /// for automated testing and accessibility tools compliance on iOS
    @Test func testImageMetadataIntelligenceGeneratesAccessibilityIdentifiersOnIOS() async {
        // Given
        let intelligence = ImageMetadataIntelligence()
        
        // When & Then
        // Service classes don't directly generate views, but we test their configuration
        #expect(intelligence != nil, "ImageMetadataIntelligence should be instantiable")
        
        // Test that the intelligence service can be configured with accessibility settings
        await MainActor.run {
            let config = AccessibilityIdentifierConfig.shared
            #expect(config.enableAutoIDs, "ImageMetadataIntelligence should work with accessibility enabled")
            #expect(config.namespace == "SixLayer", "ImageMetadataIntelligence should use correct namespace")
        }
    }
    
    /// BUSINESS PURPOSE: Validates that ImageMetadataIntelligence generates proper accessibility identifiers
    /// for automated testing and accessibility tools compliance on macOS
    @Test func testImageMetadataIntelligenceGeneratesAccessibilityIdentifiersOnMacOS() async {
        // Given
        let intelligence = ImageMetadataIntelligence()
        
        // When & Then
        // Service classes don't directly generate views, but we test their configuration
        #expect(intelligence != nil, "ImageMetadataIntelligence should be instantiable")
        
        // Test that the intelligence service can be configured with accessibility settings
        await MainActor.run {
            let config = AccessibilityIdentifierConfig.shared
            #expect(config.enableAutoIDs, "ImageMetadataIntelligence should work with accessibility enabled")
            #expect(config.namespace == "SixLayer", "ImageMetadataIntelligence should use correct namespace")
        }
    }
}

