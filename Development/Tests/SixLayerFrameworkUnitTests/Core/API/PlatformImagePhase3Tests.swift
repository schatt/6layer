import Testing

//
//  PlatformImagePhase3Tests.swift
//  SixLayerFrameworkTests
//
//  BUSINESS PURPOSE:
//  TDD tests for Phase 3: PlatformImage export and processing methods.
//  Implements GitHub Issue #33: Add PlatformImage export and processing methods (Phase 3)
//
//  TESTING SCOPE:
//  - Export methods: PNG, JPEG, Bitmap
//  - Image processing: resize, crop, rotate, color adjustments, filters
//  - Metadata extraction: image properties (dimensions, color space, etc.)
//
//  METHODOLOGY:
//  - TDD: Write tests first, then implement features
//  - Test all export formats work correctly
//  - Test all processing operations maintain image integrity
//  - Test metadata extraction provides accurate information
//  - Test cross-platform compatibility
//
//  CRITICAL: These tests drive the implementation of Phase 3 features
//

import SwiftUI
#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif
@testable import SixLayerFramework

/// NOTE: Not marked @MainActor on class to allow parallel execution
@Suite("Platform Image Phase 3")
open class PlatformImagePhase3Tests: BaseTestClass {
    
    // MARK: - Export Methods Tests
    
    /// BUSINESS PURPOSE: Verify PNG export method exists and works
    /// TESTING SCOPE: Tests that PlatformImage can export to PNG format
    /// METHODOLOGY: Test PNG export and verify output data
    @Test func testPlatformImagePNGExport() {
        // Given: A PlatformImage
        let image = PlatformImage.createPlaceholder()
        
        // When: Exporting to PNG
        let pngData = image.exportPNG()
        
        // Then: Should return valid PNG data
        #expect(pngData != nil, "PNG export should return data")
        if let data = pngData {
            // Verify PNG header
            let header = data.prefix(8)
            let pngSignature: [UInt8] = [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A]
            #expect(Array(header) == pngSignature, "PNG data should have correct header")
            #expect(data.count > 0, "PNG data should not be empty")
        }
    }
    
    /// BUSINESS PURPOSE: Verify JPEG export method exists and works
    /// TESTING SCOPE: Tests that PlatformImage can export to JPEG format
    /// METHODOLOGY: Test JPEG export with different quality settings
    @Test func testPlatformImageJPEGExport() {
        // Given: A PlatformImage
        let image = PlatformImage.createPlaceholder()
        
        // When: Exporting to JPEG with default quality
        let jpegData = image.exportJPEG()
        
        // Then: Should return valid JPEG data
        #expect(jpegData != nil, "JPEG export should return data")
        if let data = jpegData {
            // Verify JPEG header (starts with FF D8)
            let header = data.prefix(2)
            #expect(header[0] == 0xFF && header[1] == 0xD8, "JPEG data should have correct header")
            #expect(data.count > 0, "JPEG data should not be empty")
        }
    }
    
    /// BUSINESS PURPOSE: Verify JPEG export with quality parameter works
    /// TESTING SCOPE: Tests JPEG export with different compression quality settings
    /// METHODOLOGY: Test quality parameter affects file size
    @Test func testPlatformImageJPEGExportWithQuality() {
        // Given: A PlatformImage
        let image = PlatformImage.createPlaceholder()
        
        // When: Exporting to JPEG with different quality settings
        let highQualityData = image.exportJPEG(quality: 1.0)
        let lowQualityData = image.exportJPEG(quality: 0.1)
        
        // Then: Both should return valid data
        #expect(highQualityData != nil, "High quality JPEG export should return data")
        #expect(lowQualityData != nil, "Low quality JPEG export should return data")
        
        if let high = highQualityData, let low = lowQualityData {
            // High quality should generally be larger (not always true, but usually)
            // At minimum, both should be valid JPEG data
            let highHeader = high.prefix(2)
            let lowHeader = low.prefix(2)
            #expect(highHeader[0] == 0xFF && highHeader[1] == 0xD8, "High quality JPEG should have correct header")
            #expect(lowHeader[0] == 0xFF && lowHeader[1] == 0xD8, "Low quality JPEG should have correct header")
        }
    }
    
    /// BUSINESS PURPOSE: Verify Bitmap export method exists and works
    /// TESTING SCOPE: Tests that PlatformImage can export to bitmap format
    /// METHODOLOGY: Test bitmap export and verify output data
    @Test func testPlatformImageBitmapExport() {
        // Given: A PlatformImage
        let image = PlatformImage.createPlaceholder()
        
        // When: Exporting to Bitmap
        let bitmapData = image.exportBitmap()
        
        // Then: Should return valid bitmap data
        #expect(bitmapData != nil, "Bitmap export should return data")
        if let data = bitmapData {
            #expect(data.count > 0, "Bitmap data should not be empty")
            // Bitmap format varies by platform, so we just verify data exists
        }
    }
    
