import Foundation
import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

// MARK: - Apple HIG Compliance Modifier

/// Main modifier that applies comprehensive Apple HIG compliance
public struct AppleHIGComplianceModifier: ViewModifier {
    let manager: AppleHIGComplianceManager
    let complianceLevel: HIGComplianceLevel
    
    public func body(content: Content) -> some View {
        content
            .modifier(SystemAccessibilityModifier(
                accessibilityState: manager.accessibilityState,
                platform: manager.currentPlatform
            ))
            .modifier(PlatformPatternModifier(
                designSystem: manager.designSystem,
                platform: manager.currentPlatform
            ))
            .modifier(VisualConsistencyModifier(
                designSystem: manager.designSystem,
                platform: manager.currentPlatform,
                visualDesignConfig: manager.visualDesignConfig,
                iOSConfig: manager.currentPlatform == .iOS ? manager.iOSCategoryConfig : nil
            ))
            .modifier(InteractionPatternModifier(
                platform: manager.currentPlatform,
                accessibilityState: manager.accessibilityState,
                iOSConfig: manager.currentPlatform == .iOS ? manager.iOSCategoryConfig : nil,
                macOSConfig: manager.currentPlatform == .macOS ? manager.macOSCategoryConfig : nil
            ))
            .modifier(PlatformSpecificCategoryModifier(
                platform: manager.currentPlatform,
                iOSConfig: manager.currentPlatform == .iOS ? manager.iOSCategoryConfig : nil,
                macOSConfig: manager.currentPlatform == .macOS ? manager.macOSCategoryConfig : nil
            ))
            .automaticCompliance()
    }
}

// MARK: - Automatic Accessibility Modifier

/// Automatically applies Apple HIG compliance features based on system state
public struct SystemAccessibilityModifier: ViewModifier {
    let accessibilityState: AccessibilitySystemState
    let platform: SixLayerPlatform
    
    public func body(content: Content) -> some View {
        content
            .modifier(VoiceOverSupportModifier(
                isEnabled: accessibilityState.isVoiceOverRunning
            ))
            .modifier(KeyboardNavigationModifier(
                hasKeyboardSupport: accessibilityState.hasKeyboardSupport,
                hasFullKeyboardAccess: accessibilityState.hasFullKeyboardAccess
            ))
            .modifier(HighContrastModifier(
                isEnabled: accessibilityState.isHighContrastEnabled
            ))
            .modifier(ReducedMotionModifier(
                isEnabled: accessibilityState.isReducedMotionEnabled
            ))
            .modifier(DynamicTypeModifier())
            .automaticCompliance() // FIXED: Add missing accessibility identifier generation
    }
}

// MARK: - Platform Pattern Modifier

/// Applies platform-specific design patterns
public struct PlatformPatternModifier: ViewModifier {
    let designSystem: PlatformDesignSystem
    let platform: SixLayerPlatform
    
    public func body(content: Content) -> some View {
        content
            .modifier(PlatformNavigationModifier(platform: platform))
            .modifier(PlatformStylingModifier(designSystem: designSystem))
            .modifier(PlatformIconModifier(iconSystem: designSystem.iconSystem))
            .automaticCompliance()
    }
}

// MARK: - Visual Consistency Modifier

/// Applies visual design consistency following Apple's guidelines
public struct VisualConsistencyModifier: ViewModifier {
    let designSystem: PlatformDesignSystem
    let platform: SixLayerPlatform
    let visualDesignConfig: HIGVisualDesignCategoryConfig
    let iOSConfig: HIGiOSCategoryConfig?
    
    public func body(content: Content) -> some View {
        content
            .modifier(SystemColorModifier(colorSystem: designSystem.colorSystem))
            .modifier(SystemTypographyModifier(typographySystem: designSystem.typographySystem))
            .modifier(SpacingModifier(spacingSystem: designSystem.spacingSystem))
            .modifier(TouchTargetModifier(
                platform: platform,
                iOSConfig: iOSConfig
            ))
            .modifier(SafeAreaComplianceModifier(
                platform: platform,
                iOSConfig: iOSConfig
            ))
            .modifier(VisualDesignCategoryModifier(
                visualDesignSystem: designSystem.visualDesignSystem,
                config: visualDesignConfig
            ))
            .automaticCompliance()
    }
}

// MARK: - Visual Design Category Modifier

