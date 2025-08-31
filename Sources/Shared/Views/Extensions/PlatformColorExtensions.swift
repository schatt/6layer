import SwiftUI

// Platform-specific Color conveniences
public extension Color {
    static var cardBackground: Color {
        #if os(iOS)
        return Color.platformBackground
        #else
        return Color.platformSecondaryBackground
        #endif
    }

    static var secondaryBackground: Color {
        #if os(iOS)
        return Color.platformSecondaryBackground
        #else
        return Color.platformBackground
        #endif
    }

    static var tertiaryBackground: Color {
        #if os(iOS)
        return Color.platformSecondaryBackground
        #else
        return Color.platformSecondaryBackground
        #endif
    }

    static var primaryBackground: Color {
        #if os(iOS)
        return Color.platformBackground
        #elseif os(macOS)
        return Color.platformSecondaryBackground
        #else
        return Color.gray.opacity(0.1)
        #endif
    }

    static var groupedBackground: Color {
        #if os(iOS)
        return Color.platformGroupedBackground
        #elseif os(macOS)
        return Color.platformSecondaryBackground
        #else
        return Color.gray.opacity(0.1)
        #endif
    }

    static var secondaryGroupedBackground: Color {
        #if os(iOS)
        return Color.platformSecondaryBackground
        #elseif os(macOS)
        return Color.platformBackground
        #else
        return Color.gray.opacity(0.05)
        #endif
    }

    static var separator: Color {
        #if os(iOS)
        return Color.platformSeparator
        #elseif os(macOS)
        return Color.platformSeparator
        #else
        return Color.gray.opacity(0.3)
        #endif
    }

    static var label: Color {
        #if os(iOS)
        return Color.platformLabel
        #elseif os(macOS)
        return Color.platformLabel
        #else
        return Color.primary
        #endif
    }

    static var secondaryLabel: Color {
        #if os(iOS)
        return Color.platformSecondaryLabel
        #elseif os(macOS)
        return Color.platformSecondaryLabel
        #else
        return Color.secondary
        #endif
    }

    static var tertiaryLabel: Color {
        #if os(iOS)
        return Color.platformTertiaryLabel
        #elseif os(macOS)
        return Color.platformTertiaryLabel
        #else
        return Color.secondary.opacity(0.7)
        #endif
    }

    static var systemBlue: Color {
        #if os(iOS)
        return Color.platformInfo
        #elseif os(macOS)
        return Color.platformInfo
        #else
        return Color.blue
        #endif
    }

    static var systemRed: Color {
        #if os(iOS)
        return Color.platformDestructive
        #elseif os(macOS)
        return Color.platformDestructive
        #else
        return Color.red
        #endif
    }

    static var systemGreen: Color {
        #if os(iOS)
        return Color.platformSuccess
        #elseif os(macOS)
        return Color.platformSuccess
        #else
        return Color.green
        #endif
    }

    static var systemOrange: Color {
        #if os(iOS)
        return Color.platformWarning
        #elseif os(macOS)
        return Color.platformWarning
        #else
        return Color.orange
        #endif
    }

    static var systemYellow: Color {
        #if os(iOS)
        return Color.platformWarning
        #elseif os(macOS)
        return Color.platformWarning
        #else
        return Color.yellow
        #endif
    }

    static var systemPurple: Color {
        #if os(iOS)
        return Color.purple
        #elseif os(macOS)
        return Color.purple
        #else
        return Color.purple
        #endif
    }

    static var systemPink: Color {
        #if os(iOS)
        return Color.pink
        #elseif os(macOS)
        return Color.pink
        #else
        return Color.pink
        #endif
    }

    static var systemIndigo: Color {
        #if os(iOS)
        return Color.indigo
        #elseif os(macOS)
        return Color.indigo
        #else
        return Color.indigo
        #endif
    }

    static var systemTeal: Color {
        #if os(iOS)
        return Color.teal
        #elseif os(macOS)
        return Color.teal
        #else
        return Color.teal
        #endif
    }

    static var systemMint: Color {
        #if os(iOS)
        return Color.mint
        #elseif os(macOS)
        return Color.mint
        #else
        return Color.mint
        #endif
    }

    static var systemCyan: Color {
        #if os(iOS)
        return Color.cyan
        #elseif os(macOS)
        return Color.cyan
        #else
        return Color.cyan
        #endif
    }

    static var systemBrown: Color {
        #if os(iOS)
        return Color.brown
        #elseif os(macOS)
        return Color.brown
        #else
        return Color.brown
        #endif
    }

    /// Platform-specific color encoding
    /// iOS: Uses UIColor; macOS: Uses NSColor
public func platformColorEncode() -> Data? {
        #if os(macOS)
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        let nsColor = NSColor(self)
        nsColor.usingColorSpace(.deviceRGB)?.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        let components = [Float(red), Float(green), Float(blue), Float(alpha)]
        return try? NSKeyedArchiver.archivedData(withRootObject: components, requiringSecureCoding: false)
        #else
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        let uiColor = UIColor(self)
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        let components = [Float(red), Float(green), Float(blue), Float(alpha)]
        return try? NSKeyedArchiver.archivedData(withRootObject: components, requiringSecureCoding: false)
        #endif
    }
}
