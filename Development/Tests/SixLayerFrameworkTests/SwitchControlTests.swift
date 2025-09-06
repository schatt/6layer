import XCTest
import SwiftUI
@testable import SixLayerFramework

/// Tests for Switch Control accessibility features
final class SwitchControlTests: XCTestCase {
    
    // MARK: - Switch Control Manager Tests
    
    func testSwitchControlManagerInitialization() {
        // Given: Switch Control configuration
        let config = SwitchControlConfig(
            enableNavigation: true,
            enableCustomActions: true,
            enableGestureSupport: true,
            focusManagement: .automatic
        )
        
        // When: Creating Switch Control Manager
        let manager = SwitchControlManager(config: config)
        
        // Then: Manager should be properly initialized
        XCTAssertTrue(manager.isNavigationEnabled)
        XCTAssertTrue(manager.areCustomActionsEnabled)
        XCTAssertTrue(manager.isGestureSupportEnabled)
        XCTAssertEqual(manager.focusManagement, .automatic)
    }
    
    func testSwitchControlNavigationSupport() {
        // Given: Switch Control Manager with navigation enabled
        let config = SwitchControlConfig(enableNavigation: true)
        let manager = SwitchControlManager(config: config)
        
        // When: Checking navigation support
        let isSupported = manager.supportsNavigation()
        
        // Then: Navigation should be supported
        XCTAssertTrue(isSupported)
    }
    
