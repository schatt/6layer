import SwiftUI

// MARK: - Enhanced Platform Color System Extensions

/// Platform-specific color system that provides consistent theming
/// across iOS and macOS while respecting platform design guidelines
public extension Color {

    /// Platform background color
    /// iOS: systemBackground; macOS: windowBackgroundColor
    static var platformBackground: Color {
        #if os(iOS)
        return Color(.systemBackground)
        #elseif os(macOS)
        return Color(.windowBackgroundColor)
        #else
        return Color.primary
        #endif
    }

    /// Platform secondary background color
    /// iOS: secondarySystemBackground; macOS: controlBackgroundColor
    static var platformSecondaryBackground: Color {
        #if os(iOS)
        return Color(.secondarySystemBackground)
        #elseif os(macOS)
        return Color(.controlBackgroundColor)
        #else
        return Color.secondary
        #endif
    }

    /// Platform grouped background color
    /// iOS: systemGroupedBackground; macOS: controlBackgroundColor
    static var platformGroupedBackground: Color {
        #if os(iOS)
        return Color(.systemGroupedBackground)
        #elseif os(macOS)
        return Color(.controlBackgroundColor)
        #else
        return Color.secondary
        #endif
    }

    /// Platform separator color
    /// iOS: separator; macOS: separatorColor
    static var platformSeparator: Color {
        #if os(iOS)
        return Color(.separator)
        #elseif os(macOS)
        return Color(.separatorColor)
        #else
        return Color.gray
        #endif
    }

    /// Platform label color
    /// iOS: label; macOS: labelColor
    static var platformLabel: Color {
        #if os(iOS)
        return Color(.label)
        #elseif os(macOS)
        return Color(.labelColor)
        #else
        return Color.primary
        #endif
    }

    /// Platform secondary label color
    /// iOS: secondaryLabel; macOS: secondaryLabelColor
    static var platformSecondaryLabel: Color {
        #if os(iOS)
        return Color(.secondaryLabel)
        #elseif os(macOS)
        return Color(.secondaryLabelColor)
        #else
        return Color.secondary
        #endif
    }

    /// Platform tertiary label color
    /// iOS: tertiaryLabel; macOS: tertiaryLabelColor
    static var platformTertiaryLabel: Color {
        #if os(iOS)
        return Color(.tertiaryLabel)
        #elseif os(macOS)
        return Color(.tertiaryLabelColor)
        #else
        return Color.secondary.opacity(0.6)
        #endif
    }

    /// Platform quaternary label color
    /// iOS: quaternaryLabel; macOS: quaternaryLabelColor
    static var platformQuaternaryLabel: Color {
        #if os(iOS)
        return Color(.quaternaryLabel)
        #elseif os(macOS)
        return Color(.quaternaryLabelColor)
        #else
        return Color.secondary.opacity(0.4)
        #endif
    }

    /// Platform system fill color
    /// iOS: systemFill; macOS: controlColor
    static var platformSystemFill: Color {
        #if os(iOS)
        return Color(.systemFill)
        #elseif os(macOS)
        return Color(.controlColor)
        #else
        return Color.gray.opacity(0.2)
        #endif
    }

    /// Platform secondary system fill color
    /// iOS: secondarySystemFill; macOS: secondaryControlColor
    static var platformSecondarySystemFill: Color {
        #if os(iOS)
        return Color(.secondarySystemFill)
        #elseif os(macOS)
        return Color(.controlBackgroundColor)
        #else
        return Color.gray.opacity(0.15)
        #endif
    }

    /// Platform tertiary system fill color
    /// iOS: tertiarySystemFill; macOS: tertiaryControlColor
    static var platformTertiarySystemFill: Color {
        #if os(iOS)
        return Color(.tertiarySystemFill)
        #elseif os(macOS)
        return Color(.controlBackgroundColor).opacity(0.8)
        #else
        return Color.gray.opacity(0.1)
        #endif
    }

    /// Platform quaternary system fill color
    /// iOS: quaternarySystemFill; macOS: quaternaryControlColor
    static var platformQuaternarySystemFill: Color {
        #if os(iOS)
        return Color(.quaternarySystemFill)
        #elseif os(macOS)
        return Color(.controlBackgroundColor).opacity(0.6)
        #else
        return Color.gray.opacity(0.05)
        #endif
    }

