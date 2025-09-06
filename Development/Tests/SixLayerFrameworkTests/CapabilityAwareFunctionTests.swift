import XCTest
import SwiftUI
@testable import SixLayerFramework

/// Capability-aware function testing
/// Tests every function that depends on capabilities in both enabled and disabled states
@MainActor
final class CapabilityAwareFunctionTests: XCTestCase {
    
    // MARK: - Touch-Dependent Function Tests
    
    func testTouchDependentFunctions() {
        let config = getCardExpansionPlatformConfig()
        let supportsTouch = config.supportsTouch
        
        if supportsTouch {
            // Test touch functions work when touch is supported
            testTouchFunctionsEnabled()
        } else {
            // Test touch functions handle disabled state gracefully
            testTouchFunctionsDisabled()
        }
    }
    
    private func testTouchFunctionsEnabled() {
        // Test that touch-related functions work correctly when touch is supported
        let config = getCardExpansionPlatformConfig()
        
        // Touch targets should be appropriate size
        XCTAssertGreaterThanOrEqual(config.minTouchTarget, 44, 
                                   "Touch targets should be adequate when touch is supported")
        
        // Haptic feedback should be available
        XCTAssertTrue(config.supportsHapticFeedback, 
                     "Haptic feedback should be available when touch is supported")
        
        // AssistiveTouch should be available
        XCTAssertTrue(config.supportsAssistiveTouch, 
                     "AssistiveTouch should be available when touch is supported")
    }
    
    private func testTouchFunctionsDisabled() {
        // Test that touch-related functions handle disabled state gracefully
        let config = getCardExpansionPlatformConfig()
        
        // Touch should not be supported
        XCTAssertFalse(config.supportsTouch, 
                      "Touch should not be supported when disabled")
        
        // Haptic feedback should not be available
        XCTAssertFalse(config.supportsHapticFeedback, 
                      "Haptic feedback should not be available when touch is disabled")
        
        // AssistiveTouch should not be available
        XCTAssertFalse(config.supportsAssistiveTouch, 
                      "AssistiveTouch should not be available when touch is disabled")
        
        // Touch targets should still be reasonable for accessibility
        XCTAssertGreaterThanOrEqual(config.minTouchTarget, 44, 
                                   "Touch targets should still be adequate for accessibility")
    }
    
    // MARK: - Hover-Dependent Function Tests
    
    func testHoverDependentFunctions() {
        let config = getCardExpansionPlatformConfig()
        let supportsHover = config.supportsHover
        
        if supportsHover {
            testHoverFunctionsEnabled()
        } else {
            testHoverFunctionsDisabled()
        }
    }
    
    private func testHoverFunctionsEnabled() {
        let config = getCardExpansionPlatformConfig()
        
        // Hover should be supported
        XCTAssertTrue(config.supportsHover, 
                     "Hover should be supported when enabled")
        
        // Hover delay should be appropriate
        XCTAssertGreaterThanOrEqual(config.hoverDelay, 0, 
                                   "Hover delay should be set when hover is supported")
        
        // Touch should not be supported (mutually exclusive)
        XCTAssertFalse(config.supportsTouch, 
                      "Touch should not be supported when hover is enabled")
    }
    
    private func testHoverFunctionsDisabled() {
        let config = getCardExpansionPlatformConfig()
        
        // Hover should not be supported
        XCTAssertFalse(config.supportsHover, 
                      "Hover should not be supported when disabled")
        
        // Hover delay should be zero
        XCTAssertEqual(config.hoverDelay, 0, 
                      "Hover delay should be zero when hover is disabled")
    }
    
    // MARK: - Vision Framework-Dependent Function Tests
    
    func testVisionFrameworkDependentFunctions() {
        let supportsVision = isVisionFrameworkAvailable()
        
        if supportsVision {
            testVisionFunctionsEnabled()
        } else {
            testVisionFunctionsDisabled()
        }
    }
    
    private func testVisionFunctionsEnabled() {
        // Vision framework should be available
        XCTAssertTrue(isVisionFrameworkAvailable(), 
                     "Vision framework should be available when enabled")
        
        // OCR should be available
        XCTAssertTrue(isVisionOCRAvailable(), 
                     "OCR should be available when Vision framework is enabled")
        
        // Vision functions should not crash
        let testImage = PlatformImage()
        let context = OCRContext(
            textTypes: [.general],
            language: .english,
            confidenceThreshold: 0.8
        )
        let strategy = OCRStrategy(
            supportedTextTypes: [.general],
            supportedLanguages: [.english],
            processingMode: .standard
        )
        
        // Test that Vision functions can be called without crashing
        _ = safePlatformOCRImplementation_L4(
            image: testImage,
            context: context,
            strategy: strategy,
            onResult: { _ in },
            onError: { _ in }
        )
    }
    
