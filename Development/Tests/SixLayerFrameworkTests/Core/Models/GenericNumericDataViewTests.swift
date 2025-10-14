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
final class GenericNumericDataViewTests {
    
    // MARK: - Test Setup
    
    init() {
        setupTestEnvironment()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
        config.enableAutoIDs = true
        config.namespace = "SixLayer"
        config.mode = .automatic
        config.enableDebugLogging = false
    }
    
    deinit {
        cleanupTestEnvironment()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
    }
    
    // MARK: - GenericNumericDataView Tests
    
    @Test func testGenericNumericDataViewGeneratesAccessibilityIdentifiersOnIOS() async {
        let view = GenericNumericDataView(
            data: [GenericNumericData(value: 123.45, label: "Test Value", unit: "units")],
            hints: PresentationHints()
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.main.element.*", 
            platform: .iOS,
            componentName: "GenericNumericDataView"
        )
        
        #expect(hasAccessibilityID, "GenericNumericDataView should generate accessibility identifiers on iOS")
    }
    
    @Test func testGenericNumericDataViewGeneratesAccessibilityIdentifiersOnMacOS() async {
        let view = GenericNumericDataView(
            data: [GenericNumericData(value: 123.45, label: "Test Value", unit: "units")],
            hints: PresentationHints()
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.main.element.*", 
            platform: .macOS,
            componentName: "GenericNumericDataView"
        )
        
        #expect(hasAccessibilityID, "GenericNumericDataView should generate accessibility identifiers on macOS")
    }
}
