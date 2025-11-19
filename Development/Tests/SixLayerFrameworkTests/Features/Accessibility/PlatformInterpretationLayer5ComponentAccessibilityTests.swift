import Testing


//
//  PlatformInterpretationLayer5ComponentAccessibilityTests.swift
//  SixLayerFrameworkTests
//
//  Comprehensive accessibility tests for ALL Platform Interpretation Layer 5 Components
//

import SwiftUI
@testable import SixLayerFramework

/// NOTE: Not marked @MainActor on class to allow parallel execution
@Suite("Platform Interpretation Layer Component Accessibility")
open class PlatformInterpretationLayer5ComponentAccessibilityTests: BaseTestClass {
    
    // MARK: - Platform Interpretation Layer 5 Component Tests
    
    @Test func testPlatformInterpretationLayer5GeneratesAccessibilityIdentifiers() async {
        // Given: PlatformInterpretationLayer5
        let testView = PlatformInterpretationLayer5()
        
        // Then: Should generate accessibility identifiers
            // TODO: ViewInspector Detection Issue - VERIFIED: PlatformInterpretationLayer5 DOES have .automaticCompliance() 
            // modifier applied in Framework/Sources/Layers/Layer5-Platform/PlatformInterpretationLayer5.swift:17.
            // The test needs to be updated to handle ViewInspector's inability to detect these modifiers reliably.
            // This is a ViewInspector limitation, not a missing modifier issue.
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            testView,
            expectedPattern: "SixLayer.main.ui.*",
            platform: SixLayerPlatform.iOS,
            componentName: "PlatformInterpretationLayer5"
        )
 #expect(hasAccessibilityID, "PlatformInterpretationLayer5 should generate accessibility identifiers ")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }
}
