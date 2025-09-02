import XCTest
@testable import SixLayerFramework

final class DataPresentationIntelligenceTests: XCTestCase {
    
    var intelligence: DataPresentationIntelligence!
    
    override func setUp() {
        super.setUp()
        intelligence = DataPresentationIntelligence.shared
    }
    
    override func tearDown() {
        intelligence = nil
        super.tearDown()
    }
    
    // MARK: - TDD: Red Phase - Failing Tests
    
    func testDataPresentationIntelligenceExists() {
        // Given & When
        let intelligence = DataPresentationIntelligence.shared
        
        // Then
        XCTAssertNotNil(intelligence, "DataPresentationIntelligence should exist")
    }
    
    func testAnalyzeDataWithEmptyArray() {
        // Given
        let emptyData: [String] = []
        
        // When
        let result = intelligence.analyzeData(emptyData)
        
        // Then
        XCTAssertEqual(result.dataPoints, 0)
        XCTAssertEqual(result.complexity, .simple)
    }
    
    func testAnalyzeDataWithSimpleData() {
        // Given
        let simpleData = ["A", "B", "C", "D", "E"]
        
        // When
        let result = intelligence.analyzeData(simpleData)
        
        // Then
        XCTAssertEqual(result.dataPoints, 5)
        XCTAssertEqual(result.complexity, .simple)
        XCTAssertEqual(result.visualizationType, .categorical)
    }
    
    func testAnalyzeDataWithModerateData() {
        // Given
        let moderateData = Array(1...15).map { "Item \($0)" }
        
        // When
        let result = intelligence.analyzeData(moderateData)
        
        // Then
        XCTAssertEqual(result.dataPoints, 15)
        XCTAssertEqual(result.complexity, .moderate)
    }
    
    func testAnalyzeDataWithComplexData() {
        // Given
        let complexData = Array(1...50).map { "Item \($0)" }
        
        // When
        let result = intelligence.analyzeData(complexData)
        
        // Then
        XCTAssertEqual(result.dataPoints, 50)
        XCTAssertEqual(result.complexity, .complex)
    }
    
    func testAnalyzeDataWithVeryComplexData() {
        // Given
        let veryComplexData = Array(1...150).map { "Item \($0)" }
        
        // When
        let result = intelligence.analyzeData(veryComplexData)
        
        // Then
        XCTAssertEqual(result.dataPoints, 150)
        XCTAssertEqual(result.complexity, .veryComplex)
    }
    
    // MARK: - Numerical Data Analysis Tests
    
    func testAnalyzeNumericalDataWithSimpleValues() {
        // Given
        let values: [Double] = [10, 20, 30, 40, 50]
        
        // When
        let result = intelligence.analyzeNumericalData(values)
        
        // Then
        XCTAssertEqual(result.dataPoints, 5)
        XCTAssertEqual(result.complexity, .simple)
        XCTAssertEqual(result.visualizationType, .numerical)
    }
    
    func testAnalyzeNumericalDataWithTimeSeriesPattern() {
        // Given
        let values: [Double] = [10, 15, 20, 25, 30, 35, 40, 45, 50, 55]
        
        // When
        let result = intelligence.analyzeNumericalData(values)
        
        // Then
        XCTAssertEqual(result.dataPoints, 10)
        XCTAssertEqual(result.complexity, .moderate)
        XCTAssertTrue(result.hasTimeSeries)
        XCTAssertEqual(result.visualizationType, .temporal)
    }
    
    func testAnalyzeNumericalDataWithCategoricalPattern() {
        // Given
        let values: [Double] = [1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4]
        
        // When
        let result = intelligence.analyzeNumericalData(values)
        
        // Then
        XCTAssertEqual(result.dataPoints, 12)
        XCTAssertEqual(result.complexity, .moderate)
        XCTAssertTrue(result.hasCategories)
    }
    
    // MARK: - Categorical Data Analysis Tests
    
    func testAnalyzeCategoricalDataWithSimpleCategories() {
        // Given
        let categories = ["A": 3, "B": 2, "C": 1]
        
        // When
        let result = intelligence.analyzeCategoricalData(categories)
        
        // Then
        XCTAssertEqual(result.dataPoints, 6)
        XCTAssertEqual(result.complexity, .simple)
        XCTAssertEqual(result.visualizationType, .categorical)
        XCTAssertEqual(result.recommendedChartType, .pie)
        XCTAssertTrue(result.hasCategories)
    }
    
