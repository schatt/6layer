//
//  AccessibilityTestUtilities.swift
//  SixLayerFrameworkTests
//
//  BUSINESS PURPOSE:
//  Shared test utilities for testing automatic accessibility identifier functionality
//  across all layers of the SixLayer framework.
//
//  TESTING SCOPE:
//  - Test helpers for checking automatic accessibility identifiers
//  - Test helpers for checking HIG compliance
//  - Test helpers for checking performance optimizations
//
//  METHODOLOGY:
//  - Provides consistent test helpers across all test files
//  - Avoids duplicate extension declarations
//  - Enables proper TDD testing of accessibility functionality
//

import SwiftUI
#if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
import ViewInspector
#endif
@testable import SixLayerFramework
#if canImport(UIKit)
import UIKit
#endif
#if canImport(AppKit)
import AppKit
#endif

// MARK: - Test Extensions for Accessibility Identifier Testing

extension View {
    /// Set the environment variable to enable automatic accessibility identifiers.
    /// Framework components should check this environment variable and apply .automaticCompliance() themselves.
    /// This should NOT apply the modifier directly - that's the component's responsibility.
    func withGlobalAutoIDsEnabled() -> some View {
        self
            .environment(\.globalAutomaticAccessibilityIdentifiers, true)
        // NOTE: We do NOT apply .automaticCompliance() here because:
        // 1. Framework components should apply it themselves based on the environment variable
        // 2. Plain views (Text, Button, etc.) don't need it unless explicitly enabled by the app
    }
}

// MARK: - Cross-platform hosting and accessibility utilities

/// Host a SwiftUI view and return the platform root view for inspection.
@MainActor
public func hostRootPlatformView<V: View>(_ view: V) -> Any? {
    #if canImport(UIKit)
    let hosting = UIHostingController(rootView: view)
    let root = hosting.view
    root?.setNeedsLayout()
    root?.layoutIfNeeded()
    
    // Force accessibility update
    root?.accessibilityElementsHidden = false
    root?.isAccessibilityElement = true
    
    // Force another layout pass to ensure accessibility is updated
    // Removed DispatchQueue.main.async - it was causing tests to wait for async work that never completes
    // The synchronous layoutIfNeeded() call above is sufficient
    root?.setNeedsLayout()
    root?.layoutIfNeeded()
    
    print("DEBUG: Created UIHostingController with root view: \(type(of: root))")
    print("DEBUG: Root view accessibility identifier: \(root?.accessibilityIdentifier ?? "nil")")
    return root
    #elseif canImport(AppKit)
    let hosting = NSHostingController(rootView: view)
    let root = hosting.view
    root.layoutSubtreeIfNeeded()
    
    // Force accessibility update
    root.setAccessibilityElement(true)
    
    // Force another layout pass to ensure accessibility is updated
    // Removed DispatchQueue.main.async - it was causing tests to wait for async work that never completes
    // The synchronous layoutSubtreeIfNeeded() call above is sufficient
    root.layoutSubtreeIfNeeded()
    
    print("DEBUG: Created NSHostingController with root view: \(type(of: root))")
    print("DEBUG: Root view accessibility identifier: '\(root.accessibilityIdentifier())'")
    return root
    #else
    print("DEBUG: No hosting controller available")
    return nil
    #endif
}

