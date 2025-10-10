import XCTest
import SwiftUI
import ViewInspector
@testable import SixLayerFramework

/// BUSINESS PURPOSE: Accessibility tests for PlatformOCRComponentsLayer4.swift functions
/// Ensures OCR components Layer 4 functions generate proper accessibility identifiers
/// for automated testing and accessibility tools compliance
@MainActor
final class PlatformOCRComponentsLayer4AccessibilityTests: XCTestCase {
    
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
    
    // MARK: - OCR Implementation Tests
    
    /// BUSINESS PURPOSE: Validates that platformOCRImplementation_L4 generates proper accessibility identifiers
    /// for automated testing and accessibility tools compliance on iOS
    func testPlatformOCRImplementationL4GeneratesAccessibilityIdentifiersOnIOS() async {
        // Given
        let testImage = PlatformImage()
        let context = OCRContext(
            textTypes: [.general],
            language: .english,
            confidenceThreshold: 0.8,
            allowsEditing: true
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
        
        let strategy = OCRStrategy(
            supportedTextTypes: [.general],
            supportedLanguages: [.english],
            processingMode: .standard,
            requiresNeuralEngine: false,
            estimatedProcessingTime: 1.0
        )
        
        let view = platformOCRImplementation_L4(
            image: testImage,
            context: context,
            strategy: strategy,
            onResult: { _ in }
        )
        
        // When & Then
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*ocrimplementation", 
            platform: .iOS,
            componentName: "platformOCRImplementation_L4"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformOCRImplementation_L4 should generate accessibility identifiers on iOS")
    }
    
    /// BUSINESS PURPOSE: Validates that platformOCRImplementation_L4 generates proper accessibility identifiers
    /// for automated testing and accessibility tools compliance on macOS
    func testPlatformOCRImplementationL4GeneratesAccessibilityIdentifiersOnMacOS() async {
        // Given
        let testImage = PlatformImage()
        let context = OCRContext(
            textTypes: [.general],
            language: .english,
            confidenceThreshold: 0.8,
            allowsEditing: true
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
        
        let strategy = OCRStrategy(
            supportedTextTypes: [.general],
            supportedLanguages: [.english],
            processingMode: .standard,
            requiresNeuralEngine: false,
            estimatedProcessingTime: 1.0
        )
        
        let view = platformOCRImplementation_L4(
            image: testImage,
            context: context,
            strategy: strategy,
            onResult: { _ in }
        )
        
        // When & Then
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*ocrimplementation", 
            platform: .macOS,
            componentName: "platformOCRImplementation_L4"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformOCRImplementation_L4 should generate accessibility identifiers on macOS")
    }
}

