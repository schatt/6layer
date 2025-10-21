import Testing


//
//  PlatformPhotoComponentsLayer4ComponentAccessibilityTests.swift
//  SixLayerFrameworkTests
//
//  Comprehensive accessibility tests for ALL Platform Photo Components Layer 4
//

import SwiftUI
@testable import SixLayerFramework

@MainActor
open class PlatformPhotoComponentsLayer4ComponentAccessibilityTests: BaseTestClass {
    
    // MARK: - Platform Photo Components Layer 4 Tests
    
    @Test func testPlatformPhotoComponentsLayer4GeneratesAccessibilityIdentifiers() async {
        // Given: PlatformPhotoComponentsLayer4
        let photoComponents = PlatformPhotoComponentsLayer4()
        
        // When: Get a view from the component
        let testView = photoComponents.platformPhotoPicker_L4(onImageSelected: { _ in })
        
        // Then: Should generate accessibility identifiers
        let hasAccessibilityID = hasAccessibilityIdentifierPattern(
            testView,
            expectedPattern: "*.main.element.*",
            componentName: "PlatformPhotoComponentsLayer4"
        )
        
        #expect(hasAccessibilityID, "PlatformPhotoComponentsLayer4 should generate accessibility identifiers")
    }
}

