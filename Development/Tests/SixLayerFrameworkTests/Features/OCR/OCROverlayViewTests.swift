import Testing


import SwiftUI
@testable import SixLayerFramework
import ViewInspector
/// Tests for OCROverlayView.swift
/// 
/// BUSINESS PURPOSE: Ensure OCROverlayView generates proper accessibility identifiers
/// TESTING SCOPE: All components in OCROverlayView.swift
/// METHODOLOGY: Test each component on both iOS and macOS platforms as required by mandatory testing guidelines
@MainActor
open class OCROverlayViewTests {
    
    // MARK: - Test Setup
    
    init() async throws {
        await setupTestEnvironment()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
        config.enableAutoIDs = true
        config.namespace = "SixLayer"
        config.mode = .automatic
        config.enableDebugLogging = false
    }    // MARK: - OCROverlayView Tests
    
    
    private func setupTestEnvironment() async {
        await AccessibilityTestUtilities.setupAccessibilityTestEnvironment()
    }
    
    private func cleanupTestEnvironment() async {
        await AccessibilityTestUtilities.cleanupAccessibilityTestEnvironment()
    }
    
@Test func testOCROverlayViewGeneratesAccessibilityIdentifiersOnIOS() async {
        let testImage = PlatformImage()
        let testResult = OCRResult(
            extractedText: "Test OCR Text",
            confidence: 0.95,
            boundingBoxes: [],
            textTypes: [:],
            processingTime: 1.0,
            language: .english
        )
        
        let view = OCROverlayView(
            image: testImage,
            result: testResult,
            configuration: OCROverlayConfiguration(),
            onTextEdit: { _, _ in },
            onTextDelete: { _ in }
        )
        
        // OCROverlayView generates "SixLayer.main.ui" pattern (correct for basic UI component)
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view, 
            expectedPattern: "SixLayer.main.ui", 
            platform: SixLayerPlatform.iOS,
            componentName: "OCROverlayView"
        )
        
        #expect(hasAccessibilityID, "OCROverlayView should generate accessibility identifiers on iOS")
    }
    
    @Test func testOCROverlayViewGeneratesAccessibilityIdentifiersOnMacOS() async {
        let testImage = PlatformImage()
        let testResult = OCRResult(
            extractedText: "Test OCR Text",
            confidence: 0.95,
            boundingBoxes: [],
            textTypes: [:],
            processingTime: 1.0,
            language: .english
        )
        
        let view = OCROverlayView(
            image: testImage,
            result: testResult,
            configuration: OCROverlayConfiguration(),
            onTextEdit: { _, _ in },
            onTextDelete: { _ in }
        )
        
        // OCROverlayView generates "SixLayer.main.ui" pattern (correct for basic UI component)
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view, 
            expectedPattern: "SixLayer.main.ui", 
            platform: SixLayerPlatform.iOS,
            componentName: "OCROverlayView"
        )
        
        #expect(hasAccessibilityID, "OCROverlayView should generate accessibility identifiers on macOS")
    }
}

