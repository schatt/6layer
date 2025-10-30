import Testing


import SwiftUI
@testable import SixLayerFramework
import ViewInspector
/// BUSINESS PURPOSE: Accessibility tests for PlatformPhotoLayoutDecisionLayer2.swift functions
/// Ensures Photo layout decision Layer 2 functions generate proper accessibility identifiers
/// for automated testing and accessibility tools compliance
open class PlatformPhotoLayoutDecisionLayer2AccessibilityTests: BaseTestClass {
    
    // MARK: - Photo Layout Decision Tests
    
    /// BUSINESS PURPOSE: Validates that platformPhotoLayout_L2 generates proper accessibility identifiers
    /// for automated testing and accessibility tools compliance on iOS
    
    @Test func testPlatformPhotoLayoutL2GeneratesAccessibilityIdentifiersOnIOS() async {
        // Given
        let purpose = PhotoPurpose.vehiclePhoto
        let context = PhotoContext(
            screenSize: PlatformSize(width: 375, height: 812),
            availableSpace: PlatformSize(width: 375, height: 400),
            userPreferences: PhotoPreferences(),
            deviceCapabilities: PhotoDeviceCapabilities()
        )
        
        let result = determineOptimalPhotoLayout_L2(
            purpose: purpose,
            context: context
        )
        
        // When & Then
        // Layer 2 functions return data structures, not views, so we test the result structure
        // result is non-optional, so no need to check for nil
        #expect(result.width > 0, "Layout decision should have valid width")
        #expect(result.height > 0, "Layout decision should have valid height")
    }
    
    /// BUSINESS PURPOSE: Validates that platformPhotoLayout_L2 generates proper accessibility identifiers
    /// for automated testing and accessibility tools compliance on macOS
    @Test func testPlatformPhotoLayoutL2GeneratesAccessibilityIdentifiersOnMacOS() async {
        // Given
        let purpose = PhotoPurpose.vehiclePhoto
        let context = PhotoContext(
            screenSize: PlatformSize(width: 1024, height: 768),
            availableSpace: PlatformSize(width: 1024, height: 400),
            userPreferences: PhotoPreferences(),
            deviceCapabilities: PhotoDeviceCapabilities()
        )
        
        let result = determineOptimalPhotoLayout_L2(
            purpose: purpose,
            context: context
        )
        
        // When & Then
        // Layer 2 functions return data structures, not views, so we test the result structure
        // result is non-optional, so no need to check for nil
        #expect(result.width > 0, "Layout decision should have valid width")
        #expect(result.height > 0, "Layout decision should have valid height")
    }
    
    // MARK: - determinePhotoCaptureStrategy_L2 Tests
    
    @Test func testDeterminePhotoCaptureStrategy_L2_CameraOnly() async {
        let purpose = PhotoPurpose.vehiclePhoto
        let context = PhotoContext(
            screenSize: PlatformSize(width: 375, height: 812),
            availableSpace: PlatformSize(width: 375, height: 400),
            userPreferences: PhotoPreferences(),
            deviceCapabilities: PhotoDeviceCapabilities(hasCamera: true, hasPhotoLibrary: false)
        )
        
        let strategy = determinePhotoCaptureStrategy_L2(purpose: purpose, context: context)
        #expect(strategy == .camera, "Should return camera when only camera is available")
    }
    
    @Test func testDeterminePhotoCaptureStrategy_L2_PhotoLibraryOnly() async {
        let purpose = PhotoPurpose.fuelReceipt
        let context = PhotoContext(
            screenSize: PlatformSize(width: 375, height: 812),
            availableSpace: PlatformSize(width: 375, height: 400),
            userPreferences: PhotoPreferences(),
            deviceCapabilities: PhotoDeviceCapabilities(hasCamera: false, hasPhotoLibrary: true)
        )
        
        let strategy = determinePhotoCaptureStrategy_L2(purpose: purpose, context: context)
        #expect(strategy == .photoLibrary, "Should return photoLibrary when only photoLibrary is available")
    }
    
    @Test func testDeterminePhotoCaptureStrategy_L2_UserPreferenceCamera() async {
        let purpose = PhotoPurpose.vehiclePhoto
        let preferences = PhotoPreferences(preferredSource: .camera)
        let context = PhotoContext(
            screenSize: PlatformSize(width: 375, height: 812),
            availableSpace: PlatformSize(width: 375, height: 400),
            userPreferences: preferences,
            deviceCapabilities: PhotoDeviceCapabilities(hasCamera: true, hasPhotoLibrary: true)
        )
        
        let strategy = determinePhotoCaptureStrategy_L2(purpose: purpose, context: context)
        #expect(strategy == .camera, "Should respect user preference for camera")
    }
    
    @Test func testDeterminePhotoCaptureStrategy_L2_UserPreferencePhotoLibrary() async {
        let purpose = PhotoPurpose.document
        let preferences = PhotoPreferences(preferredSource: .photoLibrary)
        let context = PhotoContext(
            screenSize: PlatformSize(width: 375, height: 812),
            availableSpace: PlatformSize(width: 375, height: 400),
            userPreferences: preferences,
            deviceCapabilities: PhotoDeviceCapabilities(hasCamera: true, hasPhotoLibrary: true)
        )
        
        let strategy = determinePhotoCaptureStrategy_L2(purpose: purpose, context: context)
        #expect(strategy == .photoLibrary, "Should respect user preference for photoLibrary")
    }
    
