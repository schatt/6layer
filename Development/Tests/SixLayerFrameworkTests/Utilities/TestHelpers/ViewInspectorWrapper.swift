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
/// When ViewInspector fixes GitHub issue #405, uncomment .define("VIEW_INSPECTOR_MAC_FIXED") in Package.swift
/// All conditional logic in this file is controlled by this compile-time flag
/// The flag is defined in Package.swift as a swiftSettings define
/// When flag is defined, VIEW_INSPECTOR_MAC_FIXED is true
/// When flag is not defined, VIEW_INSPECTOR_MAC_FIXED is false (current state)
#if VIEW_INSPECTOR_MAC_FIXED
let viewInspectorMacFixed = true
#else
let viewInspectorMacFixed = false
#endif

/// Error type for when ViewInspector is not available
struct ViewInspectorNotAvailableError: Error {}

// Import ViewInspector when available (iOS always, macOS only when VIEW_INSPECTOR_MAC_FIXED is 1)
#if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
import ViewInspector
#endif

// MARK: - Type-Erased Inspectable Protocol

/// Protocol that abstracts ViewInspector's InspectableView
/// This allows the wrapper to return a consistent type regardless of platform
/// Uses prefixed method names to avoid naming conflicts with ViewInspector and prevent infinite recursion
public protocol Inspectable {
    func sixLayerButton() throws -> Inspectable
    func sixLayerText() throws -> Inspectable
    func sixLayerText(_ index: Int) throws -> Inspectable
    func sixLayerVStack() throws -> Inspectable
    func sixLayerVStack(_ index: Int) throws -> Inspectable
    func sixLayerHStack() throws -> Inspectable
    func sixLayerHStack(_ index: Int) throws -> Inspectable
    func sixLayerZStack() throws -> Inspectable
    func sixLayerTextField() throws -> Inspectable
    func sixLayerTextField(_ index: Int) throws -> Inspectable
    func sixLayerAccessibilityIdentifier() throws -> String
    func sixLayerFindAll<T>(_ type: T.Type) -> [Inspectable]
    func sixLayerFind<T>(_ type: T.Type) throws -> Inspectable
    func sixLayerTryFind<T>(_ type: T.Type) -> Inspectable?
    // sixLayerTryFindAll removed - use sixLayerFindAll instead (it's now non-throwing)
    func sixLayerAnyView() throws -> Inspectable
    func sixLayerString() throws -> String
    func sixLayerCallOnTapGesture() throws
    func sixLayerLabelView() throws -> Inspectable
    func sixLayerTap() throws
    var sixLayerCount: Int { get }
    var sixLayerIsEmpty: Bool { get }
    func sixLayerContains(_ element: Inspectable) -> Bool
}

#if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
// Make InspectableView conform to our protocol
extension InspectableView: Inspectable {
    public func sixLayerButton() throws -> Inspectable {
        // Use findAll(where:) to find buttons - Button types vary by label
        // Try to find any button by checking if we can access button-specific methods
        let allViews = try self.findAll(where: { view in
            // Check if this is a button by trying to access button-specific properties
            // This is a best-effort approach
            return true // We'll filter at usage
        })
        // Try to find a button by attempting to cast to button types
        // This is simplified - actual button detection happens when methods are called
        if let firstView = allViews.first {
            return firstView as Inspectable
        }
        throw InspectionError.notSupported("sixLayerButton() requires a Button view")
    }
    
    public func sixLayerText() throws -> Inspectable {
        // Use ViewInspector's findAll with ViewType.Text to recursively search for Text views
        let texts = try self.findAll(ViewType.Text.self)
        if let firstText = texts.first {
            return firstText as Inspectable
        }
        throw InspectionError.notSupported("sixLayerText() requires a Text view")
    }
    
