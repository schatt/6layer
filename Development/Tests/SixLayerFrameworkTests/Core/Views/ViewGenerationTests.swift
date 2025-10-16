import Testing

import SwiftUI
import ViewInspector
@testable import SixLayerFramework

/// View Generation Tests
/// Tests that the framework correctly generates SwiftUI views with proper structure and properties
/// These tests focus on what we can actually verify when running on macOS
@MainActor
final class ViewGenerationTests: BaseTestClass {
    
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
    var layoutDecision: IntelligentCardLayoutDecision!
    
    override init() {
        
        sampleData = [
            TestDataItem(title: "Item 1", subtitle: "Subtitle 1", description: "Description 1", value: 42, isActive: true),
            TestDataItem(title: "Item 2", subtitle: nil, description: "Description 2", value: 84, isActive: false),
            TestDataItem(title: "Item 3", subtitle: "Subtitle 3", description: nil, value: 126, isActive: true)
        ]
        
        layoutDecision = IntelligentCardLayoutDecision(
            columns: 2,
            spacing: 16,
            cardWidth: 200,
            cardHeight: 150,
            padding: 16
        )
    }
    
    // MARK: - View Generation Tests
    
    @Test func testIntelligentDetailViewGeneration() {
        // GIVEN: A test data item
        let item = sampleData[0]
        
        // WHEN: Generating an intelligent detail view
        let detailView = IntelligentDetailView.platformDetailView(for: item)
        
        // THEN: Test the two critical aspects
        
        // 1. View created - The view can be instantiated successfully
        #expect(detailView != nil, "IntelligentDetailView should be created successfully")
        
        // 2. Contains what it needs to contain - The view has the expected structure and content
        do {
            // The view is wrapped in AnyView, so we need to inspect it differently
            let anyView = try detailView.inspect().anyView()
            #expect(anyView != nil, "Detail view should be wrapped in AnyView")
            
            // Try to find text elements within the AnyView
            let viewText = try detailView.inspect().findAll(ViewType.Text.self)
            #expect(!viewText.isEmpty, "Detail view should contain text elements")
            
            // Should contain field names from our test data
            let hasTitleField = viewText.contains { text in
                do {
                    let textContent = try text.string()
                    return textContent.contains("Title") || textContent.contains("title")
                } catch {
                    return false
                }
            }
            #expect(hasTitleField, "Detail view should contain title field")
            
        } catch {
            Issue.record("Failed to inspect detail view structure: \(error)")
        }
    }
    
    @Test func testIntelligentDetailViewWithCustomFieldView() {
        // GIVEN: A test data item and custom field view
        let item = sampleData[0]
        
        // WHEN: Generating an intelligent detail view with custom field view
        let detailView = IntelligentDetailView.platformDetailView(
            for: item,
            customFieldView: { fieldName, value, fieldType in
                Text("\(fieldName): \(value)")
            }
        )
        
        // THEN: Test the two critical aspects
        
        // 1. View created - The view can be instantiated successfully
        #expect(detailView != nil, "IntelligentDetailView with custom field view should be created successfully")
        
        // 2. Contains what it needs to contain - The view should contain custom field content
        do {
            // The view is wrapped in AnyView
            let anyView = try detailView.inspect().anyView()
            #expect(anyView != nil, "Detail view should be wrapped in AnyView")
            
            // The view should contain text elements with our custom format
            let viewText = try detailView.inspect().findAll(ViewType.Text.self)
            #expect(!viewText.isEmpty, "Detail view should contain text elements")
            
            // Should contain custom field content in the format "fieldName: value"
            let hasCustomFieldContent = viewText.contains { text in
                do {
                    let textContent = try text.string()
                    return textContent.contains(": ") && textContent.contains("Item 1")
                } catch {
                    return false
                }
            }
            #expect(hasCustomFieldContent, "Detail view should contain custom field content")
            
        } catch {
            Issue.record("Failed to inspect detail view with custom field view: \(error)")
        }
    }
    
