import XCTest
import SwiftUI
import ViewInspector
@testable import SixLayerFramework

/// BUSINESS PURPOSE: Accessibility tests for PlatformPhotoSemanticLayer1.swift functions
/// Ensures Photo semantic Layer 1 functions generate proper accessibility identifiers
/// for automated testing and accessibility tools compliance
final class PlatformPhotoSemanticLayer1AccessibilityTests: XCTestCase {
    
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
    
    // MARK: - Photo Capture Tests
    
    /// BUSINESS PURPOSE: Validates that platformPhotoCapture_L1 generates proper accessibility identifiers
    /// for automated testing and accessibility tools compliance on iOS
    func testPlatformPhotoCaptureL1GeneratesAccessibilityIdentifiersOnIOS() async {
        // Given
        let purpose = PhotoPurpose.vehiclePhoto
        let context = PhotoContext(
            screenSize: CGSize(width: 375, height: 812),
            availableSpace: CGSize(width: 375, height: 400),
            userPreferences: PhotoPreferences(),
            deviceCapabilities: PhotoDeviceCapabilities()
        )
        
        let view = platformPhotoCapture_L1(
            purpose: purpose,
            context: context,
            onImageCaptured: { _ in }
        )
        
        // When & Then
        let hasAccessibilityID = await MainActor.run {
            hasAccessibilityIdentifier(
                view, 
                expectedPattern: "SixLayer.*element.*photocapture", 
                platform: .iOS,
                componentName: "platformPhotoCapture_L1"
            )
        }
        
        XCTAssertTrue(hasAccessibilityID, "platformPhotoCapture_L1 should generate accessibility identifiers on iOS")
    }
    
    /// BUSINESS PURPOSE: Validates that platformPhotoCapture_L1 generates proper accessibility identifiers
    /// for automated testing and accessibility tools compliance on macOS
    func testPlatformPhotoCaptureL1GeneratesAccessibilityIdentifiersOnMacOS() async {
        // Given
        let purpose = PhotoPurpose.vehiclePhoto
        let context = PhotoContext(
            screenSize: CGSize(width: 1440, height: 900),
            availableSpace: CGSize(width: 1440, height: 600),
            userPreferences: PhotoPreferences(),
            deviceCapabilities: PhotoDeviceCapabilities()
        )
        
        let view = platformPhotoCapture_L1(
            purpose: purpose,
            context: context,
            onImageCaptured: { _ in }
        )
        
        // When & Then
        let hasAccessibilityID = await MainActor.run {
            hasAccessibilityIdentifier(
                view, 
                expectedPattern: "SixLayer.*element.*photocapture", 
                platform: .macOS,
                componentName: "platformPhotoCapture_L1"
            )
        }
        
        XCTAssertTrue(hasAccessibilityID, "platformPhotoCapture_L1 should generate accessibility identifiers on macOS")
    }
    
    // MARK: - Photo Selection Tests
    
    /// BUSINESS PURPOSE: Validates that platformPhotoSelection_L1 generates proper accessibility identifiers
    /// for automated testing and accessibility tools compliance on iOS
    func testPlatformPhotoSelectionL1GeneratesAccessibilityIdentifiersOnIOS() async {
        // Given
        let purpose = PhotoPurpose.vehiclePhoto
        let context = PhotoContext(
            screenSize: CGSize(width: 375, height: 812),
            availableSpace: CGSize(width: 375, height: 400),
            userPreferences: PhotoPreferences(),
            deviceCapabilities: PhotoDeviceCapabilities()
        )
        
        let view = platformPhotoSelection_L1(
            purpose: purpose,
            context: context,
            onImageSelected: { _ in }
        )
        
        // When & Then
        let hasAccessibilityID = await MainActor.run {
            hasAccessibilityIdentifier(
                view, 
                expectedPattern: "SixLayer.*element.*photoselection", 
                platform: .iOS,
                componentName: "platformPhotoSelection_L1"
            )
        }
        
        XCTAssertTrue(hasAccessibilityID, "platformPhotoSelection_L1 should generate accessibility identifiers on iOS")
    }
    
