//
//  PlatformLayoutDecisionLayer2.swift
//  SixLayerFramework
//
//  Level 2: Layout Decision Engine - Content-aware layout analysis and decision making
//

import SwiftUI

// MARK: - Layer 2: Layout Decision Engine
// This layer analyzes content and makes layout decisions based on content characteristics
// It is CONTENT-AWARE but NOT platform-aware (platform decisions happen in Layer 3)

// MARK: - Generic Layout Decision Functions

/// Determine optimal layout for any collection of items
/// Analyzes content characteristics and makes layout decisions
@MainActor
public func determineOptimalLayout_L2<Item: Identifiable>(
    items: [Item],
    hints: PresentationHints
) -> GenericLayoutDecision {
    
    // Analyze content characteristics
    let itemCount = items.count
    let complexity = analyzeContentComplexity(itemCount: itemCount, hints: hints)
    let deviceCapabilities = getCurrentDeviceCapabilities()
    
    // Make layout decisions based on content analysis
    let layoutApproach = chooseLayoutApproach(complexity: complexity, capabilities: deviceCapabilities)
    let columns = calculateOptimalColumns(itemCount: itemCount, complexity: complexity, capabilities: deviceCapabilities)
    let spacing = calculateOptimalSpacing(complexity: complexity, capabilities: deviceCapabilities)
    let performance = choosePerformanceStrategy(complexity: complexity, capabilities: deviceCapabilities)
    
    return GenericLayoutDecision(
        approach: layoutApproach,
        columns: columns,
        spacing: spacing,
        performance: performance,
        reasoning: generateLayoutReasoning(approach: layoutApproach, columns: columns, spacing: spacing, performance: performance)
    )
}

/// Determine optimal form layout based on content analysis
@MainActor
public func determineOptimalFormLayout_L2(
    hints: PresentationHints
) -> GenericFormLayoutDecision {
    
    // Analyze form content complexity based on hints
    let fieldCount = Int(hints.customPreferences["fieldCount"] ?? "5") ?? 5
    let hasComplexFields = hints.customPreferences["hasComplexFields"] == "true"
    let hasValidation = hints.customPreferences["hasValidation"] == "true"
    
    // Content complexity analysis
    let contentComplexity: ContentComplexity = {
        if fieldCount >= 8 && hasComplexFields && hasValidation {
            return .complex
        } else if fieldCount >= 5 {
            return .moderate
        } else {
            return .simple
        }
    }()
    
    // Layout decision based on content analysis (not platform!)
    return GenericFormLayoutDecision(
        preferredContainer: .adaptive, // Let Layer 3 decide Form vs ScrollView based on platform
        fieldLayout: .standard, // Standard forms work well with standard layout
        spacing: .comfortable, // Complex forms need breathing room
        validation: hasValidation ? .realTime : .none, // Use validation if specified
        contentComplexity: contentComplexity,
        reasoning: "Form layout optimized based on field count and complexity"
    )
}

// MARK: - Content Analysis Functions

private func analyzeContentComplexity(itemCount: Int, hints: PresentationHints) -> ContentComplexity {
    switch itemCount {
    case 0...5:
        return .simple
    case 6...15:
        return .moderate
    case 16...30:
        return .complex
    default:
        return .veryComplex
    }
}

private func chooseLayoutApproach(complexity: ContentComplexity, capabilities: DeviceCapabilities) -> LayoutApproach {
    switch complexity {
    case .simple:
        return .uniform
    case .moderate:
        return .adaptive
    case .complex:
        return .responsive
    case .veryComplex:
        return .dynamic
    }
}

private func calculateOptimalColumns(itemCount: Int, complexity: ContentComplexity, capabilities: DeviceCapabilities) -> Int {
    let baseColumns = max(1, min(6, itemCount / 3))
    
    switch complexity {
    case .simple:
        return min(baseColumns, 3)
    case .moderate:
        return min(baseColumns, 4)
    case .complex:
        return min(baseColumns, 5)
    case .veryComplex:
        return min(baseColumns, 6)
    }
}

private func calculateOptimalSpacing(complexity: ContentComplexity, capabilities: DeviceCapabilities) -> CGFloat {
    switch complexity {
    case .simple:
        return 8
    case .moderate:
        return 16
    case .complex:
        return 24
    case .veryComplex:
        return 32
    }
}

private func choosePerformanceStrategy(complexity: ContentComplexity, capabilities: DeviceCapabilities) -> PerformanceStrategy {
    switch complexity {
    case .simple:
        return .standard
    case .moderate:
        return .optimized
    case .complex:
        return .highPerformance
    case .veryComplex:
        return .maximumPerformance
    }
}

private func getCurrentDeviceCapabilities() -> DeviceCapabilities {
    return DeviceCapabilities()
}

// MARK: - Data Structures

/// Generic layout decision structure
public struct GenericLayoutDecision {
    public let approach: LayoutApproach
    public let columns: Int
    public let spacing: CGFloat
    public let performance: PerformanceStrategy
    public let reasoning: String
    
    public init(
        approach: LayoutApproach,
        columns: Int,
        spacing: CGFloat,
        performance: PerformanceStrategy,
        reasoning: String
    ) {
        self.approach = approach
        self.columns = columns
        self.spacing = spacing
        self.performance = performance
        self.reasoning = reasoning
    }
}

