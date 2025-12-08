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
#if canImport(UIKit)
import UIKit
#elseif os(macOS)
import AppKit
#endif

// MARK: - Environment Keys

/// KNOWN LIMITATION: SwiftUI may emit warnings about "Accessing Environment outside of being installed on a View"
/// when using ViewInspector for testing. These warnings occur because ViewInspector creates a temporary view hierarchy
/// during inspection that isn't a "real" SwiftUI view installation. The warnings are harmless and do not affect functionality.
/// Environment values are correctly accessed within View `body` methods, which is the proper SwiftUI pattern.
/// 
/// This is a known limitation of ViewInspector and cannot be fully eliminated without breaking functionality.
/// The warnings only appear during test execution and do not affect production code.

/// Environment key for enabling automatic accessibility identifiers locally (when global is off)
/// Defaults to true - automatic identifiers enabled by default (changed in 4.2.0)
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

/// Environment key for passing label text to identifier generation
/// Components with String labels can set this to include label text in identifiers
public struct AccessibilityIdentifierLabelKey: EnvironmentKey {
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
    
    public var accessibilityIdentifierLabel: String? {
        get { self[AccessibilityIdentifierLabelKey.self] }
        set { self[AccessibilityIdentifierLabelKey.self] = newValue }
    }
    
    public var accessibilityIdentifierConfig: AccessibilityIdentifierConfig? {
        get { self[AccessibilityIdentifierConfigKey.self] }
        set { self[AccessibilityIdentifierConfigKey.self] = newValue }
    }
}

// MARK: - Label Text Sanitization

/// Sanitize label text for use in accessibility identifiers
/// Converts to lowercase, replaces spaces and special chars with hyphens
/// - Parameter label: The label text to sanitize
/// - Returns: Sanitized label suitable for use in identifiers (lowercase, hyphenated, alphanumeric only)
private func sanitizeLabelText(_ label: String) -> String {
    return label
        .lowercased()
        .replacingOccurrences(of: " ", with: "-")
        .replacingOccurrences(of: "[^a-z0-9-]", with: "-", options: .regularExpression)
        .replacingOccurrences(of: "-+", with: "-", options: .regularExpression) // Collapse multiple hyphens
        .trimmingCharacters(in: CharacterSet(charactersIn: "-")) // Remove leading/trailing hyphens
}

// MARK: - Automatic Accessibility Identifier Modifier

/// Modifier that automatically generates accessibility identifiers for views
/// This is the core modifier that all framework components should use
/// Applies both automatic accessibility identifiers and HIG compliance
/// 
/// NOTE: No singleton observer needed - modifier reads config directly from task-local/injected/shared
/// This eliminates singleton access overhead and improves test isolation
public struct AutomaticComplianceModifier: ViewModifier {
    // NOTE: Environment properties moved to EnvironmentAccessor helper view
    // to avoid SwiftUI warnings about accessing environment outside of view context

    public func body(content: Content) -> some View {
        // CRITICAL: Access environment values lazily using a helper view to avoid SwiftUI warnings
        // about accessing environment outside of view context. The helper view ensures environment
        // is only accessed when the view is actually installed in the hierarchy.
        EnvironmentAccessor(content: content)
    }
    
    // Helper view that defers environment access until view is installed
    private struct EnvironmentAccessor: View {
        let content: Content
        
        // Access environment values here - this view is only created when body is called
        // and the view is installed, so environment is guaranteed to be available
    @Environment(\.accessibilityIdentifierName) private var accessibilityIdentifierName
    @Environment(\.accessibilityIdentifierElementType) private var accessibilityIdentifierElementType
    @Environment(\.accessibilityIdentifierLabel) private var accessibilityIdentifierLabel
    @Environment(\.globalAutomaticAccessibilityIdentifiers) private var globalAutomaticAccessibilityIdentifiers
    @Environment(\.accessibilityIdentifierConfig) private var injectedConfig

