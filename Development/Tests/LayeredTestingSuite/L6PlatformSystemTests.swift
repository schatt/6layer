//
//  L6PlatformSystemTests.swift
//  SixLayerFramework
//
//  Layer 6 Testing: Platform System Functions
//  Tests L6 functions that are direct platform system calls and native implementations
//

import XCTest
import SwiftUI
@testable import SixLayerFramework

class L6PlatformSystemTests: XCTestCase {
    
    // MARK: - Test Data
    
    private var samplePlatform: Platform = .iOS
    private var samplePlatformOptimizationSettings: PlatformOptimizationSettings = PlatformOptimizationSettings(for: .iOS)
    private var sampleCrossPlatformPerformanceMetrics: CrossPlatformPerformanceMetrics = CrossPlatformPerformanceMetrics()
    private var samplePlatformUIPatterns: PlatformUIPatterns = PlatformUIPatterns(for: .iOS)
    private var samplePlatformRecommendation: PlatformRecommendation = PlatformRecommendation(
        title: "Test Recommendation",
        description: "Test Description",
        category: .performance,
        priority: .medium,
        platform: .iOS
    )
    private var sampleRecommendationCategory: RecommendationCategory = .performance
    private var samplePerformanceLevel: PerformanceLevel = .balanced
    private var sampleMemoryStrategy: MemoryStrategy = .adaptive
    private var sampleRenderingOptimizations: RenderingOptimizations = RenderingOptimizations(for: .iOS)
    private var sampleNavigationPatterns: NavigationPatterns = NavigationPatterns(for: .iOS)
    private var sampleInteractionPatterns: InteractionPatterns = InteractionPatterns(for: .iOS)
    private var sampleLayoutPatterns: LayoutPatterns = LayoutPatterns(for: .iOS)
    
    override func setUp() {
        super.setUp()
        samplePlatform = L6TestDataFactory.createSamplePlatform()
        samplePlatformOptimizationSettings = L6TestDataFactory.createSamplePlatformOptimizationSettings()
        sampleCrossPlatformPerformanceMetrics = L6TestDataFactory.createSampleCrossPlatformPerformanceMetrics()
        samplePlatformUIPatterns = L6TestDataFactory.createSamplePlatformUIPatterns()
        samplePlatformRecommendation = L6TestDataFactory.createSamplePlatformRecommendation()
        sampleRecommendationCategory = L6TestDataFactory.createSampleRecommendationCategory()
        samplePerformanceLevel = L6TestDataFactory.createSamplePerformanceLevel()
        sampleMemoryStrategy = L6TestDataFactory.createSampleMemoryStrategy()
        sampleRenderingOptimizations = L6TestDataFactory.createSampleRenderingOptimizations()
        sampleNavigationPatterns = L6TestDataFactory.createSampleNavigationPatterns()
        sampleInteractionPatterns = L6TestDataFactory.createSampleInteractionPatterns()
        sampleLayoutPatterns = L6TestDataFactory.createSampleLayoutPatterns()
    }
    
    override func tearDown() {
        samplePlatform = .iOS
        samplePlatformOptimizationSettings = PlatformOptimizationSettings(for: .iOS)
        sampleCrossPlatformPerformanceMetrics = CrossPlatformPerformanceMetrics()
        samplePlatformUIPatterns = PlatformUIPatterns(for: .iOS)
        samplePlatformRecommendation = PlatformRecommendation(
            title: "Test Recommendation",
            description: "Test Description",
            category: .performance,
            priority: .medium,
            platform: .iOS
        )
        sampleRecommendationCategory = .performance
        samplePerformanceLevel = .balanced
        sampleMemoryStrategy = .adaptive
        sampleRenderingOptimizations = RenderingOptimizations(for: .iOS)
        sampleNavigationPatterns = NavigationPatterns(for: .iOS)
        sampleInteractionPatterns = InteractionPatterns(for: .iOS)
        sampleLayoutPatterns = LayoutPatterns(for: .iOS)
        super.tearDown()
    }
    
