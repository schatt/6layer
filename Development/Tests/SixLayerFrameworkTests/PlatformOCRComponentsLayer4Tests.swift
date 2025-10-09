import XCTest
import SwiftUI
@testable import SixLayerFramework
import ViewInspector

/// Tests for PlatformOCRComponentsLayer4.swift
/// 
/// BUSINESS PURPOSE: Ensure all OCR Layer 4 components generate proper accessibility identifiers
/// TESTING SCOPE: All components in PlatformOCRComponentsLayer4.swift
/// METHODOLOGY: Test each component on both iOS and macOS platforms as required by mandatory testing guidelines
@MainActor
final class PlatformOCRComponentsLayer4Tests: XCTestCase {
    
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
    
    // MARK: - OCRWithVisualCorrectionWrapper Tests
    
    func testOCRWithVisualCorrectionWrapperGeneratesAccessibilityIdentifiersOnIOS() async {
        let testImage = PlatformImage()
        let context = OCRContext(
            textRecognitionLevel: .accurate,
            languageCorrection: true,
            customWords: []
        )
        
        let view = OCRWithVisualCorrectionWrapper(
            image: testImage,
            context: context,
            onResult: { _ in }
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*ocrwithvisualcorrectionwrapper", 
            platform: .iOS,
            componentName: "OCRWithVisualCorrectionWrapper"
        )
        
        XCTAssertTrue(hasAccessibilityID, "OCRWithVisualCorrectionWrapper should generate accessibility identifiers on iOS")
    }
    
    func testOCRWithVisualCorrectionWrapperGeneratesAccessibilityIdentifiersOnMacOS() async {
        let testImage = PlatformImage()
        let context = OCRContext(
            textRecognitionLevel: .accurate,
            languageCorrection: true,
            customWords: []
        )
        
        let view = OCRWithVisualCorrectionWrapper(
            image: testImage,
            context: context,
            onResult: { _ in }
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*ocrwithvisualcorrectionwrapper", 
            platform: .macOS,
            componentName: "OCRWithVisualCorrectionWrapper"
        )
        
        XCTAssertTrue(hasAccessibilityID, "OCRWithVisualCorrectionWrapper should generate accessibility identifiers on macOS")
    }
    
    // MARK: - StructuredDataExtractionWrapper Tests
    
    func testStructuredDataExtractionWrapperGeneratesAccessibilityIdentifiersOnIOS() async {
        let testImage = PlatformImage()
        let context = OCRContext(
            textRecognitionLevel: .accurate,
            languageCorrection: true,
            customWords: []
        )
        
        let view = StructuredDataExtractionWrapper(
            image: testImage,
            context: context,
            onResult: { _ in }
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*structureddataextractionwrapper", 
            platform: .iOS,
            componentName: "StructuredDataExtractionWrapper"
        )
        
        XCTAssertTrue(hasAccessibilityID, "StructuredDataExtractionWrapper should generate accessibility identifiers on iOS")
    }
    
    func testStructuredDataExtractionWrapperGeneratesAccessibilityIdentifiersOnMacOS() async {
        let testImage = PlatformImage()
        let context = OCRContext(
            textRecognitionLevel: .accurate,
            languageCorrection: true,
            customWords: []
        )
        
        let view = StructuredDataExtractionWrapper(
            image: testImage,
            context: context,
            onResult: { _ in }
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*structureddataextractionwrapper", 
            platform: .macOS,
            componentName: "StructuredDataExtractionWrapper"
        )
        
        XCTAssertTrue(hasAccessibilityID, "StructuredDataExtractionWrapper should generate accessibility identifiers on macOS")
    }
}

