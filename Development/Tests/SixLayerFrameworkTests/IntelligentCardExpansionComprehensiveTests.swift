//
//  IntelligentCardExpansionComprehensiveTests.swift
//  SixLayerFrameworkTests
//
//  Comprehensive tests for the Intelligent Card Expansion System
//

import XCTest
import SwiftUI
@testable import SixLayerFramework

/// Comprehensive tests for the Intelligent Card Expansion System
/// Tests all 6 layers with edge cases, performance, and integration scenarios
@MainActor
final class IntelligentCardExpansionComprehensiveTests: XCTestCase {
    
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
    
    func testPlatformPresentItemCollectionL1BasicFunctionality() {
        // Test basic Layer 1 functionality
        let view = platformPresentItemCollection_L1(
            items: sampleMenuItems,
            hints: expandableHints
        )
        
        XCTAssertNotNil(view)
    }
    
    func testPlatformPresentItemCollectionL1WithEmptyItems() {
        // Test with empty items array - use a concrete type
        let emptyHints = PresentationHints(
            dataType: .collection,
            presentationPreference: .cards,
            complexity: .simple,
            context: .dashboard
        )
        
        let emptyItems: [MenuItem] = []
        let view = platformPresentItemCollection_L1(
            items: emptyItems,
            hints: emptyHints
        )
        
        XCTAssertNotNil(view)
    }
    
    func testPlatformPresentItemCollectionL1WithDifferentDataTypes() {
        // Test with different data types
        let hints = PresentationHints(
            dataType: .form,
            presentationPreference: .cards,
            complexity: .complex,
            context: .dashboard
        )
        
        let view = platformPresentItemCollection_L1(
            items: sampleMenuItems,
            hints: hints
        )
        
        XCTAssertNotNil(view)
    }
    
    // MARK: - Layer 2 Tests: Layout Decision Engine
    
    func testDetermineIntelligentCardLayoutL2BasicFunctionality() {
        // Test basic layout determination
        let layout = determineIntelligentCardLayout_L2(
            contentCount: sampleMenuItems.count,
            screenWidth: 1024,
            deviceType: .pad,
            contentComplexity: .moderate
        )
        
        XCTAssertNotNil(layout)
        XCTAssertGreaterThan(layout.cardWidth, 0)
        XCTAssertGreaterThan(layout.cardHeight, 0)
        XCTAssertGreaterThan(layout.columns, 0)
    }
    
    func testDetermineIntelligentCardLayoutL2WithDifferentScreenSizes() {
        // Test with different screen sizes
        let mobileLayout = determineIntelligentCardLayout_L2(
            contentCount: sampleMenuItems.count,
            screenWidth: 375,
            deviceType: .phone,
            contentComplexity: .moderate
        )
        
        let tabletLayout = determineIntelligentCardLayout_L2(
            contentCount: sampleMenuItems.count,
            screenWidth: 768,
            deviceType: .pad,
            contentComplexity: .moderate
        )
        
        let desktopLayout = determineIntelligentCardLayout_L2(
            contentCount: sampleMenuItems.count,
            screenWidth: 1920,
            deviceType: .mac,
            contentComplexity: .moderate
        )
        
        // Desktop should have more columns than tablet, tablet more than mobile
        XCTAssertGreaterThan(desktopLayout.columns, tabletLayout.columns)
        XCTAssertGreaterThan(tabletLayout.columns, mobileLayout.columns)
    }
    
    func testDetermineIntelligentCardLayoutL2WithDifferentContentCounts() {
        // Test with different content counts
        let smallLayout = determineIntelligentCardLayout_L2(
            contentCount: 1,
            screenWidth: 1024,
            deviceType: .pad,
            contentComplexity: .moderate
        )
        
        let mediumLayout = determineIntelligentCardLayout_L2(
            contentCount: 10,
            screenWidth: 1024,
            deviceType: .pad,
            contentComplexity: .moderate
        )
        
        let largeLayout = determineIntelligentCardLayout_L2(
            contentCount: 100,
            screenWidth: 1024,
            deviceType: .pad,
            contentComplexity: .moderate
        )
        
        // More content should result in more columns
        XCTAssertGreaterThan(mediumLayout.columns, smallLayout.columns)
        XCTAssertGreaterThan(largeLayout.columns, mediumLayout.columns)
    }
    
