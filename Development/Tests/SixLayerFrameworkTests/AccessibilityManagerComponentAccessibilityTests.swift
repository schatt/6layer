//
//  AccessibilityManagerComponentAccessibilityTests.swift
//  SixLayerFrameworkTests
//
//  Comprehensive accessibility tests for ALL AccessibilityManager components
//

import XCTest
import SwiftUI
@testable import SixLayerFramework

@MainActor
final class AccessibilityManagerComponentAccessibilityTests: XCTestCase {
    
    // MARK: - AccessibilityManager Tests
    
    func testAccessibilityManagerGeneratesAccessibilityIdentifiers() async {
        // Given: AccessibilityManager
        let manager = AccessibilityManager()
        
        // When: Creating a view with AccessibilityManager
        let view = VStack {
            Text("Accessibility Manager Content")
        }
        .environmentObject(manager)
        
        // Then: Should generate accessibility identifiers
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view,
            expectedPattern: "*.main.element.*",
            componentName: "AccessibilityManager"
        )
        
        XCTAssertTrue(hasAccessibilityID, "AccessibilityManager should generate accessibility identifiers")
    }
}



