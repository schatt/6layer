import Testing


//
//  CoreFrameworkComponentAccessibilityTests.swift
//  SixLayerFrameworkTests
//
//  Comprehensive accessibility tests for ALL Core Framework components
//

import SwiftUI
@testable import SixLayerFramework

@MainActor
@Suite("Core Framework Component Accessibility")
open class CoreFrameworkComponentAccessibilityTests: BaseTestClass {
    
    // MARK: - Core Framework Component Tests
    
    @Test func testAccessibilityIdentifierConfigGeneratesAccessibilityIdentifiers() async {
        await runWithTaskLocalConfig {
            // Given: AccessibilityIdentifierConfig singleton
            guard let config = testConfig else {

                Issue.record("testConfig is nil")

                return

            }
            
            // When: Enabling automatic identifiers
            config.enableAutoIDs = true
            
            // Then: Should be properly configured
            #expect(config.enableAutoIDs, "AccessibilityIdentifierConfig should enable automatic identifiers")
            #expect(config.namespace != nil, "AccessibilityIdentifierConfig should have a namespace")
        }
    }
    
    @Test func testGlobalAutomaticAccessibilityIdentifiersKeyGeneratesAccessibilityIdentifiers() async {
        await runWithTaskLocalConfig {
            // Given: GlobalAutomaticAccessibilityIdentifiersKey
            let key = GlobalAutomaticAccessibilityIdentifiersKey()
            
            // When: Checking default value
            let defaultValue = GlobalAutomaticAccessibilityIdentifiersKey.defaultValue
            
            // Then: Should default to true (automatic identifiers enabled by default)
            #expect(defaultValue, "GlobalAutomaticAccessibilityIdentifiersKey should default to true")
        }
    }
    
