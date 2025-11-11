import SwiftUI

// MARK: - Platform Row Actions Layer 4: Component Implementation

/// Platform-agnostic helpers for row actions (swipe actions, context menus, etc.)
/// Implements Issue #13: Add Row Actions Helpers to Six-Layer Architecture (Layer 4)
public extension View {
    
    /// Unified row action presentation helper
    /// iOS: Uses `.swipeActions()` for swipe-to-reveal actions
    /// macOS: Uses context menus or trailing actions
    /// - Parameters:
    ///   - edge: Edge where actions appear (default: .trailing)
    ///   - allowsFullSwipe: Whether to allow full swipe to trigger first action (iOS only)
    ///   - actions: View builder for action buttons
    /// - Returns: View with row actions modifier applied
    @ViewBuilder
    func platformRowActions_L4<Actions: View>(
        edge: HorizontalEdge = .trailing,
        allowsFullSwipe: Bool = false,
        @ViewBuilder actions: @escaping () -> Actions
    ) -> some View {
        #if os(iOS)
        if #available(iOS 15.0, *) {
            self.swipeActions(edge: edge, allowsFullSwipe: allowsFullSwipe) {
                actions()
            }
            .automaticAccessibilityIdentifiers(named: "platformRowActions_L4")
        } else {
            // Fallback for older iOS versions
            self
                .automaticAccessibilityIdentifiers(named: "platformRowActions_L4")
        }
        #elseif os(macOS)
        // macOS uses context menus for row actions
        self.contextMenu {
            actions()
        }
        .automaticAccessibilityIdentifiers(named: "platformRowActions_L4")
        #else
        self
            .automaticAccessibilityIdentifiers(named: "platformRowActions_L4")
        #endif
    }
    
    /// Unified context menu presentation helper
    /// iOS: Uses `.contextMenu()` with preview
    /// macOS: Uses `.contextMenu()` with platform-appropriate styling
    /// - Parameters:
    ///   - menuItems: View builder for menu items
    ///   - preview: Optional preview view for iOS
    /// - Returns: View with context menu modifier applied
    func platformContextMenu_L4<MenuItems: View, Preview: View>(
        @ViewBuilder menuItems: @escaping () -> MenuItems,
        preview: (() -> Preview)? = nil
    ) -> some View {
        #if os(iOS)
        if let preview = preview {
            if #available(iOS 16.0, *) {
                self.contextMenu {
                    menuItems()
                } preview: {
                    preview()
                }
                .automaticAccessibilityIdentifiers(named: "platformContextMenu_L4")
            } else {
                self.contextMenu {
                    menuItems()
                }
                .automaticAccessibilityIdentifiers(named: "platformContextMenu_L4")
            }
        } else {
            self.contextMenu {
                menuItems()
            }
            .automaticAccessibilityIdentifiers(named: "platformContextMenu_L4")
        }
        #elseif os(macOS)
        self.contextMenu {
            menuItems()
        }
        .automaticAccessibilityIdentifiers(named: "platformContextMenu_L4")
        #else
        self
            .automaticAccessibilityIdentifiers(named: "platformContextMenu_L4")
        #endif
    }
}

// MARK: - Row Action Button Helpers

/// Helper for creating row action buttons with consistent styling
public struct PlatformRowActionButton: View {
    let title: String
    let systemImage: String?
    let role: ButtonRole?
    let action: () -> Void
    
    public init(
        title: String,
        systemImage: String? = nil,
        role: ButtonRole? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.systemImage = systemImage
        self.role = role
        self.action = action
    }
    
    public var body: some View {
        Button(role: role, action: action) {
            HStack {
                if let systemImage = systemImage {
                    Image(systemName: systemImage)
                }
                Text(title)
            }
        }
    }
}

/// Helper for creating destructive row action buttons
public struct PlatformDestructiveRowActionButton: View {
    let title: String
    let systemImage: String?
    let action: () -> Void
    
    public init(
        title: String,
        systemImage: String? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.systemImage = systemImage
        self.action = action
    }
    
    public var body: some View {
        PlatformRowActionButton(
            title: title,
            systemImage: systemImage,
            role: .destructive,
            action: action
        )
    }
}

