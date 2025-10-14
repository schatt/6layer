//
//  AccessibilityTypesTests.swift
//  SixLayerFrameworkTests
//
//  BUSINESS PURPOSE:
//  Validates accessibility types and enums functionality and comprehensive type system validation,
//  ensuring proper accessibility type definitions and enum behavior across all supported platforms.
//
//  TESTING SCOPE:
//  - Accessibility type definitions and enum validation
//  - Platform-specific accessibility type behavior
//  - Accessibility type conversion and mapping
//  - Accessibility type consistency and validation
//  - Cross-platform accessibility type compatibility
//  - Edge cases and error handling for accessibility types
//
//  METHODOLOGY:
//  - Test accessibility type definitions and enum validation
//  - Verify platform-specific accessibility type behavior using switch statements
//  - Test accessibility type conversion and mapping functionality
//  - Validate accessibility type consistency and validation
//  - Test cross-platform accessibility type compatibility
//  - Test edge cases and error handling for accessibility types
//
//  QUALITY ASSESSMENT: ✅ GOOD
//  - ✅ Good: Uses proper business logic testing with enum validation
//  - ✅ Good: Tests all accessibility types comprehensively
//  - ✅ Good: Validates enum cases and counts properly
//  - 🔧 Action Required: Add platform-specific behavior testing
//  - 🔧 Action Required: Add accessibility type conversion testing
//

import XCTest
import SwiftUI
@testable import SixLayerFramework

/// Comprehensive tests for all accessibility types and enums
@MainActor
final class AccessibilityTypesTests: XCTestCase {
    
    // MARK: - Platform-Specific Business Logic Tests
    
    func testAccessibilityTypesAcrossPlatforms() {
        // Given: Platform-specific accessibility type expectations
        let platform = SixLayerPlatform.current
        
        // When: Testing accessibility types on different platforms
        // Then: Test platform-specific business logic
        switch platform {
        case .iOS:
            // iOS should support comprehensive accessibility types
            XCTAssertTrue(VoiceOverAnnouncementType.allCases.count >= 6, "iOS should support comprehensive VoiceOver announcement types")
            XCTAssertTrue(VoiceOverGestureType.allCases.count >= 24, "iOS should support comprehensive VoiceOver gesture types")
            XCTAssertTrue(VoiceOverCustomActionType.allCases.count >= 17, "iOS should support comprehensive VoiceOver custom action types")
            
            // Test iOS-specific accessibility type behavior
            XCTAssertTrue(VoiceOverAnnouncementType.allCases.contains(.element), "iOS should support element announcements")
            XCTAssertTrue(VoiceOverAnnouncementType.allCases.contains(.action), "iOS should support action announcements")
            XCTAssertTrue(VoiceOverGestureType.allCases.contains(.singleTap), "iOS should support single tap gestures")
            XCTAssertTrue(VoiceOverGestureType.allCases.contains(.doubleTap), "iOS should support double tap gestures")
            
        case .macOS:
            // macOS should support keyboard-focused accessibility types
            XCTAssertTrue(VoiceOverAnnouncementType.allCases.count >= 6, "macOS should support comprehensive VoiceOver announcement types")
            XCTAssertTrue(VoiceOverGestureType.allCases.count >= 24, "macOS should support comprehensive VoiceOver gesture types")
            XCTAssertTrue(VoiceOverCustomActionType.allCases.count >= 17, "macOS should support comprehensive VoiceOver custom action types")
            
            // Test macOS-specific accessibility type behavior
            XCTAssertTrue(VoiceOverAnnouncementType.allCases.contains(.element), "macOS should support element announcements")
            XCTAssertTrue(VoiceOverAnnouncementType.allCases.contains(.state), "macOS should support state announcements")
            XCTAssertTrue(VoiceOverGestureType.allCases.contains(.rotor), "macOS should support rotor gestures")
            XCTAssertTrue(VoiceOverCustomActionType.allCases.contains(.activate), "macOS should support activate actions")
            
        case .watchOS:
            // watchOS should have simplified accessibility types
            XCTAssertTrue(VoiceOverAnnouncementType.allCases.count >= 6, "watchOS should support comprehensive VoiceOver announcement types")
            XCTAssertTrue(VoiceOverGestureType.allCases.count >= 24, "watchOS should support comprehensive VoiceOver gesture types")
            XCTAssertTrue(VoiceOverCustomActionType.allCases.count >= 17, "watchOS should support comprehensive VoiceOver custom action types")
            
            // Test watchOS-specific accessibility type behavior
            XCTAssertTrue(VoiceOverAnnouncementType.allCases.contains(.element), "watchOS should support element announcements")
            XCTAssertTrue(VoiceOverGestureType.allCases.contains(.singleTap), "watchOS should support single tap gestures")
            XCTAssertTrue(VoiceOverCustomActionType.allCases.contains(.activate), "watchOS should support activate actions")
            
        case .tvOS:
            // tvOS should support focus-based accessibility types
            XCTAssertTrue(VoiceOverAnnouncementType.allCases.count >= 6, "tvOS should support comprehensive VoiceOver announcement types")
            XCTAssertTrue(VoiceOverGestureType.allCases.count >= 24, "tvOS should support comprehensive VoiceOver gesture types")
            XCTAssertTrue(VoiceOverCustomActionType.allCases.count >= 17, "tvOS should support comprehensive VoiceOver custom action types")
            
            // Test tvOS-specific accessibility type behavior
            XCTAssertTrue(VoiceOverAnnouncementType.allCases.contains(.element), "tvOS should support element announcements")
            XCTAssertTrue(VoiceOverGestureType.allCases.contains(.rotor), "tvOS should support rotor gestures")
            XCTAssertTrue(VoiceOverCustomActionType.allCases.contains(.activate), "tvOS should support activate actions")
            
        case .visionOS:
            // visionOS should support spatial accessibility types
            XCTAssertTrue(VoiceOverAnnouncementType.allCases.count >= 6, "visionOS should support comprehensive VoiceOver announcement types")
            XCTAssertTrue(VoiceOverGestureType.allCases.count >= 24, "visionOS should support comprehensive VoiceOver gesture types")
            XCTAssertTrue(VoiceOverCustomActionType.allCases.count >= 17, "visionOS should support comprehensive VoiceOver custom action types")
            
            // Test visionOS-specific accessibility type behavior
            XCTAssertTrue(VoiceOverAnnouncementType.allCases.contains(.element), "visionOS should support element announcements")
            XCTAssertTrue(VoiceOverGestureType.allCases.contains(.singleTap), "visionOS should support single tap gestures")
            XCTAssertTrue(VoiceOverCustomActionType.allCases.contains(.activate), "visionOS should support activate actions")
        }
    }
    
