//
//  DataFrameAnalysisEngine.swift
//  SixLayerFramework
//
//  DataFrame analysis engine extending DataIntrospectionEngine
//

import Foundation
import SwiftUI
import TabularData

// MARK: - DataFrame Analysis Engine

/// DataFrame analysis engine that extends DataIntrospectionEngine with TabularData capabilities
public class DataFrameAnalysisEngine: ObservableObject {
    
    public init() {}
    
    /// Analyze a DataFrame and provide comprehensive analysis
    public func analyzeDataFrame(_ dataFrame: DataFrame) -> DataFrameAnalysisResult {
        let columns = extractColumns(from: dataFrame)
        let rowCount = dataFrame.rows.count
        let columnCount = dataFrame.columns.count
        
        let patterns = detectDataFramePatterns(dataFrame)
        let statisticalAnalysis = performStatisticalAnalysis(dataFrame)
        let timeSeriesAnalysis = detectTimeSeries(dataFrame)
        let categoricalAnalysis = analyzeCategoricalData(dataFrame)
        let dataQuality = assessDataQuality(dataFrame)
        let visualizationRecommendations = generateVisualizationRecommendations(
            dataFrame: dataFrame,
            patterns: patterns,
            statisticalAnalysis: statisticalAnalysis
        )
        
        // Integrate with existing DataIntrospectionEngine
        let dataIntrospectionResult = integrateWithDataIntrospection(dataFrame)
        
        return DataFrameAnalysisResult(
            columns: columns,
            rowCount: rowCount,
            columnCount: columnCount,
            patterns: patterns,
            statisticalAnalysis: statisticalAnalysis,
            timeSeriesAnalysis: timeSeriesAnalysis,
            categoricalAnalysis: categoricalAnalysis,
            dataQuality: dataQuality,
            visualizationRecommendations: visualizationRecommendations,
            dataIntrospectionResult: dataIntrospectionResult
        )
    }
}

// MARK: - DataFrame Analysis Result

/// Comprehensive analysis result for DataFrames
public struct DataFrameAnalysisResult {
    public let columns: [DataFrameColumn]
    public let rowCount: Int
    public let columnCount: Int
    public let patterns: DataFramePatterns
    public let statisticalAnalysis: StatisticalAnalysis?
    public let timeSeriesAnalysis: TimeSeriesAnalysis?
    public let categoricalAnalysis: CategoricalAnalysis?
    public let dataQuality: DataQualityAnalysis?
    public let visualizationRecommendations: [VisualizationRecommendation]
    public let dataIntrospectionResult: DataAnalysisResult?
    
    public init(
        columns: [DataFrameColumn],
        rowCount: Int,
        columnCount: Int,
        patterns: DataFramePatterns,
        statisticalAnalysis: StatisticalAnalysis?,
        timeSeriesAnalysis: TimeSeriesAnalysis?,
        categoricalAnalysis: CategoricalAnalysis?,
        dataQuality: DataQualityAnalysis?,
        visualizationRecommendations: [VisualizationRecommendation],
        dataIntrospectionResult: DataAnalysisResult?
    ) {
        self.columns = columns
        self.rowCount = rowCount
        self.columnCount = columnCount
        self.patterns = patterns
        self.statisticalAnalysis = statisticalAnalysis
        self.timeSeriesAnalysis = timeSeriesAnalysis
        self.categoricalAnalysis = categoricalAnalysis
        self.dataQuality = dataQuality
        self.visualizationRecommendations = visualizationRecommendations
        self.dataIntrospectionResult = dataIntrospectionResult
    }
}

// MARK: - DataFrame Column

/// Represents a column in a DataFrame
public struct DataFrameColumn {
    public let name: String
    public let type: FieldType
    public let isOptional: Bool
    public let hasMissingValues: Bool
    public let uniqueValueCount: Int
    public let sampleValues: [Any]
    
    public init(
        name: String,
        type: FieldType,
        isOptional: Bool = false,
        hasMissingValues: Bool = false,
        uniqueValueCount: Int = 0,
        sampleValues: [Any] = []
    ) {
        self.name = name
        self.type = type
        self.isOptional = isOptional
        self.hasMissingValues = hasMissingValues
        self.uniqueValueCount = uniqueValueCount
        self.sampleValues = sampleValues
    }
}

// MARK: - DataFrame Patterns

/// Patterns detected in DataFrame data
public struct DataFramePatterns {
    public let hasTimeSeries: Bool
    public let hasCategories: Bool
    public let hasHierarchy: Bool
    public let hasGeographicData: Bool
    public let hasFinancialData: Bool
    public let hasUserData: Bool
    public let hasMedia: Bool
    public let hasRelationships: Bool
    
