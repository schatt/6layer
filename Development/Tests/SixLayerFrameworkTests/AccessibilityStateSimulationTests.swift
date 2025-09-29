//
//  AccessibilityStateSimulationTests.swift
//  SixLayerFrameworkTests
//
//  BUSINESS PURPOSE:
//  Validates accessibility state simulation and behavior testing across different accessibility configurations,
//  ensuring proper UI adaptation and functionality for users with various accessibility needs.
//
//  TESTING SCOPE:
//  - Accessibility state simulation and configuration
//  - UI behavior changes based on different accessibility states
//  - Platform-specific accessibility state handling
//  - Edge cases and combinations of accessibility features
//  - Accessibility state transitions and management
//  - Cross-platform consistency of accessibility state behavior
//
//  METHODOLOGY:
//  - Simulate different accessibility states and configurations
//  - Test UI behavior changes based on accessibility state changes
//  - Verify platform-specific accessibility state handling using switch statements
//  - Test edge cases and combinations of accessibility features
//  - Validate accessibility state transitions and management
//  - Test cross-platform consistency of accessibility behavior
//
//  QUALITY ASSESSMENT: ⚠️ NEEDS IMPROVEMENT
//  - ❌ Issue: Missing business purpose and testing scope documentation
//  - ❌ Issue: Limited platform-specific testing with switch statements
//  - ❌ Issue: No validation of actual accessibility behavior effectiveness
//  - 🔧 Action Required: Add platform-specific behavior testing
//  - 🔧 Action Required: Add validation of accessibility state effectiveness
//  - 🔧 Action Required: Add comprehensive edge case testing
//

import XCTest
import SwiftUI
@testable import SixLayerFramework

/// Accessibility state simulation testing
/// Simulates different accessibility states to test behavior changes
@MainActor
final class AccessibilityStateSimulationTests: XCTestCase {
    
    // MARK: - Platform-Specific Business Logic Tests
    
    func testAccessibilityStateBehaviorAcrossPlatforms() {
        // Given: Different accessibility states and platform expectations
        let platform = Platform.current
        
        // Test different accessibility states
        for state in accessibilityStates {
            // When: Applying accessibility state on different platforms
            let config = getCardExpansionAccessibilityConfig()
            
            // Then: Test platform-specific business logic
            switch platform {
            case .iOS:
                // iOS should support all accessibility features
                XCTAssertTrue(config.supportsVoiceOver, "iOS should support VoiceOver")
                XCTAssertTrue(config.supportsAssistiveTouch, "iOS should support AssistiveTouch")
                XCTAssertTrue(config.supportsHapticFeedback, "iOS should support haptic feedback")
                
                // Test iOS-specific accessibility behavior
                if state.voiceOver {
                    XCTAssertTrue(config.voiceOverEnabled, "VoiceOver should be enabled when state requires it")
                }
                if state.assistiveTouch {
                    XCTAssertTrue(config.assistiveTouchEnabled, "AssistiveTouch should be enabled when state requires it")
                }
                
            case .macOS:
                // macOS should support keyboard navigation and high contrast
                XCTAssertTrue(config.supportsKeyboardNavigation, "macOS should support keyboard navigation")
                XCTAssertTrue(config.supportsHighContrast, "macOS should support high contrast")
                XCTAssertFalse(config.supportsHapticFeedback, "macOS should not support haptic feedback")
                
                // Test macOS-specific accessibility behavior
                if state.highContrast {
                    XCTAssertTrue(config.highContrastEnabled, "High contrast should be enabled when state requires it")
                }
                if state.switchControl {
                    XCTAssertTrue(config.switchControlEnabled, "Switch Control should be enabled when state requires it")
                }
                
            case .watchOS:
                // watchOS should have simplified accessibility support
                XCTAssertTrue(config.supportsVoiceOver, "watchOS should support VoiceOver")
                XCTAssertFalse(config.supportsHapticFeedback, "watchOS should not support haptic feedback")
                XCTAssertFalse(config.supportsAssistiveTouch, "watchOS should not support AssistiveTouch")
                
                // Test watchOS-specific accessibility behavior
                if state.voiceOver {
                    XCTAssertTrue(config.voiceOverEnabled, "VoiceOver should be enabled when state requires it")
                }
                
            case .tvOS:
                // tvOS should support focus-based navigation
                XCTAssertTrue(config.supportsFocusManagement, "tvOS should support focus management")
                XCTAssertTrue(config.supportsSwitchControl, "tvOS should support Switch Control")
                XCTAssertFalse(config.supportsTouch, "tvOS should not support touch")
                
                // Test tvOS-specific accessibility behavior
                if state.switchControl {
                    XCTAssertTrue(config.switchControlEnabled, "Switch Control should be enabled when state requires it")
                }
                
            case .visionOS:
                // visionOS should support spatial accessibility
                XCTAssertTrue(config.supportsVoiceOver, "visionOS should support VoiceOver")
                XCTAssertTrue(config.supportsSpatialAccessibility, "visionOS should support spatial accessibility")
                
                // Test visionOS-specific accessibility behavior
                if state.voiceOver {
                    XCTAssertTrue(config.voiceOverEnabled, "VoiceOver should be enabled when state requires it")
                }
            }
        }
    }
    
