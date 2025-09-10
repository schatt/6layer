//
//  OCRDisambiguationLogicTests.swift
//  SixLayerFrameworkTests
//
//  Unit tests for OCR disambiguation business logic
//  Tests the core algorithms without UI dependencies
//

import XCTest
@testable import SixLayerFramework

final class OCRDisambiguationLogicTests: XCTestCase {
    
    // MARK: - Test Data Factory
    
    private func createPriceCandidates() -> [OCRDataCandidate] {
        return [
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
            )
        ]
    }
    
    private func createLowConfidenceCandidates() -> [OCRDataCandidate] {
        return [
            OCRDataCandidate(
                text: "123",
                boundingBox: CGRect(x: 50, y: 100, width: 30, height: 20),
                confidence: 0.3,
                suggestedType: .number,
                alternativeTypes: [.number, .general]
            ),
            OCRDataCandidate(
                text: "456",
                boundingBox: CGRect(x: 50, y: 130, width: 30, height: 20),
                confidence: 0.4,
                suggestedType: .number,
                alternativeTypes: [.number, .general]
            )
        ]
    }
    
    private func createMixedTypeCandidates() -> [OCRDataCandidate] {
        return [
            OCRDataCandidate(
                text: "123",
                boundingBox: CGRect(x: 50, y: 100, width: 30, height: 20),
                confidence: 0.8,
                suggestedType: .number,
                alternativeTypes: [.number, .general]
            ),
            OCRDataCandidate(
                text: "123",
                boundingBox: CGRect(x: 50, y: 130, width: 30, height: 20),
                confidence: 0.7,
                suggestedType: .idNumber,
                alternativeTypes: [.idNumber, .number]
            )
        ]
    }
    
    private func createHighConfidenceCandidates() -> [OCRDataCandidate] {
        return [
            OCRDataCandidate(
                text: "$12.50",
                boundingBox: CGRect(x: 100, y: 200, width: 60, height: 20),
                confidence: 0.95,
                suggestedType: .price,
                alternativeTypes: [.price]
            )
        ]
    }
    
    // MARK: - Disambiguation Logic Tests
    
    func testShouldRequireDisambiguation_WithLowConfidence() {
        // Given
        let candidates = createLowConfidenceCandidates()
        
        // When
        let result = shouldRequireDisambiguation(candidates: candidates)
        
        // Then
        XCTAssertTrue(result, "Should require disambiguation for low confidence candidates")
    }
    
    func testShouldRequireDisambiguation_WithMixedTypes() {
        // Given
        let candidates = createMixedTypeCandidates()
        
        // When
        let result = shouldRequireDisambiguation(candidates: candidates)
        
        // Then
        XCTAssertTrue(result, "Should require disambiguation for identical text with different types")
    }
    
    func testShouldRequireDisambiguation_WithHighConfidence() {
        // Given
        let candidates = createHighConfidenceCandidates()
        
        // When
        let result = shouldRequireDisambiguation(candidates: candidates)
        
        // Then
        XCTAssertFalse(result, "Should not require disambiguation for high confidence single candidate")
    }
    
    func testShouldRequireDisambiguation_WithEmptyCandidates() {
        // Given
        let candidates: [OCRDataCandidate] = []
        
        // When
        let result = shouldRequireDisambiguation(candidates: candidates)
        
        // Then
        XCTAssertFalse(result, "Should not require disambiguation for empty candidates")
    }
    
    func testShouldRequireDisambiguation_WithSingleCandidate() {
        // Given
        let candidates = [createHighConfidenceCandidates().first!]
        
        // When
        let result = shouldRequireDisambiguation(candidates: candidates)
        
        // Then
        XCTAssertFalse(result, "Should not require disambiguation for single candidate")
    }
    
    // MARK: - Disambiguation Result Creation Tests
    
    func testCreateDisambiguationResult_WithHighConfidence() {
        // Given
        let candidates = createHighConfidenceCandidates()
        let config = OCRDisambiguationConfiguration(confidenceThreshold: 0.8)
        
        // When
        let result = createDisambiguationResult(from: candidates, configuration: config)
        
        // Then
        XCTAssertFalse(result.requiresUserSelection, "High confidence should not require user selection")
        XCTAssertEqual(result.confidence, 0.95, accuracy: 0.01, "Confidence should match candidate confidence")
        XCTAssertEqual(result.candidates.count, 1, "Should have one candidate")
    }
    
    func testCreateDisambiguationResult_WithLowConfidence() {
        // Given
        let candidates = createLowConfidenceCandidates()
        let config = OCRDisambiguationConfiguration(confidenceThreshold: 0.8)
        
        // When
        let result = createDisambiguationResult(from: candidates, configuration: config)
        
        // Then
        XCTAssertTrue(result.requiresUserSelection, "Low confidence should require user selection")
        XCTAssertEqual(result.confidence, 0.35, accuracy: 0.01, "Confidence should be average of candidates")
        XCTAssertEqual(result.candidates.count, 2, "Should have two candidates")
    }
    
    func testCreateDisambiguationResult_WithMaxCandidatesLimit() {
        // Given
        let candidates = createPriceCandidates() + createLowConfidenceCandidates()
        let config = OCRDisambiguationConfiguration(maxCandidates: 2)
        
        // When
        let result = createDisambiguationResult(from: candidates, configuration: config)
        
        // Then
        XCTAssertEqual(result.candidates.count, 2, "Should respect maxCandidates limit")
    }
    
    func testCreateDisambiguationResult_WithEmptyCandidates() {
        // Given
        let candidates: [OCRDataCandidate] = []
        let config = OCRDisambiguationConfiguration()
        
        // When
        let result = createDisambiguationResult(from: candidates, configuration: config)
        
        // Then
        XCTAssertFalse(result.requiresUserSelection, "Empty candidates should not require selection")
        XCTAssertEqual(result.confidence, 0.0, accuracy: 0.01, "Empty candidates should have zero confidence")
        XCTAssertEqual(result.candidates.count, 0, "Should have no candidates")
    }
    
    // MARK: - Candidate Filtering Tests
    
    func testFilterCandidatesByConfidence_WithThreshold() {
        // Given
        let candidates = createPriceCandidates() + createLowConfidenceCandidates()
        let threshold: Float = 0.5
        
        // When
        let filtered = filterCandidatesByConfidence(candidates, threshold: threshold)
        
        // Then
        XCTAssertEqual(filtered.count, 2, "Should filter out low confidence candidates")
        for candidate in filtered {
            XCTAssertGreaterThanOrEqual(candidate.confidence, threshold, "All filtered candidates should meet threshold")
        }
    }
    
    func testFilterCandidatesByConfidence_WithHighThreshold() {
        // Given
        let candidates = createPriceCandidates()
        let threshold: Float = 0.98
        
        // When
        let filtered = filterCandidatesByConfidence(candidates, threshold: threshold)
        
        // Then
        XCTAssertEqual(filtered.count, 0, "Should filter out all candidates with high threshold")
    }
    
    func testFilterCandidatesByConfidence_WithLowThreshold() {
        // Given
        let candidates = createLowConfidenceCandidates()
        let threshold: Float = 0.1
        
        // When
        let filtered = filterCandidatesByConfidence(candidates, threshold: threshold)
        
        // Then
        XCTAssertEqual(filtered.count, 2, "Should keep all candidates with low threshold")
    }
    
    // MARK: - Candidate Sorting Tests
    
    func testSortCandidatesByConfidence_HighestFirst() {
        // Given
        let candidates = createLowConfidenceCandidates() + createPriceCandidates()
        
        // When
        let sorted = sortCandidatesByConfidence(candidates)
        
        // Then
        XCTAssertEqual(sorted.count, 4, "Should have all candidates")
        for i in 0..<(sorted.count - 1) {
            XCTAssertGreaterThanOrEqual(sorted[i].confidence, sorted[i + 1].confidence, "Should be sorted by confidence descending")
        }
    }
    
    func testSortCandidatesByConfidence_WithEqualConfidence() {
        // Given
        let candidates = [
            OCRDataCandidate(
                text: "A",
                boundingBox: CGRect(x: 0, y: 0, width: 100, height: 20),
                confidence: 0.5,
                suggestedType: .general,
                alternativeTypes: [.general]
            ),
            OCRDataCandidate(
                text: "B",
                boundingBox: CGRect(x: 0, y: 20, width: 100, height: 20),
                confidence: 0.5,
                suggestedType: .general,
                alternativeTypes: [.general]
            )
        ]
        
        // When
        let sorted = sortCandidatesByConfidence(candidates)
        
        // Then
        XCTAssertEqual(sorted.count, 2, "Should have both candidates")
        // Order is not guaranteed for equal confidence, just verify both are present
        let texts = Set(sorted.map { $0.text })
        XCTAssertTrue(texts.contains("A"), "Should contain first candidate")
        XCTAssertTrue(texts.contains("B"), "Should contain second candidate")
    }
    
    // MARK: - Candidate Grouping Tests
    
    func testGroupCandidatesByType() {
        // Given
        let candidates = createPriceCandidates() + createLowConfidenceCandidates()
        
        // When
        let grouped = groupCandidatesByType(candidates)
        
        // Then
        XCTAssertEqual(grouped[.price]?.count, 2, "Should have 2 price candidates")
        XCTAssertEqual(grouped[.number]?.count, 2, "Should have 2 number candidates")
        XCTAssertNil(grouped[.email], "Should not have email candidates")
    }
    
    func testGroupCandidatesByType_WithEmptyCandidates() {
        // Given
        let candidates: [OCRDataCandidate] = []
        
        // When
        let grouped = groupCandidatesByType(candidates)
        
        // Then
        XCTAssertTrue(grouped.isEmpty, "Should have empty groups for empty candidates")
    }
    
    func testFindIdenticalTextCandidates() {
        // Given
        let candidates = createMixedTypeCandidates()
        
        // When
        let identical = findIdenticalTextCandidates(candidates)
        
        // Then
        XCTAssertEqual(identical["123"]?.count, 2, "Should find 2 candidates with identical text")
        XCTAssertEqual(identical.count, 1, "Should have only one group of identical text")
    }
    
    func testFindIdenticalTextCandidates_WithUniqueText() {
        // Given
        let candidates = createPriceCandidates()
        
        // When
        let identical = findIdenticalTextCandidates(candidates)
        
        // Then
        XCTAssertEqual(identical.count, 2, "Should have 2 groups for unique text")
        XCTAssertEqual(identical["$12.50"]?.count, 1, "Should have 1 candidate for first price")
        XCTAssertEqual(identical["$15.99"]?.count, 1, "Should have 1 candidate for second price")
    }
    
    // MARK: - Configuration Tests
    
    func testOCRDisambiguationConfiguration_DefaultValues() {
        // Given
        let config = OCRDisambiguationConfiguration()
        
        // Then
        XCTAssertEqual(config.confidenceThreshold, 0.8, "Default confidence threshold should be 0.8")
        XCTAssertEqual(config.maxCandidates, 5, "Default max candidates should be 5")
        XCTAssertTrue(config.enableCustomText, "Default should enable custom text")
        XCTAssertTrue(config.showBoundingBoxes, "Default should show bounding boxes")
        XCTAssertTrue(config.allowSkip, "Default should allow skip")
    }
    
    func testOCRDisambiguationConfiguration_CustomValues() {
        // Given
        let config = OCRDisambiguationConfiguration(
            confidenceThreshold: 0.95,
            maxCandidates: 3,
            enableCustomText: false,
            showBoundingBoxes: false,
            allowSkip: false
        )
        
        // Then
        XCTAssertEqual(config.confidenceThreshold, 0.95, "Custom confidence threshold should be set")
        XCTAssertEqual(config.maxCandidates, 3, "Custom max candidates should be set")
        XCTAssertFalse(config.enableCustomText, "Custom should disable custom text")
        XCTAssertFalse(config.showBoundingBoxes, "Custom should hide bounding boxes")
        XCTAssertFalse(config.allowSkip, "Custom should not allow skip")
    }
    
    // MARK: - OCRDataCandidate Tests
    
    func testOCRDataCandidate_Equality() {
        // Given
        let candidate1 = OCRDataCandidate(
            text: "test",
            boundingBox: CGRect(x: 0, y: 0, width: 100, height: 20),
            confidence: 0.8,
            suggestedType: .general,
            alternativeTypes: [.general]
        )
        let candidate2 = OCRDataCandidate(
            text: "test",
            boundingBox: CGRect(x: 0, y: 0, width: 100, height: 20),
            confidence: 0.8,
            suggestedType: .general,
            alternativeTypes: [.general]
        )
        
        // When & Then
        XCTAssertEqual(candidate1, candidate2, "Candidates with same data should be equal")
    }
    
    func testOCRDataCandidate_Inequality() {
        // Given
        let candidate1 = OCRDataCandidate(
            text: "test1",
            boundingBox: CGRect(x: 0, y: 0, width: 100, height: 20),
            confidence: 0.8,
            suggestedType: .general,
            alternativeTypes: [.general]
        )
        let candidate2 = OCRDataCandidate(
            text: "test2",
            boundingBox: CGRect(x: 0, y: 0, width: 100, height: 20),
            confidence: 0.8,
            suggestedType: .general,
            alternativeTypes: [.general]
        )
        
        // When & Then
        XCTAssertNotEqual(candidate1, candidate2, "Candidates with different text should not be equal")
    }
    
    // MARK: - OCRDisambiguationResult Tests
    
    func testOCRDisambiguationResult_Initialization() {
        // Given
        let candidates = createPriceCandidates()
        let confidence: Float = 0.9
        let requiresSelection = true
        
        // When
        let result = OCRDisambiguationResult(
            candidates: candidates,
            confidence: confidence,
            requiresUserSelection: requiresSelection
        )
        
        // Then
        XCTAssertEqual(result.candidates.count, 2, "Should have correct number of candidates")
        XCTAssertEqual(result.confidence, confidence, "Should have correct confidence")
        XCTAssertEqual(result.requiresUserSelection, requiresSelection, "Should have correct requires selection flag")
    }
    
    // MARK: - OCRDisambiguationSelection Tests
    
    func testOCRDisambiguationSelection_Initialization() {
        // Given
        let candidateId = UUID()
        let selectedType = TextType.price
        let customText = "Custom text"
        
        // When
        let selection = OCRDisambiguationSelection(
            candidateId: candidateId,
            selectedType: selectedType,
            customText: customText
        )
        
        // Then
        XCTAssertEqual(selection.candidateId, candidateId, "Should have correct candidate ID")
        XCTAssertEqual(selection.selectedType, selectedType, "Should have correct selected type")
        XCTAssertEqual(selection.customText, customText, "Should have correct custom text")
    }
    
    func testOCRDisambiguationSelection_WithoutCustomText() {
        // Given
        let candidateId = UUID()
        let selectedType = TextType.number
        
        // When
        let selection = OCRDisambiguationSelection(
            candidateId: candidateId,
            selectedType: selectedType
        )
        
        // Then
        XCTAssertEqual(selection.candidateId, candidateId, "Should have correct candidate ID")
        XCTAssertEqual(selection.selectedType, selectedType, "Should have correct selected type")
        XCTAssertNil(selection.customText, "Should have nil custom text")
    }
    
    // MARK: - Edge Cases and Error Handling
    
    func testDisambiguationLogic_WithExtremeConfidenceValues() {
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
        
        // When
        let result = shouldRequireDisambiguation(candidates: candidates)
        
        // Then
        XCTAssertTrue(result, "Should require disambiguation for extreme confidence difference")
    }
    
    func testDisambiguationLogic_WithVerySimilarConfidence() {
        // Given
        let candidates = [
            OCRDataCandidate(
                text: "A",
                boundingBox: CGRect(x: 0, y: 0, width: 100, height: 20),
                confidence: 0.8,
                suggestedType: .general,
                alternativeTypes: [.general]
            ),
            OCRDataCandidate(
                text: "B",
                boundingBox: CGRect(x: 0, y: 20, width: 100, height: 20),
                confidence: 0.81,
                suggestedType: .general,
                alternativeTypes: [.general]
            )
        ]
        
        // When
        let result = shouldRequireDisambiguation(candidates: candidates)
        
        // Then
        XCTAssertFalse(result, "Should not require disambiguation for very similar confidence")
    }
    
    func testDisambiguationLogic_WithManyCandidates() {
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
        
        // When
        let result = shouldRequireDisambiguation(candidates: candidates)
        
        // Then
        // Should handle large number of candidates without crashing
        XCTAssertNotNil(result, "Should handle many candidates")
    }
}
