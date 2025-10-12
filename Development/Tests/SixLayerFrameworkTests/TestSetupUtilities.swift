//
//  TestSetupUtilities.swift
//  SixLayerFrameworkTests
//
//  Centralized test setup and platform mocking utilities
//  Following DRY principles to avoid duplicating setup code across test files
//

import XCTest
import SwiftUI
@testable import SixLayerFramework

/// Centralized test setup utilities for consistent platform mocking across all tests
public final class TestSetupUtilities {
    
    // MARK: - Singleton
    
    public static let shared = TestSetupUtilities()
    
    private init() {}
    
    // MARK: - Test Environment Setup
    
    /// Sets up the testing environment with predictable platform capabilities
    /// Call this in setUp() methods of test classes
    @MainActor
    public func setupTestingEnvironment() {
        // TestingCapabilityDetection.isTestingMode is automatically enabled in test environment
        // Reset any existing overrides
        clearAllCapabilityOverrides()
    }
    
    /// Cleans up the testing environment
    /// Call this in tearDown() methods of test classes
    @MainActor
    public func cleanupTestingEnvironment() {
        // Clear all overrides
        clearAllCapabilityOverrides()
    }
    
    // MARK: - Platform Simulation
    
    /// Simulates a specific platform with its expected capabilities
    /// - Parameter platform: The platform to simulate
    public func simulatePlatform(_ platform: SixLayerPlatform) {
        RuntimeCapabilityDetection.setTestPlatform(platform)
    }
    
    /// Simulates iOS platform with touch and haptic support
    public func simulateiOS() {
        simulatePlatform(.iOS)
    }
    
    /// Simulates macOS platform with hover support (no touch/haptic)
    public func simulateMacOS() {
        simulatePlatform(.macOS)
    }
    
    /// Simulates watchOS platform with touch and haptic support
    public func simulateWatchOS() {
        simulatePlatform(.watchOS)
    }
    
    /// Simulates tvOS platform with accessibility only (no touch/hover/haptic)
    public func simulateTVOS() {
        simulatePlatform(.tvOS)
    }
    
    /// Simulates visionOS platform with touch, haptic, and hover support
    public func simulateVisionOS() {
        simulatePlatform(.visionOS)
    }
    
    // MARK: - Capability Override
    
    /// Overrides specific capabilities for testing edge cases
    /// - Parameters:
    ///   - touch: Touch support override
    ///   - haptic: Haptic feedback override
    ///   - hover: Hover support override
    ///   - voiceOver: VoiceOver support override
    ///   - switchControl: Switch Control support override
    ///   - assistiveTouch: AssistiveTouch support override
    public func overrideCapabilities(
        touch: Bool? = nil,
        haptic: Bool? = nil,
        hover: Bool? = nil,
        voiceOver: Bool? = nil,
        switchControl: Bool? = nil,
        assistiveTouch: Bool? = nil
    ) {
        if let touch = touch {
            RuntimeCapabilityDetection.setTestTouchSupport(touch)
        }
        if let haptic = haptic {
            RuntimeCapabilityDetection.setTestHapticFeedback(haptic)
        }
        if let hover = hover {
            RuntimeCapabilityDetection.setTestHover(hover)
        }
        if let voiceOver = voiceOver {
            RuntimeCapabilityDetection.setTestVoiceOver(voiceOver)
        }
        if let switchControl = switchControl {
            RuntimeCapabilityDetection.setTestSwitchControl(switchControl)
        }
        if let assistiveTouch = assistiveTouch {
            RuntimeCapabilityDetection.setTestAssistiveTouch(assistiveTouch)
        }
    }
    
    /// Clears all capability overrides
    public func clearAllCapabilityOverrides() {
        RuntimeCapabilityDetection.setTestTouchSupport(nil)
        RuntimeCapabilityDetection.setTestHapticFeedback(nil)
        RuntimeCapabilityDetection.setTestHover(nil)
        RuntimeCapabilityDetection.setTestVoiceOver(nil)
        RuntimeCapabilityDetection.setTestSwitchControl(nil)
        RuntimeCapabilityDetection.setTestAssistiveTouch(nil)
        RuntimeCapabilityDetection.setTestPlatform(nil)
    }
    
    // MARK: - Common Test Scenarios
    
    /// Sets up a touch-enabled platform (iOS/watchOS)
    public func setupTouchEnabledPlatform() {
        simulateiOS()
        overrideCapabilities(touch: true, haptic: true, hover: false)
    }
    
    /// Sets up a hover-enabled platform (macOS)
    public func setupHoverEnabledPlatform() {
        simulateMacOS()
        overrideCapabilities(touch: false, haptic: false, hover: true)
    }
    
    /// Sets up an accessibility-only platform (tvOS)
    public func setupAccessibilityOnlyPlatform() {
        simulateTVOS()
        overrideCapabilities(touch: false, haptic: false, hover: false, voiceOver: true, switchControl: true)
    }
    
    /// Sets up a vision-enabled platform (visionOS)
    public func setupVisionEnabledPlatform() {
        simulateVisionOS()
        overrideCapabilities(touch: true, haptic: true, hover: true, voiceOver: true, switchControl: true)
    }
    
    // MARK: - Test Assertion Helpers
    
