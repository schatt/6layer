//
//  RuntimeCapabilityDetectionTDDTests.swift
//  SixLayerFramework
//
//  TDD Tests for Runtime Capability Detection
//  These tests define the expected behavior before implementation
//

import XCTest
import SwiftUI
@testable import SixLayerFramework

/// TDD Tests for Runtime Capability Detection
/// These tests define the expected behavior and will initially fail
@MainActor
final class RuntimeCapabilityDetectionTDDTests: XCTestCase {
    
    // MARK: - Test Setup
    
    override func setUp() {
        super.setUp()
        // Clear any overrides before each test
        CapabilityOverride.touchSupport = nil
        CapabilityOverride.hapticSupport = nil
        CapabilityOverride.hoverSupport = nil
    }
    
    override func tearDown() {
        // Clean up overrides after each test
        CapabilityOverride.touchSupport = nil
        CapabilityOverride.hapticSupport = nil
        CapabilityOverride.hoverSupport = nil
        super.tearDown()
    }
    
    // MARK: - Testing Mode Detection Tests
    
    func testTestingModeDetection() {
        // This test should pass - we're in a test environment
        XCTAssertTrue(TestingCapabilityDetection.isTestingMode, "Should detect testing mode in XCTest environment")
    }
    
    func testTestingDefaultsForEachPlatform() {
        // Test that each platform has predictable testing defaults
        let platforms: [Platform] = [.iOS, .macOS, .watchOS, .tvOS, .visionOS]
        
        for platform in platforms {
            let defaults = TestingCapabilityDetection.getTestingDefaults(for: platform)
            
            // Each platform should have defined defaults
            XCTAssertNotNil(defaults, "Platform \(platform) should have testing defaults")
            
            // Log the defaults for verification
            print("Testing defaults for \(platform):")
            print("  Touch: \(defaults.supportsTouch)")
            print("  Haptic: \(defaults.supportsHapticFeedback)")
            print("  Hover: \(defaults.supportsHover)")
            print("  VoiceOver: \(defaults.supportsVoiceOver)")
            print("  SwitchControl: \(defaults.supportsSwitchControl)")
            print("  AssistiveTouch: \(defaults.supportsAssistiveTouch)")
        }
    }
    
    // MARK: - Runtime Detection Tests (These will initially fail)
    
    func testRuntimeTouchDetectionUsesTestingDefaults() {
        // In testing mode, should use hardcoded defaults
        let platform = Platform.current
        let expectedDefaults = TestingCapabilityDetection.getTestingDefaults(for: platform)
        
        // This should use testing defaults, not runtime detection
        let actualTouchSupport = RuntimeCapabilityDetection.supportsTouch
        XCTAssertEqual(actualTouchSupport, expectedDefaults.supportsTouch, 
                     "Runtime detection should use testing defaults when in testing mode")
    }
    
    func testRuntimeHapticDetectionUsesTestingDefaults() {
        // In testing mode, should use hardcoded defaults
        let platform = Platform.current
        let expectedDefaults = TestingCapabilityDetection.getTestingDefaults(for: platform)
        
        let actualHapticSupport = RuntimeCapabilityDetection.supportsHapticFeedback
        XCTAssertEqual(actualHapticSupport, expectedDefaults.supportsHapticFeedback, 
                     "Runtime haptic detection should use testing defaults when in testing mode")
    }
    
    func testRuntimeHoverDetectionUsesTestingDefaults() {
        // In testing mode, should use hardcoded defaults
        let platform = Platform.current
        let expectedDefaults = TestingCapabilityDetection.getTestingDefaults(for: platform)
        
        let actualHoverSupport = RuntimeCapabilityDetection.supportsHover
        XCTAssertEqual(actualHoverSupport, expectedDefaults.supportsHover, 
                     "Runtime hover detection should use testing defaults when in testing mode")
    }
    
    // MARK: - Override Functionality Tests
    
    func testTouchOverrideTakesPrecedenceOverTestingDefaults() {
        // Set override
        CapabilityOverride.touchSupport = true
        
        // Should use override, not testing defaults
        XCTAssertTrue(RuntimeCapabilityDetection.supportsTouchWithOverride, 
                     "Override should take precedence over testing defaults")
        
        // Set override to false
        CapabilityOverride.touchSupport = false
        XCTAssertFalse(RuntimeCapabilityDetection.supportsTouchWithOverride, 
                      "Override should work when set to false")
    }
    
    func testHapticOverrideTakesPrecedenceOverTestingDefaults() {
        // Set override
        CapabilityOverride.hapticSupport = true
        
        // Should use override, not testing defaults
        XCTAssertTrue(RuntimeCapabilityDetection.supportsHapticFeedbackWithOverride, 
                     "Haptic override should take precedence over testing defaults")
    }
    
    func testHoverOverrideTakesPrecedenceOverTestingDefaults() {
        // Set override
        CapabilityOverride.hoverSupport = false
        
        // Should use override, not testing defaults
        XCTAssertFalse(RuntimeCapabilityDetection.supportsHoverWithOverride, 
                      "Hover override should take precedence over testing defaults")
    }
    
    // MARK: - Platform-Specific Behavior Tests
    