/// Depth-first search for the first non-empty accessibility identifier in the platform view hierarchy.
@MainActor
public func firstAccessibilityIdentifier(inHosted root: Any?) -> String? {
    #if canImport(UIKit)
    guard let rootView = root as? UIView else { return nil }
    
    // Debug: Print all views and their identifiers
    print("DEBUG: Root view type: \(type(of: rootView))")
    print("DEBUG: Root view accessibility identifier: \(rootView.accessibilityIdentifier ?? "nil")")
    print("DEBUG: Root view subviews count: \(rootView.subviews.count)")
    
    // Check root view first
    if let id = rootView.accessibilityIdentifier, !id.isEmpty { 
        print("DEBUG: Found accessibility identifier on root view: '\(id)'")
        return id 
    }
    
    // Search through all subviews more thoroughly
    var stack: [UIView] = rootView.subviews
    var depth = 0
    var checkedViews: Set<ObjectIdentifier> = []
    
    while let next = stack.popLast(), depth < 20 { // Increased depth limit
        let nextId = ObjectIdentifier(next)
        if checkedViews.contains(nextId) {
            continue // Avoid infinite loops
        }
        checkedViews.insert(nextId)
        
        print("DEBUG: Checking view at depth \(depth): \(type(of: next))")
        print("DEBUG: View accessibility identifier: \(next.accessibilityIdentifier ?? "nil")")
        
        if let id = next.accessibilityIdentifier, !id.isEmpty { 
            print("DEBUG: Found accessibility identifier on subview: '\(id)'")
            return id 
        }
        
        // Add all subviews to the stack
        stack.append(contentsOf: next.subviews)
        depth += 1
    }
    return nil
    #elseif canImport(AppKit)
    guard let rootView = root as? NSView else { 
        print("DEBUG: Root is not an NSView")
        return nil 
    }
    
    // Debug: Print all views and their identifiers
    print("DEBUG: Root NSView type: \(type(of: rootView))")
    print("DEBUG: Root NSView accessibility identifier: '\(rootView.accessibilityIdentifier())'")
    print("DEBUG: Root NSView subviews count: \(rootView.subviews.count)")
    
    // Check root view first
    let rootId = rootView.accessibilityIdentifier()
    if !rootId.isEmpty { 
        print("DEBUG: Found accessibility identifier on root NSView: '\(rootId)'")
        return rootId 
    }
    
    // Search through all subviews more thoroughly
    var stack: [NSView] = rootView.subviews
    var depth = 0
    var checkedViews: Set<ObjectIdentifier> = []
    
    while let next = stack.popLast(), depth < 20 { // Increased depth limit
        let nextId = ObjectIdentifier(next)
        if checkedViews.contains(nextId) {
            continue // Avoid infinite loops
        }
        checkedViews.insert(nextId)
        
        let id = next.accessibilityIdentifier()
        print("DEBUG: Checking NSView at depth \(depth): \(type(of: next))")
        print("DEBUG: NSView accessibility identifier: '\(id)'")
        
        if !id.isEmpty { 
            print("DEBUG: Found accessibility identifier on NSView subview: '\(id)'")
            return id 
        }
        
        // Add all subviews to the stack
        stack.append(contentsOf: next.subviews)
        depth += 1
    }
    return nil
    #else
    return nil
    #endif
}

/// Find ALL accessibility identifiers in a platform view hierarchy (not just the first one)
/// This is used as a fallback when ViewInspector is not available
@MainActor
private func findAllAccessibilityIdentifiersFromPlatformView(_ root: Any?) -> [String] {
    var identifiers: Set<String> = []
    
    #if canImport(UIKit)
    guard let rootView = root as? UIView else { return [] }
    
    // Check root view
    if let id = rootView.accessibilityIdentifier, !id.isEmpty {
        identifiers.insert(id)
    }
    
    // Search through all subviews
    var stack: [UIView] = rootView.subviews
    var depth = 0
    var checkedViews: Set<ObjectIdentifier> = []
    
    while let next = stack.popLast(), depth < 30 { // Increased depth for comprehensive search
        let nextId = ObjectIdentifier(next)
        if checkedViews.contains(nextId) {
            continue
        }
        checkedViews.insert(nextId)
        
        if let id = next.accessibilityIdentifier, !id.isEmpty {
            identifiers.insert(id)
        }
        
        stack.append(contentsOf: next.subviews)
        depth += 1
    }
    
    return Array(identifiers)
    #elseif canImport(AppKit)
    guard let rootView = root as? NSView else { return [] }
    
    // Check root view
    let rootId = rootView.accessibilityIdentifier()
    if !rootId.isEmpty {
        identifiers.insert(rootId)
    }
    
    // Search through all subviews
    var stack: [NSView] = rootView.subviews
    var depth = 0
    var checkedViews: Set<ObjectIdentifier> = []
    
    while let next = stack.popLast(), depth < 30 { // Increased depth for comprehensive search
        let nextId = ObjectIdentifier(next)
        if checkedViews.contains(nextId) {
            continue
        }
        checkedViews.insert(nextId)
        
        let id = next.accessibilityIdentifier()
        if !id.isEmpty {
            identifiers.insert(id)
        }
        
        stack.append(contentsOf: next.subviews)
        depth += 1
    }
    
    return Array(identifiers)
    #else
    return []
    #endif
}

