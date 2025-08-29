import SwiftUI

#if os(macOS)
// MARK: - macOS List-Detail Helpers

/// macOS-specific helpers for managing list-detail selection and navigation
/// This provides consistent behavior for macOS while handling platform differences appropriately

// MARK: - List-Detail Selection State

/// Manages selection state for list-detail views on macOS
/// macOS: Selection with detail pane display
@MainActor
class PlatformListDetailSelection<T: Identifiable>: ObservableObject {
    @Published var selectedItem: T?
    @Published var showingDetail = false
    
    @Published var columnVisibility: NavigationSplitViewVisibility = .automatic
    
    init(initialSelection: T? = nil) {
        self.selectedItem = initialSelection
    }
    
    func select(_ item: T?) {
        selectedItem = item
        showingDetail = item != nil
        if item != nil {
            columnVisibility = .all
        } else {
            columnVisibility = .automatic
        }
    }
    
    func deselect() {
        selectedItem = nil
        showingDetail = false
        columnVisibility = .automatic
    }
}
#endif
