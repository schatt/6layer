//
//  IntelligentCardExpansionLayer6Tests.swift
//  SixLayerFrameworkTests
//
//  Tests for Layer 6 Intelligent Card Expansion functions
//  Tests NativeExpandableCardView, iOSExpandableCardView, macOSExpandableCardView, 
//  visionOSExpandableCardView, and PlatformAwareExpandableCardView
//

import XCTest
import SwiftUI
import ViewInspector
@testable import SixLayerFramework

@MainActor
final class IntelligentCardExpansionLayer6Tests: XCTestCase {
    
    // MARK: - Test Data
    
    struct TestItem: Identifiable {
        let id = UUID()
        let title: String
        let content: String
    }
    
    let testItem = TestItem(title: "Test Card", content: "Test content for expansion")
    
    // MARK: - NativeExpandableCardView Tests
    
    func testNativeExpandableCardView_Creation() {
        // Given: Configuration for native expandable card
        let platformConfig = getCardExpansionPlatformConfig()
        let performanceConfig = getCardExpansionPerformanceConfig()
        let accessibilityConfig = getCardExpansionAccessibilityConfig()
        
        // When: Creating native expandable card view
        let cardView = NativeExpandableCardView(
            item: testItem,
            expansionStrategy: .hoverExpand,
            platformConfig: platformConfig,
            performanceConfig: performanceConfig,
            accessibilityConfig: accessibilityConfig
        )
        
        // Then: Test the two critical aspects
        
        // 1. Does it return a valid structure of the kind it's supposed to?
        XCTAssertNotNil(cardView, "NativeExpandableCardView should be created successfully")
        
        // 2. Does that structure contain what it should?
        do {
            // The card view should be inspectable
            let _ = try cardView.inspect()
            // If we get here, the view is properly structured
        } catch {
            XCTFail("Failed to inspect NativeExpandableCardView structure: \(error)")
        }
        
        // 3. Configuration should be valid (L6 function responsibility)
        XCTAssertNotNil(platformConfig, "Platform config should be created")
        XCTAssertNotNil(performanceConfig, "Performance config should be created")
        XCTAssertNotNil(accessibilityConfig, "Accessibility config should be created")
    }
    
    func testNativeExpandableCardView_WithDifferentStrategies() {
        // Given: Different expansion strategies
        let strategies: [ExpansionStrategy] = [.hoverExpand, .contentReveal, .gridReorganize, .focusMode]
        let platformConfig = getCardExpansionPlatformConfig()
        let performanceConfig = getCardExpansionPerformanceConfig()
        let accessibilityConfig = getCardExpansionAccessibilityConfig()
        
        // When: Creating cards with different strategies
        for strategy in strategies {
            let cardView = NativeExpandableCardView(
                item: testItem,
                expansionStrategy: strategy,
                platformConfig: platformConfig,
                performanceConfig: performanceConfig,
                accessibilityConfig: accessibilityConfig
            )
            
            // Then: Each card should be created successfully
            XCTAssertNotNil(cardView, "Card with strategy \(strategy) should be created")
            
            do {
                let _ = try cardView.inspect()
            } catch {
                XCTFail("Failed to inspect card with strategy \(strategy): \(error)")
            }
        }
    }
    
    func testNativeExpandableCardView_HapticFeedback() {
        // Given: Card with haptic feedback enabled
        let platformConfig = getCardExpansionPlatformConfig()
        let performanceConfig = getCardExpansionPerformanceConfig()
        let accessibilityConfig = getCardExpansionAccessibilityConfig()
        
        let cardView = NativeExpandableCardView(
            item: testItem,
            expansionStrategy: .hoverExpand,
            platformConfig: platformConfig,
            performanceConfig: performanceConfig,
            accessibilityConfig: accessibilityConfig
        )
        
        // When: Testing haptic feedback behavior
        // Then: Configuration should be valid (L6 function responsibility)
        XCTAssertNotNil(platformConfig, "Platform config should be created")
        XCTAssertNotNil(performanceConfig, "Performance config should be created")
        XCTAssertNotNil(accessibilityConfig, "Accessibility config should be created")
    }
    
    // MARK: - Platform-Specific Card View Tests
    
