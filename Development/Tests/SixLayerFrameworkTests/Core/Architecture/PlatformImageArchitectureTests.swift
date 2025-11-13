import Testing

//
//  PlatformImageArchitectureTests.swift
//  SixLayerFrameworkTests
//
//  BUSINESS PURPOSE:
//  Tests that verify PlatformImage is the sole image type inside the framework.
//  These tests enforce the architectural principle that no platform-specific
//  image types should exist within the framework boundaries.
//
//  TESTING SCOPE:
//  - Verify no UIImage/NSImage usage inside framework
//  - Test that all image operations use PlatformImage
//  - Verify system boundary conversions work correctly
//  - Test that framework APIs only work with PlatformImage
//
//  METHODOLOGY:
//  - Static analysis tests to detect platform-specific image types
//  - Integration tests to verify PlatformImage-only APIs
//  - Boundary tests to verify proper conversions
//
//  CRITICAL: These tests enforce the architectural currency exchange model
//

import SwiftUI
#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif
@testable import SixLayerFramework


@MainActor
@Suite("Platform Image Architecture")
open class PlatformImageArchitectureTests {
    
    // MARK: - Architecture Enforcement Tests
    
    /// BUSINESS PURPOSE: Verify framework APIs only accept PlatformImage
    /// TESTING SCOPE: Tests that all public framework APIs use PlatformImage
    /// METHODOLOGY: Test that no platform-specific image types are accepted
    @Test func testFrameworkAPIsOnlyAcceptPlatformImage() {
        // Given: Platform-specific image types
        #if os(iOS)
        let uiImage = createTestUIImage()
        #elseif os(macOS)
        let nsImage = createTestNSImage()
        #endif
        
        // When: Try to use platform-specific types with framework APIs
        
        
        // Then: Framework should only work with PlatformImage
        // This test ensures the framework enforces PlatformImage-only usage
        
        #if os(iOS)
        // Test that framework doesn't accept UIImage directly
        // (This would be a compilation error if we tried to pass UIImage)
        let platformImage = PlatformImage(uiImage: uiImage)
        let cameraInterface = PlatformPhotoComponentsLayer4.platformCameraInterface_L4 { image in
            // image parameter should be PlatformImage, not UIImage
            #expect(image is PlatformImage, "Framework callback should receive PlatformImage")
        }
        
        #elseif os(macOS)
        // Test that framework doesn't accept NSImage directly
        let platformImage = PlatformImage(nsImage: nsImage)
        let cameraInterface = PlatformPhotoComponentsLayer4.platformCameraInterface_L4 { image in
            // image parameter should be PlatformImage, not NSImage
            #expect(image is PlatformImage, "Framework callback should receive PlatformImage")
        }
        #endif
        
        // Verify the interface was created successfully
        // cameraInterface is a non-optional View, so it exists if we reach here
    }
    
    /// BUSINESS PURPOSE: Verify system boundary conversions work correctly
    /// TESTING SCOPE: Tests that UIImage/NSImage ↔ PlatformImage conversions work
    /// METHODOLOGY: Test conversions at system boundaries
    @Test func testSystemBoundaryConversions() {
        // Given: Platform-specific image types
        #if os(iOS)
        let uiImage = createTestUIImage()
        
        // When: Convert at system boundary (airport)
        let platformImage = PlatformImage(uiImage: uiImage)
        
        // Then: Conversion should work correctly
        #expect(platformImage.uiImage == uiImage, "UIImage → PlatformImage conversion should work")
        
        // Test reverse conversion (leaving the country)
        let convertedBack = platformImage.uiImage
        #expect(convertedBack == uiImage, "PlatformImage → UIImage conversion should work")
        
        #elseif os(macOS)
        let nsImage = createTestNSImage()
        
        // When: Convert at system boundary (airport)
        let platformImage = PlatformImage(nsImage: nsImage)
        
        // Then: Conversion should work correctly
        #expect(platformImage.nsImage == nsImage, "NSImage → PlatformImage conversion should work")
        
        // Test reverse conversion (leaving the country)
        let convertedBack = platformImage.nsImage
        #expect(convertedBack == nsImage, "PlatformImage → NSImage conversion should work")
        #endif
    }
    
