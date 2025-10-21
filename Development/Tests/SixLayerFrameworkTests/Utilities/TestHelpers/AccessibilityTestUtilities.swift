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
#if canImport(UIKit)
import UIKit
#endif
#if canImport(AppKit)
import AppKit
#endif
@testable import SixLayerFramework

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
    print("DEBUG: Created UIHostingController with root view: \(type(of: root))")
    return root
    #elseif canImport(AppKit)
    let hosting = NSHostingController(rootView: view)
    let root = hosting.view
    root.layoutSubtreeIfNeeded()
    print("DEBUG: Created NSHostingController with root view: \(type(of: root))")
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
    
    // Check root view first
    if let id = rootView.accessibilityIdentifier { 
        print("DEBUG: Found accessibility identifier on root view: '\(id)'")
        return id 
    }
    
    // Debug: Print all views and their identifiers
    print("DEBUG: Root view type: \(type(of: rootView))")
    print("DEBUG: Root view accessibility identifier: \(rootView.accessibilityIdentifier ?? "nil")")
    print("DEBUG: Root view subviews count: \(rootView.subviews.count)")
    
    // Search through all subviews
    var stack: [UIView] = rootView.subviews
    var depth = 0
    while let next = stack.popLast(), depth < 10 { // Limit depth to avoid infinite loops
        print("DEBUG: Checking view at depth \(depth): \(type(of: next))")
        print("DEBUG: View accessibility identifier: \(next.accessibilityIdentifier ?? "nil")")
        
        if let id = next.accessibilityIdentifier { 
            print("DEBUG: Found accessibility identifier on subview: '\(id)'")
            return id 
        }
        stack.append(contentsOf: next.subviews)
        depth += 1
    }
    return nil
    #elseif canImport(AppKit)
    guard let rootView = root as? NSView else { 
        print("DEBUG: Root is not an NSView")
        return nil 
    }
    
    // Check root view first
    let rootId = rootView.accessibilityIdentifier()
    print("DEBUG: Root NSView type: \(type(of: rootView))")
    print("DEBUG: Root NSView accessibility identifier: '\(rootId)'")
    print("DEBUG: Root NSView subviews count: \(rootView.subviews.count)")
    
    if rootId != nil { 
        print("DEBUG: Found accessibility identifier on root NSView: '\(rootId)'")
        return rootId 
    }
    
    // Search through all subviews
    var stack: [NSView] = rootView.subviews
    var depth = 0
    while let next = stack.popLast(), depth < 10 { // Limit depth to avoid infinite loops
        let id = next.accessibilityIdentifier()
        print("DEBUG: Checking NSView at depth \(depth): \(type(of: next))")
        print("DEBUG: NSView accessibility identifier: '\(id)'")
        
        if let id = id { 
            print("DEBUG: Found accessibility identifier on NSView subview: '\(id)'")
            return id 
        }
        stack.append(contentsOf: next.subviews)
        depth += 1
    }
    return nil
    #else
    return nil
    #endif
}