/// Convenience: Return the accessibility identifier directly from a SwiftUI view
/// This is much simpler than hosting the view and searching platform views
/// 
/// IMPORTANT: This function does NOT apply .automaticCompliance() to the view.
/// Framework components should apply it themselves based on the environment variable.
/// We're testing that components do this, not that the test helper can do it.
/// 
/// PARALLEL TEST SAFETY: Tests MUST pass their isolated config instance (from BaseTestClass.testConfig)
/// to prevent race conditions. Do NOT use .shared - each test should have its own config.
@MainActor
public func getAccessibilityIdentifierFromSwiftUIView<V: View>(
    from view: V,
    config: AccessibilityIdentifierConfig
) -> String? {
    // CRITICAL: Tests must pass their isolated config instance to prevent singleton race conditions
    // Each test should use testConfig from BaseTestClass, not .shared
    
    // Set up environment variable AND inject config - components should check this and apply the modifier themselves
    // We do NOT apply .automaticCompliance() here because that would test the test helper,
    // not the framework components.
    // CRITICAL: Set both the environment variable AND inject the config to ensure modifiers can access it
    let viewWithEnvironment = view
        .environment(\.globalAutomaticAccessibilityIdentifiers, config.enableAutoIDs)
        .environment(\.accessibilityIdentifierConfig, config)
    
    #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
    // Use try? to safely call inspect() - if ViewInspector crashes internally, try? won't help,
    // but it will catch thrown errors. If inspect() returns nil, fall back to platform view hosting.
    if config.enableDebugLogging {
        print("🔍 SWIFTUI DEBUG: Attempting to inspect view of type: \(type(of: viewWithEnvironment))")
    }
    guard let inspected = try? viewWithEnvironment.inspect() else {
        // ViewInspector couldn't inspect the view (either threw error or crashed)
        // Fall back to platform view hosting
        if config.enableDebugLogging {
            print("🔍 SWIFTUI DEBUG: ViewInspector couldn't inspect view, falling back to platform view inspection")
        }
        let hosted = hostRootPlatformView(viewWithEnvironment)
        let platformId = firstAccessibilityIdentifier(inHosted: hosted)
        return platformId
    }
    if config.enableDebugLogging {
        print("🔍 SWIFTUI DEBUG: Successfully inspected view")
    }
    
    // CRITICAL: Check root view first - this IS the component's body when we pass the component directly
        // This ensures we're testing the component's identifier, not a parent's
        do {
            let identifier = try inspected.sixLayerAccessibilityIdentifier()
            if !identifier.isEmpty {
                if config.enableDebugLogging {
                    print("🔍 SWIFTUI DEBUG: Found accessibility identifier '\(identifier)' directly from root view (component's body)")
                }
                return identifier
            } else {
                if config.enableDebugLogging {
                    print("🔍 SWIFTUI DEBUG: Root view (component's body) has empty identifier")
                }
            }
        } catch {
            if config.enableDebugLogging {
                print("🔍 SWIFTUI DEBUG: Root view (component's body) doesn't have identifier: \(error)")
            }
        }
        
        // If root doesn't have identifier, check if root IS a container type (component's body structure)
        // This ensures we're checking the component's direct body, not searching for nested containers
        // Try to directly cast root to container types before searching deeper
        if let vStack = try? inspected.sixLayerVStack() {
            do {
                let identifier = try vStack.sixLayerAccessibilityIdentifier()
                if !identifier.isEmpty {
                    if config.enableDebugLogging {
                        print("🔍 SWIFTUI DEBUG: Found accessibility identifier '\(identifier)' from root VStack (component's body)")
                    }
                    return identifier
                }
            } catch {
                if config.enableDebugLogging {
                    print("🔍 SWIFTUI DEBUG: Root VStack (component's body) doesn't have identifier: \(error)")
                }
            }
        }
        
        if let hStack = try? inspected.sixLayerHStack() {
            do {
                let identifier = try hStack.sixLayerAccessibilityIdentifier()
                if !identifier.isEmpty {
                    if config.enableDebugLogging {
                        print("🔍 SWIFTUI DEBUG: Found accessibility identifier '\(identifier)' from root HStack (component's body)")
                    }
                    return identifier
                }
            } catch {
                if config.enableDebugLogging {
                    print("🔍 SWIFTUI DEBUG: Root HStack (component's body) doesn't have identifier: \(error)")
                }
            }
        }
        
        if let zStack = try? inspected.sixLayerZStack() {
            do {
                let identifier = try zStack.sixLayerAccessibilityIdentifier()
                if !identifier.isEmpty {
                    if config.enableDebugLogging {
                        print("🔍 SWIFTUI DEBUG: Found accessibility identifier '\(identifier)' from root ZStack (component's body)")
                    }
                    return identifier
                }
            } catch {
                if config.enableDebugLogging {
                    print("🔍 SWIFTUI DEBUG: Root ZStack (component's body) doesn't have identifier: \(error)")
                }
            }
        }
        
        // Only if root isn't a container, search deeper for containers
        // This is a fallback for components that wrap their body in another view
        // But we still prefer direct body access above
        // OPTIMIZATION: Use direct methods instead of sixLayerFind() to avoid slow recursive searches
        // sixLayerFind() uses find(where: { _ in true }) which searches everything and can be very slow
        if let vStack = try? inspected.sixLayerVStack() {
            do {
                let identifier = try vStack.sixLayerAccessibilityIdentifier()
                if !identifier.isEmpty {
                    if config.enableDebugLogging {
                        print("🔍 SWIFTUI DEBUG: Found accessibility identifier '\(identifier)' from nested VStack (fallback search)")
                    }
                    return identifier
                }
            } catch {
                if config.enableDebugLogging {
                    print("🔍 SWIFTUI DEBUG: Nested VStack doesn't have identifier: \(error)")
                }
            }
        }
        
        if let hStack = try? inspected.sixLayerHStack() {
            do {
                let identifier = try hStack.sixLayerAccessibilityIdentifier()
                if !identifier.isEmpty {
                    if config.enableDebugLogging {
                        print("🔍 SWIFTUI DEBUG: Found accessibility identifier '\(identifier)' from nested HStack (fallback search)")
                    }
                    return identifier
                }
            } catch {
                if config.enableDebugLogging {
                    print("🔍 SWIFTUI DEBUG: Nested HStack doesn't have identifier: \(error)")
                }
            }
        }
        
        if let zStack = try? inspected.sixLayerZStack() {
            do {
                let identifier = try zStack.sixLayerAccessibilityIdentifier()
                if !identifier.isEmpty {
                    if config.enableDebugLogging {
                        print("🔍 SWIFTUI DEBUG: Found accessibility identifier '\(identifier)' from nested ZStack (fallback search)")
                    }
                    return identifier
                }
            } catch {
                if config.enableDebugLogging {
                    print("🔍 SWIFTUI DEBUG: Nested ZStack doesn't have identifier: \(error)")
                }
            }
        }
        
        // If root is AnyView, try to unwrap it and find identifier in content
        // First try to get the identifier from the AnyView itself
        if let anyView = try? inspected.sixLayerAnyView() {
            do {
                let identifier = try anyView.sixLayerAccessibilityIdentifier()
                if !identifier.isEmpty {
                    if config.enableDebugLogging {
                        print("🔍 SWIFTUI DEBUG: Found accessibility identifier '\(identifier)' from unwrapped AnyView")
                    }
                    return identifier
                }
            } catch {
                if config.enableDebugLogging {
                    print("🔍 SWIFTUI DEBUG: AnyView doesn't have identifier directly: \(error)")
                }
            }
            
            // Try to find identifier deeper in the view hierarchy
            // The identifier might be on a modifier applied to the AnyView
            // Try to find Text or other views that might have the identifier
            if let text = try? anyView.sixLayerFind(ViewType.Text.self) {
                do {
                    let textId = try text.sixLayerAccessibilityIdentifier()
                    if !textId.isEmpty {
                        if config.enableDebugLogging {
                            print("🔍 SWIFTUI DEBUG: Found accessibility identifier '\(textId)' from Text inside AnyView")
                        }
                        return textId
                    }
                } catch {
                    if config.enableDebugLogging {
                        print("🔍 SWIFTUI DEBUG: Text inside AnyView doesn't have identifier: \(error)")
                    }
                }
            }
        }
        
        // ENHANCED: Search through all VStacks, HStacks, ZStacks, and AnyViews in the hierarchy
        // This finds identifiers that might be on nested views or modified views
        // Use findAll to get all instances of each container type and check their identifiers
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let containerTypes: [(String, Any.Type)] = [
            ("VStack", ViewType.VStack.self),
            ("HStack", ViewType.HStack.self),
            ("ZStack", ViewType.ZStack.self),
            ("AnyView", ViewType.AnyView.self)
        ]
        #else
        let containerTypes: [(String, Any.Type)] = []
        #endif
        
        for (typeName, viewType) in containerTypes {
            let containers = inspected.sixLayerFindAll(viewType)
            if !containers.isEmpty {
                for container in containers {
                    if let identifier = try? container.sixLayerAccessibilityIdentifier(), !identifier.isEmpty {
                        if config.enableDebugLogging {
                            print("🔍 SWIFTUI DEBUG: Found accessibility identifier '\(identifier)' in \(typeName) via findAll search")
                        }
                        return identifier
                    }
                }
            }
        }
        
        // Fallback: host platform view and search for identifier
        if config.enableDebugLogging {
            print("🔍 SWIFTUI DEBUG: ViewInspector couldn't find identifier, falling back to platform view inspection")
        }
        let hosted = hostRootPlatformView(viewWithEnvironment)
        let platformId = firstAccessibilityIdentifier(inHosted: hosted)
        return platformId
    #else
    // On macOS without VIEW_INSPECTOR_MAC_FIXED, ViewInspector is not available, so use platform view hosting
    if config.enableDebugLogging {
        print("🔍 SWIFTUI DEBUG: macOS - using platform view inspection (ViewInspector not available or VIEW_INSPECTOR_MAC_FIXED not defined)")
    }
    let hosted = hostRootPlatformView(viewWithEnvironment)
    let platformId = firstAccessibilityIdentifier(inHosted: hosted)
    return platformId
    #endif
}


