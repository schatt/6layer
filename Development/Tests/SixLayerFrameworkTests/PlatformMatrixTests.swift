import XCTest
import SwiftUI
@testable import SixLayerFramework

/// Comprehensive platform matrix testing for cross-platform framework
/// Tests all platform combinations, device types, and capability matrices
@MainActor
final class PlatformMatrixTests: XCTestCase {
    
    // MARK: - Platform Detection Tests
    
    func testPlatformDetectionMatrix() {
        // Test that platform detection works correctly
        let platform = Platform.current
        let deviceType = DeviceType.current
        
        // Verify we're running on a known platform
        XCTAssertTrue([.iOS, .macOS, .watchOS, .tvOS, .visionOS].contains(platform), 
                     "Should detect a valid platform")
        
        // Verify device type is appropriate for platform
        switch platform {
        case .iOS:
            XCTAssertTrue([.phone, .pad].contains(deviceType), 
                         "iOS should have phone or pad device type")
        case .macOS:
            XCTAssertEqual(deviceType, .mac, 
                          "macOS should have mac device type")
        case .watchOS:
            XCTAssertEqual(deviceType, .watch, 
                          "watchOS should have watch device type")
        case .tvOS:
            XCTAssertEqual(deviceType, .tv, 
                          "tvOS should have tv device type")
        case .visionOS:
            XCTAssertEqual(deviceType, .tv, 
                          "visionOS should have tv device type (using tv as closest match)")
        }
    }
    
    // MARK: - Touch Capability Matrix
    
    func testTouchCapabilityMatrix() {
        let config = getCardExpansionPlatformConfig()
        
        // Test touch support matrix
        switch Platform.current {
        case .iOS, .watchOS:
            XCTAssertTrue(config.supportsTouch, 
                         "\(Platform.current) should support touch")
            XCTAssertTrue(config.supportsHapticFeedback, 
                         "Touch platforms should support haptic feedback")
        case .macOS, .tvOS, .visionOS:
            XCTAssertFalse(config.supportsTouch, 
                          "\(Platform.current) should not support touch")
            XCTAssertFalse(config.supportsHapticFeedback, 
                          "Non-touch platforms should not support haptic feedback")
        }
    }
    
    // MARK: - Hover Capability Matrix
    
    func testHoverCapabilityMatrix() {
        let config = getCardExpansionPlatformConfig()
        
        // Test hover support matrix
        switch Platform.current {
        case .macOS:
            XCTAssertTrue(config.supportsHover, 
                         "macOS should support hover")
        case .iOS, .watchOS, .tvOS, .visionOS:
            XCTAssertFalse(config.supportsHover, 
                          "\(Platform.current) should not support hover")
        }
    }
    
    // MARK: - Accessibility Capability Matrix
    
    func testAccessibilityCapabilityMatrix() {
        let config = getCardExpansionPlatformConfig()
        
        // All platforms should support these accessibility features
        XCTAssertTrue(config.supportsVoiceOver, 
                     "All platforms should support VoiceOver")
        XCTAssertTrue(config.supportsSwitchControl, 
                     "All platforms should support Switch Control")
        
        // AssistiveTouch is iOS/watchOS only
        switch Platform.current {
        case .iOS, .watchOS:
            XCTAssertTrue(config.supportsAssistiveTouch, 
                         "\(Platform.current) should support AssistiveTouch")
        case .macOS, .tvOS, .visionOS:
            XCTAssertFalse(config.supportsAssistiveTouch, 
                          "\(Platform.current) should not support AssistiveTouch")
        }
    }
    
    // MARK: - Screen Size and Device Type Matrix
    
    func testScreenSizeCapabilityMatrix() {
        let config = getCardExpansionPlatformConfig()
        
        // Test touch target sizes based on platform
        switch Platform.current {
        case .iOS:
            XCTAssertGreaterThanOrEqual(config.minTouchTarget, 44, 
                                       "iOS should have 44pt minimum touch targets")
        case .watchOS:
            XCTAssertGreaterThanOrEqual(config.minTouchTarget, 44, 
                                       "watchOS should have 44pt minimum touch targets")
        case .macOS, .tvOS, .visionOS:
            // Non-touch platforms still need minimum sizes for accessibility
            XCTAssertGreaterThanOrEqual(config.minTouchTarget, 44, 
                                       "All platforms should have 44pt minimum targets")
        }
    }
    