    func testAccessibilityTypeConversionAndMapping() {
        // Given: Different accessibility types for conversion testing
        let announcementType = VoiceOverAnnouncementType.element
        let gestureType = VoiceOverGestureType.singleTap
        let actionType = VoiceOverCustomActionType.activate
        
        // When: Converting accessibility types
        let announcementString = announcementType.rawValue
        let gestureString = gestureType.rawValue
        let actionString = actionType.rawValue
        
        // Then: Test business logic for type conversion
        XCTAssertNotNil(announcementString, "Announcement type should convert to string")
        XCTAssertNotNil(gestureString, "Gesture type should convert to string")
        XCTAssertNotNil(actionString, "Action type should convert to string")
        
        // Test business logic: String conversion should be reversible
        XCTAssertEqual(VoiceOverAnnouncementType(rawValue: announcementString), announcementType, 
                      "Announcement type conversion should be reversible")
        XCTAssertEqual(VoiceOverGestureType(rawValue: gestureString), gestureType, 
                      "Gesture type conversion should be reversible")
        XCTAssertEqual(VoiceOverCustomActionType(rawValue: actionString), actionType, 
                      "Action type conversion should be reversible")
        
        // Test business logic: All enum cases should be convertible
        for announcementType in VoiceOverAnnouncementType.allCases {
            XCTAssertNotNil(VoiceOverAnnouncementType(rawValue: announcementType.rawValue), 
                          "All announcement types should be convertible")
        }
        
        for gestureType in VoiceOverGestureType.allCases {
            XCTAssertNotNil(VoiceOverGestureType(rawValue: gestureType.rawValue), 
                          "All gesture types should be convertible")
        }
        
        for actionType in VoiceOverCustomActionType.allCases {
            XCTAssertNotNil(VoiceOverCustomActionType(rawValue: actionType.rawValue), 
                          "All action types should be convertible")
        }
    }
    
    func testAccessibilityTypeConsistencyAndValidation() {
        // Given: Accessibility types for consistency testing
        let announcementTypes = VoiceOverAnnouncementType.allCases
        let gestureTypes = VoiceOverGestureType.allCases
        let actionTypes = VoiceOverCustomActionType.allCases
        
        // When: Validating accessibility type consistency
        // Then: Test business logic for type consistency
        XCTAssertTrue(announcementTypes.count > 0, "Should have at least one announcement type")
        XCTAssertTrue(gestureTypes.count > 0, "Should have at least one gesture type")
        XCTAssertTrue(actionTypes.count > 0, "Should have at least one action type")
        
        // Test business logic: All types should have unique raw values
        let announcementRawValues = Set(announcementTypes.map { $0.rawValue })
        XCTAssertEqual(announcementRawValues.count, announcementTypes.count, 
                      "All announcement types should have unique raw values")
        
        let gestureRawValues = Set(gestureTypes.map { $0.rawValue })
        XCTAssertEqual(gestureRawValues.count, gestureTypes.count, 
                      "All gesture types should have unique raw values")
        
        let actionRawValues = Set(actionTypes.map { $0.rawValue })
        XCTAssertEqual(actionRawValues.count, actionTypes.count, 
                      "All action types should have unique raw values")
        
        // Test business logic: All types should be case iterable
        XCTAssertTrue(announcementTypes.contains(.element), "Should contain element announcement type")
        XCTAssertTrue(gestureTypes.contains(.singleTap), "Should contain single tap gesture type")
        XCTAssertTrue(actionTypes.contains(.activate), "Should contain activate action type")
    }
    
