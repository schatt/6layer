import Testing


import SwiftUI
@testable import SixLayerFramework
#if !os(macOS)
import ViewInspector
#endif
/// Tests for GenericNumericDataView component
/// 
/// BUSINESS PURPOSE: Ensure GenericNumericDataView generates proper accessibility identifiers
/// TESTING SCOPE: GenericNumericDataView component from PlatformSemanticLayer1.swift
/// METHODOLOGY: Test component on both iOS and macOS platforms as required by mandatory testing guidelines
@Suite("Generic Numeric Data View")
@MainActor
open class GenericNumericDataViewTests {
    
    // MARK: - Helper Methods
    
    private func setupTestEnvironment() async {
        await AccessibilityTestUtilities.setupAccessibilityTestEnvironment()
    }
    
    private func configureAccessibilityIdentifiers() {
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
        config.enableAutoIDs = true
        config.namespace = "SixLayer"
        config.mode = .automatic
        config.enableDebugLogging = false
    }
    
    private func cleanupTestEnvironment() async {
        await AccessibilityTestUtilities.cleanupAccessibilityTestEnvironment()
    }
    
@Test func testGenericNumericDataViewGeneratesAccessibilityIdentifiersOnIOS() async {
        // Setup test environment
        await setupTestEnvironment()
        configureAccessibilityIdentifiers()
        
        let view = GenericNumericDataView(
            data: [GenericNumericData(value: 123.45, label: "Test Value", unit: "units")],
            hints: PresentationHints()
        )
        
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view, 
            expectedPattern: "SixLayer.*ui", 
            platform: SixLayerPlatform.iOS,
            componentName: "GenericNumericDataView"
        )
        
        #expect(hasAccessibilityID, "GenericNumericDataView should generate accessibility identifiers on iOS")
    }
    
    @Test func testGenericNumericDataViewGeneratesAccessibilityIdentifiersOnMacOS() async {
        // Setup test environment
        await setupTestEnvironment()
        configureAccessibilityIdentifiers()
        
        let view = GenericNumericDataView(
            data: [GenericNumericData(value: 123.45, label: "Test Value", unit: "units")],
            hints: PresentationHints()
        )
        
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view, 
            expectedPattern: "SixLayer.*ui", 
            platform: SixLayerPlatform.iOS,
            componentName: "GenericNumericDataView"
        )
        
        #expect(hasAccessibilityID, "GenericNumericDataView should generate accessibility identifiers on macOS")
    }
}