    public init(
        hasTimeSeries: Bool = false,
        hasCategories: Bool = false,
        hasHierarchy: Bool = false,
        hasGeographicData: Bool = false,
        hasFinancialData: Bool = false,
        hasUserData: Bool = false,
        hasMedia: Bool = false,
        hasRelationships: Bool = false
    ) {
        self.hasTimeSeries = hasTimeSeries
        self.hasCategories = hasCategories
        self.hasHierarchy = hasHierarchy
        self.hasGeographicData = hasGeographicData
        self.hasFinancialData = hasFinancialData
        self.hasUserData = hasUserData
        self.hasMedia = hasMedia
        self.hasRelationships = hasRelationships
    }
}

// MARK: - Statistical Analysis

/// Statistical analysis of DataFrame data
public struct StatisticalAnalysis {
    public let meanValues: [String: Double]
    public let medianValues: [String: Double]
    public let standardDeviations: [String: Double]
    public let minValues: [String: Double]
    public let maxValues: [String: Double]
    public let correlations: [String: [String: Double]]
    
    public init(
        meanValues: [String: Double] = [:],
        medianValues: [String: Double] = [:],
        standardDeviations: [String: Double] = [:],
        minValues: [String: Double] = [:],
        maxValues: [String: Double] = [:],
        correlations: [String: [String: Double]] = [:]
    ) {
        self.meanValues = meanValues
        self.medianValues = medianValues
        self.standardDeviations = standardDeviations
        self.minValues = minValues
        self.maxValues = maxValues
        self.correlations = correlations
    }
}

// MARK: - Time Series Analysis

/// Time series analysis of DataFrame data
public struct TimeSeriesAnalysis {
    public let timeColumn: String
    public let valueColumns: [String]
    public let trend: DataFrameTrendDirection
    public let seasonality: Bool
    public let periodicity: TimePeriod?
    
    public init(
        timeColumn: String,
        valueColumns: [String] = [],
        trend: DataFrameTrendDirection = .stable,
        seasonality: Bool = false,
        periodicity: TimePeriod? = nil
    ) {
        self.timeColumn = timeColumn
        self.valueColumns = valueColumns
        self.trend = trend
        self.seasonality = seasonality
        self.periodicity = periodicity
    }
}

public enum DataFrameTrendDirection {
    case increasing
    case decreasing
    case stable
    case volatile
}

public enum TimePeriod {
    case daily
    case weekly
    case monthly
    case quarterly
    case yearly
}

// MARK: - Categorical Analysis

/// Categorical analysis of DataFrame data
public struct CategoricalAnalysis {
    public let uniqueValueCounts: [String: Int]
    public let valueFrequencies: [String: [String: Int]]
    public let mostCommonValues: [String: String]
    public let cardinality: [String: Int]
    
    public init(
        uniqueValueCounts: [String: Int] = [:],
        valueFrequencies: [String: [String: Int]] = [:],
        mostCommonValues: [String: String] = [:],
        cardinality: [String: Int] = [:]
    ) {
        self.uniqueValueCounts = uniqueValueCounts
        self.valueFrequencies = valueFrequencies
        self.mostCommonValues = mostCommonValues
        self.cardinality = cardinality
    }
}

// MARK: - Data Quality Analysis

/// Data quality analysis of DataFrame
public struct DataQualityAnalysis {
    public let missingValueCounts: [String: Int]
    public let outlierCounts: [String: Int]
    public let completenessScore: Double
    public let consistencyScore: Double
    public let accuracyScore: Double
    public let overallQualityScore: Double
    
    public init(
        missingValueCounts: [String: Int] = [:],
        outlierCounts: [String: Int] = [:],
        completenessScore: Double = 1.0,
        consistencyScore: Double = 1.0,
        accuracyScore: Double = 1.0,
        overallQualityScore: Double = 1.0
    ) {
        self.missingValueCounts = missingValueCounts
        self.outlierCounts = outlierCounts
        self.completenessScore = completenessScore
        self.consistencyScore = consistencyScore
        self.accuracyScore = accuracyScore
        self.overallQualityScore = overallQualityScore
    }
}

// MARK: - Visualization Recommendation

/// Visualization recommendation for DataFrame data
public struct VisualizationRecommendation {
    public let chartType: ChartType
    public let confidence: Double
    public let reasoning: String
    public let columns: [String]
    
    public init(
        chartType: ChartType,
        confidence: Double,
        reasoning: String,
        columns: [String] = []
    ) {
        self.chartType = chartType
        self.confidence = confidence
        self.reasoning = reasoning
        self.columns = columns
    }
}

// MARK: - Private Helper Methods

private extension DataFrameAnalysisEngine {
    
