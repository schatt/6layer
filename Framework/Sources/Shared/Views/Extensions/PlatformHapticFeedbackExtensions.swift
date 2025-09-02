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

/// Platform-specific haptic feedback extensions that provide consistent behavior
/// across iOS and macOS while handling platform differences appropriately
public extension View {

    /// Platform haptic feedback trigger
    /// iOS: Triggers haptic feedback; macOS: No-op (graceful fallback)
    ///
    /// - Parameter feedback: The type of haptic feedback to trigger
    /// - Returns: The view unchanged (for chaining)
    ///
    /// ## Usage Example
    /// ```swift
    /// Button("Tap me") { }
    ///     .platformHapticFeedback(.light)
    /// ```
public func platformHapticFeedback(_ feedback: PlatformHapticFeedback) -> some View {
        #if os(iOS)
        // Trigger haptic feedback on iOS
        switch feedback {
        case .light:
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
        case .medium:
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
        case .heavy:
            let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
            impactFeedback.impactOccurred()
        case .soft:
            let impactFeedback = UIImpactFeedbackGenerator(style: .soft)
            impactFeedback.impactOccurred()
        case .rigid:
            let impactFeedback = UIImpactFeedbackGenerator(style: .rigid)
            impactFeedback.impactOccurred()
        case .success:
            let notificationFeedback = UINotificationFeedbackGenerator()
            notificationFeedback.notificationOccurred(.success)
        case .warning:
            let notificationFeedback = UINotificationFeedbackGenerator()
            notificationFeedback.notificationOccurred(.warning)
        case .error:
            let notificationFeedback = UINotificationFeedbackGenerator()
            notificationFeedback.notificationOccurred(.error)
        }
        #endif

        return self
    }

    /// Platform haptic feedback trigger with custom action
    /// iOS: Triggers haptic feedback and executes action; macOS: Executes action only
    ///
    /// - Parameters:
    ///   - feedback: The type of haptic feedback to trigger
    ///   - action: The action to execute after haptic feedback
    /// - Returns: The view unchanged (for chaining)
    ///
    /// ## Usage Example
    /// ```swift
    /// Button("Tap me") {
    ///     // This will trigger haptic feedback on iOS and execute the action
    /// }
    /// .platformHapticFeedback(.light) {
    ///     // Custom action after haptic feedback
    ///     print("Button tapped with haptic feedback")
    /// }
    /// ```
public func platformHapticFeedback(
        _ feedback: PlatformHapticFeedback,
        action: @escaping () -> Void
    ) -> some View {
        #if os(iOS)
        // Trigger haptic feedback on iOS
        switch feedback {
        case .light:
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
        case .medium:
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
        case .heavy:
            let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
            impactFeedback.impactOccurred()
        case .soft:
            let impactFeedback = UIImpactFeedbackGenerator(style: .soft)
            impactFeedback.impactOccurred()
        case .rigid:
            let impactFeedback = UIImpactFeedbackGenerator(style: .rigid)
            impactFeedback.impactOccurred()
        case .success:
            let notificationFeedback = UINotificationFeedbackGenerator()
            notificationFeedback.notificationOccurred(.success)
        case .warning:
            let notificationFeedback = UINotificationFeedbackGenerator()
            notificationFeedback.notificationOccurred(.warning)
        case .error:
            let notificationFeedback = UINotificationFeedbackGenerator()
            notificationFeedback.notificationOccurred(.error)
        }
        #endif

        // Execute the action on both platforms
        DispatchQueue.main.async {
            action()
        }

        return self
    }
}
