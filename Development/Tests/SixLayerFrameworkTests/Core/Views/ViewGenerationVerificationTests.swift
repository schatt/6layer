import Testing


import SwiftUI
@testable import SixLayerFramework
#if !os(macOS)
import ViewInspector
#endif
/// View Generation Verification Tests
/// Tests that the actual SwiftUI views are generated correctly with the right properties and modifiers
/// This verifies the view structure using the new testing pattern: view created + contains expected content
@MainActor
@Suite("View Generation Verification")
struct ViewGenerationVerificationTests {
    
    // MARK: - Test Data
    
    struct TestDataItem: Identifiable {
        let id = UUID()
        let title: String
        let subtitle: String?
        let description: String?
        let value: Int
        let isActive: Bool
    }
    
    var sampleData: [TestDataItem] = []
    
    init() async throws {
        
        sampleData = [
            TestDataItem(title: "Item 1", subtitle: "Subtitle 1", description: "Description 1", value: 42, isActive: true),
            TestDataItem(title: "Item 2", subtitle: nil, description: "Description 2", value: 84, isActive: false),
            TestDataItem(title: "Item 3", subtitle: "Subtitle 3", description: nil, value: 126, isActive: true)
        ]
    }
    
    // MARK: - Real Framework Tests
    
    /// BUSINESS PURPOSE: Verify that IntelligentDetailView actually generates views with proper structure
    /// TESTING SCOPE: Tests that the framework returns views with expected content and layout
    /// METHODOLOGY: Uses ViewInspector to verify actual view structure and content
    @Test @MainActor func testIntelligentDetailViewGeneratesProperStructure() {
        // GIVEN: Test data
        let item = sampleData[0]
        
        // WHEN: Generating an intelligent detail view
        let detailView = IntelligentDetailView.platformDetailView(for: item)
        
        // THEN: Test the two critical aspects
        
        // 1. View created - The view can be instantiated successfully
        // detailView is a non-optional View, so it exists if we reach here
        
        // 2. Contains what it needs to contain - The view has the expected structure and content
        do {
            // The view should be wrapped in AnyView
            let anyView = try detailView.inspect().anyView()
            #expect(anyView != nil, "Detail view should be wrapped in AnyView")
            
            // The view should contain text elements with our data
            let viewText = try detailView.inspect().findAll(ViewType.Text.self)
            #expect(!viewText.isEmpty, "Detail view should contain text elements")
            
            // Should contain the title from our test data
            let hasTitleContent = viewText.contains { text in
                do {
                    let textContent = try text.string()
                    return textContent.contains("Item 1")
                } catch {
                    return false
                }
            }
            #expect(hasTitleContent, "Detail view should contain the title 'Item 1'")
            
            // Should contain the subtitle from our test data
            let hasSubtitleContent = viewText.contains { text in
                do {
                    let textContent = try text.string()
                    return textContent.contains("Subtitle 1")
                } catch {
                    return false
                }
            }
            #expect(hasSubtitleContent, "Detail view should contain the subtitle 'Subtitle 1'")
            
        } catch {
            Issue.record("Failed to inspect detail view structure: \(error)")
        }
    }
    
