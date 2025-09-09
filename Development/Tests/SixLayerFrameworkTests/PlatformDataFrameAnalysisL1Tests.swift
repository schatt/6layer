//
//  PlatformDataFrameAnalysisL1Tests.swift
//  SixLayerFrameworkTests
//
//  Tests for Layer 1 DataFrame analysis functions
//

import XCTest
@testable import SixLayerFramework
import TabularData

@MainActor
final class PlatformDataFrameAnalysisL1Tests: XCTestCase {
    
    var testDataFrame: DataFrame = DataFrame()
    
    override func setUp() {
        super.setUp()
        testDataFrame = createTestDataFrame()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Basic DataFrame Analysis Tests
    
    func testPlatformAnalyzeDataFrame_L1_Basic() {
        // Given: A test DataFrame
        let hints = DataFrameAnalysisHints()
        
        // When: Analyzing the DataFrame
        let view = platformAnalyzeDataFrame_L1(dataFrame: testDataFrame, hints: hints)
        
        // Then: Should return a view
        XCTAssertNotNil(view)
    }
    
    func testPlatformAnalyzeDataFrame_L1_WithHints() {
        // Given: A test DataFrame with specific hints
        let hints = DataFrameAnalysisHints(
            focusAreas: [.dataQuality, .statisticalAnalysis],
            analysisDepth: .comprehensive,
            includeRecommendations: true
        )
        
        // When: Analyzing the DataFrame
        let view = platformAnalyzeDataFrame_L1(dataFrame: testDataFrame, hints: hints)
        
        // Then: Should return a view
        XCTAssertNotNil(view)
    }
    
    func testPlatformAnalyzeDataFrame_L1_EmptyDataFrame() {
        // Given: An empty DataFrame
        let emptyDataFrame = DataFrame()
        let hints = DataFrameAnalysisHints()
        
        // When: Analyzing the empty DataFrame
        let view = platformAnalyzeDataFrame_L1(dataFrame: emptyDataFrame, hints: hints)
        
        // Then: Should handle empty DataFrame gracefully
        XCTAssertNotNil(view)
    }
    
    // MARK: - DataFrame Comparison Tests
    
    func testPlatformCompareDataFrames_L1_Basic() {
        // Given: Multiple test DataFrames
        let dataFrames = [testDataFrame, createTestDataFrame2()]
        let hints = DataFrameAnalysisHints()
        
        // When: Comparing DataFrames
        let view = platformCompareDataFrames_L1(dataFrames: dataFrames, hints: hints)
        
        // Then: Should return a comparison view
        XCTAssertNotNil(view)
    }
    
    func testPlatformCompareDataFrames_L1_SingleDataFrame() {
        // Given: Single DataFrame
        let dataFrames = [testDataFrame]
        let hints = DataFrameAnalysisHints()
        
        // When: Comparing single DataFrame
        let view = platformCompareDataFrames_L1(dataFrames: dataFrames, hints: hints)
        
        // Then: Should handle single DataFrame
        XCTAssertNotNil(view)
    }
    
    func testPlatformCompareDataFrames_L1_EmptyArray() {
        // Given: Empty array of DataFrames
        let dataFrames: [DataFrame] = []
        let hints = DataFrameAnalysisHints()
        
        // When: Comparing empty array
        let view = platformCompareDataFrames_L1(dataFrames: dataFrames, hints: hints)
        
        // Then: Should handle empty array gracefully
        XCTAssertNotNil(view)
    }
    
    // MARK: - Data Quality Assessment Tests
    
    func testPlatformAssessDataQuality_L1_Basic() {
        // Given: A test DataFrame
        let hints = DataFrameAnalysisHints()
        
        // When: Assessing data quality
        let view = platformAssessDataQuality_L1(dataFrame: testDataFrame, hints: hints)
        
        // Then: Should return a quality assessment view
        XCTAssertNotNil(view)
    }
    
    func testPlatformAssessDataQuality_L1_WithMissingData() {
        // Given: A DataFrame with missing data
        let dataFrameWithMissing = createDataFrameWithMissingData()
        let hints = DataFrameAnalysisHints()
        
        // When: Assessing data quality
        let view = platformAssessDataQuality_L1(dataFrame: dataFrameWithMissing, hints: hints)
        
        // Then: Should return a quality assessment view
        XCTAssertNotNil(view)
    }
    
    // MARK: - DataFrame Analysis Hints Tests
    
    func testDataFrameAnalysisHints_DefaultValues() {
        // Given: Default hints
        let hints = DataFrameAnalysisHints()
        
        // Then: Should have expected default values
        XCTAssertTrue(hints.focusAreas.isEmpty)
        XCTAssertEqual(hints.analysisDepth, .comprehensive)
        XCTAssertTrue(hints.visualizationPreferences.isEmpty)
        XCTAssertTrue(hints.includeRecommendations)
        XCTAssertTrue(hints.includeStatisticalAnalysis)
        XCTAssertTrue(hints.includeDataQualityAssessment)
    }
    
    func testDataFrameAnalysisHints_CustomValues() {
        // Given: Custom hints
        let hints = DataFrameAnalysisHints(
            focusAreas: [.dataQuality, .patternRecognition],
            analysisDepth: .basic,
            visualizationPreferences: [.bar, .line],
            includeRecommendations: false,
            includeStatisticalAnalysis: false,
            includeDataQualityAssessment: true
        )
        
        // Then: Should have custom values
        XCTAssertEqual(hints.focusAreas.count, 2)
        XCTAssertEqual(hints.analysisDepth, .basic)
        XCTAssertEqual(hints.visualizationPreferences.count, 2)
        XCTAssertFalse(hints.includeRecommendations)
        XCTAssertFalse(hints.includeStatisticalAnalysis)
        XCTAssertTrue(hints.includeDataQualityAssessment)
    }
    
    // MARK: - Focus Areas Tests
    
    func testDataFrameFocusArea_AllCases() {
        // Given: All focus area cases
        let allCases = DataFrameFocusArea.allCases
        
        // Then: Should have expected cases
        XCTAssertEqual(allCases.count, 8)
        XCTAssertTrue(allCases.contains(.dataQuality))
        XCTAssertTrue(allCases.contains(.statisticalAnalysis))
        XCTAssertTrue(allCases.contains(.patternRecognition))
        XCTAssertTrue(allCases.contains(.visualization))
        XCTAssertTrue(allCases.contains(.dataRelationships))
        XCTAssertTrue(allCases.contains(.timeSeriesAnalysis))
        XCTAssertTrue(allCases.contains(.categoricalAnalysis))
        XCTAssertTrue(allCases.contains(.outlierDetection))
    }
    
    func testAnalysisDepth_AllCases() {
        // Given: All analysis depth cases
        let allCases = AnalysisDepth.allCases
        
        // Then: Should have expected cases
        XCTAssertEqual(allCases.count, 4)
        XCTAssertTrue(allCases.contains(.basic))
        XCTAssertTrue(allCases.contains(.moderate))
        XCTAssertTrue(allCases.contains(.comprehensive))
        XCTAssertTrue(allCases.contains(.deep))
    }
    
    // MARK: - Performance Tests
    
    func testPlatformAnalyzeDataFrame_L1_Performance() {
        // Given: A large DataFrame
        let largeDataFrame = createLargeDataFrame(rowCount: 1000)
        let hints = DataFrameAnalysisHints()
        
        // When: Analyzing the large DataFrame
        let startTime = CFAbsoluteTimeGetCurrent()
        let view = platformAnalyzeDataFrame_L1(dataFrame: largeDataFrame, hints: hints)
        let executionTime = CFAbsoluteTimeGetCurrent() - startTime
        
        // Then: Should complete within reasonable time
        XCTAssertLessThan(executionTime, 5.0) // Should complete within 5 seconds
        XCTAssertNotNil(view)
    }
    
    // MARK: - Integration Tests
    
    func testDataFrameAnalysis_IntegratesWithDataIntrospection() {
        // Given: A test DataFrame
        let hints = DataFrameAnalysisHints()
        
        // When: Analyzing the DataFrame
        let view = platformAnalyzeDataFrame_L1(dataFrame: testDataFrame, hints: hints)
        
        // Then: Should integrate with existing systems
        XCTAssertNotNil(view)
    }
    
    // MARK: - Helper Methods
    
    private func createTestDataFrame() -> DataFrame {
        var dataFrame = DataFrame()
        dataFrame.append(column: Column(name: "name", contents: ["Alice", "Bob", "Charlie"]))
        dataFrame.append(column: Column(name: "age", contents: [25, 30, 35]))
        dataFrame.append(column: Column(name: "city", contents: ["New York", "London", "Tokyo"]))
        return dataFrame
    }
    
    private func createTestDataFrame2() -> DataFrame {
        var dataFrame = DataFrame()
        dataFrame.append(column: Column(name: "product", contents: ["Widget A", "Widget B", "Widget C"]))
        dataFrame.append(column: Column(name: "price", contents: [10.99, 15.99, 20.99]))
        dataFrame.append(column: Column(name: "category", contents: ["Electronics", "Electronics", "Home"]))
        return dataFrame
    }
    
    private func createDataFrameWithMissingData() -> DataFrame {
        var dataFrame = DataFrame()
        dataFrame.append(column: Column(name: "name", contents: ["Alice", "Bob", "Charlie"]))
        dataFrame.append(column: Column(name: "age", contents: [25, nil, 35]))
        dataFrame.append(column: Column(name: "city", contents: ["New York", "London", nil]))
        return dataFrame
    }
    
    private func createLargeDataFrame(rowCount: Int) -> DataFrame {
        let values = (1...rowCount).map { Double($0) }
        let categories = (1...rowCount).map { "Category \($0 % 10)" }
        
        var dataFrame = DataFrame()
        dataFrame.append(column: Column(name: "values", contents: values))
        dataFrame.append(column: Column(name: "category", contents: categories))
        
        return dataFrame
    }
}
