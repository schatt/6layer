import Testing
@testable import SixLayerFramework

/// Base class for accessibility tests following DRY principle
/// Provides common setup and teardown functionality for all accessibility test classes
@MainActor
open class BaseAccessibilityTestClass {
    
    // MARK: - Test Setup
    
    @MainActor
    public init() async throws {
        await setupTestEnvironment()
    }
    
    @MainActor
    open func setupTestEnvironment() async {
        await TestSetupUtilities.shared.setupTestingEnvironment()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
        config.enableAutoIDs = true
        config.namespace = "SixLayer"
        config.mode = .automatic
        config.enableDebugLogging = false
    }
    
    @MainActor
    open func cleanupTestEnvironment() async {
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
    }
    
    deinit {
        Task { [weak self] in
            await self?.cleanupTestEnvironment()
        }
    }
    }

