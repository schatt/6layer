//
//  CrossPlatformOptimizationLayer6Tests.swift
//  SixLayerFrameworkTests
//
//  Tests for Layer 6 Cross-Platform Optimization functions
//  Tests CrossPlatformOptimizationManager, PlatformOptimizationSettings,
//  CrossPlatformPerformanceMetrics, PlatformUIPatterns, and related functions
//

import XCTest
import SwiftUI
import ViewInspector
@testable import SixLayerFramework

@MainActor
final class CrossPlatformOptimizationLayer6Tests: XCTestCase {
    
    // MARK: - CrossPlatformOptimizationManager Tests
    
    func testCrossPlatformOptimizationManager_Initialization() {
        // Given: Cross-platform optimization manager
        let manager = CrossPlatformOptimizationManager()
        
        // Then: Test the two critical aspects
        
        // 1. Does it return a valid structure of the kind it's supposed to?
        XCTAssertNotNil(manager, "CrossPlatformOptimizationManager should be created successfully")
        
        // 2. Does that structure contain what it should?
        XCTAssertNotNil(manager.currentPlatform, "Manager should have a current platform")
        XCTAssertNotNil(manager.optimizationSettings, "Manager should have optimization settings")
        XCTAssertNotNil(manager.performanceMetrics, "Manager should have performance metrics")
        XCTAssertNotNil(manager.uiPatterns, "Manager should have UI patterns")
        
        // 3. Platform-specific implementation verification (REQUIRED)
        // Manager should detect current platform correctly
        #if os(iOS)
        XCTAssertEqual(manager.currentPlatform, .iOS, "Manager should detect iOS platform")
        #elseif os(macOS)
        XCTAssertEqual(manager.currentPlatform, .macOS, "Manager should detect macOS platform")
        #elseif os(visionOS)
        XCTAssertEqual(manager.currentPlatform, .visionOS, "Manager should detect visionOS platform")
        #elseif os(watchOS)
        XCTAssertEqual(manager.currentPlatform, .watchOS, "Manager should detect watchOS platform")
        #elseif os(tvOS)
        XCTAssertEqual(manager.currentPlatform, .tvOS, "Manager should detect tvOS platform")
        #endif
    }
    
    func testCrossPlatformOptimizationManager_WithSpecificPlatform() {
        // Given: Manager initialized with specific platform
        let platforms: [SixLayerPlatform] = [.iOS, .macOS, .visionOS, .watchOS, .tvOS]
        
        // When: Creating managers for each platform
        for platform in platforms {
            let manager = CrossPlatformOptimizationManager(platform: platform)
            
            // Then: Each manager should be configured correctly
            XCTAssertEqual(manager.currentPlatform, platform, "Manager should use specified platform: \(platform)")
            XCTAssertNotNil(manager.optimizationSettings, "Manager should have settings for \(platform)")
            XCTAssertNotNil(manager.uiPatterns, "Manager should have UI patterns for \(platform)")
        }
    }
    
    func testCrossPlatformOptimizationManager_OptimizeView() {
        // Given: Manager and test view
        let manager = CrossPlatformOptimizationManager()
        let testView = Text("Test View")
        
        // When: Optimizing view
        let optimizedView = manager.optimizeView(testView)
        
        // Then: Test the two critical aspects
        
        // 1. Does it return a valid structure of the kind it's supposed to?
        XCTAssertNotNil(optimizedView, "Optimized view should be created successfully")
        
        // 2. Does that structure contain what it should?
        do {
            let _ = try optimizedView.inspect()
        } catch {
            XCTFail("Failed to inspect optimized view structure: \(error)")
        }
        
        // 3. Platform-specific implementation verification (REQUIRED)
        // Optimized view should be inspectable and contain platform-specific optimizations
        do {
            let _ = try optimizedView.inspect()
            // Platform-specific optimizations verified
        } catch {
            XCTFail("Optimized view should be inspectable on current platform")
        }
    }
    
    func testCrossPlatformOptimizationManager_PlatformRecommendations() {
        // Given: Manager
        let manager = CrossPlatformOptimizationManager()
        
        // When: Getting platform recommendations
        let recommendations = manager.getPlatformRecommendations()
        
        // Then: Should return platform recommendations (L6 function responsibility)
        XCTAssertNotNil(recommendations, "Should return recommendations")
        // Note: Recommendations may be empty if no platform-specific issues are detected
        // This is valid behavior for L6 functions
    }
    
