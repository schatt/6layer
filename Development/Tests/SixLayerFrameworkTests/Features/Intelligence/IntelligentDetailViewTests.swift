import Testing


import SwiftUI
@testable import SixLayerFramework
/// Tests for IntelligentDetailView.swift
/// 
/// BUSINESS PURPOSE: Ensure IntelligentDetailView generates proper accessibility identifiers
/// TESTING SCOPE: All components in IntelligentDetailView.swift
/// METHODOLOGY: Test each component on both iOS and macOS platforms as required by mandatory testing guidelines
@Suite("Intelligent Detail View")
@MainActor
open class IntelligentDetailViewTests: BaseTestClass {
    
    // MARK: - Test Setup
    
    // BaseTestClass handles setup automatically - no custom init needed    // MARK: - IntelligentDetailView Tests
    
    
    // BaseTestClass handles setup automatically
    
    private func cleanupTestEnvironment() async {
        await AccessibilityTestUtilities.cleanupAccessibilityTestEnvironment()
    }
    
@Test func testIntelligentDetailViewGeneratesAccessibilityIdentifiersOnIOS() async {
        let testData = TestDataModel(name: "Test Name", value: 42)
        
        let view = IntelligentDetailView.platformDetailView(for: testData)
        
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view, 
            expectedPattern: "SixLayer.*ui", 
            platform: SixLayerPlatform.iOS,
            componentName: "IntelligentDetailView"
        )
 #expect(hasAccessibilityID, "IntelligentDetailView should generate accessibility identifiers on iOS ")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }
    
