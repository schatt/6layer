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
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            testView,
            expectedPattern: "SixLayer.main.ui.*",
            platform: SixLayerPlatform.iOS,
            componentName: "VisionSafety"
        )
        
        #expect(hasAccessibilityID, "VisionSafety should generate accessibility identifiers")
    }
}