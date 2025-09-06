import XCTest
import SwiftUI
@testable import SixLayerFramework

/// Tests for AssistiveTouch accessibility features
final class AssistiveTouchTests: XCTestCase {
    
    // MARK: - AssistiveTouch Manager Tests
    
    func testAssistiveTouchManagerInitialization() {
        // Given: AssistiveTouch configuration
        let config = AssistiveTouchConfig(
            enableIntegration: true,
            enableCustomActions: true,
            enableMenuSupport: true,
            enableGestureRecognition: true
        )
        
        // When: Creating AssistiveTouch Manager
        let manager = AssistiveTouchManager(config: config)
        
        // Then: Manager should be properly initialized
        XCTAssertTrue(manager.isIntegrationEnabled)
        XCTAssertTrue(manager.areCustomActionsEnabled)
        XCTAssertTrue(manager.isMenuSupportEnabled)
        XCTAssertTrue(manager.isGestureRecognitionEnabled)
    }
    
    func testAssistiveTouchIntegrationSupport() {
        // Given: AssistiveTouch Manager with integration enabled
        let config = AssistiveTouchConfig(enableIntegration: true)
        let manager = AssistiveTouchManager(config: config)
        
        // When: Checking integration support
        let isSupported = manager.supportsIntegration()
        
        // Then: Integration should be supported
        XCTAssertTrue(isSupported)
    }
    
    func testAssistiveTouchCustomActions() {
        // Given: AssistiveTouch Manager with custom actions enabled
        let config = AssistiveTouchConfig(enableCustomActions: true)
        let manager = AssistiveTouchManager(config: config)
        
        // When: Adding custom actions
        let action1 = AssistiveTouchAction(
            name: "Select Item",
            gesture: .singleTap,
            action: { print("Item selected") }
        )
        let action2 = AssistiveTouchAction(
            name: "Next Item",
            gesture: .swipeRight,
            action: { print("Next item") }
        )
        
        manager.addCustomAction(action1)
        manager.addCustomAction(action2)
        
        // Then: Actions should be registered
        XCTAssertEqual(manager.customActions.count, 2)
        XCTAssertTrue(manager.hasAction(named: "Select Item"))
        XCTAssertTrue(manager.hasAction(named: "Next Item"))
    }
    
    func testAssistiveTouchMenuSupport() {
        // Given: AssistiveTouch Manager with menu support
        let config = AssistiveTouchConfig(enableMenuSupport: true)
        let manager = AssistiveTouchManager(config: config)
        
        // When: Managing menu
        let menuResult = manager.manageMenu(for: .show)
        
        // Then: Menu should be managed appropriately
        XCTAssertTrue(menuResult.success)
        XCTAssertNotNil(menuResult.menuElement)
    }
    
    func testAssistiveTouchGestureRecognition() {
        // Given: AssistiveTouch Manager with gesture recognition
        let config = AssistiveTouchConfig(enableGestureRecognition: true)
        let manager = AssistiveTouchManager(config: config)
        
        // When: Processing gestures
        let gesture = AssistiveTouchGesture(type: .swipeLeft, intensity: .medium)
        let result = manager.processGesture(gesture)
        
        // Then: Gesture should be processed
        XCTAssertTrue(result.success)
        XCTAssertNotNil(result.action)
    }
    
    // MARK: - AssistiveTouch Configuration Tests
    
    func testAssistiveTouchConfiguration() {
        // Given: AssistiveTouch configuration
        let config = AssistiveTouchConfig(
            enableIntegration: true,
            enableCustomActions: true,
            enableMenuSupport: true,
            enableGestureRecognition: true,
            gestureSensitivity: .high,
            menuStyle: .floating
        )
        
        // Then: Configuration should be properly set
        XCTAssertTrue(config.enableIntegration)
        XCTAssertTrue(config.enableCustomActions)
        XCTAssertTrue(config.enableMenuSupport)
        XCTAssertTrue(config.enableGestureRecognition)
        XCTAssertEqual(config.gestureSensitivity, .high)
        XCTAssertEqual(config.menuStyle, .floating)
    }
    
    // MARK: - AssistiveTouch Actions Tests
    
