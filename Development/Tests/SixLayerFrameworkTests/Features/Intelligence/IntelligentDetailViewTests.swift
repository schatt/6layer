import Testing


import SwiftUI
@testable import SixLayerFramework
import ViewInspector
/// Tests for IntelligentDetailView.swift
/// 
/// BUSINESS PURPOSE: Ensure IntelligentDetailView generates proper accessibility identifiers
/// TESTING SCOPE: All components in IntelligentDetailView.swift
/// METHODOLOGY: Test each component on both iOS and macOS platforms as required by mandatory testing guidelines
@MainActor
open class IntelligentDetailViewTests {
    
    // MARK: - Test Setup
    
    init() async throws {
        await setupTestEnvironment()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
        config.enableAutoIDs = true
        config.namespace = "SixLayer"
        config.mode = .automatic
        config.enableDebugLogging = false
    }    // MARK: - IntelligentDetailView Tests
    
    
    private func setupTestEnvironment() async {
        await AccessibilityTestUtilities.setupAccessibilityTestEnvironment()
    }
    
    private func cleanupTestEnvironment() async {
        await AccessibilityTestUtilities.cleanupAccessibilityTestEnvironment()
    }
    
@Test func testIntelligentDetailViewGeneratesAccessibilityIdentifiersOnIOS() async {
        let testData = TestDataModel(name: "Test Name", value: 42)
        
        let view = IntelligentDetailView.platformDetailView(for: testData)
        
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view, 
            expectedPattern: "SixLayer.*ui", 
            platform: SixLayerPlatform.iOS,
            componentName: "IntelligentDetailView"
        )
        
        #expect(hasAccessibilityID, "IntelligentDetailView should generate accessibility identifiers on iOS")
    }
    
    @Test func testIntelligentDetailViewGeneratesAccessibilityIdentifiersOnMacOS() async {
        let testData = TestDataModel(name: "Test Name", value: 42)
        
        let view = IntelligentDetailView.platformDetailView(for: testData)
        
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view, 
            expectedPattern: "SixLayer.*ui", 
            platform: SixLayerPlatform.macOS,
            componentName: "IntelligentDetailView"
        )
        
        #expect(hasAccessibilityID, "IntelligentDetailView should generate accessibility identifiers on macOS")
    }
    
    // MARK: - Test All Layout Strategies
    
    @Test func testIntelligentDetailViewCompactLayoutGeneratesAccessibilityIdentifiers() async {
        let testData = TestDataModel(name: "Test Name", value: 42)
        let hints = PresentationHints(
            dataType: .generic,
            presentationPreference: .compact,
            complexity: .simple,
            context: .list,
            customPreferences: [:]
        )
        
        let view = IntelligentDetailView.platformDetailView(for: testData, hints: hints)
        
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view, 
            expectedPattern: "SixLayer.*ui", 
            platform: SixLayerPlatform.iOS,
            componentName: "IntelligentDetailView"
        )
        
        #expect(hasAccessibilityID, "IntelligentDetailView compact layout should generate accessibility identifiers")
    }
    
    @Test func testIntelligentDetailViewStandardLayoutGeneratesAccessibilityIdentifiers() async {
        let testData = TestDataModel(name: "Test Name", value: 42)
        let hints = PresentationHints(
            dataType: .generic,
            presentationPreference: .card,
            complexity: .moderate,
            context: .list,
            customPreferences: [:]
        )
        
        let view = IntelligentDetailView.platformDetailView(for: testData, hints: hints)
        
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view, 
            expectedPattern: "SixLayer.*ui", 
            platform: SixLayerPlatform.iOS,
            componentName: "IntelligentDetailView"
        )
        
        #expect(hasAccessibilityID, "IntelligentDetailView standard layout should generate accessibility identifiers")
    }
    
    @Test func testIntelligentDetailViewDetailedLayoutGeneratesAccessibilityIdentifiers() async {
        let testData = TestDataModel(name: "Test Name", value: 42)
        let hints = PresentationHints(
            dataType: .generic,
            presentationPreference: .detail,
            complexity: .complex,
            context: .list,
            customPreferences: [:]
        )
        
        let view = IntelligentDetailView.platformDetailView(for: testData, hints: hints)
        
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view, 
            expectedPattern: "SixLayer.*ui", 
            platform: SixLayerPlatform.iOS,
            componentName: "IntelligentDetailView"
        )
        
        #expect(hasAccessibilityID, "IntelligentDetailView detailed layout should generate accessibility identifiers")
    }
    
    @Test func testIntelligentDetailViewTabbedLayoutGeneratesAccessibilityIdentifiers() async {
        struct ComplexTestData {
            let field1: String
            let field2: Int
            let field3: Double
            let field4: Bool
            let field5: String
            let field6: Int
            let field7: Double
            let field8: Bool
        }
        
        let testData = ComplexTestData(
            field1: "Value 1", field2: 2, field3: 3.0, field4: true,
            field5: "Value 5", field6: 6, field7: 7.0, field8: false
        )
        let hints = PresentationHints(
            dataType: .generic,
            presentationPreference: .automatic,
            complexity: .veryComplex,
            context: .list,
            customPreferences: [:]
        )
        
        let view = IntelligentDetailView.platformDetailView(for: testData, hints: hints)
        
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view, 
            expectedPattern: "SixLayer.*ui", 
            platform: SixLayerPlatform.iOS,
            componentName: "IntelligentDetailView"
        )
        
        #expect(hasAccessibilityID, "IntelligentDetailView tabbed layout should generate accessibility identifiers")
    }
    
    @Test func testIntelligentDetailViewAdaptiveLayoutGeneratesAccessibilityIdentifiers() async {
        let testData = TestDataModel(name: "Test Name", value: 42)
        // Don't specify hints to trigger adaptive strategy
        let view = IntelligentDetailView.platformDetailView(for: testData, hints: nil)
        
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view, 
            expectedPattern: "SixLayer.*ui", 
            platform: SixLayerPlatform.iOS,
            componentName: "IntelligentDetailView"
        )
        
        #expect(hasAccessibilityID, "IntelligentDetailView adaptive layout should generate accessibility identifiers")
    }
}

// MARK: - Test Support Types

/// Test data model for IntelligentDetailView testing
struct TestDataModel {
    let name: String
    let value: Int
}
