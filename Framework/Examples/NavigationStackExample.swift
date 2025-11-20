//
//  NavigationStackExample.swift
//  SixLayerFramework
//
//  Example demonstrating NavigationStack 6-layer implementation
//

import SwiftUI
import SixLayerFramework

// MARK: - Example Data Models

struct ExampleItem: Identifiable, Hashable {
    let id: UUID
    let title: String
    let description: String
    let category: String
}

// MARK: - Example 1: Simple Content Navigation

struct SimpleNavigationExample: View {
    var body: some View {
        platformPresentNavigationStack_L1(
            content: VStack(spacing: 20) {
                Text("Welcome")
                    .font(.largeTitle)
                
                Text("This is a simple navigation stack example")
                    .foregroundColor(.secondary)
                
                Button("Action") {
                    // Handle action
                }
            }
            .padding(),
            title: "Home",
            hints: PresentationHints(
                dataType: .navigation,
                presentationPreference: .navigation,
                complexity: .simple,
                context: .navigation
            )
        )
    }
}

// MARK: - Example 2: List-Detail Navigation

struct ListDetailNavigationExample: View {
    let items: [ExampleItem] = [
        ExampleItem(id: UUID(), title: "Item 1", description: "First item", category: "Category A"),
        ExampleItem(id: UUID(), title: "Item 2", description: "Second item", category: "Category A"),
        ExampleItem(id: UUID(), title: "Item 3", description: "Third item", category: "Category B"),
        ExampleItem(id: UUID(), title: "Item 4", description: "Fourth item", category: "Category B"),
        ExampleItem(id: UUID(), title: "Item 5", description: "Fifth item", category: "Category C")
    ]
    
    var body: some View {
        platformPresentNavigationStack_L1(
            items: items,
            hints: PresentationHints(
                dataType: .navigation,
                presentationPreference: .navigation,
                complexity: .moderate,
                context: .browse
            )
        ) { item in
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.headline)
                Text(item.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(item.category)
                    .font(.caption)
                    .foregroundColor(.blue)
            }
            .padding(.vertical, 4)
        } destination: { item in
            ItemDetailView(item: item)
        }
    }
}

// MARK: - Example 3: Split View Navigation

struct SplitViewNavigationExample: View {
    let items: [ExampleItem] = (1...20).map { i in
        ExampleItem(
            id: UUID(),
            title: "Item \(i)",
            description: "Description for item \(i)",
            category: "Category \(i % 3)"
        )
    }
    
    var body: some View {
        platformPresentNavigationStack_L1(
            items: items,
            hints: PresentationHints(
                dataType: .navigation,
                presentationPreference: .detail, // Forces split view on large screens
                complexity: .complex,
                context: .browse
            )
        ) { item in
            VStack(alignment: .leading) {
                Text(item.title)
                    .font(.headline)
                Text(item.category)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        } destination: { item in
            ItemDetailView(item: item)
        }
    }
}

// MARK: - Example 4: Modal Navigation

struct ModalNavigationExample: View {
    let items: [ExampleItem] = [
        ExampleItem(id: UUID(), title: "Quick Action 1", description: "Action description", category: "Actions"),
        ExampleItem(id: UUID(), title: "Quick Action 2", description: "Action description", category: "Actions")
    ]
    
    var body: some View {
        platformPresentNavigationStack_L1(
            items: items,
            hints: PresentationHints(
                dataType: .navigation,
                presentationPreference: .modal, // Forces modal presentation
                complexity: .simple,
                context: .navigation
            )
        ) { item in
            HStack {
                Text(item.title)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
        } destination: { item in
            ItemDetailView(item: item)
        }
    }
}

// MARK: - Supporting Views

struct ItemDetailView: View {
    let item: ExampleItem
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(item.title)
                    .font(.largeTitle)
                
                Text(item.category)
                    .font(.headline)
                    .foregroundColor(.blue)
                
                Text(item.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                
                Divider()
                
                Text("Detail Information")
                    .font(.headline)
                
                Text("This is the detail view for \(item.title). The framework automatically handles navigation between the list and detail views.")
                    .font(.body)
            }
            .padding()
        }
        .navigationTitle(item.title)
    }
}

// MARK: - Example App

struct NavigationStackExampleApp: View {
    var body: some View {
        TabView {
            SimpleNavigationExample()
                .tabItem {
                    Label("Simple", systemImage: "1.circle")
                }
            
            ListDetailNavigationExample()
                .tabItem {
                    Label("List-Detail", systemImage: "list.bullet")
                }
            
            SplitViewNavigationExample()
                .tabItem {
                    Label("Split View", systemImage: "sidebar.left")
                }
            
            ModalNavigationExample()
                .tabItem {
                    Label("Modal", systemImage: "square.stack")
                }
        }
    }
}

