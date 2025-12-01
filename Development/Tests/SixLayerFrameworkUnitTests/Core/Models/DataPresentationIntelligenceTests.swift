import Testing

@testable import SixLayerFramework

/// NOTE: Not marked @MainActor on class to allow parallel execution
@Suite("Data Presentation Intelligence")
open class DataPresentationIntelligenceTests: BaseTestClass {
    
    // MARK: - Helper Methods
    
    @MainActor
    public func createIntelligence() -> DataPresentationIntelligence {
        return DataPresentationIntelligence.shared
    }
    
    // MARK: - TDD: Red Phase - Failing Tests
    
@Test @MainActor func testDataPresentationIntelligenceExists() {
        initializeTestConfig()
        // Given & When
        let _ = DataPresentationIntelligence.shared
        
        // Then
        // intelligence is a non-optional singleton instance, so it exists if we reach here
    }
    
    @Test @MainActor func testAnalyzeDataWithEmptyArray() {
        initializeTestConfig()
        // Given
        let intelligence = createIntelligence()
        let emptyData: [String] = []
        
        // When
        let result = intelligence.analyzeData(emptyData)
        
        // Then
        #expect(result.dataPoints == 0)
        #expect(result.complexity == .simple)
    }
    
    @Test @MainActor func testAnalyzeDataWithSimpleData() {
        initializeTestConfig()
        // Given
        let intelligence = createIntelligence()
        let simpleData = ["A", "B", "C", "D", "E"]
        
        // When
        let result = intelligence.analyzeData(simpleData)
        
        // Then
        #expect(result.dataPoints == 5)
        #expect(result.complexity == .simple)
        #expect(result.visualizationType == .categorical)
    }
    
    @Test @MainActor func testAnalyzeDataWithModerateData() {
        initializeTestConfig()
        // Given
        let moderateData = Array(1...15).map { "Item \($0)" }
        
        // When
        let intelligence = createIntelligence()
        let result = intelligence.analyzeData(moderateData)
        
        // Then
        #expect(result.dataPoints == 15)
        #expect(result.complexity == .moderate)
    }
    
    @Test @MainActor func testAnalyzeDataWithComplexData() {
        initializeTestConfig()
        // Given
        let complexData = Array(1...50).map { "Item \($0)" }
        
        // When
        let intelligence = createIntelligence()
        let result = intelligence.analyzeData(complexData)
        
        // Then
        #expect(result.dataPoints == 50)
        #expect(result.complexity == .complex)
    }
    
    @Test @MainActor func testAnalyzeDataWithVeryComplexData() {
        initializeTestConfig()
        // Given
        let veryComplexData = Array(1...150).map { "Item \($0)" }
        
        // When
        let intelligence = createIntelligence()
        let result = intelligence.analyzeData(veryComplexData)
        
        // Then
        #expect(result.dataPoints == 150)
        #expect(result.complexity == .veryComplex)
    }
    
    // MARK: - Numerical Data Analysis Tests
    
    @Test @MainActor func testAnalyzeNumericalDataWithSimpleValues() {
        initializeTestConfig()
        // Given
        let values: [Double] = [10, 20, 30, 40, 50]
        
        // When
        let intelligence = createIntelligence()
        let result = intelligence.analyzeNumericalData(values)
        
        // Then
        #expect(result.dataPoints == 5)
        #expect(result.complexity == .simple)
        #expect(result.visualizationType == .numerical)
    }
    
    @Test @MainActor func testAnalyzeNumericalDataWithTimeSeriesPattern() {
        initializeTestConfig()
        // Given
        let values: [Double] = [10, 15, 20, 25, 30, 35, 40, 45, 50, 55]
        
        // When
        let intelligence = createIntelligence()
        let result = intelligence.analyzeNumericalData(values)
        
        // Then
        #expect(result.dataPoints == 10)
        #expect(result.complexity == .moderate)
        #expect(result.hasTimeSeries)
        #expect(result.visualizationType == .temporal)
    }
    
    @Test @MainActor func testAnalyzeNumericalDataWithCategoricalPattern() {
        initializeTestConfig()
        // Given
        let values: [Double] = [1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4]
        
        // When
        let intelligence = createIntelligence()
        let result = intelligence.analyzeNumericalData(values)
        
        // Then
        #expect(result.dataPoints == 12)
        #expect(result.complexity == .moderate)
        #expect(result.hasCategories)
    }
    