/// Applies visual design categories from the visual design system based on configuration
/// 
/// This modifier automatically applies visual design categories according to the
/// configuration set in `AppleHIGComplianceManager.visualDesignConfig`. Developers
/// can control which categories are applied automatically:
///
/// ```swift
/// // Configure at app startup
/// let manager = AppleHIGComplianceManager()
/// manager.visualDesignConfig.applyShadows = true
/// manager.visualDesignConfig.applyCornerRadius = true
/// ```
///
/// Individual categories can still be applied explicitly using:
/// - `.higAnimationCategory()` for animations
/// - `.higShadowCategory()` for shadows
/// - `.higCornerRadiusCategory()` for corner radius
/// - `.higBorderWidthCategory()` for borders
/// - `.higOpacityCategory()` for opacity
/// - `.higBlurCategory()` for blur
public struct VisualDesignCategoryModifier: ViewModifier {
    let visualDesignSystem: HIGVisualDesignSystem
    let config: HIGVisualDesignCategoryConfig
    
    public init(visualDesignSystem: HIGVisualDesignSystem, config: HIGVisualDesignCategoryConfig) {
        self.visualDesignSystem = visualDesignSystem
        self.config = config
    }
    
    public func body(content: Content) -> some View {
        applyVisualDesignCategories(to: content, visualDesignSystem: visualDesignSystem, config: config)
    }
    
    // MARK: - Cross-Platform Implementation
    
    /// Apply visual design categories based on configuration
    private func applyVisualDesignCategories<Content: View>(
        to content: Content,
        visualDesignSystem: HIGVisualDesignSystem,
        config: HIGVisualDesignCategoryConfig
    ) -> some View {
        var modifiedContent: AnyView = AnyView(content)
        
        // Note: Animations are not applied automatically because SwiftUI animations
        // should be tied to specific state changes, not applied globally.
        // Use `.higAnimationCategory()` or `.animation(_:value:)` with state changes instead.
        // The `applyAnimations` config flag is reserved for future use when we have
        // a better way to apply animations automatically.
        
        if config.applyShadows {
            let shadow = visualDesignSystem.shadowSystem.shadow(for: config.defaultShadowCategory)
            modifiedContent = AnyView(
                modifiedContent
                    .shadow(
                        color: shadow.color,
                        radius: shadow.radius,
                        x: shadow.offset.width,
                        y: shadow.offset.height
                    )
            )
        }
        
        if config.applyCornerRadius {
            let radius = visualDesignSystem.cornerRadiusSystem.radius(for: config.defaultCornerRadiusCategory)
            modifiedContent = AnyView(
                modifiedContent
                    .clipShape(RoundedRectangle(cornerRadius: radius))
            )
        }
        
        if config.applyBorders {
            let borderWidth = visualDesignSystem.borderWidthSystem.width(for: config.defaultBorderWidthCategory)
            modifiedContent = AnyView(
                modifiedContent
                    .overlay(
                        RoundedRectangle(cornerRadius: 0)
                            .stroke(Color.separator, lineWidth: borderWidth)
                    )
            )
        }
        
        if config.applyOpacity {
            let opacity = visualDesignSystem.opacitySystem.opacity(for: config.defaultOpacityCategory)
            modifiedContent = AnyView(
                modifiedContent
                    .opacity(opacity)
            )
        }
        
        if config.applyBlur {
            let blur = visualDesignSystem.blurSystem.blur(for: config.defaultBlurCategory)
            modifiedContent = AnyView(
                modifiedContent
                    .blur(radius: blur.radius)
            )
        }
        
        return AnyView(modifiedContent.automaticCompliance())
    }
}

// MARK: - Interaction Pattern Modifier

/// Applies platform-appropriate interaction patterns
public struct InteractionPatternModifier: ViewModifier {
    let platform: SixLayerPlatform
    let accessibilityState: AccessibilitySystemState
    let iOSConfig: HIGiOSCategoryConfig?
    let macOSConfig: HIGmacOSCategoryConfig?
    
    public init(
        platform: SixLayerPlatform,
        accessibilityState: AccessibilitySystemState,
        iOSConfig: HIGiOSCategoryConfig? = nil,
        macOSConfig: HIGmacOSCategoryConfig? = nil
    ) {
        self.platform = platform
        self.accessibilityState = accessibilityState
        self.iOSConfig = iOSConfig
        self.macOSConfig = macOSConfig
    }
    
