import SwiftUI

// MARK: - Cross-Platform Context Menu Extensions

/// Cross-platform context menu extensions that provide consistent behavior
/// while properly handling platform differences
public extension View {
    
    /// Cross-platform context menu with platform-specific behavior
    /// iOS: Full context menu support; macOS: Full context menu support
public func platformContextMenu<MenuItems: View>(
        @ViewBuilder menuItems: () -> MenuItems,
        preview: (() -> some View)? = nil
    ) -> some View {
        #if os(iOS)
        return iosContextMenu(self, menuItems: menuItems, preview: preview)
        #elseif os(macOS)
        return macContextMenu(self, menuItems: menuItems, preview: preview)
        #else
        return fallbackContextMenu(self, menuItems: menuItems)
        #endif
    }
    
    /// Cross-platform context menu with action-based menu items
    /// iOS: Full context menu support; macOS: Full context menu support
public func platformContextMenu<MenuItems: View>(
        @ViewBuilder menuItems: () -> MenuItems
    ) -> some View {
        #if os(iOS)
        return iosContextMenu(self, menuItems: menuItems)
        #elseif os(macOS)
        return macContextMenu(self, menuItems: menuItems)
        #else
        return fallbackContextMenu(self, menuItems: menuItems)
        #endif
    }
}

// MARK: - Platform-Specific Context Menu Components

#if os(iOS)
/// iOS-specific context menu implementation with preview support
private func iosContextMenu<MenuItems: View>(
    _ view: some View,
    @ViewBuilder menuItems: () -> MenuItems,
    preview: (() -> some View)? = nil
) -> some View {
    if #available(iOS 16.0, *) {
        if let preview = preview {
            return AnyView(view.contextMenu(menuItems: menuItems, preview: preview))
        } else {
            return AnyView(view.contextMenu(menuItems: menuItems))
        }
    } else {
        // Fallback for iOS 15 and earlier
        return AnyView(view.contextMenu(menuItems: menuItems))
    }
}

/// iOS-specific context menu implementation without preview
private func iosContextMenu<MenuItems: View>(
    _ view: some View,
    @ViewBuilder menuItems: () -> MenuItems
) -> some View {
    if #available(iOS 16.0, *) {
        return AnyView(view.contextMenu(menuItems: menuItems))
    } else {
        // Fallback for iOS 15 and earlier
        return AnyView(view.contextMenu(menuItems: menuItems))
    }
}
#endif

#if os(macOS)
/// macOS-specific context menu implementation with preview support
private func macContextMenu<MenuItems: View>(
    _ view: some View,
    @ViewBuilder menuItems: () -> MenuItems,
    preview: (() -> some View)? = nil
) -> some View {
    if #available(macOS 11.0, *) {
        if let preview = preview {
            return AnyView(view.contextMenu(menuItems: menuItems, preview: preview))
        } else {
            return AnyView(view.contextMenu(menuItems: menuItems))
        }
    } else {
        // Fallback for older macOS versions - just return the view
        return AnyView(view)
    }
}

/// macOS-specific context menu implementation without preview
private func macContextMenu<MenuItems: View>(
    _ view: some View,
    @ViewBuilder menuItems: () -> MenuItems
) -> some View {
    if #available(macOS 11.0, *) {
        return AnyView(view.contextMenu(menuItems: menuItems))
    } else {
        // Fallback for older macOS versions - just return the view
        return AnyView(view)
    }
}
#endif

/// Fallback context menu for other platforms
private func fallbackContextMenu<MenuItems: View>(
    _ view: some View,
    @ViewBuilder menuItems: () -> MenuItems
) -> some View {
    return AnyView(view.contextMenu(menuItems: menuItems))
}
