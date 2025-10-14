import SwiftUI

/// Shared helper for enforcing a single visible label for self-labeling controls
/// Applies empty title behavior (where relevant), hides intrinsic control labels,
/// and restores accessibility labels for screen readers.
public struct SelfLabelingControlModifier: ViewModifier {
    let accessibilityText: String

    public func body(content: Content) -> some View {
        content
            .labelsHidden()
            .accessibilityLabel(Text(accessibilityText))
    }
}

public extension View {
    /// Apply the self-labeling policy to a control that would otherwise render its own label.
    /// - Parameter label: The human-readable label to expose to accessibility.
    /// - Returns: A view with hidden visual labels and restored accessibility.
    func selfLabelingControl(label: String) -> some View {
        modifier(SelfLabelingControlModifier(accessibilityText: label))
    }
}
