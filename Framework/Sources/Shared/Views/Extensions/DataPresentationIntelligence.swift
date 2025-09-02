import Foundation
import SwiftUI

// MARK: - Basic Types (Minimal Implementation for TDD)

/// Represents different types of data that can be visualized
public enum DataVisualizationType: String, CaseIterable {
    case numerical = "numerical"
    case categorical = "categorical"
    case temporal = "temporal"
    case hierarchical = "hierarchical"
    case geographical = "geographical"
    case relational = "relational"
    case mixed = "mixed"
}

/// Represents the complexity level of data
public enum DataComplexity: String, CaseIterable {
    case simple = "simple"      // 1-5 data points
    case moderate = "moderate"  // 6-20 data points
    case complex = "complex"    // 21-100 data points
    case veryComplex = "veryComplex" // 100+ data points
}

/// Represents the recommended chart type for data visualization
public enum ChartType: String, CaseIterable {
    case bar = "bar"
    case line = "line"
    case pie = "pie"
    case scatter = "scatter"
    case area = "area"
    case donut = "donut"
    case histogram = "histogram"
    case heatmap = "heatmap"
    case treemap = "treemap"
    case network = "network"
    case table = "table"
    case list = "list"
}

/// Data analysis result for intelligent presentation
public struct DataVisualizationAnalysis {
    public let visualizationType: DataVisualizationType
    public let complexity: DataComplexity
    public let recommendedChartType: ChartType
    public let dataPoints: Int
    public let hasTimeSeries: Bool
    public let hasCategories: Bool
    public let hasHierarchy: Bool
    public let confidence: Double // 0.0 to 1.0
    
    public init(
        visualizationType: DataVisualizationType,
        complexity: DataComplexity,
        recommendedChartType: ChartType,
        dataPoints: Int,
        hasTimeSeries: Bool = false,
        hasCategories: Bool = false,
        hasHierarchy: Bool = false,
        confidence: Double = 1.0
    ) {
        self.visualizationType = visualizationType
        self.complexity = complexity
        self.recommendedChartType = recommendedChartType
        self.dataPoints = dataPoints
        self.hasTimeSeries = hasTimeSeries
        self.hasCategories = hasCategories
        self.hasHierarchy = hasHierarchy
        self.confidence = confidence
    }
}

// MARK: - Data Presentation Intelligence Engine (Minimal Implementation)

/// Intelligent data presentation engine that analyzes data and recommends optimal presentation strategies
public class DataPresentationIntelligence: ObservableObject {
    public static let shared = DataPresentationIntelligence()
    
    private init() {}
    
    /// Analyze data and return presentation recommendations
        func analyzeData<T>(_ data: [T]) -> DataVisualizationAnalysis {
        let dataPoints = data.count
        let complexity = determineComplexity(dataPoints)
        
        // Determine chart type based on complexity
        let recommendedChartType: ChartType
        switch complexity {
        case .simple:
            recommendedChartType = .bar
        case .moderate:
            recommendedChartType = .bar
        case .complex, .veryComplex:
            recommendedChartType = .table
        }
        
        let confidence = calculateConfidence(complexity: complexity, dataPoints: dataPoints)
        
        return DataVisualizationAnalysis(
            visualizationType: .categorical,
            complexity: complexity,
            recommendedChartType: recommendedChartType,
            dataPoints: dataPoints,
            confidence: confidence
        )
    }
    
