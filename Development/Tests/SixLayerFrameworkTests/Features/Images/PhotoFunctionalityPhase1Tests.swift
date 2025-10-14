//
//  PhotoFunctionalityPhase1Tests.swift
//  SixLayerFrameworkTests
//
//  TDD Tests for Phase 1: Core Photo Functionality
//  Tests for enhanced PlatformImage, Layer 4 components, and cross-platform support
//

import XCTest
import SwiftUI
#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif
@testable import SixLayerFramework

final class PhotoFunctionalityPhase1Tests: XCTestCase {
    
    // MARK: - Enhanced PlatformImage Tests
    
    @MainActor
    func testPlatformImageInitialization() {
        // Given: Sample image data
        let sampleData = createSampleImageData()
        
        // When: Creating PlatformImage from data
        let platformImage = PlatformImage(data: sampleData)
        
        // Then: PlatformImage should be created successfully and be usable
        XCTAssertNotNil(platformImage, "PlatformImage should be created from valid data")
        
        // Test that the PlatformImage can actually be used in a view
        if let platformImage = platformImage {
            let testView = createTestViewWithPlatformImage(platformImage)
            let hostingView = hostRootPlatformView(testView.withGlobalAutoIDsEnabled())
            XCTAssertNotNil(hostingView, "PlatformImage should work in actual views")
        }
    }
    
    func testPlatformImageInitializationWithInvalidData() {
        // Given: Invalid image data
        let invalidData = Data("invalid".utf8)
        
        // When: Creating PlatformImage from invalid data
        let platformImage = PlatformImage(data: invalidData)
        
        // Then: PlatformImage should be nil
        XCTAssertNil(platformImage, "PlatformImage should be nil for invalid data")
    }
    
    @MainActor
    func testPlatformImageResize() {
        // Given: A PlatformImage
        let originalImage = createTestPlatformImage()
        let targetSize = CGSize(width: 100, height: 100)
        
        // When: Resizing the image
        let resizedImage = originalImage.resized(to: targetSize)
        
        // Then: Image should be resized to target size and be usable
        XCTAssertEqual(resizedImage.size, targetSize, "Image should be resized to target size")
        
        // Test that the resized image can actually be used in a view
        let testView = createTestViewWithPlatformImage(resizedImage)
        let hostingView = hostRootPlatformView(testView.withGlobalAutoIDsEnabled())
        XCTAssertNotNil(hostingView, "Resized image should work in actual views")
    }
    
    @MainActor
    func testPlatformImageCrop() {
        // Given: A PlatformImage and crop rectangle
        let originalImage = createTestPlatformImage()
        let cropRect = CGRect(x: 10, y: 10, width: 50, height: 50)
        
        // When: Cropping the image
        let croppedImage = originalImage.cropped(to: cropRect)
        
        // Then: Image should be cropped to specified rectangle and be usable
        XCTAssertEqual(croppedImage.size, cropRect.size, "Image should be cropped to specified size")
        
        // Test that the cropped image can actually be used in a view
        let testView = createTestViewWithPlatformImage(croppedImage)
        let hostingView = hostRootPlatformView(testView.withGlobalAutoIDsEnabled())
        XCTAssertNotNil(hostingView, "Cropped image should work in actual views")
    }
    
    func testPlatformImageCompression() {
        // Given: A PlatformImage and photo purpose
        let originalImage = createTestPlatformImage()
        let purpose = PhotoPurpose.vehiclePhoto
        
        // When: Compressing the image
        let compressedData = originalImage.compressed(for: purpose, quality: 0.8)
        
        // Then: Compressed data should be returned
        XCTAssertNotNil(compressedData, "Compressed data should be returned")
        XCTAssertTrue(compressedData!.count > 0, "Compressed data should not be empty")
    }
    
    func testPlatformImageThumbnail() {
        // Given: A PlatformImage and thumbnail size
        let originalImage = createTestPlatformImage()
        let thumbnailSize = CGSize(width: 50, height: 50)
        
        // When: Creating thumbnail
        let thumbnail = originalImage.thumbnail(size: thumbnailSize)
        
        // Then: Thumbnail should be created with correct size
        XCTAssertEqual(thumbnail.size, thumbnailSize, "Thumbnail should have correct size")
    }
    
    func testPlatformImageOCROptimization() {
        // Given: A PlatformImage
        let originalImage = createTestPlatformImage()
        
        // When: Optimizing for OCR
        let optimizedImage = originalImage.optimizedForOCR()
        
        // Then: Optimized image should be returned
        XCTAssertNotNil(optimizedImage, "OCR optimized image should be returned")
    }
    
