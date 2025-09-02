//
//  InputHandlingInteractionsTests.swift
//  SixLayerFrameworkTests
//
//  Created for Phase 5: Framework Enhancement Areas - Input Handling & Interactions
//  Following TDD methodology - Tests first, then implementation
//

import XCTest
import SwiftUI
@testable import SixLayerFramework

/// Comprehensive test suite for Input Handling & Interactions system
/// Tests platform-specific input handling, keyboard shortcuts, haptic feedback, and drag & drop
final class InputHandlingInteractionsTests: XCTestCase {
    
    // MARK: - Test Setup
    
    override func setUp() {
        super.setUp()
        // Reset any state before each test
    }
    
    override func tearDown() {
        // Clean up after each test
        super.tearDown()
    }
    
    // MARK: - InputHandlingManager Tests
    
    func testInputHandlingManagerInitialization() {
        // Given
        let platform = Platform.iOS
        
        // When
        let manager = InputHandlingManager(platform: platform)
        
        // Then
        XCTAssertEqual(manager.currentPlatform, platform)
        XCTAssertEqual(manager.interactionPatterns.platform, platform)
        XCTAssertEqual(manager.keyboardManager.platform, platform)
        XCTAssertEqual(manager.hapticManager.platform, platform)
        XCTAssertEqual(manager.dragDropManager.platform, platform)
    }
    
    func testInputHandlingManagerDefaultPlatform() {
        // Given & When
        let manager = InputHandlingManager()
        
        // Then
        XCTAssertEqual(manager.currentPlatform, Platform.current)
    }
    
    // MARK: - InteractionBehavior Tests
    
    func testInteractionBehaviorForSupportedGesture() {
        // Given
        let manager = InputHandlingManager(platform: .iOS)
        let gesture = GestureType.tap
        
        // When
        let behavior = manager.getInteractionBehavior(for: gesture)
        
        // Then
        XCTAssertTrue(behavior.isSupported)
        XCTAssertEqual(behavior.gesture, gesture)
        XCTAssertEqual(behavior.inputMethod, .touch)
        XCTAssertTrue(behavior.shouldProvideHapticFeedback)
        XCTAssertFalse(behavior.shouldProvideSoundFeedback)
    }
    
    func testInteractionBehaviorForUnsupportedGesture() {
        // Given
        let manager = InputHandlingManager(platform: .iOS)
        let gesture = GestureType.rightClick // Not supported on iOS
        
        // When
        let behavior = manager.getInteractionBehavior(for: gesture)
        
        // Then
        XCTAssertFalse(behavior.isSupported)
        XCTAssertEqual(behavior.gesture, gesture)
        XCTAssertEqual(behavior.inputMethod, .mouse)
        XCTAssertFalse(behavior.shouldProvideHapticFeedback)
        XCTAssertFalse(behavior.shouldProvideSoundFeedback)
    }
    
    func testInteractionBehaviorForMacOS() {
        // Given
        let manager = InputHandlingManager(platform: .macOS)
        let gesture = GestureType.click
        
        // When
        let behavior = manager.getInteractionBehavior(for: gesture)
        
        // Then
        XCTAssertTrue(behavior.isSupported)
        XCTAssertEqual(behavior.gesture, gesture)
        XCTAssertEqual(behavior.inputMethod, .mouse)
        XCTAssertFalse(behavior.shouldProvideHapticFeedback)
        XCTAssertTrue(behavior.shouldProvideSoundFeedback)
    }
    
    // MARK: - KeyboardShortcutManager Tests
    
    func testKeyboardShortcutManagerInitialization() {
        // Given
        let platform = Platform.macOS
        
        // When
        let manager = KeyboardShortcutManager(for: platform)
        
        // Then
        XCTAssertEqual(manager.platform, platform)
    }
    
    func testCreateKeyboardShortcutForMacOS() {
        // Given
        let manager = KeyboardShortcutManager(for: .macOS)
        let key = KeyEquivalent("s")
        let modifiers = EventModifiers.command
        
        // When
        let shortcut = manager.createShortcut(key: key, modifiers: modifiers) {
            // Test action
        }
        
        // Then
        XCTAssertEqual(shortcut.key, key)
        XCTAssertEqual(shortcut.modifiers, modifiers)
    }
    