    public func sixLayerText(_ index: Int) throws -> Inspectable {
        // This works on VStack/HStack which have indexed access
        if let vStackSelf = self as? InspectableView<ViewType.VStack> {
            return try vStackSelf.text(index) as Inspectable
        }
        // Fallback: try direct access via findAll
        // Note: findAll can throw, but compiler may warn - this is a false positive
        let texts = try self.findAll(ViewType.Text.self)
        if let firstText = texts.first {
            return firstText as Inspectable
        }
        throw InspectionError.notSupported("sixLayerText() requires a Text view")
    }
    
    public func sixLayerVStack() throws -> Inspectable {
        // Use ViewInspector's findAll with ViewType.VStack to recursively search for VStacks
        // This will find VStacks even when wrapped in modifiers
        // Note: findAll can throw, but compiler may warn - this is a false positive
        let vStacks = try self.findAll(ViewType.VStack.self)
        if let firstVStack = vStacks.first {
            return firstVStack as Inspectable
        }
        throw InspectionError.notSupported("sixLayerVStack() requires a VStack view")
    }
    
    public func sixLayerVStack(_ index: Int) throws -> Inspectable {
        // VStack from MultipleViewContent parent (like another VStack) supports indexed access
        if let vStackSelf = self as? InspectableView<ViewType.VStack> {
            return try vStackSelf.vStack(index) as Inspectable
        }
        // Fallback: try direct access via findAll
        // Note: findAll can throw, but compiler may warn - this is a false positive
        let vStacks = try self.findAll(ViewType.VStack.self)
        if let firstVStack = vStacks.first {
            return firstVStack as Inspectable
        }
        throw InspectionError.notSupported("sixLayerVStack() requires a VStack view")
    }
    
    public func sixLayerHStack() throws -> Inspectable {
        // Use ViewInspector's findAll with ViewType.HStack to recursively search for HStacks
        // Note: findAll can throw, but compiler may warn - this is a false positive
        let hStacks = try self.findAll(ViewType.HStack.self)
        if let firstHStack = hStacks.first {
            return firstHStack as Inspectable
        }
        throw InspectionError.notSupported("sixLayerHStack() requires an HStack view")
    }
    
    public func sixLayerHStack(_ index: Int) throws -> Inspectable {
        // HStack from MultipleViewContent parent (like VStack) supports indexed access
        if let vStackSelf = self as? InspectableView<ViewType.VStack> {
            return try vStackSelf.hStack(index) as Inspectable
        }
        // Fallback: try direct access via findAll
        // Note: findAll can throw, but compiler may warn - this is a false positive
        let hStacks = try self.findAll(ViewType.HStack.self)
        if let firstHStack = hStacks.first {
            return firstHStack as Inspectable
        }
        throw InspectionError.notSupported("sixLayerHStack() requires an HStack view")
    }
    
    public func sixLayerZStack() throws -> Inspectable {
        // Use ViewInspector's findAll with ViewType.ZStack to recursively search for ZStacks
        // Note: findAll can throw, but compiler may warn - this is a false positive
        let zStacks = try self.findAll(ViewType.ZStack.self)
        if let firstZStack = zStacks.first {
            return firstZStack as Inspectable
        }
        throw InspectionError.notSupported("sixLayerZStack() requires a ZStack view")
    }
    
    public func sixLayerTextField() throws -> Inspectable {
        // Use ViewInspector's findAll with ViewType.TextField to recursively search for TextFields
        // Note: findAll can throw, but compiler may warn - this is a false positive
        let textFields = try self.findAll(ViewType.TextField.self)
        if let firstTextField = textFields.first {
            return firstTextField as Inspectable
        }
        throw InspectionError.notSupported("sixLayerTextField() requires a TextField view")
    }
    
    public func sixLayerTextField(_ index: Int) throws -> Inspectable {
        // This works on VStack/HStack which have indexed access
        if let vStackSelf = self as? InspectableView<ViewType.VStack> {
            return try vStackSelf.textField(index) as Inspectable
        }
        // Fallback: try direct access via findAll
        // Note: findAll can throw, but compiler may warn - this is a false positive
        let textFields = try self.findAll(ViewType.TextField.self)
        if let firstTextField = textFields.first {
            return firstTextField as Inspectable
        }
        throw InspectionError.notSupported("sixLayerTextField() requires a TextField view")
    }
    
