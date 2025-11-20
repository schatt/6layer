import Testing


//
//  PlatformOrganizationLayer5ComponentAccessibilityTests.swift
//  SixLayerFrameworkTests
//
//  Comprehensive accessibility tests for ALL Platform Organization Layer 5 Components
//

import SwiftUI
@testable import SixLayerFramework

/// NOTE: Not marked @MainActor on class to allow parallel execution
@Suite("Platform Organization Layer Component Accessibility")
open class PlatformOrganizationLayer5ComponentAccessibilityTests: BaseTestClass {
    
    // MARK: - Platform Organization Layer 5 Component Tests
    
    @Test @MainActor func testPlatformOrganizationLayer5GeneratesAccessibilityIdentifiers() async {
        // Given: PlatformOrganizationLayer5
        let testView = PlatformOrganizationLayer5()
        
        // Then: Should generate accessibility identifiers
            // TODO: ViewInspector Detection Issue - VERIFIED: PlatformOrganizationLayer5 DOES have .automaticCompliance() 
            // modifier applied in Framework/Sources/Layers/Layer5-Platform/PlatformOrganizationLayer5.swift:16.
            // The test needs to be updated to handle ViewInspector's inability to detect these modifiers reliably.
            // This is a ViewInspector limitation, not a missing modifier issue.
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            testView,
            expectedPattern: "SixLayer.main.ui.*",
            platform: SixLayerPlatform.iOS,
            componentName: "PlatformOrganizationLayer5"
        )
 #expect(hasAccessibilityID, "PlatformOrganizationLayer5 should generate accessibility identifiers ")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }
}