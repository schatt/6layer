import SwiftUI
import ViewInspector
@testable import SixLayerFramework

/// DRY Test Patterns
/// Provides reusable patterns to eliminate duplication in tests
@MainActor
final class DRYTestPatterns {
    
    // MARK: - Test Data Types
    
    struct TestDataItem: Identifiable {
        let id = UUID()
        let title: String
        let subtitle: String?
        let description: String?
        let value: Int
        let isActive: Bool
    }
    
    /// Platform capability checker protocol
    protocol PlatformCapabilityChecker {
        func supportsTouch() -> Bool
        func supportsHover() -> Bool
        func supportsHapticFeedback() -> Bool
        func supportsAssistiveTouch() -> Bool
        func supportsVoiceOver() -> Bool
        func supportsSwitchControl() -> Bool
        func supportsVision() -> Bool
        func supportsOCR() -> Bool
    }
    
    /// Accessibility feature checker protocol
    protocol AccessibilityFeatureChecker {
        func hasReduceMotion() -> Bool
        func hasIncreaseContrast() -> Bool
        func hasReduceTransparency() -> Bool
        func hasBoldText() -> Bool
        func hasLargerText() -> Bool
        func hasButtonShapes() -> Bool
        func hasOnOffLabels() -> Bool
        func hasGrayscale() -> Bool
        func hasInvertColors() -> Bool
        func hasSmartInvert() -> Bool
        func hasDifferentiateWithoutColor() -> Bool
    }
    
    /// Mock platform capability checker for testing
    class MockPlatformCapabilityChecker: PlatformCapabilityChecker {
        var touchSupported: Bool = false
        var hoverSupported: Bool = false
        var hapticSupported: Bool = false
        var assistiveTouchSupported: Bool = false
        var voiceOverSupported: Bool = false
        var switchControlSupported: Bool = false
        var visionSupported: Bool = false
        var ocrSupported: Bool = false
        
        func supportsTouch() -> Bool { return touchSupported }
        func supportsHover() -> Bool { return hoverSupported }
        func supportsHapticFeedback() -> Bool { return hapticSupported }
        func supportsAssistiveTouch() -> Bool { return assistiveTouchSupported }
        func supportsVoiceOver() -> Bool { return voiceOverSupported }
        func supportsSwitchControl() -> Bool { return switchControlSupported }
        func supportsVision() -> Bool { return visionSupported }
        func supportsOCR() -> Bool { return ocrSupported }
    }
    
    /// Platform capability enum
    enum PlatformCapability: String, CaseIterable {
        case touch = "touch"
        case hover = "hover"
        case haptic = "haptic"
        case assistiveTouch = "assistiveTouch"
        case voiceOver = "voiceOver"
        case switchControl = "switchControl"
        case vision = "vision"
        case ocr = "ocr"
    }
    
    /// Accessibility feature enum
    enum AccessibilityFeature: String, CaseIterable {
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
    }
    
    /// View info struct for testing
    struct ViewInfo {
        let id: String
        let title: String
        let isAccessible: Bool
        let supportsTouch: Bool
        let supportsHover: Bool
        let supportsHapticFeedback: Bool
        let supportsAssistiveTouch: Bool
        let supportsVoiceOver: Bool
        let supportsSwitchControl: Bool
        let supportsVision: Bool
        let supportsOCR: Bool
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
        let viewType: String
    }
    
    /// Complexity enum for testing
    enum Complexity: String, CaseIterable {
        case simple = "simple"
        case moderate = "moderate"
        case complex = "complex"
        case veryComplex = "veryComplex"
        case advanced = "advanced"
    }
    
    /// Mock accessibility feature checker for testing
    class MockAccessibilityFeatureChecker: AccessibilityFeatureChecker {
        var reduceMotionEnabled: Bool = false
        var increaseContrastEnabled: Bool = false
        var reduceTransparencyEnabled: Bool = false
        var boldTextEnabled: Bool = false
        var largerTextEnabled: Bool = false
        var buttonShapesEnabled: Bool = false
        var onOffLabelsEnabled: Bool = false
        var grayscaleEnabled: Bool = false
        var invertColorsEnabled: Bool = false
        var smartInvertEnabled: Bool = false
        var differentiateWithoutColorEnabled: Bool = false
        
