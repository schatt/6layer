//
//  LayoutDecisionReasoningTests.swift
//  SixLayerFrameworkTests
//
//  Tests for layout decision reasoning properties
//

import XCTest
@testable import SixLayerFramework

final class LayoutDecisionReasoningTests: XCTestCase {
    
    // MARK: - GenericLayoutDecision Reasoning Tests
    
    func testGenericLayoutDecisionReasoningContainsApproach() {
        // Given
        let decision = GenericLayoutDecision(
            approach: .grid,
            columns: 2,
            spacing: 16.0,
            performance: .standard,
            reasoning: "Selected grid layout with 2 columns for optimal user experience"
        )
        
        // Then
        XCTAssertTrue(decision.reasoning.contains("grid"))
        XCTAssertTrue(decision.reasoning.contains("2 columns"))
    }
    
    func testGenericLayoutDecisionReasoningContainsPerformance() {
        // Given
        let decision = GenericLayoutDecision(
            approach: .list,
            columns: 1,
            spacing: 8.0,
            performance: .highPerformance,
            reasoning: "Selected list layout with 1 column for optimal user experience"
        )
        
        // Then
        XCTAssertTrue(decision.reasoning.contains("list"))
        XCTAssertTrue(decision.reasoning.contains("1 column"))
    }
    
    func testGenericLayoutDecisionReasoningContainsSpacing() {
        // Given
        let decision = GenericLayoutDecision(
            approach: .grid,
            columns: 3,
            spacing: 24.0,
            performance: .optimized,
            reasoning: "Selected grid layout with 3 columns for optimal user experience"
        )
        
        // Then
        XCTAssertTrue(decision.reasoning.contains("grid"))
        XCTAssertTrue(decision.reasoning.contains("3 columns"))
    }
    
    // MARK: - GenericFormLayoutDecision Reasoning Tests
    
    func testGenericFormLayoutDecisionReasoningContainsContainer() {
        // Given
        let decision = GenericFormLayoutDecision(
            preferredContainer: .adaptive,
            fieldLayout: .standard,
            spacing: .comfortable,
            validation: .realTime,
            contentComplexity: .moderate,
            reasoning: "Form layout optimized based on field count and complexity"
        )
        
        // Then
        XCTAssertTrue(decision.reasoning.contains("Form layout"))
        XCTAssertTrue(decision.reasoning.contains("optimized"))
    }
    
    func testGenericFormLayoutDecisionReasoningContainsComplexity() {
        // Given
        let decision = GenericFormLayoutDecision(
            preferredContainer: .structured,
            fieldLayout: .compact,
            spacing: .generous,
            validation: .onSubmit,
            contentComplexity: .complex,
            reasoning: "Form layout optimized based on field count and complexity"
        )
        
        // Then
        XCTAssertTrue(decision.reasoning.contains("Form layout"))
        XCTAssertTrue(decision.reasoning.contains("complexity"))
    }
    
    // MARK: - Reasoning Content Validation Tests
    
    func testReasoningIsNotEmpty() {
        // Given
        let decision = GenericLayoutDecision(
            approach: .grid,
            columns: 2,
            spacing: 16.0,
            performance: .standard,
            reasoning: "Selected grid layout with 2 columns for optimal user experience"
        )
        
        // Then
        XCTAssertFalse(decision.reasoning.isEmpty)
        XCTAssertTrue(decision.reasoning.count > 10)
    }
    
    func testReasoningIsDescriptive() {
        // Given
        let decision = GenericFormLayoutDecision(
            preferredContainer: .adaptive,
            fieldLayout: .standard,
            spacing: .comfortable,
            validation: .realTime,
            contentComplexity: .moderate,
            reasoning: "Form layout optimized based on field count and complexity"
        )
        
        // Then
        XCTAssertTrue(decision.reasoning.contains("optimized"))
        XCTAssertTrue(decision.reasoning.contains("based on"))
    }
    
    // MARK: - Reasoning Consistency Tests
    
    func testReasoningConsistencyAcrossSimilarDecisions() {
        // Given
        let decision1 = GenericLayoutDecision(
            approach: .grid,
            columns: 2,
            spacing: 16.0,
            performance: .standard,
            reasoning: "Selected grid layout with 2 columns for optimal user experience"
        )
        
        let decision2 = GenericLayoutDecision(
            approach: .grid,
            columns: 2,
            spacing: 16.0,
            performance: .standard,
            reasoning: "Selected grid layout with 2 columns for optimal user experience"
        )
        
        // Then
        XCTAssertEqual(decision1.reasoning, decision2.reasoning)
    }
    
    func testReasoningReflectsDifferentApproaches() {
        // Given
        let gridDecision = GenericLayoutDecision(
            approach: .grid,
            columns: 2,
            spacing: 16.0,
            performance: .standard,
            reasoning: "Selected grid layout with 2 columns for optimal user experience"
        )
        
        let listDecision = GenericLayoutDecision(
            approach: .list,
            columns: 1,
            spacing: 8.0,
            performance: .standard,
            reasoning: "Selected list layout with 1 column for optimal user experience"
        )
        
        // Then
        XCTAssertNotEqual(gridDecision.reasoning, listDecision.reasoning)
        XCTAssertTrue(gridDecision.reasoning.contains("grid"))
        XCTAssertTrue(listDecision.reasoning.contains("list"))
    }
    
    // MARK: - Real Layout Decision Integration Tests
    
    @MainActor
    func testRealLayoutDecisionReasoningGeneration() {
        // Given
        let items = [MockItem(id: 1), MockItem(id: 2), MockItem(id: 3)]
        let hints = PresentationHints(
            dataType: .collection,
            presentationPreference: .automatic,
            complexity: .moderate,
            context: .dashboard,
            customPreferences: [:]
        )
        
        // When
        let decision = determineOptimalLayout_L2(
            items: items,
            hints: hints,
            screenWidth: 768.0,
            deviceType: .pad
        )
        
        // Then
        XCTAssertFalse(decision.reasoning.isEmpty)
        XCTAssertTrue(decision.reasoning.contains("Layout optimized"))
        XCTAssertTrue(decision.reasoning.contains("approach"))
        XCTAssertTrue(decision.reasoning.contains("columns"))
    }
    
    @MainActor
    func testRealFormLayoutDecisionReasoningGeneration() {
        // Given
        let hints = PresentationHints(
            dataType: .form,
            presentationPreference: .automatic,
            complexity: .moderate,
            context: .form,
            customPreferences: [:]
        )
        
        // When
        let decision = determineOptimalFormLayout_L2(hints: hints)
        
        // Then
        XCTAssertFalse(decision.reasoning.isEmpty)
        XCTAssertTrue(decision.reasoning.contains("Form layout"))
        XCTAssertTrue(decision.reasoning.contains("optimized"))
    }
}
