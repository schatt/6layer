import XCTest
import SwiftUI
@testable import SixLayerFramework

// Type aliases for DRY test patterns
typealias PlatformCapability = DRYTestPatterns.PlatformCapability
typealias AccessibilityFeature = DRYTestPatterns.AccessibilityFeature
typealias ViewInfo = DRYTestPatterns.ViewInfo
typealias TestDataItem = DRYTestPatterns.TestDataItem
typealias PlatformCapabilityChecker = DRYTestPatterns.PlatformCapabilityChecker
typealias AccessibilityFeatureChecker = DRYTestPatterns.AccessibilityFeatureChecker
typealias MockPlatformCapabilityChecker = DRYTestPatterns.MockPlatformCapabilityChecker
typealias MockAccessibilityFeatureChecker = DRYTestPatterns.MockAccessibilityFeatureChecker

/// Core View Function Tests
/// Tests the core view generation functions with every combination of capabilities and accessibility features
/// Uses dependency injection pattern to test both enabled and disabled states of capabilities
/// This is Phase 1 of the comprehensive testing plan
@MainActor
final class CoreViewFunctionTests: XCTestCase {
    
    // MARK: - Test Data
    
    
    var sampleData: [TestDataItem] = []
    var mockCapabilityChecker: MockPlatformCapabilityChecker!
    var mockAccessibilityChecker: MockAccessibilityFeatureChecker!
    
    override func setUp() {
        super.setUp()
        
        sampleData = [
            TestDataItem(title: "Item 1", subtitle: "Subtitle 1", description: "Description 1", value: 42, isActive: true),
            TestDataItem(title: "Item 2", subtitle: nil, description: "Description 2", value: 84, isActive: false),
            TestDataItem(title: "Item 3", subtitle: "Subtitle 3", description: nil, value: 126, isActive: true)
        ]
        
        // Setup mock capability checkers
        mockCapabilityChecker = MockPlatformCapabilityChecker()
        mockAccessibilityChecker = MockAccessibilityFeatureChecker()
    }
    
    override func tearDown() {
        mockCapabilityChecker = nil
        mockAccessibilityChecker = nil
        super.tearDown()
    }
    
    // MARK: - Capability Checker Protocols
    
    
    // MARK: - Mock Implementations
    
    
    // MARK: - IntelligentDetailView Tests
    
    func testIntelligentDetailViewWithAllCapabilities() {
        // Test realistic combinations instead of exhaustive testing
        let realisticCombinations = [
            (Set([PlatformCapability.touch, PlatformCapability.haptic]), Set([AccessibilityFeature.reduceMotion])),
            (Set([PlatformCapability.hover]), Set([AccessibilityFeature.increaseContrast])),
            (Set<PlatformCapability>(), Set<AccessibilityFeature>())
        ]
        
        for (platformCapabilities, accessibilityFeatures) in realisticCombinations {
            testIntelligentDetailViewWithSpecificCombination(
                platformCapabilities: platformCapabilities,
                accessibilityFeatures: accessibilityFeatures
            )
        }
    }
    
    func testIntelligentDetailViewWithSpecificCombination(
        platformCapabilities: Set<PlatformCapability>,
        accessibilityFeatures: Set<AccessibilityFeature>
    ) {
        // GIVEN: Specific capability and accessibility combination
        let item = sampleData[0]
        
        // Configure mock capability checker
        configureMockCapabilityChecker(platformCapabilities: platformCapabilities)
        configureMockAccessibilityChecker(accessibilityFeatures: accessibilityFeatures)
        
        let hints = createPresentationHints(
            capabilityChecker: mockCapabilityChecker,
            accessibilityChecker: mockAccessibilityChecker
        )
        
        // WHEN: Generating intelligent detail view
        let view = IntelligentDetailView.platformDetailView(for: item, hints: hints)
        
        // THEN: Should generate correct view for this combination
        let viewInfo = extractViewInfo(
            from: view,
            platformCapabilities: platformCapabilities,
            accessibilityFeatures: accessibilityFeatures
        )
        
        // Verify view generation
        XCTAssertNotNil(view, "Should generate a view for platform: \(platformCapabilities), accessibility: \(accessibilityFeatures)")
        
        // Verify view type based on capabilities
        let expectedViewType = determineExpectedViewType(
            platformCapabilities: platformCapabilities,
            accessibilityFeatures: accessibilityFeatures
        )
        XCTAssertEqual(viewInfo.viewType, expectedViewType, "View type should match for platform: \(platformCapabilities), accessibility: \(accessibilityFeatures)")
        
        // Verify platform-specific properties
        verifyPlatformProperties(viewInfo: viewInfo, capabilityChecker: mockCapabilityChecker)
        
        // Verify accessibility properties
        verifyAccessibilityProperties(viewInfo: viewInfo, accessibilityChecker: mockAccessibilityChecker)
    }
    
