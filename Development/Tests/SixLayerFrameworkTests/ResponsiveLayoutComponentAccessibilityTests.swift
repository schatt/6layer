//
//  ResponsiveLayoutComponentAccessibilityTests.swift
//  SixLayerFrameworkTests
//
//  Comprehensive accessibility tests for ALL ResponsiveLayout components
//

import XCTest
import SwiftUI
@testable import SixLayerFramework

@MainActor
final class ResponsiveLayoutComponentAccessibilityTests: XCTestCase {
    
    // MARK: - ResponsiveGrid Tests
    
    func testResponsiveGridGeneratesAccessibilityIdentifiers() async {
        // Given: Test grid items
        let gridItems = [
            GridItemData(title: "Grid Item 1", subtitle: "Subtitle 1", icon: "star", color: .blue),
            GridItemData(title: "Grid Item 2", subtitle: "Subtitle 2", icon: "heart", color: .red),
            GridItemData(title: "Grid Item 3", subtitle: "Subtitle 3", icon: "circle", color: .green)
        ]
        
        // When: Creating ResponsiveGrid
        let view = ResponsiveGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
            ForEach(gridItems) { item in
                VStack {
                    Text(item.title)
                    Text(item.subtitle)
                }
            }
        }
        
        // Then: Should generate accessibility identifiers
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view,
            expectedPattern: "*.main.element.*",
            componentName: "ResponsiveGrid"
        )
        
        XCTAssertTrue(hasAccessibilityID, "ResponsiveGrid should generate accessibility identifiers")
    }
    
    // MARK: - ResponsiveNavigation Tests
    
    func testResponsiveNavigationGeneratesAccessibilityIdentifiers() async {
        // Given: Test navigation content
        let navigationContent: (Bool) -> some View = { _ in
            VStack {
                Text("Navigation Content")
                Button("Test Button") { }
            }
        }
        
        // When: Creating ResponsiveNavigation
        let view = ResponsiveNavigation(content: navigationContent)
        
        // Then: Should generate accessibility identifiers
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view,
            expectedPattern: "*.main.element.*",
            componentName: "ResponsiveNavigation"
        )
        
        XCTAssertTrue(hasAccessibilityID, "ResponsiveNavigation should generate accessibility identifiers")
    }
    
    // MARK: - ResponsiveStack Tests
    
    func testResponsiveStackGeneratesAccessibilityIdentifiers() async {
        // Given: Test stack content
        let stackContent = {
            VStack {
                Text("Stack Item 1")
                Text("Stack Item 2")
                Text("Stack Item 3")
            }
        }
        
        // When: Creating ResponsiveStack
        let view = ResponsiveStack(content: stackContent)
        
        // Then: Should generate accessibility identifiers
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view,
            expectedPattern: "*.main.element.*",
            componentName: "ResponsiveStack"
        )
        
        XCTAssertTrue(hasAccessibilityID, "ResponsiveStack should generate accessibility identifiers")
    }
    
    // MARK: - ResponsiveLayoutExample Tests
    
    func testResponsiveLayoutExampleGeneratesAccessibilityIdentifiers() async {
        // When: Creating ResponsiveLayoutExample
        let view = ResponsiveLayoutExample()
        
        // Then: Should generate accessibility identifiers
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view,
            expectedPattern: "*.main.element.*",
            componentName: "ResponsiveLayoutExample"
        )
        
        XCTAssertTrue(hasAccessibilityID, "ResponsiveLayoutExample should generate accessibility identifiers")
    }
    
    // MARK: - ResponsiveNavigationExample Tests
    
    func testResponsiveNavigationExampleGeneratesAccessibilityIdentifiers() async {
        // When: Creating ResponsiveNavigationExample
        let view = ResponsiveNavigationExample()
        
        // Then: Should generate accessibility identifiers
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view,
            expectedPattern: "*.main.element.*",
            componentName: "ResponsiveNavigationExample"
        )
        
        XCTAssertTrue(hasAccessibilityID, "ResponsiveNavigationExample should generate accessibility identifiers")
    }
    
    // MARK: - ResponsivePadding Modifier Tests
    
    func testResponsivePaddingModifierGeneratesAccessibilityIdentifiers() async {
        // Given: Test content
        let testContent = Text("Test Content")
        
        // When: Applying ResponsivePadding modifier
        let view = testContent.modifier(ResponsivePadding())
        
        // Then: Should generate accessibility identifiers
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view,
            expectedPattern: "*.main.element.*",
            componentName: "ResponsivePadding"
        )
        
        XCTAssertTrue(hasAccessibilityID, "ResponsivePadding modifier should generate accessibility identifiers")
    }
}