    public func body(content: Content) -> some View {
        content
            .modifier(PlatformInteractionModifier(platform: platform, macOSConfig: macOSConfig))
            .modifier(HapticFeedbackModifier(platform: platform, iOSConfig: iOSConfig))
            .modifier(GestureRecognitionModifier(platform: platform, iOSConfig: iOSConfig))
            .automaticCompliance()
    }
}

// MARK: - Individual Modifiers

/// VoiceOver support modifier
public struct VoiceOverSupportModifier: ViewModifier {
    let isEnabled: Bool
    
    public func body(content: Content) -> some View {
        if isEnabled {
            content
                .accessibilityLabel(extractAccessibilityLabel(from: content))
                .accessibilityHint(extractAccessibilityHint(from: content))
                .accessibilityAddTraits(extractAccessibilityTraits(from: content))
                .automaticCompliance()
        } else {
            content
                .automaticCompliance()
        }
    }
    
    private func extractAccessibilityLabel(from content: Content) -> String {
        // Extract accessibility label from view content
        // This would use reflection or view introspection in a real implementation
        return "Interactive element"
    }
    
    private func extractAccessibilityHint(from content: Content) -> String {
        // Extract accessibility hint from view content
        return "Tap to activate"
    }
    
    private func extractAccessibilityTraits(from content: Content) -> AccessibilityTraits {
        // Extract accessibility traits from view content
        return .isButton
    }
}

/// Keyboard navigation modifier
public struct KeyboardNavigationModifier: ViewModifier {
    let hasKeyboardSupport: Bool
    let hasFullKeyboardAccess: Bool
    
    public func body(content: Content) -> some View {
        applyKeyboardNavigation(to: content, hasKeyboardSupport: hasKeyboardSupport, hasFullKeyboardAccess: hasFullKeyboardAccess)
    }
    
    // MARK: - Cross-Platform Implementation
    
    /// Apply keyboard navigation with platform-specific behavior
    private func applyKeyboardNavigation<Content: View>(
        to content: Content,
        hasKeyboardSupport: Bool,
        hasFullKeyboardAccess: Bool
    ) -> some View {
        guard hasKeyboardSupport else {
            return AnyView(content.automaticCompliance())
        }
        
        #if os(macOS)
        return AnyView(macOSKeyboardNavigation(to: content, hasFullKeyboardAccess: hasFullKeyboardAccess))
        #elseif os(iOS) || os(tvOS) || os(watchOS)
        return AnyView(iosKeyboardNavigation(to: content))
        #else
        return AnyView(fallbackKeyboardNavigation(to: content))
        #endif
    }
    
    // MARK: - Platform-Specific Implementations
    
    #if os(macOS)
    @available(macOS 14.0, *)
    private func macOSKeyboardNavigation<Content: View>(
        to content: Content,
        hasFullKeyboardAccess: Bool
    ) -> some View {
        AnyView(
            content
                .focusable()
                .onKeyPress(.return) {
                    // Handle keyboard activation
                    return .handled
                }
                .automaticCompliance()
        )
    }
    #endif
    
    #if os(iOS) || os(tvOS) || os(watchOS)
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    private func iosKeyboardNavigation<Content: View>(to content: Content) -> some View {
        AnyView(content.focusable().automaticCompliance())
    }
    #endif
    
    private func fallbackKeyboardNavigation<Content: View>(to content: Content) -> some View {
        AnyView(content.automaticCompliance())
    }
}

/// High contrast modifier
public struct HighContrastModifier: ViewModifier {
    let isEnabled: Bool
    
    public func body(content: Content) -> some View {
        applyHighContrast(to: content, isEnabled: isEnabled)
    }
    
    // MARK: - Cross-Platform Implementation
    
    /// Apply high contrast with platform-specific behavior
    private func applyHighContrast<Content: View>(to content: Content, isEnabled: Bool) -> some View {
        guard isEnabled else {
            return AnyView(content.automaticCompliance())
        }
        
        #if canImport(UIKit)
        return AnyView(iosHighContrast(to: content))
        #elseif os(macOS)
        return AnyView(macOSHighContrast(to: content))
        #else
        return AnyView(fallbackHighContrast(to: content))
        #endif
    }
    
    // MARK: - Platform-Specific Implementations
    
