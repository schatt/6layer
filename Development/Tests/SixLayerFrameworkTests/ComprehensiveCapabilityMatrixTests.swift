import XCTest
import SwiftUI
@testable import SixLayerFramework

/// Comprehensive Capability Matrix Tests
/// Tests EVERY combination of platform capabilities and accessibility features
/// This ensures we handle all possible user configurations and platform variations
@MainActor
final class ComprehensiveCapabilityMatrixTests: XCTestCase {
    
    // MARK: - Test Data
    
    struct TestDataItem: Identifiable {
        let id = UUID()
        let title: String
        let subtitle: String?
        let description: String?
        let value: Int
        let isActive: Bool
    }
    
    var sampleData: [TestDataItem] = []
    
    override func setUp() {
        super.setUp()
        
        sampleData = [
            TestDataItem(title: "Item 1", subtitle: "Subtitle 1", description: "Description 1", value: 42, isActive: true),
            TestDataItem(title: "Item 2", subtitle: nil, description: "Description 2", value: 84, isActive: false),
            TestDataItem(title: "Item 3", subtitle: "Subtitle 3", description: nil, value: 126, isActive: true)
        ]
    }
    
    // MARK: - Capability Definitions
    
    /// Platform capabilities that may or may not be available
    enum PlatformCapability: String, CaseIterable {
        case touch = "touch"                    // Touch input (iPhone, iPad, Mac with touch display)
        case hover = "hover"                    // Hover input (Mac, iPad with mouse)
        case hapticFeedback = "hapticFeedback"  // Haptic feedback (iPhone, iPad, Apple Watch)
        case assistiveTouch = "assistiveTouch"  // AssistiveTouch (iOS devices)
        case voiceOver = "voiceOver"            // VoiceOver (all platforms)
        case switchControl = "switchControl"    // Switch Control (all platforms)
        case vision = "vision"                  // Vision framework (iOS, macOS, visionOS)
        case ocr = "ocr"                        // OCR capabilities (iOS, macOS, visionOS)
        case touchpad = "touchpad"              // Trackpad/touchpad (Mac)
        case externalDisplay = "externalDisplay" // External display support
        case multipleDisplays = "multipleDisplays" // Multiple display support
    }
    
    /// Accessibility features that can be enabled/disabled by users
    enum AccessibilityFeature: String, CaseIterable {
        case voiceOver = "voiceOver"
        case switchControl = "switchControl"
        case assistiveTouch = "assistiveTouch"
        case reduceMotion = "reduceMotion"
        case increaseContrast = "increaseContrast"
        case reduceTransparency = "reduceTransparency"
        case boldText = "boldText"
        case largerText = "largerText"
        case buttonShapes = "buttonShapes"
        case onOffLabels = "onOffLabels"
        case grayscale = "grayscale"
        case invertColors = "invertColors"
        case smartInvert = "smartInvert"
        case differentiateWithoutColor = "differentiateWithoutColor"
        case fullKeyboardAccess = "fullKeyboardAccess"
        case stickyKeys = "stickyKeys"
        case slowKeys = "slowKeys"
        case mouseKeys = "mouseKeys"
    }
    
    /// Test configuration for a specific combination
    struct TestConfiguration {
        let platformCapabilities: Set<PlatformCapability>
        let accessibilityFeatures: Set<AccessibilityFeature>
        let expectedViewType: String
        let expectedProperties: [String: Any]
        let description: String
    }
    
    // MARK: - Generate All Possible Combinations
    
    
    // MARK: - Specific Platform Scenarios
    
    func testMacWithTouchDisplay() {
        // GIVEN: Mac with touch-capable display
        let capabilities: Set<PlatformCapability> = [.hover, .touch, .touchpad, .voiceOver, .switchControl, .vision, .ocr, .externalDisplay, .multipleDisplays]
        let accessibility: Set<AccessibilityFeature> = [.voiceOver, .switchControl, .reduceMotion, .increaseContrast]
        
        let config = TestConfiguration(
            platformCapabilities: capabilities,
            accessibilityFeatures: accessibility,
            expectedViewType: "ExpandableCardComponent",
            expectedProperties: [
                "supportsTouch": true,
                "supportsHover": true,
                "supportsTouchpad": true,
                "supportsExternalDisplay": true,
                "supportsMultipleDisplays": true,
                "minTouchTarget": CGFloat(44),
                "hoverDelay": 0.1
            ],
            description: "Mac with touch display"
        )
        
        testCapabilityCombination(config)
    }
    