    func testDetermineIntelligentCardLayoutL2WithDifferentComplexityLevels() {
        // Test with different complexity levels
        let simpleLayout = determineIntelligentCardLayout_L2(
            contentCount: sampleMenuItems.count,
            screenWidth: 1024,
            deviceType: .pad,
            contentComplexity: .simple
        )
        
        let complexLayout = determineIntelligentCardLayout_L2(
            contentCount: sampleMenuItems.count,
            screenWidth: 1024,
            deviceType: .pad,
            contentComplexity: .complex
        )
        
        // Complex content should result in larger cards
        XCTAssertGreaterThan(complexLayout.cardWidth, simpleLayout.cardWidth)
        XCTAssertGreaterThan(complexLayout.cardHeight, simpleLayout.cardHeight)
    }
    
    func testDetermineIntelligentCardLayoutL2EdgeCases() {
        // Test edge cases
        let zeroContentLayout = determineIntelligentCardLayout_L2(
            contentCount: 0,
            screenWidth: 1024,
            deviceType: .pad,
            contentComplexity: .moderate
        )
        
        let verySmallScreenLayout = determineIntelligentCardLayout_L2(
            contentCount: sampleMenuItems.count,
            screenWidth: 100,
            deviceType: .phone,
            contentComplexity: .moderate
        )
        
        XCTAssertNotNil(zeroContentLayout)
        XCTAssertNotNil(verySmallScreenLayout)
    }
    
    // MARK: - Layer 3 Tests: Strategy Selection
    
    func testSelectCardExpansionStrategyL3BasicFunctionality() {
        // Test basic strategy selection
        let strategy = selectCardExpansionStrategy_L3(
            contentCount: sampleMenuItems.count,
            screenWidth: 1024,
            deviceType: .pad,
            interactionStyle: .expandable,
            contentDensity: .balanced
        )
        
        XCTAssertNotNil(strategy)
        XCTAssertFalse(strategy.supportedStrategies.isEmpty)
    }
    
    func testSelectCardExpansionStrategyL3WithDifferentDeviceTypes() {
        // Test with different device types
        let phoneStrategy = selectCardExpansionStrategy_L3(
            contentCount: sampleMenuItems.count,
            screenWidth: 375,
            deviceType: .phone,
            interactionStyle: .expandable,
            contentDensity: .balanced
        )
        
        let tabletStrategy = selectCardExpansionStrategy_L3(
            contentCount: sampleMenuItems.count,
            screenWidth: 768,
            deviceType: .pad,
            interactionStyle: .expandable,
            contentDensity: .balanced
        )
        
        let desktopStrategy = selectCardExpansionStrategy_L3(
            contentCount: sampleMenuItems.count,
            screenWidth: 1920,
            deviceType: .mac,
            interactionStyle: .expandable,
            contentDensity: .balanced
        )
        
        XCTAssertNotNil(phoneStrategy)
        XCTAssertNotNil(tabletStrategy)
        XCTAssertNotNil(desktopStrategy)
    }
    
    func testSelectCardExpansionStrategyL3WithDifferentInteractionStyles() {
        // Test with different interaction styles
        let expandableStrategy = selectCardExpansionStrategy_L3(
            contentCount: sampleMenuItems.count,
            screenWidth: 1024,
            deviceType: .pad,
            interactionStyle: .expandable,
            contentDensity: .balanced
        )
        
        let staticStrategy = selectCardExpansionStrategy_L3(
            contentCount: sampleMenuItems.count,
            screenWidth: 1024,
            deviceType: .pad,
            interactionStyle: .static,
            contentDensity: .balanced
        )
        
        XCTAssertNotNil(expandableStrategy)
        XCTAssertNotNil(staticStrategy)
    }
    
    func testSelectCardExpansionStrategyL3WithDifferentContentDensities() {
        // Test with different content densities
        let denseStrategy = selectCardExpansionStrategy_L3(
            contentCount: sampleMenuItems.count,
            screenWidth: 1024,
            deviceType: .pad,
            interactionStyle: .expandable,
            contentDensity: .dense
        )
        
        let spaciousStrategy = selectCardExpansionStrategy_L3(
            contentCount: sampleMenuItems.count,
            screenWidth: 1024,
            deviceType: .pad,
            interactionStyle: .expandable,
            contentDensity: .spacious
        )
        
        XCTAssertNotNil(denseStrategy)
        XCTAssertNotNil(spaciousStrategy)
    }
    
    // MARK: - Layer 4 Tests: Component Implementation
    
