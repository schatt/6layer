import XCTest
import SwiftUI
@testable import SixLayerFramework

/// TDD Tests for window size detection across all platforms
/// Tests written FIRST, implementation will follow
/// Comprehensive coverage: positive, negative, edge cases, error conditions
@MainActor
final class WindowDetectionTests: XCTestCase {
    
    // MARK: - Test Setup
    
    var windowDetection: UnifiedWindowDetection!
    
    override func setUp() {
        super.setUp()
        // Implementation doesn't exist yet - this will fail initially (RED phase)
        windowDetection = UnifiedWindowDetection()
    }
    
    override func tearDown() {
        windowDetection?.stopMonitoring()
        windowDetection = nil
        super.tearDown()
    }
    
    // MARK: - Basic Functionality Tests (Positive Cases)
    
    func testWindowDetectionInitialization() {
        // GIVEN: A new window detection instance
        // WHEN: Initialized
        // THEN: Should have default values
        XCTAssertNotNil(windowDetection)
        XCTAssertEqual(windowDetection.windowSize, CGSize(width: 375, height: 667))
        XCTAssertEqual(windowDetection.screenSize, CGSize(width: 375, height: 667))
        XCTAssertEqual(windowDetection.screenSizeClass, .compact)
        XCTAssertEqual(windowDetection.windowState, .standard)
        XCTAssertEqual(windowDetection.deviceContext, .standard)
        XCTAssertFalse(windowDetection.isResizing)
        XCTAssertEqual(windowDetection.safeAreaInsets, EdgeInsets())
        XCTAssertEqual(windowDetection.orientation, .portrait)
    }
    
    func testWindowDetectionStartMonitoring() {
        // GIVEN: A window detection instance
        // WHEN: Start monitoring is called
        // THEN: Should start monitoring without crashing
        XCTAssertNoThrow(windowDetection.startMonitoring())
        XCTAssertNotNil(windowDetection.platformDetection)
    }
    
    func testWindowDetectionStopMonitoring() {
        // GIVEN: A window detection instance that's monitoring
        // WHEN: Stop monitoring is called
        // THEN: Should stop monitoring without crashing
        windowDetection.startMonitoring()
        XCTAssertNoThrow(windowDetection.stopMonitoring())
    }
    
    func testWindowDetectionUpdateInfo() {
        // GIVEN: A window detection instance
        // WHEN: Update window info is called
        // THEN: Should update without crashing
        XCTAssertNoThrow(windowDetection.updateWindowInfo())
    }
    
    // MARK: - Screen Size Class Tests (Positive Cases)
    