    /// BUSINESS PURPOSE: Verify that IntelligentDetailView handles different layout strategies
    /// TESTING SCOPE: Tests that different presentation hints result in different view structures
    /// METHODOLOGY: Tests actual framework behavior with different hints
    @Test @MainActor func testIntelligentDetailViewWithDifferentHints() {
        // GIVEN: Test data and different presentation hints
        let item = sampleData[0]
        
        // Test compact layout
        let compactHints = PresentationHints(
            dataType: .generic,
            presentationPreference: .compact,
            complexity: .simple,
            context: .dashboard
        )
        
        // Test detailed layout
        let detailedHints = PresentationHints(
            dataType: .generic,
            presentationPreference: .detail,
            complexity: .complex,
            context: .dashboard
        )
        
        // WHEN: Generating views with different hints
        let compactView = IntelligentDetailView.platformDetailView(for: item, hints: compactHints)
        let detailedView = IntelligentDetailView.platformDetailView(for: item, hints: detailedHints)
        
        // THEN: Test the two critical aspects for both views
        
        // 1. Views created - Both views can be instantiated successfully
        #expect(compactView != nil, "Compact view should be created successfully")
        #expect(detailedView != nil, "Detailed view should be created successfully")
        
        // 2. Contains what it needs to contain - Both views should contain our data
        do {
            // Both views should contain our test data
            let compactText = try compactView.inspect().findAll(ViewType.Text.self)
            let detailedText = try detailedView.inspect().findAll(ViewType.Text.self)
            
            #expect(!compactText.isEmpty, "Compact view should contain text elements")
            #expect(!detailedText.isEmpty, "Detailed view should contain text elements")
            
            // Both should contain the title
            let compactHasTitle = compactText.contains { text in
                do {
                    let textContent = try text.string()
                    return textContent.contains("Item 1")
                } catch {
                    return false
                }
            }
            let detailedHasTitle = detailedText.contains { text in
                do {
                    let textContent = try text.string()
                    return textContent.contains("Item 1")
                } catch {
                    return false
                }
            }
            
            #expect(compactHasTitle, "Compact view should contain the title")
            #expect(detailedHasTitle, "Detailed view should contain the title")
            
        } catch {
            Issue.record("Failed to inspect views with different hints: \(error)")
        }
    }
    
    /// BUSINESS PURPOSE: Verify that IntelligentDetailView handles custom field views
    /// TESTING SCOPE: Tests that custom field views are actually used in the generated view
    /// METHODOLOGY: Tests that custom content appears in the final view
    @Test @MainActor func testIntelligentDetailViewWithCustomFieldView() {
        // GIVEN: Test data and custom field view
        let item = sampleData[0]
        
        // WHEN: Generating view with custom field view
        let detailView = IntelligentDetailView.platformDetailView(
            for: item,
            customFieldView: { fieldName, value, fieldType in
                Text("Custom: \(fieldName) = \(value)")
            }
        )
        
        // THEN: Test the two critical aspects
        
        // 1. View created - The view can be instantiated successfully
        #expect(detailView != nil, "Detail view with custom field view should be created successfully")
        
        // 2. Contains what it needs to contain - The view should contain custom field content
        do {
            // The view should contain text elements
            let viewText = try detailView.inspect().findAll(ViewType.Text.self)
            #expect(!viewText.isEmpty, "Detail view should contain text elements")
            
            // Should contain custom field content
            let hasCustomContent = viewText.contains { text in
                do {
                    let textContent = try text.string()
                    return textContent.contains("Custom:") && textContent.contains("=")
                } catch {
                    return false
                }
            }
            #expect(hasCustomContent, "Detail view should contain custom field content")
            
        } catch {
            Issue.record("Failed to inspect detail view with custom field view: \(error)")
        }
    }
    
    /// BUSINESS PURPOSE: Verify that IntelligentDetailView handles nil values gracefully
    /// TESTING SCOPE: Tests that views with nil values still generate properly
    /// METHODOLOGY: Tests actual framework behavior with nil data
    @Test @MainActor func testIntelligentDetailViewWithNilValues() {
        // GIVEN: Test data with nil values
        let item = sampleData[1] // This has nil subtitle
        
        // WHEN: Generating an intelligent detail view
        let detailView = IntelligentDetailView.platformDetailView(for: item)
        
        // THEN: Test the two critical aspects
        
        // 1. View created - The view can be instantiated successfully
        #expect(detailView != nil, "Detail view with nil values should be created successfully")
        
        // 2. Contains what it needs to contain - The view should contain available data
        do {
            // The view should contain text elements
            let viewText = try detailView.inspect().findAll(ViewType.Text.self)
            #expect(!viewText.isEmpty, "Detail view should contain text elements")
            
            // Should contain the title (which is not nil)
            let hasTitleContent = viewText.contains { text in
                do {
                    let textContent = try text.string()
                    return textContent.contains("Item 2")
                } catch {
                    return false
                }
            }
            #expect(hasTitleContent, "Detail view should contain the title 'Item 2'")
            
            // Should contain the description (which is not nil)
            let hasDescriptionContent = viewText.contains { text in
                do {
                    let textContent = try text.string()
                    return textContent.contains("Description 2")
                } catch {
                    return false
                }
            }
            #expect(hasDescriptionContent, "Detail view should contain the description 'Description 2'")
            
        } catch {
            Issue.record("Failed to inspect detail view with nil values: \(error)")
        }
    }
    
