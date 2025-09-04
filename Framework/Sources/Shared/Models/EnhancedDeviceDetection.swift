//
//  EnhancedDeviceDetection.swift
//  SixLayerFramework
//
//  Enhanced device capability detection for all iPad and iPhone sizes
//

import Foundation
import SwiftUI

#if os(iOS)
import UIKit
#endif

// MARK: - Enhanced Device Detection

/// Comprehensive device detection system that handles all iPad and iPhone sizes
public struct EnhancedDeviceDetection {
    
    // MARK: - Device Size Categories
    
    /// iPhone size categories based on screen dimensions
    public enum iPhoneSizeCategory: String, CaseIterable {
        case mini = "mini"           // iPhone 12/13 mini, SE
        case standard = "standard"   // iPhone 12/13/14/15
        case plus = "plus"           // iPhone 12/13/14/15 Plus
        case pro = "pro"             // iPhone 12/13/14/15 Pro
        case proMax = "proMax"       // iPhone 12/13/14/15 Pro Max
        case unknown = "unknown"
        
        /// Detect iPhone size category from screen dimensions
        static func from(screenSize: CGSize) -> iPhoneSizeCategory {
            let width = screenSize.width
            let height = screenSize.height
            let minDimension = min(width, height)
            let maxDimension = max(width, height)
            
            // iPhone size detection based on screen dimensions
            switch (minDimension, maxDimension) {
            case (375, 667): // iPhone SE, 6s, 7, 8
                return .standard
            case (414, 736): // iPhone 6s Plus, 7 Plus, 8 Plus
                return .plus
            case (375, 812): // iPhone X, XS, 11 Pro, 12 mini, 13 mini
                return minDimension == 375 ? .mini : .standard
            case (414, 896): // iPhone XR, XS Max, 11, 11 Pro Max
                return .plus
            case (390, 844): // iPhone 12, 12 Pro, 13, 13 Pro, 14
                return .standard
            case (428, 926): // iPhone 12 Pro Max, 13 Pro Max, 14 Plus
                return .proMax
            case (393, 852): // iPhone 14 Pro
                return .pro
            case (430, 932): // iPhone 14 Pro Max
                return .proMax
            case (393, 852): // iPhone 15, 15 Plus
                return .standard
            case (430, 932): // iPhone 15 Pro, 15 Pro Max
                return .proMax
            default:
                // Fallback based on screen area
                let area = width * height
                switch area {
                case 0..<300000: return .mini
                case 300000..<400000: return .standard
                case 400000..<500000: return .plus
                case 500000..<600000: return .pro
                default: return .proMax
                }
            }
        }
    }
    
    /// iPad size categories based on screen dimensions
    public enum iPadSizeCategory: String, CaseIterable {
        case mini = "mini"           // iPad mini
        case standard = "standard"   // iPad, iPad Air
        case pro = "pro"             // iPad Pro 11"
        case proMax = "proMax"       // iPad Pro 12.9"
        case unknown = "unknown"
        
        /// Detect iPad size category from screen dimensions
        static func from(screenSize: CGSize) -> iPadSizeCategory {
            let width = screenSize.width
            let height = screenSize.height
            let minDimension = min(width, height)
            let maxDimension = max(width, height)
            
            // iPad size detection based on screen dimensions
            switch (minDimension, maxDimension) {
            case (768, 1024): // iPad, iPad Air (9.7", 10.2", 10.9")
                return .standard
            case (834, 1194): // iPad Air 4th gen, iPad Pro 11"
                return .pro
            case (1024, 1366): // iPad Pro 12.9"
                return .proMax
            case (744, 1133): // iPad mini 6
                return .mini
            case (820, 1180): // iPad Air 5th gen
                return .standard
            case (834, 1194): // iPad Pro 11" (3rd gen)
                return .pro
            case (1024, 1366): // iPad Pro 12.9" (6th gen)
                return .proMax
            default:
                // Fallback based on screen area
                let area = width * height
                switch area {
                case 0..<800000: return .mini
                case 800000..<1000000: return .standard
                case 1000000..<1200000: return .pro
                default: return .proMax
                }
            }
        }
    }
    
    // MARK: - Device Capabilities
    
