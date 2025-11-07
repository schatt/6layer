import Testing


import SwiftUI
@testable import SixLayerFramework
#if !os(macOS)
import ViewInspector
#endif
/// Debug Test: Check if .automaticAccessibilityIdentifiers() works at all
@MainActor
@Suite("Accessibility Identifiers Debug")
open class AccessibilityIdentifiersDebugTests: BaseTestClass {    @Test func testDirectAutomaticAccessibilityIdentifiersWorks() async {
        // Test .automaticAccessibilityIdentifiers() directly
        let testView = PlatformInteractionButton(style: .primary, action: {}) {
            platformPresentContent_L1(content: "Test", hints: PresentationHints())
        }
            .automaticAccessibilityIdentifiers()
        
        // Should look for button-specific accessibility identifier with current format
        #expect(testAccessibilityIdentifiersSinglePlatform(
            testView, 
            expectedPattern: "SixLayer.*ui", 
            platform: SixLayerPlatform.iOS,
            componentName: "DirectAutomaticAccessibilityIdentifiers"
        ), "Direct .automaticAccessibilityIdentifiers() should generate button-specific accessibility ID")
        print("🔍 Testing direct .automaticAccessibilityIdentifiers()")
    }
    
    @Test func testNamedModifierWorks() {
        // Test .named() modifier
        let testView = PlatformInteractionButton(style: .primary, action: {}) {
            platformPresentContent_L1(content: "Test", hints: PresentationHints())
        }
            .named("TestButton")
            .automaticAccessibilityIdentifiers()
        
        // Should look for named button-specific accessibility identifier: "SixLayer.main.ui.TestButton"
        #expect(testAccessibilityIdentifiersSinglePlatform(
            testView, 
            expectedPattern: "SixLayer.*TestButton", 
            platform: SixLayerPlatform.iOS,
            componentName: "NamedModifier"
        ), ".named() + .automaticAccessibilityIdentifiers() should generate named button-specific accessibility ID")
        print("🔍 Testing .named() + .automaticAccessibilityIdentifiers()")
    }
    
    @Test func testAutomaticAccessibilityModifierWorks() {
        // Test AutomaticAccessibilityModifier directly
        let testView = PlatformInteractionButton(style: .primary, action: {}) {
            platformPresentContent_L1(content: "Test", hints: PresentationHints())
        }
            .modifier(SystemAccessibilityModifier(
                accessibilityState: AccessibilitySystemState(),
                platform: .iOS
            ))
        
        // Should look for modifier-specific accessibility identifier with current format
        #expect(testAccessibilityIdentifiersSinglePlatform(
            testView, 
            expectedPattern: "SixLayer.*ui", 
            platform: SixLayerPlatform.iOS,
            componentName: "AutomaticAccessibilityModifier"
        ), "AutomaticAccessibilityModifier should generate modifier-specific accessibility ID")
        print("🔍 Testing AutomaticAccessibilityModifier directly")
    }
    
    @Test func testAutomaticAccessibilityExtensionWorks() {
        // Test .automaticAccessibility() extension
        let testView = PlatformInteractionButton(style: .primary, action: {}) {
            platformPresentContent_L1(content: "Test", hints: PresentationHints())
        }
            .automaticAccessibility()
        
        // Should look for extension-specific accessibility identifier with current format
        #expect(testAccessibilityIdentifiersSinglePlatform(
            testView, 
            expectedPattern: "SixLayer.*ui", 
            platform: SixLayerPlatform.iOS,
            componentName: "AutomaticAccessibilityExtension"
        ), ".automaticAccessibility() should generate extension-specific accessibility ID")
        print("🔍 Testing .automaticAccessibility() extension")
    }
    
    // MARK: - Helper Methods
    
    // No longer needed - using shared hasAccessibilityIdentifierPattern function
}
