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
    func testCollectionEmptyStateViewCrossPlatformAccessibility() async {
        await MainActor.run {
            // Setup: Configure test environment
            setupTestEnvironment()
            
            // Test: Use centralized cross-platform testing function
            let testPassed = testCrossPlatformAccessibilityIdentifierGeneration(
                createCollectionEmptyStateView(),
                componentName: "CollectionEmptyStateView"
            )
            
            // Assert: Should generate accessibility identifiers on all platforms
            #expect(testPassed, "CollectionEmptyStateView should generate accessibility identifiers on all platforms")
            
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
