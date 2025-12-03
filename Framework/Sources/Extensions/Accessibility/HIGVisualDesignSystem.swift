import Foundation
import SwiftUI

// MARK: - HIG Visual Design System

/// Visual design system providing HIG-compliant visual design categories
public struct HIGVisualDesignSystem {
    public let platform: SixLayerPlatform
    public let animationSystem: HIGAnimationSystem
    public let shadowSystem: HIGShadowSystem
    public let cornerRadiusSystem: HIGCornerRadiusSystem
    public let borderWidthSystem: HIGBorderWidthSystem
    public let opacitySystem: HIGOpacitySystem
    public let blurSystem: HIGBlurSystem
    
    public init(for platform: SixLayerPlatform) {
        self.platform = platform
        self.animationSystem = HIGAnimationSystem(for: platform)
        self.shadowSystem = HIGShadowSystem(for: platform)
        self.cornerRadiusSystem = HIGCornerRadiusSystem(for: platform)
        self.borderWidthSystem = HIGBorderWidthSystem(for: platform)
        self.opacitySystem = HIGOpacitySystem(for: platform)
        self.blurSystem = HIGBlurSystem(for: platform)
    }
}

// MARK: - Animation System

/// Animation category system providing HIG-compliant animation options
public struct HIGAnimationSystem {
    public let platform: SixLayerPlatform
    
    public init(for platform: SixLayerPlatform) {
        self.platform = platform
    }
    
    /// Get animation for a specific category
    public func animation(for category: HIGAnimationCategory) -> Animation {
        switch category {
        case .easeInOut:
            return .easeInOut(duration: defaultDuration)
        case .spring:
            return .spring(response: defaultSpringResponse, dampingFraction: defaultDampingFraction)
        case .custom(let timingFunction):
            return .timingCurve(
                timingFunction.controlPoint1.x,
                timingFunction.controlPoint1.y,
                timingFunction.controlPoint2.x,
                timingFunction.controlPoint2.y,
                duration: defaultDuration
            )
        }
    }
    
    /// Get default animation for platform
    public var defaultAnimation: Animation {
        switch platform {
        case .iOS:
            return .spring(response: 0.3, dampingFraction: 0.7) // iOS prefers spring animations
        case .macOS:
            return .easeInOut(duration: 0.25) // macOS prefers easeInOut
        default:
            return .easeInOut(duration: 0.25)
        }
    }
    
    private var defaultDuration: Double {
        switch platform {
        case .iOS:
            return 0.3
        case .macOS:
            return 0.25
        default:
            return 0.25
        }
    }
    
    private var defaultSpringResponse: Double {
        switch platform {
        case .iOS:
            return 0.3
        case .macOS:
            return 0.4
        default:
            return 0.3
        }
    }
    
    private var defaultDampingFraction: Double {
        switch platform {
        case .iOS:
            return 0.7
        case .macOS:
            return 0.8
        default:
            return 0.7
        }
    }
}

/// Animation category enum
public enum HIGAnimationCategory {
    case easeInOut
    case spring
    case custom(TimingFunction)
    
    /// Default animation category for platform
    public static func `default`(for platform: SixLayerPlatform) -> HIGAnimationCategory {
        switch platform {
        case .iOS:
            return .spring
        case .macOS:
            return .easeInOut
        default:
            return .easeInOut
        }
    }
}

/// Timing function for custom animations
public struct TimingFunction: Sendable {
    public let controlPoint1: CGPoint
    public let controlPoint2: CGPoint
    
    public init(controlPoint1: CGPoint, controlPoint2: CGPoint) {
        self.controlPoint1 = controlPoint1
        self.controlPoint2 = controlPoint2
    }
    
    public static let easeIn = TimingFunction(
        controlPoint1: CGPoint(x: 0.42, y: 0.0),
        controlPoint2: CGPoint(x: 1.0, y: 1.0)
    )
    
    public static let easeOut = TimingFunction(
        controlPoint1: CGPoint(x: 0.0, y: 0.0),
        controlPoint2: CGPoint(x: 0.58, y: 1.0)
    )
    
    public static let easeInOut = TimingFunction(
        controlPoint1: CGPoint(x: 0.42, y: 0.0),
        controlPoint2: CGPoint(x: 0.58, y: 1.0)
    )
}

// MARK: - Shadow System

/// Shadow category system providing HIG-compliant shadow styles
public struct HIGShadowSystem {
    public let platform: SixLayerPlatform
    
    public init(for platform: SixLayerPlatform) {
        self.platform = platform
    }
    
    /// Get shadow for a specific category
    public func shadow(for category: HIGShadowCategory) -> HIGShadow {
        switch category {
        case .elevated:
            return elevatedShadow
        case .floating:
            return floatingShadow
        case .custom(let radius, let offset, let color):
            return HIGShadow(
                color: color,
                radius: radius,
                offset: offset
            )
        }
    }
    
    private var elevatedShadow: HIGShadow {
        switch platform {
        case .iOS:
            return HIGShadow(
                color: Color.black.opacity(0.1),
                radius: 4,
                offset: CGSize(width: 0, height: 2)
            )
        case .macOS:
            return HIGShadow(
                color: Color.black.opacity(0.08),
                radius: 2,
                offset: CGSize(width: 0, height: 1)
            )
        default:
            return HIGShadow(
                color: Color.black.opacity(0.1),
                radius: 4,
                offset: CGSize(width: 0, height: 2)
            )
        }
    }
    