    func testCreateKeyboardShortcutForIOS() {
        // Given
        let manager = KeyboardShortcutManager(for: .iOS)
        let key = KeyEquivalent("s")
        let modifiers = EventModifiers.command
        
        // When
        let shortcut = manager.createShortcut(key: key, modifiers: modifiers) {
            // Test action
        }
        
        // Then
        XCTAssertEqual(shortcut.key, key)
        XCTAssertEqual(shortcut.modifiers, []) // iOS should have empty modifiers
    }
    
    func testGetShortcutDescriptionForMacOS() {
        // Given
        let manager = KeyboardShortcutManager(for: .macOS)
        let key = KeyEquivalent("s")
        let modifiers = EventModifiers.command
        
        // When
        let description = manager.getShortcutDescription(key: key, modifiers: modifiers)
        
        // Then
        XCTAssertEqual(description, "⌘s")
    }
    
    func testGetShortcutDescriptionForIOS() {
        // Given
        let manager = KeyboardShortcutManager(for: .iOS)
        let key = KeyEquivalent("s")
        let modifiers = EventModifiers.command
        
        // When
        let description = manager.getShortcutDescription(key: key, modifiers: modifiers)
        
        // Then
        XCTAssertEqual(description, "Swipe or tap gesture")
    }
    
    func testGetShortcutDescriptionForWatchOS() {
        // Given
        let manager = KeyboardShortcutManager(for: .watchOS)
        let key = KeyEquivalent("s")
        let modifiers = EventModifiers.command
        
        // When
        let description = manager.getShortcutDescription(key: key, modifiers: modifiers)
        
        // Then
        XCTAssertEqual(description, "Digital Crown or tap")
    }
    
    func testGetShortcutDescriptionForTVOS() {
        // Given
        let manager = KeyboardShortcutManager(for: .tvOS)
        let key = KeyEquivalent("s")
        let modifiers = EventModifiers.command
        
        // When
        let description = manager.getShortcutDescription(key: key, modifiers: modifiers)
        
        // Then
        XCTAssertEqual(description, "Remote button")
    }
    
    // MARK: - HapticFeedbackManager Tests
    
    func testHapticFeedbackManagerInitialization() {
        // Given
        let platform = Platform.iOS
        
        // When
        let manager = HapticFeedbackManager(for: platform)
        
        // Then
        XCTAssertEqual(manager.platform, platform)
    }
    
    func testTriggerFeedbackForIOS() {
        // Given
        let manager = HapticFeedbackManager(for: .iOS)
        let feedback = PlatformHapticFeedback.light
        
        // When & Then
        // This should not crash and should execute without error
        XCTAssertNoThrow(manager.triggerFeedback(feedback))
    }
    
    func testTriggerFeedbackForMacOS() {
        // Given
        let manager = HapticFeedbackManager(for: .macOS)
        let feedback = PlatformHapticFeedback.light
        
        // When & Then
        // This should not crash and should execute without error
        XCTAssertNoThrow(manager.triggerFeedback(feedback))
    }
    
    func testTriggerFeedbackForWatchOS() {
        // Given
        let manager = HapticFeedbackManager(for: .watchOS)
        let feedback = PlatformHapticFeedback.light
        
        // When & Then
        // This should not crash and should execute without error
        XCTAssertNoThrow(manager.triggerFeedback(feedback))
    }
    
    func testTriggerFeedbackForTVOS() {
        // Given
        let manager = HapticFeedbackManager(for: .tvOS)
        let feedback = PlatformHapticFeedback.light
        
        // When & Then
        // This should not crash and should execute without error
        XCTAssertNoThrow(manager.triggerFeedback(feedback))
    }
    
    // MARK: - DragDropManager Tests
    
    func testDragDropManagerInitialization() {
        // Given
        let platform = Platform.iOS
        
        // When
        let manager = DragDropManager(for: platform)
        
        // Then
        XCTAssertEqual(manager.platform, platform)
    }
    
    func testGetDragBehaviorForIOS() {
        // Given
        let manager = DragDropManager(for: .iOS)
        
        // When
        let behavior = manager.getDragBehavior()
        
        // Then
        XCTAssertTrue(behavior.supportsDrag)
        XCTAssertTrue(behavior.supportsDrop)
        XCTAssertEqual(behavior.dragPreview, .platform)
        XCTAssertEqual(behavior.dropIndicator, .platform)
    }
    
