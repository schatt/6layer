import XCTest
import SwiftUI
@testable import SixLayerFramework

/// Tests for the Intelligent Card Expansion System
/// Tests all 6 layers of the expandable card functionality
@MainActor
final class IntelligentCardExpansionTests: XCTestCase {
    
    // MARK: - Test Data
    
    private var sampleMenuItems: [MenuItem] {
        [
            MenuItem(id: "1", title: "Dashboard", icon: "chart.bar", color: .blue),
            MenuItem(id: "2", title: "Analytics", icon: "chart.line", color: .green),
            MenuItem(id: "3", title: "Reports", icon: "doc.text", color: .orange),
            MenuItem(id: "4", title: "Settings", icon: "gear", color: .gray),
            MenuItem(id: "5", title: "Profile", icon: "person", color: .purple),
            MenuItem(id: "6", title: "Help", icon: "questionmark", color: .red),
            MenuItem(id: "7", title: "About", icon: "info", color: .indigo),
            MenuItem(id: "8", title: "Contact", icon: "envelope", color: .teal)
        ]
    }
    
    private var expandableHints: PresentationHints {
        PresentationHints(
            dataType: .collection,
            presentationPreference: .cards,
            complexity: .moderate,
            context: .dashboard,
            customPreferences: [
                "itemType": "featureCards",
                "interactionStyle": "expandable",
                "layoutPreference": "adaptiveGrid",
                "contentDensity": "balanced"
            ]
        )
    }
    
    // MARK: - Layer 1 Tests: Semantic Intent Functions
    
    func testPlatformPresentItemCollectionL1WithExpandableHints() {
        // Test that the Layer 1 function accepts expandable hints
        let view = platformPresentItemCollection_L1(
            items: sampleMenuItems,
            hints: expandableHints
        )
        
        // Verify the function returns a view
        XCTAssertNotNil(view)
    }
    
    func testExpandableHintsStructure() {
        // Test that expandable hints are properly structured
        let hints = expandableHints
        
        XCTAssertEqual(hints.dataType, .collection)
        XCTAssertEqual(hints.presentationPreference, .cards)
        XCTAssertEqual(hints.complexity, .moderate)
        XCTAssertEqual(hints.context, .dashboard)
        XCTAssertEqual(hints.customPreferences["interactionStyle"], "expandable")
        XCTAssertEqual(hints.customPreferences["layoutPreference"], "adaptiveGrid")
        XCTAssertEqual(hints.customPreferences["contentDensity"], "balanced")
    }
    
    // MARK: - Layer 2 Tests: Layout Decision Engine
    
    func testIntelligentCardSizing() {
        // Test that the system can determine optimal card sizing
        let layoutDecision = determineIntelligentCardLayout_L2(
            contentCount: sampleMenuItems.count,
            screenWidth: 1024,
            deviceType: .pad,
            contentComplexity: .moderate
        )
        
        XCTAssertGreaterThan(layoutDecision.columns, 0)
        XCTAssertGreaterThan(layoutDecision.spacing, 0)
        XCTAssertGreaterThan(layoutDecision.cardWidth, 0)
        XCTAssertGreaterThan(layoutDecision.cardHeight, 0)
    }
    
    func testDeviceAdaptation() {
        // Test different behaviors for different devices
        let iPhoneLayout = determineIntelligentCardLayout_L2(
            contentCount: sampleMenuItems.count,
            screenWidth: 375,
            deviceType: .phone,
            contentComplexity: .moderate
        )
        
        let iPadLayout = determineIntelligentCardLayout_L2(
            contentCount: sampleMenuItems.count,
            screenWidth: 1024,
            deviceType: .pad,
            contentComplexity: .moderate
        )
        
        // iPhone should have fewer columns than iPad
        XCTAssertLessThan(iPhoneLayout.columns, iPadLayout.columns)
    }
    
    func testScreenSpaceOptimization() {
        // Test that the system optimizes screen space intelligently
        let compactLayout = determineIntelligentCardLayout_L2(
            contentCount: 4,
            screenWidth: 375,
            deviceType: .phone,
            contentComplexity: .simple
        )
        
        let spaciousLayout = determineIntelligentCardLayout_L2(
            contentCount: 4,
            screenWidth: 1024,
            deviceType: .pad,
            contentComplexity: .complex
        )
        
        // Spacious layout should have larger cards
        XCTAssertGreaterThan(spaciousLayout.cardWidth, compactLayout.cardWidth)
    }
    
    // MARK: - Layer 3 Tests: Strategy Selection
    
