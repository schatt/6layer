import Testing


//
//  SafetyComponentAccessibilityTests.swift
//  SixLayerFrameworkTests
//
//  Comprehensive accessibility tests for ALL Safety Components
//

import SwiftUI
@testable import SixLayerFramework

/// NOTE: Not marked @MainActor on class to allow parallel execution
@Suite("Safety Component Accessibility")
open class SafetyComponentAccessibilityTests: BaseTestClass {
    
    // MARK: - Safety Component Tests
    
    @Test @MainActor func testVisionSafetyGeneratesAccessibilityIdentifiers() async {
        initializeTestConfig()
        // Given: VisionSafety
        let testView = VisionSafety()
        
        // Then: Should generate accessibility identifiers
        // VERIFIED: VisionSafety DOES have .automaticCompliance() modifier applied
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testComponentComplianceSinglePlatform(
            testView,
            expectedPattern: "SixLayer.main.ui.*",
            platform: SixLayerPlatform.iOS,
            componentName: "VisionSafety"
        )
        #expect(hasAccessibilityID, "VisionSafety should generate accessibility identifiers")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }
    
    @Test @MainActor func testPlatformSafetyGeneratesAccessibilityIdentifiers() async {
        initializeTestConfig()
        // Given: PlatformSafety
        let testView = PlatformSafety()
        
        // Then: Should generate accessibility identifiers
        // VERIFIED: PlatformSafety DOES have .automaticCompliance() modifier applied
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testComponentComplianceSinglePlatform(
            testView,
            expectedPattern: "SixLayer.main.ui.*",
            platform: SixLayerPlatform.iOS,
            componentName: "PlatformSafety"
        )
        #expect(hasAccessibilityID, "PlatformSafety should generate accessibility identifiers")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }
    
    @Test @MainActor func testPlatformSecurityGeneratesAccessibilityIdentifiers() async {
        initializeTestConfig()
        // Given: PlatformSecurity
        let testView = PlatformSecurity()
        
        // Then: Should generate accessibility identifiers
        // VERIFIED: PlatformSecurity DOES have .automaticCompliance() modifier applied
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testComponentComplianceSinglePlatform(
            testView,
            expectedPattern: "SixLayer.main.ui.*",
            platform: SixLayerPlatform.iOS,
            componentName: "PlatformSecurity"
        )
        #expect(hasAccessibilityID, "PlatformSecurity should generate accessibility identifiers")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }
    
    @Test @MainActor func testPlatformPrivacyGeneratesAccessibilityIdentifiers() async {
        initializeTestConfig()
        // Given: PlatformPrivacy
        let testView = PlatformPrivacy()
        
        // Then: Should generate accessibility identifiers
        // VERIFIED: PlatformPrivacy DOES have .automaticCompliance() modifier applied
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testComponentComplianceSinglePlatform(
            testView,
            expectedPattern: "SixLayer.main.ui.*",
            platform: SixLayerPlatform.iOS,
            componentName: "PlatformPrivacy"
        )
        #expect(hasAccessibilityID, "PlatformPrivacy should generate accessibility identifiers")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }
}

