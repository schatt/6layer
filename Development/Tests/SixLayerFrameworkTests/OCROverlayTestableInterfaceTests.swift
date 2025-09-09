import XCTest
import SwiftUI
@testable import SixLayerFramework

/// Tests for OCROverlayTestableInterface
/// This demonstrates how to test OCR overlay functionality without SwiftUI StateObject warnings
@MainActor
final class OCROverlayTestableInterfaceTests: XCTestCase {
    
    // MARK: - Test Data
    
    private var mockOCRResult: OCRResult!
    private var mockConfiguration: OCROverlayConfiguration!
    private var textEditCallbacks: [(String, CGRect)] = []
    private var textDeleteCallbacks: [CGRect] = []
    
    override func setUp() {
        super.setUp()
        
        // Create mock OCR result
        mockOCRResult = OCRResult(
            extractedText: "Hello World\nTest Text\nAnother Line",
            confidence: 0.95,
            boundingBoxes: [
                CGRect(x: 0.1, y: 0.1, width: 0.3, height: 0.1),
                CGRect(x: 0.1, y: 0.3, width: 0.4, height: 0.1),
                CGRect(x: 0.1, y: 0.5, width: 0.5, height: 0.1)
            ],
            textTypes: [
                .general: "Hello World",
                .price: "Test Text",
                .date: "Another Line"
            ],
            processingTime: 0.5,
            language: .english
        )
        
        // Create mock configuration
        mockConfiguration = OCROverlayConfiguration(
            allowsEditing: true,
            allowsDeletion: true,
            showConfidenceIndicators: true,
            highlightColor: .blue,
            editingColor: .green,
            lowConfidenceThreshold: 0.7,
            highConfidenceThreshold: 0.9
        )
        
        // Reset callbacks
        textEditCallbacks = []
        textDeleteCallbacks = []
    }
    
    override func tearDown() {
        mockOCRResult = nil
        mockConfiguration = nil
        textEditCallbacks = []
        textDeleteCallbacks = []
        super.tearDown()
    }
    
    // MARK: - Testable Interface Creation
    
    private func createTestableInterface() -> OCROverlayTestableInterface {
        return OCROverlayTestableInterface(
            result: mockOCRResult,
            onTextEdit: { text, boundingBox in
                self.textEditCallbacks.append((text, boundingBox))
            },
            onTextDelete: { boundingBox in
                self.textDeleteCallbacks.append(boundingBox)
            }
        )
    }
    
    // MARK: - Basic Functionality Tests
    
    func testInitialization() {
        let interface = createTestableInterface()
        
        // Test that text regions are properly initialized
        XCTAssertEqual(interface.textRegions.count, 3, "Should have 3 text regions")
        XCTAssertFalse(interface.isEditingText, "Should not be editing initially")
        XCTAssertNil(interface.editingBoundingBox, "Should not have editing bounding box initially")
        XCTAssertEqual(interface.editingText, "", "Should have empty editing text initially")
        XCTAssertNil(interface.selectedRegion, "Should not have selected region initially")
    }
    
    func testTextRegionDetection() {
        let interface = createTestableInterface()
        
        // Test detecting text regions at different points
        let firstRegion = interface.detectTappedTextRegion(at: CGPoint(x: 0.2, y: 0.15))
        XCTAssertNotNil(firstRegion, "Should detect first text region")
        XCTAssertEqual(firstRegion?.text, "Hello World", "Should detect correct text")
        
        let secondRegion = interface.detectTappedTextRegion(at: CGPoint(x: 0.3, y: 0.35))
        XCTAssertNotNil(secondRegion, "Should detect second text region")
        XCTAssertEqual(secondRegion?.text, "Test Text", "Should detect correct text")
        
        let noRegion = interface.detectTappedTextRegion(at: CGPoint(x: 0.8, y: 0.8))
        XCTAssertNil(noRegion, "Should not detect region outside bounding boxes")
    }
    
    // MARK: - Text Editing Tests
    
    func testStartTextEditing() {
        let interface = createTestableInterface()
        let firstBoundingBox = mockOCRResult.boundingBoxes[0]
        
        // Start editing first text region
        interface.startTextEditing(for: firstBoundingBox)
        
        // Verify editing state
        XCTAssertTrue(interface.isEditingText, "Should be editing text")
        XCTAssertEqual(interface.editingBoundingBox, firstBoundingBox, "Should have correct editing bounding box")
        XCTAssertEqual(interface.editingText, "Hello World", "Should have correct editing text")
        XCTAssertNotNil(interface.selectedRegion, "Should have selected region")
        XCTAssertEqual(interface.selectedRegion?.text, "Hello World", "Should have correct selected region text")
    }
    
