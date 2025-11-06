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
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            testView,
            expectedPattern: "SixLayer.main.ui.*",
            platform: SixLayerPlatform.iOS,
            componentName: "CrossPlatformOptimization"
        )
        
        #expect(hasAccessibilityID, "CrossPlatformOptimization should generate accessibility identifiers")
    }
}

