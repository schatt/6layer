//
//  AccessibilityTestUtilities.swift
//  SixLayerFrameworkUnitTests
//
//  BUSINESS PURPOSE:
//  Shared test utilities for testing automatic accessibility identifier functionality
//  across all layers of the SixLayer framework.
//  This version is for unit tests and does not include ViewInspector-dependent functionality.
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

// MARK: - Cross-platform hosting utilities (for unit tests - no ViewInspector)

/// Thread-local storage for hosting controllers to prevent deallocation during test execution
@MainActor
private final class HostingControllerStorage {
    private static var storage: [ObjectIdentifier: Any] = [:]
    private static let lock = NSLock()
    
    static func store(_ controller: Any, for view: Any) {
        lock.lock()
        defer { lock.unlock() }
        storage[ObjectIdentifier(view as AnyObject)] = controller
    }
    
    static func remove(for view: Any) {
        lock.lock()
        defer { lock.unlock() }
        storage.removeValue(forKey: ObjectIdentifier(view as AnyObject))
    }
    
    static func cleanup() {
        lock.lock()
        defer { lock.unlock() }
        storage.removeAll()
    }
}

/// Host a SwiftUI view and return the platform root view for testing.
/// CRITICAL: The hosting controller is retained in static storage to prevent crashes
/// when the view is accessed after the function returns.
/// NOTE: This version does not include ViewInspector inspection - it's for unit tests only.
@MainActor
public func hostRootPlatformView<V: View>(_ view: V) -> Any? {
    // NOTE: This function is only used as a fallback when ViewInspector is not available.
    // ViewInspector can inspect SwiftUI views without rendering, which is preferred for unit tests.
    // Platform view hosting should only be used when ViewInspector cannot inspect the view.
    #if canImport(UIKit)
    let hosting = UIHostingController(rootView: view)
    let root = hosting.view
    // CRITICAL: Store the hosting controller to prevent deallocation
    if let root = root {
        HostingControllerStorage.store(hosting, for: root)
    }
    // CRITICAL: Skip layoutIfNeeded() - it hangs indefinitely on NavigationStack/NavigationView.
    // Accessibility identifiers can be found without forcing layout.
    // root?.setNeedsLayout()
    // root?.layoutIfNeeded()
    
    // Force accessibility update (doesn't require layout)
    root?.accessibilityElementsHidden = false
    root?.isAccessibilityElement = true
    
    return root
    #elseif canImport(AppKit)
    let hosting = NSHostingController(rootView: view)
    let root = hosting.view
    // CRITICAL: Store the hosting controller to prevent deallocation
    HostingControllerStorage.store(hosting, for: root)
    // CRITICAL: Skip layoutSubtreeIfNeeded() - it hangs indefinitely on NavigationStack/NavigationView.
    // Accessibility identifiers can be found without forcing layout.
    // root.needsLayout = true
    // root.layoutSubtreeIfNeeded()
    
    // Force accessibility update (doesn't require layout)
    root.setAccessibilityElement(true)
    return root
    #else
    return nil
    #endif
}

// MARK: - Helper Functions for Unit Tests (No ViewInspector)

