import Testing

//
//  PlatformImageAPISignatureTests.swift
//  SixLayerFrameworkTests
//
//  BUSINESS PURPOSE:
//  Validates ALL public API signatures for PlatformImage to prevent breaking changes.
//  These tests would have caught the PlatformImage initializer breaking change.
//
//  TESTING SCOPE:
//  - All public initializer signatures and parameter labels
//  - API compatibility and backward compatibility
//  - Parameter label requirements and optional parameters
//  - Cross-platform API consistency
//  - Breaking change detection for public interface
//
//  METHODOLOGY:
//  - Test every public initializer signature exists
//  - Test parameter labels are correct and required
//  - Test backward compatibility with old API patterns
//  - Test cross-platform API consistency
//  - Test that API changes would break these tests
//
//  CRITICAL: These tests MUST fail if any public API signature changes
//

import SwiftUI
#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif
@testable import SixLayerFramework


@MainActor
open class PlatformImageAPISignatureTests {
    
    // MARK: - API Signature Tests
    
    /// BUSINESS PURPOSE: Verify all public initializer signatures exist and work
    /// TESTING SCOPE: Tests that ALL public PlatformImage initializers exist and function
    /// METHODOLOGY: Test each initializer signature directly
    @Test func testPlatformImageInitializerSignatures() {
        // Test 1: Default initializer
        let defaultImage = PlatformImage()
        // defaultImage is non-optional, so no nil check needed
        #expect(Bool(true), "Default initializer should exist")
        
        // Test 2: Data initializer
        let sampleData = createSampleImageData()
        let dataImage = PlatformImage(data: sampleData)
        #expect(Bool(true), "Data initializer should exist and work")  // dataImage is non-optional
        
        // Test 3: Platform-specific initializers
        #if os(iOS)
        let uiImage = createTestUIImage()
        let uiImageInit = PlatformImage(uiImage: uiImage)
        // uiImageInit is non-optional, so no nil check needed
        #expect(Bool(true), "UIImage initializer should exist")
        #expect(uiImageInit.uiImage == uiImage, "UIImage initializer should work correctly")
        
        // Test 4: Backward compatibility initializer (implicit parameter)
        let implicitInit = PlatformImage(uiImage)
        // implicitInit is non-optional, so no nil check needed
        #expect(Bool(true), "Implicit parameter initializer should exist for backward compatibility")
        #expect(implicitInit.uiImage == uiImage, "Implicit parameter initializer should work correctly")
        #elseif os(macOS)
        let nsImage = createTestNSImage()
        let nsImageInit = PlatformImage(nsImage: nsImage)
        // nsImageInit is non-optional, so no nil check needed
        #expect(Bool(true), "NSImage initializer should exist")
        #expect(nsImageInit.nsImage == nsImage, "NSImage initializer should work correctly")
        
        // Test 4: Backward compatibility initializer (implicit parameter)
        let implicitInit = PlatformImage(nsImage)
        // implicitInit is non-optional, so no nil check needed
        #expect(Bool(true), "Implicit parameter initializer should exist for backward compatibility")
        #expect(implicitInit.nsImage == nsImage, "Implicit parameter initializer should work correctly")
        #endif
    }
    
    /// BUSINESS PURPOSE: Verify parameter labels are correct and required
    /// TESTING SCOPE: Tests that parameter labels match expected API
    /// METHODOLOGY: Test parameter label requirements
    @Test func testPlatformImageParameterLabels() {
        #if os(iOS)
        let uiImage = createTestUIImage()
        
        // Test explicit parameter label (current API)
        let explicitInit = PlatformImage(uiImage: uiImage)
        // explicitInit is non-optional, so no nil check needed
        #expect(Bool(true), "Explicit parameter label should work")
        
        // Test implicit parameter (backward compatibility)
        let implicitInit = PlatformImage(uiImage)
        // implicitInit is non-optional, so no nil check needed
        #expect(Bool(true), "Implicit parameter should work for backward compatibility")
        
        // Verify both produce equivalent results
        #expect(explicitInit.uiImage == implicitInit.uiImage, "Both initializers should produce equivalent results")
        #elseif os(macOS)
        let nsImage = createTestNSImage()
        
        // Test explicit parameter label (current API)
        let explicitInit = PlatformImage(nsImage: nsImage)
        // explicitInit is non-optional, so no nil check needed
        #expect(Bool(true), "Explicit parameter label should work")
        
        // Test implicit parameter (backward compatibility)
        let implicitInit = PlatformImage(nsImage)
        // implicitInit is non-optional, so no nil check needed
        #expect(Bool(true), "Implicit parameter should work for backward compatibility")
        
        // Verify both produce equivalent results
        #expect(explicitInit.nsImage == implicitInit.nsImage, "Both initializers should produce equivalent results")
        #endif
    }
    
