//
//  ExampleHelpersComponentAccessibilityTests.swift
//  SixLayerFrameworkTests
//
//  Comprehensive accessibility tests for ALL ExampleHelpers components
//

import XCTest
import SwiftUI
@testable import SixLayerFramework

@MainActor
final class ExampleHelpersComponentAccessibilityTests: XCTestCase {
    
    // MARK: - ExampleProjectCard Tests
    
    func testExampleProjectCardGeneratesAccessibilityIdentifiers() async {
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
        
        XCTAssertTrue(hasAccessibilityID, "ExampleProjectCard should generate accessibility identifiers")
    }
    
    // MARK: - ExampleProjectList Tests
    
    func testExampleProjectListGeneratesAccessibilityIdentifiers() async {
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
        
        XCTAssertTrue(hasAccessibilityID, "ExampleProjectList should generate accessibility identifiers")
    }
    
    // MARK: - ExampleProjectFormField Tests
    
    func testExampleProjectFormFieldGeneratesAccessibilityIdentifiers() async {
        // Given: Test form field data
        let formFieldData = ExampleFormFieldData(
            id: "example-field",
            label: "Example Form Field",
            value: "",
            type: .text
        )
        
        // When: Creating ExampleProjectFormField
        let view = ExampleProjectFormField(field: formFieldData)
        
        // Then: Should generate accessibility identifiers
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view,
            expectedPattern: "*.main.element.*",
            componentName: "ExampleProjectFormField"
        )
        
        XCTAssertTrue(hasAccessibilityID, "ExampleProjectFormField should generate accessibility identifiers")
    }
}

// MARK: - Test Data Types

struct ExampleProjectData {
    let id: String
    let title: String
    let description: String
    let status: ProjectStatus
}

enum ProjectStatus {
    case active
    case inactive
    case completed
    case archived
}

struct ExampleProjectItem: Identifiable {
    let id: String
    let title: String
}

struct ExampleFormFieldData {
    let id: String
    let label: String
    let value: String
    let type: ExampleFormFieldType
}

enum ExampleFormFieldType {
    case text
    case number
    case email
    case password
}