    func testSwitchControlCustomActions() {
        // Given: Switch Control Manager with custom actions enabled
        let config = SwitchControlConfig(enableCustomActions: true)
        let manager = SwitchControlManager(config: config)
        
        // When: Adding custom actions
        let action1 = SwitchControlAction(
            name: "Select Item",
            gesture: .singleTap,
            action: { print("Item selected") }
        )
        let action2 = SwitchControlAction(
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
    
    func testSwitchControlFocusManagement() {
        // Given: Switch Control Manager with focus management
        let config = SwitchControlConfig(focusManagement: .automatic)
        let manager = SwitchControlManager(config: config)
        
        // When: Managing focus
        let focusResult = manager.manageFocus(for: .next)
        
        // Then: Focus should be managed appropriately
        XCTAssertTrue(focusResult.success)
        XCTAssertNotNil(focusResult.focusedElement)
    }
    
    func testSwitchControlGestureSupport() {
        // Given: Switch Control Manager with gesture support
        let config = SwitchControlConfig(enableGestureSupport: true)
        let manager = SwitchControlManager(config: config)
        
        // When: Processing gestures
        let gesture = SwitchControlGesture(type: .swipeLeft, intensity: .medium)
        let result = manager.processGesture(gesture)
        
        // Then: Gesture should be processed
        XCTAssertTrue(result.success)
        XCTAssertNotNil(result.action)
    }
    
    // MARK: - Switch Control Configuration Tests
    
    func testSwitchControlConfiguration() {
        // Given: Switch Control configuration
        let config = SwitchControlConfig(
            enableNavigation: true,
            enableCustomActions: true,
            enableGestureSupport: true,
            focusManagement: .manual,
            gestureSensitivity: .high,
            navigationSpeed: .fast
        )
        
        // Then: Configuration should be properly set
        XCTAssertTrue(config.enableNavigation)
        XCTAssertTrue(config.enableCustomActions)
        XCTAssertTrue(config.enableGestureSupport)
        XCTAssertEqual(config.focusManagement, .manual)
        XCTAssertEqual(config.gestureSensitivity, .high)
        XCTAssertEqual(config.navigationSpeed, .fast)
    }
    
    // MARK: - Switch Control Actions Tests
    
    func testSwitchControlActionCreation() {
        // Given: Switch Control action parameters
        let action = SwitchControlAction(
            name: "Test Action",
            gesture: .doubleTap,
            action: { print("Test action executed") }
        )
        
        // Then: Action should be properly created
        XCTAssertEqual(action.name, "Test Action")
        XCTAssertEqual(action.gesture, .doubleTap)
        XCTAssertNotNil(action.action)
    }
    
    func testSwitchControlGestureTypes() {
        // Given: Different gesture types
        let singleTap = SwitchControlGesture(type: .singleTap, intensity: .light)
        let doubleTap = SwitchControlGesture(type: .doubleTap, intensity: .medium)
        let swipeLeft = SwitchControlGesture(type: .swipeLeft, intensity: .heavy)
        let swipeRight = SwitchControlGesture(type: .swipeRight, intensity: .light)
        
        // Then: Gestures should have correct types
        XCTAssertEqual(singleTap.type, .singleTap)
        XCTAssertEqual(doubleTap.type, .doubleTap)
        XCTAssertEqual(swipeLeft.type, .swipeLeft)
        XCTAssertEqual(swipeRight.type, .swipeRight)
    }
    
    // MARK: - Switch Control Focus Management Tests
    
    func testSwitchControlFocusDirection() {
        // Given: Different focus directions
        let nextFocus = SwitchControlFocusDirection.next
        let previousFocus = SwitchControlFocusDirection.previous
        let firstFocus = SwitchControlFocusDirection.first
        let lastFocus = SwitchControlFocusDirection.last
        
        // Then: Directions should be properly defined
        XCTAssertEqual(nextFocus, .next)
        XCTAssertEqual(previousFocus, .previous)
        XCTAssertEqual(firstFocus, .first)
        XCTAssertEqual(lastFocus, .last)
    }
    
    func testSwitchControlFocusManagementMode() {
        // Given: Different focus management modes
        let automatic = SwitchControlFocusManagement.automatic
        let manual = SwitchControlFocusManagement.manual
        let hybrid = SwitchControlFocusManagement.hybrid
        
        // Then: Modes should be properly defined
        XCTAssertEqual(automatic, .automatic)
        XCTAssertEqual(manual, .manual)
        XCTAssertEqual(hybrid, .hybrid)
    }
    
    // MARK: - Switch Control View Modifier Tests
    
    func testSwitchControlViewModifier() {
        // Given: A view with Switch Control support
        let view = Text("Test")
            .switchControlEnabled()
        
        // Then: View should support Switch Control
        XCTAssertNotNil(view)
    }
    
    func testSwitchControlViewModifierWithConfiguration() {
        // Given: A view with Switch Control configuration
        let config = SwitchControlConfig(enableNavigation: true)
        let view = Text("Test")
            .switchControlEnabled(config: config)
        
        // Then: View should support Switch Control with configuration
        XCTAssertNotNil(view)
    }
    
    // MARK: - Switch Control Compliance Tests
    
    func testSwitchControlCompliance() {
        // Given: A view with Switch Control support
        let view = VStack {
            Text("Title")
            Button("Action") { }
        }
        .switchControlEnabled()
        
        // When: Checking Switch Control compliance
        let compliance = SwitchControlManager.checkCompliance(for: view)
        
        // Then: View should be compliant
        XCTAssertTrue(compliance.isCompliant)
        XCTAssertEqual(compliance.issues.count, 0)
    }
    
    func testSwitchControlComplianceWithIssues() {
        // Given: A view without proper Switch Control support
        let view = Text("No Switch Control support")
        
        // When: Checking Switch Control compliance
        let compliance = SwitchControlManager.checkCompliance(for: view)
        
        // Then: View should have compliance issues
        XCTAssertFalse(compliance.isCompliant)
        XCTAssertGreaterThan(compliance.issues.count, 0)
    }
    
    // MARK: - Switch Control Performance Tests
    
    func testSwitchControlPerformance() {
        // Given: Switch Control Manager
        let config = SwitchControlConfig(enableNavigation: true)
        let manager = SwitchControlManager(config: config)
        
        // When: Measuring performance
        measure {
            for i in 0..<1000 {
                let gesture = SwitchControlGesture(type: .singleTap, intensity: .light)
                _ = manager.processGesture(gesture)
            }
        }
    }
}
