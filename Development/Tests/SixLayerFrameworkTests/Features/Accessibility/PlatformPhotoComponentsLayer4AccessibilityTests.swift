import Testing
import SwiftUI
import ViewInspector
@testable import SixLayerFramework

/// BUSINESS PURPOSE: Accessibility tests for PlatformPhotoComponentsLayer4.swift functions
/// Ensures Photo components Layer 4 functions generate proper accessibility identifiers
/// for automated testing and accessibility tools compliance
final class PlatformPhotoComponentsLayer4AccessibilityTests {
    
    init() async throws {
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
    
    deinit {
        await cleanupTestEnvironment()
        await MainActor.run {
            let config = AccessibilityIdentifierConfig.shared
            config.resetToDefaults()
        }
        try await super.tearDown()
    }
    
    // MARK: - Photo Picker Tests
    
    /// BUSINESS PURPOSE: Validates that platformPhotoPicker_L4 generates proper accessibility identifiers
    /// for automated testing and accessibility tools compliance on iOS
    @Test func testPlatformPhotoPickerL4GeneratesAccessibilityIdentifiersOnIOS() async {
        // Given
        let view = platformPhotoPicker_L4(
            onImageSelected: { _ in }
        )
        
        // When & Then
        let hasAccessibilityID = await MainActor.run {
            hasAccessibilityIdentifier(
                view, 
                expectedPattern: "SixLayer.main.element.*", 
                platform: .iOS,
                componentName: "platformPhotoPicker_L4"
            )
        }
        
        #expect(hasAccessibilityID, "platformPhotoPicker_L4 should generate accessibility identifiers on iOS")
    }
    
    /// BUSINESS PURPOSE: Validates that platformPhotoPicker_L4 generates proper accessibility identifiers
    /// for automated testing and accessibility tools compliance on macOS
    @Test func testPlatformPhotoPickerL4GeneratesAccessibilityIdentifiersOnMacOS() async {
        // Given
        let view = platformPhotoPicker_L4(
            onImageSelected: { _ in }
        )
        
        // When & Then
        let hasAccessibilityID = await MainActor.run {
            hasAccessibilityIdentifier(
                view, 
                expectedPattern: "SixLayer.main.element.*", 
                platform: .macOS,
                componentName: "platformPhotoPicker_L4"
            )
        }
        
        #expect(hasAccessibilityID, "platformPhotoPicker_L4 should generate accessibility identifiers on macOS")
    }
    
    // MARK: - Photo Display Tests
    
    /// BUSINESS PURPOSE: Validates that platformPhotoDisplay_L4 generates proper accessibility identifiers
    /// for automated testing and accessibility tools compliance on iOS
    @Test func testPlatformPhotoDisplayL4GeneratesAccessibilityIdentifiersOnIOS() async {
        // Given
        let view = platformPhotoDisplay_L4(
            image: PlatformImage(),
            style: .thumbnail
        )
        
        // When & Then
        let hasAccessibilityID = await MainActor.run {
            hasAccessibilityIdentifier(
                view, 
                expectedPattern: "SixLayer.main.element.*", 
                platform: .iOS,
                componentName: "platformPhotoDisplay_L4"
            )
        }
        
        #expect(hasAccessibilityID, "platformPhotoDisplay_L4 should generate accessibility identifiers on iOS")
    }
    
    /// BUSINESS PURPOSE: Validates that platformPhotoDisplay_L4 generates proper accessibility identifiers
    /// for automated testing and accessibility tools compliance on macOS
    @Test func testPlatformPhotoDisplayL4GeneratesAccessibilityIdentifiersOnMacOS() async {
        // Given
        let view = platformPhotoDisplay_L4(
            image: PlatformImage(),
            style: .thumbnail
        )
        
        // When & Then
        let hasAccessibilityID = await MainActor.run {
            hasAccessibilityIdentifier(
                view, 
                expectedPattern: "SixLayer.main.element.*", 
                platform: .macOS,
                componentName: "platformPhotoDisplay_L4"
            )
        }
        
        #expect(hasAccessibilityID, "platformPhotoDisplay_L4 should generate accessibility identifiers on macOS")
    }
    
    // MARK: - Photo Editor Tests
    
    /// BUSINESS PURPOSE: Validates that platformPhotoEditor_L4 generates proper accessibility identifiers
    /// for automated testing and accessibility tools compliance on iOS
    @Test func testPlatformPhotoEditorL4GeneratesAccessibilityIdentifiersOnIOS() async {
        // Given
        let testPhoto = PlatformImage()
        
        let view = platformPhotoEditor_L4(
            image: testPhoto,
            onImageEdited: { _ in }
        )
        
        // When & Then
        let hasAccessibilityID = await MainActor.run {
            hasAccessibilityIdentifier(
                view, 
                expectedPattern: "SixLayer.main.element.*", 
                platform: .iOS,
                componentName: "platformPhotoEditor_L4"
            )
        }
        
        #expect(hasAccessibilityID, "platformPhotoEditor_L4 should generate accessibility identifiers on iOS")
    }
    
    /// BUSINESS PURPOSE: Validates that platformPhotoEditor_L4 generates proper accessibility identifiers
    /// for automated testing and accessibility tools compliance on macOS
    @Test func testPlatformPhotoEditorL4GeneratesAccessibilityIdentifiersOnMacOS() async {
        // Given
        let testPhoto = PlatformImage()
        
        let view = platformPhotoEditor_L4(
            image: testPhoto,
            onImageEdited: { _ in }
        )
        
        // When & Then
        let hasAccessibilityID = await MainActor.run {
            hasAccessibilityIdentifier(
                view, 
                expectedPattern: "SixLayer.main.element.*", 
                platform: .macOS,
                componentName: "platformPhotoEditor_L4"
            )
        }
        
        #expect(hasAccessibilityID, "platformPhotoEditor_L4 should generate accessibility identifiers on macOS")
    }
}

// MARK: - Test Extensions
extension PlatformPhotoComponentsLayer4AccessibilityTests {
    override func setupTestEnvironment() {
        TestSetupUtilities.shared.setupTestingEnvironment()
    }
    
    override func cleanupTestEnvironment() {
        TestSetupUtilities.shared.setupTestingEnvironment()
    }
}
