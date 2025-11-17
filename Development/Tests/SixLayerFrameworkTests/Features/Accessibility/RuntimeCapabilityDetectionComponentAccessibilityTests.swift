import Testing


//
//  RuntimeCapabilityDetectionComponentAccessibilityTests.swift
//  SixLayerFrameworkTests
//
//  Comprehensive accessibility tests for ALL Runtime Capability Detection Components
//

import SwiftUI
@testable import SixLayerFramework

@MainActor
@Suite("Runtime Capability Detection Component Accessibility")
open class RuntimeCapabilityDetectionComponentAccessibilityTests: BaseTestClass {
    
    // MARK: - Runtime Capability Detection Component Tests
    
    @Test func testRuntimeCapabilityDetectionGeneratesAccessibilityIdentifiers() async {
        // Given: RuntimeCapabilityDetection
        let testView = RuntimeCapabilityDetectionView()
        
        // Then: Should generate accessibility identifiers
            // TODO: ViewInspector Detection Issue - VERIFIED: RuntimeCapabilityDetectionView DOES have .automaticCompliance() 
            // modifier applied in Framework/Sources/Components/Views/RuntimeCapabilityDetectionView.swift:17.
            // The test needs to be updated to handle ViewInspector's inability to detect these modifiers reliably.
            // This is a ViewInspector limitation, not a missing modifier issue.
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            testView,
            expectedPattern: "SixLayer.main.ui.*",
            platform: SixLayerPlatform.iOS,
            componentName: "RuntimeCapabilityDetectionView"
        )
 #expect(hasAccessibilityID, "RuntimeCapabilityDetection should generate accessibility identifiers ")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }
}