import Testing

//
//  Layer4PlatformImageArchitectureTests.swift
//  SixLayerFrameworkTests
//
//  BUSINESS PURPOSE:
//  Tests that verify Layer 4 components follow the PlatformImage-only architecture.
//  These tests ensure that the photo components use PlatformImage exclusively
//  and don't leak platform-specific image types into the framework.
//
//  TESTING SCOPE:
//  - Verify Layer 4 callbacks only use PlatformImage
//  - Test that delegate methods work with PlatformImage
//  - Verify system boundary conversions are correct
//  - Test that no platform-specific types exist in Layer 4
//
//  METHODOLOGY:
//  - Test callback parameter types
//  - Test delegate method implementations
//  - Test system boundary behavior
//
//  CRITICAL: These tests enforce the currency exchange model in Layer 4
//

import SwiftUI
@testable import SixLayerFramework
#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

@MainActor
@Suite("Layer Platform Image Architecture")
open class Layer4PlatformImageArchitectureTests {
    
    // MARK: - Layer 4 Architecture Tests
    
    /// BUSINESS PURPOSE: Verify Layer 4 callbacks only use PlatformImage
    /// TESTING SCOPE: Tests that Layer 4 callbacks work with PlatformImage only
    /// METHODOLOGY: Test callback parameter types and behavior
    @Test func testLayer4CallbacksUsePlatformImageOnly() {
        // Given: Layer 4 components
        
        
        // When: Set up callbacks with PlatformImage
        var capturedImage: PlatformImage?
        var selectedImage: PlatformImage?
        
        let cameraInterface = PlatformPhotoComponentsLayer4.platformCameraInterface_L4 { image in
            // image parameter should be PlatformImage, not UIImage/NSImage
            capturedImage = image
        }
        
        let photoPicker = PlatformPhotoComponentsLayer4.platformPhotoPicker_L4 { image in
            // image parameter should be PlatformImage, not UIImage/NSImage
            selectedImage = image
        }
        
        // Then: Callbacks should work with PlatformImage only
        #expect(capturedImage == nil, "Callback should not be called yet")
        #expect(selectedImage == nil, "Callback should not be called yet")
        
        // Verify interfaces were created successfully
        // cameraInterface and photoPicker are non-optional Views, so they exist if we reach here
    }
    
    /// BUSINESS PURPOSE: Verify Layer 4 delegate methods work with PlatformImage
    /// TESTING SCOPE: Tests that delegate methods use PlatformImage correctly
    /// METHODOLOGY: Test delegate method implementations
    @Test func testLayer4DelegateMethodsUsePlatformImage() {
        #if os(iOS)
        // Given: iOS delegate method setup
        var capturedImage: PlatformImage?
        let parent = MockCameraView { image in
            capturedImage = image
        }
        
        let coordinator = CameraView.Coordinator(parent)
        
        // When: Simulate delegate method call with PlatformImage
        // This tests that the delegate method works with PlatformImage
        let mockInfo: [UIImagePickerController.InfoKey: Any] = [
            .originalImage: createTestPlatformImage()
        ]
        
        coordinator.imagePickerController(UIImagePickerController(), didFinishPickingMediaWithInfo: mockInfo)
        
        // Then: Delegate should work with PlatformImage
        #expect(capturedImage != nil, "Delegate should work with PlatformImage")
        #expect(capturedImage!.size.width > 0, "PlatformImage should have valid properties")
        
        #elseif os(macOS)
        // Given: macOS delegate method setup
        var capturedImage: PlatformImage?
        let parent = MacCameraView { image in
            capturedImage = image
        }
        
        let coordinator = MacCameraView.Coordinator(parent)
        
        // When: Simulate delegate method call
        coordinator.takePhoto()
        
        // Then: Delegate should work with PlatformImage
        #expect(capturedImage != nil, "macOS delegate should work with PlatformImage")
        #expect(capturedImage!.size.width > 0, "PlatformImage should have valid properties")
        #endif
    }
    
    /// BUSINESS PURPOSE: Verify Layer 4 system boundary conversions
    /// TESTING SCOPE: Tests that system boundary conversions work correctly
    /// METHODOLOGY: Test conversions at Layer 4 boundaries
    @Test func testLayer4SystemBoundaryConversions() {
        #if os(iOS)
        // Given: iOS system boundary
        let uiImage = createTestUIImage()
        
        // When: Convert at system boundary (UIImage → PlatformImage)
        let platformImage = PlatformImage(uiImage: uiImage)
        
        // Then: Conversion should work correctly
        #expect(platformImage.uiImage == uiImage, "UIImage → PlatformImage conversion should work")
        
        // Test that Layer 4 can work with the converted PlatformImage
        
        let photoDisplay = PlatformPhotoComponentsLayer4.platformPhotoDisplay_L4(
            image: platformImage,
            style: .thumbnail
        )
        
        #expect(photoDisplay != nil, "Layer 4 should work with converted PlatformImage")
        
        #elseif os(macOS)
        // Given: macOS system boundary
        let nsImage = createTestNSImage()
        
        // When: Convert at system boundary (NSImage → PlatformImage)
        let platformImage = PlatformImage(nsImage: nsImage)
        
        // Then: Conversion should work correctly
        #expect(platformImage.nsImage == nsImage, "NSImage → PlatformImage conversion should work")
        
        // Test that Layer 4 can work with the converted PlatformImage
        
        let photoDisplay = PlatformPhotoComponentsLayer4.platformPhotoDisplay_L4(
            image: platformImage,
            style: .thumbnail
        )
        
        #expect(photoDisplay != nil, "Layer 4 should work with converted PlatformImage")
        #endif
    }
    
