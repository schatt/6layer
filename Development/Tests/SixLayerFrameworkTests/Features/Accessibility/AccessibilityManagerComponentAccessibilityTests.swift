import Testing


//
//  AccessibilityManagerComponentAccessibilityTests.swift
//  SixLayerFrameworkTests
//
//  Comprehensive accessibility tests for ALL AccessibilityManager components
//

import SwiftUI
@testable import SixLayerFramework

/// NOTE: Not marked @MainActor on class to allow parallel execution
@Suite("Accessibility Manager Component Accessibility")
open class AccessibilityManagerComponentAccessibilityTests: BaseTestClass {// MARK: - AccessibilityManager Tests
    
    @Test @MainActor func testAccessibilityManagerGeneratesAccessibilityIdentifiers() async {
        initializeTestConfig()
        // Given: AccessibilityManager
        let manager = AccessibilityManager()
        
        // When: Creating a view with AccessibilityManager
        let view = VStack {
            Text("Accessibility Manager Content")
        }
        .environmentObject(manager)
        .automaticCompliance()
        
        // Then: Should generate accessibility identifiers
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "SixLayer.*ui",
            platform: SixLayerPlatform.iOS,
            componentName: "AccessibilityManager"
        )
 #expect(hasAccessibilityID, "AccessibilityManager should generate accessibility identifiers ")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }
}



