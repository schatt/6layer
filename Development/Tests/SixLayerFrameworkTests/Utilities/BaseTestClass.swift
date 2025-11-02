import Testing
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
        AccessibilityIdentifierConfig.shared.resetToDefaults()
        AccessibilityIdentifierConfig.shared.enableAutoIDs = testConfig.enableAutoIDs
        AccessibilityIdentifierConfig.shared.namespace = testConfig.namespace
        AccessibilityIdentifierConfig.shared.globalPrefix = testConfig.globalPrefix
        AccessibilityIdentifierConfig.shared.mode = testConfig.mode
        AccessibilityIdentifierConfig.shared.enableDebugLogging = testConfig.enableDebugLogging
    }
    
    @MainActor
    open func cleanupTestEnvironment() {
        // Cleanup accumulating state to prevent leakage to next test
        // Framework uses singleton, so we must clean shared state after each test
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
    }
    
    // MARK: - Config Injection Helper
    
    /// Helper to inject test config into a view for isolated testing
    /// Usage: `let viewWithConfig = withTestConfig(myView)`
    @MainActor
    public func withTestConfig<V: View>(_ view: V) -> some View {
        return view.environment(\.accessibilityIdentifierConfig, testConfig)
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