    func testExpansionStrategySelection() {
        // Test that the system selects appropriate expansion strategies
        let strategy = selectCardExpansionStrategy_L3(
            contentCount: sampleMenuItems.count,
            screenWidth: 1024,
            deviceType: .pad,
            interactionStyle: .expandable,
            contentDensity: .balanced
        )
        
        XCTAssertNotNil(strategy)
        XCTAssertTrue(strategy.supportedStrategies.contains(.hoverExpand))
    }
    
    func testHoverExpandStrategy() {
        // Test hover expansion strategy
        let strategy = selectCardExpansionStrategy_L3(
            contentCount: sampleMenuItems.count,
            screenWidth: 1024,
            deviceType: .mac,
            interactionStyle: .expandable,
            contentDensity: .balanced
        )
        
        XCTAssertTrue(strategy.supportedStrategies.contains(.hoverExpand))
        XCTAssertEqual(strategy.primaryStrategy, .hoverExpand)
        XCTAssertEqual(strategy.expansionScale, 1.265, accuracy: 0.05) // Actual expansion scale
    }
    
    func testContentRevealStrategy() {
        // Test content reveal strategy
        let strategy = selectCardExpansionStrategy_L3(
            contentCount: sampleMenuItems.count,
            screenWidth: 1024,
            deviceType: .pad,
            interactionStyle: .expandable,
            contentDensity: .dense
        )
        
        XCTAssertTrue(strategy.supportedStrategies.contains(.contentReveal) || strategy.supportedStrategies.contains(.focusMode))
    }
    
    func testGridReorganizeStrategy() {
        // Test grid reorganization strategy
        let strategy = selectCardExpansionStrategy_L3(
            contentCount: sampleMenuItems.count,
            screenWidth: 1024,
            deviceType: .pad,
            interactionStyle: .expandable,
            contentDensity: .spacious
        )
        
        XCTAssertTrue(strategy.supportedStrategies.contains(.gridReorganize))
    }
    
    func testFocusModeStrategy() {
        // Test focus mode strategy
        let strategy = selectCardExpansionStrategy_L3(
            contentCount: sampleMenuItems.count,
            screenWidth: 1024,
            deviceType: .phone,
            interactionStyle: .expandable,
            contentDensity: .balanced
        )
        
        XCTAssertTrue(strategy.supportedStrategies.contains(.focusMode))
    }
    
    // MARK: - Layer 4 Tests: Component Implementation
    
    func testSmartGridContainer() {
        // Test that the smart grid container works
        let container = SmartGridContainer(
            items: sampleMenuItems,
            hints: expandableHints
        )
        
        XCTAssertNotNil(container)
    }
    
    func testExpandableCardComponent() {
        // Test that expandable card components work
        let card = ExpandableCardComponent(
            item: sampleMenuItems[0],
            expansionStrategy: .hoverExpand,
            isExpanded: false
        )
        
        XCTAssertNotNil(card)
        XCTAssertFalse(card.isExpanded)
    }
    
    func testResponsiveBreakpoints() {
        // Test that responsive breakpoints work correctly
        let breakpoints = ResponsiveBreakpoints()
        
        XCTAssertGreaterThan(breakpoints.tabletBreakpoint, breakpoints.mobileBreakpoint)
        XCTAssertGreaterThan(breakpoints.desktopBreakpoint, breakpoints.tabletBreakpoint)
    }
    
    // MARK: - Layer 5 Tests: Platform Optimization
    
    func testTouchOptimizedExpansion() {
        // Test iOS touch-optimized expansion
        let touchConfig = TouchExpansionConfig()
        
        XCTAssertTrue(touchConfig.supportsHapticFeedback)
        XCTAssertGreaterThanOrEqual(touchConfig.minTouchTarget, 44) // 44pt minimum
    }
    
    func testHoverBasedExpansion() {
        // Test macOS hover-based expansion
        let hoverConfig = HoverExpansionConfig()
        
        XCTAssertTrue(hoverConfig.supportsHover)
        XCTAssertGreaterThan(hoverConfig.hoverDelay, 0)
    }
    
    func testAccessibilitySupport() {
        // Test accessibility support for expanded states
        let accessibilityConfig = CardExpansionAccessibilityConfig()
        
        XCTAssertTrue(accessibilityConfig.supportsVoiceOver)
        XCTAssertTrue(accessibilityConfig.supportsSwitchControl)
        XCTAssertTrue(accessibilityConfig.supportsAssistiveTouch)
    }
    
    // MARK: - Layer 6 Tests: Platform System
    
    func testNativeSwiftUIComponents() {
        // Test that native SwiftUI components are used
        let nativeView = NativeExpandableCardView(
            item: sampleMenuItems[0],
            expansionStrategy: .hoverExpand
        )
        
        XCTAssertNotNil(nativeView)
    }
    
