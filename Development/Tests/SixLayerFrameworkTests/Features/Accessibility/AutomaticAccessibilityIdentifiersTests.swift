import Testing


import SwiftUI
@testable import SixLayerFramework
import ViewInspector

/// Tests for AutomaticAccessibilityIdentifiers.swift
/// 
/// BUSINESS PURPOSE: Ensure automatic accessibility identifier system functions correctly
/// TESTING SCOPE: All functions in AutomaticAccessibilityIdentifiers.swift
/// METHODOLOGY: Test each function on both iOS and macOS platforms as required by mandatory testing guidelines
@MainActor
open class AutomaticAccessibilityIdentifiersTests {
    
    // MARK: - Test Setup
    
    init() async throws {
                await setupTestEnvironment()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
        config.enableAutoIDs = true
        // namespace is automatically detected as "SixLayer" for tests
        config.mode = .automatic
        config.enableDebugLogging = false
    }
    
    // MARK: - Namespace Detection Tests
    
    private func setupTestEnvironment() async {
        await AccessibilityTestUtilities.setupAccessibilityTestEnvironment()
    }
    
    @Test func testAutomaticNamespaceDetectionForTests() async {
        // GIVEN: We're running in a test environment
        // WHEN: Creating a new config
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
        
        // THEN: Should automatically detect "SixLayer" for tests
        #expect(config.namespace == "SixLayer", "Should automatically detect SixLayer namespace for tests")
    }
    
    @Test func testAutomaticNamespaceDetectionForRealApps() async {
        // GIVEN: We're simulating a real app environment (not in tests)
        // WHEN: Creating a config (this would normally detect the real app name)
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
        
        // THEN: Should use detected namespace (SixLayer for tests, real app name for real apps)
        #expect(config.namespace != nil, "Should have a detected namespace")
        #expect(!config.namespace.isEmpty, "Namespace should not be empty")
        
        // In test environment, it should be "SixLayer"
        // In real app, it would be the actual app name
        #expect(config.namespace == "SixLayer", "Should detect SixLayer in test environment")
    }
    
    // MARK: - automaticAccessibilityIdentifiers() Modifier Tests
    
    @Test func testAutomaticAccessibilityIdentifiersModifierGeneratesIdentifiersOnIOS() async {
        let view = Text("Test")
            .automaticAccessibilityIdentifiers()
        
        let hasAccessibilityID = hasAccessibilityIdentifierPattern(
            view, 
            expectedPattern: "SixLayer.main.element.*", 
            platform: .iOS,
            componentName: "automaticAccessibilityIdentifiers modifier"
        )
        
        #expect(hasAccessibilityID, "automaticAccessibilityIdentifiers modifier should generate accessibility identifiers on iOS")
    }
    
    @Test func testAutomaticAccessibilityIdentifiersModifierGeneratesIdentifiersOnMacOS() async {
        let view = Text("Test")
            .automaticAccessibilityIdentifiers()
        
        let hasAccessibilityID = hasAccessibilityIdentifierPattern(
            view, 
            expectedPattern: "SixLayer.main.element.*", 
            platform: .macOS,
            componentName: "automaticAccessibilityIdentifiers modifier"
        )
        
        #expect(hasAccessibilityID, "automaticAccessibilityIdentifiers modifier should generate accessibility identifiers on macOS")
    }
    
    // MARK: - named() Modifier Tests
    
    @Test func testNamedModifierGeneratesIdentifiersOnIOS() async {
        let view = Text("Test")
            .named("TestElement")
        
        let hasAccessibilityID = hasAccessibilityIdentifierPattern(
            view, 
            expectedPattern: "SixLayer.main.element.*testelement.*", 
            platform: .iOS,
            componentName: "named modifier"
        )
        
        #expect(hasAccessibilityID, "named modifier should generate accessibility identifiers on iOS")
    }
    
    @Test func testNamedModifierGeneratesIdentifiersOnMacOS() async {
        let view = Text("Test")
            .named("TestElement")
        
        let hasAccessibilityID = hasAccessibilityIdentifierPattern(
            view, 
            expectedPattern: "SixLayer.main.element.*testelement.*", 
            platform: .macOS,
            componentName: "named modifier"
        )
        
        #expect(hasAccessibilityID, "named modifier should generate accessibility identifiers on macOS")
    }
}