    // MARK: - Cross-Platform Optimization Manager Tests
    
    func testCrossPlatformOptimizationManager() {
        // Given
        let platform = samplePlatform
        
        // When
        let manager = CrossPlatformOptimizationManager(platform: platform)
        
        // Then
        XCTAssertEqual(manager.currentPlatform, platform, "Should have correct platform")
        XCTAssertNotNil(manager.optimizationSettings, "Should have optimization settings")
        XCTAssertNotNil(manager.performanceMetrics, "Should have performance metrics")
        XCTAssertNotNil(manager.uiPatterns, "Should have UI patterns")
    }
    
    func testCrossPlatformOptimizationManagerOptimizeView() {
        // Given
        let manager = CrossPlatformOptimizationManager(platform: samplePlatform)
        let testView = Text("Test View")
        
        // When
        let optimizedView = manager.optimizeView(testView)
        
        // Then
        LayeredTestUtilities.verifyViewCreation(optimizedView, testName: "CrossPlatformOptimizationManager.optimizeView")
    }
    
    func testCrossPlatformOptimizationManagerGetPlatformRecommendations() {
        // Given
        let manager = CrossPlatformOptimizationManager(platform: samplePlatform)
        
        // When
        let recommendations = manager.getPlatformRecommendations()
        
        // Then
        XCTAssertNotNil(recommendations, "Should return recommendations")
        XCTAssertTrue(recommendations is [PlatformRecommendation], "Should return array of recommendations")
    }
    
    // MARK: - Platform Optimization Settings Tests
    
    func testPlatformOptimizationSettings() {
        // Given
        let platform = samplePlatform
        
        // When
        let settings = PlatformOptimizationSettings(for: platform)
        
        // Then
        XCTAssertEqual(settings.performanceLevel, .balanced, "Should have balanced performance level")
        XCTAssertEqual(settings.memoryStrategy, .adaptive, "Should have adaptive memory strategy")
        XCTAssertNotNil(settings.renderingOptimizations, "Should have rendering optimizations")
        XCTAssertNotNil(settings.featureFlags, "Should have feature flags")
    }
    
    func testPlatformOptimizationSettingsFeatureFlags() {
        // Given
        let platform = samplePlatform
        
        // When
        let settings = PlatformOptimizationSettings(for: platform)
        let featureFlags = settings.featureFlags
        
        // Then
        XCTAssertFalse(featureFlags.isEmpty, "Should have feature flags")
        // iOS should have specific feature flags
        if platform == .iOS {
            XCTAssertTrue(featureFlags["hapticFeedback"] == true, "iOS should have haptic feedback enabled")
            XCTAssertTrue(featureFlags["touchGestures"] == true, "iOS should have touch gestures enabled")
        }
    }
    
    // MARK: - Platform Recommendation Tests
    
    func testPlatformRecommendation() {
        // Given
        let recommendation = samplePlatformRecommendation
        
        // When
        let title = recommendation.title
        let description = recommendation.description
        let category = recommendation.category
        let priority = recommendation.priority
        let platform = recommendation.platform
        let timestamp = recommendation.timestamp
        
        // Then
        XCTAssertEqual(title, "Test Recommendation", "Should have correct title")
        XCTAssertEqual(description, "Test Description", "Should have correct description")
        XCTAssertEqual(category, .performance, "Should have correct category")
        XCTAssertEqual(priority, .medium, "Should have correct priority")
        XCTAssertEqual(platform, .iOS, "Should have correct platform")
        XCTAssertNotNil(timestamp, "Should have timestamp")
    }
    
    func testRecommendationCategory() {
        // Given
        let category = sampleRecommendationCategory
        
        // When
        let rawValue = category.rawValue
        
        // Then
        XCTAssertEqual(rawValue, "performance", "Should have correct raw value")
        XCTAssertTrue(RecommendationCategory.allCases.contains(category), "Should be valid case")
    }
    
