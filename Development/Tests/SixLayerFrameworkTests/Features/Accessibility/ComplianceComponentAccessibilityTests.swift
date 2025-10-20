import Testing


//
//  ComplianceComponentAccessibilityTests.swift
//  SixLayerFrameworkTests
//
//  Comprehensive accessibility tests for ALL Compliance Components
//

import SwiftUI
@testable import SixLayerFramework

@MainActor
open class ComplianceComponentAccessibilityTests: BaseTestClass {
    
    // MARK: - Compliance Component Tests
    
    @Test func testPlatformComplianceGeneratesAccessibilityIdentifiers() async {
        // Given: PlatformCompliance
        let testView = PlatformCompliance()
        
        // Then: Should generate accessibility identifiers
        let hasAccessibilityID = hasAccessibilityIdentifier(
            testView,
            expectedPattern: "*.main.element.*",
            componentName: "PlatformCompliance"
        )
        
        #expect(hasAccessibilityID, "PlatformCompliance should generate accessibility identifiers")
    }
    
    @Test func testPlatformAuditGeneratesAccessibilityIdentifiers() async {
        // Given: PlatformAudit
        let testView = PlatformAudit()
        
        // Then: Should generate accessibility identifiers
        let hasAccessibilityID = hasAccessibilityIdentifier(
            testView,
            expectedPattern: "*.main.element.*",
            componentName: "PlatformAudit"
        )
        
        #expect(hasAccessibilityID, "PlatformAudit should generate accessibility identifiers")
    }
    
    @Test func testAppleHIGComplianceGeneratesAccessibilityIdentifiers() async {
        // Given: AppleHIGCompliance
        let testView = AppleHIGCompliance()
        
        // Then: Should generate accessibility identifiers
        let hasAccessibilityID = hasAccessibilityIdentifier(
            testView,
            expectedPattern: "*.main.element.*",
            componentName: "AppleHIGCompliance"
        )
        
        #expect(hasAccessibilityID, "AppleHIGCompliance should generate accessibility identifiers")
    }
}