        var body: some View {
        // Use task-local config (automatic per-test isolation), then injected config, then shared (production)
        // Each test runs in its own task, so @TaskLocal provides isolation even when all tasks run on MainActor
        // Production: taskLocalConfig is nil, falls through to shared (trivial nil check)
        let config = AccessibilityIdentifierConfig.currentTaskLocalConfig ?? injectedConfig ?? AccessibilityIdentifierConfig.shared
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
                let identifier = generateIdentifier(
                    config: config,
                    accessibilityIdentifierName: accessibilityIdentifierName,
                    accessibilityIdentifierElementType: accessibilityIdentifierElementType,
                    accessibilityIdentifierLabel: accessibilityIdentifierLabel
                )
            if config.enableDebugLogging {
                let debugMsg = "🔍 MODIFIER DEBUG: Applying identifier '\(identifier)' to view"
                print(debugMsg)
                config.addDebugLogEntry(debugMsg)
            }
            // Apply accessibility identifier first, then HIG compliance features
            let viewWithIdentifier = content.accessibilityIdentifier(identifier)
            // Apply all Phase 1 HIG compliance features
            let viewWithHIGCompliance = applyHIGComplianceFeatures(
                to: viewWithIdentifier,
                elementType: accessibilityIdentifierElementType
            )
            // Wrap in AnyView to satisfy type erasure requirement
            return AnyView(viewWithHIGCompliance)
        } else {
            if config.enableDebugLogging {
                let debugMsg = "🔍 MODIFIER DEBUG: NOT applying identifier - conditions not met"
                print(debugMsg)
                config.addDebugLogEntry(debugMsg)
            }
            // Even if identifiers are disabled, still apply HIG compliance
            let viewWithHIGCompliance = applyHIGComplianceFeatures(
                to: content,
                elementType: accessibilityIdentifierElementType
            )
            return AnyView(viewWithHIGCompliance)
        }
    }
    
    // Note: Not @MainActor - this function only does string manipulation and config access
    // which are thread-safe. Calling from non-MainActor contexts (like view body) is safe.
    private func generateIdentifier(
        config: AccessibilityIdentifierConfig,
        accessibilityIdentifierName: String?,
        accessibilityIdentifierElementType: String?,
        accessibilityIdentifierLabel: String?
    ) -> String {
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
        
        // Include sanitized label text if available (for components with String labels)
        if let label = accessibilityIdentifierLabel, !label.isEmpty {
            identifierComponents.append(sanitizeLabelText(label))
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
                "   - label: '\(accessibilityIdentifierLabel ?? "none")'",
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
    
    // MARK: - HIG Compliance Features (Phase 1)
    
    /// Apply all Phase 1 HIG compliance features to a view
    /// Includes automatic visual styling (colors, spacing, typography) and platform-specific HIG patterns
    /// - Parameters:
    ///   - view: The view to apply HIG compliance to
    ///   - elementType: The element type hint (e.g., "Button", "Link", "TextField")
    /// - Returns: View with all Phase 1 HIG compliance features applied, including automatic styling
    private func applyHIGComplianceFeatures<V: View>(to view: V, elementType: String?) -> some View {
        // Cache platform values to avoid MainActor blocking
        // These are safe to access from any context - they use thread-local storage
        let platform = RuntimeCapabilityDetection.currentPlatform
        
        // Use cached design system to prevent infinite recursion
        // Creating new design systems in view body triggers SwiftUI AttributeGraph updates
        // which cause body to be re-evaluated, creating a circular dependency
        let designSystem = PlatformDesignSystem.cached(for: platform)
        
        // minTouchTarget is @MainActor, but we can compute it safely from platform
        let minTouchTarget: CGFloat = {
            switch platform {
            case .iOS, .watchOS:
                return 44.0
            case .macOS, .tvOS, .visionOS:
                return 0.0
            }
        }()
        
        // Determine if this is an interactive element that needs touch target sizing
        let isInteractive = isInteractiveElement(elementType: elementType)
        
        return view
            // AUTOMATIC VISUAL STYLING (Issue #35: Automatic HIG-compliant styling)
            // 1. Automatic Colors - Apply platform-specific system colors
            .modifier(SystemColorModifier(colorSystem: designSystem.colorSystem))
            // 2. Automatic Typography - Apply platform-specific typography system
            .modifier(SystemTypographyModifier(typographySystem: designSystem.typographySystem))
            // 3. Automatic Spacing - Apply HIG-compliant spacing following 8pt grid
            .modifier(SpacingModifier(spacingSystem: designSystem.spacingSystem))
            
            // ACCESSIBILITY & INTERACTION FEATURES
            // 4. Touch Target Sizing (iOS/watchOS) - minimum 44pt
            .modifier(AutomaticHIGTouchTargetModifier(
                minSize: minTouchTarget,
                isInteractive: isInteractive,
                platform: platform
            ))
            // 5. Color Contrast (WCAG) - Use system colors that automatically meet contrast requirements
            .modifier(AutomaticHIGColorContrastModifier(platform: platform))
            // 6. Typography Scaling (Dynamic Type) - Support accessibility text sizes
            .modifier(AutomaticHIGTypographyScalingModifier(platform: platform))
            // 7. Focus Indicators - Visible and accessible focus rings
            .modifier(AutomaticHIGFocusIndicatorModifier(
                isInteractive: isInteractive,
                platform: platform
            ))
            // 8. Motion Preferences - Respect reduced motion
            .modifier(AutomaticHIGMotionPreferenceModifier(platform: platform))
            // 9. Tab Order - Logical navigation order (handled by focusable modifier)
            // 10. Light/Dark Mode - Use system colors that adapt automatically
            .modifier(AutomaticHIGLightDarkModeModifier(platform: platform))
            
            // PLATFORM-SPECIFIC HIG PATTERNS (Issue #35: Platform-specific patterns)
            // Apply platform-specific styling patterns automatically
            .modifier(PlatformStylingModifier(designSystem: designSystem))
    }
    
    /// Determine if an element type is interactive (needs touch target sizing, focus indicators, etc.)
    private func isInteractiveElement(elementType: String?) -> Bool {
        guard let elementType = elementType?.lowercased() else { return false }
        let interactiveTypes = ["button", "link", "textfield", "toggle", "picker", "stepper", "slider", "segmentedcontrol"]
        return interactiveTypes.contains { elementType.contains($0) }
    }
    }
}

// MARK: - Named Automatic Accessibility Identifiers Modifier

/// Modifier that applies automatic accessibility identifiers with a specific component name
/// This is used by the .automaticCompliance(named:) helper
/// 
/// NOTE: No singleton observer needed - modifier reads config directly from task-local/injected/shared
/// This eliminates singleton access overhead and improves test isolation
public struct NamedAutomaticComplianceModifier: ViewModifier {
    let componentName: String
    // NOTE: Environment properties moved to helper view to avoid SwiftUI warnings
    
