import SwiftUI

/// Platform-specific spacing constants for consistent UI spacing
/// Follows Apple's Human Interface Guidelines with 8pt grid system
/// macOS uses slightly tighter spacing while maintaining 8pt grid alignment
public struct PlatformSpacing {
    // MARK: - Spacing Values
    
    /// Small spacing value (4pt on all platforms)
    /// Follows 8pt grid: 0.5 * 8 = 4
    public static let small: CGFloat = platformValue(
        iOS: 4,
        macOS: 4,
        watchOS: 4,
        tvOS: 4,
        visionOS: 4
    )

    /// Medium spacing value (8pt on all platforms)
    /// Follows 8pt grid: 1 * 8 = 8
    public static let medium: CGFloat = platformValue(
        iOS: 8,
        macOS: 8,
        watchOS: 8,
        tvOS: 8,
        visionOS: 8
    )

    /// Large spacing value
    /// Follows 8pt grid: iOS/watchOS/tvOS/visionOS use 2 * 8 = 16, macOS uses 1.5 * 8 = 12
    public static let large: CGFloat = platformValue(
        iOS: 16,
        macOS: 12,
        watchOS: 16,
        tvOS: 16,
        visionOS: 16
    )

    /// Extra large spacing value
    /// Follows 8pt grid: iOS/watchOS/tvOS/visionOS use 3 * 8 = 24, macOS uses 2.5 * 8 = 20
    public static let extraLarge: CGFloat = platformValue(
        iOS: 24,
        macOS: 20,
        watchOS: 24,
        tvOS: 24,
        visionOS: 24
    )

    // MARK: - Padding Values
    
    /// Standard padding value
    /// Follows 8pt grid: iOS/watchOS/tvOS/visionOS use 2 * 8 = 16, macOS uses 1.5 * 8 = 12
    public static let padding: CGFloat = platformValue(
        iOS: 16,
        macOS: 12,
        watchOS: 16,
        tvOS: 16,
        visionOS: 16
    )

    /// Reduced padding value (8pt on all platforms)
    /// Follows 8pt grid: 1 * 8 = 8
    public static let reducedPadding: CGFloat = platformValue(
        iOS: 8,
        macOS: 8,
        watchOS: 8,
        tvOS: 8,
        visionOS: 8
    )

    // MARK: - Corner Radius Values
    
    /// Standard corner radius
    /// iOS/watchOS/visionOS: 12pt (1.5 * 8), macOS/tvOS: 8pt (1 * 8)
    public static let cornerRadius: CGFloat = platformValue(
        iOS: 12,
        macOS: 8,
        watchOS: 12,
        tvOS: 8,
        visionOS: 12
    )

    /// Small corner radius
    /// iOS/watchOS/tvOS/visionOS: 8pt (1 * 8), macOS: 6pt
    public static let smallCornerRadius: CGFloat = platformValue(
        iOS: 8,
        macOS: 6,
        watchOS: 8,
        tvOS: 8,
        visionOS: 8
    )
    
    // MARK: - Private Helpers
    
    /// Returns platform-specific value with explicit handling for all platforms
    /// 
    /// This helper function selects the appropriate value based on the compile-time platform,
    /// eliminating the need for repetitive `#if os()` conditionals throughout the struct.
    /// 
    /// - Parameters:
    ///   - iOS: Value to use on iOS platform
    ///   - macOS: Value to use on macOS platform
    ///   - watchOS: Value to use on watchOS platform
    ///   - tvOS: Value to use on tvOS platform
    ///   - visionOS: Value to use on visionOS platform
    /// - Returns: The platform-specific value based on compile-time platform detection
    private static func platformValue(
        iOS: CGFloat,
        macOS: CGFloat,
        watchOS: CGFloat,
        tvOS: CGFloat,
        visionOS: CGFloat
    ) -> CGFloat {
        #if os(iOS)
        return iOS
        #elseif os(macOS)
        return macOS
        #elseif os(watchOS)
        return watchOS
        #elseif os(tvOS)
        return tvOS
        #elseif os(visionOS)
        return visionOS
        #endif
    }
}