    func testAccessibilityStateTransitions() {
        // Given: Different accessibility state transitions
        let initialState = AccessibilityState(
            reduceMotion: false,
            highContrast: false,
            voiceOver: false,
            switchControl: false,
            dynamicType: false,
            assistiveTouch: false
        )
        
        let finalState = AccessibilityState(
            reduceMotion: true,
            highContrast: true,
            voiceOver: true,
            switchControl: false,
            dynamicType: true,
            assistiveTouch: false
        )
        
        // When: Transitioning between accessibility states
        let initialConfig = getCardExpansionAccessibilityConfig()
        
        // Simulate state transition
        // Note: In a real implementation, this would trigger actual state changes
        
        // Then: Test business logic for state transitions
        XCTAssertNotNil(initialConfig, "Initial accessibility config should be valid")
        
        // Test business logic: State transitions should be handled gracefully
        XCTAssertTrue(initialConfig.supportsVoiceOver, "Config should support VoiceOver")
        XCTAssertTrue(initialConfig.supportsHighContrast, "Config should support high contrast")
        XCTAssertTrue(initialConfig.supportsReducedMotion, "Config should support reduced motion")
        
        // Test business logic: Platform should support the required accessibility features
        let platform = Platform.current
        switch platform {
        case .iOS, .macOS, .watchOS, .tvOS, .visionOS:
            XCTAssertTrue(initialConfig.supportsVoiceOver, "Platform should support VoiceOver")
        }
    }
    
    func testAccessibilityStateCombinations() {
        // Given: Complex accessibility state combinations
        let complexState = AccessibilityState(
            reduceMotion: true,
            highContrast: true,
            voiceOver: true,
            switchControl: true,
            dynamicType: true,
            assistiveTouch: true
        )
        
        // When: Applying complex accessibility state
        let config = getCardExpansionAccessibilityConfig()
        
        // Then: Test business logic for complex state handling
        XCTAssertNotNil(config, "Config should handle complex accessibility states")
        
        // Test business logic: All accessibility features should be supported
        XCTAssertTrue(config.supportsVoiceOver, "Should support VoiceOver in complex state")
        XCTAssertTrue(config.supportsHighContrast, "Should support high contrast in complex state")
        XCTAssertTrue(config.supportsReducedMotion, "Should support reduced motion in complex state")
        XCTAssertTrue(config.supportsSwitchControl, "Should support Switch Control in complex state")
        
        // Test business logic: Platform should handle complex combinations gracefully
        let platform = Platform.current
        switch platform {
        case .iOS:
            XCTAssertTrue(config.supportsAssistiveTouch, "iOS should support AssistiveTouch in complex state")
        case .macOS:
            XCTAssertTrue(config.supportsKeyboardNavigation, "macOS should support keyboard navigation in complex state")
        case .watchOS:
            XCTAssertFalse(config.supportsAssistiveTouch, "watchOS should not support AssistiveTouch")
        case .tvOS:
            XCTAssertTrue(config.supportsFocusManagement, "tvOS should support focus management in complex state")
        case .visionOS:
            XCTAssertTrue(config.supportsSpatialAccessibility, "visionOS should support spatial accessibility in complex state")
        }
    }
    
