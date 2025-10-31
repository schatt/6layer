import Testing


import SwiftUI
@testable import SixLayerFramework
import ViewInspector
/// Tests for PlatformOCRSemanticLayer1.swift
/// 
/// BUSINESS PURPOSE: Ensure all OCR Layer 1 semantic functions generate proper accessibility identifiers
/// TESTING SCOPE: All functions in PlatformOCRSemanticLayer1.swift
/// METHODOLOGY: Test each function on both iOS and macOS platforms as required by mandatory testing guidelines
@Suite("Platform O C R Semantic Layer")
@MainActor
open class PlatformOCRSemanticLayer1Tests {
    
    // MARK: - Test Setup
    
    init() async throws {
        await setupTestEnvironment()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
        config.enableAutoIDs = true
        config.namespace = "SixLayer"
        config.mode = .automatic
        config.enableDebugLogging = false
    }    // MARK: - platformOCRWithVisualCorrection_L1 Tests
    
    
    private func setupTestEnvironment() async {
        await AccessibilityTestUtilities.setupAccessibilityTestEnvironment()
    }
    
    private func cleanupTestEnvironment() async {
        await AccessibilityTestUtilities.cleanupAccessibilityTestEnvironment()
    }
    
@Test func testPlatformOCRWithVisualCorrectionL1GeneratesAccessibilityIdentifiersOnIOS() async {
        let testImage = PlatformImage()
        let context = OCRContext(
            textTypes: [.general],
            language: .english,
            confidenceThreshold: 0.8,
            allowsEditing: true
        )
        
        let view = platformOCRWithVisualCorrection_L1(
            image: testImage,
            context: context,
            onResult: { _ in }
        )
        
        let hasAccessibilityID = testAccessibilityIdentifiersCrossPlatform(
            view, 
                expectedPattern: "SixLayer.*ui", 
            componentName: "platformOCRWithVisualCorrection_L1",
            testName: "PlatformTest"
        )
        
        #expect(hasAccessibilityID, "platformOCRWithVisualCorrection_L1 should generate accessibility identifiers on iOS")
    }
    
    @Test func testPlatformOCRWithVisualCorrectionL1GeneratesAccessibilityIdentifiersOnMacOS() async {
        let testImage = PlatformImage()
        let context = OCRContext(
            textTypes: [.general],
            language: .english,
            confidenceThreshold: 0.8,
            allowsEditing: true
        )
        
        let view = platformOCRWithVisualCorrection_L1(
            image: testImage,
            context: context,
            onResult: { _ in }
        )
        
        let hasAccessibilityID = testAccessibilityIdentifiersCrossPlatform(
            view, 
                expectedPattern: "SixLayer.*ui", 
            componentName: "platformOCRWithVisualCorrection_L1",
            testName: "PlatformTest"
        )
        
        #expect(hasAccessibilityID, "platformOCRWithVisualCorrection_L1 should generate accessibility identifiers on macOS")
    }
    
    // MARK: - platformExtractStructuredData_L1 Tests
    
    @Test func testPlatformExtractStructuredDataL1GeneratesAccessibilityIdentifiersOnIOS() async {
        let testImage = PlatformImage()
        let context = OCRContext(
            textTypes: [.general],
            language: .english,
            confidenceThreshold: 0.8,
            allowsEditing: true
        )
        
        let view = platformExtractStructuredData_L1(
            image: testImage,
            context: context,
            onResult: { _ in }
        )
        
        let hasAccessibilityID = testAccessibilityIdentifiersCrossPlatform(
            view, 
                expectedPattern: "SixLayer.*ui", 
            componentName: "platformExtractStructuredData_L1",
            testName: "PlatformTest"
        )
        
        #expect(hasAccessibilityID, "platformExtractStructuredData_L1 should generate accessibility identifiers on iOS")
    }
    
    @Test func testPlatformExtractStructuredDataL1GeneratesAccessibilityIdentifiersOnMacOS() async {
        let testImage = PlatformImage()
        let context = OCRContext(
            textTypes: [.general],
            language: .english,
            confidenceThreshold: 0.8,
            allowsEditing: true
        )
        
        let view = platformExtractStructuredData_L1(
            image: testImage,
            context: context,
            onResult: { _ in }
        )
        
        let hasAccessibilityID = testAccessibilityIdentifiersCrossPlatform(
            view, 
                expectedPattern: "SixLayer.*ui", 
            componentName: "platformExtractStructuredData_L1",
            testName: "PlatformTest"
        )
        
        #expect(hasAccessibilityID, "platformExtractStructuredData_L1 should generate accessibility identifiers on macOS")
    }
}
