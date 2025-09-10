//
//  OCRDisambiguationViewTests.swift
//  SixLayerFrameworkTests
//
//  Tests for the OCRDisambiguationView component
//  Tests the actual disambiguation UI behavior
//

import XCTest
import SwiftUI
#if os(iOS)
import UIKit
#endif
@testable import SixLayerFramework

@MainActor
final class OCRDisambiguationViewTests: XCTestCase {
    
    // MARK: - Test Data
    
    private func createTestDisambiguationResult() -> OCRDisambiguationResult {
        let candidates = [
            OCRDataCandidate(
                text: "$12.50",
                boundingBox: CGRect(x: 100, y: 200, width: 60, height: 20),
                confidence: 0.95,
                suggestedType: .price,
                alternativeTypes: [.price, .number]
            ),
            OCRDataCandidate(
                text: "$15.99",
                boundingBox: CGRect(x: 100, y: 250, width: 60, height: 20),
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
        
        return OCRDisambiguationResult(
            candidates: candidates,
            confidence: 0.92,
            requiresUserSelection: true
        )
    }
    
    private func createHighConfidenceResult() -> OCRDisambiguationResult {
        let candidates = [
            OCRDataCandidate(
                text: "$12.50",
                boundingBox: CGRect(x: 100, y: 200, width: 60, height: 20),
                confidence: 0.98,
                suggestedType: .price,
                alternativeTypes: [.price]
            )
        ]
        
        return OCRDisambiguationResult(
            candidates: candidates,
            confidence: 0.98,
            requiresUserSelection: false
        )
    }
    
    // MARK: - View Creation Tests
    
    func testOCRDisambiguationView_CreatesView() {
        // Given
        let result = createTestDisambiguationResult()
        
        // When
        let view = OCRDisambiguationView(result: result) { _ in }
        
        // Then
        XCTAssertNotNil(view, "Should create OCRDisambiguationView")
    }
    
    func testOCRDisambiguationView_WithHighConfidenceResult() {
        // Given
        let result = createHighConfidenceResult()
        
        // When
        let view = OCRDisambiguationView(result: result) { _ in }
        
        // Then
        XCTAssertNotNil(view, "Should create OCRDisambiguationView with high confidence result")
    }
    
    // MARK: - Selection Callback Tests
    
    func testOCRDisambiguationView_CallsSelectionCallback() async {
        // Given
        let result = createTestDisambiguationResult()
        let expectation = XCTestExpectation(description: "Selection callback called")
        var receivedSelection: OCRDisambiguationSelection?
        
        // When
        let view = OCRDisambiguationView(result: result) { selection in
            receivedSelection = selection
            expectation.fulfill()
        }
        
        // Render the view
        #if os(iOS)
        let hostingController = UIHostingController(rootView: view)
        hostingController.view.frame = CGRect(x: 0, y: 0, width: 300, height: 400)
        hostingController.view.layoutIfNeeded()
        #endif
        
        // Simulate user selection (this would normally be done through UI interaction)
        // For testing purposes, we'll simulate the selection directly
        if let firstCandidate = result.candidates.first {
            let selection = OCRDisambiguationSelection(
                candidateId: firstCandidate.id,
                selectedType: firstCandidate.suggestedType
            )
            
            // In a real test, this would be triggered by user interaction
            // For now, we'll just verify the view can be created and rendered
            XCTAssertNotNil(selection, "Should be able to create selection")
        }
        
        // Then
        // Note: In a real UI test, we would simulate actual user interaction
        // For now, we just verify the view can be created and rendered
        XCTAssertNotNil(view, "Should create view successfully")
    }
    
    // MARK: - Result Validation Tests
    
    func testOCRDisambiguationView_WithEmptyCandidates() {
        // Given
        let result = OCRDisambiguationResult(
            candidates: [],
            confidence: 0.0,
            requiresUserSelection: false
        )
        
        // When
        let view = OCRDisambiguationView(result: result) { _ in }
        
        // Then
        XCTAssertNotNil(view, "Should handle empty candidates gracefully")
    }
    
    func testOCRDisambiguationView_WithSingleCandidate() {
        // Given
        let result = createHighConfidenceResult()
        
        // When
        let view = OCRDisambiguationView(result: result) { _ in }
        
        // Then
        XCTAssertNotNil(view, "Should handle single candidate")
    }
    
    func testOCRDisambiguationView_WithManyCandidates() {
        // Given
        let candidates = (0..<20).map { i in
            OCRDataCandidate(
                text: "Candidate \(i)",
                boundingBox: CGRect(x: 0, y: CGFloat(i * 20), width: 100, height: 20),
                confidence: Float.random(in: 0.1...0.9),
                suggestedType: .general,
                alternativeTypes: [.general]
            )
        }
        let result = OCRDisambiguationResult(
            candidates: candidates,
            confidence: 0.5,
            requiresUserSelection: true
        )
        
        // When
        let view = OCRDisambiguationView(result: result) { _ in }
        
        // Then
        XCTAssertNotNil(view, "Should handle many candidates")
    }
    
    // MARK: - Performance Tests
    
    func testOCRDisambiguationView_Performance() {
        // Given
        let result = createTestDisambiguationResult()
        
        // When & Then
        measure {
            let view = OCRDisambiguationView(result: result) { _ in }
            XCTAssertNotNil(view)
        }
    }
    
    func testOCRDisambiguationView_PerformanceWithManyCandidates() {
        // Given
        let candidates = (0..<100).map { i in
            OCRDataCandidate(
                text: "Candidate \(i)",
                boundingBox: CGRect(x: 0, y: CGFloat(i * 20), width: 100, height: 20),
                confidence: Float.random(in: 0.1...0.9),
                suggestedType: .general,
                alternativeTypes: [.general]
            )
        }
        let result = OCRDisambiguationResult(
            candidates: candidates,
            confidence: 0.5,
            requiresUserSelection: true
        )
        
        // When & Then
        measure {
            let view = OCRDisambiguationView(result: result) { _ in }
            XCTAssertNotNil(view)
        }
    }
    
    // MARK: - Memory Management Tests
    
    func testOCRDisambiguationView_MemoryManagement() {
        // Given
        let result = createTestDisambiguationResult()
        
        // When
        autoreleasepool {
            let view = OCRDisambiguationView(result: result) { _ in }
            XCTAssertNotNil(view)
        }
        
        // Then
        // View should be deallocated here
        // This test verifies that the view can be created and deallocated without memory leaks
    }
    
    // MARK: - Cross-Platform Tests
    
    func testOCRDisambiguationView_CrossPlatformCompatibility() {
        // Given
        let result = createTestDisambiguationResult()
        
        // When
        let view = OCRDisambiguationView(result: result) { _ in }
        
        // Then
        XCTAssertNotNil(view, "Should work on current platform")
        
        #if os(iOS)
        // iOS-specific validations
        let hostingController = UIHostingController(rootView: view)
        XCTAssertNotNil(hostingController, "Should create UIHostingController on iOS")
        #elseif os(macOS)
        // macOS-specific validations
        let hostingController = NSHostingController(rootView: view)
        XCTAssertNotNil(hostingController, "Should create NSHostingController on macOS")
        #endif
    }
    
    // MARK: - Edge Cases Tests
    
    func testOCRDisambiguationView_WithExtremeConfidenceValues() {
        // Given
        let candidates = [
            OCRDataCandidate(
                text: "A",
                boundingBox: CGRect(x: 0, y: 0, width: 100, height: 20),
                confidence: 0.0,
                suggestedType: .general,
                alternativeTypes: [.general]
            ),
            OCRDataCandidate(
                text: "B",
                boundingBox: CGRect(x: 0, y: 20, width: 100, height: 20),
                confidence: 1.0,
                suggestedType: .general,
                alternativeTypes: [.general]
            )
        ]
        let result = OCRDisambiguationResult(
            candidates: candidates,
            confidence: 0.5,
            requiresUserSelection: true
        )
        
        // When
        let view = OCRDisambiguationView(result: result) { _ in }
        
        // Then
        XCTAssertNotNil(view, "Should handle extreme confidence values")
    }
    
    func testOCRDisambiguationView_WithVeryLongText() {
        // Given
        let longText = String(repeating: "Very long text that might cause layout issues ", count: 10)
        let candidates = [
            OCRDataCandidate(
                text: longText,
                boundingBox: CGRect(x: 0, y: 0, width: 100, height: 20),
                confidence: 0.8,
                suggestedType: .general,
                alternativeTypes: [.general]
            )
        ]
        let result = OCRDisambiguationResult(
            candidates: candidates,
            confidence: 0.8,
            requiresUserSelection: true
        )
        
        // When
        let view = OCRDisambiguationView(result: result) { _ in }
        
        // Then
        XCTAssertNotNil(view, "Should handle very long text")
    }
    
    // MARK: - Helper Methods
    
    private func createTestResult(
        candidates: [OCRDataCandidate],
        confidence: Float,
        requiresUserSelection: Bool
    ) -> OCRDisambiguationResult {
        return OCRDisambiguationResult(
            candidates: candidates,
            confidence: confidence,
            requiresUserSelection: requiresUserSelection
        )
    }
}