    // MARK: - Categorical Data Analysis Tests
    
    @Test @MainActor func testAnalyzeCategoricalDataWithSimpleCategories() {
        initializeTestConfig()
        // Given
        let categories = ["A": 3, "B": 2, "C": 1]
        
        // When
        let intelligence = createIntelligence()
        let result = intelligence.analyzeCategoricalData(categories)
        
        // Then
        #expect(result.dataPoints == 6)
        #expect(result.complexity == .simple)
        #expect(result.visualizationType == .categorical)
        #expect(result.recommendedChartType == .pie)
        #expect(result.hasCategories)
    }
    
    @Test @MainActor func testAnalyzeCategoricalDataWithManyCategories() {
        initializeTestConfig()
        // Given
        let categories = Dictionary(uniqueKeysWithValues: (1...10).map { ("Category \($0)", $0) })
        
        // When
        let intelligence = createIntelligence()
        let result = intelligence.analyzeCategoricalData(categories)
        
        // Then
        #expect(result.dataPoints == 55) // Sum of 1+2+...+10
        #expect(result.complexity == .moderate)
        #expect(result.visualizationType == .categorical)
        #expect(result.recommendedChartType == .bar)
    }
    
    @Test @MainActor func testAnalyzeCategoricalDataWithComplexCategories() {
        initializeTestConfig()
        // Given
        let intelligence = createIntelligence()
        let categories = Dictionary(uniqueKeysWithValues: (1...25).map { ("Category \($0)", $0) })
        
        // When
        let result = intelligence.analyzeCategoricalData(categories)
        
        // Then
        #expect(result.complexity == .complex)
        #expect(result.recommendedChartType == .table)
    }
    
    // MARK: - Chart Type Recommendation Tests
    
    @Test @MainActor func testChartTypeRecommendationForSimpleNumericalData() {
        initializeTestConfig()
        // Given
        let values: [Double] = [10, 20, 30, 40, 50]
        
        // When
        let intelligence = createIntelligence()
        let result = intelligence.analyzeNumericalData(values)
        
        // Then
        #expect(result.recommendedChartType == .bar)
    }
    
    @Test @MainActor func testChartTypeRecommendationForTimeSeriesData() {
        initializeTestConfig()
        // Given
        let values: [Double] = [10, 15, 20, 25, 30, 35, 40, 45, 50, 55]
        
        // When
        let intelligence = createIntelligence()
        let result = intelligence.analyzeNumericalData(values)
        
        // Then
        #expect(result.recommendedChartType == .line)
    }
    
    @Test @MainActor func testChartTypeRecommendationForSimpleCategoricalData() {
        initializeTestConfig()
        // Given
        let categories = ["A": 3, "B": 2, "C": 1]
        
        // When
        let intelligence = createIntelligence()
        let result = intelligence.analyzeCategoricalData(categories)
        
        // Then
        #expect(result.recommendedChartType == .pie)
    }
    
    @Test @MainActor func testChartTypeRecommendationForComplexCategoricalData() async {
        initializeTestConfig()
        // Given
        let intelligence = createIntelligence()
        let categories = Dictionary(uniqueKeysWithValues: (1...25).map { ("Category \($0)", $0) })
        
        // When
        let result = intelligence.analyzeCategoricalData(categories)
        
        // Then
        #expect(result.recommendedChartType == .table)
    }
    
    // MARK: - Confidence Calculation Tests
    
    @Test @MainActor func testConfidenceCalculationForSimpleData() {
        initializeTestConfig()
        // Given
        let simpleData = ["A", "B", "C", "D", "E"]
        
        // When
        let intelligence = createIntelligence()
        let result = intelligence.analyzeData(simpleData)
        
        // Then
        #expect(result.confidence == 1.0)
    }
    
    @Test @MainActor func testConfidenceCalculationForModerateData() {
        initializeTestConfig()
        // Given
        let moderateData = Array(1...15).map { "Item \($0)" }
        
        // When
        let intelligence = createIntelligence()
        let result = intelligence.analyzeData(moderateData)
        
        // Then
        #expect(result.confidence == 0.9)
    }
    
    @Test @MainActor func testConfidenceCalculationForComplexData() async {
        initializeTestConfig()
        // Given
        let intelligence = createIntelligence()
        let complexData = Array(1...50).map { "Item \($0)" }
        
        // When
        let result = intelligence.analyzeData(complexData)
        
        // Then
        #expect(result.confidence == 0.8)
    }
    
