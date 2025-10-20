import SwiftUI

// MARK: - Layer 2: Layout Decision Engine for Intelligent Card Expansion

/// Layout decision result for intelligent card expansion
public struct IntelligentCardLayoutDecision: Sendable {
    public let columns: Int
    public let spacing: CGFloat
    public let cardWidth: CGFloat
    public let cardHeight: CGFloat
    public let padding: CGFloat
    public let expansionScale: Double
    public let animationDuration: TimeInterval
    
    public init(
        columns: Int,
        spacing: CGFloat,
        cardWidth: CGFloat,
        cardHeight: CGFloat,
        padding: CGFloat,
        expansionScale: Double = 1.15,
        animationDuration: TimeInterval = 0.3
    ) {
        self.columns = columns
        self.spacing = spacing
        self.cardWidth = cardWidth
        self.cardHeight = cardHeight
        self.padding = padding
        self.expansionScale = expansionScale
        self.animationDuration = animationDuration
    }
}

// ContentComplexity is already defined in PlatformTypes.swift

/// Intelligent layout decision engine for card collections
public func determineIntelligentCardLayout_L2(
    contentCount: Int,
    screenWidth: CGFloat,
    deviceType: DeviceType,
    contentComplexity: ContentComplexity
) -> IntelligentCardLayoutDecision {
    
    // Base calculations
    let availableWidth = screenWidth - 32 // Account for padding
    let minCardWidth: CGFloat = 200
    let maxCardWidth: CGFloat = 400
    
    // Determine optimal columns based on device and content
    let columns = calculateOptimalColumns(
        contentCount: contentCount,
        screenWidth: screenWidth,
        deviceType: deviceType,
        contentComplexity: contentComplexity
    )
    
    // Calculate spacing and card dimensions
    let spacing = calculateOptimalSpacing(deviceType: deviceType, contentComplexity: contentComplexity)
    let cardWidth = max(minCardWidth, min(maxCardWidth, (availableWidth - spacing * CGFloat(columns - 1)) / CGFloat(columns)))
    let cardHeight = calculateOptimalHeight(cardWidth: cardWidth, contentComplexity: contentComplexity)
    
    // Determine expansion behavior
    let expansionScale = calculateExpansionScale(deviceType: deviceType, contentComplexity: contentComplexity)
    let animationDuration = calculateAnimationDuration(deviceType: deviceType)
    
    return IntelligentCardLayoutDecision(
        columns: columns,
        spacing: spacing,
        cardWidth: cardWidth,
        cardHeight: cardHeight,
        padding: 16,
        expansionScale: expansionScale,
        animationDuration: animationDuration
    )
}

/// Calculate optimal number of columns
private func calculateOptimalColumns(
    contentCount: Int,
    screenWidth: CGFloat,
    deviceType: DeviceType,
    contentComplexity: ContentComplexity
) -> Int {
    
    switch deviceType {
    case .phone:
        // iPhone: 1-2 columns based on content
        if contentCount <= 2 {
            return 1
        } else if screenWidth > 400 {
            return 2
        } else {
            return 1
        }
    case .vision:
        // Vision: 1 column for immersive experience
        return 1
        
    case .pad:
        // iPad: 2-4 columns based on content and complexity
        switch contentComplexity {
        case .simple:
            return min(4, max(2, contentCount / 2))
        case .moderate:
            return min(3, max(2, contentCount / 3))
        case .complex, .veryComplex, .advanced:
            return min(2, max(1, contentCount / 4))
        }
        
    case .mac:
        // Mac: 3-6 columns based on screen width
        if screenWidth < 1200 {
            return min(3, max(2, contentCount / 3))
        } else if screenWidth < 1800 {
            return min(4, max(3, contentCount / 4))
        } else {
            return min(6, max(4, contentCount / 6))
        }
        
    case .watch:
        // Apple Watch: Always 1 column
        return 1
        
    case .tv:
        // Apple TV: 2-3 columns
        return min(3, max(2, contentCount / 3))
        
    case .car:
        // CarPlay: 1-2 columns for safety
        return min(2, max(1, contentCount / 2))
    }
}

/// Calculate optimal spacing between cards
private func calculateOptimalSpacing(deviceType: DeviceType, contentComplexity: ContentComplexity) -> CGFloat {
    let baseSpacing: CGFloat
    
    switch deviceType {
    case .phone:
        baseSpacing = 12
    case .vision:
        baseSpacing = 16
    case .pad:
        baseSpacing = 16
    case .mac:
        baseSpacing = 20
    case .watch:
        baseSpacing = 8
    case .tv:
        baseSpacing = 24
    case .car:
        baseSpacing = 16
    }
    
    // Adjust based on content complexity
    switch contentComplexity {
    case .simple:
        return baseSpacing
    case .moderate:
        return baseSpacing * 1.2
    case .complex:
        return baseSpacing * 1.5
    case .veryComplex:
        return baseSpacing * 2.0
    case .advanced:
        return baseSpacing * 2.0
    }
}

/// Calculate optimal card height
private func calculateOptimalHeight(cardWidth: CGFloat, contentComplexity: ContentComplexity) -> CGFloat {
    let aspectRatio: CGFloat
    
    switch contentComplexity {
    case .simple:
        aspectRatio = 1.2 // Slightly taller than wide
    case .moderate:
        aspectRatio = 1.4
    case .complex:
        aspectRatio = 1.6
    case .veryComplex:
        aspectRatio = 1.8
    case .advanced:
        aspectRatio = 1.8
    }
    
    return cardWidth * aspectRatio
}

/// Calculate expansion scale based on device and content
private func calculateExpansionScale(deviceType: DeviceType, contentComplexity: ContentComplexity) -> Double {
    let baseScale: Double
    
    switch deviceType {
    case .phone:
        baseScale = 1.1 // Subtle expansion on small screens
    case .vision:
        baseScale = 1.05 // Minimal expansion for immersive experience
    case .pad:
        baseScale = 1.15 // Moderate expansion on tablets
    case .mac:
        baseScale = 1.2 // More pronounced expansion on desktop
    case .watch:
        baseScale = 1.05 // Minimal expansion on watch
    case .tv:
        baseScale = 1.25 // Large expansion for TV viewing
    case .car:
        baseScale = 1.1 // Conservative expansion for CarPlay safety
    }
    
    // Adjust based on content complexity
    switch contentComplexity {
    case .simple:
        return baseScale
    case .moderate:
        return baseScale * 1.05
    case .complex:
        return baseScale * 1.1
    case .veryComplex:
        return baseScale * 1.15
    case .advanced:
        return baseScale * 1.15
    }
}

/// Calculate animation duration based on device
private func calculateAnimationDuration(deviceType: DeviceType) -> TimeInterval {
    switch deviceType {
    case .phone, .pad:
        return 0.25 // Fast animations for touch interfaces
    case .vision:
        return 0.3 // Slightly slower for immersive experience
    case .mac:
        return 0.3 // Slightly slower for desktop
    case .watch:
        return 0.15 // Very fast for watch
    case .tv:
        return 0.4 // Slower for TV viewing
    case .car:
        return 0.2 // Fast for CarPlay safety
    }
}
