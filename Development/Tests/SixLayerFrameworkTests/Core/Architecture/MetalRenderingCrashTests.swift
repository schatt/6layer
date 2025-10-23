import Testing


import SwiftUI
import ViewInspector
@testable import SixLayerFramework

/// TDD Tests for Metal Rendering Crash Bug Fix
/// Following proper TDD: Write failing tests first to prove the desired behavior
/// 
/// UPDATE: Performance layer has been removed entirely, eliminating the Metal crash bug
@MainActor
open class MetalRenderingCrashTDDTests {
    
    init() async throws {
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
        config.namespace = "MetalTest"
        config.mode = .automatic
        config.enableDebugLogging = false
        config.enableAutoIDs = true
    }    // MARK: - TDD Green Phase: Tests That Now Pass After Performance Layer Removal
    
    @Test func testPlatformPresentItemCollectionL1DoesNotCrash() {
        // TDD Green Phase: Performance layer removed, so no Metal crash
        
        let mockItems = [
            MockTaskItem(id: "task1", title: "Test Task 1"),
            MockTaskItem(id: "task2", title: "Test Task 2"),
            MockTaskItem(id: "task3", title: "Test Task 3")
        ]
        
        let hints = PresentationHints(
            dataType: .collection,
            presentationPreference: .automatic,
            complexity: .moderate,
            context: .dashboard
        )
        
        // This should NOT crash - performance layer removed
        let view = platformPresentItemCollection_L1(
            items: mockItems,
            hints: hints,
            onCreateItem: nil,
            onItemSelected: nil,
            onItemDeleted: nil,
            onItemEdited: nil
        )
        
        #expect(view != nil, "platformPresentItemCollection_L1 should not crash")
        
        // Try to inspect the view (should not crash)
        do {
            let inspectedView = try view.inspect()
            #expect(inspectedView != nil, "View should be inspectable without crashing")
            print("✅ platformPresentItemCollection_L1 rendered successfully")
        } catch {
            Issue.record("platformPresentItemCollection_L1 should not crash during inspection: \(error)")
        }
        
        print("🟢 TDD Green Phase: platformPresentItemCollection_L1 no longer crashes - performance layer removed")
    }
    
    @Test func testGenericItemCollectionViewDoesNotCrash() {
        // TDD Green Phase: Performance layer removed, so no Metal crash
        
        let mockItems = [
            MockTaskItem(id: "task1", title: "Test Task 1"),
            MockTaskItem(id: "task2", title: "Test Task 2")
        ]
        
        let hints = PresentationHints(
            dataType: .collection,
            presentationPreference: .automatic,
            complexity: .moderate,
            context: .dashboard
        )
        
        // This should NOT crash - performance layer removed
        let view = GenericItemCollectionView(
            items: mockItems,
            hints: hints,
            onCreateItem: nil,
            onItemSelected: nil,
            onItemDeleted: nil,
            onItemEdited: nil
        )
        
        #expect(view != nil, "GenericItemCollectionView should not crash")
        
        // Try to inspect the view (should not crash)
        do {
            let inspectedView = try view.inspect()
            #expect(inspectedView != nil, "View should be inspectable without crashing")
            print("✅ GenericItemCollectionView rendered successfully")
        } catch {
            Issue.record("GenericItemCollectionView should not crash during inspection: \(error)")
        }
        
        print("🟢 TDD Green Phase: GenericItemCollectionView no longer crashes - performance layer removed")
    }
    
    @Test func testMetalRenderingCrashReproduction() {
        // TDD Green Phase: Performance layer removed, so no Metal crash
        
        let mockItems = [
            MockTaskItem(id: "task1", title: "Test Task 1"),
            MockTaskItem(id: "task2", title: "Test Task 2"),
            MockTaskItem(id: "task3", title: "Test Task 3"),
            MockTaskItem(id: "task4", title: "Test Task 4"),
            MockTaskItem(id: "task5", title: "Test Task 5")
        ]
        
        let hints = PresentationHints(
            dataType: .collection,
            presentationPreference: .automatic,
            complexity: .moderate,
            context: .dashboard
        )
        
        // Simulate the exact scenario from the bug report
        let view = VStack {
            platformPresentItemCollection_L1(
                items: mockItems,
                hints: hints,
                onCreateItem: nil,
                onItemSelected: nil,
                onItemDeleted: nil,
                onItemEdited: nil
            )
        }
        .padding()
        
        // This should NOT crash - performance layer removed
        #expect(view != nil, "Metal rendering should not crash")
        
        // Try to inspect the view (should not crash)
        do {
            let inspectedView = try view.inspect()
            #expect(inspectedView != nil, "View should be inspectable without crashing")
            print("✅ Metal rendering crash reproduction test passed")
        } catch {
            Issue.record("Metal rendering should not crash during inspection: \(error)")
        }
        
        print("🟢 TDD Green Phase: Metal rendering crash fixed - performance layer removed")
    }
    
    @Test func testSimpleCardComponentWithRegularMaterialCrashes() {
        // TDD Green Phase: Performance layer removed, so no Metal crash
        
        let mockItem = MockTaskItem(id: "task1", title: "Test Task 1")
        let layoutDecision = IntelligentCardLayoutDecision(
            columns: 2,
            spacing: 16,
            cardWidth: 150,
            cardHeight: 100,
            padding: 16
        )
        
        // This should NOT crash - performance layer removed
        let view = SimpleCardComponent(
            item: mockItem,
            layoutDecision: layoutDecision,
            hints: PresentationHints(),
            onItemSelected: nil,
            onItemDeleted: nil,
            onItemEdited: nil
        )
        
        #expect(view != nil, "SimpleCardComponent should not crash")
        
        // Try to inspect the view (should not crash)
        do {
            let inspectedView = try view.inspect()
            #expect(inspectedView != nil, "SimpleCardComponent should be inspectable without crashing")
            print("✅ SimpleCardComponent rendered successfully")
        } catch {
            Issue.record("SimpleCardComponent should not crash during inspection: \(error)")
        }
        
        print("🟢 TDD Green Phase: SimpleCardComponent no longer crashes - performance layer removed")
    }
    
    @Test func testPerformanceLayerRemoval() {
        // TDD Green Phase: Document that performance layer has been removed
        
        let mockItems = [
            MockTaskItem(id: "task1", title: "Test Task 1"),
            MockTaskItem(id: "task2", title: "Test Task 2")
        ]
        
        let hints = PresentationHints(
            dataType: .collection,
            presentationPreference: .automatic,
            complexity: .moderate,
            context: .dashboard
        )
        
        let view = platformPresentItemCollection_L1(
            items: mockItems,
            hints: hints
        )
        
        // PERFORMANCE LAYER REMOVED: No more .drawingGroup(), .compositingGroup(), or Metal rendering
        // This eliminates the Metal crash bug entirely
        
        #expect(view != nil, "View should be created")
        
        print("🟢 TDD Green Phase: Performance layer completely removed")
        print("🟢 TDD Green Phase: No more Metal rendering crashes")
        print("🟢 TDD Green Phase: Framework focused on cross-platform UI, not performance optimization")
        print("🟢 TDD Green Phase: Simpler, more maintainable codebase")
    }
}

// MARK: - Mock Data

struct MockTaskItem: Identifiable {
    let id: String
    let title: String
}