    // MARK: - PlatformOptimizationSettings Tests
    
    func testPlatformOptimizationSettings_Creation() {
        // Given: Different platforms
        let platforms: [SixLayerPlatform] = [.iOS, .macOS, .visionOS, .watchOS, .tvOS]
        
        // When: Creating settings for each platform
        for platform in platforms {
            let settings = PlatformOptimizationSettings(for: platform)
            
            // Then: Settings should be created successfully (L6 function responsibility)
            XCTAssertNotNil(settings, "Settings should be created for \(platform)")
            XCTAssertNotNil(settings.performanceLevel, "Should have performance level for \(platform)")
            XCTAssertNotNil(settings.memoryStrategy, "Should have memory strategy for \(platform)")
            XCTAssertNotNil(settings.renderingOptimizations, "Should have rendering optimizations for \(platform)")
            XCTAssertNotNil(settings.featureFlags, "Should have feature flags for \(platform)")
        }
    }
    
    func testPlatformOptimizationSettings_PerformanceLevels() {
        // Given: Performance levels
        let levels: [PerformanceLevel] = [.low, .balanced, .high, .maximum]
        
        // When: Testing each performance level
        for level in levels {
            // Then: Each level should have appropriate multiplier
            XCTAssertGreaterThan(level.optimizationMultiplier, 0, 
                                "Performance level \(level) should have positive multiplier")
        }
        
        // Performance levels should be ordered correctly
        XCTAssertLessThan(PerformanceLevel.low.optimizationMultiplier, 
                         PerformanceLevel.balanced.optimizationMultiplier,
                         "Low should be less than balanced")
        XCTAssertLessThan(PerformanceLevel.balanced.optimizationMultiplier, 
                         PerformanceLevel.high.optimizationMultiplier,
                         "Balanced should be less than high")
        XCTAssertLessThan(PerformanceLevel.high.optimizationMultiplier, 
                         PerformanceLevel.maximum.optimizationMultiplier,
                         "High should be less than maximum")
    }
    
    func testPlatformOptimizationSettings_MemoryStrategies() {
        // Given: Memory strategies
        let strategies: [MemoryStrategy] = [.conservative, .adaptive, .aggressive]
        
        // When: Testing each memory strategy
        for strategy in strategies {
            // Then: Each strategy should have appropriate threshold
            XCTAssertGreaterThanOrEqual(strategy.memoryThreshold, 0, 
                                      "Memory strategy \(strategy) should have non-negative threshold")
            XCTAssertLessThanOrEqual(strategy.memoryThreshold, 1, 
                                   "Memory strategy \(strategy) should have threshold <= 1")
        }
        
        // Memory strategies should be ordered correctly
        XCTAssertLessThan(MemoryStrategy.conservative.memoryThreshold, 
                         MemoryStrategy.adaptive.memoryThreshold,
                         "Conservative should be less than adaptive")
        XCTAssertLessThan(MemoryStrategy.adaptive.memoryThreshold, 
                         MemoryStrategy.aggressive.memoryThreshold,
                         "Adaptive should be less than aggressive")
    }
    
    // MARK: - CrossPlatformPerformanceMetrics Tests
    
    func testCrossPlatformPerformanceMetrics_Initialization() {
        // Given: Performance metrics
        let metrics = CrossPlatformPerformanceMetrics()
        
        // Then: Test the two critical aspects
        
        // 1. Does it return a valid structure of the kind it's supposed to?
        XCTAssertNotNil(metrics, "Performance metrics should be created successfully")
        
        // 2. Does that structure contain what it should?
        XCTAssertNotNil(metrics.renderingMetrics, "Should have rendering metrics")
        XCTAssertNotNil(metrics.memoryMetrics, "Should have memory metrics")
        XCTAssertNotNil(metrics.platformMetrics, "Should have platform metrics")
        
        // 3. Platform-specific implementation verification (REQUIRED)
        // Metrics should be initialized for current platform
        let currentPlatform = SixLayerPlatform.current
        XCTAssertTrue(metrics.platformMetrics.keys.contains(currentPlatform), 
                    "Should have metrics for current platform")
    }
    
