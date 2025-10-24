import Testing
import SwiftUI
@testable import SixLayerFramework
import ViewInspector

/// Tests for CollectionEmptyStateView component
/// 
/// BUSINESS PURPOSE: Ensure CollectionEmptyStateView generates proper accessibility identifiers
/// TESTING SCOPE: CollectionEmptyStateView component from PlatformSemanticLayer1.swift
/// METHODOLOGY: Uses centralized test functions following DRY principles
@MainActor
open class CollectionEmptyStateViewTests {
    
    // MARK: - CollectionEmptyStateView Tests
    
    @Test(arguments: [SixLayerPlatform.iOS, SixLayerPlatform.macOS])
    func testCollectionEmptyStateViewGeneratesAccessibilityIdentifiers(
        platform: SixLayerPlatform
    ) async {
        await MainActor.run {
            // Setup: Configure test environment with automatic mode (explicit)
            setupTestEnvironment(mode: .automatic)
            
            // Test: Use centralized accessibility testing function
            let testPassed = testAccessibilityIdentifierGeneration(
                createCollectionEmptyStateView(),
                componentName: "CollectionEmptyStateView",
                expectedPattern: "SixLayer.main.ui.element.View",
                platform: platform
            )
            
            // Assert: Should generate accessibility identifiers in automatic mode
            #expect(testPassed, "CollectionEmptyStateView should generate accessibility identifiers on \(platform.rawValue) in automatic mode")
            
            // Cleanup: Reset test environment
            cleanupTestEnvironment()
        }
    }
    
    @Test
    func testCollectionEmptyStateViewAccessibilityDisabled() async {
        await MainActor.run {
            // Setup: Configure test environment with auto IDs disabled
            setupTestEnvironment(enableAutoIDs: false)
            
            // Test: Use centralized accessibility disabled testing function
            let testPassed = testComponentAccessibilityDisabled(
                componentName: "CollectionEmptyStateView",
                createComponent: createCollectionEmptyStateView
            )
            
            // Assert: Should work correctly when accessibility IDs are disabled
            #expect(testPassed, "CollectionEmptyStateView should work when accessibility IDs are disabled")
            
            // Cleanup: Reset test environment
            cleanupTestEnvironment()
        }
    }
    
    @Test
    func testCollectionEmptyStateViewAllAccessibilityModes() async {
        await MainActor.run {
            let view = createCollectionEmptyStateView()
            
            // Test automatic mode
            setupTestEnvironment(mode: .automatic)
            let automaticPassed = testComponentAccessibility(
                componentName: "CollectionEmptyStateView-Automatic",
                createComponent: { view }
            )
            cleanupTestEnvironment()
            
            // Test manual mode
            setupTestEnvironment(mode: .manual)
            let manualPassed = testComponentAccessibilityManual(
                componentName: "CollectionEmptyStateView-Manual",
                createComponent: { view }
            )
            cleanupTestEnvironment()
            
            // Test semantic mode
            setupTestEnvironment(mode: .semantic)
            let semanticPassed = testComponentAccessibilitySemantic(
                componentName: "CollectionEmptyStateView-Semantic",
                createComponent: { view }
            )
            cleanupTestEnvironment()
            
            // Test disabled mode
            setupTestEnvironment(mode: .disabled)
            let disabledPassed = testComponentAccessibilityDisabled(
                componentName: "CollectionEmptyStateView-Disabled",
                createComponent: { view }
            )
            cleanupTestEnvironment()
            
            // Assert: Should work in all accessibility modes
            #expect(automaticPassed, "CollectionEmptyStateView should work in automatic mode")
            #expect(manualPassed, "CollectionEmptyStateView should work in manual mode")
            #expect(semanticPassed, "CollectionEmptyStateView should work in semantic mode")
            #expect(disabledPassed, "CollectionEmptyStateView should work in disabled mode")
        }
    }
    
    // MARK: - Helper Functions
    
    /// Creates a CollectionEmptyStateView for testing
    public func createCollectionEmptyStateView() -> CollectionEmptyStateView {
        return CollectionEmptyStateView(
            hints: PresentationHints(
                dataType: .collection,
                presentationPreference: .automatic
            ),
            onCreateItem: {},
            customCreateView: nil
        )
    }
}
