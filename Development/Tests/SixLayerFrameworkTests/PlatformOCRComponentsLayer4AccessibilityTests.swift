import XCTest
import SwiftUI
import ViewInspector
@testable import SixLayerFramework

/// BUSINESS PURPOSE: Accessibility tests for PlatformOCRComponentsLayer4.swift functions
/// Ensures OCR components Layer 4 functions generate proper accessibility identifiers
/// for automated testing and accessibility tools compliance
final class PlatformOCRComponentsLayer4AccessibilityTests: XCTestCase {
    
    override func setUp() async throws {
        try await super.setUp()
        await setupTestEnvironment()
        await MainActor.run {
            let config = AccessibilityIdentifierConfig.shared
            config.resetToDefaults()
            config.enableAutoIDs = true
            config.namespace = "SixLayer"
            config.mode = .automatic
            config.enableDebugLogging = false
        }
    }
    
    override func tearDown() async throws {
        try await super.tearDown()
        await cleanupTestEnvironment()
        await MainActor.run {
            let config = AccessibilityIdentifierConfig.shared
            config.resetToDefaults()
        }
    }
    
    // MARK: - OCR Implementation Tests
    
    /// BUSINESS PURPOSE: Validates that platformOCRImplementation_L4 generates proper accessibility identifiers
    /// for automated testing and accessibility tools compliance on iOS
    func testPlatformOCRImplementationL4GeneratesAccessibilityIdentifiersOnIOS() async {
        // Given
        let testImage = PlatformImage()
        let context = OCRContext(
            textTypes: [TextType.general],
            language: OCRLanguage.english
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
        
        // Verify layout decision is properly configured
        XCTAssertEqual(layoutDecision.columns, 2, "Layout decision should have correct columns")
        XCTAssertEqual(layoutDecision.spacing, 16, "Layout decision should have correct spacing")
        XCTAssertEqual(layoutDecision.cardWidth, 150, "Layout decision should have correct card width")
        XCTAssertEqual(layoutDecision.cardHeight, 200, "Layout decision should have correct card height")
        XCTAssertEqual(layoutDecision.padding, 16, "Layout decision should have correct padding")
        XCTAssertEqual(layoutDecision.expansionScale, 1.0, "Layout decision should have correct expansion scale")
        XCTAssertEqual(layoutDecision.animationDuration, 0.3, "Layout decision should have correct animation duration")
        
        let strategy = OCRStrategy(
            supportedTextTypes: [.general],
            supportedLanguages: [.english],
            processingMode: .standard,
            requiresNeuralEngine: false,
            estimatedProcessingTime: 1.0
        )
        
        // Use the recommended OCRService instead of deprecated platformOCRImplementation_L4
        let ocrService = OCRService()
        let view = ocrService.processImage(
            image: testImage,
            context: context,
            strategy: strategy,
            onResult: { _ in }
        )
        
        // When & Then
        let hasAccessibilityID = await MainActor.run {
            hasAccessibilityIdentifier(
                view, 
                expectedPattern: "SixLayer.*element.*ocrimplementation", 
                platform: .iOS,
                componentName: "platformOCRImplementation_L4"
            )
        }
        
        XCTAssertTrue(hasAccessibilityID, "platformOCRImplementation_L4 should generate accessibility identifiers on iOS")
    }
    
    /// BUSINESS PURPOSE: Validates that platformOCRImplementation_L4 generates proper accessibility identifiers
    /// for automated testing and accessibility tools compliance on macOS
    func testPlatformOCRImplementationL4GeneratesAccessibilityIdentifiersOnMacOS() async {
        // Given
        let testImage = PlatformImage()
        let context = OCRContext(
            textTypes: [TextType.general],
            language: OCRLanguage.english
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
        
        // Verify layout decision is properly configured
        XCTAssertEqual(layoutDecision.columns, 2, "Layout decision should have correct columns")
        XCTAssertEqual(layoutDecision.spacing, 16, "Layout decision should have correct spacing")
        XCTAssertEqual(layoutDecision.cardWidth, 150, "Layout decision should have correct card width")
        XCTAssertEqual(layoutDecision.cardHeight, 200, "Layout decision should have correct card height")
        XCTAssertEqual(layoutDecision.padding, 16, "Layout decision should have correct padding")
        XCTAssertEqual(layoutDecision.expansionScale, 1.0, "Layout decision should have correct expansion scale")
        XCTAssertEqual(layoutDecision.animationDuration, 0.3, "Layout decision should have correct animation duration")
        
        let strategy = OCRStrategy(
            supportedTextTypes: [.general],
            supportedLanguages: [.english],
            processingMode: .standard,
            requiresNeuralEngine: false,
            estimatedProcessingTime: 1.0
        )
        
        // Use the recommended OCRService instead of deprecated platformOCRImplementation_L4
        let ocrService = OCRService()
        let view = ocrService.processImage(
            image: testImage,
            context: context,
            strategy: strategy,
            onResult: { _ in }
        )
        
        // When & Then
        let hasAccessibilityID = await MainActor.run {
            hasAccessibilityIdentifier(
                view, 
                expectedPattern: "SixLayer.*element.*ocrimplementation", 
                platform: .macOS,
                componentName: "platformOCRImplementation_L4"
            )
        }
        
        XCTAssertTrue(hasAccessibilityID, "platformOCRImplementation_L4 should generate accessibility identifiers on macOS")
    }
}

// MARK: - Test Extensions
extension PlatformOCRComponentsLayer4AccessibilityTests {
    override func setupTestEnvironment() {
        TestSetupUtilities.shared.setupTestingEnvironment()
    }
    
    override func cleanupTestEnvironment() {
        TestSetupUtilities.shared.setupTestingEnvironment()
    }
}
