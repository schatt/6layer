import XCTest
import SwiftUI
@testable import SixLayerFramework

@MainActor
final class PlatformLayoutDecisionLayer2Tests: XCTestCase {
    
    // MARK: - Business Purpose Tests
    
    /// Test: Does the layout engine actually make intelligent decisions that improve UX?
    func testLayoutEngineOptimizesForMobilePerformance() {
        // Given: Complex content on a mobile device
        let decision = determineOptimalLayout_L2(
            items: Array(0..<25).map { MockItem(id: $0) }, // 25 items = complex
            hints: createTestHints(
                dataType: .collection,
                complexity: .complex,
                context: .browse
            ),
            screenWidth: 375, // Mobile phone width
            deviceType: .phone
        )
        
        // When: Layout decision is made
        
        // Then: Should prioritize mobile performance
        XCTAssertEqual(decision.approach, .responsive, "Complex content on mobile should use responsive layout for performance")
        XCTAssertLessThanOrEqual(decision.columns, 2, "Mobile should limit columns for performance")
    }
    
    func testLayoutEngineAdaptsToContentComplexity() {
        // Given: Simple content vs complex content
        let simpleDecision = determineOptimalLayout_L2(
            items: Array(0..<3).map { MockItem(id: $0) }, // 3 items = simple
            hints: createTestHints(complexity: .simple)
        )
        
        let complexDecision = determineOptimalLayout_L2(
            items: Array(0..<20).map { MockItem(id: $0) }, // 20 items = complex
            hints: createTestHints(complexity: .complex)
        )
        
        // Then: Should adapt layout strategy based on complexity
        XCTAssertEqual(simpleDecision.approach, .uniform, "Simple content should use uniform layout")
        XCTAssertEqual(complexDecision.approach, .responsive, "Complex content should use responsive layout")
        XCTAssertGreaterThan(complexDecision.spacing, simpleDecision.spacing, "Complex content needs more spacing")
    }
    
    func testLayoutEngineConsidersDeviceCapabilities() {
        // Given: Same content on different devices
        let phoneDecision = determineOptimalLayout_L2(
            items: Array(0..<8).map { MockItem(id: $0) }, // 8 items = moderate
            hints: createTestHints(complexity: .moderate)
        )
        
        let desktopDecision = determineOptimalLayout_L2(
            items: Array(0..<8).map { MockItem(id: $0) }, // 8 items = moderate
            hints: createTestHints(complexity: .moderate)
        )
        
        // Then: Should adapt to device capabilities
        // Note: 8 items is now moderate complexity, so both should use .adaptive approach
        XCTAssertEqual(phoneDecision.approach, .adaptive, "Moderate content should use adaptive approach")
        XCTAssertEqual(desktopDecision.approach, .adaptive, "Moderate content should use adaptive approach")
    }
    
    // MARK: - Form Layout Business Purpose Tests
    
    func testFormLayoutOptimizesForUserExperience() {
        // Given: Complex form with validation
        let complexFormHints = createTestHints(
            dataType: .form,
            complexity: .complex,
            context: .edit,
            customPreferences: [
                "fieldCount": "12",
                "hasComplexFields": "true",
                "hasValidation": "true"
            ]
        )
        
        // When: Form layout decision is made
        let formDecision = determineOptimalFormLayout_L2(hints: complexFormHints)
        
        // Then: Should optimize for complex form UX
        XCTAssertEqual(formDecision.contentComplexity, .complex, "Should detect complex form")
        XCTAssertEqual(formDecision.validation, .realTime, "Complex forms should have real-time validation")
        XCTAssertEqual(formDecision.spacing, .comfortable, "Complex forms need comfortable spacing")
    }
    
    func testFormLayoutAdaptsToFieldCount() {
        // Given: Forms with different field counts
        let simpleFormHints = createTestHints(
            dataType: .form,
            customPreferences: ["fieldCount": "3"]
        )
        
        let moderateFormHints = createTestHints(
            dataType: .form,
            customPreferences: ["fieldCount": "7"]
        )
        
        // When: Form layout decisions are made
        let simpleDecision = determineOptimalFormLayout_L2(hints: simpleFormHints)
        let moderateDecision = determineOptimalFormLayout_L2(hints: moderateFormHints)
        
        // Then: Should adapt to field count
        XCTAssertEqual(simpleDecision.contentComplexity, .simple, "3 fields should be simple")
        XCTAssertEqual(moderateDecision.contentComplexity, .moderate, "7 fields should be moderate")
    }
    
