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
import Foundation

// MARK: - Config Observer Helper

/// Helper class to observe AccessibilityIdentifierConfig changes so modifiers re-execute
@MainActor
private class ConfigObserver: ObservableObject {
    static let shared = ConfigObserver()
    
    private init() {
        // Observe the shared config's enableDebugLogging changes
        AccessibilityIdentifierConfig.shared.$enableDebugLogging
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
    
    private var cancellables = Set<AnyCancellable>()
}

import Combine

// MARK: - Automatic Accessibility Identifier Modifier

/// Modifier that automatically generates accessibility identifiers for views
/// This is the core modifier that all framework components should use
public struct AutomaticAccessibilityIdentifiersModifier: ViewModifier {
    @Environment(\.accessibilityIdentifierName) private var accessibilityIdentifierName
    @Environment(\.accessibilityIdentifierElementType) private var accessibilityIdentifierElementType
    @Environment(\.globalAutomaticAccessibilityIdentifiers) private var globalAutomaticAccessibilityIdentifiers
    @Environment(\.accessibilityIdentifierConfig) private var injectedConfig
    @ObservedObject private var configObserver = ConfigObserver.shared

    public func body(content: Content) -> some View {
        // Use injected config from environment (for testing), fall back to shared (for production)
        let config = injectedConfig ?? AccessibilityIdentifierConfig.shared
        // config.enableAutoIDs IS the global setting - it's the single source of truth
        // The environment variable allows local opt-in when global is off (defaults to false)
        // Logic: global on → on, global off + local enable (env=true) → on, global off + no enable (env=false) → off
        let shouldApply = config.enableAutoIDs || globalAutomaticAccessibilityIdentifiers
        
        // Always check debug logging and print immediately (helps verify modifier is being called)
        if config.enableDebugLogging {
            let debugMsg = "🔍 MODIFIER DEBUG: body() called - enableAutoIDs=\(config.enableAutoIDs), globalAutomaticAccessibilityIdentifiers=\(globalAutomaticAccessibilityIdentifiers), shouldApply=\(shouldApply)"
            print(debugMsg)
            fflush(stdout) // Ensure output appears immediately
            config.addDebugLogEntry(debugMsg)
        }
        
        if shouldApply {
            let identifier = generateIdentifier()
            if config.enableDebugLogging {
                let debugMsg = "🔍 MODIFIER DEBUG: Applying identifier '\(identifier)' to view"
                print(debugMsg)
                config.addDebugLogEntry(debugMsg)
            }
            return AnyView(content.accessibilityIdentifier(identifier))
        } else {
            if config.enableDebugLogging {
                let debugMsg = "🔍 MODIFIER DEBUG: NOT applying identifier - conditions not met"
                print(debugMsg)
                config.addDebugLogEntry(debugMsg)
            }
            return AnyView(content)
        }
    }
    
