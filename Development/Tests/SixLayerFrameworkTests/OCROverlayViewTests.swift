import XCTest
import SwiftUI
@testable import SixLayerFramework
import ViewInspector

/// Tests for OCROverlayView.swift
/// 
/// BUSINESS PURPOSE: Ensure OCROverlayView generates proper accessibility identifiers
/// TESTING SCOPE: All components in OCROverlayView.swift
/// METHODOLOGY: Test each component on both iOS and macOS platforms as required by mandatory testing guidelines
@MainActor
final class OCROverlayViewTests: XCTestCase {
    
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
    
    // MARK: - OCROverlayView Tests
    
    func testOCROverlayViewGeneratesAccessibilityIdentifiersOnIOS() async {
        let view = OCROverlayView(
            text: "Test OCR Text",
            confidence: 0.95,
            onTap: {}
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*ocroverlayview", 
            platform: .iOS,
            componentName: "OCROverlayView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "OCROverlayView should generate accessibility identifiers on iOS")
    }
    
    func testOCROverlayViewGeneratesAccessibilityIdentifiersOnMacOS() async {
        let view = OCROverlayView(
            text: "Test OCR Text",
            confidence: 0.95,
            onTap: {}
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*ocroverlayview", 
            platform: .macOS,
            componentName: "OCROverlayView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "OCROverlayView should generate accessibility identifiers on macOS")
    }
}