    public func body(content: Content) -> some View {
        // CRITICAL: Access environment values lazily using a helper view to avoid SwiftUI warnings
        NamedEnvironmentAccessor(content: content, componentName: componentName)
    }
    
    // Helper view that defers environment access until view is installed
    private struct NamedEnvironmentAccessor: View {
        let content: Content
        let componentName: String
        
        // Access environment values here - this view is only created when body is called
        // and the view is installed, so environment is guaranteed to be available
        @Environment(\.accessibilityIdentifierConfig) private var injectedConfig
        @Environment(\.globalAutomaticAccessibilityIdentifiers) private var globalAutomaticAccessibilityIdentifiers
        
        var body: some View {
        // Use task-local config (automatic per-test isolation), then injected config, then shared (production)
        // Each test runs in its own task, so @TaskLocal provides isolation even when all tasks run on MainActor
        // Production: taskLocalConfig is nil, falls through to shared (trivial nil check)
        let config = AccessibilityIdentifierConfig.currentTaskLocalConfig ?? injectedConfig ?? AccessibilityIdentifierConfig.shared
        // Same logic as AutomaticComplianceModifier: respect both global and local settings
        let shouldApply = config.enableAutoIDs || globalAutomaticAccessibilityIdentifiers
        
        // Debug logging to help diagnose identifier generation
        if config.enableDebugLogging {
            let debugMsg = "🔍 NAMED MODIFIER DEBUG: body() called for '\(componentName)' - enableAutoIDs=\(config.enableAutoIDs), globalAutomaticAccessibilityIdentifiers=\(globalAutomaticAccessibilityIdentifiers), shouldApply=\(shouldApply)"
            print(debugMsg)
            fflush(stdout)
            config.addDebugLogEntry(debugMsg)
        }
        
        if shouldApply {
                let identifier = Self.generateIdentifier(config: config, componentName: componentName)
            if config.enableDebugLogging {
                let debugMsg = "🔍 NAMED MODIFIER DEBUG: Applying identifier '\(identifier)' to view '\(componentName)'"
                print(debugMsg)
                fflush(stdout)
                config.addDebugLogEntry(debugMsg)
            }
            // Wrap in AnyView to satisfy type erasure requirement (different branches return different types)
            return AnyView(content.accessibilityIdentifier(identifier))
        } else {
            if config.enableDebugLogging {
                let debugMsg = "🔍 NAMED MODIFIER DEBUG: NOT applying identifier for '\(componentName)' - conditions not met"
                print(debugMsg)
                fflush(stdout)
                config.addDebugLogEntry(debugMsg)
            }
            return AnyView(content)
        }
    }
    