// MARK: - Platform Mocking for Accessibility Tests

/// MANDATORY: Test accessibility identifiers with platform mocking as required by testing guidelines
/// This function REQUIRES platform mocking for any function that contains platform-dependent behavior
/// 
/// - Parameters:
///   - view: The SwiftUI view to test
///   - expectedPattern: The regex pattern to match against (use * for wildcards)
///   - platform: The platform to mock for testing
///   - componentName: Name of the component being tested (for debugging)
/// - Returns: True if the view has an identifier matching the pattern on the specified platform
/// Enhanced function to find all accessibility identifiers in a view hierarchy
/// This searches deeply through the view hierarchy to find all identifiers
@MainActor
private func findAllAccessibilityIdentifiers<V: View>(
    from view: V,
    config: AccessibilityIdentifierConfig
) -> [String] {
    var identifiers: Set<String> = []
    
    let viewWithEnvironment = view
        .environment(\.globalAutomaticAccessibilityIdentifiers, config.enableAutoIDs)
    
    #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
    guard let inspected = try? viewWithEnvironment.inspect() else {
        // Fallback to platform view - collect ALL identifiers from platform view hierarchy
        let hosted = hostRootPlatformView(viewWithEnvironment)
        let allPlatformIds = findAllAccessibilityIdentifiersFromPlatformView(hosted)
        if !allPlatformIds.isEmpty {
            if config.enableDebugLogging {
                print("🔍 PLATFORM FALLBACK: Found \(allPlatformIds.count) identifiers from platform view hierarchy: \(allPlatformIds)")
            }
            return allPlatformIds
        }
        if config.enableDebugLogging {
            print("🔍 PLATFORM FALLBACK: No identifiers found in platform view hierarchy")
        }
        return []
    }
    
    // Helper function to recursively collect identifiers
    func collectIdentifiers(from inspectable: Inspectable, depth: Int = 0) {
        guard depth < 15 else { return } // Prevent infinite recursion
        
        // Try to get identifier from this view
        if let id = try? inspectable.sixLayerAccessibilityIdentifier(), !id.isEmpty {
            if config.enableDebugLogging {
                print("🔍 COLLECT: Found identifier '\(id)' at depth \(depth)")
            }
            identifiers.insert(id)
        }
        
        // Search in VStacks
        let vStacks = inspectable.sixLayerFindAll(ViewType.VStack.self)
        if !vStacks.isEmpty {
            if config.enableDebugLogging {
                print("🔍 COLLECT: Found \(vStacks.count) VStacks at depth \(depth)")
            }
            for vStack in vStacks {
                collectIdentifiers(from: vStack, depth: depth + 1)
            }
        }
        
        // Search in HStacks
        let hStacks = inspectable.sixLayerFindAll(ViewType.HStack.self)
        if !hStacks.isEmpty {
            if config.enableDebugLogging {
                print("🔍 COLLECT: Found \(hStacks.count) HStacks at depth \(depth)")
            }
            for hStack in hStacks {
                collectIdentifiers(from: hStack, depth: depth + 1)
            }
        }
        
        // Search in ZStacks
        let zStacks = inspectable.sixLayerFindAll(ViewType.ZStack.self)
        if !zStacks.isEmpty {
            if config.enableDebugLogging {
                print("🔍 COLLECT: Found \(zStacks.count) ZStacks at depth \(depth)")
            }
            for zStack in zStacks {
                collectIdentifiers(from: zStack, depth: depth + 1)
            }
        }
        
        // Search in AnyViews
        let anyViews = inspectable.sixLayerFindAll(ViewType.AnyView.self)
        if !anyViews.isEmpty {
            if config.enableDebugLogging {
                print("🔍 COLLECT: Found \(anyViews.count) AnyViews at depth \(depth)")
            }
            for anyView in anyViews {
                collectIdentifiers(from: anyView, depth: depth + 1)
            }
        }
        
        // Also search in Text views (they might have identifiers)
        let texts = inspectable.sixLayerFindAll(ViewType.Text.self)
        if !texts.isEmpty {
            if config.enableDebugLogging {
                print("🔍 COLLECT: Found \(texts.count) Text views at depth \(depth)")
            }
            for text in texts {
                if let id = try? text.sixLayerAccessibilityIdentifier(), !id.isEmpty {
                    if config.enableDebugLogging {
                        print("🔍 COLLECT: Found identifier '\(id)' on Text view at depth \(depth)")
                    }
                    identifiers.insert(id)
                }
            }
        }
        
        // Also search in Button views (they might have identifiers)
        let buttons = inspectable.sixLayerFindAll(ViewType.Button.self)
        if !buttons.isEmpty {
            if config.enableDebugLogging {
                print("🔍 COLLECT: Found \(buttons.count) Button views at depth \(depth)")
            }
            for button in buttons {
                if let id = try? button.sixLayerAccessibilityIdentifier(), !id.isEmpty {
                    if config.enableDebugLogging {
                        print("🔍 COLLECT: Found identifier '\(id)' on Button view at depth \(depth)")
                    }
                    identifiers.insert(id)
                }
            }
        }
    }
    
    if config.enableDebugLogging {
        print("🔍 COLLECT: Starting identifier collection from root view")
    }
    collectIdentifiers(from: inspected)
    if config.enableDebugLogging {
        print("🔍 COLLECT: Finished collection, found \(identifiers.count) unique identifiers: \(Array(identifiers))")
    }
    #endif
    
    // Also check platform view hierarchy
    let hosted = hostRootPlatformView(viewWithEnvironment)
    if let platformId = firstAccessibilityIdentifier(inHosted: hosted), !platformId.isEmpty {
        identifiers.insert(platformId)
    }
    
    return Array(identifiers)
}

