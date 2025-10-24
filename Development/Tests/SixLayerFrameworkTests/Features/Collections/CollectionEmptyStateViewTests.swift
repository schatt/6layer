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
            // Setup: Configure test environment
            setupTestEnvironment()
            
            // Test: Use centralized accessibility testing function
            let testPassed = testAccessibilityIdentifierGeneration(
                createCollectionEmptyStateView(),
                componentName: "CollectionEmptyStateView",
                platform: platform
            )
            
            // Assert: Should generate accessibility identifiers
            #expect(testPassed, "CollectionEmptyStateView should generate accessibility identifiers on \(platform.rawValue)")
            
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
    
    // MARK: - Helper Functions
    
    /// Creates a CollectionEmptyStateView for testing
    private func createCollectionEmptyStateView() -> CollectionEmptyStateView {
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