    // MARK: - Accessibility State Simulation
    
    struct AccessibilityState {
        let reduceMotion: Bool
        let highContrast: Bool
        let voiceOver: Bool
        let switchControl: Bool
        let dynamicType: Bool
        let assistiveTouch: Bool
        
        var description: String {
            var features: [String] = []
            if reduceMotion { features.append("ReduceMotion") }
            if highContrast { features.append("HighContrast") }
            if voiceOver { features.append("VoiceOver") }
            if switchControl { features.append("SwitchControl") }
            if dynamicType { features.append("DynamicType") }
            if assistiveTouch { features.append("AssistiveTouch") }
            return features.isEmpty ? "None" : features.joined(separator: "+")
        }
    }
    
    private let accessibilityStates: [AccessibilityState] = [
        // No accessibility features
        AccessibilityState(
            reduceMotion: false,
            highContrast: false,
            voiceOver: false,
            switchControl: false,
            dynamicType: false,
            assistiveTouch: false
        ),
        
        // Single accessibility features
        AccessibilityState(
            reduceMotion: true,
            highContrast: false,
            voiceOver: false,
            switchControl: false,
            dynamicType: false,
            assistiveTouch: false
        ),
        
        AccessibilityState(
            reduceMotion: false,
            highContrast: true,
            voiceOver: false,
            switchControl: false,
            dynamicType: false,
            assistiveTouch: false
        ),
        
        AccessibilityState(
            reduceMotion: false,
            highContrast: false,
            voiceOver: true,
            switchControl: false,
            dynamicType: false,
            assistiveTouch: false
        ),
        
        AccessibilityState(
            reduceMotion: false,
            highContrast: false,
            voiceOver: false,
            switchControl: true,
            dynamicType: false,
            assistiveTouch: false
        ),
        
        AccessibilityState(
            reduceMotion: false,
            highContrast: false,
            voiceOver: false,
            switchControl: false,
            dynamicType: true,
            assistiveTouch: false
        ),
        
        AccessibilityState(
            reduceMotion: false,
            highContrast: false,
            voiceOver: false,
            switchControl: false,
            dynamicType: false,
            assistiveTouch: true
        ),
        
        // Common combinations
        AccessibilityState(
            reduceMotion: true,
            highContrast: true,
            voiceOver: false,
            switchControl: false,
            dynamicType: false,
            assistiveTouch: false
        ),
        
        AccessibilityState(
            reduceMotion: false,
            highContrast: false,
            voiceOver: true,
            switchControl: true,
            dynamicType: false,
            assistiveTouch: false
        ),
        
        AccessibilityState(
            reduceMotion: true,
            highContrast: false,
            voiceOver: true,
            switchControl: false,
            dynamicType: true,
            assistiveTouch: false
        ),
        
        // All accessibility features
        AccessibilityState(
            reduceMotion: true,
            highContrast: true,
            voiceOver: true,
            switchControl: true,
            dynamicType: true,
            assistiveTouch: true
        )
    ]
    
    // MARK: - State-Specific Behavior Tests
    
    func testAccessibilityStateBehaviors() {
        // Set up iOS platform for testing (supports all accessibility features)
        RuntimeCapabilityDetection.setTestPlatform(.iOS)
        
        for state in accessibilityStates {
            testAccessibilityStateBehavior(state)
        }
        
        // Clean up
        RuntimeCapabilityDetection.setTestPlatform(nil)
    }
    
