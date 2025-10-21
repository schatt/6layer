import Testing


import SwiftUI
@testable import SixLayerFramework
import ViewInspector

/// Tests for GenericNumericDataView component
/// 
/// BUSINESS PURPOSE: Ensure GenericNumericDataView generates proper accessibility identifiers
/// TESTING SCOPE: GenericNumericDataView component from PlatformSemanticLayer1.swift
/// METHODOLOGY: Test component on both iOS and macOS platforms as required by mandatory testing guidelines
@MainActor
open class GenericNumericDataViewTests {
    
    // MARK: - Test Setup
    
    init() async throws {
        await setupTestEnvironment()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
        config.enableAutoIDs = true
        config.namespace = "SixLayer"
        config.mode = .automatic
        config.enableDebugLogging = false
    }    // MARK: - GenericNumericDataView Tests
    
    
    func setupTestEnvironment() async {
        await AccessibilityTestUtilities.setupAccessibilityTestEnvironment()
    }
    
    func cleanupTestEnvironment() async {
        await AccessibilityTestUtilities.cleanupAccessibilityTestEnvironment()
    }
    
@Test func testGenericNumericDataViewGeneratesAccessibilityIdentifiersOnIOS() async {
        let view = GenericNumericDataView(
            data: [GenericNumericData(value: 123.45, label: "Test Value", unit: "units")],
            hints: PresentationHints()
        )
        
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view, 
            expectedPattern: "SixLayer.main.element.*", 
            platform: SixLayerPlatform.iOS,
            platform: SixLayerPlatform.iOS,
            componentName: "GenericNumericDataView"
        )
        
        #expect(hasAccessibilityID, "GenericNumericDataView should generate accessibility identifiers on iOS")
    }
    
    @Test func testGenericNumericDataViewGeneratesAccessibilityIdentifiersOnMacOS() async {
        let view = GenericNumericDataView(
            data: [GenericNumericData(value: 123.45, label: "Test Value", unit: "units")],
            hints: PresentationHints()
        )
        
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view, 
            expectedPattern: "SixLayer.main.element.*", 
            platform: .macOS,
            platform: SixLayerPlatform.iOS,
            componentName: "GenericNumericDataView"
        )
        
        #expect(hasAccessibilityID, "GenericNumericDataView should generate accessibility identifiers on macOS")
    }
}
