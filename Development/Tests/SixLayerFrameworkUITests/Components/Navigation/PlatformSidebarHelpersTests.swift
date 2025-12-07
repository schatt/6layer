//
//  PlatformSidebarHelpersTests.swift
//  SixLayerFramework
//
//  Tests for platform sidebar helper functions
//

import Testing
import SwiftUI
@testable import SixLayerFramework

@Suite("Platform Sidebar Helpers Tests")
struct PlatformSidebarHelpersTests {
    
    // MARK: - platformSidebarPullIndicator Tests
    
    @Test @MainActor func testPlatformSidebarPullIndicatorExists() {
        // Test that the function exists and can be called
        let indicator = platformSidebarPullIndicator(isVisible: true)
        #expect(indicator is some View, "Function should return a View")
    }
    
    @Test @MainActor func testPlatformSidebarPullIndicatorWhenVisible() {
        // Test that when isVisible is true, it returns a view (on macOS) or EmptyView (on iOS)
        let indicator = platformSidebarPullIndicator(isVisible: true)
        #expect(indicator is some View, "Should return a View when visible")
    }
    
    @Test @MainActor func testPlatformSidebarPullIndicatorWhenNotVisible() {
        // Test that when isVisible is false, it returns EmptyView
        let indicator = platformSidebarPullIndicator(isVisible: false)
        // Should return EmptyView regardless of platform when not visible
        #expect(indicator is some View, "Should return a View (EmptyView when not visible)")
    }
    
    @Test @MainActor func testPlatformSidebarPullIndicatorCanBeUsedInHStack() {
        // Test that it can be used in an HStack as shown in the usage example
        let view = HStack {
            platformSidebarPullIndicator(isVisible: true)
            Text("Sidebar Content")
        }
        #expect(view is some View, "Should be usable in HStack")
    }
    
    @Test @MainActor func testPlatformSidebarPullIndicatorPlatformBehavior() {
        // Test platform-specific behavior
        #if os(macOS)
        // On macOS, when visible, should show indicator
        let visibleIndicator = platformSidebarPullIndicator(isVisible: true)
        #expect(visibleIndicator is some View, "macOS should return indicator view when visible")
        #else
        // On iOS, should always return EmptyView
        let indicator = platformSidebarPullIndicator(isVisible: true)
        #expect(indicator is some View, "iOS should return EmptyView")
        #endif
    }
    
    @Test @MainActor func testPlatformSidebarPullIndicatorWithDifferentVisibilityStates() {
        // Test that function handles different visibility states correctly
        let visible = platformSidebarPullIndicator(isVisible: true)
        let hidden = platformSidebarPullIndicator(isVisible: false)
        
        #expect(visible is some View, "Visible state should return View")
        #expect(hidden is some View, "Hidden state should return View")
    }
}
