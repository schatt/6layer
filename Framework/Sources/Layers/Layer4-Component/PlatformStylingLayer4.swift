import SwiftUI

// MARK: - Layer 4: Platform Styling Components
/// Consolidated platform-specific styling functions
/// Reduces conditional compilation blocks by centralizing common patterns

public extension View {
    
    // MARK: - Background Styling
    
    /// Platform-specific background modifier
    /// Applies platform-specific background colors
    func platformBackground() -> some View {
        #if os(iOS)
        return self.background(Color.platformGroupedBackground)
        #elseif os(macOS)
        return self.background(Color.platformSecondaryBackground)
        #else
        return self.background(Color.gray.opacity(0.1))
        #endif
    }
    
    /// Platform-specific background with custom color
    func platformBackground(_ color: Color) -> some View {
        return self.background(color)
    }
    
    // MARK: - Padding Styling
    
    /// Platform-specific padding modifier
    /// Applies platform-specific padding values
    func platformPadding() -> some View {
        #if os(iOS)
        return self.padding(16)
            .automaticAccessibilityIdentifiers()
        #elseif os(macOS)
        return self.padding(12)
            .automaticAccessibilityIdentifiers()
        #else
        return self.padding(16)
            .automaticAccessibilityIdentifiers()
        #endif
    }
    
    /// Platform-specific padding with directional control
    func platformPadding(_ edges: Edge.Set, _ length: CGFloat? = nil) -> some View {
        return self.padding(edges, length)
    }
    
    /// Platform-specific padding with explicit value
    func platformPadding(_ value: CGFloat) -> some View {
        return self.padding(value)
    }
    
    /// Platform-specific reduced padding values
    func platformReducedPadding() -> some View {
        return self.padding(8)
            .automaticAccessibilityIdentifiers()
    }
    
    // MARK: - Visual Effects
    
    /// Platform-specific corner radius modifier
    func platformCornerRadius() -> some View {
        #if os(iOS)
        return self.cornerRadius(12)
            .automaticAccessibilityIdentifiers()
        #elseif os(macOS)
        return self.cornerRadius(8)
            .automaticAccessibilityIdentifiers()
        #else
        return self.cornerRadius(8)
            .automaticAccessibilityIdentifiers()
        #endif
    }
    
    /// Platform-specific corner radius with custom value
    func platformCornerRadius(_ radius: CGFloat) -> some View {
        return self.cornerRadius(radius)
    }
    
    /// Platform-specific shadow modifier
    func platformShadow() -> some View {
        #if os(iOS)
        return self.shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        #elseif os(macOS)
        return self.shadow(color: Color.black.opacity(0.08), radius: 3, x: 0, y: 1)
        #else
        return self.shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        #endif
    }
    
    /// Platform-specific shadow with custom parameters
    func platformShadow(color: Color = .black, radius: CGFloat, x: CGFloat = 0, y: CGFloat = 0) -> some View {
        return self.shadow(color: color, radius: radius, x: x, y: y)
    }
    
    /// Platform-specific border modifier
    func platformBorder() -> some View {
        #if os(iOS)
        return self.overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.platformSeparator, lineWidth: 0.5)
        )
        #elseif os(macOS)
        return self.overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.platformSeparator, lineWidth: 0.5)
        )
        #else
        return self.overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.platformSeparator, lineWidth: 0.5)
        )
        #endif
    }
    
    /// Platform-specific border with custom parameters
    func platformBorder(color: Color, width: CGFloat = 0.5) -> some View {
        return self.overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(color, lineWidth: width)
        )
    }
    
    // MARK: - Typography
    
    /// Platform-specific font modifier
    func platformFont() -> some View {
        #if os(iOS)
        return self.font(.body)
        #elseif os(macOS)
        return self.font(.body)
        #else
        return self.font(.body)
        #endif
    }
    
    /// Platform-specific font with custom style
    func platformFont(_ style: Font) -> some View {
        return self.font(style)
    }
    
    // MARK: - Animation
    
    /// Platform-specific animation modifier
    func platformAnimation() -> some View {
        #if os(iOS)
        return self.animation(.easeInOut(duration: 0.3), value: true)
        #elseif os(macOS)
        return self.animation(.easeInOut(duration: 0.2), value: true)
        #else
        return self.animation(.easeInOut(duration: 0.3), value: true)
        #endif
    }
    
    /// Platform-specific animation with custom parameters
    func platformAnimation(_ animation: Animation?, value: AnyHashable) -> some View {
        return self.animation(animation, value: value)
    }
    
    // MARK: - Frame Constraints
    
    /// Platform-specific minimum frame constraints
    func platformMinFrame() -> some View {
        #if os(iOS)
        return self
            .automaticAccessibilityIdentifiers()
        #elseif os(macOS)
        return self.frame(minWidth: 600, minHeight: 800)
            .automaticAccessibilityIdentifiers()
        #else
        return self
            .automaticAccessibilityIdentifiers()
        #endif
    }
    
    /// Platform-specific maximum frame constraints
    func platformMaxFrame() -> some View {
        #if os(iOS)
        return self
        #elseif os(macOS)
        return self.frame(maxWidth: 1200, maxHeight: 1000)
        #else
        return self
        #endif
    }
    
    /// Platform-specific ideal frame constraints
    func platformIdealFrame() -> some View {
        #if os(iOS)
        return self
            .automaticAccessibilityIdentifiers()
        #elseif os(macOS)
        return self.frame(idealWidth: 800, idealHeight: 900)
            .automaticAccessibilityIdentifiers()
        #else
        return self
            .automaticAccessibilityIdentifiers()
        #endif
    }
    
    /// Platform-specific adaptive frame constraints
    func platformAdaptiveFrame() -> some View {
        #if os(iOS)
        return self
        #elseif os(macOS)
        return self.frame(minWidth: 600, idealWidth: 800, maxWidth: 1200, minHeight: 800, idealHeight: 900, maxHeight: 1000)
        #else
        return self
        #endif
    }
    
    // MARK: - Form Styling
    
    /// Platform-specific form styling
    func platformFormStyle() -> some View {
        #if os(iOS)
        return self
            .automaticAccessibilityIdentifiers()
        #elseif os(macOS)
        return self.formStyle(.grouped)
            .automaticAccessibilityIdentifiers()
        #else
        return self
            .automaticAccessibilityIdentifiers()
        #endif
    }
    
    // MARK: - Content Spacing
    
    /// Platform-specific content spacing
    func platformContentSpacing() -> some View {
        #if os(iOS)
        return self
            .automaticAccessibilityIdentifiers()
        #elseif os(macOS)
        return self
            .automaticAccessibilityIdentifiers()
        #else
        return self
            .automaticAccessibilityIdentifiers()
        #endif
    }
    
    // MARK: - Container Styling
    
    /// Platform-specific styled container
    /// Applies comprehensive platform-specific styling to create a consistent container
    func platformStyledContainer_L4<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        return VStack {
            content()
        }
        .platformBackground()
        .platformPadding()
        .platformCornerRadius()
        .platformShadow()
        .platformBorder()
    }
    
    // MARK: - Hover Effects
    
    // Platform-specific hover effect function moved to PlatformSpecificViewExtensions.swift
}
