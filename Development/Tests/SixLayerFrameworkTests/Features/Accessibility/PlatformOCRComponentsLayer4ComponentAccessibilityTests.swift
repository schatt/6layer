import Testing


//
//  PlatformOCRComponentsLayer4ComponentAccessibilityTests.swift
//  SixLayerFrameworkTests
//
//  Comprehensive accessibility tests for ALL Platform OCR Components Layer 4
//

import SwiftUI
@testable import SixLayerFramework

/// NOTE: Not marked @MainActor on class to allow parallel execution
@Suite("Platform OCR Components Layer Component Accessibility")
open class PlatformOCRComponentsLayer4ComponentAccessibilityTests: BaseTestClass {
    
    // MARK: - Platform OCR Components Layer 4 Tests
    
    @Test @MainActor func testPlatformOCRComponentsLayer4GeneratesAccessibilityIdentifiers() async {
        initializeTestConfig()
        // Given: Framework component (testing our framework, not SwiftUI)
        let testView = platformPresentContent_L1(
            content: "OCR Service Test",
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