    // MARK: - VoiceOver Types Tests
    
    func testVoiceOverAnnouncementType() {
        let types = VoiceOverAnnouncementType.allCases
        XCTAssertEqual(types.count, 6)
        XCTAssertTrue(types.contains(.element))
        XCTAssertTrue(types.contains(.action))
        XCTAssertTrue(types.contains(.state))
        XCTAssertTrue(types.contains(.hint))
        XCTAssertTrue(types.contains(.value))
        XCTAssertTrue(types.contains(.custom))
    }
    
    func testVoiceOverNavigationMode() {
        let modes = VoiceOverNavigationMode.allCases
        XCTAssertEqual(modes.count, 3)
        XCTAssertTrue(modes.contains(.automatic))
        XCTAssertTrue(modes.contains(.manual))
        XCTAssertTrue(modes.contains(.custom))
    }
    
    func testVoiceOverGestureType() {
        let gestures = VoiceOverGestureType.allCases
        XCTAssertEqual(gestures.count, 24)
        XCTAssertTrue(gestures.contains(.singleTap))
        XCTAssertTrue(gestures.contains(.doubleTap))
        XCTAssertTrue(gestures.contains(.tripleTap))
        XCTAssertTrue(gestures.contains(.rotor))
        XCTAssertTrue(gestures.contains(.custom))
    }
    
    func testVoiceOverCustomActionType() {
        let actions = VoiceOverCustomActionType.allCases
        XCTAssertEqual(actions.count, 17)
        XCTAssertTrue(actions.contains(.activate))
        XCTAssertTrue(actions.contains(.edit))
        XCTAssertTrue(actions.contains(.delete))
        XCTAssertTrue(actions.contains(.play))
        XCTAssertTrue(actions.contains(.pause))
        XCTAssertTrue(actions.contains(.custom))
    }
    
    func testVoiceOverAnnouncementPriority() {
        let priorities = VoiceOverAnnouncementPriority.allCases
        XCTAssertEqual(priorities.count, 4)
        XCTAssertTrue(priorities.contains(.low))
        XCTAssertTrue(priorities.contains(.normal))
        XCTAssertTrue(priorities.contains(.high))
        XCTAssertTrue(priorities.contains(.critical))
    }
    
    func testVoiceOverAnnouncementTiming() {
        let timings = VoiceOverAnnouncementTiming.allCases
        XCTAssertEqual(timings.count, 4)
        XCTAssertTrue(timings.contains(.immediate))
        XCTAssertTrue(timings.contains(.delayed))
        XCTAssertTrue(timings.contains(.queued))
        XCTAssertTrue(timings.contains(.interrupt))
    }
    
    func testVoiceOverElementTraits() {
        let traits = VoiceOverElementTraits.all
        XCTAssertNotEqual(traits.rawValue, 0)
        
        let button = VoiceOverElementTraits.button
        let link = VoiceOverElementTraits.link
        let header = VoiceOverElementTraits.header
        
        XCTAssertTrue(button.contains(.button))
        XCTAssertTrue(link.contains(.link))
        XCTAssertTrue(header.contains(.header))
        
        let combined = button.union(link).union(header)
        XCTAssertTrue(combined.contains(.button))
        XCTAssertTrue(combined.contains(.link))
        XCTAssertTrue(combined.contains(.header))
    }
    
    func testVoiceOverConfiguration() {
        let config = VoiceOverConfiguration()
        XCTAssertEqual(config.announcementType, .element)
        XCTAssertEqual(config.navigationMode, .automatic)
        XCTAssertEqual(config.gestureSensitivity, .medium)
        XCTAssertEqual(config.announcementPriority, .normal)
        XCTAssertEqual(config.announcementTiming, .immediate)
        XCTAssertTrue(config.enableCustomActions)
        XCTAssertTrue(config.enableGestureRecognition)
        XCTAssertTrue(config.enableRotorSupport)
        XCTAssertTrue(config.enableHapticFeedback)
    }
    
    func testVoiceOverGestureSensitivity() {
        let sensitivities = VoiceOverGestureSensitivity.allCases
        XCTAssertEqual(sensitivities.count, 3)
        XCTAssertTrue(sensitivities.contains(.low))
        XCTAssertTrue(sensitivities.contains(.medium))
        XCTAssertTrue(sensitivities.contains(.high))
    }
    
    func testVoiceOverCustomAction() {
        var actionExecuted = false
        let action = VoiceOverCustomAction(
            name: "Test Action",
            type: .activate
        ) {
            actionExecuted = true
        }
        
        XCTAssertEqual(action.name, "Test Action")
        XCTAssertEqual(action.type, .activate)
        action.handler()
        XCTAssertTrue(actionExecuted)
    }
    
