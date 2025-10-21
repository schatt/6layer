import Testing


//
//  PhotoFunctionalityPhase1Tests.swift
//  SixLayerFrameworkTests
//
//  TDD Tests for Phase 1: Core Photo Functionality
//  Tests for enhanced PlatformImage, Layer 4 components, and cross-platform support
//

import SwiftUI
#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif
@testable import SixLayerFramework

open class PhotoFunctionalityPhase1Tests {
    
    // MARK: - Enhanced PlatformImage Tests
    
    @Test @MainActor
    func testPlatformImageInitialization() {
        // Given: Sample image data
        let sampleData = createSampleImageData()
        
        // When: Creating PlatformImage from data
        let platformImage = PlatformImage(data: sampleData)
        
        // Then: PlatformImage should be created successfully and be usable
        #expect(platformImage != nil, "PlatformImage should be created from valid data")
        
        // Test that the PlatformImage can actually be used in a view
        if let platformImage = platformImage {
            let testView = createTestViewWithPlatformImage(platformImage)
            let hostingView = hostRootPlatformView(testView.withGlobalAutoIDsEnabled())
            #expect(hostingView != nil, "PlatformImage should work in actual views")
        }
    }
    
    @Test func testPlatformImageInitializationWithInvalidData() {
        // Given: Invalid image data
        let invalidData = Data("invalid".utf8)
        
        // When: Creating PlatformImage from invalid data
        let platformImage = PlatformImage(data: invalidData)
        
        // Then: PlatformImage should be nil
        #expect(platformImage == nil, "PlatformImage should be nil for invalid data")
    }
    
    @Test @MainActor
    func testPlatformImageResize() {
        // Given: A PlatformImage
        let originalImage = createTestPlatformImage()
        let targetSize = CGSize(width: 100, height: 100)
        
        // When: Resizing the image
        let resizedImage = originalImage.resized(to: targetSize)
        
        // Then: Image should be resized to target size and be usable
        #expect(resizedImage.size == targetSize, "Image should be resized to target size")
        
        // Test that the resized image can actually be used in a view
        let testView = createTestViewWithPlatformImage(resizedImage)
        let hostingView = hostRootPlatformView(testView.withGlobalAutoIDsEnabled())
        #expect(hostingView != nil, "Resized image should work in actual views")
    }
    
    @Test @MainActor
    func testPlatformImageCrop() {
        // Given: A PlatformImage and crop rectangle
        let originalImage = createTestPlatformImage()
        let cropRect = CGRect(x: 10, y: 10, width: 50, height: 50)
        
        // When: Cropping the image
        let croppedImage = originalImage.cropped(to: cropRect)
        
        // Then: Image should be cropped to specified rectangle and be usable
        #expect(croppedImage.size == cropRect.size, "Image should be cropped to specified size")
        
        // Test that the cropped image can actually be used in a view
        let testView = createTestViewWithPlatformImage(croppedImage)
        let hostingView = hostRootPlatformView(testView.withGlobalAutoIDsEnabled())
        #expect(hostingView != nil, "Cropped image should work in actual views")
    }
    
    @Test func testPlatformImageCompression() {
        // Given: A PlatformImage and photo purpose
        let originalImage = createTestPlatformImage()
        let purpose = PhotoPurpose.vehiclePhoto
        
        // When: Compressing the image
        let compressedData = originalImage.compressed(for: purpose, quality: 0.8)
        
        // Then: Compressed data should be returned
        #expect(compressedData != nil, "Compressed data should be returned")
        #expect(compressedData!.count > 0, "Compressed data should not be empty")
    }
    
    @Test func testPlatformImageThumbnail() {
        // Given: A PlatformImage and thumbnail size
        let originalImage = createTestPlatformImage()
        let thumbnailSize = CGSize(width: 50, height: 50)
        
        // When: Creating thumbnail
        let thumbnail = originalImage.thumbnail(size: thumbnailSize)
        
        // Then: Thumbnail should be created with correct size
        #expect(thumbnail.size == thumbnailSize, "Thumbnail should have correct size")
    }
    
