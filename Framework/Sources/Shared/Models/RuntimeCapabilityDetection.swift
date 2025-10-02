//
//  RuntimeCapabilityDetection.swift
//  SixLayerFramework
//
//  Runtime capability detection that queries the OS instead of hardcoding platform assumptions
//

import Foundation
import SwiftUI

#if os(iOS)
import UIKit
#endif

#if os(macOS)
import AppKit
#endif

// MARK: - Runtime Capability Detection

/// Runtime capability detection that queries the OS for actual hardware/software capabilities
/// instead of making assumptions based on platform
public struct RuntimeCapabilityDetection {
    
    // MARK: - Thread-Local Testing Support
    
    /// Thread-local test platform for simulating cross-platform behavior
    /// When set, all capability detection functions will return values for the simulated platform
    public static func setTestPlatform(_ platform: SixLayerPlatform?) {
        Thread.current.threadDictionary["testPlatform"] = platform
    }
    
    /// Get the current test platform for this thread
    internal static var testPlatform: SixLayerPlatform? {
        return Thread.current.threadDictionary["testPlatform"] as? SixLayerPlatform
    }
    
    /// Get the current platform (test platform if set, otherwise actual platform)
    public static var currentPlatform: SixLayerPlatform {
        return SixLayerPlatform.currentPlatform
    }
    
    /// Get platform-specific defaults for the current test platform
    private static func getTestDefaults() -> TestingCapabilityDefaults {
        guard let platform = testPlatform else {
            return TestingCapabilityDetection.getTestingDefaults(for: SixLayerPlatform.current)
        }
        return TestingCapabilityDetection.getTestingDefaults(for: platform)
    }
    
    // MARK: - Capability-Level Override Support
    
    /// Override touch support detection for testing
    public static func setTestTouchSupport(_ value: Bool?) {
        Thread.current.threadDictionary["testTouchSupport"] = value
    }
    
    /// Override haptic feedback detection for testing
    public static func setTestHapticFeedback(_ value: Bool?) {
        Thread.current.threadDictionary["testHapticFeedback"] = value
    }
    
    /// Override hover detection for testing
    public static func setTestHover(_ value: Bool?) {
        Thread.current.threadDictionary["testHover"] = value
    }
    
    /// Override VoiceOver detection for testing
    public static func setTestVoiceOver(_ value: Bool?) {
        Thread.current.threadDictionary["testVoiceOver"] = value
    }
    
    /// Override Switch Control detection for testing
    public static func setTestSwitchControl(_ value: Bool?) {
        Thread.current.threadDictionary["testSwitchControl"] = value
    }
    
    /// Override AssistiveTouch detection for testing
    public static func setTestAssistiveTouch(_ value: Bool?) {
        Thread.current.threadDictionary["testAssistiveTouch"] = value
    }
    
    /// Clear all capability overrides
    public static func clearAllCapabilityOverrides() {
        Thread.current.threadDictionary.removeObject(forKey: "testTouchSupport")
        Thread.current.threadDictionary.removeObject(forKey: "testHapticFeedback")
        Thread.current.threadDictionary.removeObject(forKey: "testHover")
        Thread.current.threadDictionary.removeObject(forKey: "testVoiceOver")
        Thread.current.threadDictionary.removeObject(forKey: "testSwitchControl")
        Thread.current.threadDictionary.removeObject(forKey: "testAssistiveTouch")
    }
    
    // MARK: - Private Capability Override Getters
    
    private static var testTouchSupport: Bool? {
        return Thread.current.threadDictionary["testTouchSupport"] as? Bool
    }
    
    private static var testHapticFeedback: Bool? {
        return Thread.current.threadDictionary["testHapticFeedback"] as? Bool
    }
    
    private static var testHover: Bool? {
        return Thread.current.threadDictionary["testHover"] as? Bool
    }
    
    private static var testVoiceOver: Bool? {
        return Thread.current.threadDictionary["testVoiceOver"] as? Bool
    }
    
    private static var testSwitchControl: Bool? {
        return Thread.current.threadDictionary["testSwitchControl"] as? Bool
    }
    
    private static var testAssistiveTouch: Bool? {
        return Thread.current.threadDictionary["testAssistiveTouch"] as? Bool
    }
    
    // MARK: - Touch Capability Detection
    
