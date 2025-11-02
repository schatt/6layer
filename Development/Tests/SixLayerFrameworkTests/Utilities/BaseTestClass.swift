import Testing
@testable import SixLayerFramework

/// Base class for all tests following DRY principle
/// Provides common setup and teardown functionality for all test classes
@MainActor
open class BaseTestClass {
    
    // MARK: - Test Setup
    
    @MainActor
    public init() {
        // Ensure default accessibility test configuration is applied for all tests
        setupTestEnvironment()
    }
    
    @MainActor
    open func setupTestEnvironment() {
        TestSetupUtilities.shared.setupTestingEnvironment()
        let config = AccessibilityIdentifierConfig.shared
        // Just set what we need - no reset needed since each test sets its own values
        // Tests only set namespace (not prefix) as per framework design
        config.enableAutoIDs = true
        config.namespace = "SixLayer"
        config.globalPrefix = ""  // Explicitly empty - tests don't set prefix unless testing it
        config.mode = .automatic
        config.enableDebugLogging = false
    }
    
    @MainActor
    open func cleanupTestEnvironment() {
        // No cleanup needed - each test sets what it needs
        // If Swift Testing truly runs tests in isolation, singleton state shouldn't leak
        // But keeping this empty method for potential future cleanup needs
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