    func testAnalyzeCategoricalDataWithManyCategories() {
        // Given
        let categories = Dictionary(uniqueKeysWithValues: (1...10).map { ("Category \($0)", $0) })
        
        // When
        let result = intelligence.analyzeCategoricalData(categories)
        
        // Then
        XCTAssertEqual(result.dataPoints, 55) // Sum of 1+2+...+10
        XCTAssertEqual(result.complexity, .moderate)
        XCTAssertEqual(result.visualizationType, .categorical)
        XCTAssertEqual(result.recommendedChartType, .bar)
    }
    
    func testAnalyzeCategoricalDataWithComplexCategories() {
        // Given
        let categories = Dictionary(uniqueKeysWithValues: (1...25).map { ("Category \($0)", $0) })
        
        // When
        let result = intelligence.analyzeCategoricalData(categories)
        
        // Then
        XCTAssertEqual(result.complexity, .complex)
        XCTAssertEqual(result.recommendedChartType, .table)
    }
    
    // MARK: - Chart Type Recommendation Tests
    
    func testChartTypeRecommendationForSimpleNumericalData() {
        // Given
        let values: [Double] = [10, 20, 30, 40, 50]
        
        // When
        let result = intelligence.analyzeNumericalData(values)
        
        // Then
        XCTAssertEqual(result.recommendedChartType, .bar)
    }
    
    func testChartTypeRecommendationForTimeSeriesData() {
        // Given
        let values: [Double] = [10, 15, 20, 25, 30, 35, 40, 45, 50, 55]
        
        // When
        let result = intelligence.analyzeNumericalData(values)
        
        // Then
        XCTAssertEqual(result.recommendedChartType, .line)
    }
    
    func testChartTypeRecommendationForSimpleCategoricalData() {
        // Given
        let categories = ["A": 3, "B": 2, "C": 1]
        
        // When
        let result = intelligence.analyzeCategoricalData(categories)
        
        // Then
        XCTAssertEqual(result.recommendedChartType, .pie)
    }
    
    func testChartTypeRecommendationForComplexCategoricalData() {
        // Given
        let categories = Dictionary(uniqueKeysWithValues: (1...25).map { ("Category \($0)", $0) })
        
        // When
        let result = intelligence.analyzeCategoricalData(categories)
        
        // Then
        XCTAssertEqual(result.recommendedChartType, .table)
    }
    
    // MARK: - Confidence Calculation Tests
    
    func testConfidenceCalculationForSimpleData() {
        // Given
        let simpleData = ["A", "B", "C", "D", "E"]
        
        // When
        let result = intelligence.analyzeData(simpleData)
        
        // Then
        XCTAssertEqual(result.confidence, 0.9, accuracy: 0.1)
    }
    
    func testConfidenceCalculationForModerateData() {
        // Given
        let moderateData = Array(1...15).map { "Item \($0)" }
        
        // When
        let result = intelligence.analyzeData(moderateData)
        
        // Then
        XCTAssertEqual(result.confidence, 1.0, accuracy: 0.1)
    }
    
    func testConfidenceCalculationForComplexData() {
        // Given
        let complexData = Array(1...50).map { "Item \($0)" }
        
        // When
        let result = intelligence.analyzeData(complexData)
        
        // Then
        XCTAssertEqual(result.confidence, 0.8, accuracy: 0.1)
    }
    
    func testConfidenceCalculationForVeryComplexData() {
        // Given
        let veryComplexData = Array(1...150).map { "Item \($0)" }
        
        // When
        let result = intelligence.analyzeData(veryComplexData)
        
        // Then
        XCTAssertEqual(result.confidence, 0.6, accuracy: 0.1)
    }
    
    // MARK: - Data Visualization Type Detection Tests
    
    func testVisualizationTypeDetectionForNumericalData() {
        // Given
        let numericalData = [1.0, 2.0, 3.0, 4.0, 5.0]
        
        // When
        let result = intelligence.analyzeNumericalData(numericalData)
        
        // Then
        XCTAssertEqual(result.visualizationType, .numerical)
    }
    
    func testVisualizationTypeDetectionForTemporalData() {
        // Given
        let temporalData = [10.0, 15.0, 20.0, 25.0, 30.0, 35.0, 40.0, 45.0, 50.0, 55.0]
        
        // When
        let result = intelligence.analyzeNumericalData(temporalData)
        
        // Then
        XCTAssertEqual(result.visualizationType, .temporal)
    }
    
