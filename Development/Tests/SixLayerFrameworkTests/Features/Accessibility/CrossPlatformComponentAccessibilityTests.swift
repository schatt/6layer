import Testing


//
//  CrossPlatformComponentAccessibilityTests.swift
//  SixLayerFrameworkTests
//
//  Comprehensive accessibility tests for ALL Cross-Platform Components
//

import SwiftUI
@testable import SixLayerFramework

@MainActor
@Suite("Cross Platform Component Accessibility")
open class CrossPlatformComponentAccessibilityTests: BaseTestClass {
    
    // MARK: - Cross-Platform Component Tests
    
    @Test func testCrossPlatformOptimizationGeneratesAccessibilityIdentifiers() async {
        // Given: CrossPlatformOptimization
        let testView = CrossPlatformOptimization()
        
        // Then: Should generate accessibility identifiers
        // VERIFIED: CrossPlatformOptimization DOES have .automaticCompliance() 
        // modifier applied in Framework/Sources/Components/Views/CrossPlatformOptimization.swift:16.
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            testView,
            expectedPattern: "SixLayer.main.ui.*",
            platform: SixLayerPlatform.iOS,
            componentName: "CrossPlatformOptimization"
        )
        #expect(hasAccessibilityID, "CrossPlatformOptimization should generate accessibility identifiers")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }
}

