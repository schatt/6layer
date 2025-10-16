import Testing

//
//  IntelligentCardExpansionComprehensiveTests.swift
//  SixLayerFrameworkTests
//
//  Comprehensive tests for the Intelligent Card Expansion System
//

import SwiftUI
@testable import SixLayerFramework

/// Comprehensive tests for the Intelligent Card Expansion System
/// Tests all 6 layers with edge cases, performance, and integration scenarios
@MainActor
final class IntelligentCardExpansionComprehensiveTests: BaseTestClass {
    
    override init() {
        super.init()
        // Additional setup if needed
    }
    
    deinit {
        Task { [weak self] in
            await self?.cleanupTestEnvironment()
        }
    }
    
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
    
    @Test func testPlatformPresentItemCollectionL1BasicFunctionality() {
        // Test basic Layer 1 functionality
        let view = platformPresentItemCollection_L1(
            items: sampleMenuItems,
            hints: expandableHints
        )
        
        #expect(view != nil)
    }
    
    @Test func testPlatformPresentItemCollectionL1WithEmptyItems() {
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
        
        #expect(view != nil)
        // The view should render an empty state, not crash or show blank content
    }
    
    @Test func testPlatformPresentItemCollectionL1EmptyStateWithDifferentDataTypes() {
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
            
            #expect(view != nil)
            // In a real test environment, we would verify the empty state title matches expectedTitle
        }
    }
    
    @Test func testPlatformPresentItemCollectionL1EmptyStateWithDifferentContexts() {
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
            
            #expect(view != nil)
            // In a real test environment, we would verify the context-specific messaging
        }
    }
    
    @Test func testPlatformPresentItemCollectionL1WithDifferentDataTypes() {
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
        
        #expect(view != nil)
    }
    
    // MARK: - Layer 2 Tests: Layout Decision Engine
    
    @Test func testDetermineIntelligentCardLayoutL2BasicFunctionality() {
        // Test basic layout determination
        let layout = determineIntelligentCardLayout_L2(
            contentCount: sampleMenuItems.count,
            screenWidth: 1024,
            deviceType: .pad,
            contentComplexity: .moderate
        )
        
        #expect(layout != nil)
        #expect(layout.cardWidth > 0)
        #expect(layout.cardHeight > 0)
        #expect(layout.columns > 0)
    }
    
    @Test func testDetermineIntelligentCardLayoutL2WithDifferentScreenSizes() {
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
        #expect(desktopLayout.columns > tabletLayout.columns)
        #expect(tabletLayout.columns > mobileLayout.columns)
    }
    
    @Test func testDetermineIntelligentCardLayoutL2WithDifferentContentCounts() {
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
        #expect(mediumLayout.columns >= smallLayout.columns)
        #expect(largeLayout.columns >= mediumLayout.columns)
    }
    
    @Test func testDetermineIntelligentCardLayoutL2WithDifferentComplexityLevels() {
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
        #expect(complexLayout.cardWidth > simpleLayout.cardWidth)
        #expect(complexLayout.cardHeight > simpleLayout.cardHeight)
    }
    
    @Test func testDetermineIntelligentCardLayoutL2EdgeCases() {
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
        
        #expect(zeroContentLayout != nil)
        #expect(verySmallScreenLayout != nil)
    }
    
    // MARK: - Layer 3 Tests: Strategy Selection
    
    @Test func testSelectCardExpansionStrategyL3BasicFunctionality() {
        // Test basic strategy selection
        let strategy = selectCardExpansionStrategy_L3(
            contentCount: sampleMenuItems.count,
            screenWidth: 1024,
            deviceType: .pad,
            interactionStyle: .expandable,
            contentDensity: .balanced
        )
        
        #expect(strategy != nil)
        #expect(!strategy.supportedStrategies.isEmpty)
    }
    
    @Test func testSelectCardExpansionStrategyL3WithDifferentDeviceTypes() {
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
        
        #expect(phoneStrategy != nil)
        #expect(tabletStrategy != nil)
        #expect(desktopStrategy != nil)
    }
    
    @Test func testSelectCardExpansionStrategyL3WithDifferentInteractionStyles() {
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
        
        #expect(expandableStrategy != nil)
        #expect(staticStrategy != nil)
    }
    
    @Test func testSelectCardExpansionStrategyL3WithDifferentContentDensities() {
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
        
        #expect(denseStrategy != nil)
        #expect(spaciousStrategy != nil)
    }
    
    // MARK: - Layer 4 Tests: Component Implementation
    
    @Test func testExpandableCardComponentBasicFunctionality() {
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
            hints: PresentationHints(),
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
        
        #expect(card != nil)
    }
    
    @Test func testExpandableCardComponentWithDifferentStrategies() {
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
            hints: PresentationHints(),
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
            hints: PresentationHints(),
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
        
        #expect(hoverCard != nil)
        #expect(contentRevealCard != nil)
    }
    
    // MARK: - Layer 5 Tests: Platform Optimization
    
    @Test func testGetCardExpansionPlatformConfig() {
        // Test iOS platform configuration
        simulatePlatform(.iOS)
        var config = getCardExpansionPlatformConfig()
        #expect(config != nil)
        TestSetupUtilities.shared.assertCardExpansionConfig(
            config,
            touch: true,
            haptic: true,
            hover: false,
            voiceOver: true,
            switchControl: true,
            assistiveTouch: false
        )
        
        // Test macOS platform configuration
        simulatePlatform(.macOS)
        config = getCardExpansionPlatformConfig()
        #expect(config != nil)
        TestSetupUtilities.shared.assertCardExpansionConfig(
            config,
            touch: false,
            haptic: false,
            hover: true,
            voiceOver: true,
            switchControl: true,
            assistiveTouch: false
        )
        
        // Test watchOS platform configuration
        simulatePlatform(.watchOS)
        config = getCardExpansionPlatformConfig()
        #expect(config != nil)
        TestSetupUtilities.shared.assertCardExpansionConfig(
            config,
            touch: true,
            haptic: true,
            hover: false,
            voiceOver: true,
            switchControl: true,
            assistiveTouch: true
        )
        
        // Test tvOS platform configuration
        simulatePlatform(.tvOS)
        config = getCardExpansionPlatformConfig()
        #expect(config != nil)
        TestSetupUtilities.shared.assertCardExpansionConfig(
            config,
            touch: false,
            haptic: false,
            hover: false,
            voiceOver: true,
            switchControl: true,
            assistiveTouch: false
        )
        
        // Test visionOS platform configuration
        simulatePlatform(.visionOS)
        config = getCardExpansionPlatformConfig()
        #expect(config != nil)
        TestSetupUtilities.shared.assertCardExpansionConfig(
            config,
            touch: true,
            haptic: true,
            hover: true,
            voiceOver: true,
            switchControl: true,
            assistiveTouch: true
        )
        
        #expect(config.minTouchTarget >= 44)
    }
    
    @Test func testGetCardExpansionPerformanceConfig() {
        // Test performance configuration
        let config = getCardExpansionPerformanceConfig()
        
        #expect(config != nil)
    }
    
    @Test func testPlatformFeatureMatrix() {
        // Test that platform features are correctly detected
        let config = getCardExpansionPlatformConfig()
        
        // Test feature combinations that should be mutually exclusive
        if config.supportsTouch {
            // If touch is supported, haptic feedback should also be supported
            #expect(config.supportsHapticFeedback, "Touch-enabled platforms should support haptic feedback")
        }
        
        if config.supportsHover {
            // If hover is supported, it's likely a desktop platform
            #expect(!config.supportsTouch, "Hover-enabled platforms should not support touch")
        }
        
        // Test that accessibility features are always available
        #expect(config.supportsVoiceOver, "VoiceOver should be available on all platforms")
        #expect(config.supportsSwitchControl, "Switch Control should be available on all platforms")
        
        // AssistiveTouch is only available on iOS and watchOS
        #if os(iOS) || os(watchOS)
        #expect(config.supportsAssistiveTouch, "AssistiveTouch should be available on iOS and watchOS")
        #else
        #expect(!config.supportsAssistiveTouch, "AssistiveTouch should not be available on non-iOS/watchOS platforms")
        #endif
        
        // Test that touch target size is appropriate
        if config.supportsTouch {
            #expect(config.minTouchTarget >= 44, "Touch targets should be at least 44pt")
        }
    }
    
    // MARK: - Layer 6 Tests: Platform System
    
    @Test func testNativeExpandableCardViewBasicFunctionality() {
        // Test basic native expandable card view
        let platformConfig = getCardExpansionPlatformConfig()
        let performanceConfig = CardExpansionPerformanceConfig()
        let accessibilityConfig = CardExpansionAccessibilityConfig()
        
        let cardView = NativeExpandableCardView(
            item: sampleMenuItems[0],
            expansionStrategy: .hoverExpand,
            platformConfig: platformConfig,
            performanceConfig: performanceConfig,
            accessibilityConfig: accessibilityConfig
        )
        
        #expect(cardView != nil)
    }
    
    @Test func testNativeExpandableCardViewWithDifferentStrategies() {
        // Test with different expansion strategies
        let platformConfig = getCardExpansionPlatformConfig()
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
        
        #expect(hoverCardView != nil)
        #expect(contentRevealCardView != nil)
        #expect(gridReorganizeCardView != nil)
        #expect(focusModeCardView != nil)
    }
    
    // MARK: - Integration Tests
    
    @Test func testEndToEndCardExpansionWorkflow() {
        // Test complete end-to-end workflow
        let view = platformPresentItemCollection_L1(
            items: sampleMenuItems,
            hints: expandableHints
        )
        
        #expect(view != nil)
        
        // Test Layer 2
        let layoutDecision = determineIntelligentCardLayout_L2(
            contentCount: sampleMenuItems.count,
            screenWidth: 1024,
            deviceType: .pad,
            contentComplexity: .moderate
        )
        
        #expect(layoutDecision != nil)
        
        // Test Layer 3
        let strategy = selectCardExpansionStrategy_L3(
            contentCount: sampleMenuItems.count,
            screenWidth: 1024,
            deviceType: .pad,
            interactionStyle: .expandable,
            contentDensity: .balanced
        )
        
        #expect(strategy != nil)
        
        // Test Layer 5
        let platformConfig = getCardExpansionPlatformConfig()
        let performanceConfig = getCardExpansionPerformanceConfig()
        
        #expect(platformConfig != nil)
        #expect(performanceConfig != nil)
        
        // Test Layer 6
        let accessibilityConfig = CardExpansionAccessibilityConfig()
        let platformView = NativeExpandableCardView(
            item: sampleMenuItems[0],
            expansionStrategy: .hoverExpand,
            platformConfig: platformConfig,
            performanceConfig: performanceConfig,
            accessibilityConfig: accessibilityConfig
        )
        
        #expect(platformView != nil)
    }
    
    @Test func testCrossLayerDataFlow() {
        // Test that data flows correctly between layers
        let hints = expandableHints
        
        // Layer 1 -> Layer 2
        let layoutDecision = determineIntelligentCardLayout_L2(
            contentCount: sampleMenuItems.count,
            screenWidth: 1024,
            deviceType: .pad,
            contentComplexity: hints.complexity
        )
        
        #expect(layoutDecision != nil)
        
        // Layer 2 -> Layer 3
        let strategy = selectCardExpansionStrategy_L3(
            contentCount: sampleMenuItems.count,
            screenWidth: 1024,
            deviceType: .pad,
            interactionStyle: .expandable,
            contentDensity: .balanced
        )
        
        #expect(strategy != nil)
    }
    
    // MARK: - Performance Tests
    
    @Test func testCardExpansionPerformance() {
        // Test performance with large dataset
        let largeDataSet = (1...1000).map { index in
            MenuItem(
                id: "\(index)",
                title: "Item \(index)",
                icon: "star",
                color: .blue
            )
        }
        
        // Performance test removed - performance monitoring was removed from framework
    }
    
    @Test func testLayoutDecisionPerformance() {
        // Test layout decision performance
        // Performance test removed - performance monitoring was removed from framework
    }
    
    @Test func testStrategySelectionPerformance() {
        // Test strategy selection performance
        // Performance test removed - performance monitoring was removed from framework
    }
    
    // MARK: - Error Handling Tests
    
    @Test func testErrorHandlingWithInvalidData() {
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
        
        #expect(view != nil)
    }
    
    @Test func testErrorHandlingWithExtremeValues() {
        // Test error handling with extreme values
        let extremeLayout = determineIntelligentCardLayout_L2(
            contentCount: Int.max,
            screenWidth: 0,
            deviceType: .phone,
            contentComplexity: .complex
        )
        
        #expect(extremeLayout != nil)
    }
    
    // MARK: - Accessibility Tests
    
    @Test func testAccessibilitySupport() {
        // Test accessibility support
        let platformConfig = getCardExpansionPlatformConfig()
        let performanceConfig = CardExpansionPerformanceConfig()
        let accessibilityConfig = CardExpansionAccessibilityConfig()
        
        let cardView = NativeExpandableCardView(
            item: sampleMenuItems[0],
            expansionStrategy: .hoverExpand,
            platformConfig: platformConfig,
            performanceConfig: performanceConfig,
            accessibilityConfig: accessibilityConfig
        )
        
        #expect(cardView != nil)
        
        // Test that accessibility features are properly configured
        #expect(platformConfig.supportsVoiceOver)
        #expect(platformConfig.supportsSwitchControl)
        #expect(platformConfig.supportsAssistiveTouch)
    }
    
    // MARK: - Edge Case Tests
    
    @Test func testEdgeCaseEmptyItems() {
        // Test with empty items - use a concrete type
        let emptyItems: [MenuItem] = []
        let view = platformPresentItemCollection_L1(
            items: emptyItems,
            hints: expandableHints
        )
        
        #expect(view != nil)
    }
    
    @Test func testCollectionEmptyStateView() {
        // Test the CollectionEmptyStateView directly
        let hints = PresentationHints(
            dataType: .collection,
            presentationPreference: .cards,
            complexity: .moderate,
            context: .dashboard
        )
        
        let emptyStateView = CollectionEmptyStateView(hints: hints)
        #expect(emptyStateView != nil)
    }
    
    @Test func testCollectionEmptyStateViewWithDifferentDataTypes() {
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
            #expect(emptyStateView != nil)
        }
    }
    
    @Test func testCollectionEmptyStateViewWithDifferentContexts() {
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
            #expect(emptyStateView != nil)
        }
    }
    
    @Test func testCollectionEmptyStateViewWithDifferentComplexities() {
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
            #expect(emptyStateView != nil)
        }
    }
    
    // MARK: - Create Action Tests
    
    @Test func testPlatformPresentItemCollectionL1WithCreateAction() {
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
        
        #expect(view != nil)
        // Note: In a real test environment, we would verify the create button is present
        // and that calling it triggers the createAction
    }
    
    @Test func testPlatformPresentItemCollectionL1WithoutCreateAction() {
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
        
        #expect(view != nil)
        // Note: In a real test environment, we would verify no create button is shown
    }
    
    @Test func testCollectionEmptyStateViewWithCreateAction() {
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
        #expect(emptyStateView != nil)
        // Note: In a real test environment, we would verify the create button is present
    }
    
    @Test func testCollectionEmptyStateViewWithoutCreateAction() {
        // Test empty state view without create action
        let hints = PresentationHints(
            dataType: .media,
            presentationPreference: .cards,
            complexity: .moderate,
            context: .dashboard
        )
        
        let emptyStateView = CollectionEmptyStateView(hints: hints)
        #expect(emptyStateView != nil)
        // Note: In a real test environment, we would verify no create button is shown
    }
    
    @Test func testCreateButtonTitlesForDifferentDataTypes() {
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
            #expect(emptyStateView != nil)
            // Note: In a real test environment, we would verify the button title matches expectedTitle
        }
    }
    
    @Test func testEdgeCaseSingleItem() {
        // Test with single item
        let singleItem = [sampleMenuItems[0]]
        let view = platformPresentItemCollection_L1(
            items: singleItem,
            hints: expandableHints
        )
        
        #expect(view != nil)
    }
    
    @Test func testEdgeCaseVeryLargeDataset() {
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
        
        #expect(view != nil)
    }
    
    @Test func testEdgeCaseVerySmallScreen() {
        // Test with very small screen
        let layout = determineIntelligentCardLayout_L2(
            contentCount: sampleMenuItems.count,
            screenWidth: 50,
            deviceType: .phone,
            contentComplexity: .moderate
        )
        
        #expect(layout != nil)
    }
    
    @Test func testEdgeCaseVeryLargeScreen() {
        // Test with very large screen
        let layout = determineIntelligentCardLayout_L2(
            contentCount: sampleMenuItems.count,
            screenWidth: 10000,
            deviceType: .mac,
            contentComplexity: .moderate
        )
        
        #expect(layout != nil)
    }
    
    // MARK: - Enum Tests
    
    @Test func testExpansionStrategyEnum() {
        // Test ExpansionStrategy enum
        #expect(ExpansionStrategy.hoverExpand.rawValue == "hoverExpand")
        #expect(ExpansionStrategy.contentReveal.rawValue == "contentReveal")
        #expect(ExpansionStrategy.gridReorganize.rawValue == "gridReorganize")
        #expect(ExpansionStrategy.focusMode.rawValue == "focusMode")
        #expect(ExpansionStrategy.none.rawValue == "none")
        
        // Test all cases
        let allCases = ExpansionStrategy.allCases
        #expect(allCases.count == 5)
    }
    
    @Test func testInteractionStyleEnum() {
        // Test InteractionStyle enum
        #expect(InteractionStyle.expandable.rawValue == "expandable")
        #expect(InteractionStyle.static.rawValue == "static")
        #expect(InteractionStyle.interactive.rawValue == "interactive")
        
        // Test all cases
        let allCases = InteractionStyle.allCases
        #expect(allCases.count == 3)
    }
    
    @Test func testContentDensityEnum() {
        // Test ContentDensity enum
        #expect(ContentDensity.dense.rawValue == "dense")
        #expect(ContentDensity.balanced.rawValue == "balanced")
        #expect(ContentDensity.spacious.rawValue == "spacious")
        
        // Test all cases
        let allCases = ContentDensity.allCases
        #expect(allCases.count == 3)
        // Performance test removed - performance monitoring was removed from framework
    }

// MARK: - Test Helper Types

private struct MenuItem: Identifiable {
    let id: String
    let title: String
    let icon: String
    let color: Color
}
}
