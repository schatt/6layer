import Testing


import SwiftUI
@testable import SixLayerFramework
import ViewInspector
/// Tests for IntelligentFormView.swift
/// 
/// BUSINESS PURPOSE: Ensure IntelligentFormView generates proper accessibility identifiers
/// TESTING SCOPE: All components in IntelligentFormView.swift
/// METHODOLOGY: Test each component on both iOS and macOS platforms as required by mandatory testing guidelines
@Suite("Intelligent Form View")
@MainActor
open class IntelligentFormViewTests: BaseTestClass {
    
@Test func testIntelligentFormViewGeneratesAccessibilityIdentifiersOnIOS() {
        runWithTaskLocalConfig {

            let testData = TestFormDataModel(name: "Test Name", email: "test@example.com")
        
            let view = IntelligentFormView.generateForm(
                for: TestFormDataModel.self,
                initialData: testData
            )
            let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
                view, 
                expectedPattern: "SixLayer.*ui", 
                platform: SixLayerPlatform.iOS,
                componentName: "IntelligentFormView"
            )
        
            #expect(hasAccessibilityID, "IntelligentFormView should generate accessibility identifiers on iOS")
        }
    }

    
    @Test func testIntelligentFormViewGeneratesAccessibilityIdentifiersOnMacOS() {
        runWithTaskLocalConfig {

            let testData = TestFormDataModel(name: "Test Name", email: "test@example.com")
        
            let view = IntelligentFormView.generateForm(
                for: TestFormDataModel.self,
                initialData: testData
            )
            let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
                view, 
                expectedPattern: "SixLayer.*ui", 
                platform: SixLayerPlatform.macOS,
                componentName: "IntelligentFormView"
            )
        
            #expect(hasAccessibilityID, "IntelligentFormView should generate accessibility identifiers on macOS")
        }
    }

}

// MARK: - Test Support Types

/// Test form data model for IntelligentFormView testing
struct TestFormDataModel {
    let name: String
    let email: String
}

