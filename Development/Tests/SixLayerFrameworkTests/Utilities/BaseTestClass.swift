import Testing
@testable import SixLayerFramework

/// Base class for all tests following DRY principle
/// Provides common setup and teardown functionality for all test classes
@MainActor
open class BaseTestClass {
    
    // MARK: - Test Setup
    
    @MainActor
    public init() {
        // Base class initialization - individual tests handle their own setup
    }
    
    @MainActor
    open func setupTestEnvironment() {
        TestSetupUtilities.shared.setupTestingEnvironment()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
        config.enableAutoIDs = true
        config.namespace = "SixLayer"
        config.mode = .automatic
        config.enableDebugLogging = false
    }
    
    @MainActor
    open func cleanupTestEnvironment() {
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
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

