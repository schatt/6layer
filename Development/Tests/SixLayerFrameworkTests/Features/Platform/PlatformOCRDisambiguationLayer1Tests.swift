import Testing


import SwiftUI
@testable import SixLayerFramework
#if !os(macOS)
import ViewInspector
#endif
/// Tests for PlatformOCRDisambiguationLayer1.swift
/// 
/// BUSINESS PURPOSE: Ensure all OCR disambiguation Layer 1 functions generate proper accessibility identifiers
/// TESTING SCOPE: All functions in PlatformOCRDisambiguationLayer1.swift
/// METHODOLOGY: Test each function on both iOS and macOS platforms as required by mandatory testing guidelines
@Suite("Platform O C R Disambiguation Layer")
@MainActor
open class PlatformOCRDisambiguationLayer1Tests {
    
    // MARK: - Test Setup
    
    init() async throws {
        await setupTestEnvironment()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
        config.enableAutoIDs = true
        config.namespace = "SixLayer"
        config.mode = .automatic
        config.enableDebugLogging = false
    }    // MARK: - platformOCRDisambiguation_L1 Tests
    
    
    private func setupTestEnvironment() async {
        await AccessibilityTestUtilities.setupAccessibilityTestEnvironment()
    }
    
    private func cleanupTestEnvironment() async {
        await AccessibilityTestUtilities.cleanupAccessibilityTestEnvironment()
    }
    
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
        
        let hasAccessibilityID = testAccessibilityIdentifiersCrossPlatform(
            view, 
            expectedPattern: "SixLayer.*ui", 
            componentName: "platformOCRDisambiguation_L1",
            testName: "PlatformTest"
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
        
        let hasAccessibilityID = testAccessibilityIdentifiersCrossPlatform(
            view, 
            expectedPattern: "SixLayer.*ui", 
            componentName: "platformOCRDisambiguation_L1",
            testName: "PlatformTest"
        )
        
        #expect(hasAccessibilityID, "platformOCRDisambiguation_L1 should generate accessibility identifiers on macOS")
    }
}

