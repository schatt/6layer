//
//  PlatformDataFrameAnalysisL1.swift
//  SixLayerFramework
//
//  Layer 1 semantic intent functions for DataFrame analysis
//

import Foundation
import SwiftUI
import TabularData

// MARK: - Layer 1 DataFrame Analysis Functions

/// Analyze a DataFrame and provide intelligent insights at the semantic intent level
///
/// This function provides high-level analysis of DataFrame content, focusing on
/// semantic understanding rather than low-level data manipulation. It integrates
/// with the existing data intelligence systems to provide comprehensive insights.
///
/// - Parameters:
///   - dataFrame: The DataFrame to analyze
///   - hints: Optional hints to guide the analysis
/// - Returns: A view presenting the analysis results
@MainActor
public func platformAnalyzeDataFrame_L1(
    dataFrame: DataFrame,
    hints: DataFrameAnalysisHints = DataFrameAnalysisHints()
) -> some View {
    DataFrameAnalysisView(dataFrame: dataFrame, hints: hints)
}

/// Analyze multiple DataFrames and provide comparative insights
///
/// This function compares multiple DataFrames and provides insights about
/// their relationships, differences, and similarities at the semantic level.
///
/// - Parameters:
///   - dataFrames: Array of DataFrames to analyze
///   - hints: Optional hints to guide the analysis
/// - Returns: A view presenting the comparative analysis results
@MainActor
public func platformCompareDataFrames_L1(
    dataFrames: [DataFrame],
    hints: DataFrameAnalysisHints = DataFrameAnalysisHints()
) -> some View {
    DataFrameComparisonView(dataFrames: dataFrames, hints: hints)
}

/// Analyze DataFrame data quality and provide recommendations
///
/// This function focuses specifically on data quality assessment and provides
/// actionable recommendations for improving data quality.
///
/// - Parameters:
///   - dataFrame: The DataFrame to analyze
///   - hints: Optional hints to guide the analysis
/// - Returns: A view presenting data quality insights and recommendations
@MainActor
public func platformAssessDataQuality_L1(
    dataFrame: DataFrame,
    hints: DataFrameAnalysisHints = DataFrameAnalysisHints()
) -> some View {
    DataQualityAssessmentView(dataFrame: dataFrame, hints: hints)
}

// MARK: - DataFrame Analysis Hints

/// Hints to guide DataFrame analysis at the semantic level
public struct DataFrameAnalysisHints {
    public let focusAreas: [DataFrameFocusArea]
    public let analysisDepth: AnalysisDepth
    public let visualizationPreferences: [ChartType]
    public let includeRecommendations: Bool
    public let includeStatisticalAnalysis: Bool
    public let includeDataQualityAssessment: Bool
    
    public init(
        focusAreas: [DataFrameFocusArea] = [],
        analysisDepth: AnalysisDepth = .comprehensive,
        visualizationPreferences: [ChartType] = [],
        includeRecommendations: Bool = true,
        includeStatisticalAnalysis: Bool = true,
        includeDataQualityAssessment: Bool = true
    ) {
        self.focusAreas = focusAreas
        self.analysisDepth = analysisDepth
        self.visualizationPreferences = visualizationPreferences
        self.includeRecommendations = includeRecommendations
        self.includeStatisticalAnalysis = includeStatisticalAnalysis
        self.includeDataQualityAssessment = includeDataQualityAssessment
    }
}

/// Areas of focus for DataFrame analysis
public enum DataFrameFocusArea: String, CaseIterable {
    case dataQuality = "data_quality"
    case statisticalAnalysis = "statistical_analysis"
    case patternRecognition = "pattern_recognition"
    case visualization = "visualization"
    case dataRelationships = "data_relationships"
    case timeSeriesAnalysis = "time_series_analysis"
    case categoricalAnalysis = "categorical_analysis"
    case outlierDetection = "outlier_detection"
}

