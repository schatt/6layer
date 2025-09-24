//
//  L5PlatformOptimizationTests.swift
//  SixLayerFramework
//
//  Layer 5 Testing: Platform Optimization Functions
//  Tests L5 functions that apply platform-specific enhancements and optimizations
//

import XCTest
import SwiftUI
@testable import SixLayerFramework

class L5PlatformOptimizationTests: XCTestCase {
    
    // MARK: - Test Data
    
    private var samplePlatform: Platform = .iOS
    private var samplePerformanceLevel: PerformanceOptimizationLevel = .medium
    private var sampleCachingStrategy: PerformanceCachingStrategy = .intelligent
    private var sampleRenderingStrategy: PerformanceRenderingStrategy = .optimized
    private var sampleMemoryConfig: MemoryConfig = MemoryConfig()
    private var sampleLazyLoadingConfig: LazyLoadingConfig = LazyLoadingConfig()
    private var samplePerformanceMetrics: ViewPerformanceMetrics = ViewPerformanceMetrics()
    private var sampleIOSHapticStyle: IOSHapticStyle = .medium
    private var sampleMacOSPerformanceStrategy: MacOSPerformanceStrategy = .optimized
    
    override func setUp() {
        super.setUp()
        samplePlatform = L5TestDataFactory.createSamplePlatform()
        samplePerformanceLevel = L5TestDataFactory.createSamplePerformanceOptimizationLevel()
        sampleCachingStrategy = L5TestDataFactory.createSampleCachingStrategy()
        sampleRenderingStrategy = L5TestDataFactory.createSampleRenderingStrategy()
        sampleMemoryConfig = L5TestDataFactory.createSampleMemoryConfig()
        sampleLazyLoadingConfig = L5TestDataFactory.createSampleLazyLoadingConfig()
        samplePerformanceMetrics = L5TestDataFactory.createSamplePerformanceMetrics()
        sampleIOSHapticStyle = L5TestDataFactory.createSampleIOSHapticStyle()
        sampleMacOSPerformanceStrategy = L5TestDataFactory.createSampleMacOSPerformanceStrategy()
    }
    
    override func tearDown() {
        samplePlatform = .iOS
        samplePerformanceLevel = .medium
        sampleCachingStrategy = .intelligent
        sampleRenderingStrategy = .optimized
        sampleMemoryConfig = MemoryConfig()
        sampleLazyLoadingConfig = LazyLoadingConfig()
        samplePerformanceMetrics = ViewPerformanceMetrics()
        sampleIOSHapticStyle = .medium
        sampleMacOSPerformanceStrategy = .optimized
        super.tearDown()
    }
    
    // MARK: - Performance Optimization Functions
    
    func testPlatformMemoryOptimization() {
        // Given
        let testView = Text("Test View")
        
        // When
        let optimizedView = testView.platformMemoryOptimization()
        
        // Then
        LayeredTestUtilities.verifyViewCreation(optimizedView, testName: "platformMemoryOptimization")
        // Should apply memory optimization (drawingGroup on iOS/macOS)
    }
    
    func testPlatformLazyLoading() {
        // Given
        let testView = Text("Test View")
        
        // When
        let lazyView = testView.platformLazyLoading {
            Text("Lazy Content")
        }
        
        // Then
        LayeredTestUtilities.verifyViewCreation(lazyView, testName: "platformLazyLoading")
        // Should apply lazy loading optimization
    }
    
    func testPlatformRenderingOptimization() {
        // Given
        let testView = Text("Test View")
        
        // When
        let optimizedView = testView.platformRenderingOptimization()
        
        // Then
        LayeredTestUtilities.verifyViewCreation(optimizedView, testName: "platformRenderingOptimization")
        // Should apply rendering optimization (drawingGroup on iOS/macOS)
    }
    
    func testPlatformAnimationOptimization() {
        // Given
        let testView = Text("Test View")
        
        // When
        let optimizedView = testView.platformAnimationOptimization()
        
        // Then
        LayeredTestUtilities.verifyViewCreation(optimizedView, testName: "platformAnimationOptimization")
        // Should apply animation optimization
    }
    
    func testPlatformCachingOptimization() {
        // Given
        let testView = Text("Test View")
        
        // When
        let optimizedView = testView.platformCachingOptimization()
        
        // Then
        LayeredTestUtilities.verifyViewCreation(optimizedView, testName: "platformCachingOptimization")
        // Should apply caching optimization
    }
    
    // MARK: - Platform-Specific Optimization Functions
    
    func testPlatformPerformanceOptimized() {
        // Given
        let testView = Text("Test View")
        let platform = samplePlatform
        
        // When
        let optimizedView = testView.platformPerformanceOptimized(for: platform)
        
        // Then
        LayeredTestUtilities.verifyViewCreation(optimizedView, testName: "platformPerformanceOptimized")
        // Should apply platform-specific performance optimizations
    }
    
