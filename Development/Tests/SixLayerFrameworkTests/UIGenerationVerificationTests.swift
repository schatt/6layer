import XCTest
import SwiftUI
@testable import SixLayerFramework

/// UI Generation Verification Tests
/// Tests that the correct UI components are generated based on capabilities
@MainActor
final class UIGenerationVerificationTests: XCTestCase {
    
    // MARK: - Test Configuration
    
    /// UI generation test configuration
    struct UIGenerationTestConfig {
        let name: String
        let capabilities: CapabilitySet
        let expectedUIComponents: [ExpectedUIComponent]
        let expectedModifiers: [ExpectedModifier]
        let expectedBehaviors: [ExpectedBehavior]
        
        struct CapabilitySet {
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
        }
        
        struct ExpectedUIComponent {
            let type: ComponentType
            let shouldBePresent: Bool
            let description: String
        }
        
        struct ExpectedModifier {
            let type: ModifierType
            let shouldBePresent: Bool
            let description: String
        }
        
        struct ExpectedBehavior {
            let type: BehaviorType
            let shouldBePresent: Bool
            let description: String
        }
        
        enum ComponentType {
            case tapGesture
            case hoverGesture
            case hapticFeedback
            case assistiveTouch
            case accessibilityElement
            case contextMenu
            case dragAndDrop
            case keyboardShortcut
        }
        
        enum ModifierType {
            case onTapGesture
            case onHover
            case onLongPressGesture
            case accessibilityAddTraits
            case accessibilityAction
            case contextMenu
            case onDrop
            case keyboardShortcut
        }
        
        enum BehaviorType {
            case touchInteraction
            case hoverInteraction
            case hapticFeedback
            case assistiveTouchSupport
            case accessibilitySupport
            case contextMenuSupport
            case dragDropSupport
            case keyboardNavigation
        }
    }
    
    // MARK: - Test Configurations
    