    private var floatingShadow: HIGShadow {
        switch platform {
        case .iOS:
            return HIGShadow(
                color: Color.black.opacity(0.15),
                radius: 8,
                offset: CGSize(width: 0, height: 4)
            )
        case .macOS:
            return HIGShadow(
                color: Color.black.opacity(0.12),
                radius: 6,
                offset: CGSize(width: 0, height: 3)
            )
        default:
            return HIGShadow(
                color: Color.black.opacity(0.15),
                radius: 8,
                offset: CGSize(width: 0, height: 4)
            )
        }
    }
}

/// Shadow category enum
public enum HIGShadowCategory {
    case elevated
    case floating
    case custom(radius: CGFloat, offset: CGSize, color: Color)
}

/// Shadow structure
public struct HIGShadow {
    public let color: Color
    public let radius: CGFloat
    public let offset: CGSize
    
    public init(color: Color, radius: CGFloat, offset: CGSize) {
        self.color = color
        self.radius = radius
        self.offset = offset
    }
}

// MARK: - Corner Radius System

/// Corner radius category system providing HIG-compliant radius values
public struct HIGCornerRadiusSystem {
    public let platform: SixLayerPlatform
    
    public init(for platform: SixLayerPlatform) {
        self.platform = platform
    }
    
    /// Get corner radius for a specific category
    public func radius(for category: HIGCornerRadiusCategory) -> CGFloat {
        switch category {
        case .small:
            return smallRadius
        case .medium:
            return mediumRadius
        case .large:
            return largeRadius
        case .custom(let value):
            return value
        }
    }
    
    private var smallRadius: CGFloat {
        switch platform {
        case .iOS:
            return 8
        case .macOS:
            return 4
        default:
            return 8
        }
    }
    
    private var mediumRadius: CGFloat {
        switch platform {
        case .iOS:
            return 12
        case .macOS:
            return 8
        default:
            return 12
        }
    }
    
    private var largeRadius: CGFloat {
        switch platform {
        case .iOS:
            return 16
        case .macOS:
            return 12
        default:
            return 16
        }
    }
}

/// Corner radius category enum
public enum HIGCornerRadiusCategory {
    case small
    case medium
    case large
    case custom(CGFloat)
}

// MARK: - Border Width System

/// Border width category system providing HIG-compliant border widths
public struct HIGBorderWidthSystem {
    public let platform: SixLayerPlatform
    
    public init(for platform: SixLayerPlatform) {
        self.platform = platform
    }
    
    /// Get border width for a specific category
    public func width(for category: HIGBorderWidthCategory) -> CGFloat {
        switch category {
        case .thin:
            return thinWidth
        case .medium:
            return mediumWidth
        case .thick:
            return thickWidth
        }
    }
    
    private var thinWidth: CGFloat {
        switch platform {
        case .iOS:
            return 0.5
        case .macOS:
            return 0.5
        default:
            return 0.5
        }
    }
    
    private var mediumWidth: CGFloat {
        switch platform {
        case .iOS:
            return 0.5
        case .macOS:
            return 1.0
        default:
            return 0.5
        }
    }
    
    private var thickWidth: CGFloat {
        switch platform {
        case .iOS:
            return 1.0
        case .macOS:
            return 2.0
        default:
            return 1.0
        }
    }
}

/// Border width category enum
public enum HIGBorderWidthCategory: CaseIterable {
    case thin
    case medium
    case thick
}

// MARK: - Opacity System

/// Opacity category system providing HIG-compliant opacity levels
public struct HIGOpacitySystem {
    public let platform: SixLayerPlatform
    
    public init(for platform: SixLayerPlatform) {
        self.platform = platform
    }
    
    /// Get opacity for a specific category
    public func opacity(for category: HIGOpacityCategory) -> Double {
        switch category {
        case .primary:
            return 1.0
        case .secondary:
            return 0.7
        case .tertiary:
            return 0.4
        case .custom(let value):
            return value
        }
    }
}

/// Opacity category enum
public enum HIGOpacityCategory {
    case primary
    case secondary
    case tertiary
    case custom(Double)
}

// MARK: - Blur System

/// Blur category system providing HIG-compliant blur effects
public struct HIGBlurSystem {
    public let platform: SixLayerPlatform
    
    public init(for platform: SixLayerPlatform) {
        self.platform = platform
    }
    
    /// Get blur for a specific category
    public func blur(for category: HIGBlurCategory) -> HIGBlur {
        switch category {
        case .light:
            return lightBlur
        case .medium:
            return mediumBlur
        case .heavy:
            return heavyBlur
        case .custom(let radius):
            return HIGBlur(radius: radius)
        }
    }
    
    private var lightBlur: HIGBlur {
        switch platform {
        case .iOS:
            return HIGBlur(radius: 5)
        case .macOS:
            return HIGBlur(radius: 4)
        default:
            return HIGBlur(radius: 5)
        }
    }
    
    private var mediumBlur: HIGBlur {
        switch platform {
        case .iOS:
            return HIGBlur(radius: 10)
        case .macOS:
            return HIGBlur(radius: 8)
        default:
            return HIGBlur(radius: 10)
        }
    }
    
    private var heavyBlur: HIGBlur {
        switch platform {
        case .iOS:
            return HIGBlur(radius: 20)
        case .macOS:
            return HIGBlur(radius: 16)
        default:
            return HIGBlur(radius: 20)
        }
    }
}

/// Blur category enum
public enum HIGBlurCategory {
    case light
    case medium
    case heavy
    case custom(radius: CGFloat)
}

/// Blur structure
public struct HIGBlur {
    public let radius: CGFloat
    
    public init(radius: CGFloat) {
        self.radius = radius
    }
}