    func extractColumns(from dataFrame: DataFrame) -> [DataFrameColumn] {
        return dataFrame.columns.map { column in
            let type = determineColumnType(column)
            let nonNilValues = column.compactMap { $0 }
            let hasMissingValues = nonNilValues.count < column.count
            let uniqueValueCount = nonNilValues.count // Simplified - would need proper unique counting
            let sampleValues = Array(column.prefix(5)).compactMap { $0 }
            
            return DataFrameColumn(
                name: column.name,
                type: type,
                isOptional: hasMissingValues,
                hasMissingValues: hasMissingValues,
                uniqueValueCount: uniqueValueCount,
                sampleValues: sampleValues
            )
        }
    }
    
    func determineColumnType(_ column: AnyColumn) -> FieldType {
        // Analyze actual data to determine type
        let sampleValues = Array(column.prefix(10)).compactMap { $0 }
        
        guard !sampleValues.isEmpty else { return .custom }
        
        // Check if all values are strings
        if sampleValues.allSatisfy({ $0 is String }) {
            // Check for specific string patterns
            if column.name.lowercased().contains("date") || column.name.lowercased().contains("time") {
                return .date
            } else if column.name.lowercased().contains("id") || column.name.lowercased().contains("uuid") {
                return .uuid
            } else if column.name.lowercased().contains("url") || column.name.lowercased().contains("link") {
                return .url
            } else if column.name.lowercased().contains("image") || column.name.lowercased().contains("photo") {
                return .image
            } else {
                return .string
            }
        }
        
        // Check if all values are numbers
        if sampleValues.allSatisfy({ $0 is Int || $0 is Double || $0 is Float }) {
            return .number
        }
        
        // Check if all values are booleans
        if sampleValues.allSatisfy({ $0 is Bool }) {
            return .boolean
        }
        
        // Check for dates
        if sampleValues.allSatisfy({ $0 is Date }) {
            return .date
        }
        
        return .custom
    }
    
    func detectDataFramePatterns(_ dataFrame: DataFrame) -> DataFramePatterns {
        let columnNames = dataFrame.columns.map { $0.name.lowercased() }
        
        let hasTimeSeries = columnNames.contains { $0.contains("date") || $0.contains("time") }
        let hasCategories = dataFrame.columns.contains { (column: AnyColumn) in
            let nonNilValues = column.compactMap { $0 }
            // Use a simple heuristic: if unique values are less than 50% of total values, it's categorical
            // For now, use a simplified approach: if column name suggests categories or has few unique values
            let totalCount = dataFrame.rows.count
            if totalCount == 0 { return false }
            
            // Check if column name suggests it's categorical
            if column.name.lowercased().contains("category") || 
               column.name.lowercased().contains("type") || 
               column.name.lowercased().contains("status") {
                return true
            }
            
            // Check if it has few unique values (simplified check)
            return nonNilValues.count < Int(Double(totalCount) * 0.5) && nonNilValues.count > 1
        }
        let hasGeographicData = columnNames.contains { $0.contains("lat") || $0.contains("lng") || $0.contains("location") }
        let hasFinancialData = columnNames.contains { $0.contains("price") || $0.contains("amount") || $0.contains("cost") }
        let hasUserData = columnNames.contains { $0.contains("user") || $0.contains("name") || $0.contains("email") }
        let hasMedia = columnNames.contains { $0.contains("image") || $0.contains("photo") || $0.contains("video") }
        
        return DataFramePatterns(
            hasTimeSeries: hasTimeSeries,
            hasCategories: hasCategories,
            hasGeographicData: hasGeographicData,
            hasFinancialData: hasFinancialData,
            hasUserData: hasUserData,
            hasMedia: hasMedia
        )
    }
    
    func performStatisticalAnalysis(_ dataFrame: DataFrame) -> StatisticalAnalysis? {
        // Simplified implementation - in reality, you'd perform actual statistical calculations
        let numericColumns = dataFrame.columns.filter { column in
            // Check if column contains numeric data
            column.name.lowercased().contains("value") || 
            column.name.lowercased().contains("count") ||
            column.name.lowercased().contains("score")
        }
        
        guard !numericColumns.isEmpty else { return nil }
        
        var meanValues: [String: Double] = [:]
        var standardDeviations: [String: Double] = [:]
        
        for column in numericColumns {
            meanValues[column.name] = 0.0 // Placeholder
            standardDeviations[column.name] = 1.0 // Placeholder
        }
        
        return StatisticalAnalysis(
            meanValues: meanValues,
            standardDeviations: standardDeviations
        )
    }
    
    func detectTimeSeries(_ dataFrame: DataFrame) -> TimeSeriesAnalysis? {
        let timeColumns = dataFrame.columns.filter { $0.name.lowercased().contains("date") || $0.name.lowercased().contains("time") }
        
        guard let timeColumn = timeColumns.first else { return nil }
        
        let valueColumns = dataFrame.columns.filter { $0.name != timeColumn.name }
        
        return TimeSeriesAnalysis(
            timeColumn: timeColumn.name,
            valueColumns: valueColumns.map { $0.name }
        )
    }
    
