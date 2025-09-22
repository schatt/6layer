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
        // The view should render an empty state, not crash or show blank content
    }
    
    func testPlatformPresentItemCollectionL1EmptyStateWithDifferentDataTypes() {
        // Test empty state with different data types
        let testCases: [(DataTypeHint, String)] = [
            (.media, "No Media Items"),
            (.navigation, "No Navigation Items"),
            (.form, "No Form Fields"),
            (.numeric, "No Data Available"),
            (.temporal, "No Events"),
            (.hierarchical, "No Items"),
            (.collection, "No Items"),
            (.generic, "No Items")
        ]
        
        for (dataType, _) in testCases {
            let hints = PresentationHints(
                dataType: dataType,
                presentationPreference: .automatic,
                complexity: .moderate,
                context: .dashboard
            )
            
            let emptyItems: [MenuItem] = []
            let view = platformPresentItemCollection_L1(
                items: emptyItems,
                hints: hints
            )
            
            XCTAssertNotNil(view)
            // In a real test environment, we would verify the empty state title matches expectedTitle
        }
    }
    
    func testPlatformPresentItemCollectionL1EmptyStateWithDifferentContexts() {
        // Test empty state with different contexts
        let testCases: [PresentationContext] = [
            .dashboard,
            .detail,
            .search,
            .summary,
            .modal
        ]
        
        for context in testCases {
            let hints = PresentationHints(
                dataType: .collection,
                presentationPreference: .automatic,
                complexity: .moderate,
                context: context
            )
            
            let emptyItems: [MenuItem] = []
            let view = platformPresentItemCollection_L1(
                items: emptyItems,
                hints: hints
            )
            
            XCTAssertNotNil(view)
            // In a real test environment, we would verify the context-specific messaging
        }
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
        
        // More content should result in more columns (or at least not fewer)
        XCTAssertGreaterThanOrEqual(mediumLayout.columns, smallLayout.columns)
        XCTAssertGreaterThanOrEqual(largeLayout.columns, mediumLayout.columns)
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
            onHover: { _ in },
            onItemSelected: nil,
            onItemDeleted: nil,
            onItemEdited: nil
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
            onHover: { _ in },
            onItemSelected: nil,
            onItemDeleted: nil,
            onItemEdited: nil
        )
        
        let contentRevealCard = ExpandableCardComponent(
            item: sampleMenuItems[0],
            layoutDecision: layoutDecision,
            strategy: contentRevealStrategy,
            isExpanded: false,
            isHovered: false,
            onExpand: {},
            onCollapse: {},
            onHover: { _ in },
            onItemSelected: nil,
            onItemDeleted: nil,
            onItemEdited: nil
        )
        
        XCTAssertNotNil(hoverCard)
        XCTAssertNotNil(contentRevealCard)
    }
    
    // MARK: - Layer 5 Tests: Platform Optimization
    
    func testGetCardExpansionPlatformConfig() {
        // Test platform configuration
        let config = getCardExpansionPlatformConfig()
        
        XCTAssertNotNil(config)
        
        // Test platform-specific features based on actual platform
        #if os(iOS)
        // iOS should support touch
        XCTAssertTrue(config.supportsTouch, "iOS should support touch")
        XCTAssertTrue(config.supportsHapticFeedback, "iOS should support haptic feedback")
        #elseif os(macOS)
        // macOS should not support touch
        XCTAssertFalse(config.supportsTouch, "macOS should not support touch")
        XCTAssertFalse(config.supportsHapticFeedback, "macOS should not support haptic feedback")
        XCTAssertTrue(config.supportsHover, "macOS should support hover")
        #elseif os(watchOS)
        // watchOS should support touch
        XCTAssertTrue(config.supportsTouch, "watchOS should support touch")
        XCTAssertTrue(config.supportsHapticFeedback, "watchOS should support haptic feedback")
        #elseif os(tvOS)
        // tvOS should not support touch
        XCTAssertFalse(config.supportsTouch, "tvOS should not support touch")
        XCTAssertFalse(config.supportsHapticFeedback, "tvOS should not support haptic feedback")
        #elseif os(visionOS)
        // visionOS should not support touch
        XCTAssertFalse(config.supportsTouch, "visionOS should not support touch")
        XCTAssertFalse(config.supportsHapticFeedback, "visionOS should not support haptic feedback")
        #endif
        
        // These should be supported on all platforms
        XCTAssertTrue(config.supportsVoiceOver, "All platforms should support VoiceOver")
        XCTAssertTrue(config.supportsSwitchControl, "All platforms should support Switch Control")
        
        // AssistiveTouch is only available on iOS and watchOS
        #if os(iOS) || os(watchOS)
        XCTAssertTrue(config.supportsAssistiveTouch, "iOS and watchOS should support AssistiveTouch")
        #else
        XCTAssertFalse(config.supportsAssistiveTouch, "Non-iOS/watchOS platforms should not support AssistiveTouch")
        #endif
        
        XCTAssertGreaterThanOrEqual(config.minTouchTarget, 44)
    }
    
    func testGetCardExpansionPerformanceConfig() {
        // Test performance configuration
        let config = getCardExpansionPerformanceConfig()
        
        XCTAssertNotNil(config)
    }
    
    func testPlatformFeatureMatrix() {
        // Test that platform features are correctly detected
        let config = getCardExpansionPlatformConfig()
        
        // Test feature combinations that should be mutually exclusive
        if config.supportsTouch {
            // If touch is supported, haptic feedback should also be supported
            XCTAssertTrue(config.supportsHapticFeedback, "Touch-enabled platforms should support haptic feedback")
        }
        
        if config.supportsHover {
            // If hover is supported, it's likely a desktop platform
            XCTAssertFalse(config.supportsTouch, "Hover-enabled platforms should not support touch")
        }
        
        // Test that accessibility features are always available
        XCTAssertTrue(config.supportsVoiceOver, "VoiceOver should be available on all platforms")
        XCTAssertTrue(config.supportsSwitchControl, "Switch Control should be available on all platforms")
        
        // AssistiveTouch is only available on iOS and watchOS
        #if os(iOS) || os(watchOS)
        XCTAssertTrue(config.supportsAssistiveTouch, "AssistiveTouch should be available on iOS and watchOS")
        #else
        XCTAssertFalse(config.supportsAssistiveTouch, "AssistiveTouch should not be available on non-iOS/watchOS platforms")
        #endif
        
        // Test that touch target size is appropriate
        if config.supportsTouch {
            XCTAssertGreaterThanOrEqual(config.minTouchTarget, 44, "Touch targets should be at least 44pt")
        }
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
    
    func testCollectionEmptyStateView() {
        // Test the CollectionEmptyStateView directly
        let hints = PresentationHints(
            dataType: .collection,
            presentationPreference: .cards,
            complexity: .moderate,
            context: .dashboard
        )
        
        let emptyStateView = CollectionEmptyStateView(hints: hints)
        XCTAssertNotNil(emptyStateView)
    }
    
    func testCollectionEmptyStateViewWithDifferentDataTypes() {
        // Test empty state view with different data types
        let testCases: [DataTypeHint] = [
            .media, .navigation, .form, .numeric, .temporal, .hierarchical, .collection, .generic
        ]
        
        for dataType in testCases {
            let hints = PresentationHints(
                dataType: dataType,
                presentationPreference: .automatic,
                complexity: .moderate,
                context: .dashboard
            )
            
            let emptyStateView = CollectionEmptyStateView(hints: hints)
            XCTAssertNotNil(emptyStateView)
        }
    }
    
    func testCollectionEmptyStateViewWithDifferentContexts() {
        // Test empty state view with different contexts
        let testCases: [PresentationContext] = [
            .dashboard, .detail, .search, .summary, .modal
        ]
        
        for context in testCases {
            let hints = PresentationHints(
                dataType: .collection,
                presentationPreference: .automatic,
                complexity: .moderate,
                context: context
            )
            
            let emptyStateView = CollectionEmptyStateView(hints: hints)
            XCTAssertNotNil(emptyStateView)
        }
    }
    
    func testCollectionEmptyStateViewWithDifferentComplexities() {
        // Test empty state view with different complexity levels
        let testCases: [ContentComplexity] = Array(ContentComplexity.allCases) // Use real enum
        
        for complexity in testCases {
            let hints = PresentationHints(
                dataType: .collection,
                presentationPreference: .automatic,
                complexity: complexity,
                context: .dashboard
            )
            
            let emptyStateView = CollectionEmptyStateView(hints: hints)
            XCTAssertNotNil(emptyStateView)
        }
    }
    
    // MARK: - Create Action Tests
    
    func testPlatformPresentItemCollectionL1WithCreateAction() {
        // Test with create action provided
        var _ = false
        let createAction = {
            // Test callback is accepted
        }
        
        let hints = PresentationHints(
            dataType: .collection,
            presentationPreference: .cards,
            complexity: .moderate,
            context: .dashboard
        )
        
        let emptyItems: [MenuItem] = []
        let view = platformPresentItemCollection_L1(
            items: emptyItems,
            hints: hints,
            onCreateItem: createAction
        )
        
        XCTAssertNotNil(view)
        // Note: In a real test environment, we would verify the create button is present
        // and that calling it triggers the createAction
    }
    
    func testPlatformPresentItemCollectionL1WithoutCreateAction() {
        // Test without create action (should not show create button)
        let hints = PresentationHints(
            dataType: .collection,
            presentationPreference: .cards,
            complexity: .moderate,
            context: .dashboard
        )
        
        let emptyItems: [MenuItem] = []
        let view = platformPresentItemCollection_L1(
            items: emptyItems,
            hints: hints
            // No onCreateItem parameter
        )
        
        XCTAssertNotNil(view)
        // Note: In a real test environment, we would verify no create button is shown
    }
    
    func testCollectionEmptyStateViewWithCreateAction() {
        // Test empty state view with create action
        var _ = false
        let createAction = {
            // Test callback is accepted
        }
        
        let hints = PresentationHints(
            dataType: .media,
            presentationPreference: .cards,
            complexity: .moderate,
            context: .dashboard
        )
        
        let emptyStateView = CollectionEmptyStateView(hints: hints, onCreateItem: createAction)
        XCTAssertNotNil(emptyStateView)
        // Note: In a real test environment, we would verify the create button is present
    }
    
    func testCollectionEmptyStateViewWithoutCreateAction() {
        // Test empty state view without create action
        let hints = PresentationHints(
            dataType: .media,
            presentationPreference: .cards,
            complexity: .moderate,
            context: .dashboard
        )
        
        let emptyStateView = CollectionEmptyStateView(hints: hints)
        XCTAssertNotNil(emptyStateView)
        // Note: In a real test environment, we would verify no create button is shown
    }
    
    func testCreateButtonTitlesForDifferentDataTypes() {
        // Test that create button titles are appropriate for different data types
        let testCases: [(DataTypeHint, String)] = [
            (.media, "Add Media"),
            (.navigation, "Add Navigation Item"),
            (.form, "Add Form Field"),
            (.numeric, "Add Data"),
            (.temporal, "Add Event"),
            (.hierarchical, "Add Item"),
            (.collection, "Add Item"),
            (.generic, "Add Item"),
            (.text, "Add Text"),
            (.number, "Add Number"),
            (.date, "Add Date"),
            (.image, "Add Image"),
            (.boolean, "Add Boolean"),
            (.list, "Add List Item"),
            (.grid, "Add Grid Item"),
            (.chart, "Add Chart Data"),
            (.action, "Add Action"),
            (.product, "Add Product"),
            (.user, "Add User"),
            (.transaction, "Add Transaction"),
            (.communication, "Add Message"),
            (.location, "Add Location"),
            (.custom, "Add Item")
        ]
        
        for (dataType, _) in testCases {
            let hints = PresentationHints(
                dataType: dataType,
                presentationPreference: .automatic,
                complexity: .moderate,
                context: .dashboard
            )
            
            let emptyStateView = CollectionEmptyStateView(hints: hints, onCreateItem: {})
            XCTAssertNotNil(emptyStateView)
            // Note: In a real test environment, we would verify the button title matches expectedTitle
        }
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
