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
@testable import SixLayerFramework
import ViewInspector
#if canImport(UIKit)
import UIKit
#endif
#if canImport(AppKit)
import AppKit
#endif

// MARK: - Test Extensions for Accessibility Identifier Testing

extension View {
    /// Wrap the view with the global automatic accessibility identifier modifier so
    /// that auto-ID assignment is enabled in hosted test environments.
    func withGlobalAutoIDsEnabled() -> some View {
        self
            .environment(\.globalAutomaticAccessibilityIdentifiers, true)
            .automaticAccessibilityIdentifiers()
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
    DispatchQueue.main.async {
        root?.setNeedsLayout()
        root?.layoutIfNeeded()
    }
    
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
    DispatchQueue.main.async {
        root.layoutSubtreeIfNeeded()
    }
    
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

/// Convenience: Return the accessibility identifier directly from a SwiftUI view
/// This is much simpler than hosting the view and searching platform views
@MainActor
public func getAccessibilityIdentifierFromSwiftUIView<V: View>(from view: V) -> String? {
    // Ensure config is enabled for tests
    let config = AccessibilityIdentifierConfig.shared
    config.enableDebugLogging = true
    if config.namespace.isEmpty {
        config.namespace = "test"
    }
    
    // Only apply global auto IDs when enabled; respect disabled mode
    @ViewBuilder
    func wrap<W: View>(_ v: W) -> some View {
        if config.enableAutoIDs {
            v.withGlobalAutoIDsEnabled()
        } else {
            v
        }
    }
    let viewWithAutoIDs = wrap(view)
    
    do {
        // Use ViewInspector to directly inspect the SwiftUI view
        let identifier = try viewWithAutoIDs.inspect().accessibilityIdentifier()
        print("🔍 SWIFTUI DEBUG: Found accessibility identifier '\(identifier)' directly from SwiftUI view")
        return identifier.isEmpty ? nil : identifier
    } catch {
        print("🔍 SWIFTUI DEBUG: Could not inspect accessibility identifier: \(error)")
        // Fallback: host platform view and search for identifier
        let hosted = hostRootPlatformView(viewWithAutoIDs)
        let platformId = firstAccessibilityIdentifier(inHosted: hosted)
        return platformId
    }
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
@MainActor
public func hasAccessibilityIdentifierWithPattern<T: View>(
    _ view: T, 
    expectedPattern: String,
    platform: SixLayerPlatform,
    componentName: String = "Component"
) -> Bool {
    // Set up platform mocking as required by mandatory testing guidelines
    TestSetupUtilities.shared.simulatePlatform(platform)
    
    // Get the actual accessibility identifier directly from the SwiftUI view
    let actualIdentifier = getAccessibilityIdentifierFromSwiftUIView(from: view)
    if actualIdentifier == nil || actualIdentifier?.isEmpty == true {
        // Treat empty expected pattern OR explicit empty-regex patterns as success when identifier is missing/empty
        if expectedPattern.isEmpty || expectedPattern == "^$" || expectedPattern == "^\\s*$" {
            print("✅ DISCOVERY: \(componentName) has no accessibility identifier as expected (empty) on \(platform)")
            return true
        }
        print("❌ DISCOVERY: \(componentName) generates NO accessibility identifier on \(platform) - needs .automaticAccessibility() modifier")
        return false
    }
    
    // Convert pattern to regex (replace * with .*)
    // Special-case: if expected pattern is empty, we already handled above
    let regexPattern = expectedPattern.replacingOccurrences(of: "*", with: ".*")
    
    do {
        let regex = try NSRegularExpression(pattern: regexPattern)
        let range = NSRange(location: 0, length: actualIdentifier!.utf16.count)
        
        if regex.firstMatch(in: actualIdentifier!, options: [], range: range) != nil {
            print("✅ DISCOVERY: \(componentName) generates CORRECT pattern match on \(platform): '\(actualIdentifier!)' matches '\(expectedPattern)'")
            return true
        } else {
            print("⚠️ DISCOVERY: \(componentName) generates WRONG pattern on \(platform). Expected: '\(expectedPattern)', Got: '\(actualIdentifier!)'")
            // Fallback: host platform view and re-check using platform identifier (may reflect outermost modifier)
            let hosted = hostRootPlatformView(view)
            if let platformId = firstAccessibilityIdentifier(inHosted: hosted) {
                let pRange = NSRange(location: 0, length: platformId.utf16.count)
                if regex.firstMatch(in: platformId, options: [], range: pRange) != nil {
                    print("✅ DISCOVERY: \(componentName) platform identifier matches on \(platform): '\(platformId)' matches '\(expectedPattern)'")
                    return true
                }
            }
            return false
        }
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
    // Set up platform mocking as required by mandatory testing guidelines
    TestSetupUtilities.shared.simulatePlatform(platform)
    
    // Get the actual accessibility identifier directly from the SwiftUI view
    guard let actualIdentifier = getAccessibilityIdentifierFromSwiftUIView(from: view) else {
        print("❌ DISCOVERY: \(componentName) generates NO accessibility identifier on \(platform) - needs .automaticAccessibility() modifier")
        return false
    }
    
    // Check if it matches exactly
    if actualIdentifier == expectedPattern {
        print("✅ DISCOVERY: \(componentName) generates CORRECT accessibility identifier on \(platform): '\(actualIdentifier)'")
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
    // Get the actual accessibility identifier directly from the SwiftUI view
    guard let actualIdentifier = getAccessibilityIdentifierFromSwiftUIView(from: view) else {
        // Special-case: treat nil identifier as empty string for tests explicitly expecting empty
        if expectedPattern.isEmpty {
            print("✅ DISCOVERY: \(componentName) has no accessibility identifier as expected (empty)")
            return true
        }
        print("❌ DISCOVERY: \(componentName) generates NO accessibility identifier - needs .automaticAccessibility() modifier")
        return false
    }
    
    // Check if it matches exactly
    if actualIdentifier == expectedPattern {
        print("✅ DISCOVERY: \(componentName) generates CORRECT accessibility identifier: '\(actualIdentifier)'")
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

/// Test accessibility identifiers across both iOS and macOS platforms
/// - Parameters:
///   - view: The SwiftUI view to test
///   - expectedPattern: The regex pattern to match against (use * for wildcards)
///   - componentName: Name of the component being tested (for debugging)
///   - testName: Name of the test for better error messages
/// - Returns: True if the view generates correct accessibility identifiers on both platforms
@MainActor
public func testAccessibilityIdentifiersCrossPlatform<T: View>(
    _ view: T,
    expectedPattern: String,
    componentName: String,
    testName: String = "CrossPlatformTest"
) -> Bool {
    let platforms: [SixLayerPlatform] = [.iOS, .macOS]
    var allPlatformsPassed = true
    
    for platform in platforms {
        // Set the test platform for this test case
        RuntimeCapabilityDetection.setTestPlatform(platform)
        
        let passed = hasAccessibilityIdentifierWithPattern(
            view,
            expectedPattern: expectedPattern,
            platform: platform,
            componentName: "\(componentName)-\(platform)"
        )
        
        if !passed {
            print("❌ CROSS-PLATFORM: \(testName) failed on \(platform)")
            allPlatformsPassed = false
        } else {
            print("✅ CROSS-PLATFORM: \(testName) passed on \(platform)")
        }
        
        // Clean up test platform
        RuntimeCapabilityDetection.setTestPlatform(nil)
    }
    
    return allPlatformsPassed
}

/// Test accessibility identifiers on a single platform (for representative sampling)
/// - Parameters:
///   - view: The SwiftUI view to test
///   - expectedPattern: The regex pattern to match against (use * for wildcards)
///   - platform: The platform to test on
///   - componentName: Name of the component being tested (for debugging)
/// - Returns: True if the view generates correct accessibility identifiers on the specified platform
@MainActor
public func testAccessibilityIdentifiersSinglePlatform<T: View>(
    _ view: T,
    expectedPattern: String,
    platform: SixLayerPlatform,
    componentName: String
) -> Bool {
    // Set the test platform for this test case
    RuntimeCapabilityDetection.setTestPlatform(platform)
    
    let result = hasAccessibilityIdentifierWithPattern(
        view,
        expectedPattern: expectedPattern,
        platform: platform,
        componentName: componentName
    )
    
    // Clean up test platform
    RuntimeCapabilityDetection.setTestPlatform(nil)
    
    return result
}