    func testPlatformMemoryOptimized() {
        // Given
        let testView = Text("Test View")
        let platform = samplePlatform
        
        // When
        let optimizedView = testView.platformMemoryOptimized(for: platform)
        
        // Then
        LayeredTestUtilities.verifyViewCreation(optimizedView, testName: "platformMemoryOptimized")
        // Should apply platform-specific memory optimizations
    }
    
    // MARK: - iOS-Specific Optimization Functions
    
    func testPlatformIOSNavigationBar() {
        // Given
        let testView = Text("Test View")
        let title = "Test Title"
        let displayMode = NavigationBarItem.TitleDisplayMode.automatic
        
        // When
        let optimizedView = testView.platformIOSNavigationBar(
            title: title,
            displayMode: displayMode
        )
        
        // Then
        LayeredTestUtilities.verifyViewCreation(optimizedView, testName: "platformIOSNavigationBar")
        // Should apply iOS-specific navigation bar styling
    }
    
    func testPlatformIOSToolbar() {
        // Given
        let testView = Text("Test View")
        
        // When
        let optimizedView = testView.platformIOSToolbar {
            Text("Toolbar Content")
        }
        
        // Then
        LayeredTestUtilities.verifyViewCreation(optimizedView, testName: "platformIOSToolbar")
        // Should apply iOS-specific toolbar styling
    }
    
    func testPlatformIOSSwipeGestures() {
        // Given
        let testView = Text("Test View")
        var swipeLeftCalled = false
        var swipeRightCalled = false
        var swipeUpCalled = false
        var swipeDownCalled = false
        
        // When
        let optimizedView = testView.platformIOSSwipeGestures(
            onSwipeLeft: { swipeLeftCalled = true },
            onSwipeRight: { swipeRightCalled = true },
            onSwipeUp: { swipeUpCalled = true },
            onSwipeDown: { swipeDownCalled = true }
        )
        
        // Then
        LayeredTestUtilities.verifyViewCreation(optimizedView, testName: "platformIOSSwipeGestures")
        // Should apply iOS-specific swipe gesture handling
        // Note: Actual gesture testing would require UI testing
    }
    
    func testPlatformIOSHapticFeedback() {
        // Given
        let testView = Text("Test View")
        let style = sampleIOSHapticStyle
        let trigger = true
        
        // When
        let optimizedView = testView.platformIOSHapticFeedback(
            style: style,
            onTrigger: trigger
        )
        
        // Then
        LayeredTestUtilities.verifyViewCreation(optimizedView, testName: "platformIOSHapticFeedback")
        // Should apply iOS-specific haptic feedback
        // Note: Actual haptic testing would require device testing
    }
    
    // MARK: - macOS-Specific Optimization Functions
    
    func testMacOSOptimizationManager() {
        // Given
        let manager = MacOSOptimizationManager.shared
        
        // When
        let strategy = manager.getCurrentPerformanceStrategy()
        let isOptimized = manager.isMacOSOptimized
        let version = manager.macOSVersion
        
        // Then
        XCTAssertEqual(strategy, .standard, "Should return standard strategy")
        XCTAssertFalse(isOptimized, "Should not be optimized (placeholder)")
        XCTAssertFalse(version.isEmpty, "Should return macOS version")
    }
    
    func testMacOSPerformanceStrategy() {
        // Given
        let strategy = sampleMacOSPerformanceStrategy
        
        // When
        let rawValue = strategy.rawValue
        
        // Then
        XCTAssertEqual(rawValue, "optimized", "Should have correct raw value")
        XCTAssertTrue(MacOSPerformanceStrategy.allCases.contains(strategy), "Should be valid case")
    }
    
    // MARK: - Performance Metrics Testing
    
    func testViewPerformanceMetrics() {
        // Given
        let metrics = samplePerformanceMetrics
        
        // When
        let renderTime = metrics.renderTime
        let memoryUsage = metrics.memoryUsage
        let frameRate = metrics.frameRate
        let cacheHitRate = metrics.cacheHitRate
        
        // Then
        XCTAssertEqual(renderTime, 0.016, accuracy: 0.001, "Should have correct render time")
        XCTAssertEqual(memoryUsage, 1024 * 1024, "Should have correct memory usage")
        XCTAssertEqual(frameRate, 60.0, "Should have correct frame rate")
        XCTAssertEqual(cacheHitRate, 0.85, "Should have correct cache hit rate")
    }
    
    func testPerformanceOptimizationLevel() {
        // Given
        let level = samplePerformanceLevel
        
        // When
        let multiplier = level.multiplier
        
        // Then
        XCTAssertEqual(multiplier, 0.6, "Medium level should have 0.6 multiplier")
        XCTAssertTrue(PerformanceOptimizationLevel.allCases.contains(level), "Should be valid case")
    }
    
    func testPerformanceCachingStrategy() {
        // Given
        let strategy = sampleCachingStrategy
        
        // When
        let cacheSize = strategy.cacheSize
        
        // Then
        XCTAssertEqual(cacheSize, 1000, "Intelligent strategy should have 1000 cache size")
        XCTAssertTrue(PerformanceCachingStrategy.allCases.contains(strategy), "Should be valid case")
    }
    
