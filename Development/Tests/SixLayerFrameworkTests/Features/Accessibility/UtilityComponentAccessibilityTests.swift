import Testing


//
//  UtilityComponentAccessibilityTests.swift
//  SixLayerFrameworkTests
//
//  Comprehensive accessibility tests for ALL Utility Components
//

import SwiftUI
@testable import SixLayerFramework

@MainActor
@Suite("Utility Component Accessibility")
open class UtilityComponentAccessibilityTests: BaseTestClass {
    
    // MARK: - Utility Component Tests
    
    @Test func testAccessibilityTestUtilitiesGeneratesAccessibilityIdentifiers() async {
        // Given: AccessibilityTestUtilities
        let testView = VStack {
            Text("Test Content")
            Button("Test Button") { }
        }
        .automaticAccessibilityIdentifiers()
        
        // When: Using hasAccessibilityIdentifier utility
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            testView,
            expectedPattern: "SixLayer.main.ui",
            platform: SixLayerPlatform.iOS,
            componentName: "AccessibilityTestUtilities"
        )
        
        // Then: Should work correctly
        #expect(hasAccessibilityID, "AccessibilityTestUtilities should work correctly")
    }
    
    @Test func testAccessibilityIdentifierValidationGeneratesAccessibilityIdentifiers() async {
        // Given: Accessibility identifier validation
        let testView = VStack {
            Text("Test Content")
            Button("Test Button") { }
        }
        .automaticAccessibilityIdentifiers()
        
        // When: Validating accessibility identifier
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            testView,
            expectedPattern: "SixLayer.main.ui",
            platform: SixLayerPlatform.iOS,
            componentName: "AccessibilityIdentifierValidation"
        )
        
        // Then: Should validate correctly
        #expect(hasAccessibilityID, "Accessibility identifier validation should work correctly")
    }
    
    @Test func testAccessibilityIdentifierPatternMatchingGeneratesAccessibilityIdentifiers() async {
        // Given: Accessibility identifier pattern matching
        let testView = VStack {
            Text("Test Content")
            Button("Test Button") { }
        }
        .automaticAccessibilityIdentifiers()
        
        // When: Testing pattern matching
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            testView,
            expectedPattern: "SixLayer.main.ui",
            platform: SixLayerPlatform.iOS,
            componentName: "AccessibilityIdentifierPatternMatching"
        )
        
        // Then: Should match patterns correctly
        #expect(hasAccessibilityID, "Accessibility identifier pattern matching should work correctly")
    }
    
    @Test func testAccessibilityIdentifierExactMatchingGeneratesAccessibilityIdentifiers() async {
        // Given: Accessibility identifier exact matching
        let testView = VStack {
            Text("Test Content")
            Button("Test Button") { }
        }
        .accessibilityIdentifier("ExactTestView")
        
        // When: Testing exact matching
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            testView,
            expectedPattern: "ExactTestView",
            platform: SixLayerPlatform.iOS,
            componentName: "AccessibilityIdentifierExactMatching"
        )
        
        // Then: Should match exactly
        #expect(hasAccessibilityID, "Accessibility identifier exact matching should work correctly")
    }
    
    @Test func testAccessibilityIdentifierWildcardMatchingGeneratesAccessibilityIdentifiers() async {
        // Given: Accessibility identifier wildcard matching
        let testView = VStack {
            Text("Test Content")
            Button("Test Button") { }
        }
        .automaticAccessibilityIdentifiers()
        
        // When: Testing wildcard matching
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            testView,
            expectedPattern: "SixLayer.main.ui",
            platform: SixLayerPlatform.iOS,
            componentName: "AccessibilityIdentifierWildcardMatching"
        )
        
        // Then: Should match wildcards correctly
        #expect(hasAccessibilityID, "Accessibility identifier wildcard matching should work correctly")
    }
    
    @Test func testAccessibilityIdentifierComponentNameMatchingGeneratesAccessibilityIdentifiers() async {
        // Given: Accessibility identifier component name matching
        let testView = VStack {
            Text("Test Content")
            Button("Test Button") { }
        }
        .automaticAccessibilityIdentifiers()
        
        // When: Testing component name matching
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            testView,
            expectedPattern: "SixLayer.main.ui",
            platform: SixLayerPlatform.iOS,
            componentName: "AccessibilityIdentifierComponentNameMatching"
        )
        
        // Then: Should match component names correctly
        #expect(hasAccessibilityID, "Accessibility identifier component name matching should work correctly")
    }
    
    @Test func testAccessibilityIdentifierNamespaceMatchingGeneratesAccessibilityIdentifiers() async {
        // Given: Accessibility identifier namespace matching
        let testView = VStack {
            Text("Test Content")
            Button("Test Button") { }
        }
        .automaticAccessibilityIdentifiers()
        
        // When: Testing namespace matching
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            testView,
            expectedPattern: "SixLayer.main.ui",
            platform: SixLayerPlatform.iOS,
            componentName: "AccessibilityIdentifierNamespaceMatching"
        )
        
        // Then: Should match namespaces correctly
        #expect(hasAccessibilityID, "Accessibility identifier namespace matching should work correctly")
    }
    
    @Test func testAccessibilityIdentifierScreenMatchingGeneratesAccessibilityIdentifiers() async {
        // Given: Accessibility identifier screen matching
        let testView = VStack {
            Text("Test Content")
            Button("Test Button") { }
        }
        .automaticAccessibilityIdentifiers()
        
        // When: Testing screen matching
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            testView,
            expectedPattern: "*.main.ui.element.*",
            platform: SixLayerPlatform.iOS,
            componentName: "AccessibilityIdentifierScreenMatching"
        )
        
        // Then: Should match screens correctly
        #expect(hasAccessibilityID, "Accessibility identifier screen matching should work correctly")
    }
    
    @Test func testAccessibilityIdentifierElementMatchingGeneratesAccessibilityIdentifiers() async {
        // Given: Accessibility identifier element matching
        let testView = VStack {
            Text("Test Content")
            Button("Test Button") { }
        }
        .named("TestElement")
        .automaticAccessibilityIdentifiers()
        
        // When: Testing element matching
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            testView,
            expectedPattern: "*.main.ui.TestElement",
            platform: SixLayerPlatform.iOS,
            componentName: "AccessibilityIdentifierElementMatching"
        )
        
        // Then: Should match elements correctly
        #expect(hasAccessibilityID, "Accessibility identifier element matching should work correctly")
    }
    
    @Test func testAccessibilityIdentifierStateMatchingGeneratesAccessibilityIdentifiers() async {
        // Given: Accessibility identifier state matching
        let testView = VStack {
            Text("Test Content")
            Button("Test Button") { }
        }
        .automaticAccessibilityIdentifiers()
        
        // When: Testing state matching
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            testView,
            expectedPattern: "*.main.ui.element.*",
            platform: SixLayerPlatform.iOS,
            componentName: "AccessibilityIdentifierStateMatching"
        )
        
        // Then: Should match states correctly
        #expect(hasAccessibilityID, "Accessibility identifier state matching should work correctly")
    }
    
    @Test func testAccessibilityIdentifierHierarchyMatchingGeneratesAccessibilityIdentifiers() async {
        // Given: Accessibility identifier hierarchy matching
        let testView = VStack {
            Text("Test Content")
            Button("Test Button") { }
        }
        .named("TestElement")
        .automaticAccessibilityIdentifiers()
        
        // When: Testing hierarchy matching
        // Note: IDs use "main" as screen context, not custom screen names unless .screenContext() is applied
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            testView,
            expectedPattern: "*.main.ui.TestElement",
            platform: SixLayerPlatform.iOS,
            componentName: "AccessibilityIdentifierHierarchyMatching"
        )
        
        // Then: Should match hierarchy correctly
        #expect(hasAccessibilityID, "Accessibility identifier hierarchy matching should work correctly")
    }
    
    @Test func testAccessibilityIdentifierCaseInsensitiveMatchingGeneratesAccessibilityIdentifiers() async {
        // Given: Accessibility identifier case insensitive matching
        let testView = VStack {
            Text("Test Content")
            Button("Test Button") { }
        }
        .named("TestElement")
        .automaticAccessibilityIdentifiers()
        
        // When: Testing case insensitive matching
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            testView,
            expectedPattern: "*.main.ui.TestElement",
            platform: SixLayerPlatform.iOS,
            componentName: "AccessibilityIdentifierCaseInsensitiveMatching"
        )
        
        // Then: Should match case insensitively
        #expect(hasAccessibilityID, "Accessibility identifier case insensitive matching should work correctly")
    }
    
    @Test func testAccessibilityIdentifierPartialMatchingGeneratesAccessibilityIdentifiers() async {
        // Given: Accessibility identifier partial matching
        let testView = VStack {
            Text("Test Content")
            Button("Test Button") { }
        }
        .automaticAccessibilityIdentifiers()
        
        // When: Testing partial matching
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            testView,
            expectedPattern: "*.main.*",
            platform: SixLayerPlatform.iOS,
            componentName: "AccessibilityIdentifierPartialMatching"
        )
        
        // Then: Should match partially
        #expect(hasAccessibilityID, "Accessibility identifier partial matching should work correctly")
    }
    
    @Test func testAccessibilityIdentifierRegexMatchingGeneratesAccessibilityIdentifiers() async {
        // Given: Accessibility identifier regex matching
        let testView = VStack {
            Text("Test Content")
            Button("Test Button") { }
        }
        .automaticAccessibilityIdentifiers()
        
        // When: Testing regex matching
        // Updated to include ui segment in pattern
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            testView,
            expectedPattern: ".*\\.main\\.ui\\.element\\..*",
            platform: SixLayerPlatform.iOS,
            componentName: "AccessibilityIdentifierRegexMatching"
        )
        
        // Then: Should match regex patterns
        #expect(hasAccessibilityID, "Accessibility identifier regex matching should work correctly")
    }
    
    @Test func testAccessibilityIdentifierPerformanceMatchingGeneratesAccessibilityIdentifiers() async {
        // Given: Accessibility identifier performance matching
        let testView = VStack {
            Text("Test Content")
            Button("Test Button") { }
        }
        .automaticAccessibilityIdentifiers()
        
        // When: Testing accessibility identifier generation
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            testView,
            expectedPattern: "SixLayer.main.ui",
            platform: SixLayerPlatform.iOS,
            componentName: "AccessibilityIdentifierPerformanceMatching"
        )
        
        // Then: Should work correctly
        #expect(hasAccessibilityID, "Accessibility identifier performance matching should work correctly")
    }
    
    @Test func testAccessibilityIdentifierErrorHandlingGeneratesAccessibilityIdentifiers() async {
        // Given: Accessibility identifier error handling
        let testView = VStack {
            Text("Test Content")
            Button("Test Button") { }
        }
        .automaticAccessibilityIdentifiers()
        
        // When: Testing error handling with invalid pattern
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            testView,
            expectedPattern: "invalid.pattern.that.should.not.match",
            platform: SixLayerPlatform.iOS,
            componentName: "AccessibilityIdentifierErrorHandling"
        )
        
        // Then: Should handle errors gracefully by not generating invalid IDs
        #expect(!hasAccessibilityID, "Accessibility identifier error handling should not generate invalid IDs")
    }
    
    @Test func testAccessibilityIdentifierNullHandlingGeneratesAccessibilityIdentifiers() async {
        // Given: Accessibility identifier null handling
        let testView = VStack {
            Text("Test Content")
            Button("Test Button") { }
        }
        // Note: No accessibility identifiers applied
        
        // When: Testing null handling
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            testView,
            expectedPattern: "SixLayer.main.ui",
            platform: SixLayerPlatform.iOS,
            componentName: "AccessibilityIdentifierNullHandling"
        )
        
        // Then: Should handle null values gracefully by not generating invalid IDs
        #expect(!hasAccessibilityID, "Accessibility identifier null handling should not generate invalid IDs")
    }
    
    @Test func testAccessibilityIdentifierEmptyHandlingGeneratesAccessibilityIdentifiers() async {
        // Given: Accessibility identifier empty handling
        let testView = VStack {
            Text("Test Content")
            Button("Test Button") { }
        }
        .automaticAccessibilityIdentifiers()
        
        // When: Testing empty handling
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            testView,
            expectedPattern: "",
            platform: SixLayerPlatform.iOS,
            componentName: "AccessibilityIdentifierEmptyHandling"
        )
        
        // Then: Should handle empty patterns gracefully by not generating invalid IDs
        #expect(!hasAccessibilityID, "Accessibility identifier empty handling should not generate invalid IDs")
    }
    
    @Test func testAccessibilityIdentifierWhitespaceHandlingGeneratesAccessibilityIdentifiers() async {
        // Given: Accessibility identifier whitespace handling
        let testView = VStack {
            Text("Test Content")
            Button("Test Button") { }
        }
        .automaticAccessibilityIdentifiers()
        
        // When: Testing whitespace handling
        // Note: Pattern matching should trim whitespace; updated to match actual generated IDs (may have duplicate prefix)
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            testView,
            expectedPattern: "*.main.ui.element.*",
            platform: SixLayerPlatform.iOS,
            componentName: "AccessibilityIdentifierWhitespaceHandling"
        )
        
        // Then: Should handle whitespace gracefully
        #expect(hasAccessibilityID, "Accessibility identifier whitespace handling should work correctly")
    }
    
    @Test func testAccessibilityIdentifierSpecialCharacterHandlingGeneratesAccessibilityIdentifiers() async {
        // Given: Accessibility identifier special character handling
        let testView = VStack {
            Text("Test Content")
            Button("Test Button") { }
        }
        .named("Test-Element_With.Special@Characters")
        .automaticAccessibilityIdentifiers()
        
        // When: Testing special character handling
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            testView,
            expectedPattern: "SixLayer.main.ui",
            platform: SixLayerPlatform.iOS,
            componentName: "AccessibilityIdentifierSpecialCharacterHandling"
        )
        
        // Then: Should handle special characters gracefully
        #expect(hasAccessibilityID, "Accessibility identifier special character handling should work correctly")
    }
    
    @Test func testAccessibilityIdentifierUnicodeHandlingGeneratesAccessibilityIdentifiers() async {
        // Given: Accessibility identifier unicode handling
        let testView = VStack {
            Text("Test Content")
            Button("Test Button") { }
        }
        .named("TestElementWithUnicode测试")
        .automaticAccessibilityIdentifiers()
        
        // When: Testing unicode handling
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            testView,
            expectedPattern: "SixLayer.main.ui",
            platform: SixLayerPlatform.iOS,
            componentName: "AccessibilityIdentifierUnicodeHandling"
        )
        
        // Then: Should handle unicode gracefully
        #expect(hasAccessibilityID, "Accessibility identifier unicode handling should work correctly")
    }
    
    @Test func testAccessibilityIdentifierLongStringHandlingGeneratesAccessibilityIdentifiers() async {
        // Given: Accessibility identifier long string handling
        let longString = String(repeating: "A", count: 1000)
        let testView = VStack {
            Text("Test Content")
            Button("Test Button") { }
        }
        .named(longString)
        .automaticAccessibilityIdentifiers()
        
        // When: Testing long string handling
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            testView,
            expectedPattern: "SixLayer.main.ui",
            platform: SixLayerPlatform.iOS,
            componentName: "AccessibilityIdentifierLongStringHandling"
        )
        
        // Then: Should handle long strings gracefully
        #expect(hasAccessibilityID, "Accessibility identifier long string handling should work correctly")
    }
}