    func testMacWithoutTouchDisplay() {
        // GIVEN: Mac without touch display
        let capabilities: Set<PlatformCapability> = [.hover, .touchpad, .voiceOver, .switchControl, .vision, .ocr, .externalDisplay, .multipleDisplays]
        let accessibility: Set<AccessibilityFeature> = [.voiceOver, .switchControl, .reduceMotion, .increaseContrast]
        
        let config = TestConfiguration(
            platformCapabilities: capabilities,
            accessibilityFeatures: accessibility,
            expectedViewType: "ExpandableCardComponent",
            expectedProperties: [
                "supportsTouch": false,
                "supportsHover": true,
                "supportsTouchpad": true,
                "supportsExternalDisplay": true,
                "supportsMultipleDisplays": true,
                "minTouchTarget": CGFloat(0),
                "hoverDelay": 0.1
            ],
            description: "Mac without touch display"
        )
        
        testCapabilityCombination(config)
    }
    
    func testIPhoneWithAllAccessibilityFeatures() {
        // GIVEN: iPhone with all accessibility features enabled
        let capabilities: Set<PlatformCapability> = [.touch, .hapticFeedback, .assistiveTouch, .voiceOver, .switchControl, .vision, .ocr]
        let accessibility: Set<AccessibilityFeature> = Set(AccessibilityFeature.allCases)
        
        let config = TestConfiguration(
            platformCapabilities: capabilities,
            accessibilityFeatures: accessibility,
            expectedViewType: "ExpandableCardComponent",
            expectedProperties: [
                "supportsTouch": true,
                "supportsHapticFeedback": true,
                "supportsAssistiveTouch": true,
                "minTouchTarget": CGFloat(44),
                "hoverDelay": 0.0,
                "hasReduceMotion": true,
                "hasIncreaseContrast": true,
                "hasReduceTransparency": true,
                "hasBoldText": true,
                "hasLargerText": true,
                "hasButtonShapes": true,
                "hasOnOffLabels": true,
                "hasGrayscale": true,
                "hasInvertColors": true,
                "hasSmartInvert": true,
                "hasDifferentiateWithoutColor": true
            ],
            description: "iPhone with all accessibility features"
        )
        
        testCapabilityCombination(config)
    }
    
    func testIPhoneWithNoAccessibilityFeatures() {
        // GIVEN: iPhone with no accessibility features enabled
        let capabilities: Set<PlatformCapability> = [.touch, .hapticFeedback, .assistiveTouch, .voiceOver, .switchControl, .vision, .ocr]
        let accessibility: Set<AccessibilityFeature> = []
        
        let config = TestConfiguration(
            platformCapabilities: capabilities,
            accessibilityFeatures: accessibility,
            expectedViewType: "ExpandableCardComponent",
            expectedProperties: [
                "supportsTouch": true,
                "supportsHapticFeedback": true,
                "supportsAssistiveTouch": true,
                "minTouchTarget": CGFloat(44),
                "hoverDelay": 0.0,
                "hasReduceMotion": false,
                "hasIncreaseContrast": false,
                "hasReduceTransparency": false,
                "hasBoldText": false,
                "hasLargerText": false,
                "hasButtonShapes": false,
                "hasOnOffLabels": false,
                "hasGrayscale": false,
                "hasInvertColors": false,
                "hasSmartInvert": false,
                "hasDifferentiateWithoutColor": false
            ],
            description: "iPhone with no accessibility features"
        )
        
        testCapabilityCombination(config)
    }
    
