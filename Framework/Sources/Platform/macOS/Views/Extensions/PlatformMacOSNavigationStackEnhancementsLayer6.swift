//
//  PlatformMacOSNavigationStackEnhancementsLayer6.swift
//  SixLayerFramework
//
//  Layer 6: macOS-Specific NavigationStack Enhancements
//  macOS-specific enhancements for NavigationStack
//

import SwiftUI
#if os(macOS)
import AppKit
#endif

// MARK: - Layer 6: macOS-Specific NavigationStack Enhancements

/// macOS-specific enhancements for NavigationStack
/// Provides macOS-specific features like:
/// - Keyboard navigation support
/// - macOS-specific navigation styling
/// - Window management integration
/// - macOS accessibility enhancements

public extension View {
    
    /// Apply macOS-specific enhancements to a NavigationStack
    /// Provides macOS-specific navigation features and optimizations
    /// - Returns: View with macOS-specific NavigationStack enhancements applied
    #if os(macOS)
    func platformMacOSNavigationStackEnhancements_L6() -> some View {
        return self
            // macOS-specific: Keyboard navigation support
            .focusable()
            // macOS accessibility: Improve navigation accessibility
            .accessibilityAddTraits(.isHeader)
            // macOS-specific: Window management integration
            .frame(minWidth: 400, minHeight: 300)
    }
    #else
    func platformMacOSNavigationStackEnhancements_L6() -> some View {
        return self
    }
    #endif
}

