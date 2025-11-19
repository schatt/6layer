import Testing


//
//  AccessibilityFeaturesLayer5ComponentAccessibilityTests.swift
//  SixLayerFrameworkTests
//
//  Comprehensive accessibility tests for ALL AccessibilityFeaturesLayer5 components
//

import SwiftUI
@testable import SixLayerFramework

/// NOTE: Not marked @MainActor on class to allow parallel execution
@Suite("Accessibility Features Layer Component Accessibility")
open class AccessibilityFeaturesLayer5ComponentAccessibilityTests: BaseTestClass {
    
    // MARK: - AccessibilityEnhancedView Tests
    
    @Test @MainActor func testAccessibilityEnhancedViewGeneratesAccessibilityIdentifiers() async {
        initializeTestConfig()
        // Given: Test content
        let testContent = VStack {
            Text("Enhanced Content")
            Button("Test Button") { }
        }
        
        // When: Creating AccessibilityEnhancedView
        let config = AccessibilityConfig()
        let view = AccessibilityEnhancedView(config: config) {
            testContent
        }
        
        // Then: Should generate accessibility identifiers
        // Note: AccessibilityEnhancedView uses Layer 5 ID format without "ui" segment
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "*.main.element.accessibility-enhanced-*",
            platform: SixLayerPlatform.iOS,
            componentName: "AccessibilityEnhancedView"
        )
        #expect(hasAccessibilityID, "AccessibilityEnhancedView should generate accessibility identifiers")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }
    
    // MARK: - VoiceOverEnabledView Tests
    
    @Test @MainActor func testVoiceOverEnabledViewGeneratesAccessibilityIdentifiers() async {
        initializeTestConfig()
        // Given: Test content
        let testContent = VStack {
            Text("VoiceOver Content")
            Button("Test Button") { }
        }
        
        // When: Creating VoiceOverEnabledView
        let view = VoiceOverEnabledView {
            testContent
        }
        
        // Then: Should generate accessibility identifiers
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "SixLayer.*ui",
            platform: SixLayerPlatform.iOS,
            componentName: "VoiceOverEnabledView"
        )
 #expect(hasAccessibilityID, "VoiceOverEnabledView should generate accessibility identifiers ")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }
    
    // MARK: - KeyboardNavigableView Tests
    
    @Test @MainActor func testKeyboardNavigableViewGeneratesAccessibilityIdentifiers() async {
        initializeTestConfig()
        // Given: Test content
        let testContent = VStack {
            Text("Keyboard Content")
            Button("Test Button") { }
        }
        
        // When: Creating KeyboardNavigableView
        let view = KeyboardNavigableView {
            testContent
        }
        
        // Then: Should generate accessibility identifiers
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "SixLayer.*ui",
            platform: SixLayerPlatform.iOS,
            componentName: "KeyboardNavigableView"
        )
 #expect(hasAccessibilityID, "KeyboardNavigableView should generate accessibility identifiers ")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }
    
    // MARK: - HighContrastEnabledView Tests
    
    @Test @MainActor func testHighContrastEnabledViewGeneratesAccessibilityIdentifiers() async {
        initializeTestConfig()
        // Given: Test content
        let testContent = VStack {
            Text("High Contrast Content")
            Button("Test Button") { }
        }
        
        // When: Creating HighContrastEnabledView
        let view = HighContrastEnabledView {
            testContent
        }
        
        // Then: Should generate accessibility identifiers
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "SixLayer.*ui",
            platform: SixLayerPlatform.iOS,
            componentName: "HighContrastEnabledView"
        )
 #expect(hasAccessibilityID, "HighContrastEnabledView should generate accessibility identifiers ")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }
    
    // MARK: - AccessibilityHostingView Tests
    
