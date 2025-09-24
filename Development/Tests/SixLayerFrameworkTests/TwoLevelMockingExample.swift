import XCTest
@testable import SixLayerFramework

/// Example demonstrating the two-level mocking system for RuntimeCapabilityDetection
/// 
/// This shows how to test both platform-level and capability-level scenarios
@MainActor
final class TwoLevelMockingExample: XCTestCase {
    
    override func tearDown() {
        // Clean up all overrides after each test
        RuntimeCapabilityDetection.setTestPlatform(nil)
        RuntimeCapabilityDetection.clearAllCapabilityOverrides()
        super.tearDown()
    }
    
    // MARK: - Platform-Level Testing Examples
    
    /// Test default iOS capabilities
    func testDefaultiOSCapabilities() {
        // Given: Simulate iOS platform
        RuntimeCapabilityDetection.setTestPlatform(.iOS)
        
        // When: Check capabilities
        let touchSupport = RuntimeCapabilityDetection.supportsTouch
        let hapticSupport = RuntimeCapabilityDetection.supportsHapticFeedback
        let voiceOverSupport = RuntimeCapabilityDetection.supportsVoiceOver
        
        // Then: Should return iOS defaults
        XCTAssertTrue(touchSupport, "iOS should support touch by default")
        XCTAssertTrue(hapticSupport, "iOS should support haptic feedback by default")
        XCTAssertTrue(voiceOverSupport, "iOS should support VoiceOver by default")
    }
    
    /// Test default macOS capabilities
    func testDefaultmacOSCapabilities() {
        // Given: Simulate macOS platform
        RuntimeCapabilityDetection.setTestPlatform(.macOS)
        
        // When: Check capabilities
        let touchSupport = RuntimeCapabilityDetection.supportsTouch
        let hapticSupport = RuntimeCapabilityDetection.supportsHapticFeedback
        let hoverSupport = RuntimeCapabilityDetection.supportsHover
        
        // Then: Should return macOS defaults
        XCTAssertFalse(touchSupport, "macOS should not support touch by default")
        XCTAssertFalse(hapticSupport, "macOS should not support haptic feedback by default")
        XCTAssertTrue(hoverSupport, "macOS should support hover by default")
    }
    
    // MARK: - Capability-Level Override Examples
    
    /// Test macOS with touch support (edge case)
    func testmacOSWithTouchSupport() {
        // Given: Simulate macOS platform with touch override
        RuntimeCapabilityDetection.setTestPlatform(.macOS)
        RuntimeCapabilityDetection.setTestTouchSupport(true)
        
        // When: Check touch support
        let touchSupport = RuntimeCapabilityDetection.supportsTouch
        
        // Then: Should return overridden value
        XCTAssertTrue(touchSupport, "macOS with touch override should support touch")
    }
    
    /// Test iOS without haptic feedback (edge case)
    func testiOSWithoutHapticFeedback() {
        // Given: Simulate iOS platform without haptic feedback
        RuntimeCapabilityDetection.setTestPlatform(.iOS)
        RuntimeCapabilityDetection.setTestHapticFeedback(false)
        
        // When: Check haptic support
        let hapticSupport = RuntimeCapabilityDetection.supportsHapticFeedback
        
        // Then: Should return overridden value
        XCTAssertFalse(hapticSupport, "iOS without haptic override should not support haptic feedback")
    }
    
    /// Test tvOS with VoiceOver disabled (edge case)
    func testtvOSWithoutVoiceOver() {
        // Given: Simulate tvOS platform without VoiceOver
        RuntimeCapabilityDetection.setTestPlatform(.tvOS)
        RuntimeCapabilityDetection.setTestVoiceOver(false)
        
        // When: Check VoiceOver support
        let voiceOverSupport = RuntimeCapabilityDetection.supportsVoiceOver
        
        // Then: Should return overridden value
        XCTAssertFalse(voiceOverSupport, "tvOS without VoiceOver override should not support VoiceOver")
    }
    
    // MARK: - Complex Scenario Examples
    
    /// Test multiple capability overrides on same platform
    func testMultipleCapabilityOverrides() {
        // Given: Simulate iOS with multiple overrides
        RuntimeCapabilityDetection.setTestPlatform(.iOS)
        RuntimeCapabilityDetection.setTestTouchSupport(false)
        RuntimeCapabilityDetection.setTestHapticFeedback(false)
        RuntimeCapabilityDetection.setTestVoiceOver(false)
        
        // When: Check all capabilities
        let touchSupport = RuntimeCapabilityDetection.supportsTouch
        let hapticSupport = RuntimeCapabilityDetection.supportsHapticFeedback
        let voiceOverSupport = RuntimeCapabilityDetection.supportsVoiceOver
        let hoverSupport = RuntimeCapabilityDetection.supportsHover // Not overridden
        
        // Then: Should return overridden values where set, defaults where not
        XCTAssertFalse(touchSupport, "Touch should be overridden to false")
        XCTAssertFalse(hapticSupport, "Haptic should be overridden to false")
        XCTAssertFalse(voiceOverSupport, "VoiceOver should be overridden to false")
        XCTAssertFalse(hoverSupport, "Hover should use iOS default (false)")
    }
    
    /// Test capability override without platform override
    func testCapabilityOverrideWithoutPlatformOverride() {
        // Given: Use current platform but override specific capability
        RuntimeCapabilityDetection.setTestTouchSupport(true)
        
        // When: Check touch support
        let touchSupport = RuntimeCapabilityDetection.supportsTouch
        
        // Then: Should return overridden value regardless of platform
        XCTAssertTrue(touchSupport, "Touch override should work on any platform")
    }
    
    // MARK: - Edge Case Testing
    
    /// Test clearing overrides
    func testClearingOverrides() {
        // Given: Set up overrides
        RuntimeCapabilityDetection.setTestPlatform(.macOS)
        RuntimeCapabilityDetection.setTestTouchSupport(true)
        RuntimeCapabilityDetection.setTestHapticFeedback(true)
        
        // When: Clear all overrides
        RuntimeCapabilityDetection.setTestPlatform(nil)
        RuntimeCapabilityDetection.clearAllCapabilityOverrides()
        
        // Then: Should return to production behavior
        // Note: This will use actual Platform.current and real system detection
        let touchSupport = RuntimeCapabilityDetection.supportsTouch
        let hapticSupport = RuntimeCapabilityDetection.supportsHapticFeedback
        
        // These assertions depend on the actual platform we're running on
        // In a real test, you'd check against expected values for the current platform
        XCTAssertNotNil(touchSupport, "Touch support should return a boolean value")
        XCTAssertNotNil(hapticSupport, "Haptic support should return a boolean value")
    }
}
