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
        let testData = TestFormDataModel(name: "Test Name", email: "test@example.com")
        
        let view = IntelligentFormView.generateForm(
            for: TestFormDataModel.self,
            initialData: testData
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
        let testData = TestFormDataModel(name: "Test Name", email: "test@example.com")
        
        let view = IntelligentFormView.generateForm(
            for: TestFormDataModel.self,
            initialData: testData
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

// MARK: - Test Support Types

/// Test form data model for IntelligentFormView testing
struct TestFormDataModel {
    let name: String
    let email: String
}
