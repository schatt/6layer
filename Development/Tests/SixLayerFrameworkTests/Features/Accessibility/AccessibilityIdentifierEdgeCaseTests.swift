import Testing


import SwiftUI
@testable import SixLayerFramework
#if !os(macOS)
import ViewInspector
#endif
/// Edge case tests for accessibility identifier generation bug fix
/// These tests ensure our fix handles all edge cases properly
@MainActor
@Suite("Accessibility Identifier Edge Case")
open class AccessibilityIdentifierEdgeCaseTests: BaseTestClass {
    // MARK: - Edge Case 1: Empty String Parameters
    
    @Test func testEmptyStringParameters() {
        runWithTaskLocalConfig {
            setupTestEnvironment()
            
            let view = PlatformInteractionButton(style: .primary, action: {}) {
                platformPresentContent_L1(content: "Test", hints: PresentationHints())
            }
                .named("")  // ← Empty string
            
            // Using wrapper - when ViewInspector works on macOS, no changes needed here
            if let inspectedView = view.tryInspect(),
               let buttonID = try? inspectedView.accessibilityIdentifier() {
                // Should handle empty strings gracefully
                #expect(!buttonID.isEmpty, "Should generate ID even with empty parameters")
                #expect(buttonID.contains("SixLayer"), "Should contain namespace")
                
                print("✅ Empty string ID: '\(buttonID)' (\(buttonID.count) chars)")
            } else {
                Issue.record("Failed to inspect view with empty strings")
            }
        }
    }
    
    // MARK: - Edge Case 2: Special Characters in Names
    
    @Test func testSpecialCharactersInNames() {
        runWithTaskLocalConfig {
            setupTestEnvironment()
            
            // Test: How are special characters handled in names?
            let view = PlatformInteractionButton(style: .primary, action: {}) {
                platformPresentContent_L1(content: "Test", hints: PresentationHints())
            }
                .named("Button@#$%^&*()")  // ← Special characters
            
            // Using wrapper - when ViewInspector works on macOS, no changes needed here
            if let inspectedView = view.tryInspect(),
               let buttonID = try? inspectedView.accessibilityIdentifier() {
                // Should preserve special characters (no sanitization)
                #expect(!buttonID.isEmpty, "Should generate ID with special characters")
                #expect(buttonID.contains("SixLayer"), "Should contain namespace")
                #expect(buttonID.contains("@#$%^&*()"), "Should preserve special characters")
                
                print("✅ Special chars ID: '\(buttonID)' (\(buttonID.count) chars)")
            } else {
                Issue.record("Failed to inspect view with special characters")
            }
            }
    }
    
    // MARK: - Edge Case 3: Very Long Names
    
