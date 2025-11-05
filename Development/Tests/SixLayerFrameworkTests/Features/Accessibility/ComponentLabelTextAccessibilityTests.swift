import Testing
import SwiftUI
@testable import SixLayerFramework
import ViewInspector

/// TDD RED PHASE: Tests for label text inclusion in accessibility identifiers
/// These tests SHOULD FAIL until components are updated to include label text
/// 
/// BUSINESS PURPOSE: Ensure all components with String labels include label text in identifiers
/// TESTING SCOPE: All framework components that accept String labels/titles
/// METHODOLOGY: Test each component type, verify label text is included and sanitized
@Suite("Component Label Text Accessibility")
@MainActor
open class ComponentLabelTextAccessibilityTests: BaseTestClass {
    
    // MARK: - AdaptiveButton Tests
    
    @Test func testAdaptiveButtonIncludesLabelText() {
        setupTestEnvironment()
        
        // TDD RED: This should FAIL - AdaptiveButton should include "Submit" in identifier
        let button = AdaptiveButton("Submit", action: { })
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        do {
            let inspected = try button.inspect()
            let buttonID = try inspected.accessibilityIdentifier()
            
            #expect(buttonID.contains("submit") || buttonID.contains("Submit"), 
                   "AdaptiveButton identifier should include label text 'Submit'")
            
            print("🔴 RED: AdaptiveButton ID: '\(buttonID)'")
        } catch {
            Issue.record("Failed to inspect AdaptiveButton: \(error)")
        }
        