/// Depth of analysis to perform
public enum AnalysisDepth: String, CaseIterable {
    case basic = "basic"
    case moderate = "moderate"
    case comprehensive = "comprehensive"
    case deep = "deep"
}

// MARK: - DataFrame Analysis Views

/// Main view for DataFrame analysis results
private struct DataFrameAnalysisView: View {
    let dataFrame: DataFrame
    let hints: DataFrameAnalysisHints
    @StateObject private var analysisEngine = DataFrameAnalysisEngine()
    @State private var analysisResult: DataFrameAnalysisResult?
    @State private var isLoading = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if isLoading {
                ProgressView("Analyzing DataFrame...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let result = analysisResult {
                DataFrameAnalysisContentView(result: result, hints: hints)
            } else {
                Text("Analysis failed")
                    .foregroundColor(.red)
            }
        }
        .onAppear {
            performAnalysis()
        }
    }
    
    private func performAnalysis() {
        Task {
            let result = analysisEngine.analyzeDataFrame(dataFrame)
            await MainActor.run {
                self.analysisResult = result
                self.isLoading = false
            }
        }
    }
}

/// Content view for DataFrame analysis results
private struct DataFrameAnalysisContentView: View {
    let result: DataFrameAnalysisResult
    let hints: DataFrameAnalysisHints
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Overview Section
                DataFrameOverviewSection(result: result)
                
                // Data Quality Section
                if hints.includeDataQualityAssessment {
                    DataQualitySection(result: result)
                }
                
                // Statistical Analysis Section
                if hints.includeStatisticalAnalysis {
                    StatisticalAnalysisSection(result: result)
                }
                
                // Pattern Recognition Section
                PatternRecognitionSection(result: result)
                
                // Visualization Recommendations Section
                VisualizationRecommendationsSection(result: result)
            }
            .padding()
        }
    }
}

/// Overview section showing basic DataFrame information
private struct DataFrameOverviewSection: View {
    let result: DataFrameAnalysisResult
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("DataFrame Overview")
                .font(.headline)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Rows: \(result.rowCount)")
                    Text("Columns: \(result.columnCount)")
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("Data Quality")
                        .font(.caption)
                    Text("\(Int(result.dataQuality?.overallQualityScore ?? 0 * 100))%")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(qualityColor(result.dataQuality?.overallQualityScore ?? 0))
                }
            }
        }
        .padding()
        .background(Color.platformSecondaryBackground)
        .cornerRadius(8)
    }
    
    private func qualityColor(_ score: Double) -> Color {
        if score >= 0.8 { return .green }
        if score >= 0.6 { return .orange }
        return .red
    }
}

/// Data quality assessment section
private struct DataQualitySection: View {
    let result: DataFrameAnalysisResult
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Data Quality Assessment")
                .font(.headline)
            
            if let quality = result.dataQuality {
                VStack(alignment: .leading, spacing: 8) {
                    QualityMetricRow(
                        title: "Completeness",
                        value: quality.completenessScore,
                        description: "Percentage of non-missing values"
                    )
                    
                    QualityMetricRow(
                        title: "Consistency",
                        value: quality.consistencyScore,
                        description: "Data format consistency"
                    )
                    
                    QualityMetricRow(
                        title: "Accuracy",
                        value: quality.accuracyScore,
                        description: "Data accuracy assessment"
                    )
                }
            } else {
                Text("No data quality information available")
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color.platformSecondaryBackground)
        .cornerRadius(8)
    }
}

/// Statistical analysis section
private struct StatisticalAnalysisSection: View {
    let result: DataFrameAnalysisResult
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Statistical Analysis")
                .font(.headline)
            
