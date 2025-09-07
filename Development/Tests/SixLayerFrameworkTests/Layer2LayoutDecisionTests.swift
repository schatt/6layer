//
//  Layer2LayoutDecisionTests.swift
//  SixLayerFrameworkTests
//
//  Layer 2 (Decision) TDD Tests
//  Tests for determineOptimalLayout_L2 and determineOptimalFormLayout_L2 functions
//

import XCTest
@testable import SixLayerFramework

@MainActor
final class Layer2LayoutDecisionTests: XCTestCase {
    
    // MARK: - Test Data
    
    struct TestItem: Identifiable {
        let id = UUID()
        let title: String
        let content: String
    }
    
    // MARK: - determineOptimalLayout_L2 Tests
    
    func testDetermineOptimalLayout_L2_SimpleContent() {
        // Given: Simple content with few items
        let items = [
            TestItem(title: "Item 1", content: "Simple content"),
            TestItem(title: "Item 2", content: "Simple content")
        ]
        let hints = PresentationHints(
            dataType: .text,
            presentationPreference: .list,
            complexity: .simple,
            context: .dashboard
        )
        
        // When: Determining optimal layout
        let decision = determineOptimalLayout_L2(
            items: items,
            hints: hints,
            screenWidth: 375,
            deviceType: .phone
        )
        
        // Then: Should return appropriate layout decision
        XCTAssertNotNil(decision)
        XCTAssertTrue(decision.columns > 0)
        XCTAssertTrue(decision.spacing >= 0)
        XCTAssertFalse(decision.reasoning.isEmpty)
        XCTAssertEqual(decision.performance, .standard) // Simple content should use standard performance
    }
    
    func testDetermineOptimalLayout_L2_ComplexContent() {
        // Given: Complex content with many items
        let items = (1...50).map { i in
            TestItem(title: "Item \(i)", content: "Complex content with lots of information")
        }
        let hints = PresentationHints(
            dataType: .collection,
            presentationPreference: .grid,
            complexity: .complex,
            context: .dashboard
        )
        
        // When: Determining optimal layout
        let decision = determineOptimalLayout_L2(
            items: items,
            hints: hints,
            screenWidth: 1024,
            deviceType: .mac
        )
        
        // Then: Should return appropriate layout decision
        XCTAssertNotNil(decision)
        XCTAssertTrue(decision.columns > 1) // Complex content should use multiple columns
        XCTAssertTrue(decision.spacing > 0)
        XCTAssertFalse(decision.reasoning.isEmpty)
        XCTAssertEqual(decision.performance, .maximumPerformance) // 50 items = veryComplex = maximumPerformance
    }
    
    func testDetermineOptimalLayout_L2_DifferentDeviceTypes() {
        // Given: Same content for different device types
        let items = (1...20).map { i in
            TestItem(title: "Item \(i)", content: "Content")
        }
        let hints = PresentationHints(
            dataType: .collection,
            presentationPreference: .grid,
            complexity: .moderate,
            context: .dashboard
        )
        
        // When: Testing different device types
        let phoneDecision = determineOptimalLayout_L2(
            items: items,
            hints: hints,
            screenWidth: 375,
            deviceType: .phone
        )
        
        let padDecision = determineOptimalLayout_L2(
            items: items,
            hints: hints,
            screenWidth: 768,
            deviceType: .pad
        )
        
        let macDecision = determineOptimalLayout_L2(
            items: items,
            hints: hints,
            screenWidth: 1440,
            deviceType: .mac
        )
        
        // Then: Should return different decisions based on device capabilities
        XCTAssertNotNil(phoneDecision)
        XCTAssertNotNil(padDecision)
        XCTAssertNotNil(macDecision)
        
        // Mac should generally have more columns than phone
        XCTAssertGreaterThanOrEqual(macDecision.columns, phoneDecision.columns)
        // Pad should be between phone and mac
        XCTAssertGreaterThanOrEqual(padDecision.columns, phoneDecision.columns)
        XCTAssertLessThanOrEqual(padDecision.columns, macDecision.columns)
    }
    
