import Testing

import SwiftUI
@testable import SixLayerFramework
/// BUSINESS PURPOSE: Accessibility tests for OCRService integration
/// Tests that views using OCRService generate proper accessibility identifiers
/// OCRService itself is a service class and doesn't generate views, but views that use it should
@Suite("OCR Service Accessibility")
open class OCRServiceAccessibilityTests: BaseTestClass {
        
    // MARK: - OCRService Integration Tests
    
    /// BUSINESS PURPOSE: Validates that views using OCRService generate proper accessibility identifiers
    /// Tests OCROverlayView which uses OCRService internally
    @Test func testOCROverlayViewWithOCRServiceGeneratesAccessibilityIdentifiersOnIOS() {
        runWithTaskLocalConfig {
            // Given: OCROverlayView that uses OCRService internally
            let testImage = PlatformImage()
            let testResult = OCRResult(
                extractedText: "Test OCR Text",
                confidence: 0.95,
                boundingBoxes: [],
                textTypes: [:],
                processingTime: 1.0,
                language: .english
            )
            
            // When: Creating OCROverlayView (which uses OCRService)
            let view = OCROverlayView(
                image: testImage,
                result: testResult,
                configuration: OCROverlayConfiguration(),
                onTextEdit: { _, _ in },
                onTextDelete: { _ in }
            )
            
            // Then: Should generate accessibility identifiers
            let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
                view,
                expectedPattern: "SixLayer.main.ui.*OCROverlayView.*",
                platform: SixLayerPlatform.iOS,
                componentName: "OCROverlayView"
            )
            
            #expect(hasAccessibilityID, "OCROverlayView (using OCRService) should generate accessibility identifiers on iOS")
        }
    }
    
    /// BUSINESS PURPOSE: Validates that views using OCRService generate proper accessibility identifiers
    /// Tests OCROverlayView which uses OCRService internally
    @Test func testOCROverlayViewWithOCRServiceGeneratesAccessibilityIdentifiersOnMacOS() {
        runWithTaskLocalConfig {
            // Given: OCROverlayView that uses OCRService internally
            let testImage = PlatformImage()
            let testResult = OCRResult(
                extractedText: "Test OCR Text",
                confidence: 0.95,
                boundingBoxes: [],
                textTypes: [:],
                processingTime: 1.0,
                language: .english
            )
            
            // When: Creating OCROverlayView (which uses OCRService)
            let view = OCROverlayView(
                image: testImage,
                result: testResult,
                configuration: OCROverlayConfiguration(),
                onTextEdit: { _, _ in },
                onTextDelete: { _ in }
            )
            
            // Then: Should generate accessibility identifiers
            let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
                view,
                expectedPattern: "SixLayer.main.ui.*OCROverlayView.*",
                platform: SixLayerPlatform.macOS,
                componentName: "OCROverlayView"
            )
            
            #expect(hasAccessibilityID, "OCROverlayView (using OCRService) should generate accessibility identifiers on macOS")
        }
    }
    
}