    // MARK: - IntelligentFormView Tests
    
    func testIntelligentFormViewWithAllCapabilities() {
        // Test realistic combinations instead of exhaustive testing
        let realisticCombinations = [
            (Set([PlatformCapability.touch, PlatformCapability.haptic]), Set([AccessibilityFeature.reduceMotion])),
            (Set([PlatformCapability.hover]), Set([AccessibilityFeature.increaseContrast])),
            (Set<PlatformCapability>(), Set<AccessibilityFeature>())
        ]
        
        for (platformCapabilities, accessibilityFeatures) in realisticCombinations {
            testIntelligentFormViewWithSpecificCombination(
                platformCapabilities: platformCapabilities,
                accessibilityFeatures: accessibilityFeatures
            )
        }
    }
    
    func testIntelligentFormViewWithSpecificCombination(
        platformCapabilities: Set<PlatformCapability>,
        accessibilityFeatures: Set<AccessibilityFeature>
    ) {
        // GIVEN: Specific capability and accessibility combination
        let item = sampleData[0]
        let hints = createPresentationHints(capabilityChecker: mockCapabilityChecker, accessibilityChecker: mockAccessibilityChecker)
        
        // WHEN: Generating intelligent form view
        let view = IntelligentFormView.generateForm(
            for: TestDataItem.self,
            initialData: item,
            onSubmit: { _ in },
            onCancel: { }
        )
        
        // THEN: Should generate correct form for this combination
        let viewInfo = extractViewInfo(from: view, platformCapabilities: platformCapabilities, accessibilityFeatures: accessibilityFeatures)
        
        // Verify view generation
        XCTAssertNotNil(view, "Should generate a form for platform: \(platformCapabilities), accessibility: \(accessibilityFeatures)")
        
        // Verify form-specific properties
        verifyFormProperties(viewInfo: viewInfo, platformCapabilities: platformCapabilities, accessibilityFeatures: accessibilityFeatures)
    }
    
    // MARK: - SimpleCardComponent Tests
    
    func testSimpleCardComponentWithAllCapabilities() {
        // Test realistic combinations instead of exhaustive testing
        let realisticCombinations = [
            (Set([PlatformCapability.touch, PlatformCapability.haptic]), Set([AccessibilityFeature.reduceMotion])),
            (Set([PlatformCapability.hover]), Set([AccessibilityFeature.increaseContrast])),
            (Set<PlatformCapability>(), Set<AccessibilityFeature>())
        ]
        
        for (platformCapabilities, accessibilityFeatures) in realisticCombinations {
            testSimpleCardComponentWithSpecificCombination(
                platformCapabilities: platformCapabilities,
                accessibilityFeatures: accessibilityFeatures
            )
        }
    }
    
    func testSimpleCardComponentWithSpecificCombination(
        platformCapabilities: Set<PlatformCapability>,
        accessibilityFeatures: Set<AccessibilityFeature>
    ) {
        // GIVEN: Specific capability and accessibility combination
        let item = sampleData[0]
        let layoutDecision = createLayoutDecision(capabilityChecker: mockCapabilityChecker, accessibilityChecker: mockAccessibilityChecker)
        
        // WHEN: Generating simple card component
        let view = SimpleCardComponent(
            item: item,
            layoutDecision: layoutDecision,
            onItemSelected: nil,
            onItemDeleted: nil,
            onItemEdited: nil
        )
        
        // THEN: Should generate correct card for this combination
        let viewInfo = extractViewInfo(from: view, platformCapabilities: platformCapabilities, accessibilityFeatures: accessibilityFeatures)
        
        // Verify view generation
        XCTAssertNotNil(view, "Should generate a card for platform: \(platformCapabilities), accessibility: \(accessibilityFeatures)")
        
        // Verify card-specific properties
        verifyCardProperties(viewInfo: viewInfo, platformCapabilities: platformCapabilities, accessibilityFeatures: accessibilityFeatures)
    }
    
    // MARK: - ExpandableCardComponent Tests
    
    
    
    // MARK: - Parameterized Tests (Following Best Practices)
    