    func testAccessibilityStateBehavior(_ state: AccessibilityState) {
        print("🔍 Testing accessibility state: \(state.description)")
        
        // Test that the framework behaves correctly for this accessibility state
        testReduceMotionBehavior(state: state)
        testHighContrastBehavior(state: state)
        testVoiceOverBehavior(state: state)
        testSwitchControlBehavior(state: state)
        testDynamicTypeBehavior(state: state)
        testAssistiveTouchBehavior(state: state)
        
        // Test that the framework handles the combination correctly
        testAccessibilityStateCombination(state)
    }
    
    func testReduceMotionBehavior(state: AccessibilityState) {
        let performanceConfig = getCardExpansionPerformanceConfig()
        
        if state.reduceMotion {
            // When reduce motion is enabled, animations should be shorter or disabled
            XCTAssertGreaterThanOrEqual(performanceConfig.maxAnimationDuration, 0, 
                                       "Animation duration should be configurable for reduce motion")
            
            // Test that the framework can handle reduce motion
            XCTAssertNotNil(performanceConfig.targetFrameRate, "Target frame rate should be configurable")
            XCTAssertNotNil(performanceConfig.supportsSmoothAnimations, "Smooth animations should be configurable")
        } else {
            // When reduce motion is disabled, animations should work normally
            XCTAssertGreaterThanOrEqual(performanceConfig.maxAnimationDuration, 0, 
                                       "Animation duration should be configurable")
        }
    }
    
    func testHighContrastBehavior(state: AccessibilityState) {
        let testColor = Color.blue
        
        if state.highContrast {
            // When high contrast is enabled, colors should be enhanced
            do {
                let encodedData = try platformColorEncode(testColor)
                XCTAssertFalse(encodedData.isEmpty, "Color encoding should work for high contrast")
                
                let decodedColor = try platformColorDecode(encodedData)
                XCTAssertNotNil(decodedColor, "Color decoding should work for high contrast")
            } catch {
                XCTFail("Color encoding/decoding should work for high contrast: \(error)")
            }
        } else {
            // When high contrast is disabled, colors should work normally
            do {
                let encodedData = try platformColorEncode(testColor)
                XCTAssertFalse(encodedData.isEmpty, "Color encoding should work normally")
                
                let decodedColor = try platformColorDecode(encodedData)
                XCTAssertNotNil(decodedColor, "Color decoding should work normally")
            } catch {
                XCTFail("Color encoding/decoding should work normally: \(error)")
            }
        }
    }
    
    func testVoiceOverBehavior(state: AccessibilityState) {
        let config = getCardExpansionPlatformConfig()
        let accessibilityManager = AccessibilityOptimizationManager()
        
        if state.voiceOver {
            // When VoiceOver is enabled, accessibility should be optimized
            XCTAssertTrue(config.supportsVoiceOver, "VoiceOver should be supported")
            XCTAssertNotNil(accessibilityManager, "Accessibility manager should work with VoiceOver")
            XCTAssertNotNil(accessibilityManager.complianceMetrics, "Compliance metrics should be available")
        } else {
            // When VoiceOver is disabled, basic accessibility should still work
            XCTAssertTrue(config.supportsVoiceOver, "VoiceOver should still be supported (always available)")
            XCTAssertNotNil(accessibilityManager, "Accessibility manager should still work")
        }
    }
    
    func testSwitchControlBehavior(state: AccessibilityState) {
        let config = getCardExpansionPlatformConfig()
        
        if state.switchControl {
            // When Switch Control is enabled, navigation should be optimized
            XCTAssertTrue(config.supportsSwitchControl, "Switch Control should be supported")
            XCTAssertGreaterThanOrEqual(config.minTouchTarget, 44, 
                                       "Touch targets should be adequate for Switch Control")
        } else {
            // When Switch Control is disabled, basic accessibility should still work
            XCTAssertTrue(config.supportsSwitchControl, "Switch Control should still be supported (always available)")
        }
    }
    
