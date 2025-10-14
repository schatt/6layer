//
//  PlatformAdvancedContainerExtensions.swift
//  CarManager
//
//  Created by Platform Extensions System
//  Copyright © 2025 CarManager. All rights reserved.
//

import SwiftUI

// MARK: - Platform Advanced Container Extensions

/// Platform-specific advanced container extensions
/// Provides consistent container behavior across iOS and macOS
public extension View {
    
    /// Platform-specific LazyVGrid container with adaptive styling
    /// Automatically adapts grid layout and styling for each platform
    ///
    /// - Parameters:
    ///   - columns: Array of grid items defining the column layout
    ///   - alignment: Horizontal alignment for grid items
    ///   - spacing: Spacing between grid items
    ///   - pinnedViews: Views to pin during scrolling
    ///   - content: Grid content builder
    /// - Returns: A view with platform-specific LazyVGrid styling
    ///
    /// ## Usage Example
    /// ```swift
    /// LazyVGrid(columns: columns) {
    ///     ForEach(items) { item in
    ///         ItemView(item: item)
    ///     }
    /// }
    /// .platformLazyVGridContainer()
    /// ```
    func platformLazyVGridContainer() -> some View {
        #if os(iOS)
        return self
            .background(Color.platformGroupedBackground)
            .cornerRadius(12)
            .padding(.horizontal, 16)
        #elseif os(macOS)
        return self
            .background(Color.platformSecondaryBackground)
            .cornerRadius(8)
            .padding(.horizontal, 20)
        #else
        return self
        #endif
    }
    
    /// Platform-specific tab container with adaptive styling
    /// Provides consistent tab appearance and behavior across platforms
    ///
    /// - Returns: A view with platform-specific tab styling
    ///
    /// ## Usage Example
    /// ```swift
    /// TabView {
    ///     FirstTab()
    ///     SecondTab()
    /// }
    /// .platformTabContainer()
    /// ```
    func platformTabContainer() -> some View {
        #if os(iOS)
        return self
            .tabViewStyle(.page(indexDisplayMode: .never))
            .background(Color.platformBackground)
        #elseif os(macOS)
        return self
            .tabViewStyle(.automatic)
            .background(Color.platformBackground)
        #else
        return self
        #endif
    }
    
    /// Platform-specific scroll container with adaptive styling
    /// Provides consistent scroll behavior and styling across platforms
    ///
    /// - Parameter showsIndicators: Whether to show scroll indicators
    /// - Returns: A view with platform-specific scroll styling
    ///
    /// ## Usage Example
    /// ```swift
    /// ScrollView {
    ///     VStack {
    ///         ForEach(items) { item in
    ///             ItemView(item: item)
    ///         }
    ///     }
    /// }
    /// .platformScrollContainer()
    /// ```
    func platformScrollContainer(showsIndicators: Bool = true) -> some View {
        #if os(iOS)
        if #available(iOS 17.0, *) {
            return self
                .scrollIndicators(showsIndicators ? .visible : .hidden)
                .background(Color.platformGroupedBackground)
        } else {
            // Fallback on earlier versions
            return self
                .background(Color.platformGroupedBackground)
        }
        #elseif os(macOS)
        return self
            .scrollIndicators(showsIndicators ? .visible : .hidden)
            .background(Color.platformSecondaryBackground)
        #else
        return self
        #endif
    }
    
    /// Platform-specific list container with adaptive styling
    /// Provides consistent list appearance and behavior across platforms
    ///
    /// - Returns: A view with platform-specific list styling
    ///
    /// ## Usage Example
    /// ```swift
    /// List {
    ///     ForEach(items) { item in
    ///         ItemRow(item: item)
    ///     }
    /// }
    /// .platformListContainer()
    /// ```
    func platformListContainer() -> some View {
        #if os(iOS)
        return self
            .listStyle(.insetGrouped)
            .background(Color.platformGroupedBackground)
        #elseif os(macOS)
        return self
            .listStyle(.inset)
            .background(Color.platformSecondaryBackground)
        #else
        return self
        #endif
    }
    
    /// Platform-specific form container with adaptive styling
    /// Provides consistent form appearance and behavior across platforms
    ///
    /// - Returns: A view with platform-specific form styling
    ///
    /// ## Usage Example
    /// ```swift
    /// Form {
    ///     Section("Personal Information") {
    ///         TextField("Name", text: $name)
    ///         TextField("Email", text: $email)
    ///     }
    /// }
    /// .platformFormContainer()
    /// ```
    func platformFormContainer() -> some View {
        #if os(iOS)
        if #available(iOS 17.0, *) {
            return self
                .background(Color.platformGroupedBackground)
                .scrollContentBackground(.hidden)
        } else {
            // Fallback for older iOS versions
            return self
                .background(Color.platformGroupedBackground)
        }
        #elseif os(macOS)
        return self
            .background(Color.platformSecondaryBackground)
            .padding(.horizontal, 20)
        #else
        return self
        #endif
    }
}
