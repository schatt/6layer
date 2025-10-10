import XCTest
import SwiftUI
@testable import SixLayerFramework

/// Base class for all accessibility tests with shared setup/teardown
/// DRY PRINCIPLE: Centralizes common test setup logic
/// DTRT PRINCIPLE: Ensures consistent test environment across all accessibility tests
@MainActor
open class AccessibilityTestBase: XCTestCase {
    
    // MARK: - Shared Setup/Teardown
    
    override open func setUp() async throws {
        try await super.setUp()
        await setupTestEnvironment()
        configureAccessibilitySettings()
    }
    
    override open func tearDown() async throws {
        await cleanupTestEnvironment()
        resetAccessibilitySettings()
        try await super.tearDown()
    }
    
    // MARK: - Shared Configuration Methods
    
    /// Configures accessibility settings for tests
    private func configureAccessibilitySettings() {
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
        config.enableAutoIDs = true
        config.namespace = "SixLayer"
        config.mode = .automatic
        config.enableDebugLogging = false
    }
    
    /// Resets accessibility settings after tests
    private func resetAccessibilitySettings() {
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
    }
}