    func testCompleteTextEditing() {
        let interface = createTestableInterface()
        let firstBoundingBox = mockOCRResult.boundingBoxes[0]
        
        // Start editing
        interface.startTextEditing(for: firstBoundingBox)
        
        // Complete editing
        interface.completeTextEditing()
        
        // Verify completion
        XCTAssertFalse(interface.isEditingText, "Should not be editing after completion")
        XCTAssertNil(interface.editingBoundingBox, "Should not have editing bounding box after completion")
        XCTAssertEqual(interface.editingText, "", "Should have empty editing text after completion")
        XCTAssertNil(interface.selectedRegion, "Should not have selected region after completion")
        
        // Verify callback was called
        XCTAssertEqual(textEditCallbacks.count, 1, "Should have called text edit callback")
        XCTAssertEqual(textEditCallbacks[0].0, "Hello World", "Should have called with correct text")
        XCTAssertEqual(textEditCallbacks[0].1, firstBoundingBox, "Should have called with correct bounding box")
    }
    
    func testCompleteTextEditingWithSpecificText() {
        let interface = createTestableInterface()
        let firstBoundingBox = mockOCRResult.boundingBoxes[0]
        
        // Start editing
        interface.startTextEditing(for: firstBoundingBox)
        
        // Complete editing with specific text
        let newText = "Modified Text"
        interface.completeTextEditing(with: newText)
        
        // Verify completion
        XCTAssertFalse(interface.isEditingText, "Should not be editing after completion")
        XCTAssertNil(interface.editingBoundingBox, "Should not have editing bounding box after completion")
        XCTAssertEqual(interface.editingText, "", "Should have empty editing text after completion")
        XCTAssertNil(interface.selectedRegion, "Should not have selected region after completion")
        
        // Verify callback was called with new text
        XCTAssertEqual(textEditCallbacks.count, 1, "Should have called text edit callback")
        XCTAssertEqual(textEditCallbacks[0].0, newText, "Should have called with new text")
        XCTAssertEqual(textEditCallbacks[0].1, firstBoundingBox, "Should have called with correct bounding box")
    }
    
    func testCancelTextEditing() {
        let interface = createTestableInterface()
        let firstBoundingBox = mockOCRResult.boundingBoxes[0]
        
        // Start editing
        interface.startTextEditing(for: firstBoundingBox)
        
        // Cancel editing
        interface.cancelTextEditing()
        
        // Verify cancellation
        XCTAssertFalse(interface.isEditingText, "Should not be editing after cancellation")
        XCTAssertNil(interface.editingBoundingBox, "Should not have editing bounding box after cancellation")
        XCTAssertEqual(interface.editingText, "", "Should have empty editing text after cancellation")
        XCTAssertNil(interface.selectedRegion, "Should not have selected region after cancellation")
        
        // Verify no callback was called
        XCTAssertEqual(textEditCallbacks.count, 0, "Should not have called text edit callback")
    }
    
    // MARK: - Text Deletion Tests
    
    func testDeleteTextRegion() {
        let interface = createTestableInterface()
        let firstBoundingBox = mockOCRResult.boundingBoxes[0]
        
        // Delete text region
        interface.deleteTextRegion(at: firstBoundingBox)
        
        // Verify callback was called
        XCTAssertEqual(textDeleteCallbacks.count, 1, "Should have called text delete callback")
        XCTAssertEqual(textDeleteCallbacks[0], firstBoundingBox, "Should have called with correct bounding box")
    }
    
    // MARK: - Confidence Color Tests
    
    func testConfidenceColor() {
        let interface = createTestableInterface()
        
        // Test high confidence
        let highConfidenceColor = interface.confidenceColor(for: 0.95, configuration: mockConfiguration)
        XCTAssertEqual(highConfidenceColor, .green, "High confidence should be green")
        
        // Test medium confidence
        let mediumConfidenceColor = interface.confidenceColor(for: 0.8, configuration: mockConfiguration)
        XCTAssertEqual(mediumConfidenceColor, .orange, "Medium confidence should be orange")
        
        // Test low confidence
        let lowConfidenceColor = interface.confidenceColor(for: 0.5, configuration: mockConfiguration)
        XCTAssertEqual(lowConfidenceColor, .red, "Low confidence should be red")
    }
    
    // MARK: - Edge Case Tests
    
    func testStartTextEditingWithInvalidBoundingBox() {
        let interface = createTestableInterface()
        let invalidBoundingBox = CGRect(x: 0.9, y: 0.9, width: 0.1, height: 0.1)
        
        // Try to start editing with invalid bounding box
        interface.startTextEditing(for: invalidBoundingBox)
        
        // Verify no editing state was set
        XCTAssertFalse(interface.isEditingText, "Should not be editing with invalid bounding box")
        XCTAssertNil(interface.editingBoundingBox, "Should not have editing bounding box with invalid bounding box")
        XCTAssertEqual(interface.editingText, "", "Should have empty editing text with invalid bounding box")
        XCTAssertNil(interface.selectedRegion, "Should not have selected region with invalid bounding box")
    }
    