    @MainActor
    private func generateIdentifier() -> String {
        // Use injected config from environment (for testing), fall back to shared (for production)
        let config = injectedConfig ?? AccessibilityIdentifierConfig.shared
        
        // Get configured values (empty means skip entirely - no framework forcing)
        let namespace = config.namespace.isEmpty ? nil : config.namespace
        let prefix = config.globalPrefix.isEmpty ? nil : config.globalPrefix
        
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
        
        // Build identifier components in order: namespace.prefix.main.ui.element...
        // Skip empty values entirely - framework should work with developers, not against them
        var identifierComponents: [String] = []
        
        // Add namespace first (top-level organizer)
        if let namespace = namespace {
            identifierComponents.append(namespace)
        }
        
        // Add prefix second (feature/view organizer within namespace)
        // Allow duplication: Foo.Foo.main.ui for main view, Foo.Bar.main.ui for other views
        if let prefix = prefix {
            identifierComponents.append(prefix)
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
        
        // Debug logging - both print to console AND add to debug log
        if config.enableDebugLogging {
            let debugLines = [
                "🔍 ACCESSIBILITY DEBUG: Generated identifier '\(identifier)'",
                "   - prefix: '\(String(describing: prefix))'",
                "   - namespace: '\(String(describing: namespace))' (included: \(namespace != nil && prefix != nil && namespace != prefix))",
                "   - screenContext: '\(screenContext)'",
                "   - viewHierarchyPath: '\(viewHierarchyPath)'",
                "   - componentName: '\(componentName)'",
                "   - elementType: '\(elementType)'",
                "   - includeComponentNames: \(config.includeComponentNames)",
                "   - includeElementTypes: \(config.includeElementTypes)"
            ]
            for line in debugLines {
                print(line)
                fflush(stdout) // Ensure output appears immediately
                config.addDebugLogEntry(line)
            }
            
            // Also add a concise summary entry
            let summaryEntry = "Generated identifier '\(identifier)' for component: '\(componentName)' role: '\(elementType)' context: '\(viewHierarchyPath)'"
            config.addDebugLogEntry(summaryEntry)
        }
        
        return identifier
    }
}

// MARK: - Named Automatic Accessibility Identifiers Modifier

/// Modifier that applies automatic accessibility identifiers with a specific component name
/// This is used by the .automaticAccessibilityIdentifiers(named:) helper
public struct NamedAutomaticAccessibilityIdentifiersModifier: ViewModifier {
    let componentName: String
    @Environment(\.accessibilityIdentifierConfig) private var injectedConfig
    @ObservedObject private var configObserver = ConfigObserver.shared
    
    public func body(content: Content) -> some View {
        // Use injected config from environment (for testing), fall back to shared (for production)
        let config = injectedConfig ?? AccessibilityIdentifierConfig.shared
        let shouldApply = config.enableAutoIDs
        
        if shouldApply {
            let identifier = generateIdentifier()
            return AnyView(content.accessibilityIdentifier(identifier))
        } else {
            return AnyView(content)
        }
    }
    