    func testPerformanceRenderingStrategy() {
        // Given
        let strategy = sampleRenderingStrategy
        
        // When
        let useMetal = strategy.useMetal
        
        // Then
        XCTAssertTrue(useMetal, "Optimized strategy should use Metal")
        XCTAssertTrue(PerformanceRenderingStrategy.allCases.contains(strategy), "Should be valid case")
    }
    
    // MARK: - Memory Management Testing
    
    func testMemoryConfig() {
        // Given
        let config = sampleMemoryConfig
        
        // When
        let maxCacheSize = config.maxCacheSize
        let evictionPolicy = config.evictionPolicy
        let monitorMemoryPressure = config.monitorMemoryPressure
        
        // Then
        XCTAssertEqual(maxCacheSize, 1024 * 1024, "Should have correct max cache size")
        XCTAssertEqual(evictionPolicy, .lru, "Should have LRU eviction policy")
        XCTAssertTrue(monitorMemoryPressure, "Should monitor memory pressure")
    }
    
    func testLazyLoadingConfig() {
        // Given
        let config = sampleLazyLoadingConfig
        
        // When
        let threshold = config.threshold
        let batchSize = config.batchSize
        let preloadDistance = config.preloadDistance
        let enableVirtualization = config.enableVirtualization
        
        // Then
        XCTAssertEqual(threshold, 10, "Should have correct threshold")
        XCTAssertEqual(batchSize, 5, "Should have correct batch size")
        XCTAssertEqual(preloadDistance, 3, "Should have correct preload distance")
        XCTAssertTrue(enableVirtualization, "Should enable virtualization")
    }
    
    // MARK: - Platform-Specific Behavior Testing
    
    func testPlatformSpecificOptimizations() {
        // Given
        let testView = Text("Test View")
        
        // When
        let memoryOptimized = testView.platformMemoryOptimization()
        let renderingOptimized = testView.platformRenderingOptimization()
        let animationOptimized = testView.platformAnimationOptimization()
        let cachingOptimized = testView.platformCachingOptimization()
        
        // Then
        LayeredTestUtilities.verifyViewCreation(memoryOptimized, testName: "Memory optimization")
        LayeredTestUtilities.verifyViewCreation(renderingOptimized, testName: "Rendering optimization")
        LayeredTestUtilities.verifyViewCreation(animationOptimized, testName: "Animation optimization")
        LayeredTestUtilities.verifyViewCreation(cachingOptimized, testName: "Caching optimization")
    }
    
    func testOptimizationConsistency() {
        // Given
        let testView = Text("Test View")
        
        // When
        let view1 = testView.platformMemoryOptimization()
        let view2 = testView.platformMemoryOptimization()
        
        // Then
        LayeredTestUtilities.verifyViewCreation(view1, testName: "Optimization consistency test 1")
        LayeredTestUtilities.verifyViewCreation(view2, testName: "Optimization consistency test 2")
        // Both optimizations should be applied consistently
    }
    
    func testOptimizationPerformance() {
        // Given
        let testView = Text("Test View")
        
        // When
        let startTime = CFAbsoluteTimeGetCurrent()
        let optimizedView = testView.platformMemoryOptimization()
        let endTime = CFAbsoluteTimeGetCurrent()
        
        // Then
        LayeredTestUtilities.verifyViewCreation(optimizedView, testName: "Optimization performance test")
        let executionTime = endTime - startTime
        XCTAssertLessThan(executionTime, 0.1, "Optimization should be fast (< 100ms)")
    }
    
    // MARK: - Edge Case Testing
    
    func testOptimizationWithEmptyView() {
        // Given
        let emptyView = EmptyView()
        
        // When
        let optimizedView = emptyView.platformMemoryOptimization()
        
        // Then
        LayeredTestUtilities.verifyViewCreation(optimizedView, testName: "Empty view optimization")
        // Should handle empty views gracefully
    }
    
    func testOptimizationWithComplexView() {
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
        
        // When
        let optimizedView = complexView.platformMemoryOptimization()
        
        // Then
        LayeredTestUtilities.verifyViewCreation(optimizedView, testName: "Complex view optimization")
        // Should handle complex views gracefully
    }
    
    func testIOSHapticStyleCases() {
        // Given
        let allStyles: [IOSHapticStyle] = [.light, .medium, .heavy, .success, .warning, .error]
        
        // When & Then
        for style in allStyles {
            let testView = Text("Test View")
            let optimizedView = testView.platformIOSHapticFeedback(style: style, onTrigger: true)
            LayeredTestUtilities.verifyViewCreation(optimizedView, testName: "iOS Haptic Style: \(style)")
        }
    }
    
    func testMacOSPerformanceStrategyCases() {
        // Given
        let allStrategies = MacOSPerformanceStrategy.allCases
        
        // When & Then
        for strategy in allStrategies {
            XCTAssertFalse(strategy.rawValue.isEmpty, "Strategy should have non-empty raw value")
            XCTAssertTrue(MacOSPerformanceStrategy.allCases.contains(strategy), "Strategy should be valid")
        }
    }
}


