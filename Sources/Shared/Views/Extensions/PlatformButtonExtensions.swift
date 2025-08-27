import SwiftUI

// MARK: - Platform Button Extensions

/// Platform-specific Button extensions that provide consistent behavior
/// across iOS and macOS while handling platform differences appropriately
extension View {

    /// Platform-specific navigation button
    /// iOS: Shows navigation sheet; macOS: Toggles sidebar
    @ViewBuilder
    func platformNavigationSheetButton(
        action: @escaping () -> Void,
        sidebarVisibility: Binding<NavigationSplitViewVisibility>? = nil
    ) -> some View {
        #if os(iOS)
        Button(action: action) {
            Image(systemName: "list.bullet")
        }
        .accessibilityLabel("Navigation")
        .accessibilityHint("Open navigation sheet")
        #else
        Button(action: {
            if let sidebarVisibility = sidebarVisibility {
                // Toggle between .automatic and .all
                sidebarVisibility.wrappedValue = sidebarVisibility.wrappedValue == .all ? .automatic : .all
            }
        }) {
            Image(systemName: "sidebar.left")
        }
        .accessibilityLabel("Toggle Sidebar")
        .accessibilityHint("Show or hide the navigation sidebar")
        #endif
    }
}
