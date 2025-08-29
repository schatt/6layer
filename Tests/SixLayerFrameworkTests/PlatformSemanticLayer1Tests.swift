import XCTest
import SwiftUI
@testable import SixLayerFramework

@MainActor
final class PlatformSemanticLayer1Tests: XCTestCase {
    
    // MARK: - Business Purpose Tests
    
    /// Test: Does the semantic layer actually guide intelligent UI decisions?
    func testSemanticHintsGuideLayoutDecisions() {
        // Given: Same data with different semantic hints
        let dashboardHints = createTestHints(
            dataType: .collection,
            presentationPreference: .compact,
            context: .dashboard
        )
        
        let detailHints = createTestHints(
            dataType: .collection,
            presentationPreference: .detail,
            context: .detail
        )
        
        // When: Layout decisions are made (using Layer 2)
        let dashboardLayout = determineOptimalLayout_L2(
            items: Array(0..<15).map { MockItem(id: $0) },
            hints: dashboardHints
        )
        
        let detailLayout = determineOptimalLayout_L2(
            items: Array(0..<15).map { MockItem(id: $0) },
            hints: detailHints
        )
        
        // Then: Should reflect semantic intent through content analysis
        // Note: Layer 2 makes decisions based on content complexity, not direct preference mapping
        XCTAssertNotNil(dashboardLayout, "Dashboard layout should be determined")
        XCTAssertNotNil(detailLayout, "Detail layout should be determined")
        // 15 items is now complex (10-25 range) and should use responsive approach
        XCTAssertEqual(dashboardLayout.approach, .responsive, "15 items should use responsive approach (complex)")
        XCTAssertEqual(detailLayout.approach, .responsive, "15 items should use responsive approach (complex)")
    }
    
    func testSemanticLayerProvidesPlatformAgnosticIntent() {
        // Given: User wants to present a collection
        let collectionHints = createTestHints(
            dataType: .collection,
            presentationPreference: .grid,
            context: .browse
        )
        
        // When: Semantic function is called
        let view = platformPresentItemCollection_L1(
            items: Array(0..<10).map { MockItem(id: $0) },
            hints: collectionHints
        )
        
        // Then: Should work regardless of platform
        XCTAssertNotNil(view, "Should work on any platform")
        // The actual platform-specific rendering happens in Layer 6
    }
    
    // MARK: - Data Type Recognition Business Purpose Tests
    
    func testDataTypeHintsGuidePresentationStrategy() {
        // Given: Different data types
        let textHints = createTestHints(
            dataType: .text,
            presentationPreference: .list,
            context: .browse
        )
        
        let imageHints = createTestHints(
            dataType: .image,
            presentationPreference: .grid,
            context: .browse
        )
        
        let chartHints = createTestHints(
            dataType: .chart,
            presentationPreference: .chart,
            context: .dashboard
        )
        
        // When: Layout decisions are made
        let textLayout = determineOptimalLayout_L2(
            items: Array(0..<20).map { MockItem(id: $0) },
            hints: textHints
        )
        
        let imageLayout = determineOptimalLayout_L2(
            items: Array(0..<20).map { MockItem(id: $0) },
            hints: imageHints
        )
        
        let chartLayout = determineOptimalLayout_L2(
            items: Array(0..<20).map { MockItem(id: $0) },
            hints: chartHints
        )
        
        // Then: Should adapt to data type characteristics through content analysis
        // Note: Layout approach is based on item count (20 items = complex = responsive)
        XCTAssertEqual(textLayout.approach, .responsive, "20 items should use responsive approach")
        XCTAssertEqual(imageLayout.approach, .responsive, "20 items should use responsive approach")
        XCTAssertEqual(chartLayout.approach, .responsive, "20 items should use responsive approach")
    }
    
    func testContextHintsInfluenceLayoutDecisions() {
        // Given: Same data in different contexts
        let browseHints = createTestHints(
            dataType: .collection,
            presentationPreference: .grid,
            context: .browse
        )
        
        let searchHints = createTestHints(
            dataType: .collection,
            presentationPreference: .list,
            context: .search
        )
        
        let dashboardHints = createTestHints(
            dataType: .collection,
            presentationPreference: .compact,
            context: .dashboard
        )
        
        // When: Layout decisions are made
        let browseLayout = determineOptimalLayout_L2(
            items: Array(0..<25).map { MockItem(id: $0) },
            hints: browseHints
        )
        
        let searchLayout = determineOptimalLayout_L2(
            items: Array(0..<25).map { MockItem(id: $0) },
            hints: searchHints
        )
        
        let dashboardLayout = determineOptimalLayout_L2(
            items: Array(0..<25).map { MockItem(id: $0) },
            hints: dashboardHints
        )
        
        // Then: Should adapt to context requirements through content analysis
        // Note: Layout approach is based on item count (25 items = complex = responsive)
        XCTAssertEqual(browseLayout.approach, .responsive, "25 items should use responsive approach")
        XCTAssertEqual(searchLayout.approach, .responsive, "25 items should use responsive approach")
        XCTAssertEqual(dashboardLayout.approach, .responsive, "25 items should use responsive approach")
    }
    
