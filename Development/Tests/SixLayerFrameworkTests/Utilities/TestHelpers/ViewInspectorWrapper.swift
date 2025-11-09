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
//  1. Change viewInspectorMacFixed = true
//  2. All test files will automatically work without changes

import SwiftUI
@testable import SixLayerFramework

/// Flag to control ViewInspector availability on macOS
/// When ViewInspector fixes GitHub issue #405, change this to true
/// All conditional logic in this file is controlled by this flag
/// NOTE: This is a runtime constant. For compile-time conditionals, we use !os(macOS)
/// When the flag is true, we can remove the !os(macOS) checks
let viewInspectorMacFixed = false

/// Error type for when ViewInspector is not available
struct ViewInspectorNotAvailableError: Error {}

// Import ViewInspector when available (iOS always, macOS only when fixed)
// The wrapper functions handle the platform differences at runtime
#if canImport(ViewInspector) && !os(macOS)
import ViewInspector
#endif

// MARK: - View Extension for Inspection

#if canImport(ViewInspector) && !os(macOS)
extension View {
    /// Safely inspect a view using ViewInspector
    /// Returns nil on inspection failure
    /// When ViewInspector works on macOS, remove the canImport condition
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
#else
extension View {
    /// ViewInspector not available on this platform
    /// When ViewInspector works on this platform, remove the canImport condition above
    @MainActor
    func tryInspect() -> Any? {
        return nil
    }

    /// ViewInspector not available on this platform
    @MainActor
    func inspectView() throws -> Any {
        throw ViewInspectorNotAvailableError()
    }
}
#endif

// MARK: - InspectableView Extension for Common Operations

#if canImport(ViewInspector) && !os(macOS)
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

#if canImport(ViewInspector) && !os(macOS)
/// Safely inspect a view and execute a closure if inspection succeeds
/// Returns nil on inspection failure
/// When ViewInspector works on all platforms, remove the canImport condition
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
#else
/// ViewInspector not available on this platform
/// When ViewInspector works on this platform, remove the canImport condition above
@MainActor
public func withInspectedView<V: View, R>(
    _ view: V,
    perform: (Any) throws -> R
) -> R? {
    return nil
}
#endif

#if canImport(ViewInspector) && !os(macOS)
/// Safely inspect a view and execute a throwing closure
/// Throws when ViewInspector cannot inspect the view
/// When ViewInspector works on all platforms, remove the canImport condition
@MainActor
public func withInspectedViewThrowing<V: View, R>(
    _ view: V,
    perform: (InspectableView<ViewType.ClassifiedView>) throws -> R
) throws -> R {
    let inspected = try view.inspect()
    return try perform(inspected)
}
#else
/// ViewInspector not available on this platform
/// When ViewInspector works on this platform, remove the canImport condition above
@MainActor
public func withInspectedViewThrowing<V: View, R>(
    _ view: V,
    perform: (Any) throws -> R
) throws -> R {
    throw ViewInspectorNotAvailableError()
}
#endif
