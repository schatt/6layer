import Testing
import SwiftUI
@testable import SixLayerFramework
#if !os(macOS)
import ViewInspector
#endif
/// TDD Tests for Accessibility Identifier Generation
/// Following proper TDD: Test drives design, write best code to make tests pass
@MainActor
@Suite("Accessibility Identifier Generation")
open class AccessibilityIdentifierGenerationTests: BaseTestClass {
    
    // MARK: - TDD Red Phase: Write Failing Tests for Desired Behavior
    
    @Test func testAccessibilityIdentifiersAreReasonableLength() {
        // Setup test environment
        setupTestEnvironment()
        
        // TDD: Define the behavior I want - short, clean IDs
        let view = PlatformInteractionButton(style: .primary, action: {}) {
            platformPresentContent_L1(content: "Add Fuel", hints: PresentationHints())
        }
            .named("AddFuelButton")
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        // Using wrapper - when ViewInspector works on macOS, no changes needed here
        if let inspectedView = view.tryInspect(),
           let buttonID = try? inspectedView.accessibilityIdentifier() {
            // This test SHOULD FAIL initially - IDs are currently 400+ chars
            #expect(buttonID.count < 80, "Accessibility ID should be reasonable length")
            #expect(buttonID.contains("SixLayer"), "Should contain namespace")
            #expect(buttonID.contains("AddFuelButton"), "Should contain view name")
            
            print("✅ Generated ID: '\(buttonID)' (\(buttonID.count) chars)")
        } else {
            Issue.record("Failed to inspect view")
        }
        
        // Cleanup
        cleanupTestEnvironment()
    }
    
    @Test func testAccessibilityIdentifiersDontDuplicateHierarchy() {
        // Setup test environment
        setupTestEnvironment()
        
        // TDD: Define the behavior I want - no hierarchy duplication
        let view = VStack {
            PlatformInteractionButton(style: .primary, action: {}) {
                platformPresentContent_L1(content: "Test", hints: PresentationHints())
            }
            .named("TestButton")
        }
        .named("Container")
        .named("OuterContainer") // Multiple .named() calls
        .enableGlobalAutomaticAccessibilityIdentifiers()
        
        // Using wrapper - when ViewInspector works on macOS, no changes needed here
        if let inspectedView = view.tryInspect(),
           let vStackID = try? inspectedView.accessibilityIdentifier() {
            // This test SHOULD FAIL initially - contains duplicates like "container-container"
            #expect(!vStackID.contains("container-container"), "Should not contain duplicated hierarchy")
            #expect(!vStackID.contains("outercontainer-outercontainer"), "Should not contain duplicated hierarchy")
            #expect(vStackID.count < 80, "Should be reasonable length even with multiple .named() calls")
            
            print("✅ Generated ID: '\(vStackID)' (\(vStackID.count) chars)")
        } else {
            Issue.record("Failed to inspect view")
        }
        
        // Cleanup
        cleanupTestEnvironment()
    }
    
    @Test func testAccessibilityIdentifiersAreSemantic() {
        // Setup test environment
        setupTestEnvironment()
        
        // TDD: Define the behavior I want - semantic, meaningful IDs
        let view = VStack {
            platformPresentContent_L1(content: "User Profile", hints: PresentationHints())
                .named("ProfileTitle")
            PlatformInteractionButton(style: .primary, action: {}) {
                platformPresentContent_L1(content: "Edit", hints: PresentationHints())
            }
                .named("EditButton")
        }
        .named("UserProfile")
        .named("ProfileView")
        .enableGlobalAutomaticAccessibilityIdentifiers()
        
        // Using wrapper - when ViewInspector works on macOS, no changes needed here
        if let inspectedView = view.tryInspect(),
           let vStackID = try? inspectedView.accessibilityIdentifier() {
            // This test SHOULD FAIL initially - IDs are not semantic
            #expect(vStackID.contains("UserProfile"), "Should contain screen context")
            #expect(vStackID.contains("ProfileView") || vStackID.contains("UserProfile"), "Should contain view name")
            #expect(vStackID.count < 80, "Should be concise and semantic")
            
            print("✅ Generated ID: '\(vStackID)' (\(vStackID.count) chars)")
        } else {
            Issue.record("Failed to inspect view")
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
        
        // Using wrapper - when ViewInspector works on macOS, no changes needed here
        if let inspectedView = view.tryInspect(),
           let vStackID = try? inspectedView.accessibilityIdentifier() {
            // This test SHOULD FAIL initially - complex hierarchies create massive IDs
            #expect(vStackID.count < 100, "Should handle complex hierarchies gracefully")
            #expect(vStackID.contains("ComplexView"), "Should contain screen context")
            #expect(vStackID.contains("ComplexContainer") || vStackID.contains("ComplexView"), "Should contain container name")
            #expect(!vStackID.contains("item0-item1-item2"), "Should not contain all nested item names")
            
            print("✅ Generated ID: '\(vStackID)' (\(vStackID.count) chars)")
        } else {
            Issue.record("Failed to inspect view")
        }
        
        // Cleanup
        cleanupTestEnvironment()
    }
    
    // MARK: - TDD Red Phase: Label Text in Identifiers
    
    @Test func testAccessibilityIdentifiersIncludeLabelTextForStringLabels() {
        // Setup test environment
        setupTestEnvironment()
        
        // TDD: Define the behavior I want - labels from String parameters should be in identifiers
        // This test SHOULD FAIL initially - labels are not included in identifiers
        let submitButton = AdaptiveUIPatterns.AdaptiveButton("Submit", action: { })
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        let cancelButton = AdaptiveUIPatterns.AdaptiveButton("Cancel", action: { })
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        do {
            let submitInspected = submitButton.tryInspect()
            let submitID = try? submitInspected.accessibilityIdentifier()
            
            let cancelInspected = cancelButton.tryInspect()
            let cancelID = try? cancelInspected.accessibilityIdentifier()
            
            // TDD RED: These should FAIL - labels not currently included
            #expect(submitID.contains("Submit"), "Submit button identifier should include 'Submit' label")
            #expect(cancelID.contains("Cancel"), "Cancel button identifier should include 'Cancel' label")
            #expect(submitID != cancelID, "Buttons with different labels should have different identifiers")
            
            print("✅ Submit ID: '\(submitID)'")
            print("✅ Cancel ID: '\(cancelID)'")
            
        } catch {
            Issue.record("Failed to inspect views: \(error)")
        }
        
        // Cleanup
        cleanupTestEnvironment()
    }
    
    @Test func testAccessibilityIdentifiersSanitizeLabelText() {
        // Setup test environment
        setupTestEnvironment()
        
        // TDD: Labels should be sanitized (lowercase, spaces to hyphens, etc.)
        let button = AdaptiveUIPatterns.AdaptiveButton("Add New Item", action: { })
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        do {
            let inspected = button.tryInspect()
            let buttonID = try? inspected.accessibilityIdentifier()
            
            // TDD RED: Should FAIL - labels not sanitized
            // Should contain sanitized version: "add-new-item" or similar
            #expect(buttonID.contains("add") || buttonID.contains("new") || buttonID.contains("item"), 
                   "Identifier should include sanitized label text")
            #expect(!buttonID.contains("Add New Item"), 
                   "Identifier should not contain raw label with spaces")
            
            print("✅ Sanitized ID: '\(buttonID)'")
            
        } catch {
            Issue.record("Failed to inspect view: \(error)")
        }
        
        // Cleanup
        cleanupTestEnvironment()
    }
}