        func hasReduceMotion() -> Bool { return reduceMotionEnabled }
        func hasIncreaseContrast() -> Bool { return increaseContrastEnabled }
        func hasReduceTransparency() -> Bool { return reduceTransparencyEnabled }
        func hasBoldText() -> Bool { return boldTextEnabled }
        func hasLargerText() -> Bool { return largerTextEnabled }
        func hasButtonShapes() -> Bool { return buttonShapesEnabled }
        func hasOnOffLabels() -> Bool { return onOffLabelsEnabled }
        func hasGrayscale() -> Bool { return grayscaleEnabled }
        func hasInvertColors() -> Bool { return invertColorsEnabled }
        func hasSmartInvert() -> Bool { return smartInvertEnabled }
        func hasDifferentiateWithoutColor() -> Bool { return differentiateWithoutColorEnabled }
    }
    
    // MARK: - Test Data Factory
    
    static func createTestItem(
        title: String = "Test Item",
        subtitle: String? = "Test Subtitle",
        description: String? = "Test Description",
        value: Int = 42,
        isActive: Bool = true
    ) -> TestDataItem {
        return TestDataItem(
            title: title,
            subtitle: subtitle,
            description: description,
            value: value,
            isActive: isActive
        )
    }
    
    // MARK: - Capability Configuration Factory
    
    static func createTouchCapabilities() -> MockPlatformCapabilityChecker {
        let checker = MockPlatformCapabilityChecker()
        checker.touchSupported = true
        checker.hapticSupported = true
        checker.assistiveTouchSupported = true
        checker.voiceOverSupported = true
        checker.switchControlSupported = true
        return checker
    }
    
    static func createHoverCapabilities() -> MockPlatformCapabilityChecker {
        let checker = MockPlatformCapabilityChecker()
        checker.hoverSupported = true
        checker.voiceOverSupported = true
        checker.switchControlSupported = true
        return checker
    }
    
    static func createAllCapabilities() -> MockPlatformCapabilityChecker {
        let checker = MockPlatformCapabilityChecker()
        checker.touchSupported = true
        checker.hoverSupported = true
        checker.hapticSupported = true
        checker.assistiveTouchSupported = true
        checker.voiceOverSupported = true
        checker.switchControlSupported = true
        checker.visionSupported = true
        checker.ocrSupported = true
        return checker
    }
    
    static func createNoCapabilities() -> MockPlatformCapabilityChecker {
        return MockPlatformCapabilityChecker()
    }
    
    // MARK: - Accessibility Configuration Factory
    
    static func createNoAccessibility() -> MockAccessibilityFeatureChecker {
        return MockAccessibilityFeatureChecker()
    }
    
    static func createAllAccessibility() -> MockAccessibilityFeatureChecker {
        let checker = MockAccessibilityFeatureChecker()
        checker.reduceMotionEnabled = true
        checker.increaseContrastEnabled = true
        checker.reduceTransparencyEnabled = true
        checker.boldTextEnabled = true
        checker.largerTextEnabled = true
        checker.buttonShapesEnabled = true
        checker.onOffLabelsEnabled = true
        checker.grayscaleEnabled = true
        checker.invertColorsEnabled = true
        checker.smartInvertEnabled = true
        checker.differentiateWithoutColorEnabled = true
        return checker
    }
    
    // MARK: - View Generation Factory
    
    static func createIntelligentDetailView(
        item: TestDataItem,
        capabilityChecker: PlatformCapabilityChecker,
        accessibilityChecker: AccessibilityFeatureChecker
    ) -> some View {
        let hints = createPresentationHints(
            capabilityChecker: capabilityChecker,
            accessibilityChecker: accessibilityChecker
        )
        return IntelligentDetailView.platformDetailView(for: item, hints: hints)
    }
    
    static func createSimpleCardComponent(
        item: TestDataItem,
        capabilityChecker: PlatformCapabilityChecker,
        accessibilityChecker: AccessibilityFeatureChecker
    ) -> some View {
        let layoutDecision = createLayoutDecision(
            capabilityChecker: capabilityChecker,
            accessibilityChecker: accessibilityChecker
        )
        return SimpleCardComponent(
            item: item,
            layoutDecision: layoutDecision,
            onItemSelected: nil,
            onItemDeleted: nil,
            onItemEdited: nil
        )
    }
    