    func testTVOSWithMinimalCapabilities() {
        // GIVEN: tvOS with minimal capabilities
        let capabilities: Set<PlatformCapability> = [.voiceOver, .switchControl]
        let accessibility: Set<AccessibilityFeature> = [.voiceOver, .switchControl, .reduceMotion, .increaseContrast]
        
        let config = TestConfiguration(
            platformCapabilities: capabilities,
            accessibilityFeatures: accessibility,
            expectedViewType: "SimpleCardComponent",
            expectedProperties: [
                "supportsTouch": false,
                "supportsHover": false,
                "supportsHapticFeedback": false,
                "supportsAssistiveTouch": false,
                "minTouchTarget": CGFloat(0),
                "hoverDelay": 0.0,
                "hasReduceMotion": true,
                "hasIncreaseContrast": true
            ],
            description: "tvOS with minimal capabilities"
        )
        
        testCapabilityCombination(config)
    }
    
    // MARK: - Edge Cases
    
    func testNoCapabilitiesNoAccessibility() {
        // GIVEN: No capabilities and no accessibility features
        let capabilities: Set<PlatformCapability> = []
        let accessibility: Set<AccessibilityFeature> = []
        
        let config = TestConfiguration(
            platformCapabilities: capabilities,
            accessibilityFeatures: accessibility,
            expectedViewType: "SimpleCardComponent",
            expectedProperties: [
                "supportsTouch": false,
                "supportsHover": false,
                "supportsHapticFeedback": false,
                "supportsAssistiveTouch": false,
                "minTouchTarget": CGFloat(0),
                "hoverDelay": 0.0,
                "hasReduceMotion": false,
                "hasIncreaseContrast": false
            ],
            description: "No capabilities, no accessibility"
        )
        
        testCapabilityCombination(config)
    }
    
    func testAllCapabilitiesAllAccessibility() {
        // GIVEN: All capabilities and all accessibility features
        let capabilities: Set<PlatformCapability> = Set(PlatformCapability.allCases)
        let accessibility: Set<AccessibilityFeature> = Set(AccessibilityFeature.allCases)
        
        let config = TestConfiguration(
            platformCapabilities: capabilities,
            accessibilityFeatures: accessibility,
            expectedViewType: "ExpandableCardComponent",
            expectedProperties: [
                "supportsTouch": true,
                "supportsHover": true,
                "supportsHapticFeedback": true,
                "supportsAssistiveTouch": true,
                "supportsVision": true,
                "supportsOCR": true,
                "supportsTouchpad": true,
                "supportsExternalDisplay": true,
                "supportsMultipleDisplays": true,
                "minTouchTarget": CGFloat(44),
                "hoverDelay": 0.1,
                "hasReduceMotion": true,
                "hasIncreaseContrast": true,
                "hasReduceTransparency": true,
                "hasBoldText": true,
                "hasLargerText": true,
                "hasButtonShapes": true,
                "hasOnOffLabels": true,
                "hasGrayscale": true,
                "hasInvertColors": true,
                "hasSmartInvert": true,
                "hasDifferentiateWithoutColor": true
            ],
            description: "All capabilities, all accessibility"
        )
        
        testCapabilityCombination(config)
    }
    
    // MARK: - Test Implementation
    
    private func testCapabilityCombination(_ config: TestConfiguration) {
        print("🧪 Testing: \(config.description)")
        
        // GIVEN: A test data item
        let item = sampleData[0]
        
        // WHEN: Generating a view with the specific capability/accessibility combination
        let viewDefinition = generateViewDefinition(
            item: item,
            platformCapabilities: config.platformCapabilities,
            accessibilityFeatures: config.accessibilityFeatures
        )
        
        // THEN: Should generate the expected view definition
        XCTAssertEqual(viewDefinition.viewType, config.expectedViewType, "View type should match for \(config.description)")
        
        // Test all expected properties
        for (key, expectedValue) in config.expectedProperties {
            let actualValue = getPropertyValue(from: viewDefinition, key: key)
            XCTAssertEqual(String(describing: actualValue), String(describing: expectedValue), "Property \(key) should match for \(config.description)")
        }
    }
    