    func testExpandableCardComponentBasicFunctionality() {
        // Test basic expandable card component
        let layoutDecision = IntelligentCardLayoutDecision(
            columns: 3,
            spacing: 16,
            cardWidth: 200,
            cardHeight: 150,
            padding: 16
        )
        
        let strategy = CardExpansionStrategy(
            supportedStrategies: [.hoverExpand],
            primaryStrategy: .hoverExpand,
            expansionScale: 1.15,
            animationDuration: 0.3
        )
        
        let card = ExpandableCardComponent(
            item: sampleMenuItems[0],
            layoutDecision: layoutDecision,
            strategy: strategy,
            isExpanded: false,
            isHovered: false,
            onExpand: {},
            onCollapse: {},
            onHover: { _ in }
        )
        
        XCTAssertNotNil(card)
    }
    
    func testExpandableCardComponentWithDifferentStrategies() {
        // Test with different expansion strategies
        let layoutDecision = IntelligentCardLayoutDecision(
            columns: 3,
            spacing: 16,
            cardWidth: 200,
            cardHeight: 150,
            padding: 16
        )
        
        let hoverStrategy = CardExpansionStrategy(
            supportedStrategies: [.hoverExpand],
            primaryStrategy: .hoverExpand,
            expansionScale: 1.15,
            animationDuration: 0.3
        )
        
        let contentRevealStrategy = CardExpansionStrategy(
            supportedStrategies: [.contentReveal],
            primaryStrategy: .contentReveal,
            expansionScale: 1.0,
            animationDuration: 0.3
        )
        
        let hoverCard = ExpandableCardComponent(
            item: sampleMenuItems[0],
            layoutDecision: layoutDecision,
            strategy: hoverStrategy,
            isExpanded: false,
            isHovered: false,
            onExpand: {},
            onCollapse: {},
            onHover: { _ in }
        )
        
        let contentRevealCard = ExpandableCardComponent(
            item: sampleMenuItems[0],
            layoutDecision: layoutDecision,
            strategy: contentRevealStrategy,
            isExpanded: false,
            isHovered: false,
            onExpand: {},
            onCollapse: {},
            onHover: { _ in }
        )
        
        XCTAssertNotNil(hoverCard)
        XCTAssertNotNil(contentRevealCard)
    }
    
    // MARK: - Layer 5 Tests: Platform Optimization
    
    func testGetCardExpansionPlatformConfig() {
        // Test platform configuration
        let config = getCardExpansionPlatformConfig()
        
        XCTAssertNotNil(config)
        XCTAssertTrue(config.supportsTouch)
        XCTAssertTrue(config.supportsVoiceOver)
        XCTAssertTrue(config.supportsSwitchControl)
        XCTAssertTrue(config.supportsAssistiveTouch)
        XCTAssertGreaterThanOrEqual(config.minTouchTarget, 44)
    }
    
    func testGetCardExpansionPerformanceConfig() {
        // Test performance configuration
        let config = getCardExpansionPerformanceConfig()
        
        XCTAssertNotNil(config)
    }
    
    // MARK: - Layer 6 Tests: Platform System
    
    func testNativeExpandableCardViewBasicFunctionality() {
        // Test basic native expandable card view
        let platformConfig = CardExpansionPlatformConfig()
        let performanceConfig = CardExpansionPerformanceConfig()
        let accessibilityConfig = CardExpansionAccessibilityConfig()
        
        let cardView = NativeExpandableCardView(
            item: sampleMenuItems[0],
            expansionStrategy: .hoverExpand,
            platformConfig: platformConfig,
            performanceConfig: performanceConfig,
            accessibilityConfig: accessibilityConfig
        )
        
        XCTAssertNotNil(cardView)
    }
    
    func testNativeExpandableCardViewWithDifferentStrategies() {
        // Test with different expansion strategies
        let platformConfig = CardExpansionPlatformConfig()
        let performanceConfig = CardExpansionPerformanceConfig()
        let accessibilityConfig = CardExpansionAccessibilityConfig()
        
        let hoverCardView = NativeExpandableCardView(
            item: sampleMenuItems[0],
            expansionStrategy: .hoverExpand,
            platformConfig: platformConfig,
            performanceConfig: performanceConfig,
            accessibilityConfig: accessibilityConfig
        )
        
        let contentRevealCardView = NativeExpandableCardView(
            item: sampleMenuItems[0],
            expansionStrategy: .contentReveal,
            platformConfig: platformConfig,
            performanceConfig: performanceConfig,
            accessibilityConfig: accessibilityConfig
        )
        
        let gridReorganizeCardView = NativeExpandableCardView(
            item: sampleMenuItems[0],
            expansionStrategy: .gridReorganize,
            platformConfig: platformConfig,
            performanceConfig: performanceConfig,
            accessibilityConfig: accessibilityConfig
        )
        
        let focusModeCardView = NativeExpandableCardView(
            item: sampleMenuItems[0],
            expansionStrategy: .focusMode,
            platformConfig: platformConfig,
            performanceConfig: performanceConfig,
            accessibilityConfig: accessibilityConfig
        )
        
        XCTAssertNotNil(hoverCardView)
        XCTAssertNotNil(contentRevealCardView)
        XCTAssertNotNil(gridReorganizeCardView)
        XCTAssertNotNil(focusModeCardView)
    }
    