/// Convenience: Return the first non-empty accessibilityIdentifier from a SwiftUI view
/// after enabling global auto-IDs and hosting it for inspection.
@MainActor
public func getAccessibilityIdentifier<V: View>(from view: V) -> String? {
    // Ensure config is enabled for tests
    AccessibilityIdentifierConfig.shared.enableAutoIDs = true
    if AccessibilityIdentifierConfig.shared.namespace.isEmpty {
        AccessibilityIdentifierConfig.shared.namespace = "test"
    }
    // Don't wrap with global auto IDs - let the component's own modifiers work
    let root = hostRootPlatformView(view)
    return firstAccessibilityIdentifier(inHosted: root)
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
    
    // Get the actual accessibility identifier from the view
    if let actualIdentifier = getAccessibilityIdentifier(from: view) {
        // Convert pattern to regex (replace * with .*)
        let regexPattern = expectedPattern.replacingOccurrences(of: "*", with: ".*")
        do {
            let regex = try NSRegularExpression(pattern: regexPattern)
            let range = NSRange(location: 0, length: actualIdentifier.utf16.count)
            if regex.firstMatch(in: actualIdentifier, options: [], range: range) != nil {
                print("✅ DISCOVERY: \(componentName) generates CORRECT pattern match on \(platform): '\(actualIdentifier)' matches '\(expectedPattern)'")
                return true
            } else {
                print("⚠️ DISCOVERY: \(componentName) generates WRONG pattern on \(platform). Expected: '\(expectedPattern)', Got: '\(actualIdentifier)'")
                return false
            }
        } catch {
            print("❌ DISCOVERY: Error creating regex pattern '\(expectedPattern)' on \(platform): \(error)")
            return false
        }
    } else {
        // Special-case: treat nil identifier as empty string for tests explicitly expecting empty
        if expectedPattern == "^$" || expectedPattern == "^\\s*$" {
            print("✅ DISCOVERY: \(componentName) has no accessibility identifier as expected (empty) on \(platform)")
            return true
        }
        print("❌ DISCOVERY: \(componentName) generates NO accessibility identifier on \(platform) - needs .automaticAccessibility() modifier")
        return false
    }
    
    // Convert pattern to regex (replace * with .*)
    let regexPattern = expectedPattern.replacingOccurrences(of: "*", with: ".*")
    
    do {
        let regex = try NSRegularExpression(pattern: regexPattern)
        let range = NSRange(location: 0, length: actualIdentifier.utf16.count)
        
        if regex.firstMatch(in: actualIdentifier, options: [], range: range) != nil {
            print("✅ DISCOVERY: \(componentName) generates CORRECT pattern match on \(platform): '\(actualIdentifier)' matches '\(expectedPattern)'")
            return true
        } else {
            print("⚠️ DISCOVERY: \(componentName) generates WRONG pattern on \(platform). Expected: '\(expectedPattern)', Got: '\(actualIdentifier)'")
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
    
    // Get the actual accessibility identifier from the view
    guard let actualIdentifier = getAccessibilityIdentifier(from: view) else {
        print("❌ DISCOVERY: \(componentName) generates NO accessibility identifier on \(platform) - needs .automaticAccessibility() modifier")
        return false
    }
    
    // Check if it matches exactly
    if actualIdentifier == expectedIdentifier {
        print("✅ DISCOVERY: \(componentName) generates CORRECT accessibility identifier on \(platform): '\(actualIdentifier)'")
        return true
    } else {
        print("⚠️ DISCOVERY: \(componentName) generates WRONG accessibility identifier on \(platform). Expected: '\(expectedIdentifier)', Got: '\(actualIdentifier)'")
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
    // Get the actual accessibility identifier from the view
    if let actualIdentifier = getAccessibilityIdentifier(from: view) {
        // Check if it matches exactly
        if actualIdentifier == expectedIdentifier {
            print("✅ DISCOVERY: \(componentName) generates CORRECT accessibility identifier: '\(actualIdentifier)'")
            return true
        } else {
            print("⚠️ DISCOVERY: \(componentName) generates WRONG accessibility identifier. Expected: '\(expectedIdentifier)', Got: '\(actualIdentifier)'")
            return false
        }
    } else {
        // Special-case: treat nil identifier as empty string for tests explicitly expecting empty
        if expectedIdentifier.isEmpty {
            print("✅ DISCOVERY: \(componentName) has no accessibility identifier as expected (empty)")
            return true
        }
        print("❌ DISCOVERY: \(componentName) generates NO accessibility identifier - needs .automaticAccessibility() modifier")
        return false
    }
    
    // Check if it matches exactly
    if actualIdentifier == expectedIdentifier {
        print("✅ DISCOVERY: \(componentName) generates CORRECT accessibility identifier: '\(actualIdentifier)'")
        return true
    } else {
        print("⚠️ DISCOVERY: \(componentName) generates WRONG accessibility identifier. Expected: '\(expectedIdentifier)', Got: '\(actualIdentifier)'")
        return false
    }
}

/// Get the accessibility identifier from a SwiftUI view by hosting it and searching the view hierarchy
/// - Parameter view: The SwiftUI view to inspect
/// - Returns: The first accessibility identifier found, or nil if none exists
@MainActor
public func getAccessibilityIdentifier<T: View>(from view: T) -> String? {
    let hostedView = hostRootPlatformView(view)
    return firstAccessibilityIdentifier(inHosted: hostedView)
}

/// CRITICAL: Test if a view has an accessibility identifier matching a pattern
/// This function REQUIRES an expected pattern - no more generic testing!
/// 
/// - Parameters:
///   - view: The SwiftUI view to test
///   - expectedPattern: The regex pattern to match against (use * for wildcards)
///   - componentName: Name of the component being tested (for debugging)
/// - Returns: True if the view has an identifier matching the pattern
@MainActor

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
    return hasAccessibilityIdentifierWithPattern(
        view,
        expectedPattern: expectedPattern,
        platform: platform,
        componentName: componentName
    )
}
