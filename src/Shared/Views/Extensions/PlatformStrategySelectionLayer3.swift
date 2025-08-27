import SwiftUI

// MARK: - Layer 3: Strategy Selection
/// Chooses the optimal implementation strategy based on content analysis
/// Delegates to Layer 4 for component implementation

// MARK: - Strategy Types

/// Layout strategy result
public struct LayoutStrategy {
    let approach: LayoutApproach
    let columns: Int
    let spacing: CGFloat
    let responsive: ResponsiveBehavior
    let reasoning: String
}

/// Grid strategy result
public struct GridStrategy {
    let type: GridType
    let columns: Int
    let spacing: CGFloat
    let breakpoints: [CGFloat]
}

/// Responsive behavior strategy
public struct ResponsiveBehavior {
    let type: ResponsiveType
    let breakpoints: [CGFloat]
    let adaptive: Bool
}

/// Card strategy result
public struct CardStrategy {
    let layout: CardLayoutType
    let sizing: CardSizing
    let interaction: CardInteraction
}

/// Content complexity levels
public enum ContentComplexity: Sendable {
    case simple      // Basic content, minimal interaction
    case moderate    // Some complexity, moderate interaction
    case complex     // Complex content, many interactions
    case veryComplex // Heavy content, many interactive elements
}

/// Content analysis result
public struct ContentAnalysis {
    let recommendedApproach: LayoutApproach
    let optimalSpacing: CGFloat
    let performanceConsiderations: [String]
}

/// Grid type options
public enum GridType {
    case adaptive
    case fixed(columns: Int)
    case lazy
    case staggered
}

/// Responsive type options
public enum ResponsiveType {
    case fixed
    case adaptive
    case fluid
    case breakpoint
}

/// Card layout type options
public enum CardLayoutType {
    case uniform
    case contentAware
    case aspectRatio
    case dynamic
}

/// Card sizing options
public enum CardSizing {
    case fixed(width: CGFloat, height: CGFloat)
    case flexible(minWidth: CGFloat, maxWidth: CGFloat)
    case adaptive
    case contentBased
}

/// Card interaction options
public enum CardInteraction {
    case tap
    case longPress
    case drag
    case hover
    case none
}

// MARK: - Strategy Selection Functions

/// Select optimal card layout strategy
/// Layer 3: Strategy Selection
public func selectCardLayoutStrategy_L3(
    contentCount: Int,
    screenWidth: CGFloat,
    deviceType: DeviceType,
    contentComplexity: ContentComplexity
) -> LayoutStrategy {
    
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
    
    return LayoutStrategy(
        approach: approach,
        columns: columns,
        spacing: spacing,
        responsive: responsive,
        reasoning: reasoning
    )
}

/// Choose optimal grid strategy
/// Layer 3: Strategy Selection
public func chooseGridStrategy(
    screenWidth: CGFloat,
    deviceType: DeviceType,
    contentCount: Int
) -> GridStrategy {
    
    let type: GridType
    let columns: Int
    let spacing: CGFloat
    let breakpoints: [CGFloat]
    
    if contentCount <= 3 {
        type = .fixed(columns: contentCount)
        columns = contentCount
        spacing = deviceType == .mac ? 20 : 16
        breakpoints = []
    } else if contentCount <= 8 {
        type = .adaptive
        columns = calculateOptimalColumns(
            width: screenWidth,
            device: deviceType,
            content: .moderate
        )
        spacing = deviceType == .mac ? 16 : 12
        breakpoints = [600, 900, 1200]
    } else {
        type = .lazy
        columns = calculateOptimalColumns(
            width: screenWidth,
            device: deviceType,
            content: .complex
        )
        spacing = deviceType == .mac ? 12 : 8
        breakpoints = [480, 768, 1024, 1440]
    }
    
    return GridStrategy(
        type: type,
        columns: columns,
        spacing: spacing,
        breakpoints: breakpoints
    )
}

/// Determine responsive behavior strategy
/// Layer 3: Strategy Selection
public func determineResponsiveBehavior(
    deviceType: DeviceType,
    contentComplexity: ContentComplexity
) -> ResponsiveBehavior {
    
    let type: ResponsiveType
    let breakpoints: [CGFloat]
    let adaptive: Bool
    
    switch (deviceType, contentComplexity) {
    case (.phone, _):
        type = .fixed
        breakpoints = []
        adaptive = false
    case (.pad, .simple):
        type = .adaptive
        breakpoints = [600, 900]
        adaptive = true
    case (.pad, _):
        type = .fluid
        breakpoints = [600, 900, 1200]
        adaptive = true
    case (.mac, .simple):
        type = .adaptive
        breakpoints = [800, 1200, 1600]
        adaptive = true
    case (.mac, _):
        type = .breakpoint
        breakpoints = [800, 1200, 1600, 2000]
        adaptive = true
    }
    
    return ResponsiveBehavior(
        type: type,
        breakpoints: breakpoints,
        adaptive: adaptive
    )
}

