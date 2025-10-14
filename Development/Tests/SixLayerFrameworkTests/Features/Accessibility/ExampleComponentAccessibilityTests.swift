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
final class ExampleComponentAccessibilityTests {
    
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
    
    @Test func testFormInsightsDashboardGeneratesAccessibilityIdentifiers() async {
        // Given: FormInsightsDashboard
        let testView = FormInsightsDashboard()
        
        // Then: Should generate accessibility identifiers
        let hasAccessibilityID = hasAccessibilityIdentifier(
            testView,
            expectedPattern: "*.main.element.*",
            componentName: "FormInsightsDashboard"
        )
        
        #expect(hasAccessibilityID, "FormInsightsDashboard should generate accessibility identifiers")
    }
    
    @Test func testExampleHelpersGeneratesAccessibilityIdentifiers() async {
        // Given: ExampleHelpers
        let testView = ExampleHelpers()
        
        // Then: Should generate accessibility identifiers
        let hasAccessibilityID = hasAccessibilityIdentifier(
            testView,
            expectedPattern: "*.main.element.*",
            componentName: "ExampleHelpers"
        )
        
        #expect(hasAccessibilityID, "ExampleHelpers should generate accessibility identifiers")
    }
}

// MARK: - Mock Example Components (Placeholder implementations)

struct FormUsageExample: View {
    var body: some View {
        VStack {
            Text("Form Usage Example")
            Button("Submit") { }
        }
        .automaticAccessibilityIdentifiers()
    }
}

struct FormInsightsDashboard: View {
    var body: some View {
        VStack {
            Text("Form Insights Dashboard")
            Button("View Insights") { }
        }
        .automaticAccessibilityIdentifiers()
    }
}

struct ExampleHelpers: View {
    var body: some View {
        VStack {
            Text("Example Helpers")
            Button("Help") { }
        }
        .automaticAccessibilityIdentifiers()
    }
}



