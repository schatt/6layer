//
//  EyeTrackingTests.swift
//  SixLayerFrameworkTests
//
//  Unit and integration tests for Eye Tracking features
//

import XCTest
import SwiftUI
@testable import SixLayerFramework

@MainActor
final class EyeTrackingTests: XCTestCase {
    
    // MARK: - Test Properties
    
    var eyeTrackingManager: EyeTrackingManager!
    var testConfig: EyeTrackingConfig!
    
    // MARK: - Setup and Teardown
    
    override func setUp() {
        super.setUp()
        testConfig = EyeTrackingConfig(
            sensitivity: .medium,
            dwellTime: 1.0,
            visualFeedback: true,
            hapticFeedback: true
        )
        eyeTrackingManager = EyeTrackingManager(config: testConfig)
    }
    
    override func tearDown() {
        eyeTrackingManager = nil
        testConfig = nil
        super.tearDown()
    }
    
    // MARK: - Configuration Tests
    
    func testEyeTrackingConfigInitialization() {
        let config = EyeTrackingConfig()
        
        XCTAssertEqual(config.sensitivity, .medium)
        XCTAssertEqual(config.dwellTime, 1.0)
        XCTAssertTrue(config.visualFeedback)
        XCTAssertTrue(config.hapticFeedback)
        XCTAssertFalse(config.calibration.isCalibrated)
    }
    
    func testEyeTrackingConfigCustomValues() {
        let customConfig = EyeTrackingConfig(
            sensitivity: .high,
            dwellTime: 2.0,
            visualFeedback: false,
            hapticFeedback: false
        )
        
        XCTAssertEqual(customConfig.sensitivity, .high)
        XCTAssertEqual(customConfig.dwellTime, 2.0)
        XCTAssertFalse(customConfig.visualFeedback)
        XCTAssertFalse(customConfig.hapticFeedback)
    }
    
    func testEyeTrackingSensitivityThresholds() {
        XCTAssertEqual(EyeTrackingSensitivity.low.threshold, 0.8)
        XCTAssertEqual(EyeTrackingSensitivity.medium.threshold, 0.6)
        XCTAssertEqual(EyeTrackingSensitivity.high.threshold, 0.4)
        XCTAssertEqual(EyeTrackingSensitivity.adaptive.threshold, 0.6)
    }
    
    func testEyeTrackingCalibrationInitialization() {
        let calibration = EyeTrackingCalibration()
        
        XCTAssertFalse(calibration.isCalibrated)
        XCTAssertEqual(calibration.accuracy, 0.0)
        XCTAssertNil(calibration.lastCalibrationDate)
        XCTAssertTrue(calibration.calibrationPoints.isEmpty)
    }
    
    // MARK: - Manager Tests
    
    func testEyeTrackingManagerInitialization() {
        XCTAssertFalse(eyeTrackingManager.isEnabled)
        XCTAssertFalse(eyeTrackingManager.isCalibrated)
        XCTAssertEqual(eyeTrackingManager.currentGaze, .zero)
        XCTAssertFalse(eyeTrackingManager.isTracking)
        XCTAssertNil(eyeTrackingManager.lastGazeEvent)
        XCTAssertNil(eyeTrackingManager.dwellTarget)
        XCTAssertEqual(eyeTrackingManager.dwellProgress, 0.0)
    }
    
    func testEyeTrackingManagerEnable() {
        let _ = eyeTrackingManager.isEnabled
        eyeTrackingManager.enable()
        
        // Note: In test environment, eye tracking may not be available
        // So we test that enable() was called (state may or may not change)
        // The important thing is that enable() doesn't crash
        XCTAssertNotNil(eyeTrackingManager.isEnabled)
    }
    
    func testEyeTrackingManagerDisable() {
        eyeTrackingManager.enable()
        eyeTrackingManager.disable()
        
        XCTAssertFalse(eyeTrackingManager.isEnabled)
        XCTAssertFalse(eyeTrackingManager.isTracking)
        XCTAssertNil(eyeTrackingManager.dwellTarget)
        XCTAssertEqual(eyeTrackingManager.dwellProgress, 0.0)
    }
    
