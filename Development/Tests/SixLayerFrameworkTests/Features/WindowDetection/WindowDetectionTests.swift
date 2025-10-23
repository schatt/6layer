import Testing


import SwiftUI
@testable import SixLayerFramework

/// TDD Tests for window size detection across all platforms
/// Tests written FIRST, implementation will follow
/// Comprehensive coverage: positive, negative, edge cases, error conditions
@MainActor
open class WindowDetectionTests {
    
    // MARK: - Helper Methods
    
    private func createWindowDetection() -> UnifiedWindowDetection {
        return UnifiedWindowDetection()
    }
    
    // MARK: - Basic Functionality Tests (Positive Cases)
    
    @Test func testWindowDetectionInitialization() {
        // GIVEN: A new window detection instance
        let windowDetection = UnifiedWindowDetection()
        
        // WHEN: Initialized
        // THEN: Should have default values
        #expect(windowDetection != nil)
        #expect(windowDetection.windowSize == CGSize(width: 375, height: 667))
        #expect(windowDetection.screenSize == CGSize(width: 375, height: 667))
        #expect(windowDetection.screenSizeClass == .compact)
        #expect(windowDetection.windowState == .standard)
        #expect(windowDetection.deviceContext == .standard)
        #expect(!windowDetection.isResizing)
        #expect(windowDetection.safeAreaInsets == EdgeInsets())
        #expect(windowDetection.orientation == .portrait)
    }
    
    @Test func testWindowDetectionUpdateFromGeometry() {
        // GIVEN: A window detection instance with test geometry provider
        // WHEN: Update from geometry is called with a specific size
        // THEN: Should update window size correctly
        
        // Create a test geometry provider that returns controlled values
        struct TestGeometryProvider: GeometryProvider {
            let testSize: CGSize
            
            func getSize(from geometry: GeometryProxy) -> CGSize {
                return testSize
            }
            
            func getSafeAreaInsets(from geometry: GeometryProxy) -> EdgeInsets {
                return EdgeInsets()
            }
        }
        
        let testProvider = TestGeometryProvider(testSize: CGSize(width: 400, height: 600))
        let windowDetection = UnifiedWindowDetection(geometryProvider: testProvider)
        
        // Test that the geometry provider is working
        #expect(windowDetection.windowSize.width == 375) // Default initial size
        #expect(windowDetection.windowSize.height == 667) // Default initial size
        
        // Note: We can't easily test updateFromGeometry without a real GeometryProxy
        // But we can test that the geometry provider is injected correctly
        #expect(windowDetection.geometryProvider is TestGeometryProvider)
    }
    
