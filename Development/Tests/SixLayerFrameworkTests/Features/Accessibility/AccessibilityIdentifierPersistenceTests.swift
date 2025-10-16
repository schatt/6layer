import Testing


import SwiftUI
import ViewInspector
@testable import SixLayerFramework

/// TDD Tests for Accessibility Identifier Persistence
/// Following proper TDD: Write failing tests first to prove the issue exists
@MainActor
final class AccessibilityIdentifierPersistenceTests {
    
    init() async throws {
                let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
        config.enableAutoIDs = true
        config.namespace = "CarManager"
        config.mode = .automatic
        config.enableDebugLogging = false
    }
    
    deinit {
        Task { [weak self] in
            await self?.cleanupTestEnvironment()
        }
    }
    
    // MARK: - TDD Red Phase: Tests That Should Fail
    
    @Test func testAccessibilityIdentifiersArePersistentAcrossSessions() {
        // TDD: This test SHOULD FAIL initially - IDs are not persistent
        // We want IDs to be the same across app launches
        
        let view1 = Button("Add Fuel") { }
            .named("AddFuelButton")
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        // Simulate first app launch
        let id1 = generateIDForView(view1)
        
        // Simulate app restart (reset config to simulate new session)
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
        config.enableAutoIDs = true
        config.namespace = "CarManager"
        config.mode = .automatic
        
        let view2 = Button("Add Fuel") { }
            .named("AddFuelButton")
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        // Simulate second app launch
        let id2 = generateIDForView(view2)
        
        // This assertion SHOULD FAIL initially
        #expect(id1 == id2, "Accessibility IDs should be persistent across app launches")
        
        print("Testing accessibility identifier persistence: ID1='\(id1)', ID2='\(id2)'")
    }
    
    @Test func testAccessibilityIdentifiersAreDeterministicForSameView() {
        // TDD: This test SHOULD FAIL initially - IDs contain timestamps
        // Same view with same hierarchy should generate same ID
        
        let view1 = Button("Add Fuel") { }
            .named("AddFuelButton")
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        let id1 = generateIDForView(view1)
        
        // Generate ID for identical view immediately after
        let view2 = Button("Add Fuel") { }
            .named("AddFuelButton")
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        let id2 = generateIDForView(view2)
        
        // This assertion SHOULD FAIL initially (timestamps differ)
        #expect(id1 == id2, "Identical views should generate identical IDs")
        
        print("Testing accessibility identifier persistence: ID1='\(id1)', ID2='\(id2)'")
    }
    
    @Test func testAccessibilityIdentifiersDontContainTimestamps() {
        // TDD: This test SHOULD FAIL initially - IDs contain timestamps
        // IDs should be based on view structure, not time
        
        let view = Button("Add Fuel") { }
            .named("AddFuelButton")
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        let id = generateIDForView(view)
        
        // Wait a bit to ensure timestamp would change
        Thread.sleep(forTimeInterval: 0.1)
        
        let view2 = Button("Add Fuel") { }
            .named("AddFuelButton")
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        let id2 = generateIDForView(view2)
        
        // This assertion SHOULD FAIL initially (timestamps differ)
        #expect(id == id2, "IDs should not contain timestamps")
        
        print("🔴 TDD Red Phase: ID1='\(id)', ID2='\(id2)' - These should be equal but aren't")
    }
    
    @Test func testAccessibilityIdentifiersAreStableForUITesting() {
        // TDD: This test SHOULD FAIL initially
        // UI tests need stable IDs that don't change between runs
        
        let testCases = [
            ("AddFuelButton", "main"),
            ("RemoveFuelButton", "main"), 
            ("EditFuelButton", "settings"),
            ("DeleteFuelButton", "settings")
        ]
        
        var ids: [String: String] = [:]
        
        // Generate IDs for all test cases
        for (buttonName, screenContext) in testCases {
            let view = Button("Test") { }
                .named(buttonName)
                .enableGlobalAutomaticAccessibilityIdentifiers()
            
            ids[buttonName] = generateIDForView(view)
        }
        
        // Simulate app restart
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
        config.enableAutoIDs = true
        config.namespace = "CarManager"
        config.mode = .automatic
        
        // Generate IDs again for same test cases
        for (buttonName, screenContext) in testCases {
            let view = Button("Test") { }
                .named(buttonName)
                .enableGlobalAutomaticAccessibilityIdentifiers()
            
            let newID = generateIDForView(view)
            let originalID = ids[buttonName]!
            
            // This assertion SHOULD FAIL initially
            #expect(originalID == newID, "ID for \(buttonName) should be stable across sessions")
            
            print("Testing accessibility identifier persistence: \(buttonName) - Original='\(originalID)', New='\(newID)'")
        }
    }
    
    @Test func testAccessibilityIdentifiersAreBasedOnViewStructure() {
        // TDD: This test SHOULD FAIL initially
        // IDs should be based on view hierarchy and context, not random factors
        
        let view1 = Button("Add Fuel") { }
            .named("AddFuelButton")
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        let id1 = generateIDForView(view1)
        
        // Same structure, different time
        Thread.sleep(forTimeInterval: 0.1)
        
        let view2 = Button("Add Fuel") { }
            .named("AddFuelButton")
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        let id2 = generateIDForView(view2)
        
        // This assertion SHOULD FAIL initially
        #expect(id1 == id2, "Same view structure should generate same ID regardless of timing")
        
        print("Testing accessibility identifier persistence: ID1='\(id1)', ID2='\(id2)'")
    }
    
    @Test func testAccessibilityIdentifiersAreTrulyPersistentForIdenticalViews() {
        // TDD: This test focuses ONLY on persistence - truly identical views
        
        let createIdenticalView = {
            Button("Add Fuel") { }
                .named("AddFuelButton")
        }
        
        // Generate ID for first identical view
        let view1 = createIdenticalView()
        let id1 = generateIDForView(view1)
        
        // Clear hierarchy to prevent accumulation between identical views
        AccessibilityIdentifierConfig.shared.clearDebugLog()
        
        // Wait to ensure any timing-based differences would show
        Thread.sleep(forTimeInterval: 0.1)
        
        // Generate ID for second identical view
        let view2 = createIdenticalView()
        let id2 = generateIDForView(view2)
        
        // This assertion SHOULD PASS with our fix
        #expect(id1 == id2, "Truly identical views should generate identical IDs")
        
        print("🟢 TDD Green Phase: ID1='\(id1)', ID2='\(id2)' - Should be equal")
    }
    
    @Test func testAccessibilityIdentifiersPersistAcrossConfigResets() {
        // TDD: Test persistence across config resets (simulating app restarts)
        
        let createTestView = {
            Button("Test Button") { }
                .named("TestButton")
        }
        
        // First generation
        let view1 = createTestView()
        let id1 = generateIDForView(view1)
        
        // Reset config (simulate app restart)
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
        config.enableAutoIDs = true
        config.namespace = "CarManager"
        config.mode = .automatic
        
        // Second generation with same config
        let view2 = createTestView()
        let id2 = generateIDForView(view2)
        
        // This assertion SHOULD PASS with our fix
        #expect(id1 == id2, "IDs should persist across config resets")
        
        print("🟢 TDD Green Phase: ID1='\(id1)', ID2='\(id2)' - Should be equal")
    }
    
    // MARK: - Helper Methods
    
    private func generateIDForView(_ view: some View) -> String {
        do {
            let inspectedView = try view.inspect()
            let button = try inspectedView.button()
            return try button.accessibilityIdentifier()
        } catch {
            Issue.record("Failed to generate ID for view: \(error)")
            return ""
        }
    }
}
