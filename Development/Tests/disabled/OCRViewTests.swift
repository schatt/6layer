import XCTest
import SwiftUI
@testable import SixLayerFramework
import ViewInspector

/// Tests for OCRView.swift
/// 
/// BUSINESS PURPOSE: Ensure OCRView generates proper accessibility identifiers
/// TESTING SCOPE: All components in OCRView.swift
/// METHODOLOGY: Test each component on both iOS and macOS platforms as required by mandatory testing guidelines
@MainActor
final class OCRViewTests: XCTestCase {
    
    // MARK: - Test Setup
    
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
    
    // MARK: - OCRView Tests
    
    func testOCRViewGeneratesAccessibilityIdentifiersOnIOS() async {
        let testImage = PlatformImage()
        let context = OCRContext()
        let strategy = OCRStrategy(
            supportedTextTypes: [.general],
            supportedLanguages: [.english],
            processingMode: .standard,
            requiresNeuralEngine: false,
            estimatedProcessingTime: 1.0
        )
        
        let view = OCRView(
            image: testImage,
            context: context,
            strategy: strategy,
            onResult: { _ in },
            onError: { _ in }
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.main.element.*", 
            platform: .iOS,
            componentName: "OCRView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "OCRView should generate accessibility identifiers on iOS")
    }
    
    func testOCRViewGeneratesAccessibilityIdentifiersOnMacOS() async {
        let testImage = PlatformImage()
        let context = OCRContext()
        let strategy = OCRStrategy(
            supportedTextTypes: [.general],
            supportedLanguages: [.english],
            processingMode: .standard,
            requiresNeuralEngine: false,
            estimatedProcessingTime: 1.0
        )
        
        let view = OCRView(
            image: testImage,
            context: context,
            strategy: strategy,
            onResult: { _ in },
            onError: { _ in }
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.main.element.*", 
            platform: .macOS,
            componentName: "OCRView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "OCRView should generate accessibility identifiers on macOS")
    }
}
