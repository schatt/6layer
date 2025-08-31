import SwiftUI

// MARK: - Platform TabView Extensions

/// Platform-specific TabView extensions that provide consistent behavior
/// across iOS and macOS while handling platform differences appropriately
public extension View {

    // MARK: - TabView Style Extensions

    /// Platform-specific tab view style
    /// iOS: Uses PageTabViewStyle; macOS: Uses DefaultTabViewStyle
    ///
    /// - Returns: A view with platform-specific tab view style
public func platformTabViewStyle() -> some View {
        #if os(iOS)
        self.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        #else
        self.tabViewStyle(DefaultTabViewStyle())
        #endif
    }
}
