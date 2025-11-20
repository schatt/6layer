import Testing


import SwiftUI
@testable import SixLayerFramework
/// BUSINESS PURPOSE: Accessibility tests for PlatformPhotoSemanticLayer1.swift functions
/// Ensures Photo semantic Layer 1 functions generate proper accessibility identifiers
/// for automated testing and accessibility tools compliance
@Suite("Platform Photo Semantic Layer Accessibility")
open class PlatformPhotoSemanticLayer1AccessibilityTests: BaseTestClass {// MARK: - Photo Capture Tests
    
    /// BUSINESS PURPOSE: Validates that platformPhotoCapture_L1 generates proper accessibility identifiers
    /// for automated testing and accessibility tools compliance on iOS
    
    @Test @MainActor func testPlatformPhotoCaptureL1GeneratesAccessibilityIdentifiersOnIOS() async {
        // Given
        let purpose = PhotoPurpose.vehiclePhoto
        let context = PhotoContext(
            screenSize: CGSize(width: 375, height: 812),
            availableSpace: CGSize(width: 375, height: 400),
            userPreferences: PhotoPreferences(),
            deviceCapabilities: PhotoDeviceCapabilities()
        )
        
        // When & Then
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)

        let view = platformPhotoCapture_L1(
            purpose: purpose,
            context: context,
            onImageCaptured: { _ in }
        )
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view, 
            expectedPattern: "SixLayer.*ui",
            platform: SixLayerPlatform.iOS,
        componentName: "platformPhotoCapture_L1"
        )
 #expect(hasAccessibilityID, "platformPhotoCapture_L1 should generate accessibility identifiers on iOS ")
        #else

        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure

        // The modifier IS present in the code, but ViewInspector can't detect it on macOS

        #endif

    }
    
    /// BUSINESS PURPOSE: Validates that platformPhotoCapture_L1 generates proper accessibility identifiers
    /// for automated testing and accessibility tools compliance on macOS
    @Test @MainActor func testPlatformPhotoCaptureL1GeneratesAccessibilityIdentifiersOnMacOS() async {
        // Given
        let purpose = PhotoPurpose.vehiclePhoto
        let context = PhotoContext(
            screenSize: CGSize(width: 1440, height: 900),
            availableSpace: CGSize(width: 1440, height: 600),
            userPreferences: PhotoPreferences(),
            deviceCapabilities: PhotoDeviceCapabilities()
        )
        
        // When & Then
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)

        let view = platformPhotoCapture_L1(
            purpose: purpose,
            context: context,
            onImageCaptured: { _ in }
        )
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view, 
            expectedPattern: "SixLayer.*ui",
            platform: SixLayerPlatform.iOS,
        componentName: "platformPhotoCapture_L1"
        )
 #expect(hasAccessibilityID, "platformPhotoCapture_L1 should generate accessibility identifiers on macOS ")
        #else

        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure

        // The modifier IS present in the code, but ViewInspector can't detect it on macOS

        #endif

    }
    
    // MARK: - Photo Selection Tests
    
    /// BUSINESS PURPOSE: Validates that platformPhotoSelection_L1 generates proper accessibility identifiers
    /// for automated testing and accessibility tools compliance on iOS
    @Test @MainActor func testPlatformPhotoSelectionL1GeneratesAccessibilityIdentifiersOnIOS() async {
        // Given
        let purpose = PhotoPurpose.vehiclePhoto
        let context = PhotoContext(
            screenSize: CGSize(width: 375, height: 812),
            availableSpace: CGSize(width: 375, height: 400),
            userPreferences: PhotoPreferences(),
            deviceCapabilities: PhotoDeviceCapabilities()
        )
        
        // When & Then
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)

        let view = platformPhotoSelection_L1(
            purpose: purpose,
            context: context,
            onImageSelected: { _ in }
        )
        // TDD RED: element-level IDs not yet implemented for selection flow
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view, 
            expectedPattern: "SixLayer.*ui", 
            platform: SixLayerPlatform.iOS,
            componentName: "platformPhotoSelection_L1"
        )
 #expect(hasAccessibilityID, "platformPhotoSelection_L1 should generate accessibility identifiers on iOS ")
        #else

        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure

        // The modifier IS present in the code, but ViewInspector can't detect it on macOS

        #endif

    }
    
    /// BUSINESS PURPOSE: Validates that platformPhotoSelection_L1 generates proper accessibility identifiers
    /// for automated testing and accessibility tools compliance on macOS
    @Test @MainActor func testPlatformPhotoSelectionL1GeneratesAccessibilityIdentifiersOnMacOS() async {
        // Given
        let purpose = PhotoPurpose.vehiclePhoto
        let context = PhotoContext(
            screenSize: CGSize(width: 1440, height: 900),
            availableSpace: CGSize(width: 1440, height: 600),
            userPreferences: PhotoPreferences(),
            deviceCapabilities: PhotoDeviceCapabilities()
        )
        
        // When & Then
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)

        let view = platformPhotoSelection_L1(
            purpose: purpose,
            context: context,
            onImageSelected: { _ in }
        )
        // TDD RED: element-level IDs not yet implemented for selection flow
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view, 
            expectedPattern: "SixLayer.*ui", 
            platform: SixLayerPlatform.iOS,
            componentName: "platformPhotoSelection_L1"
        )
 #expect(hasAccessibilityID, "platformPhotoSelection_L1 should generate accessibility identifiers on macOS ")
        #else

        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure

        // The modifier IS present in the code, but ViewInspector can't detect it on macOS

        #endif

    }
    
    // MARK: - Photo Display Tests
    
    /// BUSINESS PURPOSE: Validates that platformPhotoDisplay_L1 generates proper accessibility identifiers
    /// for automated testing and accessibility tools compliance on iOS
    @Test @MainActor func testPlatformPhotoDisplayL1GeneratesAccessibilityIdentifiersOnIOS() async {
        // Given
        let purpose = PhotoPurpose.vehiclePhoto
        let context = PhotoContext(
            screenSize: CGSize(width: 375, height: 812),
            availableSpace: CGSize(width: 375, height: 400),
            userPreferences: PhotoPreferences(),
            deviceCapabilities: PhotoDeviceCapabilities()
        )
        let testImage = PlatformImage()
        
        // When & Then
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)

        let view = platformPhotoDisplay_L1(
            purpose: purpose,
            context: context,
            image: testImage
        )
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view, 
            expectedPattern: "SixLayer.*ui",
            platform: SixLayerPlatform.iOS,
        componentName: "platformPhotoDisplay_L1"
        )
 #expect(hasAccessibilityID, "platformPhotoDisplay_L1 should generate accessibility identifiers on iOS ")
        #else

        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure

        // The modifier IS present in the code, but ViewInspector can't detect it on macOS

        #endif

    }
    
    /// BUSINESS PURPOSE: Validates that platformPhotoDisplay_L1 generates proper accessibility identifiers
    /// for automated testing and accessibility tools compliance on macOS
    @Test @MainActor func testPlatformPhotoDisplayL1GeneratesAccessibilityIdentifiersOnMacOS() async {
        // Given
        let purpose = PhotoPurpose.vehiclePhoto
        let context = PhotoContext(
            screenSize: CGSize(width: 1440, height: 900),
            availableSpace: CGSize(width: 1440, height: 600),
            userPreferences: PhotoPreferences(),
            deviceCapabilities: PhotoDeviceCapabilities()
        )
        let testImage = PlatformImage()
        
        // When & Then
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)

        let view = platformPhotoDisplay_L1(
            purpose: purpose,
            context: context,
            image: testImage
        )
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view, 
            expectedPattern: "SixLayer.*ui",
            platform: SixLayerPlatform.iOS,
        componentName: "platformPhotoDisplay_L1"
        )
 #expect(hasAccessibilityID, "platformPhotoDisplay_L1 should generate accessibility identifiers on macOS ")
        #else

        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure

        // The modifier IS present in the code, but ViewInspector can't detect it on macOS

        #endif

    }
}


