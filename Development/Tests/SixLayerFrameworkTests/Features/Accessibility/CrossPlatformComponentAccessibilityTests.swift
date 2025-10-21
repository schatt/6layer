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
open class CrossPlatformComponentAccessibilityTests: BaseTestClass {
    
    // MARK: - Cross-Platform Component Tests
    
    @Test func testCrossPlatformOptimizationGeneratesAccessibilityIdentifiers() async {
        // Given: CrossPlatformOptimization
        let testView = CrossPlatformOptimization()
        
        // Then: Should generate accessibility identifiers
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            testView,
            expectedPattern: "*.main.element.*",
            platform: .iOS,
            platform: .iOS,
            componentName: "CrossPlatformOptimization"
        )
        
        #expect(hasAccessibilityID, "CrossPlatformOptimization should generate accessibility identifiers")
    }
}

