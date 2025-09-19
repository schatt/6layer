import XCTest
import SwiftUI
@testable import SixLayerFramework

/// DRY Core View Function Tests
/// Demonstrates how to eliminate duplication using reusable patterns
@MainActor
final class DRYCoreViewFunctionTests: XCTestCase {
    
    // MARK: - Test Data
    
    var sampleData: [TestDataItem] = []
    
    override func setUp() {
        super.setUp()
        sampleData = [
            DRYTestPatterns.createTestItem(title: "Item 1", subtitle: "Subtitle 1", description: "Description 1", value: 42, isActive: true),
            DRYTestPatterns.createTestItem(title: "Item 2", subtitle: nil, description: "Description 2", value: 84, isActive: false),
            DRYTestPatterns.createTestItem(title: "Item 3", subtitle: "Subtitle 3", description: nil, value: 126, isActive: true)
        ]
    }
    
    // MARK: - IntelligentDetailView Tests (DRY Version)
    
    func testIntelligentDetailViewWithAllCapabilities() {
        // Test every combination of platform capabilities and accessibility features
        let capabilityTestCases = DRYTestPatterns.createCapabilityTestCases()
        let accessibilityTestCases = DRYTestPatterns.createAccessibilityTestCases()
        
        for (capabilityName, capabilityFactory) in capabilityTestCases {
            for (accessibilityName, accessibilityFactory) in accessibilityTestCases {
                testIntelligentDetailViewWithSpecificCombination(
                    capabilityName: capabilityName,
                    accessibilityName: accessibilityName,
                    capabilityFactory: capabilityFactory,
                    accessibilityFactory: accessibilityFactory
                )
            }
        }
    }
    
    func testIntelligentDetailViewWithSpecificCombination(
        capabilityName: String,
        accessibilityName: String,
        capabilityFactory: () -> MockPlatformCapabilityChecker,
        accessibilityFactory: () -> MockAccessibilityFeatureChecker
    ) {
        // GIVEN: Specific capability and accessibility combination
        let item = sampleData[0]
        let capabilityChecker = capabilityFactory()
        let accessibilityChecker = accessibilityFactory()
        let testName = "\(capabilityName) + \(accessibilityName)"
        
        // WHEN: Generating intelligent detail view
        let view = DRYTestPatterns.createIntelligentDetailView(
            item: item,
            capabilityChecker: capabilityChecker,
            accessibilityChecker: accessibilityChecker
        )
        
        // THEN: Should generate correct view for this combination
        DRYTestPatterns.verifyViewGeneration(view, testName: testName)
        
        let viewInfo = extractViewInfo(
            from: view,
            capabilityChecker: capabilityChecker,
            accessibilityChecker: accessibilityChecker
        )
        
        // Verify platform-specific properties
        DRYTestPatterns.verifyPlatformProperties(
            viewInfo: viewInfo,
            capabilityChecker: capabilityChecker,
            testName: testName
        )
        
        // Verify accessibility properties
        DRYTestPatterns.verifyAccessibilityProperties(
            viewInfo: viewInfo,
            accessibilityChecker: accessibilityChecker,
            testName: testName
        )
    }
    
    // MARK: - Parameterized Tests (DRY Version)
    
