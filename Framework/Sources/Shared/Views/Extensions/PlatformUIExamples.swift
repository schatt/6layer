import Foundation
import SwiftUI

// MARK: - Platform UI Examples
// Comprehensive examples showing how to use the platform-specific UI patterns

/// Simple list item for examples
public struct ListItem: Identifiable, Hashable {
    public let id: String
    public let title: String
}

/// Example implementations demonstrating the platform-specific UI patterns
public struct PlatformUIExamples {
    
    // MARK: - Navigation Examples
    
    /// Example of adaptive navigation that works across all platforms
    public struct AdaptiveNavigationExample: View {
        @State private var selectedItem: ListItem? = nil
        @State private var items = [
            ListItem(id: "1", title: "Item 1"),
            ListItem(id: "2", title: "Item 2"),
            ListItem(id: "3", title: "Item 3"),
            ListItem(id: "4", title: "Item 4"),
            ListItem(id: "5", title: "Item 5")
        ]
        
        public init() {}
        
        public var body: some View {
            PlatformUIIntegration.SmartNavigationContainer(
                title: "Adaptive Navigation",
                style: .adaptive,
                context: .standard
            ) {
                AdaptiveUIPatterns.AdaptiveList(
                    items,
                    style: .adaptive,
                    context: .standard
                ) { item in
                    NavigationLink(destination: DetailView(item: item.title)) {
                        HStack {
                            Image(systemName: "doc.text")
                                .foregroundColor(.blue)
                            Text(item.title)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                                .font(.caption)
                        }
                        .padding()
                    }
                }
            }
        }
    }
    
    /// Example of split view navigation for larger screens
    public struct SplitViewNavigationExample: View {
        @State private var selectedItem: ListItem? = nil
        @State private var items = [
            ListItem(id: "1", title: "Item 1"),
            ListItem(id: "2", title: "Item 2"),
            ListItem(id: "3", title: "Item 3"),
            ListItem(id: "4", title: "Item 4"),
            ListItem(id: "5", title: "Item 5")
        ]
        
        public init() {}
        