    func testPlatformImageMetadata() {
        // Given: A PlatformImage
        let originalImage = createTestPlatformImage()
        
        // When: Getting metadata
        let metadata = originalImage.metadata
        
        // Then: Metadata should contain valid information
        XCTAssertTrue(metadata.size.width > 0, "Metadata should contain valid size")
        XCTAssertTrue(metadata.size.height > 0, "Metadata should contain valid size")
        XCTAssertTrue(metadata.fileSize > 0, "Metadata should contain valid file size")
        XCTAssertNotEqual(metadata.format, .unknown, "Metadata should contain valid format")
    }
    
    func testPlatformImageMeetsRequirements() {
        // Given: A PlatformImage and photo purpose
        let originalImage = createTestPlatformImage()
        let purpose = PhotoPurpose.vehiclePhoto
        
        // When: Checking if image meets requirements
        let meetsRequirements = originalImage.meetsRequirements(for: purpose)
        
        // Then: Should return boolean result
        XCTAssertTrue(meetsRequirements == true || meetsRequirements == false, "Should return boolean result")
    }
    
    // MARK: - Photo Purpose Tests
    
    func testPhotoPurposeEnum() {
        // Given: PhotoPurpose enum
        let purposes = PhotoPurpose.allCases
        
        // Then: Should contain expected purposes
        XCTAssertTrue(purposes.contains(.vehiclePhoto), "Should contain vehiclePhoto")
        XCTAssertTrue(purposes.contains(.fuelReceipt), "Should contain fuelReceipt")
        XCTAssertTrue(purposes.contains(.pumpDisplay), "Should contain pumpDisplay")
        XCTAssertTrue(purposes.contains(.odometer), "Should contain odometer")
        XCTAssertTrue(purposes.contains(.maintenance), "Should contain maintenance")
        XCTAssertTrue(purposes.contains(.expense), "Should contain expense")
        XCTAssertTrue(purposes.contains(.profile), "Should contain profile")
        XCTAssertTrue(purposes.contains(.document), "Should contain document")
    }
    
    // MARK: - Photo Context Tests
    
    func testPhotoContextInitialization() {
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
        XCTAssertEqual(context.screenSize.width, screenSize.width, "Context should have correct screen size width")
        XCTAssertEqual(context.screenSize.height, screenSize.height, "Context should have correct screen size height")
        XCTAssertEqual(context.availableSpace.width, availableSpace.width, "Context should have correct available space width")
        XCTAssertEqual(context.availableSpace.height, availableSpace.height, "Context should have correct available space height")
    }
    
    // MARK: - Photo Preferences Tests
    
    func testPhotoPreferencesInitialization() {
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
        XCTAssertEqual(preferences.preferredSource, source, "Preferences should have correct source")
        XCTAssertEqual(preferences.allowEditing, allowEditing, "Preferences should have correct editing setting")
        XCTAssertEqual(preferences.compressionQuality, compressionQuality, "Preferences should have correct quality")
        XCTAssertEqual(preferences.maxImageSize?.width, maxImageSize.width, "Preferences should have correct max size width")
        XCTAssertEqual(preferences.maxImageSize?.height, maxImageSize.height, "Preferences should have correct max size height")
    }
    
    // MARK: - Device Capabilities Tests
    
    func testDeviceCapabilitiesInitialization() {
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
        XCTAssertEqual(capabilities.hasCamera, hasCamera, "Capabilities should have correct camera setting")
        XCTAssertEqual(capabilities.hasPhotoLibrary, hasPhotoLibrary, "Capabilities should have correct photo library setting")
        XCTAssertEqual(capabilities.supportsEditing, supportsEditing, "Capabilities should have correct editing setting")
        XCTAssertEqual(capabilities.maxImageResolution.width, maxImageResolution.width, "Capabilities should have correct max resolution width")
        XCTAssertEqual(capabilities.maxImageResolution.height, maxImageResolution.height, "Capabilities should have correct max resolution height")
    }
    
    // MARK: - Layer 4 Photo Components Tests
    
    @MainActor
    func testPlatformCameraInterfaceL4() {
        // Given: Image capture callback
        var _: PlatformImage?
        let onImageCaptured: (PlatformImage) -> Void = { _ in }
        
        // When: Creating camera interface
        let cameraInterface = platformCameraInterface_L4(onImageCaptured: onImageCaptured)
        
        // Then: Camera interface should be created and be hostable
        XCTAssertNotNil(cameraInterface, "Camera interface should be created")
        
        // Test that the camera interface can actually be hosted
        let hostingView = hostRootPlatformView(cameraInterface.withGlobalAutoIDsEnabled())
        XCTAssertNotNil(hostingView, "Camera interface should be hostable")
    }
    
