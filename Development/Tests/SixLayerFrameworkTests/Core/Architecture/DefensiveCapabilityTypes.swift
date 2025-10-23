import Foundation

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
    
    /// Safe capability checker creation - returns nil instead of crashing
    static func createCapabilityChecker(for type: CapabilityType) -> MockPlatformCapabilityChecker {
        switch type {
        case .touchOnly:
            return TestPatterns.createTouchCapabilities()
        case .hoverOnly:
            return TestPatterns.createHoverCapabilities()
        case .allCapabilities:
            return TestPatterns.createAllCapabilities()
        case .noCapabilities:
            return TestPatterns.createNoCapabilities()
        }
    }
    
    /// Safe accessibility checker creation - returns nil instead of crashing
    static func createAccessibilityChecker(for type: AccessibilityType) -> MockAccessibilityFeatureChecker {
        switch type {
        case .noAccessibility:
            return TestPatterns.createNoAccessibility()
        case .allAccessibility:
            return TestPatterns.createAllAccessibility()
        }
    }
    
    /// Defensive test case creation with compile-time safety
    static func createDefensiveCapabilityTestCases() -> [(CapabilityType, () -> MockPlatformCapabilityChecker)] {
        return CapabilityType.allCases.map { type in
            (type, { createCapabilityChecker(for: type) })
        }
    }
    
    /// Defensive test case creation with compile-time safety
    static func createDefensiveAccessibilityTestCases() -> [(AccessibilityType, () -> MockAccessibilityFeatureChecker)] {
        return AccessibilityType.allCases.map { type in
            (type, { createAccessibilityChecker(for: type) })
        }
    }
}