    func testVoiceOverAnnouncement() {
        let announcement = VoiceOverAnnouncement(
            message: "Test message",
            type: .element,
            priority: .normal,
            timing: .immediate,
            delay: 0.5
        )
        
        XCTAssertEqual(announcement.message, "Test message")
        XCTAssertEqual(announcement.type, .element)
        XCTAssertEqual(announcement.priority, .normal)
        XCTAssertEqual(announcement.timing, .immediate)
        XCTAssertEqual(announcement.delay, 0.5)
    }
    
    // MARK: - Switch Control Types Tests
    
    func testSwitchControlActionType() {
        let actions = SwitchControlActionType.allCases
        XCTAssertEqual(actions.count, 11)
        XCTAssertTrue(actions.contains(.select))
        XCTAssertTrue(actions.contains(.moveNext))
        XCTAssertTrue(actions.contains(.movePrevious))
        XCTAssertTrue(actions.contains(.activate))
        XCTAssertTrue(actions.contains(.custom))
    }
    
    func testSwitchControlNavigationPattern() {
        let patterns = SwitchControlNavigationPattern.allCases
        XCTAssertEqual(patterns.count, 3)
        XCTAssertTrue(patterns.contains(.linear))
        XCTAssertTrue(patterns.contains(.grid))
        XCTAssertTrue(patterns.contains(.custom))
    }
    
    func testSwitchControlGestureType() {
        let gestures = SwitchControlGestureType.allCases
        XCTAssertEqual(gestures.count, 7)
        XCTAssertTrue(gestures.contains(.singleTap))
        XCTAssertTrue(gestures.contains(.doubleTap))
        XCTAssertTrue(gestures.contains(.longPress))
        XCTAssertTrue(gestures.contains(.swipeLeft))
        XCTAssertTrue(gestures.contains(.swipeRight))
        XCTAssertTrue(gestures.contains(.swipeUp))
        XCTAssertTrue(gestures.contains(.swipeDown))
    }
    
    func testSwitchControlGestureIntensity() {
        let intensities = SwitchControlGestureIntensity.allCases
        XCTAssertEqual(intensities.count, 3)
        XCTAssertTrue(intensities.contains(.light))
        XCTAssertTrue(intensities.contains(.medium))
        XCTAssertTrue(intensities.contains(.heavy))
    }
    
    func testSwitchControlGesture() {
        let gesture = SwitchControlGesture(
            type: .singleTap,
            intensity: .medium
        )
        
        XCTAssertEqual(gesture.type, .singleTap)
        XCTAssertEqual(gesture.intensity, .medium)
        XCTAssertNotNil(gesture.timestamp)
    }
    
    func testSwitchControlAction() {
        var actionExecuted = false
        let action = SwitchControlAction(
            name: "Test Action",
            gesture: .singleTap
        ) {
            actionExecuted = true
        }
        
        XCTAssertEqual(action.name, "Test Action")
        XCTAssertEqual(action.gesture, .singleTap)
        action.action()
        XCTAssertTrue(actionExecuted)
    }
    
    func testSwitchControlFocusResult() {
        let successResult = SwitchControlFocusResult(
            success: true,
            focusedElement: "Test Element"
        )
        
        XCTAssertTrue(successResult.success)
        XCTAssertEqual(successResult.focusedElement as? String, "Test Element")
        XCTAssertNil(successResult.error)
        
        let failureResult = SwitchControlFocusResult(
            success: false,
            error: "Test Error"
        )
        
        XCTAssertFalse(failureResult.success)
        XCTAssertNil(failureResult.focusedElement)
        XCTAssertEqual(failureResult.error, "Test Error")
    }
    
    func testSwitchControlGestureResult() {
        let successResult = SwitchControlGestureResult(
            success: true,
            action: "Test Action"
        )
        
        XCTAssertTrue(successResult.success)
        XCTAssertEqual(successResult.action, "Test Action")
        XCTAssertNil(successResult.error)
        
        let failureResult = SwitchControlGestureResult(
            success: false,
            error: "Test Error"
        )
        
        XCTAssertFalse(failureResult.success)
        XCTAssertNil(failureResult.action)
        XCTAssertEqual(failureResult.error, "Test Error")
    }
    
    func testSwitchControlCompliance() {
        let compliant = SwitchControlCompliance(
            isCompliant: true,
            issues: [],
            score: 100.0
        )
        
        XCTAssertTrue(compliant.isCompliant)
        XCTAssertTrue(compliant.issues.isEmpty)
        XCTAssertEqual(compliant.score, 100.0)
        
        let nonCompliant = SwitchControlCompliance(
            isCompliant: false,
            issues: ["Issue 1", "Issue 2"],
            score: 50.0
        )
        
        XCTAssertFalse(nonCompliant.isCompliant)
        XCTAssertEqual(nonCompliant.issues.count, 2)
        XCTAssertEqual(nonCompliant.score, 50.0)
    }
    