    #if canImport(UIKit)
    private func iosHighContrast<Content: View>(to content: Content) -> some View {
        AnyView(
            content
                .foregroundColor(.primary)
                .background(Color(UIColor.systemBackground))
                .automaticCompliance()
        )
    }
    #endif
    
    #if os(macOS)
    private func macOSHighContrast<Content: View>(to content: Content) -> some View {
        AnyView(
            content
                .foregroundColor(.primary)
                .background(.gray)
                .automaticCompliance()
        )
    }
    #endif
    
    private func fallbackHighContrast<Content: View>(to content: Content) -> some View {
        AnyView(content.automaticCompliance())
    }
}

/// Reduced motion modifier
public struct ReducedMotionModifier: ViewModifier {
    let isEnabled: Bool
    
    public func body(content: Content) -> some View {
        if isEnabled {
            content
                .animation(.none, value: UUID())
                .automaticCompliance()
        } else {
            content
                .automaticCompliance()
        }
    }
}

/// Dynamic type modifier
public struct DynamicTypeModifier: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .dynamicTypeSize(.accessibility1...)
            .automaticCompliance()
    }
}

/// Platform navigation modifier
public struct PlatformNavigationModifier: ViewModifier {
    let platform: SixLayerPlatform
    
    public func body(content: Content) -> some View {
        applyPlatformNavigation(to: content, platform: platform)
    }
    
    // MARK: - Cross-Platform Implementation
    
    /// Apply platform-specific navigation patterns
    private func applyPlatformNavigation<Content: View>(
        to content: Content,
        platform: SixLayerPlatform
    ) -> some View {
        switch platform {
        case .iOS:
            #if os(iOS)
            return AnyView(iosPlatformNavigation(to: content))
            #else
            return AnyView(fallbackPlatformNavigation(to: content))
            #endif
        case .macOS:
            return AnyView(macOSPlatformNavigation(to: content))
        default:
            return AnyView(fallbackPlatformNavigation(to: content))
        }
    }
    
    // MARK: - Platform-Specific Implementations
    
    #if os(iOS)
    private func iosPlatformNavigation<Content: View>(to content: Content) -> some View {
        AnyView(content.navigationBarTitleDisplayMode(.inline).automaticCompliance())
    }
    #endif
    
    private func macOSPlatformNavigation<Content: View>(to content: Content) -> some View {
        AnyView(content.navigationTitle("").automaticCompliance())
    }
    
    private func fallbackPlatformNavigation<Content: View>(to content: Content) -> some View {
        AnyView(content.automaticCompliance())
    }
}

/// Platform styling modifier
public struct PlatformStylingModifier: ViewModifier {
    let designSystem: PlatformDesignSystem
    
    public func body(content: Content) -> some View {
        content
            .foregroundStyle(designSystem.colorSystem.text)
            .background(designSystem.colorSystem.background)
            .automaticCompliance()
    }
}

/// Platform icon modifier
public struct PlatformIconModifier: ViewModifier {
    let iconSystem: HIGIconSystem
    
    public func body(content: Content) -> some View {
        content
            .imageScale(.medium)
            .automaticCompliance()
    }
}

/// System color modifier
public struct SystemColorModifier: ViewModifier {
    let colorSystem: HIGColorSystem
    
    public func body(content: Content) -> some View {
        content
            .foregroundStyle(colorSystem.text)
            .background(colorSystem.background)
            .automaticCompliance()
    }
}

/// System typography modifier
public struct SystemTypographyModifier: ViewModifier {
    let typographySystem: HIGTypographySystem
    
    public func body(content: Content) -> some View {
        content
            .font(typographySystem.body)
            .automaticCompliance()
    }
}

/// Spacing modifier following Apple's 8pt grid
public struct SpacingModifier: ViewModifier {
    let spacingSystem: HIGSpacingSystem
    
    public func body(content: Content) -> some View {
        content
            .padding(spacingSystem.md)
            .automaticCompliance()
    }
}

/// Touch target modifier ensuring proper touch targets
/// Enforces Apple HIG requirement: 44pt minimum touch target on iOS/watchOS
public struct TouchTargetModifier: ViewModifier {
    let platform: SixLayerPlatform
    let iOSConfig: HIGiOSCategoryConfig?
    
    public init(platform: SixLayerPlatform, iOSConfig: HIGiOSCategoryConfig? = nil) {
        self.platform = platform
        self.iOSConfig = iOSConfig
    }
    
