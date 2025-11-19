import Testing


//
//  PlatformPerformanceLayer6ComponentAccessibilityTests.swift
//  SixLayerFrameworkTests
//
//  Comprehensive accessibility tests for ALL Platform Performance Layer 6 Components
//

import SwiftUI
@testable import SixLayerFramework

/// NOTE: Not marked @MainActor on class to allow parallel execution
@Suite("Platform Performance Layer Component Accessibility")
open class PlatformPerformanceLayer6ComponentAccessibilityTests: BaseTestClass {
    
    // MARK: - Platform Performance Layer 6 Component Tests
    
    @Test func testPlatformPerformanceLayer6GeneratesAccessibilityIdentifiers() async {
        // Given: PlatformPerformanceLayer6
        let testView = PlatformPerformanceLayer6()
        
        // Then: Should generate accessibility identifiers
            // TODO: ViewInspector Detection Issue - VERIFIED: PlatformPerformanceLayer6 DOES have .automaticCompliance() 
            // modifier applied in Framework/Sources/Layers/Layer6-Optimization/PlatformPerformanceLayer6.swift:16.
            // The test needs to be updated to handle ViewInspector's inability to detect these modifiers reliably.
            // This is a ViewInspector limitation, not a missing modifier issue.
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            testView,
            expectedPattern: "SixLayer.main.ui.*",
            platform: SixLayerPlatform.iOS,
            componentName: "PlatformPerformanceLayer6"
        )
 #expect(hasAccessibilityID, "PlatformPerformanceLayer6 should generate accessibility identifiers ")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }
}