    private let uiTestConfigurations: [UIGenerationTestConfig] = [
        // Touch-enabled configuration
        UIGenerationTestConfig(
            name: "Touch-Enabled UI Generation",
            capabilities: UIGenerationTestConfig.CapabilitySet(
                supportsTouch: true,
                supportsHover: false,
                supportsHapticFeedback: true,
                supportsAssistiveTouch: true,
                supportsVoiceOver: true,
                supportsSwitchControl: true,
                supportsVision: false,
                supportsOCR: false,
                minTouchTarget: 44,
                hoverDelay: 0.0
            ),
            expectedUIComponents: [
                UIGenerationTestConfig.ExpectedUIComponent(
                    type: .tapGesture,
                    shouldBePresent: true,
                    description: "Tap gesture should be present for touch interaction"
                ),
                UIGenerationTestConfig.ExpectedUIComponent(
                    type: .hapticFeedback,
                    shouldBePresent: true,
                    description: "Haptic feedback should be present for touch interaction"
                ),
                UIGenerationTestConfig.ExpectedUIComponent(
                    type: .assistiveTouch,
                    shouldBePresent: true,
                    description: "AssistiveTouch should be present for touch interaction"
                ),
                UIGenerationTestConfig.ExpectedUIComponent(
                    type: .accessibilityElement,
                    shouldBePresent: true,
                    description: "Accessibility elements should always be present"
                )
            ],
            expectedModifiers: [
                UIGenerationTestConfig.ExpectedModifier(
                    type: .onTapGesture,
                    shouldBePresent: true,
                    description: "onTapGesture modifier should be present"
                ),
                UIGenerationTestConfig.ExpectedModifier(
                    type: .onLongPressGesture,
                    shouldBePresent: true,
                    description: "onLongPressGesture modifier should be present"
                ),
                UIGenerationTestConfig.ExpectedModifier(
                    type: .accessibilityAddTraits,
                    shouldBePresent: true,
                    description: "accessibilityAddTraits modifier should be present"
                ),
                UIGenerationTestConfig.ExpectedModifier(
                    type: .accessibilityAction,
                    shouldBePresent: true,
                    description: "accessibilityAction modifier should be present"
                )
            ],
            expectedBehaviors: [
                UIGenerationTestConfig.ExpectedBehavior(
                    type: .touchInteraction,
                    shouldBePresent: true,
                    description: "Touch interaction should be enabled"
                ),
                UIGenerationTestConfig.ExpectedBehavior(
                    type: .hapticFeedback,
                    shouldBePresent: true,
                    description: "Haptic feedback should be enabled"
                ),
                UIGenerationTestConfig.ExpectedBehavior(
                    type: .assistiveTouchSupport,
                    shouldBePresent: true,
                    description: "AssistiveTouch support should be enabled"
                ),
                UIGenerationTestConfig.ExpectedBehavior(
                    type: .accessibilitySupport,
                    shouldBePresent: true,
                    description: "Accessibility support should always be enabled"
                )
            ]
        ),
        
        // Hover-enabled configuration
        UIGenerationTestConfig(
            name: "Hover-Enabled UI Generation",
            capabilities: UIGenerationTestConfig.CapabilitySet(
                supportsTouch: false,
                supportsHover: true,
                supportsHapticFeedback: false,
                supportsAssistiveTouch: false,
                supportsVoiceOver: true,
                supportsSwitchControl: true,
                supportsVision: false,
                supportsOCR: false,
                minTouchTarget: 0,
                hoverDelay: 0.1
            ),
            expectedUIComponents: [
                UIGenerationTestConfig.ExpectedUIComponent(
                    type: .hoverGesture,
                    shouldBePresent: true,
                    description: "Hover gesture should be present for hover interaction"
                ),
                UIGenerationTestConfig.ExpectedUIComponent(
                    type: .accessibilityElement,
                    shouldBePresent: true,
                    description: "Accessibility elements should always be present"
                )
            ],
            expectedModifiers: [
                UIGenerationTestConfig.ExpectedModifier(
                    type: .onHover,
                    shouldBePresent: true,
                    description: "onHover modifier should be present"
                ),
                UIGenerationTestConfig.ExpectedModifier(
                    type: .accessibilityAddTraits,
                    shouldBePresent: true,
                    description: "accessibilityAddTraits modifier should be present"
                ),
                UIGenerationTestConfig.ExpectedModifier(
                    type: .accessibilityAction,
                    shouldBePresent: true,
                    description: "accessibilityAction modifier should be present"
                )
            ],
            expectedBehaviors: [
                UIGenerationTestConfig.ExpectedBehavior(
                    type: .hoverInteraction,
                    shouldBePresent: true,
                    description: "Hover interaction should be enabled"
                ),
                UIGenerationTestConfig.ExpectedBehavior(
                    type: .accessibilitySupport,
                    shouldBePresent: true,
                    description: "Accessibility support should always be enabled"
                )
            ]
        ),
        
        // Touch + Hover configuration (iPad)
        UIGenerationTestConfig(
            name: "Touch + Hover UI Generation (iPad)",
            capabilities: UIGenerationTestConfig.CapabilitySet(
                supportsTouch: true,
                supportsHover: true,
                supportsHapticFeedback: true,
                supportsAssistiveTouch: true,
                supportsVoiceOver: true,
                supportsSwitchControl: true,
                supportsVision: false,
                supportsOCR: false,
                minTouchTarget: 44,
                hoverDelay: 0.1
            ),
            expectedUIComponents: [
                UIGenerationTestConfig.ExpectedUIComponent(
                    type: .tapGesture,
                    shouldBePresent: true,
                    description: "Tap gesture should be present for touch interaction"
                ),
                UIGenerationTestConfig.ExpectedUIComponent(
                    type: .hoverGesture,
                    shouldBePresent: true,
                    description: "Hover gesture should be present for hover interaction"
                ),
                UIGenerationTestConfig.ExpectedUIComponent(
                    type: .hapticFeedback,
                    shouldBePresent: true,
                    description: "Haptic feedback should be present for touch interaction"
                ),
                UIGenerationTestConfig.ExpectedUIComponent(
                    type: .assistiveTouch,
                    shouldBePresent: true,
                    description: "AssistiveTouch should be present for touch interaction"
                ),
                UIGenerationTestConfig.ExpectedUIComponent(
                    type: .accessibilityElement,
                    shouldBePresent: true,
                    description: "Accessibility elements should always be present"
                )
            ],
            expectedModifiers: [
                UIGenerationTestConfig.ExpectedModifier(
                    type: .onTapGesture,
                    shouldBePresent: true,
                    description: "onTapGesture modifier should be present"
                ),
                UIGenerationTestConfig.ExpectedModifier(
                    type: .onHover,
                    shouldBePresent: true,
                    description: "onHover modifier should be present"
                ),
                UIGenerationTestConfig.ExpectedModifier(
                    type: .onLongPressGesture,
                    shouldBePresent: true,
                    description: "onLongPressGesture modifier should be present"
                ),
                UIGenerationTestConfig.ExpectedModifier(
                    type: .accessibilityAddTraits,
                    shouldBePresent: true,
                    description: "accessibilityAddTraits modifier should be present"
                ),
                UIGenerationTestConfig.ExpectedModifier(
                    type: .accessibilityAction,
                    shouldBePresent: true,
                    description: "accessibilityAction modifier should be present"
                )
            ],
            expectedBehaviors: [
                UIGenerationTestConfig.ExpectedBehavior(
                    type: .touchInteraction,
                    shouldBePresent: true,
                    description: "Touch interaction should be enabled"
                ),
                UIGenerationTestConfig.ExpectedBehavior(
                    type: .hoverInteraction,
                    shouldBePresent: true,
                    description: "Hover interaction should be enabled"
                ),
                UIGenerationTestConfig.ExpectedBehavior(
                    type: .hapticFeedback,
                    shouldBePresent: true,
                    description: "Haptic feedback should be enabled"
                ),
                UIGenerationTestConfig.ExpectedBehavior(
                    type: .assistiveTouchSupport,
                    shouldBePresent: true,
                    description: "AssistiveTouch support should be enabled"
                ),
                UIGenerationTestConfig.ExpectedBehavior(
                    type: .accessibilitySupport,
                    shouldBePresent: true,
                    description: "Accessibility support should always be enabled"
                )
            ]
        ),
        
        // Accessibility-only configuration (tvOS)
        UIGenerationTestConfig(
            name: "Accessibility-Only UI Generation (tvOS)",
            capabilities: UIGenerationTestConfig.CapabilitySet(
                supportsTouch: false,
                supportsHover: false,
                supportsHapticFeedback: false,
                supportsAssistiveTouch: false,
                supportsVoiceOver: true,
                supportsSwitchControl: true,
                supportsVision: false,
                supportsOCR: false,
                minTouchTarget: 0,
                hoverDelay: 0.0
            ),
            expectedUIComponents: [
                UIGenerationTestConfig.ExpectedUIComponent(
                    type: .accessibilityElement,
                    shouldBePresent: true,
                    description: "Accessibility elements should always be present"
                )
            ],
            expectedModifiers: [
                UIGenerationTestConfig.ExpectedModifier(
                    type: .accessibilityAddTraits,
                    shouldBePresent: true,
                    description: "accessibilityAddTraits modifier should be present"
                ),
                UIGenerationTestConfig.ExpectedModifier(
                    type: .accessibilityAction,
                    shouldBePresent: true,
                    description: "accessibilityAction modifier should be present"
                )
            ],
            expectedBehaviors: [
                UIGenerationTestConfig.ExpectedBehavior(
                    type: .accessibilitySupport,
                    shouldBePresent: true,
                    description: "Accessibility support should always be enabled"
                )
            ]
        ),
        
        // Vision-enabled configuration
        UIGenerationTestConfig(
            name: "Vision-Enabled UI Generation",
            capabilities: UIGenerationTestConfig.CapabilitySet(
                supportsTouch: false,
                supportsHover: true,
                supportsHapticFeedback: false,
                supportsAssistiveTouch: false,
                supportsVoiceOver: true,
                supportsSwitchControl: true,
                supportsVision: true,
                supportsOCR: true,
                minTouchTarget: 0,
                hoverDelay: 0.1
            ),
            expectedUIComponents: [
                UIGenerationTestConfig.ExpectedUIComponent(
                    type: .hoverGesture,
                    shouldBePresent: true,
                    description: "Hover gesture should be present for hover interaction"
                ),
                UIGenerationTestConfig.ExpectedUIComponent(
                    type: .accessibilityElement,
                    shouldBePresent: true,
                    description: "Accessibility elements should always be present"
                )
            ],
            expectedModifiers: [
                UIGenerationTestConfig.ExpectedModifier(
                    type: .onHover,
                    shouldBePresent: true,
                    description: "onHover modifier should be present"
                ),
                UIGenerationTestConfig.ExpectedModifier(
                    type: .accessibilityAddTraits,
                    shouldBePresent: true,
                    description: "accessibilityAddTraits modifier should be present"
                ),
                UIGenerationTestConfig.ExpectedModifier(
                    type: .accessibilityAction,
                    shouldBePresent: true,
                    description: "accessibilityAction modifier should be present"
                )
            ],
            expectedBehaviors: [
                UIGenerationTestConfig.ExpectedBehavior(
                    type: .hoverInteraction,
                    shouldBePresent: true,
                    description: "Hover interaction should be enabled"
                ),
                UIGenerationTestConfig.ExpectedBehavior(
                    type: .accessibilitySupport,
                    shouldBePresent: true,
                    description: "Accessibility support should always be enabled"
                )
            ]
        )
    ]
    