    // MARK: - AssistiveTouch Types Tests
    
    func testAssistiveTouchActionType() {
        let actions = AssistiveTouchActionType.allCases
        XCTAssertEqual(actions.count, 4)
        XCTAssertTrue(actions.contains(.home))
        XCTAssertTrue(actions.contains(.back))
        XCTAssertTrue(actions.contains(.menu))
        XCTAssertTrue(actions.contains(.custom))
    }
    
    func testAssistiveTouchGestureSensitivity() {
        let sensitivities = AssistiveTouchGestureSensitivity.allCases
        XCTAssertEqual(sensitivities.count, 3)
        XCTAssertTrue(sensitivities.contains(.low))
        XCTAssertTrue(sensitivities.contains(.medium))
        XCTAssertTrue(sensitivities.contains(.high))
    }
    
    func testAssistiveTouchMenuStyle() {
        let styles = AssistiveTouchMenuStyle.allCases
        XCTAssertEqual(styles.count, 3)
        XCTAssertTrue(styles.contains(.floating))
        XCTAssertTrue(styles.contains(.docked))
        XCTAssertTrue(styles.contains(.contextual))
    }
    
    func testAssistiveTouchGestureType() {
        let gestures = AssistiveTouchGestureType.allCases
        XCTAssertEqual(gestures.count, 7)
        XCTAssertTrue(gestures.contains(.singleTap))
        XCTAssertTrue(gestures.contains(.doubleTap))
        XCTAssertTrue(gestures.contains(.longPress))
        XCTAssertTrue(gestures.contains(.swipeLeft))
        XCTAssertTrue(gestures.contains(.swipeRight))
        XCTAssertTrue(gestures.contains(.swipeUp))
        XCTAssertTrue(gestures.contains(.swipeDown))
    }
    
    func testAssistiveTouchGestureIntensity() {
        let intensities = AssistiveTouchGestureIntensity.allCases
        XCTAssertEqual(intensities.count, 3)
        XCTAssertTrue(intensities.contains(.light))
        XCTAssertTrue(intensities.contains(.medium))
        XCTAssertTrue(intensities.contains(.heavy))
    }
    
    func testAssistiveTouchConfig() {
        let config = AssistiveTouchConfig()
        XCTAssertTrue(config.enableIntegration)
        XCTAssertTrue(config.enableCustomActions)
        XCTAssertTrue(config.enableMenuSupport)
        XCTAssertTrue(config.enableGestureRecognition)
        XCTAssertEqual(config.gestureSensitivity, .medium)
        XCTAssertEqual(config.menuStyle, .floating)
    }
    
    func testAssistiveTouchGesture() {
        let gesture = AssistiveTouchGesture(
            type: .singleTap,
            intensity: .medium
        )
        
        XCTAssertEqual(gesture.type, .singleTap)
        XCTAssertEqual(gesture.intensity, .medium)
        XCTAssertNotNil(gesture.timestamp)
    }
    
    func testAssistiveTouchAction() {
        var actionExecuted = false
        let action = AssistiveTouchAction(
            name: "Test Action",
            gesture: .singleTap
        ) {
            actionExecuted = true
        }
        
        XCTAssertEqual(action.name, "Test Action")
        XCTAssertEqual(action.gesture, .singleTap)
        action.action()
        XCTAssertTrue(actionExecuted)
    }
    
    func testAssistiveTouchMenuAction() {
        let actions = AssistiveTouchMenuAction.allCases
        XCTAssertEqual(actions.count, 3)
        XCTAssertTrue(actions.contains(.show))
        XCTAssertTrue(actions.contains(.hide))
        XCTAssertTrue(actions.contains(.toggle))
    }
    
    func testAssistiveTouchMenuResult() {
        let successResult = AssistiveTouchMenuResult(
            success: true,
            menuElement: "Test Menu"
        )
        
        XCTAssertTrue(successResult.success)
        XCTAssertEqual(successResult.menuElement as? String, "Test Menu")
        XCTAssertNil(successResult.error)
        
        let failureResult = AssistiveTouchMenuResult(
            success: false,
            error: "Test Error"
        )
        
        XCTAssertFalse(failureResult.success)
        XCTAssertNil(failureResult.menuElement)
        XCTAssertEqual(failureResult.error, "Test Error")
    }
    
    func testAssistiveTouchGestureResult() {
        let successResult = AssistiveTouchGestureResult(
            success: true,
            action: "Test Action"
        )
        
        XCTAssertTrue(successResult.success)
        XCTAssertEqual(successResult.action, "Test Action")
        XCTAssertNil(successResult.error)
        
        let failureResult = AssistiveTouchGestureResult(
            success: false,
            error: "Test Error"
        )
        
        XCTAssertFalse(failureResult.success)
        XCTAssertNil(failureResult.action)
        XCTAssertEqual(failureResult.error, "Test Error")
    }
    