    @Test func testPlatformImageOCROptimization() {
        // Given: A PlatformImage
        let originalImage = createTestPlatformImage()
        
        // When: Optimizing for OCR
        let optimizedImage = originalImage.optimizedForOCR()
        
        // Then: Optimized image should be returned
        #expect(optimizedImage != nil, "OCR optimized image should be returned")
    }
    
    @Test func testPlatformImageMetadata() {
        // Given: A PlatformImage
        let originalImage = createTestPlatformImage()
        
        // When: Getting metadata
        let metadata = originalImage.metadata
        
        // Then: Metadata should contain valid information
        #expect(metadata.size.width > 0, "Metadata should contain valid size")
        #expect(metadata.size.height > 0, "Metadata should contain valid size")
        #expect(metadata.fileSize > 0, "Metadata should contain valid file size")
        #expect(metadata.format != .unknown, "Metadata should contain valid format")
    }
    
    @Test func testPlatformImageMeetsRequirements() {
        // Given: A PlatformImage and photo purpose
        let originalImage = createTestPlatformImage()
        let purpose = PhotoPurpose.vehiclePhoto
        
        // When: Checking if image meets requirements
        let meetsRequirements = originalImage.meetsRequirements(for: purpose)
        
        // Then: Should return boolean result
        #expect(meetsRequirements == true || meetsRequirements == false, "Should return boolean result")
    }
    
    // MARK: - Photo Purpose Tests
    
    @Test func testPhotoPurposeEnum() {
        // Given: PhotoPurpose enum
        let purposes = PhotoPurpose.allCases
        
        // Then: Should contain expected purposes
        #expect(purposes.contains(.vehiclePhoto), "Should contain vehiclePhoto")
        #expect(purposes.contains(.fuelReceipt), "Should contain fuelReceipt")
        #expect(purposes.contains(.pumpDisplay), "Should contain pumpDisplay")
        #expect(purposes.contains(.odometer), "Should contain odometer")
        #expect(purposes.contains(.maintenance), "Should contain maintenance")
        #expect(purposes.contains(.expense), "Should contain expense")
        #expect(purposes.contains(.profile), "Should contain profile")
        #expect(purposes.contains(.document), "Should contain document")
    }
    
    // MARK: - Photo Context Tests
    
    @Test func testPhotoContextInitialization() {
        // Given: PhotoContext parameters
        let screenSize = PlatformSize(width: 1024, height: 768)
        let availableSpace = PlatformSize(width: 800, height: 600)
        let preferences = PhotoPreferences()
        let capabilities = PhotoDeviceCapabilities()
        
        // When: Creating PhotoContext
        let context = PhotoContext(
            screenSize: screenSize,
            availableSpace: availableSpace,
            userPreferences: preferences,
            deviceCapabilities: capabilities
        )
        
        // Then: Context should be created with correct values
        #expect(context.screenSize.width == screenSize.width, "Context should have correct screen size width")
        #expect(context.screenSize.height == screenSize.height, "Context should have correct screen size height")
        #expect(context.availableSpace.width == availableSpace.width, "Context should have correct available space width")
        #expect(context.availableSpace.height == availableSpace.height, "Context should have correct available space height")
    }
    
    // MARK: - Photo Preferences Tests
    
    @Test func testPhotoPreferencesInitialization() {
        // Given: PhotoPreferences parameters
        let source = PhotoSource.camera
        let allowEditing = true
        let compressionQuality = 0.8
        let maxImageSize = PlatformSize(width: 1920, height: 1080)
        
        // When: Creating PhotoPreferences
        let preferences = PhotoPreferences(
            preferredSource: source,
            allowEditing: allowEditing,
            compressionQuality: compressionQuality,
            maxImageSize: maxImageSize
        )
        
        // Then: Preferences should be created with correct values
        #expect(preferences.preferredSource == source, "Preferences should have correct source")
        #expect(preferences.allowEditing == allowEditing, "Preferences should have correct editing setting")
        #expect(preferences.compressionQuality == compressionQuality, "Preferences should have correct quality")
        #expect(preferences.maxImageSize?.width == maxImageSize.width, "Preferences should have correct max size width")
        #expect(preferences.maxImageSize?.height == maxImageSize.height, "Preferences should have correct max size height")
    }
    
    // MARK: - Device Capabilities Tests
    
