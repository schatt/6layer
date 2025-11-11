import SwiftUI
import Foundation

// MARK: - Platform Split View State Management

/// State management for split views
/// Implements Issue #15: Split View State Management & Visibility Control
@MainActor
public class PlatformSplitViewState: ObservableObject {
    /// Visibility state for each pane (index -> visible)
    /// Codable for persistence
    @Published private var paneVisibility: [Int: Bool] = [:]
    
    /// Callback for visibility changes
    public var onVisibilityChange: ((Int, Bool) -> Void)?
    
    /// Default visibility for new panes
    public var defaultVisibility: Bool = true
    
    public init(defaultVisibility: Bool = true) {
        self.defaultVisibility = defaultVisibility
    }
    
    /// Check if a pane is visible
    public func isPaneVisible(_ index: Int) -> Bool {
        return paneVisibility[index] ?? defaultVisibility
    }
    
    /// Set pane visibility
    public func setPaneVisible(_ index: Int, visible: Bool) {
        paneVisibility[index] = visible
        onVisibilityChange?(index, visible)
    }
    
    /// Toggle pane visibility
    public func togglePane(_ index: Int) {
        setPaneVisible(index, visible: !isPaneVisible(index))
    }
    
    /// Save state to UserDefaults
    public func saveToUserDefaults(key: String) -> Bool {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(paneVisibility)
            UserDefaults.standard.set(data, forKey: key)
            return true
        } catch {
            return false
        }
    }
    
    /// Restore state from UserDefaults
    public func restoreFromUserDefaults(key: String) -> Bool {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            return false
        }
        do {
            let decoder = JSONDecoder()
            paneVisibility = try decoder.decode([Int: Bool].self, from: data)
            return true
        } catch {
            return false
        }
    }
    
    /// Save state to AppStorage (via UserDefaults)
    public func saveToAppStorage(key: String) -> Bool {
        return saveToUserDefaults(key: key)
    }
}

/// Helper modifier for applying visibility control to split view panes
/// Use this modifier on individual panes within a split view to control their visibility
public extension View {
    /// Apply visibility control to a split view pane
    /// - Parameters:
    ///   - index: The index of this pane (0-based)
    ///   - state: The split view state object (from environment or binding)
    /// - Returns: View with visibility control applied
    @ViewBuilder
    func splitViewPaneVisibility(
        index: Int,
        state: PlatformSplitViewState
    ) -> some View {
        self
            .opacity(state.isPaneVisible(index) ? 1.0 : 0.0)
            .frame(
                width: state.isPaneVisible(index) ? nil : 0,
                height: state.isPaneVisible(index) ? nil : 0
            )
            .clipped()
    }
}

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
    
    /// Unified vertical split view presentation helper with state management
    ///
    /// **Cross-Platform Behavior:**
    /// - **macOS**: Uses `VSplitView` for resizable vertical split panes
    ///   - User can drag divider to resize panes
    ///   - Spacing parameter is ignored (uses split view divider)
    ///   - Visibility state controls pane visibility
    /// - **iOS**: Uses `VStack` for vertical layout
    ///   - Split views are not available on iOS
    ///   - Spacing parameter is applied between views
    ///   - Visibility state conditionally includes/excludes panes
    ///
    /// **Use For**: Sidebars, detail views, master-detail interfaces with visibility control
    ///
    /// - Parameters:
    ///   - state: Binding to split view state for visibility control
    ///   - spacing: Spacing between views (iOS only, ignored on macOS)
    ///   - content: View builder for split view content (should provide 2+ views)
    /// - Returns: View with vertical split modifier applied
    @ViewBuilder
    func platformVerticalSplit_L4<Content: View>(
        state: Binding<PlatformSplitViewState>,
        spacing: CGFloat = 0,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        let identifierName = "platformVerticalSplit_L4"
        let stateValue = state.wrappedValue
        #if os(macOS)
        VSplitView {
            content()
                .environmentObject(stateValue)
        }
        .automaticAccessibility()
        .automaticAccessibilityIdentifiers(named: identifierName)
        #else
        VStack(spacing: spacing) {
            content()
                .environmentObject(stateValue)
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
    
    /// Unified horizontal split view presentation helper with state management
    ///
    /// **Cross-Platform Behavior:**
    /// - **macOS**: Uses `HSplitView` for resizable horizontal split panes
    ///   - User can drag divider to resize panes
    ///   - Spacing parameter is ignored (uses split view divider)
    ///   - Visibility state controls pane visibility
    /// - **iOS**: Uses `HStack` for horizontal layout
    ///   - Split views are not available on iOS
    ///   - Spacing parameter is applied between views
    ///   - Visibility state conditionally includes/excludes panes
    ///
    /// **Use For**: Multi-column layouts, side-by-side content with visibility control
    ///
    /// - Parameters:
    ///   - state: Binding to split view state for visibility control
    ///   - spacing: Spacing between views (iOS only, ignored on macOS)
    ///   - content: View builder for split view content (should provide 2+ views)
    /// - Returns: View with horizontal split modifier applied
    @ViewBuilder
    func platformHorizontalSplit_L4<Content: View>(
        state: Binding<PlatformSplitViewState>,
        spacing: CGFloat = 0,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        let identifierName = "platformHorizontalSplit_L4"
        let stateValue = state.wrappedValue
        #if os(macOS)
        HSplitView {
            content()
                .environmentObject(stateValue)
        }
        .automaticAccessibility()
        .automaticAccessibilityIdentifiers(named: identifierName)
        #else
        HStack(spacing: spacing) {
            content()
                .environmentObject(stateValue)
        }
        .automaticAccessibilityIdentifiers(named: identifierName)
        #endif
    }
}

