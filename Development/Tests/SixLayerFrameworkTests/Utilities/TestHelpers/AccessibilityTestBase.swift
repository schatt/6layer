import XCTest
import SwiftUI
@testable import SixLayerFramework

/// Shared utilities for accessibility tests
/// DRY PRINCIPLE: Centralizes common test setup logic without inheritance
/// DTRT PRINCIPLE: Ensures consistent test environment across all accessibility tests
@MainActor
public enum AccessibilityTestUtilities {
    
    // MARK: - Shared Setup/Teardown Methods
    
    /// Sets up the testing environment for accessibility tests
    public static func setupAccessibilityTestEnvironment() async {
        TestSetupUtilities.shared.setupTestingEnvironment()
        configureAccessibilitySettings()
    }
    
    /// Cleans up the testing environment for accessibility tests
    public static func cleanupAccessibilityTestEnvironment() async {
        TestSetupUtilities.shared.cleanupTestingEnvironment()
        resetAccessibilitySettings()
    }
    
    // MARK: - Shared Configuration Methods
    
    /// Configures accessibility settings for tests
    private static func configureAccessibilitySettings() {
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
        config.enableAutoIDs = true
        config.namespace = "SixLayer"
        config.mode = .automatic
        config.enableDebugLogging = false
    }
    
    /// Resets accessibility settings after tests
    private static func resetAccessibilitySettings() {
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
    }
}
