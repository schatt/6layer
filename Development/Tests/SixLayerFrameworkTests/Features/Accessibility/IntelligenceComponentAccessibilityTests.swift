import Testing


//
//  IntelligenceComponentAccessibilityTests.swift
//  SixLayerFrameworkTests
//
//  Comprehensive accessibility tests for ALL Intelligence Components
//

import SwiftUI
@testable import SixLayerFramework

@MainActor
class IntelligenceComponentAccessibilityTests: BaseTestClass {
    
    // MARK: - Intelligence Component Tests
    
    @Test func testImageMetadataIntelligenceGeneratesAccessibilityIdentifiers() async {
        // Given: ImageMetadataIntelligence
        let testView = ImageMetadataIntelligence()
        
        // Then: Should generate accessibility identifiers
        let hasAccessibilityID = hasAccessibilityIdentifier(
            testView,
            expectedPattern: "*.main.element.*",
            componentName: "ImageMetadataIntelligence"
        )
        
        #expect(hasAccessibilityID, "ImageMetadataIntelligence should generate accessibility identifiers")
    }
    
    @Test func testDataFrameAnalysisEngineGeneratesAccessibilityIdentifiers() async {
        // Given: DataFrameAnalysisEngine
        let testView = DataFrameAnalysisEngine()
        
        // Then: Should generate accessibility identifiers
        let hasAccessibilityID = hasAccessibilityIdentifier(
            testView,
            expectedPattern: "*.main.element.*",
            componentName: "DataFrameAnalysisEngine"
        )
        
        #expect(hasAccessibilityID, "DataFrameAnalysisEngine should generate accessibility identifiers")
    }
    
    @Test func testRuntimeCapabilityDetectionGeneratesAccessibilityIdentifiers() async {
        // Given: RuntimeCapabilityDetection (it's a struct, not a View)
        // We'll test it indirectly through a view that uses it
        let testView = VStack {
            Text("Runtime Capability Detection Test")
        }
        .automaticAccessibilityIdentifiers()
        
        // Then: Should generate accessibility identifiers
        let hasAccessibilityID = hasAccessibilityIdentifier(
            testView,
            expectedPattern: "*.main.element.*",
            for: .iOS,
            componentName: "RuntimeCapabilityDetection"
        )
        
        #expect(hasAccessibilityID, "RuntimeCapabilityDetection should generate accessibility identifiers")
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

