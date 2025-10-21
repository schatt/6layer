import Testing


import SwiftUI
import ViewInspector
@testable import SixLayerFramework

/// BUSINESS PURPOSE: Accessibility tests for PlatformPhotoSemanticLayer1.swift functions
/// Ensures Photo semantic Layer 1 functions generate proper accessibility identifiers
/// for automated testing and accessibility tools compliance
open class PlatformPhotoSemanticLayer1AccessibilityTests: BaseTestClass {// MARK: - Photo Capture Tests
    
    /// BUSINESS PURPOSE: Validates that platformPhotoCapture_L1 generates proper accessibility identifiers
    /// for automated testing and accessibility tools compliance on iOS
    
    @Test func testPlatformPhotoCaptureL1GeneratesAccessibilityIdentifiersOnIOS() async {
        // Given
        let purpose = PhotoPurpose.vehiclePhoto
        let context = PhotoContext(
            screenSize: CGSize(width: 375, height: 812),
            availableSpace: CGSize(width: 375, height: 400),
            userPreferences: PhotoPreferences(),
            deviceCapabilities: PhotoDeviceCapabilities()
        )
        
        // When & Then
        let hasAccessibilityID = await MainActor.run {
            let view = platformPhotoCapture_L1(
                purpose: purpose,
                context: context,
                onImageCaptured: { _ in }
            )
            return testAccessibilityIdentifiersSinglePlatform(
                view, 
                expectedPattern: "SixLayer.main.element.*", 
                platform: SixLayerPlatform.iOS,
                platform: SixLayerPlatform.iOS,
            componentName: "platformPhotoCapture_L1"
            )
        }
        
        #expect(hasAccessibilityID, "platformPhotoCapture_L1 should generate accessibility identifiers on iOS")
    }
    
    /// BUSINESS PURPOSE: Validates that platformPhotoCapture_L1 generates proper accessibility identifiers
    /// for automated testing and accessibility tools compliance on macOS
    @Test func testPlatformPhotoCaptureL1GeneratesAccessibilityIdentifiersOnMacOS() async {
        // Given
        let purpose = PhotoPurpose.vehiclePhoto
        let context = PhotoContext(
            screenSize: CGSize(width: 1440, height: 900),
            availableSpace: CGSize(width: 1440, height: 600),
            userPreferences: PhotoPreferences(),
            deviceCapabilities: PhotoDeviceCapabilities()
        )
        
        // When & Then
        let hasAccessibilityID = await MainActor.run {
            let view = platformPhotoCapture_L1(
                purpose: purpose,
                context: context,
                onImageCaptured: { _ in }
            )
            return testAccessibilityIdentifiersSinglePlatform(
                view, 
                expectedPattern: "SixLayer.main.element.*", 
                platform: .macOS,
                platform: SixLayerPlatform.iOS,
            componentName: "platformPhotoCapture_L1"
            )
        }
        
        #expect(hasAccessibilityID, "platformPhotoCapture_L1 should generate accessibility identifiers on macOS")
    }
    
    // MARK: - Photo Selection Tests
    
    /// BUSINESS PURPOSE: Validates that platformPhotoSelection_L1 generates proper accessibility identifiers
    /// for automated testing and accessibility tools compliance on iOS
    @Test func testPlatformPhotoSelectionL1GeneratesAccessibilityIdentifiersOnIOS() async {
        // Given
        let purpose = PhotoPurpose.vehiclePhoto
        let context = PhotoContext(
            screenSize: CGSize(width: 375, height: 812),
            availableSpace: CGSize(width: 375, height: 400),
            userPreferences: PhotoPreferences(),
            deviceCapabilities: PhotoDeviceCapabilities()
        )
        
        // When & Then
        let hasAccessibilityID = await MainActor.run {
            let view = platformPhotoSelection_L1(
                purpose: purpose,
                context: context,
                onImageSelected: { _ in }
            )
            return testAccessibilityIdentifiersSinglePlatform(
                view, 
                expectedPattern: "SixLayer.main.element.*", 
                platform: SixLayerPlatform.iOS,
                platform: SixLayerPlatform.iOS,
            componentName: "platformPhotoSelection_L1"
            )
        }
        
        #expect(hasAccessibilityID, "platformPhotoSelection_L1 should generate accessibility identifiers on iOS")
    }
    
    /// BUSINESS PURPOSE: Validates that platformPhotoSelection_L1 generates proper accessibility identifiers
    /// for automated testing and accessibility tools compliance on macOS
    @Test func testPlatformPhotoSelectionL1GeneratesAccessibilityIdentifiersOnMacOS() async {
        // Given
        let purpose = PhotoPurpose.vehiclePhoto
        let context = PhotoContext(
            screenSize: CGSize(width: 1440, height: 900),
            availableSpace: CGSize(width: 1440, height: 600),
            userPreferences: PhotoPreferences(),
            deviceCapabilities: PhotoDeviceCapabilities()
        )
        
        // When & Then
        let hasAccessibilityID = await MainActor.run {
            let view = platformPhotoSelection_L1(
                purpose: purpose,
                context: context,
                onImageSelected: { _ in }
            )
            return testAccessibilityIdentifiersSinglePlatform(
                view, 
                expectedPattern: "SixLayer.main.element.*", 
                platform: .macOS,
                platform: SixLayerPlatform.iOS,
            componentName: "platformPhotoSelection_L1"
            )
        }
        
        #expect(hasAccessibilityID, "platformPhotoSelection_L1 should generate accessibility identifiers on macOS")
    }
    
    // MARK: - Photo Display Tests
    
    /// BUSINESS PURPOSE: Validates that platformPhotoDisplay_L1 generates proper accessibility identifiers
    /// for automated testing and accessibility tools compliance on iOS
    @Test func testPlatformPhotoDisplayL1GeneratesAccessibilityIdentifiersOnIOS() async {
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
        let hasAccessibilityID = await MainActor.run {
            let view = platformPhotoDisplay_L1(
                purpose: purpose,
                context: context,
                image: testImage
            )
            return testAccessibilityIdentifiersSinglePlatform(
                view, 
                expectedPattern: "SixLayer.main.element.*", 
                platform: SixLayerPlatform.iOS,
                platform: SixLayerPlatform.iOS,
            componentName: "platformPhotoDisplay_L1"
            )
        }
        
        #expect(hasAccessibilityID, "platformPhotoDisplay_L1 should generate accessibility identifiers on iOS")
    }
    
    /// BUSINESS PURPOSE: Validates that platformPhotoDisplay_L1 generates proper accessibility identifiers
    /// for automated testing and accessibility tools compliance on macOS
    @Test func testPlatformPhotoDisplayL1GeneratesAccessibilityIdentifiersOnMacOS() async {
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
        let hasAccessibilityID = await MainActor.run {
            let view = platformPhotoDisplay_L1(
                purpose: purpose,
                context: context,
                image: testImage
            )
            return testAccessibilityIdentifiersSinglePlatform(
                view, 
                expectedPattern: "SixLayer.main.element.*", 
                platform: .macOS,
                platform: SixLayerPlatform.iOS,
            componentName: "platformPhotoDisplay_L1"
            )
        }
        
        #expect(hasAccessibilityID, "platformPhotoDisplay_L1 should generate accessibility identifiers on macOS")
    }
}


