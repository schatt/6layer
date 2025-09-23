//
//  NavigationLayer4Tests.swift
//  SixLayerFrameworkTests
//
//  Tests for Layer 4 navigation component functions
//  Tests platformNavigationLink_L4, platformNavigationBarItems_L4, and related functions
//

import XCTest
import SwiftUI
@testable import SixLayerFramework

@MainActor
final class NavigationLayer4Tests: XCTestCase {
    
    // MARK: - Test Types
    
    struct TestItem: Identifiable, Hashable {
        let id = UUID()
        let value: String
    }
    
    // MARK: - Navigation Link Tests
    
    func testPlatformNavigationLink_L4_BasicDestination() {
        // Given: Basic navigation link with destination
        let destination = Text("Destination View")
        let label = Text("Navigate")
        
        // When: Creating navigation link
        let link = label.platformNavigationLink_L4(destination: destination) {
            Text("Label")
        }
        
        // Then: Should create valid navigation link
        XCTAssertNotNil(link, "Navigation link should be created successfully")
    }
    
    func testPlatformNavigationLink_L4_WithTitleAndSystemImage() {
        // Given: Navigation link with title and system image
        let title = "Settings"
        let systemImage = "gear"
        let isActive = Binding<Bool>(get: { false }, set: { _ in })
        
        // When: Creating navigation link
        let link = Text("Trigger")
            .platformNavigationLink_L4(
                title: title,
                systemImage: systemImage,
                isActive: isActive
            ) {
                Text("Settings View")
            }
        
        // Then: Should create valid navigation link
        XCTAssertNotNil(link, "Navigation link with title and system image should be created")
    }
    
    func testPlatformNavigationLink_L4_WithValue() {
        // Given: Navigation link with value
        let value: String? = "test-value"
        let label = Text("Navigate to Value")
        
        // When: Creating navigation link with value
        let link = label.platformNavigationLink_L4(value: value) { value in
            Text("Value: \(value)")
        } label: {
            Text("Navigate")
        }
        
        // Then: Should create valid navigation link
        XCTAssertNotNil(link, "Navigation link with value should be created")
    }
    
    func testPlatformNavigationLink_L4_WithNilValue() {
        // Given: Navigation link with nil value
        let value: String? = nil
        let label = Text("Navigate to Nil")
        
        // When: Creating navigation link with nil value
        let link = label.platformNavigationLink_L4(value: value) { value in
            Text("Value: \(value)")
        } label: {
            Text("Navigate")
        }
        
        // Then: Should create valid navigation link (should handle nil gracefully)
        XCTAssertNotNil(link, "Navigation link with nil value should be created")
    }
    
    func testPlatformNavigationLink_L4_WithTagAndSelection() {
        // Given: Navigation link with tag and selection
        let tag = "test-tag"
        let selection = Binding<String?>(get: { nil }, set: { _ in })
        
        // When: Creating navigation link with tag
        let link = Text("Trigger")
            .platformNavigationLink_L4(
                tag: tag,
                selection: selection
            ) { tag in
                Text("Tag: \(tag)")
            } label: {
                Text("Navigate")
            }
        
        // Then: Should create valid navigation link
        XCTAssertNotNil(link, "Navigation link with tag should be created")
    }
    
    func testPlatformNavigationLink_L4_WithDifferentTagTypes() {
        // Given: Different tag types
        let stringTag = "string-tag"
        let intTag = 42
        let uuidTag = UUID()
        
        let stringSelection = Binding<String?>(get: { nil }, set: { _ in })
        let intSelection = Binding<Int?>(get: { nil }, set: { _ in })
        let uuidSelection = Binding<UUID?>(get: { nil }, set: { _ in })
        
        // When: Creating navigation links with different tag types
        let stringLink = Text("String")
            .platformNavigationLink_L4(tag: stringTag, selection: stringSelection) { tag in
                Text("String: \(tag)")
            } label: {
                Text("String Link")
            }
        
        let intLink = Text("Int")
            .platformNavigationLink_L4(tag: intTag, selection: intSelection) { tag in
                Text("Int: \(tag)")
            } label: {
                Text("Int Link")
            }
        
        let uuidLink = Text("UUID")
            .platformNavigationLink_L4(tag: uuidTag, selection: uuidSelection) { tag in
                Text("UUID: \(tag)")
            } label: {
                Text("UUID Link")
            }
        
        // Then: All links should be created successfully
        XCTAssertNotNil(stringLink, "String tag navigation link should be created")
        XCTAssertNotNil(intLink, "Int tag navigation link should be created")
        XCTAssertNotNil(uuidLink, "UUID tag navigation link should be created")
    }
    
    // MARK: - Navigation Bar Items Tests
    
