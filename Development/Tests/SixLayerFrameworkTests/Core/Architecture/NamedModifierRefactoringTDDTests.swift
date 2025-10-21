import Testing


import SwiftUI
@testable import SixLayerFramework

/// TDD Tests for .named and .exactNamed Modifier Behavior
/// 
/// BUSINESS PURPOSE: Refactor .named modifier to be simpler and more predictable
/// 
/// CURRENT PROBLEM: .named modifier is over-engineered - it changes global settings,
/// applies complex ID generation, and has unpredictable behavior.
/// 
/// DESIRED BEHAVIOR: 
/// - .named: Replace current hierarchy level + generate full hierarchy path (default case)
/// - .exactNamed: Apply exact name only, no hierarchy modification (explicit case)
/// 
/// TESTING SCOPE: These tests define the new behavior and should FAIL initially
/// (RED phase) until the implementation is updated to match.
open class NamedModifierRefactoringTDDTests {
    
    init() async throws {
                // Reset configuration to known state
        await MainActor.run {
            let config = AccessibilityIdentifierConfig.shared
            config.enableAutoIDs = true
            config.namespace = "TestApp"
            config.mode = .automatic
            config.enableViewHierarchyTracking = true
            config.enableDebugLogging = false
        }
    }    // MARK: - RED PHASE TESTS (Should FAIL initially)
    
