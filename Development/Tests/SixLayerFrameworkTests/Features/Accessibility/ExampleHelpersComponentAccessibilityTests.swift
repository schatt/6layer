import Testing
@testable import SixLayerFramework


//
//  ExampleHelpersComponentAccessibilityTests.swift
//  SixLayerFrameworkTests
//
//  Comprehensive accessibility tests for ALL ExampleHelpers components
//

import SwiftUI
@testable import SixLayerFramework

@MainActor
class ExampleHelpersComponentAccessibilityTests: BaseTestClass {
    
    // MARK: - ExampleProjectCard Tests
    
    @Test func testExampleProjectCardGeneratesAccessibilityIdentifiers() async {
        // Given: Test project data
        let projectData = ExampleProjectData(
            id: "1",
            title: "Example Project",
            description: "This is an example project",
            status: .active
        )
        
        // When: Creating ExampleProjectCard
        let view = ExampleProjectCard(project: projectData)
        
        // Then: Should generate accessibility identifiers
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view,
            expectedPattern: "*.main.element.*",
            componentName: "ExampleProjectCard"
        )
        
        #expect(hasAccessibilityID, "ExampleProjectCard should generate accessibility identifiers")
    }
    
    // MARK: - ExampleProjectList Tests
    
    @Test func testExampleProjectListGeneratesAccessibilityIdentifiers() async {
        // Given: Test project items
        let projectItems = [
            ExampleProjectItem(id: "1", title: "Project 1"),
            ExampleProjectItem(id: "2", title: "Project 2")
        ]
        
        // When: Creating ExampleProjectList
        let view = ExampleProjectList(items: projectItems) { item in
            Text(item.title)
        }
        
        // Then: Should generate accessibility identifiers
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view,
            expectedPattern: "*.main.element.*",
            componentName: "ExampleProjectList"
        )
        
        #expect(hasAccessibilityID, "ExampleProjectList should generate accessibility identifiers")
    }
    
    // MARK: - ExampleProjectFormField Tests
    
    @Test func testExampleProjectFormFieldGeneratesAccessibilityIdentifiers() async {
        // Given: Test form field data
        let formFieldData = FormFieldData(
            label: "Example Form Field",
            placeholder: "Enter text here",
            value: ""
        )
        
        // When: Creating ExampleProjectFormField
        let view = ExampleProjectFormField(field: formFieldData)
        
        // Then: Should generate accessibility identifiers
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view,
            expectedPattern: "*.main.element.*",
            componentName: "ExampleProjectFormField"
        )
        
        #expect(hasAccessibilityID, "ExampleProjectFormField should generate accessibility identifiers")
    }
}