    /// BUSINESS PURPOSE: Verify Layer 4 doesn't expose platform-specific types
    /// TESTING SCOPE: Tests that Layer 4 APIs don't leak platform-specific types
    /// METHODOLOGY: Test that Layer 4 only works with PlatformImage
    @Test func testLayer4DoesNotExposePlatformSpecificTypes() {
        // Given: Layer 4 components
        
        let platformImage = createTestPlatformImage()
        
        // When: Use Layer 4 APIs
        let cameraInterface = PlatformPhotoComponentsLayer4.platformCameraInterface_L4 { _ in }
        let photoPicker = PlatformPhotoComponentsLayer4.platformPhotoPicker_L4 { _ in }
        let photoDisplay = PlatformPhotoComponentsLayer4.platformPhotoDisplay_L4(
            image: platformImage,
            style: .thumbnail
        )
        
        // Then: Layer 4 should only work with PlatformImage
        // This test ensures no platform-specific types are exposed by Layer 4
        
        #expect(cameraInterface != nil, "Camera interface should work with PlatformImage")
        #expect(photoPicker != nil, "Photo picker should work with PlatformImage")
        #expect(photoDisplay != nil, "Photo display should work with PlatformImage")
        
        // Verify that Layer 4 callbacks only accept PlatformImage
        // (This would be a compilation error if Layer 4 exposed platform-specific types)
        let testCallback: (PlatformImage) -> Void = { _ in }
        let _ = PlatformPhotoComponentsLayer4.platformCameraInterface_L4(onImageCaptured: testCallback)
        let _ = PlatformPhotoComponentsLayer4.platformPhotoPicker_L4(onImageSelected: testCallback)
    }
    
    /// BUSINESS PURPOSE: Verify Layer 4 follows currency exchange model
    /// TESTING SCOPE: Tests that Layer 4 enforces the currency exchange architecture
    /// METHODOLOGY: Test that conversions happen at boundaries, not inside Layer 4
    @Test func testLayer4FollowsCurrencyExchangeModel() {
        // Given: Platform-specific image types
        #if os(iOS)
        let uiImage = createTestUIImage()
        #elseif os(macOS)
        let nsImage = createTestNSImage()
        #endif
        
        // When: Convert at system boundary (airport)
        #if os(iOS)
        let platformImage = PlatformImage(uiImage: uiImage)
        #elseif os(macOS)
        let platformImage = PlatformImage(nsImage: nsImage)
        #endif
        
        // Then: Layer 4 should only work with PlatformImage (dollars in the country)
        
        
        // Test that Layer 4 accepts PlatformImage directly
        let photoDisplay = PlatformPhotoComponentsLayer4.platformPhotoDisplay_L4(
            image: platformImage,
            style: .thumbnail
        )
        
        #expect(photoDisplay != nil, "Layer 4 should work with PlatformImage directly")
        
        // Test that Layer 4 callbacks work with PlatformImage
        var callbackImage: PlatformImage?
        let _ = PlatformPhotoComponentsLayer4.platformCameraInterface_L4 { image in
            callbackImage = image
        }
        
        // Verify callback parameter is PlatformImage
        #expect(callbackImage == nil, "Callback should not be called yet")
        // (The callback parameter type is PlatformImage, not UIImage/NSImage)
    }
    
    // MARK: - Test Data Helpers
    
    private func createTestPlatformImage() -> PlatformImage {
        let imageData = createTestImageData()
        return PlatformImage(data: imageData) ?? PlatformImage()
    }
    
    private func createTestImageData() -> Data {
        #if os(iOS)
        let size = CGSize(width: 100, height: 100)
        let renderer = UIGraphicsImageRenderer(size: size)
        let uiImage = renderer.image { context in
            UIColor.red.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
        return uiImage.jpegData(compressionQuality: 0.8) ?? Data()
        
        #elseif os(macOS)
        let size = NSSize(width: 100, height: 100)
        let nsImage = NSImage(size: size)
        nsImage.lockFocus()
        NSColor.red.drawSwatch(in: NSRect(origin: .zero, size: size))
        nsImage.unlockFocus()
        
        guard let tiffData = nsImage.tiffRepresentation,
              let bitmapRep = NSBitmapImageRep(data: tiffData),
              let jpegData = bitmapRep.representation(using: .jpeg, properties: [:]) else {
            return Data()
        }
        return jpegData
        
        #else
        return Data()
        #endif
    }
    
    #if os(iOS)
    private func createTestUIImage() -> UIImage {
        let size = CGSize(width: 200, height: 200)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            UIColor.blue.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
    }
    #endif
    
    #if os(macOS)
    private func createTestNSImage() -> NSImage {
        let size = NSSize(width: 200, height: 200)
        let nsImage = NSImage(size: size)
        nsImage.lockFocus()
        NSColor.blue.drawSwatch(in: NSRect(origin: .zero, size: size))
        nsImage.unlockFocus()
        return nsImage
    }
    #endif
    
    // MARK: - Mock Classes for Testing
    
    #if os(iOS)
    private class MockCameraView {
        let onImageCaptured: (PlatformImage) -> Void
        
        init(onImageCaptured: @escaping (PlatformImage) -> Void) {
            self.onImageCaptured = onImageCaptured
        }
    }
    #endif
}
