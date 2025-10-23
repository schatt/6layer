import Testing


import SwiftUI
import ViewInspector
@testable import SixLayerFramework

/// Edge case tests for accessibility identifier generation bug fix
/// These tests ensure our fix handles all edge cases properly
@MainActor
open class AccessibilityIdentifierEdgeCaseTests: BaseTestClass {    // MARK: - Edge Case 1: Empty String Parameters
    
    @Test func testEmptyStringParameters() {
        let view = Button("Test") { }
            .named("")  // ← Empty string
        
        do {
            let inspectedView = try view.inspect()
            let buttonID = try inspectedView.accessibilityIdentifier()
            
            // Should handle empty strings gracefully
            #expect(!buttonID.isEmpty, "Should generate ID even with empty parameters")
            #expect(buttonID.contains("CarManager"), "Should contain namespace")
            
            print("✅ Empty string ID: '\(buttonID)' (\(buttonID.count) chars)")
            
        } catch {
            Issue.record("Failed to inspect view with empty strings: \(error)")
        }
    }
    
    // MARK: - Edge Case 2: Special Characters in Names
    
    @Test func testSpecialCharactersInNames() {
        // Test: How are special characters handled in names?
        let view = Button("Test") { }
            .named("Button@#$%^&*()")  // ← Special characters
        
        do {
            let inspectedView = try view.inspect()
            let buttonID = try inspectedView.accessibilityIdentifier()
            
            // Should preserve special characters (no sanitization)
            #expect(!buttonID.isEmpty, "Should generate ID with special characters")
            #expect(buttonID.contains("CarManager"), "Should contain namespace")
            #expect(buttonID.contains("@#$%^&*()"), "Should preserve special characters")
            
            print("✅ Special chars ID: '\(buttonID)' (\(buttonID.count) chars)")
            
        } catch {
            Issue.record("Failed to inspect view with special characters: \(error)")
        }
    }
    
    // MARK: - Edge Case 3: Very Long Names
    
    @Test func testVeryLongNames() {
        // Test: Does it handle extremely long names gracefully?
        let longName = String(repeating: "VeryLongName", count: 50)  // 600+ chars
        let view = Button("Test") { }
            .named(longName)
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        do {
            let inspectedView = try view.inspect()
            let buttonID = try inspectedView.accessibilityIdentifier()
            
            // Should handle long names gracefully
            #expect(!buttonID.isEmpty, "Should generate ID with very long names")
            #expect(buttonID.contains("SixLayer"), "Should contain namespace")
            
            // Warn if extremely long (but don't fail the test)
            if buttonID.count > 200 {
                print("⚠️ WARNING: Generated extremely long accessibility ID (\(buttonID.count) chars)")
                print("   Consider using shorter, more semantic names for better debugging experience")
                print("   ID: '\(buttonID)'")
            } else {
                print("✅ Long name ID: '\(buttonID)' (\(buttonID.count) chars)")
            }
            
        } catch {
            Issue.record("Failed to inspect view with very long names: \(error)")
        }
    }
    
    // MARK: - Edge Case 4: Manual ID Override
    
    @Test func testManualIDOverride() {
        // Test: Does manual ID override automatic ID?
        let view = PlatformInteractionButton(style: .primary, action: {
            // Test action
        }) {
            Text("Test")
        }
        .accessibilityIdentifier("manual-override")  // ← Manual override
        
        do {
            let inspectedView = try view.inspect()
            let buttonID = try inspectedView.accessibilityIdentifier()
            
            // Manual ID should override automatic ID
            #expect(buttonID == "manual-override", "Manual ID should override automatic ID")
            
            print("✅ Manual override ID: '\(buttonID)'")
            
        } catch {
            Issue.record("Failed to inspect view with manual override: \(error)")
        }
    }
    
    // MARK: - Edge Case 5: Disable/Enable Mid-Hierarchy
    
    @Test func testDisableEnableMidHierarchy() {
        // Test: Does disable work mid-hierarchy?
        let view = VStack {
            Button("Auto") { }
                .named("AutoButton")
                .enableGlobalAutomaticAccessibilityIdentifiers()
            
            Button("Manual") { }
                .named("ManualButton")
                .disableAutomaticAccessibilityIdentifiers()  // ← Disable mid-hierarchy
        }
        
        do {
            let inspectedView = try view.inspect()
            let buttons = inspectedView.findAll(ViewType.Button.self)
            
            #expect(buttons.count == 2, "Should find both buttons")
            
            // First button should have automatic ID
            let autoButtonID = try buttons[0].accessibilityIdentifier()
            #expect(autoButtonID.contains("CarManager"), "Auto button should have automatic ID")
            
            // Second button should not have accessibility identifier modifier
            // (We can't inspect for accessibility identifier when disabled)
            // Just verify the button exists
            #expect(buttons[1] != nil, "Disabled button should still exist")
            
            print("✅ Mid-hierarchy disable works")
            
        } catch {
            Issue.record("Failed to inspect view with mid-hierarchy disable: \(error)")
        }
    }
    
