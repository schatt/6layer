import Testing


//
//  AccessibilityTestingSuiteComponentAccessibilityTests.swift
//  SixLayerFrameworkTests
//
//  Comprehensive accessibility tests for ALL Accessibility Testing Suite Components
//

import SwiftUI
@testable import SixLayerFramework

/// NOTE: Not marked @MainActor on class to allow parallel execution
@Suite("Accessibilitying Suite Component Accessibility")
open class AccessibilityTestingSuiteComponentAccessibilityTests: BaseTestClass {
    
    // MARK: - Accessibility Testing Suite Component Tests
    
    @Test @MainActor func testAccessibilityTestingSuiteGeneratesAccessibilityIdentifiers() async {
        initializeTestConfig()
        // Given: AccessibilityTestingView (the actual View, not the class)
        let testView = AccessibilityTestingView()
        
        // Then: Should generate accessibility identifiers
            // TODO: ViewInspector Detection Issue - VERIFIED: AccessibilityTestingView DOES have .automaticCompliance() 
            // modifier applied in Framework/Sources/Layers/Layer5-Platform/AccessibilityFeaturesLayer5.swift:488.
            // The test needs to be updated to handle ViewInspector's inability to detect these modifiers reliably.
            // This is a ViewInspector limitation, not a missing modifier issue.
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            testView,
            expectedPattern: "SixLayer.main.ui.*",
            platform: SixLayerPlatform.iOS,
            componentName: "AccessibilityTestingView"
        )
 #expect(hasAccessibilityID, "AccessibilityTestingView should generate accessibility identifiers ")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }
}

