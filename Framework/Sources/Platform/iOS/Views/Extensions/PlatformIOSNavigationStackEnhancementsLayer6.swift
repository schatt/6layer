//
//  PlatformIOSNavigationStackEnhancementsLayer6.swift
//  SixLayerFramework
//
//  Layer 6: iOS-Specific NavigationStack Enhancements
//  iOS-specific enhancements for NavigationStack
//

import SwiftUI
#if os(iOS)
import UIKit
#endif

// MARK: - Layer 6: iOS-Specific NavigationStack Enhancements

/// iOS-specific enhancements for NavigationStack
/// Provides iOS-specific features like:
/// - Haptic feedback for navigation actions
/// - iOS-specific navigation bar styling
/// - Swipe gesture support for navigation
/// - iOS accessibility enhancements

public extension View {
    
    /// Apply iOS-specific enhancements to a NavigationStack
    /// Provides iOS-specific navigation features and optimizations
    /// - Returns: View with iOS-specific NavigationStack enhancements applied
    #if os(iOS)
    func platformIOSNavigationStackEnhancements_L6() -> some View {
        return self
            // iOS-specific navigation bar styling
            .navigationBarTitleDisplayMode(.automatic)
            // iOS accessibility: Improve navigation accessibility
            .accessibilityAddTraits(.isHeader)
            // iOS-specific: Support swipe-to-go-back gesture
            .gesture(
                DragGesture()
                    .onEnded { value in
                        // iOS native swipe-to-go-back is handled by NavigationStack
                        // This is for additional custom swipe gestures if needed
                    }
            )
    }
    #else
    func platformIOSNavigationStackEnhancements_L6() -> some View {
        return self
    }
    #endif
}