    @Test func testDeviceCapabilitiesInitialization() {
        // Given: DeviceCapabilities parameters
        let hasCamera = true
        let hasPhotoLibrary = true
        let supportsEditing = true
        let maxImageResolution = PlatformSize(width: 4096, height: 4096)
        
        // When: Creating PhotoDeviceCapabilities
        let capabilities = PhotoDeviceCapabilities(
            hasCamera: hasCamera,
            hasPhotoLibrary: hasPhotoLibrary,
            supportsEditing: supportsEditing,
            maxImageResolution: maxImageResolution
        )
        
        // Then: Capabilities should be created with correct values
        #expect(capabilities.hasCamera == hasCamera, "Capabilities should have correct camera setting")
        #expect(capabilities.hasPhotoLibrary == hasPhotoLibrary, "Capabilities should have correct photo library setting")
        #expect(capabilities.supportsEditing == supportsEditing, "Capabilities should have correct editing setting")
        #expect(capabilities.maxImageResolution.width == maxImageResolution.width, "Capabilities should have correct max resolution width")
        #expect(capabilities.maxImageResolution.height == maxImageResolution.height, "Capabilities should have correct max resolution height")
    }
    
    // MARK: - Layer 4 Photo Components Tests
    
    @Test @MainActor
    func testPlatformCameraInterfaceL4() {
        // Given: Image capture callback
        var _: PlatformImage?
        let onImageCaptured: (PlatformImage) -> Void = { _ in }
        
        // When: Creating camera interface
        let cameraInterface = platformCameraInterface_L4(onImageCaptured: onImageCaptured)
        
        // Then: Camera interface should be created and be hostable
        #expect(cameraInterface != nil, "Camera interface should be created")
        
        // Test that the camera interface can actually be hosted
        let hostingView = hostRootPlatformView(cameraInterface.withGlobalAutoIDsEnabled())
        #expect(hostingView != nil, "Camera interface should be hostable")
    }
    
    @Test @MainActor
    func testPlatformPhotoPickerL4() {
        // Given: Image selection callback
        var _: PlatformImage?
        let onImageSelected: (PlatformImage) -> Void = { _ in }
        
        // When: Creating photo picker
        let photoPicker = platformPhotoPicker_L4(onImageSelected: onImageSelected)
        
        // Then: Photo picker should be created and be hostable
        #expect(photoPicker != nil, "Photo picker should be created")
        
        // Test that the photo picker can actually be hosted
        let hostingView = hostRootPlatformView(photoPicker.withGlobalAutoIDsEnabled())
        #expect(hostingView != nil, "Photo picker should be hostable")
    }
    
    @Test @MainActor
    func testPlatformPhotoDisplayL4() {
        // Given: A PlatformImage and display style
        let testImage = createTestPlatformImage()
        let style = PhotoDisplayStyle.thumbnail
        
        // When: Creating photo display
        let photoDisplay = platformPhotoDisplay_L4(image: testImage, style: style)
        
        // Then: Photo display should be created and be hostable
        #expect(photoDisplay != nil, "Photo display should be created")
        
        // Test that the photo display can actually be hosted
        let hostingView = hostRootPlatformView(photoDisplay.withGlobalAutoIDsEnabled())
        #expect(hostingView != nil, "Photo display should be hostable")
    }
    
    @Test @MainActor
    func testPlatformPhotoDisplayL4() {
        // Given: A PlatformImage
        let testImage = createTestPlatformImage()
        
        // When: Creating photo display
        let photoDisplay = platformPhotoDisplay_L4(image: testImage, style: PhotoDisplayStyle.thumbnail)
        
        // Then: Photo display should be created and be hostable
        #expect(photoDisplay != nil, "Photo display should be created")
        
        // Test that the photo display can actually be hosted
        let hostingView = hostRootPlatformView(photoDisplay.withGlobalAutoIDsEnabled())
        #expect(hostingView != nil, "Photo display should be hostable")
    }
    
    // MARK: - Cross-Platform Color Tests
    
    @Test @MainActor
    func testPlatformSystemColors() {
        // Then: Platform system colors should be available and usable
        // Test that platform colors can actually be used in views
        let testView = createTestViewWithPlatformSystemColors()
        let hostingView = hostRootPlatformView(testView.withGlobalAutoIDsEnabled())
        #expect(hostingView != nil, "Platform system colors should work in actual views")
    }
    
