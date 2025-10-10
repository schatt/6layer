import XCTest
import SwiftUI
import ViewInspector
@testable import SixLayerFramework

/// BUSINESS PURPOSE: Accessibility tests for PlatformPhotoComponentsLayer4.swift functions
/// Ensures Photo components Layer 4 functions generate proper accessibility identifiers
/// for automated testing and accessibility tools compliance
@MainActor
final class PlatformPhotoComponentsLayer4AccessibilityTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        setupTestEnvironment()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
        config.enableAutoIDs = true
        config.namespace = "SixLayer"
        config.mode = .automatic
        config.enableDebugLogging = false
    }
    
    override func tearDown() {
        super.tearDown()
        cleanupTestEnvironment()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
    }
    
    // MARK: - Photo Picker Tests
    
    /// BUSINESS PURPOSE: Validates that platformPhotoPicker_L4 generates proper accessibility identifiers
    /// for automated testing and accessibility tools compliance on iOS
    func testPlatformPhotoPickerL4GeneratesAccessibilityIdentifiersOnIOS() async {
        // Given
        let hints = PresentationHints(
            dataType: .media,
            presentationPreference: .automatic,
            complexity: .moderate,
            context: .modal,
            customPreferences: [:]
        )
        
        let layoutDecision = IntelligentCardLayoutDecision(
            columns: 2,
            spacing: 16,
            cardWidth: 150,
            cardHeight: 200,
            padding: 16,
            expansionScale: 1.0,
            animationDuration: 0.3
        )
        
        let strategy = CardExpansionStrategy(
            supportedStrategies: [.hoverExpand],
            primaryStrategy: .hoverExpand,
            expansionScale: 1.0,
            animationDuration: 0.3,
            hapticFeedback: true,
            accessibilitySupport: true
        )
        
        let view = platformPhotoPicker_L4(
            onImageSelected: { _ in }
        )
        
        // When & Then
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*photopicker", 
            platform: .iOS,
            componentName: "platformPhotoPicker_L4"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformPhotoPicker_L4 should generate accessibility identifiers on iOS")
    }
    
    /// BUSINESS PURPOSE: Validates that platformPhotoPicker_L4 generates proper accessibility identifiers
    /// for automated testing and accessibility tools compliance on macOS
    func testPlatformPhotoPickerL4GeneratesAccessibilityIdentifiersOnMacOS() async {
        // Given
        let hints = PresentationHints(
            dataType: .media,
            presentationPreference: .automatic,
            complexity: .moderate,
            context: .modal,
            customPreferences: [:]
        )
        
        let layoutDecision = IntelligentCardLayoutDecision(
            columns: 2,
            spacing: 16,
            cardWidth: 150,
            cardHeight: 200,
            padding: 16,
            expansionScale: 1.0,
            animationDuration: 0.3
        )
        
        let strategy = CardExpansionStrategy(
            supportedStrategies: [.hoverExpand],
            primaryStrategy: .hoverExpand,
            expansionScale: 1.0,
            animationDuration: 0.3,
            hapticFeedback: true,
            accessibilitySupport: true
        )
        
        let view = platformPhotoPicker_L4(
            onImageSelected: { _ in }
        )
        
        // When & Then
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*photopicker", 
            platform: .macOS,
            componentName: "platformPhotoPicker_L4"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformPhotoPicker_L4 should generate accessibility identifiers on macOS")
    }
    
    // MARK: - Photo Display Tests
    
    /// BUSINESS PURPOSE: Validates that platformPhotoDisplay_L4 generates proper accessibility identifiers
    /// for automated testing and accessibility tools compliance on iOS
    func testPlatformPhotoDisplayL4GeneratesAccessibilityIdentifiersOnIOS() async {
        // Given
        let testPhotos = [PlatformImage(), PlatformImage()]
        let hints = PresentationHints(
            dataType: .media,
            presentationPreference: .automatic,
            complexity: .moderate,
            context: .modal,
            customPreferences: [:]
        )
        
        let layoutDecision = IntelligentCardLayoutDecision(
            columns: 2,
            spacing: 16,
            cardWidth: 150,
            cardHeight: 200,
            padding: 16,
            expansionScale: 1.0,
            animationDuration: 0.3
        )
        
        let strategy = CardExpansionStrategy(
            supportedStrategies: [.hoverExpand],
            primaryStrategy: .hoverExpand,
            expansionScale: 1.0,
            animationDuration: 0.3,
            hapticFeedback: true,
            accessibilitySupport: true
        )
        
        let view = platformPhotoDisplay_L4(
            image: PlatformImage(),
            style: .thumbnail
        )
        
        // When & Then
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*photodisplay", 
            platform: .iOS,
            componentName: "platformPhotoDisplay_L4"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformPhotoDisplay_L4 should generate accessibility identifiers on iOS")
    }
    
    /// BUSINESS PURPOSE: Validates that platformPhotoDisplay_L4 generates proper accessibility identifiers
    /// for automated testing and accessibility tools compliance on macOS
    func testPlatformPhotoDisplayL4GeneratesAccessibilityIdentifiersOnMacOS() async {
        // Given
        let testPhotos = [PlatformImage(), PlatformImage()]
        let hints = PresentationHints(
            dataType: .media,
            presentationPreference: .automatic,
            complexity: .moderate,
            context: .modal,
            customPreferences: [:]
        )
        
        let layoutDecision = IntelligentCardLayoutDecision(
            columns: 2,
            spacing: 16,
            cardWidth: 150,
            cardHeight: 200,
            padding: 16,
            expansionScale: 1.0,
            animationDuration: 0.3
        )
        
        let strategy = CardExpansionStrategy(
            supportedStrategies: [.hoverExpand],
            primaryStrategy: .hoverExpand,
            expansionScale: 1.0,
            animationDuration: 0.3,
            hapticFeedback: true,
            accessibilitySupport: true
        )
        
        let view = platformPhotoDisplay_L4(
            image: PlatformImage(),
            style: .thumbnail
        )
        
        // When & Then
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*photodisplay", 
            platform: .macOS,
            componentName: "platformPhotoDisplay_L4"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformPhotoDisplay_L4 should generate accessibility identifiers on macOS")
    }
    
    // MARK: - Photo Editor Tests
    
    /// BUSINESS PURPOSE: Validates that platformPhotoEditor_L4 generates proper accessibility identifiers
    /// for automated testing and accessibility tools compliance on iOS
    func testPlatformPhotoEditorL4GeneratesAccessibilityIdentifiersOnIOS() async {
        // Given
        let testPhoto = PlatformImage()
        let hints = PresentationHints(
            dataType: .media,
            presentationPreference: .automatic,
            complexity: .moderate,
            context: .modal,
            customPreferences: [:]
        )
        
        let layoutDecision = IntelligentCardLayoutDecision(
            columns: 1,
            spacing: 16,
            cardWidth: 300,
            cardHeight: 400,
            padding: 16,
            expansionScale: 1.0,
            animationDuration: 0.3
        )
        
        let strategy = CardExpansionStrategy(
            supportedStrategies: [.hoverExpand],
            primaryStrategy: .hoverExpand,
            expansionScale: 1.0,
            animationDuration: 0.3,
            hapticFeedback: true,
            accessibilitySupport: true
        )
        
        let view = platformPhotoEditor_L4(
            image: PlatformImage(),
            onImageEdited: { _ in }
        )
        
        // When & Then
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*photoeditor", 
            platform: .iOS,
            componentName: "platformPhotoEditor_L4"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformPhotoEditor_L4 should generate accessibility identifiers on iOS")
    }
    
    /// BUSINESS PURPOSE: Validates that platformPhotoEditor_L4 generates proper accessibility identifiers
    /// for automated testing and accessibility tools compliance on macOS
    func testPlatformPhotoEditorL4GeneratesAccessibilityIdentifiersOnMacOS() async {
        // Given
        let testPhoto = PlatformImage()
        let hints = PresentationHints(
            dataType: .media,
            presentationPreference: .automatic,
            complexity: .moderate,
            context: .modal,
            customPreferences: [:]
        )
        
        let layoutDecision = IntelligentCardLayoutDecision(
            columns: 1,
            spacing: 16,
            cardWidth: 300,
            cardHeight: 400,
            padding: 16,
            expansionScale: 1.0,
            animationDuration: 0.3
        )
        
        let strategy = CardExpansionStrategy(
            supportedStrategies: [.hoverExpand],
            primaryStrategy: .hoverExpand,
            expansionScale: 1.0,
            animationDuration: 0.3,
            hapticFeedback: true,
            accessibilitySupport: true
        )
        
        let view = platformPhotoEditor_L4(
            image: PlatformImage(),
            onImageEdited: { _ in }
        )
        
        // When & Then
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*photoeditor", 
            platform: .macOS,
            componentName: "platformPhotoEditor_L4"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformPhotoEditor_L4 should generate accessibility identifiers on macOS")
    }
}