    /// Detects if touch input is actually supported by querying the OS
    @MainActor
    public static var supportsTouch: Bool {
        // Check for capability override first
        if let testValue = testTouchSupport {
            return testValue
        }
        
        let platform = currentPlatform
        switch platform {
        case .iOS:
            #if os(iOS)
            return detectiOSTouchSupport()
            #else
            return getTestDefaults().supportsTouch
            #endif
        case .macOS:
            #if os(macOS)
            return detectmacOSTouchSupport()
            #else
            return getTestDefaults().supportsTouch
            #endif
        case .watchOS:
            #if os(watchOS)
            return true // Apple Watch always supports touch
            #else
            return getTestDefaults().supportsTouch
            #endif
        case .tvOS:
            #if os(tvOS)
            return false // Apple TV doesn't support touch
            #else
            return getTestDefaults().supportsTouch
            #endif
        case .visionOS:
            #if os(visionOS)
            return true // Vision Pro supports touch gestures
            #else
            return getTestDefaults().supportsTouch
            #endif
        }
    }
    
    #if os(iOS)
    /// iOS touch detection - checks for actual touch capability
    private static func detectiOSTouchSupport() -> Bool {
        // iOS always supports touch, but we can check for specific capabilities
        return true
    }
    #endif
    
    #if os(macOS)
    /// macOS touch detection - checks for third-party touch drivers or native support
    private static func detectmacOSTouchSupport() -> Bool {
        // Check if we're running on a Mac with touch capability
        // This could be through third-party drivers or future native support
        
        // Method 1: Check for touch events in the current session
        if canDetectTouchEvents() {
            return true
        }
        
        // Method 2: Check for third-party touch driver processes
        if hasThirdPartyTouchDrivers() {
            return true
        }
        
        // Method 3: Check system preferences or environment variables
        if isTouchEnabledInSystemPreferences() {
            return true
        }
        
        return false
    }
    
    /// Check if we can detect touch events in the current session
    private static func canDetectTouchEvents() -> Bool {
        // Try to detect if touch events are being processed
        // This is a placeholder - would need actual implementation
        return false
    }
    
    /// Check for third-party touch driver processes
    private static func hasThirdPartyTouchDrivers() -> Bool {
        // Check for common touch driver processes
        let _ = [
            "UPDD",           // Universal Pointer Device Driver
            "TouchBase",      // TouchBase driver
            "EloTouch",       // Elo Touch driver
            "PlanarTouch",    // Planar touch driver
        ]
        
        // This would require checking running processes
        // For now, return false as we don't have process checking implemented
        return false
    }
    
    /// Check if touch is enabled in system preferences
    private static func isTouchEnabledInSystemPreferences() -> Bool {
        // Check UserDefaults or system preferences for touch enablement
        // This could be set by third-party drivers or user configuration
        return UserDefaults.standard.bool(forKey: "SixLayerFramework.TouchEnabled")
    }
    #endif
    
    // MARK: - Haptic Feedback Detection
    
    /// Detects if haptic feedback is actually supported
    @MainActor
    public static var supportsHapticFeedback: Bool {
        // Check for capability override first
        if let testValue = testHapticFeedback {
            return testValue
        }
        
        let platform = currentPlatform
        switch platform {
        case .iOS:
            #if os(iOS)
            return detectiOSHapticSupport()
            #else
            return getTestDefaults().supportsHapticFeedback
            #endif
        case .macOS:
            #if os(macOS)
            return detectmacOSHapticSupport()
            #else
            return getTestDefaults().supportsHapticFeedback
            #endif
        case .watchOS:
            #if os(watchOS)
            return true // Apple Watch supports haptics
            #else
            return getTestDefaults().supportsHapticFeedback
            #endif
        case .tvOS:
            #if os(tvOS)
            return false // Apple TV doesn't support haptics
            #else
            return getTestDefaults().supportsHapticFeedback
            #endif
        case .visionOS:
            #if os(visionOS)
            return true // Vision Pro supports haptics
            #else
            return getTestDefaults().supportsHapticFeedback
            #endif
        }
    }
    
    #if os(iOS)
    private static func detectiOSHapticSupport() -> Bool {
        // iOS devices support haptic feedback
        return true
    }
    #endif
    
    #if os(macOS)
    private static func detectmacOSHapticSupport() -> Bool {
        // macOS doesn't natively support haptic feedback
        // But could be enabled through third-party solutions
        return UserDefaults.standard.bool(forKey: "SixLayerFramework.HapticEnabled")
    }
    #endif
    
    // MARK: - Hover Detection
    
    /// Detects if hover events are actually supported
    @MainActor
    public static var supportsHover: Bool {
        // Check for capability override first
        if let testValue = testHover {
            return testValue
        }
        
        let platform = currentPlatform
        switch platform {
        case .iOS:
            #if os(iOS)
            return detectiOSHoverSupport()
            #else
            return getTestDefaults().supportsHover
            #endif
        case .macOS:
            #if os(macOS)
            return detectmacOSHoverSupport()
            #else
            return getTestDefaults().supportsHover
            #endif
        case .watchOS:
            #if os(watchOS)
            return false // Apple Watch doesn't support hover
            #else
            return getTestDefaults().supportsHover
            #endif
        case .tvOS:
            #if os(tvOS)
            return false // Apple TV doesn't support hover
            #else
            return getTestDefaults().supportsHover
            #endif
        case .visionOS:
            #if os(visionOS)
            return true // Vision Pro supports hover
            #else
            return getTestDefaults().supportsHover
            #endif
        }
    }
    
