import SwiftUI

// MARK: - Layer 4: Platform Styling Components
/// Consolidated platform-specific styling functions
/// Reduces conditional compilation blocks by centralizing common patterns

public extension View {
    
    // MARK: - Background Styling
    
    /// Platform-specific background modifier
    /// Applies platform-specific background colors
public func platformBackground() -> some View {
        #if os(iOS)
        return self.background(Color.platformGroupedBackground)
        #elseif os(macOS)
        return self.background(Color.platformSecondaryBackground)
        #else
        return self.background(Color.gray.opacity(0.1))
        #endif
    }
    
    /// Platform-specific background with custom color
public func platformBackground(_ color: Color) -> some View {
        return self.background(color)
    }
    
    // MARK: - Padding Styling
    
    /// Platform-specific padding modifier
    /// Applies platform-specific padding values
public func platformPadding() -> some View {
        #if os(iOS)
        return self.padding(16)
        #elseif os(macOS)
        return self.padding(12)
        #else
        return self.padding(16)
        #endif
    }
    
    /// Platform-specific padding with directional control
public func platformPadding(_ edges: Edge.Set, _ length: CGFloat? = nil) -> some View {
        return self.padding(edges, length)
    }
    
    /// Platform-specific padding with explicit value
public func platformPadding(_ value: CGFloat) -> some View {
        return self.padding(value)
    }
    
    /// Platform-specific reduced padding values
public func platformReducedPadding() -> some View {
        return self.padding(8)
    }
    
    // MARK: - Visual Effects
    
    /// Platform-specific corner radius modifier
public func platformCornerRadius() -> some View {
        #if os(iOS)
        return self.cornerRadius(12)
        #elseif os(macOS)
        return self.cornerRadius(8)
        #else
        return self.cornerRadius(8)
        #endif
    }
    
    /// Platform-specific corner radius with custom value
public func platformCornerRadius(_ radius: CGFloat) -> some View {
        return self.cornerRadius(radius)
    }
    
    /// Platform-specific shadow modifier
public func platformShadow() -> some View {
        #if os(iOS)
        return self.shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        #elseif os(macOS)
        return self.shadow(color: Color.black.opacity(0.08), radius: 3, x: 0, y: 1)
        #else
        return self.shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        #endif
    }
    
    /// Platform-specific shadow with custom parameters
public func platformShadow(color: Color = .black, radius: CGFloat, x: CGFloat = 0, y: CGFloat = 0) -> some View {
        return self.shadow(color: color, radius: radius, x: x, y: y)
    }
    
    /// Platform-specific border modifier
public func platformBorder() -> some View {
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
public func platformBorder(color: Color, width: CGFloat = 0.5) -> some View {
        return self.overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(color, lineWidth: width)
        )
    }
    
    // MARK: - Typography
    
    /// Platform-specific font modifier
public func platformFont() -> some View {
        #if os(iOS)
        return self.font(.body)
        #elseif os(macOS)
        return self.font(.body)
        #else
        return self.font(.body)
        #endif
    }
    
    /// Platform-specific font with custom style
public func platformFont(_ style: Font) -> some View {
        return self.font(style)
    }
    
    // MARK: - Animation
    
    /// Platform-specific animation modifier
public func platformAnimation() -> some View {
        #if os(iOS)
        return self.animation(.easeInOut(duration: 0.3), value: true)
        #elseif os(macOS)
        return self.animation(.easeInOut(duration: 0.2), value: true)
        #else
        return self.animation(.easeInOut(duration: 0.3), value: true)
        #endif
    }
    
    /// Platform-specific animation with custom parameters
public func platformAnimation(_ animation: Animation?, value: AnyHashable) -> some View {
        return self.animation(animation, value: value)
    }
    
    // MARK: - Frame Constraints
    
    /// Platform-specific minimum frame constraints
public func platformMinFrame() -> some View {
        #if os(iOS)
        return self
        #elseif os(macOS)
        return self.frame(minWidth: 600, minHeight: 800)
        #else
        return self
        #endif
    }
    
    /// Platform-specific maximum frame constraints
public func platformMaxFrame() -> some View {
        #if os(iOS)
        return self
        #elseif os(macOS)
        return self.frame(maxWidth: 1200, maxHeight: 1000)
        #else
        return self
        #endif
    }
    
    /// Platform-specific ideal frame constraints
public func platformIdealFrame() -> some View {
        #if os(iOS)
        return self
        #elseif os(macOS)
        return self.frame(idealWidth: 800, idealHeight: 900)
        #else
        return self
        #endif
    }
    
    /// Platform-specific adaptive frame constraints
public func platformAdaptiveFrame() -> some View {
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
public func platformFormStyle() -> some View {
        #if os(iOS)
        return self
        #elseif os(macOS)
        return self.formStyle(.grouped)
        #else
        return self
        #endif
    }
    
    // MARK: - Content Spacing
    
    /// Platform-specific content spacing
public func platformContentSpacing() -> some View {
        #if os(iOS)
        return self
        #elseif os(macOS)
        return self
        #else
        return self
        #endif
    }
    
    // MARK: - Hover Effects
    
    // Platform-specific hover effect function moved to PlatformSpecificViewExtensions.swift
}