@MainActor
public func hasAccessibilityIdentifierWithPattern<T: View>(
    _ view: T, 
    expectedPattern: String,
    platform: SixLayerPlatform,
    componentName: String = "Component"
) -> Bool {
    // Automatically use task-local config if available (set by BaseTestClass), otherwise fall back to shared
    // This allows tests to use runWithTaskLocalConfig() for automatic isolation
    let config = AccessibilityIdentifierConfig.currentTaskLocalConfig ?? AccessibilityIdentifierConfig.shared
    
    // Set up platform mocking as required by mandatory testing guidelines
    TestSetupUtilities.shared.simulatePlatform(platform)
    
    // ENHANCED: Search for all identifiers in the hierarchy and find one that matches the pattern
    let allIdentifiers = findAllAccessibilityIdentifiers(from: view, config: config)
    
    if allIdentifiers.isEmpty {
        // Treat empty expected pattern OR explicit empty-regex patterns as success when identifier is missing/empty
        if expectedPattern.isEmpty || expectedPattern == "^$" || expectedPattern == "^\\s*$" {
            return true
        }
        print("❌ DISCOVERY: \(componentName) generates NO accessibility identifier on \(platform) - needs .automaticAccessibility() modifier")
        return false
    }
    
    // Convert pattern to regex (replace * with .*)
    let regexPattern = expectedPattern.replacingOccurrences(of: "*", with: ".*")
    
    do {
        let regex = try NSRegularExpression(pattern: regexPattern)
        
        // Check all identifiers to find one that matches the pattern
        for identifier in allIdentifiers {
            let range = NSRange(location: 0, length: identifier.utf16.count)
            if regex.firstMatch(in: identifier, options: [], range: range) != nil {
                if config.enableDebugLogging {
                    print("🔍 MATCH: Found matching identifier '\(identifier)' for pattern '\(expectedPattern)' (from \(allIdentifiers.count) total identifiers)")
                }
                return true
            }
        }
        
        // No match found
        print("⚠️ DISCOVERY: \(componentName) generates identifiers but none match pattern on \(platform). Expected: '\(expectedPattern)', Found: \(allIdentifiers.prefix(5).joined(separator: ", "))\(allIdentifiers.count > 5 ? "..." : "")")
        return false
    } catch {
        print("❌ DISCOVERY: Error creating regex pattern '\(expectedPattern)' on \(platform): \(error)")
        return false
    }
}

