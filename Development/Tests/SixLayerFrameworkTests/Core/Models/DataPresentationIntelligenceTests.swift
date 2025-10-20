import Testing

@testable import SixLayerFramework

@MainActor
open class DataPresentationIntelligenceTests: BaseTestClass {
    
    var intelligence: DataPresentationIntelligence!
    
    func setupTestEnvironment() async {
        intelligence = DataPresentationIntelligence.shared
    }
    
    // MARK: - TDD: Red Phase - Failing Tests
    
@Test func testDataPresentationIntelligenceExists() {
        // Given & When
        let intelligence = DataPresentationIntelligence.shared
        
        // Then
        #expect(intelligence != nil, "DataPresentationIntelligence should exist")
    }
    
    @Test func testAnalyzeDataWithEmptyArray() {
        // Given
        let emptyData: [String] = []
        
        // When
        let result = intelligence.analyzeData(emptyData)
        
        // Then
        #expect(result.dataPoints == 0)
        #expect(result.complexity == .simple)
    }
    
    @Test func testAnalyzeDataWithSimpleData() {
        // Given
        let simpleData = ["A", "B", "C", "D", "E"]
        
        // When
        let result = intelligence.analyzeData(simpleData)
        
        // Then
        #expect(result.dataPoints == 5)
        #expect(result.complexity == .simple)
        #expect(result.visualizationType == .categorical)
    }
    
    @Test func testAnalyzeDataWithModerateData() {
        // Given
        let moderateData = Array(1...15).map { "Item \($0)" }
        
        // When
        let result = intelligence.analyzeData(moderateData)
        
        // Then
        #expect(result.dataPoints == 15)
        #expect(result.complexity == .moderate)
    }
    
    @Test func testAnalyzeDataWithComplexData() {
        // Given
        let complexData = Array(1...50).map { "Item \($0)" }
        
        // When
        let result = intelligence.analyzeData(complexData)
        
        // Then
        #expect(result.dataPoints == 50)
        #expect(result.complexity == .complex)
    }
    
    @Test func testAnalyzeDataWithVeryComplexData() {
        // Given
        let veryComplexData = Array(1...150).map { "Item \($0)" }
        
        // When
        let result = intelligence.analyzeData(veryComplexData)
        
        // Then
        #expect(result.dataPoints == 150)
        #expect(result.complexity == .veryComplex)
    }
    
    // MARK: - Numerical Data Analysis Tests
    
    @Test func testAnalyzeNumericalDataWithSimpleValues() {
        // Given
        let values: [Double] = [10, 20, 30, 40, 50]
        
        // When
        let result = intelligence.analyzeNumericalData(values)
        
        // Then
        #expect(result.dataPoints == 5)
        #expect(result.complexity == .simple)
        #expect(result.visualizationType == .numerical)
    }
    
    @Test func testAnalyzeNumericalDataWithTimeSeriesPattern() {
        // Given
        let values: [Double] = [10, 15, 20, 25, 30, 35, 40, 45, 50, 55]
        
        // When
        let result = intelligence.analyzeNumericalData(values)
        
        // Then
        #expect(result.dataPoints == 10)
        #expect(result.complexity == .moderate)
        #expect(result.hasTimeSeries)
        #expect(result.visualizationType == .temporal)
    }
    
    @Test func testAnalyzeNumericalDataWithCategoricalPattern() {
        // Given
        let values: [Double] = [1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4]
        
        // When
        let result = intelligence.analyzeNumericalData(values)
        
        // Then
        #expect(result.dataPoints == 12)
        #expect(result.complexity == .moderate)
        #expect(result.hasCategories)
    }
    
    // MARK: - Categorical Data Analysis Tests
    
    @Test func testAnalyzeCategoricalDataWithSimpleCategories() {
        // Given
        let categories = ["A": 3, "B": 2, "C": 1]
        
        // When
        let result = intelligence.analyzeCategoricalData(categories)
        
        // Then
        #expect(result.dataPoints == 6)
        #expect(result.complexity == .simple)
        #expect(result.visualizationType == .categorical)
        #expect(result.recommendedChartType == .pie)
        #expect(result.hasCategories)
    }
    