    @Test @MainActor func testAccessibilityHostingViewGeneratesAccessibilityIdentifiers() async {
        initializeTestConfig()
        // Given: Test content
        let testContent = VStack {
            Text("Hosting Content")
            Button("Test Button") { }
        }
        
        // When: Creating AccessibilityHostingView
        let view = AccessibilityHostingView {
            testContent
        }
        
        // Then: Should generate accessibility identifiers
        // Note: AccessibilityHostingView uses Layer 5 ID format without "ui" segment
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "*.main.element.accessibility-enhanced-*",
            platform: SixLayerPlatform.iOS,
            componentName: "AccessibilityHostingView"
        )
 #expect(hasAccessibilityID, "AccessibilityHostingView should generate accessibility identifiers ")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }
    
    // MARK: - AccessibilityTestingView Tests
    
    @Test @MainActor func testAccessibilityTestingViewGeneratesAccessibilityIdentifiers() async {
        initializeTestConfig()
        // When: Creating AccessibilityTestingView
        let view = AccessibilityTestingView()
        
        // Then: Should generate accessibility identifiers
            // TODO: ViewInspector Detection Issue - VERIFIED: AccessibilityTestingView DOES have .automaticCompliance() 
            // modifier applied in Framework/Sources/Layers/Layer5-Platform/AccessibilityFeaturesLayer5.swift:488.
            // The test needs to be updated to handle ViewInspector's inability to detect these modifiers reliably.
            // This is a ViewInspector limitation, not a missing modifier issue.
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "SixLayer.*ui",
            platform: SixLayerPlatform.iOS,
            componentName: "AccessibilityTestingView"
        )
 #expect(hasAccessibilityID, "AccessibilityTestingView should generate accessibility identifiers ")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }
    
    // MARK: - VoiceOverManager Tests
    
    @Test @MainActor func testVoiceOverManagerGeneratesAccessibilityIdentifiers() async {
        initializeTestConfig()
        // Given: VoiceOverManager
        let manager = VoiceOverManager()
        
        // When: Creating a view with VoiceOverManager
        let view = VStack {
            Text("VoiceOver Manager Content")
        }
        .environmentObject(manager)
        .automaticCompliance()
        
        // Then: Should generate accessibility identifiers
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "SixLayer.*ui",
            platform: SixLayerPlatform.iOS,
            componentName: "VoiceOverManager"
        )
 #expect(hasAccessibilityID, "VoiceOverManager should generate accessibility identifiers ")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }
    
    // MARK: - KeyboardNavigationManager Tests
    
    @Test @MainActor func testKeyboardNavigationManagerGeneratesAccessibilityIdentifiers() async {
        initializeTestConfig()
        // Given: KeyboardNavigationManager
        let manager = KeyboardNavigationManager()
        
        // When: Creating a view with KeyboardNavigationManager
        let view = VStack {
            Text("Keyboard Navigation Manager Content")
        }
        .environmentObject(manager)
        .automaticCompliance()
        
        // Then: Should generate accessibility identifiers
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "SixLayer.*ui",
            platform: SixLayerPlatform.iOS,
            componentName: "KeyboardNavigationManager"
        )
 #expect(hasAccessibilityID, "KeyboardNavigationManager should generate accessibility identifiers ")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }
    
    // MARK: - HighContrastManager Tests
    
    @Test @MainActor func testHighContrastManagerGeneratesAccessibilityIdentifiers() async {
        initializeTestConfig()
        // Given: HighContrastManager
        let manager = HighContrastManager()
        
        // When: Creating a view with HighContrastManager
        let view = VStack {
            Text("High Contrast Manager Content")
        }
        .environmentObject(manager)
        .automaticCompliance()
        
        // Then: Should generate accessibility identifiers
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "SixLayer.*ui",
            platform: SixLayerPlatform.iOS,
            componentName: "HighContrastManager"
        )
 #expect(hasAccessibilityID, "HighContrastManager should generate accessibility identifiers ")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }
    
    // MARK: - AccessibilityTestingManager Tests
    
