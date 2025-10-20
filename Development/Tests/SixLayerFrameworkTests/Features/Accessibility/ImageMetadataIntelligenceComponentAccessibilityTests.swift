import Testing

//
//  ImageMetadataIntelligenceComponentAccessibilityTests.swift
//  SixLayerFrameworkTests
//
//  Comprehensive accessibility tests for ALL Image Metadata Intelligence Components
//

import SwiftUI
@testable import SixLayerFramework

@MainActor
open class ImageMetadataIntelligenceComponentAccessibilityTests: BaseTestClass {
    
    // MARK: - Image Metadata Intelligence Component Tests
    
    @Test func testImageMetadataIntelligenceGeneratesAccessibilityIdentifiers() async {
        // Given: ImageMetadataIntelligence
        let testView = ImageMetadataIntelligenceComponent()
        
        // Then: Should generate accessibility identifiers
        let hasAccessibilityID = hasAccessibilityIdentifier(
            testView,
            expectedPattern: "*.main.element.*",
            componentName: "ImageMetadataIntelligence"
        )
        
        #expect(hasAccessibilityID, "ImageMetadataIntelligence should generate accessibility identifiers")
    }
}

