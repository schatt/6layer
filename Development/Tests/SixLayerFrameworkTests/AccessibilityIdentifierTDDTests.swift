import XCTest
import SwiftUI
import ViewInspector
@testable import SixLayerFramework

/// TDD Tests for Accessibility Identifier Generation
/// Following proper TDD: Test drives design, write best code to make tests pass
@MainActor
final class AccessibilityIdentifierTDDTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Reset configuration to known state
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
        config.enableAutoIDs = true
        config.namespace = "CarManager"
        config.mode = .automatic
        config.enableDebugLogging = false // Disable spam for TDD
    }
    
    override func tearDown() {
        super.tearDown()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
    }
    
    // MARK: - TDD Red Phase: Write Failing Tests for Desired Behavior
    
    func testAccessibilityIdentifiersAreReasonableLength() {
        // TDD: Define the behavior I want - short, clean IDs
        let view = Button("Add Fuel") { }
            .named("AddFuelButton")
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        do {
            let inspectedView = try view.inspect()
            let buttonID = try inspectedView.accessibilityIdentifier()
            
            // This test SHOULD FAIL initially - IDs are currently 400+ chars
            XCTAssertLessThan(buttonID.count, 80, "Accessibility ID should be reasonable length")
            XCTAssertTrue(buttonID.contains("CarManager"), "Should contain namespace")
            XCTAssertTrue(buttonID.contains("addfuelbutton"), "Should contain view name")
            
            print("✅ Generated ID: '\(buttonID)' (\(buttonID.count) chars)")
            
        } catch {
            XCTFail("Failed to inspect view: \(error)")
        }
    }
    
    func testAccessibilityIdentifiersDontDuplicateHierarchy() {
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
            XCTAssertFalse(vStackID.contains("container-container"), "Should not contain duplicated hierarchy")
            XCTAssertFalse(vStackID.contains("outercontainer-outercontainer"), "Should not contain duplicated hierarchy")
            XCTAssertLessThan(vStackID.count, 80, "Should be reasonable length even with multiple .named() calls")
            
            print("✅ Generated ID: '\(vStackID)' (\(vStackID.count) chars)")
            
        } catch {
            XCTFail("Failed to inspect view: \(error)")
        }
    }
    
    func testAccessibilityIdentifiersAreSemantic() {
        // TDD: Define the behavior I want - semantic, meaningful IDs
        let view = VStack {
            Text("User Profile")
                .named("ProfileTitle")
            Button("Edit") { }
                .named("EditButton")
        }
        .screenContext("UserProfile")
        .named("ProfileView")
        .enableGlobalAutomaticAccessibilityIdentifiers()
        
        do {
            let inspectedView = try view.inspect()
            let vStackID = try inspectedView.accessibilityIdentifier()
            
            // This test SHOULD FAIL initially - IDs are not semantic
            XCTAssertTrue(vStackID.contains("UserProfile"), "Should contain screen context")
            XCTAssertTrue(vStackID.contains("profileview"), "Should contain view name")
            XCTAssertLessThan(vStackID.count, 80, "Should be concise and semantic")
            
            print("✅ Generated ID: '\(vStackID)' (\(vStackID.count) chars)")
            
        } catch {
            XCTFail("Failed to inspect view: \(error)")
        }
    }
    
    func testAccessibilityIdentifiersWorkInComplexHierarchy() {
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
        .screenContext("ComplexView")
        .named("ComplexContainer")
        .enableGlobalAutomaticAccessibilityIdentifiers()
        
        do {
            let inspectedView = try view.inspect()
            let vStackID = try inspectedView.accessibilityIdentifier()
            
            // This test SHOULD FAIL initially - complex hierarchies create massive IDs
            XCTAssertLessThan(vStackID.count, 100, "Should handle complex hierarchies gracefully")
            XCTAssertTrue(vStackID.contains("ComplexView"), "Should contain screen context")
            XCTAssertTrue(vStackID.contains("complexcontainer"), "Should contain container name")
            XCTAssertFalse(vStackID.contains("item0-item1-item2"), "Should not contain all nested item names")
            
            print("✅ Generated ID: '\(vStackID)' (\(vStackID.count) chars)")
            
        } catch {
            XCTFail("Failed to inspect view: \(error)")
        }
    }
}
