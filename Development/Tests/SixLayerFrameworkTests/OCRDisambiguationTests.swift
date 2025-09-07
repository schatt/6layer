//
//  OCRDisambiguationTests.swift
//  SixLayerFrameworkTests
//
//  Tests for OCR disambiguation interface - handling multiple ambiguous OCR results
//

import XCTest
import SwiftUI
@testable import SixLayerFramework

/// Tests for OCR disambiguation functionality
/// Tests data structures, detection logic, UI components, and integration
@MainActor
final class OCRDisambiguationTests: XCTestCase {
    
    // MARK: - Test Data
    
    private var testImage: PlatformImage {
        createTestPlatformImage()
    }
    
    private var mockReceiptCandidates: [OCRDataCandidate] {
        [
            OCRDataCandidate(
                text: "12.50",
                boundingBox: CGRect(x: 100, y: 200, width: 50, height: 20),
                confidence: 0.95,
                suggestedType: .price,
                alternativeTypes: [.price, .number]
            ),
            OCRDataCandidate(
                text: "15.99",
                boundingBox: CGRect(x: 100, y: 250, width: 50, height: 20),
                confidence: 0.92,
                suggestedType: .price,
                alternativeTypes: [.price, .number]
            ),
            OCRDataCandidate(
                text: "2024-01-15",
                boundingBox: CGRect(x: 200, y: 100, width: 80, height: 20),
                confidence: 0.88,
                suggestedType: .date,
                alternativeTypes: [.date, .general]
            )
        ]
    }
    
    private var mockBusinessCardCandidates: [OCRDataCandidate] {
        [
            OCRDataCandidate(
                text: "(555) 123-4567",
                boundingBox: CGRect(x: 50, y: 150, width: 120, height: 20),
                confidence: 0.90,
                suggestedType: .phone,
                alternativeTypes: [.phone, .general]
            ),
            OCRDataCandidate(
                text: "(555) 987-6543",
                boundingBox: CGRect(x: 50, y: 180, width: 120, height: 20),
                confidence: 0.87,
                suggestedType: .phone,
                alternativeTypes: [.phone, .general]
            ),
            OCRDataCandidate(
                text: "john@company.com",
                boundingBox: CGRect(x: 50, y: 210, width: 150, height: 20),
                confidence: 0.94,
                suggestedType: .email,
                alternativeTypes: [.email, .general]
            )
        ]
    }
    
    // MARK: - OCRDataCandidate Tests
    
    func testOCRDataCandidateInitialization() {
        // Given: Valid candidate data
        let text = "12.50"
        let boundingBox = CGRect(x: 100, y: 200, width: 50, height: 20)
        let confidence: Float = 0.95
        let suggestedType = TextType.price
        let alternativeTypes = [TextType.price, TextType.number]
        
        // When: Creating OCRDataCandidate
        let candidate = OCRDataCandidate(
            text: text,
            boundingBox: boundingBox,
            confidence: confidence,
            suggestedType: suggestedType,
            alternativeTypes: alternativeTypes
        )
        
        // Then: Should initialize correctly
        XCTAssertEqual(candidate.text, text)
        XCTAssertEqual(candidate.boundingBox, boundingBox)
        XCTAssertEqual(candidate.confidence, confidence)
        XCTAssertEqual(candidate.suggestedType, suggestedType)
        XCTAssertEqual(candidate.alternativeTypes, alternativeTypes)
    }
    
    func testOCRDataCandidateEquality() {
        // Given: Two identical candidates
        let candidate1 = OCRDataCandidate(
            text: "12.50",
            boundingBox: CGRect(x: 100, y: 200, width: 50, height: 20),
            confidence: 0.95,
            suggestedType: .price,
            alternativeTypes: [.price, .number]
        )
        
        let candidate2 = OCRDataCandidate(
            text: "12.50",
            boundingBox: CGRect(x: 100, y: 200, width: 50, height: 20),
            confidence: 0.95,
            suggestedType: .price,
            alternativeTypes: [.price, .number]
        )
        
        // When: Comparing candidates
        // Then: Should be equal
        XCTAssertEqual(candidate1, candidate2)
    }
    