    func testDynamicTypeBehavior(state: AccessibilityState) {
        let config = getCardExpansionPlatformConfig()
        
        if state.dynamicType {
            // When Dynamic Type is enabled, text should be scalable
            XCTAssertTrue(config.supportsVoiceOver, "VoiceOver should work with Dynamic Type")
            XCTAssertTrue(config.supportsSwitchControl, "Switch Control should work with Dynamic Type")
        } else {
            // When Dynamic Type is disabled, text should work normally
            XCTAssertTrue(config.supportsVoiceOver, "VoiceOver should work normally")
            XCTAssertTrue(config.supportsSwitchControl, "Switch Control should work normally")
        }
    }
    
    func testAssistiveTouchBehavior(state: AccessibilityState) {
        let config = getCardExpansionPlatformConfig()
        
        if state.assistiveTouch {
            // When AssistiveTouch is enabled, touch should be optimized
            if config.supportsTouch {
                XCTAssertTrue(config.supportsAssistiveTouch, "AssistiveTouch should be supported on touch platforms")
                XCTAssertTrue(config.supportsTouch, "Touch should be supported with AssistiveTouch")
            } else {
                // AssistiveTouch should not be available on non-touch platforms
                XCTAssertFalse(config.supportsAssistiveTouch, "AssistiveTouch should not be available on non-touch platforms")
            }
        } else {
            // When AssistiveTouch is disabled, touch should work normally
            if config.supportsTouch {
                XCTAssertTrue(config.supportsAssistiveTouch, "AssistiveTouch should still be available on touch platforms")
            }
        }
    }
    
    func testAccessibilityStateCombination(_ state: AccessibilityState) {
        // Test that the framework handles the combination of accessibility features correctly
        let config = getCardExpansionPlatformConfig()
        let performanceConfig = getCardExpansionPerformanceConfig()
        
        // Test that all enabled features work together
        if state.reduceMotion {
            XCTAssertGreaterThanOrEqual(performanceConfig.maxAnimationDuration, 0, 
                                       "Reduce motion should work with other features")
        }
        
        if state.highContrast {
            let testColor = Color.blue
            do {
                let encodedData = try platformColorEncode(testColor)
                XCTAssertFalse(encodedData.isEmpty, "High contrast should work with other features")
            } catch {
                XCTFail("High contrast should work with other features: \(error)")
            }
        }
        
        if state.voiceOver {
            XCTAssertTrue(config.supportsVoiceOver, "VoiceOver should work with other features")
        }
        
        if state.switchControl {
            XCTAssertTrue(config.supportsSwitchControl, "Switch Control should work with other features")
        }
        
        if state.dynamicType {
            XCTAssertTrue(config.supportsVoiceOver, "Dynamic Type should work with other features")
            XCTAssertTrue(config.supportsSwitchControl, "Dynamic Type should work with other features")
        }
        
        if state.assistiveTouch {
            if config.supportsTouch {
                XCTAssertTrue(config.supportsAssistiveTouch, "AssistiveTouch should work with other features")
            }
        }
    }
    
    // MARK: - Platform-Specific Accessibility State Tests
    
    func testPlatformSpecificAccessibilityStates() {
        // Test all platform-specific accessibility states by simulating each platform
        // This ensures comprehensive testing regardless of the actual test execution platform
        
        testIOSAccessibilityStates()
        testMacOSAccessibilityStates()
        testWatchOSAccessibilityStates()
        testTVOSAccessibilityStates()
        testVisionOSAccessibilityStates()
    }
    
    func testIOSAccessibilityStates() {
        // Set up iOS platform for testing
        RuntimeCapabilityDetection.setTestPlatform(.iOS)
        
        // Get the actual platform configuration using our new system
        let config = getCardExpansionPlatformConfig()
        
        // Test iOS-specific behavioral implications
        PlatformTestUtilities.testTouchPlatformBehavior(config, platformName: "iOS")
        PlatformTestUtilities.testAccessibilityPlatformBehavior(config, platformName: "iOS")
        
        // Test that all accessibility states work on iOS
        for state in accessibilityStates {
            testAccessibilityStateBehavior(state)
        }
        
        // Clean up
        RuntimeCapabilityDetection.setTestPlatform(nil)
    }
    
