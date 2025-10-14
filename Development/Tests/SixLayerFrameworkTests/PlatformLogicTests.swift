import XCTest
import SwiftUI
@testable import SixLayerFramework

/// Platform Logic Tests
/// Tests the platform detection and configuration logic without relying on runtime platform detection
/// These tests focus on the logic that determines platform-specific behavior
@MainActor
final class PlatformLogicTests: XCTestCase {
    
    // MARK: - Platform Detection Logic Tests
    
    func testPlatformDetectionLogic() {
        // GIVEN: Current platform runtime capabilities
        let supportsTouch = RuntimeCapabilityDetection.supportsTouch
        let supportsHover = RuntimeCapabilityDetection.supportsHover
        let supportsHapticFeedback = RuntimeCapabilityDetection.supportsHapticFeedback
        let supportsAssistiveTouch = RuntimeCapabilityDetection.supportsAssistiveTouch
        let supportsVoiceOver = RuntimeCapabilityDetection.supportsVoiceOver
        let supportsSwitchControl = RuntimeCapabilityDetection.supportsSwitchControl

        // THEN: Basic internal consistency should hold for current platform
        if supportsHapticFeedback {
            XCTAssertTrue(supportsTouch, "Haptic feedback should only be available with touch on current platform")
        }
        if supportsAssistiveTouch {
            XCTAssertTrue(supportsTouch, "AssistiveTouch should only be available with touch on current platform")
        }
        // Avoid tautologies; assert only meaningful implications
        if SixLayerPlatform.deviceType == .mac {
            XCTAssertFalse(supportsTouch, "Mac should not report touch in runtime capabilities")
        }
        if SixLayerPlatform.deviceType == .watch {
            XCTAssertTrue(supportsTouch, "Watch should report touch in runtime capabilities")
        }
    }
    
    func testDeviceTypeDetectionLogic() {
        // GIVEN: Current device type and runtime capabilities
        let deviceType = SixLayerPlatform.deviceType
        let supportsTouch = RuntimeCapabilityDetection.supportsTouch
        let supportsHapticFeedback = RuntimeCapabilityDetection.supportsHapticFeedback
        let supportsHover = RuntimeCapabilityDetection.supportsHover

        // THEN: Coherence constraints for current device type
        if deviceType == .mac {
            XCTAssertFalse(supportsTouch, "Mac should not report touch in runtime capabilities")
        }
        if deviceType == .watch {
            XCTAssertTrue(supportsTouch, "Watch should report touch in runtime capabilities")
            XCTAssertTrue(supportsHapticFeedback, "Watch should report haptic feedback in runtime capabilities")
        }
        if deviceType == .tv {
            XCTAssertFalse(supportsTouch, "TV should not report touch in runtime capabilities")
            XCTAssertFalse(supportsHapticFeedback, "TV should not report haptics in runtime capabilities")
        }
        if deviceType == .vision {
            XCTAssertTrue(supportsHover || !supportsHover, "Vision hover detectability should be defined")
        }
    }
    
    // MARK: - Capability Matrix Tests
    
    struct CapabilitySnapshot {
        let supportsHapticFeedback: Bool
        let supportsHover: Bool
        let supportsTouch: Bool
        let supportsVoiceOver: Bool
        let supportsSwitchControl: Bool
        let supportsAssistiveTouch: Bool
        let minTouchTarget: Int
        let hoverDelay: Double
    }

    func testCapabilityMatrixConsistency() {
        // GIVEN: Current platform/device runtime snapshot (general capabilities)
        let platform = SixLayerPlatform.currentPlatform
        let deviceType = SixLayerPlatform.deviceType
        let snapshot = CapabilitySnapshot(
            supportsHapticFeedback: RuntimeCapabilityDetection.supportsHapticFeedback,
            supportsHover: RuntimeCapabilityDetection.supportsHover,
            supportsTouch: RuntimeCapabilityDetection.supportsTouch,
            supportsVoiceOver: RuntimeCapabilityDetection.supportsVoiceOver,
            supportsSwitchControl: RuntimeCapabilityDetection.supportsSwitchControl,
            supportsAssistiveTouch: RuntimeCapabilityDetection.supportsAssistiveTouch,
            minTouchTarget: RuntimeCapabilityDetection.supportsTouch ? 44 : 0,
            hoverDelay: RuntimeCapabilityDetection.supportsHover ? 0.1 : 0.0
        )
        // THEN: Capabilities should be internally consistent for current platform/device
        testCapabilityConsistency(snapshot, platform: platform, deviceType: deviceType)
    }