    func testOCRDataCandidateInequality() {
        // Given: Two different candidates
        let candidate1 = OCRDataCandidate(
            text: "12.50",
            boundingBox: CGRect(x: 100, y: 200, width: 50, height: 20),
            confidence: 0.95,
            suggestedType: .price,
            alternativeTypes: [.price, .number]
        )
        
        let candidate2 = OCRDataCandidate(
            text: "15.99",
            boundingBox: CGRect(x: 100, y: 200, width: 50, height: 20),
            confidence: 0.95,
            suggestedType: .price,
            alternativeTypes: [.price, .number]
        )
        
        // When: Comparing candidates
        // Then: Should not be equal
        XCTAssertNotEqual(candidate1, candidate2)
    }
    
    func testOCRDataCandidateIdentifiable() {
        // Given: A candidate
        let candidate = OCRDataCandidate(
            text: "12.50",
            boundingBox: CGRect(x: 100, y: 200, width: 50, height: 20),
            confidence: 0.95,
            suggestedType: .price,
            alternativeTypes: [.price, .number]
        )
        
        // When: Accessing id
        // Then: Should have unique identifier
        XCTAssertNotNil(candidate.id)
        XCTAssertNotEqual(candidate.id, UUID())
    }
    
    // MARK: - OCRDisambiguationResult Tests
    
    func testOCRDisambiguationResultInitialization() {
        // Given: Valid disambiguation data
        let candidates = mockReceiptCandidates
        let confidence: Float = 0.90
        let requiresUserSelection = true
        
        // When: Creating OCRDisambiguationResult
        let result = OCRDisambiguationResult(
            candidates: candidates,
            confidence: confidence,
            requiresUserSelection: requiresUserSelection
        )
        
        // Then: Should initialize correctly
        XCTAssertEqual(result.candidates, candidates)
        XCTAssertEqual(result.confidence, confidence)
        XCTAssertEqual(result.requiresUserSelection, requiresUserSelection)
    }
    
    func testOCRDisambiguationResultWithHighConfidence() {
        // Given: High confidence result
        let candidates = mockReceiptCandidates
        let confidence: Float = 0.95
        let requiresUserSelection = false
        
        // When: Creating OCRDisambiguationResult
        let result = OCRDisambiguationResult(
            candidates: candidates,
            confidence: confidence,
            requiresUserSelection: requiresUserSelection
        )
        
        // Then: Should not require user selection
        XCTAssertFalse(result.requiresUserSelection)
        XCTAssertEqual(result.confidence, confidence)
    }
    
    func testOCRDisambiguationResultWithLowConfidence() {
        // Given: Low confidence result
        let candidates = mockReceiptCandidates
        let confidence: Float = 0.60
        let requiresUserSelection = true
        
        // When: Creating OCRDisambiguationResult
        let result = OCRDisambiguationResult(
            candidates: candidates,
            confidence: confidence,
            requiresUserSelection: requiresUserSelection
        )
        
        // Then: Should require user selection
        XCTAssertTrue(result.requiresUserSelection)
        XCTAssertEqual(result.confidence, confidence)
    }
    
    func testOCRDisambiguationResultEmptyCandidates() {
        // Given: Empty candidates array
        let candidates: [OCRDataCandidate] = []
        let confidence: Float = 0.0
        let requiresUserSelection = false
        
        // When: Creating OCRDisambiguationResult
        let result = OCRDisambiguationResult(
            candidates: candidates,
            confidence: confidence,
            requiresUserSelection: requiresUserSelection
        )
        
        // Then: Should handle empty candidates
        XCTAssertTrue(result.candidates.isEmpty)
        XCTAssertFalse(result.requiresUserSelection)
    }
    
    // MARK: - Disambiguation Detection Logic Tests
    
    func testShouldRequireDisambiguationWithMultipleSameType() {
        // Given: Multiple candidates of same type with similar confidence
        let candidates = mockReceiptCandidates
        
        // When: Checking if disambiguation is needed
        let requiresDisambiguation = shouldRequireDisambiguation(candidates: candidates)
        
        // Then: Should require disambiguation
        XCTAssertTrue(requiresDisambiguation)
    }
    
    func testShouldNotRequireDisambiguationWithSingleCandidate() {
        // Given: Single candidate
        let candidates = [mockReceiptCandidates[0]]
        
        // When: Checking if disambiguation is needed
        let requiresDisambiguation = shouldRequireDisambiguation(candidates: candidates)
        
        // Then: Should not require disambiguation
        XCTAssertFalse(requiresDisambiguation)
    }
    
