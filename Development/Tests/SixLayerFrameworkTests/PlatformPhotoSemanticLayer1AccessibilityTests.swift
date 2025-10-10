import XCTest
import SwiftUI
import ViewInspector
@testable import SixLayerFramework

/// BUSINESS PURPOSE: Accessibility tests for PlatformPhotoSemanticLayer1.swift functions
/// Ensures Photo semantic Layer 1 functions generate proper accessibility identifiers
/// for automated testing and accessibility tools compliance
final class PlatformPhotoSemanticLayer1AccessibilityTests: XCTestCase {
    
    override func setUp() async throws {
        try await super.setUp()
        await setupTestEnvironment()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
        config.enableAutoIDs = true
        config.namespace = "SixLayer"
        config.mode = .automatic
        config.enableDebugLogging = false
    }
    
    override func tearDown() async throws {
        try await super.tearDown()
        await cleanupTestEnvironment()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
    }
    
    // MARK: - Photo Capture Tests
    
    /// BUSINESS PURPOSE: Validates that platformPhotoCapture_L1 generates proper accessibility identifiers
    /// for automated testing and accessibility tools compliance on iOS
    func testPlatformPhotoCaptureL1GeneratesAccessibilityIdentifiersOnIOS() async {
        // Given
        let hints = PresentationHints(
            dataType: .media,
            presentationPreference: .automatic,
            complexity: .moderate,
            context: .modal,
            customPreferences: [:]
        )
        
        let view = platformPhotoCapture_L1(
            hints: hints,
            onPhotoCaptured: { _ in },
            onError: { _ in }
        )
        
        // When & Then
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*photocapture", 
            platform: .iOS,
            componentName: "platformPhotoCapture_L1"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformPhotoCapture_L1 should generate accessibility identifiers on iOS")
    }
    
    /// BUSINESS PURPOSE: Validates that platformPhotoCapture_L1 generates proper accessibility identifiers
    /// for automated testing and accessibility tools compliance on macOS
    func testPlatformPhotoCaptureL1GeneratesAccessibilityIdentifiersOnMacOS() async {
        // Given
        let hints = PresentationHints(
            dataType: .media,
            presentationPreference: .automatic,
            complexity: .moderate,
            context: .modal,
            customPreferences: [:]
        )
        
        let view = platformPhotoCapture_L1(
            hints: hints,
            onPhotoCaptured: { _ in },
            onError: { _ in }
        )
        
        // When & Then
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*photocapture", 
            platform: .macOS,
            componentName: "platformPhotoCapture_L1"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformPhotoCapture_L1 should generate accessibility identifiers on macOS")
    }
    
    // MARK: - Photo Selection Tests
    
    /// BUSINESS PURPOSE: Validates that platformPhotoSelection_L1 generates proper accessibility identifiers
    /// for automated testing and accessibility tools compliance on iOS
    func testPlatformPhotoSelectionL1GeneratesAccessibilityIdentifiersOnIOS() async {
        // Given
        let hints = PresentationHints(
            dataType: .media,
            presentationPreference: .automatic,
            complexity: .moderate,
            context: .modal,
            customPreferences: [:]
        )
        
        let view = platformPhotoSelection_L1(
            hints: hints,
            onPhotosSelected: { _ in },
            onError: { _ in }
        )
        
        // When & Then
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*photoselection", 
            platform: .iOS,
            componentName: "platformPhotoSelection_L1"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformPhotoSelection_L1 should generate accessibility identifiers on iOS")
    }
    
    /// BUSINESS PURPOSE: Validates that platformPhotoSelection_L1 generates proper accessibility identifiers
    /// for automated testing and accessibility tools compliance on macOS
    func testPlatformPhotoSelectionL1GeneratesAccessibilityIdentifiersOnMacOS() async {
        // Given
        let hints = PresentationHints(
            dataType: .media,
            presentationPreference: .automatic,
            complexity: .moderate,
            context: .modal,
            customPreferences: [:]
        )
        
        let view = platformPhotoSelection_L1(
            hints: hints,
            onPhotosSelected: { _ in },
            onError: { _ in }
        )
        
        // When & Then
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*photoselection", 
            platform: .macOS,
            componentName: "platformPhotoSelection_L1"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformPhotoSelection_L1 should generate accessibility identifiers on macOS")
    }
    
    // MARK: - Photo Display Tests
    
    /// BUSINESS PURPOSE: Validates that platformPhotoDisplay_L1 generates proper accessibility identifiers
    /// for automated testing and accessibility tools compliance on iOS
    func testPlatformPhotoDisplayL1GeneratesAccessibilityIdentifiersOnIOS() async {
        // Given
        let testPhotos = [PlatformImage(), PlatformImage()]
        let hints = PresentationHints(
            dataType: .media,
            presentationPreference: .automatic,
            complexity: .moderate,
            context: .modal,
            customPreferences: [:]
        )
        
        let view = platformPhotoDisplay_L1(
            photos: testPhotos,
            hints: hints,
            onPhotoSelected: { _ in },
            onPhotoDeleted: { _ in }
        )
        
        // When & Then
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*photodisplay", 
            platform: .iOS,
            componentName: "platformPhotoDisplay_L1"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformPhotoDisplay_L1 should generate accessibility identifiers on iOS")
    }
    
    /// BUSINESS PURPOSE: Validates that platformPhotoDisplay_L1 generates proper accessibility identifiers
    /// for automated testing and accessibility tools compliance on macOS
    func testPlatformPhotoDisplayL1GeneratesAccessibilityIdentifiersOnMacOS() async {
        // Given
        let testPhotos = [PlatformImage(), PlatformImage()]
        let hints = PresentationHints(
            dataType: .media,
            presentationPreference: .automatic,
            complexity: .moderate,
            context: .modal,
            customPreferences: [:]
        )
        
        let view = platformPhotoDisplay_L1(
            photos: testPhotos,
            hints: hints,
            onPhotoSelected: { _ in },
            onPhotoDeleted: { _ in }
        )
        
        // When & Then
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*photodisplay", 
            platform: .macOS,
            componentName: "platformPhotoDisplay_L1"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformPhotoDisplay_L1 should generate accessibility identifiers on macOS")
    }
}

// MARK: - Test Extensions
extension PlatformPhotoSemanticLayer1AccessibilityTests {
    override func await setupTestEnvironment() {
        TestSetupUtilities.shared.setupTestingEnvironment()
    }
    
    override func await cleanupTestEnvironment() {
        TestSetupUtilities.shared.setupTestingEnvironment()
    }
}