    /// BUSINESS PURPOSE: Validates that platformPhotoSelection_L1 generates proper accessibility identifiers
    /// for automated testing and accessibility tools compliance on macOS
    func testPlatformPhotoSelectionL1GeneratesAccessibilityIdentifiersOnMacOS() async {
        // Given
        let purpose = PhotoPurpose.vehiclePhoto
        let context = PhotoContext(
            screenSize: CGSize(width: 1440, height: 900),
            availableSpace: CGSize(width: 1440, height: 600),
            userPreferences: PhotoPreferences(),
            deviceCapabilities: PhotoDeviceCapabilities()
        )
        
        let view = platformPhotoSelection_L1(
            purpose: purpose,
            context: context,
            onImageSelected: { _ in }
        )
        
        // When & Then
        let hasAccessibilityID = await MainActor.run {
            hasAccessibilityIdentifier(
                view, 
                expectedPattern: "SixLayer.*element.*photoselection", 
                platform: .macOS,
                componentName: "platformPhotoSelection_L1"
            )
        }
        
        XCTAssertTrue(hasAccessibilityID, "platformPhotoSelection_L1 should generate accessibility identifiers on macOS")
    }
    
    // MARK: - Photo Display Tests
    
    /// BUSINESS PURPOSE: Validates that platformPhotoDisplay_L1 generates proper accessibility identifiers
    /// for automated testing and accessibility tools compliance on iOS
    func testPlatformPhotoDisplayL1GeneratesAccessibilityIdentifiersOnIOS() async {
        // Given
        let purpose = PhotoPurpose.vehiclePhoto
        let context = PhotoContext(
            screenSize: CGSize(width: 375, height: 812),
            availableSpace: CGSize(width: 375, height: 400),
            userPreferences: PhotoPreferences(),
            deviceCapabilities: PhotoDeviceCapabilities()
        )
        let testImage = PlatformImage()
        
        let view = platformPhotoDisplay_L1(
            purpose: purpose,
            context: context,
            image: testImage
        )
        
        // When & Then
        let hasAccessibilityID = await MainActor.run {
            hasAccessibilityIdentifier(
                view, 
                expectedPattern: "SixLayer.*element.*photodisplay", 
                platform: .iOS,
                componentName: "platformPhotoDisplay_L1"
            )
        }
        
        XCTAssertTrue(hasAccessibilityID, "platformPhotoDisplay_L1 should generate accessibility identifiers on iOS")
    }
    
    /// BUSINESS PURPOSE: Validates that platformPhotoDisplay_L1 generates proper accessibility identifiers
    /// for automated testing and accessibility tools compliance on macOS
    func testPlatformPhotoDisplayL1GeneratesAccessibilityIdentifiersOnMacOS() async {
        // Given
        let purpose = PhotoPurpose.vehiclePhoto
        let context = PhotoContext(
            screenSize: CGSize(width: 1440, height: 900),
            availableSpace: CGSize(width: 1440, height: 600),
            userPreferences: PhotoPreferences(),
            deviceCapabilities: PhotoDeviceCapabilities()
        )
        let testImage = PlatformImage()
        
        let view = platformPhotoDisplay_L1(
            purpose: purpose,
            context: context,
            image: testImage
        )
        
        // When & Then
        let hasAccessibilityID = await MainActor.run {
            hasAccessibilityIdentifier(
                view, 
                expectedPattern: "SixLayer.*element.*photodisplay", 
                platform: .macOS,
                componentName: "platformPhotoDisplay_L1"
            )
        }
        
        XCTAssertTrue(hasAccessibilityID, "platformPhotoDisplay_L1 should generate accessibility identifiers on macOS")
    }
}

// MARK: - Test Extensions
extension PlatformPhotoSemanticLayer1AccessibilityTests {
    override func setupTestEnvironment() {
        TestSetupUtilities.shared.setupTestingEnvironment()
    }
    
    override func cleanupTestEnvironment() {
        TestSetupUtilities.shared.setupTestingEnvironment()
    }
}
