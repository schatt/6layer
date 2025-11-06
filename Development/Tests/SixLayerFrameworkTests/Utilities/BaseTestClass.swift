import Testing
import SwiftUI
@testable import SixLayerFramework

/// Base class for all tests following DRY principle
/// Provides common setup and teardown functionality for all test classes
@MainActor
open class BaseTestClass {
    
    // MARK: - Test Config (Isolated Instance)
    
    /// Isolated config instance for this test (per-test isolation via @TaskLocal)
    /// Automatically set as task-local in setupTestEnvironment() so framework code picks it up automatically
    /// Each test runs in its own task, so @TaskLocal provides isolation even when all tasks run on MainActor
    /// Tests can use `runWithTaskLocalConfig()` to wrap test execution for automatic isolation
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
        
        // CRITICAL: Create isolated config instance for this test (per-test isolation)
        // Each test runs in its own task, so @TaskLocal provides automatic isolation
        // Framework code automatically uses task-local config via AccessibilityIdentifierConfig.currentTaskLocalConfig
        testConfig = AccessibilityIdentifierConfig()
        guard let config = testConfig else {
            Issue.record("testConfig is nil")
            return
        }

        config.enableAutoIDs = true
        config.namespace = "SixLayer"
        config.globalPrefix = ""  // Explicitly empty - tests don't set prefix unless testing it
        config.mode = .automatic
        config.enableDebugLogging = false
        
        // Task-local config will be set via runWithTaskLocalConfig() when tests wrap their execution
        // Framework code checks: taskLocalConfig ?? injectedConfig ?? shared
        // This ensures parallel tests get isolated configs automatically
    }
    
    @MainActor
    open func cleanupTestEnvironment() {
        // Task-local config is automatically cleared when test task completes
        // No explicit cleanup needed - @TaskLocal is scoped to the task
    }
    
    /// Run a test function with task-local config automatically set
    /// This ensures framework code automatically picks up the test's isolated config
    /// Tests should wrap their test body with this for automatic isolation
    @MainActor
    public func runWithTaskLocalConfig<T>(_ operation: () async throws -> T) async rethrows -> T {
        return try await AccessibilityIdentifierConfig.$taskLocalConfig.withValue(testConfig) {
            try await operation()
        }
    }
    
    /// Synchronous version for non-async tests
    @MainActor
    public func runWithTaskLocalConfig<T>(_ operation: () throws -> T) rethrows -> T {
        return try AccessibilityIdentifierConfig.$taskLocalConfig.withValue(testConfig) {
            try operation()
        }
    }
    
    // MARK: - Config Injection Helper (REMOVED)
    
    /// REMOVED: Use `runWithTaskLocalConfig` instead
    /// Task-local config is automatically available to framework code
    /// Tests should wrap their test body with `runWithTaskLocalConfig { ... }` 
    /// instead of wrapping individual views with `withTestConfig`
    /// 
    /// This method was removed because it was problematic - it wrapped views unnecessarily
    /// and caused issues with accessibility identifier detection.
    /// 
    /// Migration: Replace `let view = withTestConfig(myView)` with:
    /// ```
    /// await runWithTaskLocalConfig {
    ///     let view = myView
    ///     // ... rest of test
    /// }
    /// ```
    /*
    @MainActor
    public func withTestConfig<V: SwiftUI.View>(_ view: V) -> some View {
        // Just return the view - task-local config is automatic
        // Wrapping was unnecessary and caused issues with accessibility identifiers
        return view
    }
    */
    
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

