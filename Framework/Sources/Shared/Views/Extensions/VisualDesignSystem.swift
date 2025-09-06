import Foundation
import SwiftUI

// MARK: - Visual Design System
// Comprehensive theming system for cross-platform UI consistency

/// Central theme manager for the SixLayer Framework
@MainActor
public class VisualDesignSystem: ObservableObject {
    public static let shared = VisualDesignSystem()
    
    @Published public var currentTheme: Theme
    @Published public var platformStyle: PlatformStyle
    @Published public var accessibilitySettings: AccessibilitySettings
    
    private init() {
        self.currentTheme = Self.detectSystemTheme()
        self.platformStyle = Self.detectPlatformStyle()
        self.accessibilitySettings = Self.detectAccessibilitySettings()
        
        // Listen for system theme changes
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name("NSAppearanceChanged"),
            object: nil,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor in
                self?.updateTheme()
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Theme Detection
    
    private static func detectSystemTheme() -> Theme {
        #if os(iOS)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            return window.traitCollection.userInterfaceStyle == .dark ? .dark : .light
        }
        return .light // Fallback for iOS when no window is available
        #elseif os(macOS)
        let appearance = NSApp.effectiveAppearance
        return appearance.name == .darkAqua ? .dark : .light
        #else
        return .light
        #endif
    }
    
    private static func detectPlatformStyle() -> PlatformStyle {
        #if os(iOS)
        return .ios
        #elseif os(macOS)
        return .macOS
        #elseif os(watchOS)
        return .watchOS
        #elseif os(tvOS)
        return .tvOS
        #else
        return .ios // Default fallback
        #endif
    }
    
    private static func detectAccessibilitySettings() -> AccessibilitySettings {
        #if os(iOS)
        return AccessibilitySettings(
            voiceOverSupport: UIAccessibility.isVoiceOverRunning,
            keyboardNavigation: true,
            highContrastMode: UIAccessibility.isDarkerSystemColorsEnabled,
            dynamicType: true,
            reducedMotion: UIAccessibility.isReduceMotionEnabled,
            hapticFeedback: true
        )
        #elseif os(macOS)
        return AccessibilitySettings(
            voiceOverSupport: NSWorkspace.shared.isVoiceOverEnabled,
            keyboardNavigation: true,
            highContrastMode: false,
            dynamicType: true,
            reducedMotion: false,
            hapticFeedback: false
        )
        #else
        return AccessibilitySettings()
        #endif
    }
    
    private func updateTheme() {
        currentTheme = Self.detectSystemTheme()
        accessibilitySettings = Self.detectAccessibilitySettings()
    }
}

// MARK: - Theme Definitions

public enum Theme: String, CaseIterable {
    case light = "light"
    case dark = "dark"
    case auto = "auto"
    
    public var effectiveTheme: Theme {
        if self == .auto {
            return .light // Simplified for now
        }
        return self
    }
}

public enum PlatformStyle: String, CaseIterable {
    case ios = "ios"
    case macOS = "macOS"
    case watchOS = "watchOS"
    case tvOS = "tvOS"
    case visionOS = "visionOS"
}

// MARK: - Color System

public struct ColorSystem {
    public let primary: Color
    public let secondary: Color
    public let accent: Color
    public let background: Color
    public let surface: Color
    public let text: Color
    public let textSecondary: Color
    public let border: Color
    public let error: Color
    public let warning: Color
    public let success: Color
    public let info: Color
    
