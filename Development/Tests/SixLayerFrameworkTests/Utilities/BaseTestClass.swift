import Testing
import SwiftUI
@testable import SixLayerFramework

/// Base class for all tests following DRY principle
/// Provides common setup and teardown functionality for all test classes
    @MainActor
    open class BaseTestClass {
    
    // MARK: - Test Config (Isolated Instance)
    
    /// Isolated config instance for this test to prevent singleton state leakage
    /// Tests should inject this into views via `withTestConfig()` helper
    @MainActor
    public var testConfig: AccessibilityIdentifierConfig!
    
    // MARK: - Test Setup
    
    @MainActor
    public init() {
        // Ensure default accessibility test configuration is applied for all tests
        setupTestEnvironment()
    }
    
    @MainActor
    open func setupTestEnvironment() {
        TestSetupUtilities.shared.setupTestingEnvironment()
        
        // CRITICAL: Create isolated config for this test to prevent singleton state leakage
        // Framework code can now use injected config via environment, falling back to shared for production
        testConfig = AccessibilityIdentifierConfig()
        testConfig.enableAutoIDs = true
        testConfig.namespace = "SixLayer"
        testConfig.globalPrefix = ""  // Explicitly empty - tests don't set prefix unless testing it
        testConfig.mode = .automatic
        testConfig.enableDebugLogging = false
        
        // Also set shared for backward compatibility during migration
        // TODO: Migrate all tests to use injected config instead of shared
        // NOTE: No need to resetToDefaults() - each test is isolated, just set the values we need
        AccessibilityIdentifierConfig.shared.enableAutoIDs = testConfig.enableAutoIDs
        AccessibilityIdentifierConfig.shared.namespace = testConfig.namespace
        AccessibilityIdentifierConfig.shared.globalPrefix = testConfig.globalPrefix
        AccessibilityIdentifierConfig.shared.mode = testConfig.mode
        AccessibilityIdentifierConfig.shared.enableDebugLogging = testConfig.enableDebugLogging
    }
    
    @MainActor
    open func cleanupTestEnvironment() {
        // NOTE: Since each test runs on its own thread with its own testConfig,
        // we don't need to reset the shared singleton. Each test's setup will
        // configure shared as needed. If tests run in parallel, they each set
        // their own values on shared, which should be fine since they all set
        // the same test values anyway.
        // If we need cleanup, we'd clear accumulating state like debug logs:
        // AccessibilityIdentifierConfig.shared.debugLogEntries.removeAll()
    }
    
    // MARK: - Config Injection Helper
    
    /// Helper to inject test config into a view for isolated testing
    /// Usage: `let viewWithConfig = withTestConfig(myView)`
    @MainActor
    public func withTestConfig<V: SwiftUI.View>(_ view: V) -> AnyView {
        return AnyView(view.environment(\.accessibilityIdentifierConfig, testConfig))
    }
    
    // MARK: - Common Test Data Creation
    
    /// Creates generic sample data for testing
    /// Override this method in subclasses to provide specific test data
    @MainActor
    open func createSampleData() -> [Any] {
        return [
            "Sample Item 1",
            "Sample Item 2", 
            "Sample Item 3"
        ]
    }
    
    /// Creates test hints for presentation components
    /// Override this method in subclasses to provide specific presentation hints
    @MainActor
    open func createTestHints() -> PresentationHints {
        return PresentationHints(
            dataType: .generic,
            presentationPreference: .automatic,
            complexity: .moderate,
            context: .dashboard,
            customPreferences: [:]
        )
    }
    
    /// Creates a default layout decision for testing
    /// Override this method in subclasses to provide specific layout decisions
    @MainActor
    open func createLayoutDecision() -> IntelligentCardLayoutDecision {
        return IntelligentCardLayoutDecision(
            columns: 2,
            spacing: 16,
            cardWidth: 200,
            cardHeight: 150,
            padding: 16
        )
    }
    
}