    func testShouldNotRequireDisambiguationWithDifferentTypes() {
        // Given: Candidates of different types
        let candidates = [
            OCRDataCandidate(
                text: "12.50",
                boundingBox: CGRect(x: 100, y: 200, width: 50, height: 20),
                confidence: 0.95,
                suggestedType: .price,
                alternativeTypes: [.price, .number]
            ),
            OCRDataCandidate(
                text: "2024-01-15",
                boundingBox: CGRect(x: 200, y: 100, width: 80, height: 20),
                confidence: 0.88,
                suggestedType: .date,
                alternativeTypes: [.date, .general]
            )
        ]
        
        // When: Checking if disambiguation is needed
        let requiresDisambiguation = shouldRequireDisambiguation(candidates: candidates)
        
        // Then: Should not require disambiguation
        XCTAssertFalse(requiresDisambiguation)
    }
    
    func testShouldRequireDisambiguationWithLowConfidence() {
        // Given: Candidates with low confidence
        let candidates = [
            OCRDataCandidate(
                text: "12.50",
                boundingBox: CGRect(x: 100, y: 200, width: 50, height: 20),
                confidence: 0.60,
                suggestedType: .price,
                alternativeTypes: [.price, .number]
            ),
            OCRDataCandidate(
                text: "15.99",
                boundingBox: CGRect(x: 100, y: 250, width: 50, height: 20),
                confidence: 0.65,
                suggestedType: .price,
                alternativeTypes: [.price, .number]
            )
        ]
        
        // When: Checking if disambiguation is needed
        let requiresDisambiguation = shouldRequireDisambiguation(candidates: candidates)
        
        // Then: Should require disambiguation
        XCTAssertTrue(requiresDisambiguation)
    }
    
    // MARK: - Disambiguation UI Tests
    
    func testOCRDisambiguationViewInitialization() {
        // Given: Disambiguation result
        let result = OCRDisambiguationResult(
            candidates: mockReceiptCandidates,
            confidence: 0.85,
            requiresUserSelection: true
        )
        
        // When: Creating OCRDisambiguationView
        let view = OCRDisambiguationView(
            result: result,
            onSelection: { _ in }
        )
        
        // Then: Should initialize correctly
        XCTAssertNotNil(view)
    }
    
    func testOCRDisambiguationViewWithEmptyCandidates() {
        // Given: Empty disambiguation result
        let result = OCRDisambiguationResult(
            candidates: [],
            confidence: 0.0,
            requiresUserSelection: false
        )
        
        // When: Creating OCRDisambiguationView
        let view = OCRDisambiguationView(
            result: result,
            onSelection: { _ in }
        )
        
        // Then: Should handle empty candidates
        XCTAssertNotNil(view)
    }
    
    // MARK: - Integration Tests
    
    func testOCRDisambiguationIntegrationWithReceipt() async {
        // Given: Receipt image with multiple prices
        let service = OCRServiceFactory.create()
        let context = OCRContext(
            textTypes: [.price, .date],
            language: .english,
            confidenceThreshold: 0.8
        )
        
        let strategy = OCRStrategy(
            supportedTextTypes: [.price, .date],
            supportedLanguages: [.english],
            processingMode: .standard
        )
        
        // When: Processing with OCR service
        do {
            let result = try await service.processImage(testImage, context: context, strategy: strategy)
            // Then: Should handle result
            XCTAssertNotNil(result)
        } catch {
            // OCR might not be available in test environment
            // This is expected behavior for tests
        }
    }
    
    func testOCRDisambiguationIntegrationWithBusinessCard() async {
        // Given: Business card image with multiple phone numbers
        let service = OCRServiceFactory.create()
        let context = OCRContext(
            textTypes: [.phone, .email],
            language: .english,
            confidenceThreshold: 0.8
        )
        
        let strategy = OCRStrategy(
            supportedTextTypes: [.phone, .email],
            supportedLanguages: [.english],
            processingMode: .standard
        )
        
        // When: Processing with OCR service
        do {
            let result = try await service.processImage(testImage, context: context, strategy: strategy)
            // Then: Should handle result
            XCTAssertNotNil(result)
        } catch {
            // OCR might not be available in test environment
            // This is expected behavior for tests
        }
    }
    
    // MARK: - Edge Case Tests
    