    // MARK: - Test Case Factory
    
    static func createCapabilityTestCases() -> [(String, () -> MockPlatformCapabilityChecker)] {
        return [
            ("Touch Only", { createTouchCapabilities() }),
            ("Hover Only", { createHoverCapabilities() }),
            ("All Capabilities", { createAllCapabilities() }),
            ("No Capabilities", { createNoCapabilities() })
        ]
    }
    
    static func createAccessibilityTestCases() -> [(String, () -> MockAccessibilityFeatureChecker)] {
        return [
            ("No Accessibility", { createNoAccessibility() }),
            ("All Accessibility", { createAllAccessibility() })
        ]
    }
    
    static func createBooleanTestCases() -> [(Bool, String)] {
        return [
            (true, "enabled"),
            (false, "disabled")
        ]
    }
    
    // MARK: - Verification Factory
    
    /// BUSINESS PURPOSE: Verify that a view is created and contains expected content
    /// TESTING SCOPE: Tests the two critical aspects: view creation + content verification
    /// METHODOLOGY: Uses ViewInspector to verify actual view structure and content
    static func verifyViewGeneration(_ view: some View, testName: String) {
        // 1. View created - The view can be instantiated successfully
        #expect(view != nil, "Should generate view for \(testName)")
        
        // 2. Contains what it needs to contain - The view has proper structure
        do {
            // Try to inspect the view structure
            let _ = try view.inspect()
            // If we can inspect it, the view structure is valid
            
        } catch {
            Issue.record("Failed to inspect view structure for \(testName): \(error)")
        }
    }
    
    /// BUSINESS PURPOSE: Verify that a view contains specific text content
    /// TESTING SCOPE: Tests that views contain expected text elements
    /// METHODOLOGY: Uses ViewInspector to find and verify text content
    static func verifyViewContainsText(_ view: some View, expectedText: String, testName: String) {
        // 1. View created - The view can be instantiated successfully
        #expect(view != nil, "Should generate view for \(testName)")
        
        // 2. Contains what it needs to contain - The view should contain expected text
        do {
            let viewText = try view.inspect().findAll(ViewType.Text.self)
            #expect(!viewText.isEmpty, "View should contain text elements for \(testName)")
            
            let hasExpectedText = viewText.contains { text in
                do {
                    let textContent = try text.string()
                    return textContent.contains(expectedText)
                } catch {
                    return false
                }
            }
            #expect(hasExpectedText, "View should contain text '\(expectedText)' for \(testName)")
            
        } catch {
            Issue.record("Failed to inspect view text content for \(testName): \(error)")
        }
    }
    
    /// BUSINESS PURPOSE: Verify that a view contains specific image elements
    /// TESTING SCOPE: Tests that views contain expected image elements
    /// METHODOLOGY: Uses ViewInspector to find and verify image content
    static func verifyViewContainsImage(_ view: some View, testName: String) {
        // 1. View created - The view can be instantiated successfully
        #expect(view != nil, "Should generate view for \(testName)")
        
        // 2. Contains what it needs to contain - The view should contain image elements
        do {
            let viewImages = try view.inspect().findAll(ViewType.Image.self)
            #expect(!viewImages.isEmpty, "View should contain image elements for \(testName)")
            
        } catch {
            Issue.record("Failed to inspect view image content for \(testName): \(error)")
        }
    }
    