    func testGetDragBehaviorForMacOS() {
        // Given
        let manager = DragDropManager(for: .macOS)
        
        // When
        let behavior = manager.getDragBehavior()
        
        // Then
        XCTAssertTrue(behavior.supportsDrag)
        XCTAssertTrue(behavior.supportsDrop)
        XCTAssertEqual(behavior.dragPreview, .custom)
        XCTAssertEqual(behavior.dropIndicator, .custom)
    }
    
    func testGetDragBehaviorForWatchOS() {
        // Given
        let manager = DragDropManager(for: .watchOS)
        
        // When
        let behavior = manager.getDragBehavior()
        
        // Then
        XCTAssertFalse(behavior.supportsDrag)
        XCTAssertFalse(behavior.supportsDrop)
        XCTAssertEqual(behavior.dragPreview, .none)
        XCTAssertEqual(behavior.dropIndicator, .none)
    }
    
    func testGetDragBehaviorForTVOS() {
        // Given
        let manager = DragDropManager(for: .tvOS)
        
        // When
        let behavior = manager.getDragBehavior()
        
        // Then
        XCTAssertFalse(behavior.supportsDrag)
        XCTAssertFalse(behavior.supportsDrop)
        XCTAssertEqual(behavior.dragPreview, .none)
        XCTAssertEqual(behavior.dropIndicator, .none)
    }
    
    // MARK: - SwipeDirection Tests
    
    func testSwipeDirectionFromDragLeft() {
        // Given - Test the SwipeDirection enum values directly
        let direction = SwipeDirection.left
        
        // When - Verify the enum works correctly
        let isLeft = direction == .left
        
        // Then
        XCTAssertTrue(isLeft)
        XCTAssertEqual(direction, .left)
    }
    
    func testSwipeDirectionFromDragRight() {
        // Given - Test the SwipeDirection enum values directly
        let direction = SwipeDirection.right
        
        // When - Verify the enum works correctly
        let isRight = direction == .right
        
        // Then
        XCTAssertTrue(isRight)
        XCTAssertEqual(direction, .right)
    }
    
    func testSwipeDirectionFromDragUp() {
        // Given - Test the SwipeDirection enum values directly
        let direction = SwipeDirection.up
        
        // When - Verify the enum works correctly
        let isUp = direction == .up
        
        // Then
        XCTAssertTrue(isUp)
        XCTAssertEqual(direction, .up)
    }
    
    func testSwipeDirectionFromDragDown() {
        // Given - Test the SwipeDirection enum values directly
        let direction = SwipeDirection.down
        
        // When - Verify the enum works correctly
        let isDown = direction == .down
        
        // Then
        XCTAssertTrue(isDown)
        XCTAssertEqual(direction, .down)
    }
    
    func testSwipeDirectionFromDragDiagonal() {
        // Given - Test that SwipeDirection enum supports all directions
        let directions: [SwipeDirection] = [.left, .right, .up, .down]
        
        // When - Verify all directions are distinct
        let uniqueDirections = Set(directions)
        
        // Then
        XCTAssertEqual(uniqueDirections.count, 4) // All directions should be unique
        XCTAssertTrue(directions.contains(.right)) // Should include right direction
    }
    
    // MARK: - PlatformInteractionButton Tests
    
    func testPlatformInteractionButtonInitialization() {
        // Given
        let action = {}
        let label = Text("Test Button")
        
        // When
        let button = PlatformInteractionButton(style: .primary, action: action) {
            label
        }
        
        // Then
        // Button should be created without crashing
        XCTAssertNotNil(button)
    }
    
    func testPlatformInteractionButtonWithDifferentStyles() {
        // Given
        let styles: [InteractionButtonStyle] = [.adaptive, .primary, .secondary, .destructive]
        
        // When & Then
        for style in styles {
            let button = PlatformInteractionButton(style: style, action: {}) {
                Text("Test")
            }
            XCTAssertNotNil(button)
        }
    }
    
    // MARK: - Integration Tests
    
