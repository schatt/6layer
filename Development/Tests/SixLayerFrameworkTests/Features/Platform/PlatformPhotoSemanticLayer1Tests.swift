import Testing


import SwiftUI
@testable import SixLayerFramework
import ViewInspector
/// Tests for PlatformPhotoSemanticLayer1.swift
/// 
/// BUSINESS PURPOSE: Ensure all photo Layer 1 semantic functions generate proper accessibility identifiers
/// TESTING SCOPE: All functions in PlatformPhotoSemanticLayer1.swift
/// METHODOLOGY: Test each function on both iOS and macOS platforms as required by mandatory testing guidelines
@MainActor
open class PlatformPhotoSemanticLayer1Tests: BaseTestClass {
    
    // MARK: - Test Setup
    
    private func cleanupTestEnvironment() async {
        await AccessibilityTestUtilities.cleanupAccessibilityTestEnvironment()
    }
    
    @Test func testPlatformPhotoDisplayL1GeneratesAccessibilityIdentifiersOnIOS() async {
        
        
        // Given
        let preferences = PhotoPreferences(
            preferredSource: .camera,
            allowEditing: true,
            compressionQuality: 0.8
        )
        let capabilities = PhotoDeviceCapabilities(
            hasCamera: true,
            hasPhotoLibrary: true,
            supportsEditing: true
        )
        let context = PhotoContext(
            screenSize: CGSize(width: 375, height: 812),
            availableSpace: CGSize(width: 375, height: 400),
            userPreferences: preferences,
            deviceCapabilities: capabilities
        )
        
        // When
        let view = platformPhotoDisplay_L1(
            purpose: .document,
            context: context,
            image: nil
        )
        
        // Then
        #expect(view != nil, "platformPhotoDisplay_L1 should create a view")
        
        // Test accessibility identifier generation
        let hasAccessibilityID = await MainActor.run {
            testAccessibilityIdentifiersCrossPlatform(
                view, 
                expectedPattern: "SixLayer.*ui", 
                componentName: "platformPhotoDisplay_L1",
                testName: "PlatformTest"
            )
        }
        #expect(hasAccessibilityID, "platformPhotoDisplay_L1 should generate accessibility identifier on iOS")
        
        await cleanupTestEnvironment()
    }
    
    @Test func testPlatformPhotoDisplayL1GeneratesAccessibilityIdentifiersOnMacOS() async {
        
        
        // Given
        let preferences = PhotoPreferences(
            preferredSource: .camera,
            allowEditing: true,
            compressionQuality: 0.8
        )
        let capabilities = PhotoDeviceCapabilities(
            hasCamera: true,
            hasPhotoLibrary: true,
            supportsEditing: true
        )
        let context = PhotoContext(
            screenSize: CGSize(width: 1024, height: 768),
            availableSpace: CGSize(width: 1024, height: 400),
            userPreferences: preferences,
            deviceCapabilities: capabilities
        )
        
        // When
        let view = platformPhotoDisplay_L1(
            purpose: .document,
            context: context,
            image: nil
        )
        
        // Then
        #expect(view != nil, "platformPhotoDisplay_L1 should create a view")
        
        // Test accessibility identifier generation
        let hasAccessibilityID = await MainActor.run {
            testAccessibilityIdentifiersCrossPlatform(
                view, 
                expectedPattern: "SixLayer.*ui", 
                componentName: "platformPhotoDisplay_L1",
                testName: "PlatformTest"
            )
        }
        #expect(hasAccessibilityID, "platformPhotoDisplay_L1 should generate accessibility identifier on macOS")
        
        await cleanupTestEnvironment()
    }
}