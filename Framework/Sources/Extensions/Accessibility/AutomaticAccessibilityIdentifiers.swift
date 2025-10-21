//
//  AutomaticAccessibilityIdentifiers.swift
//  SixLayerFramework
//
//  BUSINESS PURPOSE:
//  Provides automatic accessibility identifier generation for all framework components
//  to ensure comprehensive accessibility testing and compliance.
//
//  FEATURES:
//  - Automatic accessibility identifier generation
//  - Named component support
//  - Pattern-based identifier generation
//  - Cross-platform compatibility
//

import SwiftUI

// MARK: - Automatic Accessibility Identifier Modifier

/// Modifier that automatically generates accessibility identifiers for views
/// This is the core modifier that all framework components should use
public struct AutomaticAccessibilityIdentifiersModifier: ViewModifier {
    @Environment(\.accessibilityIdentifierName) private var accessibilityIdentifierName
    @Environment(\.accessibilityIdentifierElementType) private var accessibilityIdentifierElementType
    @Environment(\.globalAutomaticAccessibilityIdentifiers) private var globalAutomaticAccessibilityIdentifiers

    public func body(content: Content) -> some View {
        if AccessibilityIdentifierConfig.shared.enableAutoIDs && globalAutomaticAccessibilityIdentifiers {
            content
                .accessibilityIdentifier(generateIdentifier())
        } else {
            content
        }
    }
    
    @MainActor
    private func generateIdentifier() -> String {
        let config = AccessibilityIdentifierConfig.shared
        
        // Use the configured global prefix
        let prefix = config.globalPrefix.isEmpty ? "SixLayer" : config.globalPrefix
        
        // Use the configured namespace (legacy support, can be same as prefix)
        let namespace = config.namespace.isEmpty ? "main" : config.namespace
        
        // Use the current screen context from config
        let screenContext = config.currentScreenContext ?? "main"
        
        // Build the view hierarchy path
        let viewHierarchyPath = config.currentViewHierarchy.isEmpty ? "ui" : config.currentViewHierarchy.joined(separator: ".")
        
        // Determine component name
        let componentName = accessibilityIdentifierName ?? "element"
        
        // Determine element type
        let elementType = accessibilityIdentifierElementType ?? "View" // Default to "View" if not specified
        
        var identifierComponents: [String] = [prefix, namespace, screenContext, viewHierarchyPath]
        
        if config.includeComponentNames {
            identifierComponents.append(componentName)
        }
        
        if config.includeElementTypes {
            identifierComponents.append(elementType)
        }
        
        return identifierComponents.joined(separator: ".")
    }
}

// MARK: - Named Component Modifier

/// Modifier that allows components to be named for more specific accessibility identifiers
public struct NamedModifier: ViewModifier {
    let name: String
    @Environment(\.globalAutomaticAccessibilityIdentifiers) private var globalEnabled
    @Environment(\.accessibilityIdentifierPrefix) private var prefix
    
    public func body(content: Content) -> some View {
        content
            .accessibilityIdentifier(generateNamedAccessibilityIdentifier())
    }
    
    private func generateNamedAccessibilityIdentifier() -> String {
        guard globalEnabled else { return "" }
        
        let basePrefix = prefix ?? "SixLayer"
        let componentName = "main"
        let elementType = "element"
        let uniqueId = UUID().uuidString.prefix(8)
        
        return "\(basePrefix).\(componentName).\(elementType).\(uniqueId)"
    }
}

// MARK: - Environment Keys

/// Environment key for enabling/disabling automatic accessibility identifiers globally
public struct GlobalAutomaticAccessibilityIdentifiersKey: EnvironmentKey {
    public static let defaultValue: Bool = true
}

/// Environment key for setting the accessibility identifier prefix
public struct AccessibilityIdentifierPrefixKey: EnvironmentKey {
    public static let defaultValue: String? = nil
}

/// Environment key for accessibility identifier name hint
public struct AccessibilityIdentifierNameKey: EnvironmentKey {
    public static let defaultValue: String? = nil
}

/// Environment key for accessibility identifier element type hint
public struct AccessibilityIdentifierElementTypeKey: EnvironmentKey {
    public static let defaultValue: String? = nil
}

// MARK: - Environment Extensions

extension EnvironmentValues {
    public var globalAutomaticAccessibilityIdentifiers: Bool {
        get { self[GlobalAutomaticAccessibilityIdentifiersKey.self] }
        set { self[GlobalAutomaticAccessibilityIdentifiersKey.self] = newValue }
    }
    
    public var accessibilityIdentifierPrefix: String? {
        get { self[AccessibilityIdentifierPrefixKey.self] }
        set { self[AccessibilityIdentifierPrefixKey.self] = newValue }
    }
    
    public var accessibilityIdentifierName: String? {
        get { self[AccessibilityIdentifierNameKey.self] }
        set { self[AccessibilityIdentifierNameKey.self] = newValue }
    }
    
    public var accessibilityIdentifierElementType: String? {
        get { self[AccessibilityIdentifierElementTypeKey.self] }
        set { self[AccessibilityIdentifierElementTypeKey.self] = newValue }
    }
}

// MARK: - View Extensions

extension View {
    /// Apply automatic accessibility identifiers to a view
    /// This is the primary modifier that all framework components should use
    public func automaticAccessibilityIdentifiers() -> some View {
        self.modifier(AutomaticAccessibilityIdentifiersModifier())
    }
    
    /// Enable global automatic accessibility identifiers (alias for automaticAccessibilityIdentifiers)
    /// This is provided for backward compatibility with tests
    public func enableGlobalAutomaticAccessibilityIdentifiers() -> some View {
        self.automaticAccessibilityIdentifiers()
    }
    
    /// Disable automatic accessibility identifiers
    /// This is provided for backward compatibility with tests
    public func disableAutomaticAccessibilityIdentifiers() -> some View {
        self.environment(\.globalAutomaticAccessibilityIdentifiers, false)
    }
    
    /// Apply a named accessibility identifier to a view
    /// This allows for more specific component identification
    public func named(_ name: String) -> some View {
        self.modifier(NamedModifier(name: name))
    }
    
    /// Apply an exact named accessibility identifier to a view
    /// TDD RED PHASE: This is a stub implementation for testing
    public func exactNamed(_ name: String) -> some View {
        self.modifier(NamedModifier(name: name))
    }
}

// MARK: - Automatic Accessibility Identifier Modifier

/// Modifier that automatically applies accessibility identifiers
/// TDD RED PHASE: This is a stub implementation for testing
public struct AutomaticAccessibilityIdentifierModifier: ViewModifier {
    public init() {}
    
    public func body(content: Content) -> some View {
        content
            .automaticAccessibilityIdentifiers()
    }
}

// MARK: - View Extension for Automatic Modifier

public extension View {
    /// Apply automatic accessibility identifier modifier
    /// TDD RED PHASE: This is a stub implementation for testing
    public func automaticAccessibilityIdentifierModifier() -> some View {
        self.modifier(AutomaticAccessibilityIdentifierModifier())
    }
}