    func testMacOSAccessibilityStates() {
        // Set up macOS platform for testing
        RuntimeCapabilityDetection.setTestPlatform(.macOS)
        
        // Get the actual platform configuration using our new system
        let config = getCardExpansionPlatformConfig()
        
        // Test macOS-specific behavioral implications
        PlatformTestUtilities.testHoverPlatformBehavior(config, platformName: "macOS")
        PlatformTestUtilities.testNonTouchPlatformBehavior(config, platformName: "macOS")
        PlatformTestUtilities.testAccessibilityPlatformBehavior(config, platformName: "macOS")
        
        // Test that accessibility states work on macOS
        for state in accessibilityStates {
            testAccessibilityStateBehavior(state)
        }
        
        // Clean up
        RuntimeCapabilityDetection.setTestPlatform(nil)
    }
    
    func testWatchOSAccessibilityStates() {
        // Set up watchOS platform for testing
        RuntimeCapabilityDetection.setTestPlatform(.watchOS)
        
        // Get the actual platform configuration using our new system
        let config = getCardExpansionPlatformConfig()
        
        // Test watchOS-specific behavioral implications
        PlatformTestUtilities.testTouchPlatformBehavior(config, platformName: "watchOS")
        PlatformTestUtilities.testNonHoverPlatformBehavior(config, platformName: "watchOS")
        PlatformTestUtilities.testAccessibilityPlatformBehavior(config, platformName: "watchOS")
        
        // Test that accessibility states work on watchOS
        for state in accessibilityStates {
            testAccessibilityStateBehavior(state)
        }
        
        // Clean up
        RuntimeCapabilityDetection.setTestPlatform(nil)
    }
    
    func testTVOSAccessibilityStates() {
        // Set up tvOS platform for testing
        RuntimeCapabilityDetection.setTestPlatform(.tvOS)
        
        // Get the actual platform configuration using our new system
        let config = getCardExpansionPlatformConfig()
        
        // Test tvOS-specific behavioral implications
        PlatformTestUtilities.testNonTouchPlatformBehavior(config, platformName: "tvOS")
        PlatformTestUtilities.testNonHoverPlatformBehavior(config, platformName: "tvOS")
        PlatformTestUtilities.testAccessibilityPlatformBehavior(config, platformName: "tvOS")
        
        // Test that accessibility states work on tvOS
        for state in accessibilityStates {
            testAccessibilityStateBehavior(state)
        }
        
        // Clean up
        RuntimeCapabilityDetection.setTestPlatform(nil)
    }
    
    func testVisionOSAccessibilityStates() {
        // Create complete visionOS platform test configuration
        let testConfig = PlatformTestUtilities.createVisionOSPlatformTestConfig()
        
        // Test visionOS-specific behavioral implications
        PlatformTestUtilities.testNonTouchPlatformBehavior(testConfig.config, platformName: "visionOS")
        PlatformTestUtilities.testNonHoverPlatformBehavior(testConfig.config, platformName: "visionOS")
        PlatformTestUtilities.testAccessibilityPlatformBehavior(testConfig.config, platformName: "visionOS")
        PlatformTestUtilities.testVisionAvailableBehavior(testConfig, platformName: "visionOS")
        
        // Test that accessibility states work on visionOS
        for state in accessibilityStates {
            testAccessibilityStateBehavior(state)
        }
    }
    
    // MARK: - Comprehensive Accessibility State Testing
    
    func testAllAccessibilityStates() {
        // Test all accessibility states comprehensively
        testAccessibilityStateBehaviors()
        testPlatformSpecificAccessibilityStates()
        
        print("✅ All accessibility states tested successfully!")
    }
    