    public func body(content: Content) -> some View {
        applyTouchTarget(to: content, platform: platform, iOSConfig: iOSConfig)
    }
    
    // MARK: - Cross-Platform Implementation
    
    /// Apply platform-specific touch target requirements
    private func applyTouchTarget<Content: View>(
        to content: Content,
        platform: SixLayerPlatform,
        iOSConfig: HIGiOSCategoryConfig?
    ) -> some View {
        switch platform {
        case .iOS, .watchOS:
            #if os(iOS) || os(watchOS)
            let config = iOSConfig ?? HIGiOSCategoryConfig()
            return AnyView(iosTouchTarget(to: content, config: config))
            #else
            return AnyView(fallbackTouchTarget(to: content))
            #endif
        default:
            return AnyView(fallbackTouchTarget(to: content))
        }
    }
    
    // MARK: - Platform-Specific Implementations
    
    #if os(iOS) || os(watchOS)
    /// iOS/watchOS: Enforce 44pt minimum touch target (Apple HIG requirement)
    private func iosTouchTarget<Content: View>(
        to content: Content,
        config: HIGiOSCategoryConfig
    ) -> some View {
        guard config.enableTouchTargetValidation else {
            return AnyView(content.automaticCompliance())
        }
        
        // Apple HIG: Minimum 44pt touch target for interactive elements
        return AnyView(content.frame(minHeight: 44, minWidth: 44).automaticCompliance())
    }
    #endif
    
    /// Fallback for platforms without touch target requirements
    private func fallbackTouchTarget<Content: View>(to content: Content) -> some View {
        AnyView(content.automaticCompliance())
    }
}

// MARK: - Safe Area Compliance Modifier

/// Safe area compliance modifier ensuring proper safe area handling on iOS
/// Automatically applies safe area insets to respect device notches, status bars, and home indicators
public struct SafeAreaComplianceModifier: ViewModifier {
    let platform: SixLayerPlatform
    let iOSConfig: HIGiOSCategoryConfig?
    
    public init(platform: SixLayerPlatform, iOSConfig: HIGiOSCategoryConfig? = nil) {
        self.platform = platform
        self.iOSConfig = iOSConfig
    }
    
    public func body(content: Content) -> some View {
        applySafeAreaCompliance(to: content, platform: platform, iOSConfig: iOSConfig)
    }
    
    // MARK: - Cross-Platform Implementation
    
    /// Apply platform-specific safe area compliance
    private func applySafeAreaCompliance<Content: View>(
        to content: Content,
        platform: SixLayerPlatform,
        iOSConfig: HIGiOSCategoryConfig?
    ) -> some View {
        switch platform {
        case .iOS, .watchOS:
            #if os(iOS) || os(watchOS)
            let config = iOSConfig ?? HIGiOSCategoryConfig()
            return AnyView(iosSafeAreaCompliance(to: content, config: config))
            #else
            return AnyView(fallbackSafeAreaCompliance(to: content))
            #endif
        default:
            return AnyView(fallbackSafeAreaCompliance(to: content))
        }
    }
    
    // MARK: - Platform-Specific Implementations
    
    #if os(iOS) || os(watchOS)
    /// iOS/watchOS: Apply safe area insets automatically
    private func iosSafeAreaCompliance<Content: View>(
        to content: Content,
        config: HIGiOSCategoryConfig
    ) -> some View {
        guard config.enableSafeAreaCompliance else {
            return AnyView(content.automaticCompliance())
        }
        
        // Safe area is automatically handled by SwiftUI when using proper container views
        // This modifier ensures content respects safe areas by using safeAreaInset when needed
        // For most cases, SwiftUI's automatic safe area handling is sufficient
        return AnyView(
            content
                .ignoresSafeArea(.container, edges: []) // Respect all safe areas
                .automaticCompliance()
        )
    }
    #endif
    
    /// Fallback for platforms without safe area requirements
    private func fallbackSafeAreaCompliance<Content: View>(to content: Content) -> some View {
        AnyView(content.automaticCompliance())
    }
}

/// Platform interaction modifier
/// Applies platform-specific interaction patterns (touch for iOS, mouse for macOS)
public struct PlatformInteractionModifier: ViewModifier {
    let platform: SixLayerPlatform
    let macOSConfig: HIGmacOSCategoryConfig?
    
