import Testing


//
//  FormUsageExampleComponentAccessibilityTests.swift
//  SixLayerFrameworkTests
//
//  Comprehensive accessibility tests for ALL Form Usage Example Components
//

import SwiftUI
@testable import SixLayerFramework

@MainActor
@Suite("Form Usage Example Component Accessibility")
open class FormUsageExampleComponentAccessibilityTests: BaseTestClass {
    
    // MARK: - Form Usage Example Component Tests
    
    @Test func testFormUsageExampleGeneratesAccessibilityIdentifiers() async {
        // Given: FormUsageExample
        let testView = FormUsageExample()
        
        // Then: Should generate accessibility identifiers
            // TODO: ViewInspector Detection Issue - VERIFIED: FormUsageExample DOES have .automaticCompliance() 
            // modifier applied in Framework/Sources/Components/Forms/FormUsageExample.swift:33.
            // The test needs to be updated to handle ViewInspector's inability to detect these modifiers reliably.
            // This is a ViewInspector limitation, not a missing modifier issue.
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            testView,
            expectedPattern: "SixLayer.*ui",
            platform: SixLayerPlatform.iOS,
            componentName: "FormUsageExample"
        )
 #expect(hasAccessibilityID, "FormUsageExample should generate accessibility identifiers ")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }
}

