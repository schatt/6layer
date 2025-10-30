import Foundation


/// Manager for keyboard navigation accessibility features
@MainActor
public class KeyboardNavigationManager: ObservableObject {

    @Published public var focusableItems: [String] = []
    @Published public var currentFocusIndex: Int = 0
    
    public init() {}
    
    /// Add a focusable item to the navigation list
    public func addFocusableItem(_ item: String) {
        if !focusableItems.contains(item) {
            focusableItems.append(item)
        }
    }
    
    /// Remove a focusable item from the navigation list
    public func removeFocusableItem(_ item: String) {
        focusableItems.removeAll { $0 == item }
        if currentFocusIndex >= focusableItems.count {
            currentFocusIndex = max(0, focusableItems.count - 1)
        }
    }
    
    /// Move focus in the specified direction
    public func moveFocus(direction: FocusDirection) {
        guard !focusableItems.isEmpty else { return }
        
        switch direction {
        case .next:
            currentFocusIndex = (currentFocusIndex + 1) % focusableItems.count
        case .previous:
            currentFocusIndex = currentFocusIndex == 0 ? focusableItems.count - 1 : currentFocusIndex - 1
        case .first:
            currentFocusIndex = 0
        case .last:
            currentFocusIndex = focusableItems.count - 1
        }
    }
    
    /// Focus a specific item
    public func focusItem(_ item: String) {
        if let index = focusableItems.firstIndex(of: item) {
            currentFocusIndex = index
        }
    }
}