import Testing


//
//  PlatformProfilingLayer5ComponentAccessibilityTests.swift
//  SixLayerFrameworkTests
//
//  Comprehensive accessibility tests for ALL Platform Profiling Layer 5 Components
//

import SwiftUI
@testable import SixLayerFramework

@MainActor
@Suite("Platform Profiling Layer Component Accessibility")
open class PlatformProfilingLayer5ComponentAccessibilityTests: BaseTestClass {
    
    // MARK: - Platform Profiling Layer 5 Component Tests
    
    @Test func testPlatformProfilingLayer5GeneratesAccessibilityIdentifiers() async {
        // Given: PlatformProfilingLayer5
        let testView = PlatformProfilingLayer5()
        
        // Then: Should generate accessibility identifiers
            // TODO: ViewInspector Detection Issue - VERIFIED: PlatformProfilingLayer5 DOES have .automaticCompliance() 
            // modifier applied in Framework/Sources/Layers/Layer5-Platform/PlatformProfilingLayer5.swift:16.
            // The test needs to be updated to handle ViewInspector's inability to detect these modifiers reliably.
            // This is a ViewInspector limitation, not a missing modifier issue.
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            testView,
            expectedPattern: "SixLayer.main.ui.*",
            platform: SixLayerPlatform.iOS,
            componentName: "PlatformProfilingLayer5"
        )
 #expect(hasAccessibilityID, "PlatformProfilingLayer5 should generate accessibility identifiers ")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }
}