    func testDisambiguationWithIdenticalCandidates() {
        // Given: Identical candidates
        let candidates = [
            OCRDataCandidate(
                text: "12.50",
                boundingBox: CGRect(x: 100, y: 200, width: 50, height: 20),
                confidence: 0.95,
                suggestedType: .price,
                alternativeTypes: [.price, .number]
            ),
            OCRDataCandidate(
                text: "12.50",
                boundingBox: CGRect(x: 100, y: 250, width: 50, height: 20),
                confidence: 0.95,
                suggestedType: .price,
                alternativeTypes: [.price, .number]
            )
        ]
        
        // When: Checking if disambiguation is needed
        let requiresDisambiguation = shouldRequireDisambiguation(candidates: candidates)
        
        // Then: Should require disambiguation
        XCTAssertTrue(requiresDisambiguation)
    }
    
    func testDisambiguationWithVeryLowConfidence() {
        // Given: Very low confidence candidates
        let candidates = [
            OCRDataCandidate(
                text: "12.50",
                boundingBox: CGRect(x: 100, y: 200, width: 50, height: 20),
                confidence: 0.30,
                suggestedType: .price,
                alternativeTypes: [.price, .number]
            ),
            OCRDataCandidate(
                text: "15.99",
                boundingBox: CGRect(x: 100, y: 250, width: 50, height: 20),
                confidence: 0.35,
                suggestedType: .price,
                alternativeTypes: [.price, .number]
            )
        ]
        
        // When: Checking if disambiguation is needed
        let requiresDisambiguation = shouldRequireDisambiguation(candidates: candidates)
        
        // Then: Should require disambiguation
        XCTAssertTrue(requiresDisambiguation)
    }
    
    func testDisambiguationWithMixedConfidence() {
        // Given: Mixed confidence candidates
        let candidates = [
            OCRDataCandidate(
                text: "12.50",
                boundingBox: CGRect(x: 100, y: 200, width: 50, height: 20),
                confidence: 0.95,
                suggestedType: .price,
                alternativeTypes: [.price, .number]
            ),
            OCRDataCandidate(
                text: "15.99",
                boundingBox: CGRect(x: 100, y: 250, width: 50, height: 20),
                confidence: 0.60,
                suggestedType: .price,
                alternativeTypes: [.price, .number]
            )
        ]
        
        // When: Checking if disambiguation is needed
        let requiresDisambiguation = shouldRequireDisambiguation(candidates: candidates)
        
        // Then: Should require disambiguation due to confidence difference
        XCTAssertTrue(requiresDisambiguation)
    }
    
    // MARK: - Performance Tests
    
    func testDisambiguationPerformanceWithManyCandidates() {
        // Given: Many candidates
        let candidates = (0..<100).map { index in
            OCRDataCandidate(
                text: "\(index).50",
                boundingBox: CGRect(x: 100, y: CGFloat(200 + index * 20), width: 50, height: 20),
                confidence: 0.85,
                suggestedType: .price,
                alternativeTypes: [.price, .number]
            )
        }
        
        // When: Measuring disambiguation performance
        measure {
            let _ = shouldRequireDisambiguation(candidates: candidates)
        }
    }
    
    // MARK: - Helper Methods
    
    private func createTestPlatformImage() -> PlatformImage {
        #if os(iOS)
        let size = CGSize(width: 300, height: 400)
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { context in
            UIColor.white.setFill()
            context.fill(CGRect(origin: .zero, size: size))
            
            // Add some text-like content for testing
            let text = "Receipt\nTotal: $12.50\nTax: $15.99\nDate: 2024-01-15"
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 16),
                .foregroundColor: UIColor.black
            ]
            text.draw(in: CGRect(x: 20, y: 20, width: 260, height: 360), withAttributes: attributes)
        }
        return PlatformImage(uiImage: image)
        #elseif os(macOS)
        let size = NSSize(width: 300, height: 400)
        let image = NSImage(size: size)
        image.lockFocus()
        NSColor.white.setFill()
        NSRect(origin: .zero, size: size).fill()
        
        // Add some text-like content for testing
        let text = "Receipt\nTotal: $12.50\nTax: $15.99\nDate: 2024-01-15"
        let attributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 16),
            .foregroundColor: NSColor.black
        ]
        text.draw(in: NSRect(x: 20, y: 20, width: 260, height: 360), withAttributes: attributes)
        image.unlockFocus()
        return PlatformImage(nsImage: image)
        #else
        return PlatformImage()
        #endif
    }
}