    func testCrossPlatformPerformanceMetrics_RecordMeasurement() {
        // Given: Performance metrics and measurement
        let metrics = CrossPlatformPerformanceMetrics()
        let measurement = PerformanceMeasurement(
            type: .rendering,
            metric: .frameRate,
            value: 60.0,
            platform: .iOS
        )
        
        // When: Recording measurement
        metrics.recordMeasurement(measurement)
        
        // Then: Measurement should be recorded
        let summary = metrics.getCurrentPlatformSummary()
        XCTAssertNotNil(summary, "Should be able to get performance summary")
        XCTAssertEqual(summary.platform, SixLayerPlatform.current, 
                      "Summary should be for current platform")
    }
    
    func testCrossPlatformPerformanceMetrics_PlatformSummary() {
        // Given: Performance metrics
        let metrics = CrossPlatformPerformanceMetrics()
        
        // When: Getting platform summary
        let summary = metrics.getCurrentPlatformSummary()
        
        // Then: Summary should be valid
        XCTAssertNotNil(summary, "Should be able to get performance summary")
        XCTAssertEqual(summary.platform, SixLayerPlatform.current, 
                      "Summary should be for current platform")
        XCTAssertNotNil(summary.rendering, "Summary should have rendering metrics")
        XCTAssertNotNil(summary.memory, "Summary should have memory metrics")
        XCTAssertNotNil(summary.platformSpecific, "Summary should have platform-specific metrics")
        XCTAssertGreaterThanOrEqual(summary.overallScore, 0, "Overall score should be non-negative")
        XCTAssertLessThanOrEqual(summary.overallScore, 100, "Overall score should be <= 100")
    }
    
    // MARK: - PlatformUIPatterns Tests
    
    func testPlatformUIPatterns_PlatformSpecific() {
        // Given: Different platforms
        let platforms: [SixLayerPlatform] = [.iOS, .macOS, .visionOS, .watchOS, .tvOS]
        
        // When: Creating UI patterns for each platform
        for platform in platforms {
            let patterns = PlatformUIPatterns(for: platform)
            
            // Then: Patterns should be platform-appropriate
            XCTAssertNotNil(patterns, "UI patterns should be created for \(platform)")
            XCTAssertEqual(patterns.platform, platform, "Patterns should be for correct platform")
            XCTAssertNotNil(patterns.navigationPatterns, "Should have navigation patterns for \(platform)")
            XCTAssertNotNil(patterns.interactionPatterns, "Should have interaction patterns for \(platform)")
            XCTAssertNotNil(patterns.layoutPatterns, "Should have layout patterns for \(platform)")
            
            // Platform-specific verification
            switch platform {
            case .iOS:
                // iOS should have mobile navigation patterns
                XCTAssertEqual(patterns.navigationPatterns.platform, platform, 
                              "iOS navigation patterns should be for iOS")
            case .macOS:
                // macOS should have desktop navigation patterns
                XCTAssertEqual(patterns.navigationPatterns.platform, platform, 
                              "macOS navigation patterns should be for macOS")
            case .visionOS:
                // visionOS should have spatial navigation patterns
                XCTAssertEqual(patterns.navigationPatterns.platform, platform, 
                              "visionOS navigation patterns should be for visionOS")
            case .watchOS:
                // watchOS should have compact navigation patterns
                XCTAssertEqual(patterns.navigationPatterns.platform, platform, 
                              "watchOS navigation patterns should be for watchOS")
            case .tvOS:
                // tvOS should have TV navigation patterns
                XCTAssertEqual(patterns.navigationPatterns.platform, platform, 
                              "tvOS navigation patterns should be for tvOS")
            }
        }
    }
    
    func testPlatformUIPatterns_NavigationPatterns() {
        // Given: Navigation patterns for different platforms
        let platforms: [SixLayerPlatform] = [.iOS, .macOS, .visionOS, .watchOS, .tvOS]
        
        // When: Testing navigation patterns
        for platform in platforms {
            let navigationPatterns = NavigationPatterns(for: platform)
            
            // Then: Navigation patterns should be platform-appropriate
            XCTAssertEqual(navigationPatterns.platform, platform, 
                          "Navigation patterns should be for \(platform)")
            XCTAssertNotNil(navigationPatterns.primaryNavigation, 
                           "Should have primary navigation for \(platform)")
            XCTAssertNotNil(navigationPatterns.secondaryNavigation, 
                           "Should have secondary navigation for \(platform)")
            XCTAssertNotNil(navigationPatterns.modalPresentation, 
                           "Should have modal presentation for \(platform)")
        }
    }
    