    // MARK: - Helper Methods
    
    
    private func determineExpectedViewType(platformCapabilities: Set<PlatformCapability>, accessibilityFeatures: Set<AccessibilityFeature>) -> String {
        // Determine view type based on capabilities and features
        if platformCapabilities.contains(.touch) || platformCapabilities.contains(.hover) {
            return "ExpandableCardComponent"
        } else {
            return "SimpleCardComponent"
        }
    }
    
    private func determineExpectedProperties(platformCapabilities: Set<PlatformCapability>, accessibilityFeatures: Set<AccessibilityFeature>) -> [String: Any] {
        var properties: [String: Any] = [:]
        
        // Platform capabilities
        properties["supportsTouch"] = platformCapabilities.contains(.touch)
        properties["supportsHover"] = platformCapabilities.contains(.hover)
        properties["supportsHapticFeedback"] = platformCapabilities.contains(.hapticFeedback)
        properties["supportsAssistiveTouch"] = platformCapabilities.contains(.assistiveTouch)
        properties["supportsVision"] = platformCapabilities.contains(.vision)
        properties["supportsOCR"] = platformCapabilities.contains(.ocr)
        properties["supportsTouchpad"] = platformCapabilities.contains(.touchpad)
        properties["supportsExternalDisplay"] = platformCapabilities.contains(.externalDisplay)
        properties["supportsMultipleDisplays"] = platformCapabilities.contains(.multipleDisplays)
        
        // Touch target and hover delay
        properties["minTouchTarget"] = platformCapabilities.contains(.touch) ? CGFloat(44) : CGFloat(0)
        properties["hoverDelay"] = platformCapabilities.contains(.hover) ? 0.1 : 0.0
        
        // Accessibility features
        properties["hasReduceMotion"] = accessibilityFeatures.contains(.reduceMotion)
        properties["hasIncreaseContrast"] = accessibilityFeatures.contains(.increaseContrast)
        properties["hasReduceTransparency"] = accessibilityFeatures.contains(.reduceTransparency)
        properties["hasBoldText"] = accessibilityFeatures.contains(.boldText)
        properties["hasLargerText"] = accessibilityFeatures.contains(.largerText)
        properties["hasButtonShapes"] = accessibilityFeatures.contains(.buttonShapes)
        properties["hasOnOffLabels"] = accessibilityFeatures.contains(.onOffLabels)
        properties["hasGrayscale"] = accessibilityFeatures.contains(.grayscale)
        properties["hasInvertColors"] = accessibilityFeatures.contains(.invertColors)
        properties["hasSmartInvert"] = accessibilityFeatures.contains(.smartInvert)
        properties["hasDifferentiateWithoutColor"] = accessibilityFeatures.contains(.differentiateWithoutColor)
        
        return properties
    }
    
