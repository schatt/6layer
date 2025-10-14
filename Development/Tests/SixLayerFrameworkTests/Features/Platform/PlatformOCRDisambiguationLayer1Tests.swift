import Testing
import SwiftUI
@testable import SixLayerFramework
import ViewInspector

/// Tests for PlatformOCRDisambiguationLayer1.swift
/// 
/// BUSINESS PURPOSE: Ensure all OCR disambiguation Layer 1 functions generate proper accessibility identifiers
/// TESTING SCOPE: All functions in PlatformOCRDisambiguationLayer1.swift
/// METHODOLOGY: Test each function on both iOS and macOS platforms as required by mandatory testing guidelines
@MainActor
final class PlatformOCRDisambiguationLayer1Tests {
    
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
    
    // MARK: - platformOCRDisambiguation_L1 Tests
    
    @Test func testPlatformOCRDisambiguationL1GeneratesAccessibilityIdentifiersOnIOS() async {
        let alternatives = ["Option 1", "Option 2", "Option 3"]
        
        // Verify alternatives are properly configured
        #expect(alternatives.count == 3, "Should have 3 alternatives")
        #expect(alternatives[0] == "Option 1", "First alternative should be correct")
        #expect(alternatives[1] == "Option 2", "Second alternative should be correct")
        #expect(alternatives[2] == "Option 3", "Third alternative should be correct")
        
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
            expectedPattern: "SixLayer.main.element.*", 
            platform: .iOS,
            componentName: "platformOCRDisambiguation_L1"
        )
        
        #expect(hasAccessibilityID, "platformOCRDisambiguation_L1 should generate accessibility identifiers on iOS")
    }
    
    @Test func testPlatformOCRDisambiguationL1GeneratesAccessibilityIdentifiersOnMacOS() async {
        let alternatives = ["Option 1", "Option 2", "Option 3"]
        
        // Verify alternatives are properly configured
        #expect(alternatives.count == 3, "Should have 3 alternatives")
        #expect(alternatives[0] == "Option 1", "First alternative should be correct")
        #expect(alternatives[1] == "Option 2", "Second alternative should be correct")
        #expect(alternatives[2] == "Option 3", "Third alternative should be correct")
        
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
            expectedPattern: "SixLayer.main.element.*", 
            platform: .macOS,
            componentName: "platformOCRDisambiguation_L1"
        )
        
        #expect(hasAccessibilityID, "platformOCRDisambiguation_L1 should generate accessibility identifiers on macOS")
    }
}

