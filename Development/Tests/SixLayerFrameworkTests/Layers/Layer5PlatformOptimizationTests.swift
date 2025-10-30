import Testing
import SwiftUI
@testable import SixLayerFramework

/// Comprehensive tests for Layer 5 platform optimization functions
/// Ensures all Layer 5 functions are tested
@MainActor
open class Layer5PlatformOptimizationTests {
    
    // MARK: - getCardExpansionPlatformConfig Tests
    
    @Test func testGetCardExpansionPlatformConfig_iOS() async {
        RuntimeCapabilityDetection.setTestPlatform(.iOS)
        let config = getCardExpansionPlatformConfig()
        
        #expect(config.supportsTouch == true, "iOS should support touch")
        #expect(config.minTouchTarget >= 44, "iOS should have minimum touch target of 44")
        #expect(config.hoverDelay >= 0, "iOS hover delay should be non-negative")
    }
    
    @Test func testGetCardExpansionPlatformConfig_macOS() async {
        RuntimeCapabilityDetection.setTestPlatform(.macOS)
        let config = getCardExpansionPlatformConfig()
        
        #expect(config.supportsHover == true, "macOS should support hover")
        #expect(config.minTouchTarget >= 44, "macOS should have minimum touch target")
        #expect(config.hoverDelay >= 0, "macOS hover delay should be non-negative")
    }
    
    @Test func testGetCardExpansionPlatformConfig_visionOS() async {
        RuntimeCapabilityDetection.setTestPlatform(.visionOS)
        let config = getCardExpansionPlatformConfig()
        
        #expect(config.minTouchTarget >= 60, "visionOS should have larger touch targets for spatial interface")
        #expect(config.hoverDelay >= 0, "visionOS hover delay should be non-negative")
    }
    
    @Test func testGetCardExpansionPlatformConfig_watchOS() async {
        RuntimeCapabilityDetection.setTestPlatform(.watchOS)
        let config = getCardExpansionPlatformConfig()
        
        #expect(config.minTouchTarget >= 44, "watchOS should have minimum touch target")
        #expect(config.hoverDelay >= 0, "watchOS hover delay should be non-negative")
    }
    
    @Test func testGetCardExpansionPlatformConfig_tvOS() async {
        RuntimeCapabilityDetection.setTestPlatform(.tvOS)
        let config = getCardExpansionPlatformConfig()
        
        #expect(config.minTouchTarget >= 60, "tvOS should have larger touch targets for TV")
        #expect(config.hoverDelay >= 0, "tvOS hover delay should be non-negative")
    }
    
    @Test func testGetCardExpansionPlatformConfig_AllPlatforms() async {
        let platforms: [SixLayerPlatform] = [.iOS, .macOS, .visionOS, .watchOS, .tvOS]
        
        for platform in platforms {
            RuntimeCapabilityDetection.setTestPlatform(platform)
            let config = getCardExpansionPlatformConfig()
            
            #expect(config.minTouchTarget > 0, "Platform \(platform) should have positive touch target")
            #expect(config.hoverDelay >= 0, "Platform \(platform) should have non-negative hover delay")
        }
    }
    
    // MARK: - getCardExpansionPerformanceConfig Tests
    
    @Test func testGetCardExpansionPerformanceConfig_iOS() async {
        RuntimeCapabilityDetection.setTestPlatform(.iOS)
        let config = getCardExpansionPerformanceConfig()
        
        #expect(config.targetFrameRate > 0, "iOS should have positive target frame rate")
        #expect(config.maxAnimationDuration > 0, "iOS should have positive max animation duration")
        #expect(config.supportsSmoothAnimations == true, "iOS should support smooth animations")
    }
    
    @Test func testGetCardExpansionPerformanceConfig_macOS() async {
        RuntimeCapabilityDetection.setTestPlatform(.macOS)
        let config = getCardExpansionPerformanceConfig()
        
        #expect(config.targetFrameRate > 0, "macOS should have positive target frame rate")
        #expect(config.maxAnimationDuration > 0, "macOS should have positive max animation duration")
        #expect(config.supportsSmoothAnimations == true, "macOS should support smooth animations")
    }
    
    @Test func testGetCardExpansionPerformanceConfig_visionOS() async {
        RuntimeCapabilityDetection.setTestPlatform(.visionOS)
        let config = getCardExpansionPerformanceConfig()
        
        #expect(config.targetFrameRate >= 90, "visionOS should have higher frame rate for spatial interface")
        #expect(config.maxAnimationDuration > 0, "visionOS should have positive max animation duration")
    }
    
    @Test func testGetCardExpansionPerformanceConfig_watchOS() async {
        RuntimeCapabilityDetection.setTestPlatform(.watchOS)
        let config = getCardExpansionPerformanceConfig()
        
        #expect(config.targetFrameRate > 0, "watchOS should have positive target frame rate")
        #expect(config.maxAnimationDuration <= 0.15, "watchOS should have fast animations")
    }
    
