import SwiftUI

// MARK: - Platform Menu System Extensions

/// Platform-specific menu system extensions that provide consistent behavior
/// across iOS and macOS while handling platform differences appropriately
public extension View {

    /// Platform menu with menu items
    /// iOS: No-op (menus not supported); macOS: Uses menu with menu items
    ///
    /// - Parameter content: The menu items to display
    /// - Returns: A view with platform-appropriate menu behavior
    ///
    /// ## Usage Example
    /// ```swift
    /// Button("Actions")
    ///     .platformMenu {
    ///         Button("Copy") { copyText() }
    ///         Button("Delete") { deleteText() }
    ///     }
    /// ```
    @ViewBuilder
public func platformMenu<MenuItems: View>(
        @ViewBuilder content: () -> MenuItems
    ) -> some View {
        #if os(macOS)
        Menu {
            content()
        } label: {
            self
        }
        #else
        self
        #endif
    }

    /// Platform menu with menu items and label
    /// iOS: No-op (menus not supported); macOS: Uses menu with menu items and label
    ///
    /// - Parameters:
    ///   - label: The label for the menu
    ///   - content: The menu items to display
    /// - Returns: A view with platform-appropriate menu behavior
    ///
    /// ## Usage Example
    /// ```swift
    /// Button("Actions")
    ///     .platformMenu(
    ///         label: Text("More Actions"),
    ///         content: {
    ///             Button("Copy") { copyText() }
    ///             Button("Delete") { deleteText() }
    ///         }
    ///     )
    /// ```
    @ViewBuilder
public func platformMenu<Label: View, MenuItems: View>(
        label: Label,
        @ViewBuilder content: () -> MenuItems
    ) -> some View {
        #if os(macOS)
        Menu {
            content()
        } label: {
            label
        }
        #else
        self
        #endif
    }

    /// Platform menu with menu items and title
    /// iOS: No-op (menus not supported); macOS: Uses menu with menu items and title
    ///
    /// - Parameters:
    ///   - title: The title for the menu
    ///   - content: The menu items to display
    /// - Returns: A view with platform-appropriate menu behavior
    ///
    /// ## Usage Example
    /// ```swift
    /// Button("Actions")
    ///     .platformMenu(
    ///         title: "More Actions",
    ///         content: {
    ///             Button("Copy") { copyText() }
    ///             Button("Delete") { deleteText() }
    ///         }
    ///     )
    /// ```
    @ViewBuilder
public func platformMenu<MenuItems: View>(
        title: String,
        @ViewBuilder content: () -> MenuItems
    ) -> some View {
        #if os(macOS)
        Menu {
            content()
        } label: {
            Text(title)
        }
        #else
        self
        #endif
    }
}


