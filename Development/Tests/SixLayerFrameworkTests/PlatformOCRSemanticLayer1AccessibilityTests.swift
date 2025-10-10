import XCTest
import SwiftUI
import ViewInspector
@testable import SixLayerFramework

/// BUSINESS PURPOSE: Accessibility tests for PlatformOCRSemanticLayer1.swift functions
/// Ensures OCR semantic Layer 1 functions generate proper accessibility identifiers
/// for automated testing and accessibility tools compliance
final class PlatformOCRSemanticLayer1AccessibilityTests: XCTestCase {
    
    override func setUp() async throws {
        try await try await super.setUp()
        await setupTestEnvironment()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
        config.enableAutoIDs = true
        config.namespace = "SixLayer"
        config.mode = .automatic
        config.enableDebugLogging = false
    }
    
    override func tearDown() async throws {
        try await try await super.tearDown()
        await cleanupTestEnvironment()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
    }
    
    // MARK: - OCR Visual Correction Tests
    
    /// BUSINESS PURPOSE: Validates that platformOCRWithVisualCorrection_L1 generates proper accessibility identifiers
    /// for automated testing and accessibility tools compliance on iOS
    func testPlatformOCRWithVisualCorrectionL1GeneratesAccessibilityIdentifiersOnIOS() async {
        // Given
        let testImage = PlatformImage()
        let context = OCRContext(
            supportedTextTypes: [.general],
            supportedLanguages: [.english],
            processingMode: .standard,
            requiresNeuralEngine: false,
            estimatedProcessingTime: 1.0
        )
        
        let view = platformOCRWithVisualCorrection_L1(
            image: testImage,
            context: context,
            onResult: { _ in },
            onError: { _ in }
        )
        
        // When & Then
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*ocrvisualcorrection", 
            platform: .iOS,
            componentName: "platformOCRWithVisualCorrection_L1"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformOCRWithVisualCorrection_L1 should generate accessibility identifiers on iOS")
    }
    
    /// BUSINESS PURPOSE: Validates that platformOCRWithVisualCorrection_L1 generates proper accessibility identifiers
    /// for automated testing and accessibility tools compliance on macOS
    func testPlatformOCRWithVisualCorrectionL1GeneratesAccessibilityIdentifiersOnMacOS() async {
        // Given
        let testImage = PlatformImage()
        let context = OCRContext(
            supportedTextTypes: [.general],
            supportedLanguages: [.english],
            processingMode: .standard,
            requiresNeuralEngine: false,
            estimatedProcessingTime: 1.0
        )
        
        let view = platformOCRWithVisualCorrection_L1(
            image: testImage,
            context: context,
            onResult: { _ in },
            onError: { _ in }
        )
        
        // When & Then
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*ocrvisualcorrection", 
            platform: .macOS,
            componentName: "platformOCRWithVisualCorrection_L1"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformOCRWithVisualCorrection_L1 should generate accessibility identifiers on macOS")
    }
    
    /// BUSINESS PURPOSE: Validates that platformOCRWithVisualCorrection_L1 (array version) generates proper accessibility identifiers
    /// for automated testing and accessibility tools compliance on iOS
    func testPlatformOCRWithVisualCorrectionArrayL1GeneratesAccessibilityIdentifiersOnIOS() async {
        // Given
        let testImages = [PlatformImage(), PlatformImage()]
        let context = OCRContext(
            supportedTextTypes: [.general],
            supportedLanguages: [.english],
            processingMode: .standard,
            requiresNeuralEngine: false,
            estimatedProcessingTime: 1.0
        )
        
        let view = platformOCRWithVisualCorrection_L1(
            images: testImages,
            context: context,
            onResult: { _ in },
            onError: { _ in }
        )
        
        // When & Then
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*ocrvisualcorrection", 
            platform: .iOS,
            componentName: "platformOCRWithVisualCorrection_L1"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformOCRWithVisualCorrection_L1 (array) should generate accessibility identifiers on iOS")
    }
    
    /// BUSINESS PURPOSE: Validates that platformOCRWithVisualCorrection_L1 (array version) generates proper accessibility identifiers
    /// for automated testing and accessibility tools compliance on macOS
    func testPlatformOCRWithVisualCorrectionArrayL1GeneratesAccessibilityIdentifiersOnMacOS() async {
        // Given
        let testImages = [PlatformImage(), PlatformImage()]
        let context = OCRContext(
            supportedTextTypes: [.general],
            supportedLanguages: [.english],
            processingMode: .standard,
            requiresNeuralEngine: false,
            estimatedProcessingTime: 1.0
        )
        
        let view = platformOCRWithVisualCorrection_L1(
            images: testImages,
            context: context,
            onResult: { _ in },
            onError: { _ in }
        )
        
        // When & Then
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*ocrvisualcorrection", 
            platform: .macOS,
            componentName: "platformOCRWithVisualCorrection_L1"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformOCRWithVisualCorrection_L1 (array) should generate accessibility identifiers on macOS")
    }
}

// MARK: - Test Extensions
extension PlatformOCRSemanticLayer1AccessibilityTests {
    override func await setupTestEnvironment() {
        TestSetupUtilities.shared.setupTestingEnvironment()
    }
    
    override func await cleanupTestEnvironment() {
        TestSetupUtilities.shared.setupTestingEnvironment()
    }
}
