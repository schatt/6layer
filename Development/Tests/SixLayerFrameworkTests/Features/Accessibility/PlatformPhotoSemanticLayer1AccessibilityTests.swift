import Testing


import SwiftUI
import ViewInspector
@testable import SixLayerFramework

/// BUSINESS PURPOSE: Accessibility tests for PlatformPhotoSemanticLayer1.swift functions
/// Ensures Photo semantic Layer 1 functions generate proper accessibility identifiers
/// for automated testing and accessibility tools compliance
final class PlatformPhotoSemanticLayer1AccessibilityTests: BaseAccessibilityTestClass {
    
    override init() async throws {
        try await super.init()
    }
    
    deinit {
        Task { [weak self] in
            await self?.cleanupTestEnvironment()
        }
    }
            }
    
    // MARK: - Photo Capture Tests
    
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
        
        let view = await MainActor.run {
            platformPhotoCapture_L1(
                purpose: purpose,
                context: context,
                onImageCaptured: { _ in }
            )
        }
        
        // When & Then
        let hasAccessibilityID = await MainActor.run {
            hasAccessibilityIdentifier(
                view, 
                expectedPattern: "SixLayer.main.element.*", 
                platform: .iOS,
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
        
        let view = await MainActor.run {
            platformPhotoCapture_L1(
                purpose: purpose,
                context: context,
                onImageCaptured: { _ in }
            )
        }
        
        // When & Then
        let hasAccessibilityID = await MainActor.run {
            hasAccessibilityIdentifier(
                view, 
                expectedPattern: "SixLayer.main.element.*", 
                platform: .macOS,
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
        
        let view = await MainActor.run {
            platformPhotoSelection_L1(
                purpose: purpose,
                context: context,
                onImageSelected: { _ in }
            )
        }
        
        // When & Then
        let hasAccessibilityID = await MainActor.run {
            hasAccessibilityIdentifier(
                view, 
                expectedPattern: "SixLayer.main.element.*", 
                platform: .iOS,
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
        
        let view = await MainActor.run {
            platformPhotoSelection_L1(
                purpose: purpose,
                context: context,
                onImageSelected: { _ in }
            )
        }
        
        // When & Then
        let hasAccessibilityID = await MainActor.run {
            hasAccessibilityIdentifier(
                view, 
                expectedPattern: "SixLayer.main.element.*", 
                platform: .macOS,
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
        
        let view = await MainActor.run {
            platformPhotoDisplay_L1(
                purpose: purpose,
                context: context,
                image: testImage
            )
        }
        
        // When & Then
        let hasAccessibilityID = await MainActor.run {
            hasAccessibilityIdentifier(
                view, 
                expectedPattern: "SixLayer.main.element.*", 
                platform: .iOS,
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
        
        let view = await MainActor.run {
            platformPhotoDisplay_L1(
                purpose: purpose,
                context: context,
                image: testImage
            )
        }
        
        // When & Then
        let hasAccessibilityID = await MainActor.run {
            hasAccessibilityIdentifier(
                view, 
                expectedPattern: "SixLayer.main.element.*", 
                platform: .macOS,
                componentName: "platformPhotoDisplay_L1"
            )
        }
        
        #expect(hasAccessibilityID, "platformPhotoDisplay_L1 should generate accessibility identifiers on macOS")
    }


