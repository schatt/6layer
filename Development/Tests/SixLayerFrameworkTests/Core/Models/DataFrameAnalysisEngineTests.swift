import Testing
import Foundation


//
//  DataFrameAnalysisEngineTests.swift
//  SixLayerFrameworkTests
//
//  Tests for DataFrame analysis engine extending DataIntrospectionEngine
//

@testable import SixLayerFramework
import TabularData

@MainActor
open class DataFrameAnalysisEngineTests {
    
    var analysisEngine: DataFrameAnalysisEngine!
    
    init() async throws {
        analysisEngine = DataFrameAnalysisEngine()
    }
    
    deinit {
        Task { [weak self] in
            await self?.cleanupTestEnvironment()
        }
    }
    
    // MARK: - Basic DataFrame Analysis Tests
    
    @Test func testAnalyzeDataFrame_BasicStructure() throws {
        // Given: A simple DataFrame with basic data
        let dataFrame = try createSampleDataFrame()
        
        // When: Analyzing the DataFrame
        let result = analysisEngine.analyzeDataFrame(dataFrame)
        
        // Then: Should return proper analysis
        #expect(result != nil)
        #expect(result.columns.count > 0)
        #expect(result.rowCount == 3)
        #expect(result.columnCount == 3)
    }
    
    @Test func testAnalyzeDataFrame_EmptyDataFrame() throws {
        // Given: An empty DataFrame
        let dataFrame = DataFrame()
        
        // When: Analyzing the DataFrame
        let result = analysisEngine.analyzeDataFrame(dataFrame)
        
        // Then: Should handle empty DataFrame gracefully
        #expect(result.rowCount == 0)
        #expect(result.columnCount == 0)
        #expect(result.columns.isEmpty)
    }
    
    @Test func testAnalyzeDataFrame_ColumnTypes() throws {
        // Given: A DataFrame with mixed column types
        let dataFrame = try createMixedTypeDataFrame()
        
        // When: Analyzing the DataFrame
        let result = analysisEngine.analyzeDataFrame(dataFrame)
        
        // Then: Should correctly identify column types
        #expect(result.columns.count == 4)
        
        let stringColumn = result.columns.first { $0.name == "name" }
        #expect(stringColumn != nil)
        #expect(stringColumn?.type == .string)
        
        let numericColumn = result.columns.first { $0.name == "age" }
        #expect(numericColumn != nil)
        #expect(numericColumn?.type == .number)
        
        let booleanColumn = result.columns.first { $0.name == "isActive" }
        #expect(booleanColumn != nil)
        #expect(booleanColumn?.type == .boolean)
    }
    
    // MARK: - Statistical Analysis Tests
    
    @Test func testAnalyzeDataFrame_StatisticalAnalysis() throws {
        // Given: A DataFrame with numeric data
        let dataFrame = try createNumericDataFrame()
        
        // When: Analyzing the DataFrame
        let result = analysisEngine.analyzeDataFrame(dataFrame)
        
        // Then: Should provide statistical analysis
        #expect(result.statisticalAnalysis != nil)
        #expect(result.statisticalAnalysis?.meanValues.count ?? 0 > 0)
        #expect(result.statisticalAnalysis?.standardDeviations.count ?? 0 > 0)
    }
    
    @Test func testAnalyzeDataFrame_TimeSeriesDetection() throws {
        // Given: A DataFrame with time series data
        let dataFrame = try createTimeSeriesDataFrame()
        
        // When: Analyzing the DataFrame
        let result = analysisEngine.analyzeDataFrame(dataFrame)
        
        // Then: Should detect time series patterns
        #expect(result.patterns.hasTimeSeries)
        #expect(result.timeSeriesAnalysis != nil)
    }
    
    @Test func testAnalyzeDataFrame_CategoricalAnalysis() throws {
        // Given: A DataFrame with categorical data
        let dataFrame = try createCategoricalDataFrame()
        
        // When: Analyzing the DataFrame
        let result = analysisEngine.analyzeDataFrame(dataFrame)
        
        // Then: Should provide categorical analysis
        #expect(result.patterns.hasCategories)
        #expect(result.categoricalAnalysis != nil)
        #expect(result.categoricalAnalysis?.uniqueValueCounts.count ?? 0 > 0)
    }
    
    // MARK: - Data Quality Tests
    
    @Test func testAnalyzeDataFrame_MissingDataDetection() throws {
        // Given: A DataFrame with missing values
        let dataFrame = try createDataFrameWithMissingValues()
        
        // When: Analyzing the DataFrame
        let result = analysisEngine.analyzeDataFrame(dataFrame)
        
        // Then: Should detect missing data
        #expect(result.dataQuality != nil)
        #expect(result.dataQuality?.missingValueCounts.count ?? 0 > 0)
        #expect(result.dataQuality?.completenessScore ?? 0 > 0)
    }
    
    @Test func testAnalyzeDataFrame_OutlierDetection() throws {
        // Given: A DataFrame with outliers
        let dataFrame = try createDataFrameWithOutliers()
        
        // When: Analyzing the DataFrame
        let result = analysisEngine.analyzeDataFrame(dataFrame)
        
        // Then: Should detect outliers
        #expect(result.dataQuality != nil)
        #expect(result.dataQuality?.outlierCounts.count ?? 0 > 0)
    }
    
    // MARK: - Visualization Recommendations Tests
    
    @Test func testAnalyzeDataFrame_VisualizationRecommendations() throws {
        // Given: A DataFrame with various data types
        let dataFrame = try createMixedTypeDataFrame()
        
        // When: Analyzing the DataFrame
        let result = analysisEngine.analyzeDataFrame(dataFrame)
        
        // Then: Should provide visualization recommendations
        #expect(result.visualizationRecommendations != nil)
        #expect(result.visualizationRecommendations.count > 0)
        
        let chartRecommendation = result.visualizationRecommendations.first
        #expect(chartRecommendation != nil)
        #expect(chartRecommendation?.chartType != nil)
        #expect(chartRecommendation?.confidence ?? 0 > 0)
    }
    
    // MARK: - Performance Tests
    
    @Test func testAnalyzeDataFrame_Performance_LargeDataset() throws {
        // Given: A large DataFrame
        let dataFrame = try createLargeDataFrame(rowCount: 1000)
        
        // When: Analyzing the DataFrame
        let startTime = CFAbsoluteTimeGetCurrent()
        let result = analysisEngine.analyzeDataFrame(dataFrame)
        let executionTime = CFAbsoluteTimeGetCurrent() - startTime
        
        // Then: Should complete within reasonable time
        #expect(executionTime < 5.0) // Should complete within 5 seconds
        #expect(result != nil)
        #expect(result.rowCount == 1000)
    }
    
    // MARK: - Integration with Existing DataIntrospectionEngine Tests
    
    @Test func testDataFrameAnalysis_IntegratesWithDataIntrospection() throws {
        // Given: A DataFrame
        let dataFrame = try createSampleDataFrame()
        
        // When: Analyzing the DataFrame
        let result = analysisEngine.analyzeDataFrame(dataFrame)
        
        // Then: Should integrate with existing DataIntrospectionEngine
        #expect(result.dataIntrospectionResult != nil)
        #expect(result.dataIntrospectionResult?.fields.count == result.columns.count)
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