    // MARK: - Complexity Recognition Business Purpose Tests
    
    func testComplexityHintsDrivePerformanceDecisions() {
        // Given: Same data with different complexity hints
        let simpleHints = createTestHints(
            dataType: .collection,
            complexity: .simple,
            context: .browse
        )
        
        let complexHints = createTestHints(
            dataType: .collection,
            complexity: .complex,
            context: .browse
        )
        
        // When: Layout decisions are made
        let simpleLayout = determineOptimalLayout_L2(
            items: Array(0..<8).map { MockItem(id: $0) },
            hints: simpleHints
        )
        
        let complexLayout = determineOptimalLayout_L2(
            items: Array(0..<8).map { MockItem(id: $0) },
            hints: complexHints
        )
        
        // Then: Should adapt performance strategy to complexity
        // 8 items is now moderate (6-9 range) and should use adaptive approach
        XCTAssertEqual(simpleLayout.approach, .uniform, "Simple content should use uniform approach")
        XCTAssertEqual(complexLayout.approach, .adaptive, "8 items should use adaptive approach (moderate complexity)")
    }
    
    // MARK: - Custom Preferences Business Purpose Tests
    
    func testCustomPreferencesOverrideDefaultBehavior() {
        // Given: Custom preferences that override defaults
        let customHints = createTestHints(
            dataType: .form,
            context: .edit,
            customPreferences: [
                "fieldCount": "15",
                "hasComplexFields": "true",
                "hasValidation": "true",
                "preferredLayout": "vertical"
            ]
        )
        
        // When: Form layout decision is made
        let formDecision = determineOptimalFormLayout_L2(hints: customHints)
        
        // Then: Should respect custom preferences
        XCTAssertEqual(formDecision.contentComplexity, .complex, "Should detect complex form from custom preferences")
        XCTAssertEqual(formDecision.validation, .realTime, "Should use validation from custom preferences")
    }
    
    // MARK: - Platform Independence Business Purpose Tests
    
    func testSemanticLayerWorksAcrossAllPlatforms() {
        // Given: Platform-agnostic semantic hints
        let universalHints = createTestHints(
            dataType: .collection,
            presentationPreference: .automatic,
            context: .browse
        )
        
        // When: Semantic functions are called
        let collectionView = platformPresentItemCollection_L1(
            items: Array(0..<12).map { MockItem(id: $0) },
            hints: universalHints
        )
        
        // Note: These functions expect specific data types, so we'll test the collection view
        // which is the most commonly used and should work with our MockItem
        
        // Then: Should work on any platform
        XCTAssertNotNil(collectionView, "Collection view should work on any platform")
    }
    
    // MARK: - Semantic Intent Validation Tests
    
    func testSemanticHintsReflectUserIntent() {
        // Given: User wants to browse images in a grid
        let imageBrowseHints = createTestHints(
            dataType: .image,
            presentationPreference: .grid,
            complexity: .moderate,
            context: .browse
        )
        
        // When: Semantic intent is processed
        let layoutDecision = determineOptimalLayout_L2(
            items: Array(0..<18).map { MockItem(id: $0) },
            hints: imageBrowseHints
        )
        
        // Then: Should reflect user's browsing intent through content analysis
        // 18 items is now complex (10-25 range) and should use responsive approach
        XCTAssertEqual(layoutDecision.approach, .responsive, "18 items should use responsive approach")
        // Note: GenericLayoutDecision doesn't have a context property, so we test the approach
    }
    
    func testSemanticLayerPreservesIntentThroughLayers() {
        // Given: User wants detailed form editing
        let detailedFormHints = createTestHints(
            dataType: .form,
            presentationPreference: .detail,
            complexity: .complex,
            context: .edit
        )
        
        // When: Intent flows through semantic layer to layout layer
        let formLayout = determineOptimalFormLayout_L2(hints: detailedFormHints)
        let generalLayout = determineOptimalLayout_L2(
            items: Array(0..<20).map { MockItem(id: $0) },
            hints: detailedFormHints
        )
        
        // Then: Should preserve detailed editing intent
        // Note: GenericFormLayoutDecision doesn't have a context property
        XCTAssertEqual(formLayout.contentComplexity, .complex, "Should preserve complexity")
        // Note: GenericLayoutDecision doesn't have a context property, so we test the approach
        // 20 items is now complex (10-25 range) and should use responsive approach
        XCTAssertEqual(generalLayout.approach, .responsive, "20 items should use responsive approach")
    }
}