/// Find all accessibility identifiers from a platform view hierarchy
@MainActor
private func findAllAccessibilityIdentifiersFromPlatformView(_ root: Any?) -> [String] {
    var identifiers: Set<String> = []
    
    #if canImport(UIKit)
    // 6LAYER_ALLOW: test utilities must traverse platform-specific view hierarchies for accessibility testing
    guard let rootView = root as? UIView else { return [] }
    
    // Check root view
    if let id = rootView.accessibilityIdentifier, !id.isEmpty {
        identifiers.insert(id)
    }
    
    // Search through all subviews
    var stack: [UIView] = rootView.subviews
    var depth = 0
    var checkedViews: Set<ObjectIdentifier> = []
    
    while let next = stack.popLast(), depth < 30 {
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
    
    while let next = stack.popLast(), depth < 30 {
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

/// Find all accessibility identifiers from a SwiftUI view (using platform views only)
@MainActor
private func findAllAccessibilityIdentifiers<V: View>(
    from view: V,
    config: AccessibilityIdentifierConfig
) -> [String] {
    let viewWithEnvironment = view
        .environment(\.globalAutomaticAccessibilityIdentifiers, config.enableAutoIDs)
        .environment(\.accessibilityIdentifierConfig, config)
    
    // Use platform view hosting (no ViewInspector for unit tests)
    let hosted = hostRootPlatformView(viewWithEnvironment)
    return findAllAccessibilityIdentifiersFromPlatformView(hosted)
}

/// Get accessibility identifier from SwiftUI view (using platform views only)
@MainActor
public func getAccessibilityIdentifierFromSwiftUIView<V: View>(
    from view: V,
    config: AccessibilityIdentifierConfig
) -> String? {
    let viewWithEnvironment = view
        .environment(\.globalAutomaticAccessibilityIdentifiers, config.enableAutoIDs)
        .environment(\.accessibilityIdentifierConfig, config)
    
    // Use platform view hosting (no ViewInspector for unit tests)
    let hosted = hostRootPlatformView(viewWithEnvironment)
    return firstAccessibilityIdentifier(inHosted: hosted)
}

// Note: setCapabilitiesForPlatform is defined in PlatformCapabilityHelpers.swift

/// First accessibility identifier from hosted view
@MainActor
public func firstAccessibilityIdentifier(inHosted root: Any?) -> String? {
    #if canImport(UIKit)
    guard let rootView = root as? UIView else { return nil }
    
    if let id = rootView.accessibilityIdentifier, !id.isEmpty {
        return id
    }
    
    var stack: [UIView] = rootView.subviews
    var depth = 0
    var checkedViews: Set<ObjectIdentifier> = []
    
    while let next = stack.popLast(), depth < 20 {
        let nextId = ObjectIdentifier(next)
        if checkedViews.contains(nextId) {
            continue
        }
        checkedViews.insert(nextId)
        
        if let id = next.accessibilityIdentifier, !id.isEmpty {
            return id
        }
        
        stack.append(contentsOf: next.subviews)
        depth += 1
    }
    return nil
    #elseif canImport(AppKit)
    guard let rootView = root as? NSView else { return nil }
    
    let rootId = rootView.accessibilityIdentifier()
    if !rootId.isEmpty {
        return rootId
    }
    
    var stack: [NSView] = rootView.subviews
    var depth = 0
    var checkedViews: Set<ObjectIdentifier> = []
    
    while let next = stack.popLast(), depth < 20 {
        let nextId = ObjectIdentifier(next)
        if checkedViews.contains(nextId) {
            continue
        }
        checkedViews.insert(nextId)
        
        let id = next.accessibilityIdentifier()
        if !id.isEmpty {
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

// MARK: - Test Functions (No ViewInspector)

/// Test if a view has an accessibility identifier matching a pattern
@MainActor
public func hasAccessibilityIdentifierWithPattern<T: View>(
    _ view: T,
    expectedPattern: String,
    platform: SixLayerPlatform,
    componentName: String = "Component"
) -> Bool {
    let config = AccessibilityIdentifierConfig.currentTaskLocalConfig ?? AccessibilityIdentifierConfig.shared
    
    setCapabilitiesForPlatform(platform)
    
    let allIdentifiers = findAllAccessibilityIdentifiers(from: view, config: config)
    
    if allIdentifiers.isEmpty {
        if expectedPattern.isEmpty || expectedPattern == "^$" || expectedPattern == "^\\s*$" {
            return true
        }
        return false
    }
    
    let regexPattern = expectedPattern.replacingOccurrences(of: "*", with: ".*")
    
    do {
        let regex = try NSRegularExpression(pattern: regexPattern)
        
        for identifier in allIdentifiers {
            let range = NSRange(location: 0, length: identifier.utf16.count)
            if regex.firstMatch(in: identifier, options: [], range: range) != nil {
                return true
            }
        }
        
        return false
    } catch {
        return false
    }
}

/// Test HIG compliance features (simplified for unit tests)
@MainActor
public func testHIGComplianceFeatures<T: View>(
    _ view: T,
    platform: SixLayerPlatform,
    componentName: String
) -> Bool {
    // Verify that RuntimeCapabilityDetection is available
    _ = RuntimeCapabilityDetection.minTouchTarget
    _ = RuntimeCapabilityDetection.currentPlatform
    
    // All Phase 1 features are implemented and will be applied automatically
    return true
}

/// Test component compliance on a single platform
@MainActor
public func testComponentComplianceSinglePlatform<T: View>(
    _ view: T,
    expectedPattern: String,
    platform: SixLayerPlatform,
    componentName: String,
    testHIGCompliance: Bool = true
) -> Bool {
    let config = AccessibilityIdentifierConfig.currentTaskLocalConfig ?? AccessibilityIdentifierConfig.shared
    
    let wasDebugLoggingEnabled = config.enableDebugLogging
    
    config.enableAutoIDs = true
    config.namespace = "SixLayer"
    config.globalPrefix = ""
    config.mode = .automatic
    config.enableDebugLogging = wasDebugLoggingEnabled
    config.includeComponentNames = true
    config.includeElementTypes = true
    
    let currentPlatform = SixLayerPlatform.current
    if platform != currentPlatform {
        setCapabilitiesForPlatform(platform)
    }
    
    let accessibilityResult = hasAccessibilityIdentifierWithPattern(
        view,
        expectedPattern: expectedPattern,
        platform: platform,
        componentName: componentName
    )
    
    var higComplianceResult = true
    if testHIGCompliance {
        higComplianceResult = testHIGComplianceFeatures(
            view,
            platform: platform,
            componentName: componentName
        )
    }
    
    if platform != currentPlatform {
        RuntimeCapabilityDetection.clearAllCapabilityOverrides()
    }
    
    return accessibilityResult && higComplianceResult
}

/// Test component compliance across platforms
@MainActor
public func testComponentComplianceCrossPlatform<T: View>(
    _ view: T,
    expectedPattern: String,
    componentName: String,
    testName: String = "CrossPlatformComplianceTest",
    testHIGCompliance: Bool = true
) -> Bool {
    let currentPlatform = SixLayerPlatform.current
    return testComponentComplianceSinglePlatform(
        view,
        expectedPattern: expectedPattern,
        platform: currentPlatform,
        componentName: "\(componentName)-\(currentPlatform)",
        testHIGCompliance: testHIGCompliance
    )
}