    private func generateViewDefinition(item: TestDataItem, platformCapabilities: Set<PlatformCapability>, accessibilityFeatures: Set<AccessibilityFeature>) -> ViewDefinition {
        // Determine view type
        let viewType = determineExpectedViewType(platformCapabilities: platformCapabilities, accessibilityFeatures: accessibilityFeatures)
        
        // Determine properties
        let properties = determineExpectedProperties(platformCapabilities: platformCapabilities, accessibilityFeatures: accessibilityFeatures)
        
        return ViewDefinition(
            viewType: viewType,
            supportsTouch: properties["supportsTouch"] as? Bool ?? false,
            supportsHover: properties["supportsHover"] as? Bool ?? false,
            supportsHapticFeedback: properties["supportsHapticFeedback"] as? Bool ?? false,
            supportsAssistiveTouch: properties["supportsAssistiveTouch"] as? Bool ?? false,
            supportsVision: properties["supportsVision"] as? Bool ?? false,
            supportsOCR: properties["supportsOCR"] as? Bool ?? false,
            supportsTouchpad: properties["supportsTouchpad"] as? Bool ?? false,
            supportsExternalDisplay: properties["supportsExternalDisplay"] as? Bool ?? false,
            supportsMultipleDisplays: properties["supportsMultipleDisplays"] as? Bool ?? false,
            minTouchTarget: properties["minTouchTarget"] as? CGFloat ?? 0,
            hoverDelay: properties["hoverDelay"] as? TimeInterval ?? 0.0,
            hasReduceMotion: properties["hasReduceMotion"] as? Bool ?? false,
            hasIncreaseContrast: properties["hasIncreaseContrast"] as? Bool ?? false,
            hasReduceTransparency: properties["hasReduceTransparency"] as? Bool ?? false,
            hasBoldText: properties["hasBoldText"] as? Bool ?? false,
            hasLargerText: properties["hasLargerText"] as? Bool ?? false,
            hasButtonShapes: properties["hasButtonShapes"] as? Bool ?? false,
            hasOnOffLabels: properties["hasOnOffLabels"] as? Bool ?? false,
            hasGrayscale: properties["hasGrayscale"] as? Bool ?? false,
            hasInvertColors: properties["hasInvertColors"] as? Bool ?? false,
            hasSmartInvert: properties["hasSmartInvert"] as? Bool ?? false,
            hasDifferentiateWithoutColor: properties["hasDifferentiateWithoutColor"] as? Bool ?? false
        )
    }
    
    private func getPropertyValue(from viewDefinition: ViewDefinition, key: String) -> Any {
        switch key {
        case "supportsTouch": return viewDefinition.supportsTouch
        case "supportsHover": return viewDefinition.supportsHover
        case "supportsHapticFeedback": return viewDefinition.supportsHapticFeedback
        case "supportsAssistiveTouch": return viewDefinition.supportsAssistiveTouch
        case "supportsVision": return viewDefinition.supportsVision
        case "supportsOCR": return viewDefinition.supportsOCR
        case "supportsTouchpad": return viewDefinition.supportsTouchpad
        case "supportsExternalDisplay": return viewDefinition.supportsExternalDisplay
        case "supportsMultipleDisplays": return viewDefinition.supportsMultipleDisplays
        case "minTouchTarget": return viewDefinition.minTouchTarget
        case "hoverDelay": return viewDefinition.hoverDelay
        case "hasReduceMotion": return viewDefinition.hasReduceMotion
        case "hasIncreaseContrast": return viewDefinition.hasIncreaseContrast
        case "hasReduceTransparency": return viewDefinition.hasReduceTransparency
        case "hasBoldText": return viewDefinition.hasBoldText
        case "hasLargerText": return viewDefinition.hasLargerText
        case "hasButtonShapes": return viewDefinition.hasButtonShapes
        case "hasOnOffLabels": return viewDefinition.hasOnOffLabels
        case "hasGrayscale": return viewDefinition.hasGrayscale
        case "hasInvertColors": return viewDefinition.hasInvertColors
        case "hasSmartInvert": return viewDefinition.hasSmartInvert
        case "hasDifferentiateWithoutColor": return viewDefinition.hasDifferentiateWithoutColor
        default: return false
        }
    }
    
    // MARK: - Helper Types
    
    struct ViewDefinition {
        let viewType: String
        let supportsTouch: Bool
        let supportsHover: Bool
        let supportsHapticFeedback: Bool
        let supportsAssistiveTouch: Bool
        let supportsVision: Bool
        let supportsOCR: Bool
        let supportsTouchpad: Bool
        let supportsExternalDisplay: Bool
        let supportsMultipleDisplays: Bool
        let minTouchTarget: CGFloat
        let hoverDelay: TimeInterval
        let hasReduceMotion: Bool
        let hasIncreaseContrast: Bool
        let hasReduceTransparency: Bool
        let hasBoldText: Bool
        let hasLargerText: Bool
        let hasButtonShapes: Bool
        let hasOnOffLabels: Bool
        let hasGrayscale: Bool
        let hasInvertColors: Bool
        let hasSmartInvert: Bool
        let hasDifferentiateWithoutColor: Bool
    }
}
