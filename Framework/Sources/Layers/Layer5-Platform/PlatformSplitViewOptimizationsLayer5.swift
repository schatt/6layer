import SwiftUI
import Foundation

// MARK: - Platform Split View Optimizations Layer 5

/// Platform-specific optimizations for split views
/// Implements Issue #19: Split View Platform-Specific Optimizations (Layer 5)
///
/// This layer provides platform-specific performance optimizations for split views:
/// - **iOS**: Touch responsiveness, smooth animations, memory efficiency for mobile
/// - **macOS**: Window performance, large dataset handling, desktop-optimized rendering
///
/// These optimizations enhance the base Layer 4 split view functionality with
/// platform-appropriate performance improvements.

public extension View {
    
    /// Apply platform-appropriate optimizations to a split view
    /// Automatically selects iOS or macOS optimizations based on platform
    /// - Returns: View with platform-specific optimizations applied
    func platformSplitViewOptimizations_L5() -> some View {
        #if os(iOS)
        return self.platformIOSSplitViewOptimizations_L5()
        #elseif os(macOS)
        return self.platformMacOSSplitViewOptimizations_L5()
        #else
        return self
        #endif
    }
    
    /// Apply iOS-specific optimizations to a split view
    /// Optimizes for touch responsiveness, smooth animations, and memory efficiency
    /// - Returns: View with iOS-specific optimizations applied
    #if os(iOS)
    func platformIOSSplitViewOptimizations_L5() -> some View {
        return self
            // REMOVED: .drawingGroup() - causes Metal crash with TextEditor and other UIKit-backed views
            // REMOVED: .compositingGroup() - causes Metal crash with TextEditor and other UIKit-backed views
            // Touch optimization: Improve touch hit testing for better responsiveness
            .contentShape(Rectangle())
            // Performance: Optimize for smooth scrolling and animations
            .transaction { transaction in
                transaction.animation = .easeInOut(duration: 0.25)
            }
    }
    #else
    func platformIOSSplitViewOptimizations_L5() -> some View {
        return self
    }
    #endif
    
    /// Apply macOS-specific optimizations to a split view
    /// Optimizes for window performance, large dataset handling, and desktop rendering
    /// - Returns: View with macOS-specific optimizations applied
    #if os(macOS)
    func platformMacOSSplitViewOptimizations_L5() -> some View {
        return self
            // REMOVED: .drawingGroup() - causes Metal crash with TextEditor and other AppKit-backed views
            // REMOVED: .compositingGroup() - causes Metal crash with TextEditor and other AppKit-backed views
            // Performance: Optimize split view divider interactions
            .transaction { transaction in
                transaction.animation = .easeInOut(duration: 0.2)
            }
    }
    #else
    func platformMacOSSplitViewOptimizations_L5() -> some View {
        return self
    }
    #endif
}