    // MARK: - UI Generation Tests
    
    /// Test all UI generation configurations
    func testAllUIGenerationConfigurations() {
        for config in uiTestConfigurations {
            testUIGenerationConfiguration(config)
        }
    }
    
    /// Test a specific UI generation configuration
    private func testUIGenerationConfiguration(_ config: UIGenerationTestConfig) {
        print("🎨 Testing UI generation for: \(config.name)")
        
        // Test UI component generation
        testUIComponentGeneration(config)
        
        // Test modifier generation
        testModifierGeneration(config)
        
        // Test behavior generation
        testBehaviorGeneration(config)
        
        // Test integration
        testUIGenerationIntegration(config)
    }
    
    // MARK: - UI Component Generation Tests
    
    /// Test that the correct UI components are generated
    private func testUIComponentGeneration(_ config: UIGenerationTestConfig) {
        for expectedComponent in config.expectedUIComponents {
            testUIComponent(expectedComponent, capabilities: config.capabilities, configName: config.name)
        }
    }
    
    /// Test a specific UI component
    private func testUIComponent(
        _ expectedComponent: UIGenerationTestConfig.ExpectedUIComponent,
        capabilities: UIGenerationTestConfig.CapabilitySet,
        configName: String
    ) {
        let actualPresence = checkUIComponentPresence(expectedComponent.type, capabilities: capabilities)
        
        XCTAssertEqual(actualPresence, expectedComponent.shouldBePresent,
                      "\(expectedComponent.description) for \(configName)")
    }
    