    private func testVisionFunctionsDisabled() {
        // Vision framework should not be available
        XCTAssertFalse(isVisionFrameworkAvailable(), 
                      "Vision framework should not be available when disabled")
        
        // OCR should not be available
        XCTAssertFalse(isVisionOCRAvailable(), 
                      "OCR should not be available when Vision framework is disabled")
        
        // Vision functions should still be callable but return fallback behavior
        let testImage = PlatformImage()
        let context = OCRContext(
            textTypes: [.general],
            language: .english,
            confidenceThreshold: 0.8
        )
        let strategy = OCRStrategy(
            supportedTextTypes: [.general],
            supportedLanguages: [.english],
            processingMode: .standard
        )
        
        // Test that Vision functions handle disabled state gracefully
        _ = safePlatformOCRImplementation_L4(
            image: testImage,
            context: context,
            strategy: strategy,
            onResult: { result in
                // Should provide fallback result when Vision is disabled
                XCTAssertNotNil(result, "Should provide fallback result when Vision is disabled")
            },
            onError: { error in
                // Should handle error gracefully when Vision is disabled
                XCTAssertNotNil(error, "Should handle error gracefully when Vision is disabled")
            }
        )
    }
    
    // MARK: - Accessibility-Dependent Function Tests
    
    func testAccessibilityDependentFunctions() {
        // Test accessibility functions that are available
        let accessibilityManager = AccessibilityOptimizationManager()
        
        // Test that accessibility manager can be created
        XCTAssertNotNil(accessibilityManager, "Accessibility manager should be created")
        
        // Test that accessibility manager has expected properties
        XCTAssertNotNil(accessibilityManager.complianceMetrics, "Compliance metrics should be available")
        XCTAssertNotNil(accessibilityManager.recommendations, "Recommendations should be available")
        XCTAssertNotNil(accessibilityManager.auditHistory, "Audit history should be available")
        XCTAssertNotNil(accessibilityManager.accessibilityLevel, "Accessibility level should be available")
    }
    
    // MARK: - Color Encoding-Dependent Function Tests
    
    func testColorEncodingDependentFunctions() {
        // Color encoding should work on all platforms
        testColorEncodingFunctionsEnabled()
    }
    
    private func testColorEncodingFunctionsEnabled() {
        // Color encoding should work on all platforms
        let testColor = Color.blue
        
        do {
            let encodedData = try platformColorEncode(testColor)
            XCTAssertFalse(encodedData.isEmpty, "Color encoding should work on all platforms")
            
            let decodedColor = try platformColorDecode(encodedData)
            XCTAssertNotNil(decodedColor, "Color decoding should work on all platforms")
        } catch {
            XCTFail("Color encoding/decoding should work on all platforms: \(error)")
        }
    }
    
    // MARK: - Comprehensive Capability-Aware Testing
    
    func testAllCapabilityDependentFunctions() {
        // Test all capability-dependent functions
        testTouchDependentFunctions()
        testHoverDependentFunctions()
        testVisionFrameworkDependentFunctions()
        testAccessibilityDependentFunctions()
        testColorEncodingDependentFunctions()
    }
    
    // MARK: - Capability State Validation
    
    func testCapabilityStateConsistency() {
        let platform = Platform.current
        let config = getCardExpansionPlatformConfig()
        
        // Test that all capability states are consistent
        let capabilities = [
            "Touch": config.supportsTouch,
            "Hover": config.supportsHover,
            "Haptic": config.supportsHapticFeedback,
            "AssistiveTouch": config.supportsAssistiveTouch,
            "VoiceOver": config.supportsVoiceOver,
            "SwitchControl": config.supportsSwitchControl,
            "Vision": isVisionFrameworkAvailable(),
            "OCR": isVisionOCRAvailable()
        ]
        
        // Validate capability consistency
        for (capability, isSupported) in capabilities {
            print("🔍 \(platform): \(capability) = \(isSupported ? "✅" : "❌")")
        }
        
        // Test that the capability state is internally consistent
        XCTAssertTrue(validateCapabilityStateConsistency(capabilities), 
                     "Capability state should be internally consistent")
    }
    
    private func validateCapabilityStateConsistency(_ capabilities: [String: Bool]) -> Bool {
        // Touch and haptic should be consistent
        if capabilities["Touch"] == true && capabilities["Haptic"] != true {
            return false
        }
        
        // AssistiveTouch should only be available on touch platforms
        if capabilities["AssistiveTouch"] == true && capabilities["Touch"] != true {
            return false
        }
        
        // OCR should only be available if Vision is available
        if capabilities["OCR"] == true && capabilities["Vision"] != true {
            return false
        }
        
        return true
    }
}
