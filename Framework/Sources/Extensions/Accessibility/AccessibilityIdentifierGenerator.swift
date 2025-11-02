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
        let config = AccessibilityIdentifierConfig.shared
        
        // Generate the identifier using the same logic as AutomaticAccessibilityIdentifiersModifier
        // Get configured values (empty means skip entirely - no framework forcing)
        let namespace = config.namespace.isEmpty ? nil : config.namespace
        let prefix = config.globalPrefix.isEmpty ? nil : config.globalPrefix
        let screenContext: String = config.enableUITestIntegration ? "main" : (config.currentScreenContext ?? "main")
        let viewHierarchyPath: String = config.enableUITestIntegration ? "ui" : (config.currentViewHierarchy.isEmpty ? "ui" : config.currentViewHierarchy.joined(separator: "."))
        
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
        
        if config.includeComponentNames {
            identifierComponents.append(componentName)
        }
        
        if config.includeElementTypes {
            identifierComponents.append(role)
        }
        
        let generatedID = identifierComponents.joined(separator: ".")
        
        // Register the generated ID for collision detection
        generatedIDs.insert(generatedID)
        
        // Log the generation if debug logging is enabled
        if config.enableDebugLogging {
            let logEntry = "Generated ID: \(generatedID) for: \(componentName) role: \(role) context: \(context)"
            config.addDebugLogEntry(logEntry)
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