    /// Platform tint color
    /// iOS: systemBlue; macOS: controlAccentColor
    static var platformTint: Color {
        #if os(iOS)
        return Color(.systemBlue)
        #elseif os(macOS)
        return Color(.controlAccentColor)
        #else
        return Color.blue
        #endif
    }

    /// Platform destructive color
    /// iOS: systemRed; macOS: systemRedColor
    static var platformDestructive: Color {
        #if os(iOS)
        return Color(.systemRed)
        #elseif os(macOS)
        return Color(.systemRed)
        #else
        return Color.red
        #endif
    }

    /// Platform success color
    /// iOS: systemGreen; macOS: systemGreenColor
    static var platformSuccess: Color {
        #if os(iOS)
        return Color(.systemGreen)
        #elseif os(macOS)
        return Color(.systemGreen)
        #else
        return Color.green
        #endif
    }

    /// Platform warning color
    /// iOS: systemOrange; macOS: systemOrangeColor
    static var platformWarning: Color {
        #if os(iOS)
        return Color(.systemOrange)
        #elseif os(macOS)
        return Color(.systemOrange)
        #else
        return Color.orange
        #endif
    }

    /// Platform info color
    /// iOS: systemBlue; macOS: systemBlueColor
    static var platformInfo: Color {
        #if os(iOS)
        return Color(.systemBlue)
        #elseif os(macOS)
        return Color(.systemBlue)
        #else
        return Color.blue
        #endif
    }
    
    /// Platform system background color
    /// iOS: systemBackground; macOS: windowBackgroundColor
    static var platformSystemBackground: Color {
        #if os(iOS)
        return Color(.systemBackground)
        #elseif os(macOS)
        return Color(.windowBackgroundColor)
        #else
        return Color.primary
        #endif
    }
    
    /// Platform system gray6 color
    /// iOS: systemGray6; macOS: controlBackgroundColor
    static var platformSystemGray6: Color {
        #if os(iOS)
        return Color(.systemGray6)
        #elseif os(macOS)
        return Color(.controlBackgroundColor)
        #else
        return Color.gray.opacity(0.1)
        #endif
    }
    
    /// Platform system gray5 color
    /// iOS: systemGray5; macOS: controlColor
    static var platformSystemGray5: Color {
        #if os(iOS)
        return Color(.systemGray5)
        #elseif os(macOS)
        return Color(.controlColor)
        #else
        return Color.gray.opacity(0.2)
        #endif
    }
    
    /// Platform system gray4 color
    /// iOS: systemGray4; macOS: controlColor
    static var platformSystemGray4: Color {
        #if os(iOS)
        return Color(.systemGray4)
        #elseif os(macOS)
        return Color(.controlColor)
        #else
        return Color.gray.opacity(0.3)
        #endif
    }
    
    /// Platform system gray3 color
    /// iOS: systemGray3; macOS: controlColor
    static var platformSystemGray3: Color {
        #if os(iOS)
        return Color(.systemGray3)
        #elseif os(macOS)
        return Color(.controlColor)
        #else
        return Color.gray.opacity(0.4)
        #endif
    }
    
    /// Platform system gray2 color
    /// iOS: systemGray2; macOS: controlColor
    static var platformSystemGray2: Color {
        #if os(iOS)
        return Color(.systemGray2)
        #elseif os(macOS)
        return Color(.controlColor)
        #else
        return Color.gray.opacity(0.5)
        #endif
    }
    
    /// Platform system gray color
    /// iOS: systemGray; macOS: systemGray
    static var platformSystemGray: Color {
        #if os(iOS)
        return Color(.systemGray)
        #elseif os(macOS)
        return Color(.systemGray)
        #else
        return Color.gray
        #endif
    }
    
    /// Platform secondary background color (alias for existing)
    static var secondaryBackground: Color {
        return platformSecondaryBackground
    }
    
    /// Platform tertiary background color
    static var tertiaryBackground: Color {
        #if os(iOS)
        return Color(.tertiarySystemBackground)
        #elseif os(macOS)
        return Color(.controlBackgroundColor).opacity(0.5)
        #else
        return Color.gray.opacity(0.1)
        #endif
    }
    
    /// Platform primary background color (alias for existing)
    static var primaryBackground: Color {
        return platformBackground
    }
    
