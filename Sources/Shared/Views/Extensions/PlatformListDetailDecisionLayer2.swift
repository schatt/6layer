import SwiftUI

// MARK: - Platform List-Detail Helpers

/// Platform-specific helpers for managing list-detail selection and navigation
/// This provides consistent behavior across iOS and macOS while handling
/// platform differences appropriately

// MARK: - List-Detail Selection State

/// Manages selection state for list-detail views
/// iOS: Single selection with navigation push
/// macOS: Selection with detail pane display
@MainActor
class PlatformListDetailSelection<T: Identifiable>: ObservableObject {
    @Published var selectedItem: T?
    @Published var showingDetail = false
    
    #if os(macOS)
    @Published var columnVisibility: NavigationSplitViewVisibility = .automatic
    #endif
    
    init(initialSelection: T? = nil) {
        self.selectedItem = initialSelection
    }
    
    func select(_ item: T?) {
        selectedItem = item
        showingDetail = item != nil
        #if os(macOS)
        if item != nil {
            columnVisibility = .all
        } else {
            columnVisibility = .automatic
        }
        #endif
    }
    
    func deselect() {
        selectedItem = nil
        showingDetail = false
        #if os(macOS)
        columnVisibility = .automatic
        #endif
    }
}
