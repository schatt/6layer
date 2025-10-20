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
        let hasAccessibilityID = hasAccessibilityIdentifier(
            testView,
            expectedPattern: "*.main.element.*",
            componentName: "FormUsageExample"
        )
        
        #expect(hasAccessibilityID, "FormUsageExample should generate accessibility identifiers")
    }
    
    // FormInsightsDashboard test removed - component was removed as business-specific logic
    
    @Test func testExampleHelpersGeneratesAccessibilityIdentifiers() async {
        // Given: ExampleProjectCard (from ExampleHelpers)
        let testView = ExampleProjectCard(
            title: "Test Project",
            description: "Test Description",
            onTap: {}
        )
        
        // Then: Should generate accessibility identifiers
        let hasAccessibilityID = hasAccessibilityIdentifier(
            testView,
            expectedPattern: "*.main.element.*",
            componentName: "ExampleProjectCard"
        )
        
        #expect(hasAccessibilityID, "ExampleProjectCard should generate accessibility identifiers")
    }
}

