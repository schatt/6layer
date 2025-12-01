import XCTest
@testable import SixLayerFramework

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

/// Test the exact bug scenario from the bug report
/// This verifies that the PlatformImage breaking change is fixed
final class PlatformImageBugFixVerificationTests: XCTestCase {
    
    func testExactBugScenario() throws {
        // This is the exact code that was broken in 4.6.2
        // Tests both implicit and explicit conversion patterns on the current platform
        
        #if os(iOS)
        let uiImage = UIImage() // 6LAYER_ALLOW: boundary testing between platform-specific images and PlatformImage

        // Test implicit conversion (the broken pattern)
        let platformImageImplicit = PlatformImage(uiImage)  // Should work now
        XCTAssertNotNil(platformImageImplicit)

        // Test explicit conversion (the new pattern)
        let platformImageExplicit = PlatformImage(uiImage: uiImage)  // Should also work
        XCTAssertNotNil(platformImageExplicit)

        // Both should be equivalent
        XCTAssertEqual(platformImageImplicit.size, platformImageExplicit.size)

        #elseif os(macOS)
        let nsImage = NSImage() // 6LAYER_ALLOW: boundary testing between platform-specific images and PlatformImage

        // Test implicit conversion (the broken pattern)
        let platformImageImplicit = PlatformImage(nsImage)  // Should work now
        XCTAssertNotNil(platformImageImplicit)
        
        // Test explicit conversion (the new pattern)
        let platformImageExplicit = PlatformImage(nsImage: nsImage)  // Should also work
        XCTAssertNotNil(platformImageExplicit)
        
        // Both should be equivalent
        XCTAssertEqual(platformImageImplicit.size, platformImageExplicit.size)
        
        #else
        throw XCTSkip("Platform-specific test - only runs on iOS or macOS")
        #endif
    }
    
    func testLayer4CallbackCode() throws {
        // Simulate the exact Layer 4 callback code that was broken
        // Tests the implicit conversion pattern on the current platform
        
        #if os(iOS)
        let uiImage = UIImage() // 6LAYER_ALLOW: boundary testing between platform-specific images and PlatformImage

        // This is the exact pattern from PlatformPhotoComponentsLayer4.swift line 90
        let platformImage = PlatformImage(uiImage)  // Implicit conversion: UIImage → PlatformImage

        XCTAssertNotNil(platformImage)
        XCTAssertEqual(platformImage.size, uiImage.size)

        #elseif os(macOS)
        let nsImage = NSImage() // 6LAYER_ALLOW: boundary testing between platform-specific images and PlatformImage

        // This is the exact pattern from PlatformPhotoComponentsLayer4.swift (macOS equivalent)
        let platformImage = PlatformImage(nsImage)  // Implicit conversion: NSImage → PlatformImage

        XCTAssertNotNil(platformImage)
        XCTAssertEqual(platformImage.size, nsImage.size)
        
        #else
        throw XCTSkip("Platform-specific test - only runs on iOS or macOS")
        #endif
    }
    
    func testBackwardCompatibility() {
        // Test that both old and new patterns work
        let platformImage1 = PlatformImage()
        XCTAssertNotNil(platformImage1)
        
        #if os(iOS)
        let uiImage = UIImage() // 6LAYER_ALLOW: boundary testing between platform-specific images and PlatformImage
        let platformImage2 = PlatformImage(uiImage)  // Old pattern (implicit)
        let platformImage3 = PlatformImage(uiImage: uiImage)  // New pattern (explicit)
        XCTAssertEqual(platformImage2.size, platformImage3.size)
        #elseif os(macOS)
        let nsImage = NSImage() // 6LAYER_ALLOW: boundary testing between platform-specific images and PlatformImage
        let platformImage2 = PlatformImage(nsImage)  // Old pattern (implicit)
        let platformImage3 = PlatformImage(nsImage: nsImage)  // New pattern (explicit)
        XCTAssertEqual(platformImage2.size, platformImage3.size)
        #endif
    }
}