    public init(platform: SixLayerPlatform, macOSConfig: HIGmacOSCategoryConfig? = nil) {
        self.platform = platform
        self.macOSConfig = macOSConfig
    }
    
    public func body(content: Content) -> some View {
        applyPlatformInteraction(to: content, platform: platform, macOSConfig: macOSConfig)
    }
    
    // MARK: - Cross-Platform Implementation
    
    /// Apply platform-specific interaction patterns
    private func applyPlatformInteraction<Content: View>(
        to content: Content,
        platform: SixLayerPlatform,
        macOSConfig: HIGmacOSCategoryConfig?
    ) -> some View {
        switch platform {
        case .iOS:
            #if os(iOS)
            return AnyView(iosPlatformInteraction(to: content))
            #else
            return AnyView(fallbackPlatformInteraction(to: content))
            #endif
        case .macOS:
            #if os(macOS)
            let config = macOSConfig ?? HIGmacOSCategoryConfig()
            return AnyView(macOSPlatformInteraction(to: content, config: config))
            #else
            return AnyView(fallbackPlatformInteraction(to: content))
            #endif
        default:
            return AnyView(fallbackPlatformInteraction(to: content))
        }
    }
    
    // MARK: - Platform-Specific Implementations
    
    #if os(iOS)
    /// iOS: Touch-based interactions with button styling
    private func iosPlatformInteraction<Content: View>(to content: Content) -> some View {
        AnyView(content.buttonStyle(.bordered).automaticCompliance())
    }
    #endif
    
    #if os(macOS)
    /// macOS: Mouse-based interactions with hover states and click patterns
    private func macOSPlatformInteraction<Content: View>(
        to content: Content,
        config: HIGmacOSCategoryConfig
    ) -> some View {
        guard config.enableMouseInteractions else {
            return AnyView(content.buttonStyle(.bordered).automaticCompliance())
        }
        
        // Apply macOS-appropriate mouse interaction patterns
        // Hover states, click patterns, and cursor changes
        return AnyView(
            content
                .buttonStyle(.bordered)
                .onHover { isHovering in
                    // Handle hover state - cursor changes are automatic in SwiftUI
                    // Additional hover effects can be added here
                }
                .automaticCompliance()
        )
    }
    #endif
    
    private func fallbackPlatformInteraction<Content: View>(to content: Content) -> some View {
        AnyView(content.automaticCompliance())
    }
}

/// Haptic feedback modifier
/// Applies platform-specific haptic feedback based on configuration
public struct HapticFeedbackModifier: ViewModifier {
    let platform: SixLayerPlatform
    let iOSConfig: HIGiOSCategoryConfig?
    
    public init(platform: SixLayerPlatform, iOSConfig: HIGiOSCategoryConfig? = nil) {
        self.platform = platform
        self.iOSConfig = iOSConfig
    }
    
    public func body(content: Content) -> some View {
        applyHapticFeedback(to: content, platform: platform, iOSConfig: iOSConfig)
    }
    
    // MARK: - Cross-Platform Implementation
    
    /// Apply platform-specific haptic feedback
    private func applyHapticFeedback<Content: View>(
        to content: Content,
        platform: SixLayerPlatform,
        iOSConfig: HIGiOSCategoryConfig?
    ) -> some View {
        switch platform {
        case .iOS, .watchOS:
            #if os(iOS) || os(watchOS)
            let config = iOSConfig ?? HIGiOSCategoryConfig()
            return AnyView(iosHapticFeedback(to: content, config: config))
            #else
            return AnyView(fallbackHapticFeedback(to: content))
            #endif
        case .macOS:
            #if os(macOS)
            return AnyView(macOSHapticFeedback(to: content))
            #else
            return AnyView(fallbackHapticFeedback(to: content))
            #endif
        default:
            return AnyView(fallbackHapticFeedback(to: content))
        }
    }
    
    // MARK: - Platform-Specific Implementations
    
    #if os(iOS) || os(watchOS)
    /// iOS/watchOS: Native haptic feedback on tap with configurable type
    private func iosHapticFeedback<Content: View>(
        to content: Content,
        config: HIGiOSCategoryConfig
    ) -> some View {
        guard config.enableHapticFeedback else {
            return AnyView(content.automaticCompliance())
        }
        
        let hapticType = config.defaultHapticFeedbackType
        
        return AnyView(
            content
                .onTapGesture {
                    triggerIOSHapticFeedback(type: hapticType)
                }
                .automaticCompliance()
        )
    }
    
