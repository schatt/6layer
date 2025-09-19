import XCTest
import SwiftUI
@testable import SixLayerFramework

/// DRY Test Patterns
/// Provides reusable patterns to eliminate duplication in tests
@MainActor
final class DRYTestPatterns {
    
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
    
    static func verifyViewGeneration(_ view: some View, testName: String) {
        XCTAssertNotNil(view, "Should generate view for \(testName)")
    }
    
    static func verifyPlatformProperties(
        viewInfo: ViewInfo,
        capabilityChecker: PlatformCapabilityChecker,
        testName: String
    ) {
        XCTAssertEqual(viewInfo.supportsTouch, capabilityChecker.supportsTouch(), "Touch support should match for \(testName)")
        XCTAssertEqual(viewInfo.supportsHover, capabilityChecker.supportsHover(), "Hover support should match for \(testName)")
        XCTAssertEqual(viewInfo.supportsHapticFeedback, capabilityChecker.supportsHapticFeedback(), "Haptic feedback support should match for \(testName)")
        XCTAssertEqual(viewInfo.supportsAssistiveTouch, capabilityChecker.supportsAssistiveTouch(), "AssistiveTouch support should match for \(testName)")
        XCTAssertEqual(viewInfo.supportsVoiceOver, capabilityChecker.supportsVoiceOver(), "VoiceOver support should match for \(testName)")
        XCTAssertEqual(viewInfo.supportsSwitchControl, capabilityChecker.supportsSwitchControl(), "Switch Control support should match for \(testName)")
        XCTAssertEqual(viewInfo.supportsVision, capabilityChecker.supportsVision(), "Vision support should match for \(testName)")
        XCTAssertEqual(viewInfo.supportsOCR, capabilityChecker.supportsOCR(), "OCR support should match for \(testName)")
        
        // Verify touch target and hover delay
        XCTAssertEqual(viewInfo.minTouchTarget, capabilityChecker.supportsTouch() ? 44 : 0, "Touch target should match for \(testName)")
        XCTAssertEqual(viewInfo.hoverDelay, capabilityChecker.supportsHover() ? 0.1 : 0.0, "Hover delay should match for \(testName)")
    }
    
    static func verifyAccessibilityProperties(
        viewInfo: ViewInfo,
        accessibilityChecker: AccessibilityFeatureChecker,
        testName: String
    ) {
        XCTAssertEqual(viewInfo.hasReduceMotion, accessibilityChecker.hasReduceMotion(), "Reduce motion should match for \(testName)")
        XCTAssertEqual(viewInfo.hasIncreaseContrast, accessibilityChecker.hasIncreaseContrast(), "Increase contrast should match for \(testName)")
        XCTAssertEqual(viewInfo.hasReduceTransparency, accessibilityChecker.hasReduceTransparency(), "Reduce transparency should match for \(testName)")
        XCTAssertEqual(viewInfo.hasBoldText, accessibilityChecker.hasBoldText(), "Bold text should match for \(testName)")
        XCTAssertEqual(viewInfo.hasLargerText, accessibilityChecker.hasLargerText(), "Larger text should match for \(testName)")
        XCTAssertEqual(viewInfo.hasButtonShapes, accessibilityChecker.hasButtonShapes(), "Button shapes should match for \(testName)")
        XCTAssertEqual(viewInfo.hasOnOffLabels, accessibilityChecker.hasOnOffLabels(), "On/Off labels should match for \(testName)")
        XCTAssertEqual(viewInfo.hasGrayscale, accessibilityChecker.hasGrayscale(), "Grayscale should match for \(testName)")
        XCTAssertEqual(viewInfo.hasInvertColors, accessibilityChecker.hasInvertColors(), "Invert colors should match for \(testName)")
        XCTAssertEqual(viewInfo.hasSmartInvert, accessibilityChecker.hasSmartInvert(), "Smart invert should match for \(testName)")
        XCTAssertEqual(viewInfo.hasDifferentiateWithoutColor, accessibilityChecker.hasDifferentiateWithoutColor(), "Differentiate without color should match for \(testName)")
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
    
    private static func determineComplexity(capabilityChecker: PlatformCapabilityChecker, accessibilityChecker: AccessibilityFeatureChecker) -> Complexity {
        let capabilityCount = countCapabilities(capabilityChecker)
        let accessibilityCount = countAccessibilityFeatures(accessibilityChecker)
        
        if capabilityCount >= 6 && accessibilityCount >= 8 {
            return .veryComplex
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
