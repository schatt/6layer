//
//  LiquidGlassCapabilityDetection.swift
//  SixLayerFramework
//
//  Capability detection for Liquid Glass design system
//

import Foundation
import SwiftUI

#if os(iOS)
import UIKit
#endif

// MARK: - Liquid Glass Capability Detection

/// Capability detection system for Liquid Glass design features
public struct LiquidGlassCapabilityDetection {
    
    /// Check if Liquid Glass is supported on the current platform
    public static var isSupported: Bool {
        #if os(iOS)
        if #available(iOS 26.0, *) {
            return true
        }
        #elseif os(macOS)
        if #available(macOS 26.0, *) {
            return true
        }
        #endif
        return false
    }
    
    /// Get the current platform's Liquid Glass support level
    public static var supportLevel: LiquidGlassSupportLevel {
        if isSupported {
            return .full
        } else {
            return .fallback
        }
    }
    
    /// Check if specific Liquid Glass features are available
    public static func isFeatureAvailable(_ feature: LiquidGlassFeature) -> Bool {
        guard isSupported else { return false }
        
        switch feature {
        case .materials:
            return true
        case .floatingControls:
            return true
        case .contextualMenus:
            return true
        case .adaptiveWallpapers:
            return true
        case .dynamicReflections:
            return true
        }
    }
    
    /// Get fallback behavior for unsupported features
    public static func getFallbackBehavior(for feature: LiquidGlassFeature) -> LiquidGlassFallbackBehavior {
        switch feature {
        case .materials:
            return .opaqueBackground
        case .floatingControls:
            return .standardControls
        case .contextualMenus:
            return .standardMenus
        case .adaptiveWallpapers:
            return .staticWallpapers
        case .dynamicReflections:
            return .noReflections
        }
    }
}

// MARK: - Support Levels

public enum LiquidGlassSupportLevel: String, CaseIterable {
    case full = "full"
    case fallback = "fallback"
    case unsupported = "unsupported"
}

// MARK: - Features

public enum LiquidGlassFeature: String, CaseIterable {
    case materials = "materials"
    case floatingControls = "floatingControls"
    case contextualMenus = "contextualMenus"
    case adaptiveWallpapers = "adaptiveWallpapers"
    case dynamicReflections = "dynamicReflections"
}

// MARK: - Fallback Behaviors

public enum LiquidGlassFallbackBehavior: String, CaseIterable {
    case opaqueBackground = "opaqueBackground"
    case standardControls = "standardControls"
    case standardMenus = "standardMenus"
    case staticWallpapers = "staticWallpapers"
    case noReflections = "noReflections"
}

// MARK: - Capability Info

public struct LiquidGlassCapabilityInfo {
    public let isSupported: Bool
    public let supportLevel: LiquidGlassSupportLevel
    public let availableFeatures: [LiquidGlassFeature]
    public let fallbackBehaviors: [LiquidGlassFeature: LiquidGlassFallbackBehavior]
    
    public init() {
        self.isSupported = LiquidGlassCapabilityDetection.isSupported
        self.supportLevel = LiquidGlassCapabilityDetection.supportLevel
        self.availableFeatures = LiquidGlassFeature.allCases.filter { 
            LiquidGlassCapabilityDetection.isFeatureAvailable($0) 
        }
        self.fallbackBehaviors = Dictionary(uniqueKeysWithValues: 
            LiquidGlassFeature.allCases.map { feature in
                (feature, LiquidGlassCapabilityDetection.getFallbackBehavior(for: feature))
            }
        )
    }
}

// MARK: - Platform-Specific Detection

extension LiquidGlassCapabilityDetection {
    
    /// Get platform-specific capability information
    public static func getPlatformCapabilities() -> LiquidGlassCapabilityInfo {
        return LiquidGlassCapabilityInfo()
    }
    
    /// Check if the current device supports Liquid Glass hardware requirements
    public static var supportsHardwareRequirements: Bool {
        #if os(iOS)
        // Check for Metal support and sufficient GPU capabilities
        return true // Simplified for now
        #elseif os(macOS)
        // Check for Metal support and sufficient GPU capabilities
        return true // Simplified for now
        #else
        return false
        #endif
    }
    
    /// Get recommended fallback UI approach
    public static var recommendedFallbackApproach: String {
        if isSupported {
            return "Use full Liquid Glass features"
        } else {
            return "Use standard UI components with enhanced styling"
        }
    }
}