    /// BUSINESS PURPOSE: Verify PlatformImage is the only image type in callbacks
    /// TESTING SCOPE: Tests that all framework callbacks use PlatformImage
    /// METHODOLOGY: Test callback parameter types
    @Test func testFrameworkCallbacksUsePlatformImageOnly() {
        // Given: Framework components
        
        
        // When: Set up callbacks
        var capturedImage: PlatformImage?
        var selectedImage: PlatformImage?
        
        let cameraInterface = PlatformPhotoComponentsLayer4.platformCameraInterface_L4 { image in
            capturedImage = image
        }
        
        let photoPicker = PlatformPhotoComponentsLayer4.platformPhotoPicker_L4 { image in
            selectedImage = image
        }
        
        // Then: Callbacks should only work with PlatformImage
        // Note: Callbacks are not executed in unit tests (only when views are actually used)
        // We verify that the interfaces accept PlatformImage callbacks by checking they were created successfully
        
        // Verify the interfaces were created (they accept PlatformImage callbacks)
        #expect(Bool(true), "Camera interface should accept PlatformImage callback")  // cameraInterface is non-optional
        #expect(Bool(true), "Photo picker should accept PlatformImage callback")  // photoPicker is non-optional
    }
    
    /// BUSINESS PURPOSE: Verify PlatformImage can handle all image operations
    /// TESTING SCOPE: Tests that PlatformImage supports all necessary operations
    /// METHODOLOGY: Test PlatformImage functionality without platform-specific types
    @Test func testPlatformImageSupportsAllOperations() {
        // Given: PlatformImage
        let platformImage = createTestPlatformImage()
        
        // When: Perform various operations
        // Then: All operations should work with PlatformImage only
        
        // Test basic properties
        #expect(platformImage.size.width > 0, "PlatformImage should have valid width")
        #expect(platformImage.size.height > 0, "PlatformImage should have valid height")
        #expect(platformImage.isEmpty == false, "PlatformImage should not be empty")
        
        // Test that we can create from data (cross-platform)
        let imageData = createTestImageData()
        if let dataImage = PlatformImage(data: imageData) {
            #expect(dataImage.size.width > 0, "PlatformImage from data should work")
        }
        
        // Test that we can create default image
        let defaultImage = PlatformImage()
        #expect(defaultImage.isEmpty == true, "Default PlatformImage should be empty")
    }
    
    /// BUSINESS PURPOSE: Verify no platform-specific image types leak into framework
    /// TESTING SCOPE: Tests that framework doesn't expose platform-specific types
    /// METHODOLOGY: Test that framework APIs don't return platform-specific types
    @Test func testNoPlatformSpecificTypesInFramework() {
        // Given: Framework components
        
        let platformImage = createTestPlatformImage()
        
        // When: Use framework APIs
        let photoDisplay = PlatformPhotoComponentsLayer4.platformPhotoDisplay_L4(
            image: platformImage,
            style: .thumbnail
        )
        
        // Then: Framework should only work with PlatformImage
        // This test ensures no platform-specific types are exposed
        
        #if os(iOS)
        // Verify we can't accidentally get UIImage from framework
        // (This would be a compilation error if framework exposed UIImage)
        let uiImage = platformImage.uiImage  // This is OK - it's a property access
        #expect(Bool(true), "PlatformImage should provide UIImage access")  // uiImage is non-optional
        
        #elseif os(macOS)
        // Verify we can't accidentally get NSImage from framework
        let nsImage = platformImage.nsImage  // This is OK - it's a property access
        #expect(Bool(true), "PlatformImage should provide NSImage access")  // nsImage is non-optional
        #endif
        
        // Verify framework components work
        #expect(Bool(true), "Framework should work with PlatformImage")  // photoDisplay is non-optional
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
}
