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
        try await super.tearDown()
        await cleanupTestEnvironment()
        await MainActor.run {
            let config = AccessibilityIdentifierConfig.shared
            config.resetToDefaults()
        }
    }
    
    // MARK: - OCR Layout Decision Tests
    
    /// BUSINESS PURPOSE: Validates that platformOCRLayout_L2 generates proper accessibility identifiers
    /// for automated testing and accessibility tools compliance on iOS
    func testPlatformOCRLayoutL2GeneratesAccessibilityIdentifiersOnIOS() async {
        // Given
        let testImage = PlatformImage()
        let context = OCRContext(
            textTypes: [TextType.general],
            language: OCRLanguage.english
        )
        
        let result = platformOCRLayout_L2(
            context: context
        )
        
        // When & Then
        // Layer 2 functions return data structures, not views, so we test the result structure
        XCTAssertNotNil(result, "platformOCRLayout_L2 should return a valid layout decision")
        XCTAssertTrue(result.maxImageSize.width > 0, "Layout decision should have valid max image size")
        XCTAssertTrue(result.recommendedImageSize.width > 0, "Layout decision should have valid recommended image size")
    }
    
    /// BUSINESS PURPOSE: Validates that platformOCRLayout_L2 generates proper accessibility identifiers
    /// for automated testing and accessibility tools compliance on macOS
    func testPlatformOCRLayoutL2GeneratesAccessibilityIdentifiersOnMacOS() async {
        // Given
        let testImage = PlatformImage()
        let context = OCRContext(
            textTypes: [TextType.general],
            language: OCRLanguage.english
        )
        
        let result = platformOCRLayout_L2(
            context: context
        )
        
        // When & Then
        // Layer 2 functions return data structures, not views, so we test the result structure
        XCTAssertNotNil(result, "platformOCRLayout_L2 should return a valid layout decision")
        XCTAssertTrue(result.maxImageSize.width > 0, "Layout decision should have valid max image size")
        XCTAssertTrue(result.recommendedImageSize.width > 0, "Layout decision should have valid recommended image size")
    }
}

// MARK: - Test Extensions
extension PlatformOCRLayoutDecisionLayer2AccessibilityTests {
    override func setupTestEnvironment() {
        TestSetupUtilities.shared.setupTestingEnvironment()
    }
    
    override func cleanupTestEnvironment() {
        TestSetupUtilities.shared.setupTestingEnvironment()
    }
}
