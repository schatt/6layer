import Testing


//
//  AutomaticAccessibilityComponentAccessibilityTests.swift
//  SixLayerFrameworkTests
//
//  Comprehensive accessibility tests for ALL Automatic Accessibility Components
//

import SwiftUI
@testable import SixLayerFramework

/// NOTE: Not marked @MainActor on class to allow parallel execution
@Suite("Automatic Accessibility Component Accessibility")
open class AutomaticAccessibilityComponentAccessibilityTests: BaseTestClass {
    
    // MARK: - Automatic Accessibility Component Tests
    
    @Test @MainActor func testAutomaticAccessibilityIdentifiersGeneratesAccessibilityIdentifiers() async {
        initializeTestConfig()
        // Given: Framework component (testing our framework, not SwiftUI)
        let testView = platformPresentContent_L1(
            content: "Test",
            hints: PresentationHints()
        )
        
        // Then: Framework component should automatically generate accessibility identifiers
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            testView,
            expectedPattern: "SixLayer.main.ui.*",
            platform: SixLayerPlatform.iOS,
            componentName: "platformPresentContent_L1"
        )
 #expect(hasAccessibilityID, "Framework component should automatically generate accessibility identifiers ")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }
}

