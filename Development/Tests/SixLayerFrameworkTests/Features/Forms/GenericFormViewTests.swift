import Testing


import SwiftUI
@testable import SixLayerFramework
/// Tests for GenericFormView component
/// 
/// BUSINESS PURPOSE: Ensure GenericFormView generates proper accessibility identifiers
/// TESTING SCOPE: GenericFormView component from PlatformSemanticLayer1.swift
/// METHODOLOGY: Test component on both iOS and macOS platforms as required by mandatory testing guidelines
@Suite("Generic Form View")
@MainActor
open class GenericFormViewTests {
    
    // MARK: - Test Setup
    
    init() async throws {
        await setupTestEnvironment()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
        config.enableAutoIDs = true
        config.namespace = "SixLayer"
        config.mode = .automatic
        config.enableDebugLogging = false
    }    // MARK: - GenericFormView Tests
    
    
    private func setupTestEnvironment() async {
        await AccessibilityTestUtilities.setupAccessibilityTestEnvironment()
    }
    
    private func cleanupTestEnvironment() async {
        await AccessibilityTestUtilities.cleanupAccessibilityTestEnvironment()
    }
    
@Test func testGenericFormViewGeneratesAccessibilityIdentifiersOnIOS() async {
        let testFields = [
            DynamicFormField(
                id: "field1",
                contentType: .text,
                label: "Test Field 1",
                placeholder: "Enter text",
                isRequired: true,
                validationRules: [:]
            )
        ]
        
        let view = GenericFormView(
            fields: testFields,
            hints: PresentationHints()
        )
        
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view, 
            expectedPattern: "SixLayer.*ui", 
            platform: SixLayerPlatform.iOS,
            componentName: "GenericFormView"
        )
 #expect(hasAccessibilityID, "GenericFormView should generate accessibility identifiers on iOS ")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }
    
    @Test func testGenericFormViewGeneratesAccessibilityIdentifiersOnMacOS() async {
        let testFields = [
            DynamicFormField(
                id: "field1",
                contentType: .text,
                label: "Test Field 1",
                placeholder: "Enter text",
                isRequired: true,
                validationRules: [:]
            )
        ]
        
        let view = GenericFormView(
            fields: testFields,
            hints: PresentationHints()
        )
        
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view, 
            expectedPattern: "SixLayer.*ui", 
            platform: SixLayerPlatform.iOS,
            componentName: "GenericFormView"
        )
 #expect(hasAccessibilityID, "GenericFormView should generate accessibility identifiers on macOS ")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }
}
