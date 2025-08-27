import SwiftUI

// MARK: - Platform Buttons Layer 3: Layout Implementation
/// This layer provides platform-specific button components that implement
/// button patterns across iOS and macOS. This layer handles the specific
/// implementation of button components.
extension View {
    
    /// Platform-specific primary button style
    /// Provides consistent primary button appearance across platforms
    func platformPrimaryButtonStyle() -> some View {
        #if os(iOS)
        return self.buttonStyle(.borderedProminent)
        #elseif os(macOS)
        if #available(macOS 12.0, *) {
            return self.buttonStyle(.borderedProminent)
        } else {
            return self.buttonStyle(.bordered)
                .foregroundColor(.white)
                .background(Color.accentColor)
        }
        #else
        return self.buttonStyle(.borderedProminent)
        #endif
    }
    
    /// Platform-specific secondary button style
    /// Provides consistent secondary button appearance across platforms
    func platformSecondaryButtonStyle() -> some View {
        #if os(iOS)
        return self.buttonStyle(.bordered)
        #elseif os(macOS)
        if #available(macOS 12.0, *) {
            return self.buttonStyle(.bordered)
        } else {
            return self.buttonStyle(.bordered)
                .foregroundColor(.accentColor)
        }
        #else
        return self.buttonStyle(.bordered)
        #endif
    }
    
    /// Platform-specific destructive button style
    /// Provides consistent destructive button appearance across platforms
    func platformDestructiveButtonStyle() -> some View {
        #if os(iOS)
        return self.buttonStyle(.borderedProminent)
            .foregroundColor(.red)
        #elseif os(macOS)
        if #available(macOS 12.0, *) {
            return self.buttonStyle(.borderedProminent)
                .foregroundColor(.red)
        } else {
            return self.buttonStyle(.bordered)
                .foregroundColor(.white)
                .background(Color.red)
        }
        #else
        return self.buttonStyle(.borderedProminent)
            .foregroundColor(.red)
        #endif
    }
    
    /// Platform-specific icon button with consistent styling
    /// Provides standardized icon button appearance across platforms
    func platformIconButton(
        systemImage: String,
        accessibilityLabel: String,
        accessibilityHint: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            #if os(macOS)
            if #available(macOS 11.0, *) {
                Image(systemName: systemImage)
                    .foregroundColor(.primary)
            } else {
                // Fallback for older macOS versions
                Text("•")
                    .foregroundColor(.primary)
            }
            #else
            Image(systemName: systemImage)
                .foregroundColor(.primary)
            #endif
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityLabel(accessibilityLabel)
        .accessibilityHint(accessibilityHint)
        .accessibilityAddTraits(.isButton)
    }
}
