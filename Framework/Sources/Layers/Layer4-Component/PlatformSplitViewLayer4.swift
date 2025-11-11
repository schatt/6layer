import SwiftUI

// MARK: - Platform Split View Layer 4: Component Implementation

/// Platform-agnostic helpers for split view presentation
/// Implements Issue #14: Add Split View Helpers to Six-Layer Architecture (Layer 4)
///
/// ## Cross-Platform Behavior
///
/// ### Vertical Split Views
/// **Semantic Purpose**: Divide content into resizable vertical panes
/// - **macOS**: Uses `VSplitView` for resizable vertical split panes
///   - User can drag divider to resize panes
///   - Spacing parameter is ignored (uses split view divider)
///   - Native macOS split view behavior
/// - **iOS**: Uses `VStack` for vertical layout
///   - Split views are not available on iOS
///   - Spacing parameter is applied between views
///   - Standard vertical stack layout
///
/// **When to Use**: Sidebars, detail views, master-detail interfaces
///
/// ### Horizontal Split Views
/// **Semantic Purpose**: Divide content into resizable horizontal panes
/// - **macOS**: Uses `HSplitView` for resizable horizontal split panes
///   - User can drag divider to resize panes
///   - Spacing parameter is ignored (uses split view divider)
///   - Native macOS split view behavior
/// - **iOS**: Uses `HStack` for horizontal layout
///   - Split views are not available on iOS
///   - Spacing parameter is applied between views
///   - Standard horizontal stack layout
///
/// **When to Use**: Multi-column layouts, side-by-side content
///
/// ## Platform Mapping
///
/// | Concept | macOS Behavior | iOS Behavior | Unified API |
/// |---------|---------------|--------------|------------|
/// | Vertical Split | VSplitView (resizable) | VStack (spacing) | `platformVerticalSplit_L4()` |
/// | Horizontal Split | HSplitView (resizable) | HStack (spacing) | `platformHorizontalSplit_L4()` |
///
/// **Note**: The unified API automatically uses the appropriate container for each platform.
/// Developers don't need to handle platform differences - the framework adapts automatically.
public extension View {
    
    /// Unified vertical split view presentation helper
    ///
    /// **Cross-Platform Behavior:**
    /// - **macOS**: Uses `VSplitView` for resizable vertical split panes
    ///   - User can drag divider to resize panes
    ///   - Spacing parameter is ignored (uses split view divider)
    /// - **iOS**: Uses `VStack` for vertical layout
    ///   - Split views are not available on iOS
    ///   - Spacing parameter is applied between views
    ///
    /// **Use For**: Sidebars, detail views, master-detail interfaces
    ///
    /// - Parameters:
    ///   - spacing: Spacing between views (iOS only, ignored on macOS)
    ///   - content: View builder for split view content
    /// - Returns: View with vertical split modifier applied
    @ViewBuilder
    func platformVerticalSplit_L4<Content: View>(
        spacing: CGFloat = 0,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        let identifierName = "platformVerticalSplit_L4"
        #if os(macOS)
        VSplitView {
            content()
        }
        .automaticAccessibility()
        .automaticAccessibilityIdentifiers(named: identifierName)
        #else
        VStack(spacing: spacing) {
            content()
        }
        .automaticAccessibilityIdentifiers(named: identifierName)
        #endif
    }
    
    /// Unified horizontal split view presentation helper
    ///
    /// **Cross-Platform Behavior:**
    /// - **macOS**: Uses `HSplitView` for resizable horizontal split panes
    ///   - User can drag divider to resize panes
    ///   - Spacing parameter is ignored (uses split view divider)
    /// - **iOS**: Uses `HStack` for horizontal layout
    ///   - Split views are not available on iOS
    ///   - Spacing parameter is applied between views
    ///
    /// **Use For**: Multi-column layouts, side-by-side content
    ///
    /// - Parameters:
    ///   - spacing: Spacing between views (iOS only, ignored on macOS)
    ///   - content: View builder for split view content
    /// - Returns: View with horizontal split modifier applied
    @ViewBuilder
    func platformHorizontalSplit_L4<Content: View>(
        spacing: CGFloat = 0,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        let identifierName = "platformHorizontalSplit_L4"
        #if os(macOS)
        HSplitView {
            content()
        }
        .automaticAccessibility()
        .automaticAccessibilityIdentifiers(named: identifierName)
        #else
        HStack(spacing: spacing) {
            content()
        }
        .automaticAccessibilityIdentifiers(named: identifierName)
        #endif
    }
}

