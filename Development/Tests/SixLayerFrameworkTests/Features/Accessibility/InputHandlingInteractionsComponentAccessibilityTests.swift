import Testing


//
//  InputHandlingInteractionsComponentAccessibilityTests.swift
//  SixLayerFrameworkTests
//
//  Comprehensive accessibility tests for ALL InputHandlingInteractions components
//

import SwiftUI
@testable import SixLayerFramework

@MainActor
class InputHandlingInteractionsComponentAccessibilityTests: BaseTestClass {
    
    // MARK: - PlatformInteractionButton Tests
    
    @Test func testPlatformInteractionButtonGeneratesAccessibilityIdentifiers() async {
        // Given: Test label
        let testLabel = VStack {
            Text("Platform Interaction Button")
            Image(systemName: "button")
        }
        
        // When: Creating PlatformInteractionButton
        let view = PlatformInteractionButton(label: testLabel) {
            // Button action
        }
        
        // Then: Should generate accessibility identifiers
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view,
            expectedPattern: "*.main.element.*",
            componentName: "PlatformInteractionButton"
        )
        
        #expect(hasAccessibilityID, "PlatformInteractionButton should generate accessibility identifiers")
    }
    
    // MARK: - InputHandlingManager Tests
    
    @Test func testInputHandlingManagerGeneratesAccessibilityIdentifiers() async {
        // Given: InputHandlingManager
        let manager = InputHandlingManager()
        
        // When: Creating a view with InputHandlingManager
        let view = VStack {
            Text("Input Handling Manager Content")
        }
        .environmentObject(manager)
        
        // Then: Should generate accessibility identifiers
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view,
            expectedPattern: "*.main.element.*",
            componentName: "InputHandlingManager"
        )
        
        #expect(hasAccessibilityID, "InputHandlingManager should generate accessibility identifiers")
    }
    
    // MARK: - KeyboardShortcutManager Tests
    
    @Test func testKeyboardShortcutManagerGeneratesAccessibilityIdentifiers() async {
        // Given: KeyboardShortcutManager
        let manager = KeyboardShortcutManager()
        
        // When: Creating a view with KeyboardShortcutManager
        let view = VStack {
            Text("Keyboard Shortcut Manager Content")
        }
        .environmentObject(manager)
        
        // Then: Should generate accessibility identifiers
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view,
            expectedPattern: "*.main.element.*",
            componentName: "KeyboardShortcutManager"
        )
        
        #expect(hasAccessibilityID, "KeyboardShortcutManager should generate accessibility identifiers")
    }
    
    // MARK: - HapticFeedbackManager Tests
    
    @Test func testHapticFeedbackManagerGeneratesAccessibilityIdentifiers() async {
        // Given: HapticFeedbackManager
        let manager = HapticFeedbackManager()
        
        // When: Creating a view with HapticFeedbackManager
        let view = VStack {
            Text("Haptic Feedback Manager Content")
        }
        .environmentObject(manager)
        
        // Then: Should generate accessibility identifiers
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view,
            expectedPattern: "*.main.element.*",
            componentName: "HapticFeedbackManager"
        )
        
        #expect(hasAccessibilityID, "HapticFeedbackManager should generate accessibility identifiers")
    }
    
    // MARK: - DragDropManager Tests
    
    @Test func testDragDropManagerGeneratesAccessibilityIdentifiers() async {
        // Given: DragDropManager
        let manager = DragDropManager()
        
        // When: Creating a view with DragDropManager
        let view = VStack {
            Text("Drag Drop Manager Content")
        }
        .environmentObject(manager)
        
        // Then: Should generate accessibility identifiers
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view,
            expectedPattern: "*.main.element.*",
            componentName: "DragDropManager"
        )
        
        #expect(hasAccessibilityID, "DragDropManager should generate accessibility identifiers")
    }
}