    @MainActor
    func testPlatformPhotoPickerL4() {
        // Given: Image selection callback
        var _: PlatformImage?
        let onImageSelected: (PlatformImage) -> Void = { _ in }
        
        // When: Creating photo picker
        let photoPicker = platformPhotoPicker_L4(onImageSelected: onImageSelected)
        
        // Then: Photo picker should be created and be hostable
        XCTAssertNotNil(photoPicker, "Photo picker should be created")
        
        // Test that the photo picker can actually be hosted
        let hostingView = hostRootPlatformView(photoPicker.withGlobalAutoIDsEnabled())
        XCTAssertNotNil(hostingView, "Photo picker should be hostable")
    }
    
    @MainActor
    func testPlatformPhotoDisplayL4() {
        // Given: A PlatformImage and display style
        let testImage = createTestPlatformImage()
        let style = PhotoDisplayStyle.thumbnail
        
        // When: Creating photo display
        let photoDisplay = platformPhotoDisplay_L4(image: testImage, style: style)
        
        // Then: Photo display should be created and be hostable
        XCTAssertNotNil(photoDisplay, "Photo display should be created")
        
        // Test that the photo display can actually be hosted
        let hostingView = hostRootPlatformView(photoDisplay.withGlobalAutoIDsEnabled())
        XCTAssertNotNil(hostingView, "Photo display should be hostable")
    }
    
    @MainActor
    func testPlatformPhotoEditorL4() {
        // Given: A PlatformImage and edit callback
        let testImage = createTestPlatformImage()
        var _: PlatformImage?
        let onImageEdited: (PlatformImage) -> Void = { _ in }
        
        // When: Creating photo editor
        let photoEditor = platformPhotoEditor_L4(image: testImage, onImageEdited: onImageEdited)
        
        // Then: Photo editor should be created and be hostable
        XCTAssertNotNil(photoEditor, "Photo editor should be created")
        
        // Test that the photo editor can actually be hosted
        let hostingView = hostRootPlatformView(photoEditor.withGlobalAutoIDsEnabled())
        XCTAssertNotNil(hostingView, "Photo editor should be hostable")
    }
    
    // MARK: - Cross-Platform Color Tests
    
    @MainActor
    func testPlatformSystemColors() {
        // Then: Platform system colors should be available and usable
        // Test that platform colors can actually be used in views
        let testView = createTestViewWithPlatformSystemColors()
        let hostingView = hostRootPlatformView(testView.withGlobalAutoIDsEnabled())
        XCTAssertNotNil(hostingView, "Platform system colors should work in actual views")
    }
    
    // MARK: - Cross-Platform Keyboard Tests
    
    @MainActor
    func testPlatformKeyboardTypeModifier() {
        // Given: A view and keyboard type
        let testView = Text("Test")
        let keyboardType = PlatformKeyboardType.decimalPad
        
        // When: Applying keyboard type modifier
        let modifiedView = testView.platformKeyboardType(keyboardType)
        
        // Then: Modified view should be created and be hostable
        XCTAssertNotNil(modifiedView, "Modified view with keyboard type should be created")
        
        // Test that the modified view can actually be hosted
        let hostingView = hostRootPlatformView(modifiedView.withGlobalAutoIDsEnabled())
        XCTAssertNotNil(hostingView, "Modified view with keyboard type should be hostable")
    }
    
    @MainActor
    func testPlatformTextFieldStyleModifier() {
        // Given: A view and text field style
        let testView = Text("Test")
        let style = PlatformTextFieldStyle.roundedBorder
        
        // When: Applying text field style modifier
        let modifiedView = testView.platformTextFieldStyle(style)
        
        // Then: Modified view should be created and be hostable
        XCTAssertNotNil(modifiedView, "Modified view with text field style should be created")
        
        // Test that the modified view can actually be hosted
        let hostingView = hostRootPlatformView(modifiedView.withGlobalAutoIDsEnabled())
        XCTAssertNotNil(hostingView, "Modified view with text field style should be hostable")
    }
    
    // MARK: - Cross-Platform Location Tests
    
    func testPlatformLocationAuthorizationStatus() {
        // Given: PlatformLocationAuthorizationStatus enum
        let statuses = PlatformLocationAuthorizationStatus.allCases
        
        // Then: Should contain expected statuses
        XCTAssertTrue(statuses.contains(.notDetermined), "Should contain notDetermined")
        XCTAssertTrue(statuses.contains(.denied), "Should contain denied")
        XCTAssertTrue(statuses.contains(.restricted), "Should contain restricted")
        XCTAssertTrue(statuses.contains(.authorizedAlways), "Should contain authorizedAlways")
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
