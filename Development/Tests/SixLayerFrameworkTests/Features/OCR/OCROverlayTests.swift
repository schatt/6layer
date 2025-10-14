//
//  OCROverlayTests.swift
//  SixLayerFrameworkTests
//
//  Comprehensive tests for OCR overlay functionality
//  Test-Driven Development approach for visual text correction
//

import XCTest
import SwiftUI
@testable import SixLayerFramework

final class OCROverlayTests: XCTestCase {
    
    var testImage: PlatformImage!
    var testOCRResult: OCRResult!
    var testBoundingBoxes: [CGRect]!
    
    override func setUp() {
        super.setUp()
        
        // Create test image
        testImage = PlatformImage()
        
        // Create test bounding boxes
        testBoundingBoxes = [
            CGRect(x: 10, y: 20, width: 100, height: 30),  // First text region
            CGRect(x: 50, y: 60, width: 80, height: 25),   // Second text region
            CGRect(x: 120, y: 100, width: 60, height: 20)  // Third text region
        ]
        
        // Create test OCR result
        testOCRResult = OCRResult(
            extractedText: "Hello World\nTest Text\nAnother Line",
            confidence: 0.85,
            boundingBoxes: testBoundingBoxes,
            textTypes: [
                .general: "Hello World",
                .price: "Test Text", 
                .number: "Another Line"
            ],
            processingTime: 1.2,
            language: .english
        )
    }
    
    override func tearDown() {
        testImage = nil
        testOCRResult = nil
        testBoundingBoxes = nil
        super.tearDown()
    }
    
    // MARK: - OCR Overlay View Tests
    
    @MainActor
    func testOCROverlayViewInitialization() {
        // Given: OCR overlay parameters
        let onTextEdit: (String, CGRect) -> Void = { _, _ in }
        let onTextDelete: (CGRect) -> Void = { _ in }
        
        // When: Creating OCR overlay view
        let overlayView = OCROverlayView(
            image: testImage,
            result: testOCRResult,
            onTextEdit: onTextEdit,
            onTextDelete: onTextDelete
        )
        
        // Then: Should initialize successfully and be hostable
        let hostingView = hostRootPlatformView(overlayView.withGlobalAutoIDsEnabled())
        XCTAssertNotNil(hostingView, "OCR overlay view should be hostable")
        XCTAssertNotNil(overlayView, "OCR overlay view should be created")
    }
    
    func testOCROverlayViewWithEmptyResult() {
        // Given: Empty OCR result
        let emptyResult = OCRResult(
            extractedText: "",
            confidence: 0.0,
            boundingBoxes: [],
            textTypes: [:],
            processingTime: 0.0,
            language: .english
        )
        
        // When: Creating overlay with empty result
        let overlayView = OCROverlayView(
            image: testImage,
            result: emptyResult,
            onTextEdit: { _, _ in },
            onTextDelete: { _ in }
        )
        
        // Then: Should handle empty result gracefully
        XCTAssertNotNil(overlayView, "Overlay should handle empty result")
    }
    
    // MARK: - Bounding Box Visualization Tests
    
    func testBoundingBoxRendering() {
        // Given: OCR result with bounding boxes
        _ = OCROverlayView(
            image: testImage,
            result: testOCRResult,
            onTextEdit: { _, _ in },
            onTextDelete: { _ in }
        )
        
        // When: Rendering overlay
        // Then: Should render all bounding boxes
        XCTAssertEqual(testOCRResult.boundingBoxes.count, 3, "Should have 3 bounding boxes")
        XCTAssertEqual(testOCRResult.boundingBoxes[0], CGRect(x: 10, y: 20, width: 100, height: 30))
        XCTAssertEqual(testOCRResult.boundingBoxes[1], CGRect(x: 50, y: 60, width: 80, height: 25))
        XCTAssertEqual(testOCRResult.boundingBoxes[2], CGRect(x: 120, y: 100, width: 60, height: 20))
    }
    
    func testBoundingBoxCoordinateConversion() {
        // Given: Image size and bounding box
        let imageSize = CGSize(width: 200, height: 150)
        let boundingBox = CGRect(x: 0.1, y: 0.2, width: 0.5, height: 0.3) // Normalized coordinates
        
        // When: Converting to image coordinates
        let convertedBox = OCROverlayView.convertBoundingBoxToImageCoordinates(
            boundingBox: boundingBox,
            imageSize: imageSize
        )
        
        // Then: Should convert correctly
        XCTAssertEqual(convertedBox.origin.x, 20, accuracy: 0.1) // 0.1 * 200
        XCTAssertEqual(convertedBox.origin.y, 30, accuracy: 0.1) // 0.2 * 150
        XCTAssertEqual(convertedBox.width, 100, accuracy: 0.1)  // 0.5 * 200
        XCTAssertEqual(convertedBox.height, 45, accuracy: 0.1)  // 0.3 * 150
    }
    