        cleanupTestEnvironment()
    }
    
    @Test func testAdaptiveButtonDifferentLabelsDifferentIdentifiers() {
        setupTestEnvironment()
        
        let submitButton = AdaptiveButton("Submit", action: { })
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        let cancelButton = AdaptiveButton("Cancel", action: { })
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        do {
            let submitInspected = try submitButton.inspect()
            let submitID = try submitInspected.accessibilityIdentifier()
            
            let cancelInspected = try cancelButton.inspect()
            let cancelID = try cancelInspected.accessibilityIdentifier()
            
            // TDD RED: Should FAIL - different labels should produce different IDs
            #expect(submitID != cancelID, 
                   "Buttons with different labels should have different identifiers")
            
            print("🔴 RED: Submit ID: '\(submitID)'")
            print("🔴 RED: Cancel ID: '\(cancelID)'")
        } catch {
            Issue.record("Failed to inspect buttons: \(error)")
        }
        
        cleanupTestEnvironment()
    }
    
    // MARK: - Platform Navigation Title Tests
    
    @Test func testPlatformNavigationTitleIncludesTitleText() {
        setupTestEnvironment()
        
        // TDD RED: This should FAIL - platformNavigationTitle should include title in identifier
        let view = VStack {
            Text("Content")
        }
        .platformNavigationTitle("Settings")
        .enableGlobalAutomaticAccessibilityIdentifiers()
        
        do {
            let inspected = try view.inspect()
            let viewID = try inspected.accessibilityIdentifier()
            
            #expect(viewID.contains("settings") || viewID.contains("Settings"), 
                   "platformNavigationTitle identifier should include title text 'Settings'")
            
            print("🔴 RED: Navigation Title ID: '\(viewID)'")
        } catch {
            Issue.record("Failed to inspect platformNavigationTitle: \(error)")
        }
        
        cleanupTestEnvironment()
    }
    
    // MARK: - Platform Navigation Link Tests
    
    @Test func testPlatformNavigationLinkWithTitleIncludesTitleText() {
        setupTestEnvironment()
        
        // TDD RED: This should FAIL - platformNavigationLink_L4 with title should include title
        let view = VStack {
            platformNavigationLink_L4(
                title: "Next Page",
                systemImage: "arrow.right",
                isActive: .constant(false)
            ) {
                Text("Destination")
            }
        }
        .enableGlobalAutomaticAccessibilityIdentifiers()
        
        do {
            let inspected = try view.inspect()
            // Navigation link might be nested, try to find it
            let viewID = try inspected.accessibilityIdentifier()
            
            #expect(viewID.contains("next") || viewID.contains("page") || viewID.contains("Next"), 
                   "platformNavigationLink_L4 identifier should include title text 'Next Page'")
            
            print("🔴 RED: Navigation Link ID: '\(viewID)'")
        } catch {
            Issue.record("Failed to inspect platformNavigationLink_L4: \(error)")
        }
        
        cleanupTestEnvironment()
    }
    
    // MARK: - Platform Navigation Button Tests
    
    @Test func testPlatformNavigationButtonIncludesTitleText() {
        setupTestEnvironment()
        
        // TDD RED: This should FAIL - platformNavigationButton should include title
        let button = VStack {
            platformNavigationButton(
                title: "Save",
                systemImage: "checkmark",
                accessibilityLabel: "Save changes",
                accessibilityHint: "Tap to save",
                action: { }
            )
        }
        .enableGlobalAutomaticAccessibilityIdentifiers()
        
        do {
            let inspected = try button.inspect()
            let buttonID = try inspected.accessibilityIdentifier()
            
            #expect(buttonID.contains("save") || buttonID.contains("Save"), 
                   "platformNavigationButton identifier should include title text 'Save'")
            
            print("🔴 RED: Navigation Button ID: '\(buttonID)'")
        } catch {
            Issue.record("Failed to inspect platformNavigationButton: \(error)")
        }
        
        cleanupTestEnvironment()
    }
    
    // MARK: - Label Sanitization Tests
    
    @Test func testLabelTextSanitizationHandlesSpaces() {
        setupTestEnvironment()
        
        let button = AdaptiveButton("Add New Item", action: { })
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        do {
            let inspected = try button.inspect()
            let buttonID = try inspected.accessibilityIdentifier()
            
            // TDD RED: Should FAIL - spaces should be converted to hyphens
            #expect(!buttonID.contains("Add New Item"), 
                   "Identifier should not contain raw label with spaces")
            #expect(buttonID.contains("add-new-item") || buttonID.contains("add") && buttonID.contains("new"), 
                   "Identifier should contain sanitized label (hyphens)")
            
            print("🔴 RED: Sanitized ID: '\(buttonID)'")
        } catch {
            Issue.record("Failed to inspect button: \(error)")
        }
        
        cleanupTestEnvironment()
    }
    
    @Test func testLabelTextSanitizationHandlesSpecialCharacters() {
        setupTestEnvironment()
        
        let button = AdaptiveButton("Save & Close!", action: { })
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        do {
            let inspected = try button.inspect()
            let buttonID = try inspected.accessibilityIdentifier()
            
            // TDD RED: Should FAIL - special chars should be sanitized
            #expect(!buttonID.contains("&"), "Identifier should not contain '&'")
            #expect(!buttonID.contains("!"), "Identifier should not contain '!'")
            
            print("🔴 RED: Special chars ID: '\(buttonID)'")
        } catch {
            Issue.record("Failed to inspect button: \(error)")
        }
        
        cleanupTestEnvironment()
    }
    
    @Test func testLabelTextSanitizationHandlesCase() {
        setupTestEnvironment()
        
        let button = AdaptiveButton("CamelCaseLabel", action: { })
            .enableGlobalAutomaticAccessibilityIdentifiers()
        
        do {
            let inspected = try button.inspect()
            let buttonID = try inspected.accessibilityIdentifier()
            
            // TDD RED: Should FAIL - should be lowercase
            #expect(!buttonID.contains("CamelCaseLabel"), 
                   "Identifier should not contain mixed case label")
            #expect(buttonID.contains("camelcaselabel") || buttonID.contains("camel"), 
                   "Identifier should contain lowercase version")
            
            print("🔴 RED: Case sanitized ID: '\(buttonID)'")
        } catch {
            Issue.record("Failed to inspect button: \(error)")
        }
        
        cleanupTestEnvironment()
    }
}

