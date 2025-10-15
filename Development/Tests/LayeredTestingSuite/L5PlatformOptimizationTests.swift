//
//  L5PlatformOptimizationTests.swift
//  SixLayerFramework
//
//  Layer 5 Testing: Platform Optimization Functions
//  Tests L5 functions that apply platform-specific enhancements and optimizations
//

import Testing
import SwiftUI
@testable import SixLayerFramework

class L5PlatformOptimizationTests {
    
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
    
    init() async throws {
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
    
    deinit {
        Task { [weak self] in
            await self?.cleanupTestEnvironment()
        }
    }
    
    // MARK: - Performance Optimization Functions
    
    @Test func testPlatformMemoryOptimization() {
        // Given
        let testView = Text("Test View")
        
        // When
        let optimizedView = testView.platformMemoryOptimization()
        
        // Then
        LayeredTestUtilities.verifyViewCreation(optimizedView, testName: "platformMemoryOptimization")
        // Should apply memory optimization (drawingGroup on iOS/macOS)
    }
    
    @Test func testPlatformLazyLoading() {
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
    
    @Test func testPlatformRenderingOptimization() {
        // Given
        let testView = Text("Test View")
        
        // When
        let optimizedView = testView.platformRenderingOptimization()
        
        // Then
        LayeredTestUtilities.verifyViewCreation(optimizedView, testName: "platformRenderingOptimization")
        // Should apply rendering optimization (drawingGroup on iOS/macOS)
    }
    
    @Test func testPlatformAnimationOptimization() {
        // Given
        let testView = Text("Test View")
        
        // When
        let optimizedView = testView.platformAnimationOptimization()
        
        // Then
        LayeredTestUtilities.verifyViewCreation(optimizedView, testName: "platformAnimationOptimization")
        // Should apply animation optimization
    }
    
    @Test func testPlatformCachingOptimization() {
        // Given
        let testView = Text("Test View")
        
        // When
        let optimizedView = testView.platformCachingOptimization()
        
        // Then
        LayeredTestUtilities.verifyViewCreation(optimizedView, testName: "platformCachingOptimization")
        // Should apply caching optimization
    }
    
    // MARK: - Platform-Specific Optimization Functions
    
    @Test func testPlatformPerformanceOptimized() {
        // Given
        let testView = Text("Test View")
        let platform = samplePlatform
        
        // When
        let optimizedView = testView.platformPerformanceOptimized(for: platform)
        
        // Then
        LayeredTestUtilities.verifyViewCreation(optimizedView, testName: "platformPerformanceOptimized")
        // Should apply platform-specific performance optimizations
    }
    
    @Test func testPlatformMemoryOptimized() {
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
    
    @Test func testPlatformIOSNavigationBar() {
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
    
    @Test func testPlatformIOSToolbar() {
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
    
    @Test func testPlatformIOSSwipeGestures() {
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
    
    @Test func testPlatformIOSHapticFeedback() {
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
    
    @Test func testMacOSOptimizationManager() {
        // Given
        let manager = MacOSOptimizationManager.shared
        
        // When
        let strategy = manager.getCurrentPerformanceStrategy()
        let isOptimized = manager.isMacOSOptimized
        let version = manager.macOSVersion
        
        // Then
        #expect(strategy == .standard, "Should return standard strategy")
        #expect(!isOptimized, "Should not be optimized (placeholder)")
        #expect(!version.isEmpty, "Should return macOS version")
    }
    
    @Test func testMacOSPerformanceStrategy() {
        // Given
        let strategy = sampleMacOSPerformanceStrategy
        
        // When
        let rawValue = strategy.rawValue
        
        // Then
        #expect(rawValue == "optimized", "Should have correct raw value")
        #expect(MacOSPerformanceStrategy.allCases.contains(strategy), "Should be valid case")
    }
    
    // MARK: - Performance Metrics Testing
    
    @Test func testViewPerformanceMetrics() {
        // Given
        let metrics = samplePerformanceMetrics
        
        // When
        let renderTime = metrics.renderTime
        let memoryUsage = metrics.memoryUsage
        let frameRate = metrics.frameRate
        let cacheHitRate = metrics.cacheHitRate
        
        // Then
        #expect(renderTime == 0.016)
        #expect(memoryUsage == 1024 * 1024, "Should have correct memory usage")
        #expect(frameRate == 60.0, "Should have correct frame rate")
        #expect(cacheHitRate == 0.85, "Should have correct cache hit rate")
    }
    
    @Test func testPerformanceOptimizationLevel() {
        // Given
        let level = samplePerformanceLevel
        
        // When
        let multiplier = level.multiplier
        
        // Then
        #expect(multiplier == 0.6, "Medium level should have 0.6 multiplier")
        #expect(PerformanceOptimizationLevel.allCases.contains(level), "Should be valid case")
    }
    
    @Test func testPerformanceCachingStrategy() {
        // Given
        let strategy = sampleCachingStrategy
        
        // When
        let cacheSize = strategy.cacheSize
        
        // Then
        #expect(cacheSize == 1000, "Intelligent strategy should have 1000 cache size")
        #expect(PerformanceCachingStrategy.allCases.contains(strategy), "Should be valid case")
    }
    
    @Test func testPerformanceRenderingStrategy() {
        // Given
        let strategy = sampleRenderingStrategy
        
        // When
        let useMetal = strategy.useMetal
        
        // Then
        #expect(useMetal, "Optimized strategy should use Metal")
        #expect(PerformanceRenderingStrategy.allCases.contains(strategy), "Should be valid case")
    }
    
    // MARK: - Memory Management Testing
    
    @Test func testMemoryConfig() {
        // Given
        let config = sampleMemoryConfig
        
        // When
        let maxCacheSize = config.maxCacheSize
        let evictionPolicy = config.evictionPolicy
        let monitorMemoryPressure = config.monitorMemoryPressure
        
        // Then
        #expect(maxCacheSize == 1024 * 1024, "Should have correct max cache size")
        #expect(evictionPolicy == .lru, "Should have LRU eviction policy")
        #expect(monitorMemoryPressure, "Should monitor memory pressure")
    }
    
    @Test func testLazyLoadingConfig() {
        // Given
        let config = sampleLazyLoadingConfig
        
        // When
        let threshold = config.threshold
        let batchSize = config.batchSize
        let preloadDistance = config.preloadDistance
        let enableVirtualization = config.enableVirtualization
        
        // Then
        #expect(threshold == 10, "Should have correct threshold")
        #expect(batchSize == 5, "Should have correct batch size")
        #expect(preloadDistance == 3, "Should have correct preload distance")
        #expect(enableVirtualization, "Should enable virtualization")
    }
    
    // MARK: - Platform-Specific Behavior Testing
    
    @Test func testPlatformSpecificOptimizations() {
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
    
    @Test func testOptimizationConsistency() {
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
    
    @Test func testOptimizationPerformance() {
        // Given
        let testView = Text("Test View")
        
        // When
        let startTime = CFAbsoluteTimeGetCurrent()
        let optimizedView = testView.platformMemoryOptimization()
        let endTime = CFAbsoluteTimeGetCurrent()
        
        // Then
        LayeredTestUtilities.verifyViewCreation(optimizedView, testName: "Optimization performance test")
        let executionTime = endTime - startTime
        #expect(executionTime < 0.1, "Optimization should be fast (< 100ms)")
    }
    
    // MARK: - Edge Case Testing
    
    @Test func testOptimizationWithEmptyView() {
        // Given
        let emptyView = EmptyView()
        
        // When
        let optimizedView = emptyView.platformMemoryOptimization()
        
        // Then
        LayeredTestUtilities.verifyViewCreation(optimizedView, testName: "Empty view optimization")
        // Should handle empty views gracefully
    }
    
    @Test func testOptimizationWithComplexView() {
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
    
    @Test func testIOSHapticStyleCases() {
        // Given
        let allStyles: [IOSHapticStyle] = [.light, .medium, .heavy, .success, .warning, .error]
        
        // When & Then
        for style in allStyles {
            let testView = Text("Test View")
            let optimizedView = testView.platformIOSHapticFeedback(style: style, onTrigger: true)
            LayeredTestUtilities.verifyViewCreation(optimizedView, testName: "iOS Haptic Style: \(style)")
        }
    }
    
    @Test func testMacOSPerformanceStrategyCases() {
        // Given
        let allStrategies = MacOSPerformanceStrategy.allCases
        
        // When & Then
        for strategy in allStrategies {
            #expect(!strategy.rawValue.isEmpty, "Strategy should have non-empty raw value")
            #expect(MacOSPerformanceStrategy.allCases.contains(strategy), "Strategy should be valid")
        }
    }
}