    /// Analyze numerical data specifically
        func analyzeNumericalData(_ values: [Double]) -> DataVisualizationAnalysis {
        let dataPoints = values.count
        let complexity = determineComplexity(dataPoints)
        
        // Check for different patterns
        let hasTimeSeries = analyzeNumericalTimeSeries(values)
        let hasCategoricalPattern = analyzeNumericalCategoricalPattern(values)
        
        // Determine visualization type based on patterns
        let visualizationType: DataVisualizationType
        if hasTimeSeries {
            visualizationType = .temporal
        } else if hasCategoricalPattern {
            visualizationType = .categorical
        } else {
            visualizationType = .numerical
        }
        
        // Determine recommended chart type
        let recommendedChartType = determineChartType(
            visualizationType: visualizationType,
            complexity: complexity,
            hasTimeSeries: hasTimeSeries,
            hasCategories: hasCategoricalPattern
        )
        
        // Calculate confidence based on data characteristics
        let confidence = calculateConfidence(complexity: complexity, dataPoints: dataPoints)
        
        return DataVisualizationAnalysis(
            visualizationType: visualizationType,
            complexity: complexity,
            recommendedChartType: recommendedChartType,
            dataPoints: dataPoints,
            hasTimeSeries: hasTimeSeries,
            hasCategories: hasCategoricalPattern,
            confidence: confidence
        )
    }
    
    /// Analyze categorical data specifically
        func analyzeCategoricalData(_ categories: [String: Int]) -> DataVisualizationAnalysis {
        let dataPoints = categories.values.reduce(0, +)
        let complexity = determineComplexity(categories.count)
        
        let recommendedChartType = determineChartType(
            visualizationType: .categorical,
            complexity: complexity,
            hasTimeSeries: false,
            hasCategories: true
        )
        
        let confidence = calculateConfidence(complexity: complexity, dataPoints: dataPoints)
        
        return DataVisualizationAnalysis(
            visualizationType: .categorical,
            complexity: complexity,
            recommendedChartType: recommendedChartType,
            dataPoints: dataPoints,
            hasCategories: true,
            confidence: confidence
        )
    }
    
    // MARK: - Private Helper Methods
    
    private func determineComplexity(_ count: Int) -> DataComplexity {
        switch count {
        case 0...5:
            return .simple
        case 6...20:
            return .moderate
        case 21...100:
            return .complex
        default:
            return .veryComplex
        }
    }
    
    private func analyzeNumericalTimeSeries(_ values: [Double]) -> Bool {
        // More sophisticated time series detection
        guard values.count >= 7 else { return false } // Require more data points
        
        // Check for monotonic trends (increasing or decreasing)
        var increasingCount = 0
        var decreasingCount = 0
        
        for i in 1..<values.count {
            if values[i] > values[i-1] {
                increasingCount += 1
            } else if values[i] < values[i-1] {
                decreasingCount += 1
            }
        }
        
        let totalComparisons = values.count - 1
        let trendThreshold = Double(totalComparisons) * 0.85 // 85% of comparisons must show trend (more strict)
        
        // Only consider it time series if there's a very strong monotonic trend
        return Double(increasingCount) >= trendThreshold || Double(decreasingCount) >= trendThreshold
    }
    
    private func analyzeNumericalCategoricalPattern(_ values: [Double]) -> Bool {
        // Check if numerical values represent categories (repeated values)
        guard values.count >= 3 else { return false }
        
        let uniqueValues = Set(values)
        let uniqueCount = uniqueValues.count
        let totalCount = values.count
        
        // If we have many repeated values relative to unique values, it's categorical
        return Double(uniqueCount) / Double(totalCount) < 0.5
    }
    
    private func determineChartType(
        visualizationType: DataVisualizationType,
        complexity: DataComplexity,
        hasTimeSeries: Bool,
        hasCategories: Bool
    ) -> ChartType {
        switch visualizationType {
        case .temporal:
            return .line
        case .categorical:
            switch complexity {
            case .simple:
                return .pie
            case .moderate:
                return .bar
            case .complex, .veryComplex:
                return .table
            }
        case .numerical:
            switch complexity {
            case .simple:
                return .bar
            case .moderate:
                return .bar
            case .complex, .veryComplex:
                return .table
            }
        default:
            return .bar
        }
    }
    
    private func calculateConfidence(complexity: DataComplexity, dataPoints: Int) -> Double {
        // Return confidence based on complexity
        switch complexity {
        case .simple:
            return 1.0
        case .moderate:
            return 0.9
        case .complex:
            return 0.8
        case .veryComplex:
            return 0.6
        }
    }
}