        public var body: some View {
            PlatformUIIntegration.SmartNavigationContainer(
                title: "Split View Navigation",
                style: .splitView,
                context: .standard
            ) {
                HStack(spacing: 0) {
                    // Sidebar
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Items")
                            .font(.headline)
                            .padding()
                        
                        List(items, id: \.id, selection: $selectedItem) { item in
                            Text(item.title)
                                .tag(item)
                        }
                        .listStyle(SidebarListStyle())
                    }
                    .frame(width: 250)
                    
                    Divider()
                    
                    // Detail view
                    if let selectedItem = selectedItem {
                        DetailView(item: selectedItem.title)
                    } else {
                        VStack {
                            Image(systemName: "doc.text")
                                .font(.system(size: 48))
                                .foregroundColor(.secondary)
                            Text("Select an item")
                                .font(.headline)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
            }
        }
    }
    
    // MARK: - Modal Examples
    
    /// Example of adaptive modal presentation
    public struct AdaptiveModalExample: View {
        @State private var isPresented = false
        
        public init() {}
        
        public var body: some View {
            VStack(spacing: 20) {
                Text("Modal Examples")
                    .font(.title)
                
                AdaptiveUIPatterns.AdaptiveButton(
                    "Show Adaptive Modal",
                    style: ButtonStyle.primary,
                    action: { isPresented = true }
                )
                
                AdaptiveUIPatterns.AdaptiveButton(
                    "Show Sheet Modal",
                    style: ButtonStyle.secondary,
                    action: { isPresented = true }
                )
            }
            .padding()
            .sheet(isPresented: $isPresented) {
                PlatformUIIntegration.SmartModalContainer(
                    title: "Adaptive Modal",
                    isPresented: $isPresented,
                    style: .adaptive
                ) {
                    VStack(spacing: 20) {
                        Text("This is an adaptive modal that adjusts to the platform.")
                            .multilineTextAlignment(.center)
                        
                        Text("On iOS, it shows as a sheet with detents.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("On macOS, it shows in a window with specific dimensions.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                    }
                    .padding()
                }
            }
        }
    }
    
    // MARK: - List Examples
    
    /// Example of adaptive list with different styles
    public struct AdaptiveListExample: View {
        @State private var selectedStyle: ListStyle = .adaptive
        @State private var items = Array(1...20).map { ListItem(id: "\($0)", title: "Item \($0)") }
        
        public init() {}
        
        public var body: some View {
            PlatformUIIntegration.SmartNavigationContainer(
                title: "Adaptive Lists",
                style: .adaptive
            ) {
                VStack(spacing: 0) {
                    // Style picker
                    Picker("List Style", selection: $selectedStyle) {
                        Text("Adaptive").tag(ListStyle.adaptive)
                        Text("Plain").tag(ListStyle.plain)
                        Text("Grouped").tag(ListStyle.grouped)
                        Text("Inset Grouped").tag(ListStyle.insetGrouped)
                        Text("Sidebar").tag(ListStyle.sidebar)
                        Text("Carousel").tag(ListStyle.carousel)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    
                    Divider()
                    
                    // List
                    AdaptiveUIPatterns.AdaptiveList(
                        items,
                        style: selectedStyle,
                        context: .standard
                    ) { item in
                        HStack {
                            Image(systemName: "doc.text")
                                .foregroundColor(.blue)
                            Text(item.title)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                                .font(.caption)
                        }
                        .padding()
                    }
                }
            }
        }
    }
    
    // MARK: - Button Examples
    
    /// Example of adaptive buttons with different styles and sizes
    public struct AdaptiveButtonExample: View {
        public init() {}
        
        public var body: some View {
            PlatformUIIntegration.SmartNavigationContainer(
                title: "Adaptive Buttons",
                style: .adaptive
            ) {
                ScrollView {
                    VStack(spacing: 20) {
                        // Button styles
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Button Styles")
                                .font(.headline)
                            
                            HStack(spacing: 12) {
                                AdaptiveUIPatterns.AdaptiveButton(
                                    "Primary",
                                    style: ButtonStyle.primary,
                                    action: {}
                                )
                                
                                AdaptiveUIPatterns.AdaptiveButton(
                                    "Secondary",
                                    style: ButtonStyle.secondary,
                                    action: {}
                                )
                                
                                AdaptiveUIPatterns.AdaptiveButton(
                                    "Outline",
                                    style: ButtonStyle.outline,
                                    action: {}
                                )
                            }
                            
                            HStack(spacing: 12) {
                                AdaptiveUIPatterns.AdaptiveButton(
                                    "Ghost",
                                    style: ButtonStyle.ghost,
                                    action: {}
                                )
                                
                                AdaptiveUIPatterns.AdaptiveButton(
                                    "Destructive",
                                    style: ButtonStyle.destructive,
                                    action: {}
                                )
                                
                                AdaptiveUIPatterns.AdaptiveButton(
                                    "Adaptive",
                                    style: ButtonStyle.adaptive,
                                    action: {}
                                )
                            }
                        }
                        
                        // Button sizes
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Button Sizes")
                                .font(.headline)
                            
                            HStack(spacing: 12) {
                                AdaptiveUIPatterns.AdaptiveButton(
                                    "Small",
                                    size: ButtonSize.small,
                                    action: {}
                                )
                                
                                AdaptiveUIPatterns.AdaptiveButton(
                                    "Medium",
                                    size: ButtonSize.medium,
                                    action: {}
                                )
                                
                                AdaptiveUIPatterns.AdaptiveButton(
                                    "Large",
                                    size: ButtonSize.large,
                                    action: {}
                                )
                            }
                        }
                        
                        // Buttons with icons
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Buttons with Icons")
                                .font(.headline)
                            
                            HStack(spacing: 12) {
                                AdaptiveUIPatterns.AdaptiveButton(
                                    "Add",
                                    icon: "plus",
                                    style: ButtonStyle.primary,
                                    action: {}
                                )
                                
                                AdaptiveUIPatterns.AdaptiveButton(
                                    "Edit",
                                    icon: "pencil",
                                    style: ButtonStyle.secondary,
                                    action: {}
                                )
                                
                                AdaptiveUIPatterns.AdaptiveButton(
                                    "Delete",
                                    icon: "trash",
                                    style: ButtonStyle.destructive,
                                    action: {}
                                )
                            }
                        }
                    }
                    .padding()
                }
            }
        }
    }
    
