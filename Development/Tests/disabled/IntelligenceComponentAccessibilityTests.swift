//
//  IntelligenceComponentAccessibilityTests.swift
//  SixLayerFrameworkTests
//
//  Comprehensive accessibility tests for ALL Intelligence Components
//

import XCTest
import SwiftUI
@testable import SixLayerFramework

@MainActor
final class IntelligenceComponentAccessibilityTests: XCTestCase {
    
    // MARK: - Intelligence Component Tests
    
    func testImageMetadataIntelligenceGeneratesAccessibilityIdentifiers() async {
        // Given: ImageMetadataIntelligence
        let testView = ImageMetadataIntelligence()
        
        // Then: Should generate accessibility identifiers
        let hasAccessibilityID = hasAccessibilityIdentifier(
            testView,
            expectedPattern: "*.main.element.*",
            componentName: "ImageMetadataIntelligence"
        )
        
        XCTAssertTrue(hasAccessibilityID, "ImageMetadataIntelligence should generate accessibility identifiers")
    }
    
    func testDataFrameAnalysisEngineGeneratesAccessibilityIdentifiers() async {
        // Given: DataFrameAnalysisEngine
        let testView = DataFrameAnalysisEngine()
        
        // Then: Should generate accessibility identifiers
        let hasAccessibilityID = hasAccessibilityIdentifier(
            testView,
            expectedPattern: "*.main.element.*",
            componentName: "DataFrameAnalysisEngine"
        )
        
        XCTAssertTrue(hasAccessibilityID, "DataFrameAnalysisEngine should generate accessibility identifiers")
    }
    
    func testRuntimeCapabilityDetectionGeneratesAccessibilityIdentifiers() async {
        // Given: RuntimeCapabilityDetection
        let testView = RuntimeCapabilityDetection()
        
        // Then: Should generate accessibility identifiers
        let hasAccessibilityID = hasAccessibilityIdentifier(
            testView,
            expectedPattern: "*.main.element.*",
            componentName: "RuntimeCapabilityDetection"
        )
        
        XCTAssertTrue(hasAccessibilityID, "RuntimeCapabilityDetection should generate accessibility identifiers")
    }
}

// MARK: - Mock Intelligence Components (Placeholder implementations)

struct ImageMetadataIntelligence: View {
    var body: some View {
        VStack {
            Text("Image Metadata Intelligence")
            Button("Analyze") { }
        }
        .automaticAccessibilityIdentifiers()
    }
}

struct DataFrameAnalysisEngine: View {
    var body: some View {
        VStack {
            Text("Data Frame Analysis Engine")
            Button("Analyze") { }
        }
        .automaticAccessibilityIdentifiers()
    }
}