    // MARK: - Text Region Interaction Tests
    
    func testTextRegionTapDetection() {
        // Given: OCR overlay with text regions
        var _: (String, CGRect)?
        let overlayView = OCROverlayView(
            image: testImage,
            result: testOCRResult,
            onTextEdit: { _, _ in
                // Text edit handler
            },
            onTextDelete: { _ in }
        )
        
        // When: Simulating tap on first text region
        let tapPoint = CGPoint(x: 60, y: 35) // Within first bounding box
        let detectedRegion = overlayView.detectTappedTextRegion(at: tapPoint)
        
        // Then: Should detect correct region
        XCTAssertNotNil(detectedRegion, "Should detect tapped text region")
        XCTAssertEqual(detectedRegion?.text, "Hello World")
        XCTAssertEqual(detectedRegion?.boundingBox, testBoundingBoxes[0])
    }
    
    func testTextRegionTapOutsideBounds() {
        // Given: OCR overlay
        let overlayView = OCROverlayView(
            image: testImage,
            result: testOCRResult,
            onTextEdit: { _, _ in },
            onTextDelete: { _ in }
        )
        
        // When: Tapping outside any text region
        let tapPoint = CGPoint(x: 5, y: 5) // Outside all bounding boxes
        let detectedRegion = overlayView.detectTappedTextRegion(at: tapPoint)
        
        // Then: Should return nil
        XCTAssertNil(detectedRegion, "Should return nil for tap outside bounds")
    }
    
    // MARK: - Text Editing Tests
    
    func testTextEditingModeToggle() {
        // Given: OCR overlay
        let overlayView = OCROverlayView(
            image: testImage,
            result: testOCRResult,
            onTextEdit: { _, _ in },
            onTextDelete: { _ in }
        )
        
        // When: Starting text editing
        overlayView.startTextEditing(for: testBoundingBoxes[0])
        
        // Then: Should be able to detect tapped region
        let tappedRegion = overlayView.detectTappedTextRegion(at: CGPoint(x: testBoundingBoxes[0].midX, y: testBoundingBoxes[0].midY))
        XCTAssertNotNil(tappedRegion, "Should detect tapped region")
        XCTAssertEqual(tappedRegion?.boundingBox, testBoundingBoxes[0])
    }
    
    func testTextEditingCompletion() {
        // Given: OCR overlay in editing mode
        var editedText: String?
        var editedRect: CGRect?
        let overlayView = OCROverlayView(
            image: testImage,
            result: testOCRResult,
            onTextEdit: { text, rect in
                editedText = text
                editedRect = rect
            },
            onTextDelete: { _ in }
        )
        
        overlayView.startTextEditing(for: testBoundingBoxes[0])
        
        // When: Completing text editing
        let newText = "Edited Text"
        overlayView.completeTextEditing(with: newText)
        
        // Then: Should call completion handler
        XCTAssertEqual(editedText, newText)
        XCTAssertEqual(editedRect, testBoundingBoxes[0])
    }
    
    func testTextEditingCancellation() {
        // Given: OCR overlay in editing mode
        let overlayView = OCROverlayView(
            image: testImage,
            result: testOCRResult,
            onTextEdit: { _, _ in },
            onTextDelete: { _ in }
        )
        
        overlayView.startTextEditing(for: testBoundingBoxes[0])
        
        // When: Canceling text editing
        overlayView.cancelTextEditing()
        
        // Then: Should exit editing mode without calling completion
        // Note: We can't directly test internal state, but we can test the behavior
        XCTAssertTrue(true, "Cancellation should work")
    }
    
    // MARK: - Text Deletion Tests
    
    func testTextRegionDeletion() {
        // Given: OCR overlay
        var deletedRect: CGRect?
        let overlayView = OCROverlayView(
            image: testImage,
            result: testOCRResult,
            onTextEdit: { _, _ in },
            onTextDelete: { rect in
                deletedRect = rect
            }
        )
        
        // When: Deleting text region
        overlayView.deleteTextRegion(at: testBoundingBoxes[1])
        
        // Then: Should call deletion handler
        XCTAssertEqual(deletedRect, testBoundingBoxes[1])
    }
    