    @Test func testAnalyzeCategoricalDataWithManyCategories() {
        // Given
        let categories = Dictionary(uniqueKeysWithValues: (1...10).map { ("Category \($0)", $0) })
        
        // When
        let result = intelligence.analyzeCategoricalData(categories)
        
        // Then
        #expect(result.dataPoints == 55) // Sum of 1+2+...+10
        #expect(result.complexity == .moderate)
        #expect(result.visualizationType == .categorical)
        #expect(result.recommendedChartType == .bar)
    }
    
    @Test func testAnalyzeCategoricalDataWithComplexCategories() {
        // Given
        let categories = Dictionary(uniqueKeysWithValues: (1...25).map { ("Category \($0)", $0) })
        
        // When
        let result = intelligence.analyzeCategoricalData(categories)
        
        // Then
        #expect(result.complexity == .complex)
        #expect(result.recommendedChartType == .table)
    }
    
    // MARK: - Chart Type Recommendation Tests
    
    @Test func testChartTypeRecommendationForSimpleNumericalData() {
        // Given
        let values: [Double] = [10, 20, 30, 40, 50]
        
        // When
        let result = intelligence.analyzeNumericalData(values)
        
        // Then
        #expect(result.recommendedChartType == .bar)
    }
    
    @Test func testChartTypeRecommendationForTimeSeriesData() {
        // Given
        let values: [Double] = [10, 15, 20, 25, 30, 35, 40, 45, 50, 55]
        
        // When
        let result = intelligence.analyzeNumericalData(values)
        
        // Then
        #expect(result.recommendedChartType == .line)
    }
    
    @Test func testChartTypeRecommendationForSimpleCategoricalData() {
        // Given
        let categories = ["A": 3, "B": 2, "C": 1]
        
        // When
        let result = intelligence.analyzeCategoricalData(categories)
        
        // Then
        #expect(result.recommendedChartType == .pie)
    }
    
    @Test func testChartTypeRecommendationForComplexCategoricalData() {
        // Given
        let categories = Dictionary(uniqueKeysWithValues: (1...25).map { ("Category \($0)", $0) })
        
        // When
        let result = intelligence.analyzeCategoricalData(categories)
        
        // Then
        #expect(result.recommendedChartType == .table)
    }
    
    // MARK: - Confidence Calculation Tests
    
    @Test func testConfidenceCalculationForSimpleData() {
        // Given
        let simpleData = ["A", "B", "C", "D", "E"]
        
        // When
        let result = intelligence.analyzeData(simpleData)
        
        // Then
        #expect(result.confidence == 0.9)
    }
    
    @Test func testConfidenceCalculationForModerateData() {
        // Given
        let moderateData = Array(1...15).map { "Item \($0)" }
        
        // When
        let result = intelligence.analyzeData(moderateData)
        
        // Then
        #expect(result.confidence == 1.0)
    }
    
    @Test func testConfidenceCalculationForComplexData() {
        // Given
        let complexData = Array(1...50).map { "Item \($0)" }
        
        // When
        let result = intelligence.analyzeData(complexData)
        
        // Then
        #expect(result.confidence == 0.8)
    }
    
    @Test func testConfidenceCalculationForVeryComplexData() {
        // Given
        let veryComplexData = Array(1...150).map { "Item \($0)" }
        
        // When
        let result = intelligence.analyzeData(veryComplexData)
        
        // Then
        #expect(result.confidence == 0.6)
    }
    
    // MARK: - Data Visualization Type Detection Tests
    
    @Test func testVisualizationTypeDetectionForNumericalData() {
        // Given
        let numericalData = [1.0, 2.0, 3.0, 4.0, 5.0]
        
        // When
        let result = intelligence.analyzeNumericalData(numericalData)
        
        // Then
        #expect(result.visualizationType == .numerical)
    }
    
