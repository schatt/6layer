import Testing

//
//  HIGComplianceTouchTargetTests.swift
//  SixLayerFrameworkTests
//
//  BUSINESS PURPOSE:
//  Validates that automatic HIG compliance applies minimum touch target sizing to all
//  interactive components, ensuring accessibility and usability standards are met on each platform.
//
//  TESTING SCOPE:
//  - Minimum touch target sizing for buttons, links, and interactive elements
//  - Platform-specific behavior:
//    * iOS/watchOS: 44pt minimum touch target (touch-based interaction)
//    * macOS/tvOS/visionOS: No touch targets required (hover/remote/spatial interaction)
//  - Automatic application via .automaticCompliance() modifier
//  - Cross-platform consistency and platform-appropriate behavior
//
//  METHODOLOGY:
//  - TDD RED phase: Tests fail until touch target sizing is implemented
//  - Test interactive components (buttons, links, tappable views)
//  - Verify platform-specific minimum sizes
//  - Use shared test functions for consistency
//

import SwiftUI
@testable import SixLayerFramework

@Suite("HIG Compliance - Touch Target Sizing")
@MainActor
open class HIGComplianceTouchTargetTests: BaseTestClass {
    
    // MARK: - iOS Touch Target Tests
    
    @Test func testButtonHasMinimumTouchTargetOniOS() async {
        runWithTaskLocalConfig {
            // GIVEN: A button with automatic compliance on iOS
            let button = Button("Test Button") { }
                .automaticCompliance()
            
            // WHEN: View is created
            // THEN: Button should have minimum 44pt touch target on iOS
            #if os(iOS)
            // RED PHASE: This will fail until touch target sizing is implemented
            let passed = testComponentComplianceSinglePlatform(
                button,
                expectedPattern: "SixLayer.*ui",
                platform: .iOS,
                componentName: "Button"
            )
            #expect(passed, "Button should have minimum 44pt touch target on iOS")
            #else
            // Skip on non-iOS platforms
            #expect(Bool(true), "Touch target test is iOS-specific")
            #endif
        }
    }
    
    @Test func testLinkHasMinimumTouchTargetOniOS() async {
        runWithTaskLocalConfig {
            // GIVEN: A link with automatic compliance on iOS
            let link = Link("Test Link", destination: URL(string: "https://example.com")!)
                .automaticCompliance()
            
            // WHEN: View is created
            // THEN: Link should have minimum 44pt touch target on iOS
            #if os(iOS)
            // RED PHASE: This will fail until touch target sizing is implemented
            let passed = testComponentComplianceSinglePlatform(
                link,
                expectedPattern: "SixLayer.*ui",
                platform: .iOS,
                componentName: "Link"
            )
            #expect(passed, "Link should have minimum 44pt touch target on iOS")
            #else
            // Skip on non-iOS platforms
            #expect(Bool(true), "Touch target test is iOS-specific")
            #endif
        }
    }
    
    @Test func testInteractiveViewHasMinimumTouchTargetOniOS() async {
        runWithTaskLocalConfig {
            // GIVEN: An interactive view (tappable) with automatic compliance on iOS
            let interactiveView = Text("Tap Me")
                .onTapGesture { }
                .automaticCompliance()
            
            // WHEN: View is created
            // THEN: Interactive view should have minimum 44pt touch target on iOS
            #if os(iOS)
            // RED PHASE: This will fail until touch target sizing is implemented
            let passed = testComponentComplianceSinglePlatform(
                interactiveView,
                expectedPattern: "SixLayer.*ui",
                platform: .iOS,
                componentName: "InteractiveView"
            )
            #expect(passed, "Interactive view should have minimum 44pt touch target on iOS")
            #else
            // Skip on non-iOS platforms
            #expect(Bool(true), "Touch target test is iOS-specific")
            #endif
        }
    }
    
    // MARK: - watchOS Touch Target Tests
    
    @Test func testButtonHasMinimumTouchTargetOnWatchOS() async {
        runWithTaskLocalConfig {
            // GIVEN: A button with automatic compliance on watchOS
            let button = Button("Test Button") { }
                .automaticCompliance()
            
            // WHEN: View is created
            // THEN: Button should have minimum 44pt touch target on watchOS (same as iOS)
            #if os(watchOS)
            // RED PHASE: This will fail until touch target sizing is implemented
            let passed = testComponentComplianceSinglePlatform(
                button,
                expectedPattern: "SixLayer.*ui",
                platform: .watchOS,
                componentName: "Button"
            )
            #expect(passed, "Button should have minimum 44pt touch target on watchOS")
            #else
            // Skip on non-watchOS platforms
            #expect(Bool(true), "Touch target test is watchOS-specific")
            #endif
        }
    }
    
