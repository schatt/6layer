import Testing


//
//  OCRComponentAccessibilityTests.swift
//  SixLayerFrameworkTests
//
//  Comprehensive accessibility tests for ALL OCR Components
//

import SwiftUI
@testable import SixLayerFramework

@MainActor
open class OCRComponentAccessibilityTests: BaseTestClass {
    
    // MARK: - OCR Component Tests
    
    @Test func testPlatformOCRComponentsGeneratesAccessibilityIdentifiers() async {
        // Given: PlatformOCRComponents
        let testView = PlatformOCRComponents()
        
        // Then: Should generate accessibility identifiers
        let hasAccessibilityID = hasAccessibilityIdentifier(
            testView,
            expectedPattern: "*.main.element.*",
            componentName: "PlatformOCRComponents"
        )
        
        #expect(hasAccessibilityID, "PlatformOCRComponents should generate accessibility identifiers")
    }
    
    @Test func testPlatformPhotoComponentsGeneratesAccessibilityIdentifiers() async {
        // Given: PlatformPhotoComponents
        let testView = PlatformPhotoComponents()
        
        // Then: Should generate accessibility identifiers
        let hasAccessibilityID = hasAccessibilityIdentifier(
            testView,
            expectedPattern: "*.main.element.*",
            componentName: "PlatformPhotoComponents"
        )
        
        #expect(hasAccessibilityID, "PlatformPhotoComponents should generate accessibility identifiers")
    }
}

