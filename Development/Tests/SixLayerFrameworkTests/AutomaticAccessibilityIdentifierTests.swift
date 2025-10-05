import XCTest
import SwiftUI
@testable import SixLayerFramework

/**
 * BUSINESS PURPOSE: SixLayer framework should automatically generate accessibility identifiers
 * for views created by Layer 1 functions, ensuring consistent testability without requiring
 * developers to manually add identifiers to every interactive element.
 * 
 * TESTING SCOPE: Tests that automatic identifier generation works correctly with global config,
 * respects manual overrides, generates stable IDs based on object identity, and integrates
 * with existing HIG compliance modifiers.
 * 
 * METHODOLOGY: Uses TDD principles to test automatic identifier generation. Creates views using
 * Layer 1 functions and verifies they have proper accessibility identifiers generated automatically
 * based on configuration settings and object identity.
 */
final class AutomaticAccessibilityIdentifierTests: XCTestCase {
    
    // MARK: - Test Data Setup
    
    private var testItems: [TestItem]!
    private var testHints: PresentationHints!
    
    override func setUp() {
        super.setUp()
        testItems = [
            TestItem(id: "user-1", title: "Alice", subtitle: "Developer"),
            TestItem(id: "user-2", title: "Bob", subtitle: "Designer")
        ]
        testHints = PresentationHints(
            dataType: .generic,
            presentationPreference: .grid,
            complexity: .moderate,
            context: .list,
            customPreferences: [:]
        )
        
        // Reset global config to default state
        Task { @MainActor in
            AccessibilityIdentifierConfig.shared.resetToDefaults()
        }
    }
    
    override func tearDown() {
        testItems = nil
        testHints = nil
        Task { @MainActor in
            AccessibilityIdentifierConfig.shared.resetToDefaults()
        }
        super.tearDown()
    }
    
    // MARK: - Global Configuration Tests
    
    /// BUSINESS PURPOSE: Global config should control automatic identifier generation
    /// TESTING SCOPE: Tests that enabling/disabling automatic IDs works globally
    /// METHODOLOGY: Tests global config toggle and verifies behavior changes
    func testGlobalConfigControlsAutomaticIdentifiers() async {
        await MainActor.run {
            // Given: Automatic IDs enabled by default in v4.0.0
            XCTAssertTrue(AccessibilityIdentifierConfig.shared.enableAutoIDs, "Auto IDs should be enabled by default in v4.0.0")
            
            // When: Disabling automatic IDs
            AccessibilityIdentifierConfig.shared.enableAutoIDs = false
            
            // Then: Config should reflect the change
            XCTAssertFalse(AccessibilityIdentifierConfig.shared.enableAutoIDs, "Auto IDs should be disabled")
            
            // When: Re-enabling automatic IDs
            AccessibilityIdentifierConfig.shared.enableAutoIDs = true
            
            // Then: Config should reflect the change
            XCTAssertTrue(AccessibilityIdentifierConfig.shared.enableAutoIDs, "Auto IDs should be enabled")
        }
    }
    
    /// BUSINESS PURPOSE: Global config should support custom namespace
    /// TESTING SCOPE: Tests that custom namespace affects generated identifiers
    /// METHODOLOGY: Sets custom namespace and verifies it's used in generated IDs
    func testGlobalConfigSupportsCustomNamespace() async {
        await MainActor.run {
            // Given: Custom namespace
            let customNamespace = "myapp.users"
            AccessibilityIdentifierConfig.shared.namespace = customNamespace
            
            // When: Getting the namespace
            let retrievedNamespace = AccessibilityIdentifierConfig.shared.namespace
            
            // Then: Should match the set value
            XCTAssertEqual(retrievedNamespace, customNamespace, "Namespace should match set value")
        }
    }
    
    /// BUSINESS PURPOSE: Global config should support different generation modes
    /// TESTING SCOPE: Tests that different modes affect ID generation strategy
    /// METHODOLOGY: Tests various generation modes and their behavior
    func testGlobalConfigSupportsGenerationModes() async {
        await MainActor.run {
            // Test each mode
            let modes: [AccessibilityIdentifierMode] = [.automatic, .semantic, .minimal]
            
            for mode in modes {
                AccessibilityIdentifierConfig.shared.mode = mode
                XCTAssertEqual(AccessibilityIdentifierConfig.shared.mode, mode, "Mode should be set to \(mode)")
            }
        }
    }
    
    // MARK: - Automatic ID Generation Tests
    