    // MARK: - Form Examples
    
    /// Example of adaptive form with smart container
    public struct AdaptiveFormExample: View {
        @State private var name = ""
        @State private var email = ""
        @State private var age = ""
        @State private var isPresented = false
        
        public init() {}
        
        public var body: some View {
            PlatformUIIntegration.SmartNavigationContainer(
                title: "Form Examples",
                style: .adaptive
            ) {
                VStack(spacing: 20) {
                    Text("Form Examples")
                        .font(.title)
                    
                    AdaptiveUIPatterns.AdaptiveButton(
                        "Show Form Modal",
                        icon: "doc.text",
                        style: ButtonStyle.primary,
                        action: { isPresented = true }
                    )
                }
                .padding()
            }
            .sheet(isPresented: $isPresented) {
                PlatformUIIntegration.SmartFormContainer(
                    title: "User Information",
                    onSubmit: { isPresented = false },
                    onCancel: { isPresented = false }
                ) {
                    VStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Name")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            TextField("Enter your name", text: $name)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Email")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            TextField("Enter your email", text: $email)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Age")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            TextField("Enter your age", text: $age)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Card Examples
    
    /// Example of adaptive cards with smart container
    public struct AdaptiveCardExample: View {
        public init() {}
        
        public var body: some View {
            PlatformUIIntegration.SmartNavigationContainer(
                title: "Card Examples",
                style: .adaptive
            ) {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        PlatformUIIntegration.SmartCardContainer(
                            title: "Simple Card",
                            subtitle: "This is a simple card with just content"
                        ) {
                            Text("This card contains simple content without any actions.")
                                .font(.body)
                        }
                        
                        PlatformUIIntegration.SmartCardContainer(
                            title: "Card with Action",
                            subtitle: "This card has an action button",
                            actionTitle: "View Details",
                            action: {}
                        ) {
                            Text("This card has an action button that can be tapped.")
                                .font(.body)
                        }
                        
                        PlatformUIIntegration.SmartCardContainer(
                            title: "Complex Card",
                            subtitle: "This card has multiple elements"
                        ) {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("This is a more complex card with multiple elements.")
                                    .font(.body)
                                
                                HStack {
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.yellow)
                                    Text("4.5")
                                        .font(.caption)
                                    Spacer()
                                    Text("Updated 2 hours ago")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

// MARK: - Supporting Views

private struct DetailView: View {
    let item: String
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "doc.text")
                .font(.system(size: 64))
                .foregroundColor(.blue)
            
            Text("Detail for \(item)")
                .font(.title)
                .fontWeight(.bold)
            
            Text("This is the detail view for \(item). It shows additional information about the selected item.")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            
            Spacer()
        }
        .padding()
        .navigationTitle(item)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

// MARK: - Main Example App

/// Main example app that demonstrates all platform-specific UI patterns
public struct PlatformUIExampleApp: View {
    @State private var selectedTab = 0
    
    public init() {}
    
    public var body: some View {
        TabView(selection: $selectedTab) {
            PlatformUIExamples.AdaptiveNavigationExample()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Navigation")
                }
                .tag(0)
            
            PlatformUIExamples.AdaptiveModalExample()
                .tabItem {
                    Image(systemName: "rectangle.stack")
                    Text("Modals")
                }
                .tag(1)
            
            PlatformUIExamples.AdaptiveListExample()
                .tabItem {
                    Image(systemName: "list.dash")
                    Text("Lists")
                }
                .tag(2)
            
            PlatformUIExamples.AdaptiveButtonExample()
                .tabItem {
                    Image(systemName: "button.programmable")
                    Text("Buttons")
                }
                .tag(3)
            
            PlatformUIExamples.AdaptiveFormExample()
                .tabItem {
                    Image(systemName: "doc.text")
                    Text("Forms")
                }
                .tag(4)
            
            PlatformUIExamples.AdaptiveCardExample()
                .tabItem {
                    Image(systemName: "rectangle")
                    Text("Cards")
                }
                .tag(5)
        }
        .withThemedFramework()
    }
}