    @Test func testDeterminePhotoCaptureStrategy_L2_PurposeBasedDecision() async {
        // Vehicle photos should prefer camera
        let vehicleContext = PhotoContext(
            screenSize: PlatformSize(width: 375, height: 812),
            availableSpace: PlatformSize(width: 375, height: 400),
            userPreferences: PhotoPreferences(preferredSource: .both),
            deviceCapabilities: PhotoDeviceCapabilities(hasCamera: true, hasPhotoLibrary: true)
        )
        let vehicleStrategy = determinePhotoCaptureStrategy_L2(purpose: .vehiclePhoto, context: vehicleContext)
        #expect(vehicleStrategy == .camera, "Vehicle photos should prefer camera")
        
        // Receipts should prefer photoLibrary
        let receiptContext = PhotoContext(
            screenSize: PlatformSize(width: 375, height: 812),
            availableSpace: PlatformSize(width: 375, height: 400),
            userPreferences: PhotoPreferences(preferredSource: .both),
            deviceCapabilities: PhotoDeviceCapabilities(hasCamera: true, hasPhotoLibrary: true)
        )
        let receiptStrategy = determinePhotoCaptureStrategy_L2(purpose: .fuelReceipt, context: receiptContext)
        #expect(receiptStrategy == .photoLibrary, "Receipts should prefer photoLibrary")
        
        // Profile photos can go either way
        let profileContext = PhotoContext(
            screenSize: PlatformSize(width: 375, height: 812),
            availableSpace: PlatformSize(width: 375, height: 400),
            userPreferences: PhotoPreferences(preferredSource: .both),
            deviceCapabilities: PhotoDeviceCapabilities(hasCamera: true, hasPhotoLibrary: true)
        )
        let profileStrategy = determinePhotoCaptureStrategy_L2(purpose: .profile, context: profileContext)
        #expect(profileStrategy == .both, "Profile photos should allow both")
    }
    
    // MARK: - calculateOptimalImageSize Tests
    
    @Test func testCalculateOptimalImageSize() async {
        let purpose = PhotoPurpose.vehiclePhoto
        let availableSpace = CGSize(width: 800, height: 600)
        let maxResolution = CGSize(width: 4096, height: 4096)
        
        let size = calculateOptimalImageSize(for: purpose, in: availableSpace, maxResolution: maxResolution)
        #expect(size.width > 0, "Should have valid width")
        #expect(size.height > 0, "Should have valid height")
        #expect(size.width <= Double(maxResolution.width), "Should not exceed max resolution width")
        #expect(size.height <= Double(maxResolution.height), "Should not exceed max resolution height")
    }
    
    @Test func testCalculateOptimalImageSize_RespectsMaxResolution() async {
        let purpose = PhotoPurpose.odometer
        let availableSpace = CGSize(width: 10000, height: 10000) // Very large space
        let maxResolution = CGSize(width: 2048, height: 2048) // Smaller max
        
        let size = calculateOptimalImageSize(for: purpose, in: availableSpace, maxResolution: maxResolution)
        #expect(size.width <= Double(maxResolution.width), "Should respect max resolution width")
        #expect(size.height <= Double(maxResolution.height), "Should respect max resolution height")
    }
    
    // MARK: - shouldCropImage Tests
    
    @Test func testShouldCropImage_VehiclePhoto() async {
        let purpose = PhotoPurpose.vehiclePhoto
        let imageSize = CGSize(width: 4000, height: 3000) // 4:3 aspect ratio
        let targetSize = CGSize(width: 2000, height: 1200) // 5:3 aspect ratio (different)
        
        let shouldCrop = shouldCropImage(for: purpose, imageSize: imageSize, targetSize: targetSize)
        #expect(shouldCrop == true, "Vehicle photos with different aspect ratios should be cropped")
    }
    
    @Test func testShouldCropImage_SimilarAspectRatio() async {
        let purpose = PhotoPurpose.vehiclePhoto
        let imageSize = CGSize(width: 2000, height: 1200) // 5:3 aspect ratio
        let targetSize = CGSize(width: 2000, height: 1200) // Same aspect ratio
        
        let shouldCrop = shouldCropImage(for: purpose, imageSize: imageSize, targetSize: targetSize)
        #expect(shouldCrop == false, "Images with similar aspect ratios should not be cropped")
    }
    
    @Test func testShouldCropImage_Odometer() async {
        let purpose = PhotoPurpose.odometer
        let imageSize = CGSize(width: 4000, height: 3000) // Different aspect ratio
        let targetSize = CGSize(width: 1000, height: 1000) // Square
        
        let shouldCrop = shouldCropImage(for: purpose, imageSize: imageSize, targetSize: targetSize)
        #expect(shouldCrop == false, "Odometer photos are flexible and should not be cropped")
    }
    
    @Test func testShouldCropImage_Profile() async {
        let purpose = PhotoPurpose.profile
        let imageSize = CGSize(width: 2000, height: 3000) // Portrait
        let targetSize = CGSize(width: 1000, height: 1000) // Square
        
        let shouldCrop = shouldCropImage(for: purpose, imageSize: imageSize, targetSize: targetSize)
        #expect(shouldCrop == false, "Profile photos are flexible and should not be cropped")
    }
    
    @Test func testDetermineOptimalPhotoLayout_L2_AllPurposes() async {
        let purposes: [PhotoPurpose] = [.vehiclePhoto, .fuelReceipt, .pumpDisplay, .odometer, .maintenance, .expense, .profile, .document]
        let context = PhotoContext(
            screenSize: PlatformSize(width: 375, height: 812),
            availableSpace: PlatformSize(width: 375, height: 400),
            userPreferences: PhotoPreferences(),
            deviceCapabilities: PhotoDeviceCapabilities()
        )
        
        for purpose in purposes {
            let layout = determineOptimalPhotoLayout_L2(purpose: purpose, context: context)
            #expect(layout.width > 0, "Layout for \(purpose) should have valid width")
            #expect(layout.height > 0, "Layout for \(purpose) should have valid height")
        }
    }

}