    func testDetermineOptimalLayout_L2_DifferentComplexityLevels() {
        // Given: Same items with different complexity hints
        let items = (1...10).map { i in
            TestItem(title: "Item \(i)", content: "Content")
        }
        
        // When: Testing different complexity levels
        let simpleDecision = determineOptimalLayout_L2(
            items: items,
            hints: PresentationHints(
                dataType: .text,
                presentationPreference: .list,
                complexity: .simple,
                context: .dashboard
            ),
            screenWidth: 375,
            deviceType: .phone
        )
        
        let moderateDecision = determineOptimalLayout_L2(
            items: items,
            hints: PresentationHints(
                dataType: .collection,
                presentationPreference: .grid,
                complexity: .moderate,
                context: .dashboard
            ),
            screenWidth: 375,
            deviceType: .phone
        )
        
        let complexDecision = determineOptimalLayout_L2(
            items: items,
            hints: PresentationHints(
                dataType: .collection,
                presentationPreference: .grid,
                complexity: .complex,
                context: .dashboard
            ),
            screenWidth: 375,
            deviceType: .phone
        )
        
        // Then: Performance strategy should increase with item count (not hints complexity)
        XCTAssertEqual(simpleDecision.performance, .highPerformance) // 10 items = complex = highPerformance
        XCTAssertEqual(moderateDecision.performance, .highPerformance) // 10 items = complex = highPerformance  
        XCTAssertEqual(complexDecision.performance, .highPerformance) // 10 items = complex = highPerformance
    }
    
    func testDetermineOptimalLayout_L2_EmptyItems() {
        // Given: Empty items array
        let items: [TestItem] = []
        let hints = PresentationHints(
            dataType: .collection,
            presentationPreference: .list,
            complexity: .simple,
            context: .dashboard
        )
        
        // When: Determining optimal layout
        let decision = determineOptimalLayout_L2(
            items: items,
            hints: hints,
            screenWidth: 375,
            deviceType: .phone
        )
        
        // Then: Should handle empty array gracefully
        XCTAssertNotNil(decision)
        XCTAssertTrue(decision.columns >= 1) // Should have at least 1 column
        XCTAssertTrue(decision.spacing >= 0)
        XCTAssertFalse(decision.reasoning.isEmpty)
    }
    
    func testDetermineOptimalLayout_L2_WithoutDeviceContext() {
        // Given: Items without explicit device context
        let items = (1...5).map { i in
            TestItem(title: "Item \(i)", content: "Content")
        }
        let hints = PresentationHints(
            dataType: .text,
            presentationPreference: .list,
            complexity: .simple,
            context: .dashboard
        )
        
        // When: Determining optimal layout without device context
        let decision = determineOptimalLayout_L2(
            items: items,
            hints: hints
        )
        
        // Then: Should use auto-detection and return valid decision
        XCTAssertNotNil(decision)
        XCTAssertTrue(decision.columns > 0)
        XCTAssertTrue(decision.spacing >= 0)
        XCTAssertFalse(decision.reasoning.isEmpty)
    }
    
    // MARK: - determineOptimalFormLayout_L2 Tests
    
    func testDetermineOptimalFormLayout_L2_SimpleForm() {
        // Given: Simple form hints
        let hints = PresentationHints(
            dataType: .form,
            presentationPreference: .form,
            complexity: .simple,
            context: .form,
            customPreferences: [
                "fieldCount": "3",
                "hasComplexFields": "false",
                "hasValidation": "false"
            ]
        )
        
        // When: Determining optimal form layout
        let decision = determineOptimalFormLayout_L2(hints: hints)
        
        // Then: Should return appropriate form layout decision
        XCTAssertNotNil(decision)
        XCTAssertEqual(decision.preferredContainer, .adaptive)
        XCTAssertEqual(decision.fieldLayout, .standard)
        XCTAssertEqual(decision.spacing, .comfortable)
        XCTAssertEqual(decision.validation, .none)
        XCTAssertEqual(decision.contentComplexity, .simple)
        XCTAssertFalse(decision.reasoning.isEmpty)
    }
    
    func testDetermineOptimalFormLayout_L2_ComplexForm() {
        // Given: Complex form hints
        let hints = PresentationHints(
            dataType: .form,
            presentationPreference: .form,
            complexity: .complex,
            context: .form,
            customPreferences: [
                "fieldCount": "10",
                "hasComplexFields": "true",
                "hasValidation": "true"
            ]
        )
        
        // When: Determining optimal form layout
        let decision = determineOptimalFormLayout_L2(hints: hints)
        
        // Then: Should return appropriate form layout decision
        XCTAssertNotNil(decision)
        XCTAssertEqual(decision.preferredContainer, .adaptive)
        XCTAssertEqual(decision.fieldLayout, .standard)
        XCTAssertEqual(decision.spacing, .comfortable)
        XCTAssertEqual(decision.validation, .realTime)
        XCTAssertEqual(decision.contentComplexity, .complex)
        XCTAssertFalse(decision.reasoning.isEmpty)
    }
    