    public init(theme: Theme, platform: PlatformStyle) {
        let isDark = theme == .dark
        
        // Platform-specific color adjustments
        switch platform {
        case .ios:
            self.primary = isDark ? Color(red: 0.0, green: 0.48, blue: 1.0) : Color(red: 0.0, green: 0.48, blue: 1.0)
            self.secondary = isDark ? Color(red: 0.55, green: 0.55, blue: 0.57) : Color(red: 0.55, green: 0.55, blue: 0.57)
            self.accent = isDark ? Color(red: 0.0, green: 0.78, blue: 1.0) : Color(red: 0.0, green: 0.48, blue: 1.0)
            self.background = isDark ? Color(red: 0.0, green: 0.0, blue: 0.0) : Color(red: 0.95, green: 0.95, blue: 0.97)
            self.surface = isDark ? Color(red: 0.11, green: 0.11, blue: 0.12) : Color(red: 1.0, green: 1.0, blue: 1.0)
            self.text = isDark ? Color(red: 1.0, green: 1.0, blue: 1.0) : Color(red: 0.0, green: 0.0, blue: 0.0)
            self.textSecondary = isDark ? Color(red: 0.55, green: 0.55, blue: 0.57) : Color(red: 0.24, green: 0.24, blue: 0.26)
            self.border = isDark ? Color(red: 0.33, green: 0.33, blue: 0.35) : Color(red: 0.78, green: 0.78, blue: 0.8)
            self.error = isDark ? Color(red: 1.0, green: 0.23, blue: 0.19) : Color(red: 1.0, green: 0.23, blue: 0.19)
            self.warning = isDark ? Color(red: 1.0, green: 0.58, blue: 0.0) : Color(red: 1.0, green: 0.58, blue: 0.0)
            self.success = isDark ? Color(red: 0.2, green: 0.78, blue: 0.35) : Color(red: 0.2, green: 0.78, blue: 0.35)
            self.info = isDark ? Color(red: 0.0, green: 0.78, blue: 1.0) : Color(red: 0.0, green: 0.48, blue: 1.0)
            
        case .macOS:
            self.primary = isDark ? Color(red: 0.0, green: 0.48, blue: 1.0) : Color(red: 0.0, green: 0.48, blue: 1.0)
            self.secondary = isDark ? Color(red: 0.55, green: 0.55, blue: 0.57) : Color(red: 0.55, green: 0.55, blue: 0.57)
            self.accent = isDark ? Color(red: 0.0, green: 0.78, blue: 1.0) : Color(red: 0.0, green: 0.48, blue: 1.0)
            self.background = isDark ? Color(red: 0.11, green: 0.11, blue: 0.12) : Color(red: 0.95, green: 0.95, blue: 0.97)
            self.surface = isDark ? Color(red: 0.18, green: 0.18, blue: 0.18) : Color(red: 1.0, green: 1.0, blue: 1.0)
            self.text = isDark ? Color(red: 1.0, green: 1.0, blue: 1.0) : Color(red: 0.0, green: 0.0, blue: 0.0)
            self.textSecondary = isDark ? Color(red: 0.55, green: 0.55, blue: 0.57) : Color(red: 0.24, green: 0.24, blue: 0.26)
            self.border = isDark ? Color(red: 0.33, green: 0.33, blue: 0.35) : Color(red: 0.78, green: 0.78, blue: 0.8)
            self.error = isDark ? Color(red: 1.0, green: 0.23, blue: 0.19) : Color(red: 1.0, green: 0.23, blue: 0.19)
            self.warning = isDark ? Color(red: 1.0, green: 0.58, blue: 0.0) : Color(red: 1.0, green: 0.58, blue: 0.0)
            self.success = isDark ? Color(red: 0.2, green: 0.78, blue: 0.35) : Color(red: 0.2, green: 0.78, blue: 0.35)
            self.info = isDark ? Color(red: 0.0, green: 0.78, blue: 1.0) : Color(red: 0.0, green: 0.48, blue: 1.0)
            
        case .watchOS:
            // watchOS specific colors - more vibrant and high contrast
            self.primary = isDark ? Color(red: 0.0, green: 0.78, blue: 1.0) : Color(red: 0.0, green: 0.48, blue: 1.0)
            self.secondary = isDark ? Color(red: 0.7, green: 0.7, blue: 0.7) : Color(red: 0.4, green: 0.4, blue: 0.4)
            self.accent = isDark ? Color(red: 0.0, green: 0.9, blue: 1.0) : Color(red: 0.0, green: 0.6, blue: 1.0)
            self.background = isDark ? Color(red: 0.0, green: 0.0, blue: 0.0) : Color(red: 0.95, green: 0.95, blue: 0.97)
            self.surface = isDark ? Color(red: 0.15, green: 0.15, blue: 0.15) : Color(red: 1.0, green: 1.0, blue: 1.0)
            self.text = isDark ? Color(red: 1.0, green: 1.0, blue: 1.0) : Color(red: 0.0, green: 0.0, blue: 0.0)
            self.textSecondary = isDark ? Color(red: 0.7, green: 0.7, blue: 0.7) : Color(red: 0.3, green: 0.3, blue: 0.3)
            self.border = isDark ? Color(red: 0.4, green: 0.4, blue: 0.4) : Color(red: 0.7, green: 0.7, blue: 0.7)
            self.error = isDark ? Color(red: 1.0, green: 0.3, blue: 0.3) : Color(red: 1.0, green: 0.2, blue: 0.2)
            self.warning = isDark ? Color(red: 1.0, green: 0.7, blue: 0.0) : Color(red: 1.0, green: 0.6, blue: 0.0)
            self.success = isDark ? Color(red: 0.3, green: 0.9, blue: 0.5) : Color(red: 0.2, green: 0.8, blue: 0.4)
            self.info = isDark ? Color(red: 0.0, green: 0.9, blue: 1.0) : Color(red: 0.0, green: 0.6, blue: 1.0)
            
        case .tvOS:
            // tvOS specific colors - optimized for TV viewing
            self.primary = isDark ? Color(red: 0.0, green: 0.78, blue: 1.0) : Color(red: 0.0, green: 0.48, blue: 1.0)
            self.secondary = isDark ? Color(red: 0.6, green: 0.6, blue: 0.6) : Color(red: 0.4, green: 0.4, blue: 0.4)
            self.accent = isDark ? Color(red: 0.0, green: 0.9, blue: 1.0) : Color(red: 0.0, green: 0.6, blue: 1.0)
            self.background = isDark ? Color(red: 0.0, green: 0.0, blue: 0.0) : Color(red: 0.95, green: 0.95, blue: 0.97)
            self.surface = isDark ? Color(red: 0.1, green: 0.1, blue: 0.1) : Color(red: 1.0, green: 1.0, blue: 1.0)
            self.text = isDark ? Color(red: 1.0, green: 1.0, blue: 1.0) : Color(red: 0.0, green: 0.0, blue: 0.0)
            self.textSecondary = isDark ? Color(red: 0.6, green: 0.6, blue: 0.6) : Color(red: 0.3, green: 0.3, blue: 0.3)
            self.border = isDark ? Color(red: 0.3, green: 0.3, blue: 0.3) : Color(red: 0.7, green: 0.7, blue: 0.7)
            self.error = isDark ? Color(red: 1.0, green: 0.3, blue: 0.3) : Color(red: 1.0, green: 0.2, blue: 0.2)
            self.warning = isDark ? Color(red: 1.0, green: 0.7, blue: 0.0) : Color(red: 1.0, green: 0.6, blue: 0.0)
            self.success = isDark ? Color(red: 0.3, green: 0.9, blue: 0.5) : Color(red: 0.2, green: 0.8, blue: 0.4)
            self.info = isDark ? Color(red: 0.0, green: 0.9, blue: 1.0) : Color(red: 0.0, green: 0.6, blue: 1.0)
            
        case .visionOS:
            // visionOS specific colors - optimized for spatial computing
            self.primary = isDark ? Color(red: 0.0, green: 0.78, blue: 1.0) : Color(red: 0.0, green: 0.48, blue: 1.0)
            self.secondary = isDark ? Color(red: 0.6, green: 0.6, blue: 0.6) : Color(red: 0.4, green: 0.4, blue: 0.4)
            self.accent = isDark ? Color(red: 0.0, green: 0.9, blue: 1.0) : Color(red: 0.0, green: 0.6, blue: 1.0)
            self.background = isDark ? Color(red: 0.05, green: 0.05, blue: 0.05) : Color(red: 0.98, green: 0.98, blue: 0.98)
            self.surface = isDark ? Color(red: 0.12, green: 0.12, blue: 0.12) : Color(red: 1.0, green: 1.0, blue: 1.0)
            self.text = isDark ? Color(red: 1.0, green: 1.0, blue: 1.0) : Color(red: 0.0, green: 0.0, blue: 0.0)
            self.textSecondary = isDark ? Color(red: 0.6, green: 0.6, blue: 0.6) : Color(red: 0.3, green: 0.3, blue: 0.3)
            self.border = isDark ? Color(red: 0.3, green: 0.3, blue: 0.3) : Color(red: 0.7, green: 0.7, blue: 0.7)
            self.error = isDark ? Color(red: 1.0, green: 0.3, blue: 0.3) : Color(red: 1.0, green: 0.2, blue: 0.2)
            self.warning = isDark ? Color(red: 1.0, green: 0.7, blue: 0.0) : Color(red: 1.0, green: 0.6, blue: 0.0)
            self.success = isDark ? Color(red: 0.3, green: 0.9, blue: 0.5) : Color(red: 0.2, green: 0.8, blue: 0.4)
            self.info = isDark ? Color(red: 0.0, green: 0.9, blue: 1.0) : Color(red: 0.0, green: 0.6, blue: 1.0)
        }
    }
}

