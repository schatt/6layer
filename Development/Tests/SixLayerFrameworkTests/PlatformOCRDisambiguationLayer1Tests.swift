import XCTest
import SwiftUI
@testable import SixLayerFramework
import ViewInspector

/// Tests for PlatformOCRDisambiguationLayer1.swift
/// 
/// BUSINESS PURPOSE: Ensure all OCR disambiguation Layer 1 functions generate proper accessibility identifiers
/// TESTING SCOPE: All functions in PlatformOCRDisambiguationLayer1.swift
/// METHODOLOGY: Test each function on both iOS and macOS platforms as required by mandatory testing guidelines
@MainActor
final class PlatformOCRDisambiguationLayer1Tests: XCTestCase {
    
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
    
    // MARK: - platformOCRDisambiguation_L1 Tests
    
    func testPlatformOCRDisambiguationL1GeneratesAccessibilityIdentifiersOnIOS() async {
        let alternatives = ["Option 1", "Option 2", "Option 3"]
        
        let view = platformOCRWithDisambiguation_L1(
            image: PlatformImage(),
            context: OCRContext(
                textTypes: [.general],
                language: .english,
                confidenceThreshold: 0.8,
                allowsEditing: true
            ),
            onResult: { _ in }
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*platformocrdisambiguation_l1", 
            platform: .iOS,
            componentName: "platformOCRDisambiguation_L1"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformOCRDisambiguation_L1 should generate accessibility identifiers on iOS")
    }
    
    func testPlatformOCRDisambiguationL1GeneratesAccessibilityIdentifiersOnMacOS() async {
        let alternatives = ["Option 1", "Option 2", "Option 3"]
        
        let view = platformOCRWithDisambiguation_L1(
            image: PlatformImage(),
            context: OCRContext(
                textTypes: [.general],
                language: .english,
                confidenceThreshold: 0.8,
                allowsEditing: true
            ),
            onResult: { _ in }
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*platformocrdisambiguation_l1", 
            platform: .macOS,
            componentName: "platformOCRDisambiguation_L1"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformOCRDisambiguation_L1 should generate accessibility identifiers on macOS")
    }
}

