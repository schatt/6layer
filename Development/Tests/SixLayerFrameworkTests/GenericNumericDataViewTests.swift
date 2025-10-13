import XCTest
import SwiftUI
@testable import SixLayerFramework
import ViewInspector

/// Tests for GenericNumericDataView component
/// 
/// BUSINESS PURPOSE: Ensure GenericNumericDataView generates proper accessibility identifiers
/// TESTING SCOPE: GenericNumericDataView component from PlatformSemanticLayer1.swift
/// METHODOLOGY: Test component on both iOS and macOS platforms as required by mandatory testing guidelines
@MainActor
final class GenericNumericDataViewTests: XCTestCase {
    
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
    
    // MARK: - GenericNumericDataView Tests
    
    func testGenericNumericDataViewGeneratesAccessibilityIdentifiersOnIOS() async {
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
        
        XCTAssertTrue(hasAccessibilityID, "GenericNumericDataView should generate accessibility identifiers on iOS")
    }
    
    func testGenericNumericDataViewGeneratesAccessibilityIdentifiersOnMacOS() async {
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
        
        XCTAssertTrue(hasAccessibilityID, "GenericNumericDataView should generate accessibility identifiers on macOS")
    }
}