    func testAssistiveTouchCompliance() {
        let compliant = AssistiveTouchCompliance(
            isCompliant: true,
            issues: [],
            score: 100.0
        )
        
        XCTAssertTrue(compliant.isCompliant)
        XCTAssertTrue(compliant.issues.isEmpty)
        XCTAssertEqual(compliant.score, 100.0)
        
        let nonCompliant = AssistiveTouchCompliance(
            isCompliant: false,
            issues: ["Issue 1", "Issue 2"],
            score: 50.0
        )
        
        XCTAssertFalse(nonCompliant.isCompliant)
        XCTAssertEqual(nonCompliant.issues.count, 2)
        XCTAssertEqual(nonCompliant.score, 50.0)
    }
    
    // MARK: - Eye Tracking Types Tests
    
    func testEyeTrackingCalibrationLevel() {
        let levels = EyeTrackingCalibrationLevel.allCases
        XCTAssertEqual(levels.count, 4)
        XCTAssertTrue(levels.contains(.basic))
        XCTAssertTrue(levels.contains(.standard))
        XCTAssertTrue(levels.contains(.advanced))
        XCTAssertTrue(levels.contains(.expert))
    }
    
    func testEyeTrackingInteractionType() {
        let types = EyeTrackingInteractionType.allCases
        XCTAssertEqual(types.count, 5)
        XCTAssertTrue(types.contains(.gaze))
        XCTAssertTrue(types.contains(.dwell))
        XCTAssertTrue(types.contains(.blink))
        XCTAssertTrue(types.contains(.wink))
        XCTAssertTrue(types.contains(.custom))
    }
    
    func testEyeTrackingFocusManagement() {
        let management = EyeTrackingFocusManagement.allCases
        XCTAssertEqual(management.count, 3)
        XCTAssertTrue(management.contains(.automatic))
        XCTAssertTrue(management.contains(.manual))
        XCTAssertTrue(management.contains(.hybrid))
    }
    
    func testEyeTrackingConfiguration() {
        let config = EyeTrackingConfiguration()
        XCTAssertEqual(config.calibrationLevel, .standard)
        XCTAssertEqual(config.interactionType, .dwell)
        XCTAssertEqual(config.focusManagement, .automatic)
        XCTAssertEqual(config.dwellTime, 1.0)
        XCTAssertTrue(config.enableHapticFeedback)
        XCTAssertFalse(config.enableAudioFeedback)
    }
    
    func testEyeTrackingSensitivity() {
        let sensitivities = EyeTrackingSensitivity.allCases
        XCTAssertEqual(sensitivities.count, 4)
        XCTAssertTrue(sensitivities.contains(.low))
        XCTAssertTrue(sensitivities.contains(.medium))
        XCTAssertTrue(sensitivities.contains(.high))
        XCTAssertTrue(sensitivities.contains(.adaptive))
        
        XCTAssertEqual(EyeTrackingSensitivity.low.threshold, 0.8)
        XCTAssertEqual(EyeTrackingSensitivity.medium.threshold, 0.6)
        XCTAssertEqual(EyeTrackingSensitivity.high.threshold, 0.4)
        XCTAssertEqual(EyeTrackingSensitivity.adaptive.threshold, 0.6)
    }
    
    func testEyeTrackingCalibration() {
        let calibration = EyeTrackingCalibration()
        XCTAssertFalse(calibration.isCalibrated)
        XCTAssertEqual(calibration.accuracy, 0.0)
        XCTAssertNil(calibration.lastCalibrationDate)
        XCTAssertTrue(calibration.calibrationPoints.isEmpty)
        
        let calibrated = EyeTrackingCalibration(
            isCalibrated: true,
            accuracy: 0.85,
            lastCalibrationDate: Date(),
            calibrationPoints: [CGPoint(x: 0, y: 0), CGPoint(x: 100, y: 100)]
        )
        
        XCTAssertTrue(calibrated.isCalibrated)
        XCTAssertEqual(calibrated.accuracy, 0.85)
        XCTAssertNotNil(calibrated.lastCalibrationDate)
        XCTAssertEqual(calibrated.calibrationPoints.count, 2)
    }
    
    func testEyeTrackingGazeEvent() {
        let position = CGPoint(x: 100, y: 200)
        let timestamp = Date()
        let event = EyeTrackingGazeEvent(
            position: position,
            timestamp: timestamp,
            confidence: 0.85,
            isStable: true
        )
        
        XCTAssertEqual(event.position, position)
        XCTAssertEqual(event.timestamp, timestamp)
        XCTAssertEqual(event.confidence, 0.85)
        XCTAssertTrue(event.isStable)
    }
    
