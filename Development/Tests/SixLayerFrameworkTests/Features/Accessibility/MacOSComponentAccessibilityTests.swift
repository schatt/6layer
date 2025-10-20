import Testing


//
//  MacOSComponentAccessibilityTests.swift
//  SixLayerFrameworkTests
//
//  Comprehensive accessibility tests for ALL macOS Components
//

import SwiftUI
@testable import SixLayerFramework

@MainActor
open class MacOSComponentAccessibilityTests: BaseTestClass {
    
    // MARK: - macOS Component Tests
    
    @Test func testMacOSComponentsGeneratesAccessibilityIdentifiers() async {
        // Given: MacOSComponents
        let testView = MacOSComponents()
        
        // Then: Should generate accessibility identifiers
        let hasAccessibilityID = hasAccessibilityIdentifier(
            testView,
            expectedPattern: "*.main.element.*",
            componentName: "MacOSComponents"
        )
        
        #expect(hasAccessibilityID, "MacOSComponents should generate accessibility identifiers")
    }
}