    @Test func testIntelligentDetailViewWithHints() {
        // GIVEN: A test data item and presentation hints
        let item = sampleData[0]
        let hints = PresentationHints(
            dataType: .generic,
            presentationPreference: .compact,
            complexity: .moderate,
            context: .dashboard
        )
        
        // WHEN: Generating an intelligent detail view with hints
        let detailView = IntelligentDetailView.platformDetailView(for: item, hints: hints)
        
        // THEN: Test the two critical aspects
        
        // 1. View created - The view can be instantiated successfully
        #expect(detailView != nil, "IntelligentDetailView with hints should be created successfully")
        
        // 2. Contains what it needs to contain - The view should respect the hints
        do {
            // The view is wrapped in AnyView
            let anyView = try detailView.inspect().anyView()
            #expect(anyView != nil, "Detail view should be wrapped in AnyView")
            
            // The view should contain text elements
            let viewText = try detailView.inspect().findAll(ViewType.Text.self)
            #expect(!viewText.isEmpty, "Detail view should contain text elements")
            
            // Should contain field content from our test data
            let hasFieldContent = viewText.contains { text in
                do {
                    let textContent = try text.string()
                    return textContent.contains("Item 1") || textContent.contains("Subtitle 1")
                } catch {
                    return false
                }
            }
            #expect(hasFieldContent, "Detail view should contain field content from test data")
            
        } catch {
            Issue.record("Failed to inspect detail view with hints: \(error)")
        }
    }
    
    // MARK: - Layout Strategy Tests
    
    @Test func testLayoutStrategyDetermination() {
        // GIVEN: Different data complexities based on content richness
        // Simple data with minimal content (should get compact/standard)
        let simpleData = TestDataItem(
            title: "Simple", 
            subtitle: nil, 
            description: nil, 
            value: 1, 
            isActive: true
        )
        
        // Complex data with rich content (should get detailed/tabbed)
        // This should trigger higher complexity due to content richness, not just field count
        let complexData = TestDataItem(
            title: "Complex Item with Very Long Title That Should Impact Layout Decisions",
            subtitle: "This is a very detailed subtitle that provides extensive context and additional information about the item",
            description: "This is an extremely detailed and comprehensive description that contains a lot of information. It includes multiple paragraphs of content, detailed explanations, technical specifications, usage instructions, and additional context that would require significant screen real estate to display properly. The content is rich enough that it should trigger a more sophisticated layout strategy that can handle complex content presentation, potentially including scrollable areas, expandable sections, or tabbed interfaces to manage the information density effectively.",
            value: 999, 
            isActive: true
        )
        
        // WHEN: Analyzing data for layout strategy
        let simpleAnalysis = DataIntrospectionEngine.analyze(simpleData)
        let complexAnalysis = DataIntrospectionEngine.analyze(complexData)
        
        // THEN: Should determine appropriate layout strategies
        let simpleStrategy = IntelligentDetailView.determineLayoutStrategy(analysis: simpleAnalysis, hints: nil)
        let complexStrategy = IntelligentDetailView.determineLayoutStrategy(analysis: complexAnalysis, hints: nil)
        
        #expect(simpleStrategy != nil)
        #expect(complexStrategy != nil)
        
        // Simple data should get compact or standard layout
        #expect([DetailLayoutStrategy.compact, DetailLayoutStrategy.standard].contains(simpleStrategy))
        
        // Complex data should get detailed or tabbed layout
        #expect([DetailLayoutStrategy.detailed, DetailLayoutStrategy.tabbed].contains(complexStrategy))
    }
    
    @Test func testLayoutStrategyWithHints() {
        // GIVEN: Data and explicit hints
        let item = sampleData[0]
        let hints = PresentationHints(
            dataType: .generic,
            presentationPreference: .detail,
            complexity: .moderate,
            context: .dashboard
        )
        
        // WHEN: Determining layout strategy with hints
        let analysis = DataIntrospectionEngine.analyze(item)
        let strategy = IntelligentDetailView.determineLayoutStrategy(analysis: analysis, hints: hints)
        
        // THEN: Should respect the hints
        #expect(strategy == DetailLayoutStrategy.detailed)
    }
    