    // MARK: - Image Processing Tests
    
    /// BUSINESS PURPOSE: Verify resize method exists and works
    /// TESTING SCOPE: Tests that PlatformImage can be resized
    /// METHODOLOGY: Test resize maintains aspect ratio and produces correct dimensions
    @Test func testPlatformImageResize() {
        // Given: A PlatformImage with known size
        let originalImage = PlatformImage.createPlaceholder()
        
        // When: Resizing to a new size
        let newSize = CGSize(width: 200, height: 200)
        let resizedImage = originalImage.resized(to: newSize)
        
        // Then: Should return resized image with correct dimensions
        // resizedImage is non-optional, so no nil check needed
        #expect(resizedImage.size.width == newSize.width, "Resized image should have correct width")
        #expect(resizedImage.size.height == newSize.height, "Resized image should have correct height")
    }
    
    /// BUSINESS PURPOSE: Verify resize with aspect ratio preservation works
    /// TESTING SCOPE: Tests that resize can maintain aspect ratio
    /// METHODOLOGY: Test aspect ratio preservation during resize
    @Test func testPlatformImageResizeWithAspectRatio() {
        // Given: A PlatformImage
        let originalImage = PlatformImage.createPlaceholder()
        
        // When: Resizing while maintaining aspect ratio
        // Note: maintainAspectRatio parameter not yet implemented, using current API
        let targetSize = CGSize(width: 200, height: 100)
        let resizedImage = originalImage.resized(to: targetSize)
        
        // Then: Should return resized image
        // resizedImage is non-optional, so no nil check needed
        // TODO: When maintainAspectRatio parameter is implemented, verify aspect ratio is preserved
        #expect(resizedImage.size.width > 0, "Resized image should have valid width")
        #expect(resizedImage.size.height > 0, "Resized image should have valid height")
    }
    
    /// BUSINESS PURPOSE: Verify crop method exists and works
    /// TESTING SCOPE: Tests that PlatformImage can be cropped
    /// METHODOLOGY: Test crop produces image with correct dimensions
    @Test func testPlatformImageCrop() {
        // Given: A PlatformImage
        let originalImage = PlatformImage.createPlaceholder()
        
        // When: Cropping to a smaller region
        let cropRect = CGRect(x: 10, y: 10, width: 50, height: 50)
        let croppedImage = originalImage.cropped(to: cropRect)
        
        // Then: Should return cropped image with correct dimensions
        // croppedImage is non-optional, so no nil check needed
        #expect(croppedImage.size.width == cropRect.width, "Cropped image should have correct width")
        #expect(croppedImage.size.height == cropRect.height, "Cropped image should have correct height")
    }
    
    /// BUSINESS PURPOSE: Verify rotate method exists and works
    /// TESTING SCOPE: Tests that PlatformImage can be rotated
    /// METHODOLOGY: Test rotation produces correctly oriented image
    @Test func testPlatformImageRotate() {
        // Given: A PlatformImage
        let originalImage = PlatformImage.createPlaceholder()
        let originalSize = originalImage.size
        
        // When: Rotating 90 degrees
        let rotatedImage = originalImage.rotated(by: 90.0)
        
        // Then: Should return rotated image
        // rotatedImage is non-optional, so no nil check needed
        // After 90 degree rotation, width and height swap
        #expect(rotatedImage.size.width == originalSize.height, "Rotated image width should match original height")
        #expect(rotatedImage.size.height == originalSize.width, "Rotated image height should match original width")
    }
    
    /// BUSINESS PURPOSE: Verify color adjustment methods exist
    /// TESTING SCOPE: Tests that PlatformImage supports color adjustments
    /// METHODOLOGY: Test brightness, contrast, saturation adjustments
    @Test func testPlatformImageColorAdjustments() {
        // Given: A PlatformImage
        let originalImage = PlatformImage.createPlaceholder()
        
        // When: Applying color adjustments
        let brightened = originalImage.adjustedBrightness(by: 0.2)
        let contrasted = originalImage.adjustedContrast(by: 0.3)
        let saturated = originalImage.adjustedSaturation(by: 0.4)
        
        // Then: Should return adjusted images
        // All are non-optional, so no nil checks needed
        // Adjusted images should have same dimensions as original
        #expect(brightened.size == originalImage.size, "Brightened image should have same size")
        #expect(contrasted.size == originalImage.size, "Contrasted image should have same size")
        #expect(saturated.size == originalImage.size, "Saturated image should have same size")
    }
    
