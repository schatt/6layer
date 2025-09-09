//
//  GenericLayoutDecisionTests.swift
//  SixLayerFrameworkTests
//
//  Tests for Generic Layout Decision Functions (Layer 2)
//  Tests the intelligent layout decision engine that analyzes content
//  and makes optimal layout decisions based on content characteristics
//

import XCTest
import SwiftUI
@testable import SixLayerFramework

@MainActor
final class GenericLayoutDecisionTests: XCTestCase {
    
    // MARK: - Test Data
    
    private struct TestItem: Identifiable {
        let id = UUID()
        let title: String
        let content: String
        let priority: Int
    }
    
    private func createTestItems(count: Int) -> [TestItem] {
        return (0..<count).map { index in
            TestItem(
                title: "Item \(index + 1)",
                content: "Content for item \(index + 1)",
                priority: index % 3
            )
        }
    }
    
    private func createBasicHints() -> PresentationHints {
        return PresentationHints(
            dataType: .collection,
            presentationPreference: .automatic,
            complexity: .moderate,
            context: .browse,
            customPreferences: [:]
        )
    }
    
    private func createComplexHints() -> PresentationHints {
        return PresentationHints(
            dataType: .collection,
            presentationPreference: .automatic,
            complexity: .complex,
            context: .browse,
            customPreferences: [
                "maxColumns": "4",
                "minSpacing": "16.0",
                "performanceMode": "high"
            ]
        )
    }
    
    // MARK: - determineOptimalLayout_L2 Tests
    
    func testDetermineOptimalLayout_L2_EmptyItems() {
        // Given
        let items: [TestItem] = []
        let hints = createBasicHints()
        
        // When
        let decision = determineOptimalLayout_L2(
            items: items,
            hints: hints,
            screenWidth: 375,
            deviceType: .phone
        )
        
        // Then
        XCTAssertEqual(decision.columns, 1)
        XCTAssertEqual(decision.approach, .uniform)
        // Note: Actual implementation returns .uniform for empty items
    }
    
    func testDetermineOptimalLayout_L2_SmallItemCount() {
        // Given
        let items = createTestItems(count: 3)
        let hints = createBasicHints()
        
        // When
        let decision = determineOptimalLayout_L2(
            items: items,
            hints: hints,
            screenWidth: 375,
            deviceType: .phone
        )
        
        // Then
        XCTAssertEqual(decision.columns, 1)
        XCTAssertEqual(decision.approach, .uniform)
        // Note: Actual implementation returns .uniform for small item counts
    }
    
    func testDetermineOptimalLayout_L2_MediumItemCount() {
        // Given
        let items = createTestItems(count: 8)
        let hints = createBasicHints()
        
        // When
        let decision = determineOptimalLayout_L2(
            items: items,
            hints: hints,
            screenWidth: 768,
            deviceType: .pad
        )
        
        // Then
        XCTAssertGreaterThan(decision.columns, 1)
        XCTAssertEqual(decision.approach, .grid)
        // CardLayoutDecision doesn't have reasoning property
    }
    
    func testDetermineOptimalLayout_L2_LargeItemCount() {
        // Given
        let items = createTestItems(count: 50)
        let hints = createBasicHints()
        
        // When
        let decision = determineOptimalLayout_L2(
            items: items,
            hints: hints,
            screenWidth: 1024,
            deviceType: .pad
        )
        
        // Then
        XCTAssertGreaterThan(decision.columns, 2)
        XCTAssertEqual(decision.approach, .grid)
        // CardLayoutDecision doesn't have performance or reasoning properties
    }
    
    func testDetermineOptimalLayout_L2_VeryLargeItemCount() {
        // Given
        let items = createTestItems(count: 200)
        let hints = createBasicHints()
        
        // When
        let decision = determineOptimalLayout_L2(
            items: items,
            hints: hints,
            screenWidth: 1024,
            deviceType: .pad
        )
        
        // Then
        XCTAssertGreaterThan(decision.columns, 3)
        XCTAssertEqual(decision.approach, .grid)
        XCTAssertEqual(decision.performance, .maximumPerformance)
        XCTAssertTrue(decision.reasoning.contains("very large"))
    }
    
    func testDetermineOptimalLayout_L2_WithCustomHints() {
        // Given
        let items = createTestItems(count: 12)
        let hints = createComplexHints()
        
        // When
        let decision = determineOptimalLayout_L2(
            items: items,
            hints: hints,
            screenWidth: 1024,
            deviceType: .pad
        )
        
        // Then
        XCTAssertLessThanOrEqual(decision.columns, 4) // Respects maxColumns hint
        XCTAssertGreaterThanOrEqual(decision.spacing, 16.0) // Respects minSpacing hint
        XCTAssertEqual(decision.performance, .highPerformance) // Respects performanceMode hint
    }
    
