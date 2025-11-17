import Testing


//
//  VisionSafetyComponentAccessibilityTests.swift
//  SixLayerFrameworkTests
//
//  Comprehensive accessibility tests for ALL Vision Safety Components
//

import SwiftUI
@testable import SixLayerFramework

@MainActor
@Suite("Vision Safety Component Accessibility")
open class VisionSafetyComponentAccessibilityTests: BaseTestClass {
    
    // MARK: - Vision Safety Component Tests
    
    @Test func testVisionSafetyGeneratesAccessibilityIdentifiers() async {
        // Given: VisionSafety
        let testView = VisionSafety()
        
        // Then: Should generate accessibility identifiers
        // VERIFIED: VisionSafety DOES have .automaticCompliance() 
        // modifier applied in Framework/Sources/Components/Views/VisionSafety.swift:15.
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            testView,
            expectedPattern: "SixLayer.main.ui.*",
            platform: SixLayerPlatform.iOS,
            componentName: "VisionSafety"
        )
        #expect(hasAccessibilityID, "VisionSafety should generate accessibility identifiers")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }
}