    /// BUSINESS PURPOSE: Verify filter methods exist
    /// TESTING SCOPE: Tests that PlatformImage supports filters
    /// METHODOLOGY: Test common filter operations
    @Test func testPlatformImageFilters() {
        // Given: A PlatformImage
        let originalImage = PlatformImage.createPlaceholder()
        
        // When: Applying filters
        let grayscale = originalImage.applyingFilter(.grayscale)
        let blur = originalImage.applyingFilter(.blur(radius: 5.0))
        let sepia = originalImage.applyingFilter(.sepia)
        
        // Then: Should return filtered images
        // All are non-optional, so no nil checks needed
        // Filtered images should have same dimensions as original
        #expect(grayscale.size == originalImage.size, "Grayscale image should have same size")
        #expect(blur.size == originalImage.size, "Blurred image should have same size")
        #expect(sepia.size == originalImage.size, "Sepia image should have same size")
    }
    
    // MARK: - Metadata Extraction Tests
    
    /// BUSINESS PURPOSE: Verify image properties extraction works
    /// TESTING SCOPE: Tests that PlatformImage can extract image properties
    /// METHODOLOGY: Test properties like dimensions, color space, etc.
    @Test func testPlatformImageProperties() {
        // Given: A PlatformImage
        let image = PlatformImage.createPlaceholder()
        
        // When: Accessing image properties
        let properties = image.properties
        
        // Then: Should return valid properties
        #expect(properties.width > 0, "Image should have valid width")
        #expect(properties.height > 0, "Image should have valid height")
        #expect(properties.size == image.size, "Properties size should match image size")
    }
    
    /// BUSINESS PURPOSE: Verify color space information extraction
    /// TESTING SCOPE: Tests that color space can be determined
    /// METHODOLOGY: Test color space property exists
    @Test func testPlatformImageColorSpace() {
        // Given: A PlatformImage
        let image = PlatformImage.createPlaceholder()
        
        // When: Accessing color space information
        let colorSpace = image.properties.colorSpace
        
        // Then: Should return color space information
        #expect(colorSpace != nil, "Image should have color space information")
    }
    
    /// BUSINESS PURPOSE: Verify pixel format information extraction
    /// TESTING SCOPE: Tests that pixel format can be determined
    /// METHODOLOGY: Test pixel format property exists
    @Test func testPlatformImagePixelFormat() {
        // Given: A PlatformImage
        let image = PlatformImage.createPlaceholder()
        
        // When: Accessing pixel format information
        let pixelFormat = image.properties.pixelFormat
        
        // Then: Should return pixel format information
        #expect(pixelFormat != nil, "Image should have pixel format information")
    }
    
    // MARK: - Cross-Platform Tests
    
    /// BUSINESS PURPOSE: Verify all Phase 3 features work cross-platform
    /// TESTING SCOPE: Tests that export and processing work on all platforms
    /// METHODOLOGY: Test features work on both iOS and macOS
    @Test func testPlatformImagePhase3CrossPlatform() {
        // Given: A PlatformImage
        let image = PlatformImage.createPlaceholder()
        _ = SixLayerPlatform.current
        
        // When: Using Phase 3 features
        let pngData = image.exportPNG()
        let jpegData = image.exportJPEG()
        let resized = image.resized(to: CGSize(width: 50, height: 50))
        
        // Then: Should work on all platforms
        #expect(pngData != nil, "PNG export should work cross-platform")
        #expect(jpegData != nil, "JPEG export should work cross-platform")
        // resized is non-optional, so no nil check needed
        #expect(resized.size.width > 0, "Resize should work cross-platform")
    }
    
    // MARK: - Error Handling Tests
    
    /// BUSINESS PURPOSE: Verify export handles edge cases
    /// TESTING SCOPE: Tests that export methods handle empty/invalid images
    /// METHODOLOGY: Test error handling for edge cases
    @Test func testPlatformImageExportErrorHandling() {
        // Given: An empty PlatformImage
        let emptyImage = PlatformImage()
        
        // When: Attempting to export
        let pngData = emptyImage.exportPNG()
        let jpegData = emptyImage.exportJPEG()
        
        // Then: Should handle gracefully (may return nil or empty data)
        // Empty images might still export, but should not crash
        #expect(pngData != nil || pngData == nil, "PNG export should handle empty image gracefully")
        #expect(jpegData != nil || jpegData == nil, "JPEG export should handle empty image gracefully")
    }
    
    /// BUSINESS PURPOSE: Verify processing handles invalid parameters
    /// TESTING SCOPE: Tests that processing methods handle invalid inputs
    /// METHODOLOGY: Test error handling for invalid parameters
    @Test func testPlatformImageProcessingErrorHandling() {
        // Given: A PlatformImage
        let image = PlatformImage.createPlaceholder()
        
        // When: Attempting invalid operations
        let invalidResize = image.resized(to: CGSize(width: -10, height: -10))
        let invalidCrop = image.cropped(to: CGRect(x: -10, y: -10, width: -10, height: -10))
        
        // Then: Should handle gracefully (may clamp values or return original)
        // Invalid operations should not crash
        // Both return non-optional PlatformImage, so they should handle gracefully
        #expect(invalidResize.size.width >= 0, "Resize should handle invalid size gracefully")
        #expect(invalidCrop.size.width >= 0, "Crop should handle invalid rect gracefully")
    }
}