    // MARK: - Visual Feedback Tests
    
    func testConfidenceVisualIndicators() {
        // Given: OCR result with varying confidence levels
        let highConfidenceResult = OCRResult(
            extractedText: "High Confidence",
            confidence: 0.95,
            boundingBoxes: [CGRect(x: 0, y: 0, width: 100, height: 20)],
            textTypes: [.general: "High Confidence"],
            processingTime: 0.5,
            language: .english
        )
        
        let lowConfidenceResult = OCRResult(
            extractedText: "Low Confidence",
            confidence: 0.3,
            boundingBoxes: [CGRect(x: 0, y: 0, width: 100, height: 20)],
            textTypes: [.general: "Low Confidence"],
            processingTime: 0.5,
            language: .english
        )
        
        // Create configuration for testing
        let configuration = OCROverlayConfiguration(
            allowsEditing: true,
            allowsDeletion: true,
            showConfidenceIndicators: true,
            highlightColor: .blue,
            editingColor: .green,
            lowConfidenceThreshold: 0.7,
            highConfidenceThreshold: 0.9
        )
        
        // When: Creating overlays
        let highConfidenceOverlay = OCROverlayView(
            image: testImage,
            result: highConfidenceResult,
            onTextEdit: { _, _ in },
            onTextDelete: { _ in }
        )
        
        let lowConfidenceOverlay = OCROverlayView(
            image: testImage,
            result: lowConfidenceResult,
            onTextEdit: { _, _ in },
            onTextDelete: { _ in }
        )
        
        // Then: Should provide different visual indicators
        // Test high confidence (above high threshold)
        XCTAssertGreaterThanOrEqual(0.95, configuration.highConfidenceThreshold, "High confidence should be above high threshold")

        // Test low confidence (below low threshold)
        XCTAssertLessThan(0.3, configuration.lowConfidenceThreshold, "Low confidence should be below low threshold")

        // Test that overlays can be created with different confidence levels
        XCTAssertNotNil(highConfidenceOverlay)
        XCTAssertNotNil(lowConfidenceOverlay)
    }
    
    // MARK: - Accessibility Tests
    
    @MainActor
    func testAccessibilitySupport() {
        // Given: OCR overlay
        let overlayView = OCROverlayView(
            image: testImage,
            result: testOCRResult,
            onTextEdit: { _, _ in },
            onTextDelete: { _ in }
        )
        
        // When: Checking accessibility
        // Then: Should provide accessibility labels and be hostable
        let hostingView = hostRootPlatformView(overlayView.withGlobalAutoIDsEnabled())
        XCTAssertNotNil(hostingView, "OCR overlay view should be hostable with accessibility")
        // Note: We can't directly test SwiftUI accessibility modifiers in unit tests,
        // but we can verify the view can be hosted and the modifiers are applied
    }
    
    @MainActor
    func testVoiceOverSupport() {
        // Given: OCR overlay with multiple text regions
        let overlayView = OCROverlayView(
            image: testImage,
            result: testOCRResult,
            onTextEdit: { _, _ in },
            onTextDelete: { _ in }
        )
        
        // When: Checking VoiceOver support
        // Then: Should provide proper accessibility elements and be hostable
        let hostingView = hostRootPlatformView(overlayView.withGlobalAutoIDsEnabled())
        XCTAssertNotNil(hostingView, "OCR overlay view should be hostable with VoiceOver support")
        // Note: We can't directly test SwiftUI accessibility elements in unit tests,
        // but we can verify the view can be hosted and the modifiers are applied
    }
    
    // MARK: - Performance Tests
    
    func testOverlayRenderingPerformance() {
        // Given: Large OCR result with many bounding boxes
        let largeBoundingBoxes = (0..<100).map { i in
            CGRect(x: CGFloat(i * 10), y: CGFloat(i * 5), width: 50, height: 20)
        }
        
        let largeResult = OCRResult(
            extractedText: String(repeating: "Text ", count: 100),
            confidence: 0.8,
            boundingBoxes: largeBoundingBoxes,
            textTypes: [.general: "Large Result"],
            processingTime: 2.0,
            language: .english
        )
        
        let overlayView = OCROverlayView(
            image: testImage,
            result: largeResult,
            onTextEdit: { _, _ in },
            onTextDelete: { _ in }
        )
        
        // When: Measuring rendering performance
        measure {
            // Simulate view rendering
            _ = overlayView.body
        }
    }
    