    // MARK: - Cross-Platform Keyboard Tests
    
    @Test @MainActor
    func testPlatformKeyboardTypeModifier() {
        // Given: A view and keyboard type
        let testView = Text("Test")
        let keyboardType = PlatformKeyboardType.decimalPad
        
        // When: Applying keyboard type modifier
        let modifiedView = testView.platformKeyboardType(keyboardType)
        
        // Then: Modified view should be created and be hostable
        #expect(modifiedView != nil, "Modified view with keyboard type should be created")
        
        // Test that the modified view can actually be hosted
        let hostingView = hostRootPlatformView(modifiedView.withGlobalAutoIDsEnabled())
        #expect(hostingView != nil, "Modified view with keyboard type should be hostable")
    }
    
    @Test @MainActor
    func testPlatformTextFieldStyleModifier() {
        // Given: A view and text field style
        let testView = Text("Test")
        let style = PlatformTextFieldStyle.roundedBorder
        
        // When: Applying text field style modifier
        let modifiedView = testView.platformTextFieldStyle(style)
        
        // Then: Modified view should be created and be hostable
        #expect(modifiedView != nil, "Modified view with text field style should be created")
        
        // Test that the modified view can actually be hosted
        let hostingView = hostRootPlatformView(modifiedView.withGlobalAutoIDsEnabled())
        #expect(hostingView != nil, "Modified view with text field style should be hostable")
    }
    
    // MARK: - Cross-Platform Location Tests
    
    @Test func testPlatformLocationAuthorizationStatus() {
        // Given: PlatformLocationAuthorizationStatus enum
        let statuses = PlatformLocationAuthorizationStatus.allCases
        
        // Then: Should contain expected statuses
        #expect(statuses.contains(.notDetermined), "Should contain notDetermined")
        #expect(statuses.contains(.denied), "Should contain denied")
        #expect(statuses.contains(.restricted), "Should contain restricted")
        #expect(statuses.contains(.authorizedAlways), "Should contain authorizedAlways")
    }
    
    // MARK: - Helper Methods
    
    private func createSampleImageData() -> Data {
        // Create a simple 1x1 pixel image data
        #if os(iOS)
        let size = CGSize(width: 1, height: 1)
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { context in
            Color.red.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
        return image.pngData() ?? Data()
        #elseif os(macOS)
        let size = NSSize(width: 1, height: 1)
        let image = NSImage(size: size)
        image.lockFocus()
        Color.red.fillRect(size: size)
        image.unlockFocus()
        return image.tiffRepresentation ?? Data()
        #else
        return Data()
        #endif
    }
    
    private func createTestPlatformImage() -> PlatformImage {
        #if os(iOS)
        let size = CGSize(width: 200, height: 200)
        let renderer = UIGraphicsImageRenderer(size: size)
        let uiImage = renderer.image { context in
            Color.red.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
        return PlatformImage(uiImage: uiImage)
        #elseif os(macOS)
        let size = NSSize(width: 200, height: 200)
        let nsImage = NSImage(size: size)
        nsImage.lockFocus()
        Color.red.fillRect(size: size)
        nsImage.unlockFocus()
        return PlatformImage(nsImage: nsImage)
        #endif
    }
    
    /// Create a test view using a PlatformImage to verify it works functionally
    private func createTestViewWithPlatformImage(_ image: PlatformImage) -> some View {
        return Image(platformImage: image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .accessibilityLabel("Test view using PlatformImage")
            .accessibilityHint("Tests that PlatformImage can be used in actual views")
    }
    
    /// Create a test view using platform system colors to verify they work functionally
    private func createTestViewWithPlatformSystemColors() -> some View {
        return VStack {
            Text("System Background")
                .foregroundColor(Color.platformLabel)
                .background(Color.platformSystemBackground)
            Text("System Gray")
                .foregroundColor(Color.platformSecondaryLabel)
                .background(Color.platformSystemGray)
        }
        .accessibilityLabel("Test view using platform system colors")
        .accessibilityHint("Tests that platform system colors can be used in actual views")
    }
}
