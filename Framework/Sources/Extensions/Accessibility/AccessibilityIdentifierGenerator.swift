//
//  AccessibilityIdentifierGenerator.swift
//  SixLayerFramework
//
//  BUSINESS PURPOSE:
//  Generates accessibility identifiers with debug logging support
//  Provides centralized ID generation with comprehensive logging
//
//  FEATURES:
//  - Automatic accessibility identifier generation
//  - Debug logging integration
//  - Context-aware identifier creation
//  - Cross-platform compatibility
//

import Foundation

/// Generator for accessibility identifiers with debug logging
@MainActor
public class AccessibilityIdentifierGenerator {
    
    // MARK: - Private Properties
    
    /// Track generated IDs for collision detection
    private var generatedIDs: Set<String> = []
    
    // MARK: - Initialization
    
    public init() {}
    
    // MARK: - Public Methods
    
    /// Generate an accessibility identifier with debug logging
    /// - Parameters:
    ///   - componentName: The name of the component
    ///   - role: The accessibility role (e.g., "button", "textField")
    ///   - context: The context where the component is used
    /// - Returns: A formatted accessibility identifier
    public func generateID(for componentName: String, role: String, context: String) -> String {
        // Use task-local config (automatic per-test isolation), then shared (production)
        // Each test runs in its own task, so @TaskLocal provides isolation even when all tasks run on MainActor
        // Production: taskLocalConfig is nil, falls through to shared (trivial nil check)
        let config = AccessibilityIdentifierConfig.currentTaskLocalConfig ?? AccessibilityIdentifierConfig.shared
        
        // CRITICAL: Capture @Published property values as local variables BEFORE using them
        // to avoid creating SwiftUI dependencies that cause infinite recursion if called from View.body
        let capturedNamespace = config.namespace
        let capturedGlobalPrefix = config.globalPrefix
        let capturedEnableUITestIntegration = config.enableUITestIntegration
        let capturedScreenContext = config.currentScreenContext
        let capturedViewHierarchy = config.currentViewHierarchy
        let capturedIncludeComponentNames = config.includeComponentNames
        let capturedIncludeElementTypes = config.includeElementTypes
        let capturedEnableDebugLogging = config.enableDebugLogging
        
        // Generate the identifier using the same logic as AutomaticAccessibilityIdentifiersModifier
        // Get configured values (empty means skip entirely - no framework forcing)
        // CRITICAL: Use captured values instead of accessing @Published properties directly
        let namespace = capturedNamespace.isEmpty ? nil : capturedNamespace
        let prefix = capturedGlobalPrefix.isEmpty ? nil : capturedGlobalPrefix
        let screenContext: String = capturedEnableUITestIntegration ? "main" : (capturedScreenContext ?? "main")
        let viewHierarchyPath: String = capturedEnableUITestIntegration ? "ui" : (capturedViewHierarchy.isEmpty ? "ui" : capturedViewHierarchy.joined(separator: "."))
        
        // Build identifier components in order: namespace.prefix.main.ui...
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
        
        // Add screen context and view hierarchy path
        identifierComponents.append(screenContext)
        identifierComponents.append(viewHierarchyPath)
        
        // CRITICAL: Use captured value instead of accessing @Published property directly
        if capturedIncludeComponentNames {
            identifierComponents.append(componentName)
        }
        
        // CRITICAL: Use captured value instead of accessing @Published property directly
        if capturedIncludeElementTypes {
            identifierComponents.append(role)
        }
        
        let generatedID = identifierComponents.joined(separator: ".")
        
        // Register the generated ID for collision detection
        generatedIDs.insert(generatedID)
        
        // Log the generation if debug logging is enabled
        // CRITICAL: Use captured value instead of accessing @Published property directly
        if capturedEnableDebugLogging {
            let logEntry = "Generated ID: \(generatedID) for: \(componentName) role: \(role) context: \(context)"
            config.addDebugLogEntry(logEntry, enabled: capturedEnableDebugLogging)
        }
        
        return generatedID
    }
    
    /// Check if an identifier has collision with existing registered identifiers
    /// - Parameter identifier: The identifier to check
    /// - Returns: True if collision detected, false otherwise
    public func checkForCollision(_ identifier: String) -> Bool {
        return generatedIDs.contains(identifier)
    }
    
    /// Clear all generated IDs (for testing - prevents state accumulation)
    /// CRITICAL: Tests should call this to prevent ID registry from leaking between tests
    public func clearGeneratedIDs() {
        generatedIDs.removeAll()
    }
}