    @Test @MainActor func testConfidenceCalculationForVeryComplexData() {
        initializeTestConfig()
        // Given
        let veryComplexData = Array(1...150).map { "Item \($0)" }
        
        // When
        let intelligence = createIntelligence()
        let result = intelligence.analyzeData(veryComplexData)
        
        // Then
        #expect(result.confidence == 0.6)
    }
    
    // MARK: - Data Visualization Type Detection Tests
    
    @Test @MainActor func testVisualizationTypeDetectionForNumericalData() {
        initializeTestConfig()
        // Given
        let intelligence = createIntelligence()
        let numericalData = [1.0, 2.0, 3.0, 4.0, 5.0]
        
        // When
        let result = intelligence.analyzeNumericalData(numericalData)
        
        // Then
        #expect(result.visualizationType == .numerical)
    }
    
    @Test @MainActor func testVisualizationTypeDetectionForTemporalData() {
        initializeTestConfig()
        // Given
        let temporalData = [10.0, 15.0, 20.0, 25.0, 30.0, 35.0, 40.0, 45.0, 50.0, 55.0]
        
        // When
        let intelligence = createIntelligence()
        let result = intelligence.analyzeNumericalData(temporalData)
        
        // Then
        #expect(result.visualizationType == .temporal)
    }
    
    @Test @MainActor func testVisualizationTypeDetectionForCategoricalData() {
        initializeTestConfig()
        // Given
        let categories = ["A": 3, "B": 2, "C": 1]
        
        // When
        let intelligence = createIntelligence()
        let result = intelligence.analyzeCategoricalData(categories)
        
        // Then
        #expect(result.visualizationType == .categorical)
    }
    
    
    // MARK: - Edge Cases Tests
    
    @Test @MainActor func testAnalysisWithSingleDataPoint() async {
        initializeTestConfig()
        // Given
        let intelligence = createIntelligence()
        let singleData = ["Single Item"]
        
        // When
        let result = intelligence.analyzeData(singleData)
        
        // Then
        #expect(result.dataPoints == 1)
        #expect(result.complexity == .simple)
    }
    
    @Test @MainActor func testAnalysisWithIdenticalValues() async {
        initializeTestConfig()
        // Given
        let intelligence = createIntelligence()
        let identicalValues = Array(repeating: 42.0, count: 10)
        
        // When
        let result = intelligence.analyzeNumericalData(identicalValues)
        
        // Then
        #expect(result.dataPoints == 10)
        #expect(result.complexity == .moderate)
        #expect(result.hasCategories)
    }
    
    @Test @MainActor func testAnalysisWithZeroValues() async {
        initializeTestConfig()
        // Given
        let intelligence = createIntelligence()
        let zeroValues: [Double] = [0, 0, 0, 0, 0]
        
        // When
        let result = intelligence.analyzeNumericalData(zeroValues)
        
        // Then
        #expect(result.dataPoints == 5)
        #expect(result.complexity == .simple)
        #expect(result.hasCategories)
    }
    
    @Test @MainActor func testAnalysisWithNegativeValues() async {
        initializeTestConfig()
        // Given
        let intelligence = createIntelligence()
        let negativeValues: [Double] = [-10, -5, 0, 5, 10]
        
        // When
        let result = intelligence.analyzeNumericalData(negativeValues)
        
        // Then
        #expect(result.dataPoints == 5)
        #expect(result.complexity == .simple)
    }
    
    @Test @MainActor func testAnalysisWithVeryLargeValues() async {
        initializeTestConfig()
        // Given
        let intelligence = createIntelligence()
        let largeValues: [Double] = [1e6, 2e6, 3e6, 4e6, 5e6]
        
        // When
        let result = intelligence.analyzeNumericalData(largeValues)
        
        // Then
        #expect(result.dataPoints == 5)
        #expect(result.complexity == .simple)
    }
    
    // MARK: - Consistency Tests
    
    @Test @MainActor func testAnalysisConsistencyForSameData() async {
        initializeTestConfig()
        // Given
        let intelligence = createIntelligence()
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
    
    @Test @MainActor func testAnalysisConsistencyForSimilarData() async {
        initializeTestConfig()
        // Given
        let intelligence = createIntelligence()
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
}