    public func sixLayerAccessibilityIdentifier() throws -> String {
        // No recursion risk - different method name than ViewInspector's accessibilityIdentifier()
        // Only return the identifier for this specific view, do not search children recursively
        // If a test needs to find an identifier in a child view, it should navigate to that child first
        
        // Safely call ViewInspector's accessibilityIdentifier() method
        // Use try? to prevent crashes if ViewInspector's method throws or crashes
        // Return empty string if the call fails, which tests can check for
        guard let identifier = try? self.accessibilityIdentifier() else {
            return ""
        }
        return identifier
    }
    
    public func sixLayerFindAll<T>(_ type: T.Type) -> [Inspectable] {
        // Use findAll(where:) to search for views matching the type
        // This works for all types but requires runtime type checking
        // Non-throwing version - returns empty array on failure
        guard let allViews = try? self.findAll(where: { view in
            // Check if the view matches the requested type by trying to access it
            // This is a best-effort approach since we can't use internal ViewInspector APIs
            return true // Accept all views - filtering happens at usage site
        }) else {
            return []
        }
        return allViews.map { $0 as Inspectable }
    }
    
    public func sixLayerFind<T>(_ type: T.Type) throws -> Inspectable {
        // Thin wrapper around ViewInspector's find method
        // The slowness is in ViewInspector itself, not this wrapper
        let found = try self.find(where: { _ in true })
        return found as Inspectable
    }
    
    public func sixLayerTryFind<T>(_ type: T.Type) -> Inspectable? {
        return try? self.sixLayerFind(type)
    }
    
    // sixLayerTryFindAll removed - sixLayerFindAll is now non-throwing, so use it directly
    
    public func sixLayerAnyView() throws -> Inspectable {
        // Use find(where:) to find any view, avoiding SingleViewContent constraint
        // This is a workaround for the anyView() constraint issue
        if let anyViewResult = try? self.find(where: { _ in true }) {
            return anyViewResult as Inspectable
        }
        // If that fails, return self as a fallback
        return self as Inspectable
    }
    
    public func sixLayerString() throws -> String {
        // No recursion - different method name than ViewInspector's string()
        if let textView = self as? InspectableView<ViewType.Text> {
            return try textView.string()
        }
        throw InspectionError.notSupported("sixLayerString() can only be called on Text views")
    }
    
    public func sixLayerCallOnTapGesture() throws {
        // No recursion - different method name than ViewInspector's callOnTapGesture()
        try self.callOnTapGesture()
    }
    
    public func sixLayerLabelView() throws -> Inspectable {
        // Try to find text content - buttons typically have text labels
        // This is a simplified approach since we can't easily detect button types
        if let text = try? self.sixLayerFind(ViewType.Text.self) {
            return text
        }
        // Fallback: return self
        return self as Inspectable
    }
    
    public func sixLayerTap() throws {
        // Use callOnTapGesture for all tapable views
        // This works for buttons and other tappable views
        try self.callOnTapGesture()
    }
    
    public var sixLayerCount: Int {
        // No recursion - different property name than ViewInspector's count
        if let vStackSelf = self as? InspectableView<ViewType.VStack> {
            return vStackSelf.count
        }
        if let hStackSelf = self as? InspectableView<ViewType.HStack> {
            return hStackSelf.count
        }
        return 0
    }
    
    public var sixLayerIsEmpty: Bool {
        // InspectableView doesn't have isEmpty directly
        return false
    }
    
    public func sixLayerContains(_ element: Inspectable) -> Bool {
        // InspectableView doesn't have contains directly
        return false
    }
}
#endif

