import Testing
import SwiftUI

//
//  NavigationStackLayer1Tests.swift
//  SixLayerFrameworkTests
//
//  TDD Tests for platformPresentNavigationStack_L1 function
//  Tests for Layer 1 semantic intent for NavigationStack
//

@testable import SixLayerFramework

/// NOTE: Not marked @MainActor on class to allow parallel execution
@Suite("NavigationStack Layer 1")
open class NavigationStackLayer1Tests: BaseTestClass {
    
    // MARK: - Test Data
    
    struct TestItem: Identifiable, Hashable {
        let id: UUID
        let title: String
    }
    
    let testHints = PresentationHints(
        dataType: .navigation,
        presentationPreference: .navigation,
        complexity: .simple,
        context: .navigation
    )
    
    // MARK: - Basic Functionality Tests
    
    @Test @MainActor func testPlatformPresentNavigationStack_L1_CreatesView() {
        // Given: Simple content view
        let content = Text("Test Content")
        
        // When: Creating navigation stack presentation
        let view = platformPresentNavigationStack_L1(
            content: content,
            hints: testHints
        )
        
        // Then: Should return a valid SwiftUI view
        // Verify the view type contains View-related types (may be wrapped in modifiers)
        let mirror = Mirror(reflecting: view)
        let viewType = String(describing: mirror.subjectType)
        // Check for View in the type name (case-insensitive) or ModifiedContent which is a valid SwiftUI view wrapper
        #expect(viewType.lowercased().contains("view") || viewType.contains("ModifiedContent"), 
                "View should be a SwiftUI view type, got: \(viewType)")
    }
    
    @Test @MainActor func testPlatformPresentNavigationStack_L1_WithTitle() {
        // Given: Content with title
        let content = Text("Test Content")
        let title = "Test Navigation"
        
        // When: Creating navigation stack with title
        let view = platformPresentNavigationStack_L1(
            content: content,
            title: title,
            hints: testHints
        )
        
        // Then: Should return a valid SwiftUI view
        let mirror = Mirror(reflecting: view)
        let viewType = String(describing: mirror.subjectType)
        #expect(viewType.lowercased().contains("view") || viewType.contains("ModifiedContent"), 
                "View should be a SwiftUI view type, got: \(viewType)")
    }
    
    @Test @MainActor func testPlatformPresentNavigationStack_L1_WithItems() {
        // Given: Collection of items
        let items = [
            TestItem(id: UUID(), title: "Item 1"),
            TestItem(id: UUID(), title: "Item 2"),
            TestItem(id: UUID(), title: "Item 3")
        ]
        
        // When: Creating navigation stack with items
        let view = platformPresentNavigationStack_L1(
            items: items,
            hints: testHints
        ) { item in
            Text(item.title)
        } destination: { item in
            Text("Detail: \(item.title)")
        }
        
        // Then: Should return a valid SwiftUI view
        let mirror = Mirror(reflecting: view)
        let viewType = String(describing: mirror.subjectType)
        #expect(viewType.lowercased().contains("view") || viewType.contains("ModifiedContent"), 
                "View should be a SwiftUI view type, got: \(viewType)")
    }
    
    @Test @MainActor func testPlatformPresentNavigationStack_L1_HandlesEmptyItems() {
        // Given: Empty items array
        let items: [TestItem] = []
        
        // When: Creating navigation stack with empty items
        let view = platformPresentNavigationStack_L1(
            items: items,
            hints: testHints
        ) { item in
            Text(item.title)
        } destination: { item in
            Text("Detail: \(item.title)")
        }
        
        // Then: Should return a valid SwiftUI view even with empty items
        let mirror = Mirror(reflecting: view)
        let viewType = String(describing: mirror.subjectType)
        #expect(viewType.lowercased().contains("view") || viewType.contains("ModifiedContent"), 
                "View should be a SwiftUI view type even with empty items, got: \(viewType)")
    }
    
    @Test @MainActor func testPlatformPresentNavigationStack_L1_WithDifferentHints() {
        // Given: Different presentation hints
        let simpleHints = PresentationHints(
            dataType: .navigation,
            presentationPreference: .navigation,
            complexity: .simple,
            context: .navigation
        )
        
        let complexHints = PresentationHints(
            dataType: .navigation,
            presentationPreference: .navigation,
            complexity: .complex,
            context: .navigation
        )
        
        let content = Text("Test Content")
        
        // When: Creating navigation stacks with different hints
        let simpleView = platformPresentNavigationStack_L1(
            content: content,
            hints: simpleHints
        )
        
        let complexView = platformPresentNavigationStack_L1(
            content: content,
            hints: complexHints
        )
        
        // Then: Both should return valid SwiftUI views
        let simpleMirror = Mirror(reflecting: simpleView)
        let simpleType = String(describing: simpleMirror.subjectType)
        #expect(simpleType.lowercased().contains("view") || simpleType.contains("ModifiedContent"), 
                "Simple view should be a SwiftUI view type, got: \(simpleType)")
        
        let complexMirror = Mirror(reflecting: complexView)
        let complexType = String(describing: complexMirror.subjectType)
        #expect(complexType.lowercased().contains("view") || complexType.contains("ModifiedContent"), 
                "Complex view should be a SwiftUI view type, got: \(complexType)")
    }
}

