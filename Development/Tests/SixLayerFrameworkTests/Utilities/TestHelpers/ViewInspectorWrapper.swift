//
//  ViewInspectorWrapper.swift
//  SixLayerFrameworkTests
//
//  BUSINESS PURPOSE:
//  Centralized wrapper for ViewInspector APIs to handle platform differences.
//  When ViewInspector works on macOS again, we only need to update this file,
//  not every test file that uses ViewInspector.
//
//  TESTING SCOPE:
//  - Provides platform-agnostic ViewInspector API wrappers
//  - Handles conditional compilation in one place
//  - Makes it easy to enable ViewInspector on macOS when available
//
//  METHODOLOGY:
//  - All ViewInspector API calls go through these wrapper extensions
//  - Conditional compilation is centralized here
//  - Test files use the wrapper APIs, not ViewInspector directly
//
//  MIGRATION PATH:
//  When ViewInspector works on macOS:
//  1. Remove all #if !os(macOS) conditions in this file
//  2. Change #if !os(macOS) to #if true (or remove entirely)
//  3. All test files will automatically work without changes

import SwiftUI
@testable import SixLayerFramework
import ViewInspector

// MARK: - View Extension for Inspection

extension View {
    /// Safely inspect a view using ViewInspector
    /// Returns nil on inspection failure (platform or other issues)
    /// When ViewInspector has issues on any platform, this gracefully returns nil
    @MainActor
    func tryInspect() -> InspectableView<ViewType.ClassifiedView>? {
        return try? self.inspect()
    }
    
    /// Inspect a view using ViewInspector, throwing on failure
    /// Throws when ViewInspector cannot inspect the view
    @MainActor
    func inspectView() throws -> InspectableView<ViewType.ClassifiedView> {
        return try self.inspect()
    }
}

// MARK: - InspectableView Extension for Common Operations

extension InspectableView {
    /// Safely find a view type, returning nil if not found
    func tryFind<T>(_ type: T.Type) -> InspectableView<ViewType.View<T>>? {
        return try? self.find(type)
    }

    /// Safely find all views of a type, returning empty array if none found
    func tryFindAll<T>(_ type: T.Type) -> [InspectableView<ViewType.View<T>>] {
        return (try? self.findAll(type)) ?? []
    }
}

// MARK: - Helper Functions for Common Patterns

/// Safely inspect a view and execute a closure if inspection succeeds
/// Returns nil on inspection failure
/// Handles all platform differences internally
@MainActor
public func withInspectedView<V: View, R>(
    _ view: V,
    perform: (InspectableView<ViewType.ClassifiedView>) throws -> R
) -> R? {
    guard let inspected = try? view.inspect() else {
        return nil
    }
    return try? perform(inspected)
}

/// Safely inspect a view and execute a throwing closure
/// Throws when ViewInspector cannot inspect the view
@MainActor
public func withInspectedViewThrowing<V: View, R>(
    _ view: V,
    perform: (InspectableView<ViewType.ClassifiedView>) throws -> R
) throws -> R {
    let inspected = try view.inspect()
    return try perform(inspected)
}