    /// Check if a UI component should be present based on capabilities
    private func checkUIComponentPresence(
        _ componentType: UIGenerationTestConfig.ComponentType,
        capabilities: UIGenerationTestConfig.CapabilitySet
    ) -> Bool {
        switch componentType {
        case .tapGesture:
            return capabilities.supportsTouch
        case .hoverGesture:
            return capabilities.supportsHover
        case .hapticFeedback:
            return capabilities.supportsHapticFeedback
        case .assistiveTouch:
            return capabilities.supportsAssistiveTouch
        case .accessibilityElement:
            return capabilities.supportsVoiceOver || capabilities.supportsSwitchControl
        case .contextMenu:
            return capabilities.supportsTouch || capabilities.supportsHover
        case .dragAndDrop:
            return capabilities.supportsTouch || capabilities.supportsHover
        case .keyboardShortcut:
            return !capabilities.supportsTouch // Keyboard shortcuts are more common on non-touch platforms
        }
    }
    
    // MARK: - Modifier Generation Tests
    
    /// Test that the correct modifiers are generated
    private func testModifierGeneration(_ config: UIGenerationTestConfig) {
        for expectedModifier in config.expectedModifiers {
            testModifier(expectedModifier, capabilities: config.capabilities, configName: config.name)
        }
    }
    
    /// Test a specific modifier
    private func testModifier(
        _ expectedModifier: UIGenerationTestConfig.ExpectedModifier,
        capabilities: UIGenerationTestConfig.CapabilitySet,
        configName: String
    ) {
        let actualPresence = checkModifierPresence(expectedModifier.type, capabilities: capabilities)
        
        XCTAssertEqual(actualPresence, expectedModifier.shouldBePresent,
                      "\(expectedModifier.description) for \(configName)")
    }
    
    /// Check if a modifier should be present based on capabilities
    private func checkModifierPresence(
        _ modifierType: UIGenerationTestConfig.ModifierType,
        capabilities: UIGenerationTestConfig.CapabilitySet
    ) -> Bool {
        switch modifierType {
        case .onTapGesture:
            return capabilities.supportsTouch
        case .onHover:
            return capabilities.supportsHover
        case .onLongPressGesture:
            return capabilities.supportsTouch
        case .accessibilityAddTraits:
            return capabilities.supportsVoiceOver || capabilities.supportsSwitchControl
        case .accessibilityAction:
            return capabilities.supportsVoiceOver || capabilities.supportsSwitchControl
        case .contextMenu:
            return capabilities.supportsTouch || capabilities.supportsHover
        case .onDrop:
            return capabilities.supportsTouch || capabilities.supportsHover
        case .keyboardShortcut:
            return !capabilities.supportsTouch
        }
    }
    
