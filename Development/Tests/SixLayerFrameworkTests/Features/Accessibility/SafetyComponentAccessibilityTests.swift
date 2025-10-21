import Testing


//
//  SafetyComponentAccessibilityTests.swift
//  SixLayerFrameworkTests
//
//  Comprehensive accessibility tests for ALL Safety Components
//

import SwiftUI
@testable import SixLayerFramework

@MainActor
open class SafetyComponentAccessibilityTests: BaseTestClass {
    
    // MARK: - Safety Component Tests
    
    @Test func testVisionSafetyGeneratesAccessibilityIdentifiers() async {
        // Given: VisionSafety
        let testView = VisionSafety()
        
        // Then: Should generate accessibility identifiers
        let hasAccessibilityID = hasAccessibilityIdentifierPattern(
            testView,
            expectedPattern: "*.main.element.*",
            platform: .iOS,
            componentName: "VisionSafety"
        )
        
        #expect(hasAccessibilityID, "VisionSafety should generate accessibility identifiers")
    }
    
    @Test func testPlatformSafetyGeneratesAccessibilityIdentifiers() async {
        // Given: PlatformSafety
        let testView = PlatformSafety()
        
        // Then: Should generate accessibility identifiers
        let hasAccessibilityID = hasAccessibilityIdentifierPattern(
            testView,
            expectedPattern: "*.main.element.*",
            platform: .iOS,
            componentName: "PlatformSafety"
        )
        
        #expect(hasAccessibilityID, "PlatformSafety should generate accessibility identifiers")
    }
    
    @Test func testPlatformSecurityGeneratesAccessibilityIdentifiers() async {
        // Given: PlatformSecurity
        let testView = PlatformSecurity()
        
        // Then: Should generate accessibility identifiers
        let hasAccessibilityID = hasAccessibilityIdentifierPattern(
            testView,
            expectedPattern: "*.main.element.*",
            platform: .iOS,
            componentName: "PlatformSecurity"
        )
        
        #expect(hasAccessibilityID, "PlatformSecurity should generate accessibility identifiers")
    }
    
    @Test func testPlatformPrivacyGeneratesAccessibilityIdentifiers() async {
        // Given: PlatformPrivacy
        let testView = PlatformPrivacy()
        
        // Then: Should generate accessibility identifiers
        let hasAccessibilityID = hasAccessibilityIdentifierPattern(
            testView,
            expectedPattern: "*.main.element.*",
            platform: .iOS,
            componentName: "PlatformPrivacy"
        )
        
        #expect(hasAccessibilityID, "PlatformPrivacy should generate accessibility identifiers")
    }
}

