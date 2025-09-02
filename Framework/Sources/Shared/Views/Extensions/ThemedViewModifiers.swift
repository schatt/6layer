import Foundation
import SwiftUI

// MARK: - Themed View Modifiers
// Comprehensive view modifiers for applying theme-aware styling

// ThemedButtonStyle removed due to compilation issues - using AdaptiveUIPatterns.AdaptiveButton instead

public enum ButtonVariant: String, CaseIterable {
    case primary = "primary"
    case secondary = "secondary"
    case outline = "outline"
    case ghost = "ghost"
}

public enum ButtonSize: String, CaseIterable {
    case small = "small"
    case medium = "medium"
    case large = "large"
}

/// Themed card style that adapts to platform and theme
public struct ThemedCardStyle: ViewModifier {
    @Environment(\.colorSystem) private var colors
    @Environment(\.platformStyle) private var platform
    @Environment(\.accessibilitySettings) private var accessibility
    
        public func body(content: Content) -> some View {
        content
            .background(colors.surface)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(colors.border, lineWidth: borderWidth)
            )
            .shadow(
                color: shadowColor,
                radius: shadowRadius,
                x: shadowOffset.width,
                y: shadowOffset.height
            )
    }
    
    private var cornerRadius: CGFloat {
        switch platform {
        case .ios: return 12
        case .macOS: return 8
        case .watchOS: return 16
        case .tvOS: return 12
        }
    }
    
    private var borderWidth: CGFloat {
        switch platform {
        case .ios: return 0.5
        case .macOS: return 1
        case .watchOS: return 0
        case .tvOS: return 0.5
        }
    }
    
    private var shadowColor: Color {
        switch platform {
        case .ios: return Color.black.opacity(0.1)
        case .macOS: return Color.black.opacity(0.05)
        case .watchOS: return Color.clear
        case .tvOS: return Color.black.opacity(0.2)
        }
    }
    
    private var shadowRadius: CGFloat {
        switch platform {
        case .ios: return 8
        case .macOS: return 4
        case .watchOS: return 0
        case .tvOS: return 12
        }
    }
    
    private var shadowOffset: CGSize {
        switch platform {
        case .ios: return CGSize(width: 0, height: 2)
        case .macOS: return CGSize(width: 0, height: 1)
        case .watchOS: return CGSize.zero
        case .tvOS: return CGSize(width: 0, height: 4)
        }
    }
}

/// Themed list style that adapts to platform
public struct ThemedListStyle: ViewModifier {
    @Environment(\.colorSystem) private var colors
    @Environment(\.platformStyle) private var platform
    
        public func body(content: Content) -> some View {
        content
            #if os(iOS)
            .listStyle(.insetGrouped)
            #elseif os(macOS)
            .listStyle(.sidebar)
            #else
            .listStyle(.plain)
            #endif
            .scrollContentBackground(.hidden)
            .background(colors.background)
    }
    
    // listStyle removed due to compilation issues
}

/// Themed navigation style that adapts to platform
public struct ThemedNavigationStyle: ViewModifier {
    @Environment(\.colorSystem) private var colors
    @Environment(\.platformStyle) private var platform
    
        public func body(content: Content) -> some View {
        content
            .navigationViewStyle(navigationViewStyle)
            .background(colors.background)
    }
    
    private var navigationViewStyle: some NavigationViewStyle {
        #if os(iOS)
        return .stack
        #elseif os(macOS)
        return .columns
        #else
        return .stack
        #endif
    }
}

/// Themed form style that adapts to platform
public struct ThemedFormStyle: ViewModifier {
    @Environment(\.colorSystem) private var colors
    @Environment(\.platformStyle) private var platform
    
        public func body(content: Content) -> some View {
        content
            .formStyle(formStyle)
            .background(colors.background)
    }
    
    private var formStyle: some FormStyle {
        switch platform {
        case .ios: return .grouped
        case .macOS: return .grouped
        case .watchOS: return .grouped
        case .tvOS: return .grouped
        }
    }
}

/// Themed text field style that adapts to platform
public struct ThemedTextFieldStyle: TextFieldStyle {
    @Environment(\.colorSystem) private var colors
    @Environment(\.platformStyle) private var platform
    @Environment(\.accessibilitySettings) private var accessibility
    