// MARK: - Helper Functions

/// Analyze card content to determine optimal layout
private func analyzeCardContent(
    count: Int,
    width: CGFloat,
    device: DeviceType,
    complexity: ContentComplexity
) -> ContentAnalysis {
    
    // Determine optimal approach based on content count and complexity
    let approach: LayoutApproach
    let spacing: CGFloat
    
    if count <= 3 {
        approach = .grid
        spacing = device == .mac ? 20 : 16
    } else if count <= 8 {
        approach = complexity == .simple ? .grid : .masonry
        spacing = device == .mac ? 16 : 12
    } else {
        approach = .adaptive
        spacing = device == .mac ? 12 : 8
    }
    
    let considerations = generatePerformanceConsiderations(
        count: count,
        complexity: complexity,
        device: device
    )
    
    return ContentAnalysis(
        recommendedApproach: approach,
        optimalSpacing: spacing,
        performanceConsiderations: considerations
    )
}

private func calculateOptimalColumns(
    width: CGFloat,
    device: DeviceType,
    content: ContentComplexity
) -> Int {
    
    let baseWidth: CGFloat
    switch content {
    case .simple: baseWidth = 200
    case .moderate: baseWidth = 250
    case .complex: baseWidth = 300
    case .veryComplex: baseWidth = 350
    }
    
    let columns = max(1, Int(width / baseWidth))
    return min(columns, device == .mac ? 6 : 4)
}

private func calculateAdaptiveWidths(
    width: CGFloat,
    device: DeviceType
) -> (minWidth: CGFloat, maxWidth: CGFloat) {
    
    let minWidth: CGFloat
    let maxWidth: CGFloat
    
    switch device {
    case .mac:
        minWidth = 200
        maxWidth = width * 0.8
    case .pad:
        minWidth = 180
        maxWidth = width * 0.7
    case .phone:
        minWidth = 160
        maxWidth = width * 0.9
    }
    
    return (minWidth, maxWidth)
}

private func generateCustomGridItems(
    width: CGFloat,
    device: DeviceType,
    content: ContentComplexity
) -> [GridItem] {
    
    let (minWidth, maxWidth) = calculateAdaptiveWidths(
        width: width,
        device: device
    )
    
    return [GridItem(.adaptive(minimum: minWidth, maximum: maxWidth))]
}

private func generatePerformanceConsiderations(
    count: Int,
    complexity: ContentComplexity,
    device: DeviceType
) -> [String] {
    
    var considerations: [String] = []
    
    if count > 20 {
        considerations.append("Consider lazy loading for large datasets")
    }
    
    if complexity == .veryComplex {
        considerations.append("Optimize rendering for complex content")
    }
    
    if device == .phone && count > 10 {
        considerations.append("Prioritize performance on mobile devices")
    }
    
    return considerations
}

private func generateStrategyReasoning(
    approach: LayoutApproach,
    columns: Int,
    spacing: CGFloat,
    responsive: ResponsiveBehavior
) -> String {
    
    var reasoning = "Selected \(approach) layout with \(columns) columns"
    
    if responsive.adaptive {
        reasoning += " and adaptive behavior"
    }
    
    reasoning += " for optimal user experience"
    
    return reasoning
}

// MARK: - Migration Phase: Temporary Type-Specific Layer 3 Functions
// These functions provide immediate strategy selection during migration while building toward
// the full intelligent strategy selection system. They will be consolidated into generic
// functions once the system is mature.

/// Form strategy for implementing form containers
public struct FormStrategy {
    let containerType: FormContainerType
    let fieldLayout: FieldLayout
    let validation: ValidationStrategy
    let platformAdaptations: [ModalPlatform: PlatformAdaptation]
}

/// Form container types
public enum FormContainerType {
    case form
    case card
    case sheet
}

/// Field layout strategies
public enum FieldLayout {
    case compact
    case standard
    case spacious
}

/// Platform adaptations
public enum PlatformAdaptation {
    case largeFields
    case standardFields
    case compactFields
}

/// Modal strategy for implementing modal containers
public struct ModalStrategy {
    let presentationType: ModalPresentationType
    let sizing: ModalSizing
    let detents: [SheetDetent]
    let platformOptimizations: [ModalPlatform: ModalConstraint]
}