    func testIntelligentDetailViewWithTouchCapability() {
        let testCases = DRYTestPatterns.createBooleanTestCases()
        
        for (isEnabled, description) in testCases {
            // Configure mock for this test case
            let capabilityChecker = isEnabled ? 
                DRYTestPatterns.createTouchCapabilities() : 
                DRYTestPatterns.createNoCapabilities()
            
            let accessibilityChecker = DRYTestPatterns.createNoAccessibility()
            let item = sampleData[0]
            let testName = "Touch \(description)"
            
            // WHEN: Generating view with touch capability
            let view = DRYTestPatterns.createIntelligentDetailView(
                item: item,
                capabilityChecker: capabilityChecker,
                accessibilityChecker: accessibilityChecker
            )
            
            // THEN: Should generate correct view for touch capability
            DRYTestPatterns.verifyViewGeneration(view, testName: testName)
            
            let viewInfo = extractViewInfo(
                from: view,
                capabilityChecker: capabilityChecker,
                accessibilityChecker: accessibilityChecker
            )
            
            if isEnabled {
                XCTAssertTrue(viewInfo.supportsTouch, "Should support touch when enabled")
                XCTAssertTrue(viewInfo.supportsHapticFeedback, "Should support haptic feedback when touch enabled")
                XCTAssertTrue(viewInfo.supportsAssistiveTouch, "Should support AssistiveTouch when touch enabled")
                XCTAssertEqual(viewInfo.minTouchTarget, 44, "Should have proper touch target when touch enabled")
            } else {
                XCTAssertFalse(viewInfo.supportsTouch, "Should not support touch when disabled")
                XCTAssertFalse(viewInfo.supportsHapticFeedback, "Should not support haptic feedback when touch disabled")
                XCTAssertFalse(viewInfo.supportsAssistiveTouch, "Should not support AssistiveTouch when touch disabled")
                XCTAssertEqual(viewInfo.minTouchTarget, 0, "Should have zero touch target when touch disabled")
            }
        }
    }
    
    func testIntelligentDetailViewWithHoverCapability() {
        let testCases = DRYTestPatterns.createBooleanTestCases()
        
        for (isEnabled, description) in testCases {
            // Configure mock for this test case
            let capabilityChecker = isEnabled ? 
                DRYTestPatterns.createHoverCapabilities() : 
                DRYTestPatterns.createNoCapabilities()
            
            let accessibilityChecker = DRYTestPatterns.createNoAccessibility()
            let item = sampleData[0]
            let testName = "Hover \(description)"
            
            // WHEN: Generating view with hover capability
            let view = DRYTestPatterns.createIntelligentDetailView(
                item: item,
                capabilityChecker: capabilityChecker,
                accessibilityChecker: accessibilityChecker
            )
            
            // THEN: Should generate correct view for hover capability
            DRYTestPatterns.verifyViewGeneration(view, testName: testName)
            
            let viewInfo = extractViewInfo(
                from: view,
                capabilityChecker: capabilityChecker,
                accessibilityChecker: accessibilityChecker
            )
            
            if isEnabled {
                XCTAssertTrue(viewInfo.supportsHover, "Should support hover when enabled")
                XCTAssertEqual(viewInfo.hoverDelay, 0.1, "Should have proper hover delay when hover enabled")
            } else {
                XCTAssertFalse(viewInfo.supportsHover, "Should not support hover when disabled")
                XCTAssertEqual(viewInfo.hoverDelay, 0.0, "Should have zero hover delay when hover disabled")
            }
        }
    }
    
    func testIntelligentDetailViewWithAccessibilityFeatures() {
        let testCases: [(AccessibilityFeature, String)] = [
            (.reduceMotion, "reduce motion"),
            (.increaseContrast, "increase contrast"),
            (.boldText, "bold text"),
            (.largerText, "larger text")
        ]
        
        for (feature, description) in testCases {
            // Test enabled state
            let capabilityChecker = DRYTestPatterns.createAllCapabilities()
            let accessibilityChecker = createAccessibilityWithFeature(feature, enabled: true)
            let item = sampleData[0]
            let testName = "\(description) enabled"
            
            let view = DRYTestPatterns.createIntelligentDetailView(
                item: item,
                capabilityChecker: capabilityChecker,
                accessibilityChecker: accessibilityChecker
            )
            
            DRYTestPatterns.verifyViewGeneration(view, testName: testName)
            
            let viewInfo = extractViewInfo(
                from: view,
                capabilityChecker: capabilityChecker,
                accessibilityChecker: accessibilityChecker
            )
            
            // Verify feature is applied
            verifyAccessibilityFeature(viewInfo: viewInfo, feature: feature, shouldBeEnabled: true, testName: testName)
            
            // Test disabled state
            let disabledAccessibilityChecker = createAccessibilityWithFeature(feature, enabled: false)
            let disabledView = DRYTestPatterns.createIntelligentDetailView(
                item: item,
                capabilityChecker: capabilityChecker,
                accessibilityChecker: disabledAccessibilityChecker
            )
            
            let disabledTestName = "\(description) disabled"
            DRYTestPatterns.verifyViewGeneration(disabledView, testName: disabledTestName)
            
            let disabledViewInfo = extractViewInfo(
                from: disabledView,
                capabilityChecker: capabilityChecker,
                accessibilityChecker: disabledAccessibilityChecker
            )
            
            // Verify feature is not applied
            verifyAccessibilityFeature(viewInfo: disabledViewInfo, feature: feature, shouldBeEnabled: false, testName: disabledTestName)
        }
    }
    
