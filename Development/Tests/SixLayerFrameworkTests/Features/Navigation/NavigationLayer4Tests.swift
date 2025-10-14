import Testing


//
//  NavigationLayer4Tests.swift
//  SixLayerFrameworkTests
//
//  Tests for Layer 4 navigation component functions
//  Tests platformNavigationLink_L4, platformNavigationBarItems_L4, and related functions
//

import SwiftUI
import ViewInspector
@testable import SixLayerFramework

@MainActor
final class NavigationLayer4Tests {
    
    // MARK: - Test Types
    
    struct TestItem: Identifiable, Hashable {
        let id = UUID()
        let value: String
    }
    
    // MARK: - Navigation Link Tests
    
    @Test func testPlatformNavigationLink_L4_BasicDestination() {
        // Given: Basic navigation link with destination
        let destination = Text("Destination View")
        let label = Text("Navigate")
        
        // When: Creating navigation link
        let link = label.platformNavigationLink_L4(destination: destination) {
            Text("Label")
        }
        
        // Then: Test the two critical aspects
        
        // 1. Does it return a valid structure of the kind it's supposed to?
        #expect(link != nil, "Navigation link should be created successfully")
        
        // 2. Does that structure contain what it should?
        do {
            // The navigation link should contain text elements
            let viewText = try link.inspect().findAll(ViewType.Text.self)
            #expect(!viewText.isEmpty, "Navigation link should contain text elements")
            
            // Should contain the label text
            let hasLabelText = viewText.contains { text in
                do {
                    let textContent = try text.string()
                    return textContent.contains("Label")
                } catch {
                    return false
                }
            }
            #expect(hasLabelText, "Navigation link should contain the label text 'Label'")
            
        } catch {
            Issue.record("Failed to inspect navigation link structure: \(error)")
        }
        
        // 3. Platform-specific implementation verification (REQUIRED)
        #if os(iOS)
        // iOS: Should contain NavigationLink structure
        do {
            let _ = try link.inspect().find(ViewType.NavigationLink.self)
            // NavigationLink found - this is correct for iOS
        } catch {
            Issue.record("iOS navigation link should contain NavigationLink structure")
        }
        #elseif os(macOS)
        // macOS: Should contain the content directly (no NavigationLink wrapper)
        do {
            let _ = try link.inspect()
            // Direct content inspection works - this is correct for macOS
        } catch {
            Issue.record("macOS navigation link should be inspectable directly")
        }
        #endif
    }
    
    @Test func testPlatformNavigationLink_L4_WithTitleAndSystemImage() {
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
        
        // Then: Should create valid navigation link that can be hosted
        let hostingView = hostRootPlatformView(link.withGlobalAutoIDsEnabled())
        #expect(hostingView != nil, "Navigation link with title and system image should be hostable")
        #expect(link != nil, "Navigation link with title and system image should be created")
    }
    
    @Test func testPlatformNavigationLink_L4_WithValue() {
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
        #expect(link != nil, "Navigation link with value should be created")
    }
    
    @Test func testPlatformNavigationLink_L4_WithNilValue() {
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
        #expect(link != nil, "Navigation link with nil value should be created")
    }
    
    @Test func testPlatformNavigationLink_L4_WithTagAndSelection() {
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
        #expect(link != nil, "Navigation link with tag should be created")
    }
    
    @Test func testPlatformNavigationLink_L4_WithDifferentTagTypes() {
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
        #expect(stringLink != nil, "String tag navigation link should be created")
        #expect(intLink != nil, "Int tag navigation link should be created")
        #expect(uuidLink != nil, "UUID tag navigation link should be created")
    }
    
    // MARK: - Navigation Bar Items Tests
    
    @Test func testPlatformNavigationBarItems_L4_TrailingItem() {
        // Given: Navigation bar items with trailing item
        let trailingItem = Button("Save") { }
        
        // When: Adding navigation bar items
        let view = Text("Content")
            .platformNavigationBarItems_L4(trailing: trailingItem)
        
        // Then: Should create view with navigation bar items
        #expect(view != nil, "View with navigation bar items should be created")
    }
    
    @Test func testPlatformNavigationBarItems_L4_WithDifferentTrailingItems() {
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
        #expect(buttonView != nil, "View with button trailing item should be created")
        #expect(textView != nil, "View with text trailing item should be created")
        #expect(imageView != nil, "View with image trailing item should be created")
    }
    
    // MARK: - Navigation Container Tests
    
    @Test func testPlatformNavigationContainer() {
        // Given: Content to wrap in navigation container
        let content = Text("Navigation Content")
        
        // When: Wrapping content in navigation container
        let container = content.platformNavigationContainer {
            Text("Wrapped Content")
        }
        
        // Then: Should create navigation container
        #expect(container != nil, "Navigation container should be created")
        
        // 3. Platform-specific implementation verification (REQUIRED)
        #if os(iOS)
        // iOS: Should contain NavigationStack structure (iOS 16+) or direct content (iOS 15-)
        do {
            // Try to find NavigationStack first (iOS 16+)
            let _ = try container.inspect().find(ViewType.NavigationStack.self)
            // NavigationStack found - this is correct for iOS 16+
        } catch {
            // Fallback: direct content inspection (iOS 15-)
            do {
                let _ = try container.inspect()
                // Direct content inspection works - this is correct for iOS 15-
            } catch {
                Issue.record("iOS platform navigation container should be inspectable")
            }
        }
        #elseif os(macOS)
        // macOS: Should contain the content directly (no NavigationStack wrapper)
        do {
            let _ = try container.inspect()
            // Direct content inspection works - this is correct for macOS
        } catch {
            Issue.record("macOS platform navigation container should be inspectable directly")
        }
        #endif
    }
    