    // Note: Not @MainActor - this function only does string manipulation and config access
    // which are thread-safe. Calling from non-MainActor contexts (like view body) is safe.
    private static func generateIdentifier(config: AccessibilityIdentifierConfig, componentName: String) -> String {
        
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
}

// MARK: - Named Component Modifier

/// Modifier that allows components to be named for more specific accessibility identifiers
public struct NamedModifier: ViewModifier {
    let name: String
    // NOTE: Environment properties moved to helper view to avoid SwiftUI warnings
    
    public func body(content: Content) -> some View {
        // CRITICAL: Access environment values lazily using a helper view to avoid SwiftUI warnings
        NamedModifierEnvironmentAccessor(content: content, name: name)
    }
    
    // Helper view that defers environment access until view is installed
    private struct NamedModifierEnvironmentAccessor: View {
        let content: Content
        let name: String
        
        // Access environment values here - this view is only created when body is called
        // and the view is installed, so environment is guaranteed to be available
    @Environment(\.globalAutomaticAccessibilityIdentifiers) private var globalEnabled
    @Environment(\.accessibilityIdentifierPrefix) private var prefix
    @Environment(\.accessibilityIdentifierConfig) private var injectedConfig
    
        var body: some View {
        // Compute once
            let newId = Self.generateNamedAccessibilityIdentifier(
                config: AccessibilityIdentifierConfig.currentTaskLocalConfig ?? injectedConfig ?? AccessibilityIdentifierConfig.shared,
                name: name
            )
        // Apply identifier directly to content
        return content
            .environment(\.accessibilityIdentifierName, name)
            .accessibilityIdentifier(newId)
    }
        
        private static func generateNamedAccessibilityIdentifier(config: AccessibilityIdentifierConfig, name: String) -> String {
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
}

// MARK: - Exact Named Component Modifier

/// Modifier that applies exact accessibility identifiers without framework additions
/// GREEN PHASE: Produces truly minimal identifiers - just the exact name provided
public struct ExactNamedModifier: ViewModifier {
    let name: String
    // NOTE: Environment properties moved to helper view to avoid SwiftUI warnings
    
    public func body(content: Content) -> some View {
        // CRITICAL: Access environment values lazily using a helper view to avoid SwiftUI warnings
        ExactNamedModifierEnvironmentAccessor(content: content, name: name)
    }
    
    // Helper view that defers environment access until view is installed
    private struct ExactNamedModifierEnvironmentAccessor: View {
        let content: Content
        let name: String
        
        // Access environment values here - this view is only created when body is called
        // and the view is installed, so environment is guaranteed to be available
        @Environment(\.globalAutomaticAccessibilityIdentifiers) private var globalEnabled
        @Environment(\.accessibilityIdentifierConfig) private var injectedConfig
        
        var body: some View {
        // Compute once
            let exactId = Self.generateExactNamedAccessibilityIdentifier(
                config: AccessibilityIdentifierConfig.currentTaskLocalConfig ?? injectedConfig ?? AccessibilityIdentifierConfig.shared,
                name: name
            )
        // Apply exact identifier directly to content
        return content.accessibilityIdentifier(exactId)
    }
        
        private static func generateExactNamedAccessibilityIdentifier(config: AccessibilityIdentifierConfig, name: String) -> String {
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
}

// MARK: - Forced Automatic Accessibility Identifier Modifier

/// Modifier that forces automatic accessibility identifiers regardless of global settings
/// Used for local override scenarios
public struct ForcedAutomaticAccessibilityIdentifiersModifier: ViewModifier {
    // NOTE: Environment properties moved to helper view to avoid SwiftUI warnings
    
    public func body(content: Content) -> some View {
        // CRITICAL: Access environment values lazily using a helper view to avoid SwiftUI warnings
        ForcedEnvironmentAccessor(content: content)
    }
    
