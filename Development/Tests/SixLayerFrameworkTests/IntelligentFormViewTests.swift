import XCTest
import SwiftUI
@testable import SixLayerFramework
import ViewInspector

/// Tests for IntelligentFormView.swift
/// 
/// BUSINESS PURPOSE: Ensure IntelligentFormView generates proper accessibility identifiers
/// TESTING SCOPE: All components in IntelligentFormView.swift
/// METHODOLOGY: Test each component on both iOS and macOS platforms as required by mandatory testing guidelines
@MainActor
final class IntelligentFormViewTests: XCTestCase {
    
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
    
    // MARK: - IntelligentFormView Tests
    
    func testIntelligentFormViewGeneratesAccessibilityIdentifiersOnIOS() async {
        let testField = DynamicFormField(
            id: "testField",
            contentType: .text,
            label: "Test Field",
            placeholder: "Enter text",
            isRequired: true,
            validationRules: []
        )
        let configuration = DynamicFormConfiguration(id: "testForm", title: "Test Form")
        
        let view = IntelligentFormView(
            configuration: configuration,
            fields: [testField]
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*intelligentformview", 
            platform: .iOS,
            componentName: "IntelligentFormView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "IntelligentFormView should generate accessibility identifiers on iOS")
    }
    
    func testIntelligentFormViewGeneratesAccessibilityIdentifiersOnMacOS() async {
        let testField = DynamicFormField(
            id: "testField",
            contentType: .text,
            label: "Test Field",
            placeholder: "Enter text",
            isRequired: true,
            validationRules: []
        )
        let configuration = DynamicFormConfiguration(id: "testForm", title: "Test Form")
        
        let view = IntelligentFormView(
            configuration: configuration,
            fields: [testField]
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*intelligentformview", 
            platform: .macOS,
            componentName: "IntelligentFormView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "IntelligentFormView should generate accessibility identifiers on macOS")
    }
}
