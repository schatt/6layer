import Foundation
import SwiftUI

// MARK: - App Namespace Detection

/// Automatically detects the app namespace from Bundle.main
/// - Returns: App name for real apps, "SixLayer" for tests, "app" as fallback
private func detectAppNamespace() -> String {
    // Check if we're running in a test environment
    // Multiple ways to detect test environment
    let isTestEnvironment = ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil ||
                           ProcessInfo.processInfo.environment["XCTestBundlePath"] != nil ||
                           Bundle.main.bundleIdentifier?.contains("xctest") == true ||
                           Bundle.main.bundleIdentifier?.contains("test") == true
    
    if isTestEnvironment {
        return "SixLayer" // Use framework name for tests
    }
    
    // Try to get the app name from Bundle.main
    if let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String,
       !appName.isEmpty {
        // Clean up the app name for use as namespace
        return cleanNamespace(appName)
    }
    
    // Fallback to bundle identifier if CFBundleName is not available
    if let bundleId = Bundle.main.bundleIdentifier {
        // Extract the last component (app name) from bundle identifier
        let components = bundleId.components(separatedBy: ".")
        if let lastComponent = components.last, !lastComponent.isEmpty {
            return cleanNamespace(lastComponent)
        }
    }
    
    // Final fallback
    return "app"
}

/// Cleans app name for use as namespace (removes spaces, special chars, etc.)
private func cleanNamespace(_ name: String) -> String {
    return name
        .replacingOccurrences(of: " ", with: "")
        .replacingOccurrences(of: "-", with: "")
        .replacingOccurrences(of: "_", with: "")
        .replacingOccurrences(of: ".", with: "")
        .lowercased()
}

// MARK: - Enhanced Debug Entry

/// Enhanced debug entry with view hierarchy and screen context for UI testing
public struct AccessibilityDebugEntry {
    public let id: String
    public let context: String
    public let timestamp: Date
    public let viewHierarchy: [String]
    public let screenContext: String?
    public let navigationState: String?
    
    public init(id: String, context: String, timestamp: Date, viewHierarchy: [String], screenContext: String? = nil, navigationState: String? = nil) {
        self.id = id
        self.context = context
        self.timestamp = timestamp
        self.viewHierarchy = viewHierarchy
        self.screenContext = screenContext
        self.navigationState = navigationState
    }
}

// MARK: - Accessibility Identifier Configuration

/// Global configuration for automatic accessibility identifier generation
@MainActor
public class AccessibilityIdentifierConfig: ObservableObject {
    
    // MARK: - Singleton
    
    public static let shared = AccessibilityIdentifierConfig()
    
    // MARK: - Published Properties
    
    /// Whether automatic accessibility identifiers are enabled
    @Published public var enableAutoIDs: Bool = true
    
    /// Global namespace for generated identifiers
    @Published public var namespace: String = detectAppNamespace()
    
    /// Generation mode for identifiers
    @Published public var mode: AccessibilityIdentifierMode = .automatic
    
    /// Whether to enable DEBUG collision detection
    @Published public var enableCollisionDetection: Bool = true
    
    /// Whether to enable DEBUG logging of generated IDs
    @Published public var enableDebugLogging: Bool = false
    
    /// Whether to enable enhanced debugging with view hierarchy tracking
    @Published public var enableViewHierarchyTracking: Bool = false
    
    /// Whether to enable UI test integration features
    @Published public var enableUITestIntegration: Bool = false
    
    // MARK: - Private Properties
    
    private var generatedIDs: Set<String> = []
    
    /// DEBUG: Log of all generated IDs with context
    public var generatedIDsLog: [(id: String, context: String, timestamp: Date)] = []
    
    /// DEBUG: Enhanced log entries with view hierarchy and screen context
    public var enhancedDebugLog: [AccessibilityDebugEntry] = []
    
    /// Current view hierarchy for breadcrumb tracking
    public var currentViewHierarchy: [String] = []
    
    /// Current screen context for breadcrumb tracking
    public var currentScreenContext: String?
    
    /// Current navigation state for breadcrumb tracking
    public var currentNavigationState: String?
    
    // MARK: - Initialization
    
    private init() {
        // Private initializer for singleton
    }
    
    // MARK: - Public Methods
    
    /// Reset configuration to defaults
    public func resetToDefaults() {
        enableAutoIDs = true
        namespace = detectAppNamespace()
        mode = .automatic
        enableCollisionDetection = true
        enableDebugLogging = false
        enableViewHierarchyTracking = false
        enableUITestIntegration = false
        generatedIDs.removeAll()
        generatedIDsLog.removeAll()
        enhancedDebugLog.removeAll()
        currentViewHierarchy.removeAll()
        currentScreenContext = nil
        currentNavigationState = nil
    }
    
    /// Check if an ID has been generated before (collision detection)
    public func checkForCollision(_ id: String) -> Bool {
        guard enableCollisionDetection else { return false }
        // Only report collision if the ID was generated by a different object/context
        // For now, we'll just check if it exists - in a more sophisticated implementation
        // we could track the source of each ID to detect actual conflicts
        return generatedIDs.contains(id)
    }
    
    /// Register a generated ID for collision detection
    public func registerGeneratedID(_ id: String) {
        guard enableCollisionDetection else { return }
        generatedIDs.insert(id)
    }
    
    /// Clear all registered IDs (useful for testing)
    public func clearRegisteredIDs() {
        generatedIDs.removeAll()
    }
    
    // MARK: - DEBUG Methods
    