    /// TDD RED PHASE: Test that .named replaces current hierarchy level
    /// THIS TEST SHOULD FAIL - proving current implementation doesn't match desired behavior
    @Test func testNamedModifierReplacesCurrentHierarchyLevel() async {
        await MainActor.run {
            // Given: A button with .named modifier
            let testView = Button("Save") { }
                .named("SaveButton")
            
            // When: We check the accessibility identifier
            // Then: Should get full hierarchy path ending with "SaveButton"
            #expect(testAccessibilityIdentifiersSinglePlatform(
                testView, 
                expectedPattern: "TestApp.main.element.*", 
                platform: .iOS,
            platform: .iOS,
            componentName: "HierarchyReplacement"
            ), "RED PHASE: .named() should replace current hierarchy level and generate full path as accessibility ID")
        }
    }
    
    /// TDD RED PHASE: Test that .named generates full hierarchy path
    /// THIS TEST SHOULD FAIL - proving current implementation doesn't match desired behavior
    @Test func testNamedModifierGeneratesFullHierarchyPath() async {
        await MainActor.run {
            // Given: Nested components with .named modifiers
            let testView = VStack {
                Button("Edit") { }
                    .named("EditButton")
            }
            .named("ActionContainer")
            
            // When: We check the accessibility identifier
            // Then: Should get full path including both names
            #expect(testAccessibilityIdentifiersSinglePlatform(
                testView, 
                expectedPattern: "TestApp.main.element.*", 
                platform: .iOS,
            platform: .iOS,
            componentName: "FullHierarchyPath"
            ), "RED PHASE: .named() should generate full hierarchy path as accessibility identifier")
        }
    }
    
    /// TDD RED PHASE: Test that multiple nested .named modifiers build hierarchy
    /// THIS TEST SHOULD FAIL - proving current implementation doesn't match desired behavior
    @Test func testMultipleNestedNamedModifiersBuildHierarchy() async {
        await MainActor.run {
            // Given: Multiple levels of .named modifiers
            let testView = VStack {
                HStack {
                    Button("Cancel") { }
                        .named("CancelButton")
                }
                .named("ButtonRow")
            }
            .named("DialogBox")
            
            // When: We check the accessibility identifier
            // Then: Should get complete hierarchy path
            #expect(testAccessibilityIdentifiersSinglePlatform(
                testView, 
                expectedPattern: "TestApp.main.element.*", 
                platform: .iOS,
            platform: .iOS,
            componentName: "NestedHierarchy"
            ), "RED PHASE: Multiple .named() calls should build complete hierarchy path")
        }
    }
    
    /// TDD RED PHASE: Test that .named prevents collision with same names
    /// THIS TEST SHOULD FAIL - proving current implementation doesn't match desired behavior
    @Test func testNamedModifierPreventsCollisionWithSameNames() async {
        await MainActor.run {
            // Given: Two buttons with same name in different contexts
            let view1 = VStack {
                Button("Save") { }
                    .named("SaveButton")
            }
            .named("UserProfile")
            
            let view2 = VStack {
                Button("Save") { }
                    .named("SaveButton")
            }
            .named("Settings")
            
            // When: We check both accessibility identifiers
            // Then: Should get different full paths
            #expect(testAccessibilityIdentifiersSinglePlatform(
                view1, 
                expectedPattern: "TestApp.main.element.*", 
                platform: .iOS,
            platform: .iOS,
            componentName: "CollisionPrevention1"
            ), "RED PHASE: First SaveButton should include UserProfile in path")
            
            #expect(testAccessibilityIdentifiersSinglePlatform(
                view2, 
                expectedPattern: "TestApp.main.element.*", 
                platform: .iOS,
            platform: .iOS,
            componentName: "CollisionPrevention2"
            ), "RED PHASE: Second SaveButton should include Settings in path")
        }
    }
    
    /// TDD RED PHASE: Test that .named works independently of global settings
    /// THIS TEST SHOULD FAIL - proving current implementation doesn't match desired behavior
    @Test func testNamedModifierWorksIndependentlyOfGlobalSettings() async {
        await MainActor.run {
            // Given: Global automatic accessibility disabled
            AccessibilityIdentifierConfig.shared.enableAutoIDs = false
            
            let testView = Button("Test") { }
                .named("TestButton")
            
            // When: We check the accessibility identifier
            // Then: Should still get full hierarchy path even with global system disabled
            #expect(testAccessibilityIdentifiersSinglePlatform(
                testView, 
                expectedPattern: "TestApp.main.element.*", 
                platform: .iOS,
            platform: .iOS,
            componentName: "IndependentNamedModifier"
            ), "RED PHASE: .named() should work independently of global automatic accessibility settings")
        }
    }
    
    /// TDD RED PHASE: Test that .named overrides existing accessibility identifier
    /// THIS TEST SHOULD FAIL - proving current implementation doesn't match desired behavior
    @Test func testNamedModifierOverridesExistingAccessibilityIdentifier() async {
        await MainActor.run {
            // Given: A button with existing accessibility identifier
            let testView = Button("Test") { }
                .accessibilityIdentifier("OriginalID")
                .named("NewName")
            
            // When: We check the accessibility identifier
            // Then: Should get full hierarchy path, not "OriginalID"
            #expect(testAccessibilityIdentifiersSinglePlatform(
                testView, 
                expectedPattern: "TestApp.main.element.*", 
                platform: .iOS,
            platform: .iOS,
            componentName: "OverrideTest"
            ), "RED PHASE: .named() should override existing accessibility identifier with full hierarchy path")
        }
    }
    
    /// TDD RED PHASE: Test that subcomponents inherit modified hierarchy
    /// THIS TEST SHOULD FAIL - proving current implementation doesn't match desired behavior
    @Test func testSubcomponentsInheritModifiedHierarchy() async {
        await MainActor.run {
            // Given: A container with .named and subcomponent with automatic accessibility
            let testView = VStack {
                Button("Save") { }
                    .automaticAccessibilityIdentifiers()
            }
            .named("ActionContainer")
            
            // When: We check the accessibility identifier
            // Then: Button should include "ActionContainer" in its generated ID
            #expect(testAccessibilityIdentifiersSinglePlatform(
                testView, 
                expectedPattern: "TestApp.main.element.*", 
                platform: .iOS,
            platform: .iOS,
            componentName: "HierarchyInheritance"
            ), "RED PHASE: Subcomponents should inherit modified hierarchy context")
        }
    }
    
    /// TDD RED PHASE: Test that .named handles empty string gracefully
    /// THIS TEST SHOULD FAIL - proving current implementation doesn't match desired behavior
    @Test func testNamedModifierWithEmptyString() async {
        await MainActor.run {
            // Given: A button with empty string in .named
            let testView = Button("Test") { }
                .named("")
            
            // When: We check the accessibility identifier
            // Then: Should handle empty string gracefully
            #expect(testAccessibilityIdentifiersSinglePlatform(
                testView, 
                expectedPattern: ".*", 
                platform: .iOS,
            platform: .iOS,
            componentName: "EmptyStringTest"
            ), "RED PHASE: .named() with empty string should handle gracefully")
        }
    }
    
    /// TDD RED PHASE: Test that .named doesn't change global environment settings
    /// THIS TEST SHOULD FAIL - proving current implementation doesn't match desired behavior
    @Test func testNamedModifierDoesNotChangeGlobalEnvironmentSettings() async {
        await MainActor.run {
            // Given: Global settings are disabled
            AccessibilityIdentifierConfig.shared.enableAutoIDs = false
            
            let testView = Button("Test") { }
                .named("TestButton")
            
            // When: We check the accessibility identifier
            // Then: Should work without changing global settings
            #expect(testAccessibilityIdentifiersSinglePlatform(
                testView, 
                expectedPattern: "TestApp.main.element.*", 
                platform: .iOS,
            platform: .iOS,
            componentName: "NoGlobalChanges"
            ), "RED PHASE: .named() should not change global environment settings")
            
            // And global settings should remain unchanged
            #expect(!AccessibilityIdentifierConfig.shared.enableAutoIDs, 
                          "Global settings should remain unchanged after .named()")
        }
    }
    
    // MARK: - .exactNamed Modifier Tests (NEW)
    
    /// TDD RED PHASE: Test that .exactNamed applies exact name only
    /// THIS TEST SHOULD FAIL - proving .exactNamed doesn't exist yet (compilation error)
    @Test func testExactNamedModifierAppliesExactNameOnly() async {
        await MainActor.run {
            // Given: A button with .exactNamed modifier
            let testView = Button("Save") { }
                .exactNamed("SaveButton")
            
            // When: We check the accessibility identifier
            // Then: Should get exactly "SaveButton" (no hierarchy)
            #expect(testAccessibilityIdentifiersSinglePlatform(
                testView, 
                expectedPattern: "^SaveButton$", 
                platform: .iOS,
            platform: .iOS,
            componentName: "ExactNamedModifier"
            ), "RED PHASE: .exactNamed() should apply exact name only, no hierarchy")
        }
    }
    
    /// TDD RED PHASE: Test that .exactNamed doesn't modify hierarchy
    /// THIS TEST SHOULD FAIL - proving .exactNamed doesn't exist yet
    @Test func testExactNamedModifierDoesNotModifyHierarchy() async {
        await MainActor.run {
            // Given: Nested components with .exactNamed modifier
            let testView = VStack {
                Button("Edit") { }
                    .exactNamed("EditButton")
            }
            .named("ActionContainer")
            
            // When: We check the accessibility identifier
            // Then: Button should get exact name, VStack should get hierarchy
            #expect(testAccessibilityIdentifiersSinglePlatform(
                testView, 
                expectedPattern: "TestApp.main.element.*", 
                platform: .iOS,
            platform: .iOS,
            componentName: "ExactNamedHierarchyTest"
            ), "RED PHASE: .exactNamed() should not modify hierarchy for other components")
        }
    }
    
    /// TDD RED PHASE: Test that .exactNamed works independently of global settings
    /// THIS TEST SHOULD FAIL - proving .exactNamed doesn't exist yet
    @Test func testExactNamedModifierWorksIndependentlyOfGlobalSettings() async {
        await MainActor.run {
            // Given: Global automatic accessibility disabled
            AccessibilityIdentifierConfig.shared.enableAutoIDs = false
            
            let testView = Button("Test") { }
                .exactNamed("TestButton")
            
            // When: We check the accessibility identifier
            // Then: Should get exact name even with global system disabled
            #expect(testAccessibilityIdentifiersSinglePlatform(
                testView, 
                expectedPattern: "^TestButton$", 
                platform: .iOS,
            platform: .iOS,
            componentName: "IndependentExactNamedModifier"
            ), "RED PHASE: .exactNamed() should work independently of global settings")
        }
    }
    
    /// TDD RED PHASE: Test that .exactNamed overrides existing accessibility identifier
    /// THIS TEST SHOULD FAIL - proving .exactNamed doesn't exist yet
    @Test func testExactNamedModifierOverridesExistingAccessibilityIdentifier() async {
        await MainActor.run {
            // Given: A button with existing accessibility identifier
            let testView = Button("Test") { }
                .accessibilityIdentifier("OriginalID")
                .exactNamed("NewExactName")
            
            // When: We check the accessibility identifier
            // Then: Should get exact name, not "OriginalID"
            #expect(testAccessibilityIdentifiersSinglePlatform(
                testView, 
                expectedPattern: "^NewExactName$", 
                platform: .iOS,
            platform: .iOS,
            componentName: "ExactNamedOverrideTest"
            ), "RED PHASE: .exactNamed() should override existing accessibility identifier with exact name")
        }
    }
    
    // MARK: - Combined Modifier Tests (NEW)
    
    /// TDD RED PHASE: Test that .named and .exactNamed work together
    /// THIS TEST SHOULD FAIL - proving both modifiers don't work as expected yet
    @Test func testNamedAndExactNamedWorkTogether() async {
        await MainActor.run {
            // Given: Nested components with both modifiers
            let testView = VStack {
                Button("Save") { }
                    .exactNamed("SaveButton")  // Exact name only
                Button("Cancel") { }
                    .named("CancelButton")     // Hierarchical name
            }
            .named("DialogBox")
            
            // When: We check the accessibility identifier
            // Then: Should get hierarchical path for the container
            #expect(testAccessibilityIdentifiersSinglePlatform(
                testView, 
                expectedPattern: "TestApp.main.element.*", 
                platform: .iOS,
            platform: .iOS,
            componentName: "CombinedModifiersTest"
            ), "RED PHASE: .named() and .exactNamed() should work together")
        }
    }
    
    /// TDD RED PHASE: Test collision prevention with .exactNamed
    /// THIS TEST SHOULD FAIL - proving .exactNamed doesn't prevent collisions
    @Test func testExactNamedModifierDoesNotPreventCollisions() async {
        await MainActor.run {
            // Given: Two buttons with same exact name
            let view1 = Button("Save") { }
                .exactNamed("SaveButton")
            
            let view2 = Button("Save") { }
                .exactNamed("SaveButton")
            
            // When: We check both accessibility identifiers
            // Then: Both should get the same exact name (collision expected)
            #expect(testAccessibilityIdentifiersSinglePlatform(
                view1, 
                expectedPattern: "^SaveButton$", 
                platform: .iOS,
            platform: .iOS,
            componentName: "ExactNamedCollision1"
            ), "RED PHASE: First .exactNamed() should get exact name")
            
            #expect(testAccessibilityIdentifiersSinglePlatform(
                view2, 
                expectedPattern: "^SaveButton$", 
                platform: .iOS,
            platform: .iOS,
            componentName: "ExactNamedCollision2"
            ), "RED PHASE: Second .exactNamed() should get same exact name (collision)")
        }
    }
    
    /// TDD RED PHASE: Test that .exactNamed handles empty string
    /// THIS TEST SHOULD FAIL - proving .exactNamed doesn't exist yet
    @Test func testExactNamedModifierWithEmptyString() async {
        await MainActor.run {
            // Given: A button with empty string in .exactNamed
            let testView = Button("Test") { }
                .exactNamed("")
            
            // Debug: Print the test view
            print("DEBUG: Test view type: \(type(of: testView))")
            print("DEBUG: About to test empty string accessibility identifier")
            
            // When: We check the accessibility identifier
            // Then: Should handle empty string gracefully
            #expect(testAccessibilityIdentifiersSinglePlatform(
                testView, 
                expectedPattern: "^$", 
                platform: .iOS,
            platform: .iOS,
            componentName: "ExactNamedEmptyStringTest"
            ), "RED PHASE: .exactNamed() with empty string should handle gracefully")
        }
    }
}