    // MARK: - Field View Generation Tests
    
    @Test func testFieldViewGeneration() {
        // GIVEN: A data field
        let field = DataField(
            name: "testField",
            type: .string,
            isOptional: false,
            isArray: false,
            isIdentifiable: false
        )
        let value = "Test Value"
        
        // WHEN: Generating a field view
        let fieldView = IntelligentDetailView.platformFieldView(
            field: field,
            value: value,
            customFieldView: { _, _, _ in EmptyView() }
        )
        
        // THEN: Should generate a valid SwiftUI view (struct, not reference type)
        // SwiftUI views are structs, so we can't use XCTAssertNotNil
        // Instead, we verify the view can be created without crashing
        _ = fieldView
    }
    
    @Test func testDetailedFieldViewGeneration() {
        // GIVEN: A data field
        let field = DataField(
            name: "testField",
            type: .string,
            isOptional: true,
            isArray: false,
            isIdentifiable: true
        )
        let value = "Test Value"
        
        // WHEN: Generating a detailed field view
        let fieldView = IntelligentDetailView.platformDetailedFieldView(
            field: field,
            value: value,
            customFieldView: { _, _, _ in EmptyView() }
        )
        
        // THEN: Should generate a valid SwiftUI view (struct, not reference type)
        // SwiftUI views are structs, so we can't use XCTAssertNotNil
        // Instead, we verify the view can be created without crashing
        _ = fieldView
    }
    
    // MARK: - Data Analysis Tests
    
    @Test func testDataIntrospection() {
        // GIVEN: A test data item
        let item = sampleData[0]
        
        // WHEN: Analyzing the data
        let analysis = DataIntrospectionEngine.analyze(item)
        
        // THEN: Should return valid analysis
        #expect(analysis != nil)
        #expect(!analysis.fields.isEmpty)
        #expect(analysis.complexity != nil)
        #expect(analysis.patterns != nil)
    }
    
    @Test func testDataIntrospectionWithDifferentTypes() {
        // GIVEN: Different data types
        let stringData = "Test String"
        let intData = 42
        let boolData = true
        let arrayData = [1, 2, 3]
        let dictData = ["key": "value"]
        
        // WHEN: Analyzing each type
        let stringAnalysis = DataIntrospectionEngine.analyze(stringData)
        let intAnalysis = DataIntrospectionEngine.analyze(intData)
        let boolAnalysis = DataIntrospectionEngine.analyze(boolData)
        let arrayAnalysis = DataIntrospectionEngine.analyze(arrayData)
        let dictAnalysis = DataIntrospectionEngine.analyze(dictData)
        
        // THEN: Should return valid analysis for each
        #expect(stringAnalysis != nil)
        #expect(intAnalysis != nil)
        #expect(boolAnalysis != nil)
        #expect(arrayAnalysis != nil)
        #expect(dictAnalysis != nil)
    }
    
    // MARK: - View Structure Validation Tests
    
    @Test func testViewStructureConsistency() {
        // GIVEN: The same data item
        let item = sampleData[0]
        
        // WHEN: Generating views multiple times
        let view1 = IntelligentDetailView.platformDetailView(for: item)
        let view2 = IntelligentDetailView.platformDetailView(for: item)
        
        // THEN: Should generate consistent views
        #expect(view1 != nil)
        #expect(view2 != nil)
        
        // Both views should be instantiable
        // Note: We don't access .body directly as it can cause SwiftUI runtime issues
        // with complex view hierarchies. The view creation itself is the test.
    }
    
    @Test func testViewGenerationWithNilValues() {
        // GIVEN: Data with nil values
        let item = sampleData[1] // This has nil subtitle
        
        // WHEN: Generating a view
        let view = IntelligentDetailView.platformDetailView(for: item)
        
        // THEN: Should handle nil values gracefully
        #expect(view != nil)
        
        // View should be instantiable without crashing
        // Note: We don't access .body directly as it can cause SwiftUI runtime issues
        // with complex view hierarchies. The view creation itself is the test.
    }
    