    /// Log a generated ID with context for debugging
    public func logGeneratedID(_ id: String, context: String) {
        guard enableDebugLogging else { return }
        
        let logEntry = (id: id, context: context, timestamp: Date())
        generatedIDsLog.append(logEntry)
        
        // Enhanced logging with view hierarchy and screen context
        if enableViewHierarchyTracking || enableUITestIntegration {
            let enhancedEntry = AccessibilityDebugEntry(
                id: id,
                context: context,
                timestamp: Date(),
                viewHierarchy: currentViewHierarchy,
                screenContext: currentScreenContext,
                navigationState: currentNavigationState
            )
            enhancedDebugLog.append(enhancedEntry)
        }
        
        #if DEBUG
        print("🔍 Accessibility ID Generated: '\(id)' for \(context)")
        if enableViewHierarchyTracking && !currentViewHierarchy.isEmpty {
            print("   📍 View Hierarchy: \(currentViewHierarchy.joined(separator: " → "))")
        }
        if let screen = currentScreenContext {
            print("   📱 Screen: \(screen)")
        }
        if let navState = currentNavigationState {
            print("   🧭 Navigation: \(navState)")
        }
        #endif
    }
    
    /// Get all generated IDs as a formatted string for debugging
    public func getDebugLog() -> String {
        guard !generatedIDsLog.isEmpty else {
            return "No accessibility identifiers generated yet."
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        
        let logEntries = generatedIDsLog.map { entry in
            "\(formatter.string(from: entry.timestamp)) - \(entry.id) (\(entry.context))"
        }
        
        return "Generated Accessibility Identifiers:\n" + logEntries.joined(separator: "\n")
    }
    
    /// Print debug log to console
    public func printDebugLog() {
        print(getDebugLog())
    }
    
    /// Clear debug log
    public func clearDebugLog() {
        generatedIDsLog.removeAll()
        enhancedDebugLog.removeAll()
        currentViewHierarchy.removeAll()
        currentScreenContext = nil
        currentNavigationState = nil
    }
    
    // MARK: - View Hierarchy Management
    
    /// Push a view name onto the current view hierarchy
    public func pushViewHierarchy(_ viewName: String) {
        currentViewHierarchy.append(viewName)
    }
    
    /// Pop the last view name from the current view hierarchy
    public func popViewHierarchy() {
        if !currentViewHierarchy.isEmpty {
            currentViewHierarchy.removeLast()
        }
    }
    
    /// Check if the current view hierarchy is empty
    public func isViewHierarchyEmpty() -> Bool {
        return currentViewHierarchy.isEmpty
    }
    
    /// Set the current screen context for breadcrumb tracking
    public func setScreenContext(_ screen: String) {
        currentScreenContext = screen
    }
    
    /// Set the current navigation state for breadcrumb tracking
    public func setNavigationState(_ state: String) {
        currentNavigationState = state
    }
    
    // MARK: - UI Test Integration
    
    /// Generate UI test code from the enhanced debug log
    public func generateUITestCode() -> String {
        guard !enhancedDebugLog.isEmpty else {
            return "// No accessibility identifiers generated yet"
        }
        
        var testCode = "// Generated UI Test Code\n"
        testCode += "// Generated at: \(Date())\n\n"
        
        // Group by screen context
        let groupedByScreen = Dictionary(grouping: enhancedDebugLog) { $0.screenContext ?? "Unknown" }
        
        for (screen, entries) in groupedByScreen.sorted(by: { $0.key < $1.key }) {
            testCode += "// Screen: \(screen)\n"
            for entry in entries.sorted(by: { $0.timestamp < $1.timestamp }) {
                let testMethod = generateTestMethod(for: entry)
                testCode += testMethod + "\n"
            }
            testCode += "\n"
        }
        
        return testCode
    }
    
    private func generateTestMethod(for entry: AccessibilityDebugEntry) -> String {
        let methodName = entry.id.replacingOccurrences(of: ".", with: "_").replacingOccurrences(of: "-", with: "_")
        let hierarchy = entry.viewHierarchy.isEmpty ? "" : " // Hierarchy: \(entry.viewHierarchy.joined(separator: " → "))"
        
        // Determine the containing view name
        let containingView = entry.viewHierarchy.isEmpty ? "UnknownView" : entry.viewHierarchy.first ?? "UnknownView"
        
        return """
        func test_\(methodName)() {
            // Element is in: \(containingView)
            let element = app.otherElements["\(entry.id)"]
            XCTAssertTrue(element.exists, "Element '\(entry.id)' should exist in \(containingView)")\(hierarchy)
        }
        """
    }
    
    /// Generate breadcrumb trail from enhanced debug log
    public func generateBreadcrumbTrail() -> String {
        guard !enhancedDebugLog.isEmpty else {
            return "No accessibility identifiers generated yet."
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        
        var breadcrumb = "🍞 Accessibility ID Breadcrumb Trail:\n\n"
        
        // Group by screen context
        let groupedByScreen = Dictionary(grouping: enhancedDebugLog) { $0.screenContext ?? "Unknown" }
        
        for (screen, entries) in groupedByScreen.sorted(by: { $0.key < $1.key }) {
            breadcrumb += "📱 Screen: \(screen)\n"
            
            for entry in entries.sorted(by: { $0.timestamp < $1.timestamp }) {
                breadcrumb += "  \(formatter.string(from: entry.timestamp)) - \(entry.id)\n"
                
                if !entry.viewHierarchy.isEmpty {
                    breadcrumb += "    📍 Path: \(entry.viewHierarchy.joined(separator: " → "))\n"
                }
                
                if let navState = entry.navigationState {
                    breadcrumb += "    🧭 Navigation: \(navState)\n"
                }
            }
            breadcrumb += "\n"
        }
        
        return breadcrumb
    }
    
    /// Print UI test code to console
    public func printUITestCode() {
        print(generateUITestCode())
    }
    
    /// Generate UI test code and save to file in autoGeneratedTests folder
    public func generateUITestCodeToFile() throws -> String {
        let testCode = generateUITestCode()
        
        // Create autoGeneratedTests directory if it doesn't exist
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let autoGeneratedTestsPath = documentsPath.appendingPathComponent("autoGeneratedTests")
        
        try FileManager.default.createDirectory(at: autoGeneratedTestsPath, withIntermediateDirectories: true, attributes: nil)
        
        // Generate unique filename with PID and timestamp
        let pid = ProcessInfo.processInfo.processIdentifier
        let timestamp = Int(Date().timeIntervalSince1970)
        let filename = "GeneratedUITests_\(pid)_\(timestamp).swift"
        let filePath = autoGeneratedTestsPath.appendingPathComponent(filename)
        
        // Write test code to file
        try testCode.write(to: filePath, atomically: true, encoding: .utf8)
        
        return filePath.path
    }
    
    /// Generate UI test code and copy to clipboard (macOS only)
    public func generateUITestCodeToClipboard() {
        let testCode = generateUITestCode()
        #if os(macOS)
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(testCode, forType: .string)
        #endif
    }
    
    /// Print breadcrumb trail to console
    public func printBreadcrumbTrail() {
        print(generateBreadcrumbTrail())
    }
    
    // MARK: - UI Test Helpers
    
    /// Get XCTest element reference for an accessibility ID
    public func getElementByID(_ id: String) -> String {
        return "app.otherElements[\"\(id)\"]"
    }
    
    /// Generate tap action code for UI testing
    public func generateTapAction(_ id: String) -> String {
        return """
        let element = app.otherElements["\(id)"]
        XCTAssertTrue(element.exists, "Element '\(id)' should exist")
        element.tap()
        """
    }
    
    /// Generate text input action code for UI testing
    public func generateTextInputAction(_ id: String, text: String) -> String {
        return """
        let element = app.textFields["\(id)"]
        XCTAssertTrue(element.exists, "Text field '\(id)' should exist")
        element.tap()
        element.typeText("\(text)")
        """
    }
}

// MARK: - Accessibility Identifier Mode

/// Generation mode for accessibility identifiers
public enum AccessibilityIdentifierMode: String, CaseIterable {
    case automatic = "automatic"
    case semantic = "semantic"
    case minimal = "minimal"
    
    public var description: String {
        switch self {
        case .automatic:
            return "Full automatic generation with namespace, context, role, and object identity"
        case .semantic:
            return "Semantic generation focusing on meaningful identifiers"
        case .minimal:
            return "Minimal generation with basic object identity only"
        }
    }
}

// MARK: - Accessibility Identifier Generator

/// Generates deterministic accessibility identifiers based on object identity and context
@MainActor
public struct AccessibilityIdentifierGenerator {
    
    // MARK: - Public Methods
    
    /// Generate an accessibility identifier for an Identifiable object
    public func generateID<T: Identifiable>(
        for object: T,
        role: String,
        context: String
    ) -> String {
        let config = AccessibilityIdentifierConfig.shared
        
        guard config.enableAutoIDs else {
            return ""
        }
        
        let identifier = buildIdentifier(
            namespace: config.namespace,
            context: context,
            role: role,
            objectID: String(describing: object.id)
        )
        
        // Register for collision detection
        config.registerGeneratedID(identifier)
        
        // Log for debugging
        config.logGeneratedID(identifier, context: "Identifiable(\(String(describing: object.id)))")
        
        return identifier
    }
    
    /// Generate an accessibility identifier for a non-Identifiable object
    public func generateID(
        for object: Any,
        role: String,
        context: String
    ) -> String {
        let config = AccessibilityIdentifierConfig.shared
        
        guard config.enableAutoIDs else {
            return ""
        }
        
        let objectID = generateObjectID(for: object)
        let identifier = buildIdentifier(
            namespace: config.namespace,
            context: context,
            role: role,
            objectID: objectID
        )
        
        // Register for collision detection
        config.registerGeneratedID(identifier)
        
        // Log for debugging
        config.logGeneratedID(identifier, context: "Any(\(String(describing: type(of: object))))")
        
        return identifier
    }
    
    /// Check if an identifier would cause a collision
    public func checkForCollision(_ identifier: String) -> Bool {
        return AccessibilityIdentifierConfig.shared.checkForCollision(identifier)
    }
    
    // MARK: - Private Methods
    
    private func buildIdentifier(
        namespace: String,
        context: String,
        role: String,
        objectID: String
    ) -> String {
        let config = AccessibilityIdentifierConfig.shared
        
        switch config.mode {
        case .automatic:
            return "\(namespace).\(context).\(role).\(objectID)"
        case .semantic:
            return "\(namespace).\(role).\(objectID)"
        case .minimal:
            return "\(objectID)"
        }
    }
    
    private func generateObjectID(for object: Any) -> String {
        // Try to extract meaningful identifier from object
        if let string = object as? String {
            return sanitizeID(string)
        } else if let number = object as? NSNumber {
            return "\(number)"
        } else if let array = object as? [Any], !array.isEmpty {
            return "array-\(array.count)"
        } else if let dict = object as? [String: Any], !dict.isEmpty {
            return "dict-\(dict.count)"
        } else {
            // Fallback to type name and hash
            let typeName = String(describing: type(of: object))
            let hash = abs(ObjectIdentifier(object as AnyObject).hashValue)
            return "\(typeName)-\(hash)"
        }
    }
    
    private func sanitizeID(_ id: String) -> String {
        // Remove or replace characters that might cause issues in accessibility identifiers
        return id
            .replacingOccurrences(of: " ", with: "-")
            .replacingOccurrences(of: ".", with: "-")
            .replacingOccurrences(of: "/", with: "-")
            .replacingOccurrences(of: "\\", with: "-")
            .replacingOccurrences(of: ":", with: "-")
            .replacingOccurrences(of: ";", with: "-")
            .replacingOccurrences(of: ",", with: "-")
            .lowercased()
    }
}

// MARK: - View Extensions

public extension View {
    
    /// Apply comprehensive automatic accessibility features (IDs, labels, hints, traits, values)
    /// This modifier enables automatic accessibility for this specific view, overriding global config
    /// - Returns: A view with comprehensive accessibility features applied
    func automaticAccessibilityIdentifiers() -> some View {
        return self.modifier(ComprehensiveAccessibilityModifier())
            .environment(\.automaticAccessibilityIdentifiersEnabled, true) // Enable for all child views
    }
    
    /// Disable automatic accessibility identifiers for this specific view
    func disableAutomaticAccessibilityIdentifiers() -> some View {
        self.modifier(DisableAutomaticAccessibilityIdentifierModifier())
    }
    
    /// Apply automatic accessibility identifiers globally to all views in this hierarchy
    /// This should be called once at the app level (e.g., in your main App struct)
    func enableGlobalAutomaticAccessibilityIdentifiers() -> some View {
        self.modifier(GlobalAutomaticAccessibilityIdentifierModifier())
    }
    
    /// Automatically apply accessibility identifiers to ALL views globally
    /// This is the default behavior - no need to call this manually
    func automaticAccessibilityIdentifiersGlobal() -> some View {
        self.modifier(ComprehensiveAccessibilityModifier())
            .environment(\.automaticAccessibilityIdentifiersEnabled, true) // Enable for all child views
    }
}

// MARK: - Automatic Accessibility Identifier Modifier

/// Modifier that automatically applies comprehensive accessibility features to views
/// This modifier enables automatic IDs, labels, hints, traits, and values for this specific view, overriding global config
public struct ComprehensiveAccessibilityModifier: ViewModifier {
    
    public func body(content: Content) -> some View {
        // Always apply automatic IDs when this modifier is used (local enable)
        // This overrides global configuration by directly applying the assignment modifier
        // We don't rely on environment variables - this modifier always works
        return content
            .modifier(AccessibilityIdentifierAssignmentModifier(isDirectApplication: true)) // Apply ID generation directly
            .modifier(AccessibilityLabelAssignmentModifier())      // Generate VoiceOver labels
            .modifier(AccessibilityHintAssignmentModifier())        // Generate user guidance hints
            .modifier(AccessibilityTraitsAssignmentModifier())      // Generate behavioral traits
            .modifier(AccessibilityValueAssignmentModifier())       // Generate state values
    }
}

/// Global modifier that automatically applies accessibility identifiers to all views
/// This should be applied once at the app level
public struct GlobalAutomaticAccessibilityIdentifierModifier: ViewModifier {
    
    public func body(content: Content) -> some View {
        content
            .environment(\.globalAutomaticAccessibilityIdentifiers, true)
            .environment(\.automaticAccessibilityIdentifiersEnabled, true) // Enable for ALL views
            .modifier(AccessibilityIdentifierAssignmentModifier()) // Apply to this view
    }
}

// MARK: - Disable Automatic Accessibility Identifier Modifier

/// Modifier that disables automatic accessibility identifiers for a specific view
public struct DisableAutomaticAccessibilityIdentifierModifier: ViewModifier {
    
    public func body(content: Content) -> some View {
        content
            .environment(\.disableAutomaticAccessibilityIdentifiers, true)
    }
}

// MARK: - Accessibility Identifier Assignment Modifier

/// Internal modifier that handles the actual ID assignment
@MainActor
public struct AccessibilityIdentifierAssignmentModifier: ViewModifier {
    
    @Environment(\.disableAutomaticAccessibilityIdentifiers) private var environmentDisableAutoIDs
    @Environment(\.globalAutomaticAccessibilityIdentifiers) private var globalAutoIDs
    @Environment(\.automaticAccessibilityIdentifiersEnabled) private var autoIDsEnabled
    
    // Flag to indicate this modifier was applied directly (not through environment)
    let isDirectApplication: Bool
    
    // Optional override for disable flag (passed from parent modifiers)
    let disableAutoIDsOverride: Bool?
    
    public init(isDirectApplication: Bool = false, disableAutoIDs: Bool? = nil) {
        self.isDirectApplication = isDirectApplication
        self.disableAutoIDsOverride = disableAutoIDs
    }
    
    public func body(content: Content) -> some View {
        let config = AccessibilityIdentifierConfig.shared
        
        // Use override if provided, otherwise use environment
        let disableAutoIDs = disableAutoIDsOverride ?? environmentDisableAutoIDs
        
        // Priority order: Local disable > Direct application > Local enable > Global config
        let shouldApplyAutoIDs: Bool
        if disableAutoIDs {
            // Local disable takes highest priority
            shouldApplyAutoIDs = false
        } else if isDirectApplication {
            // Direct application takes second priority (always works)
            shouldApplyAutoIDs = true
        } else if autoIDsEnabled {
            // Local enable takes third priority (overrides global config)
            shouldApplyAutoIDs = true
        } else {
            // Fall back to global config
            shouldApplyAutoIDs = config.enableAutoIDs && globalAutoIDs
        }
        
        // DEBUG: Log the conditions to understand what's happening
        if config.enableDebugLogging {
            print("🔍 AccessibilityIdentifierAssignmentModifier DEBUG:")
            print("   disableAutoIDs: \(disableAutoIDs)")
            print("   config.enableAutoIDs: \(config.enableAutoIDs)")
            print("   globalAutoIDs: \(globalAutoIDs)")
            print("   autoIDsEnabled: \(autoIDsEnabled)")
            print("   isDirectApplication: \(isDirectApplication)")
            print("   shouldApplyAutoIDs: \(shouldApplyAutoIDs)")
        }
        
        if shouldApplyAutoIDs {
            // Apply automatic identifier based on view context
            let generatedID = generateAutomaticID()
            
            // Warn about problematic characters
            if generatedID.contains("@") || generatedID.contains("#") || generatedID.contains(" ") {
                print("⚠️ WARNING: Generated accessibility ID contains characters that may cause UI testing issues")
                print("   ID: '\(generatedID)'")
                print("   Consider using alphanumeric characters and dashes/underscores only")
            }
            
            if config.enableDebugLogging {
                print("🔍 Applying automatic ID: '\(generatedID)'")
            }
            return AnyView(content.modifier(WorkingAccessibilityIdentifierModifier(identifier: generatedID)))
        } else {
            // Don't apply any modifier - let user-specified accessibility identifiers work naturally
            if config.enableDebugLogging {
                print("🔍 Not applying automatic ID - returning content unchanged")
            }
            return AnyView(content)
        }
    }
    
    private func generateAutomaticID() -> String {
        let config = AccessibilityIdentifierConfig.shared
        
        // Use view hierarchy context if available
        let context = config.currentViewHierarchy.isEmpty ? "ui" : config.currentViewHierarchy.joined(separator: ".")
        let screenContext = config.currentScreenContext ?? "main"
        let role = "element"
        
        // Generate a unique object ID based on view type and hierarchy
        let objectID = generateViewObjectID(context: context, screenContext: screenContext)
        
        // Build identifier directly instead of going through generateID method
        let identifier = buildIdentifier(
            namespace: config.namespace,
            context: screenContext,
            role: role,
            objectID: objectID
        )
        
        // Register for collision detection
        config.registerGeneratedID(identifier)
        
        // Log for debugging
        config.logGeneratedID(identifier, context: "ViewModifier(\(context))")
        
        return identifier
    }
    
    private func buildIdentifier(
        namespace: String,
        context: String,
        role: String,
        objectID: String
    ) -> String {
        let config = AccessibilityIdentifierConfig.shared
        
        switch config.mode {
        case .automatic:
            return "\(namespace).\(context).\(role).\(objectID)"
        case .semantic:
            return "\(namespace).\(role).\(objectID)"
        case .minimal:
            return "\(objectID)"
        }
    }
    
    private func generateViewObjectID(context: String, screenContext: String) -> String {
        // Create deterministic object ID based on context only (no timestamps)
        // This ensures IDs are persistent across app launches
        let contextHash = abs(context.hashValue) % 10000
        let screenHash = abs(screenContext.hashValue) % 1000
        
        return "\(screenContext.lowercased())-\(context.lowercased())-\(contextHash)-\(screenHash)"
    }
}

// MARK: - Environment Keys

/// Environment key for enabling automatic accessibility identifiers for all child views
public struct AutomaticAccessibilityIdentifiersEnabledKey: EnvironmentKey {
    public static let defaultValue: Bool = false
}

public extension EnvironmentValues {
    var automaticAccessibilityIdentifiersEnabled: Bool {
        get { self[AutomaticAccessibilityIdentifiersEnabledKey.self] }
        set { self[AutomaticAccessibilityIdentifiersEnabledKey.self] = newValue }
    }
}

/// Environment key for disabling automatic accessibility identifiers
public struct DisableAutomaticAccessibilityIdentifiersKey: EnvironmentKey {
    public static let defaultValue: Bool = false
}

/// Environment key for enabling global automatic accessibility identifiers
public struct GlobalAutomaticAccessibilityIdentifiersKey: EnvironmentKey {
    public static let defaultValue: Bool = true  // ✅ Changed from false to true
}

/// Environment key for tracking manual accessibility identifiers
public struct ManualAccessibilityIdentifierKey: EnvironmentKey {
    public static let defaultValue: Bool = false
}

public extension EnvironmentValues {
    var disableAutomaticAccessibilityIdentifiers: Bool {
        get { self[DisableAutomaticAccessibilityIdentifiersKey.self] }
        set { self[DisableAutomaticAccessibilityIdentifiersKey.self] = newValue }
    }
    
    var globalAutomaticAccessibilityIdentifiers: Bool {
        get { self[GlobalAutomaticAccessibilityIdentifiersKey.self] }
        set { self[GlobalAutomaticAccessibilityIdentifiersKey.self] = newValue }
    }
    
    var manualAccessibilityIdentifier: Bool {
        get { self[ManualAccessibilityIdentifierKey.self] }
        set { self[ManualAccessibilityIdentifierKey.self] = newValue }
    }
}

// MARK: - View Hierarchy Tracking Modifiers

/// View modifier for tracking view hierarchy in breadcrumb system
public struct ViewHierarchyTrackingModifier: ViewModifier {
    let viewName: String
    
    @Environment(\.automaticAccessibilityIdentifiersEnabled) private var autoIDsEnabled
    @Environment(\.disableAutomaticAccessibilityIdentifiers) private var disableAutoIDs
    
    public func body(content: Content) -> some View {
        // Push hierarchy immediately (synchronously) so it's available for ID generation
        AccessibilityIdentifierConfig.shared.pushViewHierarchy(viewName)
        
        // DEBUG: Check environment variable
        if AccessibilityIdentifierConfig.shared.enableDebugLogging {
            print("🔍 ViewHierarchyTrackingModifier DEBUG: disableAutoIDs = \(disableAutoIDs)")
        }
        
        return content
            .onDisappear {
                AccessibilityIdentifierConfig.shared.popViewHierarchy()
            }
            .environment(\.globalAutomaticAccessibilityIdentifiers, !disableAutoIDs) // Respect disable flag
            .modifier(AccessibilityIdentifierAssignmentModifier(disableAutoIDs: disableAutoIDs)) // Pass disable flag directly
    }
}

/// View modifier for setting screen context in breadcrumb system
public struct ScreenContextModifier: ViewModifier {
    let screenName: String
    
    @Environment(\.disableAutomaticAccessibilityIdentifiers) private var disableAutoIDs
    
    public func body(content: Content) -> some View {
        // Set screen context immediately (synchronously) so it's available for ID generation
        AccessibilityIdentifierConfig.shared.setScreenContext(screenName)
        
        // DEBUG: Check environment variable
        if AccessibilityIdentifierConfig.shared.enableDebugLogging {
            print("🔍 ScreenContextModifier DEBUG: disableAutoIDs = \(disableAutoIDs)")
        }
        
        return content
            .environment(\.globalAutomaticAccessibilityIdentifiers, !disableAutoIDs) // Respect disable flag
            .modifier(AccessibilityIdentifierAssignmentModifier(disableAutoIDs: disableAutoIDs)) // Pass disable flag directly
    }
}

/// View modifier for setting navigation state in breadcrumb system
public struct NavigationStateModifier: ViewModifier {
    let navigationState: String
    
    @Environment(\.disableAutomaticAccessibilityIdentifiers) private var disableAutoIDs
    
    public func body(content: Content) -> some View {
        content
            .onAppear {
                AccessibilityIdentifierConfig.shared.setNavigationState(navigationState)
            }
            .environment(\.globalAutomaticAccessibilityIdentifiers, !disableAutoIDs) // Respect disable flag
            .environment(\.automaticAccessibilityIdentifiersEnabled, !disableAutoIDs) // Respect disable flag
            .modifier(AccessibilityIdentifierAssignmentModifier()) // Apply to THIS view only
    }
}

// MARK: - Working Accessibility Identifier Modifier

/// Modifier that applies accessibility identifiers and ensures they transfer to platform views
/// This works around SwiftUI's broken accessibility identifier transfer mechanism
public struct WorkingAccessibilityIdentifierModifier: ViewModifier {
    let identifier: String
    
    public init(identifier: String) {
        self.identifier = identifier
    }
    
    public func body(content: Content) -> some View {
        #if os(macOS)
        return AnyView(
            WorkingAccessibilityHostingControllerWrapper(identifier: identifier) {
                content
            }
        )
        #else
        return AnyView(content.accessibilityIdentifier(identifier))
        #endif
    }
}

#if os(macOS)
import AppKit

/// macOS-specific wrapper that ensures accessibility identifiers transfer properly
struct WorkingAccessibilityHostingControllerWrapper<Content: View>: NSViewControllerRepresentable {
    let identifier: String
    let content: () -> Content
    
    init(identifier: String, @ViewBuilder content: @escaping () -> Content) {
        self.identifier = identifier
        self.content = content
    }
    
    func makeNSViewController(context: Context) -> NSViewController {
        let hostingController = NSHostingController(rootView: content())
        return hostingController
    }
    
    func updateNSViewController(_ nsViewController: NSViewController, context: Context) {
        guard let hostingController = nsViewController as? NSHostingController<Content> else { return }
        
        // Update the root view
        hostingController.rootView = content()
        
        // Force accessibility identifier transfer
        transferAccessibilityIdentifier(to: nsViewController.view, identifier: identifier)
    }
    
    private func transferAccessibilityIdentifier(to view: NSView, identifier: String) {
        // Apply the identifier to the root view
        view.setAccessibilityIdentifier(identifier)
        
        // Also apply to any NSHostingView subviews
        findAndUpdateHostingViews(in: view, identifier: identifier)
    }
    
    private func findAndUpdateHostingViews(in view: NSView, identifier: String) {
        // Recursively search for NSHostingView instances and apply the identifier
        for subview in view.subviews {
            if subview is NSHostingView<Content> {
                subview.setAccessibilityIdentifier(identifier)
            }
            findAndUpdateHostingViews(in: subview, identifier: identifier)
        }
    }
}
#endif

// MARK: - Exact Accessibility Identifier Modifier

/// Modifier that applies an exact accessibility identifier and ensures it transfers to platform views
/// This works around SwiftUI's broken accessibility identifier transfer mechanism
public struct ExactAccessibilityIdentifierModifier: ViewModifier {
    let identifier: String
    
    public init(identifier: String) {
        self.identifier = identifier
    }
    
    public func body(content: Content) -> some View {
        #if os(macOS)
        return AnyView(
            ExactAccessibilityHostingControllerWrapper(identifier: identifier) {
                content
            }
        )
        #else
        return AnyView(content.accessibilityIdentifier(identifier))
        #endif
    }
}

#if os(macOS)
import AppKit

/// macOS-specific wrapper that ensures exact accessibility identifiers transfer properly
struct ExactAccessibilityHostingControllerWrapper<Content: View>: NSViewControllerRepresentable {
    let identifier: String
    let content: () -> Content
    
    init(identifier: String, @ViewBuilder content: @escaping () -> Content) {
        self.identifier = identifier
        self.content = content
    }
    
    func makeNSViewController(context: Context) -> NSViewController {
        let hostingController = NSHostingController(rootView: content())
        return hostingController
    }
    
    func updateNSViewController(_ nsViewController: NSViewController, context: Context) {
        guard let hostingController = nsViewController as? NSHostingController<Content> else { return }
        
        // Update the root view
        hostingController.rootView = content()
        
        // Force exact accessibility identifier transfer
        transferExactAccessibilityIdentifier(to: nsViewController.view, identifier: identifier)
    }
    
    private func transferExactAccessibilityIdentifier(to view: NSView, identifier: String) {
        // Apply the exact identifier to the root view
        view.setAccessibilityIdentifier(identifier)
        
        // Also apply to any NSHostingView subviews
        findAndUpdateHostingViews(in: view, identifier: identifier)
    }
    
    private func findAndUpdateHostingViews(in view: NSView, identifier: String) {
        // Recursively search for NSHostingView instances and apply the identifier
        for subview in view.subviews {
            if subview is NSHostingView<Content> {
                subview.setAccessibilityIdentifier(identifier)
            }
            findAndUpdateHostingViews(in: subview, identifier: identifier)
        }
    }
}
#endif

// MARK: - Hierarchical Named Modifier

/// Modifier that applies hierarchical naming and generates accessibility identifiers
/// This replaces the current level in the hierarchy with the provided name
public struct HierarchicalNamedModifier: ViewModifier {
    let viewName: String
    
    @Environment(\.disableAutomaticAccessibilityIdentifiers) private var disableAutoIDs
    
    public init(viewName: String) {
        self.viewName = viewName
    }
    
    public func body(content: Content) -> some View {
        // Push the name to the hierarchy (replaces current level)
        AccessibilityIdentifierConfig.shared.pushViewHierarchy(viewName)
        
        // Check if global config is enabled AND local disable is not set
        let config = AccessibilityIdentifierConfig.shared
        if config.enableAutoIDs && !disableAutoIDs {
            // Generate and apply accessibility identifier based on the modified hierarchy
            let context = config.currentViewHierarchy.isEmpty ? "ui" : config.currentViewHierarchy.joined(separator: ".")
            let screenContext = config.currentScreenContext ?? "main"
            let role = "element"
            
            // Generate object ID based on the named context
            let objectID = generateNamedObjectID(context: context, screenContext: screenContext, viewName: viewName)
            
            // Build hierarchical identifier manually
            let identifier = "\(config.namespace).\(screenContext).\(role).\(objectID)"
            
            return AnyView(content
                .onDisappear {
                    AccessibilityIdentifierConfig.shared.popViewHierarchy()
                }
                .modifier(WorkingAccessibilityIdentifierModifier(identifier: identifier)))
        } else {
            // Global config is disabled - just track hierarchy without applying identifier
            return AnyView(content
                .onDisappear {
                    AccessibilityIdentifierConfig.shared.popViewHierarchy()
                })
        }
    }
    
    private func generateNamedObjectID(context: String, screenContext: String, viewName: String) -> String {
        // Create deterministic object ID based on context and view name
        let contextHash = abs(context.hashValue) % 10000
        let screenHash = abs(screenContext.hashValue) % 1000
        let nameHash = abs(viewName.hashValue) % 1000
        
        return "\(screenContext.lowercased())-\(viewName.lowercased())-\(contextHash)-\(screenHash)-\(nameHash)"
    }
}

// MARK: - View Extensions for Breadcrumb Tracking

public extension View {
    /// Give this view a semantic name for accessibility identifier generation
    /// - Parameter name: The semantic name to use for this view
    /// - Returns: A view with a semantic name for accessibility identifiers
    func named(_ name: String) -> some View {
        modifier(HierarchicalNamedModifier(viewName: name))
    }
    
    /// Apply an exact accessibility identifier without hierarchy modification
    /// - Parameter name: The exact accessibility identifier to apply
    /// - Returns: A view with the exact accessibility identifier
    func exactNamed(_ name: String) -> some View {
        modifier(ExactAccessibilityIdentifierModifier(identifier: name))
    }
    
    /// Track this view in the hierarchy for breadcrumb debugging
    /// - Parameter name: The name to use for this view in the hierarchy
    /// - Returns: A view that tracks its presence in the view hierarchy
    @available(*, deprecated, renamed: "named", message: "Use .named() instead for clearer intent")
    func trackViewHierarchy(_ name: String) -> some View {
        modifier(ViewHierarchyTrackingModifier(viewName: name))
    }
    
    /// Set the screen context for breadcrumb debugging
    /// - Parameter name: The screen name to use for breadcrumb grouping
    /// - Returns: A view that sets the screen context
    func screenContext(_ name: String) -> some View {
        modifier(ScreenContextModifier(screenName: name))
    }
    
    /// Set the navigation state for breadcrumb debugging
    /// - Parameter state: The navigation state to track
    /// - Returns: A view that sets the navigation state
    func navigationState(_ state: String) -> some View {
        modifier(NavigationStateModifier(navigationState: state))
    }
}

// MARK: - Enhanced Accessibility Modifiers

/// Modifier that automatically generates accessibility labels for VoiceOver
public struct AccessibilityLabelAssignmentModifier: ViewModifier {
    
    public func body(content: Content) -> some View {
        let config = AccessibilityIdentifierConfig.shared
        let label = generateAccessibilityLabel()
        
        if config.enableDebugLogging {
            print("🔍 Applying accessibility label: '\(label)'")
        }
        
        return content.accessibilityLabel(label)
    }
    
    private func generateAccessibilityLabel() -> String {
        let config = AccessibilityIdentifierConfig.shared
        let context = config.currentViewHierarchy.isEmpty ? "ui" : config.currentViewHierarchy.joined(separator: " ")
        
        // Convert technical context to human-readable labels
        let humanReadable = context
            .replacingOccurrences(of: "platforminteractionbutton", with: "interactive button")
            .replacingOccurrences(of: "platformcamerainterface", with: "camera interface")
            .replacingOccurrences(of: "platformphotopicker", with: "photo picker")
            .replacingOccurrences(of: "platformphotoeditor", with: "photo editor")
            .replacingOccurrences(of: "platformphotodisplay", with: "photo display")
            .replacingOccurrences(of: "platformhapticfeedback", with: "haptic feedback")
            .replacingOccurrences(of: "platform", with: "")
            .replacingOccurrences(of: "_", with: " ")
            .replacingOccurrences(of: "-", with: " ")
            .capitalized
        
        return humanReadable.isEmpty ? "Interactive element" : humanReadable
    }
}

/// Modifier that automatically generates accessibility hints for user guidance
public struct AccessibilityHintAssignmentModifier: ViewModifier {
    
    public func body(content: Content) -> some View {
        let config = AccessibilityIdentifierConfig.shared
        let hint = generateAccessibilityHint()
        
        if config.enableDebugLogging {
            print("🔍 Applying accessibility hint: '\(hint)'")
        }
        
        return content.accessibilityHint(hint)
    }
    
    private func generateAccessibilityHint() -> String {
        let config = AccessibilityIdentifierConfig.shared
        let context = config.currentViewHierarchy.isEmpty ? "ui" : config.currentViewHierarchy.joined(separator: " ")
        
        // Generate contextual hints based on component type
        if context.contains("button") || context.contains("interaction") {
            return "Tap to activate"
        } else if context.contains("picker") || context.contains("camera") {
            return "Tap to select or capture"
        } else if context.contains("editor") {
            return "Tap to edit"
        } else if context.contains("display") || context.contains("view") {
            return "View content"
        } else if context.contains("feedback") {
            return "Provides tactile feedback"
        } else {
            return "Tap to interact"
        }
    }
}

/// Modifier that automatically generates accessibility traits for behavior
public struct AccessibilityTraitsAssignmentModifier: ViewModifier {
    
    public func body(content: Content) -> some View {
        let config = AccessibilityIdentifierConfig.shared
        let traits = generateAccessibilityTraits()
        
        if config.enableDebugLogging {
            print("🔍 Applying accessibility traits: \(traits)")
        }
        
        return content.accessibilityAddTraits(traits)
    }
    
    private func generateAccessibilityTraits() -> AccessibilityTraits {
        let config = AccessibilityIdentifierConfig.shared
        let context = config.currentViewHierarchy.isEmpty ? "ui" : config.currentViewHierarchy.joined(separator: " ")
        
        // Generate appropriate traits based on component type
        if context.contains("button") || context.contains("interaction") {
            return .isButton
        } else if context.contains("header") || context.contains("title") {
            return .isHeader
        } else if context.contains("image") || context.contains("photo") {
            return .isImage
        } else if context.contains("text") || context.contains("label") {
            return .isStaticText
        } else {
            return []
        }
    }
}

/// Modifier that automatically generates accessibility values for state
public struct AccessibilityValueAssignmentModifier: ViewModifier {
    
    public func body(content: Content) -> some View {
        let config = AccessibilityIdentifierConfig.shared
        let value = generateAccessibilityValue()
        
        if config.enableDebugLogging && !value.isEmpty {
            print("🔍 Applying accessibility value: '\(value)'")
        }
        
        if value.isEmpty {
            return AnyView(content)
        } else {
            return AnyView(content.accessibilityValue(value))
        }
    }
    
    private func generateAccessibilityValue() -> String {
        let config = AccessibilityIdentifierConfig.shared
        let context = config.currentViewHierarchy.isEmpty ? "ui" : config.currentViewHierarchy.joined(separator: " ")
        
        // Generate values for components that have state
        if context.contains("picker") {
            return "Ready to select"
        } else if context.contains("camera") {
            return "Ready to capture"
        } else if context.contains("editor") {
            return "Ready to edit"
        } else if context.contains("feedback") {
            return "Enabled"
        } else {
            return "" // No value for most components
        }
    }
}
