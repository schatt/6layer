import Testing


import SwiftUI
@testable import SixLayerFramework
import ViewInspector
/// Tests for OCROverlayView.swift
/// 
/// BUSINESS PURPOSE: Ensure OCROverlayView generates proper accessibility identifiers
/// TESTING SCOPE: All components in OCROverlayView.swift
/// METHODOLOGY: Test each component on both iOS and macOS platforms as required by mandatory testing guidelines
@Suite("OCR Overlay View")
@MainActor
open class OCROverlayViewTests: BaseTestClass {
    
    // MARK: - OCROverlayView Tests
    // BaseTestClass.init() handles setupTestEnvironment() automatically
    
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
        
        // OCROverlayView generates "SixLayer.main.ui.*OCROverlayView.*" pattern (with component name)
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view, 
            expectedPattern: "SixLayer.main.ui.*OCROverlayView.*", 
            platform: SixLayerPlatform.iOS,
            componentName: "OCROverlayView"
        )
        
        #expect(hasAccessibilityID, "OCROverlayView should generate accessibility identifiers with component name on iOS")
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
        
        // OCROverlayView generates "SixLayer.main.ui.*OCROverlayView.*" pattern (with component name)
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view, 
            expectedPattern: "SixLayer.main.ui.*OCROverlayView.*", 
            platform: SixLayerPlatform.macOS,
            componentName: "OCROverlayView"
        )
        
        #expect(hasAccessibilityID, "OCROverlayView should generate accessibility identifiers with component name on macOS")
    }
}

