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
#if !os(macOS)
import ViewInspector
#endif

// MARK: - View Extension for Inspection

extension View {
    /// Safely inspect a view using ViewInspector
    /// Returns nil on macOS or on inspection failure
    /// When ViewInspector works on macOS, remove the #if !os(macOS) condition
    @MainActor
    func tryInspect() -> InspectableView<ViewType.ClassifiedView>? {
        #if !os(macOS)
        return try? self.inspect()
        #else
        // TODO: When ViewInspector works on macOS, remove this return nil and use self.inspect() directly
        return nil
        #endif
    }
    
    /// Inspect a view using ViewInspector, throwing on failure
    /// When ViewInspector works on macOS, remove the #if !os(macOS) condition
    @MainActor
    func inspectView() throws -> InspectableView<ViewType.ClassifiedView> {
        #if !os(macOS)
        return try self.inspect()
        #else
        // TODO: When ViewInspector works on macOS, remove this throw and use self.inspect() directly
        struct ViewInspectorNotAvailableOnMacOS: Error {}
        throw ViewInspectorNotAvailableOnMacOS()
        #endif
    }
}

// MARK: - InspectableView Extension for Common Operations

#if !os(macOS)
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
#endif

// MARK: - Helper Functions for Common Patterns

/// Safely inspect a view and execute a closure if inspection succeeds
/// Returns nil on macOS or on inspection failure
/// When ViewInspector works on macOS, remove the #if !os(macOS) condition
@MainActor
public func withInspectedView<V: View, R>(
    _ view: V,
    perform: (InspectableView<ViewType.ClassifiedView>) throws -> R
) -> R? {
    #if !os(macOS)
    guard let inspected = try? view.inspect() else {
        return nil
    }
    return try? perform(inspected)
    #else
    // TODO: When ViewInspector works on macOS, remove this return nil
    return nil
    #endif
}

/// Safely inspect a view and execute a throwing closure
/// When ViewInspector works on macOS, remove the #if !os(macOS) condition
@MainActor
public func withInspectedViewThrowing<V: View, R>(
    _ view: V,
    perform: (InspectableView<ViewType.ClassifiedView>) throws -> R
) throws -> R {
    #if !os(macOS)
    let inspected = try view.inspect()
    return try perform(inspected)
    #else
    // TODO: When ViewInspector works on macOS, remove this throw
    struct ViewInspectorNotAvailableOnMacOS: Error {}
    throw ViewInspectorNotAvailableOnMacOS()
    #endif
}
