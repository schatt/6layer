//
//  DataFrameAnalysisEngineTests.swift
//  SixLayerFrameworkTests
//
//  Tests for DataFrame analysis engine extending DataIntrospectionEngine
//

import XCTest
@testable import SixLayerFramework
import TabularData

@MainActor
final class DataFrameAnalysisEngineTests: XCTestCase {
    
    var analysisEngine: DataFrameAnalysisEngine!
    
    override func setUp() {
        super.setUp()
        analysisEngine = DataFrameAnalysisEngine()
    }
    
    override func tearDown() {
        analysisEngine = nil
        super.tearDown()
    }
    
    // MARK: - Basic DataFrame Analysis Tests
    
    func testAnalyzeDataFrame_BasicStructure() throws {
        // Given: A simple DataFrame with basic data
        let dataFrame = try createSampleDataFrame()
        
        // When: Analyzing the DataFrame
        let result = analysisEngine.analyzeDataFrame(dataFrame)
        
        // Then: Should return proper analysis
        XCTAssertNotNil(result)
        XCTAssertGreaterThan(result.columns.count, 0)
        XCTAssertEqual(result.rowCount, 3)
        XCTAssertEqual(result.columnCount, 3)
    }
    
    func testAnalyzeDataFrame_EmptyDataFrame() throws {
        // Given: An empty DataFrame
        let dataFrame = DataFrame()
        
        // When: Analyzing the DataFrame
        let result = analysisEngine.analyzeDataFrame(dataFrame)
        
        // Then: Should handle empty DataFrame gracefully
        XCTAssertEqual(result.rowCount, 0)
        XCTAssertEqual(result.columnCount, 0)
        XCTAssertTrue(result.columns.isEmpty)
    }
    
    func testAnalyzeDataFrame_ColumnTypes() throws {
        // Given: A DataFrame with mixed column types
        let dataFrame = try createMixedTypeDataFrame()
        
        // When: Analyzing the DataFrame
        let result = analysisEngine.analyzeDataFrame(dataFrame)
        
        // Then: Should correctly identify column types
        XCTAssertEqual(result.columns.count, 4)
        
        let stringColumn = result.columns.first { $0.name == "name" }
        XCTAssertNotNil(stringColumn)
        XCTAssertEqual(stringColumn?.contentType, .string)
        
        let numericColumn = result.columns.first { $0.name == "age" }
        XCTAssertNotNil(numericColumn)
        XCTAssertEqual(numericColumn?.contentType, .number)
        
        let booleanColumn = result.columns.first { $0.name == "isActive" }
        XCTAssertNotNil(booleanColumn)
        XCTAssertEqual(booleanColumn?.contentType, .boolean)
    }
    
    // MARK: - Statistical Analysis Tests
    
    func testAnalyzeDataFrame_StatisticalAnalysis() throws {
        // Given: A DataFrame with numeric data
        let dataFrame = try createNumericDataFrame()
        
        // When: Analyzing the DataFrame
        let result = analysisEngine.analyzeDataFrame(dataFrame)
        
        // Then: Should provide statistical analysis
        XCTAssertNotNil(result.statisticalAnalysis)
        XCTAssertGreaterThan(result.statisticalAnalysis?.meanValues.count ?? 0, 0)
        XCTAssertGreaterThan(result.statisticalAnalysis?.standardDeviations.count ?? 0, 0)
    }
    
    func testAnalyzeDataFrame_TimeSeriesDetection() throws {
        // Given: A DataFrame with time series data
        let dataFrame = try createTimeSeriesDataFrame()
        
        // When: Analyzing the DataFrame
        let result = analysisEngine.analyzeDataFrame(dataFrame)
        
        // Then: Should detect time series patterns
        XCTAssertTrue(result.patterns.hasTimeSeries)
        XCTAssertNotNil(result.timeSeriesAnalysis)
    }
    
    func testAnalyzeDataFrame_CategoricalAnalysis() throws {
        // Given: A DataFrame with categorical data
        let dataFrame = try createCategoricalDataFrame()
        
        // When: Analyzing the DataFrame
        let result = analysisEngine.analyzeDataFrame(dataFrame)
        
        // Then: Should provide categorical analysis
        XCTAssertTrue(result.patterns.hasCategories)
        XCTAssertNotNil(result.categoricalAnalysis)
        XCTAssertGreaterThan(result.categoricalAnalysis?.uniqueValueCounts.count ?? 0, 0)
    }
    
    // MARK: - Data Quality Tests
    
    func testAnalyzeDataFrame_MissingDataDetection() throws {
        // Given: A DataFrame with missing values
        let dataFrame = try createDataFrameWithMissingValues()
        
        // When: Analyzing the DataFrame
        let result = analysisEngine.analyzeDataFrame(dataFrame)
        
        // Then: Should detect missing data
        XCTAssertNotNil(result.dataQuality)
        XCTAssertGreaterThan(result.dataQuality?.missingValueCounts.count ?? 0, 0)
        XCTAssertGreaterThan(result.dataQuality?.completenessScore ?? 0, 0)
    }
    
    func testAnalyzeDataFrame_OutlierDetection() throws {
        // Given: A DataFrame with outliers
        let dataFrame = try createDataFrameWithOutliers()
        
        // When: Analyzing the DataFrame
        let result = analysisEngine.analyzeDataFrame(dataFrame)
        
        // Then: Should detect outliers
        XCTAssertNotNil(result.dataQuality)
        XCTAssertGreaterThan(result.dataQuality?.outlierCounts.count ?? 0, 0)
    }
    