    /// Trigger iOS haptic feedback based on type
    private func triggerIOSHapticFeedback(type: PlatformHapticFeedback) {
        #if os(iOS)
        switch type {
        case .light:
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        case .medium:
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        case .heavy:
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
        case .soft:
            if #available(iOS 13.0, *) {
                let generator = UIImpactFeedbackGenerator(style: .soft)
                generator.impactOccurred()
            } else {
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.impactOccurred()
            }
        case .rigid:
            if #available(iOS 13.0, *) {
                let generator = UIImpactFeedbackGenerator(style: .rigid)
                generator.impactOccurred()
            } else {
                let generator = UIImpactFeedbackGenerator(style: .heavy)
                generator.impactOccurred()
            }
        case .success:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        case .warning:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.warning)
        case .error:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
        }
        #endif
    }
    #endif
    
    #if os(macOS)
    /// macOS: Sound feedback instead of haptics (macOS doesn't support haptics)
    private func macOSHapticFeedback<Content: View>(to content: Content) -> some View {
        // macOS doesn't have haptic feedback, so we return content unchanged
        // In a full implementation, this could trigger sound feedback
        AnyView(content.automaticCompliance())
    }
    #endif
    
    /// Fallback for platforms without haptic feedback support
    private func fallbackHapticFeedback<Content: View>(to content: Content) -> some View {
        AnyView(content.automaticCompliance())
    }
}

/// Gesture recognition modifier
/// Applies platform-specific gesture recognition based on configuration
public struct GestureRecognitionModifier: ViewModifier {
    let platform: SixLayerPlatform
    let iOSConfig: HIGiOSCategoryConfig?
    
    public init(platform: SixLayerPlatform, iOSConfig: HIGiOSCategoryConfig? = nil) {
        self.platform = platform
        self.iOSConfig = iOSConfig
    }
    
    public func body(content: Content) -> some View {
        applyGestureRecognition(to: content, platform: platform, iOSConfig: iOSConfig)
    }
    
    // MARK: - Cross-Platform Implementation
    
    /// Apply platform-specific gesture recognition
    private func applyGestureRecognition<Content: View>(
        to content: Content,
        platform: SixLayerPlatform,
        iOSConfig: HIGiOSCategoryConfig?
    ) -> some View {
        switch platform {
        case .iOS, .watchOS:
            #if os(iOS) || os(watchOS)
            let config = iOSConfig ?? HIGiOSCategoryConfig()
            return AnyView(iosGestureRecognition(to: content, config: config))
            #else
            return AnyView(fallbackGestureRecognition(to: content))
            #endif
        case .macOS:
            #if os(macOS)
            return AnyView(macOSGestureRecognition(to: content))
            #else
            return AnyView(fallbackGestureRecognition(to: content))
            #endif
        default:
            return AnyView(fallbackGestureRecognition(to: content))
        }
    }
    
    // MARK: - Platform-Specific Implementations
    
    #if os(iOS) || os(watchOS)
    /// iOS/watchOS: Touch-based gesture recognition (tap, long press, swipe, pinch, rotation)
    private func iosGestureRecognition<Content: View>(
        to content: Content,
        config: HIGiOSCategoryConfig
    ) -> some View {
        guard config.enableGestureRecognition else {
            return AnyView(content.automaticCompliance())
        }
        
        // Apply basic tap gesture recognition
        // Additional gestures (long press, swipe, pinch, rotation) can be added
        // via explicit gesture modifiers when needed
        return AnyView(
            content
                .gesture(
                    TapGesture()
                        .onEnded { _ in
                            // Tap gesture handled - additional gestures can be added explicitly
                        }
                )
                .automaticCompliance()
        )
    }
    #endif
    
    #if os(macOS)
    /// macOS: Mouse-based gesture recognition
    private func macOSGestureRecognition<Content: View>(to content: Content) -> some View {
        AnyView(
            content
                .onTapGesture {
                    // Handle click gesture
                }
                .automaticCompliance()
        )
    }
    #endif
    
    /// Fallback for platforms without gesture recognition
    private func fallbackGestureRecognition<Content: View>(to content: Content) -> some View {
        AnyView(content.automaticCompliance())
    }
}

// MARK: - View Extensions for Easy Use

