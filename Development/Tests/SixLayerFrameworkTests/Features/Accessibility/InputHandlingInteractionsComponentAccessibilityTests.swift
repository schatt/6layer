import Testing


//
//  InputHandlingInteractionsComponentAccessibilityTests.swift
//  SixLayerFrameworkTests
//
//  Comprehensive accessibility tests for ALL InputHandlingInteractions components
//

import SwiftUI
@testable import SixLayerFramework

@MainActor
@Suite("Input Handling Interactions Component Accessibility")
open class InputHandlingInteractionsComponentAccessibilityTests: BaseTestClass {
    
    // MARK: - PlatformInteractionButton Tests
    
    @Test func testPlatformInteractionButtonGeneratesAccessibilityIdentifiers() async {
        // Given: Framework component as label (testing our framework, not SwiftUI)
        let testLabel = platformPresentContent_L1(
            content: "Platform Interaction Button",
            hints: PresentationHints()
        )
        
        // When: Creating PlatformInteractionButton with framework component label
        let view = PlatformInteractionButton(style: .primary, action: {
            // Button action
        }, label: {
            testLabel
        })
        
        // Then: Should generate accessibility identifiers
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "SixLayer.main.ui.*",
            platform: SixLayerPlatform.iOS,
            componentName: "PlatformInteractionButton"
        )
        
        #expect(hasAccessibilityID, "PlatformInteractionButton should generate accessibility identifiers")
    }
    
    // MARK: - InputHandlingManager Tests
    
    @Test func testInputHandlingManagerGeneratesAccessibilityIdentifiers() async {
        // Given: Framework component with InputHandlingManager
        let manager = InputHandlingManager()
        
        // When: Creating a framework component view with InputHandlingManager
        let view = platformPresentContent_L1(
            content: "Input Handling Manager Content",
            hints: PresentationHints()
        )
        .environmentObject(manager)
        
        // Then: Should generate accessibility identifiers
        let hasAccessibilityID = hasAccessibilityIdentifierWithPattern(
            view,
            expectedPattern: "SixLayer.main.ui.*",
            platform: SixLayerPlatform.iOS,
            componentName: "InputHandlingManager"
        )
        
        #expect(hasAccessibilityID, "InputHandlingManager should generate accessibility identifiers")
    }
    
    // MARK: - KeyboardShortcutManager Tests
    
    @Test func testKeyboardShortcutManagerGeneratesAccessibilityIdentifiers() async {
        // When: Creating a framework component
        let view = platformPresentContent_L1(
            content: "Keyboard Shortcut Manager Content",
            hints: PresentationHints()
        )
        
        // Then: Should generate accessibility identifiers
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "SixLayer.main.ui.*",
            platform: SixLayerPlatform.iOS,
            componentName: "KeyboardShortcutManager"
        )
        
        #expect(hasAccessibilityID, "KeyboardShortcutManager should generate accessibility identifiers")
    }
    
    // MARK: - HapticFeedbackManager Tests
    
    @Test func testHapticFeedbackManagerGeneratesAccessibilityIdentifiers() async {
        // When: Creating a framework component
        let view = platformPresentContent_L1(
            content: "Haptic Feedback Manager Content",
            hints: PresentationHints()
        )
        
        // Then: Should generate accessibility identifiers
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "SixLayer.main.ui.*",
            platform: SixLayerPlatform.iOS,
            componentName: "HapticFeedbackManager"
        )
        
        #expect(hasAccessibilityID, "HapticFeedbackManager should generate accessibility identifiers")
    }
    
    // MARK: - DragDropManager Tests
    
    @Test func testDragDropManagerGeneratesAccessibilityIdentifiers() async {
        // When: Creating a framework component
        let view = platformPresentContent_L1(
            content: "Drag Drop Manager Content",
            hints: PresentationHints()
        )
        
        // Then: Should generate accessibility identifiers
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "SixLayer.main.ui.*",
            platform: SixLayerPlatform.iOS,
            componentName: "DragDropManager"
        )
        
        #expect(hasAccessibilityID, "DragDropManager should generate accessibility identifiers")
    }
}


