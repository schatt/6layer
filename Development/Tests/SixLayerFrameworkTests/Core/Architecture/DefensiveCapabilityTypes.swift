import Foundation
import SixLayerFramework

/// Defensive approach: Use enums instead of string literals to prevent runtime crashes
enum CapabilityType: String, CaseIterable {
    case touchOnly = "Touch Only"
    case hoverOnly = "Hover Only"
    case allCapabilities = "All Capabilities"
    case noCapabilities = "No Capabilities"
    
    /// Human-readable display name for logging and testing
    var displayName: String {
        return self.rawValue
    }
    
    /// Safe factory method that can't fail at runtime
    static func from(string: String) -> CapabilityType? {
        return CapabilityType(rawValue: string)
    }
}

enum AccessibilityType: String, CaseIterable {
    case noAccessibility = "No Accessibility"
    case allAccessibility = "All Accessibility"
    
    /// Human-readable display name for logging and testing
    var displayName: String {
        return self.rawValue
    }
    
    /// Safe factory method that can't fail at runtime
    static func from(string: String) -> AccessibilityType? {
        return AccessibilityType(rawValue: string)
    }
}

/// Defensive test pattern that prevents crashes
struct DefensiveTestPatterns {
    
    /// Safe platform setting for capability types using RuntimeCapabilityDetection
    static func setPlatformForCapabilityType(_ type: CapabilityType) {
        switch type {
        case .touchOnly:
            RuntimeCapabilityDetection.setTestPlatform(.iOS)
        case .hoverOnly:
            RuntimeCapabilityDetection.setTestPlatform(.macOS)
        case .allCapabilities:
            RuntimeCapabilityDetection.setTestPlatform(.iOS)
        case .noCapabilities:
            RuntimeCapabilityDetection.setTestPlatform(.tvOS)
        }
    }
    
    /// Safe platform setting for accessibility types using RuntimeCapabilityDetection
    static func setPlatformForAccessibilityType(_ type: AccessibilityType) {
        // For accessibility testing, we can use any platform that supports accessibility
        switch type {
        case .noAccessibility:
            RuntimeCapabilityDetection.setTestPlatform(.tvOS) // Minimal accessibility
        case .allAccessibility:
            RuntimeCapabilityDetection.setTestPlatform(.iOS) // Full accessibility
        }
    }
    
    /// Defensive test case creation with compile-time safety
    static func createDefensiveCapabilityTestCases() -> [(CapabilityType, () -> Void)] {
        return CapabilityType.allCases.map { type in
            (type, { setPlatformForCapabilityType(type) })
        }
    }
    
    /// Defensive test case creation with compile-time safety
    static func createDefensiveAccessibilityTestCases() -> [(AccessibilityType, () -> Void)] {
        return AccessibilityType.allCases.map { type in
            (type, { setPlatformForAccessibilityType(type) })
        }
    }
}