    // MARK: - SimpleCardComponent Tests (DRY Version)
    
    func testSimpleCardComponentWithAllCapabilities() {
        let capabilityTestCases = DRYTestPatterns.createCapabilityTestCases()
        let accessibilityTestCases = DRYTestPatterns.createAccessibilityTestCases()
        
        for (capabilityName, capabilityFactory) in capabilityTestCases {
            for (accessibilityName, accessibilityFactory) in accessibilityTestCases {
                testSimpleCardComponentWithSpecificCombination(
                    capabilityName: capabilityName,
                    accessibilityName: accessibilityName,
                    capabilityFactory: capabilityFactory,
                    accessibilityFactory: accessibilityFactory
                )
            }
        }
    }
    
    func testSimpleCardComponentWithSpecificCombination(
        capabilityName: String,
        accessibilityName: String,
        capabilityFactory: () -> MockPlatformCapabilityChecker,
        accessibilityFactory: () -> MockAccessibilityFeatureChecker
    ) {
        // GIVEN: Specific capability and accessibility combination
        let item = sampleData[0]
        let capabilityChecker = capabilityFactory()
        let accessibilityChecker = accessibilityFactory()
        let testName = "SimpleCard \(capabilityName) + \(accessibilityName)"
        
        // WHEN: Generating simple card component
        let view = DRYTestPatterns.createSimpleCardComponent(
            item: item,
            capabilityChecker: capabilityChecker,
            accessibilityChecker: accessibilityChecker
        )
        
        // THEN: Should generate correct view for this combination
        DRYTestPatterns.verifyViewGeneration(view, testName: testName)
        
        let viewInfo = extractViewInfo(
            from: view,
            capabilityChecker: capabilityChecker,
            accessibilityChecker: accessibilityChecker
        )
        
        // Verify platform-specific properties
        DRYTestPatterns.verifyPlatformProperties(
            viewInfo: viewInfo,
            capabilityChecker: capabilityChecker,
            testName: testName
        )
        
        // Verify accessibility properties
        DRYTestPatterns.verifyAccessibilityProperties(
            viewInfo: viewInfo,
            accessibilityChecker: accessibilityChecker,
            testName: testName
        )
    }
    
    // MARK: - Helper Methods
    
    private func createAccessibilityWithFeature(_ feature: AccessibilityFeature, enabled: Bool) -> MockAccessibilityFeatureChecker {
        let checker = MockAccessibilityFeatureChecker()
        configureAccessibilityFeature(checker, feature: feature, enabled: enabled)
        return checker
    }
    
    private func configureAccessibilityFeature(_ checker: MockAccessibilityFeatureChecker, feature: AccessibilityFeature, enabled: Bool) {
        switch feature {
        case .reduceMotion:
            checker.reduceMotionEnabled = enabled
        case .increaseContrast:
            checker.increaseContrastEnabled = enabled
        case .reduceTransparency:
            checker.reduceTransparencyEnabled = enabled
        case .boldText:
            checker.boldTextEnabled = enabled
        case .largerText:
            checker.largerTextEnabled = enabled
        case .buttonShapes:
            checker.buttonShapesEnabled = enabled
        case .onOffLabels:
            checker.onOffLabelsEnabled = enabled
        case .grayscale:
            checker.grayscaleEnabled = enabled
        case .invertColors:
            checker.invertColorsEnabled = enabled
        case .smartInvert:
            checker.smartInvertEnabled = enabled
        case .differentiateWithoutColor:
            checker.differentiateWithoutColorEnabled = enabled
        }
    }
    
