import Testing


import SwiftUI
@testable import SixLayerFramework
import ViewInspector
/// Tests for AutomaticAccessibilityIdentifiers.swift
/// 
/// BUSINESS PURPOSE: Ensure automatic accessibility identifier system functions correctly
/// TESTING SCOPE: All functions in AutomaticAccessibilityIdentifiers.swift
/// METHODOLOGY: Test each function on both iOS and macOS platforms as required by mandatory testing guidelines
@Suite("Automatic Accessibility Identifiers")
@MainActor
open class AutomaticAccessibilityIdentifiersTests: BaseTestClass {
    
    // MARK: - Test Setup

    override init() {
        super.init()
        // BaseTestClass already sets up testConfig - no need to access .shared
        // Tests will use runWithTaskLocalConfig() to automatically use isolated config
    }

    // MARK: - Namespace Detection Tests
    
    @Test func testAutomaticNamespaceDetectionForTests() async {
        try await runWithTaskLocalConfig {
            // GIVEN: We're running in a test environment
            // WHEN: Using test config (isolated per test)
            // THEN: Should use configured namespace from BaseTestClass
            guard let config = self.testConfig else {
                Issue.record("testConfig is nil")
                return
            }

            #expect(config.namespace == "SixLayer", "Should use configured namespace for tests")
        }
    }
    
    @Test func testAutomaticNamespaceDetectionForRealApps() async {
        try await runWithTaskLocalConfig {
            // GIVEN: We're simulating a real app environment (not in tests)
            // WHEN: Using test config
            // THEN: Should use configured namespace
            guard let config = self.testConfig else {
                Issue.record("testConfig is nil")
                return
            }

            #expect(config.namespace != nil, "Should have a configured namespace")
            #expect(!config.namespace.isEmpty, "Namespace should not be empty")
            #expect(config.namespace == "SixLayer", "Should use configured SixLayer namespace")
        }
    }
    
    // MARK: - automaticAccessibilityIdentifiers() Modifier Tests
    
    @Test func testAutomaticAccessibilityIdentifiersModifierGeneratesIdentifiersOnIOS() async {
        let view = platformPresentContent_L1(
            content: "Test",
            hints: PresentationHints()
        )
            .automaticAccessibilityIdentifiers()
        
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view, 
            expectedPattern: "SixLayer.*ui", 
            platform: SixLayerPlatform.iOS,
            componentName: "automaticAccessibilityIdentifiers modifier"
        )
        
        #expect(hasAccessibilityID, "automaticAccessibilityIdentifiers modifier should generate accessibility identifiers on iOS")
    }
    
    @Test func testAutomaticAccessibilityIdentifiersModifierGeneratesIdentifiersOnMacOS() async {
        let view = platformPresentContent_L1(
            content: "Test",
            hints: PresentationHints()
        )
            .automaticAccessibilityIdentifiers()
        
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view, 
            expectedPattern: "SixLayer.*ui", 
            platform: .macOS,
            componentName: "automaticAccessibilityIdentifiers modifier"
        )
        
        #expect(hasAccessibilityID, "automaticAccessibilityIdentifiers modifier should generate accessibility identifiers on macOS")
    }
    
    // MARK: - named() Modifier Tests
    
    @Test func testNamedModifierGeneratesIdentifiersOnIOS() async {
        let view = platformPresentContent_L1(
            content: "Test",
            hints: PresentationHints()
        )
            .named("TestElement")
        
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view, 
            expectedPattern: "SixLayer.*ui", 
            platform: SixLayerPlatform.iOS,
            componentName: "named modifier"
        )
        
        #expect(hasAccessibilityID, "named modifier should generate accessibility identifiers on iOS")
    }
    
    @Test func testNamedModifierGeneratesIdentifiersOnMacOS() async {
        let view = platformPresentContent_L1(
            content: "Test",
            hints: PresentationHints()
        )
            .named("TestElement")
        
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view, 
            expectedPattern: "SixLayer.*ui", 
            platform: .macOS,
            componentName: "named modifier"
        )
        
        #expect(hasAccessibilityID, "named modifier should generate accessibility identifiers on macOS")
    }
}

