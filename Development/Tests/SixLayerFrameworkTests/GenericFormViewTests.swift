import XCTest
import SwiftUI
@testable import SixLayerFramework
import ViewInspector

/// Tests for GenericFormView component
/// 
/// BUSINESS PURPOSE: Ensure GenericFormView generates proper accessibility identifiers
/// TESTING SCOPE: GenericFormView component from PlatformSemanticLayer1.swift
/// METHODOLOGY: Test component on both iOS and macOS platforms as required by mandatory testing guidelines
@MainActor
final class GenericFormViewTests: XCTestCase {
    
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
    
    // MARK: - GenericFormView Tests
    
    func testGenericFormViewGeneratesAccessibilityIdentifiersOnIOS() async {
        let testFields = [
            DynamicFormField(
                id: "field1",
                label: "Test Field 1",
                type: .text,
                placeholder: "Enter text",
                isRequired: true,
                validationRules: [:]
            )
        ]
        
        let view = GenericFormView(
            fields: testFields,
            onSubmit: { _ in }
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*genericformview", 
            platform: .iOS,
            componentName: "GenericFormView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "GenericFormView should generate accessibility identifiers on iOS")
    }
    
    func testGenericFormViewGeneratesAccessibilityIdentifiersOnMacOS() async {
        let testFields = [
            DynamicFormField(
                id: "field1",
                label: "Test Field 1",
                type: .text,
                placeholder: "Enter text",
                isRequired: true,
                validationRules: [:]
            )
        ]
        
        let view = GenericFormView(
            fields: testFields,
            onSubmit: { _ in }
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*genericformview", 
            platform: .macOS,
            componentName: "GenericFormView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "GenericFormView should generate accessibility identifiers on macOS")
    }
}
