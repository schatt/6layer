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
        let config = AccessibilityIdentifierConfig.shared
        // config.enableAutoIDs IS the global setting - it's the single source of truth
        // The environment variable allows local opt-in when global is off (defaults to false)
        // Logic: global on → on, global off + local enable (env=true) → on, global off + no enable (env=false) → off
        let shouldApply = config.enableAutoIDs || globalAutomaticAccessibilityIdentifiers
        
        if config.enableDebugLogging {
            print("🔍 MODIFIER DEBUG: enableAutoIDs=\(config.enableAutoIDs), globalAutomaticAccessibilityIdentifiers=\(globalAutomaticAccessibilityIdentifiers), shouldApply=\(shouldApply)")
        }
        
        if shouldApply {
            let identifier = generateIdentifier()
            if config.enableDebugLogging {
                print("🔍 MODIFIER DEBUG: Applying identifier '\(identifier)' to view")
            }
            return AnyView(content.accessibilityIdentifier(identifier))
        } else {
            if config.enableDebugLogging {
                print("🔍 MODIFIER DEBUG: NOT applying identifier - conditions not met")
            }
            return AnyView(content)
        }
    }
    
    @MainActor
    private func generateIdentifier() -> String {
        let config = AccessibilityIdentifierConfig.shared
        
        // Use the configured global prefix
        let prefix = config.globalPrefix.isEmpty ? "SixLayer" : config.globalPrefix
        
        // Use the configured namespace (avoid duplication with prefix)
        let namespace = config.namespace.isEmpty ? "main" : config.namespace
        
        // Use simplified context in UI test integration to stabilize patterns
        let screenContext: String
        let viewHierarchyPath: String
        if config.enableUITestIntegration {
            screenContext = "main"
            viewHierarchyPath = "ui"
        } else {
            screenContext = config.currentScreenContext ?? "main"
            viewHierarchyPath = config.currentViewHierarchy.isEmpty ? "ui" : config.currentViewHierarchy.joined(separator: ".")
        }
        
        // Determine component name
        let componentName = accessibilityIdentifierName ?? "element"
        
        // Determine element type
        let elementType = accessibilityIdentifierElementType ?? "View" // Default to "View" if not specified
        
        // Build identifier components, avoiding duplication
        var identifierComponents: [String] = []
        
        // Add prefix
        identifierComponents.append(prefix)
        
        // Add namespace only if it's different from prefix (to avoid duplication)
        // Rationale: If a developer wants both prefix and namespace in the ID, they should set them to different values.
        // Duplicating "SixLayer.SixLayer" serves no semantic purpose and creates unnecessarily long IDs.
        // The comment about "UI test integration" was incorrect - it was causing duplicates in test output.
        if namespace != prefix {
            identifierComponents.append(namespace)
        }
        
        // Add screen context
        identifierComponents.append(screenContext)
        
        // Add view hierarchy path
        identifierComponents.append(viewHierarchyPath)
        
        if config.includeComponentNames {
            identifierComponents.append(componentName)
        }
        
        if config.includeElementTypes {
            identifierComponents.append(elementType)
        }
        
        let identifier = identifierComponents.joined(separator: ".")
        
        // Debug logging
        if config.enableDebugLogging {
            print("🔍 ACCESSIBILITY DEBUG: Generated identifier '\(identifier)'")
            print("   - prefix: '\(prefix)'")
            print("   - namespace: '\(namespace)' (included: \(namespace != prefix))")
            print("   - screenContext: '\(screenContext)'")
            print("   - viewHierarchyPath: '\(viewHierarchyPath)'")
            print("   - componentName: '\(componentName)'")
            print("   - elementType: '\(elementType)'")
            print("   - includeComponentNames: \(config.includeComponentNames)")
            print("   - includeElementTypes: \(config.includeElementTypes)")
        }
        
        return identifier
    }
}

// MARK: - Named Component Modifier

/// Modifier that allows components to be named for more specific accessibility identifiers
public struct NamedModifier: ViewModifier {
    let name: String
    @Environment(\.globalAutomaticAccessibilityIdentifiers) private var globalEnabled
    @Environment(\.accessibilityIdentifierPrefix) private var prefix
    
