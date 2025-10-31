import Testing


//
//  AccessibilityManagerComponentAccessibilityTests.swift
//  SixLayerFrameworkTests
//
//  Comprehensive accessibility tests for ALL AccessibilityManager components
//

import SwiftUI
@testable import SixLayerFramework

@MainActor
@Suite("Accessibility Manager Component Accessibility")
open class AccessibilityManagerComponentAccessibilityTests: BaseTestClass {// MARK: - AccessibilityManager Tests
    
    @Test func testAccessibilityManagerGeneratesAccessibilityIdentifiers() async {
        // Given: AccessibilityManager
        let manager = AccessibilityManager()
        
        // When: Creating a view with AccessibilityManager
        let view = VStack {
            Text("Accessibility Manager Content")
        }
        .environmentObject(manager)
        .automaticAccessibilityIdentifiers()
        
        // Then: Should generate accessibility identifiers
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "SixLayer.*ui",
            platform: SixLayerPlatform.iOS,
            componentName: "AccessibilityManager"
        )
        
        #expect(hasAccessibilityID, "AccessibilityManager should generate accessibility identifiers")
    }
}



