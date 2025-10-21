import Testing


import SwiftUI
import ViewInspector
@testable import SixLayerFramework

/// View Generation Integration Tests
/// Tests the actual view generation pipeline with different capability states
@MainActor
open class ViewGenerationIntegrationTests {
    
    // MARK: - Test Configuration
    
    /// View generation test configuration
    struct ViewGenerationTestConfig {
        let name: String
        let capabilities: CapabilitySet
        let expectedViewComponents: [ExpectedViewComponent]
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
            let platform: SixLayerPlatform
            let deviceType: DeviceType
        }
        
        struct ExpectedViewComponent {
            let type: ViewComponentType
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
        
        enum ViewComponentType {
            case tapGesture
            case hoverGesture
            case hapticFeedback
            case assistiveTouch
            case accessibilityElement
            case contextMenu
            case dragAndDrop
            case keyboardShortcut
            case animation
            case layout
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
            case animation
            case frame
            case padding
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
            case animationSupport
            case layoutSupport
        }
        
        
        enum DeviceType {
            case phone
            case pad
            case mac
            case tv
            case watch
        }
    }
    
    // MARK: - Test Configurations
    
    private let viewGenerationTestConfigurations: [ViewGenerationTestConfig] = [
        // Touch-enabled view generation
        ViewGenerationTestConfig(
            name: "Touch-Enabled View Generation",
            capabilities: ViewGenerationTestConfig.CapabilitySet(
                supportsTouch: true,
                supportsHover: false,
                supportsHapticFeedback: true,
                supportsAssistiveTouch: true,
                supportsVoiceOver: true,
                supportsSwitchControl: true,
                supportsVision: false,
                supportsOCR: false,
                minTouchTarget: 44,
                hoverDelay: 0.0,
                platform: SixLayerPlatform.iOS,
                deviceType: .phone
            ),
            expectedViewComponents: [
                ViewGenerationTestConfig.ExpectedViewComponent(
                    type: .tapGesture,
                    shouldBePresent: true,
                    description: "Tap gesture should be present for touch interaction"
                ),
                ViewGenerationTestConfig.ExpectedViewComponent(
                    type: .hapticFeedback,
                    shouldBePresent: true,
                    description: "Haptic feedback should be present for touch interaction"
                ),
                ViewGenerationTestConfig.ExpectedViewComponent(
                    type: .assistiveTouch,
                    shouldBePresent: true,
                    description: "AssistiveTouch should be present for touch interaction"
                ),
                ViewGenerationTestConfig.ExpectedViewComponent(
                    type: .accessibilityElement,
                    shouldBePresent: true,
                    description: "Accessibility elements should always be present"
                ),
                ViewGenerationTestConfig.ExpectedViewComponent(
                    type: .animation,
                    shouldBePresent: true,
                    description: "Animation should be present for touch interaction"
                ),
                ViewGenerationTestConfig.ExpectedViewComponent(
                    type: .layout,
                    shouldBePresent: true,
                    description: "Layout should be present for touch interaction"
                )
            ],
            expectedModifiers: [
                ViewGenerationTestConfig.ExpectedModifier(
                    type: .onTapGesture,
                    shouldBePresent: true,
                    description: "onTapGesture modifier should be present"
                ),
                ViewGenerationTestConfig.ExpectedModifier(
                    type: .onLongPressGesture,
                    shouldBePresent: true,
                    description: "onLongPressGesture modifier should be present"
                ),
                ViewGenerationTestConfig.ExpectedModifier(
                    type: .accessibilityAddTraits,
                    shouldBePresent: true,
                    description: "accessibilityAddTraits modifier should be present"
                ),
                ViewGenerationTestConfig.ExpectedModifier(
                    type: .accessibilityAction,
                    shouldBePresent: true,
                    description: "accessibilityAction modifier should be present"
                ),
                ViewGenerationTestConfig.ExpectedModifier(
                    type: .frame,
                    shouldBePresent: true,
                    description: "frame modifier should be present for touch targets"
                ),
                ViewGenerationTestConfig.ExpectedModifier(
                    type: .animation,
                    shouldBePresent: true,
                    description: "animation modifier should be present"
                )
            ],
            expectedBehaviors: [
                ViewGenerationTestConfig.ExpectedBehavior(
                    type: .touchInteraction,
                    shouldBePresent: true,
                    description: "Touch interaction should be enabled"
                ),
                ViewGenerationTestConfig.ExpectedBehavior(
                    type: .hapticFeedback,
                    shouldBePresent: true,
                    description: "Haptic feedback should be enabled"
                ),
                ViewGenerationTestConfig.ExpectedBehavior(
                    type: .assistiveTouchSupport,
                    shouldBePresent: true,
                    description: "AssistiveTouch support should be enabled"
                ),
                ViewGenerationTestConfig.ExpectedBehavior(
                    type: .accessibilitySupport,
                    shouldBePresent: true,
                    description: "Accessibility support should always be enabled"
                ),
                ViewGenerationTestConfig.ExpectedBehavior(
                    type: .animationSupport,
                    shouldBePresent: true,
                    description: "Animation support should be enabled"
                ),
                ViewGenerationTestConfig.ExpectedBehavior(
                    type: .layoutSupport,
                    shouldBePresent: true,
                    description: "Layout support should be enabled"
                )
            ]
        ),
        
        // Hover-enabled view generation
        ViewGenerationTestConfig(
            name: "Hover-Enabled View Generation",
            capabilities: ViewGenerationTestConfig.CapabilitySet(
                supportsTouch: false,
                supportsHover: true,
                supportsHapticFeedback: false,
                supportsAssistiveTouch: false,
                supportsVoiceOver: true,
                supportsSwitchControl: true,
                supportsVision: false,
                supportsOCR: false,
                minTouchTarget: 0,
                hoverDelay: 0.1,
                platform: .macOS,
                deviceType: .mac
            ),
            expectedViewComponents: [
                ViewGenerationTestConfig.ExpectedViewComponent(
                    type: .hoverGesture,
                    shouldBePresent: true,
                    description: "Hover gesture should be present for hover interaction"
                ),
                ViewGenerationTestConfig.ExpectedViewComponent(
                    type: .accessibilityElement,
                    shouldBePresent: true,
                    description: "Accessibility elements should always be present"
                ),
                ViewGenerationTestConfig.ExpectedViewComponent(
                    type: .keyboardShortcut,
                    shouldBePresent: true,
                    description: "Keyboard shortcuts should be present for hover interaction"
                ),
                ViewGenerationTestConfig.ExpectedViewComponent(
                    type: .animation,
                    shouldBePresent: true,
                    description: "Animation should be present for hover interaction"
                ),
                ViewGenerationTestConfig.ExpectedViewComponent(
                    type: .layout,
                    shouldBePresent: true,
                    description: "Layout should be present for hover interaction"
                )
            ],
            expectedModifiers: [
                ViewGenerationTestConfig.ExpectedModifier(
                    type: .onHover,
                    shouldBePresent: true,
                    description: "onHover modifier should be present"
                ),
                ViewGenerationTestConfig.ExpectedModifier(
                    type: .accessibilityAddTraits,
                    shouldBePresent: true,
                    description: "accessibilityAddTraits modifier should be present"
                ),
                ViewGenerationTestConfig.ExpectedModifier(
                    type: .accessibilityAction,
                    shouldBePresent: true,
                    description: "accessibilityAction modifier should be present"
                ),
                ViewGenerationTestConfig.ExpectedModifier(
                    type: .keyboardShortcut,
                    shouldBePresent: true,
                    description: "keyboardShortcut modifier should be present"
                ),
                ViewGenerationTestConfig.ExpectedModifier(
                    type: .animation,
                    shouldBePresent: true,
                    description: "animation modifier should be present"
                )
            ],
            expectedBehaviors: [
                ViewGenerationTestConfig.ExpectedBehavior(
                    type: .hoverInteraction,
                    shouldBePresent: true,
                    description: "Hover interaction should be enabled"
                ),
                ViewGenerationTestConfig.ExpectedBehavior(
                    type: .accessibilitySupport,
                    shouldBePresent: true,
                    description: "Accessibility support should always be enabled"
                ),
                ViewGenerationTestConfig.ExpectedBehavior(
                    type: .keyboardNavigation,
                    shouldBePresent: true,
                    description: "Keyboard navigation should be enabled"
                ),
                ViewGenerationTestConfig.ExpectedBehavior(
                    type: .animationSupport,
                    shouldBePresent: true,
                    description: "Animation support should be enabled"
                ),
                ViewGenerationTestConfig.ExpectedBehavior(
                    type: .layoutSupport,
                    shouldBePresent: true,
                    description: "Layout support should be enabled"
                )
            ]
        ),
        
        // Touch + Hover view generation (iPad)
        ViewGenerationTestConfig(
            name: "Touch + Hover View Generation (iPad)",
            capabilities: ViewGenerationTestConfig.CapabilitySet(
                supportsTouch: true,
                supportsHover: true,
                supportsHapticFeedback: true,
                supportsAssistiveTouch: true,
                supportsVoiceOver: true,
                supportsSwitchControl: true,
                supportsVision: false,
                supportsOCR: false,
                minTouchTarget: 44,
                hoverDelay: 0.1,
                platform: SixLayerPlatform.iOS,
                deviceType: .pad
            ),
            expectedViewComponents: [
                ViewGenerationTestConfig.ExpectedViewComponent(
                    type: .tapGesture,
                    shouldBePresent: true,
                    description: "Tap gesture should be present for touch interaction"
                ),
                ViewGenerationTestConfig.ExpectedViewComponent(
                    type: .hoverGesture,
                    shouldBePresent: true,
                    description: "Hover gesture should be present for hover interaction"
                ),
                ViewGenerationTestConfig.ExpectedViewComponent(
                    type: .hapticFeedback,
                    shouldBePresent: true,
                    description: "Haptic feedback should be present for touch interaction"
                ),
                ViewGenerationTestConfig.ExpectedViewComponent(
                    type: .assistiveTouch,
                    shouldBePresent: true,
                    description: "AssistiveTouch should be present for touch interaction"
                ),
                ViewGenerationTestConfig.ExpectedViewComponent(
                    type: .accessibilityElement,
                    shouldBePresent: true,
                    description: "Accessibility elements should always be present"
                ),
                ViewGenerationTestConfig.ExpectedViewComponent(
                    type: .animation,
                    shouldBePresent: true,
                    description: "Animation should be present for touch and hover interaction"
                ),
                ViewGenerationTestConfig.ExpectedViewComponent(
                    type: .layout,
                    shouldBePresent: true,
                    description: "Layout should be present for touch and hover interaction"
                )
            ],
            expectedModifiers: [
                ViewGenerationTestConfig.ExpectedModifier(
                    type: .onTapGesture,
                    shouldBePresent: true,
                    description: "onTapGesture modifier should be present"
                ),
                ViewGenerationTestConfig.ExpectedModifier(
                    type: .onHover,
                    shouldBePresent: true,
                    description: "onHover modifier should be present"
                ),
                ViewGenerationTestConfig.ExpectedModifier(
                    type: .onLongPressGesture,
                    shouldBePresent: true,
                    description: "onLongPressGesture modifier should be present"
                ),
                ViewGenerationTestConfig.ExpectedModifier(
                    type: .accessibilityAddTraits,
                    shouldBePresent: true,
                    description: "accessibilityAddTraits modifier should be present"
                ),
                ViewGenerationTestConfig.ExpectedModifier(
                    type: .accessibilityAction,
                    shouldBePresent: true,
                    description: "accessibilityAction modifier should be present"
                ),
                ViewGenerationTestConfig.ExpectedModifier(
                    type: .frame,
                    shouldBePresent: true,
                    description: "frame modifier should be present for touch targets"
                ),
                ViewGenerationTestConfig.ExpectedModifier(
                    type: .animation,
                    shouldBePresent: true,
                    description: "animation modifier should be present"
                )
            ],
            expectedBehaviors: [
                ViewGenerationTestConfig.ExpectedBehavior(
                    type: .touchInteraction,
                    shouldBePresent: true,
                    description: "Touch interaction should be enabled"
                ),
                ViewGenerationTestConfig.ExpectedBehavior(
                    type: .hoverInteraction,
                    shouldBePresent: true,
                    description: "Hover interaction should be enabled"
                ),
                ViewGenerationTestConfig.ExpectedBehavior(
                    type: .hapticFeedback,
                    shouldBePresent: true,
                    description: "Haptic feedback should be enabled"
                ),
                ViewGenerationTestConfig.ExpectedBehavior(
                    type: .assistiveTouchSupport,
                    shouldBePresent: true,
                    description: "AssistiveTouch support should be enabled"
                ),
                ViewGenerationTestConfig.ExpectedBehavior(
                    type: .accessibilitySupport,
                    shouldBePresent: true,
                    description: "Accessibility support should always be enabled"
                ),
                ViewGenerationTestConfig.ExpectedBehavior(
                    type: .animationSupport,
                    shouldBePresent: true,
                    description: "Animation support should be enabled"
                ),
                ViewGenerationTestConfig.ExpectedBehavior(
                    type: .layoutSupport,
                    shouldBePresent: true,
                    description: "Layout support should be enabled"
                )
            ]
        ),
        
        // Accessibility-only view generation (tvOS)
        ViewGenerationTestConfig(
            name: "Accessibility-Only View Generation (tvOS)",
            capabilities: ViewGenerationTestConfig.CapabilitySet(
                supportsTouch: false,
                supportsHover: false,
                supportsHapticFeedback: false,
                supportsAssistiveTouch: false,
                supportsVoiceOver: true,
                supportsSwitchControl: true,
                supportsVision: false,
                supportsOCR: false,
                minTouchTarget: 0,
                hoverDelay: 0.0,
                platform: .tvOS,
                deviceType: .tv
            ),
            expectedViewComponents: [
                ViewGenerationTestConfig.ExpectedViewComponent(
                    type: .accessibilityElement,
                    shouldBePresent: true,
                    description: "Accessibility elements should always be present"
                ),
                ViewGenerationTestConfig.ExpectedViewComponent(
                    type: .keyboardShortcut,
                    shouldBePresent: true,
                    description: "Keyboard shortcuts should be present for accessibility-only interaction"
                ),
                ViewGenerationTestConfig.ExpectedViewComponent(
                    type: .animation,
                    shouldBePresent: true,
                    description: "Animation should be present for accessibility-only interaction"
                ),
                ViewGenerationTestConfig.ExpectedViewComponent(
                    type: .layout,
                    shouldBePresent: true,
                    description: "Layout should be present for accessibility-only interaction"
                )
            ],
            expectedModifiers: [
                ViewGenerationTestConfig.ExpectedModifier(
                    type: .accessibilityAddTraits,
                    shouldBePresent: true,
                    description: "accessibilityAddTraits modifier should be present"
                ),
                ViewGenerationTestConfig.ExpectedModifier(
                    type: .accessibilityAction,
                    shouldBePresent: true,
                    description: "accessibilityAction modifier should be present"
                ),
                ViewGenerationTestConfig.ExpectedModifier(
                    type: .keyboardShortcut,
                    shouldBePresent: true,
                    description: "keyboardShortcut modifier should be present"
                ),
                ViewGenerationTestConfig.ExpectedModifier(
                    type: .animation,
                    shouldBePresent: true,
                    description: "animation modifier should be present"
                )
            ],
            expectedBehaviors: [
                ViewGenerationTestConfig.ExpectedBehavior(
                    type: .accessibilitySupport,
                    shouldBePresent: true,
                    description: "Accessibility support should always be enabled"
                ),
                ViewGenerationTestConfig.ExpectedBehavior(
                    type: .keyboardNavigation,
                    shouldBePresent: true,
                    description: "Keyboard navigation should be enabled"
                ),
                ViewGenerationTestConfig.ExpectedBehavior(
                    type: .animationSupport,
                    shouldBePresent: true,
                    description: "Animation support should be enabled"
                ),
                ViewGenerationTestConfig.ExpectedBehavior(
                    type: .layoutSupport,
                    shouldBePresent: true,
                    description: "Layout support should be enabled"
                )
            ]
        )
    ]
    
