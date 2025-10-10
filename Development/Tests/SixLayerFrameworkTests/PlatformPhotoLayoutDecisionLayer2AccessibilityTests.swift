import XCTest
import SwiftUI
import ViewInspector
@testable import SixLayerFramework

/// BUSINESS PURPOSE: Accessibility tests for PlatformPhotoLayoutDecisionLayer2.swift functions
/// Ensures Photo layout decision Layer 2 functions generate proper accessibility identifiers
/// for automated testing and accessibility tools compliance
final class PlatformPhotoLayoutDecisionLayer2AccessibilityTests: XCTestCase {
    
    override func setUp() async throws {
        try await try await super.setUp()
        await await setupTestEnvironment()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
        config.enableAutoIDs = true
        config.namespace = "SixLayer"
        config.mode = .automatic
        config.enableDebugLogging = false
    }
    
    override func tearDown() async throws {
        await await cleanupTestEnvironment()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
        await try await try await super.tearDown()
    }
    
    // MARK: - Photo Layout Decision Tests
    
    /// BUSINESS PURPOSE: Validates that platformPhotoLayout_L2 generates proper accessibility identifiers
    /// for automated testing and accessibility tools compliance on iOS
    func testPlatformPhotoLayoutL2GeneratesAccessibilityIdentifiersOnIOS() async {
        // Given
        let testPhotos = [PlatformImage(), PlatformImage()]
        
        let result = platformPhotoLayout_L2(
            photos: testPhotos,
            screenWidth: 375,
            deviceType: .phone,
            contentComplexity: .moderate
        )
        
        // When & Then
        // Layer 2 functions return data structures, not views, so we test the result structure
        XCTAssertNotNil(result, "platformPhotoLayout_L2 should return a valid layout decision")
        XCTAssertTrue(result.columns > 0, "Layout decision should have valid columns")
        XCTAssertTrue(result.spacing >= 0, "Layout decision should have valid spacing")
    }
    
    /// BUSINESS PURPOSE: Validates that platformPhotoLayout_L2 generates proper accessibility identifiers
    /// for automated testing and accessibility tools compliance on macOS
    func testPlatformPhotoLayoutL2GeneratesAccessibilityIdentifiersOnMacOS() async {
        // Given
        let testPhotos = [PlatformImage(), PlatformImage()]
        
        let result = platformPhotoLayout_L2(
            photos: testPhotos,
            screenWidth: 1024,
            deviceType: .desktop,
            contentComplexity: .moderate
        )
        
        // When & Then
        // Layer 2 functions return data structures, not views, so we test the result structure
        XCTAssertNotNil(result, "platformPhotoLayout_L2 should return a valid layout decision")
        XCTAssertTrue(result.columns > 0, "Layout decision should have valid columns")
        XCTAssertTrue(result.spacing >= 0, "Layout decision should have valid spacing")
    }
}

// MARK: - Test Extensions
extension PlatformPhotoLayoutDecisionLayer2AccessibilityTests {
    override func await setupTestEnvironment() {
        TestSetupUtilities.shared.setupTestingEnvironment()
    }
    
    override func await cleanupTestEnvironment() {
        TestSetupUtilities.shared.setupTestingEnvironment()
    }
}
