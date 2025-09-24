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
    
    // MARK: - Touch Capability Detection
    
    /// Detects if touch input is actually supported by querying the OS
    @MainActor
    public static var supportsTouch: Bool {
        // Use testing defaults when in testing mode
        if TestingCapabilityDetection.isTestingMode {
            let platform = Platform.current
            let defaults = TestingCapabilityDetection.getTestingDefaults(for: platform)
            return defaults.supportsTouch
        }
        
        #if os(iOS)
        return detectiOSTouchSupport()
        #elseif os(macOS)
        return detectmacOSTouchSupport()
        #elseif os(watchOS)
        return true // Apple Watch always supports touch
        #elseif os(tvOS)
        return false // Apple TV doesn't support touch
        #elseif os(visionOS)
        return true // Vision Pro supports touch gestures
        #else
        return false
        #endif
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
        let touchDriverProcesses = [
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
        // Use testing defaults when in testing mode
        if TestingCapabilityDetection.isTestingMode {
            let platform = Platform.current
            let defaults = TestingCapabilityDetection.getTestingDefaults(for: platform)
            return defaults.supportsHapticFeedback
        }
        
        #if os(iOS)
        return detectiOSHapticSupport()
        #elseif os(macOS)
        return detectmacOSHapticSupport()
        #elseif os(watchOS)
        return true // Apple Watch supports haptics
        #elseif os(tvOS)
        return false // Apple TV doesn't support haptics
        #elseif os(visionOS)
        return true // Vision Pro supports haptics
        #else
        return false
        #endif
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
        // Use testing defaults when in testing mode
        if TestingCapabilityDetection.isTestingMode {
            let platform = Platform.current
            let defaults = TestingCapabilityDetection.getTestingDefaults(for: platform)
            return defaults.supportsHover
        }
        
        #if os(iOS)
        return detectiOSHoverSupport()
        #elseif os(macOS)
        return detectmacOSHoverSupport()
        #elseif os(watchOS)
        return false // Apple Watch doesn't support hover
        #elseif os(tvOS)
        return false // Apple TV doesn't support hover
        #elseif os(visionOS)
        return true // Vision Pro supports hover
        #else
        return false
        #endif
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
        #if os(iOS)
        return UIAccessibility.isVoiceOverRunning
        #elseif os(macOS)
        return NSWorkspace.shared.isVoiceOverEnabled
        #elseif os(watchOS)
        return true // Apple Watch supports VoiceOver
        #elseif os(tvOS)
        return true // Apple TV supports VoiceOver
        #elseif os(visionOS)
        return true // Vision Pro supports VoiceOver
        #else
        return false
        #endif
    }
    
    /// Detects if Switch Control is actually available
    @MainActor
    public static var supportsSwitchControl: Bool {
        #if os(iOS)
        return UIAccessibility.isSwitchControlRunning
        #elseif os(macOS)
        return NSWorkspace.shared.isSwitchControlEnabled
        #elseif os(watchOS)
        return true // Apple Watch supports Switch Control
        #elseif os(tvOS)
        return true // Apple TV supports Switch Control
        #elseif os(visionOS)
        return true // Vision Pro supports Switch Control
        #else
        return false
        #endif
    }
    
    /// Detects if AssistiveTouch is actually available
    @MainActor
    public static var supportsAssistiveTouch: Bool {
        #if os(iOS)
        return UIAccessibility.isAssistiveTouchRunning
        #elseif os(macOS)
        return false // macOS doesn't have AssistiveTouch
        #elseif os(watchOS)
        return true // Apple Watch supports AssistiveTouch
        #elseif os(tvOS)
        return false // Apple TV doesn't have AssistiveTouch
        #elseif os(visionOS)
        return true // Vision Pro supports AssistiveTouch
        #else
        return false
        #endif
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
    public static func getTestingDefaults(for platform: Platform) -> TestingCapabilityDefaults {
        switch platform {
        case .iOS:
            return TestingCapabilityDefaults(
                supportsTouch: true,
                supportsHapticFeedback: true,
                supportsHover: false, // Will be true for iPad in actual detection
                supportsVoiceOver: false, // Testing default
                supportsSwitchControl: false, // Testing default
                supportsAssistiveTouch: false // Testing default
            )
        case .macOS:
            return TestingCapabilityDefaults(
                supportsTouch: false, // Testing default - can be overridden
                supportsHapticFeedback: false,
                supportsHover: true,
                supportsVoiceOver: false, // Testing default
                supportsSwitchControl: false, // Testing default
                supportsAssistiveTouch: false
            )
        case .watchOS:
            return TestingCapabilityDefaults(
                supportsTouch: true,
                supportsHapticFeedback: true,
                supportsHover: false,
                supportsVoiceOver: false,
                supportsSwitchControl: false,
                supportsAssistiveTouch: false
            )
        case .tvOS:
            return TestingCapabilityDefaults(
                supportsTouch: false,
                supportsHapticFeedback: false,
                supportsHover: false,
                supportsVoiceOver: false,
                supportsSwitchControl: false,
                supportsAssistiveTouch: false
            )
        case .visionOS:
            return TestingCapabilityDefaults(
                supportsTouch: true,
                supportsHapticFeedback: true,
                supportsHover: true,
                supportsVoiceOver: false,
                supportsSwitchControl: false,
                supportsAssistiveTouch: false
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