            if let stats = result.statisticalAnalysis {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(Array(stats.meanValues.keys), id: \.self) { column in
                        HStack {
                            Text(column)
                                .fontWeight(.medium)
                            Spacer()
                            Text("Mean: \(stats.meanValues[column] ?? 0, specifier: "%.2f")")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            } else {
                Text("No statistical analysis available")
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color.platformSecondaryBackground)
        .cornerRadius(8)
    }
}

/// Pattern recognition section
private struct PatternRecognitionSection: View {
    let result: DataFrameAnalysisResult
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Pattern Recognition")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 8) {
                PatternRow(
                    title: "Time Series",
                    detected: result.patterns.hasTimeSeries,
                    description: "Sequential time-based data patterns"
                )
                
                PatternRow(
                    title: "Categorical Data",
                    detected: result.patterns.hasCategories,
                    description: "Discrete category-based data"
                )
                
                PatternRow(
                    title: "Geographic Data",
                    detected: result.patterns.hasGeographicData,
                    description: "Location-based data patterns"
                )
                
                PatternRow(
                    title: "Financial Data",
                    detected: result.patterns.hasFinancialData,
                    description: "Monetary value patterns"
                )
            }
        }
        .padding()
        .background(Color.platformSecondaryBackground)
        .cornerRadius(8)
    }
}

/// Visualization recommendations section
private struct VisualizationRecommendationsSection: View {
    let result: DataFrameAnalysisResult
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Visualization Recommendations")
                .font(.headline)
            
            if !result.visualizationRecommendations.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(Array(result.visualizationRecommendations.enumerated()), id: \.offset) { index, recommendation in
                        VisualizationRecommendationRow(recommendation: recommendation)
                    }
                }
            } else {
                Text("No visualization recommendations available")
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color.platformSecondaryBackground)
        .cornerRadius(8)
    }
}

// MARK: - Helper Views

private struct QualityMetricRow: View {
    let title: String
    let value: Double
    let description: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                    .fontWeight(.medium)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text("\(Int(value * 100))%")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(qualityColor(value))
                
                ProgressView(value: value)
                    .frame(width: 100)
            }
        }
    }
    
    private func qualityColor(_ score: Double) -> Color {
        if score >= 0.8 { return .green }
        if score >= 0.6 { return .orange }
        return .red
    }
}

private struct PatternRow: View {
    let title: String
    let detected: Bool
    let description: String
    
    var body: some View {
        HStack {
            Image(systemName: detected ? "checkmark.circle.fill" : "xmark.circle.fill")
                .foregroundColor(detected ? .green : .red)
            
            VStack(alignment: .leading) {
                Text(title)
                    .fontWeight(.medium)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
    }
}

private struct VisualizationRecommendationRow: View {
    let recommendation: VisualizationRecommendation
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(recommendation.chartType.rawValue.capitalized)
                    .fontWeight(.medium)
                Text(recommendation.reasoning)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text("\(Int(recommendation.confidence * 100))%")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                Text("Confidence")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
    }
}

// MARK: - DataFrame Comparison View

private struct DataFrameComparisonView: View {
    let dataFrames: [DataFrame]
    let hints: DataFrameAnalysisHints
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("DataFrame Comparison")
                .font(.headline)
            
            Text("Comparing \(dataFrames.count) DataFrames")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            // Placeholder for comparison logic
            Text("Comparison analysis coming soon...")
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

// MARK: - Data Quality Assessment View

private struct DataQualityAssessmentView: View {
    let dataFrame: DataFrame
    let hints: DataFrameAnalysisHints
    @StateObject private var analysisEngine = DataFrameAnalysisEngine()
    @State private var analysisResult: DataFrameAnalysisResult?
    @State private var isLoading = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if isLoading {
                ProgressView("Assessing data quality...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let result = analysisResult {
                DataQualitySection(result: result)
            } else {
                Text("Data quality assessment failed")
                    .foregroundColor(.red)
            }
        }
        .onAppear {
            performAnalysis()
        }
    }
    
    private func performAnalysis() {
        Task {
            let result = analysisEngine.analyzeDataFrame(dataFrame)
            await MainActor.run {
                self.analysisResult = result
                self.isLoading = false
            }
        }
    }
}
