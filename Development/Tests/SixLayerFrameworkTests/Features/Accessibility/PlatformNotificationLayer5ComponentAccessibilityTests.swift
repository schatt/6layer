import Testing


//
//  PlatformNotificationLayer5ComponentAccessibilityTests.swift
//  SixLayerFrameworkTests
//
//  Comprehensive accessibility tests for ALL Platform Notification Layer 5 Components
//

import SwiftUI
@testable import SixLayerFramework

/// NOTE: Not marked @MainActor on class to allow parallel execution
@Suite("Platform Notification Layer Component Accessibility")
open class PlatformNotificationLayer5ComponentAccessibilityTests: BaseTestClass {
    
    // MARK: - Platform Notification Layer 5 Component Tests
    
    @Test @MainActor func testPlatformNotificationLayer5GeneratesAccessibilityIdentifiers() async {
        // Given: PlatformNotificationLayer5
        let testView = PlatformNotificationLayer5()
        
        // Then: Should generate accessibility identifiers
            // TODO: ViewInspector Detection Issue - VERIFIED: PlatformNotificationLayer5 DOES have .automaticCompliance() 
            // modifier applied in Framework/Sources/Layers/Layer5-Platform/PlatformNotificationLayer5.swift:16.
            // The test needs to be updated to handle ViewInspector's inability to detect these modifiers reliably.
            // This is a ViewInspector limitation, not a missing modifier issue.
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            testView,
            expectedPattern: "SixLayer.main.ui.*",
            platform: SixLayerPlatform.iOS,
            componentName: "PlatformNotificationLayer5"
        )
 #expect(hasAccessibilityID, "PlatformNotificationLayer5 should generate accessibility identifiers ")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }
}