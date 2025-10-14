import Testing


import SwiftUI
@testable import SixLayerFramework
import ViewInspector

/// Tests for OCRDisambiguationView.swift
/// 
/// BUSINESS PURPOSE: Ensure OCRDisambiguationView generates proper accessibility identifiers
/// TESTING SCOPE: All components in OCRDisambiguationView.swift
/// METHODOLOGY: Test each component on both iOS and macOS platforms as required by mandatory testing guidelines
@MainActor
final class OCRDisambiguationViewTests {
    
    // MARK: - Test Setup
    
    init() {
        setupTestEnvironment()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
        config.enableAutoIDs = true
        config.namespace = "SixLayer"
        config.mode = .automatic
        config.enableDebugLogging = false
    }
    
    deinit {
        cleanupTestEnvironment()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
    }
    
    // MARK: - OCRDisambiguationView Tests
    
    @Test func testOCRDisambiguationViewGeneratesAccessibilityIdentifiersOnIOS() async {
        let candidates = [
            OCRDataCandidate(
                text: "Test Text",
                boundingBox: CGRect(x: 0, y: 0, width: 100, height: 20),
                confidence: 0.95,
                suggestedType: .general,
                alternativeTypes: [.email, .phone]
            )
        ]
        
        let result = OCRDisambiguationResult(
            candidates: candidates,
            confidence: 0.95,
            requiresUserSelection: true
        )
        
        let view = OCRDisambiguationView(
            result: result,
            onSelection: { _ in }
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.main.element.*", 
            platform: .iOS,
            componentName: "OCRDisambiguationView"
        )
        
        #expect(hasAccessibilityID, "OCRDisambiguationView should generate accessibility identifiers on iOS")
    }
    
    @Test func testOCRDisambiguationViewGeneratesAccessibilityIdentifiersOnMacOS() async {
        let candidates = [
            OCRDataCandidate(
                text: "Test Text",
                boundingBox: CGRect(x: 0, y: 0, width: 100, height: 20),
                confidence: 0.95,
                suggestedType: .general,
                alternativeTypes: [.email, .phone]
            )
        ]
        
        let result = OCRDisambiguationResult(
            candidates: candidates,
            confidence: 0.95,
            requiresUserSelection: true
        )
        
        let view = OCRDisambiguationView(
            result: result,
            onSelection: { _ in }
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.main.element.*", 
            platform: .macOS,
            componentName: "OCRDisambiguationView"
        )
        
        #expect(hasAccessibilityID, "OCRDisambiguationView should generate accessibility identifiers on macOS")
    }
}

