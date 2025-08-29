import SwiftUI

// MARK: - Cross-Platform Sidebar Helpers

/// Cross-platform sidebar helpers that provide consistent behavior
/// while properly handling platform differences
extension View {
    
    /// Cross-platform sidebar toggle button with platform-specific behavior
    /// iOS: Toggles sidebar visibility; macOS: Toggles sidebar visibility
    func platformSidebarToggleButton(columnVisibility: Binding<Bool>) -> some View {
        #if os(iOS)
        return iosSidebarToggleButton(columnVisibility: columnVisibility)
        #elseif os(macOS)
        return macSidebarToggleButton(columnVisibility: columnVisibility)
        #else
        return fallbackSidebarToggleButton(columnVisibility: columnVisibility)
        #endif
    }
    
    /// Cross-platform sidebar with platform-specific behavior
    /// iOS: No-op (no sidebar support); macOS: Full sidebar support
    func platformSidebar<Content: View>(
        columnVisibility: Binding<Bool>,
        @ViewBuilder content: () -> Content
    ) -> some View {
        #if os(iOS)
        return iosSidebar(columnVisibility: columnVisibility, content: content)
        #elseif os(macOS)
        return macSidebar(columnVisibility: columnVisibility, content: content)
        #else
        return fallbackSidebar(content: content)
        #endif
    }
}

// MARK: - Platform-Specific Sidebar Components

#if os(iOS)
/// iOS-specific sidebar toggle button implementation
private func iosSidebarToggleButton(columnVisibility: Binding<Bool>) -> some View {
    Button(action: {
        if #available(iOS 16.0, *) {
            // Toggle sidebar visibility
            columnVisibility.wrappedValue.toggle()
        } else {
            // No sidebar support in iOS 15
        }
    }) {
        Image(systemName: "sidebar.left")
    }
    .accessibilityLabel("Toggle Sidebar")
    .accessibilityHint("Show or hide the navigation sidebar")
    .disabled(!ProcessInfo.processInfo.isiOSAppOnMac && ProcessInfo.processInfo.operatingSystemVersion.majorVersion < 16)
}

/// iOS-specific sidebar implementation
private func iosSidebar<Content: View>(
    columnVisibility: Binding<Bool>,
    @ViewBuilder content: () -> Content
) -> some View {
    // iOS doesn't have navigationSplitViewColumnVisibility
    return content()
}
#endif

#if os(macOS)
/// macOS-specific sidebar toggle button implementation
private func macSidebarToggleButton(columnVisibility: Binding<Bool>) -> some View {
    Button(action: {
        columnVisibility.wrappedValue.toggle()
    }) {
        Image(systemName: "sidebar.left")
    }
    .accessibilityLabel("Toggle Sidebar")
    .accessibilityHint("Show or hide the navigation sidebar")
}

/// macOS-specific sidebar implementation
private func macSidebar<Content: View>(
    columnVisibility: Binding<Bool>,
    @ViewBuilder content: () -> Content
) -> some View {
    // macOS has full sidebar support
    return content()
}
#endif

/// Fallback sidebar toggle button for other platforms
private func fallbackSidebarToggleButton(columnVisibility: Binding<Bool>) -> some View {
    Button(action: {
        columnVisibility.wrappedValue.toggle()
    }) {
        Image(systemName: "sidebar.left")
    }
    .accessibilityLabel("Toggle Sidebar")
    .accessibilityHint("Show or hide the navigation sidebar")
}

/// Fallback sidebar for other platforms
private func fallbackSidebar<Content: View>(
    @ViewBuilder content: () -> Content
) -> some View {
    return content()
}