public extension View {
    /// Apply comprehensive Apple HIG compliance automatically
    func appleHIGCompliant() -> some View {
        self.modifier(SystemAccessibilityModifier(
            accessibilityState: AccessibilitySystemState(),
            platform: .iOS
        ))
        .automaticCompliance(named: "AppleHIGCompliant")
    }
    
    /// Apply automatic accessibility features
    func automaticAccessibility() -> some View {
        self.modifier(SystemAccessibilityModifier(
            accessibilityState: AccessibilitySystemState(),
            platform: .iOS // This would be detected automatically
        ))
    }
    
    /// Apply platform-specific patterns
    func platformPatterns() -> some View {
        self.modifier(PlatformPatternModifier(
            designSystem: PlatformDesignSystem(for: .iOS),
            platform: .iOS
        ))
    }
    
    /// Apply visual design consistency
    func visualConsistency() -> some View {
        self.modifier(VisualConsistencyModifier(
            designSystem: PlatformDesignSystem(for: .iOS),
            platform: .iOS,
            visualDesignConfig: HIGVisualDesignCategoryConfig.default(for: .iOS),
            iOSConfig: HIGiOSCategoryConfig()
        ))
    }
    
    /// Apply interaction patterns
    func interactionPatterns() -> some View {
        self.modifier(InteractionPatternModifier(
            platform: .iOS,
            accessibilityState: AccessibilitySystemState(),
            iOSConfig: HIGiOSCategoryConfig()
        ))
    }
}

// MARK: - Platform-Specific Category Modifier

/// Applies platform-specific HIG compliance categories (iOS, macOS, visionOS)
/// Handles categories that are specific to each platform's interaction patterns
public struct PlatformSpecificCategoryModifier: ViewModifier {
    let platform: SixLayerPlatform
    let iOSConfig: HIGiOSCategoryConfig?
    let macOSConfig: HIGmacOSCategoryConfig?
    
    public init(
        platform: SixLayerPlatform,
        iOSConfig: HIGiOSCategoryConfig? = nil,
        macOSConfig: HIGmacOSCategoryConfig? = nil
    ) {
        self.platform = platform
        self.iOSConfig = iOSConfig
        self.macOSConfig = macOSConfig
    }
    
    public func body(content: Content) -> some View {
        applyPlatformSpecificCategories(to: content, platform: platform, iOSConfig: iOSConfig, macOSConfig: macOSConfig)
    }
    
    // MARK: - Cross-Platform Implementation
    
    /// Apply platform-specific categories
    private func applyPlatformSpecificCategories<Content: View>(
        to content: Content,
        platform: SixLayerPlatform,
        iOSConfig: HIGiOSCategoryConfig?,
        macOSConfig: HIGmacOSCategoryConfig?
    ) -> some View {
        switch platform {
        case .iOS, .watchOS:
            #if os(iOS) || os(watchOS)
            // iOS categories are already handled by other modifiers
            return AnyView(content.automaticCompliance())
            #else
            return AnyView(content.automaticCompliance())
            #endif
        case .macOS:
            #if os(macOS)
            let config = macOSConfig ?? HIGmacOSCategoryConfig()
            return AnyView(macOSPlatformSpecificCategories(to: content, config: config))
            #else
            return AnyView(content.automaticCompliance())
            #endif
        default:
            return AnyView(content.automaticCompliance())
        }
    }
    
    // MARK: - Platform-Specific Implementations
    
    #if os(macOS)
    /// macOS: Apply window management, keyboard shortcuts, and mouse interactions
    private func macOSPlatformSpecificCategories<Content: View>(
        to content: Content,
        config: HIGmacOSCategoryConfig
    ) -> some View {
        var modifiedContent: AnyView = AnyView(content)
        
        // Note: Window management (resize, minimize, maximize, fullscreen) is typically
        // handled at the App/Window level via NSWindow or SwiftUI WindowGroup, not at the view level.
        // This modifier focuses on view-level macOS HIG compliance.
        
        // Keyboard shortcuts are applied via .keyboardShortcut() modifier when needed
        // Mouse interactions (hover states, click patterns) are handled by PlatformInteractionModifier
        // Menu bar integration requires App-level configuration and is opt-in via config
        
        // Additional macOS-specific view-level enhancements can be added here
        // For now, the existing modifiers handle the core functionality
        
        return AnyView(modifiedContent.automaticCompliance())
    }
    #endif
}