    func testScreenSizeClassCompactDetection() {
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
            XCTAssertEqual(sizeClass, .compact, "Size \(size) should be compact")
        }
    }
    
    func testScreenSizeClassRegularDetection() {
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
            XCTAssertEqual(sizeClass, .regular, "Size \(size) should be regular")
        }
    }
    
    func testScreenSizeClassLargeDetection() {
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
            XCTAssertEqual(sizeClass, .large, "Size \(size) should be large")
        }
    }
    
    // MARK: - Edge Case Tests (Negative Cases)
    
    func testZeroWindowSize() {
        // GIVEN: Zero window size
        let zeroSize = CGSize(width: 0, height: 0)
        
        // WHEN: Screen size class is calculated
        // THEN: Should handle gracefully and return compact
        let sizeClass = ScreenSizeClass.from(screenSize: zeroSize)
        XCTAssertEqual(sizeClass, .compact, "Zero size should default to compact")
    }
    
    func testNegativeWindowSize() {
        // GIVEN: Negative window size
        let negativeSize = CGSize(width: -100, height: -200)
        
        // WHEN: Screen size class is calculated
        // THEN: Should handle gracefully and return compact
        let sizeClass = ScreenSizeClass.from(screenSize: negativeSize)
        XCTAssertEqual(sizeClass, .compact, "Negative size should default to compact")
    }
    
    func testExtremelyLargeWindowSize() {
        // GIVEN: Extremely large window size
        let hugeSize = CGSize(width: 100000, height: 100000)
        
        // WHEN: Screen size class is calculated
        // THEN: Should handle gracefully and return large
        let sizeClass = ScreenSizeClass.from(screenSize: hugeSize)
        XCTAssertEqual(sizeClass, .large, "Huge size should be large")
    }
    
    func testVerySmallWindowSize() {
        // GIVEN: Very small window size
        let tinySize = CGSize(width: 1, height: 1)
        
        // WHEN: Screen size class is calculated
        // THEN: Should handle gracefully and return compact
        let sizeClass = ScreenSizeClass.from(screenSize: tinySize)
        XCTAssertEqual(sizeClass, .compact, "Tiny size should be compact")
    }
    
    func testAspectRatioEdgeCases() {
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
            XCTAssertTrue([.compact, .regular, .large].contains(sizeClass), 
                         "Size \(size) should return valid size class")
        }
    }
    
    // MARK: - Error Condition Tests
    
    func testMultipleStartMonitoringCalls() {
        // GIVEN: A window detection instance
        // WHEN: Start monitoring is called multiple times
        // THEN: Should not crash or create multiple observers
        XCTAssertNoThrow(windowDetection.startMonitoring())
        XCTAssertNoThrow(windowDetection.startMonitoring())
        XCTAssertNoThrow(windowDetection.startMonitoring())
    }
    
    func testStopMonitoringWithoutStart() {
        // GIVEN: A window detection instance that hasn't started monitoring
        // WHEN: Stop monitoring is called
        // THEN: Should not crash
        XCTAssertNoThrow(windowDetection.stopMonitoring())
    }
    
    func testMultipleStopMonitoringCalls() {
        // GIVEN: A window detection instance that's monitoring
        // WHEN: Stop monitoring is called multiple times
        // THEN: Should not crash
        windowDetection.startMonitoring()
        XCTAssertNoThrow(windowDetection.stopMonitoring())
        XCTAssertNoThrow(windowDetection.stopMonitoring())
        XCTAssertNoThrow(windowDetection.stopMonitoring())
    }
    
    // MARK: - Window State Tests
    
    func testWindowStateEnumCompleteness() {
        // GIVEN: Window state enum
        // WHEN: All cases are checked
        // THEN: Should contain all expected states
        let states = UnifiedWindowDetection.WindowState.allCases
        XCTAssertTrue(states.contains(.standard))
        XCTAssertTrue(states.contains(.splitView))
        XCTAssertTrue(states.contains(.slideOver))
        XCTAssertTrue(states.contains(.stageManager))
        XCTAssertTrue(states.contains(.fullscreen))
        XCTAssertTrue(states.contains(.minimized))
        XCTAssertTrue(states.contains(.hidden))
        XCTAssertEqual(states.count, 7, "Should have exactly 7 window states")
    }
    
    func testWindowStateStringValues() {
        // GIVEN: Window state enum cases
        // WHEN: String values are checked
        // THEN: Should have expected string values
        XCTAssertEqual(UnifiedWindowDetection.WindowState.standard.rawValue, "standard")
        XCTAssertEqual(UnifiedWindowDetection.WindowState.splitView.rawValue, "splitView")
        XCTAssertEqual(UnifiedWindowDetection.WindowState.slideOver.rawValue, "slideOver")
        XCTAssertEqual(UnifiedWindowDetection.WindowState.stageManager.rawValue, "stageManager")
        XCTAssertEqual(UnifiedWindowDetection.WindowState.fullscreen.rawValue, "fullscreen")
        XCTAssertEqual(UnifiedWindowDetection.WindowState.minimized.rawValue, "minimized")
        XCTAssertEqual(UnifiedWindowDetection.WindowState.hidden.rawValue, "hidden")
    }
    
    // MARK: - Device Context Tests
    
    func testDeviceContextEnumCompleteness() {
        // GIVEN: Device context enum
        // WHEN: All cases are checked
        // THEN: Should contain all expected contexts
        let contexts = DeviceContext.allCases
        XCTAssertTrue(contexts.contains(.standard))
        XCTAssertTrue(contexts.contains(.carPlay))
        XCTAssertTrue(contexts.contains(.externalDisplay))
        XCTAssertTrue(contexts.contains(.splitView))
        XCTAssertTrue(contexts.contains(.stageManager))
        XCTAssertEqual(contexts.count, 5, "Should have exactly 5 device contexts")
    }
    
    func testDeviceContextStringValues() {
        // GIVEN: Device context enum cases
        // WHEN: String values are checked
        // THEN: Should have expected string values
        XCTAssertEqual(DeviceContext.standard.rawValue, "standard")
        XCTAssertEqual(DeviceContext.carPlay.rawValue, "carPlay")
        XCTAssertEqual(DeviceContext.externalDisplay.rawValue, "externalDisplay")
        XCTAssertEqual(DeviceContext.splitView.rawValue, "splitView")
        XCTAssertEqual(DeviceContext.stageManager.rawValue, "stageManager")
    }
    
    // MARK: - SwiftUI Integration Tests
    
    func testUnifiedWindowSizeModifierCreation() {
        // GIVEN: SwiftUI modifier
        // WHEN: Created
        // THEN: Should not crash
        XCTAssertNoThrow(UnifiedWindowSizeModifier())
    }
    
    func testDetectWindowSizeViewExtension() {
        // GIVEN: A SwiftUI view
        let view = Text("Test")
        
        // WHEN: Detect window size modifier is applied
        // THEN: Should return modified view without crashing
        let modifiedView = view.detectWindowSize()
        XCTAssertNotNil(modifiedView)
    }
    
    func testDetectWindowSizeOnDifferentViewTypes() {
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
            XCTAssertNoThrow(view.detectWindowSize())
        }
    }
    
    // MARK: - Performance Tests
    
    func testWindowDetectionPerformance() {
        // GIVEN: A window detection instance
        // WHEN: Update window info is called many times
        // THEN: Should complete within reasonable time
        measure {
            for _ in 0..<1000 {
                windowDetection.updateWindowInfo()
            }
        }
    }
    
    func testScreenSizeClassCalculationPerformance() {
        // GIVEN: Various window sizes
        let testSizes = [
            CGSize(width: 320, height: 568),
            CGSize(width: 768, height: 1024),
            CGSize(width: 1920, height: 1080),
            CGSize(width: 0, height: 0),
            CGSize(width: -100, height: -200),
            CGSize(width: 100000, height: 100000)
        ]
        
        // WHEN: Screen size class is calculated many times
        // THEN: Should complete within reasonable time
        measure {
            for _ in 0..<10000 {
                for size in testSizes {
                    _ = ScreenSizeClass.from(screenSize: size)
                }
            }
        }
    }
    
    // MARK: - Memory Management Tests
    
    func testWindowDetectionMemoryManagement() {
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
        XCTAssertNil(weakDetection, "Window detection should be deallocated")
    }
    
    func testMultipleWindowDetectionInstances() {
        // GIVEN: Multiple window detection instances
        // WHEN: Created and destroyed
        // THEN: Should not interfere with each other
        let detection1 = UnifiedWindowDetection()
        let detection2 = UnifiedWindowDetection()
        
        detection1.startMonitoring()
        detection2.startMonitoring()
        
        XCTAssertNoThrow(detection1.updateWindowInfo())
        XCTAssertNoThrow(detection2.updateWindowInfo())
        
        detection1.stopMonitoring()
        detection2.stopMonitoring()
    }
    
    // MARK: - Thread Safety Tests
    
    func testWindowDetectionThreadSafety() {
        // GIVEN: A window detection instance
        // WHEN: Called from multiple threads
        // THEN: Should not crash
        let expectation = XCTestExpectation(description: "Thread safety test")
        expectation.expectedFulfillmentCount = 10
        
        for _ in 0..<10 {
            let detector = windowDetection
            DispatchQueue.global().async {
                Task { @MainActor in
                    detector?.updateWindowInfo()
                    expectation.fulfill()
                }
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    // MARK: - Platform-Specific Tests (iOS)
    
    #if os(iOS)
    func testiOSWindowDetectionInitialization() {
        // GIVEN: iOS window detection
        // WHEN: Initialized
        // THEN: Should have iOS-specific defaults
        let iOSDetection = iOSWindowDetection()
        XCTAssertNotNil(iOSDetection)
        XCTAssertEqual(iOSDetection.windowSize, CGSize(width: 375, height: 667))
        XCTAssertEqual(iOSDetection.screenSize, CGSize(width: 375, height: 667))
    }
    
    func testiOSWindowDetectionLifecycle() {
        // GIVEN: iOS window detection
        let iOSDetection = iOSWindowDetection()
        
        // WHEN: Lifecycle methods are called
        // THEN: Should not crash
        XCTAssertNoThrow(iOSDetection.startMonitoring())
        XCTAssertNoThrow(iOSDetection.updateWindowInfo())
        XCTAssertNoThrow(iOSDetection.stopMonitoring())
    }
    
    func testiOSScreenSizeClassFromWindowSize() {
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
            XCTAssertEqual(result, expected, "iOS size \(size) should be \(expected)")
        }
    }
    #endif
    
    // MARK: - Platform-Specific Tests (macOS)
    
    #if os(macOS)
    func testmacOSWindowDetectionInitialization() {
        // GIVEN: macOS window detection
        // WHEN: Initialized
        // THEN: Should have macOS-specific defaults
        let macOSDetection = macOSWindowDetection()
        XCTAssertNotNil(macOSDetection)
        XCTAssertEqual(macOSDetection.windowSize, CGSize(width: 1024, height: 768))
        XCTAssertEqual(macOSDetection.screenSize, CGSize(width: 1024, height: 768))
    }
    
    func testmacOSWindowDetectionLifecycle() {
        // GIVEN: macOS window detection
        let macOSDetection = macOSWindowDetection()
        
        // WHEN: Lifecycle methods are called
        // THEN: Should not crash
        XCTAssertNoThrow(macOSDetection.startMonitoring())
        XCTAssertNoThrow(macOSDetection.updateWindowInfo())
        XCTAssertNoThrow(macOSDetection.stopMonitoring())
    }
    
    func testmacOSScreenSizeClassFromWindowSize() {
        // GIVEN: macOS window sizes
        let testCases = [
            (CGSize(width: 800, height: 600), ScreenSizeClass.compact),
            (CGSize(width: 1200, height: 800), ScreenSizeClass.regular),
            (CGSize(width: 1920, height: 1080), ScreenSizeClass.large)
        ]
        
        // WHEN: macOS screen size class is calculated
        // THEN: Should return expected values
        for (size, expected) in testCases {
            let result = ScreenSizeClass.from(macOSWindowSize: size)
            XCTAssertEqual(result, expected, "macOS size \(size) should be \(expected)")
        }
    }
    #endif
}
