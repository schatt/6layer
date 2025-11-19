import Testing


//
//  PlatformMaintenanceLayer5ComponentAccessibilityTests.swift
//  SixLayerFrameworkTests
//
//  Comprehensive accessibility tests for ALL Platform Maintenance Layer 5 Components
//

import SwiftUI
@testable import SixLayerFramework

/// NOTE: Not marked @MainActor on class to allow parallel execution
@Suite("Platform Maintenance Layer Component Accessibility")
open class PlatformMaintenanceLayer5ComponentAccessibilityTests: BaseTestClass {
    
    // MARK: - Platform Maintenance Layer 5 Component Tests
    
    @Test @MainActor func testPlatformMaintenanceLayer5GeneratesAccessibilityIdentifiers() async {
        initializeTestConfig()
        // Given: PlatformMaintenanceLayer5
        let testView = PlatformMaintenanceLayer5()
        
        // Then: Should generate accessibility identifiers
        // VERIFIED: PlatformMaintenanceLayer5 DOES have .automaticCompliance() 
        // modifier applied in Framework/Sources/Layers/Layer5-Platform/PlatformMaintenanceLayer5.swift:26.
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            testView,
            expectedPattern: "SixLayer.main.ui.*",
            platform: SixLayerPlatform.iOS,
            componentName: "PlatformMaintenanceLayer5"
        )
        #expect(hasAccessibilityID, "PlatformMaintenanceLayer5 should generate accessibility identifiers")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }
}