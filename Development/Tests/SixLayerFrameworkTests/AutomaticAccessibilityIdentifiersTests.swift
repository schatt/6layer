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
        config.namespace = "SixLayer"
        config.mode = .automatic
        config.enableDebugLogging = false
    }
    
    override func tearDown() {
        try await super.tearDown()
        cleanupTestEnvironment()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
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

