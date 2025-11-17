import Testing

//
//  PlatformImageFixVerificationTests.swift
//  SixLayerFrameworkTests
//
//  BUSINESS PURPOSE:
//  Simple tests to verify our PlatformImage backward compatibility fix works.
//  These tests prove that the broken code now works.
//

import SwiftUI
@testable import SixLayerFramework
#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

@MainActor
open class PlatformImageFixVerificationTests: BaseTestClass {
    
    /// BUSINESS PURPOSE: Verify the exact broken code now works
    /// TESTING SCOPE: Tests the exact PlatformImage(image) pattern that was broken
    /// METHODOLOGY: Test the exact API pattern that was broken in 4.6.2
    @Test func testPlatformImageFix_ExactBrokenPattern() {
        #if os(iOS)
        // Given: The exact code that was broken in 4.6.2
        let uiImage = createTestUIImage()
        
        // When: Use the exact pattern that was broken
        // This is the EXACT code from the bug report: PlatformImage(image)
        let platformImage = PlatformImage(uiImage)
        
        // Then: Verify it works (would have failed in 4.6.2)
        #expect(platformImage.uiImage == uiImage, "Broken pattern should now work")
        #elseif os(macOS)
        // Given: The exact code that was broken in 4.6.2
        let nsImage = createTestNSImage()
        
        // When: Use the exact pattern that was broken
        let platformImage = PlatformImage(nsImage)
        
        // Then: Verify it works (would have failed in 4.6.2)
        #expect(platformImage.nsImage == nsImage, "Broken pattern should now work")
        #endif
    }
    
    /// BUSINESS PURPOSE: Verify both old and new API patterns work
    /// TESTING SCOPE: Tests that both implicit and explicit parameter patterns work
    /// METHODOLOGY: Test both API patterns to ensure backward compatibility
    @Test func testPlatformImageFix_BothPatternsWork() {
        #if os(iOS)
        let uiImage = createTestUIImage()
        
        // Test both patterns
        let oldPattern = PlatformImage(uiImage)        // Old pattern (was broken)
        let newPattern = PlatformImage(uiImage: uiImage)  // New pattern
        
        // Both should work and produce equivalent results
        #expect(oldPattern.uiImage == newPattern.uiImage, "Both patterns should work")
        #elseif os(macOS)
        let nsImage = createTestNSImage()
        
        // Test both patterns
        let oldPattern = PlatformImage(nsImage)        // Old pattern (was broken)
        let newPattern = PlatformImage(nsImage: nsImage)  // New pattern
        
        // Both should work and produce equivalent results
        #expect(oldPattern.nsImage == newPattern.nsImage, "Both patterns should work")
        #endif
    }
    
    /// BUSINESS PURPOSE: Verify the Layer 4 callback code now works
    /// TESTING SCOPE: Tests the exact callback code that was broken
    /// METHODOLOGY: Test the exact callback execution that was broken
    @Test func testPlatformImageFix_Layer4CallbackCode() {
        #if os(iOS)
        let uiImage = createTestUIImage()
        
        // This is the EXACT code that was broken in Layer 4 callbacks:
        // parent.onImageCaptured(PlatformImage(image))
        // parent.onImageSelected(PlatformImage(image))
        let capturedImage = PlatformImage(uiImage)
        let selectedImage = PlatformImage(uiImage)
        
        // Both should work (would have failed in 4.6.2)
        #expect(capturedImage.uiImage == uiImage, "Camera callback should work")
        #expect(selectedImage.uiImage == uiImage, "Photo picker callback should work")
        #elseif os(macOS)
        let nsImage = createTestNSImage()
        
        // This is the EXACT code that was broken in Layer 4 callbacks
        let capturedImage = PlatformImage(nsImage)
        let selectedImage = PlatformImage(nsImage)
        
        // Both should work (would have failed in 4.6.2)
        #expect(capturedImage.nsImage == nsImage, "macOS camera callback should work")
        #expect(selectedImage.nsImage == nsImage, "macOS photo picker callback should work")
        #endif
    }
    
    // MARK: - Test Data Helpers
    
    #if os(iOS)
    private func createTestUIImage() -> UIImage {
        let size = CGSize(width: 200, height: 200)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            UIColor.red.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
    }
    #endif
    
    #if os(macOS)
    private func createTestNSImage() -> NSImage {
        let size = NSSize(width: 200, height: 200)
        let nsImage = NSImage(size: size)
        nsImage.lockFocus()
        NSColor.red.drawSwatch(in: NSRect(origin: .zero, size: size))
        nsImage.unlockFocus()
        return nsImage
    }
    #endif
}