/// MANDATORY: Test accessibility identifiers with platform mocking for exact match
/// This function REQUIRES platform mocking for any function that contains platform-dependent behavior
/// 
/// - Parameters:
///   - view: The SwiftUI view to test
///   - expectedPattern: The exact accessibility identifier to look for
///   - platform: The platform to mock for testing
///   - componentName: Name of the component being tested (for debugging)
/// - Returns: True if the view has the exact expected identifier on the specified platform
@MainActor
public func hasAccessibilityIdentifierExact<T: View>(
    _ view: T, 
    expectedPattern: String,
    platform: SixLayerPlatform,
    componentName: String = "Component"
) -> Bool {
    // Automatically use task-local config if available (set by BaseTestClass), otherwise fall back to shared
    let config = AccessibilityIdentifierConfig.currentTaskLocalConfig ?? AccessibilityIdentifierConfig.shared
    
    // Set up platform mocking as required by mandatory testing guidelines
    TestSetupUtilities.shared.simulatePlatform(platform)
    
    // Get the actual accessibility identifier directly from the SwiftUI view
    guard let actualIdentifier = getAccessibilityIdentifierFromSwiftUIView(from: view, config: config) else {
        print("❌ DISCOVERY: \(componentName) generates NO accessibility identifier on \(platform) - needs .automaticAccessibility() modifier")
        return false
    }
    
    // Check if it matches exactly
    if actualIdentifier == expectedPattern {
        return true
    } else {
        print("⚠️ DISCOVERY: \(componentName) generates WRONG accessibility identifier on \(platform). Expected: '\(expectedPattern)', Got: '\(actualIdentifier)'")
        return false
    }
}