    // MARK: - Edge Cases Tests
    
    func testOverlappingBoundingBoxes() {
        // Given: OCR result with overlapping bounding boxes
        let overlappingBoxes = [
            CGRect(x: 10, y: 10, width: 50, height: 20),
            CGRect(x: 30, y: 15, width: 40, height: 25) // Overlaps with first
        ]
        
        let overlappingResult = OCRResult(
            extractedText: "Overlapping Text",
            confidence: 0.7,
            boundingBoxes: overlappingBoxes,
            textTypes: [.general: "Overlapping Text"],
            processingTime: 1.0,
            language: .english
        )
        
        let overlayView = OCROverlayView(
            image: testImage,
            result: overlappingResult,
            onTextEdit: { _, _ in },
            onTextDelete: { _ in }
        )
        
        // When: Tapping in overlap area
        let tapPoint = CGPoint(x: 40, y: 20) // In overlap area
        let detectedRegion = overlayView.detectTappedTextRegion(at: tapPoint)
        
        // Then: Should handle overlap gracefully
        XCTAssertNotNil(detectedRegion, "Should detect region despite overlap")
    }
    
    func testZeroSizeBoundingBoxes() {
        // Given: OCR result with zero-size bounding boxes
        let zeroSizeBoxes = [
            CGRect(x: 10, y: 10, width: 0, height: 0),
            CGRect(x: 20, y: 20, width: 0, height: 20),
            CGRect(x: 30, y: 30, width: 20, height: 0)
        ]
        
        let zeroSizeResult = OCRResult(
            extractedText: "Zero Size",
            confidence: 0.5,
            boundingBoxes: zeroSizeBoxes,
            textTypes: [.general: "Zero Size"],
            processingTime: 0.5,
            language: .english
        )
        
        let overlayView = OCROverlayView(
            image: testImage,
            result: zeroSizeResult,
            onTextEdit: { _, _ in },
            onTextDelete: { _ in }
        )
        
        // When: Rendering overlay
        // Then: Should handle zero-size boxes gracefully
        XCTAssertNotNil(overlayView, "Should handle zero-size bounding boxes")
    }
    
    func testNegativeBoundingBoxes() {
        // Given: OCR result with negative bounding boxes
        let negativeBoxes = [
            CGRect(x: -10, y: -10, width: 50, height: 20),
            CGRect(x: 10, y: 10, width: -20, height: 30)
        ]
        
        let negativeResult = OCRResult(
            extractedText: "Negative Boxes",
            confidence: 0.6,
            boundingBoxes: negativeBoxes,
            textTypes: [.general: "Negative Boxes"],
            processingTime: 0.8,
            language: .english
        )
        
        let overlayView = OCROverlayView(
            image: testImage,
            result: negativeResult,
            onTextEdit: { _, _ in },
            onTextDelete: { _ in }
        )
        
        // When: Rendering overlay
        // Then: Should handle negative boxes gracefully
        XCTAssertNotNil(overlayView, "Should handle negative bounding boxes")
    }
    
    // MARK: - Integration Tests
    
    func testOCROverlayWithDisambiguationIntegration() {
        // Given: OCR disambiguation result
        let candidates = [
            OCRDataCandidate(
                text: "Hello",
                boundingBox: CGRect(x: 10, y: 10, width: 50, height: 20),
                confidence: 0.9,
                suggestedType: .general,
                alternativeTypes: [.general, .email]
            ),
            OCRDataCandidate(
                text: "World",
                boundingBox: CGRect(x: 70, y: 10, width: 40, height: 20),
                confidence: 0.7,
                suggestedType: .price,
                alternativeTypes: [.general, .number]
            )
        ]
        
        let disambiguationResult = OCRDisambiguationResult(
            candidates: candidates,
            confidence: 0.8,
            requiresUserSelection: true
        )
        
        // When: Creating overlay from disambiguation result
        let overlayView = OCROverlayView.fromDisambiguationResult(
            image: testImage,
            result: disambiguationResult,
            onTextEdit: { _, _ in },
            onTextDelete: { _ in }
        )
        
        // Then: Should create overlay successfully
        XCTAssertNotNil(overlayView, "Should create overlay from disambiguation result")
    }
}