    func testRecommendationCategoryAllCases() {
        // Given
        let allCategories = RecommendationCategory.allCases
        
        // When & Then
        for category in allCategories {
            XCTAssertFalse(category.rawValue.isEmpty, "Category should have non-empty raw value")
            XCTAssertTrue(RecommendationCategory.allCases.contains(category), "Category should be valid")
        }
    }
    
    // MARK: - Performance Level Tests
    
    func testPerformanceLevel() {
        // Given
        let level = samplePerformanceLevel
        
        // When
        let rawValue = level.rawValue
        
        // Then
        XCTAssertEqual(rawValue, "balanced", "Should have correct raw value")
        XCTAssertTrue(PerformanceLevel.allCases.contains(level), "Should be valid case")
    }
    
    func testPerformanceLevelAllCases() {
        // Given
        let allLevels = PerformanceLevel.allCases
        
        // When & Then
        for level in allLevels {
            XCTAssertFalse(level.rawValue.isEmpty, "Level should have non-empty raw value")
            XCTAssertTrue(PerformanceLevel.allCases.contains(level), "Level should be valid")
        }
    }
    
    // MARK: - Memory Strategy Tests
    
    func testMemoryStrategy() {
        // Given
        let strategy = sampleMemoryStrategy
        
        // When
        let rawValue = strategy.rawValue
        
        // Then
        XCTAssertEqual(rawValue, "adaptive", "Should have correct raw value")
        XCTAssertTrue(MemoryStrategy.allCases.contains(strategy), "Should be valid case")
    }
    
    func testMemoryStrategyAllCases() {
        // Given
        let allStrategies = MemoryStrategy.allCases
        
        // When & Then
        for strategy in allStrategies {
            XCTAssertFalse(strategy.rawValue.isEmpty, "Strategy should have non-empty raw value")
            XCTAssertTrue(MemoryStrategy.allCases.contains(strategy), "Strategy should be valid")
        }
    }
    
    // MARK: - Rendering Optimizations Tests
    
    func testRenderingOptimizations() {
        // Given
        let platform = samplePlatform
        
        // When
        let optimizations = RenderingOptimizations(for: platform)
        
        // Then
        XCTAssertNotNil(optimizations, "Should create rendering optimizations")
    }
    
    // MARK: - Platform UI Patterns Tests
    
    func testPlatformUIPatterns() {
        // Given
        let platform = samplePlatform
        
        // When
        let patterns = PlatformUIPatterns(for: platform)
        
        // Then
        XCTAssertNotNil(patterns, "Should create UI patterns")
    }
    
    // MARK: - Navigation Patterns Tests
    
    func testNavigationPatterns() {
        // Given
        let platform = samplePlatform
        
        // When
        let patterns = NavigationPatterns(for: platform)
        
        // Then
        XCTAssertNotNil(patterns, "Should create navigation patterns")
    }
    
    // MARK: - Interaction Patterns Tests
    
    func testInteractionPatterns() {
        // Given
        let platform = samplePlatform
        
        // When
        let patterns = InteractionPatterns(for: platform)
        
        // Then
        XCTAssertNotNil(patterns, "Should create interaction patterns")
    }
    
    // MARK: - Layout Patterns Tests
    
    func testLayoutPatterns() {
        // Given
        let platform = samplePlatform
        
        // When
        let patterns = LayoutPatterns(for: platform)
        
        // Then
        XCTAssertNotNil(patterns, "Should create layout patterns")
    }
    
    // MARK: - Cross-Platform Performance Metrics Tests
    
    func testCrossPlatformPerformanceMetrics() {
        // Given
        let metrics = sampleCrossPlatformPerformanceMetrics
        
        // When
        // Test that metrics can be created and accessed
        
        // Then
        XCTAssertNotNil(metrics, "Should create performance metrics")
    }
    
    // MARK: - View Extension Tests
    
    func testPlatformSpecificOptimizations() {
        // Given
        let testView = Text("Test View")
        let platform = samplePlatform
        
        // When
        let optimizedView = testView.platformSpecificOptimizations(for: platform)
        
        // Then
        LayeredTestUtilities.verifyViewCreation(optimizedView, testName: "platformSpecificOptimizations")
    }
    
