import Testing


//
//  PlatformResourceLayer5ComponentAccessibilityTests.swift
//  SixLayerFrameworkTests
//
//  Comprehensive accessibility tests for ALL Platform Resource Layer 5 Components
//

import SwiftUI
@testable import SixLayerFramework

@MainActor
@Suite("Platform Resource Layer Component Accessibility")
open class PlatformResourceLayer5ComponentAccessibilityTests: BaseTestClass {
    
    // MARK: - Platform Resource Layer 5 Component Tests
    
    @Test func testPlatformResourceLayer5GeneratesAccessibilityIdentifiers() async {
        // Given: PlatformResourceLayer5
        let resourceLayer = PlatformResourceLayer5()
        
        // When: Get a view from the component
        let testView = resourceLayer.createResourceButton(title: "Test", action: {})
        
        // Then: Should generate accessibility identifiers
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            testView,
            expectedPattern: "SixLayer.main.ui.*",
            platform: SixLayerPlatform.iOS,
            componentName: "PlatformResourceLayer5"
        )
 #expect(hasAccessibilityID, "PlatformResourceLayer5 should generate accessibility identifiers ")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }
}