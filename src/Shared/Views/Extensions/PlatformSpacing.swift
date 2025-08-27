import SwiftUI

/// Platform-specific spacing constants for consistent UI spacing
struct PlatformSpacing {
    static let small: CGFloat = {
        #if os(iOS)
        return 4
        #elseif os(macOS)
        return 3
        #else
        return 4
        #endif
    }()

    static let medium: CGFloat = {
        #if os(iOS)
        return 8
        #elseif os(macOS)
        return 6
        #else
        return 8
        #endif
    }()

    static let large: CGFloat = {
        #if os(iOS)
        return 16
        #elseif os(macOS)
        return 12
        #else
        return 16
        #endif
    }()

    static let extraLarge: CGFloat = {
        #if os(iOS)
        return 24
        #elseif os(macOS)
        return 18
        #else
        return 24
        #endif
    }()

    static let padding: CGFloat = {
        #if os(iOS)
        return 16
        #elseif os(macOS)
        return 12
        #else
        return 16
        #endif
    }()

    static let reducedPadding: CGFloat = {
        #if os(iOS)
        return 8
        #elseif os(macOS)
        return 6
        #else
        return 8
        #endif
    }()

    static let cornerRadius: CGFloat = {
        #if os(iOS)
        return 12
        #elseif os(macOS)
        return 8
        #else
        return 8
        #endif
    }()

    static let smallCornerRadius: CGFloat = {
        #if os(iOS)
        return 8
        #elseif os(macOS)
        return 6
        #else
        return 6
        #endif
    }()
}


