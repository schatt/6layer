import CoreData
import Foundation
import SwiftUI

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

// Import shared types and platform extensions
@_exported import struct SwiftUI.Color

// Device type detection - using shared type from PlatformTypes.swift
@_exported import struct SwiftUI.Color

// Screen size classes
public enum ScreenSizeClass {
    case compact, regular, large

    static func horizontal(width: CGFloat) -> ScreenSizeClass {
        switch width {
        case 0..<600:
            return .compact
        case 600..<1000:
            return .regular
        default:
            return .large
        }
    }

    static func vertical(height: CGFloat) -> ScreenSizeClass {
        switch height {
        case 0..<500:
            return .compact
        case 500..<800:
            return .regular
        default:
            return .large
        }
    }
}

// MARK: - Responsive Container

// MARK: - Responsive Grid
public struct ResponsiveGrid<Content: View>: View {
    let columns: [GridItem]
    let spacing: CGFloat
    let content: () -> Content

    init(columns: [GridItem], spacing: CGFloat = 16, @ViewBuilder content: @escaping () -> Content) {
        self.columns = columns
        self.spacing = spacing
        self.content = content
    }

    public var body: some View {
        LazyVGrid(columns: columns, spacing: spacing) {
            content()
        }
    }
}

// MARK: - Grid Item Data
public struct GridItemData: Identifiable {
    public var id = UUID()
    var title: String
    var subtitle: String
    var icon: String
    var color: Color

    init(title: String, subtitle: String, icon: String, color: Color) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.color = color
    }
}

// MARK: - Responsive Navigation
public struct ResponsiveNavigation<Content: View>: View {
    var content: (Bool) -> Content

    init(@ViewBuilder content: @escaping (Bool) -> Content) {
        self.content = content
    }

    public var body: some View {
        ResponsiveContainer { horizontal, _ in
            content(horizontal)
        }
    }
}

// MARK: - Responsive Stack
public struct ResponsiveStack<Content: View>: View {
    var spacing: CGFloat
    var content: () -> Content

    init(spacing: CGFloat = 16, @ViewBuilder content: @escaping () -> Content) {
        self.spacing = spacing
        self.content = content
    }

    public var body: some View {
        ResponsiveContainer { horizontal, _ in
            if horizontal {
                AnyView(HStack(spacing: spacing) {
                    content()
                })
            } else {
                AnyView(VStack(spacing: spacing) {
                    content()
                })
            }
        }
    }
}

// MARK: - Responsive Padding
public struct ResponsivePadding: ViewModifier {
        public func body(content: Content) -> some View {
        content.padding(paddingValue)
    }

    private var paddingValue: CGFloat {
        switch DeviceType.current {
        case .phone:
            return 16
        case .pad:
            return 20
        case .mac:
            return 24
        case .tv:
            return 24
        case .watch:
            return 12
        }
    }
}

public extension View {
    func responsivePadding() -> some View {
        modifier(ResponsivePadding())
    }
}

// MARK: - Responsive Layout
public struct ResponsiveLayout {
    static func gridColumns(for width: CGFloat, minWidth: CGFloat = 300) -> [GridItem] {
        let count = max(1, Int(width / minWidth))
        return Array(repeating: GridItem(.flexible()), count: count)
    }

    @MainActor
    static func adaptiveGrid<Content: View>(
        minWidth: CGFloat = 300,
        spacing: CGFloat = 16,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        ResponsiveContainer { horizontal, _ in
            let columns = gridColumns(for: horizontal ? 800 : 400, minWidth: minWidth)
            return ResponsiveGrid(columns: columns, spacing: spacing) {
                content()
            }
        }
    }

    @MainActor
    static func horizontalGrid<Content: View>(
        minWidth: CGFloat = 300,
        spacing: CGFloat = 16,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        ResponsiveContainer { horizontal, _ in
            let columns = gridColumns(for: horizontal ? 1200 : 600, minWidth: minWidth)
            return ResponsiveGrid(columns: columns, spacing: spacing) {
                content()
            }
        }
    }

    @MainActor
    static func verticalGrid<Content: View>(
        minWidth: CGFloat = 300,
        spacing: CGFloat = 16,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        ResponsiveContainer { _, _ in
            let columns = gridColumns(for: 400, minWidth: minWidth)
            return ResponsiveGrid(columns: columns, spacing: spacing) {
                content()
            }
        }
    }
}

// MARK: - Example Usage
public struct ResponsiveLayoutExample: View {
    let gridItems = [
        GridItemData(title: "Item 1", subtitle: "Description 1", icon: "star.fill", color: .blue),
        GridItemData(title: "Item 2", subtitle: "Description 2", icon: "heart.fill", color: .red),
        GridItemData(title: "Item 3", subtitle: "Description 3", icon: "circle.fill", color: .green)
    ]

    public var body: some View {
        ResponsiveLayout.adaptiveGrid {
            ForEach(gridItems) { item in
                VStack {
                    Image(systemName: item.icon)
                        .foregroundColor(item.color)
                    Text(item.title)
                        .font(.headline)
                    Text(item.subtitle)
                        .font(.caption)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 100)

                .cornerRadius(8)
            }
        }
    }
}

// MARK: - Example Navigation
public struct ResponsiveNavigationExample: View {
    public var body: some View {
        ResponsiveNavigation { isHorizontal in
            if isHorizontal {
                NavigationView {
                    List {
                        Text("Sidebar Item 1")
                        Text("Sidebar Item 2")
                    }
                    .listStyle(SidebarListStyle())
                }
                .frame(minWidth: 160, maxWidth: 240)
            } else {
                TabView {
                    Text("Tab 1")
                        .tabItem { Label("First", systemImage: "1.circle") }
                    Text("Tab 2")
                        .tabItem { Label("Second", systemImage: "2.circle") }
                }
            }
        }
    }
}