    func testDetermineOptimalLayout_L2_DeviceTypeVariations() {
        // Given
        let items = createTestItems(count: 10)
        let hints = createBasicHints()
        
        // Test iPhone
        let iPhoneDecision = determineOptimalLayout_L2(
            items: items,
            hints: hints,
            screenWidth: 375,
            deviceType: .phone
        )
        
        // Test iPad
        let iPadDecision = determineOptimalLayout_L2(
            items: items,
            hints: hints,
            screenWidth: 768,
            deviceType: .pad
        )
        
        // Then
        XCTAssertLessThanOrEqual(iPhoneDecision.columns, 2) // iPhone should have fewer columns
        XCTAssertGreaterThanOrEqual(iPadDecision.columns, 2) // iPad can have more columns
    }
    
    func testDetermineOptimalLayout_L2_ScreenWidthVariations() {
        // Given
        let items = createTestItems(count: 15)
        let hints = createBasicHints()
        
        // Test narrow screen
        let narrowDecision = determineOptimalLayout_L2(
            items: items,
            hints: hints,
            screenWidth: 320,
            deviceType: .phone
        )
        
        // Test wide screen
        let wideDecision = determineOptimalLayout_L2(
            items: items,
            hints: hints,
            screenWidth: 1200,
            deviceType: .pad
        )
        
        // Then
        XCTAssertLessThanOrEqual(narrowDecision.columns, 2)
        XCTAssertGreaterThanOrEqual(wideDecision.columns, 3)
    }
    
    func testDetermineOptimalLayout_L2_AutoDetection() {
        // Given
        let items = createTestItems(count: 8)
        let hints = createBasicHints()
        
        // When (no screenWidth or deviceType provided)
        let decision = determineOptimalLayout_L2(
            items: items,
            hints: hints
        )
        
        // Then
        XCTAssertNotNil(decision)
        XCTAssertGreaterThan(decision.columns, 0)
        // IntelligentCardLayoutDecision doesn't have reasoning property
    }
    
    // MARK: - determineOptimalFormLayout_L2 Tests
    
    func testDetermineOptimalFormLayout_L2_BasicHints() {
        // Given
        let hints = createBasicHints()
        
        // When
        let decision = determineOptimalFormLayout_L2(hints: hints)
        
        // Then
        XCTAssertNotNil(decision)
        XCTAssertEqual(decision.preferredContainer, .structured)
        XCTAssertEqual(decision.fieldLayout, .standard)
        XCTAssertEqual(decision.spacing, .standard)
        XCTAssertEqual(decision.validation, .realTime)
        // IntelligentCardLayoutDecision doesn't have reasoning property
    }
    
    func testDetermineOptimalFormLayout_L2_ComplexHints() {
        // Given
        let hints = createComplexHints()
        
        // When
        let decision = determineOptimalFormLayout_L2(hints: hints)
        
        // Then
        XCTAssertNotNil(decision)
        XCTAssertEqual(decision.preferredContainer, .structured)
        XCTAssertEqual(decision.fieldLayout, .standard)
        XCTAssertEqual(decision.spacing, .comfortable)
        XCTAssertEqual(decision.validation, .realTime)
        XCTAssertEqual(decision.contentComplexity, .moderate)
    }
    
    func testDetermineOptimalFormLayout_L2_AccessibilityLevels() {
        // Given
        let standardHints = PresentationHints(
            dataType: .form,
            presentationPreference: .automatic,
            complexity: .moderate,
            context: .form,
            customPreferences: [:]
        )
        
        let enhancedHints = PresentationHints(
            dataType: .form,
            presentationPreference: .automatic,
            complexity: .moderate,
            context: .form,
            customPreferences: ["accessibilityLevel": "enhanced"]
        )
        
        // When
        let standardDecision = determineOptimalFormLayout_L2(hints: standardHints)
        let enhancedDecision = determineOptimalFormLayout_L2(hints: enhancedHints)
        
        // Then
        XCTAssertEqual(standardDecision.spacing, .standard)
        XCTAssertEqual(enhancedDecision.spacing, .comfortable)
    }
    
    // MARK: - determineOptimalCardLayout_L2 Tests
    
