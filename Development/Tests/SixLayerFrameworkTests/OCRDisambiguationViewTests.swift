import XCTest
import SwiftUI
@testable import SixLayerFramework
import ViewInspector

/// Tests for OCRDisambiguationView.swift
/// 
/// BUSINESS PURPOSE: Ensure OCRDisambiguationView generates proper accessibility identifiers
/// TESTING SCOPE: All components in OCRDisambiguationView.swift
/// METHODOLOGY: Test each component on both iOS and macOS platforms as required by mandatory testing guidelines
@MainActor
final class OCRDisambiguationViewTests: XCTestCase {
    
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
    
    // MARK: - OCRDisambiguationView Tests
    
    func testOCRDisambiguationViewGeneratesAccessibilityIdentifiersOnIOS() async {
        let alternatives = ["Option 1", "Option 2", "Option 3"]
        
        let view = OCRDisambiguationView(
            recognizedText: "Test Text",
            alternatives: alternatives,
            onSelection: { _ in }
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*ocrdisambiguationview", 
            platform: .iOS,
            componentName: "OCRDisambiguationView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "OCRDisambiguationView should generate accessibility identifiers on iOS")
    }
    
    func testOCRDisambiguationViewGeneratesAccessibilityIdentifiersOnMacOS() async {
        let alternatives = ["Option 1", "Option 2", "Option 3"]
        
        let view = OCRDisambiguationView(
            recognizedText: "Test Text",
            alternatives: alternatives,
            onSelection: { _ in }
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*ocrdisambiguationview", 
            platform: .macOS,
            componentName: "OCRDisambiguationView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "OCRDisambiguationView should generate accessibility identifiers on macOS")
    }
}