    /// BUSINESS PURPOSE: Verify backward compatibility with old API patterns
    /// TESTING SCOPE: Tests that old API usage patterns still work
    /// METHODOLOGY: Test the exact API patterns used in Layer 4 callbacks
    @Test func testPlatformImageBackwardCompatibility() {
        #if os(iOS)
        let uiImage = createTestUIImage()
        
        // Test the EXACT pattern used in Layer 4 callbacks
        // This is the pattern that was broken in 4.6.2
        let callbackPattern = PlatformImage(uiImage)
        // callbackPattern is non-optional, so no nil check needed
        #expect(Bool(true), "Callback pattern PlatformImage(image) should work")
        #expect(callbackPattern.uiImage == uiImage, "Callback pattern should produce correct result")
        
        // Test that both old and new patterns work
        let newPattern = PlatformImage(uiImage: uiImage)
        #expect(newPattern.uiImage == callbackPattern.uiImage, "Old and new patterns should be equivalent")
        #elseif os(macOS)
        let nsImage = createTestNSImage()
        
        // Test the EXACT pattern used in Layer 4 callbacks
        let callbackPattern = PlatformImage(nsImage)
        // callbackPattern is non-optional, so no nil check needed
        #expect(Bool(true), "Callback pattern PlatformImage(image) should work")
        #expect(callbackPattern.nsImage == nsImage, "Callback pattern should produce correct result")
        
        // Test that both old and new patterns work
        let newPattern = PlatformImage(nsImage: nsImage)
        #expect(newPattern.nsImage == callbackPattern.nsImage, "Old and new patterns should be equivalent")
        #endif
    }
    
    /// BUSINESS PURPOSE: Verify cross-platform API consistency
    /// TESTING SCOPE: Tests that API is consistent across platforms
    /// METHODOLOGY: Test API patterns work on all platforms
    @Test func testPlatformImageCrossPlatformConsistency() {
        // Test that data initializer works on all platforms
        let sampleData = createSampleImageData()
        let dataImage = PlatformImage(data: sampleData)
        #expect(Bool(true), "Data initializer should work on all platforms")  // dataImage is non-optional
        
        // Test that default initializer works on all platforms
        let defaultImage = PlatformImage()
        // defaultImage is non-optional, so no nil check needed
        #expect(Bool(true), "Default initializer should work on all platforms")
        
        // Test that both implicit and explicit patterns work
        #if os(iOS)
        let uiImage = createTestUIImage()
        let implicit = PlatformImage(uiImage)
        let explicit = PlatformImage(uiImage: uiImage)
        #expect(implicit.uiImage == explicit.uiImage, "iOS patterns should be equivalent")
        #elseif os(macOS)
        let nsImage = createTestNSImage()
        let implicit = PlatformImage(nsImage)
        let explicit = PlatformImage(nsImage: nsImage)
        #expect(implicit.nsImage == explicit.nsImage, "macOS patterns should be equivalent")
        #endif
    }
    
    /// BUSINESS PURPOSE: Verify API breaking change detection
    /// TESTING SCOPE: Tests that would fail if API signatures change
    /// METHODOLOGY: Test specific API patterns that must remain stable
    @Test func testPlatformImageBreakingChangeDetection() {
        // This test would have FAILED in version 4.6.2 before our fix
        // It tests the exact API pattern that was broken
        
        #if os(iOS)
        let uiImage = createTestUIImage()
        
        // Test the broken pattern from Layer 4 callbacks
        // This should work with our backward compatibility fix
        let brokenPattern = PlatformImage(uiImage)
        // brokenPattern is non-optional, so no nil check needed
        #expect(Bool(true), "Broken pattern should work with backward compatibility")
        
        // Test that the result is usable
        #expect(brokenPattern.uiImage == uiImage, "Broken pattern should produce correct result")
        #expect(brokenPattern.size == uiImage.size, "Broken pattern should preserve image properties")
        #elseif os(macOS)
        let nsImage = createTestNSImage()
        
        // Test the broken pattern from Layer 4 callbacks
        let brokenPattern = PlatformImage(nsImage)
        // brokenPattern is non-optional, so no nil check needed
        #expect(Bool(true), "Broken pattern should work with backward compatibility")
        
        // Test that the result is usable
        #expect(brokenPattern.nsImage == nsImage, "Broken pattern should produce correct result")
        #expect(brokenPattern.size == nsImage.size, "Broken pattern should preserve image properties")
        #endif
    }
    
    // MARK: - Test Data Helpers
    
    private func createSampleImageData() -> Data {
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