    #if os(iOS)
    private static func detectiOSHoverSupport() -> Bool {
        // Check if we're on iPad with Apple Pencil or hover-capable device
        if UIDevice.current.userInterfaceIdiom == .pad {
            // iPad with Apple Pencil 2 or later supports hover
            return true
        }
        return false
    }
    #endif
    
    #if os(macOS)
    private static func detectmacOSHoverSupport() -> Bool {
        // macOS supports hover through mouse/trackpad
        return true
    }
    #endif
    
    // MARK: - Accessibility Support Detection
    
    /// Detects if VoiceOver is actually available
    @MainActor
    public static var supportsVoiceOver: Bool {
        // Check for capability override first
        if let testValue = testVoiceOver {
            return testValue
        }
        
        let platform = currentPlatform
        switch platform {
        case .iOS:
            #if os(iOS)
            return UIAccessibility.isVoiceOverRunning
            #else
            return getTestDefaults().supportsVoiceOver
            #endif
        case .macOS:
            #if os(macOS)
            return NSWorkspace.shared.isVoiceOverEnabled
            #else
            return getTestDefaults().supportsVoiceOver
            #endif
        case .watchOS:
            #if os(watchOS)
            return true // Apple Watch supports VoiceOver
            #else
            return getTestDefaults().supportsVoiceOver
            #endif
        case .tvOS:
            #if os(tvOS)
            return true // Apple TV supports VoiceOver
            #else
            return getTestDefaults().supportsVoiceOver
            #endif
        case .visionOS:
            #if os(visionOS)
            return true // Vision Pro supports VoiceOver
            #else
            return getTestDefaults().supportsVoiceOver
            #endif
        }
    }
    
    /// Detects if Switch Control is actually available
    @MainActor
    public static var supportsSwitchControl: Bool {
        // Check for capability override first
        if let testValue = testSwitchControl {
            return testValue
        }
        
        let platform = currentPlatform
        switch platform {
        case .iOS:
            #if os(iOS)
            return UIAccessibility.isSwitchControlRunning
            #else
            return getTestDefaults().supportsSwitchControl
            #endif
        case .macOS:
            #if os(macOS)
            return NSWorkspace.shared.isSwitchControlEnabled
            #else
            return getTestDefaults().supportsSwitchControl
            #endif
        case .watchOS:
            #if os(watchOS)
            return true // Apple Watch supports Switch Control
            #else
            return getTestDefaults().supportsSwitchControl
            #endif
        case .tvOS:
            #if os(tvOS)
            return true // Apple TV supports Switch Control
            #else
            return getTestDefaults().supportsSwitchControl
            #endif
        case .visionOS:
            #if os(visionOS)
            return true // Vision Pro supports Switch Control
            #else
            return getTestDefaults().supportsSwitchControl
            #endif
        }
    }
    
    /// Detects if AssistiveTouch is actually available
    @MainActor
    public static var supportsAssistiveTouch: Bool {
        // Check for capability override first
        if let testValue = testAssistiveTouch {
            return testValue
        }
        
        let platform = currentPlatform
        switch platform {
        case .iOS:
            #if os(iOS)
            return UIAccessibility.isAssistiveTouchRunning
            #else
            return getTestDefaults().supportsAssistiveTouch
            #endif
        case .macOS:
            return false // macOS doesn't have AssistiveTouch
        case .watchOS:
            #if os(watchOS)
            return true // Apple Watch supports AssistiveTouch
            #else
            return getTestDefaults().supportsAssistiveTouch
            #endif
        case .tvOS:
            return false // Apple TV doesn't have AssistiveTouch
        case .visionOS:
            #if os(visionOS)
            return true // Vision Pro supports AssistiveTouch
            #else
            return getTestDefaults().supportsAssistiveTouch
            #endif
        }
    }
}

// MARK: - Testing Configuration

/// Testing-specific capability detection with predictable defaults
public struct TestingCapabilityDetection {
    
    /// Whether we're currently in testing mode
    public static var isTestingMode: Bool {
        #if DEBUG
        // Check for XCTest environment variables
        let environment = ProcessInfo.processInfo.environment
        return environment["XCTestConfigurationFilePath"] != nil ||
               environment["XCTestSessionIdentifier"] != nil ||
               environment["XCTestBundlePath"] != nil ||
               NSClassFromString("XCTestCase") != nil
        #else
        return false
        #endif
    }
    