    /// BUSINESS PURPOSE: Verify that DataIntrospectionEngine actually analyzes data correctly
    /// TESTING SCOPE: Tests that the data analysis returns expected results
    /// METHODOLOGY: Tests actual analysis results, not just that analysis runs
    @Test func testDataIntrospectionEngineAnalyzesDataCorrectly() {
        // GIVEN: Test data
        let item = sampleData[0]
        
        // WHEN: Analyzing the data
        let analysis = DataIntrospectionEngine.analyze(item)
        
        // THEN: Test the two critical aspects
        
        // 1. Analysis created - The analysis should be created successfully
        #expect(analysis != nil, "Data analysis should be created successfully")
        
        // 2. Contains what it needs to contain - The analysis should contain expected data
        #expect(!analysis.fields.isEmpty, "Analysis should contain fields")
        #expect(analysis.complexity != nil, "Analysis should have complexity assessment")
        #expect(analysis.patterns != nil, "Analysis should have pattern detection")
        
        // Should contain fields for our test data properties
        let fieldNames = analysis.fields.map { $0.name }
        #expect(fieldNames.contains("title"), "Analysis should contain 'title' field")
        #expect(fieldNames.contains("subtitle"), "Analysis should contain 'subtitle' field")
        #expect(fieldNames.contains("description"), "Analysis should contain 'description' field")
        #expect(fieldNames.contains("value"), "Analysis should contain 'value' field")
        #expect(fieldNames.contains("isActive"), "Analysis should contain 'isActive' field")
    }
    
    /// BUSINESS PURPOSE: Verify that layout strategy determination works correctly
    /// TESTING SCOPE: Tests that different data complexities result in appropriate layout strategies
    /// METHODOLOGY: Tests actual strategy selection based on data analysis
    @Test @MainActor func testLayoutStrategyDeterminationWorksCorrectly() {
        // GIVEN: Different data complexities
        let simpleData = TestDataItem(
            title: "Simple",
            subtitle: nil,
            description: nil,
            value: 1,
            isActive: true
        )
        
        let complexData = TestDataItem(
            title: "Complex Item with Very Long Title That Should Impact Layout Decisions",
            subtitle: "This is a very detailed subtitle that provides extensive context",
            description: "This is an extremely detailed and comprehensive description that contains a lot of information and should trigger a more sophisticated layout strategy.",
            value: 999,
            isActive: true
        )
        
        // WHEN: Analyzing data and determining layout strategies
        let simpleAnalysis = DataIntrospectionEngine.analyze(simpleData)
        let complexAnalysis = DataIntrospectionEngine.analyze(complexData)
        
        let simpleStrategy = IntelligentDetailView.determineLayoutStrategy(analysis: simpleAnalysis, hints: nil)
        let complexStrategy = IntelligentDetailView.determineLayoutStrategy(analysis: complexAnalysis, hints: nil)
        
        // THEN: Test the two critical aspects
        
        // 1. Strategies created - Both strategies should be determined successfully
        #expect(simpleStrategy != nil, "Simple data should have a layout strategy")
        #expect(complexStrategy != nil, "Complex data should have a layout strategy")
        
        // 2. Contains what it needs to contain - Strategies should be appropriate for data complexity
        // Simple data should get compact or standard layout
        #expect([DetailLayoutStrategy.compact, DetailLayoutStrategy.standard].contains(simpleStrategy), 
                     "Simple data should get compact or standard layout")
        
        // Complex data should get detailed or tabbed layout
        #expect([DetailLayoutStrategy.detailed, DetailLayoutStrategy.tabbed].contains(complexStrategy), 
                     "Complex data should get detailed or tabbed layout")
    }
}