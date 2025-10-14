import Testing
import SwiftUI
import ViewInspector
@testable import SixLayerFramework

/// BUSINESS PURPOSE: Accessibility tests for PlatformOCRSemanticLayer1.swift functions
/// Ensures OCR semantic Layer 1 functions generate proper accessibility identifiers
/// for automated testing and accessibility tools compliance
final class PlatformOCRSemanticLayer1AccessibilityTests {
    
    init() async throws {
        try await super.setUp()
        await setupTestEnvironment()
        await MainActor.run {
            let config = AccessibilityIdentifierConfig.shared
            config.resetToDefaults()
            config.enableAutoIDs = true
            config.namespace = "SixLayer"
            config.mode = .automatic
            config.enableDebugLogging = false
        }
    }
    
    deinit {
        try await super.tearDown()
        await cleanupTestEnvironment()
        await MainActor.run {
            let config = AccessibilityIdentifierConfig.shared
            config.resetToDefaults()
        }
    }
    
    // MARK: - OCR Visual Correction Tests
    
    /// BUSINESS PURPOSE: Validates that platformOCRWithVisualCorrection_L1 generates proper accessibility identifiers
    /// for automated testing and accessibility tools compliance on iOS
    @Test func testPlatformOCRWithVisualCorrectionL1GeneratesAccessibilityIdentifiersOnIOS() async {
        // Given
        let testImage = PlatformImage()
        let context = OCRContext(
            textTypes: [TextType.general],
            language: OCRLanguage.english
        )
        
        let view = platformOCRWithVisualCorrection_L1(
            image: testImage,
            context: context,
            onResult: { _ in }
        )
        
        // When & Then
        let hasAccessibilityID = await MainActor.run {
            hasAccessibilityIdentifier(
                view, 
                expectedPattern: "SixLayer.main.element.*", 
                platform: .iOS,
                componentName: "platformOCRWithVisualCorrection_L1"
            )
        }
        
        #expect(hasAccessibilityID, "platformOCRWithVisualCorrection_L1 should generate accessibility identifiers on iOS")
    }
    
    /// BUSINESS PURPOSE: Validates that platformOCRWithVisualCorrection_L1 generates proper accessibility identifiers
    /// for automated testing and accessibility tools compliance on macOS
    @Test func testPlatformOCRWithVisualCorrectionL1GeneratesAccessibilityIdentifiersOnMacOS() async {
        // Given
        let testImage = PlatformImage()
        let context = OCRContext(
            textTypes: [TextType.general],
            language: OCRLanguage.english
        )
        
        let view = platformOCRWithVisualCorrection_L1(
            image: testImage,
            context: context,
            onResult: { _ in }
        )
        
        // When & Then
        let hasAccessibilityID = await MainActor.run {
            hasAccessibilityIdentifier(
                view, 
                expectedPattern: "SixLayer.main.element.*", 
                platform: .macOS,
                componentName: "platformOCRWithVisualCorrection_L1"
            )
        }
        
        #expect(hasAccessibilityID, "platformOCRWithVisualCorrection_L1 should generate accessibility identifiers on macOS")
    }
    
    /// BUSINESS PURPOSE: Validates that platformOCRWithVisualCorrection_L1 (array version) generates proper accessibility identifiers
    /// for automated testing and accessibility tools compliance on iOS
    @Test func testPlatformOCRWithVisualCorrectionArrayL1GeneratesAccessibilityIdentifiersOnIOS() async {
        // Given
        let testImage = PlatformImage()
        let context = OCRContext(
            textTypes: [TextType.general],
            language: OCRLanguage.english
        )
        
        let view = platformOCRWithVisualCorrection_L1(
            image: testImage,
            context: context,
            onResult: { _ in }
        )
        
        // When & Then
        let hasAccessibilityID = await MainActor.run {
            hasAccessibilityIdentifier(
                view, 
                expectedPattern: "SixLayer.main.element.*", 
                platform: .iOS,
                componentName: "platformOCRWithVisualCorrection_L1"
            )
        }
        
        #expect(hasAccessibilityID, "platformOCRWithVisualCorrection_L1 (array) should generate accessibility identifiers on iOS")
    }
    
    /// BUSINESS PURPOSE: Validates that platformOCRWithVisualCorrection_L1 (array version) generates proper accessibility identifiers
    /// for automated testing and accessibility tools compliance on macOS
    @Test func testPlatformOCRWithVisualCorrectionArrayL1GeneratesAccessibilityIdentifiersOnMacOS() async {
        // Given
        let testImage = PlatformImage()
        let context = OCRContext(
            textTypes: [TextType.general],
            language: OCRLanguage.english
        )
        
        let view = platformOCRWithVisualCorrection_L1(
            image: testImage,
            context: context,
            onResult: { _ in }
        )
        
        // When & Then
        let hasAccessibilityID = await MainActor.run {
            hasAccessibilityIdentifier(
                view, 
                expectedPattern: "SixLayer.main.element.*", 
                platform: .macOS,
                componentName: "platformOCRWithVisualCorrection_L1"
            )
        }
        
        #expect(hasAccessibilityID, "platformOCRWithVisualCorrection_L1 (array) should generate accessibility identifiers on macOS")
    }
}