    // MARK: - Vision Framework Availability Matrix
    
    func testVisionFrameworkAvailabilityMatrix() {
        let isAvailable = isVisionFrameworkAvailable()
        
        // Vision framework availability by platform
        switch Platform.current {
        case .iOS:
            if #available(iOS 11.0, *) {
                XCTAssertTrue(isAvailable, "Vision should be available on iOS 11.0+")
            } else {
                XCTAssertFalse(isAvailable, "Vision should not be available on iOS < 11.0")
            }
        case .macOS:
            if #available(macOS 10.15, *) {
                XCTAssertTrue(isAvailable, "Vision should be available on macOS 10.15+")
            } else {
                XCTAssertFalse(isAvailable, "Vision should not be available on macOS < 10.15")
            }
        case .watchOS, .tvOS, .visionOS:
            XCTAssertFalse(isAvailable, "Vision should not be available on \(Platform.current)")
        }
    }
    
    // MARK: - Performance Configuration Matrix
    
    func testPerformanceConfigurationMatrix() {
        let config = getCardExpansionPerformanceConfig()
        
        // Test performance settings are appropriate for platform
        XCTAssertGreaterThan(config.maxAnimationDuration, 0, 
                           "Animation duration should be positive")
        XCTAssertGreaterThan(config.targetFrameRate, 0, 
                           "Target frame rate should be positive")
        XCTAssertTrue(config.supportsSmoothAnimations, 
                     "Should support smooth animations")
        
        // Platform-specific performance expectations
        switch Platform.current {
        case .watchOS:
            // Watch should have faster animations
            XCTAssertLessThan(config.maxAnimationDuration, 0.5, 
                             "Watch should have fast animations")
        case .tvOS:
            // TV should have slower, more deliberate animations
            XCTAssertGreaterThan(config.maxAnimationDuration, 0.3, 
                                "TV should have slower animations")
        default:
            // Other platforms should have moderate animation speeds
            XCTAssertGreaterThan(config.maxAnimationDuration, 0.1, 
                                "Platforms should have reasonable animation speeds")
        }
    }
    
    // MARK: - Color Encoding Matrix
    
    func testColorEncodingCapabilityMatrix() {
        // Test color encoding works on all platforms
        let testColor = Color.blue
        
        do {
            let encodedData = try platformColorEncode(testColor)
            XCTAssertFalse(encodedData.isEmpty, "Color encoding should produce data")
            
            let decodedColor = try platformColorDecode(encodedData)
            XCTAssertNotNil(decodedColor, "Color decoding should work")
        } catch {
            XCTFail("Color encoding/decoding should work on all platforms: \(error)")
        }
    }
    
    // MARK: - OCR Capability Matrix
    
    func testOCRCapabilityMatrix() {
        let isOCRAvailable = isVisionOCRAvailable()
        
        // OCR availability should match Vision framework availability
        let isVisionAvailable = isVisionFrameworkAvailable()
        XCTAssertEqual(isOCRAvailable, isVisionAvailable, 
                     "OCR availability should match Vision framework availability")
    }
    
    // MARK: - CarPlay Capability Matrix
    
    func testCarPlayCapabilityMatrix() {
        // Test CarPlay support detection
        let supportsCarPlay = CarPlayCapabilityDetection.supportsCarPlay
        let isCarPlayActive = CarPlayCapabilityDetection.isCarPlayActive
        
        // CarPlay should only be supported on iOS
        switch Platform.current {
        case .iOS:
            XCTAssertTrue(supportsCarPlay, "iOS should support CarPlay")
        case .macOS, .watchOS, .tvOS, .visionOS:
            XCTAssertFalse(supportsCarPlay, "\(Platform.current) should not support CarPlay")
        }
        
        // Test CarPlay device type
        if isCarPlayActive {
            let carPlayDeviceType = CarPlayCapabilityDetection.carPlayDeviceType
            XCTAssertEqual(carPlayDeviceType, .car, "CarPlay should use car device type")
        }
        
        // Test CarPlay layout preferences
        let preferences = CarPlayCapabilityDetection.carPlayLayoutPreferences
        XCTAssertTrue(preferences.prefersLargeText, "CarPlay should prefer large text")
        XCTAssertTrue(preferences.prefersHighContrast, "CarPlay should prefer high contrast")
        XCTAssertTrue(preferences.prefersMinimalUI, "CarPlay should prefer minimal UI")
        XCTAssertTrue(preferences.supportsVoiceControl, "CarPlay should support voice control")
        XCTAssertTrue(preferences.supportsTouch, "CarPlay should support touch")
        XCTAssertTrue(preferences.supportsKnobControl, "CarPlay should support knob control")
    }
    
    func testCarPlayFeatureAvailabilityMatrix() {
        // Test all CarPlay features
        let features: [CarPlayFeature] = Array(CarPlayFeature.allCases) // Use real enum
        
        for feature in features {
            let isAvailable = CarPlayCapabilityDetection.isFeatureAvailable(feature)
            
            if CarPlayCapabilityDetection.isCarPlayActive {
                XCTAssertTrue(isAvailable, "CarPlay feature \(feature) should be available when CarPlay is active")
            } else {
                XCTAssertFalse(isAvailable, "CarPlay feature \(feature) should not be available when CarPlay is not active")
            }
        }
    }
    
    func testDeviceContextDetectionMatrix() {
        let deviceContext = DeviceContext.current
        
        // Verify we get a valid device context
        XCTAssertTrue([.standard, .carPlay, .externalDisplay, .splitView, .stageManager].contains(deviceContext),
                     "Should detect a valid device context")
        
        // Test CarPlay context detection
        if CarPlayCapabilityDetection.isCarPlayActive {
            XCTAssertEqual(deviceContext, .carPlay, "Device context should be carPlay when CarPlay is active")
        }
        
        // Test external display context detection
        #if os(iOS)
        if UIScreen.screens.count > 1 && !CarPlayCapabilityDetection.isCarPlayActive {
            XCTAssertEqual(deviceContext, .externalDisplay, "Device context should be externalDisplay when multiple screens are present")
        }
        #endif
    }
    
    func testCarPlayDeviceTypeDetectionMatrix() {
        let deviceType = DeviceType.current
        let deviceContext = DeviceContext.current
        
        // Test CarPlay device type detection
        if deviceContext == .carPlay {
            XCTAssertEqual(deviceType, .car, "Device type should be car when in CarPlay context")
        }
        
        // Test that car device type is only used for CarPlay
        if deviceType == .car {
            XCTAssertEqual(deviceContext, .carPlay, "Car device type should only be used in CarPlay context")
        }
    }
    
    func testCarPlayPlatformCapabilitiesMatrix() {
        let platformCapabilities = PlatformDeviceCapabilities.self
        
        // Test CarPlay support in platform capabilities
        let supportsCarPlay = platformCapabilities.supportsCarPlay
        let isCarPlayActive = platformCapabilities.isCarPlayActive
        let deviceContext = platformCapabilities.deviceContext
        
        // CarPlay support should match detection
        XCTAssertEqual(supportsCarPlay, CarPlayCapabilityDetection.supportsCarPlay,
                      "Platform capabilities CarPlay support should match detection")
        XCTAssertEqual(isCarPlayActive, CarPlayCapabilityDetection.isCarPlayActive,
                      "Platform capabilities CarPlay active should match detection")
        XCTAssertEqual(deviceContext, DeviceContext.current,
                      "Platform capabilities device context should match current context")
    }
    
    // MARK: - Comprehensive Platform Feature Matrix
    
    func testComprehensivePlatformFeatureMatrix() {
        let platform = Platform.current
        let deviceType = DeviceType.current
        let platformConfig = getCardExpansionPlatformConfig()
        let performanceConfig = getCardExpansionPerformanceConfig()
        
        // Create a comprehensive feature matrix
        let featureMatrix = PlatformFeatureMatrix(
            platform: platform,
            deviceType: deviceType,
            deviceContext: DeviceContext.current,
            supportsTouch: platformConfig.supportsTouch,
            supportsHover: platformConfig.supportsHover,
            supportsHapticFeedback: platformConfig.supportsHapticFeedback,
            supportsVoiceOver: platformConfig.supportsVoiceOver,
            supportsSwitchControl: platformConfig.supportsSwitchControl,
            supportsAssistiveTouch: platformConfig.supportsAssistiveTouch,
            supportsCarPlay: CarPlayCapabilityDetection.supportsCarPlay,
            isCarPlayActive: CarPlayCapabilityDetection.isCarPlayActive,
            minTouchTarget: platformConfig.minTouchTarget,
            maxAnimationDuration: performanceConfig.maxAnimationDuration,
            supportsVision: isVisionFrameworkAvailable(),
            supportsOCR: isVisionOCRAvailable()
        )
        
        // Verify feature matrix is internally consistent
        XCTAssertTrue(featureMatrix.isInternallyConsistent(), 
                     "Feature matrix should be internally consistent")
        
        // Verify platform-specific constraints
        XCTAssertTrue(featureMatrix.satisfiesPlatformConstraints(), 
                     "Feature matrix should satisfy platform constraints")
    }
}