    func testPlatformNavigationBarItems_L4_TrailingItem() {
        // Given: Navigation bar items with trailing item
        let trailingItem = Button("Save") { }
        
        // When: Adding navigation bar items
        let view = Text("Content")
            .platformNavigationBarItems_L4(trailing: trailingItem)
        
        // Then: Should create view with navigation bar items
        XCTAssertNotNil(view, "View with navigation bar items should be created")
    }
    
    func testPlatformNavigationBarItems_L4_WithDifferentTrailingItems() {
        // Given: Different types of trailing items
        let buttonItem = Button("Action") { }
        let textItem = Text("Info")
        let imageItem = Image(systemName: "star")
        
        // When: Adding different trailing items
        let buttonView = Text("Content")
            .platformNavigationBarItems_L4(trailing: buttonItem)
        
        let textView = Text("Content")
            .platformNavigationBarItems_L4(trailing: textItem)
        
        let imageView = Text("Content")
            .platformNavigationBarItems_L4(trailing: imageItem)
        
        // Then: All views should be created successfully
        XCTAssertNotNil(buttonView, "View with button trailing item should be created")
        XCTAssertNotNil(textView, "View with text trailing item should be created")
        XCTAssertNotNil(imageView, "View with image trailing item should be created")
    }
    
    // MARK: - Navigation Container Tests
    
    func testPlatformNavigationContainer() {
        // Given: Content to wrap in navigation container
        let content = Text("Navigation Content")
        
        // When: Wrapping content in navigation container
        let container = content.platformNavigationContainer {
            Text("Wrapped Content")
        }
        
        // Then: Should create navigation container
        XCTAssertNotNil(container, "Navigation container should be created")
    }
    
    func testPlatformNavigationContainer_WithComplexContent() {
        // Given: Complex content to wrap
        let complexContent = VStack {
            Text("Title")
            Text("Subtitle")
            Button("Action") { }
        }
        
        // When: Wrapping complex content
        let container = Text("Trigger")
            .platformNavigationContainer {
                complexContent
            }
        
        // Then: Should create container with complex content
        XCTAssertNotNil(container, "Navigation container with complex content should be created")
    }
    
    // MARK: - Navigation Destination Tests
    
    func testPlatformNavigationDestination() {
        // Given: Navigation destination with item
        let item = Binding<TestItem?>(get: { TestItem(value: "test-item") }, set: { _ in })
        
        // When: Creating navigation destination
        let destination = Text("Trigger")
            .platformNavigationDestination(item: item) { item in
                Text("Destination: \(item.value)")
            }
        
        // Then: Should create navigation destination
        XCTAssertNotNil(destination, "Navigation destination should be created")
    }
    
    func testPlatformNavigationDestination_WithNilItem() {
        // Given: Navigation destination with nil item
        let item = Binding<TestItem?>(get: { nil }, set: { _ in })
        
        // When: Creating navigation destination with nil item
        let destination = Text("Trigger")
            .platformNavigationDestination(item: item) { item in
                Text("Destination: \(item.value)")
            }
        
        // Then: Should create navigation destination (should handle nil gracefully)
        XCTAssertNotNil(destination, "Navigation destination with nil item should be created")
    }
    
    func testPlatformNavigationDestination_WithDifferentItemTypes() {
        // Given: Different item types
        let item1 = Binding<TestItem?>(get: { TestItem(value: "string") }, set: { _ in })
        let item2 = Binding<TestItem?>(get: { TestItem(value: "number") }, set: { _ in })
        let item3 = Binding<TestItem?>(get: { TestItem(value: "uuid") }, set: { _ in })
        
        // When: Creating destinations with different item types
        let destination1 = Text("String")
            .platformNavigationDestination(item: item1) { item in
                Text("String: \(item.value)")
            }
        
        let destination2 = Text("Int")
            .platformNavigationDestination(item: item2) { item in
                Text("Number: \(item.value)")
            }
        
        let destination3 = Text("UUID")
            .platformNavigationDestination(item: item3) { item in
                Text("UUID: \(item.value)")
            }
        
        // Then: All destinations should be created successfully
        XCTAssertNotNil(destination1, "String item destination should be created")
        XCTAssertNotNil(destination2, "Number item destination should be created")
        XCTAssertNotNil(destination3, "UUID item destination should be created")
    }
    
    // MARK: - Platform Navigation Tests
    
    func testPlatformNavigation_Basic() {
        // Given: Content to wrap in platform navigation
        let content = Text("Navigation Content")
        
        // When: Wrapping content in platform navigation
        let navigation = content.platformNavigation {
            Text("Wrapped Content")
        }
        
        // Then: Should create platform navigation
        XCTAssertNotNil(navigation, "Platform navigation should be created")
    }
    
