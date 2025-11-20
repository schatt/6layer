//
//  PlatformNavigationStackEnhancementsLayer6.swift
//  SixLayerFramework
//
//  Layer 6: Cross-Platform NavigationStack Enhancements
//  Platform-specific enhancements for NavigationStack
//

import SwiftUI

// MARK: - Layer 6: Cross-Platform NavigationStack Enhancements

/// Platform-specific enhancements for NavigationStack
/// Automatically applies iOS or macOS enhancements based on platform

public extension View {
    
    /// Apply platform-appropriate enhancements to a NavigationStack
    /// Automatically selects iOS or macOS enhancements based on platform
    /// - Returns: View with platform-specific NavigationStack enhancements applied
    func platformNavigationStackEnhancements_L6() -> some View {
        #if os(iOS)
        return self.platformIOSNavigationStackEnhancements_L6()
        #elseif os(macOS)
        return self.platformMacOSNavigationStackEnhancements_L6()
        #else
        return self
        #endif
    }
}