    @Test func testGetCardExpansionPerformanceConfig_tvOS() async {
        RuntimeCapabilityDetection.setTestPlatform(.tvOS)
        let config = getCardExpansionPerformanceConfig()
        
        #expect(config.targetFrameRate > 0, "tvOS should have positive target frame rate")
        #expect(config.maxAnimationDuration > 0, "tvOS should have positive max animation duration")
    }
    
    @Test func testGetCardExpansionPerformanceConfig_AllPlatforms() async {
        let platforms: [SixLayerPlatform] = [.iOS, .macOS, .visionOS, .watchOS, .tvOS]
        
        for platform in platforms {
            RuntimeCapabilityDetection.setTestPlatform(platform)
            let config = getCardExpansionPerformanceConfig()
            
            #expect(config.targetFrameRate > 0, "Platform \(platform) should have positive target frame rate")
            #expect(config.maxAnimationDuration > 0, "Platform \(platform) should have positive max animation duration")
            #expect(config.memoryOptimization == true, "Platform \(platform) should enable memory optimization")
            #expect(config.lazyLoading == true, "Platform \(platform) should enable lazy loading")
        }
    }
    
    // MARK: - getCardExpansionAccessibilityConfig Tests
    
    @Test func testGetCardExpansionAccessibilityConfig_iOS() async {
        RuntimeCapabilityDetection.setTestPlatform(.iOS)
        let config = getCardExpansionAccessibilityConfig()
        
        #expect(config.supportsVoiceOver == true, "iOS should support VoiceOver")
        #expect(config.supportsSwitchControl == true, "iOS should support Switch Control")
        #expect(config.supportsAssistiveTouch == true, "iOS should support AssistiveTouch")
        #expect(config.announcementDelay > 0, "iOS should have positive announcement delay")
    }
    
    @Test func testGetCardExpansionAccessibilityConfig_macOS() async {
        RuntimeCapabilityDetection.setTestPlatform(.macOS)
        let config = getCardExpansionAccessibilityConfig()
        
        #expect(config.supportsVoiceOver == true, "macOS should support VoiceOver")
        #expect(config.supportsSwitchControl == true, "macOS should support Switch Control")
        #expect(config.supportsAssistiveTouch == true, "macOS should support AssistiveTouch")
        #expect(config.announcementDelay > 0, "macOS should have positive announcement delay")
    }
    
    @Test func testGetCardExpansionAccessibilityConfig_visionOS() async {
        RuntimeCapabilityDetection.setTestPlatform(.visionOS)
        let config = getCardExpansionAccessibilityConfig()
        
        #expect(config.supportsVoiceOver == true, "visionOS should support VoiceOver")
        #expect(config.supportsAssistiveTouch == false, "visionOS should not support AssistiveTouch")
        #expect(config.announcementDelay >= 0.7, "visionOS should have longer announcement delay for spatial interface")
    }
    
    @Test func testGetCardExpansionAccessibilityConfig_watchOS() async {
        RuntimeCapabilityDetection.setTestPlatform(.watchOS)
        let config = getCardExpansionAccessibilityConfig()
        
        #expect(config.supportsVoiceOver == true, "watchOS should support VoiceOver")
        #expect(config.supportsAssistiveTouch == false, "watchOS should not support AssistiveTouch")
        #expect(config.announcementDelay > 0, "watchOS should have positive announcement delay")
    }
    
    @Test func testGetCardExpansionAccessibilityConfig_tvOS() async {
        RuntimeCapabilityDetection.setTestPlatform(.tvOS)
        let config = getCardExpansionAccessibilityConfig()
        
        #expect(config.supportsVoiceOver == true, "tvOS should support VoiceOver")
        #expect(config.supportsAssistiveTouch == false, "tvOS should not support AssistiveTouch")
        #expect(config.announcementDelay > 0, "tvOS should have positive announcement delay")
    }
    
    @Test func testGetCardExpansionAccessibilityConfig_AllPlatforms() async {
        let platforms: [SixLayerPlatform] = [.iOS, .macOS, .visionOS, .watchOS, .tvOS]
        
        for platform in platforms {
            RuntimeCapabilityDetection.setTestPlatform(platform)
            let config = getCardExpansionAccessibilityConfig()
            
            #expect(config.supportsVoiceOver == true, "Platform \(platform) should support VoiceOver")
            #expect(config.supportsSwitchControl == true, "Platform \(platform) should support Switch Control")
            #expect(config.supportsReduceMotion == true, "Platform \(platform) should support Reduce Motion")
            #expect(config.supportsHighContrast == true, "Platform \(platform) should support High Contrast")
            #expect(config.supportsDynamicType == true, "Platform \(platform) should support Dynamic Type")
            #expect(config.announcementDelay > 0, "Platform \(platform) should have positive announcement delay")
            #expect(config.focusManagement == true, "Platform \(platform) should enable focus management")
        }
    }
    
