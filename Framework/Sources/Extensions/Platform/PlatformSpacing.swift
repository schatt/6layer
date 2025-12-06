import SwiftUI

/// Platform-specific spacing constants for consistent UI spacing
/// Follows Apple's Human Interface Guidelines with 8pt grid system
/// macOS uses slightly tighter spacing while maintaining 8pt grid alignment
public struct PlatformSpacing {
    /// Small spacing value (4pt on all platforms)
    /// Follows 8pt grid: 0.5 * 8 = 4
    public static let small: CGFloat = {
        #if os(iOS) || os(watchOS) || os(visionOS)
        return 4
        #elseif os(macOS)
        return 4
        #elseif os(tvOS)
        return 4
        #else
        return 4
        #endif
    }()

    /// Medium spacing value
    /// Follows 8pt grid: 1 * 8 = 8
    public static let medium: CGFloat = {
        #if os(iOS) || os(watchOS) || os(visionOS)
        return 8
        #elseif os(macOS)
        return 8
        #elseif os(tvOS)
        return 8
        #else
        return 8
        #endif
    }()

    /// Large spacing value
    /// Follows 8pt grid: iOS uses 2 * 8 = 16, macOS uses 1.5 * 8 = 12
    public static let large: CGFloat = {
        #if os(iOS) || os(watchOS) || os(visionOS)
        return 16
        #elseif os(macOS)
        return 12
        #elseif os(tvOS)
        return 16
        #else
        return 16
        #endif
    }()

    /// Extra large spacing value
    /// Follows 8pt grid: iOS uses 3 * 8 = 24, macOS uses 2.5 * 8 = 20
    public static let extraLarge: CGFloat = {
        #if os(iOS) || os(watchOS) || os(visionOS)
        return 24
        #elseif os(macOS)
        return 20
        #elseif os(tvOS)
        return 24
        #else
        return 24
        #endif
    }()

    /// Standard padding value
    /// Follows 8pt grid: iOS uses 2 * 8 = 16, macOS uses 1.5 * 8 = 12
    public static let padding: CGFloat = {
        #if os(iOS) || os(watchOS) || os(visionOS)
        return 16
        #elseif os(macOS)
        return 12
        #elseif os(tvOS)
        return 16
        #else
        return 16
        #endif
    }()

    /// Reduced padding value
    /// Follows 8pt grid: 1 * 8 = 8
    public static let reducedPadding: CGFloat = {
        #if os(iOS) || os(watchOS) || os(visionOS)
        return 8
        #elseif os(macOS)
        return 8
        #elseif os(tvOS)
        return 8
        #else
        return 8
        #endif
    }()

    /// Standard corner radius
    /// iOS: 12pt (1.5 * 8), macOS: 8pt (1 * 8)
    public static let cornerRadius: CGFloat = {
        #if os(iOS) || os(watchOS) || os(visionOS)
        return 12
        #elseif os(macOS)
        return 8
        #elseif os(tvOS)
        return 8
        #else
        return 8
        #endif
    }()

    /// Small corner radius
    /// Follows 8pt grid: 1 * 8 = 8
    public static let smallCornerRadius: CGFloat = {
        #if os(iOS) || os(watchOS) || os(visionOS)
        return 8
        #elseif os(macOS)
        return 6
        #elseif os(tvOS)
        return 8
        #else
        return 8
        #endif
    }()
}