    /// Enhanced device capabilities with detailed size information
    public struct EnhancedDeviceCapabilities {
        public let deviceType: DeviceType
        public let screenSize: CGSize
        public let orientation: DeviceOrientation
        public let memoryAvailable: Int64
        public let iPhoneSizeCategory: iPhoneSizeCategory?
        public let iPadSizeCategory: iPadSizeCategory?
        public let screenSizeClass: ScreenSizeClass
        public let supportsHapticFeedback: Bool
        public let supportsKeyboardShortcuts: Bool
        public let supportsContextMenus: Bool
        public let supportsSplitView: Bool
        public let supportsStageManager: Bool
        public let pixelDensity: CGFloat
        public let safeAreaInsets: EdgeInsets
        
        public init() {
            #if os(iOS)
            let screen = UIScreen.main
            self.screenSize = screen.bounds.size
            self.orientation = DeviceOrientation.fromUIDeviceOrientation(UIDevice.current.orientation)
            self.pixelDensity = screen.scale
            self.safeAreaInsets = EdgeInsets(
                top: screen.safeAreaInsets.top,
                leading: screen.safeAreaInsets.left,
                bottom: screen.safeAreaInsets.bottom,
                trailing: screen.safeAreaInsets.right
            )
            
            // Device type detection
            if UIDevice.current.userInterfaceIdiom == .pad {
                self.deviceType = .pad
                self.iPadSizeCategory = iPadSizeCategory.from(screenSize: screenSize)
                self.iPhoneSizeCategory = nil
                self.supportsSplitView = true
                self.supportsStageManager = true
            } else {
                self.deviceType = .phone
                self.iPhoneSizeCategory = iPhoneSizeCategory.from(screenSize: screenSize)
                self.iPadSizeCategory = nil
                self.supportsSplitView = false
                self.supportsStageManager = false
            }
            #elseif os(macOS)
            self.screenSize = CGSize(width: 1024, height: 768) // Default macOS size
            self.orientation = .landscape
            self.deviceType = .mac
            self.iPhoneSizeCategory = nil
            self.iPadSizeCategory = nil
            self.pixelDensity = 1.0
            self.safeAreaInsets = EdgeInsets()
            self.supportsSplitView = false
            self.supportsStageManager = false
            #else
            self.screenSize = CGSize(width: 375, height: 667) // Default fallback
            self.orientation = .portrait
            self.deviceType = .phone
            self.iPhoneSizeCategory = .unknown
            self.iPadSizeCategory = nil
            self.pixelDensity = 1.0
            self.safeAreaInsets = EdgeInsets()
            self.supportsSplitView = false
            self.supportsStageManager = false
            #endif
            
            // Screen size class calculation
            self.screenSizeClass = ScreenSizeClass.horizontal(width: screenSize.width)
            
            // Capability detection
            self.supportsHapticFeedback = deviceType == .phone
            self.supportsKeyboardShortcuts = deviceType == .mac
            self.supportsContextMenus = deviceType == .mac || deviceType == .pad
            
            // Memory estimation based on device type and size
            self.memoryAvailable = Self.estimateMemoryAvailable(
                deviceType: deviceType,
                screenSize: screenSize,
                iPhoneSize: iPhoneSizeCategory,
                iPadSize: iPadSizeCategory
            )
        }
        
        /// Custom initializer for testing and specific configurations
        public init(
            deviceType: DeviceType,
            screenSize: CGSize,
            orientation: DeviceOrientation,
            memoryAvailable: Int64,
            iPhoneSizeCategory: iPhoneSizeCategory?,
            iPadSizeCategory: iPadSizeCategory?,
            screenSizeClass: ScreenSizeClass,
            supportsHapticFeedback: Bool,
            supportsKeyboardShortcuts: Bool,
            supportsContextMenus: Bool,
            supportsSplitView: Bool,
            supportsStageManager: Bool,
            pixelDensity: CGFloat,
            safeAreaInsets: EdgeInsets
        ) {
            self.deviceType = deviceType
            self.screenSize = screenSize
            self.orientation = orientation
            self.memoryAvailable = memoryAvailable
            self.iPhoneSizeCategory = iPhoneSizeCategory
            self.iPadSizeCategory = iPadSizeCategory
            self.screenSizeClass = screenSizeClass
            self.supportsHapticFeedback = supportsHapticFeedback
            self.supportsKeyboardShortcuts = supportsKeyboardShortcuts
            self.supportsContextMenus = supportsContextMenus
            self.supportsSplitView = supportsSplitView
            self.supportsStageManager = supportsStageManager
            self.pixelDensity = pixelDensity
            self.safeAreaInsets = safeAreaInsets
        }
        
