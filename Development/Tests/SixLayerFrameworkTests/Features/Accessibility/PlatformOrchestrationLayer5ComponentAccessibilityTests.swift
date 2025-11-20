import Testing


//
//  PlatformOrchestrationLayer5ComponentAccessibilityTests.swift
//  SixLayerFrameworkTests
//
//  Comprehensive accessibility tests for ALL Platform Orchestration Layer 5 Components
//

import SwiftUI
@testable import SixLayerFramework

/// NOTE: Not marked @MainActor on class to allow parallel execution
@Suite("Platform Orchestration Layer Component Accessibility")
open class PlatformOrchestrationLayer5ComponentAccessibilityTests: BaseTestClass {
    
    // MARK: - Platform Orchestration Layer 5 Component Tests
    
    @Test @MainActor func testPlatformOrchestrationLayer5GeneratesAccessibilityIdentifiers() async {
        // Given: PlatformOrchestrationLayer5
        let testView = PlatformOrchestrationLayer5()
        
        // Then: Should generate accessibility identifiers
            // TODO: ViewInspector Detection Issue - VERIFIED: PlatformOrchestrationLayer5 DOES have .automaticCompliance() 
            // modifier applied in Framework/Sources/Layers/Layer5-Platform/PlatformOrchestrationLayer5.swift:16.
            // The test needs to be updated to handle ViewInspector's inability to detect these modifiers reliably.
            // This is a ViewInspector limitation, not a missing modifier issue.
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            testView,
            expectedPattern: "SixLayer.main.ui.*",
            platform: SixLayerPlatform.iOS,
            componentName: "PlatformOrchestrationLayer5"
        )
 #expect(hasAccessibilityID, "PlatformOrchestrationLayer5 should generate accessibility identifiers ")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }
}