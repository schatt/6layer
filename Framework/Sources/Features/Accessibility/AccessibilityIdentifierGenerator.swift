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
        let namespace = config.namespace.isEmpty ? "main" : config.namespace
        let screenContext = config.currentScreenContext ?? "main"
        let viewHierarchyPath = config.currentViewHierarchy.isEmpty ? "ui" : config.currentViewHierarchy.joined(separator: ".")
        
        var identifierComponents: [String] = [prefix, namespace, screenContext, viewHierarchyPath]
        
        if config.includeComponentNames {
            identifierComponents.append(componentName)
        }
        
        if config.includeElementTypes {
            identifierComponents.append(role)
        }
        
        let generatedID = identifierComponents.joined(separator: ".")
        
        // Log the generation if debug logging is enabled
        if config.enableDebugLogging {
            let logEntry = "Generated ID: \(generatedID) for: \(componentName) role: \(role) context: \(context)"
            config.addDebugLogEntry(logEntry)
        }
        
        return generatedID
    }
}
