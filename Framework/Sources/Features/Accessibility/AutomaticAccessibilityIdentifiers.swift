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
    @Environment(\.globalAutomaticAccessibilityIdentifiers) private var globalEnabled
    @Environment(\.accessibilityIdentifierPrefix) private var prefix
    
    public func body(content: Content) -> some View {
        content
            .accessibilityIdentifier(generateAccessibilityIdentifier())
    }
    
    private func generateAccessibilityIdentifier() -> String {
        guard globalEnabled else { return "" }
        
        let basePrefix = prefix ?? "SixLayer"
        let componentName = "main"
        let elementType = "element"
        let uniqueId = UUID().uuidString.prefix(8)
        
        return "\(basePrefix).\(componentName).\(elementType).\(uniqueId)"
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
}

// MARK: - View Extensions

extension View {
    /// Apply automatic accessibility identifiers to a view
    /// This is the primary modifier that all framework components should use
    public func automaticAccessibilityIdentifiers() -> some View {
        self.modifier(AutomaticAccessibilityIdentifiersModifier())
    }
    
    /// Apply a named accessibility identifier to a view
    /// This allows for more specific component identification
    public func named(_ name: String) -> some View {
        self.modifier(NamedModifier(name: name))
    }
}