    /// Platform card background color
    static var cardBackground: Color {
        #if os(iOS)
        return Color(.secondarySystemBackground)
        #elseif os(macOS)
        return Color(.controlBackgroundColor)
        #else
        return Color.gray.opacity(0.1)
        #endif
    }
    
    /// Platform grouped background color
    static var groupedBackground: Color {
        #if os(iOS)
        return Color(.systemGroupedBackground)
        #elseif os(macOS)
        return Color(.controlBackgroundColor)
        #else
        return Color.gray.opacity(0.05)
        #endif
    }
    
    /// Platform separator color
    static var separator: Color {
        #if os(iOS)
        return Color(.separator)
        #elseif os(macOS)
        return Color(.separatorColor)
        #else
        return Color.gray.opacity(0.3)
        #endif
    }
    
    /// Platform label color
    static var label: Color {
        #if os(iOS)
        return Color(.label)
        #elseif os(macOS)
        return Color(.labelColor)
        #else
        return Color.primary
        #endif
    }
    
    /// Platform secondary label color
    static var secondaryLabel: Color {
        #if os(iOS)
        return Color(.secondaryLabel)
        #elseif os(macOS)
        return Color(.secondaryLabelColor)
        #else
        return Color.secondary
        #endif
    }
    
    // MARK: - Additional Cross-Platform Colors (Feature Request)
    
    /// Cross-platform primary label color (alias for existing platformLabel)
    static var platformPrimaryLabel: Color {
        return platformLabel
    }
    
    /// Cross-platform placeholder text color
    /// iOS: placeholderText; macOS: placeholderTextColor
    static var platformPlaceholderText: Color {
        #if os(iOS)
        return Color(.placeholderText)
        #elseif os(macOS)
        return Color(.placeholderTextColor)
        #else
        return Color.secondary.opacity(0.6)
        #endif
    }
    
    /// Cross-platform opaque separator color
    /// iOS: opaqueSeparator; macOS: separatorColor
    static var platformOpaqueSeparator: Color {
        #if os(iOS)
        return Color(.opaqueSeparator)
        #elseif os(macOS)
        return Color(.separatorColor)
        #else
        return Color.gray.opacity(0.5)
        #endif
    }
}

// MARK: - View Extensions for Platform Colors

public extension View {

    /// Apply platform secondary background color
    /// iOS: secondarySystemBackground; macOS: controlBackgroundColor
    func platformSecondaryBackgroundColor() -> some View {
        self.background(Color.platformSecondaryBackground)
    }

    /// Apply platform grouped background color
    /// iOS: systemGroupedBackground; macOS: controlBackgroundColor
    func platformGroupedBackgroundColor() -> some View {
        self.background(Color.platformGroupedBackground)
    }

    /// Apply platform foreground color
    /// iOS: label; macOS: labelColor
    func platformForegroundColor() -> some View {
        self.foregroundColor(Color.platformLabel)
    }

    /// Apply platform secondary foreground color
    /// iOS: secondaryLabel; macOS: secondaryLabelColor
    func platformSecondaryForegroundColor() -> some View {
        self.foregroundColor(Color.platformSecondaryLabel)
    }

    /// Apply platform tertiary foreground color
    /// iOS: tertiaryLabel; macOS: tertiaryLabelColor
    func platformTertiaryForegroundColor() -> some View {
        self.foregroundColor(Color.platformTertiaryLabel)
    }

    /// Apply platform tint color
    /// iOS: systemBlue; macOS: controlAccentColor
    func platformTintColor() -> some View {
        self.foregroundColor(Color.platformTint)
    }

    /// Apply platform destructive color
    /// iOS: systemRed; macOS: systemRedColor
    func platformDestructiveColor() -> some View {
        self.foregroundColor(Color.platformDestructive)
    }

    /// Apply platform success color
    /// iOS: systemGreen; macOS: systemGreenColor
    func platformSuccessColor() -> some View {
        self.foregroundColor(Color.platformSuccess)
    }

    /// Apply platform warning color
    /// iOS: systemOrange; macOS: systemOrangeColor
    func platformWarningColor() -> some View {
        self.foregroundColor(Color.platformWarning)
    }

    /// Apply platform info color
    /// iOS: systemBlue; macOS: systemBlueColor
    func platformInfoColor() -> some View {
        self.foregroundColor(Color.platformInfo)
    }
}