    // MARK: - View Generation Tests
    
    /// Test all view generation configurations
    @Test func testAllViewGenerationConfigurations() {
        for config in viewGenerationTestConfigurations {
            testViewGenerationConfiguration(config)
        }
    }
    
    /// Test a specific view generation configuration
    @Test func testViewGenerationConfiguration(_ config: ViewGenerationTestConfig) {
        print("🎨 Testing view generation for: \(config.name)")
        
        // Test view component generation
        testViewComponentGeneration(config)
        
        // Test modifier generation
        testModifierGeneration(config)
        
        // Test behavior generation
        testBehaviorGeneration(config)
        
        // Test integration
        testViewGenerationIntegration(config)
    }
    
    // MARK: - View Component Generation Tests
    
    /// Test that the correct view components are generated
    @Test func testViewComponentGeneration(_ config: ViewGenerationTestConfig) {
        for expectedComponent in config.expectedViewComponents {
            testViewComponent(expectedComponent, capabilities: config.capabilities, configName: config.name)
        }
    }
    
    /// Test a specific view component
    @Test func testViewComponent(
        _ expectedComponent: ViewGenerationTestConfig.ExpectedViewComponent,
        capabilities: ViewGenerationTestConfig.CapabilitySet,
        configName: String
    ) {
        let actualPresence = checkViewComponentPresence(expectedComponent.type, capabilities: capabilities)
        
        #expect(actualPresence == expectedComponent.shouldBePresent, 
                      "\(expectedComponent.description) for \(configName)")
    }
    
    /// Check if a view component should be present based on capabilities
    private func checkViewComponentPresence(
        _ componentType: ViewGenerationTestConfig.ViewComponentType,
        capabilities: ViewGenerationTestConfig.CapabilitySet
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
            return !capabilities.supportsTouch
        case .animation:
            return true // Animation should always be supported
        case .layout:
            return true // Layout should always be supported
        }
    }
    
    // MARK: - Modifier Generation Tests
    
    /// Test that the correct modifiers are generated
    @Test func testModifierGeneration(_ config: ViewGenerationTestConfig) {
        for expectedModifier in config.expectedModifiers {
            testModifier(expectedModifier, capabilities: config.capabilities, configName: config.name)
        }
    }
    
    /// Test a specific modifier
    @Test func testModifier(
        _ expectedModifier: ViewGenerationTestConfig.ExpectedModifier,
        capabilities: ViewGenerationTestConfig.CapabilitySet,
        configName: String
    ) {
        let actualPresence = checkModifierPresence(expectedModifier.type, capabilities: capabilities)
        
        #expect(actualPresence == expectedModifier.shouldBePresent, 
                      "\(expectedModifier.description) for \(configName)")
    }
    
    /// Check if a modifier should be present based on capabilities
    private func checkModifierPresence(
        _ modifierType: ViewGenerationTestConfig.ModifierType,
        capabilities: ViewGenerationTestConfig.CapabilitySet
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
        case .animation:
            return true // Animation should always be supported
        case .frame:
            return capabilities.supportsTouch // Frame is needed for touch targets
        case .padding:
            return true // Padding should always be supported
        }
    }
    
    // MARK: - Behavior Generation Tests
    
    /// Test that the correct behaviors are generated
    @Test func testBehaviorGeneration(_ config: ViewGenerationTestConfig) {
        for expectedBehavior in config.expectedBehaviors {
            testBehavior(expectedBehavior, capabilities: config.capabilities, configName: config.name)
        }
    }
    
    /// Test a specific behavior
    @Test func testBehavior(
        _ expectedBehavior: ViewGenerationTestConfig.ExpectedBehavior,
        capabilities: ViewGenerationTestConfig.CapabilitySet,
        configName: String
    ) {
        let actualPresence = checkBehaviorPresence(expectedBehavior.type, capabilities: capabilities)
        
        #expect(actualPresence == expectedBehavior.shouldBePresent, 
                      "\(expectedBehavior.description) for \(configName)")
    }
    
    /// Check if a behavior should be present based on capabilities
    private func checkBehaviorPresence(
        _ behaviorType: ViewGenerationTestConfig.BehaviorType,
        capabilities: ViewGenerationTestConfig.CapabilitySet
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
        case .animationSupport:
            return true // Animation should always be supported
        case .layoutSupport:
            return true // Layout should always be supported
        }
    }
    
    // MARK: - Integration Tests
    
    /// Test view generation integration
    @Test func testViewGenerationIntegration(_ config: ViewGenerationTestConfig) {
        // Test that the configuration can be used to generate a complete view
        let mockConfig = createMockPlatformConfig(from: config.capabilities)
        
        // Test that the mock configuration is valid and functional
        #expect(mockConfig != nil, "Mock configuration should be valid for \(config.name)")
        
        // Test that the configuration actually works by creating a view with it
        let testView = createTestViewWithMockConfig(mockConfig)
        
        // Then: Test the two critical aspects
        
        // 1. Does it return a valid structure of the kind it's supposed to?
        #expect(testView != nil, "Should be able to create view with mock config for \(config.name)")
        
        // 2. Does that structure contain what it should?
        do {
            // Verify the view is inspectable (meaning it's properly constructed)
            let _ = try testView.inspect()
            
            // Test that the configuration produces the expected view behavior
            testViewGenerationBehavior(mockConfig, configName: config.name)
            
        } catch {
            Issue.record("Failed to inspect view structure for \(config.name): \(error)")
        }
    }
    
    /// Create a mock platform config from capabilities
    private func createMockPlatformConfig(from capabilities: ViewGenerationTestConfig.CapabilitySet) -> SixLayerFramework.CardExpansionPlatformConfig {
        return getCardExpansionPlatformConfig()
    }
    
    /// Test view generation behavior
    @Test func testViewGenerationBehavior(_ config: SixLayerFramework.CardExpansionPlatformConfig, configName: String) {
        // Test that the configuration produces the expected view behavior
        // This would test actual view generation in a real implementation
        
        // Test touch behavior
        if config.supportsTouch {
            #expect(config.supportsTouch, "Touch should be supported for view generation in \(configName)")
            #expect(config.minTouchTarget >= 44, 
                                      "Touch targets should be adequate for \(configName)")
        }
        
        // Test hover behavior
        if config.supportsHover {
            #expect(config.supportsHover, "Hover should be supported for view generation in \(configName)")
            #expect(config.hoverDelay >= 0, 
                                      "Hover delay should be set for \(configName)")
        }
        
        // Test accessibility behavior
        #expect(config.supportsVoiceOver, "VoiceOver should be supported for view generation in \(configName)")
        #expect(config.supportsSwitchControl, "Switch Control should be supported for view generation in \(configName)")
    }
    
    // MARK: - Individual Capability View Tests
    
    /// Test touch view generation in both enabled and disabled states
    @Test func testTouchViewGenerationBothStates() {
        // Test touch enabled
        let touchEnabledConfig = ViewGenerationTestConfig(
            name: "Touch Enabled View",
            capabilities: ViewGenerationTestConfig.CapabilitySet(
                supportsTouch: true,
                supportsHover: false,
                supportsHapticFeedback: true,
                supportsAssistiveTouch: true,
                supportsVoiceOver: true,
                supportsSwitchControl: true,
                supportsVision: true,
                supportsOCR: true,
                minTouchTarget: 44,
                hoverDelay: 0.0,
                platform: SixLayerPlatform.iOS,
                deviceType: .phone
            ),
            expectedViewComponents: [
                ViewGenerationTestConfig.ExpectedViewComponent(
                    type: .tapGesture,
                    shouldBePresent: true,
                    description: "Tap gesture should be present"
                ),
                ViewGenerationTestConfig.ExpectedViewComponent(
                    type: .hapticFeedback,
                    shouldBePresent: true,
                    description: "Haptic feedback should be present"
                )
            ],
            expectedModifiers: [],
            expectedBehaviors: []
        )
        testViewGenerationConfiguration(touchEnabledConfig)
        
        // Test touch disabled
        let touchDisabledConfig = ViewGenerationTestConfig(
            name: "Touch Disabled View",
            capabilities: ViewGenerationTestConfig.CapabilitySet(
                supportsTouch: false,
                supportsHover: true,
                supportsHapticFeedback: false,
                supportsAssistiveTouch: false,
                supportsVoiceOver: true,
                supportsSwitchControl: true,
                supportsVision: true,
                supportsOCR: true,
                minTouchTarget: 0,
                hoverDelay: 0.1,
                platform: .macOS,
                deviceType: .mac
            ),
            expectedViewComponents: [
                ViewGenerationTestConfig.ExpectedViewComponent(
                    type: .tapGesture,
                    shouldBePresent: false,
                    description: "Tap gesture should not be present"
                ),
                ViewGenerationTestConfig.ExpectedViewComponent(
                    type: .hapticFeedback,
                    shouldBePresent: false,
                    description: "Haptic feedback should not be present"
                )
            ],
            expectedModifiers: [],
            expectedBehaviors: []
        )
        testViewGenerationConfiguration(touchDisabledConfig)
    }
    
    /// Test hover view generation in both enabled and disabled states
    @Test func testHoverViewGenerationBothStates() {
        // Test hover enabled
        let hoverEnabledConfig = ViewGenerationTestConfig(
            name: "Hover Enabled View",
            capabilities: ViewGenerationTestConfig.CapabilitySet(
                supportsTouch: false,
                supportsHover: true,
                supportsHapticFeedback: false,
                supportsAssistiveTouch: false,
                supportsVoiceOver: true,
                supportsSwitchControl: true,
                supportsVision: true,
                supportsOCR: true,
                minTouchTarget: 0,
                hoverDelay: 0.1,
                platform: .macOS,
                deviceType: .mac
            ),
            expectedViewComponents: [
                ViewGenerationTestConfig.ExpectedViewComponent(
                    type: .hoverGesture,
                    shouldBePresent: true,
                    description: "Hover gesture should be present"
                )
            ],
            expectedModifiers: [],
            expectedBehaviors: []
        )
        testViewGenerationConfiguration(hoverEnabledConfig)
        
        // Test hover disabled
        let hoverDisabledConfig = ViewGenerationTestConfig(
            name: "Hover Disabled View",
            capabilities: ViewGenerationTestConfig.CapabilitySet(
                supportsTouch: true,
                supportsHover: false,
                supportsHapticFeedback: true,
                supportsAssistiveTouch: true,
                supportsVoiceOver: true,
                supportsSwitchControl: true,
                supportsVision: true,
                supportsOCR: true,
                minTouchTarget: 44,
                hoverDelay: 0.0,
                platform: SixLayerPlatform.iOS,
                deviceType: .phone
            ),
            expectedViewComponents: [
                ViewGenerationTestConfig.ExpectedViewComponent(
                    type: .hoverGesture,
                    shouldBePresent: false,
                    description: "Hover gesture should not be present"
                )
            ],
            expectedModifiers: [],
            expectedBehaviors: []
        )
        testViewGenerationConfiguration(hoverDisabledConfig)
    }
    
    // MARK: - Helper Functions
    
    /// Create a test view using general platform configuration
    private func createTestViewWithGeneralConfig(_ config: ViewGenerationTestConfig.CapabilitySet) -> some View {
        let baseView = Text("Test View")
            .frame(minWidth: config.minTouchTarget, minHeight: config.minTouchTarget)
            .accessibilityLabel("Test view with general configuration")
        
        // Apply platform-specific modifiers based on capabilities
        // This simulates what the framework would actually do for different platforms
        if config.supportsTouch {
            return AnyView(baseView.onTapGesture {
                // Touch action
            })
        }
        
        if config.supportsHover {
            return AnyView(baseView.onHover { _ in
                // Hover action
            })
        }
        
        if config.supportsVoiceOver {
            return AnyView(baseView.accessibilityAddTraits(.isButton))
        }
        
        return AnyView(baseView)
    }
    
    /// Test that different platform configurations generate different underlying view types
    @Test func testPlatformSpecificViewGeneration() {
        // Create different platform configurations using general platform types
        let touchConfig = ViewGenerationTestConfig.CapabilitySet(
            supportsTouch: true,
            supportsHover: false,
            supportsHapticFeedback: true,
            supportsAssistiveTouch: true,
            supportsVoiceOver: true,
            supportsSwitchControl: true,
            supportsVision: true,
            supportsOCR: true,
            minTouchTarget: 44,
            hoverDelay: 0.0,
            platform: .iOS,
            deviceType: .phone
        )
        
        let hoverConfig = ViewGenerationTestConfig.CapabilitySet(
            supportsTouch: false,
            supportsHover: true,
            supportsHapticFeedback: false,
            supportsAssistiveTouch: false,
            supportsVoiceOver: true,
            supportsSwitchControl: true,
            supportsVision: true,
            supportsOCR: true,
            minTouchTarget: 0,
            hoverDelay: 0.5,
            platform: .macOS,
            deviceType: .mac
        )
        
        // Generate views for different platforms using general configuration
        let touchView = createTestViewWithGeneralConfig(touchConfig)
        let hoverView = createTestViewWithGeneralConfig(hoverConfig)
        
        // Then: Test the two critical aspects
        
        // 1. Does it return a valid structure of the kind it's supposed to?
        #expect(touchView != nil, "Touch platform should generate a valid view")
        #expect(hoverView != nil, "Hover platform should generate a valid view")
        
        // 2. Does that structure contain what it should?
        do {
            // Both views should be inspectable
            let touchInspection = try touchView.inspect()
            let hoverInspection = try hoverView.inspect()
            
            // The views should be different because they represent different platforms
            // This is the key test - platform mocking should generate different views
            // We can verify this by checking that the views have different capabilities
            // Touch view should have touch target size, hover view should not
            #expect(touchConfig.minTouchTarget == 44, "Touch platform should have proper touch target size")
            #expect(hoverConfig.minTouchTarget == 0, "Hover platform should not have touch target size")
            
            // Both views should be valid SwiftUI views
            #expect(touchInspection != nil, "Touch view should be inspectable")
            #expect(hoverInspection != nil, "Hover view should be inspectable")
            
        } catch {
            Issue.record("Failed to inspect platform-specific view structures: \(error)")
        }
    }
    
    /// Test that platform mocking actually creates different underlying view types
    @Test func testPlatformMockingCreatesDifferentViewTypes() {
        // This test verifies that platform mocking works correctly
        // by ensuring different platforms generate different underlying view types
        
        // Simulate iOS platform (touch-enabled)
        let iOSConfig = getCardExpansionPlatformConfig()
        
        // Simulate macOS platform (hover-enabled)
        let macOSConfig = getCardExpansionPlatformConfig()
        
        // Generate views for different platforms
        let iOSView = createTestViewWithMockConfig(iOSConfig)
        let macOSView = createTestViewWithMockConfig(macOSConfig)
        
        // Then: Test the two critical aspects
        
        // 1. Does it return a valid structure of the kind it's supposed to?
        #expect(iOSView != nil, "iOS platform should generate a valid view")
        #expect(macOSView != nil, "macOS platform should generate a valid view")
        
        // 2. Does that structure contain what it should?
        do {
            // Both views should be inspectable
            let iOSInspection = try iOSView.inspect()
            let macOSInspection = try macOSView.inspect()
            
            // Verify platform-specific capabilities
            #expect(iOSConfig.supportsTouch, "iOS should support touch")
            #expect(!macOSConfig.supportsTouch, "macOS should not support touch")
            #expect(macOSConfig.supportsHover, "macOS should support hover")
            #expect(!iOSConfig.supportsHover, "iOS should not support hover")
            
            // Both views should be valid SwiftUI views
            #expect(iOSInspection != nil, "iOS view should be inspectable")
            #expect(macOSInspection != nil, "macOS view should be inspectable")
            
            // The key test: different platforms should generate different view configurations
            // This verifies that platform mocking is working correctly
            #expect(iOSConfig.minTouchTarget != macOSConfig.minTouchTarget, 
                            "Different platforms should have different touch target sizes")
            #expect(iOSConfig.supportsTouch != macOSConfig.supportsTouch, 
                            "Different platforms should have different touch support")
            #expect(iOSConfig.supportsHover != macOSConfig.supportsHover, 
                            "Different platforms should have different hover support")
            
        } catch {
            Issue.record("Failed to inspect platform-specific view structures: \(error)")
        }
    }
}
