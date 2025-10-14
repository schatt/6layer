//
//  PlatformDragDropExtensions.swift
//  CarManager
//
//  Created by Platform Extensions System
//  Copyright © 2025 CarManager. All rights reserved.
//

import SwiftUI
import UniformTypeIdentifiers

// MARK: - Platform Drag & Drop Extensions

/// Platform-specific drag & drop extensions
/// Provides consistent drag & drop behavior across iOS and macOS
public extension View {
    
    /// Platform-specific drop handling with Transferable types
    /// Automatically adapts to platform-specific drag & drop APIs
    ///
    /// - Parameters:
    ///   - supportedTypes: Array of supported content types
    ///   - isTargeted: Binding to track if the view is a drop target
    ///   - action: Closure called when items are dropped
    /// - Returns: A view with platform-specific drop handling
    ///
    /// ## Usage Example
    /// ```swift
    /// Text("Drop files here")
    ///     .platformOnDrop(
    ///         supportedTypes: [.fileURL, .image],
    ///         isTargeted: $isDropTarget
    ///     ) { providers in
    ///         // Handle dropped providers
    ///         return true
    ///     }
    /// ```
    func platformOnDrop(
        supportedTypes: [UTType],
        isTargeted: Binding<Bool>? = nil,
        action: @escaping ([NSItemProvider]) -> Bool
    ) -> some View {
        #if os(iOS)
        return self.onDrop(
            of: supportedTypes,
            isTargeted: isTargeted
        ) { providers in
            return action(providers)
        }
        #elseif os(macOS)
        return self.onDrop(
            of: supportedTypes,
            isTargeted: isTargeted
        ) { providers in
            return action(providers)
        }
        #else
        return self
        #endif
    }
    
    /// Platform-specific drop handling for file URLs
    /// Simplified API for common file drop scenarios
    ///
    /// - Parameters:
    ///   - isTargeted: Binding to track if the view is a drop target
    ///   - action: Closure called when files are dropped
    /// - Returns: A view with platform-specific file drop handling
    ///
    /// ## Usage Example
    /// ```swift
    /// Text("Drop files here")
    ///     .platformOnDropFiles(isTargeted: $isDropTarget) { providers in
    ///         // Handle dropped file providers
    ///         return true
    ///     }
    /// ```
    func platformOnDropFiles(
        isTargeted: Binding<Bool>? = nil,
        action: @escaping ([NSItemProvider]) -> Bool
    ) -> some View {
        return self.platformOnDrop(
            supportedTypes: [.fileURL],
            isTargeted: isTargeted,
            action: action
        )
    }
    
    /// Platform-specific drop handling for images
    /// Simplified API for image drop scenarios
    ///
    /// - Parameters:
    ///   - isTargeted: Binding to track if the view is a drop target
    ///   - action: Closure called when images are dropped
    /// - Returns: A view with platform-specific image drop handling
    ///
    /// ## Usage Example
    /// ```swift
    /// Text("Drop images here")
    ///     .platformOnDropImages(isTargeted: $isDropTarget) { providers in
    ///         // Handle dropped image providers
    ///         return true
    ///     }
    /// ```
    func platformOnDropImages(
        isTargeted: Binding<Bool>? = nil,
        action: @escaping ([NSItemProvider]) -> Bool
    ) -> some View {
        return self.platformOnDrop(
            supportedTypes: [.image],
            isTargeted: isTargeted,
            action: action
        )
    }
    
    /// Platform-specific drop handling for text
    /// Simplified API for text drop scenarios
    ///
    /// - Parameters:
    ///   - isTargeted: Binding to track if the view is a drop target
    ///   - action: Closure called when text is dropped
    /// - Returns: A view with platform-specific text drop handling
    ///
    /// ## Usage Example
    /// ```swift
    /// Text("Drop text here")
    ///     .platformOnDropText(isTargeted: $isDropTarget) { providers in
    ///         // Handle dropped text providers
    ///         return true
    ///     }
    /// ```
    func platformOnDropText(
        isTargeted: Binding<Bool>? = nil,
        action: @escaping ([NSItemProvider]) -> Bool
    ) -> some View {
        return self.platformOnDrop(
            supportedTypes: [.text, .plainText],
            isTargeted: isTargeted,
            action: action
        )
    }
}
