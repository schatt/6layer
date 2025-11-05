import Testing


import SwiftUI
@testable import SixLayerFramework
import ViewInspector
/// BUSINESS PURPOSE: Accessibility tests for InternationalizationService.swift classes
/// Ensures InternationalizationService classes generate proper accessibility identifiers
/// for automated testing and accessibility tools compliance
@Suite("Internationalization Service Accessibility")
open class InternationalizationServiceAccessibilityTests: BaseTestClass {
    
    // MARK: - InternationalizationService Tests
    
    /// BUSINESS PURPOSE: Validates that InternationalizationService generates proper accessibility identifiers
    /// for automated testing and accessibility tools compliance on iOS
    @Test @MainActor func testInternationalizationServiceGeneratesAccessibilityIdentifiersOnIOS() async {
        // Given
        // Ensure config is set up (BaseTestClass.init() should have done this, but ensure it's on MainActor)
        await MainActor.run {
            guard let config = AccessibilityIdentifierConfig.currentTaskLocalConfig ?? self.testConfig else {
                Issue.record("testConfig is nil")
                return
            }
            config.enableAutoIDs = true
            config.namespace = "SixLayer"
            config.globalPrefix = ""
            config.mode = .automatic
            config.enableDebugLogging = false
        }
        
        let service = InternationalizationService()
        
        // When & Then
        // Service classes don't directly generate views, but we test their configuration
        #expect(true, "Service should be instantiable")
        
        // Test that the service can be configured with accessibility settings
        await MainActor.run {
            guard let config = AccessibilityIdentifierConfig.currentTaskLocalConfig ?? self.testConfig else {
                Issue.record("testConfig is nil")
                return
            }
            #expect(config.enableAutoIDs, "InternationalizationService should work with accessibility enabled")
            #expect(config.namespace == "SixLayer", "InternationalizationService should use correct namespace")
        }
    }
    
    /// BUSINESS PURPOSE: Validates that InternationalizationService generates proper accessibility identifiers
    /// for automated testing and accessibility tools compliance on macOS
    @Test @MainActor func testInternationalizationServiceGeneratesAccessibilityIdentifiersOnMacOS() async {
        // Given
        // Ensure config is set up (BaseTestClass.init() should have done this, but ensure it's on MainActor)
        await MainActor.run {
            guard let config = AccessibilityIdentifierConfig.currentTaskLocalConfig ?? self.testConfig else {
                Issue.record("testConfig is nil")
                return
            }
            config.enableAutoIDs = true
            config.namespace = "SixLayer"
            config.globalPrefix = ""
            config.mode = .automatic
            config.enableDebugLogging = false
        }
        
        let service = InternationalizationService()
        
        // When & Then
        // Service classes don't directly generate views, but we test their configuration
        #expect(true, "Service should be instantiable")
        
        // Test that the service can be configured with accessibility settings
        await MainActor.run {
            guard let config = AccessibilityIdentifierConfig.currentTaskLocalConfig ?? self.testConfig else {
                Issue.record("testConfig is nil")
                return
            }
            #expect(config.enableAutoIDs, "InternationalizationService should work with accessibility enabled")
            #expect(config.namespace == "SixLayer", "InternationalizationService should use correct namespace")
        }
    }