    // MARK: - Integration Tests
    
    func testEndToEndCardExpansionWorkflow() {
        // Test complete end-to-end workflow
        let view = platformPresentItemCollection_L1(
            items: sampleMenuItems,
            hints: expandableHints
        )
        
        XCTAssertNotNil(view)
        
        // Test Layer 2
        let layoutDecision = determineIntelligentCardLayout_L2(
            contentCount: sampleMenuItems.count,
            screenWidth: 1024,
            deviceType: .pad,
            contentComplexity: .moderate
        )
        
        XCTAssertNotNil(layoutDecision)
        
        // Test Layer 3
        let strategy = selectCardExpansionStrategy_L3(
            contentCount: sampleMenuItems.count,
            screenWidth: 1024,
            deviceType: .pad,
            interactionStyle: .expandable,
            contentDensity: .balanced
        )
        
        XCTAssertNotNil(strategy)
        
        // Test Layer 5
        let platformConfig = getCardExpansionPlatformConfig()
        let performanceConfig = getCardExpansionPerformanceConfig()
        
        XCTAssertNotNil(platformConfig)
        XCTAssertNotNil(performanceConfig)
        
        // Test Layer 6
        let accessibilityConfig = CardExpansionAccessibilityConfig()
        let platformView = NativeExpandableCardView(
            item: sampleMenuItems[0],
            expansionStrategy: .hoverExpand,
            platformConfig: platformConfig,
            performanceConfig: performanceConfig,
            accessibilityConfig: accessibilityConfig
        )
        
        XCTAssertNotNil(platformView)
    }
    
    func testCrossLayerDataFlow() {
        // Test that data flows correctly between layers
        let hints = expandableHints
        
        // Layer 1 -> Layer 2
        let layoutDecision = determineIntelligentCardLayout_L2(
            contentCount: sampleMenuItems.count,
            screenWidth: 1024,
            deviceType: .pad,
            contentComplexity: hints.complexity
        )
        
        XCTAssertNotNil(layoutDecision)
        
        // Layer 2 -> Layer 3
        let strategy = selectCardExpansionStrategy_L3(
            contentCount: sampleMenuItems.count,
            screenWidth: 1024,
            deviceType: .pad,
            interactionStyle: .expandable,
            contentDensity: .balanced
        )
        
        XCTAssertNotNil(strategy)
    }
    
    // MARK: - Performance Tests
    
    func testCardExpansionPerformance() {
        // Test performance with large dataset
        let largeDataSet = (1...1000).map { index in
            MenuItem(
                id: "\(index)",
                title: "Item \(index)",
                icon: "star",
                color: .blue
            )
        }
        
        measure {
            let view = platformPresentItemCollection_L1(
                items: largeDataSet,
                hints: expandableHints
            )
            
            XCTAssertNotNil(view)
        }
    }
    
    func testLayoutDecisionPerformance() {
        // Test layout decision performance
        measure {
            for _ in 0..<100 {
                let layout = determineIntelligentCardLayout_L2(
                    contentCount: sampleMenuItems.count,
                    screenWidth: 1024,
                    deviceType: .pad,
                    contentComplexity: .moderate
                )
                
                XCTAssertNotNil(layout)
            }
        }
    }
    
    func testStrategySelectionPerformance() {
        // Test strategy selection performance
        measure {
            for _ in 0..<100 {
                let strategy = selectCardExpansionStrategy_L3(
                    contentCount: sampleMenuItems.count,
                    screenWidth: 1024,
                    deviceType: .pad,
                    interactionStyle: .expandable,
                    contentDensity: .balanced
                )
                
                XCTAssertNotNil(strategy)
            }
        }
    }
    
    // MARK: - Error Handling Tests
    
    func testErrorHandlingWithInvalidData() {
        // Test error handling with invalid data
        let invalidHints = PresentationHints(
            dataType: .collection,
            presentationPreference: .cards,
            complexity: .moderate,
            context: .dashboard
        )
        
        let view = platformPresentItemCollection_L1(
            items: sampleMenuItems,
            hints: invalidHints
        )
        
        XCTAssertNotNil(view)
    }
    
