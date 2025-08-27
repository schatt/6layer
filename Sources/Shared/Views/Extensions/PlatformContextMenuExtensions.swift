import SwiftUI

// MARK: - Platform Context Menu Extensions

/// Platform-specific context menu extensions that provide consistent behavior
/// across iOS and macOS while handling platform differences appropriately
extension View {

    /// Basic platform context menu with menu items
    /// iOS: Uses native context menu; macOS: Uses native context menu
    /// Both platforms support the same API, so this provides a unified interface
    ///
    /// - Parameter content: The menu items to display in the context menu
    /// - Returns: A view with platform-appropriate context menu behavior
    ///
    /// ## Usage Example
    /// ```swift
    /// Text("Long press me")
    ///     .platformContextMenu {
    ///         Button("Copy") { copyText() }
    ///         Button("Delete") { deleteText() }
    ///     }
    /// ```
    @ViewBuilder
    func platformContextMenu<MenuItems: View>(
        @ViewBuilder content: () -> MenuItems
    ) -> some View {
        self.contextMenu { content() }
    }

    /// Platform context menu with preview
    /// iOS: Uses contextMenu with preview; macOS: Uses contextMenu with preview
    /// Both platforms support the same API, so this provides a unified interface
    ///
    /// - Parameters:
    ///   - preview: The preview content to show
    ///   - content: The menu items to display in the context menu
    /// - Returns: A view with platform-appropriate context menu behavior
    ///
    /// ## Usage Example
    /// ```swift
    /// Text("Long press me")
    ///     .platformContextMenu(
    ///         preview: Text("Preview content"),
    ///         content: {
    ///             Button("Copy") { copyText() }
    ///             Button("Delete") { deleteText() }
    ///         }
    ///     )
    /// ```
    @ViewBuilder
    func platformContextMenu<Preview: View, MenuItems: View>(
        preview: Preview,
        @ViewBuilder content: () -> MenuItems
    ) -> some View {
        self.contextMenu(menuItems: { content() }, preview: { preview })
    }

    /// Platform context menu with actions
    /// iOS: Uses contextMenu with actions; macOS: Uses contextMenu with actions
    /// Both platforms support the same API, so this provides a unified interface
    ///
    /// - Parameter actions: The actions to display in the context menu
    /// - Returns: A view with platform-appropriate context menu behavior
    ///
    /// ## Usage Example
    /// ```swift
    /// Text("Long press me")
    ///     .platformContextMenu(actions: [
    ///         ContextMenuAction("Copy", action: copyText),
    ///         ContextMenuAction("Delete", action: deleteText)
    ///     ])
    /// ```
    @ViewBuilder
    func platformContextMenu(actions: [ContextMenuAction]) -> some View {
        self.contextMenu(menuItems: {
            ForEach(actions, id: \.title) { action in
                Button(action.title, action: action.action)
            }
        })
    }
}

// MARK: - Context Menu Action

/// Represents a context menu action
public struct ContextMenuAction {
    public let title: String
    public let action: () -> Void

    public init(_ title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
}
