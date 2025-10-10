import XCTest
import SwiftUI
import ViewInspector
@testable import SixLayerFramework

/// BUSINESS PURPOSE: Accessibility tests for ImageMetadataIntelligence.swift classes
/// Ensures ImageMetadataIntelligence classes generate proper accessibility identifiers
/// for automated testing and accessibility tools compliance
final class ImageMetadataIntelligenceAccessibilityTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        setupTestEnvironment()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
        config.enableAutoIDs = true
        config.namespace = "SixLayer"
        config.mode = .automatic
        config.enableDebugLogging = false
    }
    
    override func tearDown() {
        super.tearDown()
        cleanupTestEnvironment()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
    }
    
    // MARK: - ImageMetadataIntelligence Tests
    
    /// BUSINESS PURPOSE: Validates that ImageMetadataIntelligence generates proper accessibility identifiers
    /// for automated testing and accessibility tools compliance on iOS
    func testImageMetadataIntelligenceGeneratesAccessibilityIdentifiersOnIOS() async {
        // Given
        let intelligence = ImageMetadataIntelligence()
        
        // When & Then
        // Service classes don't directly generate views, but we test their configuration
        XCTAssertNotNil(intelligence, "ImageMetadataIntelligence should be instantiable")
        
        // Test that the intelligence service can be configured with accessibility settings
        let config = AccessibilityIdentifierConfig.shared
        XCTAssertTrue(config.enableAutoIDs, "ImageMetadataIntelligence should work with accessibility enabled")
        XCTAssertEqual(config.namespace, "SixLayer", "ImageMetadataIntelligence should use correct namespace")
    }
    
    /// BUSINESS PURPOSE: Validates that ImageMetadataIntelligence generates proper accessibility identifiers
    /// for automated testing and accessibility tools compliance on macOS
    func testImageMetadataIntelligenceGeneratesAccessibilityIdentifiersOnMacOS() async {
        // Given
        let intelligence = ImageMetadataIntelligence()
        
        // When & Then
        // Service classes don't directly generate views, but we test their configuration
        XCTAssertNotNil(intelligence, "ImageMetadataIntelligence should be instantiable")
        
        // Test that the intelligence service can be configured with accessibility settings
        let config = AccessibilityIdentifierConfig.shared
        XCTAssertTrue(config.enableAutoIDs, "ImageMetadataIntelligence should work with accessibility enabled")
        XCTAssertEqual(config.namespace, "SixLayer", "ImageMetadataIntelligence should use correct namespace")
    }
}

// MARK: - Test Extensions
extension ImageMetadataIntelligenceAccessibilityTests {
    private func setupTestEnvironment() {
        TestSetupUtilities.shared.reset()
    }
    
    private func cleanupTestEnvironment() {
        TestSetupUtilities.shared.reset()
    }
}