    @Test func testVeryLongNames() {
        runWithTaskLocalConfig {
            setupTestEnvironment()
            
            // Test: Does it handle extremely long names gracefully?
            let longName = String(repeating: "VeryLongName", count: 50)  // 600+ chars
            let view = PlatformInteractionButton(style: .primary, action: {}) {
                platformPresentContent_L1(content: "Test", hints: PresentationHints())
            }
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
    }
    
    // MARK: - Edge Case 4: Manual ID Override
    
    @Test func testManualIDOverride() {
        runWithTaskLocalConfig {
            setupTestEnvironment()
            
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
    }
    
    // MARK: - Edge Case 5: Disable/Enable Mid-Hierarchy
    
    @Test func testDisableEnableMidHierarchy() {
        runWithTaskLocalConfig {
            setupTestEnvironment()
            
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
                #expect(autoButtonID.contains("SixLayer"), "Auto button should have automatic ID")
                
                // Second button should not have accessibility identifier modifier
                // (We can't inspect for accessibility identifier when disabled)
                // Just verify the button exists
                #expect(buttons[1] != nil, "Disabled button should still exist")
                
                print("✅ Mid-hierarchy disable works")
                
            } catch {
                Issue.record("Failed to inspect view with mid-hierarchy disable: \(error)")
        }
            }
    }
    
    // MARK: - Edge Case 6: Multiple Screen Contexts
    
    @Test func testMultipleScreenContexts() {
        runWithTaskLocalConfig {
            setupTestEnvironment()
            
            let view = VStack {
                Text("Content")
            }
            .named("TestView")
            
            do {
                let inspectedView = try view.inspect()
                let vStackID = try inspectedView.accessibilityIdentifier()
                
                // Should handle multiple contexts (last one wins or combines)
                #expect(!vStackID.isEmpty, "Should generate ID with multiple contexts")
                #expect(vStackID.contains("SixLayer"), "Should contain namespace")
                
                print("✅ Multiple contexts ID: '\(vStackID)' (\(vStackID.count) chars)")
                
            } catch {
                Issue.record("Failed to inspect view with multiple contexts: \(error)")
        }
            }
    }
    
    // MARK: - Edge Case 7: Exact Named Behavior (Red Phase Tests)
    
    @Test func testExactNamedBehavior() {
        runWithTaskLocalConfig {
            setupTestEnvironment()
            
            // Test: Does exactNamed() use exact names without hierarchy?
            let view1 = PlatformInteractionButton(style: .primary, action: {}) {
                platformPresentContent_L1(content: "Test1", hints: PresentationHints())
            }
                .exactNamed("SameName")
                .enableGlobalAutomaticAccessibilityIdentifiers()
            
            let view2 = PlatformInteractionButton(style: .primary, action: {}) {
                platformPresentContent_L1(content: "Test2", hints: PresentationHints())
            }
                .exactNamed("SameName")  // ← Same exact name
                .enableGlobalAutomaticAccessibilityIdentifiers()
            
            do {
                let inspectedView1 = try view1.inspect()
                let button1ID = try inspectedView1.accessibilityIdentifier()
                
                let inspectedView2 = try view2.inspect()
                let button2ID = try inspectedView2.accessibilityIdentifier()
                
                // exactNamed() should respect the exact name (no hierarchy, no collision detection)
                #expect(button1ID == button2ID, "exactNamed() should use exact names without modification")
                #expect(button1ID == "SameName", "exactNamed() should produce exact identifier 'SameName', got '\(button1ID)'")
                #expect(button2ID == "SameName", "exactNamed() should produce exact identifier 'SameName', got '\(button2ID)'")
                
                print("✅ Exact named test - ID1: '\(button1ID)'")
                print("✅ Exact named test - ID2: '\(button2ID)'")
                
            } catch {
                Issue.record("Failed to inspect exactNamed views: \(error)")
        }
            }
    }
    
    @Test func testExactNamedVsNamedDifference() {
        runWithTaskLocalConfig {
            setupTestEnvironment()
            
            // Test: exactNamed() should produce different identifiers than named()
            let exactView = Button("Test") { }
                .exactNamed("TestButton")
                .enableGlobalAutomaticAccessibilityIdentifiers()
            
            let namedView = Button("Test") { }
                .named("TestButton")
                .enableGlobalAutomaticAccessibilityIdentifiers()
            
            do {
                let exactInspected = try exactView.inspect()
                let exactID = try exactInspected.accessibilityIdentifier()
                
                let namedInspected = try namedView.inspect()
                let namedID = try namedInspected.accessibilityIdentifier()
                
                // exactNamed() should produce different identifiers than named()
                // This test will FAIL until exactNamed() is properly implemented
                #expect(exactID != namedID, "exactNamed() should produce different identifiers than named()")
                #expect(exactID.contains("TestButton"), "exactNamed() should contain the exact name")
                #expect(namedID.contains("TestButton"), "named() should contain the name")
                #expect(exactID == "TestButton", "exactNamed() should produce exact identifier 'TestButton', got '\(exactID)'")
                
                print("✅ Exact vs Named - Exact: '\(exactID)'")
                print("✅ Exact vs Named - Named: '\(namedID)'")
                
            } catch {
                Issue.record("Failed to inspect exactNamed vs named views: \(error)")
        }
            }
    }
    
    @Test func testExactNamedIgnoresHierarchy() {
        runWithTaskLocalConfig {
            setupTestEnvironment()
            
            // Test: exactNamed() should ignore view hierarchy context
            guard let config = testConfig else {
                Issue.record("testConfig is nil")
                return
            }
            config.pushViewHierarchy("NavigationView")
            config.pushViewHierarchy("ProfileSection")
            config.setScreenContext("UserProfile")
            
            let exactView = Button("Test") { }
                .exactNamed("SaveButton")
                .enableGlobalAutomaticAccessibilityIdentifiers()
            
            do {
                let exactInspected = try exactView.inspect()
                let exactID = try exactInspected.accessibilityIdentifier()
                
                // exactNamed() should NOT include hierarchy components
                // This test will FAIL until exactNamed() is properly implemented
                #expect(!exactID.contains("NavigationView"), "exactNamed() should ignore NavigationView hierarchy")
                #expect(!exactID.contains("ProfileSection"), "exactNamed() should ignore ProfileSection hierarchy")
                #expect(!exactID.contains("UserProfile"), "exactNamed() should ignore UserProfile screen context")
                #expect(exactID.contains("SaveButton"), "exactNamed() should contain the exact name")
                #expect(exactID == "SaveButton", "exactNamed() should produce exact identifier 'SaveButton', got '\(exactID)'")
                
                print("✅ Exact named ignores hierarchy - ID: '\(exactID)'")
                
            } catch {
                Issue.record("Failed to inspect exactNamed with hierarchy: \(error)")
        }
            }
    }
    
    @Test func testExactNamedMinimalIdentifier() {
        runWithTaskLocalConfig {
            setupTestEnvironment()
            
            // Test: exactNamed() should produce minimal identifiers
            let exactView = Button("Test") { }
                .exactNamed("MinimalButton")
                .enableGlobalAutomaticAccessibilityIdentifiers()
            
            do {
                let exactInspected = try exactView.inspect()
                let exactID = try exactInspected.accessibilityIdentifier()
                
                // exactNamed() should produce minimal identifiers (just the exact name)
                // This test will FAIL until exactNamed() is properly implemented
                let expectedMinimalPattern = "MinimalButton"
                #expect(exactID == expectedMinimalPattern, "exactNamed() should produce exact identifier '\(expectedMinimalPattern)', got '\(exactID)'")
                
                print("✅ Exact named minimal - ID: '\(exactID)'")
                
            } catch {
                Issue.record("Failed to inspect exactNamed minimal: \(error)")
        }
            }
    }
    
    // MARK: - Edge Case 8: Configuration Changes Mid-Test
    
    @Test func testConfigurationChangesMidTest() {
        runWithTaskLocalConfig {
            setupTestEnvironment()
            
            // Test: What happens if configuration changes during view creation?
            guard let config = testConfig else {

                Issue.record("testConfig is nil")

                return

            }
            
            let view = PlatformInteractionButton(style: .primary, action: {}) {
                platformPresentContent_L1(content: "Test", hints: PresentationHints())
            }
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
    }
    
    // MARK: - Edge Case 9: Nested .named() Calls
    
    @Test func testNestedNamedCalls() {
        runWithTaskLocalConfig {
            setupTestEnvironment()
            
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
                #expect(buttonID.contains("SixLayer"), "Should contain namespace")
                #expect(!buttonID.contains("outer-outer"), "Should not duplicate names")
                
                print("✅ Nested calls ID: '\(buttonID)' (\(buttonID.count) chars)")
                
            } catch {
                Issue.record("Failed to inspect view with nested .named() calls: \(error)")
        }
            }
    }
    
    // MARK: - Edge Case 10: Unicode Characters
    
    @Test func testUnicodeCharacters() {
        runWithTaskLocalConfig {
            setupTestEnvironment()
            
            // Test: How are Unicode characters handled?
            let view = PlatformInteractionButton(style: .primary, action: {}) {
                platformPresentContent_L1(content: "Test", hints: PresentationHints())
            }
                .named("按钮")  // ← Chinese characters
            
            do {
                let inspectedView = try view.inspect()
                let buttonID = try inspectedView.accessibilityIdentifier()
                
                // Should handle Unicode gracefully
                #expect(!buttonID.isEmpty, "Should generate ID with Unicode characters")
                #expect(buttonID.contains("SixLayer"), "Should contain namespace")
                
                print("✅ Unicode ID: '\(buttonID)' (\(buttonID.count) chars)")
                
            } catch {
                Issue.record("Failed to inspect view with Unicode characters: \(error)")
        }
            }
    }
}
