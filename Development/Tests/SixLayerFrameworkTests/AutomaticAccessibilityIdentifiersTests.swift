import XCTest
import SwiftUI
@testable import SixLayerFramework
import ViewInspector

/// Tests for AutomaticAccessibilityIdentifiers.swift
/// 
/// BUSINESS PURPOSE: Ensure automatic accessibility identifier system functions correctly
/// TESTING SCOPE: All functions in AutomaticAccessibilityIdentifiers.swift
/// METHODOLOGY: Test each function on both iOS and macOS platforms as required by mandatory testing guidelines
@MainActor
final class AutomaticAccessibilityIdentifiersTests: XCTestCase {
    
    // MARK: - Test Setup
    
    override func setUp() async throws {
        try await super.setUp()
        setupTestEnvironment()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
        config.enableAutoIDs = true
        // namespace is automatically detected as "SixLayer" for tests
        config.mode = .automatic
        config.enableDebugLogging = false
    }
    
    override func tearDown() async throws {
        try await super.tearDown()
        cleanupTestEnvironment()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
    }
    
    // MARK: - Namespace Detection Tests
    
    func testAutomaticNamespaceDetectionForTests() async {
        // GIVEN: We're running in a test environment
        // WHEN: Creating a new config
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
        
        // THEN: Should automatically detect "SixLayer" for tests
        XCTAssertEqual(config.namespace, "SixLayer", "Should automatically detect SixLayer namespace for tests")
    }
    
    func testAutomaticNamespaceDetectionForRealApps() async {
        // GIVEN: We're simulating a real app environment (not in tests)
        // WHEN: Creating a config (this would normally detect the real app name)
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
        
        // THEN: Should use detected namespace (SixLayer for tests, real app name for real apps)
        XCTAssertNotNil(config.namespace, "Should have a detected namespace")
        XCTAssertFalse(config.namespace.isEmpty, "Namespace should not be empty")
        
        // In test environment, it should be "SixLayer"
        // In real app, it would be the actual app name
        XCTAssertEqual(config.namespace, "SixLayer", "Should detect SixLayer in test environment")
    }
    
    // MARK: - automaticAccessibilityIdentifiers() Modifier Tests
    
    func testAutomaticAccessibilityIdentifiersModifierGeneratesIdentifiersOnIOS() async {
        let view = Text("Test")
            .automaticAccessibilityIdentifiers()
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*", 
            platform: .iOS,
            componentName: "automaticAccessibilityIdentifiers modifier"
        )
        
        XCTAssertTrue(hasAccessibilityID, "automaticAccessibilityIdentifiers modifier should generate accessibility identifiers on iOS")
    }
    
    func testAutomaticAccessibilityIdentifiersModifierGeneratesIdentifiersOnMacOS() async {
        let view = Text("Test")
            .automaticAccessibilityIdentifiers()
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*", 
            platform: .macOS,
            componentName: "automaticAccessibilityIdentifiers modifier"
        )
        
        XCTAssertTrue(hasAccessibilityID, "automaticAccessibilityIdentifiers modifier should generate accessibility identifiers on macOS")
    }
    
    // MARK: - named() Modifier Tests
    
    func testNamedModifierGeneratesIdentifiersOnIOS() async {
        let view = Text("Test")
            .named("TestElement")
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*TestElement.*", 
            platform: .iOS,
            componentName: "named modifier"
        )
        
        XCTAssertTrue(hasAccessibilityID, "named modifier should generate accessibility identifiers on iOS")
    }
    
    func testNamedModifierGeneratesIdentifiersOnMacOS() async {
        let view = Text("Test")
            .named("TestElement")
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*TestElement.*", 
            platform: .macOS,
            componentName: "named modifier"
        )
        
        XCTAssertTrue(hasAccessibilityID, "named modifier should generate accessibility identifiers on macOS")
    }
}