    func analyzeCategoricalData(_ dataFrame: DataFrame) -> CategoricalAnalysis? {
        let categoricalColumns = dataFrame.columns.filter { (column: AnyColumn) in
            let nonNilValues = column.compactMap { $0 }
            let totalCount = dataFrame.rows.count
            if totalCount == 0 { return false }
            
            // Check if column name suggests it's categorical
            if column.name.lowercased().contains("category") || 
               column.name.lowercased().contains("type") || 
               column.name.lowercased().contains("status") {
                return true
            }
            
            // Check if it has few unique values (simplified check)
            return nonNilValues.count < Int(Double(totalCount) * 0.5) && nonNilValues.count > 1
        }
        
        guard !categoricalColumns.isEmpty else { return nil }
        
        var uniqueValueCounts: [String: Int] = [:]
        var cardinality: [String: Int] = [:]
        
        for column in categoricalColumns {
            let nonNilValues = column.compactMap { $0 }
            let uniqueCount = nonNilValues.count // Simplified - would need proper unique counting
            uniqueValueCounts[column.name] = uniqueCount
            cardinality[column.name] = uniqueCount
        }
        
        return CategoricalAnalysis(
            uniqueValueCounts: uniqueValueCounts,
            cardinality: cardinality
        )
    }
    
    func assessDataQuality(_ dataFrame: DataFrame) -> DataQualityAnalysis {
        var missingValueCounts: [String: Int] = [:]
        var outlierCounts: [String: Int] = [:]
        
        for column in dataFrame.columns {
            let nonNilValues = column.compactMap { $0 }
            missingValueCounts[column.name] = column.count - nonNilValues.count
            outlierCounts[column.name] = 0 // Placeholder - would need actual outlier detection
        }
        
        let totalCells = dataFrame.rows.count * dataFrame.columns.count
        let missingCells = missingValueCounts.values.reduce(0, +)
        let completenessScore = totalCells > 0 ? Double(totalCells - missingCells) / Double(totalCells) : 1.0
        
        return DataQualityAnalysis(
            missingValueCounts: missingValueCounts,
            outlierCounts: outlierCounts,
            completenessScore: completenessScore,
            overallQualityScore: completenessScore
        )
    }
    
    func generateVisualizationRecommendations(
        dataFrame: DataFrame,
        patterns: DataFramePatterns,
        statisticalAnalysis: StatisticalAnalysis?
    ) -> [VisualizationRecommendation] {
        var recommendations: [VisualizationRecommendation] = []
        
        if patterns.hasTimeSeries {
            recommendations.append(VisualizationRecommendation(
                chartType: .line,
                confidence: 0.9,
                reasoning: "Time series data detected",
                columns: dataFrame.columns.map { $0.name }
            ))
        }
        
        if patterns.hasCategories {
            recommendations.append(VisualizationRecommendation(
                chartType: .bar,
                confidence: 0.8,
                reasoning: "Categorical data detected",
                columns: dataFrame.columns.map { $0.name }
            ))
        }
        
        if dataFrame.columns.count == 2 {
            recommendations.append(VisualizationRecommendation(
                chartType: .scatter,
                confidence: 0.7,
                reasoning: "Two columns suitable for scatter plot",
                columns: dataFrame.columns.map { $0.name }
            ))
        }
        
        // Always provide at least one recommendation
        if recommendations.isEmpty {
            recommendations.append(VisualizationRecommendation(
                chartType: .table,
                confidence: 0.5,
                reasoning: "Default table view for data exploration",
                columns: dataFrame.columns.map { $0.name }
            ))
        }
        
        return recommendations
    }
    
    func integrateWithDataIntrospection(_ dataFrame: DataFrame) -> DataAnalysisResult? {
        // Convert DataFrame to a format that DataIntrospectionEngine can analyze
        // This is a simplified integration
        let fields = dataFrame.columns.map { column in
            DataField(
                name: column.name,
                type: determineColumnType(column),
                isOptional: column.compactMap { $0 }.count < column.count,
                isArray: false,
                isIdentifiable: false,
                hasDefaultValue: false
            )
        }
        
        let patterns = DataPatterns(
            hasMedia: dataFrame.columns.contains { $0.name.lowercased().contains("image") },
            hasDates: dataFrame.columns.contains { $0.name.lowercased().contains("date") },
            hasRelationships: false,
            isHierarchical: false,
            hasGeographicData: dataFrame.columns.contains { $0.name.lowercased().contains("lat") },
            hasFinancialData: dataFrame.columns.contains { $0.name.lowercased().contains("price") },
            hasUserData: dataFrame.columns.contains { $0.name.lowercased().contains("user") }
        )
        
        return DataAnalysisResult(
            fields: fields,
            complexity: .moderate,
            patterns: patterns,
            recommendations: []
        )
    }
}