    func testEyeTrackingDwellEvent() {
        let targetView = AnyView(Text("Test"))
        let position = CGPoint(x: 100, y: 200)
        let duration: TimeInterval = 2.5
        let timestamp = Date()
        
        let event = EyeTrackingDwellEvent(
            targetView: targetView,
            position: position,
            duration: duration,
            timestamp: timestamp
        )
        
        XCTAssertEqual(event.position, position)
        XCTAssertEqual(event.duration, duration)
        XCTAssertEqual(event.timestamp, timestamp)
    }
    
    func testEyeTrackingConfig() {
        let config = EyeTrackingConfig()
        XCTAssertEqual(config.sensitivity, .medium)
        XCTAssertEqual(config.dwellTime, 1.0)
        XCTAssertTrue(config.visualFeedback)
        XCTAssertTrue(config.hapticFeedback)
        XCTAssertFalse(config.calibration.isCalibrated)
    }
    
    // MARK: - Voice Control Types Tests
    
    func testVoiceControlCommandType() {
        let types = VoiceControlCommandType.allCases
        XCTAssertEqual(types.count, 8)
        XCTAssertTrue(types.contains(.tap))
        XCTAssertTrue(types.contains(.swipe))
        XCTAssertTrue(types.contains(.scroll))
        XCTAssertTrue(types.contains(.zoom))
        XCTAssertTrue(types.contains(.select))
        XCTAssertTrue(types.contains(.edit))
        XCTAssertTrue(types.contains(.delete))
        XCTAssertTrue(types.contains(.custom))
    }
    
    func testVoiceControlFeedbackType() {
        let types = VoiceControlFeedbackType.allCases
        XCTAssertEqual(types.count, 4)
        XCTAssertTrue(types.contains(.audio))
        XCTAssertTrue(types.contains(.haptic))
        XCTAssertTrue(types.contains(.visual))
        XCTAssertTrue(types.contains(.combined))
    }
    
    func testVoiceControlCustomCommand() {
        var commandExecuted = false
        let command = VoiceControlCustomCommand(
            phrase: "Test command",
            type: .tap
        ) {
            commandExecuted = true
        }
        
        XCTAssertEqual(command.phrase, "Test command")
        XCTAssertEqual(command.type, .tap)
        command.handler()
        XCTAssertTrue(commandExecuted)
    }
    
    func testVoiceControlConfiguration() {
        let config = VoiceControlConfiguration()
        XCTAssertTrue(config.enableCustomCommands)
        XCTAssertEqual(config.feedbackType, .combined)
        XCTAssertTrue(config.enableAudioFeedback)
        XCTAssertTrue(config.enableHapticFeedback)
        XCTAssertTrue(config.enableVisualFeedback)
        XCTAssertEqual(config.commandTimeout, 5.0)
    }
    
    func testVoiceControlCommandResult() {
        let successResult = VoiceControlCommandResult(
            success: true,
            action: "Test Action",
            feedback: "Test Feedback"
        )
        
        XCTAssertTrue(successResult.success)
        XCTAssertEqual(successResult.action, "Test Action")
        XCTAssertEqual(successResult.feedback, "Test Feedback")
        XCTAssertNil(successResult.error)
        
        let failureResult = VoiceControlCommandResult(
            success: false,
            error: "Test Error"
        )
        
        XCTAssertFalse(failureResult.success)
        XCTAssertNil(failureResult.action)
        XCTAssertNil(failureResult.feedback)
        XCTAssertEqual(failureResult.error, "Test Error")
    }
    
    func testVoiceControlNavigationType() {
        let types = VoiceControlNavigationType.allCases
        XCTAssertEqual(types.count, 9)
        XCTAssertTrue(types.contains(.tap))
        XCTAssertTrue(types.contains(.swipe))
        XCTAssertTrue(types.contains(.scroll))
        XCTAssertTrue(types.contains(.zoom))
        XCTAssertTrue(types.contains(.select))
        XCTAssertTrue(types.contains(.navigate))
        XCTAssertTrue(types.contains(.back))
        XCTAssertTrue(types.contains(.home))
        XCTAssertTrue(types.contains(.menu))
    }
    
    func testVoiceControlGestureType() {
        let types = VoiceControlGestureType.allCases
        XCTAssertEqual(types.count, 10)
        XCTAssertTrue(types.contains(.tap))
        XCTAssertTrue(types.contains(.doubleTap))
        XCTAssertTrue(types.contains(.longPress))
        XCTAssertTrue(types.contains(.swipeLeft))
        XCTAssertTrue(types.contains(.swipeRight))
        XCTAssertTrue(types.contains(.swipeUp))
        XCTAssertTrue(types.contains(.swipeDown))
        XCTAssertTrue(types.contains(.pinch))
        XCTAssertTrue(types.contains(.rotate))
        XCTAssertTrue(types.contains(.scroll))
    }
    
    func testVoiceControlCommandRecognition() {
        let recognition = VoiceControlCommandRecognition(
            phrase: "Test phrase",
            confidence: 0.85,
            recognizedCommand: .tap
        )
        
        XCTAssertEqual(recognition.phrase, "Test phrase")
        XCTAssertEqual(recognition.confidence, 0.85)
        XCTAssertEqual(recognition.recognizedCommand, .tap)
        XCTAssertNotNil(recognition.timestamp)
    }
    