/// Generic form layout decision structure
public struct GenericFormLayoutDecision {
    public let preferredContainer: ContainerPreference
    public let fieldLayout: FieldLayout
    public let spacing: SpacingPreference
    public let validation: ValidationStrategy
    public let contentComplexity: ContentComplexity
    public let reasoning: String
    
    public init(
        preferredContainer: ContainerPreference,
        fieldLayout: FieldLayout,
        spacing: SpacingPreference,
        validation: ValidationStrategy,
        contentComplexity: ContentComplexity,
        reasoning: String
    ) {
        self.preferredContainer = preferredContainer
        self.fieldLayout = fieldLayout
        self.spacing = spacing
        self.validation = validation
        self.contentComplexity = contentComplexity
        self.reasoning = reasoning
    }
}

// Layout approach is defined in PlatformTypes.swift to avoid duplication



/// Container preference (content-based, not platform-based)
public enum ContainerPreference: String, CaseIterable {
    case adaptive = "adaptive"         // Let Layer 3 choose based on platform capabilities
    case structured = "structured"     // Prefer structured container (Form-like)
    case flexible = "flexible"         // Prefer flexible container (ScrollView-like)
}



/// Performance strategy
public enum PerformanceStrategy: String, CaseIterable {
    case standard = "standard"         // Standard performance
    case optimized = "optimized"       // Optimized performance
    case highPerformance = "highPerformance" // High performance
    case maximumPerformance = "maximumPerformance" // Maximum performance
}

/// Device capabilities for layout decisions
public struct DeviceCapabilities {
    public let screenSize: CGSize
    public let orientation: UIDeviceOrientation
    public let memoryAvailable: Int64
    
    public init() {
        #if os(iOS)
        self.screenSize = UIScreen.main.bounds.size
        self.orientation = UIDevice.current.orientation
        #else
        self.screenSize = CGSize(width: 1024, height: 768)
        self.orientation = .portrait
        #endif
        
        // Placeholder for memory availability
        self.memoryAvailable = 1024 * 1024 * 1024 // 1GB default
    }
}

// Responsive behavior types are defined in PlatformTypes.swift to avoid duplication





// MARK: - Helper Functions

private func generateLayoutReasoning(approach: LayoutApproach, columns: Int, spacing: CGFloat, performance: PerformanceStrategy) -> String {
    return "Layout optimized for current device and content: \(approach.rawValue) approach with \(columns) columns, \(spacing)pt spacing, and \(performance.rawValue) performance"
}

// MARK: - Card Layout Decision Functions

/// Determine optimal card layout for the given content and device
/// Layer 2: Layout Decision
public func determineOptimalCardLayout_L2(
    contentCount: Int,
    screenWidth: CGFloat,
    deviceType: DeviceType,
    contentComplexity: ContentComplexity
) -> CardLayoutDecision {
    
    // Analyze content and device capabilities
    let analysis = analyzeCardContent(
        count: contentCount,
        width: screenWidth,
        device: deviceType,
        complexity: contentComplexity
    )
    
    // Choose optimal approach
    let approach = analysis.recommendedApproach
    let columns = calculateOptimalColumns(
        width: screenWidth,
        device: deviceType,
        content: contentComplexity
    )
    let spacing = analysis.optimalSpacing
    let responsive = determineResponsiveBehavior(
        deviceType: deviceType,
        contentComplexity: contentComplexity
    )
    
    let reasoning = generateStrategyReasoning(
        approach: approach,
        columns: columns,
        spacing: spacing,
        responsive: responsive
    )
    
    return CardLayoutDecision(
        layout: .uniform,
        sizing: .adaptive,
        interaction: .tap,
        responsive: ResponsiveBehavior(
            type: .adaptive,
            breakpoints: [320, 768, 1024, 1440],
            adaptive: true
        ),
        spacing: spacing,
        columns: columns
    )
}

/// Analyze card content for layout decisions
private func analyzeCardContent(
    count: Int,
    width: CGFloat,
    device: DeviceType,
    complexity: ContentComplexity
) -> ContentAnalysis {
    
    var considerations: [String] = []
    
    if complexity == .complex || complexity == .veryComplex {
        considerations.append("Optimize rendering for complex content")
    }
    
    if device == .phone && count > 10 {
        considerations.append("Prioritize performance on mobile devices")
    }
    
    return ContentAnalysis(
        recommendedApproach: .adaptive,
        optimalSpacing: 16.0,
        performanceConsiderations: considerations
    )
}

/// Calculate optimal number of columns based on screen width and device
private func calculateOptimalColumns(
    width: CGFloat,
    device: DeviceType,
    content: ContentComplexity
) -> Int {
    switch device {
    case .phone:
        return content == .simple ? 1 : 2
    case .pad:
        return content == .simple ? 2 : 3
    case .mac:
        return content == .simple ? 3 : 4
    case .tv:
        return 4
    case .watch:
        return 1
    }
}



/// Generate strategy reasoning for card layout
private func generateStrategyReasoning(
    approach: LayoutApproach,
    columns: Int,
    spacing: CGFloat,
    responsive: ResponsiveBehavior
) -> String {
    
    var reasoning = "Selected \(approach.rawValue) layout with \(columns) columns"
    
    if responsive.adaptive {
        reasoning += " and adaptive behavior"
    }
    
    reasoning += " for optimal user experience"
    
    return reasoning
}
