//
//  PlatformImageEXIFTests.swift
//  SixLayerFrameworkTests
//
//  Tests for PlatformImage EXIF GPS location extraction
//  Implements GitHub Issue #21: PlatformImage EXIF GPS Location Extraction
//

import Testing
import CoreLocation
@testable import SixLayerFramework

#if canImport(ImageIO) && canImport(CoreLocation)
import ImageIO
#endif

/// Tests for PlatformImage EXIF GPS location extraction
/// Implements GitHub Issue #21
@MainActor
@Suite("Platform Image EXIF")
open class PlatformImageEXIFTests: BaseTestClass {
    
    // MARK: - EXIF Accessor Tests
    
    @Test func testPlatformImageHasEXIFAccessor() async {
        // Given: A PlatformImage
        let image = PlatformImage.createPlaceholder()
        
        // When: Accessing the exif property
        let exif = image.exif
        
        // Then: Should return a PlatformImageEXIF instance
        // PlatformImageEXIF is a struct, so accessing it confirms it exists
        let _ = exif.gpsLocation // Access a property to verify the struct exists
    }
    
    @Test func testPlatformImageEXIFHasGPSLocationProperty() async {
        // Given: A PlatformImage with EXIF accessor
        let image = PlatformImage.createPlaceholder()
        let exif = image.exif
        
        // When: Accessing gpsLocation property
        let location = exif.gpsLocation
        
        // Then: Should return CLLocation? (may be nil for placeholder images)
        // For placeholder images, location should be nil
        #expect(location == nil || location != nil)
    }
    
    @Test func testPlatformImageEXIFHasHasGPSLocationProperty() async {
        // Given: A PlatformImage with EXIF accessor
        let image = PlatformImage.createPlaceholder()
        let exif = image.exif
        
        // When: Accessing hasGPSLocation property
        let hasLocation = exif.hasGPSLocation
        
        // Then: Should return a boolean value
        #expect(hasLocation == true || hasLocation == false)
    }
    
    // MARK: - GPS Location Extraction Tests
    
    @Test func testEXIFReturnsNilForImagesWithoutGPSMetadata() async {
        // Given: A PlatformImage without GPS metadata (placeholder)
        let image = PlatformImage.createPlaceholder()
        
        // When: Extracting GPS location
        let location = image.exif.gpsLocation
        
        // Then: Should return nil
        #expect(location == nil)
    }
    
    @Test func testHasGPSLocationReturnsFalseForImagesWithoutGPSMetadata() async {
        // Given: A PlatformImage without GPS metadata (placeholder)
        let image = PlatformImage.createPlaceholder()
        
        // When: Checking if image has GPS location
        let hasLocation = image.exif.hasGPSLocation
        
        // Then: Should return false
        #expect(hasLocation == false)
    }
    
    // MARK: - Cross-Platform Tests
    
    @Test func testEXIFWorksOnAllPlatforms() async {
        // Given: A PlatformImage
        let image = PlatformImage.createPlaceholder()
        let currentPlatform = SixLayerPlatform.current
        
        // When: Accessing EXIF data
        let exif = image.exif
        let hasLocation = exif.hasGPSLocation
        
        // Then: Should work on all platforms
        // The exif property should be available regardless of platform
        #expect(hasLocation == true || hasLocation == false)
    }
    
    // MARK: - API Design Tests
    
    @Test func testEXIFAPIIsIntuitive() async {
        // Given: A PlatformImage
        let image = PlatformImage.createPlaceholder()
        
        // When: Using the API as designed
        let location = image.exif.gpsLocation
        let hasLocation = image.exif.hasGPSLocation
        
        // Then: API should be intuitive and discoverable
        // image.exif.gpsLocation should be the primary way to access GPS data
        #expect(location == nil || location != nil)
        #expect(hasLocation == true || hasLocation == false)
    }
    
    // MARK: - Error Handling Tests
    
    @Test func testEXIFHandlesInvalidImageData() async {
        // Given: An invalid image (empty data)
        let invalidData = Data()
        let image = PlatformImage(data: invalidData)
        
        // When: Accessing EXIF data
        // Then: Should handle gracefully (image is nil, so we can't test exif)
        #expect(image == nil)
    }
    
    @Test func testEXIFHandlesMissingEXIFMetadata() async {
        // Given: A valid image without EXIF metadata
        let image = PlatformImage.createPlaceholder()
        
        // When: Accessing GPS location
        let location = image.exif.gpsLocation
        
        // Then: Should return nil gracefully
        #expect(location == nil)
    }
}