    func testMacOSTouchDefaults() {
        let macDefaults = TestingCapabilityDetection.getTestingDefaults(for: .macOS)
        
        // macOS testing defaults should be predictable
        XCTAssertFalse(macDefaults.supportsTouch, "macOS testing default should be false for touch")
        XCTAssertFalse(macDefaults.supportsHapticFeedback, "macOS testing default should be false for haptic")
        XCTAssertTrue(macDefaults.supportsHover, "macOS testing default should be true for hover")
        XCTAssertFalse(macDefaults.supportsAssistiveTouch, "macOS testing default should be false for AssistiveTouch")
    }
    
    func testiOSTouchDefaults() {
        let iOSDefaults = TestingCapabilityDetection.getTestingDefaults(for: .iOS)
        
        // iOS testing defaults should be predictable
        XCTAssertTrue(iOSDefaults.supportsTouch, "iOS testing default should be true for touch")
        XCTAssertTrue(iOSDefaults.supportsHapticFeedback, "iOS testing default should be true for haptic")
        XCTAssertFalse(iOSDefaults.supportsHover, "iOS testing default should be false for hover (simplified)")
        XCTAssertFalse(iOSDefaults.supportsAssistiveTouch, "iOS testing default should be false for AssistiveTouch (simplified)")
    }
    
    func testVisionOSTouchDefaults() {
        let visionDefaults = TestingCapabilityDetection.getTestingDefaults(for: .visionOS)
        
        // visionOS testing defaults should be predictable
        XCTAssertTrue(visionDefaults.supportsTouch, "visionOS testing default should be true for touch")
        XCTAssertTrue(visionDefaults.supportsHapticFeedback, "visionOS testing default should be true for haptic")
        XCTAssertTrue(visionDefaults.supportsHover, "visionOS testing default should be true for hover")
    }
    
    // MARK: - Integration Tests
    
    func testCardExpansionConfigUsesRuntimeDetection() {
        let config = getCardExpansionPlatformConfig()
        
        // The config should use runtime detection (which uses testing defaults in test mode)
        let platform = Platform.current
        let expectedDefaults = TestingCapabilityDetection.getTestingDefaults(for: platform)
        
        XCTAssertEqual(config.supportsTouch, expectedDefaults.supportsTouch, 
                     "Card expansion config should use runtime detection")
        XCTAssertEqual(config.supportsHapticFeedback, expectedDefaults.supportsHapticFeedback, 
                     "Card expansion config should use runtime detection")
        XCTAssertEqual(config.supportsHover, expectedDefaults.supportsHover, 
                     "Card expansion config should use runtime detection")
    }
    
    func testPlatformOptimizationUsesRuntimeDetection() {
        let platform = Platform.current
        let supportsTouchGestures = platform.supportsTouchGestures
        
        // Should use runtime detection (which uses testing defaults in test mode)
        let expectedDefaults = TestingCapabilityDetection.getTestingDefaults(for: platform)
        XCTAssertEqual(supportsTouchGestures, expectedDefaults.supportsTouch, 
                     "Platform optimization should use runtime detection")
    }
    
    // MARK: - Override Persistence Tests
    
    func testOverridePersistenceAcrossMultipleCalls() {
        // Set overrides
        CapabilityOverride.touchSupport = true
        CapabilityOverride.hapticSupport = false
        
        // Multiple calls should return consistent values
        for _ in 0..<5 {
            XCTAssertTrue(RuntimeCapabilityDetection.supportsTouchWithOverride)
            XCTAssertFalse(RuntimeCapabilityDetection.supportsHapticFeedbackWithOverride)
        }
    }
    
    func testOverrideClearing() {
        // Set override
        CapabilityOverride.touchSupport = true
        XCTAssertTrue(RuntimeCapabilityDetection.supportsTouchWithOverride)
        
        // Clear override
        CapabilityOverride.touchSupport = nil
        
        // Should return to testing defaults
        let platform = Platform.current
        let expectedDefaults = TestingCapabilityDetection.getTestingDefaults(for: platform)
        XCTAssertEqual(RuntimeCapabilityDetection.supportsTouchWithOverride, expectedDefaults.supportsTouch)
    }
    
    // MARK: - Edge Case Tests
    
    func testMultipleOverridesWorkIndependently() {
        // Set different overrides
        CapabilityOverride.touchSupport = true
        CapabilityOverride.hapticSupport = false
        CapabilityOverride.hoverSupport = true
        
        // Each should work independently
        XCTAssertTrue(RuntimeCapabilityDetection.supportsTouchWithOverride)
        XCTAssertFalse(RuntimeCapabilityDetection.supportsHapticFeedbackWithOverride)
        XCTAssertTrue(RuntimeCapabilityDetection.supportsHoverWithOverride)
    }
    
    func testOverridePrecedenceOrder() {
        // Override should take precedence over testing defaults
        let platform = Platform.current
        let testingDefaults = TestingCapabilityDetection.getTestingDefaults(for: platform)
        
        // Set override to opposite of testing default
        CapabilityOverride.touchSupport = !testingDefaults.supportsTouch
        
        // Should use override, not testing default
        XCTAssertEqual(RuntimeCapabilityDetection.supportsTouchWithOverride, !testingDefaults.supportsTouch)
    }
}