    func testPerformanceOptimizations() {
        // Given
        let testView = Text("Test View")
        let settings = samplePlatformOptimizationSettings
        
        // When
        let optimizedView = testView.performanceOptimizations(using: settings)
        
        // Then
        LayeredTestUtilities.verifyViewCreation(optimizedView, testName: "performanceOptimizations")
    }
    
    func testUIPatternOptimizations() {
        // Given
        let testView = Text("Test View")
        let patterns = samplePlatformUIPatterns
        
        // When
        let optimizedView = testView.uiPatternOptimizations(using: patterns)
        
        // Then
        LayeredTestUtilities.verifyViewCreation(optimizedView, testName: "uiPatternOptimizations")
    }
    
    // MARK: - Platform System Integration Tests
    
    func testPlatformSystemIntegration() {
        // Given
        let testView = Text("Test View")
        let platform = samplePlatform
        let settings = samplePlatformOptimizationSettings
        let patterns = samplePlatformUIPatterns
        
        // When
        let fullyOptimizedView = testView
            .platformSpecificOptimizations(for: platform)
            .performanceOptimizations(using: settings)
            .uiPatternOptimizations(using: patterns)
        
        // Then
        LayeredTestUtilities.verifyViewCreation(fullyOptimizedView, testName: "Platform system integration")
    }
    
    func testPlatformSystemConsistency() {
        // Given
        let testView = Text("Test View")
        let platform = samplePlatform
        
        // When
        let view1 = testView.platformSpecificOptimizations(for: platform)
        let view2 = testView.platformSpecificOptimizations(for: platform)
        
        // Then
        LayeredTestUtilities.verifyViewCreation(view1, testName: "Platform system consistency test 1")
        LayeredTestUtilities.verifyViewCreation(view2, testName: "Platform system consistency test 2")
        // Both optimizations should be applied consistently
    }
    
    func testPlatformSystemPerformance() {
        // Given
        let testView = Text("Test View")
        let platform = samplePlatform
        
        // When
        let startTime = CFAbsoluteTimeGetCurrent()
        let optimizedView = testView.platformSpecificOptimizations(for: platform)
        let endTime = CFAbsoluteTimeGetCurrent()
        
        // Then
        LayeredTestUtilities.verifyViewCreation(optimizedView, testName: "Platform system performance test")
        let executionTime = endTime - startTime
        XCTAssertLessThan(executionTime, 0.1, "Platform system optimization should be fast (< 100ms)")
    }
    
    // MARK: - Edge Case Testing
    
    func testPlatformSystemWithEmptyView() {
        // Given
        let emptyView = EmptyView()
        let platform = samplePlatform
        
        // When
        let optimizedView = emptyView.platformSpecificOptimizations(for: platform)
        
        // Then
        LayeredTestUtilities.verifyViewCreation(optimizedView, testName: "Empty view platform system optimization")
        // Should handle empty views gracefully
    }
    
    func testPlatformSystemWithComplexView() {
        // Given
        let complexView = VStack {
            Text("Title")
            HStack {
                Text("Left")
                Text("Right")
            }
            LazyVStack {
                ForEach(0..<10) { index in
                    Text("Item \(index)")
                }
            }
        }
        let platform = samplePlatform
        
        // When
        let optimizedView = complexView.platformSpecificOptimizations(for: platform)
        
        // Then
        LayeredTestUtilities.verifyViewCreation(optimizedView, testName: "Complex view platform system optimization")
        // Should handle complex views gracefully
    }
    
    // MARK: - Platform-Specific System Testing
    