        /// Estimate available memory based on device characteristics
        private static func estimateMemoryAvailable(
            deviceType: DeviceType,
            screenSize: CGSize,
            iPhoneSize: iPhoneSizeCategory?,
            iPadSize: iPadSizeCategory?
        ) -> Int64 {
            let baseMemory: Int64 = 1024 * 1024 * 1024 // 1GB base
            
            switch deviceType {
            case .phone:
                switch iPhoneSize {
                case .mini, .standard:
                    return baseMemory * 2 // 2GB
                case .plus, .pro:
                    return baseMemory * 4 // 4GB
                case .proMax:
                    return baseMemory * 6 // 6GB
                case .unknown:
                    return baseMemory * 2 // 2GB fallback
                case .none:
                    return baseMemory * 2
                }
            case .pad:
                switch iPadSize {
                case .mini:
                    return baseMemory * 3 // 3GB
                case .standard:
                    return baseMemory * 4 // 4GB
                case .pro:
                    return baseMemory * 8 // 8GB
                case .proMax:
                    return baseMemory * 12 // 12GB
                case .unknown:
                    return baseMemory * 4 // 4GB fallback
                case .none:
                    return baseMemory * 4
                }
            case .mac:
                return baseMemory * 8 // 8GB
            case .tv:
                return baseMemory * 4 // 4GB
            case .watch:
                return baseMemory / 4 // 256MB
            }
        }
    }
    
    // MARK: - Public API
    
    /// Get current device capabilities with enhanced detection
    @MainActor
    public static func getCurrentCapabilities() -> EnhancedDeviceCapabilities {
        return EnhancedDeviceCapabilities()
    }
    
    /// Get device capabilities for a specific screen size (useful for testing)
    public static func getCapabilitiesForScreenSize(
        _ size: CGSize,
        deviceType: DeviceType,
        orientation: DeviceOrientation = .portrait
    ) -> EnhancedDeviceCapabilities {
        var capabilities = EnhancedDeviceCapabilities()
        
        // Override with provided values
        capabilities = EnhancedDeviceCapabilities(
            deviceType: deviceType,
            screenSize: size,
            orientation: orientation,
            memoryAvailable: capabilities.memoryAvailable,
            iPhoneSizeCategory: deviceType == .phone ? iPhoneSizeCategory.from(screenSize: size) : nil,
            iPadSizeCategory: deviceType == .pad ? iPadSizeCategory.from(screenSize: size) : nil,
            screenSizeClass: ScreenSizeClass.horizontal(width: size.width),
            supportsHapticFeedback: deviceType == .phone,
            supportsKeyboardShortcuts: deviceType == .mac,
            supportsContextMenus: deviceType == .mac || deviceType == .pad,
            supportsSplitView: deviceType == .pad,
            supportsStageManager: deviceType == .pad,
            pixelDensity: capabilities.pixelDensity,
            safeAreaInsets: capabilities.safeAreaInsets
        )
        
        return capabilities
    }
}

// MARK: - Screen Size Class Extension

extension ScreenSizeClass {
    /// Get detailed size class information
    public var description: String {
        switch self {
        case .compact:
            return "Compact"
        case .regular:
            return "Regular"
        case .large:
            return "Large"
        }
    }
    
    /// Check if size class supports specific features
    public var supportsMultiColumn: Bool {
        switch self {
        case .compact:
            return false
        case .regular, .large:
            return true
        }
    }
    
    /// Get recommended column count for this size class
    public var recommendedColumns: Int {
        switch self {
        case .compact:
            return 1
        case .regular:
            return 2
        case .large:
            return 3
        }
    }
}

// MARK: - Device Type Extensions

extension DeviceType {
    /// Get detailed device information
    public var detailedDescription: String {
        switch self {
        case .phone:
            return "iPhone"
        case .pad:
            return "iPad"
        case .mac:
            return "Mac"
        case .tv:
            return "Apple TV"
        case .watch:
            return "Apple Watch"
        }
    }
    
    /// Check if device supports specific features
    public var supportsHapticFeedback: Bool {
        return self == .phone
    }
    
    public var supportsKeyboardShortcuts: Bool {
        return self == .mac
    }
    
    public var supportsContextMenus: Bool {
        return self == .mac || self == .pad
    }
    
    public var supportsSplitView: Bool {
        return self == .pad
    }
    
    public var supportsStageManager: Bool {
        return self == .pad
    }
}