    func testVoiceControlCompliance() {
        let compliant = VoiceControlCompliance(
            isCompliant: true,
            issues: [],
            score: 100.0
        )
        
        XCTAssertTrue(compliant.isCompliant)
        XCTAssertTrue(compliant.issues.isEmpty)
        XCTAssertEqual(compliant.score, 100.0)
        
        let nonCompliant = VoiceControlCompliance(
            isCompliant: false,
            issues: ["Issue 1", "Issue 2"],
            score: 50.0
        )
        
        XCTAssertFalse(nonCompliant.isCompliant)
        XCTAssertEqual(nonCompliant.issues.count, 2)
        XCTAssertEqual(nonCompliant.score, 50.0)
    }
    
    // MARK: - Material Accessibility Types Tests
    
    func testMaterialContrastLevel() {
        let levels = MaterialContrastLevel.allCases
        XCTAssertEqual(levels.count, 4)
        XCTAssertTrue(levels.contains(.low))
        XCTAssertTrue(levels.contains(.medium))
        XCTAssertTrue(levels.contains(.high))
        XCTAssertTrue(levels.contains(.maximum))
    }
    
    
    func testMaterialAccessibilityConfiguration() {
        let config = MaterialAccessibilityConfiguration()
        XCTAssertEqual(config.contrastLevel, .medium)
        XCTAssertTrue(config.enableHighContrastAlternatives)
        XCTAssertTrue(config.enableVoiceOverDescriptions)
        XCTAssertTrue(config.enableSwitchControlSupport)
        XCTAssertTrue(config.enableAssistiveTouchSupport)
    }
    
    
    
    
    
    
    
    
    
    // MARK: - Basic Accessibility Types Tests
    
    func testComplianceLevel() {
        let levels = ComplianceLevel.allCases
        XCTAssertEqual(levels.count, 4)
        XCTAssertTrue(levels.contains(.basic))
        XCTAssertTrue(levels.contains(.intermediate))
        XCTAssertTrue(levels.contains(.advanced))
        XCTAssertTrue(levels.contains(.expert))
        
        XCTAssertEqual(ComplianceLevel.basic.rawValue, 1)
        XCTAssertEqual(ComplianceLevel.intermediate.rawValue, 2)
        XCTAssertEqual(ComplianceLevel.advanced.rawValue, 3)
        XCTAssertEqual(ComplianceLevel.expert.rawValue, 4)
    }
    
    func testIssueSeverity() {
        let severities = IssueSeverity.allCases
        XCTAssertEqual(severities.count, 4)
        XCTAssertTrue(severities.contains(.low))
        XCTAssertTrue(severities.contains(.medium))
        XCTAssertTrue(severities.contains(.high))
        XCTAssertTrue(severities.contains(.critical))
    }
    
    func testAccessibilitySettings() {
        let settings = SixLayerFramework.AccessibilitySettings()
        XCTAssertTrue(settings.voiceOverSupport)
        XCTAssertTrue(settings.keyboardNavigation)
        XCTAssertTrue(settings.highContrastMode)
        XCTAssertTrue(settings.dynamicType)
        XCTAssertTrue(settings.reducedMotion)
        XCTAssertTrue(settings.hapticFeedback)
    }
    
    func testAccessibilityComplianceMetrics() {
        let metrics = AccessibilityComplianceMetrics()
        XCTAssertEqual(metrics.voiceOverCompliance, .basic)
        XCTAssertEqual(metrics.keyboardCompliance, .basic)
        XCTAssertEqual(metrics.contrastCompliance, .basic)
        XCTAssertEqual(metrics.motionCompliance, .basic)
        XCTAssertEqual(metrics.overallComplianceScore, 0.0)
    }
    
    func testAccessibilityAuditResult() {
        let metrics = AccessibilityComplianceMetrics()
        let result = AccessibilityAuditResult(
            complianceLevel: .basic,
            issues: [],
            recommendations: ["Recommendation 1"],
            score: 75.0,
            complianceMetrics: metrics
        )
        
        XCTAssertEqual(result.complianceLevel, .basic)
        XCTAssertTrue(result.issues.isEmpty)
        XCTAssertEqual(result.recommendations.count, 1)
        XCTAssertEqual(result.score, 75.0)
        XCTAssertEqual(result.complianceMetrics.voiceOverCompliance, .basic)
    }
    
    func testAccessibilityIssue() {
        let issue = AccessibilityIssue(
            severity: .high,
            description: "Test issue",
            element: "Test element",
            suggestion: "Test suggestion"
        )
        
        XCTAssertEqual(issue.severity, .high)
        XCTAssertEqual(issue.description, "Test issue")
        XCTAssertEqual(issue.element, "Test element")
        XCTAssertEqual(issue.suggestion, "Test suggestion")
    }
}