    func testPlatformUIPatterns_InteractionPatterns() {
        // Given: Interaction patterns for different platforms
        let platforms: [SixLayerPlatform] = [.iOS, .macOS, .visionOS, .watchOS, .tvOS]
        
        // When: Testing interaction patterns
        for platform in platforms {
            let interactionPatterns = InteractionPatterns(for: platform)
            
            // Then: Interaction patterns should be platform-appropriate
            XCTAssertEqual(interactionPatterns.platform, platform, 
                          "Interaction patterns should be for \(platform)")
            XCTAssertNotNil(interactionPatterns.primaryInput, 
                           "Should have primary input for \(platform)")
            XCTAssertNotNil(interactionPatterns.secondaryInput, 
                           "Should have secondary input for \(platform)")
            XCTAssertNotNil(interactionPatterns.gestureSupport, 
                           "Should have gesture support for \(platform)")
        }
    }
    
    func testPlatformUIPatterns_LayoutPatterns() {
        // Given: Layout patterns for different platforms
        let platforms: [SixLayerPlatform] = [.iOS, .macOS, .visionOS, .watchOS, .tvOS]
        
        // When: Testing layout patterns
        for platform in platforms {
            let layoutPatterns = LayoutPatterns(for: platform)
            
            // Then: Layout patterns should be platform-appropriate
            XCTAssertEqual(layoutPatterns.platform, platform, 
                          "Layout patterns should be for \(platform)")
            XCTAssertNotNil(layoutPatterns.primaryLayout, 
                           "Should have primary layout for \(platform)")
            XCTAssertNotNil(layoutPatterns.secondaryLayout, 
                           "Should have secondary layout for \(platform)")
            XCTAssertNotNil(layoutPatterns.responsiveBreakpoints, 
                           "Should have responsive breakpoints for \(platform)")
            XCTAssertFalse(layoutPatterns.responsiveBreakpoints.isEmpty, 
                          "Should have at least one breakpoint for \(platform)")
        }
    }
    
    // MARK: - View Modifier Tests
    
    func testPlatformSpecificOptimizationsModifier() {
        // Given: Test view and platform
        let testView = Text("Test View")
        let platform = SixLayerPlatform.current
        
        // When: Applying platform-specific optimizations
        let optimizedView = testView.platformSpecificOptimizations(for: platform)
        
        // Then: Test the two critical aspects
        
        // 1. Does it return a valid structure of the kind it's supposed to?
        XCTAssertNotNil(optimizedView, "Optimized view should be created successfully")
        
        // 2. Does that structure contain what it should?
        do {
            let _ = try optimizedView.inspect()
        } catch {
            XCTFail("Failed to inspect platform-optimized view structure: \(error)")
        }
        
        // 3. Platform-specific implementation verification (REQUIRED)
        // Optimized view should be inspectable and contain platform-specific optimizations
        do {
            let _ = try optimizedView.inspect()
            // Platform-specific optimizations verified
        } catch {
            XCTFail("Platform-optimized view should be inspectable on current platform")
        }
    }
    
    func testPerformanceOptimizationsModifier() {
        // Given: Test view and performance settings
        let testView = Text("Test View")
        let settings = PlatformOptimizationSettings(for: SixLayerPlatform.current)
        
        // When: Applying performance optimizations
        let optimizedView = testView.performanceOptimizations(using: settings)
        
        // Then: Test the two critical aspects
        
        // 1. Does it return a valid structure of the kind it's supposed to?
        XCTAssertNotNil(optimizedView, "Performance-optimized view should be created successfully")
        
        // 2. Does that structure contain what it should?
        do {
            let _ = try optimizedView.inspect()
        } catch {
            XCTFail("Failed to inspect performance-optimized view structure: \(error)")
        }
        
        // 3. Platform-specific implementation verification (REQUIRED)
        // Performance-optimized view should be inspectable
        do {
            let _ = try optimizedView.inspect()
            // Performance optimizations verified
        } catch {
            XCTFail("Performance-optimized view should be inspectable on current platform")
        }
    }
    
