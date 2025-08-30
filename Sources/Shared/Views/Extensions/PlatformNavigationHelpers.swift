import SwiftUI

// MARK: - Cross-Platform Navigation Helpers

/// Cross-platform navigation helpers that provide consistent behavior
/// while properly handling platform differences
@MainActor
public struct PlatformNavigationHelpers {
    
    /// Cross-platform app navigation with platform-specific behavior
    /// iOS: Uses NavigationSplitView or NavigationView; macOS: Uses NavigationSplitView
    public static func platformAppNavigation<SidebarContent: View, DetailContent: View>(
        columnVisibility: Binding<Bool>,
        showingSidebar: Binding<Bool>,
        @ViewBuilder sidebar: () -> SidebarContent,
        @ViewBuilder detail: () -> DetailContent
    ) -> some View {
        #if os(iOS)
        return iosAppNavigation(columnVisibility: columnVisibility, showingSidebar: showingSidebar, sidebar: sidebar, detail: detail)
        #elseif os(macOS)
        return macAppNavigation(columnVisibility: columnVisibility, showingSidebar: showingSidebar, sidebar: sidebar, detail: detail)
        #else
        return fallbackAppNavigation(sidebar: sidebar, detail: detail)
        #endif
    }
    
    /// Cross-platform navigation action with platform-specific behavior
    /// iOS: Hides sidebar after navigation; macOS: Maintains sidebar state
    public static func platformNavigationAction<T>(
        to pane: T,
        selectedPane: Binding<T?>,
        columnVisibility: Binding<Bool>?,
        showingSidebar: Binding<Bool>?
    ) {
        #if os(iOS)
        iosNavigationAction(to: pane, selectedPane: selectedPane, columnVisibility: columnVisibility, showingSidebar: showingSidebar)
        #elseif os(macOS)
        macNavigationAction(to: pane, selectedPane: selectedPane, columnVisibility: columnVisibility, showingSidebar: showingSidebar)
        #else
        fallbackNavigationAction(to: pane, selectedPane: selectedPane)
        #endif
    }
}

// MARK: - Platform-Specific Navigation Components

#if os(iOS)
/// iOS-specific app navigation implementation
private func iosAppNavigation<SidebarContent: View, DetailContent: View>(
    columnVisibility: Binding<Bool>,
    showingSidebar: Binding<Bool>,
    @ViewBuilder sidebar: () -> SidebarContent,
    @ViewBuilder detail: () -> DetailContent
) -> some View {
    if #available(iOS 16.0, *) {
        // Use NavigationSplitView without columnVisibility for iOS 16+
        AnyView(NavigationSplitView {
            sidebar()
        } detail: {
            detail()
        })
    } else {
        // Fallback for iOS 15 and earlier
        AnyView(NavigationView {
            detail()
        })
    }
}

/// iOS-specific navigation action implementation
private func iosNavigationAction<T>(
    to pane: T,
    selectedPane: Binding<T?>,
    columnVisibility: Binding<Bool>?,
    showingSidebar: Binding<Bool>?
) {
    // Update selection
    selectedPane.wrappedValue = pane
    
    // iOS: Hide sidebar after navigation (mobile users expect full-screen content)
    if let cv = columnVisibility {
        cv.wrappedValue = false
    }
    // Don't force sidebar visibility on iOS
}
#endif

#if os(macOS)
/// macOS-specific app navigation implementation
private func macAppNavigation<SidebarContent: View, DetailContent: View>(
    columnVisibility: Binding<Bool>,
    showingSidebar: Binding<Bool>,
    @ViewBuilder sidebar: () -> SidebarContent,
    @ViewBuilder detail: () -> DetailContent
) -> some View {
    if #available(macOS 13.0, *) {
        NavigationSplitView {
            sidebar()
        } detail: {
            detail()
        }
    } else {
        // Fallback for older macOS versions
        HStack {
            sidebar()
            detail()
        }
    }
}

/// macOS-specific navigation action implementation
private func macNavigationAction<T>(
    to pane: T,
    selectedPane: Binding<T?>,
    columnVisibility: Binding<Bool>?,
    showingSidebar: Binding<Bool>?
) {
    // Update selection
    selectedPane.wrappedValue = pane
    
    // macOS: Maintain sidebar state for desktop users
    if let cv = columnVisibility {
        cv.wrappedValue = true
    }
}
#endif

/// Fallback navigation action for other platforms
private func fallbackNavigationAction<T>(
    to pane: T,
    selectedPane: Binding<T?>
) {
    selectedPane.wrappedValue = pane
}

/// Fallback app navigation for other platforms
private func fallbackAppNavigation<SidebarContent: View, DetailContent: View>(
    @ViewBuilder sidebar: () -> SidebarContent,
    @ViewBuilder detail: () -> DetailContent
) -> some View {
    detail()
}