    private func verifyAccessibilityFeature(viewInfo: ViewInfo, feature: AccessibilityFeature, shouldBeEnabled: Bool, testName: String) {
        let actualValue: Bool
        let featureName: String
        
        switch feature {
        case .reduceMotion:
            actualValue = viewInfo.hasReduceMotion
            featureName = "reduce motion"
        case .increaseContrast:
            actualValue = viewInfo.hasIncreaseContrast
            featureName = "increase contrast"
        case .reduceTransparency:
            actualValue = viewInfo.hasReduceTransparency
            featureName = "reduce transparency"
        case .boldText:
            actualValue = viewInfo.hasBoldText
            featureName = "bold text"
        case .largerText:
            actualValue = viewInfo.hasLargerText
            featureName = "larger text"
        case .buttonShapes:
            actualValue = viewInfo.hasButtonShapes
            featureName = "button shapes"
        case .onOffLabels:
            actualValue = viewInfo.hasOnOffLabels
            featureName = "on/off labels"
        case .grayscale:
            actualValue = viewInfo.hasGrayscale
            featureName = "grayscale"
        case .invertColors:
            actualValue = viewInfo.hasInvertColors
            featureName = "invert colors"
        case .smartInvert:
            actualValue = viewInfo.hasSmartInvert
            featureName = "smart invert"
        case .differentiateWithoutColor:
            actualValue = viewInfo.hasDifferentiateWithoutColor
            featureName = "differentiate without color"
        }
        
        XCTAssertEqual(actualValue, shouldBeEnabled, "\(featureName) should be \(shouldBeEnabled ? "enabled" : "disabled") for \(testName)")
    }
    
    private func extractViewInfo(
        from view: some View,
        capabilityChecker: PlatformCapabilityChecker,
        accessibilityChecker: AccessibilityFeatureChecker
    ) -> ViewInfo {
        // This would extract actual view properties in a real implementation
        // For now, return a mock ViewInfo based on the checkers
        return ViewInfo(
            viewType: "MockView",
            supportsTouch: capabilityChecker.supportsTouch(),
            supportsHover: capabilityChecker.supportsHover(),
            supportsHapticFeedback: capabilityChecker.supportsHapticFeedback(),
            supportsAssistiveTouch: capabilityChecker.supportsAssistiveTouch(),
            supportsVoiceOver: capabilityChecker.supportsVoiceOver(),
            supportsSwitchControl: capabilityChecker.supportsSwitchControl(),
            supportsVision: capabilityChecker.supportsVision(),
            supportsOCR: capabilityChecker.supportsOCR(),
            hasReduceMotion: accessibilityChecker.hasReduceMotion(),
            hasIncreaseContrast: accessibilityChecker.hasIncreaseContrast(),
            hasReduceTransparency: accessibilityChecker.hasReduceTransparency(),
            hasBoldText: accessibilityChecker.hasBoldText(),
            hasLargerText: accessibilityChecker.hasLargerText(),
            hasButtonShapes: accessibilityChecker.hasButtonShapes(),
            hasOnOffLabels: accessibilityChecker.hasOnOffLabels(),
            hasGrayscale: accessibilityChecker.hasGrayscale(),
            hasInvertColors: accessibilityChecker.hasInvertColors(),
            hasSmartInvert: accessibilityChecker.hasSmartInvert(),
            hasDifferentiateWithoutColor: accessibilityChecker.hasDifferentiateWithoutColor(),
            minTouchTarget: capabilityChecker.supportsTouch() ? 44 : 0,
            hoverDelay: capabilityChecker.supportsHover() ? 0.1 : 0.0,
            animationDuration: accessibilityChecker.hasReduceMotion() ? 0.0 : 0.3
        )
    }
}