/// CRITICAL: Test if a view has the SPECIFIC accessibility identifier
/// This function REQUIRES an expected identifier - no more generic testing!
/// 
/// - Parameters:
///   - view: The SwiftUI view to test
///   - expectedPattern: The exact accessibility identifier to look for
///   - componentName: Name of the component being tested (for debugging)
/// - Returns: True if the view has the exact expected identifier
@MainActor
public func hasAccessibilityIdentifierSimple<T: View>(
    _ view: T, 
    expectedPattern: String,
    componentName: String = "Component"
) -> Bool {
    // Automatically use task-local config if available (set by BaseTestClass), otherwise fall back to shared
    let config = AccessibilityIdentifierConfig.currentTaskLocalConfig ?? AccessibilityIdentifierConfig.shared
    
    // Get the actual accessibility identifier directly from the SwiftUI view
    guard let actualIdentifier = getAccessibilityIdentifierFromSwiftUIView(from: view, config: config) else {
        // Special-case: treat nil identifier as empty string for tests explicitly expecting empty
        if expectedPattern.isEmpty {
            return true
        }
        print("❌ DISCOVERY: \(componentName) generates NO accessibility identifier - needs .automaticAccessibility() modifier")
        return false
    }
    
    // Check if it matches exactly
    if actualIdentifier == expectedPattern {
        return true
    } else {
        print("⚠️ DISCOVERY: \(componentName) generates WRONG accessibility identifier. Expected: '\(expectedPattern)', Got: '\(actualIdentifier)'")
        return false
    }
}

/// CRITICAL: Test if a view has an accessibility identifier matching a pattern
/// This function REQUIRES an expected pattern - no more generic testing!
/// 
/// - Parameters:
///   - view: The SwiftUI view to test
///   - expectedPattern: The regex pattern to match against (use * for wildcards)
///   - componentName: Name of the component being tested (for debugging)
/// - Returns: True if the view has an identifier matching the pattern

// MARK: - Parameterized Cross-Platform Testing

/// Test component compliance (accessibility identifiers + HIG compliance) across both iOS and macOS platforms
/// - Parameters:
///   - view: The SwiftUI view to test
///   - expectedPattern: The regex pattern to match against (use * for wildcards)
///   - componentName: Name of the component being tested (for debugging)
///   - testName: Name of the test for better error messages
///   - testHIGCompliance: Whether to test HIG compliance features (default: true - tests both accessibility identifiers and HIG compliance)
/// - Returns: True if the view generates correct accessibility identifiers and passes HIG compliance on both platforms
@MainActor
public func testComponentComplianceCrossPlatform<T: View>(
    _ view: T,
    expectedPattern: String,
    componentName: String,
    testName: String = "CrossPlatformComplianceTest",
    testHIGCompliance: Bool = true
) -> Bool {
    let platforms: [SixLayerPlatform] = [.iOS, .macOS]
    var allPlatformsPassed = true
    
    for platform in platforms {
        // Set the test platform for this test case
        RuntimeCapabilityDetection.setTestPlatform(platform)
        
        // Test accessibility identifiers and HIG compliance
        let passed = testComponentComplianceSinglePlatform(
            view,
            expectedPattern: expectedPattern,
            platform: platform,
            componentName: "\(componentName)-\(platform)",
            testHIGCompliance: testHIGCompliance
        )
        
        if !passed {
            print("❌ CROSS-PLATFORM: \(testName) failed on \(platform)")
            allPlatformsPassed = false
        } else {
        }
        
        // Clean up test platform
        RuntimeCapabilityDetection.setTestPlatform(nil)
    }
    
    return allPlatformsPassed
}

/// Test accessibility identifiers across both iOS and macOS platforms
/// This is kept for backward compatibility - it now also tests HIG compliance by default
@available(*, deprecated, renamed: "testComponentComplianceCrossPlatform", message: "Use testComponentComplianceCrossPlatform which tests both accessibility identifiers and HIG compliance")
@MainActor
public func testAccessibilityIdentifiersCrossPlatform<T: View>(
    _ view: T,
    expectedPattern: String,
    componentName: String,
    testName: String = "CrossPlatformTest",
    testHIGCompliance: Bool = true
) -> Bool {
    return testComponentComplianceCrossPlatform(
        view,
        expectedPattern: expectedPattern,
        componentName: componentName,
        testName: testName,
        testHIGCompliance: testHIGCompliance
    )
}