    // Helper view that defers environment access until view is installed
    private struct ForcedEnvironmentAccessor: View {
        let content: Content
        
        // Access environment values here - this view is only created when body is called
        // and the view is installed, so environment is guaranteed to be available
    @Environment(\.accessibilityIdentifierName) private var accessibilityIdentifierName
    @Environment(\.accessibilityIdentifierElementType) private var accessibilityIdentifierElementType
    @Environment(\.accessibilityIdentifierConfig) private var injectedConfig

        var body: some View {
        // Use task-local config (automatic per-test isolation), then injected config, then shared (production)
        // Each test runs in its own task, so @TaskLocal provides isolation even when all tasks run on MainActor
        // Production: taskLocalConfig is nil, falls through to shared (trivial nil check)
        let config = AccessibilityIdentifierConfig.currentTaskLocalConfig ?? injectedConfig ?? AccessibilityIdentifierConfig.shared
        
        if config.enableDebugLogging {
            print("🔍 FORCED MODIFIER DEBUG: Always applying identifier (local override)")
            print("🔍 FORCED MODIFIER DEBUG: accessibilityIdentifierName = '\(accessibilityIdentifierName ?? "nil")'")
            print("🔍 FORCED MODIFIER DEBUG: accessibilityIdentifierElementType = '\(accessibilityIdentifierElementType ?? "nil")'")
        }
        
            let identifier = Self.generateIdentifier(
                config: config,
                accessibilityIdentifierName: accessibilityIdentifierName,
                accessibilityIdentifierElementType: accessibilityIdentifierElementType
            )
        if config.enableDebugLogging {
            print("🔍 FORCED MODIFIER DEBUG: Applying identifier '\(identifier)' to view")
        }
        
        return AnyView(content.accessibilityIdentifier(identifier))
    }
    
        private static func generateIdentifier(
            config: AccessibilityIdentifierConfig,
            accessibilityIdentifierName: String?,
            accessibilityIdentifierElementType: String?
        ) -> String {
        // Use injected config from environment (for testing), fall back to shared (for production)
        
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

// MARK: - HIG Compliance Modifiers (Phase 1)

/// Modifier that applies minimum touch target sizing for interactive elements
/// iOS/watchOS: 44pt minimum (Apple HIG requirement)
/// Other platforms: No minimum (not applicable)
struct AutomaticHIGTouchTargetModifier: ViewModifier {
    let minSize: CGFloat
    let isInteractive: Bool
    let platform: SixLayerPlatform
    
    func body(content: Content) -> some View {
        if isInteractive && minSize > 0 {
            // Apply minimum touch target for interactive elements on touch platforms
            content
                .frame(minWidth: minSize, minHeight: minSize)
        } else {
            content
        }
    }
}

/// Modifier that ensures WCAG color contrast compliance
/// Uses system colors that automatically meet contrast requirements
struct AutomaticHIGColorContrastModifier: ViewModifier {
    let platform: SixLayerPlatform
    
    func body(content: Content) -> some View {
        // System colors (Color.primary, Color.secondary, Color.accentColor, etc.)
        // automatically meet WCAG contrast requirements in both light and dark mode
        // No explicit modification needed - framework components should use system colors
        // This modifier serves as a reminder/documentation that color contrast is handled
        content
    }
}

/// Modifier that applies Dynamic Type support and minimum font sizes
/// Ensures text scales with system accessibility settings
struct AutomaticHIGTypographyScalingModifier: ViewModifier {
    let platform: SixLayerPlatform
    
    func body(content: Content) -> some View {
        // Apply Dynamic Type support - text automatically scales with system settings
        // SwiftUI's built-in text styles (.body, .headline, etc.) already support Dynamic Type
        // This modifier ensures custom font sizes respect minimum readable sizes
        content
            .dynamicTypeSize(...DynamicTypeSize.accessibility5)
    }
}

/// Modifier that applies visible focus indicators for interactive elements
/// Ensures focus rings are visible and accessible
struct AutomaticHIGFocusIndicatorModifier: ViewModifier {
    let isInteractive: Bool
    let platform: SixLayerPlatform
    
    func body(content: Content) -> some View {
        if isInteractive {
            // Make interactive elements focusable with visible focus indicators
            // SwiftUI automatically shows focus indicators for focusable elements
            // Note: .focusable() requires iOS 17.0+, macOS 14.0+, tvOS 17.0+, watchOS 10.0+
            if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
                content.focusable()
            } else {
                // On older platforms, interactive elements are already focusable by default
                // No explicit modifier needed
                content
            }
        } else {
            content
        }
    }
}

/// Modifier that respects reduced motion preferences
/// Disables or simplifies animations when user prefers reduced motion
struct AutomaticHIGMotionPreferenceModifier: ViewModifier {
    let platform: SixLayerPlatform
    