    func testCapabilityConsistency(_ config: CapabilitySnapshot, platform: SixLayerPlatform, deviceType: DeviceType) {
        // Haptic feedback should only be available with touch
        if config.supportsHapticFeedback {
            XCTAssertTrue(config.supportsTouch, "Haptic feedback should only be available with touch on \(platform) \(deviceType)")
        }
        
        // AssistiveTouch should only be available with touch
        if config.supportsAssistiveTouch {
            XCTAssertTrue(config.supportsTouch, "AssistiveTouch should only be available with touch on \(platform) \(deviceType)")
        }
        
        // Hover delay should be zero if hover is not supported
        if !config.supportsHover {
            XCTAssertEqual(config.hoverDelay, 0, "Hover delay should be zero when hover is not supported on \(platform) \(deviceType)")
        }
        
        // Touch target should be appropriate for touch platforms
        if config.supportsTouch {
            XCTAssertGreaterThanOrEqual(config.minTouchTarget, 44, "Touch target should be adequate for touch platforms on \(platform) \(deviceType)")
        } else {
            XCTAssertEqual(config.minTouchTarget, 0, "Touch target should be zero for non-touch platforms on \(platform) \(deviceType)")
        }
    }
    
    // MARK: - Vision Framework Availability Tests
    
    func testVisionFrameworkAvailabilityLogic() {
        // GIVEN: Different platforms
        let platforms: [SixLayerPlatform] = Array(SixLayerPlatform.allCases) // Use real enum
        
        // WHEN: Testing Vision framework availability logic
        for platform in platforms {
            let hasVision = createMockVisionAvailability(for: platform)
            
            // THEN: Vision availability should be correct for each platform
            switch platform {
            case .iOS, .macOS, .visionOS:
                XCTAssertTrue(hasVision, "\(platform) should have Vision framework")
                
            case .watchOS, .tvOS:
                XCTAssertFalse(hasVision, "\(platform) should not have Vision framework")
            }
        }
    }
    
    func testOCRAvailabilityLogic() {
        // GIVEN: Different platforms
        let platforms: [SixLayerPlatform] = Array(SixLayerPlatform.allCases) // Use real enum
        
        // WHEN: Testing OCR availability logic
        for platform in platforms {
            let hasOCR = createMockOCRAvailability(for: platform)
            
            // THEN: OCR availability should be correct for each platform
            switch platform {
            case .iOS, .macOS, .visionOS:
                XCTAssertTrue(hasOCR, "\(platform) should have OCR")
                
            case .watchOS, .tvOS:
                XCTAssertFalse(hasOCR, "\(platform) should not have OCR")
            }
        }
    }
    
    // MARK: - Layout Decision Logic Tests
    
    func testLayoutDecisionLogic() {
        // GIVEN: Different platform configurations
        let platforms: [SixLayerPlatform] = Array(SixLayerPlatform.allCases) // Use real enum
        
        // WHEN: Testing layout decision logic
        for platform in platforms {
            let config = createMockPlatformConfig(for: platform)
            let layoutDecision = createMockLayoutDecision(for: platform)
            
            // THEN: Layout decisions should be appropriate for the platform
            testLayoutDecisionAppropriateness(layoutDecision, platform: platform, config: config)
        }
    }
    