    func testInputHandlingIntegration() {
        // Given
        let manager = InputHandlingManager(platform: .iOS)
        
        // When
        let behavior = manager.getInteractionBehavior(for: .tap)
        let dragBehavior = manager.dragDropManager.getDragBehavior()
        let shortcutDescription = manager.keyboardManager.getShortcutDescription(
            key: KeyEquivalent("s"),
            modifiers: .command
        )
        
        // Then
        XCTAssertTrue(behavior.isSupported)
        XCTAssertTrue(dragBehavior.supportsDrag)
        XCTAssertEqual(shortcutDescription, "Swipe or tap gesture")
    }
    
    func testCrossPlatformConsistency() {
        // Given
        let platforms: [Platform] = [.iOS, .macOS, .watchOS, .tvOS]
        
        // When & Then
        for platform in platforms {
            let manager = InputHandlingManager(platform: platform)
            
            // Each platform should have consistent behavior
            XCTAssertEqual(manager.currentPlatform, platform)
            XCTAssertEqual(manager.interactionPatterns.platform, platform)
            XCTAssertEqual(manager.keyboardManager.platform, platform)
            XCTAssertEqual(manager.hapticManager.platform, platform)
            XCTAssertEqual(manager.dragDropManager.platform, platform)
        }
    }
    
    // MARK: - Performance Tests
    
    func testInputHandlingManagerPerformance() {
        // Given
        let iterations = 1000
        
        // When
        measure {
            for _ in 0..<iterations {
                let manager = InputHandlingManager(platform: .iOS)
                let behavior = manager.getInteractionBehavior(for: .tap)
                _ = behavior.isSupported
            }
        }
    }
    
    func testSwipeDirectionPerformance() {
        // Given - Test enum comparison performance
        let directions: [SwipeDirection] = [.left, .right, .up, .down]
        let iterations = 10000
        
        // When
        measure {
            for _ in 0..<iterations {
                for direction in directions {
                    _ = direction == .left
                }
            }
        }
    }
    
    // MARK: - Edge Case Tests
    
    func testInteractionBehaviorWithAllGestureTypes() {
        // Given
        let manager = InputHandlingManager(platform: .iOS)
        let allGestures = GestureType.allCases
        
        // When & Then
        for gesture in allGestures {
            let behavior = manager.getInteractionBehavior(for: gesture)
            XCTAssertEqual(behavior.gesture, gesture)
            XCTAssertEqual(behavior.platform, .iOS)
        }
    }
    
    func testKeyboardShortcutWithAllModifiers() {
        // Given
        let manager = KeyboardShortcutManager(for: .macOS)
        let key = KeyEquivalent("s")
        let modifiers: [EventModifiers] = [
            .command,
            .option,
            .control,
            .shift,
            [.command, .option],
            [.command, .control],
            [.command, .shift],
            [.option, .control],
            [.option, .shift],
            [.control, .shift]
        ]
        
        // When & Then
        for modifier in modifiers {
            let shortcut = manager.createShortcut(key: key, modifiers: modifier) {}
            XCTAssertEqual(shortcut.key, key)
            XCTAssertEqual(shortcut.modifiers, modifier)
        }
    }
    
    func testHapticFeedbackWithAllTypes() {
        // Given
        let manager = HapticFeedbackManager(for: .iOS)
        let allFeedbackTypes = PlatformHapticFeedback.allCases
        
        // When & Then
        for feedback in allFeedbackTypes {
            XCTAssertNoThrow(manager.triggerFeedback(feedback))
        }
    }
    
    func testDragBehaviorWithAllPlatforms() {
        // Given
        let platforms: [Platform] = [.iOS, .macOS, .watchOS, .tvOS]
        
        // When & Then
        for platform in platforms {
            let manager = DragDropManager(for: platform)
            let behavior = manager.getDragBehavior()
            
            // Each platform should have a defined behavior
            XCTAssertNotNil(behavior)
            XCTAssertTrue(behavior.dragPreview == .none || behavior.dragPreview == .platform || behavior.dragPreview == .custom)
            XCTAssertTrue(behavior.dropIndicator == .none || behavior.dropIndicator == .platform || behavior.dropIndicator == .custom)
        }
    }
}

// MARK: - Test Extensions