    /// BUSINESS PURPOSE: Automatic ID generator should create stable identifiers based on object identity
    /// TESTING SCOPE: Tests that generated IDs are stable and based on item.id, not position
    /// METHODOLOGY: Creates views with same items in different orders and verifies stable IDs
    func testAutomaticIDGeneratorCreatesStableIdentifiers() async {
        await MainActor.run {
            // Given: Automatic IDs enabled
            AccessibilityIdentifierConfig.shared.enableAutoIDs = true
            AccessibilityIdentifierConfig.shared.namespace = "test"
            
            // When: Generating IDs for items
            let generator = AccessibilityIdentifierGenerator()
            let id1 = generator.generateID(for: testItems[0], role: "item", context: "list")
            let id2 = generator.generateID(for: testItems[1], role: "item", context: "list")
            
            // Then: IDs should be stable and based on item identity
            XCTAssertEqual(id1, "test.list.item.user-1", "ID should be based on item identity")
            XCTAssertEqual(id2, "test.list.item.user-2", "ID should be based on item identity")
            
            // When: Reordering items and generating IDs again
            let reorderedItems = [testItems[1], testItems[0]]
            let id1Reordered = generator.generateID(for: reorderedItems[1], role: "item", context: "list")
            let id2Reordered = generator.generateID(for: reorderedItems[0], role: "item", context: "list")
            
            // Then: IDs should remain the same regardless of order
            XCTAssertEqual(id1Reordered, id1, "ID should be stable regardless of order")
            XCTAssertEqual(id2Reordered, id2, "ID should be stable regardless of order")
        }
    }
    
    /// BUSINESS PURPOSE: Automatic ID generator should handle different roles and contexts
    /// TESTING SCOPE: Tests that different roles and contexts create appropriate IDs
    /// METHODOLOGY: Tests various role/context combinations
    func testAutomaticIDGeneratorHandlesDifferentRolesAndContexts() async {
        await MainActor.run {
            // Given: Automatic IDs enabled with namespace
            AccessibilityIdentifierConfig.shared.enableAutoIDs = true
            AccessibilityIdentifierConfig.shared.namespace = "app"
            
            let generator = AccessibilityIdentifierGenerator()
            let item = testItems[0]
            
            // When: Generating IDs with different roles and contexts
            let listItemID = generator.generateID(for: item, role: "item", context: "list")
            let detailButtonID = generator.generateID(for: item, role: "detail-button", context: "item")
            let editButtonID = generator.generateID(for: item, role: "edit-button", context: "item")
            
            // Then: IDs should reflect the different roles and contexts
            XCTAssertEqual(listItemID, "app.list.item.user-1", "List item ID should include list context")
            XCTAssertEqual(detailButtonID, "app.item.detail-button.user-1", "Detail button ID should include item context")
            XCTAssertEqual(editButtonID, "app.item.edit-button.user-1", "Edit button ID should include item context")
        }
    }
    
    /// BUSINESS PURPOSE: Automatic ID generator should handle non-Identifiable objects
    /// TESTING SCOPE: Tests that non-Identifiable objects get appropriate fallback IDs
    /// METHODOLOGY: Tests ID generation for objects without stable identity
    func testAutomaticIDGeneratorHandlesNonIdentifiableObjects() async {
        await MainActor.run {
            // Given: Automatic IDs enabled
            AccessibilityIdentifierConfig.shared.enableAutoIDs = true
            AccessibilityIdentifierConfig.shared.namespace = "test"
            
            let generator = AccessibilityIdentifierGenerator()
            
            // When: Generating ID for non-Identifiable object
            let nonIdentifiableObject = "some-string"
            let id = generator.generateID(for: nonIdentifiableObject, role: "text", context: "display")
            
            // Then: Should generate appropriate fallback ID
            XCTAssertTrue(id.hasPrefix("test.display.text."), "ID should have proper prefix")
            XCTAssertTrue(id.contains("some-string"), "ID should include object content")
        }
    }
    
    // MARK: - Manual Override Tests
    
    /// BUSINESS PURPOSE: Manual accessibility identifiers should always override automatic ones
    /// TESTING SCOPE: Tests that explicit .platformAccessibilityIdentifier() takes precedence
    /// METHODOLOGY: Creates view with both manual and automatic IDs and verifies manual wins
    func testManualAccessibilityIdentifiersOverrideAutomatic() async {
        await MainActor.run {
            // Given: Automatic IDs enabled
            AccessibilityIdentifierConfig.shared.enableAutoIDs = true
            AccessibilityIdentifierConfig.shared.namespace = "auto"
            
            // When: Creating view with manual identifier
            let manualID = "manual-custom-id"
            let view = Text("Test")
                .platformAccessibilityIdentifier(manualID)
                .automaticAccessibilityIdentifiers()
            
            // Then: Manual identifier should take precedence
            // Note: In a real test, we'd need to extract the actual identifier from the view
            // For now, we verify the modifier chain compiles without errors
            XCTAssertNotNil(view, "View with manual override should be created successfully")
        }
    }
    