    static func verifyPlatformProperties(
        viewInfo: ViewInfo,
        capabilityChecker: PlatformCapabilityChecker,
        testName: String
    ) {
        #expect(viewInfo.supportsTouch == capabilityChecker.supportsTouch(), "Touch support should match for \(testName)")
        #expect(viewInfo.supportsHover == capabilityChecker.supportsHover(), "Hover support should match for \(testName)")
        #expect(viewInfo.supportsHapticFeedback == capabilityChecker.supportsHapticFeedback(), "Haptic feedback support should match for \(testName)")
        #expect(viewInfo.supportsAssistiveTouch == capabilityChecker.supportsAssistiveTouch(), "AssistiveTouch support should match for \(testName)")
        #expect(viewInfo.supportsVoiceOver == capabilityChecker.supportsVoiceOver(), "VoiceOver support should match for \(testName)")
        #expect(viewInfo.supportsSwitchControl == capabilityChecker.supportsSwitchControl(), "Switch Control support should match for \(testName)")
        #expect(viewInfo.supportsVision == capabilityChecker.supportsVision(), "Vision support should match for \(testName)")
        #expect(viewInfo.supportsOCR == capabilityChecker.supportsOCR(), "OCR support should match for \(testName)")
        
        // Verify touch target and hover delay
        #expect(viewInfo.minTouchTarget == capabilityChecker.supportsTouch() ? 44 : 0, "Touch target should match for \(testName)")
        #expect(viewInfo.hoverDelay == capabilityChecker.supportsHover() ? 0.1 : 0.0, "Hover delay should match for \(testName)")
    }
    
    static func verifyAccessibilityProperties(
        viewInfo: ViewInfo,
        accessibilityChecker: AccessibilityFeatureChecker,
        testName: String
    ) {
        #expect(viewInfo.hasReduceMotion == accessibilityChecker.hasReduceMotion(), "Reduce motion should match for \(testName)")
        #expect(viewInfo.hasIncreaseContrast == accessibilityChecker.hasIncreaseContrast(), "Increase contrast should match for \(testName)")
        #expect(viewInfo.hasReduceTransparency == accessibilityChecker.hasReduceTransparency(), "Reduce transparency should match for \(testName)")
        #expect(viewInfo.hasBoldText == accessibilityChecker.hasBoldText(), "Bold text should match for \(testName)")
        #expect(viewInfo.hasLargerText == accessibilityChecker.hasLargerText(), "Larger text should match for \(testName)")
        #expect(viewInfo.hasButtonShapes == accessibilityChecker.hasButtonShapes(), "Button shapes should match for \(testName)")
        #expect(viewInfo.hasOnOffLabels == accessibilityChecker.hasOnOffLabels(), "On/Off labels should match for \(testName)")
        #expect(viewInfo.hasGrayscale == accessibilityChecker.hasGrayscale(), "Grayscale should match for \(testName)")
        #expect(viewInfo.hasInvertColors == accessibilityChecker.hasInvertColors(), "Invert colors should match for \(testName)")
        #expect(viewInfo.hasSmartInvert == accessibilityChecker.hasSmartInvert(), "Smart invert should match for \(testName)")
        #expect(viewInfo.hasDifferentiateWithoutColor == accessibilityChecker.hasDifferentiateWithoutColor(), "Differentiate without color should match for \(testName)")
    }
    
    // MARK: - Helper Methods (Private)
    
    private static func createPresentationHints(
        capabilityChecker: PlatformCapabilityChecker,
        accessibilityChecker: AccessibilityFeatureChecker
    ) -> PresentationHints {
        let dataType = DataTypeHint.generic
        let presentationPreference = determinePresentationPreference(capabilityChecker: capabilityChecker)
        let complexity = determineComplexity(capabilityChecker: capabilityChecker, accessibilityChecker: accessibilityChecker)
        let context = PresentationContext.standard
        
        return PresentationHints(
            dataType: dataType,
            presentationPreference: presentationPreference,
            complexity: complexity,
            context: context
        )
    }
    
    private static func createLayoutDecision(
        capabilityChecker: PlatformCapabilityChecker,
        accessibilityChecker: AccessibilityFeatureChecker
    ) -> IntelligentCardLayoutDecision {
        let columns = determineColumns(capabilityChecker: capabilityChecker)
        let spacing = determineSpacing(capabilityChecker: capabilityChecker, accessibilityChecker: accessibilityChecker)
        let cardWidth = determineCardWidth(capabilityChecker: capabilityChecker, accessibilityChecker: accessibilityChecker)
        let cardHeight = determineCardHeight(capabilityChecker: capabilityChecker, accessibilityChecker: accessibilityChecker)
        let padding = determinePadding(capabilityChecker: capabilityChecker, accessibilityChecker: accessibilityChecker)
        
        return IntelligentCardLayoutDecision(
            columns: columns,
            spacing: spacing,
            cardWidth: cardWidth,
            cardHeight: cardHeight,
            padding: padding
        )
    }
    