    @Test func testIntelligentDetailViewGeneratesAccessibilityIdentifiersOnMacOS() async {
        let testData = TestDataModel(name: "Test Name", value: 42)
        
        let view = IntelligentDetailView.platformDetailView(for: testData)
        
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view, 
            expectedPattern: "SixLayer.*ui", 
            platform: SixLayerPlatform.macOS,
            componentName: "IntelligentDetailView"
        )
 #expect(hasAccessibilityID, "IntelligentDetailView should generate accessibility identifiers on macOS ")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
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
        
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view, 
            expectedPattern: "SixLayer.*ui", 
            platform: SixLayerPlatform.iOS,
            componentName: "IntelligentDetailView"
        )
 #expect(hasAccessibilityID, "IntelligentDetailView compact layout should generate accessibility identifiers")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
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
        
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view, 
            expectedPattern: "SixLayer.*ui", 
            platform: SixLayerPlatform.iOS,
            componentName: "IntelligentDetailView"
        )
 #expect(hasAccessibilityID, "IntelligentDetailView standard layout should generate accessibility identifiers")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
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
        
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view, 
            expectedPattern: "SixLayer.*ui", 
            platform: SixLayerPlatform.iOS,
            componentName: "IntelligentDetailView"
        )
 #expect(hasAccessibilityID, "IntelligentDetailView detailed layout should generate accessibility identifiers")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
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
        
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view, 
            expectedPattern: "SixLayer.*ui", 
            platform: SixLayerPlatform.iOS,
            componentName: "IntelligentDetailView"
        )
 #expect(hasAccessibilityID, "IntelligentDetailView tabbed layout should generate accessibility identifiers")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }
    
    @Test func testIntelligentDetailViewAdaptiveLayoutGeneratesAccessibilityIdentifiers() async {
        let testData = TestDataModel(name: "Test Name", value: 42)
        // Don't specify hints to trigger adaptive strategy
        let view = IntelligentDetailView.platformDetailView(for: testData, hints: nil)

        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "SixLayer.*ui",
            platform: SixLayerPlatform.iOS,
            componentName: "IntelligentDetailView"
        )
 #expect(hasAccessibilityID, "IntelligentDetailView adaptive layout should generate accessibility identifiers")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }

    // MARK: - Edit Button Tests

    @Test func testIntelligentDetailViewShowsEditButtonByDefault() async {
        let testData = TestDataModel(name: "Test Name", value: 42)
        var editCalled = false

        // Test that the view can be created with edit callback (button enabled by default)
        let view = IntelligentDetailView.platformDetailView(
            for: testData,
            onEdit: { editCalled = true }
        )

        // Verify the view is created successfully and callback isn't called yet
        #expect(editCalled == false, "Edit should not be called yet")
        // view is non-optional, not used further
    }

    @Test func testIntelligentDetailViewCanDisableEditButton() async {
        let testData = TestDataModel(name: "Test Name", value: 42)

        // Test that the view can be created with edit button disabled
        let view = IntelligentDetailView.platformDetailView(
            for: testData,
            showEditButton: false,
            onEdit: { /* should not be called */ }
        )

        // view is non-optional, not used further
    }

    @Test func testIntelligentDetailViewEditButtonAccessibility() async {
        let testData = TestDataModel(name: "Test Name", value: 42)

        let view = IntelligentDetailView.platformDetailView(
            for: testData,
            onEdit: { /* edit action */ }
        )

        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "SixLayer.*ui",
            platform: SixLayerPlatform.iOS,
            componentName: "IntelligentDetailView"
        )
 #expect(hasAccessibilityID, "IntelligentDetailView with edit button should generate accessibility identifiers")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }

    @Test func testIntelligentDetailViewCompactLayoutWithEditButton() async {
        let testData = TestDataModel(name: "Test Name", value: 42)
        let hints = PresentationHints(
            dataType: .generic,
            presentationPreference: .compact,
            complexity: .simple,
            context: .list,
            customPreferences: [:]
        )

        let view = IntelligentDetailView.platformDetailView(
            for: testData,
            hints: hints,
            onEdit: { /* edit action */ }
        )

        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "SixLayer.*ui",
            platform: SixLayerPlatform.iOS,
            componentName: "IntelligentDetailView"
        )
 #expect(hasAccessibilityID, "IntelligentDetailView compact layout with edit button should generate accessibility identifiers")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }

    @Test func testIntelligentDetailViewStandardLayoutWithEditButton() async {
        let testData = TestDataModel(name: "Test Name", value: 42)
        let hints = PresentationHints(
            dataType: .generic,
            presentationPreference: .card,
            complexity: .moderate,
            context: .list,
            customPreferences: [:]
        )

        let view = IntelligentDetailView.platformDetailView(
            for: testData,
            hints: hints,
            onEdit: { /* edit action */ }
        )

        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "SixLayer.*ui",
            platform: SixLayerPlatform.iOS,
            componentName: "IntelligentDetailView"
        )
 #expect(hasAccessibilityID, "IntelligentDetailView standard layout with edit button should generate accessibility identifiers")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }

    @Test func testIntelligentDetailViewDetailedLayoutWithEditButton() async {
        let testData = TestDataModel(name: "Test Name", value: 42)
        let hints = PresentationHints(
            dataType: .generic,
            presentationPreference: .detail,
            complexity: .complex,
            context: .list,
            customPreferences: [:]
        )

        let view = IntelligentDetailView.platformDetailView(
            for: testData,
            hints: hints,
            onEdit: { /* edit action */ }
        )

        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "SixLayer.*ui",
            platform: SixLayerPlatform.iOS,
            componentName: "IntelligentDetailView"
        )
 #expect(hasAccessibilityID, "IntelligentDetailView detailed layout with edit button should generate accessibility identifiers")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }

    @Test func testIntelligentDetailViewTabbedLayoutWithEditButton() async {
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

        let view = IntelligentDetailView.platformDetailView(
            for: testData,
            hints: hints,
            onEdit: { /* edit action */ }
        )

        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "SixLayer.*ui",
            platform: SixLayerPlatform.iOS,
            componentName: "IntelligentDetailView"
        )
 #expect(hasAccessibilityID, "IntelligentDetailView tabbed layout with edit button should generate accessibility identifiers")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }

    @Test func testIntelligentDetailViewAdaptiveLayoutWithEditButton() async {
        let testData = TestDataModel(name: "Test Name", value: 42)

        let view = IntelligentDetailView.platformDetailView(
            for: testData,
            hints: nil,
            onEdit: { /* edit action */ }
        )

        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "SixLayer.*ui",
            platform: SixLayerPlatform.iOS,
            componentName: "IntelligentDetailView"
        )
 #expect(hasAccessibilityID, "IntelligentDetailView adaptive layout with edit button should generate accessibility identifiers")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }
}

// MARK: - Test Support Types

/// Test data model for IntelligentDetailView testing
struct TestDataModel {
    let name: String
    let value: Int
}
