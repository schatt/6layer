import XCTest
import SwiftUI
@testable import SixLayerFramework
import ViewInspector

/// Tests for PlatformFormsLayer4.swift
/// 
/// BUSINESS PURPOSE: Ensure all forms Layer 4 components generate proper accessibility identifiers
/// TESTING SCOPE: All components in PlatformFormsLayer4.swift
/// METHODOLOGY: Test each component on both iOS and macOS platforms as required by mandatory testing guidelines
@MainActor
final class PlatformFormsLayer4Tests: XCTestCase {
    
    // MARK: - Test Setup
    
    override func setUp() {
        super.setUp()
        setupTestEnvironment()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
        config.enableAutoIDs = true
        config.namespace = "SixLayer"
        config.mode = .automatic
        config.enableDebugLogging = false
    }
    
    override func tearDown() {
        super.tearDown()
        cleanupTestEnvironment()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
    }
    
    // MARK: - platformFormContainer_L4 Tests
    
    func testPlatformFormContainerL4GeneratesAccessibilityIdentifiersOnIOS() async {
        let testField = DynamicFormField(
            id: "testField",
            contentType: .text,
            label: "Test Field",
            placeholder: "Enter text",
            isRequired: true,
            validationRules: []
        )
        
        let view = platformFormContainer_L4(fields: [testField])
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*platformformcontainer_l4", 
            platform: .iOS,
            componentName: "platformFormContainer_L4"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformFormContainer_L4 should generate accessibility identifiers on iOS")
    }
    
    func testPlatformFormContainerL4GeneratesAccessibilityIdentifiersOnMacOS() async {
        let testField = DynamicFormField(
            id: "testField",
            contentType: .text,
            label: "Test Field",
            placeholder: "Enter text",
            isRequired: true,
            validationRules: []
        )
        
        let view = platformFormContainer_L4(fields: [testField])
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*platformformcontainer_l4", 
            platform: .macOS,
            componentName: "platformFormContainer_L4"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformFormContainer_L4 should generate accessibility identifiers on macOS")
    }
}