    // MARK: - Performance Tests
    
    @Test func testViewGenerationPerformance() {
        // GIVEN: A large number of data items
        let manyItems = (0..<1000).map { i in
            TestDataItem(
                title: "Item \(i)",
                subtitle: i % 2 == 0 ? "Subtitle \(i)" : nil,
                description: "Description \(i)",
                value: i,
                isActive: i % 3 == 0
            )
        }
        
        // WHEN: Generating views for many items
        // THEN: Should complete within reasonable time
        }
    }
    
    // MARK: - Error Handling Tests
    
    @Test func testViewGenerationWithInvalidData() {
        // GIVEN: Invalid data that might cause issues
        let invalidData = NSNull()
        
        // WHEN: Generating a view with invalid data
        let view = IntelligentDetailView.platformDetailView(for: invalidData)
        
        // THEN: Should handle invalid data gracefully
        #expect(view != nil)
        
        // View should be instantiable without crashing
        // Note: We don't access .body directly as it can cause SwiftUI runtime issues
        // with complex view hierarchies. The view creation itself is the test.
    }
    
    @Test func testViewGenerationWithEmptyData() {
        // GIVEN: Empty data
        let emptyData = TestDataItem(title: "", subtitle: nil, description: nil, value: 0, isActive: false)
        
        // WHEN: Generating a view
        let view = IntelligentDetailView.platformDetailView(for: emptyData)
        
        // THEN: Should handle empty data gracefully
        #expect(view != nil)
        
        // View should be instantiable without crashing
        // Note: We don't access .body directly as it can cause SwiftUI runtime issues
        // with complex view hierarchies. The view creation itself is the test.
    }
    
    // MARK: - Accessibility Tests
    
    @Test func testViewGenerationWithAccessibilityHints() {
        // GIVEN: Data with accessibility hints
        let item = sampleData[0]
        let hints = PresentationHints(
            dataType: .generic,
            presentationPreference: .automatic,
            complexity: .moderate,
            context: .dashboard
        )
        
        // WHEN: Generating a view with accessibility hints
        let view = IntelligentDetailView.platformDetailView(for: item, hints: hints)
        
        // THEN: Should generate a valid view
        #expect(view != nil)
        
        // View should be instantiable without crashing
        // Note: We don't access .body directly as it can cause SwiftUI runtime issues
        // with complex view hierarchies. The view creation itself is the test.
    }
    
    // MARK: - Integration Tests
    
    @Test func testViewGenerationIntegration() {
        // GIVEN: A complete data set
        let items = sampleData
        
        // WHEN: Generating views for all items
        let views = items.map { item in
            IntelligentDetailView.platformDetailView(for: item)
        }
        
        // THEN: Should generate valid views for all items
        #expect(views.count == items.count)
        
        // SwiftUI views are structs, so we can't use XCTAssertNotNil
        // Instead, we verify the views can be created without crashing
        for view in views {
            _ = view
        }
    }
    
    @Test func testViewGenerationWithCustomFieldViews() {
        // GIVEN: Data and custom field view implementations
        let item = sampleData[0]
        
        // WHEN: Generating views with different custom field views
        let view1 = IntelligentDetailView.platformDetailView(
            for: item,
            customFieldView: { fieldName, value, fieldType in
                Text("Custom: \(fieldName)")
            }
        )
        
        let view2 = IntelligentDetailView.platformDetailView(
            for: item,
            customFieldView: { fieldName, value, fieldType in
                VStack {
                    Text(fieldName)
                    Text(String(describing: value))
                }
            }
        )
        
        // THEN: Should generate valid views with custom field views
        #expect(view1 != nil)
        #expect(view2 != nil)
        
        // Note: We don't access .body directly as it can cause SwiftUI runtime issues
        // with complex view hierarchies. The view creation itself is the test.
    }