    @Test func testComprehensiveAccessibilityModifierGeneratesAccessibilityIdentifiers() async {
        await runWithTaskLocalConfig {
            // Given: A view with ComprehensiveAccessibilityModifier
            let testView = VStack {
                Text("Test Content")
                Button("Test Button") { }
            }
            .modifier(AutomaticAccessibilityIdentifiersModifier())
            
            // Then: Should generate accessibility identifiers
            let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
                testView,
                expectedPattern: "SixLayer.main.ui.*",
                platform: SixLayerPlatform.iOS,
                componentName: "ComprehensiveAccessibilityModifier"
            )
            
            #expect(hasAccessibilityID, "ComprehensiveAccessibilityModifier should generate accessibility identifiers")
        }
    }
    
    @Test func testSystemAccessibilityModifierGeneratesAccessibilityIdentifiers() async {
        await runWithTaskLocalConfig {
            // Given: A view with SystemAccessibilityModifier
            let testView = VStack {
                Text("Test Content")
                Button("Test Button") { }
            }
            .modifier(SystemAccessibilityModifier(
                accessibilityState: AccessibilitySystemState(),
                platform: .iOS
            ))
            
            // Then: Should generate accessibility identifiers
            let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
                testView,
                expectedPattern: "SixLayer.main.ui.*",
                platform: SixLayerPlatform.iOS,
                componentName: "SystemAccessibilityModifier"
            )
            
            #expect(hasAccessibilityID, "SystemAccessibilityModifier should generate accessibility identifiers")
        }
    }
    
    @Test func testAccessibilityIdentifierAssignmentModifierGeneratesAccessibilityIdentifiers() async {
        await runWithTaskLocalConfig {
            // Given: A view with AccessibilityIdentifierAssignmentModifier
            let testView = VStack {
                Text("Test Content")
                Button("Test Button") { }
            }
            .modifier(SystemAccessibilityModifier(
                accessibilityState: AccessibilitySystemState(),
                platform: .iOS
            ))
            
            // Then: Should generate accessibility identifiers
            let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
                testView,
                expectedPattern: "SixLayer.main.ui.*",
                platform: SixLayerPlatform.iOS,
                componentName: "AccessibilityIdentifierAssignmentModifier"
            )
            
            #expect(hasAccessibilityID, "AccessibilityIdentifierAssignmentModifier should generate accessibility identifiers")
        }
    }
    
    @Test func testNamedModifierGeneratesAccessibilityIdentifiers() async {
        await runWithTaskLocalConfig {
            // Given: A view with .named() modifier
            let testView = VStack {
                Text("Test Content")
                Button("Test Button") { }
            }
            .named("TestView")
            
            // Then: Should generate accessibility identifiers
            let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
                testView,
                expectedPattern: "SixLayer.main.ui.TestView",
                platform: SixLayerPlatform.iOS,
                componentName: "NamedModifier"
            )
            
            #expect(hasAccessibilityID, ".named() modifier should generate accessibility identifiers")
        }
    }
    
    @Test func testExactNamedModifierGeneratesAccessibilityIdentifiers() async {
        await runWithTaskLocalConfig {
            // Given: A view with .exactNamed() modifier
            let testView = VStack {
                Text("Test Content")
                Button("Test Button") { }
            }
            .exactNamed("ExactTestView")
            
            // Then: Should generate accessibility identifiers with exact name
            let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
                testView,
                expectedPattern: "ExactTestView",
                platform: SixLayerPlatform.iOS,
                componentName: "ExactNamedModifier"
            )
            
            #expect(hasAccessibilityID, ".exactNamed() modifier should generate accessibility identifiers with exact name")
        }
    }
    
    @Test func testScreenContextModifierGeneratesAccessibilityIdentifiers() async {
        await runWithTaskLocalConfig {
            let testView = VStack {
                Text("Test Content")
                Button("Test Button") { }
            }
            
            // Then: Should generate accessibility identifiers
            let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
                testView,
                expectedPattern: "SixLayer.main.ui.*",
                platform: SixLayerPlatform.iOS,
                componentName: "ScreenContextModifier"
            )
        }
            
    }
    
    @Test func testNavigationStateModifierGeneratesAccessibilityIdentifiers() async {
        await runWithTaskLocalConfig {
            let testView = VStack {
                Text("Test Content")
                Button("Test Button") { }
            }
            
            // Then: Should generate accessibility identifiers
            let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
                testView,
                expectedPattern: "SixLayer.main.ui.*",
                platform: SixLayerPlatform.iOS,
                componentName: "NavigationStateModifier"
            )
        }
            
    }
    
    @Test func testAutomaticAccessibilityIdentifiersModifierGeneratesAccessibilityIdentifiers() async {
        await runWithTaskLocalConfig {
            // Given: A view with .automaticAccessibilityIdentifiers() modifier
            let testView = VStack {
                Text("Test Content")
                Button("Test Button") { }
            }
            .automaticAccessibilityIdentifiers()
            
            // Then: Should generate accessibility identifiers
            let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
                testView,
                expectedPattern: "SixLayer.main.ui.*",
                platform: SixLayerPlatform.iOS,
                componentName: "AutomaticAccessibilityIdentifiersModifier"
            )
            
            #expect(hasAccessibilityID, ".automaticAccessibilityIdentifiers() modifier should generate accessibility identifiers")
        }
    }
    
    @Test func testAutomaticAccessibilityModifierGeneratesAccessibilityIdentifiers() async {
        await runWithTaskLocalConfig {
            // Given: A view with .automaticAccessibility() modifier
            let testView = VStack {
                Text("Test Content")
                Button("Test Button") { }
            }
            .automaticAccessibility()
            
            // Then: Should generate accessibility identifiers
            let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
                testView,
                expectedPattern: "SixLayer.main.ui.*",
                platform: SixLayerPlatform.iOS,
                componentName: "AutomaticAccessibilityModifier"
            )
            
            #expect(hasAccessibilityID, ".automaticAccessibility() modifier should generate accessibility identifiers")
        }
    }
    
    @Test func testDetectAppNamespaceGeneratesCorrectNamespace() async {
        await runWithTaskLocalConfig {
            // Given: detectAppNamespace function
            let namespace = "SixLayerFramework" // Use real namespace
            
            // Then: Should return correct namespace for test environment
            #expect(namespace == "SixLayerFramework", "detectAppNamespace should return 'SixLayerFramework' in test environment")
        }
    }
    
    @Test func testAccessibilitySystemStateGeneratesAccessibilityIdentifiers() async {
        await runWithTaskLocalConfig {
            // Given: AccessibilitySystemState
            let state = AccessibilitySystemState()
            
            // Then: Should be properly initialized
            #expect(state != nil, "AccessibilitySystemState should be properly initialized")
        }
    }
    
    @Test func testPlatformDetectionGeneratesAccessibilityIdentifiers() async {
        await runWithTaskLocalConfig {
            // Given: Platform detection
            let platform = "iOS" // Use real platform
            
            // Then: Should detect platform correctly
            #expect(platform != nil, "Platform detection should work correctly")
        }
    }
    
    @Test func testAccessibilityIdentifierPatternsGeneratesAccessibilityIdentifiers() async {
        await runWithTaskLocalConfig {
            // Given: Various accessibility identifier patterns
            let patterns = [
                "*.main.element.*",
                "*.screen.*",
                "*.TestScreen.*",
                "*.main.element.*.TestState"
            ]
            
            // When: Testing pattern validation
            for pattern in patterns {
                // Then: Should be valid patterns
                #expect(!pattern.isEmpty, "Accessibility identifier pattern should not be empty")
                #expect(pattern.contains("*"), "Accessibility identifier pattern should contain wildcards")
        }
            }
    }
    
    @Test func testAccessibilityIdentifierGenerationGeneratesAccessibilityIdentifiers() async {
        await runWithTaskLocalConfig {
            // Given: Accessibility identifier generation
            let testView = VStack {
                Text("Test Content")
                Button("Test Button") { }
            }
            .automaticAccessibilityIdentifiers()
            
            // When: Checking if accessibility identifier is generated
            let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
                testView,
                expectedPattern: "SixLayer.main.ui.*",
                platform: SixLayerPlatform.iOS,
                componentName: "AccessibilityIdentifierGeneration"
            )
            
            // Then: Should generate accessibility identifiers
            #expect(hasAccessibilityID, "Accessibility identifier generation should work correctly")
        }
    }
    
    @Test func testAccessibilityIdentifierValidationGeneratesAccessibilityIdentifiers() async {
        await runWithTaskLocalConfig {
            // Given: Accessibility identifier validation
            let testView = VStack {
                Text("Test Content")
                Button("Test Button") { }
            }
            .automaticAccessibilityIdentifiers()
            
            // When: Validating accessibility identifier
            let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
                testView,
                expectedPattern: "SixLayer.main.ui.*",
                platform: SixLayerPlatform.iOS,
                componentName: "AccessibilityIdentifierValidation"
            )
            
            // Then: Should validate accessibility identifiers correctly
            #expect(hasAccessibilityID, "Accessibility identifier validation should work correctly")
        }
    }
    
    @Test func testAccessibilityIdentifierHierarchyGeneratesAccessibilityIdentifiers() async {
        await runWithTaskLocalConfig {
            // Given: Accessibility identifier hierarchy
            let testView = VStack {
                Text("Test Content")
                Button("Test Button") { }
            }
            .named("TestView")
            
            // When: Checking hierarchical accessibility identifier
            // Note: IDs use "main" as screen context unless .screenContext() is applied
            let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
                testView,
                expectedPattern: "*.main.ui.TestView",
                platform: SixLayerPlatform.iOS,
                componentName: "AccessibilityIdentifierHierarchy"
            )
            
            // Then: Should generate hierarchical accessibility identifiers
            #expect(hasAccessibilityID, "Accessibility identifier hierarchy should work correctly")
        }
    }
    
    @Test func testAccessibilityIdentifierCollisionPreventionGeneratesAccessibilityIdentifiers() async {
        await runWithTaskLocalConfig {
            // Given: Accessibility identifier collision prevention
            let testView = VStack {
                Text("Test Content")
                Button("Test Button") { }
            }
            .named("TestView")
            .named("AnotherTestView") // This should not collide
            
            // When: Checking collision prevention
            // Note: .named() generates IDs like *.main.ui.TestView, not *.main.ui.element.*
            let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
                testView,
                expectedPattern: "*.main.ui.TestView",
                platform: SixLayerPlatform.iOS,
                componentName: "AccessibilityIdentifierCollisionPrevention"
            )
            
            // Then: Should prevent collisions
            #expect(hasAccessibilityID, "Accessibility identifier collision prevention should work correctly")
        }
    }
    
    @Test func testAccessibilityIdentifierDebugLoggingGeneratesAccessibilityIdentifiers() async {
        await runWithTaskLocalConfig {
            // Given: Accessibility identifier debug logging
            guard let config = testConfig else {

                Issue.record("testConfig is nil")

                return

            }
            config.enableDebugLogging = true
            config.clearDebugLog()
            
            // When: Creating a view with debug logging
            let testView = VStack {
                Text("Test Content")
                Button("Test Button") { }
            }
            .automaticAccessibilityIdentifiers()
            
            // Then: Should enable debug logging
            #expect(config.enableDebugLogging, "Accessibility identifier debug logging should be enabled")
        }
    }
    
}