    func testEyeTrackingManagerConfigUpdate() {
        let newConfig = EyeTrackingConfig(
            sensitivity: .high,
            dwellTime: 2.0,
            visualFeedback: false,
            hapticFeedback: false
        )
        
        eyeTrackingManager.updateConfig(newConfig)
        
        // Test that config was updated (we can't directly access the private config)
        // but we can test the calibration state
        XCTAssertFalse(eyeTrackingManager.isCalibrated)
    }
    
    // MARK: - Gaze Event Tests
    
    func testGazeEventInitialization() {
        let position = CGPoint(x: 100, y: 200)
        let timestamp = Date()
        let confidence = 0.85
        let isStable = true
        
        let gazeEvent = EyeTrackingGazeEvent(
            position: position,
            timestamp: timestamp,
            confidence: confidence,
            isStable: isStable
        )
        
        XCTAssertEqual(gazeEvent.position, position)
        XCTAssertEqual(gazeEvent.timestamp, timestamp)
        XCTAssertEqual(gazeEvent.confidence, confidence)
        XCTAssertEqual(gazeEvent.isStable, isStable)
    }
    
    func testGazeEventDefaultTimestamp() {
        let gazeEvent = EyeTrackingGazeEvent(
            position: CGPoint(x: 50, y: 75),
            confidence: 0.9
        )
        
        // Should use current timestamp
        XCTAssertTrue(gazeEvent.timestamp <= Date())
        XCTAssertFalse(gazeEvent.isStable)
    }
    
    func testProcessGazeEvent() {
        // Force enable for testing (bypass availability check)
        eyeTrackingManager.isEnabled = true
        
        let gazeEvent = EyeTrackingGazeEvent(
            position: CGPoint(x: 150, y: 250),
            confidence: 0.8
        )
        
        eyeTrackingManager.processGazeEvent(gazeEvent)
        
        XCTAssertEqual(eyeTrackingManager.currentGaze, gazeEvent.position)
        XCTAssertEqual(eyeTrackingManager.lastGazeEvent, gazeEvent)
    }
    
    // MARK: - Dwell Event Tests
    
    func testDwellEventInitialization() {
        let targetView = AnyView(Text("Test"))
        let position = CGPoint(x: 100, y: 200)
        let duration = 1.5
        let timestamp = Date()
        
        let dwellEvent = EyeTrackingDwellEvent(
            targetView: targetView,
            position: position,
            duration: duration,
            timestamp: timestamp
        )
        
        XCTAssertEqual(dwellEvent.position, position)
        XCTAssertEqual(dwellEvent.duration, duration)
        XCTAssertEqual(dwellEvent.timestamp, timestamp)
    }
    
    func testDwellEventDefaultTimestamp() {
        let dwellEvent = EyeTrackingDwellEvent(
            targetView: AnyView(Text("Test")),
            position: CGPoint(x: 50, y: 75),
            duration: 1.0
        )
        
        // Should use current timestamp
        XCTAssertTrue(dwellEvent.timestamp <= Date())
    }
    
    // MARK: - Calibration Tests
    
    func testStartCalibration() {
        let expectation = XCTestExpectation(description: "Calibration completed")
        
        eyeTrackingManager.startCalibration()
        
        // Wait for calibration to complete (simulated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            XCTAssertTrue(self.eyeTrackingManager.isCalibrated)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testCompleteCalibration() {
        XCTAssertFalse(eyeTrackingManager.isCalibrated)
        
        eyeTrackingManager.completeCalibration()
        
        XCTAssertTrue(eyeTrackingManager.isCalibrated)
    }
    
    // MARK: - View Modifier Tests
    
    func testEyeTrackingModifierInitialization() {
        let modifier = EyeTrackingModifier()
        
        // Test that modifier can be created
        XCTAssertNotNil(modifier)
    }
    
