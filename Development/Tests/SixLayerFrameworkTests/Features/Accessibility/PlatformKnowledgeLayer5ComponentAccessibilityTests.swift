import Testing


//
//  PlatformKnowledgeLayer5ComponentAccessibilityTests.swift
//  SixLayerFrameworkTests
//
//  Comprehensive accessibility tests for ALL Platform Knowledge Layer 5 Components
//

import SwiftUI
@testable import SixLayerFramework

@MainActor
@Suite("Platform Knowledge Layer Component Accessibility")
open class PlatformKnowledgeLayer5ComponentAccessibilityTests: BaseTestClass {
    
    // MARK: - Platform Knowledge Layer 5 Component Tests
    
    @Test func testPlatformKnowledgeLayer5GeneratesAccessibilityIdentifiers() async {
        // Given: PlatformKnowledgeLayer5
        let testView = PlatformKnowledgeLayer5()
        
        // Then: Should generate accessibility identifiers with component name
            // TODO: ViewInspector Detection Issue - VERIFIED: PlatformKnowledgeLayer5 DOES have .automaticCompliance() 
            // modifier applied in Framework/Sources/Layers/Layer5-Platform/PlatformKnowledgeLayer5.swift:32.
            // The test needs to be updated to handle ViewInspector's inability to detect these modifiers reliably.
            // This is a ViewInspector limitation, not a missing modifier issue.
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            testView,
            expectedPattern: "SixLayer.main.ui.*PlatformKnowledgeLayer5.*",
            platform: SixLayerPlatform.iOS,
            componentName: "PlatformKnowledgeLayer5"
        )
 #expect(hasAccessibilityID, "PlatformKnowledgeLayer5 should generate accessibility identifiers with component name ")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }
}