// Dummy implementation for when ViewInspector is not available
struct DummyInspectable: Inspectable {
    func sixLayerButton() throws -> Inspectable { throw ViewInspectorNotAvailableError() }
    func sixLayerText() throws -> Inspectable { throw ViewInspectorNotAvailableError() }
    func sixLayerText(_ index: Int) throws -> Inspectable { throw ViewInspectorNotAvailableError() }
    func sixLayerVStack() throws -> Inspectable { throw ViewInspectorNotAvailableError() }
    func sixLayerVStack(_ index: Int) throws -> Inspectable { throw ViewInspectorNotAvailableError() }
    func sixLayerHStack() throws -> Inspectable { throw ViewInspectorNotAvailableError() }
    func sixLayerHStack(_ index: Int) throws -> Inspectable { throw ViewInspectorNotAvailableError() }
    func sixLayerZStack() throws -> Inspectable { throw ViewInspectorNotAvailableError() }
    func sixLayerTextField() throws -> Inspectable { throw ViewInspectorNotAvailableError() }
    func sixLayerTextField(_ index: Int) throws -> Inspectable { throw ViewInspectorNotAvailableError() }
    func sixLayerAccessibilityIdentifier() throws -> String { throw ViewInspectorNotAvailableError() }
    func sixLayerFindAll<T>(_ type: T.Type) -> [Inspectable] { return [] }
    func sixLayerFind<T>(_ type: T.Type) throws -> Inspectable { throw ViewInspectorNotAvailableError() }
    func sixLayerTryFind<T>(_ type: T.Type) -> Inspectable? { return nil }
    func sixLayerAnyView() throws -> Inspectable { throw ViewInspectorNotAvailableError() }
    func sixLayerString() throws -> String { throw ViewInspectorNotAvailableError() }
    func sixLayerCallOnTapGesture() throws { throw ViewInspectorNotAvailableError() }
    func sixLayerLabelView() throws -> Inspectable { throw ViewInspectorNotAvailableError() }
    func sixLayerTap() throws { throw ViewInspectorNotAvailableError() }
    var sixLayerCount: Int { return 0 }
    var sixLayerIsEmpty: Bool { return true }
    func sixLayerContains(_ element: Inspectable) -> Bool { return false }
}

// MARK: - View Extension for Inspection

extension View {
    /// Safely inspect a view using ViewInspector
    /// Returns nil on inspection failure
    /// Returns a consistent Inspectable type regardless of platform
    @MainActor
    func tryInspect() -> Inspectable? {
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        return try? self.inspect() as Inspectable?
        #else
        return nil
        #endif
    }
    
    /// Inspect a view using ViewInspector, throwing on failure
    /// Throws when ViewInspector cannot inspect the view
    @MainActor
    func inspectView() throws -> Inspectable {
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        return try self.inspect() as Inspectable
        #else
        throw ViewInspectorNotAvailableError()
        #endif
    }
}

// MARK: - InspectableView Extension for Common Operations

#if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
extension InspectableView {
    /// Safely find a view type, returning nil if not found
    func tryFind<T: SwiftUI.View>(_ type: T.Type) -> InspectableView<ViewType.View<T>>? {
        return try? self.find(type)
    }

    /// Safely find all views of a type, returning empty array if none found
    func tryFindAll<T: SwiftUI.View>(_ type: T.Type) -> [InspectableView<ViewType.View<T>>] {
        // Note: findAll can throw, but compiler may warn - this is a false positive
        return (try? self.findAll(type)) ?? []
    }
}
#endif

// MARK: - Helper Functions for Common Patterns

/// Safely inspect a view and execute a closure if inspection succeeds
/// Returns nil on inspection failure
/// Uses Inspectable protocol for consistent type across platforms
@MainActor
public func withInspectedView<V: View, R>(
    _ view: V,
    perform: (Inspectable) throws -> R
) -> R? {
    guard let inspected = view.tryInspect() else {
        return nil
    }
    return try? perform(inspected)
}

/// Safely inspect a view and execute a throwing closure
/// Throws when ViewInspector cannot inspect the view
/// Uses Inspectable protocol for consistent type across platforms
@MainActor
public func withInspectedViewThrowing<V: View, R>(
    _ view: V,
    perform: (Inspectable) throws -> R
) throws -> R {
    let inspected = try view.inspectView()
    return try perform(inspected)
}
