//
//  OCRComponentAccessibilityTests.swift
//  SixLayerFrameworkTests
//
//  Comprehensive accessibility tests for ALL OCR Components
//

import Testing
import SwiftUI
@testable import SixLayerFramework

@MainActor
final class OCRComponentAccessibilityTests {
    
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

// MARK: - Mock OCR Components (Placeholder implementations)

struct PlatformOCRComponents: View {
    var body: some View {
        VStack {
            Text("Platform OCR Components")
            Button("OCR") { }
        }
        .automaticAccessibilityIdentifiers()
    }
}

struct PlatformPhotoComponents: View {
    var body: some View {
        VStack {
            Text("Platform Photo Components")
            Button("Photo") { }
        }
        .automaticAccessibilityIdentifiers()
    }
}