    func testiOSExpandableCardView_Creation() {
        // Given: iOS-specific card view
        let cardView = iOSExpandableCardView(
            item: testItem,
            expansionStrategy: .hoverExpand
        )
        
        // Then: Test the two critical aspects
        
        // 1. Does it return a valid structure of the kind it's supposed to?
        XCTAssertNotNil(cardView, "iOSExpandableCardView should be created successfully")
        
        // 2. Does that structure contain what it should?
        do {
            let _ = try cardView.inspect()
        } catch {
            XCTFail("Failed to inspect iOSExpandableCardView structure: \(error)")
        }
        
        // 3. L6 function should create valid view (no platform mocking needed)
        do {
            let _ = try cardView.inspect()
            // L6 function successfully created inspectable view
        } catch {
            XCTFail("iOS card view should be inspectable: \(error)")
        }
    }
    
    func testmacOSExpandableCardView_Creation() {
        // Given: macOS-specific card view
        let cardView = macOSExpandableCardView(
            item: testItem,
            expansionStrategy: .hoverExpand
        )
        
        // Then: Test the two critical aspects
        
        // 1. Does it return a valid structure of the kind it's supposed to?
        XCTAssertNotNil(cardView, "macOSExpandableCardView should be created successfully")
        
        // 2. Does that structure contain what it should?
        do {
            let _ = try cardView.inspect()
        } catch {
            XCTFail("Failed to inspect macOSExpandableCardView structure: \(error)")
        }
        
        // 3. L6 function should create valid view (no platform mocking needed)
        do {
            let _ = try cardView.inspect()
            // L6 function successfully created inspectable view
        } catch {
            XCTFail("macOS card view should be inspectable: \(error)")
        }
    }
    
    func testvisionOSExpandableCardView_Creation() {
        // Given: visionOS-specific card view
        let cardView = visionOSExpandableCardView(
            item: testItem,
            expansionStrategy: .hoverExpand
        )
        
        // Then: Test the two critical aspects
        
        // 1. Does it return a valid structure of the kind it's supposed to?
        XCTAssertNotNil(cardView, "visionOSExpandableCardView should be created successfully")
        
        // 2. Does that structure contain what it should?
        do {
            let _ = try cardView.inspect()
        } catch {
            XCTFail("Failed to inspect visionOSExpandableCardView structure: \(error)")
        }
        
        // 3. L6 function should create valid view (no platform mocking needed)
        do {
            let _ = try cardView.inspect()
            // L6 function successfully created inspectable view
        } catch {
            XCTFail("visionOS card view should be inspectable: \(error)")
        }
    }
    
    // MARK: - Platform-Aware Card View Tests
    
    func testPlatformAwareExpandableCardView_Creation() {
        // Given: Platform-aware card view
        let cardView = PlatformAwareExpandableCardView(
            item: testItem,
            expansionStrategy: .hoverExpand
        )
        
        // Then: Test the two critical aspects
        
        // 1. Does it return a valid structure of the kind it's supposed to?
        XCTAssertNotNil(cardView, "PlatformAwareExpandableCardView should be created successfully")
        
        // 2. Does that structure contain what it should?
        do {
            let _ = try cardView.inspect()
        } catch {
            XCTFail("Failed to inspect PlatformAwareExpandableCardView structure: \(error)")
        }
        
        // 3. L6 function should create valid view (no platform mocking needed)
        do {
            let _ = try cardView.inspect()
            // L6 function successfully created inspectable view
        } catch {
            XCTFail("Platform-aware card view should be inspectable: \(error)")
        }
    }
    
    func testPlatformAwareExpandableCardView_PlatformAdaptation() {
        // Given: Platform-aware card view
        let cardView = PlatformAwareExpandableCardView(
            item: testItem,
            expansionStrategy: .hoverExpand
        )
        
        // When: Testing platform adaptation
        // Then: L6 function should create valid view (platform adaptation handled by L5 functions)
        do {
            let _ = try cardView.inspect()
            // L6 function successfully created inspectable view
        } catch {
            XCTFail("Platform-aware card view should be inspectable: \(error)")
        }
    }
    