// MARK: - Typography System

public struct TypographySystem {
    public let largeTitle: Font
    public let title1: Font
    public let title2: Font
    public let title3: Font
    public let headline: Font
    public let body: Font
    public let callout: Font
    public let subheadline: Font
    public let footnote: Font
    public let caption1: Font
    public let caption2: Font
    
    public init(platform: PlatformStyle, accessibility: AccessibilitySettings) {
        let scaleFactor = accessibility.typographyScaleFactor
        
        switch platform {
        case .ios:
            self.largeTitle = .largeTitle.weight(.bold).scale(scaleFactor)
            self.title1 = .title.weight(.bold).scale(scaleFactor)
            self.title2 = .title2.weight(.bold).scale(scaleFactor)
            self.title3 = .title3.weight(.semibold).scale(scaleFactor)
            self.headline = .headline.weight(.semibold).scale(scaleFactor)
            self.body = .body.scale(scaleFactor)
            self.callout = .callout.scale(scaleFactor)
            self.subheadline = .subheadline.scale(scaleFactor)
            self.footnote = .footnote.scale(scaleFactor)
            self.caption1 = .caption.scale(scaleFactor)
            self.caption2 = .caption2.scale(scaleFactor)
            
        case .macOS:
            self.largeTitle = .system(size: 34 * scaleFactor, weight: .bold, design: .default)
            self.title1 = .system(size: 28 * scaleFactor, weight: .bold, design: .default)
            self.title2 = .system(size: 22 * scaleFactor, weight: .bold, design: .default)
            self.title3 = .system(size: 20 * scaleFactor, weight: .semibold, design: .default)
            self.headline = .system(size: 17 * scaleFactor, weight: .semibold, design: .default)
            self.body = .system(size: 17 * scaleFactor, weight: .regular, design: .default)
            self.callout = .system(size: 16 * scaleFactor, weight: .regular, design: .default)
            self.subheadline = .system(size: 15 * scaleFactor, weight: .regular, design: .default)
            self.footnote = .system(size: 13 * scaleFactor, weight: .regular, design: .default)
            self.caption1 = .system(size: 12 * scaleFactor, weight: .regular, design: .default)
            self.caption2 = .system(size: 11 * scaleFactor, weight: .regular, design: .default)
            
        case .watchOS:
            self.largeTitle = .system(size: 28 * scaleFactor, weight: .bold, design: .default)
            self.title1 = .system(size: 24 * scaleFactor, weight: .bold, design: .default)
            self.title2 = .system(size: 20 * scaleFactor, weight: .bold, design: .default)
            self.title3 = .system(size: 18 * scaleFactor, weight: .semibold, design: .default)
            self.headline = .system(size: 16 * scaleFactor, weight: .semibold, design: .default)
            self.body = .system(size: 16 * scaleFactor, weight: .regular, design: .default)
            self.callout = .system(size: 15 * scaleFactor, weight: .regular, design: .default)
            self.subheadline = .system(size: 14 * scaleFactor, weight: .regular, design: .default)
            self.footnote = .system(size: 12 * scaleFactor, weight: .regular, design: .default)
            self.caption1 = .system(size: 11 * scaleFactor, weight: .regular, design: .default)
            self.caption2 = .system(size: 10 * scaleFactor, weight: .regular, design: .default)
            
        case .tvOS:
            self.largeTitle = .system(size: 48 * scaleFactor, weight: .bold, design: .default)
            self.title1 = .system(size: 40 * scaleFactor, weight: .bold, design: .default)
            self.title2 = .system(size: 32 * scaleFactor, weight: .bold, design: .default)
            self.title3 = .system(size: 28 * scaleFactor, weight: .semibold, design: .default)
            self.headline = .system(size: 24 * scaleFactor, weight: .semibold, design: .default)
            self.body = .system(size: 24 * scaleFactor, weight: .regular, design: .default)
            self.callout = .system(size: 22 * scaleFactor, weight: .regular, design: .default)
            self.subheadline = .system(size: 20 * scaleFactor, weight: .regular, design: .default)
            self.footnote = .system(size: 18 * scaleFactor, weight: .regular, design: .default)
            self.caption1 = .system(size: 16 * scaleFactor, weight: .regular, design: .default)
            self.caption2 = .system(size: 14 * scaleFactor, weight: .regular, design: .default)
            
        case .visionOS:
            // visionOS specific typography - optimized for spatial computing
            self.largeTitle = .system(size: 36 * scaleFactor, weight: .bold, design: .default)
            self.title1 = .system(size: 30 * scaleFactor, weight: .bold, design: .default)
            self.title2 = .system(size: 24 * scaleFactor, weight: .bold, design: .default)
            self.title3 = .system(size: 22 * scaleFactor, weight: .semibold, design: .default)
            self.headline = .system(size: 20 * scaleFactor, weight: .semibold, design: .default)
            self.body = .system(size: 18 * scaleFactor, weight: .regular, design: .default)
            self.callout = .system(size: 17 * scaleFactor, weight: .regular, design: .default)
            self.subheadline = .system(size: 16 * scaleFactor, weight: .regular, design: .default)
            self.footnote = .system(size: 14 * scaleFactor, weight: .regular, design: .default)
            self.caption1 = .system(size: 13 * scaleFactor, weight: .regular, design: .default)
            self.caption2 = .system(size: 12 * scaleFactor, weight: .regular, design: .default)
        }
    }
}

