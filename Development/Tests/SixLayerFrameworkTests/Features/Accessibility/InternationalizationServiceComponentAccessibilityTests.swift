import Testing


//
//  InternationalizationServiceComponentAccessibilityTests.swift
//  SixLayerFrameworkTests
//
//  Comprehensive accessibility tests for ALL InternationalizationService components
//

import SwiftUI
@testable import SixLayerFramework

@MainActor
class InternationalizationServiceComponentAccessibilityTests: BaseTestClass {
    
    // MARK: - InternationalizationService Tests
    
    @Test func testInternationalizationServiceGeneratesAccessibilityIdentifiers() async {
        // Given: InternationalizationService
        let i18nService = InternationalizationService()
        
        // When: Creating a view with InternationalizationService
        let view = VStack {
            Text("Internationalization Service Content")
        }
        .environmentObject(i18nService)
        
        // Then: Should generate accessibility identifiers
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view,
            expectedPattern: "*.main.element.*",
            componentName: "InternationalizationService"
        )
        
        #expect(hasAccessibilityID, "InternationalizationService should generate accessibility identifiers")
    }
}