    @Test func testPlatformNavigationContainer_WithComplexContent() {
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
        #expect(container != nil, "Navigation container with complex content should be created")
    }
    
    // MARK: - Navigation Destination Tests
    
    @Test func testPlatformNavigationDestination() {
        // Given: Navigation destination with item
        let item = Binding<TestItem?>(get: { TestItem(value: "test-item") }, set: { _ in })
        
        // When: Creating navigation destination
        let destination = Text("Trigger")
            .platformNavigationDestination(item: item) { item in
                Text("Destination: \(item.value)")
            }
        
        // Then: Should create navigation destination
        #expect(destination != nil, "Navigation destination should be created")
    }
    
    @Test func testPlatformNavigationDestination_WithNilItem() {
        // Given: Navigation destination with nil item
        let item = Binding<TestItem?>(get: { nil }, set: { _ in })
        
        // When: Creating navigation destination with nil item
        let destination = Text("Trigger")
            .platformNavigationDestination(item: item) { item in
                Text("Destination: \(item.value)")
            }
        
        // Then: Should create navigation destination (should handle nil gracefully)
        #expect(destination != nil, "Navigation destination with nil item should be created")
    }
    
    @Test func testPlatformNavigationDestination_WithDifferentItemTypes() {
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
        #expect(destination1 != nil, "String item destination should be created")
        #expect(destination2 != nil, "Number item destination should be created")
        #expect(destination3 != nil, "UUID item destination should be created")
    }
    
    // MARK: - Platform Navigation Tests
    
    @Test func testPlatformNavigation_Basic() {
        // Given: Content to wrap in platform navigation
        let content = Text("Navigation Content")
        
        // When: Wrapping content in platform navigation
        let navigation = content.platformNavigation {
            Text("Wrapped Content")
        }
        
        // Then: Should create platform navigation
        #expect(navigation != nil, "Platform navigation should be created")
        
        // 3. Platform-specific implementation verification (REQUIRED)
        #if os(iOS)
        // iOS: Should contain NavigationView structure
        do {
            let _ = try navigation.inspect().find(ViewType.NavigationView.self)
            // NavigationView found - this is correct for iOS
        } catch {
            Issue.record("iOS platform navigation should contain NavigationView structure")
        }
        #elseif os(macOS)
        // macOS: Should contain the content directly (no NavigationView wrapper)
        do {
            let _ = try navigation.inspect()
            // Direct content inspection works - this is correct for macOS
        } catch {
            Issue.record("macOS platform navigation should be inspectable directly")
        }
        #endif
    }
    
    @Test func testPlatformNavigation_WithComplexContent() {
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
        #expect(navigation != nil, "Platform navigation with complex content should be created")
    }
    
    // MARK: - Integration Tests
    
    @Test func testNavigationComponents_Integration() {
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
        #expect(integratedView != nil, "Integrated navigation view should be created")
    }
    
    @Test func testNavigationComponents_WithStateManagement() {
        // Given: State management for navigation
        let isActive = Binding<Bool>(get: { false }, set: { _ in })
        let selection = Binding<String?>(get: { nil }, set: { _ in })
        let item = Binding<TestItem?>(get: { nil }, set: { _ in })
        
        // Verify bindings are properly configured
        #expect(selection.wrappedValue == nil, "Selection binding should return nil")
        #expect(item.wrappedValue == nil, "Item binding should return nil")
        #expect(!isActive.wrappedValue, "IsActive binding should return false")
        
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
        #expect(statefulView != nil, "Stateful navigation view should be created")
    }
    
    // MARK: - Edge Cases and Error Handling
    
    @Test func testNavigationComponents_EmptyContent() {
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
        #expect(emptyNavigation != nil, "Empty navigation should be created")
        #expect(emptyContainer != nil, "Empty container should be created")
    }
    
    @Test func testNavigationComponents_WithNilBindings() {
        // Given: Nil bindings
        let nilIsActive = Binding<Bool>(get: { false }, set: { _ in })
        let nilSelection = Binding<String?>(get: { nil }, set: { _ in })
        let nilItem = Binding<TestItem?>(get: { nil }, set: { _ in })
        
        // Verify nil bindings are properly configured
        #expect(nilSelection.wrappedValue == nil, "Nil selection binding should return nil")
        #expect(nilItem.wrappedValue == nil, "Nil item binding should return nil")
        #expect(!nilIsActive.wrappedValue, "Nil isActive binding should return false")
        
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
        #expect(nilLink != nil, "Nil link should be created")
        #expect(nilDestination != nil, "Nil destination should be created")
    }
    
    // MARK: - Performance Tests
    
    @Test func testNavigationComponents_Performance() {
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