// MARK: - Platform Feature Matrix Data Structure

struct PlatformFeatureMatrix {
    let platform: Platform
    let deviceType: DeviceType
    let deviceContext: DeviceContext
    let supportsTouch: Bool
    let supportsHover: Bool
    let supportsHapticFeedback: Bool
    let supportsVoiceOver: Bool
    let supportsSwitchControl: Bool
    let supportsAssistiveTouch: Bool
    let supportsCarPlay: Bool
    let isCarPlayActive: Bool
    let minTouchTarget: CGFloat
    let maxAnimationDuration: TimeInterval
    let supportsVision: Bool
    let supportsOCR: Bool
    
    func isInternallyConsistent() -> Bool {
        // Touch and haptic feedback should be consistent
        if supportsTouch && !supportsHapticFeedback {
            return false
        }
        
        // Hover and touch should be mutually exclusive
        if supportsHover && supportsTouch {
            return false
        }
        
        // AssistiveTouch should only be available on touch platforms
        if supportsAssistiveTouch && !supportsTouch {
            return false
        }
        
        // OCR should only be available if Vision is available
        if supportsOCR && !supportsVision {
            return false
        }
        
        // CarPlay should only be active if supported
        if isCarPlayActive && !supportsCarPlay {
            return false
        }
        
        // CarPlay should only be supported on iOS
        if supportsCarPlay && platform != .iOS {
            return false
        }
        
        // CarPlay active should only be true when device context is carPlay
        if isCarPlayActive && deviceContext != .carPlay {
            return false
        }
        
        // Car device type should only be used in CarPlay context
        if deviceType == .car && deviceContext != .carPlay {
            return false
        }
        
        return true
    }
    
    func satisfiesPlatformConstraints() -> Bool {
        switch platform {
        case .iOS:
            // iOS can support CarPlay, but CarPlay should only be active when context is carPlay
            let carPlayConstraint = !isCarPlayActive || (isCarPlayActive && deviceContext == .carPlay && deviceType == .car)
            return supportsTouch && supportsHapticFeedback && supportsAssistiveTouch && carPlayConstraint
        case .macOS:
            return supportsHover && !supportsTouch && !supportsHapticFeedback && !supportsAssistiveTouch && !supportsCarPlay && !isCarPlayActive
        case .watchOS:
            return supportsTouch && supportsHapticFeedback && supportsAssistiveTouch && !supportsCarPlay && !isCarPlayActive
        case .tvOS:
            return !supportsTouch && !supportsHover && !supportsHapticFeedback && !supportsAssistiveTouch && !supportsCarPlay && !isCarPlayActive
        case .visionOS:
            return !supportsTouch && !supportsHover && !supportsHapticFeedback && !supportsAssistiveTouch && !supportsCarPlay && !isCarPlayActive
        }
    }
}
