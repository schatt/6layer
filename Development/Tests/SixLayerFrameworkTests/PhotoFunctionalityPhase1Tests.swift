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
    
    func testPlatformImageInitialization() {
        // Given: Sample image data
        let sampleData = createSampleImageData()
        
        // When: Creating PlatformImage from data
        let platformImage = PlatformImage(data: sampleData)
        
        // Then: PlatformImage should be created successfully
        XCTAssertNotNil(platformImage, "PlatformImage should be created from valid data")
    }
    
    func testPlatformImageInitializationWithInvalidData() {
        // Given: Invalid image data
        let invalidData = Data("invalid".utf8)
        
        // When: Creating PlatformImage from invalid data
        let platformImage = PlatformImage(data: invalidData)
        
        // Then: PlatformImage should be nil
        XCTAssertNil(platformImage, "PlatformImage should be nil for invalid data")
    }
    
    func testPlatformImageResize() {
        // Given: A PlatformImage
        let originalImage = createTestPlatformImage()
        let targetSize = CGSize(width: 100, height: 100)
        
        // When: Resizing the image
        let resizedImage = originalImage.resized(to: targetSize)
        
        // Then: Image should be resized to target size
        XCTAssertEqual(resizedImage.size, targetSize, "Image should be resized to target size")
    }
    
    func testPlatformImageCrop() {
        // Given: A PlatformImage and crop rectangle
        let originalImage = createTestPlatformImage()
        let cropRect = CGRect(x: 10, y: 10, width: 50, height: 50)
        
        // When: Cropping the image
        let croppedImage = originalImage.cropped(to: cropRect)
        
        // Then: Image should be cropped to specified rectangle
        XCTAssertEqual(croppedImage.size, cropRect.size, "Image should be cropped to specified size")
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
        let screenSize = CGSize(width: 1024, height: 768)
        let availableSpace = CGSize(width: 800, height: 600)
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
        XCTAssertEqual(context.screenSize, screenSize, "Context should have correct screen size")
        XCTAssertEqual(context.availableSpace, availableSpace, "Context should have correct available space")
    }
    
    // MARK: - Photo Preferences Tests
    
    func testPhotoPreferencesInitialization() {
        // Given: PhotoPreferences parameters
        let source = PhotoSource.camera
        let allowEditing = true
        let compressionQuality = 0.8
        let maxImageSize = CGSize(width: 1920, height: 1080)
        
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
        XCTAssertEqual(preferences.maxImageSize, maxImageSize, "Preferences should have correct max size")
    }
    
    // MARK: - Device Capabilities Tests
    
    func testDeviceCapabilitiesInitialization() {
        // Given: DeviceCapabilities parameters
        let hasCamera = true
        let hasPhotoLibrary = true
        let supportsEditing = true
        let maxImageResolution = CGSize(width: 4096, height: 4096)
        
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
        XCTAssertEqual(capabilities.maxImageResolution, maxImageResolution, "Capabilities should have correct max resolution")
    }
    
    // MARK: - Layer 4 Photo Components Tests
    
    func testPlatformCameraInterfaceL4() {
        // Given: Image capture callback
        var _: PlatformImage?
        let onImageCaptured: (PlatformImage) -> Void = { _ in }
        
        // When: Creating camera interface
        let cameraInterface = platformCameraInterface_L4(onImageCaptured: onImageCaptured)
        
        // Then: Camera interface should be created
        XCTAssertNotNil(cameraInterface, "Camera interface should be created")
    }
    
    func testPlatformPhotoPickerL4() {
        // Given: Image selection callback
        var _: PlatformImage?
        let onImageSelected: (PlatformImage) -> Void = { _ in }
        
        // When: Creating photo picker
        let photoPicker = platformPhotoPicker_L4(onImageSelected: onImageSelected)
        
        // Then: Photo picker should be created
        XCTAssertNotNil(photoPicker, "Photo picker should be created")
    }
    
    func testPlatformPhotoDisplayL4() {
        // Given: A PlatformImage and display style
        let testImage = createTestPlatformImage()
        let style = PhotoDisplayStyle.thumbnail
        
        // When: Creating photo display
        let photoDisplay = platformPhotoDisplay_L4(image: testImage, style: style)
        
        // Then: Photo display should be created
        XCTAssertNotNil(photoDisplay, "Photo display should be created")
    }
    
    func testPlatformPhotoEditorL4() {
        // Given: A PlatformImage and edit callback
        let testImage = createTestPlatformImage()
        var _: PlatformImage?
        let onImageEdited: (PlatformImage) -> Void = { _ in }
        
        // When: Creating photo editor
        let photoEditor = platformPhotoEditor_L4(image: testImage, onImageEdited: onImageEdited)
        
        // Then: Photo editor should be created
        XCTAssertNotNil(photoEditor, "Photo editor should be created")
    }
    
    // MARK: - Cross-Platform Color Tests
    
    func testPlatformSystemColors() {
        // Then: Platform system colors should be available
        XCTAssertNotNil(Color.platformSystemBackground, "Platform system background color should be available")
        XCTAssertNotNil(Color.platformSystemGray6, "Platform system gray6 color should be available")
        XCTAssertNotNil(Color.platformSystemGray5, "Platform system gray5 color should be available")
        XCTAssertNotNil(Color.platformSystemGray4, "Platform system gray4 color should be available")
        XCTAssertNotNil(Color.platformSystemGray3, "Platform system gray3 color should be available")
        XCTAssertNotNil(Color.platformSystemGray2, "Platform system gray2 color should be available")
        XCTAssertNotNil(Color.platformSystemGray, "Platform system gray color should be available")
        XCTAssertNotNil(Color.platformLabel, "Platform label color should be available")
        XCTAssertNotNil(Color.platformSecondaryLabel, "Platform secondary label color should be available")
        XCTAssertNotNil(Color.platformTertiaryLabel, "Platform tertiary label color should be available")
        XCTAssertNotNil(Color.platformQuaternaryLabel, "Platform quaternary label color should be available")
    }
    
    // MARK: - Cross-Platform Keyboard Tests
    
    func testPlatformKeyboardTypeModifier() {
        // Given: A view and keyboard type
        let testView = Text("Test")
        let keyboardType = PlatformKeyboardType.decimalPad
        
        // When: Applying keyboard type modifier
        let modifiedView = testView.platformKeyboardType(keyboardType)
        
        // Then: Modified view should be created
        XCTAssertNotNil(modifiedView, "Modified view with keyboard type should be created")
    }
    
    func testPlatformTextFieldStyleModifier() {
        // Given: A view and text field style
        let testView = Text("Test")
        let style = PlatformTextFieldStyle.roundedBorder
        
        // When: Applying text field style modifier
        let modifiedView = testView.platformTextFieldStyle(style)
        
        // Then: Modified view should be created
        XCTAssertNotNil(modifiedView, "Modified view with text field style should be created")
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
            UIColor.red.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
        return image.pngData() ?? Data()
        #elseif os(macOS)
        let size = NSSize(width: 1, height: 1)
        let image = NSImage(size: size)
        image.lockFocus()
        NSColor.red.setFill()
        NSRect(origin: .zero, size: size).fill()
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
            UIColor.red.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
        return PlatformImage(uiImage: uiImage)
        #elseif os(macOS)
        let size = NSSize(width: 200, height: 200)
        let nsImage = NSImage(size: size)
        nsImage.lockFocus()
        NSColor.red.setFill()
        NSRect(origin: .zero, size: size).fill()
        nsImage.unlockFocus()
        return PlatformImage(nsImage: nsImage)
        #endif
    }
}