// MARK: - Accessibility Settings Extension

public extension AccessibilitySettings {
    var typographyScaleFactor: CGFloat {
        // Simplified scale factor for now
        return 1.0
    }
}

public enum ContentSizeCategory: String, CaseIterable {
    case extraSmall = "extraSmall"
    case small = "small"
    case medium = "medium"
    case large = "large"
    case extraLarge = "extraLarge"
    case extraExtraLarge = "extraExtraLarge"
    case extraExtraExtraLarge = "extraExtraExtraLarge"
    case accessibilityMedium = "accessibilityMedium"
    case accessibilityLarge = "accessibilityLarge"
    case accessibilityExtraLarge = "accessibilityExtraLarge"
    case accessibilityExtraExtraLarge = "accessibilityExtraExtraLarge"
    case accessibilityExtraExtraExtraLarge = "accessibilityExtraExtraExtraLarge"
}

// MARK: - View Extensions

public extension View {
    /// Apply the current theme colors to this view
    func themedColors() -> some View {
        self.environmentObject(VisualDesignSystem.shared)
    }
    
    /// Apply platform-specific styling
    func platformStyled() -> some View {
        self.environmentObject(VisualDesignSystem.shared)
    }
    
    /// Apply accessibility-aware styling
    func accessibilityStyled() -> some View {
        self.environmentObject(VisualDesignSystem.shared)
    }
}