    /// Asserts that the current platform configuration matches expected capabilities
    /// - Parameters:
    ///   - touch: Expected touch support
    ///   - haptic: Expected haptic support
    ///   - hover: Expected hover support
    ///   - voiceOver: Expected VoiceOver support
    ///   - switchControl: Expected Switch Control support
    ///   - assistiveTouch: Expected AssistiveTouch support
    ///   - file: File name for assertion
    ///   - line: Line number for assertion
    @MainActor
    public func assertPlatformCapabilities(
        touch: Bool? = nil,
        haptic: Bool? = nil,
        hover: Bool? = nil,
        voiceOver: Bool? = nil,
        switchControl: Bool? = nil,
        assistiveTouch: Bool? = nil,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        if let touch = touch {
            XCTAssertEqual(RuntimeCapabilityDetection.supportsTouch, touch, "Touch support should be \(touch)", file: file, line: line)
        }
        if let haptic = haptic {
            XCTAssertEqual(RuntimeCapabilityDetection.supportsHapticFeedback, haptic, "Haptic support should be \(haptic)", file: file, line: line)
        }
        if let hover = hover {
            XCTAssertEqual(RuntimeCapabilityDetection.supportsHover, hover, "Hover support should be \(hover)", file: file, line: line)
        }
        if let voiceOver = voiceOver {
            XCTAssertEqual(RuntimeCapabilityDetection.supportsVoiceOver, voiceOver, "VoiceOver support should be \(voiceOver)", file: file, line: line)
        }
        if let switchControl = switchControl {
            XCTAssertEqual(RuntimeCapabilityDetection.supportsSwitchControl, switchControl, "Switch Control support should be \(switchControl)", file: file, line: line)
        }
        if let assistiveTouch = assistiveTouch {
            XCTAssertEqual(RuntimeCapabilityDetection.supportsAssistiveTouch, assistiveTouch, "AssistiveTouch support should be \(assistiveTouch)", file: file, line: line)
        }
    }
    
    /// Asserts that a card expansion config matches expected capabilities
    /// - Parameters:
    ///   - config: The card expansion configuration to test
    ///   - touch: Expected touch support
    ///   - haptic: Expected haptic support
    ///   - hover: Expected hover support
    ///   - voiceOver: Expected VoiceOver support
    ///   - switchControl: Expected Switch Control support
    ///   - assistiveTouch: Expected AssistiveTouch support
    ///   - file: File name for assertion
    ///   - line: Line number for assertion
    public func assertCardExpansionConfig(
        _ config: CardExpansionPlatformConfig,
        touch: Bool? = nil,
        haptic: Bool? = nil,
        hover: Bool? = nil,
        voiceOver: Bool? = nil,
        switchControl: Bool? = nil,
        assistiveTouch: Bool? = nil,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        if let touch = touch {
            XCTAssertEqual(config.supportsTouch, touch, "Card config touch support should be \(touch)", file: file, line: line)
        }
        if let haptic = haptic {
            XCTAssertEqual(config.supportsHapticFeedback, haptic, "Card config haptic support should be \(haptic)", file: file, line: line)
        }
        if let hover = hover {
            XCTAssertEqual(config.supportsHover, hover, "Card config hover support should be \(hover)", file: file, line: line)
        }
        if let voiceOver = voiceOver {
            XCTAssertEqual(config.supportsVoiceOver, voiceOver, "Card config VoiceOver support should be \(voiceOver)", file: file, line: line)
        }
        if let switchControl = switchControl {
            XCTAssertEqual(config.supportsSwitchControl, switchControl, "Card config Switch Control support should be \(switchControl)", file: file, line: line)
        }
        if let assistiveTouch = assistiveTouch {
            XCTAssertEqual(config.supportsAssistiveTouch, assistiveTouch, "Card config AssistiveTouch support should be \(assistiveTouch)", file: file, line: line)
        }
    }
}

// MARK: - XCTestCase Extension

/// Convenience extension for XCTestCase to easily use TestSetupUtilities
public extension XCTestCase {
    
    /// Sets up the testing environment using centralized utilities
    @MainActor
    override func setupTestEnvironment() {
        TestSetupUtilities.shared.setupTestingEnvironment()
    }
    
    /// Cleans up the testing environment using centralized utilities
    @MainActor
    override func cleanupTestEnvironment() {
        TestSetupUtilities.shared.cleanupTestingEnvironment()
    }
    
    /// Simulates a specific platform for testing
    /// - Parameter platform: The platform to simulate
    @MainActor
    func simulatePlatform(_ platform: SixLayerPlatform) {
        TestSetupUtilities.shared.simulatePlatform(platform)
    }
    
    /// Sets up common test scenarios
    @MainActor
    func setupTouchEnabledPlatform() {
        TestSetupUtilities.shared.setupTouchEnabledPlatform()
    }
    
    @MainActor
    func setupHoverEnabledPlatform() {
        TestSetupUtilities.shared.setupHoverEnabledPlatform()
    }
    
    @MainActor
    func setupAccessibilityOnlyPlatform() {
        TestSetupUtilities.shared.setupAccessibilityOnlyPlatform()
    }
    
    @MainActor
    func setupVisionEnabledPlatform() {
        TestSetupUtilities.shared.setupVisionEnabledPlatform()
    }
}