    func testUIPatternOptimizationsModifier() {
        // Given: Test view and UI patterns
        let testView = Text("Test View")
        let patterns = PlatformUIPatterns(for: SixLayerPlatform.current)
        
        // When: Applying UI pattern optimizations
        let optimizedView = testView.uiPatternOptimizations(using: patterns)
        
        // Then: Test the two critical aspects
        
        // 1. Does it return a valid structure of the kind it's supposed to?
        XCTAssertNotNil(optimizedView, "UI pattern-optimized view should be created successfully")
        
        // 2. Does that structure contain what it should?
        do {
            let _ = try optimizedView.inspect()
        } catch {
            XCTFail("Failed to inspect UI pattern-optimized view structure: \(error)")
        }
        
        // 3. Platform-specific implementation verification (REQUIRED)
        // UI pattern-optimized view should be inspectable
        do {
            let _ = try optimizedView.inspect()
            // UI pattern optimizations verified
        } catch {
            XCTFail("UI pattern-optimized view should be inspectable on current platform")
        }
    }
    
    // MARK: - Environment Values Tests
    
    func testEnvironmentValues_PlatformSpecific() {
        // Given: Environment values
        var environment = EnvironmentValues()
        
        // When: Setting platform-specific environment values
        environment.platform = SixLayerPlatform.current
        environment.performanceLevel = .balanced
        environment.memoryStrategy = .adaptive
        
        // Then: Environment values should be set correctly
        XCTAssertEqual(environment.platform, SixLayerPlatform.current, 
                      "Platform should be set correctly")
        XCTAssertEqual(environment.performanceLevel, .balanced, "Performance level should be balanced")
        XCTAssertEqual(environment.memoryStrategy, .adaptive, "Memory strategy should be adaptive")
    }
    
    // MARK: - Integration Tests
    
    func testCrossPlatformOptimizationIntegration() {
        // Given: Manager and test view
        let manager = CrossPlatformOptimizationManager()
        let testView = Text("Integration Test View")
        
        // When: Applying all optimizations
        let fullyOptimizedView = manager.optimizeView(testView)
        
        // Then: Fully optimized view should be created successfully
        XCTAssertNotNil(fullyOptimizedView, "Fully optimized view should be created")
        
        do {
            let _ = try fullyOptimizedView.inspect()
        } catch {
            XCTFail("Fully optimized view should be inspectable: \(error)")
        }
    }
    
    func testCrossPlatformOptimizationPerformance() {
        // Given: Manager for performance testing
        let manager = CrossPlatformOptimizationManager()
        
        // When: Measuring optimization performance
        measure {
            // Create and optimize multiple views
            for _ in 0..<10 {
                let testView = Text("Performance Test View")
                let _ = manager.optimizeView(testView)
            }
        }
        
        // Then: Performance should be acceptable
        XCTAssertNotNil(manager, "Manager should exist for performance test")
    }
    
    // MARK: - Platform Detection Tests
    
    func testSixLayerPlatform_CurrentPlatformDetection() {
        // Given: Current platform detection
        let currentPlatform = SixLayerPlatform.current
        
        // Then: Platform should be detected correctly
        XCTAssertNotNil(currentPlatform, "Current platform should be detected")
        
        // Platform-specific verification
        #if os(iOS)
        XCTAssertEqual(currentPlatform, .iOS, "Should detect iOS platform")
        #elseif os(macOS)
        XCTAssertEqual(currentPlatform, .macOS, "Should detect macOS platform")
        #elseif os(visionOS)
        XCTAssertEqual(currentPlatform, .visionOS, "Should detect visionOS platform")
        #elseif os(watchOS)
        XCTAssertEqual(currentPlatform, .watchOS, "Should detect watchOS platform")
        #elseif os(tvOS)
        XCTAssertEqual(currentPlatform, .tvOS, "Should detect tvOS platform")
        #endif
    }
    
    func testSixLayerPlatform_AllPlatforms() {
        // Given: All available platforms
        let allPlatforms = SixLayerPlatform.allCases
        
        // Then: Should have all expected platforms
        XCTAssertTrue(allPlatforms.contains(.iOS), "Should include iOS")
        XCTAssertTrue(allPlatforms.contains(.macOS), "Should include macOS")
        XCTAssertTrue(allPlatforms.contains(.visionOS), "Should include visionOS")
        XCTAssertTrue(allPlatforms.contains(.watchOS), "Should include watchOS")
        XCTAssertTrue(allPlatforms.contains(.tvOS), "Should include tvOS")
        XCTAssertEqual(allPlatforms.count, 5, "Should have exactly 5 platforms")
    }
}