// MARK: - Environment Values

private struct ThemeEnvironmentKey: EnvironmentKey {
    static let defaultValue = Theme.light
}

private struct PlatformStyleEnvironmentKey: EnvironmentKey {
    static let defaultValue = PlatformStyle.ios
}

private struct ColorSystemEnvironmentKey: EnvironmentKey {
    static let defaultValue = ColorSystem(theme: .light, platform: .ios)
}

private struct TypographySystemEnvironmentKey: EnvironmentKey {
    static let defaultValue = TypographySystem(platform: .ios, accessibility: AccessibilitySettings())
}

public extension EnvironmentValues {
    var theme: Theme {
        get { self[ThemeEnvironmentKey.self] }
        set { self[ThemeEnvironmentKey.self] = newValue }
    }
    
    var platformStyle: PlatformStyle {
        get { self[PlatformStyleEnvironmentKey.self] }
        set { self[PlatformStyleEnvironmentKey.self] = newValue }
    }
    
    var colorSystem: ColorSystem {
        get { self[ColorSystemEnvironmentKey.self] }
        set { self[ColorSystemEnvironmentKey.self] = newValue }
    }
    
    var typographySystem: TypographySystem {
        get { self[TypographySystemEnvironmentKey.self] }
        set { self[TypographySystemEnvironmentKey.self] = newValue }
    }
}

// MARK: - Font Extension

extension Font {
    func scale(_ factor: CGFloat) -> Font {
        // This is a simplified scaling approach
        // In a real implementation, you'd want to use Dynamic Type
        return self
    }
}