    /// Get testing defaults for each platform
    public static func getTestingDefaults(for platform: SixLayerPlatform) -> TestingCapabilityDefaults {
        switch platform {
        case .iOS:
            return TestingCapabilityDefaults(
                supportsTouch: true,
                supportsHapticFeedback: true,
                supportsHover: false, // Will be true for iPad in actual detection
                supportsVoiceOver: true, // iOS supports VoiceOver
                supportsSwitchControl: true, // iOS supports Switch Control
                supportsAssistiveTouch: true // iOS supports AssistiveTouch
            )
        case .macOS:
            return TestingCapabilityDefaults(
                supportsTouch: false, // Testing default - can be overridden
                supportsHapticFeedback: false,
                supportsHover: true,
                supportsVoiceOver: false, // Testing default - macOS doesn't have VoiceOver enabled by default
                supportsSwitchControl: false, // Testing default - macOS doesn't have Switch Control enabled by default
                supportsAssistiveTouch: false
            )
        case .watchOS:
            return TestingCapabilityDefaults(
                supportsTouch: true,
                supportsHapticFeedback: true,
                supportsHover: false,
                supportsVoiceOver: true, // Apple Watch supports VoiceOver
                supportsSwitchControl: true, // Apple Watch supports Switch Control
                supportsAssistiveTouch: true // Apple Watch supports AssistiveTouch
            )
        case .tvOS:
            return TestingCapabilityDefaults(
                supportsTouch: false,
                supportsHapticFeedback: false,
                supportsHover: false,
                supportsVoiceOver: true, // Apple TV supports VoiceOver
                supportsSwitchControl: true, // Apple TV supports Switch Control
                supportsAssistiveTouch: false // Apple TV doesn't have AssistiveTouch
            )
        case .visionOS:
            return TestingCapabilityDefaults(
                supportsTouch: true,
                supportsHapticFeedback: true,
                supportsHover: true,
                supportsVoiceOver: true, // Vision Pro supports VoiceOver
                supportsSwitchControl: true, // Vision Pro supports Switch Control
                supportsAssistiveTouch: true // Vision Pro supports AssistiveTouch
            )
        }
    }
}

/// Testing capability defaults for predictable test behavior
public struct TestingCapabilityDefaults {
    public let supportsTouch: Bool
    public let supportsHapticFeedback: Bool
    public let supportsHover: Bool
    public let supportsVoiceOver: Bool
    public let supportsSwitchControl: Bool
    public let supportsAssistiveTouch: Bool
}

// MARK: - Configuration Override

/// Allows users to override capability detection for testing or special configurations
public struct CapabilityOverride {
    
    /// Override touch support (useful for testing with external touchscreens)
    public static var touchSupport: Bool? {
        get {
            let value = UserDefaults.standard.object(forKey: "SixLayerFramework.Override.TouchSupport")
            return value as? Bool
        }
        set {
            if let newValue = newValue {
                UserDefaults.standard.set(newValue, forKey: "SixLayerFramework.Override.TouchSupport")
            } else {
                UserDefaults.standard.removeObject(forKey: "SixLayerFramework.Override.TouchSupport")
            }
        }
    }
    
    /// Override haptic feedback support
    public static var hapticSupport: Bool? {
        get {
            let value = UserDefaults.standard.object(forKey: "SixLayerFramework.Override.HapticSupport")
            return value as? Bool
        }
        set {
            if let newValue = newValue {
                UserDefaults.standard.set(newValue, forKey: "SixLayerFramework.Override.HapticSupport")
            } else {
                UserDefaults.standard.removeObject(forKey: "SixLayerFramework.Override.HapticSupport")
            }
        }
    }
    
    /// Override hover support
    public static var hoverSupport: Bool? {
        get {
            let value = UserDefaults.standard.object(forKey: "SixLayerFramework.Override.HoverSupport")
            return value as? Bool
        }
        set {
            if let newValue = newValue {
                UserDefaults.standard.set(newValue, forKey: "SixLayerFramework.Override.HoverSupport")
            } else {
                UserDefaults.standard.removeObject(forKey: "SixLayerFramework.Override.HoverSupport")
            }
        }
    }
}

// MARK: - Enhanced Runtime Detection with Overrides

public extension RuntimeCapabilityDetection {
    
    /// Touch support with override capability
    @MainActor
    static var supportsTouchWithOverride: Bool {
        if let override = CapabilityOverride.touchSupport {
            return override
        }
        return supportsTouch
    }
    
    /// Haptic feedback support with override capability
    @MainActor
    static var supportsHapticFeedbackWithOverride: Bool {
        if let override = CapabilityOverride.hapticSupport {
            return override
        }
        return supportsHapticFeedback
    }
    
    /// Hover support with override capability
    @MainActor
    static var supportsHoverWithOverride: Bool {
        if let override = CapabilityOverride.hoverSupport {
            return override
        }
        return supportsHover
    }
}
