import Testing


//
//  IntelligentFormViewComponentAccessibilityTests.swift
//  SixLayerFrameworkTests
//
//  Comprehensive accessibility tests for ALL IntelligentFormView components
//

import SwiftUI
@testable import SixLayerFramework

@MainActor
@Suite("Intelligent Form View Component Accessibility")
open class IntelligentFormViewComponentAccessibilityTests: BaseTestClass {
    
    // MARK: - IntelligentFormView Tests
    
    @Test func testIntelligentFormViewGeneratesAccessibilityIdentifiers() async {
        try await runWithTaskLocalConfig {
            // Given: Sample data for form generation
            struct SampleData {
                let name: String
                let email: String
            }
            
            let sampleData = SampleData(name: "Test User", email: "test@example.com")
            
            // When: Creating IntelligentFormView using static method
            let view = IntelligentFormView.generateForm(
                for: SampleData.self,
                initialData: sampleData,
                onSubmit: { _ in },
                onCancel: { }
            )
            
            // Then: Should generate accessibility identifiers
            let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
                view,
                expectedPattern: "SixLayer.main.ui.*",
                platform: SixLayerPlatform.iOS,
                componentName: "IntelligentFormView"
            )
            
            #expect(hasAccessibilityID, "IntelligentFormView should generate accessibility identifiers")
        }
    }
    
    // MARK: - IntelligentDetailView Tests
    
    @Test func testIntelligentDetailViewGeneratesAccessibilityIdentifiers() async {
        try await runWithTaskLocalConfig {
            // Given: Test detail data
            let detailData = IntelligentDetailData(
                id: "detail-1",
                title: "Intelligent Detail",
                content: "This is intelligent detail content",
                metadata: ["key": "value"]
            )
            
            // When: Creating IntelligentDetailView
            let view = IntelligentDetailView.platformDetailView(for: detailData)
            
            // Then: Should generate accessibility identifiers
            let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
                view,
                expectedPattern: "SixLayer.main.ui.*",
                platform: SixLayerPlatform.iOS,
                componentName: "IntelligentDetailView"
            )
            
            #expect(hasAccessibilityID, "IntelligentDetailView should generate accessibility identifiers")
        }
    }
}

// MARK: - Test Data Types

struct IntelligentFormConfiguration {
    let id: String
    let title: String
    let fields: [IntelligentFormField]
    let intelligenceLevel: IntelligenceLevel
}

struct IntelligentFormField {
    let id: String
    let label: String
    let type: IntelligentFormFieldType
    let value: String
    let intelligenceFeatures: [IntelligenceFeature]
}

enum IntelligentFormFieldType {
    case text
    case number
    case email
    case password
    case intelligent
}

enum IntelligenceLevel {
    case basic
    case intermediate
    case advanced
    case expert
}

enum IntelligenceFeature {
    case autoComplete
    case validation
    case suggestions
    case adaptive
}

struct IntelligentDetailData {
    let id: String
    let title: String
    let content: String
    let metadata: [String: String]
}