    // MARK: - Visualization Recommendations Tests
    
    func testAnalyzeDataFrame_VisualizationRecommendations() throws {
        // Given: A DataFrame with various data types
        let dataFrame = try createMixedTypeDataFrame()
        
        // When: Analyzing the DataFrame
        let result = analysisEngine.analyzeDataFrame(dataFrame)
        
        // Then: Should provide visualization recommendations
        XCTAssertNotNil(result.visualizationRecommendations)
        XCTAssertGreaterThan(result.visualizationRecommendations.count, 0)
        
        let chartRecommendation = result.visualizationRecommendations.first
        XCTAssertNotNil(chartRecommendation)
        XCTAssertNotNil(chartRecommendation?.chartType)
        XCTAssertGreaterThan(chartRecommendation?.confidence ?? 0, 0)
    }
    
    // MARK: - Performance Tests
    
    func testAnalyzeDataFrame_Performance_LargeDataset() throws {
        // Given: A large DataFrame
        let dataFrame = try createLargeDataFrame(rowCount: 1000)
        
        // When: Analyzing the DataFrame
        let startTime = CFAbsoluteTimeGetCurrent()
        let result = analysisEngine.analyzeDataFrame(dataFrame)
        let executionTime = CFAbsoluteTimeGetCurrent() - startTime
        
        // Then: Should complete within reasonable time
        XCTAssertLessThan(executionTime, 5.0) // Should complete within 5 seconds
        XCTAssertNotNil(result)
        XCTAssertEqual(result.rowCount, 1000)
    }
    
    // MARK: - Integration with Existing DataIntrospectionEngine Tests
    
    func testDataFrameAnalysis_IntegratesWithDataIntrospection() throws {
        // Given: A DataFrame
        let dataFrame = try createSampleDataFrame()
        
        // When: Analyzing the DataFrame
        let result = analysisEngine.analyzeDataFrame(dataFrame)
        
        // Then: Should integrate with existing DataIntrospectionEngine
        XCTAssertNotNil(result.dataIntrospectionResult)
        XCTAssertEqual(result.dataIntrospectionResult?.fields.count, result.columns.count)
    }
    
    // MARK: - Helper Methods
    
    private func createSampleDataFrame() throws -> DataFrame {
        var dataFrame = DataFrame()
        dataFrame.append(column: Column(name: "name", contents: ["Alice", "Bob", "Charlie"]))
        dataFrame.append(column: Column(name: "age", contents: [25, 30, 35]))
        dataFrame.append(column: Column(name: "city", contents: ["New York", "London", "Tokyo"]))
        
        return dataFrame
    }
    
    private func createMixedTypeDataFrame() throws -> DataFrame {
        var dataFrame = DataFrame()
        dataFrame.append(column: Column(name: "name", contents: ["Alice", "Bob", "Charlie"]))
        dataFrame.append(column: Column(name: "age", contents: [25, 30, 35]))
        dataFrame.append(column: Column(name: "isActive", contents: [true, false, true]))
        dataFrame.append(column: Column(name: "score", contents: [85.5, 92.0, 78.5]))
        
        return dataFrame
    }
    
    private func createNumericDataFrame() throws -> DataFrame {
        let values = (1...100).map { Double($0) }
        var dataFrame = DataFrame()
        dataFrame.append(column: Column(name: "values", contents: values))
        dataFrame.append(column: Column(name: "squared", contents: values.map { $0 * $0 }))
        
        return dataFrame
    }
    
    private func createTimeSeriesDataFrame() throws -> DataFrame {
        let dates = (0..<30).map { Date().addingTimeInterval(TimeInterval($0 * 86400)) }
        let values = (0..<30).map { Double($0 * 2 + Int.random(in: -5...5)) }
        
        var dataFrame = DataFrame()
        dataFrame.append(column: Column(name: "date", contents: dates))
        dataFrame.append(column: Column(name: "value", contents: values))
        
        return dataFrame
    }
    
    private func createCategoricalDataFrame() throws -> DataFrame {
        let categories = ["A", "B", "A", "C", "B", "A", "C", "B"]
        let values = [10, 20, 15, 25, 18, 12, 22, 16]
        
        var dataFrame = DataFrame()
        dataFrame.append(column: Column(name: "category", contents: categories))
        dataFrame.append(column: Column(name: "value", contents: values))
        
        return dataFrame
    }
    
    private func createDataFrameWithMissingValues() throws -> DataFrame {
        var dataFrame = DataFrame()
        dataFrame.append(column: Column(name: "name", contents: ["Alice", "Bob", "Charlie"]))
        dataFrame.append(column: Column(name: "age", contents: [25, nil, 35]))
        dataFrame.append(column: Column(name: "city", contents: ["New York", "London", nil]))
        
        return dataFrame
    }
    
    private func createDataFrameWithOutliers() throws -> DataFrame {
        let values = [1, 2, 3, 4, 5, 100, 2, 3, 4, 5] // 100 is an outlier
        var dataFrame = DataFrame()
        dataFrame.append(column: Column(name: "values", contents: values))
        
        return dataFrame
    }
    
    private func createLargeDataFrame(rowCount: Int) throws -> DataFrame {
        let values = (1...rowCount).map { Double($0) }
        let categories = (1...rowCount).map { "Category \($0 % 10)" }
        
        var dataFrame = DataFrame()
        dataFrame.append(column: Column(name: "values", contents: values))
        dataFrame.append(column: Column(name: "category", contents: categories))
        
        return dataFrame
    }
}