    public func body(content: Content) -> some View {
        // Compute once
        let newId = generateNamedAccessibilityIdentifier()
        // Apply identifier directly to content and again at outermost level to ensure override
        let inner = content
            .environment(\.accessibilityIdentifierName, name)
            .accessibilityIdentifier(newId)
        ZStack { inner }
            .accessibilityIdentifier(newId)
    }
    
    private func generateNamedAccessibilityIdentifier() -> String {
        let config = AccessibilityIdentifierConfig.shared
        
        if config.enableDebugLogging {
            print("🔍 NAMED MODIFIER DEBUG: Generating identifier for explicit name (ignoring global settings)")
        }
        
        let prefix = config.globalPrefix.isEmpty ? "SixLayer" : config.globalPrefix
        let namespace = config.namespace.isEmpty ? "SixLayer" : config.namespace
        let screenContext: String = config.enableUITestIntegration ? "main" : (config.currentScreenContext ?? "main")
        let viewHierarchyPath: String = config.enableUITestIntegration ? "ui" : (config.currentViewHierarchy.isEmpty ? "ui" : config.currentViewHierarchy.joined(separator: "."))
        
        // Build identifier components, avoiding duplication
        var identifierComponents: [String] = []
        
        // Add prefix
        identifierComponents.append(prefix)
        
        // Add namespace only if it's different from prefix
        if namespace != prefix {
            identifierComponents.append(namespace)
        }
        
        // Add screen context
        identifierComponents.append(screenContext)
        
        // Add view hierarchy path
        identifierComponents.append(viewHierarchyPath)
        
        // Add the actual name that was passed to the modifier
        identifierComponents.append(name)
        
        let identifier = identifierComponents.joined(separator: ".")
        
        // Debug logging
        if config.enableDebugLogging {
            print("🔍 NAMED MODIFIER DEBUG: Generated identifier '\(identifier)' for name '\(name)'")
        }
        
        return identifier
    }
}

// MARK: - Exact Named Component Modifier

/// Modifier that applies exact accessibility identifiers without framework additions
/// GREEN PHASE: Produces truly minimal identifiers - just the exact name provided
public struct ExactNamedModifier: ViewModifier {
    let name: String
    @Environment(\.globalAutomaticAccessibilityIdentifiers) private var globalEnabled
    
    public func body(content: Content) -> some View {
        // Compute once
        let exactId = generateExactNamedAccessibilityIdentifier()
        // Apply exact identifier directly to content and again at outermost level to ensure override
        let inner = content.accessibilityIdentifier(exactId)
        ZStack { inner }
            .accessibilityIdentifier(exactId)
    }
    
    private func generateExactNamedAccessibilityIdentifier() -> String {
        guard globalEnabled else { return "" }
        
        let config = AccessibilityIdentifierConfig.shared
        guard config.enableAutoIDs else { return "" }  // ← Add this check
        
        // GREEN PHASE: Return ONLY the exact name - no framework additions
        let exactIdentifier = name
        
        // Debug logging
        if config.enableDebugLogging {
            print("🔍 EXACT NAMED MODIFIER DEBUG: Generated exact identifier '\(exactIdentifier)' for name '\(name)'")
        }
        
        return exactIdentifier
    }
}

// MARK: - Environment Keys

/// Environment key for enabling automatic accessibility identifiers locally (when global is off)
/// Defaults to false - only set to true via .enableGlobalAutomaticAccessibilityIdentifiers() for local opt-in
/// config.enableAutoIDs is the global setting; this env var only matters when global is off
public struct GlobalAutomaticAccessibilityIdentifiersKey: EnvironmentKey {
    public static let defaultValue: Bool = false
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

// MARK: - Forced Automatic Accessibility Identifier Modifier

/// Modifier that forces automatic accessibility identifiers regardless of global settings
/// Used for local override scenarios
public struct ForcedAutomaticAccessibilityIdentifiersModifier: ViewModifier {
    @Environment(\.accessibilityIdentifierName) private var accessibilityIdentifierName
    @Environment(\.accessibilityIdentifierElementType) private var accessibilityIdentifierElementType

