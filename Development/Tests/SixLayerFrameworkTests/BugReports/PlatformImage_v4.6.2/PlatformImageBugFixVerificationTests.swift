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
    
    func testExactBugScenario_iOS() throws {
        #if os(iOS)
        // This is the exact code that was broken in 4.6.2
        let uiImage = UIImage()
        
        // Test implicit conversion (the broken pattern)
        let platformImageImplicit = PlatformImage(uiImage)  // Should work now
        XCTAssertNotNil(platformImageImplicit)
        
        // Test explicit conversion (the new pattern)
        let platformImageExplicit = PlatformImage(uiImage: uiImage)  // Should also work
        XCTAssertNotNil(platformImageExplicit)
        
        // Both should be equivalent
        XCTAssertEqual(platformImageImplicit.size, platformImageExplicit.size)
        
        #else
        // Skip on non-iOS platforms
        throw XCTSkip("iOS-specific test")
        #endif
    }
    
    func testExactBugScenario_macOS() throws {
        #if os(macOS)
        // This is the macOS equivalent of the broken pattern
        let nsImage = NSImage()
        
        // Test implicit conversion (the broken pattern)
        let platformImageImplicit = PlatformImage(nsImage)  // Should work now
        XCTAssertNotNil(platformImageImplicit)
        
        // Test explicit conversion (the new pattern)
        let platformImageExplicit = PlatformImage(nsImage: nsImage)  // Should also work
        XCTAssertNotNil(platformImageExplicit)
        
        // Both should be equivalent
        XCTAssertEqual(platformImageImplicit.size, platformImageExplicit.size)
        
        #else
        // Skip on non-macOS platforms
        throw XCTSkip("macOS-specific test")
        #endif
    }
    
    func testLayer4CallbackCode_iOS() throws {
        #if os(iOS)
        // Simulate the exact Layer 4 callback code that was broken
        let uiImage = UIImage()
        
        // This is the exact pattern from PlatformPhotoComponentsLayer4.swift line 90
        let platformImage = PlatformImage(uiImage)  // Implicit conversion: UIImage → PlatformImage
        
        XCTAssertNotNil(platformImage)
        XCTAssertEqual(platformImage.size, uiImage.size)
        
        #else
        // Skip on non-iOS platforms
        throw XCTSkip("iOS-specific test")
        #endif
    }
    
    func testLayer4CallbackCode_macOS() throws {
        #if os(macOS)
        // Simulate the exact Layer 4 callback code that was broken
        let nsImage = NSImage()
        
        // This is the exact pattern from PlatformPhotoComponentsLayer4.swift (macOS equivalent)
        let platformImage = PlatformImage(nsImage)  // Implicit conversion: NSImage → PlatformImage
        
        XCTAssertNotNil(platformImage)
        XCTAssertEqual(platformImage.size, nsImage.size)
        
        #else
        // Skip on non-macOS platforms
        throw XCTSkip("macOS-specific test")
        #endif
    }
    
    func testBackwardCompatibility() {
        // Test that both old and new patterns work
        let platformImage1 = PlatformImage()
        XCTAssertNotNil(platformImage1)
        
        #if os(iOS)
        let uiImage = UIImage()
        let platformImage2 = PlatformImage(uiImage)  // Old pattern (implicit)
        let platformImage3 = PlatformImage(uiImage: uiImage)  // New pattern (explicit)
        XCTAssertEqual(platformImage2.size, platformImage3.size)
        #elseif os(macOS)
        let nsImage = NSImage()
        let platformImage2 = PlatformImage(nsImage)  // Old pattern (implicit)
        let platformImage3 = PlatformImage(nsImage: nsImage)  // New pattern (explicit)
        XCTAssertEqual(platformImage2.size, platformImage3.size)
        #endif
    }
}
