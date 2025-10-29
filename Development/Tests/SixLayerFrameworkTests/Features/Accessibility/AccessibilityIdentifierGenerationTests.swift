import Testing
import SwiftUI
@testable import SixLayerFramework
import ViewInspector
/// TDD Tests for Accessibility Identifier Generation
/// Following proper TDD: Test drives design, write best code to make tests pass
@MainActor
open class AccessibilityIdentifierGenerationTests: BaseTestClass {
    
    // MARK: - TDD Red Phase: Write Failing Tests for Desired Behavior
    
    @Test func testAccessibilityIdentifiersAreReasonableLength() {
        // Setup test environment
        setupTestEnvironment()
        
        // TDD: Define the behavior I want - short, clean IDs
        let view = Button("Add Fuel") { }
            .named("AddFuelButton")
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        do {
            let inspectedView = try view.inspect()
            let buttonID = try inspectedView.accessibilityIdentifier()
            
            // This test SHOULD FAIL initially - IDs are currently 400+ chars
            #expect(buttonID.count < 80, "Accessibility ID should be reasonable length")
            #expect(buttonID.contains("SixLayer"), "Should contain namespace")
            #expect(buttonID.contains("AddFuelButton"), "Should contain view name")
            
            print("✅ Generated ID: '\(buttonID)' (\(buttonID.count) chars)")
            
        } catch {
            Issue.record("Failed to inspect view: \(error)")
        }
        
        // Cleanup
        cleanupTestEnvironment()
    }
    
    @Test func testAccessibilityIdentifiersDontDuplicateHierarchy() {
        // Setup test environment
        setupTestEnvironment()
        
        // TDD: Define the behavior I want - no hierarchy duplication
        let view = VStack {
            Button("Test") { }
                .named("TestButton")
        }
        .named("Container")
        .named("OuterContainer") // Multiple .named() calls
        .enableGlobalAutomaticAccessibilityIdentifiers()
        
        do {
            let inspectedView = try view.inspect()
            let vStackID = try inspectedView.accessibilityIdentifier()
            
            // This test SHOULD FAIL initially - contains duplicates like "container-container"
            #expect(!vStackID.contains("container-container"), "Should not contain duplicated hierarchy")
            #expect(!vStackID.contains("outercontainer-outercontainer"), "Should not contain duplicated hierarchy")
            #expect(vStackID.count < 80, "Should be reasonable length even with multiple .named() calls")
            
            print("✅ Generated ID: '\(vStackID)' (\(vStackID.count) chars)")
            
        } catch {
            Issue.record("Failed to inspect view: \(error)")
        }
        
        // Cleanup
        cleanupTestEnvironment()
    }
    
    @Test func testAccessibilityIdentifiersAreSemantic() {
        // Setup test environment
        setupTestEnvironment()
        
        // TDD: Define the behavior I want - semantic, meaningful IDs
        let view = VStack {
            Text("User Profile")
                .named("ProfileTitle")
            Button("Edit") { }
                .named("EditButton")
        }
        .named("UserProfile")
        .named("ProfileView")
        .enableGlobalAutomaticAccessibilityIdentifiers()
        
        do {
            let inspectedView = try view.inspect()
            let vStackID = try inspectedView.accessibilityIdentifier()
            
            // This test SHOULD FAIL initially - IDs are not semantic
            #expect(vStackID.contains("UserProfile"), "Should contain screen context")
            #expect(vStackID.contains("ProfileView") || vStackID.contains("UserProfile"), "Should contain view name")
            #expect(vStackID.count < 80, "Should be concise and semantic")
            
            print("✅ Generated ID: '\(vStackID)' (\(vStackID.count) chars)")
            
        } catch {
            Issue.record("Failed to inspect view: \(error)")
        }
        
        // Cleanup
        cleanupTestEnvironment()
    }
    
    @Test func testAccessibilityIdentifiersWorkInComplexHierarchy() {
        // Setup test environment
        setupTestEnvironment()
        
        // TDD: Define the behavior I want - works in complex nested views
        let view = VStack {
            HStack {
                Text("Title")
                    .named("TitleText")
                Button("Action") { }
                    .named("ActionButton")
            }
            .named("HeaderRow")
            
            VStack {
                ForEach(0..<3) { index in
                    Text("Item \(index)")
                        .named("Item\(index)")
                }
            }
            .named("ItemList")
        }
        .named("ComplexView")
        .named("ComplexContainer")
        .enableGlobalAutomaticAccessibilityIdentifiers()
        
        do {
            let inspectedView = try view.inspect()
            let vStackID = try inspectedView.accessibilityIdentifier()
            
            // This test SHOULD FAIL initially - complex hierarchies create massive IDs
            #expect(vStackID.count < 100, "Should handle complex hierarchies gracefully")
            #expect(vStackID.contains("ComplexView"), "Should contain screen context")
            #expect(vStackID.contains("ComplexContainer") || vStackID.contains("ComplexView"), "Should contain container name")
            #expect(!vStackID.contains("item0-item1-item2"), "Should not contain all nested item names")
            
            print("✅ Generated ID: '\(vStackID)' (\(vStackID.count) chars)")
            
        } catch {
            Issue.record("Failed to inspect view: \(error)")
        }
        
        // Cleanup
        cleanupTestEnvironment()
    }
}