    func testDetermineOptimalFormLayout_L2_ModerateForm() {
        // Given: Moderate form hints
        let hints = PresentationHints(
            dataType: .form,
            presentationPreference: .form,
            complexity: .moderate,
            context: .form,
            customPreferences: [
                "fieldCount": "6",
                "hasComplexFields": "false",
                "hasValidation": "true"
            ]
        )
        
        // When: Determining optimal form layout
        let decision = determineOptimalFormLayout_L2(hints: hints)
        
        // Then: Should return appropriate form layout decision
        XCTAssertNotNil(decision)
        XCTAssertEqual(decision.preferredContainer, .adaptive)
        XCTAssertEqual(decision.fieldLayout, .standard)
        XCTAssertEqual(decision.spacing, .comfortable)
        XCTAssertEqual(decision.validation, .realTime)
        XCTAssertEqual(decision.contentComplexity, .moderate)
        XCTAssertFalse(decision.reasoning.isEmpty)
    }
    
    func testDetermineOptimalFormLayout_L2_DefaultPreferences() {
        // Given: Form hints with default preferences
        let hints = PresentationHints(
            dataType: .form,
            presentationPreference: .form,
            complexity: .moderate,
            context: .form
        )
        
        // When: Determining optimal form layout
        let decision = determineOptimalFormLayout_L2(hints: hints)
        
        // Then: Should use default values
        XCTAssertNotNil(decision)
        XCTAssertEqual(decision.preferredContainer, .adaptive)
        XCTAssertEqual(decision.fieldLayout, .standard)
        XCTAssertEqual(decision.spacing, .comfortable)
        XCTAssertEqual(decision.validation, .none) // Default should be no validation
        XCTAssertEqual(decision.contentComplexity, .moderate) // Default fieldCount=5 = moderate
        XCTAssertFalse(decision.reasoning.isEmpty)
    }
    
    // MARK: - Edge Cases and Error Handling
    
    func testDetermineOptimalLayout_L2_ExtremeValues() {
        // Given: Very large number of items
        let items = (1...1000).map { i in
            TestItem(title: "Item \(i)", content: "Content")
        }
        let hints = PresentationHints(
            dataType: .collection,
            presentationPreference: .grid,
            complexity: .veryComplex,
            context: .dashboard
        )
        
        // When: Determining optimal layout
        let decision = determineOptimalLayout_L2(
            items: items,
            hints: hints,
            screenWidth: 1920,
            deviceType: .mac
        )
        
        // Then: Should handle extreme values gracefully
        XCTAssertNotNil(decision)
        XCTAssertTrue(decision.columns > 0)
        XCTAssertTrue(decision.spacing >= 0)
        XCTAssertEqual(decision.performance, .maximumPerformance) // Very complex should use maximum performance
        XCTAssertFalse(decision.reasoning.isEmpty)
    }
    
    func testDetermineOptimalLayout_L2_DifferentDataTypes() {
        // Given: Different data types
        let items = (1...5).map { i in
            TestItem(title: "Item \(i)", content: "Content")
        }
        
        let dataTypes: [DataTypeHint] = [.text, .number, .date, .image, .collection, .chart, .navigation]
        
        for dataType in dataTypes {
            let hints = PresentationHints(
                dataType: dataType,
                presentationPreference: .list,
                complexity: .moderate,
                context: .dashboard
            )
            
            // When: Determining optimal layout for each data type
            let decision = determineOptimalLayout_L2(
                items: items,
                hints: hints,
                screenWidth: 375,
                deviceType: .phone
            )
            
            // Then: Should return valid decision for each data type
            XCTAssertNotNil(decision, "Should handle data type: \(dataType)")
            XCTAssertTrue(decision.columns > 0, "Should have positive columns for data type: \(dataType)")
            XCTAssertTrue(decision.spacing >= 0, "Should have non-negative spacing for data type: \(dataType)")
            XCTAssertFalse(decision.reasoning.isEmpty, "Should have reasoning for data type: \(dataType)")
        }
    }
    
    // MARK: - Performance Tests
    
    func testDetermineOptimalLayout_L2_Performance() {
        // Given: Large dataset
        let items = (1...1000).map { i in
            TestItem(title: "Item \(i)", content: "Content")
        }
        let hints = PresentationHints(
            dataType: .collection,
            presentationPreference: .grid,
            complexity: .complex,
            context: .dashboard
        )
        
        // When: Measuring performance
        measure {
            _ = determineOptimalLayout_L2(
                items: items,
                hints: hints,
                screenWidth: 1024,
                deviceType: .mac
            )
        }
    }
}
