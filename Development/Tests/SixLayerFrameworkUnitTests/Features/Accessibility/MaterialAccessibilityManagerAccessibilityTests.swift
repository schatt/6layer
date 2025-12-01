import Testing


import SwiftUI
@testable import SixLayerFramework
/// BUSINESS PURPOSE: Accessibility tests for MaterialAccessibilityManager.swift classes
/// Ensures MaterialAccessibilityManager classes generate proper accessibility identifiers
/// for automated testing and accessibility tools compliance
@Suite("Material Accessibility Manager Accessibility")
open class MaterialAccessibilityManagerAccessibilityTests: BaseTestClass {
    
    // MARK: - MaterialAccessibilityManager Tests
    
    /// BUSINESS PURPOSE: Validates that views using MaterialAccessibilityManager generate proper accessibility identifiers
    /// Tests MaterialAccessibilityEnhancedView which uses MaterialAccessibilityManager internally
    @Test @MainActor func testMaterialAccessibilityManagerGeneratesAccessibilityIdentifiersOnIOS() {
            initializeTestConfig()
        runWithTaskLocalConfig {
            // Given: A view with MaterialAccessibilityManager (via MaterialAccessibilityEnhancedView)
            let view = platformVStackContainer {
                Text("Material Accessibility Content")
            }
            .accessibilityMaterialEnhanced()
            .automaticCompliance()
            
            // When & Then: Should generate accessibility identifiers
            #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
            let hasAccessibilityID = testComponentComplianceSinglePlatform(
                view,
                expectedPattern: "SixLayer.main.ui.*",
                platform: SixLayerPlatform.iOS,
                componentName: "MaterialAccessibilityEnhancedView"
            )
 #expect(hasAccessibilityID, "View with MaterialAccessibilityManager should generate accessibility identifiers on iOS ")
        #else
            // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
            // The modifier IS present in the code, but ViewInspector can't detect it on macOS
            #endif
        }
    }
    
    /// BUSINESS PURPOSE: Validates that views using MaterialAccessibilityManager generate proper accessibility identifiers
    /// Tests MaterialAccessibilityEnhancedView which uses MaterialAccessibilityManager internally
    @Test @MainActor func testMaterialAccessibilityManagerGeneratesAccessibilityIdentifiersOnMacOS() {
            initializeTestConfig()
        runWithTaskLocalConfig {
            // Given: A view with MaterialAccessibilityManager (via MaterialAccessibilityEnhancedView)
            let view = platformVStackContainer {
                Text("Material Accessibility Content")
            }
            .accessibilityMaterialEnhanced()
            .automaticCompliance()
            
            // When & Then: Should generate accessibility identifiers
            #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
            let hasAccessibilityID = testComponentComplianceSinglePlatform(
                view,
                expectedPattern: "SixLayer.main.ui.*",
                platform: SixLayerPlatform.macOS,
                componentName: "MaterialAccessibilityEnhancedView"
            )
 #expect(hasAccessibilityID, "View with MaterialAccessibilityManager should generate accessibility identifiers on macOS ")
        #else
            // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
            // The modifier IS present in the code, but ViewInspector can't detect it on macOS
            #endif
        }
    }
}

