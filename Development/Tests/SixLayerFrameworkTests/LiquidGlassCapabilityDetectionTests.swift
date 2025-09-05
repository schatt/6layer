//
//  LiquidGlassCapabilityDetectionTests.swift
//  SixLayerFrameworkTests
//
//  Tests for Liquid Glass capability detection system
//

import XCTest
@testable import SixLayerFramework

final class LiquidGlassCapabilityDetectionTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Basic Capability Tests
    
    func testLiquidGlassSupportDetection() {
        // Given & When
        let isSupported = LiquidGlassCapabilityDetection.isSupported
        
        // Then
        // This will be false on current platforms since iOS 26/macOS 26 don't exist yet
        XCTAssertFalse(isSupported, "Liquid Glass should not be supported on current platforms")
    }
    
    func testSupportLevelDetection() {
        // Given & When
        let supportLevel = LiquidGlassCapabilityDetection.supportLevel
        
        // Then
        // Should be fallback on current platforms
        XCTAssertEqual(supportLevel, .fallback, "Current platforms should use fallback support level")
    }
    
    func testHardwareRequirementsSupport() {
        // Given & When
        let supportsHardware = LiquidGlassCapabilityDetection.supportsHardwareRequirements
        
        // Then
        // This should be true on current platforms (simplified implementation)
        XCTAssertTrue(supportsHardware, "Current platforms should support hardware requirements")
    }
    
    // MARK: - Feature Availability Tests
    
    func testFeatureAvailabilityForUnsupportedPlatform() {
        // Given
        let features: [LiquidGlassFeature] = [.materials, .floatingControls, .contextualMenus, .adaptiveWallpapers, .dynamicReflections]
        
        // When & Then
        for feature in features {
            let isAvailable = LiquidGlassCapabilityDetection.isFeatureAvailable(feature)
            XCTAssertFalse(isAvailable, "Feature \(feature.rawValue) should not be available on current platforms")
        }
    }
    
    func testAllFeaturesHaveFallbackBehaviors() {
        // Given
        let features = LiquidGlassFeature.allCases
        
        // When & Then
        for feature in features {
            let fallbackBehavior = LiquidGlassCapabilityDetection.getFallbackBehavior(for: feature)
            XCTAssertNotNil(fallbackBehavior, "Feature \(feature.rawValue) should have a fallback behavior")
        }
    }
    
    func testFallbackBehaviorsAreAppropriate() {
        // Given & When
        let materialFallback = LiquidGlassCapabilityDetection.getFallbackBehavior(for: .materials)
        let controlFallback = LiquidGlassCapabilityDetection.getFallbackBehavior(for: .floatingControls)
        let menuFallback = LiquidGlassCapabilityDetection.getFallbackBehavior(for: .contextualMenus)
        let wallpaperFallback = LiquidGlassCapabilityDetection.getFallbackBehavior(for: .adaptiveWallpapers)
        let reflectionFallback = LiquidGlassCapabilityDetection.getFallbackBehavior(for: .dynamicReflections)
        
        // Then
        XCTAssertEqual(materialFallback, .opaqueBackground, "Materials should fallback to opaque background")
        XCTAssertEqual(controlFallback, .standardControls, "Floating controls should fallback to standard controls")
        XCTAssertEqual(menuFallback, .standardMenus, "Contextual menus should fallback to standard menus")
        XCTAssertEqual(wallpaperFallback, .staticWallpapers, "Adaptive wallpapers should fallback to static wallpapers")
        XCTAssertEqual(reflectionFallback, .noReflections, "Dynamic reflections should fallback to no reflections")
    }
    
    // MARK: - Capability Info Tests
    
    func testCapabilityInfoCreation() {
        // Given & When
        let capabilityInfo = LiquidGlassCapabilityInfo()
        
        // Then
        XCTAssertFalse(capabilityInfo.isSupported, "Capability info should reflect unsupported status")
        XCTAssertEqual(capabilityInfo.supportLevel, .fallback, "Support level should be fallback")
        XCTAssertTrue(capabilityInfo.availableFeatures.isEmpty, "No features should be available on current platforms")
        XCTAssertEqual(capabilityInfo.fallbackBehaviors.count, LiquidGlassFeature.allCases.count, "All features should have fallback behaviors")
    }
    
    func testCapabilityInfoFallbackBehaviors() {
        // Given
        let capabilityInfo = LiquidGlassCapabilityInfo()
        
        // When & Then
        for feature in LiquidGlassFeature.allCases {
            let fallbackBehavior = capabilityInfo.fallbackBehaviors[feature]
            XCTAssertNotNil(fallbackBehavior, "Feature \(feature.rawValue) should have a fallback behavior")
        }
    }
    
    // MARK: - Platform-Specific Tests
    
    func testPlatformCapabilities() {
        // Given & When
        let platformCapabilities = LiquidGlassCapabilityDetection.getPlatformCapabilities()
        
        // Then
        XCTAssertFalse(platformCapabilities.isSupported, "Platform capabilities should reflect unsupported status")
        XCTAssertEqual(platformCapabilities.supportLevel, .fallback, "Platform support level should be fallback")
    }
    
    func testRecommendedFallbackApproach() {
        // Given & When
        let approach = LiquidGlassCapabilityDetection.recommendedFallbackApproach
        
        // Then
        XCTAssertTrue(approach.contains("standard UI components"), "Recommended approach should mention standard UI components")
        XCTAssertFalse(approach.contains("full Liquid Glass"), "Recommended approach should not mention full Liquid Glass on current platforms")
    }
    
    // MARK: - Support Level Tests
    
    func testSupportLevelCases() {
        // Given
        let allCases = LiquidGlassSupportLevel.allCases
        
        // Then
        XCTAssertEqual(allCases.count, 3, "Should have 3 support levels")
        XCTAssertTrue(allCases.contains(.full), "Should include full support level")
        XCTAssertTrue(allCases.contains(.fallback), "Should include fallback support level")
        XCTAssertTrue(allCases.contains(.unsupported), "Should include unsupported support level")
    }
    
    func testSupportLevelRawValues() {
        // Given & When
        let full = LiquidGlassSupportLevel.full
        let fallback = LiquidGlassSupportLevel.fallback
        let unsupported = LiquidGlassSupportLevel.unsupported
        
        // Then
        XCTAssertEqual(full.rawValue, "full")
        XCTAssertEqual(fallback.rawValue, "fallback")
        XCTAssertEqual(unsupported.rawValue, "unsupported")
    }
    
    // MARK: - Feature Tests
    
    func testFeatureCases() {
        // Given
        let allCases = LiquidGlassFeature.allCases
        
        // Then
        XCTAssertEqual(allCases.count, 5, "Should have 5 features")
        XCTAssertTrue(allCases.contains(.materials), "Should include materials feature")
        XCTAssertTrue(allCases.contains(.floatingControls), "Should include floating controls feature")
        XCTAssertTrue(allCases.contains(.contextualMenus), "Should include contextual menus feature")
        XCTAssertTrue(allCases.contains(.adaptiveWallpapers), "Should include adaptive wallpapers feature")
        XCTAssertTrue(allCases.contains(.dynamicReflections), "Should include dynamic reflections feature")
    }
    
    func testFeatureRawValues() {
        // Given & When
        let materials = LiquidGlassFeature.materials
        let floatingControls = LiquidGlassFeature.floatingControls
        let contextualMenus = LiquidGlassFeature.contextualMenus
        let adaptiveWallpapers = LiquidGlassFeature.adaptiveWallpapers
        let dynamicReflections = LiquidGlassFeature.dynamicReflections
        
        // Then
        XCTAssertEqual(materials.rawValue, "materials")
        XCTAssertEqual(floatingControls.rawValue, "floatingControls")
        XCTAssertEqual(contextualMenus.rawValue, "contextualMenus")
        XCTAssertEqual(adaptiveWallpapers.rawValue, "adaptiveWallpapers")
        XCTAssertEqual(dynamicReflections.rawValue, "dynamicReflections")
    }
    
    // MARK: - Fallback Behavior Tests
    
    func testFallbackBehaviorCases() {
        // Given
        let allCases = LiquidGlassFallbackBehavior.allCases
        
        // Then
        XCTAssertEqual(allCases.count, 5, "Should have 5 fallback behaviors")
        XCTAssertTrue(allCases.contains(.opaqueBackground), "Should include opaque background behavior")
        XCTAssertTrue(allCases.contains(.standardControls), "Should include standard controls behavior")
        XCTAssertTrue(allCases.contains(.standardMenus), "Should include standard menus behavior")
        XCTAssertTrue(allCases.contains(.staticWallpapers), "Should include static wallpapers behavior")
        XCTAssertTrue(allCases.contains(.noReflections), "Should include no reflections behavior")
    }
    
    func testFallbackBehaviorRawValues() {
        // Given & When
        let opaqueBackground = LiquidGlassFallbackBehavior.opaqueBackground
        let standardControls = LiquidGlassFallbackBehavior.standardControls
        let standardMenus = LiquidGlassFallbackBehavior.standardMenus
        let staticWallpapers = LiquidGlassFallbackBehavior.staticWallpapers
        let noReflections = LiquidGlassFallbackBehavior.noReflections
        
        // Then
        XCTAssertEqual(opaqueBackground.rawValue, "opaqueBackground")
        XCTAssertEqual(standardControls.rawValue, "standardControls")
        XCTAssertEqual(standardMenus.rawValue, "standardMenus")
        XCTAssertEqual(staticWallpapers.rawValue, "staticWallpapers")
        XCTAssertEqual(noReflections.rawValue, "noReflections")
    }
    
    // MARK: - Edge Case Tests
    
    func testCapabilityDetectionConsistency() {
        // Given & When
        let isSupported1 = LiquidGlassCapabilityDetection.isSupported
        let isSupported2 = LiquidGlassCapabilityDetection.isSupported
        let supportLevel1 = LiquidGlassCapabilityDetection.supportLevel
        let supportLevel2 = LiquidGlassCapabilityDetection.supportLevel
        
        // Then
        XCTAssertEqual(isSupported1, isSupported2, "Support detection should be consistent")
        XCTAssertEqual(supportLevel1, supportLevel2, "Support level should be consistent")
    }
    
    func testFeatureAvailabilityConsistency() {
        // Given
        let features = LiquidGlassFeature.allCases
        
        // When & Then
        for feature in features {
            let isAvailable1 = LiquidGlassCapabilityDetection.isFeatureAvailable(feature)
            let isAvailable2 = LiquidGlassCapabilityDetection.isFeatureAvailable(feature)
            XCTAssertEqual(isAvailable1, isAvailable2, "Feature availability should be consistent for \(feature.rawValue)")
        }
    }
    
    func testFallbackBehaviorConsistency() {
        // Given
        let features = LiquidGlassFeature.allCases
        
        // When & Then
        for feature in features {
            let behavior1 = LiquidGlassCapabilityDetection.getFallbackBehavior(for: feature)
            let behavior2 = LiquidGlassCapabilityDetection.getFallbackBehavior(for: feature)
            XCTAssertEqual(behavior1, behavior2, "Fallback behavior should be consistent for \(feature.rawValue)")
        }
    }
    
    // MARK: - Performance Tests
    
    func testCapabilityDetectionPerformance() {
        // Given
        let iterations = 1000
        
        // When
        let startTime = CFAbsoluteTimeGetCurrent()
        for _ in 0..<iterations {
            _ = LiquidGlassCapabilityDetection.isSupported
            _ = LiquidGlassCapabilityDetection.supportLevel
        }
        let endTime = CFAbsoluteTimeGetCurrent()
        
        // Then
        let executionTime = endTime - startTime
        XCTAssertLessThan(executionTime, 0.1, "Capability detection should be fast (under 100ms for 1000 iterations)")
    }
    
    func testFeatureAvailabilityPerformance() {
        // Given
        let features = LiquidGlassFeature.allCases
        let iterations = 100
        
        // When
        let startTime = CFAbsoluteTimeGetCurrent()
        for _ in 0..<iterations {
            for feature in features {
                _ = LiquidGlassCapabilityDetection.isFeatureAvailable(feature)
                _ = LiquidGlassCapabilityDetection.getFallbackBehavior(for: feature)
            }
        }
        let endTime = CFAbsoluteTimeGetCurrent()
        
        // Then
        let executionTime = endTime - startTime
        XCTAssertLessThan(executionTime, 0.05, "Feature availability checks should be fast (under 50ms for 100 iterations)")
    }
}
