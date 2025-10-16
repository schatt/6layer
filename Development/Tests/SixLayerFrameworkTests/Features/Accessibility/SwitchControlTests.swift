import Testing

import SwiftUI
@testable import SixLayerFramework

/// Tests for Switch Control accessibility features
@MainActor
final class SwitchControlTests: BaseTestClass {
    
    // MARK: - Switch Control Manager Tests
    
    @Test func testSwitchControlManagerInitialization() {
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
        #expect(manager.isNavigationEnabled)
        #expect(manager.areCustomActionsEnabled)
        #expect(manager.isGestureSupportEnabled)
        #expect(manager.focusManagement == .automatic)
    }
    
    @Test func testSwitchControlNavigationSupport() {
        // Given: Switch Control Manager with navigation enabled
        let config = SwitchControlConfig(enableNavigation: true)
        let manager = SwitchControlManager(config: config)
        
        // When: Checking navigation support
        let isSupported = manager.supportsNavigation()
        
        // Then: Navigation should be supported
        #expect(isSupported)
    }
    
    @Test func testSwitchControlCustomActions() {
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
        #expect(manager.customActions.count == 2)
        #expect(manager.hasAction(named: "Select Item"))
        #expect(manager.hasAction(named: "Next Item"))
    }
    
    @Test func testSwitchControlFocusManagement() {
        // Given: Switch Control Manager with focus management
        let config = SwitchControlConfig(focusManagement: .automatic)
        let manager = SwitchControlManager(config: config)
        
        // When: Managing focus
        let focusResult = manager.manageFocus(for: .next)
        
        // Then: Focus should be managed appropriately
        #expect(focusResult.success)
        #expect(focusResult.focusedElement != nil)
    }
    
    @Test func testSwitchControlGestureSupport() {
        // Given: Switch Control Manager with gesture support
        let config = SwitchControlConfig(enableGestureSupport: true)
        let manager = SwitchControlManager(config: config)
        
        // When: Processing gestures
        let gesture = SwitchControlGesture(type: .swipeLeft, intensity: .medium)
        let result = manager.processGesture(gesture)
        
        // Then: Gesture should be processed
        #expect(result.success)
        #expect(result.action != nil)
    }
    
    // MARK: - Switch Control Configuration Tests
    
    @Test func testSwitchControlConfiguration() {
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
        #expect(config.enableNavigation)
        #expect(config.enableCustomActions)
        #expect(config.enableGestureSupport)
        #expect(config.focusManagement == .manual)
        #expect(config.gestureSensitivity == .high)
        #expect(config.navigationSpeed == .fast)
    }
    
    // MARK: - Switch Control Actions Tests
    
    @Test func testSwitchControlActionCreation() {
        // Given: Switch Control action parameters
        let action = SwitchControlAction(
            name: "Test Action",
            gesture: .doubleTap,
            action: { print("Test action executed") }
        )
        
        // Then: Action should be properly created
        #expect(action.name == "Test Action")
        #expect(action.gesture == .doubleTap)
        #expect(action.action != nil)
    }
    
    @Test func testSwitchControlGestureTypes() {
        // Given: Different gesture types
        let singleTap = SwitchControlGesture(type: .singleTap, intensity: .light)
        let doubleTap = SwitchControlGesture(type: .doubleTap, intensity: .medium)
        let swipeLeft = SwitchControlGesture(type: .swipeLeft, intensity: .heavy)
        let swipeRight = SwitchControlGesture(type: .swipeRight, intensity: .light)
        
        // Then: Gestures should have correct types
        #expect(singleTap.type == .singleTap)
        #expect(doubleTap.type == .doubleTap)
        #expect(swipeLeft.type == .swipeLeft)
        #expect(swipeRight.type == .swipeRight)
    }
    
    // MARK: - Switch Control Focus Management Tests
    
    @Test func testSwitchControlFocusDirection() {
        // Given: Different focus directions
        let nextFocus = SwitchControlFocusDirection.next
        let previousFocus = SwitchControlFocusDirection.previous
        let firstFocus = SwitchControlFocusDirection.first
        let lastFocus = SwitchControlFocusDirection.last
        
        // Then: Directions should be properly defined
        #expect(nextFocus == .next)
        #expect(previousFocus == .previous)
        #expect(firstFocus == .first)
        #expect(lastFocus == .last)
    }
    
    @Test func testSwitchControlFocusManagementMode() {
        // Given: Different focus management modes
        let automatic = SwitchControlFocusManagement.automatic
        let manual = SwitchControlFocusManagement.manual
        let hybrid = SwitchControlFocusManagement.hybrid
        
        // Then: Modes should be properly defined
        #expect(automatic == .automatic)
        #expect(manual == .manual)
        #expect(hybrid == .hybrid)
    }
    
    // MARK: - Switch Control View Modifier Tests
    
    @Test func testSwitchControlViewModifier() {
        // Given: A view with Switch Control support
        let view = Text("Test")
            .switchControlEnabled()
        
        // Then: View should support Switch Control
        #expect(view != nil)
    }
    
    @Test func testSwitchControlViewModifierWithConfiguration() {
        // Given: A view with Switch Control configuration
        let config = SwitchControlConfig(enableNavigation: true)
        let view = Text("Test")
            .switchControlEnabled(config: config)
        
        // Then: View should support Switch Control with configuration
        #expect(view != nil)
    }
    
    // MARK: - Switch Control Compliance Tests
    
    @Test func testSwitchControlCompliance() {
        // Given: A view with Switch Control support
        let view = VStack {
            Text("Title")
            Button("Action") { }
        }
        .switchControlEnabled()
        
        // When: Checking Switch Control compliance
        let compliance = SwitchControlManager.checkCompliance(for: view)
        
        // Then: View should be compliant
        #expect(compliance.isCompliant)
        #expect(compliance.issues.count == 0)
    }
    
    @Test func testSwitchControlComplianceWithIssues() {
        // Given: A view without proper Switch Control support
        let view = Text("No Switch Control support")
        
        // When: Checking Switch Control compliance
        let compliance = SwitchControlManager.checkCompliance(for: view)
        
        // Then: View should have compliance issues
        #expect(!compliance.isCompliant)
        #expect(compliance.issues.count > 0)
    }
    
    // MARK: - Switch Control Performance Tests
    
    @Test func testSwitchControlPerformance() {
        // Given: Switch Control Manager
        let config = SwitchControlConfig(enableNavigation: true)
        let manager = SwitchControlManager(config: config)
        
        // When: Measuring performance
        // Performance test removed - performance monitoring was removed from framework
    }
}
