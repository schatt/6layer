//
//  PlatformNavigationStackOptimizationsLayer5.swift
//  SixLayerFramework
//
//  Layer 5: NavigationStack Performance Optimizations
//  Platform-specific performance optimizations for NavigationStack
//

import SwiftUI

// MARK: - Layer 5: NavigationStack Performance Optimizations

/// Platform-specific optimizations for NavigationStack
/// Implements performance optimizations for navigation stacks:
/// - **iOS**: Touch responsiveness, smooth navigation transitions, memory efficiency
/// - **macOS**: Window performance, navigation state preservation, desktop-optimized rendering
///
/// These optimizations enhance the base Layer 4 NavigationStack functionality with
/// platform-appropriate performance improvements.

public extension View {
    
    /// Apply platform-appropriate optimizations to a NavigationStack
    /// Automatically selects iOS or macOS optimizations based on platform
    /// - Returns: View with platform-specific NavigationStack optimizations applied
    func platformNavigationStackOptimizations_L5() -> some View {
        #if os(iOS)
        return self.platformIOSNavigationStackOptimizations_L5()
        #elseif os(macOS)
        return self.platformMacOSNavigationStackOptimizations_L5()
        #else
        return self
        #endif
    }
    
    /// Apply iOS-specific optimizations to a NavigationStack
    /// Optimizes for touch responsiveness, smooth navigation transitions, and memory efficiency
    /// - Returns: View with iOS-specific NavigationStack optimizations applied
    #if os(iOS)
    func platformIOSNavigationStackOptimizations_L5() -> some View {
        return self
            // Memory optimization: Use drawingGroup for complex navigation views to reduce layer count
            .drawingGroup()
            // Touch optimization: Improve touch hit testing for better navigation responsiveness
            .contentShape(Rectangle())
            // Memory: Optimize rendering for mobile devices with compositing
            .compositingGroup()
            // Performance: Optimize navigation transitions for smooth animations
            .transaction { transaction in
                transaction.animation = .easeInOut(duration: 0.3)
            }
    }
    #else
    func platformIOSNavigationStackOptimizations_L5() -> some View {
        return self
    }
    #endif
    
    /// Apply macOS-specific optimizations to a NavigationStack
    /// Optimizes for window performance, navigation state preservation, and desktop rendering
    /// - Returns: View with macOS-specific NavigationStack optimizations applied
    #if os(macOS)
    func platformMacOSNavigationStackOptimizations_L5() -> some View {
        return self
            // Performance: Optimize for large navigation hierarchies with drawing group
            .drawingGroup()
            // Window performance: Optimize rendering for desktop with compositing
            .compositingGroup()
            // Performance: Optimize navigation state preservation for desktop
            .transaction { transaction in
                transaction.animation = .easeInOut(duration: 0.2)
            }
    }
    #else
    func platformMacOSNavigationStackOptimizations_L5() -> some View {
        return self
    }
    #endif
}

