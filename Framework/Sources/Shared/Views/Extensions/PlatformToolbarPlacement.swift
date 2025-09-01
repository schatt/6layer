import SwiftUI

// MARK: - Platform Toolbar Placement

/// Platform-specific toolbar placement for toolbar items
/// iOS: Uses navigationBarTrailing/navigationBarLeading; macOS: Uses automatic
public enum PlatformToolbarPlacement {
    case leading
    case trailing
    case automatic
}