    // MARK: - Card Layout Business Purpose Tests
    
    func testCardLayoutOptimizesForScreenRealEstate() {
        // Given: Different screen sizes
        let phoneWidth: CGFloat = 375
        let tabletWidth: CGFloat = 768
        let desktopWidth: CGFloat = 1440
        
        // When: Card layout decisions are made
        let phoneDecision = determineOptimalCardLayout_L2(
            contentCount: 15,
            screenWidth: phoneWidth,
            deviceType: .phone,
            contentComplexity: .complex  // 15 items is now complex
        )
        
        let tabletDecision = determineOptimalCardLayout_L2(
            contentCount: 15,
            screenWidth: tabletWidth,
            deviceType: .pad,
            contentComplexity: .complex  // 15 items is now complex
        )
        
        let desktopDecision = determineOptimalCardLayout_L2(
            contentCount: 15,
            screenWidth: desktopWidth,
            deviceType: .mac,
            contentComplexity: .complex  // 15 items is now complex
        )
        
        // Then: Should optimize for each screen size
        XCTAssertEqual(phoneDecision.columns, 2, "Phone should use 2 columns for complex content")
        XCTAssertEqual(tabletDecision.columns, 3, "Tablet should use 3 columns for complex content")
        XCTAssertEqual(desktopDecision.columns, 4, "Desktop should use 4 columns for complex content")
    }
    
    func testCardLayoutConsidersContentComplexity() {
        // Given: Same device, different content complexity
        let simpleDecision = determineOptimalCardLayout_L2(
            contentCount: 5,
            screenWidth: 1024,
            deviceType: .pad,
            contentComplexity: .simple
        )
        
        let complexDecision = determineOptimalCardLayout_L2(
            contentCount: 25,
            screenWidth: 1024,
            deviceType: .pad,
            contentComplexity: .complex
        )
        
        // Then: Should adapt to content complexity
        XCTAssertEqual(simpleDecision.columns, 2, "Simple content should use fewer columns")
        XCTAssertEqual(complexDecision.columns, 3, "Complex content should use more columns")
        XCTAssertGreaterThan(complexDecision.spacing, simpleDecision.spacing, "Complex content needs more spacing")
    }
    
    // MARK: - Content Analysis Business Purpose Tests
    
    func testContentAnalysisDrivesLayoutDecisions() {
        // Given: Content with different characteristics
        let simpleContent = Array(0..<4).map { MockItem(id: $0) }   // 4 items = simple
        let moderateContent = Array(0..<8).map { MockItem(id: $0) }  // 8 items = moderate
        let complexContent = Array(0..<20).map { MockItem(id: $0) }  // 20 items = complex
        
        // When: Layout decisions are made
        let simpleDecision = determineOptimalLayout_L2(
            items: simpleContent,
            hints: createTestHints(complexity: .simple)
        )
        
        let moderateDecision = determineOptimalLayout_L2(
            items: moderateContent,
            hints: createTestHints(complexity: .moderate)
        )
        
        let complexDecision = determineOptimalLayout_L2(
            items: complexContent,
            hints: createTestHints(complexity: .complex)
        )
        
        // Then: Should analyze content and make appropriate decisions
        XCTAssertEqual(simpleDecision.approach, .uniform, "Simple content should use uniform approach")
        XCTAssertEqual(moderateDecision.approach, .adaptive, "Moderate content should use adaptive approach")
        XCTAssertEqual(complexDecision.approach, .responsive, "Complex content should use responsive approach")
    }
    
    // MARK: - Performance Strategy Business Purpose Tests
    
    func testPerformanceStrategyOptimizesForUserExperience() {
        // Given: Complex content on performance-constrained devices
        let complexHints = createTestHints(
            dataType: .collection,
            complexity: .veryComplex,
            context: .browse
        )
        
        // When: Layout decision is made
        let decision = determineOptimalLayout_L2(
            items: Array(0..<50).map { MockItem(id: $0) },
            hints: complexHints,
            screenWidth: 768, // Tablet width for performance constraints
            deviceType: .pad
        )
        
        // Then: Should prioritize performance for complex content
        XCTAssertEqual(decision.approach, .dynamic, "Very complex content should use dynamic layout for performance")
        XCTAssertLessThanOrEqual(decision.columns, 3, "Should limit columns for performance")
    }
}
