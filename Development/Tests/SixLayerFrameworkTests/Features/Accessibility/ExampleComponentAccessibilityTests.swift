import Testing


//
//  ExampleComponentAccessibilityTests.swift
//  SixLayerFrameworkTests
//
//  Comprehensive accessibility tests for ALL Example Components
//

import SwiftUI
@testable import SixLayerFramework

@MainActor
open class ExampleComponentAccessibilityTests: BaseTestClass {
    
    // MARK: - Example Component Tests
    
    @Test func testFormUsageExampleGeneratesAccessibilityIdentifiers() async {
        // Given: FormUsageExample
        let testView = FormUsageExample()
        
        // Then: Should generate accessibility identifiers
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            testView,
            expectedPattern: "*.main.element.*",
            platform: SixLayerPlatform.iOS,
            componentName: "FormUsageExample"
        )
        
        #expect(hasAccessibilityID, "FormUsageExample should generate accessibility identifiers")
    }
    
    // FormInsightsDashboard test removed - component was removed as business-specific logic
    
    @Test func testExampleHelpersGeneratesAccessibilityIdentifiers() async {
        // Given: ExampleHelpers
        let testView = ExampleHelpers()
        
        // Then: Should generate accessibility identifiers
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            testView,
            expectedPattern: "*.main.element.*",
            platform: SixLayerPlatform.iOS,
            componentName: "ExampleProjectCard"
        )
        
        #expect(hasAccessibilityID, "ExampleProjectCard should generate accessibility identifiers")
    }
}

