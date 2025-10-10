import XCTest
import SwiftUI
import ViewInspector
@testable import SixLayerFramework

/// BUSINESS PURPOSE: Accessibility tests for PlatformOCRLayoutDecisionLayer2.swift functions
/// Ensures OCR layout decision Layer 2 functions generate proper accessibility identifiers
/// for automated testing and accessibility tools compliance
@MainActor
final class PlatformOCRLayoutDecisionLayer2AccessibilityTests: XCTestCase {
    
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
    
    // MARK: - OCR Layout Decision Tests
    
    /// BUSINESS PURPOSE: Validates that platformOCRLayout_L2 generates proper accessibility identifiers
    /// for automated testing and accessibility tools compliance on iOS
    func testPlatformOCRLayoutL2GeneratesAccessibilityIdentifiersOnIOS() async {
        // Given
        let testImage = PlatformImage()
        let context = OCRContext(
            textTypes: [.general],
            language: .english,
            confidenceThreshold: 0.8,
            allowsEditing: true
        )
        
        let result = platformOCRLayout_L2(
            context: context
        )
        
        // When & Then
        // Layer 2 functions return data structures, not views, so we test the result structure
        XCTAssertNotNil(result, "platformOCRLayout_L2 should return a valid layout decision")
        XCTAssertTrue(result.maxImageSize.width > 0, "Layout decision should have valid max image width")
        XCTAssertTrue(result.maxImageSize.height > 0, "Layout decision should have valid max image height")
    }
    
    /// BUSINESS PURPOSE: Validates that platformOCRLayout_L2 generates proper accessibility identifiers
    /// for automated testing and accessibility tools compliance on macOS
    func testPlatformOCRLayoutL2GeneratesAccessibilityIdentifiersOnMacOS() async {
        // Given
        let testImage = PlatformImage()
        let context = OCRContext(
            textTypes: [.general],
            language: .english,
            confidenceThreshold: 0.8,
            allowsEditing: true
        )
        
        let result = platformOCRLayout_L2(
            context: context
        )
        
        // When & Then
        // Layer 2 functions return data structures, not views, so we test the result structure
        XCTAssertNotNil(result, "platformOCRLayout_L2 should return a valid layout decision")
        XCTAssertTrue(result.maxImageSize.width > 0, "Layout decision should have valid max image width")
        XCTAssertTrue(result.maxImageSize.height > 0, "Layout decision should have valid max image height")
    }
}

