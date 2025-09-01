//
//  PlatformBasicContainerExtensions.swift
//  CarManager
//
//  Created by Platform Extensions System
//  Copyright © 2025 CarManager. All rights reserved.
//

import SwiftUI

// MARK: - Platform Basic Container Extensions

/// Platform-specific basic container extensions
/// Provides consistent container behavior across iOS and macOS
public extension View {
    
    /// Platform-specific VStack container with consistent styling
    /// iOS: Uses VStack with iOS-appropriate styling; macOS: Uses VStack with macOS-appropriate styling
    ///
    /// - Parameters:
    ///   - alignment: The alignment of items in the stack
    ///   - spacing: The spacing between stack items
    ///   - content: The stack content
    /// - Returns: A view with platform-appropriate VStack styling
    ///
    /// ## Usage Example
    /// ```swift
    /// EmptyView().platformVStackContainer(alignment: .leading, spacing: 12) {
    ///     ForEach(items) { item in
    ///         ItemView(item: item)
    ///     }
    /// }
    /// ```
    @ViewBuilder
public func platformVStackContainer<Content: View>(
        alignment: HorizontalAlignment = .center,
        spacing: CGFloat? = nil,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: alignment, spacing: spacing) {
            content()
        }
    }
    
    /// Platform-specific HStack container with consistent styling
    /// iOS: Uses HStack with iOS-appropriate styling; macOS: Uses HStack with macOS-appropriate styling
    ///
    /// - Parameters:
    ///   - alignment: The alignment of items in the stack
    ///   - spacing: The spacing between stack items
    ///   - content: The stack content
    /// - Returns: A view with platform-appropriate HStack styling
    ///
    /// ## Usage Example
    /// ```swift
    /// EmptyView().platformHStackContainer(alignment: .top, spacing: 8) {
    ///     ForEach(items) { item in
    ///         ItemView(item: item)
    ///     }
    /// }
    /// ```
    @ViewBuilder
public func platformHStackContainer<Content: View>(
        alignment: VerticalAlignment = .center,
        spacing: CGFloat? = nil,
        @ViewBuilder content: () -> Content
    ) -> some View {
        HStack(alignment: alignment, spacing: spacing) {
            content()
        }
    }
    
    /// Platform-specific ZStack container with consistent styling
    /// iOS: Uses ZStack with iOS-appropriate styling; macOS: Uses ZStack with macOS-appropriate styling
    ///
    /// - Parameters:
    ///   - alignment: The alignment of items in the stack
    ///   - content: The stack content
    /// - Returns: A view with platform-appropriate ZStack styling
    ///
    /// ## Usage Example
    /// ```swift
    /// EmptyView().platformZStackContainer(alignment: .center) {
    ///     BackgroundView()
    ///     ForegroundView()
    /// }
    /// ```
    @ViewBuilder
public func platformZStackContainer<Content: View>(
        alignment: Alignment = .center,
        @ViewBuilder content: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            content()
        }
    }
    
    /// Platform-specific LazyVStack container with consistent styling
    /// iOS: Uses LazyVStack with iOS-appropriate styling; macOS: Uses LazyVStack with macOS-appropriate styling
    ///
    /// - Parameters:
    ///   - alignment: The alignment of items in the stack
    ///   - spacing: The spacing between stack items
    ///   - pinnedViews: The pinned views for the stack
    ///   - content: The stack content
    /// - Returns: A view with platform-appropriate LazyVStack styling
    ///
    /// ## Usage Example
    /// ```swift
    /// EmptyView().platformLazyVStackContainer(alignment: .leading, spacing: 12) {
    ///     ForEach(items) { item in
    ///         ItemView(item: item)
    ///     }
    /// }
    /// ```
    @ViewBuilder
public func platformLazyVStackContainer<Content: View>(
        alignment: HorizontalAlignment = .center,
        spacing: CGFloat? = nil,
        pinnedViews: PinnedScrollableViews = .init(),
        @ViewBuilder content: () -> Content
    ) -> some View {
        LazyVStack(alignment: alignment, spacing: spacing, pinnedViews: pinnedViews) {
            content()
        }
    }
    
    /// Platform-specific LazyHStack container with consistent styling
    /// iOS: Uses LazyHStack with iOS-appropriate styling; macOS: Uses LazyHStack with macOS-appropriate styling
    ///
    /// - Parameters:
    ///   - alignment: The alignment of items in the stack
    ///   - spacing: The spacing between stack items
    ///   - pinnedViews: The pinned views for the stack
    ///   - content: The stack content
    /// - Returns: A view with platform-appropriate LazyHStack styling
    ///
    /// ## Usage Example
    /// ```swift
    /// EmptyView().platformLazyHStackContainer(alignment: .top, spacing: 8) {
    ///     ForEach(items) { item in
    ///         ItemView(item: item)
    ///     }
    /// }
    /// ```
    @ViewBuilder