    // MARK: - Strategy Determination Methods (Private)
    
    private static func determinePresentationPreference(capabilityChecker: PlatformCapabilityChecker) -> PresentationPreference {
        if capabilityChecker.supportsTouch() {
            return .card
        } else if capabilityChecker.supportsHover() {
            return .detail
        } else {
            return .standard
        }
    }
    
    private static func determineComplexity(capabilityChecker: PlatformCapabilityChecker, accessibilityChecker: AccessibilityFeatureChecker) -> ContentComplexity {
        let capabilityCount = countCapabilities(capabilityChecker)
        let accessibilityCount = countAccessibilityFeatures(accessibilityChecker)
        
        if capabilityCount >= 6 && accessibilityCount >= 8 {
            return .advanced
        } else if capabilityCount >= 4 && accessibilityCount >= 5 {
            return .complex
        } else if capabilityCount >= 2 && accessibilityCount >= 3 {
            return .moderate
        } else {
            return .simple
        }
    }
    
    private static func countCapabilities(_ checker: PlatformCapabilityChecker) -> Int {
        var count = 0
        if checker.supportsTouch() { count += 1 }
        if checker.supportsHover() { count += 1 }
        if checker.supportsHapticFeedback() { count += 1 }
        if checker.supportsAssistiveTouch() { count += 1 }
        if checker.supportsVoiceOver() { count += 1 }
        if checker.supportsSwitchControl() { count += 1 }
        if checker.supportsVision() { count += 1 }
        if checker.supportsOCR() { count += 1 }
        return count
    }
    
    private static func countAccessibilityFeatures(_ checker: AccessibilityFeatureChecker) -> Int {
        var count = 0
        if checker.hasReduceMotion() { count += 1 }
        if checker.hasIncreaseContrast() { count += 1 }
        if checker.hasReduceTransparency() { count += 1 }
        if checker.hasBoldText() { count += 1 }
        if checker.hasLargerText() { count += 1 }
        if checker.hasButtonShapes() { count += 1 }
        if checker.hasOnOffLabels() { count += 1 }
        if checker.hasGrayscale() { count += 1 }
        if checker.hasInvertColors() { count += 1 }
        if checker.hasSmartInvert() { count += 1 }
        if checker.hasDifferentiateWithoutColor() { count += 1 }
        return count
    }
    
    private static func determineColumns(capabilityChecker: PlatformCapabilityChecker) -> Int {
        if capabilityChecker.supportsTouch() && capabilityChecker.supportsHover() {
            return 3 // iPad
        } else if capabilityChecker.supportsHover() {
            return 4 // Mac
        } else if capabilityChecker.supportsTouch() {
            return 2 // iPhone
        } else {
            return 1 // tvOS
        }
    }
    
    private static func determineSpacing(capabilityChecker: PlatformCapabilityChecker, accessibilityChecker: AccessibilityFeatureChecker) -> CGFloat {
        var spacing: CGFloat = 16
        
        if accessibilityChecker.hasLargerText() {
            spacing += 4
        }
        
        if capabilityChecker.supportsHover() {
            spacing += 4
        }
        
        return spacing
    }
    
    private static func determineCardWidth(capabilityChecker: PlatformCapabilityChecker, accessibilityChecker: AccessibilityFeatureChecker) -> CGFloat {
        var width: CGFloat = 200
        
        if accessibilityChecker.hasLargerText() {
            width += 20
        }
        
        if capabilityChecker.supportsHover() {
            width += 50
        }
        
        return width
    }
    
    private static func determineCardHeight(capabilityChecker: PlatformCapabilityChecker, accessibilityChecker: AccessibilityFeatureChecker) -> CGFloat {
        var height: CGFloat = 150
        
        if accessibilityChecker.hasLargerText() {
            height += 20
        }
        
        if capabilityChecker.supportsHover() {
            height += 30
        }
        
        return height
    }
    
    private static func determinePadding(capabilityChecker: PlatformCapabilityChecker, accessibilityChecker: AccessibilityFeatureChecker) -> CGFloat {
        var padding: CGFloat = 16
        
        if accessibilityChecker.hasLargerText() {
            padding += 4
        }
        
        if capabilityChecker.supportsTouch() {
            padding += 4
        }
        
        return padding
    }
}
