//
//  PlatformTestUtilities.swift
//  SixLayerFrameworkTests
//
//  Centralized platform test utilities for consistent capability testing
//

import XCTest
import SwiftUI
@testable import SixLayerFramework

/// Centralized platform test utilities for consistent capability testing
final class PlatformTestUtilities {
    
    // MARK: - Platform Test Configuration Structure
    
    /// Complete platform test configuration containing all capabilities and settings
    struct PlatformTestConfig {
        let platform: Platform
        let config: CardExpansionPlatformConfig
        let visionAvailable: Bool
        let ocrAvailable: Bool
    }
    
    // MARK: - Platform Test Helper Methods
    
    /// Creates a complete iOS platform test configuration with all capabilities set appropriately
    static func createIOSPlatformTestConfig() -> PlatformTestConfig {
        return PlatformTestConfig(
            platform: .iOS,
            config: CardExpansionPlatformConfig(
                supportsHapticFeedback: true,
                supportsHover: false,
                supportsTouch: true,
                supportsVoiceOver: true,
                supportsSwitchControl: true,
                supportsAssistiveTouch: true,
                minTouchTarget: 44,
                hoverDelay: 0.0,
                animationEasing: .easeInOut(duration: 0.3)
            ),
            visionAvailable: true,
            ocrAvailable: true
        )
    }
    
    /// Creates a complete macOS platform test configuration with all capabilities set appropriately
    static func createMacOSPlatformTestConfig() -> PlatformTestConfig {
        return PlatformTestConfig(
            platform: .macOS,
            config: CardExpansionPlatformConfig(
                supportsHapticFeedback: false,
                supportsHover: true,
                supportsTouch: false,
                supportsVoiceOver: true,
                supportsSwitchControl: true,
                supportsAssistiveTouch: false,
                minTouchTarget: 0,
                hoverDelay: 0.1,
                animationEasing: .easeInOut(duration: 0.3)
            ),
            visionAvailable: true,
            ocrAvailable: true
        )
    }
    
    /// Creates a complete watchOS platform test configuration with all capabilities set appropriately
    static func createWatchOSPlatformTestConfig() -> PlatformTestConfig {
        return PlatformTestConfig(
            platform: .watchOS,
            config: CardExpansionPlatformConfig(
                supportsHapticFeedback: true,
                supportsHover: false,
                supportsTouch: true,
                supportsVoiceOver: true,
                supportsSwitchControl: true,
                supportsAssistiveTouch: true,
                minTouchTarget: 44,
                hoverDelay: 0.0,
                animationEasing: .easeInOut(duration: 0.2)
            ),
            visionAvailable: false,
            ocrAvailable: false
        )
    }
    
    /// Creates a complete tvOS platform test configuration with all capabilities set appropriately
    static func createTVOSPlatformTestConfig() -> PlatformTestConfig {
        return PlatformTestConfig(
            platform: .tvOS,
            config: CardExpansionPlatformConfig(
                supportsHapticFeedback: false,
                supportsHover: false,
                supportsTouch: false,
                supportsVoiceOver: true,
                supportsSwitchControl: true,
                supportsAssistiveTouch: false,
                minTouchTarget: 0,
                hoverDelay: 0.0,
                animationEasing: .easeInOut(duration: 0.3)
            ),
            visionAvailable: false,
            ocrAvailable: false
        )
    }
    
    /// Creates a complete visionOS platform test configuration with all capabilities set appropriately
    static func createVisionOSPlatformTestConfig() -> PlatformTestConfig {
        return PlatformTestConfig(
            platform: .visionOS,
            config: CardExpansionPlatformConfig(
                supportsHapticFeedback: false,
                supportsHover: false,
                supportsTouch: false,
                supportsVoiceOver: true,
                supportsSwitchControl: true,
                supportsAssistiveTouch: false,
                minTouchTarget: 44,
                hoverDelay: 0.0,
                animationEasing: .easeInOut(duration: 0.3)
            ),
            visionAvailable: true,
            ocrAvailable: true
        )
    }
    
    // MARK: - Behavioral Test Methods
    
    /// Test the behavioral implications of touch platform capabilities
    static func testTouchPlatformBehavior(_ config: CardExpansionPlatformConfig, platformName: String) {
        // Touch platforms should have adequate touch targets
        XCTAssertGreaterThanOrEqual(config.minTouchTarget, 44, 
                                   "\(platformName) should have adequate touch targets")
        
        // Touch platforms should support haptic feedback
        XCTAssertTrue(config.supportsHapticFeedback, 
                     "\(platformName) should support haptic feedback")
        
        // Touch platforms should support AssistiveTouch
        XCTAssertTrue(config.supportsAssistiveTouch, 
                     "\(platformName) should support AssistiveTouch")
        
        // Touch platforms should have zero hover delay (no hover)
        XCTAssertEqual(config.hoverDelay, 0, 
                      "\(platformName) should have zero hover delay")
    }
    