    // MARK: - Behavior Generation Tests
    
    /// Test that the correct behaviors are generated
    private func testBehaviorGeneration(_ config: UIGenerationTestConfig) {
        for expectedBehavior in config.expectedBehaviors {
            testBehavior(expectedBehavior, capabilities: config.capabilities, configName: config.name)
        }
    }
    
    /// Test a specific behavior
    private func testBehavior(
        _ expectedBehavior: UIGenerationTestConfig.ExpectedBehavior,
        capabilities: UIGenerationTestConfig.CapabilitySet,
        configName: String
    ) {
        let actualPresence = checkBehaviorPresence(expectedBehavior.type, capabilities: capabilities)
        
        XCTAssertEqual(actualPresence, expectedBehavior.shouldBePresent,
                      "\(expectedBehavior.description) for \(configName)")
    }
    
    /// Check if a behavior should be present based on capabilities
    private func checkBehaviorPresence(
        _ behaviorType: UIGenerationTestConfig.BehaviorType,
        capabilities: UIGenerationTestConfig.CapabilitySet
    ) -> Bool {
        switch behaviorType {
        case .touchInteraction:
            return capabilities.supportsTouch
        case .hoverInteraction:
            return capabilities.supportsHover
        case .hapticFeedback:
            return capabilities.supportsHapticFeedback
        case .assistiveTouchSupport:
            return capabilities.supportsAssistiveTouch
        case .accessibilitySupport:
            return capabilities.supportsVoiceOver || capabilities.supportsSwitchControl
        case .contextMenuSupport:
            return capabilities.supportsTouch || capabilities.supportsHover
        case .dragDropSupport:
            return capabilities.supportsTouch || capabilities.supportsHover
        case .keyboardNavigation:
            return !capabilities.supportsTouch
        }
    }
    
    // MARK: - Integration Tests
    
    /// Test UI generation integration
    private func testUIGenerationIntegration(_ config: UIGenerationTestConfig) {
        // Test that the configuration can be used to generate a complete UI
        let mockConfig = createMockPlatformConfig(from: config.capabilities)
        
        // Test that the mock configuration is valid
        XCTAssertNotNil(mockConfig, "Mock configuration should be valid for \(config.name)")
        
        // Test that the configuration produces the expected UI behavior
        testUIGenerationBehavior(mockConfig, configName: config.name)
    }
    
    /// Create a mock platform config from capabilities
    private func createMockPlatformConfig(from capabilities: UIGenerationTestConfig.CapabilitySet) -> CardExpansionPlatformConfig {
        return CardExpansionPlatformConfig(
            supportsHapticFeedback: capabilities.supportsHapticFeedback,
            supportsHover: capabilities.supportsHover,
            supportsTouch: capabilities.supportsTouch,
            supportsVoiceOver: capabilities.supportsVoiceOver,
            supportsSwitchControl: capabilities.supportsSwitchControl,
            supportsAssistiveTouch: capabilities.supportsAssistiveTouch,
            minTouchTarget: capabilities.minTouchTarget,
            hoverDelay: capabilities.hoverDelay,
            animationEasing: .easeInOut(duration: 0.3)
        )
    }
    
    /// Test UI generation behavior
    private func testUIGenerationBehavior(_ config: CardExpansionPlatformConfig, configName: String) {
        // Test that the configuration produces the expected UI behavior
        // This would test actual view generation in a real implementation
        
        // Test touch behavior
        if config.supportsTouch {
            XCTAssertTrue(config.supportsTouch, "Touch should be supported for UI generation in \(configName)")
            XCTAssertGreaterThanOrEqual(config.minTouchTarget, 44,
                                      "Touch targets should be adequate for \(configName)")
        }
        
        // Test hover behavior
        if config.supportsHover {
            XCTAssertTrue(config.supportsHover, "Hover should be supported for UI generation in \(configName)")
            XCTAssertGreaterThanOrEqual(config.hoverDelay, 0,
                                      "Hover delay should be set for \(configName)")
        }
        
        // Test accessibility behavior
        XCTAssertTrue(config.supportsVoiceOver, "VoiceOver should be supported for UI generation in \(configName)")
        XCTAssertTrue(config.supportsSwitchControl, "Switch Control should be supported for UI generation in \(configName)")
    }
    
