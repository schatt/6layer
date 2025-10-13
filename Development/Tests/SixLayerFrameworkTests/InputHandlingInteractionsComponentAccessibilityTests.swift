//
//  InputHandlingInteractionsComponentAccessibilityTests.swift
//  SixLayerFrameworkTests
//
//  Comprehensive accessibility tests for ALL InputHandlingInteractions components
//

import XCTest
import SwiftUI
@testable import SixLayerFramework

@MainActor
final class InputHandlingInteractionsComponentAccessibilityTests: XCTestCase {
    
    // MARK: - PlatformInteractionButton Tests
    
    func testPlatformInteractionButtonGeneratesAccessibilityIdentifiers() async {
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
        
        XCTAssertTrue(hasAccessibilityID, "PlatformInteractionButton should generate accessibility identifiers")
    }
    
    // MARK: - InputHandlingManager Tests
    
    func testInputHandlingManagerGeneratesAccessibilityIdentifiers() async {
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
        
        XCTAssertTrue(hasAccessibilityID, "InputHandlingManager should generate accessibility identifiers")
    }
    
    // MARK: - KeyboardShortcutManager Tests
    
    func testKeyboardShortcutManagerGeneratesAccessibilityIdentifiers() async {
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
        
        XCTAssertTrue(hasAccessibilityID, "KeyboardShortcutManager should generate accessibility identifiers")
    }
    
    // MARK: - HapticFeedbackManager Tests
    
    func testHapticFeedbackManagerGeneratesAccessibilityIdentifiers() async {
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
        
        XCTAssertTrue(hasAccessibilityID, "HapticFeedbackManager should generate accessibility identifiers")
    }
    
    // MARK: - DragDropManager Tests
    
    func testDragDropManagerGeneratesAccessibilityIdentifiers() async {
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
        
        XCTAssertTrue(hasAccessibilityID, "DragDropManager should generate accessibility identifiers")
    }
}
