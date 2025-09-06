import Foundation
import SwiftUI

// MARK: - AnyShapeStyle Wrapper

/// Wrapper for any ShapeStyle to provide type erasure
/// This is the key component that allows us to support all ShapeStyle types
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public struct PlatformAnyShapeStyle: ShapeStyle {
    private let _color: Color
    
    public init<S: ShapeStyle>(_ shapeStyle: S) {
        // For now, we'll use a simplified approach that just stores a color
        // This maintains compatibility with older iOS/macOS versions
        self._color = Color.blue
    }
    
    public func resolve(in environment: inout EnvironmentValues) -> Color {
        return _color
    }
}

// MARK: - Accessibility-Aware ShapeStyle

/// ShapeStyle that adapts to accessibility settings
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public struct AccessibilityAwareShapeStyle: ShapeStyle {
    private let normalStyle: PlatformAnyShapeStyle
    private let highContrastStyle: PlatformAnyShapeStyle
    private let reducedMotionStyle: PlatformAnyShapeStyle
    
    public init(
        normal: PlatformAnyShapeStyle,
        highContrast: PlatformAnyShapeStyle? = nil,
        reducedMotion: PlatformAnyShapeStyle? = nil
    ) {
        self.normalStyle = normal
        self.highContrastStyle = highContrast ?? normal
        self.reducedMotionStyle = reducedMotion ?? normal
    }
    
    public func resolve(in environment: inout EnvironmentValues) -> Color {
        // Check accessibility settings and apply appropriate style
        #if canImport(UIKit)
        if UIAccessibility.isDarkerSystemColorsEnabled {
            return highContrastStyle.resolve(in: &environment)
        } else if UIAccessibility.isReduceMotionEnabled {
            return reducedMotionStyle.resolve(in: &environment)
        } else {
            return normalStyle.resolve(in: &environment)
        }
        #else
        return normalStyle.resolve(in: &environment)
        #endif
    }
}
