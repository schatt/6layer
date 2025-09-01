import SwiftUI

// MARK: - Platform-Specific Toolbar Helpers

/// Platform-specific toolbar placement and behavior
public extension View {
    
    /// Platform-specific secondary action placement
    /// iOS: .secondaryAction; macOS: .automatic
public func platformSecondaryActionPlacement() -> ToolbarItemPlacement {
        #if os(iOS)
        if #available(iOS 16.0, *) {
            return .secondaryAction
        } else {
            return .navigationBarTrailing
        }
        #else
        return .automatic
        #endif
    }
}