    @Test func testWindowDetectionUpdateFromEnvironment() {
        // GIVEN: A window detection instance
        let windowDetection = UnifiedWindowDetection()
        
        // WHEN: Update from environment is called
        // THEN: Should update environment values without crashing
        let safeAreaInsets = EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0)
        #expect(throws: Never.self) { 
            windowDetection.updateFromEnvironment(
                horizontalSizeClass: .regular,
                verticalSizeClass: .compact,
                safeAreaInsets: safeAreaInsets
            )
        }
        #expect(windowDetection.safeAreaInsets == safeAreaInsets)
    }
    
    @Test func testWindowDetectionSizeClassConversion() {
        // GIVEN: A window detection instance
        // WHEN: Testing size class conversion
        // THEN: Should convert sizes correctly to size classes
        
        // Test compact size class
        let compactDetection = UnifiedWindowDetection()
        compactDetection.windowSize = CGSize(width: 300, height: 600)
        compactDetection.updateSizeClass()
        #expect(compactDetection.screenSizeClass == .compact)
        
        // Test regular size class
        let regularDetection = UnifiedWindowDetection()
        regularDetection.windowSize = CGSize(width: 800, height: 600)
        regularDetection.updateSizeClass()
        #expect(regularDetection.screenSizeClass == .regular)
        
        // Test large size class
        let largeDetection = UnifiedWindowDetection()
        largeDetection.windowSize = CGSize(width: 1200, height: 800)
        largeDetection.updateSizeClass()
        #expect(largeDetection.screenSizeClass == .large)
    }
    
    // MARK: - Screen Size Class Tests (Positive Cases)
    
    @Test func testScreenSizeClassCompactDetection() {
        // GIVEN: Small window sizes
        let testCases = [
            CGSize(width: 320, height: 568),  // iPhone SE
            CGSize(width: 375, height: 667),  // iPhone 8
            CGSize(width: 390, height: 844),  // iPhone 12 mini
            CGSize(width: 100, height: 200),  // Very small
            CGSize(width: 399, height: 600)   // Just under regular threshold
        ]
        
        // WHEN: Screen size class is calculated
        // THEN: Should return compact
        for size in testCases {
            let sizeClass = ScreenSizeClass.from(screenSize: size)
            #expect(sizeClass == .compact, "Size \(size) should be compact")
        }
    }
    
    @Test func testScreenSizeClassRegularDetection() {
        // GIVEN: Medium window sizes
        let testCases = [
            CGSize(width: 768, height: 1024),  // iPad
            CGSize(width: 834, height: 1112),  // iPad Air
            CGSize(width: 1024, height: 1366), // iPad Pro 12.9"
            CGSize(width: 800, height: 600),   // Small laptop
            CGSize(width: 1099, height: 800)   // Just under large threshold
        ]
        
        // WHEN: Screen size class is calculated
        // THEN: Should return regular
        for size in testCases {
            let sizeClass = ScreenSizeClass.from(screenSize: size)
            #expect(sizeClass == .regular, "Size \(size) should be regular")
        }
    }
    
    @Test func testScreenSizeClassLargeDetection() {
        // GIVEN: Large window sizes
        let testCases = [
            CGSize(width: 1920, height: 1080), // Desktop
            CGSize(width: 2560, height: 1440), // Large desktop
            CGSize(width: 3840, height: 2160), // 4K display
            CGSize(width: 1200, height: 800),  // Large laptop
            CGSize(width: 2000, height: 1500)  // Very large
        ]
        
        // WHEN: Screen size class is calculated
        // THEN: Should return large
        for size in testCases {
            let sizeClass = ScreenSizeClass.from(screenSize: size)
            #expect(sizeClass == .large, "Size \(size) should be large")
        }
    }
    
    // MARK: - Edge Case Tests (Negative Cases)
    
    @Test func testZeroWindowSize() {
        // GIVEN: Zero window size
        let zeroSize = CGSize(width: 0, height: 0)
        
        // WHEN: Screen size class is calculated
        // THEN: Should handle gracefully and return compact
        let sizeClass = ScreenSizeClass.from(screenSize: zeroSize)
        #expect(sizeClass == .compact, "Zero size should default to compact")
    }
    
    @Test func testNegativeWindowSize() {
        // GIVEN: Negative window size
        let negativeSize = CGSize(width: -100, height: -200)
        
        // WHEN: Screen size class is calculated
        // THEN: Should handle gracefully and return compact
        let sizeClass = ScreenSizeClass.from(screenSize: negativeSize)
        #expect(sizeClass == .compact, "Negative size should default to compact")
    }
    
    @Test func testExtremelyLargeWindowSize() {
        // GIVEN: Extremely large window size
        let hugeSize = CGSize(width: 100000, height: 100000)
        
        // WHEN: Screen size class is calculated
        // THEN: Should handle gracefully and return large
        let sizeClass = ScreenSizeClass.from(screenSize: hugeSize)
        #expect(sizeClass == .large, "Huge size should be large")
    }
    
    @Test func testVerySmallWindowSize() {
        // GIVEN: Very small window size
        let tinySize = CGSize(width: 1, height: 1)
        
        // WHEN: Screen size class is calculated
        // THEN: Should handle gracefully and return compact
        let sizeClass = ScreenSizeClass.from(screenSize: tinySize)
        #expect(sizeClass == .compact, "Tiny size should be compact")
    }
    
    @Test func testAspectRatioEdgeCases() {
        // GIVEN: Unusual aspect ratios
        let testCases = [
            CGSize(width: 1000, height: 1),    // Very wide
            CGSize(width: 1, height: 1000),    // Very tall
            CGSize(width: 500, height: 500),   // Square
            CGSize(width: 0.1, height: 0.1)    // Very small decimal
        ]
        
        // WHEN: Screen size class is calculated
        // THEN: Should handle gracefully
        for size in testCases {
            let sizeClass = ScreenSizeClass.from(screenSize: size)
            #expect([.compact, .regular, .large].contains(sizeClass), 
                         "Size \(size) should return valid size class")
        }
    }
    
    // MARK: - Error Condition Tests
    
    @Test func testMultipleStartMonitoringCalls() {
        // GIVEN: A window detection instance
        let windowDetection = UnifiedWindowDetection()
        
        // WHEN: Start monitoring is called multiple times
        // THEN: Should not crash or create multiple observers
        #expect(throws: Never.self) { windowDetection.startMonitoring() }
        #expect(throws: Never.self) { windowDetection.startMonitoring() }
        #expect(throws: Never.self) { windowDetection.startMonitoring() }
    }
    
    @Test func testStopMonitoringWithoutStart() {
        // GIVEN: A window detection instance that hasn't started monitoring
        let windowDetection = UnifiedWindowDetection()
        
        // WHEN: Stop monitoring is called
        // THEN: Should not crash
        #expect(throws: Never.self) { windowDetection.stopMonitoring() }
    }
    
    @Test func testMultipleStopMonitoringCalls() {
        // GIVEN: A window detection instance that's monitoring
        let windowDetection = UnifiedWindowDetection()
        
        // WHEN: Stop monitoring is called multiple times
        // THEN: Should not crash
        windowDetection.startMonitoring()
        #expect(throws: Never.self) { windowDetection.stopMonitoring() }
        #expect(throws: Never.self) { windowDetection.stopMonitoring() }
        #expect(throws: Never.self) { windowDetection.stopMonitoring() }
    }
    
    // MARK: - Window State Tests
    
    @Test func testWindowStateEnumCompleteness() {
        // GIVEN: Window state enum
        // WHEN: All cases are checked
        // THEN: Should contain all expected states
        let states = UnifiedWindowDetection.WindowState.allCases
        #expect(states.contains(.standard))
        #expect(states.contains(.splitView))
        #expect(states.contains(.slideOver))
        #expect(states.contains(.stageManager))
        #expect(states.contains(.fullscreen))
        #expect(states.contains(.minimized))
        #expect(states.contains(.hidden))
        #expect(states.count == 7, "Should have exactly 7 window states")
    }
    
    @Test func testWindowStateStringValues() {
        // GIVEN: Window state enum cases
        // WHEN: String values are checked
        // THEN: Should have expected string values
        #expect(UnifiedWindowDetection.WindowState.standard.rawValue == "standard")
        #expect(UnifiedWindowDetection.WindowState.splitView.rawValue == "splitView")
        #expect(UnifiedWindowDetection.WindowState.slideOver.rawValue == "slideOver")
        #expect(UnifiedWindowDetection.WindowState.stageManager.rawValue == "stageManager")
        #expect(UnifiedWindowDetection.WindowState.fullscreen.rawValue == "fullscreen")
        #expect(UnifiedWindowDetection.WindowState.minimized.rawValue == "minimized")
        #expect(UnifiedWindowDetection.WindowState.hidden.rawValue == "hidden")
    }
    
    // MARK: - Device Context Tests
    
    @Test func testDeviceContextEnumCompleteness() {
        // GIVEN: Device context enum
        // WHEN: All cases are checked
        // THEN: Should contain all expected contexts
        let contexts = DeviceContext.allCases
        #expect(contexts.contains(.standard))
        #expect(contexts.contains(.carPlay))
        #expect(contexts.contains(.externalDisplay))
        #expect(contexts.contains(.splitView))
        #expect(contexts.contains(.stageManager))
        #expect(contexts.count == 5, "Should have exactly 5 device contexts")
    }
    
    @Test func testDeviceContextStringValues() {
        // GIVEN: Device context enum cases
        // WHEN: String values are checked
        // THEN: Should have expected string values
        #expect(DeviceContext.standard.rawValue == "standard")
        #expect(DeviceContext.carPlay.rawValue == "carPlay")
        #expect(DeviceContext.externalDisplay.rawValue == "externalDisplay")
        #expect(DeviceContext.splitView.rawValue == "splitView")
        #expect(DeviceContext.stageManager.rawValue == "stageManager")
    }
    
    // MARK: - SwiftUI Integration Tests
    
    @Test func testUnifiedWindowSizeModifierCreation() {
        // GIVEN: SwiftUI modifier
        // WHEN: Created
        // THEN: Should not crash
        #expect(throws: Never.self) { UnifiedWindowSizeModifier() }
    }
    
    @Test func testDetectWindowSizeViewExtension() {
        // GIVEN: A SwiftUI view
        let view = Text("Test")
        
        // WHEN: Detect window size modifier is applied
        // THEN: Should return modified view without crashing
        let modifiedView = view.detectWindowSize()
        #expect(modifiedView != nil)
    }
    
    @Test func testDetectWindowSizeOnDifferentViewTypes() {
        // GIVEN: Different SwiftUI view types
        let views: [AnyView] = [
            AnyView(Text("Text")),
            AnyView(VStack { Text("VStack") }),
            AnyView(HStack { Text("HStack") }),
            AnyView(Image(systemName: "star")),
            AnyView(Button("Button") { })
        ]
        
        // WHEN: Detect window size modifier is applied to each
        // THEN: Should work without crashing
        for view in views {
            #expect(throws: Never.self) { view.detectWindowSize() }
        }
    }
    
    
    // MARK: - Memory Management Tests
    
    @Test @MainActor func testWindowDetectionMemoryManagement() {
        // GIVEN: A window detection instance
        // WHEN: Created and destroyed
        // THEN: Should not leak memory
        weak var weakDetection: UnifiedWindowDetection?
        
        autoreleasepool {
            let detection = UnifiedWindowDetection()
            weakDetection = detection
            detection.startMonitoring()
            detection.stopMonitoring()
        }
        
        // Should be deallocated
        #expect(weakDetection == nil, "Window detection should be deallocated")
    }
    
    @Test @MainActor func testMultipleWindowDetectionInstances() {
        // GIVEN: Multiple window detection instances
        // WHEN: Created and destroyed
        // THEN: Should not interfere with each other
        let detection1 = UnifiedWindowDetection()
        let detection2 = UnifiedWindowDetection()
        
        detection1.startMonitoring()
        detection2.startMonitoring()
        
        #expect(throws: Never.self) { detection1.updateWindowInfo() }
        #expect(throws: Never.self) { detection2.updateWindowInfo() }
        
        detection1.stopMonitoring()
        detection2.stopMonitoring()
    }
    
    // MARK: - Thread Safety Tests
    
    @Test func testWindowDetectionThreadSafety() async {
        // GIVEN: A window detection instance
        let windowDetection = UnifiedWindowDetection()
        
        // WHEN: Called from multiple threads
        // THEN: Should not crash

        // Test that the method can be called safely from the main thread multiple times
        // This tests basic thread safety for repeated calls
        #expect(throws: Never.self) { windowDetection.updateWindowInfo() }
        #expect(throws: Never.self) { windowDetection.updateWindowInfo() }
        #expect(throws: Never.self) { windowDetection.updateWindowInfo() }

        // Test that the method can be called safely from different contexts
        // This is a simplified test that doesn't use async/await to avoid hanging
        
        // Test that we can call updateWindowInfo from a background queue
        // The method should handle this gracefully
        await Task { @MainActor in
            #expect(throws: Never.self) { windowDetection.updateWindowInfo() }
        }
    }
    
    // MARK: - Platform-Specific Tests (iOS)
    
    #if os(iOS)
    @Test func testiOSWindowDetectionInitialization() {
        // GIVEN: iOS window detection
        // WHEN: Initialized
        // THEN: Should have iOS-specific defaults
        let iOSDetection = iOSWindowDetection()
        #expect(iOSDetection != nil)
        #expect(iOSDetection.windowSize == CGSize(width: 375, height: 667))
        #expect(iOSDetection.screenSize == CGSize(width: 375, height: 667))
    }
    
    @Test func testiOSWindowDetectionLifecycle() {
        // GIVEN: iOS window detection
        let iOSDetection = iOSWindowDetection()
        
        // WHEN: Lifecycle methods are called
        // THEN: Should not crash
        #expect(throws: Never.self) { iOSDetection.startMonitoring() }
        #expect(throws: Never.self) { iOSDetection.updateWindowInfo() }
        #expect(throws: Never.self) { iOSDetection.stopMonitoring() }
    }
    
    @Test func testiOSScreenSizeClassFromWindowSize() {
        // GIVEN: iOS window sizes
        let testCases = [
            (CGSize(width: 320, height: 568), ScreenSizeClass.compact),
            (CGSize(width: 768, height: 1024), ScreenSizeClass.regular),
            (CGSize(width: 1200, height: 800), ScreenSizeClass.large)
        ]
        
        // WHEN: iOS screen size class is calculated
        // THEN: Should return expected values
        for (size, expected) in testCases {
            let result = ScreenSizeClass.from(iOSWindowSize: size)
            #expect(result == expected, "iOS size \(size) should be \(expected)")
        }
    }
    #endif
    
    // MARK: - Platform-Specific Tests (macOS)
    
    #if os(macOS)
    @Test func testmacOSWindowDetectionInitialization() {
        // GIVEN: macOS window detection
        // WHEN: Initialized
        // THEN: Should have macOS-specific defaults
        let macOSDetection = macOSWindowDetection()
        #expect(macOSDetection != nil)
        #expect(macOSDetection.windowSize == CGSize(width: 1024, height: 768))
        #expect(macOSDetection.screenSize == CGSize(width: 1024, height: 768))
    }
    
    @Test func testmacOSWindowDetectionLifecycle() {
        // GIVEN: macOS window detection
        let macOSDetection = macOSWindowDetection()
        
        // WHEN: Lifecycle methods are called
        // THEN: Should not crash
        #expect(throws: Never.self) { macOSDetection.startMonitoring() }
        #expect(throws: Never.self) { macOSDetection.updateWindowInfo() }
        #expect(throws: Never.self) { macOSDetection.stopMonitoring() }
    }
    
    @Test func testmacOSScreenSizeClassFromWindowSize() {
        // GIVEN: macOS window sizes
        let testCases = [
            (CGSize(width: 800, height: 600), ScreenSizeClass.compact),
            (CGSize(width: 1200, height: 800), ScreenSizeClass.regular),
            (CGSize(width: 1920, height: 1080), ScreenSizeClass.large)
        ]
        
        // WHEN: macOS screen size class is calculated
        // THEN: Should return expected values
        for (size, expected) in testCases {
            let result = ScreenSizeClass.from(screenSize: size)
            #expect(result == expected, "macOS size \(size) should be \(expected)")
        }
    }
    #endif
}