    func testCompleteTextEditingWithoutStarting() {
        let interface = createTestableInterface()
        
        // Try to complete editing without starting
        interface.completeTextEditing()
        
        // Verify no callback was called
        XCTAssertEqual(textEditCallbacks.count, 0, "Should not have called text edit callback without starting")
    }
    
    func testCompleteTextEditingWithSpecificTextWithoutStarting() {
        let interface = createTestableInterface()
        
        // Try to complete editing with specific text without starting
        interface.completeTextEditing(with: "Some Text")
        
        // Verify callback was called with fallback bounding box
        XCTAssertEqual(textEditCallbacks.count, 1, "Should have called text edit callback with fallback")
        XCTAssertEqual(textEditCallbacks[0].0, "Some Text", "Should have called with correct text")
        XCTAssertEqual(textEditCallbacks[0].1, mockOCRResult.boundingBoxes.first ?? CGRect.zero, "Should have called with fallback bounding box")
    }
    
    // MARK: - Multiple Operations Tests
    
    func testMultipleTextEditingOperations() {
        let interface = createTestableInterface()
        
        // Start editing first region
        let firstBoundingBox = mockOCRResult.boundingBoxes[0]
        interface.startTextEditing(for: firstBoundingBox)
        XCTAssertTrue(interface.isEditingText, "Should be editing first region")
        
        // Complete editing
        interface.completeTextEditing()
        XCTAssertFalse(interface.isEditingText, "Should not be editing after completion")
        XCTAssertEqual(textEditCallbacks.count, 1, "Should have one text edit callback")
        
        // Start editing second region
        let secondBoundingBox = mockOCRResult.boundingBoxes[1]
        interface.startTextEditing(for: secondBoundingBox)
        XCTAssertTrue(interface.isEditingText, "Should be editing second region")
        XCTAssertEqual(interface.editingText, "Test Text", "Should have correct editing text for second region")
        
        // Complete editing with specific text
        interface.completeTextEditing(with: "Modified Second Text")
        XCTAssertFalse(interface.isEditingText, "Should not be editing after second completion")
        XCTAssertEqual(textEditCallbacks.count, 2, "Should have two text edit callbacks")
        XCTAssertEqual(textEditCallbacks[1].0, "Modified Second Text", "Should have correct text for second callback")
    }
    
    func testMixedOperations() {
        let interface = createTestableInterface()
        
        // Start editing
        let firstBoundingBox = mockOCRResult.boundingBoxes[0]
        interface.startTextEditing(for: firstBoundingBox)
        
        // Cancel editing
        interface.cancelTextEditing()
        XCTAssertEqual(textEditCallbacks.count, 0, "Should not have text edit callbacks after cancellation")
        
        // Delete a region
        interface.deleteTextRegion(at: firstBoundingBox)
        XCTAssertEqual(textDeleteCallbacks.count, 1, "Should have text delete callback")
        
        // Start editing another region
        let secondBoundingBox = mockOCRResult.boundingBoxes[1]
        interface.startTextEditing(for: secondBoundingBox)
        
        // Complete editing
        interface.completeTextEditing()
        XCTAssertEqual(textEditCallbacks.count, 1, "Should have one text edit callback")
        XCTAssertEqual(textDeleteCallbacks.count, 1, "Should have one text delete callback")
    }
    
    // MARK: - Performance Tests
    
    func testPerformanceWithManyTextRegions() {
        // Create a large OCR result
        let largeText = (0..<100).map { "Text Line \($0)" }.joined(separator: "\n")
        let largeBoundingBoxes = (0..<100).map { index in
            CGRect(x: 0.1, y: 0.1 + Double(index) * 0.01, width: 0.3, height: 0.01)
        }
        
        let largeOCRResult = OCRResult(
            extractedText: largeText,
            confidence: 0.95,
            boundingBoxes: largeBoundingBoxes,
            textTypes: [:],
            processingTime: 1.0,
            language: .english
        )
        
        let interface = OCROverlayTestableInterface(
            result: largeOCRResult,
            onTextEdit: { _, _ in },
            onTextDelete: { _ in }
        )
        
        // Test performance of text region detection
        measure {
            for i in 0..<1000 {
                let point = CGPoint(x: 0.2, y: 0.1 + Double(i % 100) * 0.01)
                _ = interface.detectTappedTextRegion(at: point)
            }
        }
    }
}