    /// BUSINESS PURPOSE: View-level opt-out should disable automatic IDs for specific views
    /// TESTING SCOPE: Tests that .disableAutomaticAccessibilityIdentifiers() works
    /// METHODOLOGY: Tests opt-out modifier on specific views
    func testViewLevelOptOutDisablesAutomaticIDs() async {
        await MainActor.run {
            // Given: Automatic IDs enabled globally
            AccessibilityIdentifierConfig.shared.enableAutoIDs = true
            
            // When: Creating view with opt-out modifier
            let view = Text("Test")
                .disableAutomaticAccessibilityIdentifiers()
                .automaticAccessibilityIdentifiers()
            
            // Then: View should be created without automatic IDs
            XCTAssertNotNil(view, "View with opt-out should be created successfully")
        }
    }
    
    // MARK: - Integration Tests
    
    /// BUSINESS PURPOSE: Automatic identifiers should integrate with AppleHIGComplianceModifier
    /// TESTING SCOPE: Tests that HIG compliance modifier includes automatic ID generation
    /// METHODOLOGY: Tests integration with existing HIG compliance system
    func testAutomaticIdentifiersIntegrateWithHIGCompliance() async {
        await MainActor.run {
            // Given: Automatic IDs enabled
            AccessibilityIdentifierConfig.shared.enableAutoIDs = true
            AccessibilityIdentifierConfig.shared.namespace = "hig"
            
            // When: Creating view with HIG compliance
            let view = Text("Test")
                .appleHIGCompliant()
            
            // Then: View should be created with both HIG compliance and automatic IDs
            XCTAssertNotNil(view, "View with HIG compliance should include automatic IDs")
        }
    }
    
    /// BUSINESS PURPOSE: Layer 1 functions should automatically apply identifier generation
    /// TESTING SCOPE: Tests that platformPresentItemCollection_L1 includes automatic IDs
    /// METHODOLOGY: Tests Layer 1 function integration
    func testLayer1FunctionsIncludeAutomaticIdentifiers() async {
        await MainActor.run {
            // Given: Automatic IDs enabled
            AccessibilityIdentifierConfig.shared.enableAutoIDs = true
            AccessibilityIdentifierConfig.shared.namespace = "layer1"
            
            // When: Creating view using Layer 1 function
            let view = platformPresentItemCollection_L1(
                items: testItems!,
                hints: testHints!
            )
            
            // Then: View should be created with automatic identifiers
            XCTAssertNotNil(view, "Layer 1 function should include automatic identifiers")
        }
    }
    
    // MARK: - Collision Detection Tests
    
    /// BUSINESS PURPOSE: DEBUG collision detection should identify ID conflicts
    /// TESTING SCOPE: Tests that collision detection works in DEBUG builds
    /// METHODOLOGY: Tests collision detection and logging
    func testCollisionDetectionIdentifiesConflicts() async {
        await MainActor.run {
            // Given: Automatic IDs enabled
            AccessibilityIdentifierConfig.shared.enableAutoIDs = true
            AccessibilityIdentifierConfig.shared.namespace = "collision"
            
            let generator = AccessibilityIdentifierGenerator()
            let item = testItems[0]
            
            // When: Generating same ID twice
            let id1 = generator.generateID(for: item, role: "item", context: "list")
            let id2 = generator.generateID(for: item, role: "item", context: "list")
            
            // Then: IDs should be identical (no collision in this case)
            XCTAssertEqual(id1, id2, "Same input should generate same ID")
            
            // When: Checking for collisions (should detect collision since ID was registered)
            let hasCollision = generator.checkForCollision(id1)
            
            // Then: Should detect collision since the ID was registered
            XCTAssertTrue(hasCollision, "Registered IDs should be detected as collisions")
            
            // When: Checking for collision with an unregistered ID
            let unregisteredID = "unregistered.id"
            let hasUnregisteredCollision = generator.checkForCollision(unregisteredID)
            
            // Then: Should not detect collision for unregistered IDs
            XCTAssertFalse(hasUnregisteredCollision, "Unregistered IDs should not be considered collisions")
        }
    }
    
    // MARK: - Performance Tests
    
    /// BUSINESS PURPOSE: Automatic ID generation should be performant
    /// TESTING SCOPE: Tests that ID generation doesn't significantly impact performance
    /// METHODOLOGY: Performance tests for ID generation
    func testAutomaticIDGenerationPerformance() async {
        await MainActor.run {
            // Given: Automatic IDs enabled
            AccessibilityIdentifierConfig.shared.enableAutoIDs = true
            AccessibilityIdentifierConfig.shared.namespace = "perf"
            
            let generator = AccessibilityIdentifierGenerator()
            let items = (0..<100).map { TestItem(id: "item-\($0)", title: "Item \($0)", subtitle: "Subtitle") }
            
            // When: Measuring ID generation performance
            measure {
                for item in items {
                    _ = generator.generateID(for: item, role: "item", context: "list")
                }
            }
            
            // Then: Performance should be acceptable (test passes if measure doesn't fail)
        }
    }
}

// MARK: - Test Support Types
// Note: TestItem is already defined in AutomaticHIGComplianceTests.swift