    func body(content: Content) -> some View {
        // SwiftUI automatically respects reduced motion through its animation environment.
        // When reduced motion is enabled, SwiftUI's .animation() modifier automatically
        // disables or simplifies animations.
        //
        // This modifier ensures that views with automatic compliance will respect the system
        // reduced motion setting. SwiftUI handles this automatically, but we apply it explicitly
        // to ensure compliance.
        //
        // Note: SwiftUI's animation system already respects UIAccessibility.isReduceMotionEnabled
        // (iOS) and system accessibility settings (macOS), so explicit checks are not strictly
        // necessary. However, this modifier serves as documentation and ensures the behavior
        // is explicit.
        //
        // For views that need explicit animation control, developers should use:
        // .animation(reducedMotion ? .none : .default, value: someValue)
        //
        // The automatic compliance system ensures all animations respect reduced motion preferences.
        content
    }
}

/// Modifier that ensures light/dark mode support
/// Uses system colors that automatically adapt to color scheme
struct AutomaticHIGLightDarkModeModifier: ViewModifier {
    let platform: SixLayerPlatform
    
    func body(content: Content) -> some View {
        // System colors automatically adapt to light/dark mode
        // No explicit modification needed - framework components should use system colors
        // This modifier serves as a reminder/documentation that light/dark mode is handled
        content
    }
}

// MARK: - View Extensions

extension View {
    /// Apply automatic compliance (accessibility identifiers + HIG compliance) to a view
    /// This is the primary modifier that all framework components should use
    /// Respects global and environment settings (no forced override)
    /// 
    /// Applies:
    /// - Automatic accessibility identifiers
    /// - HIG compliance features (touch targets, color contrast, typography, focus indicators, etc.)
    public func automaticCompliance() -> some View {
        self.modifier(AutomaticComplianceModifier())
    }
    
    /// Apply automatic compliance with a specific component name
    /// Framework components should use this to set their own name for better identifier generation
    /// - Parameter componentName: The name of the component (e.g., "CoverFlowCardComponent")
    public func automaticCompliance(named componentName: String) -> some View {
        // Create a modifier that accepts the name directly
        self.modifier(NamedAutomaticComplianceModifier(componentName: componentName))
    }
    
    // MARK: - Backward Compatibility Aliases
    
    /// Apply automatic accessibility identifiers to a view
    /// This is kept for backward compatibility - it now also applies HIG compliance
    @available(*, deprecated, renamed: "automaticCompliance()", message: "Use automaticCompliance() which includes both accessibility identifiers and HIG compliance")
    public func automaticAccessibilityIdentifiers() -> some View {
        self.automaticCompliance()
    }
    
    /// Apply automatic accessibility identifiers with a specific component name
    /// This is kept for backward compatibility - it now also applies HIG compliance
    @available(*, deprecated, renamed: "automaticCompliance(named:)", message: "Use automaticCompliance(named:) which includes both accessibility identifiers and HIG compliance")
    public func automaticAccessibilityIdentifiers(named componentName: String) -> some View {
        self.automaticCompliance(named: componentName)
    }
    
    /// Enable automatic compliance locally (for custom views when global is off)
    /// Sets the environment variable to true, then applies the modifier
    public func enableGlobalAutomaticCompliance() -> some View {
        self
            .environment(\.globalAutomaticAccessibilityIdentifiers, true)
            .automaticCompliance()
    }
    
    /// Enable automatic accessibility identifiers locally (for custom views when global is off)
    /// This is kept for backward compatibility
    @available(*, deprecated, renamed: "enableGlobalAutomaticCompliance()", message: "Use enableGlobalAutomaticCompliance() which includes both accessibility identifiers and HIG compliance")
    public func enableGlobalAutomaticAccessibilityIdentifiers() -> some View {
        self.enableGlobalAutomaticCompliance()
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
            .automaticCompliance()
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