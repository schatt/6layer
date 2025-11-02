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
        let prefix = config.globalPrefix.isEmpty ? "SixLayer" : config.globalPrefix
        let namespace = config.namespace.isEmpty ? "SixLayer" : config.namespace
        let screenContext: String = config.enableUITestIntegration ? "main" : (config.currentScreenContext ?? "main")
        let viewHierarchyPath: String = config.enableUITestIntegration ? "ui" : (config.currentViewHierarchy.isEmpty ? "ui" : config.currentViewHierarchy.joined(separator: "."))
        
        // Build identifier components, avoiding duplication unless explicitly configured
        var identifierComponents: [String] = []
        
        // Add prefix
        identifierComponents.append(prefix)
        
        // Add namespace only if it's different from prefix (to avoid duplication)
        // This prevents "SixLayer.SixLayer.main.ui..." when prefix == namespace
        if namespace != prefix {
            identifierComponents.append(namespace)
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
}
