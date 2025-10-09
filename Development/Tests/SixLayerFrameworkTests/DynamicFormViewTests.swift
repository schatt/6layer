import XCTest
import SwiftUI
@testable import SixLayerFramework
import ViewInspector

/// Tests for DynamicFormView.swift
/// 
/// BUSINESS PURPOSE: Ensure DynamicFormView generates proper accessibility identifiers
/// TESTING SCOPE: All components in DynamicFormView.swift
/// METHODOLOGY: Test each component on both iOS and macOS platforms as required by mandatory testing guidelines
@MainActor
final class DynamicFormViewTests: XCTestCase {
    
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
    
    // MARK: - DynamicFormView Tests
    
    func testDynamicFormViewGeneratesAccessibilityIdentifiersOnIOS() async {
        let testField = DynamicFormField(
            id: "testField",
            contentType: .text,
            label: "Test Field",
            placeholder: "Enter text",
            isRequired: true,
            validationRules: [:]
        )
        let configuration = DynamicFormConfiguration(id: "testForm", title: "Test Form")
        
        let view = DynamicFormView(
            configuration: configuration,
            fields: [testField]
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*dynamicformview", 
            platform: .iOS,
            componentName: "DynamicFormView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "DynamicFormView should generate accessibility identifiers on iOS")
    }
    
    func testDynamicFormViewGeneratesAccessibilityIdentifiersOnMacOS() async {
        let testField = DynamicFormField(
            id: "testField",
            contentType: .text,
            label: "Test Field",
            placeholder: "Enter text",
            isRequired: true,
            validationRules: [:]
        )
        let configuration = DynamicFormConfiguration(id: "testForm", title: "Test Form")
        
        let view = DynamicFormView(
            configuration: configuration,
            fields: [testField]
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*dynamicformview", 
            platform: .macOS,
            componentName: "DynamicFormView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "DynamicFormView should generate accessibility identifiers on macOS")
    }
}

