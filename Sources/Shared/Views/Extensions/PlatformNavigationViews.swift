import SwiftUI

@MainActor
struct PlatformNavigationSplitView<Content: View, Detail: View>: View {
    let content: Content
    let detail: Detail
    @Binding var columnVisibility: NavigationSplitViewVisibility

    init(columnVisibility: Binding<NavigationSplitViewVisibility>, @ViewBuilder content: () -> Content, @ViewBuilder detail: () -> Detail) {
        self._columnVisibility = columnVisibility
        self.content = content()
        self.detail = detail()
    }

    var body: some View {
        #if os(macOS)
        NavigationSplitView(columnVisibility: $columnVisibility) {
            content
        } detail: {
            detail
        }
        #else
        NavigationSplitView(columnVisibility: $columnVisibility) {
            content
        } detail: {
            detail
        }
        #endif
    }
}

@MainActor
struct PlatformNavigationSplitView3<Sidebar: View, Content: View, Detail: View>: View {
    let sidebar: Sidebar
    let content: Content
    let detail: Detail
    @Binding var columnVisibility: NavigationSplitViewVisibility

    init(columnVisibility: Binding<NavigationSplitViewVisibility>, @ViewBuilder sidebar: () -> Sidebar, @ViewBuilder content: () -> Content, @ViewBuilder detail: () -> Detail) {
        self._columnVisibility = columnVisibility
        self.sidebar = sidebar()
        self.content = content()
        self.detail = detail()
    }

    var body: some View {
        #if os(macOS)
        NavigationSplitView(columnVisibility: $columnVisibility) {
            sidebar
        } content: {
            content
        } detail: {
            detail
        }
        #else
        NavigationSplitView(columnVisibility: $columnVisibility) {
            sidebar
        } content: {
            content
        } detail: {
            detail
        }
        #endif
    }
}

@MainActor
struct PlatformAppNavigation<SidebarContent: View, DetailContent: View>: View {
    let sidebarContent: SidebarContent
    let detailContent: DetailContent
    @Binding var columnVisibility: NavigationSplitViewVisibility
    @Binding var showingSidebar: Bool

    init(
        columnVisibility: Binding<NavigationSplitViewVisibility>,
        showingSidebar: Binding<Bool>,
        @ViewBuilder sidebar: () -> SidebarContent,
        @ViewBuilder detail: () -> DetailContent
    ) {
        self._columnVisibility = columnVisibility
        self._showingSidebar = showingSidebar
        self.sidebarContent = sidebar()
        self.detailContent = detail()
    }

    var body: some View {
        #if os(iOS)
        NavigationStack {
            detailContent
        }
        #else
        NavigationSplitView(columnVisibility: $columnVisibility) {
            sidebarContent
        } detail: {
            detailContent
        }
        .navigationSplitViewStyle(.balanced)
        #endif
    }
}