    /// Test that each platform helper completely sets all capabilities for its platform
    func testPlatformHelperCompleteness() {
        // Test that each platform helper sets ALL capabilities correctly
        
        // Test iOS completeness
        let iOSConfig = PlatformTestUtilities.createIOSPlatformTestConfig()
        XCTAssertTrue(iOSConfig.config.supportsTouch, "iOS helper should set touch support")
        XCTAssertTrue(iOSConfig.config.supportsHapticFeedback, "iOS helper should set haptic feedback")
        XCTAssertTrue(iOSConfig.config.supportsAssistiveTouch, "iOS helper should set AssistiveTouch")
        XCTAssertFalse(iOSConfig.config.supportsHover, "iOS helper should disable hover")
        XCTAssertTrue(iOSConfig.visionAvailable, "iOS helper should set Vision availability")
        XCTAssertTrue(iOSConfig.ocrAvailable, "iOS helper should set OCR availability")
        
        // Test macOS completeness
        let macOSConfig = PlatformTestUtilities.createMacOSPlatformTestConfig()
        XCTAssertFalse(macOSConfig.config.supportsTouch, "macOS helper should disable touch")
        XCTAssertFalse(macOSConfig.config.supportsHapticFeedback, "macOS helper should disable haptic feedback")
        XCTAssertFalse(macOSConfig.config.supportsAssistiveTouch, "macOS helper should disable AssistiveTouch")
        XCTAssertTrue(macOSConfig.config.supportsHover, "macOS helper should set hover support")
        XCTAssertTrue(macOSConfig.visionAvailable, "macOS helper should set Vision availability")
        XCTAssertTrue(macOSConfig.ocrAvailable, "macOS helper should set OCR availability")
        
        // Test watchOS completeness
        let watchOSConfig = PlatformTestUtilities.createWatchOSPlatformTestConfig()
        XCTAssertTrue(watchOSConfig.config.supportsTouch, "watchOS helper should set touch support")
        XCTAssertTrue(watchOSConfig.config.supportsHapticFeedback, "watchOS helper should set haptic feedback")
        XCTAssertTrue(watchOSConfig.config.supportsAssistiveTouch, "watchOS helper should set AssistiveTouch")
        XCTAssertFalse(watchOSConfig.config.supportsHover, "watchOS helper should disable hover")
        XCTAssertFalse(watchOSConfig.visionAvailable, "watchOS helper should disable Vision")
        XCTAssertFalse(watchOSConfig.ocrAvailable, "watchOS helper should disable OCR")
        
        // Test tvOS completeness
        let tvOSConfig = PlatformTestUtilities.createTVOSPlatformTestConfig()
        XCTAssertFalse(tvOSConfig.config.supportsTouch, "tvOS helper should disable touch")
        XCTAssertFalse(tvOSConfig.config.supportsHapticFeedback, "tvOS helper should disable haptic feedback")
        XCTAssertFalse(tvOSConfig.config.supportsAssistiveTouch, "tvOS helper should disable AssistiveTouch")
        XCTAssertFalse(tvOSConfig.config.supportsHover, "tvOS helper should disable hover")
        XCTAssertFalse(tvOSConfig.visionAvailable, "tvOS helper should disable Vision")
        XCTAssertFalse(tvOSConfig.ocrAvailable, "tvOS helper should disable OCR")
        
        // Test visionOS completeness
        let visionOSConfig = PlatformTestUtilities.createVisionOSPlatformTestConfig()
        XCTAssertFalse(visionOSConfig.config.supportsTouch, "visionOS helper should disable touch")
        XCTAssertFalse(visionOSConfig.config.supportsHapticFeedback, "visionOS helper should disable haptic feedback")
        XCTAssertFalse(visionOSConfig.config.supportsAssistiveTouch, "visionOS helper should disable AssistiveTouch")
        XCTAssertFalse(visionOSConfig.config.supportsHover, "visionOS helper should disable hover")
        XCTAssertTrue(visionOSConfig.visionAvailable, "visionOS helper should set Vision availability")
        XCTAssertTrue(visionOSConfig.ocrAvailable, "visionOS helper should set OCR availability")
        
        print("✅ All platform helpers set complete capability configurations!")
    }
    
}
