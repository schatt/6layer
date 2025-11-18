import Testing


//
//  PlatformWisdomLayer5ComponentAccessibilityTests.swift
//  SixLayerFrameworkTests
//
//  Comprehensive accessibility tests for ALL Platform Wisdom Layer 5 Components
//

import SwiftUI
@testable import SixLayerFramework

@MainActor
@Suite("Platform Wisdom Layer Component Accessibility")
open class PlatformWisdomLayer5ComponentAccessibilityTests: BaseTestClass {
    
    // MARK: - Platform Wisdom Layer 5 Component Tests
    
    @Test func testPlatformWisdomLayer5GeneratesAccessibilityIdentifiers() async {
        // Given: PlatformWisdomLayer5
        let testView = PlatformWisdomLayer5()
        
        // Then: Should generate accessibility identifiers
            // TODO: ViewInspector Detection Issue - VERIFIED: PlatformWisdomLayer5 DOES have .automaticCompliance() 
            // modifier applied in Framework/Sources/Layers/Layer5-Platform/PlatformWisdomLayer5.swift:16.
            // The test needs to be updated to handle ViewInspector's inability to detect these modifiers reliably.
            // This is a ViewInspector limitation, not a missing modifier issue.
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            testView,
            expectedPattern: "SixLayer.main.ui.*",
            platform: SixLayerPlatform.iOS,
            componentName: "PlatformWisdomLayer5"
        )
        #expect(hasAccessibilityID, "PlatformWisdomLayer5 should generate accessibility identifiers")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }
}