    func testAssistiveTouchActionCreation() {
        // Given: AssistiveTouch action parameters
        let action = AssistiveTouchAction(
            name: "Test Action",
            gesture: .doubleTap,
            action: { print("Test action executed") }
        )
        
        // Then: Action should be properly created
        XCTAssertEqual(action.name, "Test Action")
        XCTAssertEqual(action.gesture, .doubleTap)
        XCTAssertNotNil(action.action)
    }
    
    func testAssistiveTouchGestureTypes() {
        // Given: Different gesture types
        let singleTap = AssistiveTouchGesture(type: .singleTap, intensity: .light)
        let doubleTap = AssistiveTouchGesture(type: .doubleTap, intensity: .medium)
        let swipeLeft = AssistiveTouchGesture(type: .swipeLeft, intensity: .heavy)
        let swipeRight = AssistiveTouchGesture(type: .swipeRight, intensity: .light)
        
        // Then: Gestures should have correct types
        XCTAssertEqual(singleTap.type, .singleTap)
        XCTAssertEqual(doubleTap.type, .doubleTap)
        XCTAssertEqual(swipeLeft.type, .swipeLeft)
        XCTAssertEqual(swipeRight.type, .swipeRight)
    }
    
    // MARK: - AssistiveTouch Menu Management Tests
    
    func testAssistiveTouchMenuAction() {
        // Given: Different menu actions
        let showMenu = AssistiveTouchMenuAction.show
        let hideMenu = AssistiveTouchMenuAction.hide
        let toggleMenu = AssistiveTouchMenuAction.toggle
        
        // Then: Actions should be properly defined
        XCTAssertEqual(showMenu, .show)
        XCTAssertEqual(hideMenu, .hide)
        XCTAssertEqual(toggleMenu, .toggle)
    }
    
    func testAssistiveTouchMenuStyle() {
        // Given: Different menu styles
        let floating = AssistiveTouchMenuStyle.floating
        let docked = AssistiveTouchMenuStyle.docked
        let contextual = AssistiveTouchMenuStyle.contextual
        
        // Then: Styles should be properly defined
        XCTAssertEqual(floating, .floating)
        XCTAssertEqual(docked, .docked)
        XCTAssertEqual(contextual, .contextual)
    }
    
    // MARK: - AssistiveTouch View Modifier Tests
    
    func testAssistiveTouchViewModifier() {
        // Given: A view with AssistiveTouch support
        let view = Text("Test")
            .assistiveTouchEnabled()
        
        // Then: View should support AssistiveTouch
        XCTAssertNotNil(view)
    }
    
    func testAssistiveTouchViewModifierWithConfiguration() {
        // Given: A view with AssistiveTouch configuration
        let config = AssistiveTouchConfig(enableIntegration: true)
        let view = Text("Test")
            .assistiveTouchEnabled(config: config)
        
        // Then: View should support AssistiveTouch with configuration
        XCTAssertNotNil(view)
    }
    
    // MARK: - AssistiveTouch Compliance Tests
    
    func testAssistiveTouchCompliance() {
        // Given: A view with AssistiveTouch support
        let view = VStack {
            Text("Title")
            Button("Action") { }
        }
        .assistiveTouchEnabled()
        
        // When: Checking AssistiveTouch compliance
        let compliance = AssistiveTouchManager.checkCompliance(for: view)
        
        // Then: View should be compliant
        XCTAssertTrue(compliance.isCompliant)
        XCTAssertEqual(compliance.issues.count, 0)
    }
    
    func testAssistiveTouchComplianceWithIssues() {
        // Given: A view without proper AssistiveTouch support
        let view = Text("No AssistiveTouch support")
        
        // When: Checking AssistiveTouch compliance
        let compliance = AssistiveTouchManager.checkCompliance(for: view)
        
        // Then: View should have compliance issues
        XCTAssertFalse(compliance.isCompliant)
        XCTAssertGreaterThan(compliance.issues.count, 0)
    }
    
    // MARK: - AssistiveTouch Performance Tests
    
    func testAssistiveTouchPerformance() {
        // Given: AssistiveTouch Manager
        let config = AssistiveTouchConfig(enableIntegration: true)
        let manager = AssistiveTouchManager(config: config)
        
        // When: Measuring performance
        measure {
            for _ in 0..<1000 {
                let gesture = AssistiveTouchGesture(type: .singleTap, intensity: .light)
                _ = manager.processGesture(gesture)
            }
        }
    }
}
