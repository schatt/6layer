import Testing


import SwiftUI
@testable import SixLayerFramework
import ViewInspector
/// BUSINESS PURPOSE: Accessibility tests for MaterialAccessibilityManager.swift classes
/// Ensures MaterialAccessibilityManager classes generate proper accessibility identifiers
/// for automated testing and accessibility tools compliance
@Suite("Material Accessibility Manager Accessibility")
open class MaterialAccessibilityManagerAccessibilityTests: BaseTestClass {
    
    // MARK: - MaterialAccessibilityManager Tests
    
    /// BUSINESS PURPOSE: Validates that views using MaterialAccessibilityManager generate proper accessibility identifiers
    /// Tests MaterialAccessibilityEnhancedView which uses MaterialAccessibilityManager internally
    @Test func testMaterialAccessibilityManagerGeneratesAccessibilityIdentifiersOnIOS() {
        runWithTaskLocalConfig {
            // Given: A view with MaterialAccessibilityManager (via MaterialAccessibilityEnhancedView)
            let view = VStack {
                Text("Material Accessibility Content")
            }
            .accessibilityMaterialEnhanced()
            .automaticAccessibilityIdentifiers()
            
            // When & Then: Should generate accessibility identifiers
            let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
                view,
                expectedPattern: "SixLayer.main.ui.*",
                platform: SixLayerPlatform.iOS,
                componentName: "MaterialAccessibilityEnhancedView"
            )
            
            #expect(hasAccessibilityID, "View with MaterialAccessibilityManager should generate accessibility identifiers on iOS")
        }
    }
    
    /// BUSINESS PURPOSE: Validates that views using MaterialAccessibilityManager generate proper accessibility identifiers
    /// Tests MaterialAccessibilityEnhancedView which uses MaterialAccessibilityManager internally
    @Test func testMaterialAccessibilityManagerGeneratesAccessibilityIdentifiersOnMacOS() {
        runWithTaskLocalConfig {
            // Given: A view with MaterialAccessibilityManager (via MaterialAccessibilityEnhancedView)
            let view = VStack {
                Text("Material Accessibility Content")
            }
            .accessibilityMaterialEnhanced()
            .automaticAccessibilityIdentifiers()
            
            // When & Then: Should generate accessibility identifiers
            let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
                view,
                expectedPattern: "SixLayer.main.ui.*",
                platform: SixLayerPlatform.macOS,
                componentName: "MaterialAccessibilityEnhancedView"
            )
            
            #expect(hasAccessibilityID, "View with MaterialAccessibilityManager should generate accessibility identifiers on macOS")
        }
    }
}