    // MARK: - CardExpansionPlatformConfig Initialization Tests
    
    @Test func testCardExpansionPlatformConfig_DefaultInitializer() async {
        let config = CardExpansionPlatformConfig()
        
        #expect(config.supportsHapticFeedback == false, "Default config should not support haptic feedback")
        #expect(config.supportsHover == false, "Default config should not support hover")
        #expect(config.supportsTouch == true, "Default config should support touch")
        #expect(config.supportsVoiceOver == true, "Default config should support VoiceOver")
        #expect(config.minTouchTarget == 44, "Default config should have 44pt touch target")
        #expect(config.hoverDelay == 0.1, "Default config should have 0.1s hover delay")
    }
    
    @Test func testCardExpansionPlatformConfig_CustomInitializer() async {
        let config = CardExpansionPlatformConfig(
            supportsHapticFeedback: true,
            supportsHover: true,
            supportsTouch: true,
            supportsVoiceOver: true,
            supportsSwitchControl: true,
            supportsAssistiveTouch: true,
            minTouchTarget: 60,
            hoverDelay: 0.2,
            animationEasing: .easeInOut(duration: 0.5)
        )
        
        #expect(config.supportsHapticFeedback == true, "Custom config should support haptic feedback")
        #expect(config.supportsHover == true, "Custom config should support hover")
        #expect(config.minTouchTarget == 60, "Custom config should have 60pt touch target")
        #expect(config.hoverDelay == 0.2, "Custom config should have 0.2s hover delay")
    }
    
    // MARK: - CardExpansionPerformanceConfig Initialization Tests
    
    @Test func testCardExpansionPerformanceConfig_DefaultInitializer() async {
        let config = CardExpansionPerformanceConfig()
        
        #expect(config.targetFrameRate == 60, "Default config should target 60fps")
        #expect(config.maxAnimationDuration == 0.3, "Default config should have 0.3s max animation duration")
        #expect(config.supportsSmoothAnimations == true, "Default config should support smooth animations")
        #expect(config.memoryOptimization == true, "Default config should enable memory optimization")
        #expect(config.lazyLoading == true, "Default config should enable lazy loading")
    }
    
    @Test func testCardExpansionPerformanceConfig_CustomInitializer() async {
        let config = CardExpansionPerformanceConfig(
            targetFrameRate: 120,
            maxAnimationDuration: 0.5,
            supportsSmoothAnimations: false,
            memoryOptimization: false,
            lazyLoading: false
        )
        
        #expect(config.targetFrameRate == 120, "Custom config should target 120fps")
        #expect(config.maxAnimationDuration == 0.5, "Custom config should have 0.5s max animation duration")
        #expect(config.supportsSmoothAnimations == false, "Custom config should not support smooth animations")
        #expect(config.memoryOptimization == false, "Custom config should not enable memory optimization")
        #expect(config.lazyLoading == false, "Custom config should not enable lazy loading")
    }
    
    // MARK: - CardExpansionAccessibilityConfig Initialization Tests
    
    @Test func testCardExpansionAccessibilityConfig_DefaultInitializer() async {
        let config = CardExpansionAccessibilityConfig()
        
        #expect(config.supportsVoiceOver == true, "Default config should support VoiceOver")
        #expect(config.supportsSwitchControl == true, "Default config should support Switch Control")
        #expect(config.supportsAssistiveTouch == true, "Default config should support AssistiveTouch")
        #expect(config.supportsReduceMotion == true, "Default config should support Reduce Motion")
        #expect(config.supportsHighContrast == true, "Default config should support High Contrast")
        #expect(config.supportsDynamicType == true, "Default config should support Dynamic Type")
        #expect(config.announcementDelay == 0.5, "Default config should have 0.5s announcement delay")
        #expect(config.focusManagement == true, "Default config should enable focus management")
    }
    
    @Test func testCardExpansionAccessibilityConfig_CustomInitializer() async {
        let config = CardExpansionAccessibilityConfig(
            supportsVoiceOver: false,
            supportsSwitchControl: false,
            supportsAssistiveTouch: false,
            supportsReduceMotion: false,
            supportsHighContrast: false,
            supportsDynamicType: false,
            announcementDelay: 1.0,
            focusManagement: false
        )
        
        #expect(config.supportsVoiceOver == false, "Custom config should not support VoiceOver")
        #expect(config.supportsSwitchControl == false, "Custom config should not support Switch Control")
        #expect(config.supportsAssistiveTouch == false, "Custom config should not support AssistiveTouch")
        #expect(config.announcementDelay == 1.0, "Custom config should have 1.0s announcement delay")
        #expect(config.focusManagement == false, "Custom config should not enable focus management")
    }
}

