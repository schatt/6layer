import Foundation
import SwiftUI

// MARK: - AnyShapeStyle Wrapper

/// Wrapper for any ShapeStyle to provide type erasure
/// This is the key component that allows us to support all ShapeStyle types
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public struct AnyShapeStyle: ShapeStyle {
    private let _resolve: @Sendable (inout EnvironmentValues) -> Void
    
    public init<S: ShapeStyle>(_ shapeStyle: S) {
        _resolve = { environment in
            shapeStyle.resolve(in: &environment)
        }
    }
    
    public func resolve(in environment: inout EnvironmentValues) {
        _resolve(&environment)
    }
}

// MARK: - Accessibility-Aware ShapeStyle

/// ShapeStyle that adapts to accessibility settings
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public struct AccessibilityAwareShapeStyle: ShapeStyle {
    private let normalStyle: AnyShapeStyle
    private let highContrastStyle: AnyShapeStyle
    private let reducedMotionStyle: AnyShapeStyle
    
    public init(
        normal: AnyShapeStyle,
        highContrast: AnyShapeStyle? = nil,
        reducedMotion: AnyShapeStyle? = nil
    ) {
        self.normalStyle = normal
        self.highContrastStyle = highContrast ?? normal
        self.reducedMotionStyle = reducedMotion ?? normal
    }
    
    public func resolve(in environment: inout EnvironmentValues) {
        // Check accessibility settings and apply appropriate style
        #if canImport(UIKit)
        if UIAccessibility.isDarkerSystemColorsEnabled {
            highContrastStyle.resolve(in: &environment)
        } else if UIAccessibility.isReduceMotionEnabled {
            reducedMotionStyle.resolve(in: &environment)
        } else {
            normalStyle.resolve(in: &environment)
        }
        #else
        normalStyle.resolve(in: &environment)
        #endif
    }
}