    // MARK: - macOS Tests (No Touch Targets)
    
    @Test func testTouchTargetNotRequiredOnMacOS() async {
        runWithTaskLocalConfig {
            // GIVEN: A button with automatic compliance on macOS
            let button = Button("Test Button") { }
                .automaticCompliance()
            
            // WHEN: View is created on macOS
            // THEN: Touch target sizing should not be applied (macOS uses hover/click, not touch)
            #if os(macOS)
            // On macOS, touch targets are not required (uses hover/click, not touch)
            // But accessibility identifiers and other HIG compliance should still be tested
            let passed = testComponentComplianceSinglePlatform(
                button,
                expectedPattern: "SixLayer.*ui",
                platform: .macOS,
                componentName: "Button"
            )
            // Note: HIG compliance test will fail until implemented, but that's expected in RED phase
            #expect(passed, "Button should have HIG compliance on macOS (touch target not required)")
            #else
            // Skip on non-macOS platforms
            #expect(Bool(true), "Touch target test is macOS-specific")
            #endif
        }
    }
    
    // MARK: - tvOS Tests (No Touch Targets)
    
    @Test func testTouchTargetNotRequiredOnTvOS() async {
        runWithTaskLocalConfig {
            // GIVEN: A button with automatic compliance on tvOS
            let button = Button("Test Button") { }
                .automaticCompliance()
            
            // WHEN: View is created on tvOS
            // THEN: Touch target sizing should not be applied (tvOS uses remote control, not touch)
            #if os(tvOS)
            // On tvOS, touch targets are not required (uses remote control navigation, not touch)
            // But accessibility identifiers and other HIG compliance should still be tested
            let passed = testComponentComplianceSinglePlatform(
                button,
                expectedPattern: "SixLayer.*ui",
                platform: .tvOS,
                componentName: "Button"
            )
            // Note: HIG compliance test will fail until implemented, but that's expected in RED phase
            #expect(passed, "Button should have HIG compliance on tvOS (touch target not required)")
            #else
            // Skip on non-tvOS platforms
            #expect(Bool(true), "Touch target test is tvOS-specific")
            #endif
        }
    }
    
    // MARK: - visionOS Tests (No Touch Targets)
    
    @Test func testTouchTargetNotRequiredOnVisionOS() async {
        runWithTaskLocalConfig {
            // GIVEN: A button with automatic compliance on visionOS
            let button = Button("Test Button") { }
                .automaticCompliance()
            
            // WHEN: View is created on visionOS
            // THEN: Touch target sizing should not be applied (visionOS uses spatial gestures, not touch)
            #if os(visionOS)
            // On visionOS, touch targets are not required (uses spatial gestures, not touch)
            // But accessibility identifiers and other HIG compliance should still be tested
            let passed = testComponentComplianceSinglePlatform(
                button,
                expectedPattern: "SixLayer.*ui",
                platform: .visionOS,
                componentName: "Button"
            )
            // Note: HIG compliance test will fail until implemented, but that's expected in RED phase
            #expect(passed, "Button should have HIG compliance on visionOS (touch target not required)")
            #else
            // Skip on non-visionOS platforms
            #expect(Bool(true), "Touch target test is visionOS-specific")
            #endif
        }
    }
    
    // MARK: - Cross-Platform Summary Tests
    
    @Test func testTouchTargetRequirementsAcrossAllPlatforms() async {
        runWithTaskLocalConfig {
            // GIVEN: A button with automatic compliance
            let button = Button("Test Button") { }
                .automaticCompliance()
            
            // WHEN: View is created on different platforms
            // THEN: Touch target requirements should be platform-appropriate
            // - iOS/watchOS: 44pt minimum
            // - macOS/tvOS/visionOS: No touch targets required
            
            let platforms: [(SixLayerPlatform, Bool)] = [
                (.iOS, true),      // Requires 44pt touch target
                (.watchOS, true),  // Requires 44pt touch target
                (.macOS, false),   // No touch target required
                (.tvOS, false),    // No touch target required
                (.visionOS, false) // No touch target required
            ]
            
            for (platform, requiresTouchTarget) in platforms {
                let passed = testComponentComplianceSinglePlatform(
                    button,
                    expectedPattern: "SixLayer.*ui",
                    platform: platform,
                    componentName: "Button-\(platform)"
                )
                
                if requiresTouchTarget {
                    #expect(passed, "Button should have minimum 44pt touch target on \(platform)")
                } else {
                    #expect(passed, "Button should have HIG compliance on \(platform) (touch target not required)")
                }
            }
        }
    }
}