    @Test @MainActor func testAccessibilityTestingManagerGeneratesAccessibilityIdentifiers() async {
        initializeTestConfig()
        // Given: AccessibilityTestingManager
        let manager = AccessibilityTestingManager()
        
        // When: Creating a view with AccessibilityTestingManager
        let view = VStack {
            Text("Accessibility Testing Manager Content")
        }
        .environmentObject(manager)
        .automaticCompliance()
        
        // Then: Should generate accessibility identifiers
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "SixLayer.*ui",
            platform: SixLayerPlatform.iOS,
            componentName: "AccessibilityTestingManager"
        )
 #expect(hasAccessibilityID, "AccessibilityTestingManager should generate accessibility identifiers ")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }
    
    // MARK: - SwitchControlManager Tests
    
    @Test @MainActor func testSwitchControlManagerGeneratesAccessibilityIdentifiers() async {
        initializeTestConfig()
        // Given: SwitchControlManager
        let config = SwitchControlConfig(
            enableNavigation: true,
            enableCustomActions: true,
            enableGestureSupport: true,
            focusManagement: .automatic,
            gestureSensitivity: .medium,
            navigationSpeed: .normal
        )
        let manager = SwitchControlManager(config: config)
        
        // When: Creating a view with SwitchControlManager
        let view = VStack {
            Text("Switch Control Manager Content")
        }
        .environmentObject(manager)
        .automaticCompliance()
        
        // Then: Should generate accessibility identifiers
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "SixLayer.*ui",
            platform: SixLayerPlatform.iOS,
            componentName: "SwitchControlManager"
        )
 #expect(hasAccessibilityID, "SwitchControlManager should generate accessibility identifiers ")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }
    
    // MARK: - MaterialAccessibilityManager Tests
    
    @Test @MainActor func testMaterialAccessibilityManagerGeneratesAccessibilityIdentifiers() async {
        initializeTestConfig()
        // Given: MaterialAccessibilityManager
        let manager = MaterialAccessibilityManager()
        
        // When: Creating a view with MaterialAccessibilityManager
        let view = VStack {
            Text("Material Accessibility Manager Content")
        }
        .environmentObject(manager)
        .automaticCompliance()
        
        // Then: Should generate accessibility identifiers
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "SixLayer.*ui",
            platform: SixLayerPlatform.iOS,
            componentName: "MaterialAccessibilityManager"
        )
 #expect(hasAccessibilityID, "MaterialAccessibilityManager should generate accessibility identifiers ")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }
    
    // MARK: - EyeTrackingManager Tests
    
    @Test @MainActor func testEyeTrackingManagerGeneratesAccessibilityIdentifiers() async {
        initializeTestConfig()
        // Given: EyeTrackingManager
        let manager = EyeTrackingManager()
        
        // When: Creating a view with EyeTrackingManager
        let view = VStack {
            Text("Eye Tracking Manager Content")
        }
        .environmentObject(manager)
        .automaticCompliance()
        
        // Then: Should generate accessibility identifiers
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "SixLayer.*ui",
            platform: SixLayerPlatform.iOS,
            componentName: "EyeTrackingManager"
        )
 #expect(hasAccessibilityID, "EyeTrackingManager should generate accessibility identifiers ")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }
    
    // MARK: - AssistiveTouchManager Tests
    
    @Test @MainActor func testAssistiveTouchManagerGeneratesAccessibilityIdentifiers() async {
        initializeTestConfig()
        // Given: AssistiveTouchManager
        let config = AssistiveTouchConfig(
            enableIntegration: true,
            enableCustomActions: true,
            enableMenuSupport: true,
            enableGestureRecognition: true,
            gestureSensitivity: .medium,
            menuStyle: .floating
        )
        let manager = AssistiveTouchManager(config: config)
        
        // When: Creating a view with AssistiveTouchManager
        let view = VStack {
            Text("Assistive Touch Manager Content")
        }
        .environmentObject(manager)
        .automaticCompliance()
        
        // Then: Should generate accessibility identifiers
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "SixLayer.*ui",
            platform: SixLayerPlatform.iOS,
            componentName: "AssistiveTouchManager"
        )
 #expect(hasAccessibilityID, "AssistiveTouchManager should generate accessibility identifiers ")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }
}


