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
    
}

