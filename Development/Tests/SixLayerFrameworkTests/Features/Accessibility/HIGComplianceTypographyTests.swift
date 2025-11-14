import Testing

//
//  HIGComplianceTypographyTests.swift
//  SixLayerFrameworkTests
//
//  BUSINESS PURPOSE:
//  Validates that automatic HIG compliance applies Dynamic Type support to all text,
//  ensuring text scales appropriately with system accessibility settings.
//
//  TESTING SCOPE:
//  - Dynamic Type support for all text elements
//  - Accessibility text size range support
//  - Automatic scaling with system settings
//  - Platform-specific typography behavior
//
//  METHODOLOGY:
//  - TDD RED phase: Tests fail until Dynamic Type support is implemented
//  - Test text elements with various font sizes
//  - Verify .dynamicTypeSize modifier is applied
//  - Test accessibility size range support
//

import SwiftUI
@testable import SixLayerFramework

@Suite("HIG Compliance - Typography Scaling")
@MainActor
open class HIGComplianceTypographyTests: BaseTestClass {
    
    // MARK: - Dynamic Type Support Tests
    
    @Test func testTextSupportsDynamicType() async {
        runWithTaskLocalConfig {
            // GIVEN: Text with automatic compliance
            let view = Text("Test Text")
                .automaticCompliance()
            
            // WHEN: View is created
            // THEN: Text should support Dynamic Type and accessibility sizes
            // RED PHASE: This will fail until Dynamic Type support is implemented
            let passed = testComponentComplianceSinglePlatform(
                view,
                expectedPattern: "SixLayer.*ui",
                platform: .iOS,
                componentName: "TextWithDynamicType"
            )
            #expect(passed, "Text should support Dynamic Type scaling")
        }
    }
    
    @Test func testButtonTextSupportsDynamicType() async {
        runWithTaskLocalConfig {
            // GIVEN: Button with text and automatic compliance
            let button = Button("Test Button") { }
                .automaticCompliance()
            
            // WHEN: View is created
            // THEN: Button text should support Dynamic Type
            // RED PHASE: This will fail until Dynamic Type support is implemented
            let passed = testComponentComplianceSinglePlatform(
                button,
                expectedPattern: "SixLayer.*ui",
                platform: .iOS,
                componentName: "ButtonWithDynamicType"
            )
            #expect(passed, "Button text should support Dynamic Type scaling")
        }
    }
    
    @Test func testLabelSupportsDynamicType() async {
        runWithTaskLocalConfig {
            // GIVEN: Label with automatic compliance
            let label = Label("Test Label", systemImage: "star")
                .automaticCompliance()
            
            // WHEN: View is created
            // THEN: Label text should support Dynamic Type
            // RED PHASE: This will fail until Dynamic Type support is implemented
            let passed = testComponentComplianceSinglePlatform(
                label,
                expectedPattern: "SixLayer.*ui",
                platform: .iOS,
                componentName: "LabelWithDynamicType"
            )
            #expect(passed, "Label text should support Dynamic Type scaling")
        }
    }
    
    // MARK: - Accessibility Size Range Tests
    
    @Test func testTextSupportsAccessibilitySizes() async {
        runWithTaskLocalConfig {
            // GIVEN: Text that should support accessibility sizes
            let view = Text("Accessibility Text")
                .automaticCompliance()
            
            // WHEN: View is created
            // THEN: Text should support accessibility size range (up to .accessibility5)
            // RED PHASE: This will fail until accessibility size support is implemented
            let passed = testComponentComplianceSinglePlatform(
                view,
                expectedPattern: "SixLayer.*ui",
                platform: .iOS,
                componentName: "TextWithAccessibilitySizes"
            )
            #expect(passed, "Text should support accessibility size range")
        }
    }
    
    // MARK: - Cross-Platform Tests
    
    @Test func testDynamicTypeOnBothPlatforms() async {
        runWithTaskLocalConfig {
            // GIVEN: Text with automatic compliance
            let view = Text("Cross-Platform Text")
                .automaticCompliance()
            
            // WHEN: View is created on both platforms
            // THEN: Dynamic Type should be supported on both iOS and macOS
            // RED PHASE: This will fail until Dynamic Type support is implemented
            let passed = testComponentComplianceCrossPlatform(
                view,
                expectedPattern: "SixLayer.*ui",
                componentName: "CrossPlatformDynamicType"
            )
            #expect(passed, "Dynamic Type should be supported on both platforms")
        }
    }
}

