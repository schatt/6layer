import SwiftUI

func platformConfirmationActionPlacement() -> ToolbarItemPlacement {
    #if os(iOS)
    return .confirmationAction
    #else
    return .automatic
    #endif
}

func platformCancellationActionPlacement() -> ToolbarItemPlacement {
    #if os(iOS)
    return .cancellationAction
    #else
    return .automatic
    #endif
}

func platformPrimaryActionPlacement() -> ToolbarItemPlacement {
    #if os(iOS)
    return .primaryAction
    #else
    return .automatic
    #endif
}

func platformSecondaryActionPlacement() -> ToolbarItemPlacement {
    #if os(iOS)
    return .secondaryAction
    #else
    return .automatic
    #endif
}

func platformToolbarPlacement() -> ToolbarItemPlacement {
    #if os(iOS)
    return .automatic
    #else
    return .automatic
    #endif
}