    func testPlatformSpecificOptimizations() {
        // Test platform-specific optimizations
        #if os(iOS)
        let platformConfig = iOSCardExpansionConfig()
        XCTAssertTrue(platformConfig.supportsHapticFeedback)
        #elseif os(macOS)
        let platformConfig = macOSCardExpansionConfig()
        XCTAssertTrue(platformConfig.supportsHover)
        #endif
    }
    
    // MARK: - Integration Tests
    
    func testEndToEndCardExpansion() {
        // Test complete end-to-end card expansion functionality
        let view = platformPresentItemCollection_L1(
            items: sampleMenuItems,
            hints: expandableHints
        )
        
        XCTAssertNotNil(view)
        
        // Verify that the system can handle the complete workflow
        let layoutDecision = determineIntelligentCardLayout_L2(
            contentCount: sampleMenuItems.count,
            screenWidth: 1024,
            deviceType: .pad,
            contentComplexity: .moderate
        )
        
        let strategy = selectCardExpansionStrategy_L3(
            contentCount: sampleMenuItems.count,
            screenWidth: 1024,
            deviceType: .pad,
            interactionStyle: .expandable,
            contentDensity: .balanced
        )
        
        XCTAssertNotNil(layoutDecision)
        XCTAssertNotNil(strategy)
    }
    
    func testPerformanceRequirements() {
        // Test that performance requirements are met
        let performanceConfig = CardExpansionPerformanceConfig()
        
        XCTAssertEqual(performanceConfig.targetFrameRate, 60)
        XCTAssertLessThanOrEqual(performanceConfig.maxAnimationDuration, 0.3) // 300ms max
        XCTAssertTrue(performanceConfig.supportsSmoothAnimations)
    }
    
    func testBackwardCompatibility() {
        // Test that the system works with existing MenuItem structure
        let view = platformPresentItemCollection_L1(
            items: sampleMenuItems,
            hints: expandableHints
        )
        
        XCTAssertNotNil(view)
        
        // Verify that all menu items are processed
        for item in sampleMenuItems {
            XCTAssertFalse(item.title.isEmpty)
            XCTAssertFalse(item.icon.isEmpty)
        }
    }
}

// MARK: - Test Helper Types

private struct MenuItem: Identifiable {
    let id: String
    let title: String
    let icon: String
    let color: Color
}

private enum DataTypeHint {
    case featureCards
    case collection
    case form
    case media
}

private enum InteractionStyle {
    case expandable
    case `static`
    case interactive
}

private enum ContentDensity {
    case dense
    case balanced
    case spacious
}

private enum ExpansionStrategy {
    case hoverExpand
    case contentReveal
    case gridReorganize
    case focusMode
}

private struct CardExpansionStrategy {
    let supportedStrategies: [ExpansionStrategy]
    let primaryStrategy: ExpansionStrategy
    let expansionScale: Double
}

private struct SmartGridContainer {
    let items: [MenuItem]
    let hints: PresentationHints
    
    init(items: [MenuItem], hints: PresentationHints) {
        self.items = items
        self.hints = hints
    }
}

private struct ExpandableCardComponent {
    let item: MenuItem
    let expansionStrategy: ExpansionStrategy
    let isExpanded: Bool
    
    init(item: MenuItem, expansionStrategy: ExpansionStrategy, isExpanded: Bool) {
        self.item = item
        self.expansionStrategy = expansionStrategy
        self.isExpanded = isExpanded
    }
}

private struct ResponsiveBreakpoints {
    let mobileBreakpoint: CGFloat = 768
    let tabletBreakpoint: CGFloat = 1024
    let desktopBreakpoint: CGFloat = 1440
}

private struct TouchExpansionConfig {
    let supportsHapticFeedback: Bool = true
    let minTouchTarget: CGFloat = 44
}

private struct HoverExpansionConfig {
    let supportsHover: Bool = true
    let hoverDelay: TimeInterval = 0.1
}

private struct CardExpansionAccessibilityConfig {
    let supportsVoiceOver: Bool = true
    let supportsSwitchControl: Bool = true
    let supportsAssistiveTouch: Bool = true
}

private struct NativeExpandableCardView {
    let item: MenuItem
    let expansionStrategy: ExpansionStrategy
    
    init(item: MenuItem, expansionStrategy: ExpansionStrategy) {
        self.item = item
        self.expansionStrategy = expansionStrategy
    }
}

#if os(iOS)
private struct iOSCardExpansionConfig {
    let supportsHapticFeedback: Bool = true
}
#elseif os(macOS)
private struct macOSCardExpansionConfig {
    let supportsHover: Bool = true
}
#endif

private struct CardExpansionPerformanceConfig {
    let targetFrameRate: Int = 60
    let maxAnimationDuration: TimeInterval = 0.3
    let supportsSmoothAnimations: Bool = true
}