    @Test func testVisualizationTypeDetectionForTemporalData() {
        // Given
        let temporalData = [10.0, 15.0, 20.0, 25.0, 30.0, 35.0, 40.0, 45.0, 50.0, 55.0]
        
        // When
        let result = intelligence.analyzeNumericalData(temporalData)
        
        // Then
        #expect(result.visualizationType == .temporal)
    }
    
    @Test func testVisualizationTypeDetectionForCategoricalData() {
        // Given
        let categories = ["A": 3, "B": 2, "C": 1]
        
        // When
        let result = intelligence.analyzeCategoricalData(categories)
        
        // Then
        #expect(result.visualizationType == .categorical)
    }
    
    // MARK: - Performance Tests
    
    @Test func testDataAnalysisPerformance() {
        // Given
        let largeData = Array(1...1000).map { "Item \($0)" }
        
        // When & Then
        }
    }
    
    // Performance tests removed - performance monitoring was removed from framework
    
    // MARK: - Edge Cases Tests
    
    @Test func testAnalysisWithSingleDataPoint() {
        // Given
        let intelligence = DataPresentationIntelligence.shared
        let singleData = ["Single Item"]
        
        // When
        let result = intelligence.analyzeData(singleData)
        
        // Then
        #expect(result.dataPoints == 1)
        #expect(result.complexity == .simple)
    }
    
    @Test func testAnalysisWithIdenticalValues() {
        // Given
        let intelligence = DataPresentationIntelligence.shared
        let identicalValues = Array(repeating: 42.0, count: 10)
        
        // When
        let result = intelligence.analyzeNumericalData(identicalValues)
        
        // Then
        #expect(result.dataPoints == 10)
        #expect(result.complexity == .moderate)
        #expect(result.hasCategories)
    }
    
    @Test func testAnalysisWithZeroValues() {
        // Given
        let zeroValues: [Double] = [0, 0, 0, 0, 0]
        
        // When
        let result = intelligence.analyzeNumericalData(zeroValues)
        
        // Then
        #expect(result.dataPoints == 5)
        #expect(result.complexity == .simple)
        #expect(result.hasCategories)
    }
    
    @Test func testAnalysisWithNegativeValues() {
        // Given
        let negativeValues: [Double] = [-10, -5, 0, 5, 10]
        
        // When
        let result = intelligence.analyzeNumericalData(negativeValues)
        
        // Then
        #expect(result.dataPoints == 5)
        #expect(result.complexity == .simple)
    }
    
    @Test func testAnalysisWithVeryLargeValues() {
        // Given
        let largeValues: [Double] = [1e6, 2e6, 3e6, 4e6, 5e6]
        
        // When
        let result = intelligence.analyzeNumericalData(largeValues)
        
        // Then
        #expect(result.dataPoints == 5)
        #expect(result.complexity == .simple)
    }
    
    // MARK: - Consistency Tests
    
    @Test func testAnalysisConsistencyForSameData() {
        // Given
        let data = ["A", "B", "C", "D", "E"]
        
        // When
        let result1 = intelligence.analyzeData(data)
        let result2 = intelligence.analyzeData(data)
        
        // Then
        #expect(result1.dataPoints == result2.dataPoints)
        #expect(result1.complexity == result2.complexity)
        #expect(result1.visualizationType == result2.visualizationType)
        #expect(result1.recommendedChartType == result2.recommendedChartType)
    }
    
    @Test func testAnalysisConsistencyForSimilarData() {
        // Given
        let data1 = ["A", "B", "C", "D", "E"]
        let data2 = ["X", "Y", "Z", "W", "V"]
        
        // When
        let result1 = intelligence.analyzeData(data1)
        let result2 = intelligence.analyzeData(data2)
        
        // Then
        #expect(result1.dataPoints == result2.dataPoints)
        #expect(result1.complexity == result2.complexity)
        #expect(result1.visualizationType == result2.visualizationType)
        #expect(result1.recommendedChartType == result2.recommendedChartType)
    }

