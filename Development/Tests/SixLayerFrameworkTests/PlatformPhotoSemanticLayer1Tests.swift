import XCTest
import SwiftUI
@testable import SixLayerFramework
import ViewInspector

/// Tests for PlatformPhotoSemanticLayer1.swift
/// 
/// BUSINESS PURPOSE: Ensure all photo Layer 1 semantic functions generate proper accessibility identifiers
/// TESTING SCOPE: All functions in PlatformPhotoSemanticLayer1.swift
/// METHODOLOGY: Test each function on both iOS and macOS platforms as required by mandatory testing guidelines
@MainActor
final class PlatformPhotoSemanticLayer1Tests: XCTestCase {
    
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
    
    // MARK: - platformPresentPhotoGallery_L1 Tests
    
    func testPlatformPresentPhotoGalleryL1GeneratesAccessibilityIdentifiersOnIOS() async {
        let testPhotos = [
            PhotoItem(id: "1", url: "https://example.com/1.jpg", caption: "Photo 1"),
            PhotoItem(id: "2", url: "https://example.com/2.jpg", caption: "Photo 2")
        ]
        let hints = PresentationHints(
            dataType: .media,
            presentationPreference: .grid,
            complexity: .moderate,
            context: .gallery,
            customPreferences: [:]
        )
        
        let view = platformPresentPhotoGallery_L1(photos: testPhotos, hints: hints)
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*platformpresentphotogallery_l1", 
            platform: .iOS,
            componentName: "platformPresentPhotoGallery_L1"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformPresentPhotoGallery_L1 should generate accessibility identifiers on iOS")
    }
    
    func testPlatformPresentPhotoGalleryL1GeneratesAccessibilityIdentifiersOnMacOS() async {
        let testPhotos = [
            PhotoItem(id: "1", url: "https://example.com/1.jpg", caption: "Photo 1"),
            PhotoItem(id: "2", url: "https://example.com/2.jpg", caption: "Photo 2")
        ]
        let hints = PresentationHints(
            dataType: .media,
            presentationPreference: .grid,
            complexity: .moderate,
            context: .gallery,
            customPreferences: [:]
        )
        
        let view = platformPresentPhotoGallery_L1(photos: testPhotos, hints: hints)
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*platformpresentphotogallery_l1", 
            platform: .macOS,
            componentName: "platformPresentPhotoGallery_L1"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformPresentPhotoGallery_L1 should generate accessibility identifiers on macOS")
    }
}

