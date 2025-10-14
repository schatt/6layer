import Testing
import SwiftUI
@testable import SixLayerFramework

/// Tests for single-instance Layer 1 functions
/// Following TDD principles - these tests define the expected behavior
@MainActor
final class SingleInstanceLayer1Tests {
    
    // MARK: - Test Setup
    
    private var testHints: PresentationHints!
    
    init() {
        testHints = PresentationHints(
            dataType: .numeric,
            presentationPreference: .card,
            complexity: .simple,
            context: .detail,
            customPreferences: [:]
        )
    }
    
    // MARK: - Single Instance Numeric Data Tests
    
    @Test func testPlatformPresentNumericData_L1_SingleInstance() {
        // GIVEN: A single GenericNumericData item
        let singleNumericData = GenericNumericData(
            value: 42.0,
            label: "Test Value",
            unit: "units"
        )
        
        // WHEN: Presenting the single item
        let view = platformPresentNumericData_L1(data: singleNumericData, hints: testHints)
        
        // THEN: Should create a view successfully
        #expect(view != nil, "Single numeric data should create a view")
        
        // Test that the view can be hosted (functional test)
        let hostingView = hostRootPlatformView(view.withGlobalAutoIDsEnabled())
        #expect(hostingView != nil, "Single numeric data view should be hostable")
    }
    
    @Test func testPlatformPresentNumericData_L1_SingleInstance_Consistency() {
        // GIVEN: A single GenericNumericData item
        let singleNumericData = GenericNumericData(
            value: 42.0,
            label: "Test Value",
            unit: "units"
        )
        
        // WHEN: Presenting as single instance and as array
        let singleView = platformPresentNumericData_L1(data: singleNumericData, hints: testHints)
        let arrayView = platformPresentNumericData_L1(data: [singleNumericData], hints: testHints)
        
        // THEN: Both should create views successfully
        #expect(singleView != nil, "Single instance should create a view")
        #expect(arrayView != nil, "Array version should create a view")
        
        // Both should be hostable
        let singleHostingView = hostRootPlatformView(singleView.withGlobalAutoIDsEnabled())
        let arrayHostingView = hostRootPlatformView(arrayView.withGlobalAutoIDsEnabled())
        #expect(singleHostingView != nil, "Single instance view should be hostable")
        #expect(arrayHostingView != nil, "Array version view should be hostable")
    }
    
    // MARK: - Single Instance Media Data Tests
    
    @Test func testPlatformPresentMediaData_L1_SingleInstance() {
        // GIVEN: A single GenericMediaItem
        let singleMediaItem = GenericMediaItem(
            title: "Test Media",
            url: "https://example.com/image.jpg",
            thumbnail: nil
        )
        
        // WHEN: Presenting the single item
        let view = platformPresentMediaData_L1(media: singleMediaItem, hints: testHints)
        
        // THEN: Should create a view successfully
        #expect(view != nil, "Single media item should create a view")
        
        // Test that the view can be hosted (functional test)
        let hostingView = hostRootPlatformView(view.withGlobalAutoIDsEnabled())
        #expect(hostingView != nil, "Single media item view should be hostable")
    }
    
    // MARK: - Single Instance Hierarchical Data Tests
    
    @Test func testPlatformPresentHierarchicalData_L1_SingleInstance() {
        // GIVEN: A single GenericHierarchicalItem
        let singleHierarchicalItem = GenericHierarchicalItem(
            title: "Test Item",
            level: 0,
            children: []
        )
        
        // WHEN: Presenting the single item
        let view = platformPresentHierarchicalData_L1(item: singleHierarchicalItem, hints: testHints)
        
        // THEN: Should create a view successfully
        #expect(view != nil, "Single hierarchical item should create a view")
        
        // Test that the view can be hosted (functional test)
        let hostingView = hostRootPlatformView(view.withGlobalAutoIDsEnabled())
        #expect(hostingView != nil, "Single hierarchical item view should be hostable")
    }
    
    // MARK: - Single Instance Temporal Data Tests
    
    @Test func testPlatformPresentTemporalData_L1_SingleInstance() {
        // GIVEN: A single GenericTemporalItem
        let singleTemporalItem = GenericTemporalItem(
            title: "Test Event",
            date: Date(),
            duration: 3600
        )
        
        // WHEN: Presenting the single item
        let view = platformPresentTemporalData_L1(item: singleTemporalItem, hints: testHints)
        
        // THEN: Should create a view successfully
        #expect(view != nil, "Single temporal item should create a view")
        
        // Test that the view can be hosted (functional test)
        let hostingView = hostRootPlatformView(view.withGlobalAutoIDsEnabled())
        #expect(hostingView != nil, "Single temporal item view should be hostable")
    }
    
    // MARK: - Single Instance Form Data Tests
    
    @Test func testPlatformPresentFormData_L1_SingleInstance() {
        // GIVEN: A single DynamicFormField
        let singleFormField = DynamicFormField(
            id: "test-field",
            contentType: .text,
            label: "Test Field",
            isRequired: false,
            validationRules: [:],
            metadata: [:]
        )
        
        // WHEN: Presenting the single field
        let view = platformPresentFormData_L1(field: singleFormField, hints: testHints)
        
        // THEN: Should create a view successfully (even if deprecated)
        #expect(view != nil, "Single form field should create a view")
        
        // Test that the view can be hosted (functional test)
        let hostingView = hostRootPlatformView(view.withGlobalAutoIDsEnabled())
        #expect(hostingView != nil, "Single form field view should be hostable")
    }
    
    // MARK: - Edge Cases
    
    @Test func testSingleInstanceFunctions_WithDifferentHints() {
        // GIVEN: A single numeric data item and different hint types
        let singleNumericData = GenericNumericData(
            value: 42.0,
            label: "Test Value",
            unit: "units"
        )
        
        let cardHints = PresentationHints(
            dataType: .numeric,
            presentationPreference: .card,
            complexity: .simple,
            context: .detail,
            customPreferences: [:]
        )
        
        let listHints = PresentationHints(
            dataType: .numeric,
            presentationPreference: .list,
            complexity: .simple,
            context: .detail,
            customPreferences: [:]
        )
        
        // WHEN: Presenting with different hints
        let cardView = platformPresentNumericData_L1(data: singleNumericData, hints: cardHints)
        let listView = platformPresentNumericData_L1(data: singleNumericData, hints: listHints)
        
        // THEN: Both should create views successfully
        #expect(cardView != nil, "Card presentation should create a view")
        #expect(listView != nil, "List presentation should create a view")
        
        // Both should be hostable
        let cardHostingView = hostRootPlatformView(cardView.withGlobalAutoIDsEnabled())
        let listHostingView = hostRootPlatformView(listView.withGlobalAutoIDsEnabled())
        #expect(cardHostingView != nil, "Card view should be hostable")
        #expect(listHostingView != nil, "List view should be hostable")
    }
}

// MARK: - Test Extensions

extension SingleInstanceLayer1Tests {
    
    /// Host a SwiftUI view and return the platform root view for inspection
    private func hostRootPlatformView<V: View>(_ view: V) -> Any? {
        #if canImport(UIKit)
        let hostingController = UIHostingController(rootView: view)
        return hostingController.view
        #elseif canImport(AppKit)
        let hostingController = NSHostingController(rootView: view)
        return hostingController.view
        #else
        return nil
        #endif
    }
}
