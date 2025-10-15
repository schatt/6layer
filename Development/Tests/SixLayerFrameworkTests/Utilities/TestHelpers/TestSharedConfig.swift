import SwiftUI
@testable import SixLayerFramework

// Shared test-only configuration builders (DRY, centralized)

// General platform capabilities for non-card tests
struct PlatformCapabilitiesTestSnapshot {
    let supportsHapticFeedback: Bool
    let supportsHover: Bool
    let supportsTouch: Bool
    let supportsVoiceOver: Bool
    let supportsSwitchControl: Bool
    let supportsAssistiveTouch: Bool
    let minTouchTarget: CGFloat
    let hoverDelay: TimeInterval
}

// Build a general capability snapshot from RuntimeCapabilityDetection
@MainActor
func buildPlatformCapabilitiesSnapshot() -> PlatformCapabilitiesTestSnapshot {
    let touch = RuntimeCapabilityDetection.supportsTouch
    let hover = RuntimeCapabilityDetection.supportsHover
    return PlatformCapabilitiesTestSnapshot(
        supportsHapticFeedback: RuntimeCapabilityDetection.supportsHapticFeedback,
        supportsHover: hover,
        supportsTouch: touch,
        supportsVoiceOver: RuntimeCapabilityDetection.supportsVoiceOver,
        supportsSwitchControl: RuntimeCapabilityDetection.supportsSwitchControl,
        supportsAssistiveTouch: RuntimeCapabilityDetection.supportsAssistiveTouch,
        minTouchTarget: touch ? 44 : 0,
        hoverDelay: hover ? 0.1 : 0.0
    )
}

// Note: Card-specific configuration functions have been moved to their respective test utilities
// to maintain proper separation of concerns. Use the framework's getCardExpansionPlatformConfig()
// directly or import the appropriate card-specific test utilities.