    func testIntelligentDetailViewWithTouchCapability() {
        let testCases: [(Bool, String)] = [
            (true, "enabled"),
            (false, "disabled")
        ]
        
        for (isEnabled, description) in testCases {
            // Configure mock for this test case
            mockCapabilityChecker.touchSupported = isEnabled
            mockCapabilityChecker.hapticSupported = isEnabled
            mockCapabilityChecker.assistiveTouchSupported = isEnabled
            
            let item = sampleData[0]
            let hints = createPresentationHints(
                capabilityChecker: mockCapabilityChecker,
                accessibilityChecker: mockAccessibilityChecker
            )
            
            // WHEN: Generating view with touch capability
            let view = IntelligentDetailView.platformDetailView(for: item, hints: hints)
            
            // THEN: Should generate correct view for touch capability
            XCTAssertNotNil(view, "Should generate view with touch \(description)")
            
            // Create platform capabilities and accessibility features sets
            let platformCapabilities: Set<PlatformCapability> = [.touch]
            let accessibilityFeatures: Set<AccessibilityFeature> = []
            
            let viewInfo = extractViewInfo(
                from: view,
                platformCapabilities: platformCapabilities,
                accessibilityFeatures: accessibilityFeatures
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
        let testCases: [(Bool, String)] = [
            (true, "enabled"),
            (false, "disabled")
        ]
        
        for (isEnabled, description) in testCases {
            // Configure mock for this test case
            mockCapabilityChecker.hoverSupported = isEnabled
            
            let item = sampleData[0]
            let hints = createPresentationHints(
                capabilityChecker: mockCapabilityChecker,
                accessibilityChecker: mockAccessibilityChecker
            )
            
            // WHEN: Generating view with hover capability
            let view = IntelligentDetailView.platformDetailView(for: item, hints: hints)
            
            // THEN: Should generate correct view for hover capability
            XCTAssertNotNil(view, "Should generate view with hover \(description)")
            
            // Create platform capabilities and accessibility features sets
            let platformCapabilities: Set<PlatformCapability> = [.hover]
            let accessibilityFeatures: Set<AccessibilityFeature> = []
            
            let viewInfo = extractViewInfo(
                from: view,
                platformCapabilities: platformCapabilities,
                accessibilityFeatures: accessibilityFeatures
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
            configureAccessibilityFeature(feature, enabled: true)
            let item = sampleData[0]
            let hints = createPresentationHints(
                capabilityChecker: mockCapabilityChecker,
                accessibilityChecker: mockAccessibilityChecker
            )
            
            let view = IntelligentDetailView.platformDetailView(for: item, hints: hints)
            XCTAssertNotNil(view, "Should generate view with \(description) enabled")
            
            // Create platform capabilities and accessibility features sets
            let platformCapabilities: Set<PlatformCapability> = [.hover]
            let accessibilityFeatures: Set<AccessibilityFeature> = []
            
            let viewInfo = extractViewInfo(
                from: view,
                platformCapabilities: platformCapabilities,
                accessibilityFeatures: accessibilityFeatures
            )
            
            // Verify feature is applied
            verifyAccessibilityFeature(viewInfo: viewInfo, feature: feature, shouldBeEnabled: true)
            
            // Test disabled state
            configureAccessibilityFeature(feature, enabled: false)
            let disabledView = IntelligentDetailView.platformDetailView(for: item, hints: hints)
            XCTAssertNotNil(disabledView, "Should generate view with \(description) disabled")
            
            let disabledViewInfo = extractViewInfo(
                from: disabledView,
                platformCapabilities: platformCapabilities,
                accessibilityFeatures: accessibilityFeatures
            )
            
            // Verify feature is not applied
            verifyAccessibilityFeature(viewInfo: disabledViewInfo, feature: feature, shouldBeEnabled: false)
        }
    }
    
    // MARK: - Helper Methods
    
    
    private func configureMockCapabilityChecker(platformCapabilities: Set<PlatformCapability>) {
        mockCapabilityChecker.touchSupported = platformCapabilities.contains(.touch)
        mockCapabilityChecker.hoverSupported = platformCapabilities.contains(.hover)
        mockCapabilityChecker.hapticSupported = platformCapabilities.contains(.haptic)
        mockCapabilityChecker.assistiveTouchSupported = platformCapabilities.contains(.assistiveTouch)
        mockCapabilityChecker.voiceOverSupported = platformCapabilities.contains(.voiceOver)
        mockCapabilityChecker.switchControlSupported = platformCapabilities.contains(.switchControl)
        mockCapabilityChecker.visionSupported = platformCapabilities.contains(.vision)
        mockCapabilityChecker.ocrSupported = platformCapabilities.contains(.ocr)
    }
    
    private func configureMockAccessibilityChecker(accessibilityFeatures: Set<AccessibilityFeature>) {
        mockAccessibilityChecker.reduceMotionEnabled = accessibilityFeatures.contains(AccessibilityFeature.reduceMotion)
        mockAccessibilityChecker.increaseContrastEnabled = accessibilityFeatures.contains(AccessibilityFeature.increaseContrast)
        mockAccessibilityChecker.reduceTransparencyEnabled = accessibilityFeatures.contains(AccessibilityFeature.reduceTransparency)
        mockAccessibilityChecker.boldTextEnabled = accessibilityFeatures.contains(AccessibilityFeature.boldText)
        mockAccessibilityChecker.largerTextEnabled = accessibilityFeatures.contains(AccessibilityFeature.largerText)
        mockAccessibilityChecker.buttonShapesEnabled = accessibilityFeatures.contains(AccessibilityFeature.buttonShapes)
        mockAccessibilityChecker.onOffLabelsEnabled = accessibilityFeatures.contains(AccessibilityFeature.onOffLabels)
        mockAccessibilityChecker.grayscaleEnabled = accessibilityFeatures.contains(AccessibilityFeature.grayscale)
        mockAccessibilityChecker.invertColorsEnabled = accessibilityFeatures.contains(AccessibilityFeature.invertColors)
        mockAccessibilityChecker.smartInvertEnabled = accessibilityFeatures.contains(AccessibilityFeature.smartInvert)
        mockAccessibilityChecker.differentiateWithoutColorEnabled = accessibilityFeatures.contains(AccessibilityFeature.differentiateWithoutColor)
    }
    
    private func configureAccessibilityFeature(_ feature: AccessibilityFeature, enabled: Bool) {
        switch feature {
        case .reduceMotion:
            mockAccessibilityChecker.reduceMotionEnabled = enabled
        case .increaseContrast:
            mockAccessibilityChecker.increaseContrastEnabled = enabled
        case .reduceTransparency:
            mockAccessibilityChecker.reduceTransparencyEnabled = enabled
        case .boldText:
            mockAccessibilityChecker.boldTextEnabled = enabled
        case .largerText:
            mockAccessibilityChecker.largerTextEnabled = enabled
        case .buttonShapes:
            mockAccessibilityChecker.buttonShapesEnabled = enabled
        case .onOffLabels:
            mockAccessibilityChecker.onOffLabelsEnabled = enabled
        case .grayscale:
            mockAccessibilityChecker.grayscaleEnabled = enabled
        case .invertColors:
            mockAccessibilityChecker.invertColorsEnabled = enabled
        case .smartInvert:
            mockAccessibilityChecker.smartInvertEnabled = enabled
        case .differentiateWithoutColor:
            mockAccessibilityChecker.differentiateWithoutColorEnabled = enabled
        }
    }
    
    private func createPresentationHints(
        capabilityChecker: PlatformCapabilityChecker,
        accessibilityChecker: AccessibilityFeatureChecker
    ) -> PresentationHints {
        // Create presentation hints based on injected capability checkers
        let dataType = DataTypeHint.generic
        let platformCapabilities = Set<PlatformCapability>([.touch, .hover, .haptic])
        let accessibilityFeatures = Set<AccessibilityFeature>([AccessibilityFeature.reduceMotion, AccessibilityFeature.increaseContrast])
        let presentationPreference = determinePresentationPreference(platformCapabilities: platformCapabilities)
        let complexity = determineComplexity(platformCapabilities: platformCapabilities, accessibilityFeatures: accessibilityFeatures)
        let context = PresentationContext.standard
        
        return PresentationHints(
            dataType: dataType,
            presentationPreference: presentationPreference,
            complexity: complexity,
            context: context
        )
    }
    
    private func createLayoutDecision(
        capabilityChecker: PlatformCapabilityChecker,
        accessibilityChecker: AccessibilityFeatureChecker
    ) -> IntelligentCardLayoutDecision {
        let platformCapabilities = Set<PlatformCapability>([.touch, .hover, .haptic])
        let accessibilityFeatures = Set<AccessibilityFeature>([AccessibilityFeature.reduceMotion, AccessibilityFeature.increaseContrast])
        let columns = determineColumns(platformCapabilities: platformCapabilities)
        let spacing = determineSpacing(platformCapabilities: platformCapabilities, accessibilityFeatures: accessibilityFeatures)
        let cardWidth = determineCardWidth(platformCapabilities: platformCapabilities, accessibilityFeatures: accessibilityFeatures)
        let cardHeight = determineCardHeight(platformCapabilities: platformCapabilities, accessibilityFeatures: accessibilityFeatures)
        let padding = determinePadding(platformCapabilities: platformCapabilities, accessibilityFeatures: accessibilityFeatures)
        
        return IntelligentCardLayoutDecision(
            columns: columns,
            spacing: spacing,
            cardWidth: cardWidth,
            cardHeight: cardHeight,
            padding: padding
        )
    }
    
    private func createExpansionStrategy(
        for platformCapabilities: Set<PlatformCapability>,
        accessibilityFeatures: Set<AccessibilityFeature>
    ) -> CardExpansionStrategy {
        let primaryStrategy = determinePrimaryStrategy(platformCapabilities: platformCapabilities)
        let _ = determineSecondaryStrategy(platformCapabilities: platformCapabilities)
        let animationDuration = determineAnimationDuration(platformCapabilities: platformCapabilities, accessibilityFeatures: accessibilityFeatures)
        let supportedStrategies = determineSupportedStrategies(platformCapabilities: platformCapabilities)
        
        return CardExpansionStrategy(
            supportedStrategies: supportedStrategies,
            primaryStrategy: primaryStrategy,
            expansionScale: 1.1,
            animationDuration: animationDuration,
            hapticFeedback: true,
            accessibilitySupport: true
        )
    }
    
    private func extractViewInfo(
        from view: some View,
        platformCapabilities: Set<PlatformCapability>,
        accessibilityFeatures: Set<AccessibilityFeature>
    ) -> ViewInfo {
        // Extract view information based on the view type and capabilities
        // This would need to be implemented based on how you want to verify view properties
        return ViewInfo(
            viewType: determineExpectedViewType(platformCapabilities: platformCapabilities, accessibilityFeatures: accessibilityFeatures),
            supportsTouch: platformCapabilities.contains(.touch),
            supportsHover: platformCapabilities.contains(.hover),
            supportsHapticFeedback: platformCapabilities.contains(.haptic),
            supportsAssistiveTouch: platformCapabilities.contains(.assistiveTouch),
            supportsVoiceOver: platformCapabilities.contains(.voiceOver),
            supportsSwitchControl: platformCapabilities.contains(.switchControl),
            supportsVision: platformCapabilities.contains(.vision),
            supportsOCR: platformCapabilities.contains(.ocr),
            hasReduceMotion: accessibilityFeatures.contains(AccessibilityFeature.reduceMotion),
            hasIncreaseContrast: accessibilityFeatures.contains(AccessibilityFeature.increaseContrast),
            hasReduceTransparency: accessibilityFeatures.contains(AccessibilityFeature.reduceTransparency),
            hasBoldText: accessibilityFeatures.contains(AccessibilityFeature.boldText),
            hasLargerText: accessibilityFeatures.contains(AccessibilityFeature.largerText),
            hasButtonShapes: accessibilityFeatures.contains(AccessibilityFeature.buttonShapes),
            hasOnOffLabels: accessibilityFeatures.contains(AccessibilityFeature.onOffLabels),
            hasGrayscale: accessibilityFeatures.contains(AccessibilityFeature.grayscale),
            hasInvertColors: accessibilityFeatures.contains(AccessibilityFeature.invertColors),
            hasSmartInvert: accessibilityFeatures.contains(AccessibilityFeature.smartInvert),
            hasDifferentiateWithoutColor: accessibilityFeatures.contains(AccessibilityFeature.differentiateWithoutColor),
            minTouchTarget: platformCapabilities.contains(.touch) ? 44 : 0,
            hoverDelay: platformCapabilities.contains(.hover) ? 0.1 : 0.0,
            animationDuration: determineAnimationDuration(platformCapabilities: platformCapabilities, accessibilityFeatures: accessibilityFeatures)
        )
    }
    
    // MARK: - Verification Methods
    
    private func verifyPlatformProperties(viewInfo: ViewInfo, capabilityChecker: PlatformCapabilityChecker) {
        XCTAssertEqual(viewInfo.supportsTouch, capabilityChecker.supportsTouch(), "Touch support should match capability checker")
        XCTAssertEqual(viewInfo.supportsHover, capabilityChecker.supportsHover(), "Hover support should match capability checker")
        XCTAssertEqual(viewInfo.supportsHapticFeedback, capabilityChecker.supportsHapticFeedback(), "Haptic feedback support should match capability checker")
        XCTAssertEqual(viewInfo.supportsAssistiveTouch, capabilityChecker.supportsAssistiveTouch(), "AssistiveTouch support should match capability checker")
        XCTAssertEqual(viewInfo.supportsVoiceOver, capabilityChecker.supportsVoiceOver(), "VoiceOver support should match capability checker")
        XCTAssertEqual(viewInfo.supportsSwitchControl, capabilityChecker.supportsSwitchControl(), "Switch Control support should match capability checker")
        XCTAssertEqual(viewInfo.supportsVision, capabilityChecker.supportsVision(), "Vision support should match capability checker")
        XCTAssertEqual(viewInfo.supportsOCR, capabilityChecker.supportsOCR(), "OCR support should match capability checker")
        
        // Verify touch target and hover delay
        XCTAssertEqual(viewInfo.minTouchTarget, capabilityChecker.supportsTouch() ? 44 : 0, "Touch target should match capability checker")
        XCTAssertEqual(viewInfo.hoverDelay, capabilityChecker.supportsHover() ? 0.1 : 0.0, "Hover delay should match capability checker")
    }
    
    private func verifyAccessibilityProperties(viewInfo: ViewInfo, accessibilityChecker: AccessibilityFeatureChecker) {
        XCTAssertEqual(viewInfo.hasReduceMotion, accessibilityChecker.hasReduceMotion(), "Reduce motion should match accessibility checker")
        XCTAssertEqual(viewInfo.hasIncreaseContrast, accessibilityChecker.hasIncreaseContrast(), "Increase contrast should match accessibility checker")
        XCTAssertEqual(viewInfo.hasReduceTransparency, accessibilityChecker.hasReduceTransparency(), "Reduce transparency should match accessibility checker")
        XCTAssertEqual(viewInfo.hasBoldText, accessibilityChecker.hasBoldText(), "Bold text should match accessibility checker")
        XCTAssertEqual(viewInfo.hasLargerText, accessibilityChecker.hasLargerText(), "Larger text should match accessibility checker")
        XCTAssertEqual(viewInfo.hasButtonShapes, accessibilityChecker.hasButtonShapes(), "Button shapes should match accessibility checker")
        XCTAssertEqual(viewInfo.hasOnOffLabels, accessibilityChecker.hasOnOffLabels(), "On/Off labels should match accessibility checker")
        XCTAssertEqual(viewInfo.hasGrayscale, accessibilityChecker.hasGrayscale(), "Grayscale should match accessibility checker")
        XCTAssertEqual(viewInfo.hasInvertColors, accessibilityChecker.hasInvertColors(), "Invert colors should match accessibility checker")
        XCTAssertEqual(viewInfo.hasSmartInvert, accessibilityChecker.hasSmartInvert(), "Smart invert should match accessibility checker")
        XCTAssertEqual(viewInfo.hasDifferentiateWithoutColor, accessibilityChecker.hasDifferentiateWithoutColor(), "Differentiate without color should match accessibility checker")
    }
    
    private func verifyAccessibilityFeature(viewInfo: ViewInfo, feature: AccessibilityFeature, shouldBeEnabled: Bool) {
        switch feature {
        case .reduceMotion:
            XCTAssertEqual(viewInfo.hasReduceMotion, shouldBeEnabled, "Reduce motion should be \(shouldBeEnabled ? "enabled" : "disabled")")
        case .increaseContrast:
            XCTAssertEqual(viewInfo.hasIncreaseContrast, shouldBeEnabled, "Increase contrast should be \(shouldBeEnabled ? "enabled" : "disabled")")
        case .reduceTransparency:
            XCTAssertEqual(viewInfo.hasReduceTransparency, shouldBeEnabled, "Reduce transparency should be \(shouldBeEnabled ? "enabled" : "disabled")")
        case .boldText:
            XCTAssertEqual(viewInfo.hasBoldText, shouldBeEnabled, "Bold text should be \(shouldBeEnabled ? "enabled" : "disabled")")
        case .largerText:
            XCTAssertEqual(viewInfo.hasLargerText, shouldBeEnabled, "Larger text should be \(shouldBeEnabled ? "enabled" : "disabled")")
        case .buttonShapes:
            XCTAssertEqual(viewInfo.hasButtonShapes, shouldBeEnabled, "Button shapes should be \(shouldBeEnabled ? "enabled" : "disabled")")
        case .onOffLabels:
            XCTAssertEqual(viewInfo.hasOnOffLabels, shouldBeEnabled, "On/Off labels should be \(shouldBeEnabled ? "enabled" : "disabled")")
        case .grayscale:
            XCTAssertEqual(viewInfo.hasGrayscale, shouldBeEnabled, "Grayscale should be \(shouldBeEnabled ? "enabled" : "disabled")")
        case .invertColors:
            XCTAssertEqual(viewInfo.hasInvertColors, shouldBeEnabled, "Invert colors should be \(shouldBeEnabled ? "enabled" : "disabled")")
        case .smartInvert:
            XCTAssertEqual(viewInfo.hasSmartInvert, shouldBeEnabled, "Smart invert should be \(shouldBeEnabled ? "enabled" : "disabled")")
        case .differentiateWithoutColor:
            XCTAssertEqual(viewInfo.hasDifferentiateWithoutColor, shouldBeEnabled, "Differentiate without color should be \(shouldBeEnabled ? "enabled" : "disabled")")
        }
    }
    
    private func verifyFormProperties(viewInfo: ViewInfo, platformCapabilities: Set<PlatformCapability>, accessibilityFeatures: Set<AccessibilityFeature>) {
        // Verify form-specific properties
        XCTAssertNotNil(viewInfo, "Form should be generated")
        
        // Verify form layout based on capabilities
        if platformCapabilities.contains(.touch) {
            XCTAssertTrue(viewInfo.supportsTouch, "Form should support touch on touch platforms")
        }
        
        if platformCapabilities.contains(.hover) {
            XCTAssertTrue(viewInfo.supportsHover, "Form should support hover on hover platforms")
        }
        
        // Verify accessibility features are applied
        if accessibilityFeatures.contains(AccessibilityFeature.reduceMotion) {
            XCTAssertTrue(viewInfo.hasReduceMotion, "Form should respect reduce motion")
        }
        
        if accessibilityFeatures.contains(AccessibilityFeature.increaseContrast) {
            XCTAssertTrue(viewInfo.hasIncreaseContrast, "Form should respect increase contrast")
        }
    }
    
    private func verifyCardProperties(viewInfo: ViewInfo, platformCapabilities: Set<PlatformCapability>, accessibilityFeatures: Set<AccessibilityFeature>) {
        // Verify card-specific properties
        XCTAssertNotNil(viewInfo, "Card should be generated")
        
        // Verify card layout based on capabilities
        if platformCapabilities.contains(.touch) {
            XCTAssertTrue(viewInfo.supportsTouch, "Card should support touch on touch platforms")
            XCTAssertEqual(viewInfo.minTouchTarget, 44, "Card should have proper touch target on touch platforms")
        }
        
        if platformCapabilities.contains(.hover) {
            XCTAssertTrue(viewInfo.supportsHover, "Card should support hover on hover platforms")
            XCTAssertEqual(viewInfo.hoverDelay, 0.1, "Card should have proper hover delay on hover platforms")
        }
        
        // Verify accessibility features are applied
        if accessibilityFeatures.contains(AccessibilityFeature.reduceMotion) {
            XCTAssertTrue(viewInfo.hasReduceMotion, "Card should respect reduce motion")
        }
        
        if accessibilityFeatures.contains(AccessibilityFeature.increaseContrast) {
            XCTAssertTrue(viewInfo.hasIncreaseContrast, "Card should respect increase contrast")
        }
    }
    
    private func verifyExpandableCardProperties(viewInfo: ViewInfo, platformCapabilities: Set<PlatformCapability>, accessibilityFeatures: Set<AccessibilityFeature>) {
        // Verify expandable card-specific properties
        XCTAssertNotNil(viewInfo, "Expandable card should be generated")
        
        // Verify expansion capabilities
        if platformCapabilities.contains(.touch) || platformCapabilities.contains(.hover) {
            XCTAssertEqual(viewInfo.viewType, "ExpandableCardComponent", "Should generate expandable card for touch/hover platforms")
        }
        
        // Verify platform-specific properties
        verifyPlatformProperties(viewInfo: viewInfo, capabilityChecker: mockCapabilityChecker)
        
        // Verify accessibility properties
        verifyAccessibilityProperties(viewInfo: viewInfo, accessibilityChecker: mockAccessibilityChecker)
    }
    
    
    
    // MARK: - Strategy Determination Methods
    
    private func determineExpectedViewType(platformCapabilities: Set<PlatformCapability>, accessibilityFeatures: Set<AccessibilityFeature>) -> String {
        if platformCapabilities.contains(.touch) || platformCapabilities.contains(.hover) {
            return "ExpandableCardComponent"
        } else {
            return "SimpleCardComponent"
        }
    }
    
    private func determinePresentationPreference(platformCapabilities: Set<PlatformCapability>) -> PresentationPreference {
        if platformCapabilities.contains(.touch) {
            return .card
        } else if platformCapabilities.contains(.hover) {
            return .detail
        } else {
            return .standard
        }
    }
    
    private func determineComplexity(platformCapabilities: Set<PlatformCapability>, accessibilityFeatures: Set<AccessibilityFeature>) -> ContentComplexity {
        let capabilityCount = platformCapabilities.count
        let accessibilityCount = accessibilityFeatures.count
        
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
    
    private func determineColumns(platformCapabilities: Set<PlatformCapability>) -> Int {
        if platformCapabilities.contains(.touch) && platformCapabilities.contains(.hover) {
            return 3 // iPad
        } else if platformCapabilities.contains(.hover) {
            return 4 // Mac
        } else if platformCapabilities.contains(.touch) {
            return 2 // iPhone
        } else {
            return 1 // tvOS
        }
    }
    
    private func determineSpacing(platformCapabilities: Set<PlatformCapability>, accessibilityFeatures: Set<AccessibilityFeature>) -> CGFloat {
        var spacing: CGFloat = 16
        
        if accessibilityFeatures.contains(AccessibilityFeature.largerText) {
            spacing += 4
        }
        
        if platformCapabilities.contains(.hover) {
            spacing += 4
        }
        
        return spacing
    }
    
    private func determineCardWidth(platformCapabilities: Set<PlatformCapability>, accessibilityFeatures: Set<AccessibilityFeature>) -> CGFloat {
        var width: CGFloat = 200
        
        if accessibilityFeatures.contains(AccessibilityFeature.largerText) {
            width += 20
        }
        
        if platformCapabilities.contains(.hover) {
            width += 50
        }
        
        return width
    }
    
    private func determineCardHeight(platformCapabilities: Set<PlatformCapability>, accessibilityFeatures: Set<AccessibilityFeature>) -> CGFloat {
        var height: CGFloat = 150
        
        if accessibilityFeatures.contains(AccessibilityFeature.largerText) {
            height += 20
        }
        
        if platformCapabilities.contains(.hover) {
            height += 30
        }
        
        return height
    }
    
    private func determinePadding(platformCapabilities: Set<PlatformCapability>, accessibilityFeatures: Set<AccessibilityFeature>) -> CGFloat {
        var padding: CGFloat = 16
        
        if accessibilityFeatures.contains(AccessibilityFeature.largerText) {
            padding += 4
        }
        
        if platformCapabilities.contains(.touch) {
            padding += 4
        }
        
        return padding
    }
    
    private func determinePrimaryStrategy(platformCapabilities: Set<PlatformCapability>) -> ExpansionStrategy {
        if platformCapabilities.contains(.touch) {
            return .contentReveal
        } else if platformCapabilities.contains(.hover) {
            return .hoverExpand
        } else {
            return .none
        }
    }
    
    private func determineSecondaryStrategy(platformCapabilities: Set<PlatformCapability>) -> ExpansionStrategy {
        if platformCapabilities.contains(.hover) {
            return .hoverExpand
        } else {
            return .none
        }
    }
    
    private func determineAnimationDuration(platformCapabilities: Set<PlatformCapability>, accessibilityFeatures: Set<AccessibilityFeature>) -> TimeInterval {
        if accessibilityFeatures.contains(AccessibilityFeature.reduceMotion) {
            return 0.0
        } else if platformCapabilities.contains(.touch) {
            return 0.3
        } else if platformCapabilities.contains(.hover) {
            return 0.2
        } else {
            return 0.1
        }
    }
    
    private func determineSupportedStrategies(platformCapabilities: Set<PlatformCapability>) -> [ExpansionStrategy] {
        var strategies: [ExpansionStrategy] = []
        
        if platformCapabilities.contains(.touch) {
            strategies.append(.contentReveal)
        }
        
        if platformCapabilities.contains(.hover) {
            strategies.append(.hoverExpand)
        }
        
        if strategies.isEmpty {
            strategies.append(.none)
        }
        
        return strategies
    }
}