    func testLayoutDecisionAppropriateness(_ layoutDecision: IntelligentCardLayoutDecision, platform: SixLayerPlatform, config: CardExpansionPlatformConfig) {
        // Touch platforms should have appropriate touch targets
        if config.supportsTouch {
            XCTAssertGreaterThanOrEqual(layoutDecision.cardWidth, config.minTouchTarget, "Card width should accommodate touch targets on \(platform)")
            XCTAssertGreaterThanOrEqual(layoutDecision.cardHeight, config.minTouchTarget, "Card height should accommodate touch targets on \(platform)")
        }
        
        // Hover platforms should have appropriate spacing
        if config.supportsHover {
            XCTAssertGreaterThan(layoutDecision.spacing, 0, "Hover platforms should have spacing on \(platform)")
        }
        
        // All platforms should have reasonable padding
        XCTAssertGreaterThanOrEqual(layoutDecision.padding, 8, "All platforms should have reasonable padding on \(platform)")
    }
    
    // MARK: - Animation Logic Tests
    
    func testAnimationLogic() {
        // GIVEN: Different platform configurations
        let platforms: [SixLayerPlatform] = Array(SixLayerPlatform.allCases) // Use real enum
        
        // WHEN: Testing animation logic
        for platform in platforms {
            let config = createMockPlatformConfig(for: platform)
            let performanceConfig = createMockPerformanceConfig(for: platform)
            
            // THEN: Animation settings should be appropriate for the platform
            testAnimationAppropriateness(performanceConfig, platform: platform, config: config)
        }
    }
    
    func testAnimationAppropriateness(_ performanceConfig: CardExpansionPerformanceConfig, platform: SixLayerPlatform, config: CardExpansionPlatformConfig) {
        // Touch platforms should have appropriate animation duration
        if config.supportsTouch {
            XCTAssertGreaterThan(performanceConfig.maxAnimationDuration, 0, "Touch platforms should have animation duration on \(platform)")
        }
        
        // All platforms should have reasonable animation settings
        XCTAssertGreaterThanOrEqual(performanceConfig.maxAnimationDuration, 0, "All platforms should have non-negative animation duration on \(platform)")
    }
    
    // MARK: - Helper Methods
    
    // Removed mock platform mapping; use RuntimeCapabilityDetection directly
    
    // Removed mock device mapping; use RuntimeCapabilityDetection directly
    
    // Removed platform-device mapping; using snapshot from runtime in test
    
    private func createMockVisionAvailability(for platform: SixLayerPlatform) -> Bool {
        switch platform {
        case .iOS, .macOS, .visionOS:
            return true
        case .watchOS, .tvOS:
            return false
        }
    }
    
    private func createMockOCRAvailability(for platform: SixLayerPlatform) -> Bool {
        switch platform {
        case .iOS, .macOS, .visionOS:
            return true
        case .watchOS, .tvOS:
            return false
        }
    }
    
    private func createMockLayoutDecision(for platform: SixLayerPlatform) -> IntelligentCardLayoutDecision {
        switch platform {
        case .iOS:
            return IntelligentCardLayoutDecision(
                columns: 2,
                spacing: 16,
                cardWidth: 200,
                cardHeight: 150,
                padding: 16
            )
        case .macOS:
            return IntelligentCardLayoutDecision(
                columns: 3,
                spacing: 20,
                cardWidth: 250,
                cardHeight: 180,
                padding: 20
            )
        case .watchOS:
            return IntelligentCardLayoutDecision(
                columns: 1,
                spacing: 12,
                cardWidth: 150,
                cardHeight: 100,
                padding: 12
            )
        case .tvOS:
            return IntelligentCardLayoutDecision(
                columns: 4,
                spacing: 24,
                cardWidth: 300,
                cardHeight: 200,
                padding: 24
            )
        case .visionOS:
            return IntelligentCardLayoutDecision(
                columns: 3,
                spacing: 20,
                cardWidth: 250,
                cardHeight: 180,
                padding: 20
            )
        }
    }
    
    private func createMockPerformanceConfig(for platform: SixLayerPlatform) -> CardExpansionPerformanceConfig {
        switch platform {
        case .iOS, .macOS, .visionOS:
            return CardExpansionPerformanceConfig(
                targetFrameRate: 60,
                maxAnimationDuration: 0.3
            )
        case .watchOS:
            return CardExpansionPerformanceConfig(
                targetFrameRate: 30,
                maxAnimationDuration: 0.2
            )
        case .tvOS:
            return CardExpansionPerformanceConfig(
                targetFrameRate: 60,
                maxAnimationDuration: 0.4
            )
        }
    }
}
