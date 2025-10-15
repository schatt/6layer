import Testing
@testable import SixLayerFramework

/// Base class for accessibility tests following DRY principle
/// Provides common setup and teardown functionality for all accessibility test classes
@MainActor
open class BaseAccessibilityTestClass {
    
    // MARK: - Test Setup
    
    @MainActor
    public init() {
        setupTestEnvironment()
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
    
    deinit {
        Task { @MainActor in
            cleanupTestEnvironment()
        }
    }
}
