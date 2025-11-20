import Testing
import Foundation

//
//  NavigationStackLayer2Tests.swift
//  SixLayerFrameworkTests
//
//  Layer 2 (Decision) TDD Tests for NavigationStack
//  Tests for determineNavigationStackStrategy_L2 function
//
//  Test Documentation:
//  Business purpose: Determine when NavigationStack is appropriate vs other navigation patterns
//  What are we actually testing:
//    - Navigation strategy decision algorithm based on content analysis
//    - Integration with existing NavigationStrategy enum
//    - Content complexity analysis for navigation decisions
//    - Device type considerations for navigation
//  HOW are we testing it:
//    - Test navigation strategy selection with different content types
//    - Test navigation strategy selection with different item counts
//    - Test navigation strategy selection with different hints
//    - Test integration with existing NavigationStrategy enum
//    - Validate decision logic algorithms
//

@testable import SixLayerFramework

/// NOTE: Not marked @MainActor on class to allow parallel execution
@Suite("NavigationStack Layer 2")
open class NavigationStackLayer2Tests: BaseTestClass {
    
    // MARK: - Test Data
    
    struct TestItem: Identifiable, Hashable {
        let id: UUID
        let title: String
    }
    
    // MARK: - determineNavigationStackStrategy_L2 Tests
    
    @Test @MainActor func testDetermineNavigationStackStrategy_L2_ReturnsDecision() {
        // Given: Simple content with navigation hints
        let items = (1...3).map { i in TestItem(id: UUID(), title: "Item \(i)") }
        let hints = PresentationHints(
            dataType: .navigation,
            presentationPreference: .navigation,
            complexity: .simple,
            context: .navigation
        )
        
        // When: Determining navigation strategy
        let decision = determineNavigationStackStrategy_L2(
            items: items,
            hints: hints
        )
        
        // Then: Should return a decision
        #expect(Bool(true), "decision is non-optional")
        #expect(decision.strategy != nil, "Should have a navigation strategy")
    }
    
    @Test @MainActor func testDetermineNavigationStackStrategy_L2_SimpleContentUsesNavigationStack() {
        // Given: Simple content (few items)
        let items = (1...3).map { i in TestItem(id: UUID(), title: "Item \(i)") }
        let hints = PresentationHints(
            dataType: .navigation,
            presentationPreference: .navigation,
            complexity: .simple,
            context: .navigation
        )
        
        // When: Determining navigation strategy
        let decision = determineNavigationStackStrategy_L2(
            items: items,
            hints: hints
        )
        
        // Then: Should recommend NavigationStack for simple content
        #expect(decision.strategy == .navigationStack, 
                "Simple content should use NavigationStack strategy")
    }
    
    @Test @MainActor func testDetermineNavigationStackStrategy_L2_EmptyContentUsesNavigationStack() {
        // Given: Empty content
        let items: [TestItem] = []
        let hints = PresentationHints(
            dataType: .navigation,
            presentationPreference: .navigation,
            complexity: .simple,
            context: .navigation
        )
        
        // When: Determining navigation strategy
        let decision = determineNavigationStackStrategy_L2(
            items: items,
            hints: hints
        )
        
        // Then: Should recommend NavigationStack for empty content
        #expect(decision.strategy == .navigationStack, 
                "Empty content should use NavigationStack strategy")
    }
    
    @Test @MainActor func testDetermineNavigationStackStrategy_L2_RespectsHintsPreference() {
        // Given: Hints explicitly requesting navigation
        let items = (1...10).map { i in TestItem(id: UUID(), title: "Item \(i)") }
        let hints = PresentationHints(
            dataType: .navigation,
            presentationPreference: .navigation,
            complexity: .moderate,
            context: .navigation
        )
        
        // When: Determining navigation strategy
        let decision = determineNavigationStackStrategy_L2(
            items: items,
            hints: hints
        )
        
        // Then: Should respect hints preference
        #expect(decision.strategy == .navigationStack, 
                "Should respect hints preference for navigation")
    }
    
    @Test @MainActor func testDetermineNavigationStackStrategy_L2_RespectsDetailPreference() {
        // Given: Hints explicitly requesting detail/split view
        let items = (1...10).map { i in TestItem(id: UUID(), title: "Item \(i)") }
        let hints = PresentationHints(
            dataType: .navigation,
            presentationPreference: .detail,
            complexity: .moderate,
            context: .navigation
        )
        
        // When: Determining navigation strategy
        let decision = determineNavigationStackStrategy_L2(
            items: items,
            hints: hints
        )
        
        // Then: Should respect detail preference (may recommend splitView)
        #expect(decision.strategy == .splitView || decision.strategy == .navigationStack,
                "Should respect detail preference, may use splitView or navigationStack")
    }
    
    @Test @MainActor func testDetermineNavigationStackStrategy_L2_RespectsModalPreference() {
        // Given: Hints explicitly requesting modal
        let items = (1...5).map { i in TestItem(id: UUID(), title: "Item \(i)") }
        let hints = PresentationHints(
            dataType: .navigation,
            presentationPreference: .modal,
            complexity: .simple,
            context: .navigation
        )
        
        // When: Determining navigation strategy
        let decision = determineNavigationStackStrategy_L2(
            items: items,
            hints: hints
        )
        
        // Then: Should respect modal preference
        #expect(decision.strategy == .modal, 
                "Should respect modal preference")
    }
    
    @Test @MainActor func testDetermineNavigationStackStrategy_L2_ComplexContentAnalysis() {
        // Given: Complex content (many items)
        let items = (1...50).map { i in TestItem(id: UUID(), title: "Item \(i)") }
        let hints = PresentationHints(
            dataType: .navigation,
            presentationPreference: .automatic,
            complexity: .complex,
            context: .navigation
        )
        
        // When: Determining navigation strategy
        let decision = determineNavigationStackStrategy_L2(
            items: items,
            hints: hints
        )
        
        // Then: Should make appropriate decision for complex content
        #expect(decision.strategy != nil, "Should have a strategy for complex content")
        #expect(decision.reasoning != nil && !decision.reasoning!.isEmpty,
                "Should provide reasoning for decision")
    }
    
    @Test @MainActor func testDetermineNavigationStackStrategy_L2_ProvidesReasoning() {
        // Given: Content with hints
        let items = (1...5).map { i in TestItem(id: UUID(), title: "Item \(i)") }
        let hints = PresentationHints(
            dataType: .navigation,
            presentationPreference: .navigation,
            complexity: .simple,
            context: .navigation
        )
        
        // When: Determining navigation strategy
        let decision = determineNavigationStackStrategy_L2(
            items: items,
            hints: hints
        )
        
        // Then: Should provide reasoning
        #expect(decision.reasoning != nil, "Should provide reasoning")
        #expect(!decision.reasoning!.isEmpty, "Reasoning should not be empty")
    }
}