    func testVisualizationTypeDetectionForCategoricalData() {
        // Given
        let categories = ["A": 3, "B": 2, "C": 1]
        
        // When
        let result = intelligence.analyzeCategoricalData(categories)
        
        // Then
        XCTAssertEqual(result.visualizationType, .categorical)
    }
    
    // MARK: - Performance Tests
    
    func testDataAnalysisPerformance() {
        // Given
        let largeData = Array(1...1000).map { "Item \($0)" }
        
        // When & Then
        measure {
            _ = intelligence.analyzeData(largeData)
        }
    }
    
    func testNumericalDataAnalysisPerformance() {
        // Given
        let largeValues = Array(1...1000).map { Double($0) }
        
        // When & Then
        measure {
            _ = intelligence.analyzeNumericalData(largeValues)
        }
    }
    
    func testCategoricalDataAnalysisPerformance() {
        // Given
        let largeCategories = Dictionary(uniqueKeysWithValues: (1...100).map { ("Category \($0)", $0) })
        
        // When & Then
        measure {
            _ = intelligence.analyzeCategoricalData(largeCategories)
        }
    }
    
    // MARK: - Edge Cases Tests
    
    func testAnalysisWithSingleDataPoint() {
        // Given
        let singleData = ["Single Item"]
        
        // When
        let result = intelligence.analyzeData(singleData)
        
        // Then
        XCTAssertEqual(result.dataPoints, 1)
        XCTAssertEqual(result.complexity, .simple)
    }
    
    func testAnalysisWithIdenticalValues() {
        // Given
        let identicalValues = Array(repeating: 42.0, count: 10)
        
        // When
        let result = intelligence.analyzeNumericalData(identicalValues)
        
        // Then
        XCTAssertEqual(result.dataPoints, 10)
        XCTAssertEqual(result.complexity, .moderate)
        XCTAssertTrue(result.hasCategories)
    }
    
    func testAnalysisWithZeroValues() {
        // Given
        let zeroValues: [Double] = [0, 0, 0, 0, 0]
        
        // When
        let result = intelligence.analyzeNumericalData(zeroValues)
        
        // Then
        XCTAssertEqual(result.dataPoints, 5)
        XCTAssertEqual(result.complexity, .simple)
        XCTAssertTrue(result.hasCategories)
    }
    
    func testAnalysisWithNegativeValues() {
        // Given
        let negativeValues: [Double] = [-10, -5, 0, 5, 10]
        
        // When
        let result = intelligence.analyzeNumericalData(negativeValues)
        
        // Then
        XCTAssertEqual(result.dataPoints, 5)
        XCTAssertEqual(result.complexity, .simple)
    }
    
    func testAnalysisWithVeryLargeValues() {
        // Given
        let largeValues: [Double] = [1e6, 2e6, 3e6, 4e6, 5e6]
        
        // When
        let result = intelligence.analyzeNumericalData(largeValues)
        
        // Then
        XCTAssertEqual(result.dataPoints, 5)
        XCTAssertEqual(result.complexity, .simple)
    }
    
    // MARK: - Consistency Tests
    
    func testAnalysisConsistencyForSameData() {
        // Given
        let data = ["A", "B", "C", "D", "E"]
        
        // When
        let result1 = intelligence.analyzeData(data)
        let result2 = intelligence.analyzeData(data)
        
        // Then
        XCTAssertEqual(result1.dataPoints, result2.dataPoints)
        XCTAssertEqual(result1.complexity, result2.complexity)
        XCTAssertEqual(result1.visualizationType, result2.visualizationType)
        XCTAssertEqual(result1.recommendedChartType, result2.recommendedChartType)
    }
    
    func testAnalysisConsistencyForSimilarData() {
        // Given
        let data1 = ["A", "B", "C", "D", "E"]
        let data2 = ["X", "Y", "Z", "W", "V"]
        
        // When
        let result1 = intelligence.analyzeData(data1)
        let result2 = intelligence.analyzeData(data2)
        
        // Then
        XCTAssertEqual(result1.dataPoints, result2.dataPoints)
        XCTAssertEqual(result1.complexity, result2.complexity)
        XCTAssertEqual(result1.visualizationType, result2.visualizationType)
        XCTAssertEqual(result1.recommendedChartType, result2.recommendedChartType)
    }
}