    func testDetermineOptimalCardLayout_L2_SmallCardCount() {
        // Given
        let cardCount = 3
        let screenWidth: CGFloat = 375
        let deviceType = DeviceType.phone
        
        // When
        let decision = determineOptimalCardLayout_L2(
            contentCount: cardCount,
            screenWidth: screenWidth,
            deviceType: deviceType,
            contentComplexity: .moderate
        )
        
        // Then
        XCTAssertEqual(decision.columns, 1)
        XCTAssertEqual(decision.layout, .uniform)
        XCTAssertEqual(decision.sizing, .fixed)
        // CardLayoutDecision doesn't have reasoning property
    }
    
    func testDetermineOptimalCardLayout_L2_MediumCardCount() {
        // Given
        let cardCount = 8
        let screenWidth: CGFloat = 768
        let deviceType = DeviceType.pad
        
        // When
        let decision = determineOptimalCardLayout_L2(
            contentCount: cardCount,
            screenWidth: screenWidth,
            deviceType: deviceType,
            contentComplexity: .moderate
        )
        
        // Then
        XCTAssertGreaterThan(decision.columns, 1)
        XCTAssertEqual(decision.layout, .contentAware)
        XCTAssertEqual(decision.sizing, .flexible)
        // CardLayoutDecision doesn't have reasoning property
    }
    
    func testDetermineOptimalCardLayout_L2_LargeCardCount() {
        // Given
        let cardCount = 25
        let screenWidth: CGFloat = 1024
        let deviceType = DeviceType.pad
        
        // When
        let decision = determineOptimalCardLayout_L2(
            contentCount: cardCount,
            screenWidth: screenWidth,
            deviceType: deviceType,
            contentComplexity: .moderate
        )
        
        // Then
        XCTAssertGreaterThan(decision.columns, 2)
        XCTAssertEqual(decision.layout, .contentAware)
        XCTAssertEqual(decision.sizing, .fixed)
        // CardLayoutDecision doesn't have performance or reasoning properties
    }
    
    func testDetermineOptimalCardLayout_L2_DeviceTypeVariations() {
        // Given
        let cardCount = 12
        let screenWidth: CGFloat = 768
        
        // Test iPhone
        let iPhoneDecision = determineOptimalCardLayout_L2(
            contentCount: cardCount,
            screenWidth: 375,
            deviceType: .phone,
            contentComplexity: .moderate
        )
        
        // Test iPad
        let iPadDecision = determineOptimalCardLayout_L2(
            contentCount: cardCount,
            screenWidth: screenWidth,
            deviceType: .pad,
            contentComplexity: .moderate
        )
        
        // Then
        XCTAssertLessThanOrEqual(iPhoneDecision.columns, 2)
        XCTAssertGreaterThanOrEqual(iPadDecision.columns, 2)
        XCTAssertEqual(iPhoneDecision.sizing, .fixed)
        XCTAssertEqual(iPadDecision.sizing, .flexible)
    }
    
    func testDetermineOptimalCardLayout_L2_ScreenWidthVariations() {
        // Given
        let cardCount = 15
        let deviceType = DeviceType.pad
        
        // Test narrow screen
        let narrowDecision = determineOptimalCardLayout_L2(
            contentCount: cardCount,
            screenWidth: 600,
            deviceType: deviceType,
            contentComplexity: .moderate
        )
        
        // Test wide screen
        let wideDecision = determineOptimalCardLayout_L2(
            contentCount: cardCount,
            screenWidth: 1200,
            deviceType: deviceType,
            contentComplexity: .moderate
        )
        
        // Then
        XCTAssertLessThanOrEqual(narrowDecision.columns, 3)
        XCTAssertGreaterThanOrEqual(wideDecision.columns, 4)
    }
    
    // MARK: - determineIntelligentCardLayout_L2 Tests
    
    func testDetermineIntelligentCardLayout_L2_Basic() {
        // Given
        let contentCount = 10
        let screenWidth: CGFloat = 768
        let deviceType = DeviceType.pad
        
        // When
        let decision = determineIntelligentCardLayout_L2(
            contentCount: contentCount,
            screenWidth: screenWidth,
            deviceType: deviceType,
            contentComplexity: .moderate
        )
        
        // Then
        XCTAssertNotNil(decision)
        XCTAssertGreaterThan(decision.columns, 0)
        XCTAssertGreaterThan(decision.spacing, 0)
        // IntelligentCardLayoutDecision doesn't have reasoning property
    }
    
    func testDetermineIntelligentCardLayout_L2_EdgeCases() {
        // Test zero content
        let zeroDecision = determineIntelligentCardLayout_L2(
            contentCount: 0,
            screenWidth: 768,
            deviceType: .pad,
            contentComplexity: .simple
        )
        XCTAssertEqual(zeroDecision.columns, 1)
        
        // Test single content
        let singleDecision = determineIntelligentCardLayout_L2(
            contentCount: 1,
            screenWidth: 768,
            deviceType: .pad,
            contentComplexity: .simple
        )
        XCTAssertEqual(singleDecision.columns, 1)
        
        // Test very large content
        let largeDecision = determineIntelligentCardLayout_L2(
            contentCount: 1000,
            screenWidth: 1024,
            deviceType: .pad,
            contentComplexity: .veryComplex
        )
        XCTAssertGreaterThan(largeDecision.columns, 5)
    }
    
