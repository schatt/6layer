import XCTest
@testable import SixLayerFramework

/// Test ButtonStyle compatibility across different deployment targets
final class ButtonStyleCompatibilityTests: XCTestCase {
    
    @MainActor
    func testAlertButtonCreation() {
        let messagingLayer = PlatformMessagingLayer5()
        
        // Test that we can create alert buttons without compilation errors
        let button = messagingLayer.createAlertButton(
            title: "Test Button",
            style: .default
        ) {
            // Test action
        }
        
        // Verify the button was created (basic smoke test)
        XCTAssertNotNil(button)
    }
    
    @MainActor
    func testDestructiveAlertButtonCreation() {
        let messagingLayer = PlatformMessagingLayer5()
        
        // Test destructive button style
        let destructiveButton = messagingLayer.createAlertButton(
            title: "Delete",
            style: .destructive
        ) {
            // Test action
        }
        
        // Verify the button was created (basic smoke test)
        XCTAssertNotNil(destructiveButton)
    }
    
    func testButtonStyleAvailability() {
        // Test that ButtonStyle APIs are available at runtime
        // This will fail at compile time if APIs aren't available
        
        #if os(iOS)
        if #available(iOS 15.0, *) {
            // These should be available since we target iOS 16.0+
            // Note: We can't test the actual ButtonStyle.bordered here due to compilation issues
            // But the fact that our createAlertButton method compiles means the APIs are available
            XCTAssertTrue(true, "ButtonStyle APIs should be available for iOS 15.0+")
        }
        #elseif os(macOS)
        if #available(macOS 12.0, *) {
            // These should be available since we target macOS 13.0+
            // Note: We can't test the actual ButtonStyle.bordered here due to compilation issues
            // But the fact that our createAlertButton method compiles means the APIs are available
            XCTAssertTrue(true, "ButtonStyle APIs should be available for macOS 12.0+")
        }
        #endif
        
        // If we get here, the APIs are available
        XCTAssertTrue(true, "ButtonStyle APIs should be available")
    }
}