    @MainActor
    private func generateIdentifier() -> String {
        let config = injectedConfig ?? AccessibilityIdentifierConfig.shared
        
        let namespace = config.namespace.isEmpty ? nil : config.namespace
        let prefix = config.globalPrefix.isEmpty ? nil : config.globalPrefix
        
        let screenContext: String
        let viewHierarchyPath: String
        if config.enableUITestIntegration {
            screenContext = "main"
            viewHierarchyPath = "ui"
        } else {
            screenContext = config.currentScreenContext ?? "main"
            viewHierarchyPath = config.currentViewHierarchy.isEmpty ? "ui" : config.currentViewHierarchy.joined(separator: ".")
        }
        
        var identifierComponents: [String] = []
        
        if let namespace = namespace {
            identifierComponents.append(namespace)
        }
        
        if let prefix = prefix {
            identifierComponents.append(prefix)
        }
        
        identifierComponents.append(screenContext)
        identifierComponents.append(viewHierarchyPath)
        
        if config.includeComponentNames {
            identifierComponents.append(componentName)
        }
        
        if config.includeElementTypes {
            identifierComponents.append("View")
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
    @Environment(\.accessibilityIdentifierConfig) private var injectedConfig
    
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
        // Use injected config from environment (for testing), fall back to shared (for production)
        let config = injectedConfig ?? AccessibilityIdentifierConfig.shared
        
        // .named() should ALWAYS apply when explicitly called, regardless of global settings
        // This is an explicit modifier call - user intent is clear
        
        if config.enableDebugLogging {
            print("🔍 NAMED MODIFIER DEBUG: Generating identifier for explicit name (applies regardless of global settings)")
        }
        
        // Get configured values (empty means skip entirely - no framework forcing)
        let namespace = config.namespace.isEmpty ? nil : config.namespace
        let prefix = config.globalPrefix.isEmpty ? nil : config.globalPrefix
        let screenContext: String = config.enableUITestIntegration ? "main" : (config.currentScreenContext ?? "main")
        let viewHierarchyPath: String = config.enableUITestIntegration ? "ui" : (config.currentViewHierarchy.isEmpty ? "ui" : config.currentViewHierarchy.joined(separator: "."))
        
        // Build identifier components in order: namespace.prefix.main.ui.name
        var identifierComponents: [String] = []
        
        // Add namespace first (top-level organizer)
        if let namespace = namespace {
            identifierComponents.append(namespace)
        }
        
        // Add prefix second (feature/view organizer within namespace)
        // Allow duplication: Foo.Foo.main.ui for main view, Foo.Bar.main.ui for other views
        if let prefix = prefix {
            identifierComponents.append(prefix)
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
    @Environment(\.accessibilityIdentifierConfig) private var injectedConfig
    
    public func body(content: Content) -> some View {
        // Compute once
        let exactId = generateExactNamedAccessibilityIdentifier()
        // Apply exact identifier directly to content and again at outermost level to ensure override
        let inner = content.accessibilityIdentifier(exactId)
        ZStack { inner }
            .accessibilityIdentifier(exactId)
    }
    
    private func generateExactNamedAccessibilityIdentifier() -> String {
        // Use injected config from environment (for testing), fall back to shared (for production)
        let config = injectedConfig ?? AccessibilityIdentifierConfig.shared
        
        // .exactNamed() should ALWAYS apply when explicitly called, regardless of global settings
        // This is an explicit modifier call - user intent is clear
        // No guard needed - always apply when modifier is explicitly used
        
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
/// Defaults to true - automatic identifiers are enabled by default
/// config.enableAutoIDs is the global setting; this env var allows local opt-in when global is off
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

/// Environment key for injecting AccessibilityIdentifierConfig (for testing)
/// Allows tests to provide isolated config instances instead of using singleton
public struct AccessibilityIdentifierConfigKey: EnvironmentKey {
    public static let defaultValue: AccessibilityIdentifierConfig? = nil
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
    
    public var accessibilityIdentifierConfig: AccessibilityIdentifierConfig? {
        get { self[AccessibilityIdentifierConfigKey.self] }
        set { self[AccessibilityIdentifierConfigKey.self] = newValue }
    }
}

// MARK: - Forced Automatic Accessibility Identifier Modifier

/// Modifier that forces automatic accessibility identifiers regardless of global settings
/// Used for local override scenarios
public struct ForcedAutomaticAccessibilityIdentifiersModifier: ViewModifier {
    @Environment(\.accessibilityIdentifierName) private var accessibilityIdentifierName
    @Environment(\.accessibilityIdentifierElementType) private var accessibilityIdentifierElementType
    @Environment(\.accessibilityIdentifierConfig) private var injectedConfig

    public func body(content: Content) -> some View {
        // Use injected config from environment (for testing), fall back to shared (for production)
        let config = injectedConfig ?? AccessibilityIdentifierConfig.shared
        
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
        // Use injected config from environment (for testing), fall back to shared (for production)
        let config = injectedConfig ?? AccessibilityIdentifierConfig.shared
        
        // Get configured values (empty means skip entirely - no framework forcing)
        let namespace = config.namespace.isEmpty ? nil : config.namespace
        let prefix = config.globalPrefix.isEmpty ? nil : config.globalPrefix
        let screenContext: String = config.enableUITestIntegration ? "main" : (config.currentScreenContext ?? "main")
        let viewHierarchyPath: String = config.enableUITestIntegration ? "ui" : (config.currentViewHierarchy.isEmpty ? "ui" : config.currentViewHierarchy.joined(separator: "."))
        
        // Build identifier components in order: namespace.prefix.main.ui.element...
        var identifierComponents: [String] = []
        
        // Add namespace first (top-level organizer)
        if let namespace = namespace {
            identifierComponents.append(namespace)
        }
        
        // Add prefix second (feature/view organizer within namespace)
        // Allow duplication: Foo.Foo.main.ui for main view, Foo.Bar.main.ui for other views
        if let prefix = prefix {
            identifierComponents.append(prefix)
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
    
    /// Apply automatic accessibility identifiers with a specific component name
    /// Framework components should use this to set their own name for better identifier generation
    /// - Parameter componentName: The name of the component (e.g., "CoverFlowCardComponent")
    public func automaticAccessibilityIdentifiers(named componentName: String) -> some View {
        // Create a modifier that accepts the name directly
        self.modifier(NamedAutomaticAccessibilityIdentifiersModifier(componentName: componentName))
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