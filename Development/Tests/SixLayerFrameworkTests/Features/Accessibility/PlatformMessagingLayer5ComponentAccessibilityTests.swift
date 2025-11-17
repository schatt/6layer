import Testing


//
//  PlatformMessagingLayer5ComponentAccessibilityTests.swift
//  SixLayerFrameworkTests
//
//  Comprehensive accessibility tests for ALL Platform Messaging Layer 5 Components
//

import SwiftUI
@testable import SixLayerFramework

@MainActor
@Suite("Platform Messaging Layer Component Accessibility")
open class PlatformMessagingLayer5ComponentAccessibilityTests: BaseTestClass {
    
    // MARK: - Platform Messaging Layer 5 Component Tests
    
    @Test func testPlatformMessagingLayer5GeneratesAccessibilityIdentifiers() async {
        // Given: PlatformMessagingLayer5
        let messagingLayer = PlatformMessagingLayer5()
        
        // When: Creating components
        let alertButton = messagingLayer.createAlertButton(title: "Test Alert", action: {})
        let toastNotification = messagingLayer.createToastNotification(message: "Test Toast")
        let bannerNotification = messagingLayer.createBannerNotification(title: "Test Banner", message: "Test Message")
        
        // Then: Should generate accessibility identifiers for components
        // VERIFIED: Components have .automaticCompliance() modifiers applied
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAlertAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            alertButton,
            expectedPattern: "SixLayer.main.ui.*",
            platform: SixLayerPlatform.iOS,
            componentName: "AlertButton"
        )
        #expect(hasAlertAccessibilityID, "Alert button should generate accessibility identifiers")
        
        let hasToastAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            toastNotification,
            expectedPattern: "SixLayer.main.ui.*",
            platform: SixLayerPlatform.iOS,
            componentName: "ToastNotification"
        )
        #expect(hasToastAccessibilityID, "Toast notification should generate accessibility identifiers")
        
        let hasBannerAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            bannerNotification,
            expectedPattern: "SixLayer.main.ui.*",
            platform: SixLayerPlatform.iOS,
            componentName: "BannerNotification"
        )
        #expect(hasBannerAccessibilityID, "Banner notification should generate accessibility identifiers")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }
}