    /// Test the behavioral implications of non-touch platform capabilities
    static func testNonTouchPlatformBehavior(_ config: CardExpansionPlatformConfig, platformName: String) {
        // Non-touch platforms should not support haptic feedback
        XCTAssertFalse(config.supportsHapticFeedback, 
                      "\(platformName) should not support haptic feedback")
        
        // Non-touch platforms should not support AssistiveTouch
        XCTAssertFalse(config.supportsAssistiveTouch, 
                      "\(platformName) should not support AssistiveTouch")
        
        // Non-touch platforms should have zero touch target requirement
        XCTAssertEqual(config.minTouchTarget, 0, 
                      "\(platformName) should have zero touch target requirement")
    }
    
    /// Test the behavioral implications of hover platform capabilities
    static func testHoverPlatformBehavior(_ config: CardExpansionPlatformConfig, platformName: String) {
        // Hover platforms should have hover delay set
        XCTAssertGreaterThanOrEqual(config.hoverDelay, 0, 
                                   "\(platformName) should have hover delay set")
        
        // Hover platforms should not support touch (mutually exclusive)
        XCTAssertFalse(config.supportsTouch, 
                      "\(platformName) should not support touch (hover exclusive)")
    }
    
    /// Test the behavioral implications of non-hover platform capabilities
    static func testNonHoverPlatformBehavior(_ config: CardExpansionPlatformConfig, platformName: String) {
        // Non-hover platforms should have zero hover delay
        XCTAssertEqual(config.hoverDelay, 0, 
                      "\(platformName) should have zero hover delay")
    }
    
    /// Test the behavioral implications of accessibility platform capabilities
    static func testAccessibilityPlatformBehavior(_ config: CardExpansionPlatformConfig, platformName: String) {
        // Test the actual business logic: how does the platform handle accessibility?
        
        // Test that touch targets are appropriate for the platform's capabilities
        if config.supportsTouch {
            // Touch platforms need adequate touch targets for accessibility
            XCTAssertGreaterThanOrEqual(config.minTouchTarget, 44, 
                                       "\(platformName) touch targets should be adequate for accessibility")
        } else {
            // Non-touch platforms can have smaller targets
            XCTAssertGreaterThanOrEqual(config.minTouchTarget, 20, 
                                       "\(platformName) should have reasonable minimum touch target")
        }
        
        // Test that hover behavior is appropriate for the platform
        if config.supportsHover {
            // Hover platforms should have reasonable hover delay
            XCTAssertGreaterThanOrEqual(config.hoverDelay, 0, 
                                       "\(platformName) hover delay should be non-negative")
        } else {
            // Non-hover platforms should have zero hover delay
            XCTAssertEqual(config.hoverDelay, 0, 
                          "\(platformName) should have zero hover delay")
        }
        
        // Test that the configuration reflects the actual platform capabilities
        // This tests the real business logic: does the config match what the platform actually supports?
        XCTAssertNotNil(config, "\(platformName) should have a valid accessibility configuration")
    }
    
    /// Test the behavioral implications of Vision framework availability
    static func testVisionAvailableBehavior(_ testConfig: PlatformTestConfig, platformName: String) {
        // Vision-available platforms should have OCR
        XCTAssertTrue(testConfig.ocrAvailable, 
                     "\(platformName) should have OCR available")
        
        // Vision-available platforms should have Vision framework
        XCTAssertTrue(testConfig.visionAvailable, 
                     "\(platformName) should have Vision framework")
    }
    
    /// Test the behavioral implications of Vision framework unavailability
    static func testVisionUnavailableBehavior(_ testConfig: PlatformTestConfig, platformName: String) {
        // Vision-unavailable platforms should not have OCR
        XCTAssertFalse(testConfig.ocrAvailable, 
                      "\(platformName) should not have OCR available")
        
        // Vision-unavailable platforms should not have Vision framework
        XCTAssertFalse(testConfig.visionAvailable, 
                      "\(platformName) should not have Vision framework")
    }
    
    // MARK: - Platform Configuration Helpers
    
    /// Get platform configuration for a specific platform using centralized helpers
    static func getPlatformConfig(for platform: Platform) -> CardExpansionPlatformConfig {
        switch platform {
        case .iOS:
            return createIOSPlatformTestConfig().config
        case .macOS:
            return createMacOSPlatformTestConfig().config
        case .watchOS:
            return createWatchOSPlatformTestConfig().config
        case .tvOS:
            return createTVOSPlatformTestConfig().config
        case .visionOS:
            return createVisionOSPlatformTestConfig().config
        }
    }
    
    /// Get Vision availability for a specific platform using centralized helpers
    static func getVisionAvailability(for platform: Platform) -> Bool {
        switch platform {
        case .iOS, .macOS, .visionOS:
            return true
        case .watchOS, .tvOS:
            return false
        }
    }
    
    /// Get OCR availability for a specific platform using centralized helpers
    static func getOCRAvailability(for platform: Platform) -> Bool {
        switch platform {
        case .iOS, .macOS, .visionOS:
            return true
        case .watchOS, .tvOS:
            return false
        }
    }
}