    public func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(textFieldPadding)
            .background(colors.surface)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(colors.border, lineWidth: borderWidth)
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
    
    private var textFieldPadding: EdgeInsets {
        switch platform {
        case .ios: return EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)
        case .macOS: return EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)
        case .watchOS: return EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)
        case .tvOS: return EdgeInsets(top: 16, leading: 20, bottom: 16, trailing: 20)
        }
    }
    
    private var cornerRadius: CGFloat {
        switch platform {
        case .ios: return 8
        case .macOS: return 6
        case .watchOS: return 12
        case .tvOS: return 8
        }
    }
    
    private var borderWidth: CGFloat {
        switch platform {
        case .ios: return 1
        case .macOS: return 1
        case .watchOS: return 0
        case .tvOS: return 1
        }
    }
}

/// Themed loading indicator that adapts to platform
public struct ThemedLoadingIndicator: View {
    @Environment(\.colorSystem) private var colors
    @Environment(\.platformStyle) private var platform
    @Environment(\.accessibilitySettings) private var accessibility
    @State private var isAnimating = false
    
    public init() {}
    
    public var body: some View {
        Group {
            if accessibility.reducedMotion {
                // Static indicator for reduced motion
                Circle()
                    .fill(colors.primary)
                    .frame(width: 20, height: 20)
            } else {
                // Animated indicator
                Circle()
                    .trim(from: 0, to: 0.7)
                    .stroke(colors.primary, lineWidth: 3)
                    .frame(width: 20, height: 20)
                    .rotationEffect(.degrees(isAnimating ? 360 : 0))
                    .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: isAnimating)
                    .onAppear {
                        isAnimating = true
                    }
            }
        }
    }
}

/// Themed progress bar that adapts to platform
public struct ThemedProgressBar: View {
    let progress: Double
    let variant: ProgressVariant
    
    @Environment(\.colorSystem) private var colors
    @Environment(\.platformStyle) private var platform
    
    public init(progress: Double, variant: ProgressVariant = .primary) {
        self.progress = max(0, min(1, progress))
        self.variant = variant
    }
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(colors.surface)
                    .frame(height: height)
                
                // Progress
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(progressColor)
                    .frame(width: geometry.size.width * progress, height: height)
                    .animation(.easeInOut(duration: 0.3), value: progress)
            }
        }
        .frame(height: height)
    }
    
    private var height: CGFloat {
        switch platform {
        case .ios: return 4
        case .macOS: return 6
        case .watchOS: return 3
        case .tvOS: return 6
        }
    }
    
    private var cornerRadius: CGFloat {
        height / 2
    }
    
    private var progressColor: Color {
        switch variant {
        case .primary: return colors.primary
        case .success: return colors.success
        case .warning: return colors.warning
        case .error: return colors.error
        }
    }
}

public enum ProgressVariant: String, CaseIterable {
    case primary = "primary"
    case success = "success"
    case warning = "warning"
    case error = "error"
}

// MARK: - View Extensions

public extension View {
    /// Apply themed button styling - use AdaptiveUIPatterns.AdaptiveButton instead
    // func themedButton(variant: ButtonVariant = .primary, size: ButtonSize = .medium) -> some View {
    //     self.buttonStyle(ThemedButtonStyle(variant: variant, size: size))
    // }
    
    /// Apply themed card styling
    func themedCard() -> some View {
        self.modifier(ThemedCardStyle())
    }
    
    /// Apply themed list styling
    func themedList() -> some View {
        self.modifier(ThemedListStyle())
    }
    
    /// Apply themed navigation styling
    func themedNavigation() -> some View {
        self.modifier(ThemedNavigationStyle())
    }
    
    /// Apply themed form styling
    func themedForm() -> some View {
        self.modifier(ThemedFormStyle())
    }
    
    /// Apply themed text field styling
    func themedTextField() -> some View {
        self.textFieldStyle(ThemedTextFieldStyle())
    }
}

// MARK: - Environment Extensions

private struct AccessibilitySettingsEnvironmentKey: EnvironmentKey {
    static let defaultValue = AccessibilitySettings()
}

public extension EnvironmentValues {
    var accessibilitySettings: AccessibilitySettings {
        get { self[AccessibilitySettingsEnvironmentKey.self] }
        set { self[AccessibilitySettingsEnvironmentKey.self] = newValue }
    }
}