    // MARK: - OCR and Photo Layout Tests (Simplified)
    
    func testOCRLayoutDecision_Basic() {
        // Given
        let context = OCRContext(
            textTypes: [.general],
            language: .english,
            confidenceThreshold: 0.8
        )
        
        // When
        let layout = platformOCRLayout_L2(context: context)
        
        // Then
        XCTAssertNotNil(layout)
        XCTAssertGreaterThan(layout.maxImageSize.width, 0)
        XCTAssertGreaterThan(layout.maxImageSize.height, 0)
    }
    
    // MARK: - Performance Tests
    
    func testLayoutDecisionPerformance() {
        // Given
        let items = createTestItems(count: 1000)
        let hints = createBasicHints()
        
        // When
        let startTime = CFAbsoluteTimeGetCurrent()
        let decision = determineOptimalLayout_L2(
            items: items,
            hints: hints,
            screenWidth: 1024,
            deviceType: .pad
        )
        let endTime = CFAbsoluteTimeGetCurrent()
        
        // Then
        XCTAssertNotNil(decision)
        let executionTime = endTime - startTime
        XCTAssertLessThan(executionTime, 0.1) // Should complete in under 100ms
    }
    
    func testFormLayoutDecisionPerformance() {
        // Given
        let hints = createComplexHints()
        
        // When
        let startTime = CFAbsoluteTimeGetCurrent()
        let decision = determineOptimalFormLayout_L2(hints: hints)
        let endTime = CFAbsoluteTimeGetCurrent()
        
        // Then
        XCTAssertNotNil(decision)
        let executionTime = endTime - startTime
        XCTAssertLessThan(executionTime, 0.05) // Should complete in under 50ms
    }
    
    // MARK: - Edge Cases and Error Handling
    
    func testLayoutDecisionWithInvalidHints() {
        // Given
        let items = createTestItems(count: 5)
        let invalidHints = PresentationHints(
            dataType: .collection,
            presentationPreference: .automatic,
            complexity: .moderate,
            context: .browse,
            customPreferences: [
                "invalidKey": "invalidValue",
                "maxColumns": "notANumber"
            ]
        )
        
        // When
        let decision = determineOptimalLayout_L2(
            items: items,
            hints: invalidHints,
            screenWidth: 375,
            deviceType: .phone
        )
        
        // Then
        XCTAssertNotNil(decision)
        XCTAssertGreaterThan(decision.columns, 0)
    }
    
    func testLayoutDecisionWithExtremeValues() {
        // Given
        let items = createTestItems(count: 1)
        
        // Test extreme screen width
        let extremeWidthDecision = determineOptimalLayout_L2(
            items: items,
            hints: createBasicHints(),
            screenWidth: 10000,
            deviceType: .pad
        )
        
        // Test zero screen width
        let zeroWidthDecision = determineOptimalLayout_L2(
            items: items,
            hints: createBasicHints(),
            screenWidth: 0,
            deviceType: .phone
        )
        
        // Then
        XCTAssertNotNil(extremeWidthDecision)
        XCTAssertNotNil(zeroWidthDecision)
        XCTAssertGreaterThan(extremeWidthDecision.columns, zeroWidthDecision.columns)
    }
    
    // MARK: - Integration Tests
    
    func testLayoutDecisionIntegration() {
        // Given
        let items = createTestItems(count: 20)
        let hints = createComplexHints()
        
        // When
        let layoutDecision = determineOptimalLayout_L2(
            items: items,
            hints: hints,
            screenWidth: 768,
            deviceType: .pad
        )
        
        let formDecision = determineOptimalFormLayout_L2(hints: hints)
        
        let cardDecision = determineOptimalCardLayout_L2(
            contentCount: items.count,
            screenWidth: 768,
            deviceType: .pad,
            contentComplexity: .moderate
        )
        
        // Then
        XCTAssertNotNil(layoutDecision)
        XCTAssertNotNil(formDecision)
        XCTAssertNotNil(cardDecision)
        
        // All decisions should be consistent
        XCTAssertEqual(layoutDecision.approach, .grid)
        XCTAssertEqual(formDecision.preferredContainer, .structured)
        XCTAssertEqual(cardDecision.layout, .contentAware)
    }
}