/// Temporary Layer 3 function for selecting form strategy for AddFuelView
/// This provides immediate domain-specific strategy logic while building the intelligent system
@MainActor
public func selectFormStrategy_AddFuelView_L3(
    layout: FormLayoutDecision
) -> FormStrategy {
    // Hardcoded for now, will become intelligent later
    // Select the optimal strategy based on the layout decision
    return FormStrategy(
        containerType: FormContainerType.form,
        fieldLayout: FieldLayout.standard,
        validation: ValidationStrategy.realTime,
        platformAdaptations: [ModalPlatform.macOS: PlatformAdaptation.largeFields, ModalPlatform.iOS: PlatformAdaptation.standardFields]
    )
}

/// Temporary Layer 3 function for selecting modal strategy for forms
/// This handles sheet presentation strategy decisions
@MainActor
public func selectModalStrategy_Form_L3(
    layout: ModalLayoutDecision
) -> ModalStrategy {
    // Hardcoded for now, will become intelligent later
    // Select the optimal modal strategy based on the layout decision
    return ModalStrategy(
        presentationType: layout.presentationType,
        sizing: layout.sizing,
        detents: layout.detents,
        platformOptimizations: layout.platformConstraints
    )
}

/// Temporary Layer 3 function for selecting vehicle form strategy
/// THIS IS WHERE PLATFORM DETECTION HAPPENS - Layer 3 is platform-aware
@MainActor
public func selectFormStrategy_VehicleForm_L3(
    layout: VehicleFormLayoutDecision
) -> VehicleFormStrategy {
    // Platform detection happens in Layer 3
    #if os(iOS)
    let currentPlatform = ModalPlatform.iOS
    #elseif os(macOS)
    let currentPlatform = ModalPlatform.macOS
    #else
    let currentPlatform = ModalPlatform.iOS // Default fallback
    #endif
    
    // Platform-specific strategy selection based on content analysis from Layer 2
    let containerType: VehicleFormContainerType
    
    // iOS has Form rendering issues with complex forms - use ScrollView
    // macOS Form component works reliably
    switch (currentPlatform, layout.contentComplexity) {
    case (.iOS, .complex), (.iOS, .moderate):
        containerType = .scrollView // iOS Form has rendering issues
    case (.macOS, _):
        containerType = .form // macOS Form works reliably
    case (.iOS, .simple):
        containerType = .form // Simple iOS forms work fine
    default:
        containerType = .scrollView // Safe default
    }
    
    return VehicleFormStrategy(
        containerType: containerType,
        fieldLayout: layout.fieldLayout,
        spacing: mapSpacingToStrategy(layout.spacing),
        validation: layout.validation,
        platform: currentPlatform,
        reasoning: "Platform: \(currentPlatform), Complexity: \(layout.contentComplexity) → Container: \(containerType)"
    )
}

/// Vehicle form strategy structure
public struct VehicleFormStrategy {
    let containerType: VehicleFormContainerType
    let fieldLayout: FieldLayout
    let spacing: SpacingStrategy
    let validation: ValidationStrategy
    let platform: ModalPlatform
    let reasoning: String
}

/// Vehicle form container types (platform-specific implementation choices)
public enum VehicleFormContainerType {
    case form        // Use SwiftUI Form (works on macOS, issues on iOS)
    case scrollView  // Use ScrollView + VStack (reliable on iOS)
}

/// Spacing strategy mapping
public enum SpacingStrategy {
    case tight       // 8pt spacing
    case standard    // 16pt spacing  
    case comfortable // 20pt spacing
    case generous    // 24pt spacing
}

/// Helper function to map content-based spacing to implementation spacing
private func mapSpacingToStrategy(_ preference: SpacingPreference) -> SpacingStrategy {
    switch preference {
    case .compact: return .tight
    case .comfortable: return .standard
    case .generous: return .comfortable
    }
}

// MARK: - Migration Phase: Temporary Functions

/// TEMPORARY Layer 3 function that contains our current working AddVehicleView implementation
/// This will be replaced by intelligent strategy selection later
/// For now, it returns the strategy that matches our current working implementation
@MainActor
public func selectFormStrategy_VehicleForm_L3_TEMP(
    layout: VehicleFormLayoutDecision
) -> VehicleFormStrategy {
    // Our current working implementation uses ScrollView for iOS (avoiding Form rendering issues)
    // and platformFormToolbar - this is what we're preserving during migration
    return VehicleFormStrategy(
        containerType: .scrollView, // Use ScrollView to avoid iOS Form issues
        fieldLayout: layout.fieldLayout,
        spacing: mapSpacingToStrategy(layout.spacing),
        validation: layout.validation,
        platform: .iOS, // Will be detected dynamically later
        reasoning: "MIGRATION: Using ScrollView to avoid iOS Form rendering issues"
    )
}