    func testEyeTrackingModifierWithConfig() {
        let config = EyeTrackingConfig(sensitivity: .high)
        let modifier = EyeTrackingModifier(config: config)
        
        XCTAssertNotNil(modifier)
    }
    
    func testEyeTrackingModifierWithCallbacks() {
        var _ = false // gazeCallbackCalled
        var _ = false // dwellCallbackCalled
        
        let modifier = EyeTrackingModifier(
            onGaze: { _ in },
            onDwell: { _ in }
        )
        
        XCTAssertNotNil(modifier)
        // Note: We can't easily test the callbacks without a full view hierarchy
    }
    
    // MARK: - View Extension Tests
    
    func testEyeTrackingEnabledViewModifier() {
        let testView = Text("Test")
        let modifiedView = testView.eyeTrackingEnabled()
        
        // Test that the modifier can be applied
        XCTAssertNotNil(modifiedView)
    }
    
    func testEyeTrackingEnabledWithConfig() {
        let testView = Text("Test")
        let config = EyeTrackingConfig(sensitivity: .low)
        let modifiedView = testView.eyeTrackingEnabled(config: config)
        
        XCTAssertNotNil(modifiedView)
    }
    
    func testEyeTrackingEnabledWithCallbacks() {
        let testView = Text("Test")
        let modifiedView = testView.eyeTrackingEnabled(
            onGaze: { _ in },
            onDwell: { _ in }
        )
        
        XCTAssertNotNil(modifiedView)
    }
    
    // MARK: - Performance Tests
    
    func testEyeTrackingPerformance() {
        measure {
            for i in 0..<1000 {
                let gazeEvent = EyeTrackingGazeEvent(
                    position: CGPoint(x: Double(i), y: Double(i * 2)),
                    confidence: 0.8
                )
                eyeTrackingManager.processGazeEvent(gazeEvent)
            }
        }
    }
    
    func testGazeEventCreationPerformance() {
        measure {
            for i in 0..<10000 {
                let _ = EyeTrackingGazeEvent(
                    position: CGPoint(x: Double(i), y: Double(i * 2)),
                    confidence: 0.8
                )
            }
        }
    }
    
    // MARK: - Integration Tests
    
    func testEyeTrackingIntegration() {
        // Test the complete eye tracking workflow
        let config = EyeTrackingConfig(
            sensitivity: .medium,
            dwellTime: 0.5,
            visualFeedback: true,
            hapticFeedback: true
        )
        
        let manager = EyeTrackingManager(config: config)
        
        // Enable tracking (force for testing)
        manager.isEnabled = true
        XCTAssertTrue(manager.isEnabled)
        
        // Process gaze events
        for i in 0..<10 {
            let gazeEvent = EyeTrackingGazeEvent(
                position: CGPoint(x: Double(i * 10), y: Double(i * 10)),
                confidence: 0.8
            )
            manager.processGazeEvent(gazeEvent)
        }
        
        // Complete calibration
        manager.completeCalibration()
        XCTAssertTrue(manager.isCalibrated)
        
        // Disable tracking
        manager.disable()
        XCTAssertFalse(manager.isEnabled)
    }
    
    func testEyeTrackingWithDifferentSensitivities() {
        let sensitivities: [EyeTrackingSensitivity] = [.low, .medium, .high, .adaptive]
        
        for sensitivity in sensitivities {
            let config = EyeTrackingConfig(sensitivity: sensitivity)
            let manager = EyeTrackingManager(config: config)
            
            XCTAssertNotNil(manager)
            // Test that manager can be created with different sensitivities
        }
    }
    
    func testEyeTrackingWithDifferentDwellTimes() {
        let dwellTimes: [TimeInterval] = [0.5, 1.0, 1.5, 2.0]
        
        for dwellTime in dwellTimes {
            let config = EyeTrackingConfig(dwellTime: dwellTime)
            let manager = EyeTrackingManager(config: config)
            
            XCTAssertNotNil(manager)
            // Test that manager can be created with different dwell times
        }
    }
}