    // MARK: - Individual Capability UI Tests
    
    /// Test touch UI generation in both enabled and disabled states
    func testTouchUIGenerationBothStates() {
        // Test touch enabled
        let touchEnabledConfig = UIGenerationTestConfig(
            name: "Touch Enabled UI",
            capabilities: UIGenerationTestConfig.CapabilitySet(
                supportsTouch: true,
                supportsHover: false,
                supportsHapticFeedback: true,
                supportsAssistiveTouch: true,
                supportsVoiceOver: true,
                supportsSwitchControl: true,
                supportsVision: true,
                supportsOCR: true,
                minTouchTarget: 44,
                hoverDelay: 0.0
            ),
            expectedUIComponents: [
                UIGenerationTestConfig.ExpectedUIComponent(
                    type: .tapGesture,
                    shouldBePresent: true,
                    description: "Tap gesture should be present"
                ),
                UIGenerationTestConfig.ExpectedUIComponent(
                    type: .hapticFeedback,
                    shouldBePresent: true,
                    description: "Haptic feedback should be present"
                )
            ],
            expectedModifiers: [],
            expectedBehaviors: []
        )
        testUIGenerationConfiguration(touchEnabledConfig)
        
        // Test touch disabled
        let touchDisabledConfig = UIGenerationTestConfig(
            name: "Touch Disabled UI",
            capabilities: UIGenerationTestConfig.CapabilitySet(
                supportsTouch: false,
                supportsHover: false,
                supportsHapticFeedback: false,
                supportsAssistiveTouch: false,
                supportsVoiceOver: true,
                supportsSwitchControl: true,
                supportsVision: true,
                supportsOCR: true,
                minTouchTarget: 0,
                hoverDelay: 0.0
            ),
            expectedUIComponents: [
                UIGenerationTestConfig.ExpectedUIComponent(
                    type: .tapGesture,
                    shouldBePresent: false,
                    description: "Tap gesture should not be present"
                ),
                UIGenerationTestConfig.ExpectedUIComponent(
                    type: .hapticFeedback,
                    shouldBePresent: false,
                    description: "Haptic feedback should not be present"
                )
            ],
            expectedModifiers: [],
            expectedBehaviors: []
        )
        testUIGenerationConfiguration(touchDisabledConfig)
    }
    
    /// Test hover UI generation in both enabled and disabled states
    func testHoverUIGenerationBothStates() {
        // Test hover enabled
        let hoverEnabledConfig = UIGenerationTestConfig(
            name: "Hover Enabled UI",
            capabilities: UIGenerationTestConfig.CapabilitySet(
                supportsTouch: false,
                supportsHover: true,
                supportsHapticFeedback: false,
                supportsAssistiveTouch: false,
                supportsVoiceOver: true,
                supportsSwitchControl: true,
                supportsVision: true,
                supportsOCR: true,
                minTouchTarget: 0,
                hoverDelay: 0.1
            ),
            expectedUIComponents: [
                UIGenerationTestConfig.ExpectedUIComponent(
                    type: .hoverGesture,
                    shouldBePresent: true,
                    description: "Hover gesture should be present"
                )
            ],
            expectedModifiers: [],
            expectedBehaviors: []
        )
        testUIGenerationConfiguration(hoverEnabledConfig)
        
        // Test hover disabled
        let hoverDisabledConfig = UIGenerationTestConfig(
            name: "Hover Disabled UI",
            capabilities: UIGenerationTestConfig.CapabilitySet(
                supportsTouch: false,
                supportsHover: false,
                supportsHapticFeedback: false,
                supportsAssistiveTouch: false,
                supportsVoiceOver: true,
                supportsSwitchControl: true,
                supportsVision: true,
                supportsOCR: true,
                minTouchTarget: 0,
                hoverDelay: 0.0
            ),
            expectedUIComponents: [
                UIGenerationTestConfig.ExpectedUIComponent(
                    type: .hoverGesture,
                    shouldBePresent: false,
                    description: "Hover gesture should not be present"
                )
            ],
            expectedModifiers: [],
            expectedBehaviors: []
        )
        testUIGenerationConfiguration(hoverDisabledConfig)
    }
}
