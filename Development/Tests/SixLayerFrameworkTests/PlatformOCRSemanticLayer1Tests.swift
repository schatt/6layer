import XCTest
import SwiftUI
@testable import SixLayerFramework
import ViewInspector

/// Tests for PlatformOCRSemanticLayer1.swift
/// 
/// BUSINESS PURPOSE: Ensure all OCR Layer 1 semantic functions generate proper accessibility identifiers
/// TESTING SCOPE: All functions in PlatformOCRSemanticLayer1.swift
/// METHODOLOGY: Test each function on both iOS and macOS platforms as required by mandatory testing guidelines
@MainActor
final class PlatformOCRSemanticLayer1Tests: XCTestCase {
    
    // MARK: - Test Setup
    
    override func setUp() {
        super.setUp()
        setupTestEnvironment()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
        config.enableAutoIDs = true
        config.namespace = "SixLayer"
        config.mode = .automatic
        config.enableDebugLogging = false
    }
    
    override func tearDown() {
        super.tearDown()
        cleanupTestEnvironment()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
    }
    
    // MARK: - platformOCRWithVisualCorrection_L1 Tests
    
    func testPlatformOCRWithVisualCorrectionL1GeneratesAccessibilityIdentifiersOnIOS() async {
        let testImage = PlatformImage()
        let context = OCRContext(
            textRecognitionLevel: .accurate,
            languageCorrection: true,
            customWords: []
        )
        
        let view = platformOCRWithVisualCorrection_L1(
            image: testImage,
            context: context,
            onResult: { _ in }
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*platformocrwithvisualcorrection_l1", 
            platform: .iOS,
            componentName: "platformOCRWithVisualCorrection_L1"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformOCRWithVisualCorrection_L1 should generate accessibility identifiers on iOS")
    }
    
    func testPlatformOCRWithVisualCorrectionL1GeneratesAccessibilityIdentifiersOnMacOS() async {
        let testImage = PlatformImage()
        let context = OCRContext(
            textRecognitionLevel: .accurate,
            languageCorrection: true,
            customWords: []
        )
        
        let view = platformOCRWithVisualCorrection_L1(
            image: testImage,
            context: context,
            onResult: { _ in }
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*platformocrwithvisualcorrection_l1", 
            platform: .macOS,
            componentName: "platformOCRWithVisualCorrection_L1"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformOCRWithVisualCorrection_L1 should generate accessibility identifiers on macOS")
    }
    
    // MARK: - platformExtractStructuredData_L1 Tests
    
    func testPlatformExtractStructuredDataL1GeneratesAccessibilityIdentifiersOnIOS() async {
        let testImage = PlatformImage()
        let context = OCRContext(
            textRecognitionLevel: .accurate,
            languageCorrection: true,
            customWords: []
        )
        
        let view = platformExtractStructuredData_L1(
            image: testImage,
            context: context,
            onResult: { _ in }
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*platformextractstructureddata_l1", 
            platform: .iOS,
            componentName: "platformExtractStructuredData_L1"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformExtractStructuredData_L1 should generate accessibility identifiers on iOS")
    }
    
    func testPlatformExtractStructuredDataL1GeneratesAccessibilityIdentifiersOnMacOS() async {
        let testImage = PlatformImage()
        let context = OCRContext(
            textRecognitionLevel: .accurate,
            languageCorrection: true,
            customWords: []
        )
        
        let view = platformExtractStructuredData_L1(
            image: testImage,
            context: context,
            onResult: { _ in }
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*platformextractstructureddata_l1", 
            platform: .macOS,
            componentName: "platformExtractStructuredData_L1"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformExtractStructuredData_L1 should generate accessibility identifiers on macOS")
    }
}
