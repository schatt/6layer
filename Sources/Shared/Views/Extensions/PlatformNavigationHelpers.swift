import SwiftUI

@MainActor @ViewBuilder
func platformNavigationSplitView<Content: View, Detail: View>(
    @ViewBuilder content: () -> Content,
    @ViewBuilder detail: () -> Detail
) -> some View {
    #if os(iOS)
    if #available(iOS 16.0, *) {
        NavigationStack { content() }
    } else {
        content()
    }
    #else
    NavigationSplitView { content() } detail: { detail() }
    #endif
}

@MainActor @ViewBuilder
func platformNavigationSplitView<Sidebar: View, Content: View, Detail: View>(
    @ViewBuilder sidebar: () -> Sidebar,
    @ViewBuilder content: () -> Content,
    @ViewBuilder detail: () -> Detail
) -> some View {
    #if os(iOS)
    if #available(iOS 16.0, *) {
        NavigationStack { content() }
    } else {
        content()
    }
    #else
    NavigationSplitView { sidebar() } content: { content() } detail: { detail() }
    #endif
}

@MainActor @ViewBuilder
func platformAppNavigation<SidebarContent: View, DetailContent: View>(
    @ViewBuilder sidebar: () -> SidebarContent,
    @ViewBuilder detail: () -> DetailContent
) -> some View {
    #if os(iOS)
    if #available(iOS 16.0, *) {
        NavigationStack { sidebar() }
    } else {
        sidebar()
    }
    #else
    NavigationSplitView { sidebar() } detail: { detail() }
    #endif
}

// Overload that accepts bindings for split-view state on platforms that support it
@MainActor @ViewBuilder
func platformAppNavigation<SidebarContent: View, DetailContent: View>(
    columnVisibility: Binding<NavigationSplitViewVisibility>,
    showingSidebar: Binding<Bool>,
    @ViewBuilder sidebar: () -> SidebarContent,
    @ViewBuilder detail: () -> DetailContent
) -> some View {
    #if os(iOS)
    // On iOS, present a single NavigationStack focused on detail content
    NavigationStack { detail() }
    #else
    NavigationSplitView(columnVisibility: columnVisibility) {
        sidebar()
    } detail: {
        detail()
    }
    #endif
}

func platformNavigationAction<T>(_ action: () -> T) -> T {
    return action()
}

// Overload to perform pane navigation with platform-specific split-view coordination
@MainActor
func platformNavigationAction<T>(
    to pane: T,
    selectedPane: Binding<T?>,
    columnVisibility: Binding<NavigationSplitViewVisibility>?,
    showingSidebar: Binding<Bool>?
) {
    // Update selection
    selectedPane.wrappedValue = pane
    #if os(iOS)
    // Ensure sidebar flag is off on iOS single-column navigation (ignored if nil)
    showingSidebar?.wrappedValue = false
    _ = columnVisibility // not used on iOS
    #else
    // Platform-specific sidebar behavior
    #if os(macOS)
    // macOS: Keep sidebar visible when navigating (desktop users expect persistent navigation)
    if let cv = columnVisibility {
        cv.wrappedValue = .all
    }
    // Ensure sidebar is visible when navigating
    if let ss = showingSidebar {
        ss.wrappedValue = true
    }
    #else
    // iOS: Hide sidebar after navigation (mobile users expect full-screen content)
    if let cv = columnVisibility {
        cv.wrappedValue = .detailOnly
    }
    // Don't force sidebar visibility on iOS
    #endif
    #endif
}