    public func body(content: Content) -> some View {
        let config = AccessibilityIdentifierConfig.shared
        
        if config.enableDebugLogging {
            print("🔍 FORCED MODIFIER DEBUG: Always applying identifier (local override)")
            print("🔍 FORCED MODIFIER DEBUG: accessibilityIdentifierName = '\(accessibilityIdentifierName ?? "nil")'")
            print("🔍 FORCED MODIFIER DEBUG: accessibilityIdentifierElementType = '\(accessibilityIdentifierElementType ?? "nil")'")
        }
        
        let identifier = generateIdentifier()
        if config.enableDebugLogging {
            print("🔍 FORCED MODIFIER DEBUG: Applying identifier '\(identifier)' to view")
        }
        
        return AnyView(content.accessibilityIdentifier(identifier))
    }
    
    private func generateIdentifier() -> String {
        let config = AccessibilityIdentifierConfig.shared
        let prefix = config.globalPrefix.isEmpty ? "SixLayer" : config.globalPrefix
        let namespace = config.namespace.isEmpty ? "SixLayer" : config.namespace
        let screenContext: String = config.enableUITestIntegration ? "main" : (config.currentScreenContext ?? "main")
        let viewHierarchyPath: String = config.enableUITestIntegration ? "ui" : (config.currentViewHierarchy.isEmpty ? "ui" : config.currentViewHierarchy.joined(separator: "."))
        
        // Build identifier components, avoiding duplication
        var identifierComponents: [String] = []
        
        // Add prefix
        identifierComponents.append(prefix)
        
        // Add namespace only if it's different from prefix (to avoid duplication)
        // Rationale: If a developer wants both prefix and namespace in the ID, they should set them to different values.
        // Duplicating "SixLayer.SixLayer" serves no semantic purpose and creates unnecessarily long IDs.
        // The comment about "UI test integration" was incorrect - it was causing duplicates in test output.
        if namespace != prefix {
            identifierComponents.append(namespace)
        }
        
        // Add screen context
        identifierComponents.append(screenContext)
        
        // Add view hierarchy path
        identifierComponents.append(viewHierarchyPath)
        
        // Add element type if available
        if let elementType = accessibilityIdentifierElementType {
            identifierComponents.append(elementType)
        }
        
        // Add name if available
        if let name = accessibilityIdentifierName {
            identifierComponents.append(name)
        }
        
        return identifierComponents.joined(separator: ".")
    }
}

// MARK: - Disable Automatic Accessibility Identifier Modifier

/// Modifier that prevents automatic accessibility identifiers from being applied
/// Used for local disable scenarios
public struct DisableAutomaticAccessibilityIdentifiersModifier: ViewModifier {
    public func body(content: Content) -> some View {
        // This modifier doesn't apply any accessibility identifier
        // It just passes through the content unchanged
        content
    }
}

// MARK: - View Extensions

extension View {
    /// Apply automatic accessibility identifiers to a view
    /// This is the primary modifier that all framework components should use
    /// Respects global and environment settings (no forced override)
    public func automaticAccessibilityIdentifiers() -> some View {
        self.modifier(AutomaticAccessibilityIdentifiersModifier())
    }
    
    /// Enable automatic accessibility identifiers locally (for custom views when global is off)
    /// Sets the environment variable to true, then applies the modifier
    public func enableGlobalAutomaticAccessibilityIdentifiers() -> some View {
        self
            .environment(\.globalAutomaticAccessibilityIdentifiers, true)
            .automaticAccessibilityIdentifiers()
    }
    
    /// Disable automatic accessibility identifiers
    /// This is provided for backward compatibility with tests
    public func disableAutomaticAccessibilityIdentifiers() -> some View {
        self.modifier(DisableAutomaticAccessibilityIdentifiersModifier())
    }
    
    /// Apply a named accessibility identifier to a view
    /// This allows for more specific component identification
    public func named(_ name: String) -> some View {
        self.modifier(NamedModifier(name: name))
    }
    
    /// Apply an exact named accessibility identifier to a view
    /// GREEN PHASE: Produces truly minimal identifiers without framework additions
    public func exactNamed(_ name: String) -> some View {
        self.modifier(ExactNamedModifier(name: name))
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
    func automaticAccessibilityIdentifierModifier() -> some View {
        self.modifier(AutomaticAccessibilityIdentifierModifier())
    }
}