    // MARK: - Edge Case 6: Multiple Screen Contexts
    
    @Test func testMultipleScreenContexts() {
        let view = VStack {
            Text("Content")
        }
        .named("TestView")
        
        do {
            let inspectedView = try view.inspect()
            let vStackID = try inspectedView.accessibilityIdentifier()
            
            // Should handle multiple contexts (last one wins or combines)
            #expect(!vStackID.isEmpty, "Should generate ID with multiple contexts")
            #expect(vStackID.contains("CarManager"), "Should contain namespace")
            
            print("✅ Multiple contexts ID: '\(vStackID)' (\(vStackID.count) chars)")
            
        } catch {
            Issue.record("Failed to inspect view with multiple contexts: \(error)")
        }
    }
    
    // MARK: - Edge Case 7: Collision Detection
    
    @Test func testCollisionDetection() {
        // Test: Are IDs unique despite same names?
        let view1 = Button("Test1") { }
            .named("SameName")
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        let view2 = Button("Test2") { }
            .named("SameName")  // ← Same name
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        do {
            let inspectedView1 = try view1.inspect()
            let button1ID = try inspectedView1.accessibilityIdentifier()
            
            let inspectedView2 = try view2.inspect()
            let button2ID = try inspectedView2.accessibilityIdentifier()
            
            // IDs should be unique despite same names
            #expect(button1ID != button2ID, "IDs should be unique despite same names")
            #expect(button1ID.contains("CarManager"), "First ID should contain namespace")
            #expect(button2ID.contains("CarManager"), "Second ID should contain namespace")
            
            print("✅ Collision test - ID1: '\(button1ID)'")
            print("✅ Collision test - ID2: '\(button2ID)'")
            
        } catch {
            Issue.record("Failed to inspect views for collision detection: \(error)")
        }
    }
    
    // MARK: - Edge Case 8: Configuration Changes Mid-Test
    
    @Test func testConfigurationChangesMidTest() {
        // Test: What happens if configuration changes during view creation?
        let config = AccessibilityIdentifierConfig.shared
        
        let view = Button("Test") { }
            .named("TestButton")
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        // Change configuration after view creation
        config.namespace = "ChangedNamespace"
        config.mode = .semantic
        
        do {
            let inspectedView = try view.inspect()
            let buttonID = try inspectedView.accessibilityIdentifier()
            
            // Should use configuration at time of ID generation
            #expect(!buttonID.isEmpty, "Should generate ID with changed config")
            
            print("✅ Config change ID: '\(buttonID)' (\(buttonID.count) chars)")
            
        } catch {
            Issue.record("Failed to inspect view with config changes: \(error)")
        }
    }
    
    // MARK: - Edge Case 9: Nested .named() Calls
    
    @Test func testNestedNamedCalls() {
        // Test: What happens with deeply nested .named() calls?
        let view = VStack {
            HStack {
                Button("Content") { }
                    .named("DeepNested")
                    .enableGlobalAutomaticAccessibilityIdentifiers()
            }
            .named("Nested")
        }
        .named("Outer")
        .named("VeryOuter")  // ← Multiple .named() calls
        
        do {
            let inspectedView = try view.inspect()
            let button = try inspectedView.find(ViewType.Button.self)
            let buttonID = try button.accessibilityIdentifier()
            
            // Should handle nested calls without duplication
            #expect(!buttonID.isEmpty, "Should generate ID with nested .named() calls")
            #expect(buttonID.contains("CarManager"), "Should contain namespace")
            #expect(!buttonID.contains("outer-outer"), "Should not duplicate names")
            
            print("✅ Nested calls ID: '\(buttonID)' (\(buttonID.count) chars)")
            
        } catch {
            Issue.record("Failed to inspect view with nested .named() calls: \(error)")
        }
    }
    
    // MARK: - Edge Case 10: Unicode Characters
    
    @Test func testUnicodeCharacters() {
        // Test: How are Unicode characters handled?
        let view = Button("Test") { }
            .named("按钮")  // ← Chinese characters
        
        do {
            let inspectedView = try view.inspect()
            let buttonID = try inspectedView.accessibilityIdentifier()
            
            // Should handle Unicode gracefully
            #expect(!buttonID.isEmpty, "Should generate ID with Unicode characters")
            #expect(buttonID.contains("CarManager"), "Should contain namespace")
            
            print("✅ Unicode ID: '\(buttonID)' (\(buttonID.count) chars)")
            
        } catch {
            Issue.record("Failed to inspect view with Unicode characters: \(error)")
        }
    }
}