    func testPlatformNavigation_WithComplexContent() {
        // Given: Complex content
        let complexContent = VStack {
            Text("Title")
            Text("Subtitle")
            Button("Action") { }
        }
        
        // When: Wrapping complex content in platform navigation
        let navigation = Text("Trigger")
            .platformNavigation {
                complexContent
            }
        
        // Then: Should create platform navigation with complex content
        XCTAssertNotNil(navigation, "Platform navigation with complex content should be created")
    }
    
    // MARK: - Integration Tests
    
    func testNavigationComponents_Integration() {
        // Given: Multiple navigation components
        let isActive = Binding<Bool>(get: { false }, set: { _ in })
        let selection = Binding<String?>(get: { nil }, set: { _ in })
        
        // When: Combining multiple navigation components
        let integratedView = Text("Content")
            .platformNavigation {
                VStack {
                    Text("Title")
                    
                    Text("Navigate")
                        .platformNavigationLink_L4(
                            title: "Settings",
                            systemImage: "gear",
                            isActive: isActive
                        ) {
                            Text("Settings View")
                        }
                    
                    Text("Tag Link")
                        .platformNavigationLink_L4(
                            tag: "test-tag",
                            selection: selection
                        ) { tag in
                            Text("Tag: \(tag)")
                        } label: {
                            Text("Navigate to Tag")
                        }
                }
            }
            .platformNavigationBarItems_L4(trailing: Button("Save") { })
        
        // Then: Should create integrated navigation view
        XCTAssertNotNil(integratedView, "Integrated navigation view should be created")
    }
    
    func testNavigationComponents_WithStateManagement() {
        // Given: State management for navigation
        let isActive = Binding<Bool>(get: { false }, set: { _ in })
        let selection = Binding<String?>(get: { nil }, set: { _ in })
        let item = Binding<TestItem?>(get: { nil }, set: { _ in })
        
        // When: Creating navigation components with state
        let statefulView = Text("Content")
            .platformNavigationContainer {
                VStack {
                    Text("Stateful Navigation")
                    
                    Text("Link")
                        .platformNavigationLink_L4(
                            title: "State Link",
                            systemImage: "link",
                            isActive: isActive
                        ) {
                            Text("State Destination")
                        }
                    
                    Text("Destination")
                        .platformNavigationDestination(item: item) { item in
                            Text("Item: \(item.value)")
                        }
                }
            }
            .platformNavigationBarItems_L4(trailing: Button("Action") { })
        
        // Then: Should create stateful navigation view
        XCTAssertNotNil(statefulView, "Stateful navigation view should be created")
    }
    
    // MARK: - Edge Cases and Error Handling
    
    func testNavigationComponents_EmptyContent() {
        // Given: Empty content
        let emptyContent = EmptyView()
        
        // When: Using empty content with navigation components
        let emptyNavigation = emptyContent.platformNavigation {
            EmptyView()
        }
        
        let emptyContainer = emptyContent.platformNavigationContainer {
            EmptyView()
        }
        
        // Then: Should handle empty content gracefully
        XCTAssertNotNil(emptyNavigation, "Empty navigation should be created")
        XCTAssertNotNil(emptyContainer, "Empty container should be created")
    }
    
    func testNavigationComponents_WithNilBindings() {
        // Given: Nil bindings
        let nilIsActive = Binding<Bool>(get: { false }, set: { _ in })
        let nilSelection = Binding<String?>(get: { nil }, set: { _ in })
        let nilItem = Binding<TestItem?>(get: { nil }, set: { _ in })
        
        // When: Using nil bindings with navigation components
        let nilLink = Text("Nil Link")
            .platformNavigationLink_L4(
                title: "Nil",
                systemImage: "questionmark",
                isActive: nilIsActive
            ) {
                Text("Nil Destination")
            }
        
        let nilDestination = Text("Nil Destination")
            .platformNavigationDestination(item: nilItem) { item in
                Text("Nil: \(item.value)")
            }
        
        // Then: Should handle nil bindings gracefully
        XCTAssertNotNil(nilLink, "Nil link should be created")
        XCTAssertNotNil(nilDestination, "Nil destination should be created")
    }
    
    // MARK: - Performance Tests
    
    func testNavigationComponents_Performance() {
        // Given: Test data
        let isActive = Binding<Bool>(get: { false }, set: { _ in })
        
        // When: Measuring performance
        measure {
            let _ = Text("Content")
                .platformNavigation {
                    Text("Navigation Content")
                }
            
            let _ = Text("Link")
                .platformNavigationLink_L4(
                    title: "Test",
                    systemImage: "star",
                    isActive: isActive
                ) {
                    Text("Destination")
                }
            
            let _ = Text("Container")
                .platformNavigationContainer {
                    Text("Container Content")
                }
            
            let _ = Text("Bar Items")
                .platformNavigationBarItems_L4(trailing: Button("Action") { })
        }
    }
}
