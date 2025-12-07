import SwiftUI
#if os(iOS)
import UIKit
#endif

// MARK: - Platform Haptic Feedback Extensions

/// Platform-specific haptic feedback types that provide consistent tactile feedback
/// across iOS devices while gracefully handling macOS (no-op)
public enum PlatformHapticFeedback: CaseIterable {
    /// Light impact feedback - subtle tactile response
    case light
    /// Medium impact feedback - moderate tactile response
    case medium
    /// Heavy impact feedback - strong tactile response
    case heavy
    /// Soft impact feedback - gentle tactile response
    case soft
    /// Rigid impact feedback - sharp tactile response
    case rigid
    /// Success notification feedback - positive completion
    case success
    /// Warning notification feedback - caution indication
    case warning
    /// Error notification feedback - error indication
    case error
}

// MARK: - Haptic Feedback Triggering

/// Platform-specific haptic feedback triggering logic
private func triggerHapticFeedback(_ feedback: PlatformHapticFeedback) {
    #if os(iOS)
    switch feedback {
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
    #else
    // macOS and other platforms: No-op (graceful fallback)
    #endif
}

// MARK: - Haptic Feedback View Modifiers

/// View modifier that triggers haptic feedback on tap
private struct PlatformHapticFeedbackTapModifier: ViewModifier {
    let feedback: PlatformHapticFeedback
    
    func body(content: Content) -> some View {
        content
            .onTapGesture {
                triggerHapticFeedback(feedback)
            }
    }
}

/// View modifier that triggers haptic feedback and executes action on tap
private struct PlatformHapticFeedbackWithActionModifier: ViewModifier {
    let feedback: PlatformHapticFeedback
    let action: () -> Void
    
    func body(content: Content) -> some View {
        content
            .onTapGesture {
                triggerHapticFeedback(feedback)
                action()
            }
    }
}

/// Platform-specific haptic feedback extensions that provide consistent behavior
/// across iOS and macOS while handling platform differences appropriately
public extension View {

    /// Platform haptic feedback trigger
    /// iOS: Triggers haptic feedback on tap; macOS: No-op (graceful fallback)
    ///
    /// - Parameter feedback: The type of haptic feedback to trigger
    /// - Returns: The view with haptic feedback on tap
    ///
    /// ## Usage Example
    /// ```swift
    /// Button("Tap me") { }
    ///     .platformHapticFeedback(.light)
    /// ```
    ///
    /// **Note**: Haptic feedback triggers when the view is tapped, not when the modifier is applied.
    func platformHapticFeedback(_ feedback: PlatformHapticFeedback) -> some View {
        self
            .modifier(PlatformHapticFeedbackTapModifier(feedback: feedback))
            .automaticCompliance()
    }

    /// Platform haptic feedback trigger with custom action
    /// iOS: Triggers haptic feedback and executes action on tap; macOS: Executes action only
    ///
    /// - Parameters:
    ///   - feedback: The type of haptic feedback to trigger
    ///   - action: The action to execute after haptic feedback
    /// - Returns: The view with haptic feedback and action on tap
    ///
    /// ## Usage Example
    /// ```swift
    /// Button("Save") {
    ///     save()
    /// }
    /// .platformHapticFeedback(.success) {
    ///     print("Save completed")
    /// }
    /// ```
    ///
    /// **Note**: Haptic feedback and action trigger when the view is tapped, not when the modifier is applied.
    func platformHapticFeedback(
        _ feedback: PlatformHapticFeedback,
        action: @escaping () -> Void
    ) -> some View {
        self
            .modifier(PlatformHapticFeedbackWithActionModifier(feedback: feedback, action: action))
            .automaticCompliance()
    }
}