    func testErrorHandlingWithExtremeValues() {
        // Test error handling with extreme values
        let extremeLayout = determineIntelligentCardLayout_L2(
            contentCount: Int.max,
            screenWidth: 0,
            deviceType: .phone,
            contentComplexity: .complex
        )
        
        XCTAssertNotNil(extremeLayout)
    }
    
    // MARK: - Accessibility Tests
    
    func testAccessibilitySupport() {
        // Test accessibility support
        let platformConfig = CardExpansionPlatformConfig()
        let performanceConfig = CardExpansionPerformanceConfig()
        let accessibilityConfig = CardExpansionAccessibilityConfig()
        
        let cardView = NativeExpandableCardView(
            item: sampleMenuItems[0],
            expansionStrategy: .hoverExpand,
            platformConfig: platformConfig,
            performanceConfig: performanceConfig,
            accessibilityConfig: accessibilityConfig
        )
        
        XCTAssertNotNil(cardView)
        
        // Test that accessibility features are properly configured
        XCTAssertTrue(platformConfig.supportsVoiceOver)
        XCTAssertTrue(platformConfig.supportsSwitchControl)
        XCTAssertTrue(platformConfig.supportsAssistiveTouch)
    }
    
    // MARK: - Edge Case Tests
    
    func testEdgeCaseEmptyItems() {
        // Test with empty items - use a concrete type
        let emptyItems: [MenuItem] = []
        let view = platformPresentItemCollection_L1(
            items: emptyItems,
            hints: expandableHints
        )
        
        XCTAssertNotNil(view)
    }
    
    func testEdgeCaseSingleItem() {
        // Test with single item
        let singleItem = [sampleMenuItems[0]]
        let view = platformPresentItemCollection_L1(
            items: singleItem,
            hints: expandableHints
        )
        
        XCTAssertNotNil(view)
    }
    
    func testEdgeCaseVeryLargeDataset() {
        // Test with very large dataset
        let veryLargeDataSet = (1...1000).map { index in
            MenuItem(
                id: "\(index)",
                title: "Item \(index)",
                icon: "star",
                color: .blue
            )
        }
        
        let view = platformPresentItemCollection_L1(
            items: veryLargeDataSet,
            hints: expandableHints
        )
        
        XCTAssertNotNil(view)
    }
    
    func testEdgeCaseVerySmallScreen() {
        // Test with very small screen
        let layout = determineIntelligentCardLayout_L2(
            contentCount: sampleMenuItems.count,
            screenWidth: 50,
            deviceType: .phone,
            contentComplexity: .moderate
        )
        
        XCTAssertNotNil(layout)
    }
    
    func testEdgeCaseVeryLargeScreen() {
        // Test with very large screen
        let layout = determineIntelligentCardLayout_L2(
            contentCount: sampleMenuItems.count,
            screenWidth: 10000,
            deviceType: .mac,
            contentComplexity: .moderate
        )
        
        XCTAssertNotNil(layout)
    }
    
    // MARK: - Enum Tests
    
    func testExpansionStrategyEnum() {
        // Test ExpansionStrategy enum
        XCTAssertEqual(ExpansionStrategy.hoverExpand.rawValue, "hoverExpand")
        XCTAssertEqual(ExpansionStrategy.contentReveal.rawValue, "contentReveal")
        XCTAssertEqual(ExpansionStrategy.gridReorganize.rawValue, "gridReorganize")
        XCTAssertEqual(ExpansionStrategy.focusMode.rawValue, "focusMode")
        XCTAssertEqual(ExpansionStrategy.none.rawValue, "none")
        
        // Test all cases
        let allCases = ExpansionStrategy.allCases
        XCTAssertEqual(allCases.count, 5)
    }
    
    func testInteractionStyleEnum() {
        // Test InteractionStyle enum
        XCTAssertEqual(InteractionStyle.expandable.rawValue, "expandable")
        XCTAssertEqual(InteractionStyle.static.rawValue, "static")
        XCTAssertEqual(InteractionStyle.interactive.rawValue, "interactive")
        
        // Test all cases
        let allCases = InteractionStyle.allCases
        XCTAssertEqual(allCases.count, 3)
    }
    
    func testContentDensityEnum() {
        // Test ContentDensity enum
        XCTAssertEqual(ContentDensity.dense.rawValue, "dense")
        XCTAssertEqual(ContentDensity.balanced.rawValue, "balanced")
        XCTAssertEqual(ContentDensity.spacious.rawValue, "spacious")
        
        // Test all cases
        let allCases = ContentDensity.allCases
        XCTAssertEqual(allCases.count, 3)
    }
}

// MARK: - Test Helper Types

private struct MenuItem: Identifiable {
    let id: String
    let title: String
    let icon: String
    let color: Color
}
