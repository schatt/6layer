import SwiftUI

// MARK: - Platform-Specific Toolbar Helpers

/// Platform-specific toolbar placement and behavior
public extension View {
    
    /// Platform-specific confirmation action placement (Done, Save, etc.)
    /// iOS/watchOS/visionOS: .confirmationAction (iOS 16+), .navigationBarTrailing (older)
    /// macOS/tvOS: .automatic
    func platformConfirmationActionPlacement() -> ToolbarItemPlacement {
        #if os(iOS) || os(watchOS) || os(visionOS)
        if #available(iOS 16.0, watchOS 9.0, *) {
            return .confirmationAction
        } else {
            return .navigationBarTrailing
        }
        #elseif os(macOS)
        return .automatic
        #elseif os(tvOS)
        return .automatic
        #else
        return .automatic
        #endif
    }
    
    /// Platform-specific cancellation action placement (Cancel, etc.)
    /// iOS/watchOS/visionOS: .cancellationAction (iOS 16+), .navigationBarTrailing (older)
    /// macOS/tvOS: .automatic
    func platformCancellationActionPlacement() -> ToolbarItemPlacement {
        #if os(iOS) || os(watchOS) || os(visionOS)
        if #available(iOS 16.0, watchOS 9.0, *) {
            return .cancellationAction
        } else {
            return .navigationBarTrailing
        }
        #elseif os(macOS)
        return .automatic
        #elseif os(tvOS)
        return .automatic
        #else
        return .automatic
        #endif
    }
    
    /// Platform-specific primary action placement (Add, etc.)
    /// iOS/watchOS/visionOS: .primaryAction (iOS 16+), .navigationBarTrailing (older)
    /// macOS/tvOS: .automatic
    func platformPrimaryActionPlacement() -> ToolbarItemPlacement {
        #if os(iOS) || os(watchOS) || os(visionOS)
        if #available(iOS 16.0, watchOS 9.0, *) {
            return .primaryAction
        } else {
            return .navigationBarTrailing
        }
        #elseif os(macOS)
        return .automatic
        #elseif os(tvOS)
        return .automatic
        #else
        return .automatic
        #endif
    }
    
    /// Platform-specific secondary action placement
    /// iOS/watchOS/visionOS: .secondaryAction (iOS 16+), .navigationBarTrailing (older)
    /// macOS/tvOS: .automatic
    func platformSecondaryActionPlacement() -> ToolbarItemPlacement {
        #if os(iOS) || os(watchOS) || os(visionOS)
        if #available(iOS 16.0, watchOS 9.0, *) {
            return .secondaryAction
        } else {
            return .navigationBarTrailing
        }
        #elseif os(macOS)
        return .automatic
        #elseif os(tvOS)
        return .automatic
        #else
        return .automatic
        #endif
    }
}