    func testPlatformSpecificSystemBehavior() {
        // Given
        let testView = Text("Test View")
        
        // When
        let iOSView = testView.platformSpecificOptimizations(for: .iOS)
        let macOSView = testView.platformSpecificOptimizations(for: .macOS)
        let watchOSView = testView.platformSpecificOptimizations(for: .watchOS)
        let tvOSView = testView.platformSpecificOptimizations(for: .tvOS)
        let visionOSView = testView.platformSpecificOptimizations(for: .visionOS)
        
        // Then
        LayeredTestUtilities.verifyViewCreation(iOSView, testName: "iOS platform system")
        LayeredTestUtilities.verifyViewCreation(macOSView, testName: "macOS platform system")
        LayeredTestUtilities.verifyViewCreation(watchOSView, testName: "watchOS platform system")
        LayeredTestUtilities.verifyViewCreation(tvOSView, testName: "tvOS platform system")
        LayeredTestUtilities.verifyViewCreation(visionOSView, testName: "visionOS platform system")
    }
    
    func testPlatformSystemFeatureFlags() {
        // Given
        let iOSSettings = PlatformOptimizationSettings(for: .iOS)
        let macOSSettings = PlatformOptimizationSettings(for: .macOS)
        let watchOSSettings = PlatformOptimizationSettings(for: .watchOS)
        let tvOSSettings = PlatformOptimizationSettings(for: .tvOS)
        let visionOSSettings = PlatformOptimizationSettings(for: .visionOS)
        
        // When & Then
        // iOS should have touch and haptic features
        XCTAssertTrue(iOSSettings.featureFlags["touchGestures"] == true, "iOS should support touch gestures")
        XCTAssertTrue(iOSSettings.featureFlags["hapticFeedback"] == true, "iOS should support haptic feedback")
        
        // macOS should have keyboard and mouse features
        XCTAssertTrue(macOSSettings.featureFlags["keyboardNavigation"] == true, "macOS should support keyboard navigation")
        XCTAssertTrue(macOSSettings.featureFlags["mouseOptimization"] == true, "macOS should support mouse optimization")
        
        // watchOS should have Digital Crown and complications
        XCTAssertTrue(watchOSSettings.featureFlags["digitalCrown"] == true, "watchOS should support Digital Crown")
        XCTAssertTrue(watchOSSettings.featureFlags["complications"] == true, "watchOS should support complications")
        
        // tvOS should have remote control and focus engine
        XCTAssertTrue(tvOSSettings.featureFlags["remoteControl"] == true, "tvOS should support remote control")
        XCTAssertTrue(tvOSSettings.featureFlags["focusEngine"] == true, "tvOS should support focus engine")
        
        // visionOS should have spatial UI and hand tracking
        XCTAssertTrue(visionOSSettings.featureFlags["spatialUI"] == true, "visionOS should support spatial UI")
        XCTAssertTrue(visionOSSettings.featureFlags["handTracking"] == true, "visionOS should support hand tracking")
    }
    
    // MARK: - System Integration Testing
    
    func testSystemIntegrationWithAllLayers() {
        // Given
        let testView = Text("Test View")
        let platform = samplePlatform
        let settings = samplePlatformOptimizationSettings
        let patterns = samplePlatformUIPatterns
        
        // When
        let fullyIntegratedView = testView
            .platformSpecificOptimizations(for: platform)
            .performanceOptimizations(using: settings)
            .uiPatternOptimizations(using: patterns)
        
        // Then
        LayeredTestUtilities.verifyViewCreation(fullyIntegratedView, testName: "Full system integration test")
        // Should integrate all L6 system components successfully
    }
    
    func testSystemIntegrationPerformance() {
        // Given
        let testView = Text("Test View")
        let platform = samplePlatform
        let settings = samplePlatformOptimizationSettings
        let patterns = samplePlatformUIPatterns
        
        // When
        let startTime = CFAbsoluteTimeGetCurrent()
        let fullyIntegratedView = testView
            .platformSpecificOptimizations(for: platform)
            .performanceOptimizations(using: settings)
            .uiPatternOptimizations(using: patterns)
        let endTime = CFAbsoluteTimeGetCurrent()
        
        // Then
        LayeredTestUtilities.verifyViewCreation(fullyIntegratedView, testName: "System integration performance test")
        let executionTime = endTime - startTime
        XCTAssertLessThan(executionTime, 0.2, "Full system integration should be fast (< 200ms)")
    }
}



