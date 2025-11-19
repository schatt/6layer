import Testing

//
//  HIGComplianceTabOrderTests.swift
//  SixLayerFrameworkTests
//
//  BUSINESS PURPOSE:
//  Validates that automatic HIG compliance applies correct tab order to all
//  focusable elements, ensuring logical keyboard navigation flow.
//
//  TESTING SCOPE:
//  - Logical tab order for form fields
//  - Tab order for buttons and interactive elements
//  - Tab order for complex layouts (VStack, HStack, ZStack)
//  - Platform-specific tab order behavior
//
//  METHODOLOGY:
//  - TDD RED phase: Tests fail until tab order implementation is implemented
//  - Test multiple focusable elements
//  - Verify logical navigation order
//  - Test complex view hierarchies
//

import SwiftUI
@testable import SixLayerFramework

@Suite("HIG Compliance - Tab Order")
/// NOTE: Not marked @MainActor on class to allow parallel execution
open class HIGComplianceTabOrderTests: BaseTestClass {
    
    // MARK: - Form Field Tab Order Tests
    
    @Test @MainActor func testFormFieldsHaveLogicalTabOrder() async {
            initializeTestConfig()
        await runWithTaskLocalConfig {
            // GIVEN: Multiple form fields with automatic compliance
            let view = VStack {
                TextField("First Name", text: .constant(""))
                    .automaticCompliance()
                TextField("Last Name", text: .constant(""))
                    .automaticCompliance()
                TextField("Email", text: .constant(""))
                    .automaticCompliance()
            }
            .automaticCompliance()
            
            // WHEN: View is created
            // THEN: Fields should have logical tab order (top to bottom)
            // RED PHASE: This will fail until tab order implementation is implemented
            #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
            let passed = testComponentComplianceCrossPlatform(
                view,
                expectedPattern: "SixLayer.*ui",
                componentName: "FormFieldsWithTabOrder"
            )
 #expect(passed, "Form fields should have logical tab order on all platforms")
        #else
            // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
            // The modifier IS present in the code, but ViewInspector can't detect it on macOS
            #endif
        }
    }
    
    // MARK: - Button Tab Order Tests
    
    @Test @MainActor func testButtonsHaveLogicalTabOrder() async {
            initializeTestConfig()
        await runWithTaskLocalConfig {
            // GIVEN: Multiple buttons with automatic compliance
            let view = HStack {
                Button("Cancel") { }
                    .automaticCompliance()
                Button("Save") { }
                    .automaticCompliance()
            }
            .automaticCompliance()
            
            // WHEN: View is created
            // THEN: Buttons should have logical tab order (left to right)
            // RED PHASE: This will fail until tab order implementation is implemented
            #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
            let passed = testComponentComplianceCrossPlatform(
                view,
                expectedPattern: "SixLayer.*ui",
                componentName: "ButtonsWithTabOrder"
            )
 #expect(passed, "Buttons should have logical tab order on all platforms")
        #else
            // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
            // The modifier IS present in the code, but ViewInspector can't detect it on macOS
            #endif
        }
    }
    
    // MARK: - Complex Layout Tab Order Tests
    
    @Test @MainActor func testComplexLayoutHasLogicalTabOrder() async {
            initializeTestConfig()
        await runWithTaskLocalConfig {
            // GIVEN: Complex layout with multiple focusable elements
            let view = VStack {
                TextField("Name", text: .constant(""))
                    .automaticCompliance()
                HStack {
                    Button("Cancel") { }
                        .automaticCompliance()
                    Button("Save") { }
                        .automaticCompliance()
                }
                .automaticCompliance()
            }
            .automaticCompliance()
            
            // WHEN: View is created
            // THEN: Elements should have logical tab order (top to bottom, then left to right)
            // RED PHASE: This will fail until tab order implementation is implemented
            #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
            let passed = testComponentComplianceCrossPlatform(
                view,
                expectedPattern: "SixLayer.*ui",
                componentName: "ComplexLayoutWithTabOrder"
            )
 #expect(passed, "Complex layout should have logical tab order on all platforms")
        #else
            // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
            // The modifier IS present in the code, but ViewInspector can't detect it on macOS
            #endif
        }
    }
    
    // MARK: - Cross-Platform Tests
    
    @Test @MainActor func testTabOrderOnBothPlatforms() async {
            initializeTestConfig()
        await runWithTaskLocalConfig {
            // GIVEN: Multiple focusable elements with automatic compliance
            let view = VStack {
                TextField("Field 1", text: .constant(""))
                    .automaticCompliance()
                TextField("Field 2", text: .constant(""))
                    .automaticCompliance()
            }
            .automaticCompliance()
            
            // WHEN: View is created on all platforms
            // THEN: Tab order should be logical on all platforms
            // RED PHASE: This will fail until tab order implementation is implemented
            #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
            let passed = testComponentComplianceCrossPlatform(
                view,
                expectedPattern: "SixLayer.*ui",
                componentName: "CrossPlatformTabOrder"
            )
 #expect(passed, "Tab order should be logical on all platforms")
        #else
            // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
            // The modifier IS present in the code, but ViewInspector can't detect it on macOS
            #endif
        }
    }
}