/// Test component compliance (accessibility identifiers + HIG compliance) on a single platform
/// - Parameters:
///   - view: The SwiftUI view to test
///   - expectedPattern: The regex pattern to match against (use * for wildcards)
///   - platform: The platform to test on
///   - componentName: Name of the component being tested (for debugging)
///   - testHIGCompliance: Whether to test HIG compliance features (default: true - tests both accessibility identifiers and HIG compliance)
/// - Returns: True if the view generates correct accessibility identifiers and passes HIG compliance on the specified platform
@MainActor
public func testComponentComplianceSinglePlatform<T: View>(
    _ view: T,
    expectedPattern: String,
    platform: SixLayerPlatform,
    componentName: String,
    testHIGCompliance: Bool = true
) -> Bool {
    // Automatically use task-local config if available (set by BaseTestClass), otherwise fall back to shared
    let config = AccessibilityIdentifierConfig.currentTaskLocalConfig ?? AccessibilityIdentifierConfig.shared
    
    // Configure the test-specific settings
    // Preserve existing debug logging setting (don't override - tests control this)
    let wasDebugLoggingEnabled = config.enableDebugLogging
    
    config.enableAutoIDs = true
    config.namespace = "SixLayer"
    config.globalPrefix = ""
    config.mode = .automatic
    // Don't enable debug logging by default - too verbose for normal test runs
    // Tests that need debug logging should enable it explicitly before calling this function
    config.enableDebugLogging = wasDebugLoggingEnabled  // Preserve existing setting
    config.includeComponentNames = true  // Required for component name to appear in identifiers
    config.includeElementTypes = true   // Required for element type to appear in identifiers
    
    // Set the test platform for this test case
    RuntimeCapabilityDetection.setTestPlatform(platform)
    
    // Test accessibility identifiers
    let accessibilityResult = hasAccessibilityIdentifierWithPattern(
        view,
        expectedPattern: expectedPattern,
        platform: platform,
        componentName: componentName
    )
    
    // Test HIG compliance (default: true - tests both accessibility identifiers and HIG compliance)
    var higComplianceResult = true
    if testHIGCompliance {
        higComplianceResult = testHIGComplianceFeatures(
            view,
            platform: platform,
            componentName: componentName
        )
    }
    
    // Clean up test platform
    RuntimeCapabilityDetection.setTestPlatform(nil)
    
    return accessibilityResult && higComplianceResult
}

/// Test accessibility identifiers on a single platform (for representative sampling)
/// This is kept for backward compatibility - it now also tests HIG compliance by default
@available(*, deprecated, renamed: "testComponentComplianceSinglePlatform", message: "Use testComponentComplianceSinglePlatform which tests both accessibility identifiers and HIG compliance")
@MainActor
public func testAccessibilityIdentifiersSinglePlatform<T: View>(
    _ view: T,
    expectedPattern: String,
    platform: SixLayerPlatform,
    componentName: String,
    testHIGCompliance: Bool = true
) -> Bool {
    return testComponentComplianceSinglePlatform(
        view,
        expectedPattern: expectedPattern,
        platform: platform,
        componentName: componentName,
        testHIGCompliance: testHIGCompliance
    )
}

// MARK: - HIG Compliance Test Functions

/// Test HIG compliance features on a view
/// - Parameters:
///   - view: The SwiftUI view to test
///   - platform: The platform to test on
///   - componentName: Name of the component being tested (for debugging)
/// - Returns: True if all HIG compliance features pass
@MainActor
public func testHIGComplianceFeatures<T: View>(
    _ view: T,
    platform: SixLayerPlatform,
    componentName: String
) -> Bool {
    // TDD RED PHASE: This function should FAIL until HIG compliance features are implemented
    // As we implement each HIG feature, we'll add checks here and return true only when all pass
    
    // TODO: Implement actual HIG compliance checks:
    // - Touch target sizing (iOS) - minimum 44pt
    // - Color contrast (WCAG) - AA/AAA compliance
    // - Typography scaling (Dynamic Type) - supports accessibility sizes
    // - Focus indicators - visible and accessible
    // - Motion preferences - respects reduced motion
    // - Tab order - logical navigation order
    // etc.
    
    // RED PHASE: Return false until features are implemented
    // This ensures tests fail until we actually implement HIG compliance
    print("⚠️ HIG COMPLIANCE: \(componentName) on \(platform) - HIG compliance features not yet implemented (TDD RED phase)")
    return false
}