public func platformLazyHStackContainer<Content: View>(
        alignment: VerticalAlignment = .center,
        spacing: CGFloat? = nil,
        pinnedViews: PinnedScrollableViews = .init(),
        @ViewBuilder content: () -> Content
    ) -> some View {
        LazyHStack(alignment: alignment, spacing: spacing, pinnedViews: pinnedViews) {
            content()
        }
    }
    
    /// Platform-specific ScrollView container with consistent styling
    /// iOS: Uses ScrollView with iOS-appropriate styling; macOS: Uses ScrollView with macOS-appropriate styling
    ///
    /// - Parameters:
    ///   - axes: The scroll axes
    ///   - showsIndicators: Whether to show scroll indicators
    ///   - content: The scrollable content
    /// - Returns: A view with platform-appropriate ScrollView styling
    ///
    /// ## Usage Example
    /// ```swift
    /// EmptyView().platformScrollViewContainer(.vertical, showsIndicators: false) {
    ///     VStack(spacing: 16) {
    ///         ForEach(items) { item in
    ///             ItemView(item: item)
    ///         }
    ///         .padding()
    ///     }
    /// }
    /// ```
    @ViewBuilder
public func platformScrollViewContainer<Content: View>(
        _ axes: Axis.Set = .vertical,
        showsIndicators: Bool = true,
        @ViewBuilder content: () -> Content
    ) -> some View {
        ScrollView(axes, showsIndicators: showsIndicators) {
            content()
        }
    }
    
    /// Platform-specific GroupBox container with consistent styling
    /// iOS: Uses GroupBox with iOS-appropriate styling; macOS: Uses GroupBox with macOS-appropriate styling
    ///
    /// - Parameters:
    ///   - title: The title for the group box
    ///   - content: The group box content
    /// - Returns: A view with platform-appropriate GroupBox styling
    ///
    /// ## Usage Example
    /// ```swift
    /// EmptyView().platformGroupBoxContainer(title: "Settings") {
    ///     VStack(alignment: .leading) {
    ///         Toggle("Enable notifications", isOn: $notificationsEnabled)
    ///         Toggle("Auto-save", isOn: $autoSaveEnabled)
    ///     }
    /// }
    /// ```
    @ViewBuilder
public func platformGroupBoxContainer<Content: View>(
        title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        GroupBox(title) {
            content()
        }
    }
    
    /// Platform-specific Section container with consistent styling
    /// iOS: Uses Section with iOS-appropriate styling; macOS: Uses Section with macOS-appropriate styling
    ///
    /// - Parameters:
    ///   - header: The section header
    ///   - footer: The section footer
    ///   - content: The section content
    /// - Returns: A view with platform-appropriate Section styling
    ///
    /// ## Usage Example
    /// ```swift
    /// EmptyView().platformSectionContainer(
    ///     header: "Personal Information",
    ///     footer: "This information is kept private"
    /// ) {
    ///     TextField("Name", text: $name)
    ///     TextField("Email", text: $email)
    /// }
    /// ```
    @ViewBuilder
public func platformSectionContainer<Header: View, Footer: View, Content: View>(
        header: Header,
        footer: Footer,
        @ViewBuilder content: () -> Content
    ) -> some View {
        Section(header: header, footer: footer) {
            content()
        }
    }
    
    /// Platform-specific Section container with header only
    /// iOS: Uses Section with iOS-appropriate styling; macOS: Uses Section with macOS-appropriate styling
    ///
    /// - Parameters:
    ///   - header: The section header
    ///   - content: The section content
    /// - Returns: A view with platform-appropriate Section styling
    ///
    /// ## Usage Example
    /// ```swift
    /// EmptyView().platformSectionContainer(header: "Settings") {
    ///     Toggle("Enable notifications", isOn: $notificationsEnabled)
    ///     Toggle("Auto-save", isOn: $autoSaveEnabled)
    /// }
    /// ```
    @ViewBuilder
public func platformSectionContainer<Header: View, Content: View>(
        header: Header,
        @ViewBuilder content: () -> Content
    ) -> some View {
        Section(header: header) {
            content()
        }
    }
    
    /// Platform-specific Section container with string header
    /// iOS: Uses Section with iOS-appropriate styling; macOS: Uses Section with macOS-appropriate styling
    ///
    /// - Parameters:
    ///   - header: The section header text
    ///   - content: The section content
    /// - Returns: A view with platform-appropriate Section styling
    ///
    /// ## Usage Example
    /// ```swift
    /// EmptyView().platformSectionContainer(header: "Settings") {
    ///     Toggle("Enable notifications", isOn: $notificationsEnabled)
    ///     Toggle("Auto-save", isOn: $autoSaveEnabled)
    /// }
    /// ```
    @ViewBuilder