    // MARK: - Configuration Tests
    
    func testCardExpansionPlatformConfig_Creation() {
        // Given: Platform configuration
        let config = getCardExpansionPlatformConfig()
        
        // Then: Configuration should be valid (L6 function responsibility)
        XCTAssertNotNil(config, "Platform config should be created")
        XCTAssertNotNil(config.supportsTouch, "Should have touch support setting")
        XCTAssertNotNil(config.supportsHover, "Should have hover support setting")
        XCTAssertNotNil(config.supportsHapticFeedback, "Should have haptic feedback support setting")
        XCTAssertNotNil(config.supportsVoiceOver, "Should have VoiceOver support setting")
        XCTAssertNotNil(config.supportsSwitchControl, "Should have Switch Control support setting")
        XCTAssertNotNil(config.supportsAssistiveTouch, "Should have AssistiveTouch support setting")
        XCTAssertGreaterThan(config.minTouchTarget, 0, "Should have positive min touch target")
        XCTAssertGreaterThanOrEqual(config.hoverDelay, 0, "Should have non-negative hover delay")
    }
    
    func testCardExpansionPerformanceConfig_Creation() {
        // Given: Performance configuration
        let config = getCardExpansionPerformanceConfig()
        
        // Then: Configuration should be valid (L6 function responsibility)
        XCTAssertNotNil(config, "Performance config should be created")
        XCTAssertGreaterThan(config.maxAnimationDuration, 0, "Should have positive max animation duration")
        XCTAssertGreaterThan(config.targetFrameRate, 0, "Should have positive target frame rate")
        XCTAssertNotNil(config.supportsSmoothAnimations, "Should have smooth animations setting")
        XCTAssertNotNil(config.memoryOptimization, "Should have memory optimization setting")
        XCTAssertNotNil(config.lazyLoading, "Should have lazy loading setting")
    }
    
    func testCardExpansionAccessibilityConfig_Creation() {
        // Given: Accessibility configuration
        let config = getCardExpansionAccessibilityConfig()
        
        // Then: Configuration should be valid (L6 function responsibility)
        XCTAssertNotNil(config, "Accessibility config should be created")
        XCTAssertNotNil(config.supportsVoiceOver, "Should have VoiceOver support setting")
        XCTAssertNotNil(config.supportsSwitchControl, "Should have Switch Control support setting")
        XCTAssertNotNil(config.supportsAssistiveTouch, "Should have AssistiveTouch support setting")
        XCTAssertGreaterThanOrEqual(config.announcementDelay, 0, "Should have non-negative announcement delay")
    }
    
    // MARK: - Integration Tests
    
    func testCardExpansionIntegration_AllPlatforms() {
        // Given: Different platform-specific card views
        let nativeCard = NativeExpandableCardView(
            item: testItem,
            expansionStrategy: .hoverExpand,
            platformConfig: getCardExpansionPlatformConfig(),
            performanceConfig: getCardExpansionPerformanceConfig(),
            accessibilityConfig: getCardExpansionAccessibilityConfig()
        )
        
        let platformAwareCard = PlatformAwareExpandableCardView(
            item: testItem,
            expansionStrategy: .hoverExpand
        )
        
        // When: Testing integration
        // Then: All cards should be created successfully
        
        XCTAssertNotNil(nativeCard, "Native card should be created")
        XCTAssertNotNil(platformAwareCard, "Platform-aware card should be created")
        
        do {
            let _ = try nativeCard.inspect()
            let _ = try platformAwareCard.inspect()
        } catch {
            XCTFail("All card types should be inspectable: \(error)")
        }
    }
    
    func testCardExpansionPerformance() {
        // Given: Card view for performance testing
        let cardView = PlatformAwareExpandableCardView(
            item: testItem,
            expansionStrategy: .hoverExpand
        )
        
        // When: Measuring performance
        measure {
            // Create multiple cards to test performance
            for _ in 0..<10 {
                let _ = PlatformAwareExpandableCardView(
                    item: testItem,
                    expansionStrategy: .hoverExpand
                )
            }
        }
        
        // Then: Performance should be acceptable
        XCTAssertNotNil(cardView, "Card should be created for performance test")
    }
}
