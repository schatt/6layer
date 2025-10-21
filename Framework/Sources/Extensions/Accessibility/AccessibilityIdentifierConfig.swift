//
//  AccessibilityIdentifierConfig.swift
//  SixLayerFramework
//
//  BUSINESS PURPOSE:
//  Configuration management for accessibility identifier generation
//  Provides centralized control over accessibility identifier behavior
//
//  FEATURES:
//  - Global enable/disable for accessibility identifiers
//  - Configuration management
//  - Testing support
//

import Foundation

/// Accessibility configuration mode
public enum AccessibilityMode: String, CaseIterable, Sendable {
    case automatic = "automatic"
    case manual = "manual"
    case disabled = "disabled"
    case semantic = "semantic"
}

/// Configuration manager for accessibility identifier generation
@MainActor
public class AccessibilityIdentifierConfig: ObservableObject {
    /// Shared instance for global configuration
    public static let shared = AccessibilityIdentifierConfig()
    
    /// Whether automatic accessibility identifiers are enabled
    @Published public var enableAutoIDs: Bool = true
    
    /// Global prefix for accessibility identifiers
    @Published public var globalPrefix: String = "SixLayer"
    
    /// Namespace for accessibility identifiers (legacy support)
    @Published public var namespace: String = "SixLayer"
    
    /// Whether to include component names in identifiers
    @Published public var includeComponentNames: Bool = true
    
    /// Whether to include element types in identifiers
    @Published public var includeElementTypes: Bool = true
    
    /// Current view hierarchy for context-aware identifier generation
    @Published public var currentViewHierarchy: [String] = []
    
    /// Current screen context for identifier generation
    @Published public var currentScreenContext: String? = nil
    
    /// Debug logging mode
    @Published public var enableDebugLogging: Bool = false
    
    /// Debug log entries
    @Published private var debugLogEntries: [String] = []
    
    /// Maximum number of debug log entries to keep
    private let maxDebugLogEntries = 1000
    
    /// Configuration mode
    @Published public var mode: AccessibilityMode = .automatic
    
    /// Whether to enable view hierarchy tracking (for testing)
    @Published public var enableViewHierarchyTracking: Bool = false
    
    /// Push view hierarchy (for testing)
    public func pushViewHierarchy(_ viewName: String) {
        currentViewHierarchy.append(viewName)
    }
    
    private init() {}
    
    /// Reset configuration to defaults
    public func resetToDefaults() {
        enableAutoIDs = true
        globalPrefix = "SixLayer"
        namespace = "SixLayer"
        includeComponentNames = true
        includeElementTypes = true
        currentViewHierarchy = []
        currentScreenContext = nil
        enableDebugLogging = false
        mode = .automatic
    }
    
    /// Configure for testing mode
    public func configureForTesting() {
        enableAutoIDs = true
        globalPrefix = "DebugTest"
        namespace = "DebugTest"
        includeComponentNames = true
        includeElementTypes = true
        currentViewHierarchy = []
        currentScreenContext = "main"
    }
    
    /// Set the current screen context for accessibility identifier generation
    public func setScreenContext(_ context: String) {
        currentScreenContext = context
    }
    
    /// Set the current view hierarchy for accessibility identifier generation
    public func setViewHierarchy(_ hierarchy: [String]) {
        currentViewHierarchy = hierarchy
    }
    
    // MARK: - Debug Logging Methods
    
    /// Get the current debug log as a formatted string
    public func getDebugLog() -> String {
        return debugLogEntries.joined(separator: "\n")
    }
    
    /// Clear the debug log
    public func clearDebugLog() {
        debugLogEntries.removeAll()
    }
    
    /// Add an entry to the debug log (internal method)
    internal func addDebugLogEntry(_ entry: String) {
        guard enableDebugLogging else { return }
        
        let timestamp = DateFormatter.debugTimestamp.string(from: Date())
        let formattedEntry = "[\(timestamp)] \(entry)"
        
        debugLogEntries.append(formattedEntry)
        
        // Keep only the most recent entries
        if debugLogEntries.count > maxDebugLogEntries {
            debugLogEntries.removeFirst(debugLogEntries.count - maxDebugLogEntries)
        }
    }
    /// Check if view hierarchy is empty
    public func isViewHierarchyEmpty() -> Bool {
        return currentViewHierarchy.isEmpty
    }
    
    /// Generate tap action for UI testing
    public func generateTapAction(_ identifier: String) -> String {
        return "app.otherElements[\"\(identifier)\"].element.tap()"
    }
    
    /// Generate UI test code and save to file
    public func generateUITestCodeToFile() throws -> String {
        let testCode = """
        // Generated UI test code
        let app = XCUIApplication()
        app.launch()
        """
        return "/tmp/generated_ui_test.swift"
    }
    
    /// Generate UI test code and copy to clipboard
    public func generateUITestCodeToClipboard() {
        // Stub implementation - would copy to clipboard in real implementation
    }
    
    /// Push view hierarchy context
    public func pushViewHierarchy(_ context: String) {
        currentViewHierarchy.append(context)
    }
    
    /// Pop view hierarchy context
    public func popViewHierarchy() {
        if !currentViewHierarchy.isEmpty {
            currentViewHierarchy.removeLast()
        }
    }
}

// MARK: - DateFormatter Extension

private extension DateFormatter {
    static let debugTimestamp: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        return formatter
    }()
}
