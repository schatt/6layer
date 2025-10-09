import XCTest
import SwiftUI
@testable import SixLayerFramework
import ViewInspector

/// Tests for ModalFormView component
/// 
/// BUSINESS PURPOSE: Ensure ModalFormView generates proper accessibility identifiers
/// TESTING SCOPE: ModalFormView component from PlatformSemanticLayer1.swift
/// METHODOLOGY: Test component on both iOS and macOS platforms as required by mandatory testing guidelines
@MainActor
final class ModalFormViewTests: XCTestCase {
    
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
    
    // MARK: - ModalFormView Tests
    
    func testModalFormViewGeneratesAccessibilityIdentifiersOnIOS() async {
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
        
        let view = ModalFormView(
            title: "Test Modal",
            fields: testFields,
            onSubmit: { _ in },
            onCancel: {}
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*modalformview", 
            platform: .iOS,
            componentName: "ModalFormView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "ModalFormView should generate accessibility identifiers on iOS")
    }
    
    func testModalFormViewGeneratesAccessibilityIdentifiersOnMacOS() async {
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
        
        let view = ModalFormView(
            title: "Test Modal",
            fields: testFields,
            onSubmit: { _ in },
            onCancel: {}
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*modalformview", 
            platform: .macOS,
            componentName: "ModalFormView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "ModalFormView should generate accessibility identifiers on macOS")
    }
}
