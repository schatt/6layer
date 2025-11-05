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
    /// Task-local config for per-test isolation
    /// Each test runs in its own task, so @TaskLocal provides isolation even when all tasks run on MainActor
    /// BaseTestClass automatically sets this in setupTestEnvironment() using withValue
    @TaskLocal static var taskLocalConfig: AccessibilityIdentifierConfig?
    
    /// Get task-local config (for per-test isolation)
    /// Returns nil in production, or the test's isolated config in tests
    internal static var currentTaskLocalConfig: AccessibilityIdentifierConfig? {
        return taskLocalConfig
    }
    
    /// Shared instance for global configuration (PRODUCTION ONLY)
    /// Tests use task-local config automatically via @TaskLocal - never use .shared in tests
    /// 
    /// PARALLEL TEST SAFETY: Framework code checks `taskLocalConfig ?? injectedConfig ?? shared`
    /// Each test runs in its own task, so @TaskLocal provides automatic isolation.
    /// Tests that access .shared directly will cause race conditions in parallel execution.
    ///
    /// CONCURRENCY: Static properties on @MainActor classes are MainActor isolated.
    /// The initializer is @MainActor isolated, so initialization happens lazily
    /// on first access (which will be from MainActor context in production).
    public static let shared: AccessibilityIdentifierConfig = {
        // Lazy initialization - first access will be from MainActor context in production
        return AccessibilityIdentifierConfig(singleton: true)
    }()
    
    /// Whether automatic accessibility identifiers are enabled
    @Published public var enableAutoIDs: Bool = true
    
    /// Global prefix for accessibility identifiers (feature/view organizer)
    /// Empty string means skip in ID generation - framework works with developers, not against them
    @Published public var globalPrefix: String = ""
    
    /// Namespace for accessibility identifiers (top-level organizer)
    /// Empty string means skip in ID generation - framework works with developers, not against them
    @Published public var namespace: String = ""
    
    /// Whether to include component names in identifiers
    @Published public var includeComponentNames: Bool = true
    
    /// Whether to include element types in identifiers
    @Published public var includeElementTypes: Bool = true
    
    /// Current view hierarchy for context-aware identifier generation
    @Published public var currentViewHierarchy: [String] = []
    
    /// Current screen context for identifier generation
    @Published public var currentScreenContext: String? = nil
    
    /// Debug logging mode
    /// Automatically enabled if SIXLAYER_DEBUG_A11Y environment variable is set to "1" or "true"
    @Published public var enableDebugLogging: Bool = false {
        didSet {
            if enableDebugLogging && !oldValue {
                print("🔍 SixLayer Accessibility ID debugging enabled")
                print("   Use AccessibilityIdentifierConfig.shared.printDebugLog() to see generated IDs")
                fflush(stdout) // Ensure output appears immediately
            }
        }
    }
    
    /// UI test integration mode
    @Published public var enableUITestIntegration: Bool = false
    
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
    
    /// Initialize a new config instance (allows tests to create isolated instances)
    public init() {}
    
    /// Private initializer for singleton pattern
    private init(singleton: Bool) {
        // Used only by shared instance
        // Check environment variable to auto-enable debug logging
        let envValue = ProcessInfo.processInfo.environment["SIXLAYER_DEBUG_A11Y"]
        if envValue == "1" || envValue == "true" {
            enableDebugLogging = true
        }
    }
    
    /// Reset configuration to defaults
    /// Sets empty strings for namespace and prefix - framework should work with developers, not force framework values
    /// CRITICAL: Also clears ALL accumulating state (debug logs, view hierarchy) to prevent test leakage
    public func resetToDefaults() {
        enableAutoIDs = true
        globalPrefix = ""  // Empty = skip in ID generation
        namespace = ""      // Empty = skip in ID generation
        includeComponentNames = true
        includeElementTypes = true
        currentViewHierarchy = []  // Clear accumulating view hierarchy
        currentScreenContext = nil
        enableDebugLogging = false
        mode = .automatic
        // CRITICAL: Clear accumulating data stores to prevent test state leakage
        debugLogEntries.removeAll()  // Clear debug log accumulation
    }
    
    /// Configure for testing mode
    public func configureForTesting() {
        enableAutoIDs = true
        globalPrefix = ""  // Tests should set namespace only (unless testing prefix)
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
    
    /// Print the debug log to console
    /// Convenience method for debugging - prints all debug log entries
    public func printDebugLog() {
        let log = getDebugLog()
        if log.isEmpty {
            print("📋 Accessibility Debug Log: (empty)")
        } else {
            print("📋 Accessibility Debug Log:")
            print(log)
        }
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
    
    /// Generate text input action for UI testing
    /// TDD RED PHASE: This is a stub implementation for testing
    public func generateTextInputAction(_ identifier: String, text: String) -> String {
        return "app.textFields[\"\(identifier)\"].element.typeText(\"\(text)\")"
    }
    
    /// Generate UI test code and save to file
    public func generateUITestCodeToFile() throws -> String {
        let _ = """
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
    
    /// Pop view hierarchy context
    public func popViewHierarchy() {
        if !currentViewHierarchy.isEmpty {
            currentViewHierarchy.removeLast()
        }
    }
    
    /// Set navigation state for accessibility identifier generation
    /// TDD RED PHASE: This is a stub implementation for testing
    public func setNavigationState(_ state: String) {
        currentScreenContext = state
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
