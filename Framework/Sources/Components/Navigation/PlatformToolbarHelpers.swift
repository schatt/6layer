import SwiftUI

// MARK: - Platform-Specific Toolbar Helpers

/// Platform-specific toolbar placement and behavior
public extension View {
    
    /// Platform-specific confirmation action placement (Done, Save, etc.)
    /// iOS/watchOS/visionOS/tvOS: .confirmationAction (iOS 16+/tvOS 16+), .navigationBarTrailing (older)
    /// macOS: .automatic
    func platformConfirmationActionPlacement() -> ToolbarItemPlacement {
        #if os(iOS) || os(watchOS) || os(visionOS)
        if #available(iOS 16.0, watchOS 9.0, *) {
            return .confirmationAction
        } else {
            return .navigationBarTrailing
        }
        #elseif os(tvOS)
        if #available(tvOS 16.0, *) {
            return .confirmationAction
        } else {
            return .automatic
        }
        #elseif os(macOS)
        return .automatic
        #else
        return .automatic
        #endif
    }
    
    /// Platform-specific cancellation action placement (Cancel, etc.)
    /// iOS/watchOS/visionOS/tvOS: .cancellationAction (iOS 16+/tvOS 16+), .navigationBarTrailing (older)
    /// macOS: .automatic
    func platformCancellationActionPlacement() -> ToolbarItemPlacement {
        #if os(iOS) || os(watchOS) || os(visionOS)
        if #available(iOS 16.0, watchOS 9.0, *) {
            return .cancellationAction
        } else {
            return .navigationBarTrailing
        }
        #elseif os(tvOS)
        if #available(tvOS 16.0, *) {
            return .cancellationAction
        } else {
            return .automatic
        }
        #elseif os(macOS)
        return .automatic
        #else
        return .automatic
        #endif
    }
    
    /// Platform-specific primary action placement (Add, etc.)
    /// iOS/watchOS/visionOS/tvOS: .primaryAction (iOS 16+/tvOS 16+), .navigationBarTrailing (older)
    /// macOS: .automatic
    func platformPrimaryActionPlacement() -> ToolbarItemPlacement {
        #if os(iOS) || os(watchOS) || os(visionOS)
        if #available(iOS 16.0, watchOS 9.0, *) {
            return .primaryAction
        } else {
            return .navigationBarTrailing
        }
        #elseif os(tvOS)
        if #available(tvOS 16.0, *) {
            return .primaryAction
        } else {
            return .automatic
        }
        #elseif os(macOS)
        return .automatic
        #else
        return .automatic
        #endif
    }
    
    /// Platform-specific secondary action placement
    /// iOS/watchOS/visionOS/tvOS: .secondaryAction (iOS 16+/tvOS 16+), .navigationBarTrailing (older)
    /// macOS: .automatic
    func platformSecondaryActionPlacement() -> ToolbarItemPlacement {
        #if os(iOS) || os(watchOS) || os(visionOS)
        if #available(iOS 16.0, watchOS 9.0, *) {
            return .secondaryAction
        } else {
            return .navigationBarTrailing
        }
        #elseif os(tvOS)
        if #available(tvOS 16.0, *) {
            return .secondaryAction
        } else {
            return .automatic
        }
        #elseif os(macOS)
        return .automatic
        #else
        return .automatic
        #endif
    }
}