public func platformSectionContainer<Content: View>(
        header: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        Section(header) {
            content()
        }
    }
    
    /// Platform-specific List container with consistent styling
    /// iOS: Uses List with iOS-appropriate styling; macOS: Uses List with macOS-appropriate styling
    ///
    /// - Parameters:
    ///   - content: The list content
    /// - Returns: A view with platform-appropriate List styling
    ///
    /// ## Usage Example
    /// ```swift
    /// EmptyView().platformListContainer {
    ///     ForEach(items) { item in
    ///         ItemRow(item: item)
    ///     }
    /// }
    /// ```
    @MainActor
    @ViewBuilder
public func platformListContainer<Content: View>(
        @ViewBuilder content: () -> Content
    ) -> some View {
        List {
            content()
        }
    }
}

// MARK: - Global Function Wrappers

/// Global function wrapper for platformVStackContainer
/// Provides backward compatibility for code that expects global functions
@MainActor
@ViewBuilder
func platformVStackContainer<Content: View>(
    alignment: HorizontalAlignment = .center,
    spacing: CGFloat? = nil,
    @ViewBuilder content: () -> Content
) -> some View {
    EmptyView().platformVStackContainer(alignment: alignment, spacing: spacing, content: content)
}

/// Global function wrapper for platformHStackContainer
/// Provides backward compatibility for code that expects global functions
@MainActor
@ViewBuilder
func platformHStackContainer<Content: View>(
    alignment: VerticalAlignment = .center,
    spacing: CGFloat? = nil,
    @ViewBuilder content: () -> Content
) -> some View {
    EmptyView().platformHStackContainer(alignment: alignment, spacing: spacing, content: content)
}

/// Global function wrapper for platformZStackContainer
/// Provides backward compatibility for code that expects global functions
@MainActor
@ViewBuilder
func platformZStackContainer<Content: View>(
    alignment: Alignment = .center,
    @ViewBuilder content: () -> Content
) -> some View {
    EmptyView().platformZStackContainer(alignment: alignment, content: content)
}

/// Global function wrapper for platformLazyVStackContainer
/// Provides backward compatibility for code that expects global functions
@MainActor
@ViewBuilder
func platformLazyVStackContainer<Content: View>(
    alignment: HorizontalAlignment = .center,
    spacing: CGFloat? = nil,
    pinnedViews: PinnedScrollableViews = .init(),
    @ViewBuilder content: () -> Content
) -> some View {
    EmptyView().platformLazyVStackContainer(alignment: alignment, spacing: spacing, pinnedViews: pinnedViews, content: content)
}

/// Global function wrapper for platformLazyHStackContainer
/// Provides backward compatibility for code that expects global functions
@MainActor
@ViewBuilder
func platformLazyHStackContainer<Content: View>(
    alignment: VerticalAlignment = .center,
    spacing: CGFloat? = nil,
    pinnedViews: PinnedScrollableViews = .init(),
    @ViewBuilder content: () -> Content
) -> some View {
    EmptyView().platformLazyHStackContainer(alignment: alignment, spacing: spacing, pinnedViews: pinnedViews, content: content)
}

/// Global function wrapper for platformScrollViewContainer
/// Provides backward compatibility for code that expects global functions
@MainActor
@ViewBuilder
func platformScrollViewContainer<Content: View>(
    _ axes: Axis.Set = .vertical,
    showsIndicators: Bool = true,
    @ViewBuilder content: () -> Content
) -> some View {
    EmptyView().platformScrollViewContainer(axes, showsIndicators: showsIndicators, content: content)
}

/// Global function wrapper for platformGroupBoxContainer
/// Provides backward compatibility for code that expects global functions
@MainActor
@ViewBuilder
func platformGroupBoxContainer<Content: View>(
    title: String,
    @ViewBuilder content: () -> Content
) -> some View {
    EmptyView().platformGroupBoxContainer(title: title, content: content)
}

/// Global function wrapper for platformSectionContainer with header and footer
/// Provides backward compatibility for code that expects global functions
@MainActor
@ViewBuilder
func platformSectionContainer<Header: View, Footer: View, Content: View>(
    header: Header,
    footer: Footer,
    @ViewBuilder content: () -> Content
) -> some View {
    EmptyView().platformSectionContainer(header: header, footer: footer, content: content)
}

/// Global function wrapper for platformSectionContainer with header only
/// Provides backward compatibility for code that expects global functions
@MainActor
@ViewBuilder
func platformSectionContainer<Header: View, Content: View>(
    header: Header,
    @ViewBuilder content: () -> Content
) -> some View {
    EmptyView().platformSectionContainer(header: header, content: content)
}

/// Global function wrapper for platformSectionContainer with string header
/// Provides backward compatibility for code that expects global functions
@MainActor
@ViewBuilder
func platformSectionContainer<Content: View>(
    header: String,
    @ViewBuilder content: () -> Content
) -> some View {
    EmptyView().platformSectionContainer(header: header, content: content)
}

/// Global function wrapper for platformListContainer
/// Provides backward compatibility for code that expects global functions
@MainActor
@ViewBuilder
func platformListContainer<Content: View>(
    @ViewBuilder content: () -> Content
) -> some View {
    EmptyView().platformListContainer(content: content)
}
