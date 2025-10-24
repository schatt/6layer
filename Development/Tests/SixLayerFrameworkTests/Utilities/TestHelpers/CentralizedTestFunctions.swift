//
//  CentralizedTestFunctions.swift
//  SixLayerFrameworkTests
//
//  BUSINESS PURPOSE:
//  Centralized test functions following DRY principles to eliminate code duplication
//  across all test files in the SixLayer framework.
//
//  DRY PRINCIPLE:
//  - Single source of truth for common test patterns
//  - Reusable test functions that can be called from individual test files
//  - Consistent test setup and validation across all components
//
//  USAGE PATTERN:
//  testfile.swift:
//  func testfoo() {
//      test1()
//      test2()
//  }
//
//  test2.swift:
//  func testBob() {
//      setup()
//      testfoo(bob, componentName: "Bob")
//  }
//

import SwiftUI
@testable import SixLayerFramework

// MARK: - Centralized Accessibility Test Functions

/// Centralized function for testing accessibility identifier generation
/// This is the single source of truth for accessibility identifier testing
/// 
/// - Parameters:
///   - view: The SwiftUI view to test
///   - componentName: Name of the component being tested
///   - expectedPattern: Expected accessibility identifier pattern
///   - platform: Platform to test on (optional, defaults to current)
///   - testName: Name of the test for debugging
/// - Returns: True if accessibility identifier test passes
@MainActor
public func testAccessibilityIdentifierGeneration<T: View>(
    _ view: T,
    componentName: String,
    expectedPattern: String = "SixLayer.main.element.*",
    platform: SixLayerPlatform? = nil,
    testName: String = "AccessibilityTest"
) -> Bool {
    // Setup: Configure test environment
    let config = AccessibilityIdentifierConfig.shared
    config.enableAutoIDs = true
    config.namespace = "SixLayer"
    config.mode = .automatic
    
    // Set platform if specified
    if let platform = platform {
        RuntimeCapabilityDetection.setTestPlatform(platform)
    }
    
    // Test: Use centralized accessibility identifier testing
    let result = testAccessibilityIdentifiersSinglePlatform(
        view,
        expectedPattern: expectedPattern,
        platform: platform ?? SixLayerPlatform.current,
        componentName: componentName
    )
    
    // Cleanup: Reset platform
    if platform != nil {
        RuntimeCapabilityDetection.setTestPlatform(nil)
    }
    
    return result
}

/// Centralized function for testing cross-platform accessibility identifier generation
/// Tests the same component across multiple platforms
/// 
/// - Parameters:
///   - view: The SwiftUI view to test
///   - componentName: Name of the component being tested
///   - expectedPattern: Expected accessibility identifier pattern
///   - platforms: Array of platforms to test (defaults to iOS and macOS)
///   - testName: Name of the test for debugging
/// - Returns: True if accessibility identifier test passes on all platforms
@MainActor
public func testCrossPlatformAccessibilityIdentifierGeneration<T: View>(
    _ view: T,
    componentName: String,
    expectedPattern: String = "SixLayer.main.element.*",
    platforms: [SixLayerPlatform] = [.iOS, .macOS],
    testName: String = "CrossPlatformAccessibilityTest"
) -> Bool {
    // Setup: Configure test environment
    let config = AccessibilityIdentifierConfig.shared
    config.enableAutoIDs = true
    config.namespace = "SixLayer"
    config.mode = .automatic
    
    // Test: Use centralized cross-platform accessibility identifier testing
    let result = testAccessibilityIdentifiersCrossPlatform(
        view,
        expectedPattern: expectedPattern,
        componentName: componentName,
        testName: testName
    )
    
    return result
}

// MARK: - Centralized Platform Detection Test Functions

/// Centralized function for testing platform capability detection
/// Tests that platform-specific capabilities are correctly detected
/// 
/// - Parameters:
///   - platform: Platform to test
///   - expectedCapabilities: Expected platform capabilities
///   - testName: Name of the test for debugging
/// - Returns: True if platform capability detection test passes
@MainActor
internal func testPlatformCapabilityDetection(
    platform: SixLayerPlatform,
    expectedCapabilities: PlatformCapabilitiesTestSnapshot,
    testName: String = "PlatformCapabilityTest"
) -> Bool {
    // Setup: Set test platform
    RuntimeCapabilityDetection.setTestPlatform(platform)
    
    // Test: Verify platform detection
    let actualPlatform = SixLayerPlatform.currentPlatform
    guard actualPlatform == platform else {
        print("❌ PLATFORM TEST: Expected \(platform), got \(actualPlatform)")
        RuntimeCapabilityDetection.setTestPlatform(nil)
        return false
    }
    
    // Test: Verify capabilities match expected values
    let actualCapabilities = PlatformCapabilitiesTestSnapshot(
        supportsHapticFeedback: RuntimeCapabilityDetection.supportsHapticFeedback,
        supportsHover: RuntimeCapabilityDetection.supportsHover,
        supportsTouch: RuntimeCapabilityDetection.supportsTouch,
        supportsVoiceOver: RuntimeCapabilityDetection.supportsVoiceOver,
        supportsSwitchControl: RuntimeCapabilityDetection.supportsSwitchControl,
        supportsAssistiveTouch: RuntimeCapabilityDetection.supportsAssistiveTouch,
        minTouchTarget: RuntimeCapabilityDetection.minTouchTarget,
        hoverDelay: RuntimeCapabilityDetection.hoverDelay
    )
    
    // Validate capabilities
    let capabilitiesMatch = actualCapabilities.supportsHapticFeedback == expectedCapabilities.supportsHapticFeedback &&
                           actualCapabilities.supportsHover == expectedCapabilities.supportsHover &&
                           actualCapabilities.supportsTouch == expectedCapabilities.supportsTouch &&
                           actualCapabilities.supportsVoiceOver == expectedCapabilities.supportsVoiceOver &&
                           actualCapabilities.supportsSwitchControl == expectedCapabilities.supportsSwitchControl &&
                           actualCapabilities.supportsAssistiveTouch == expectedCapabilities.supportsAssistiveTouch &&
                           actualCapabilities.minTouchTarget == expectedCapabilities.minTouchTarget &&
                           actualCapabilities.hoverDelay == expectedCapabilities.hoverDelay
    
    if !capabilitiesMatch {
        print("❌ PLATFORM TEST: Capabilities don't match expected values for \(platform)")
        print("Expected: \(expectedCapabilities)")
        print("Actual: \(actualCapabilities)")
    }
    
    // Cleanup: Reset platform
    RuntimeCapabilityDetection.setTestPlatform(nil)
    
    return capabilitiesMatch
}

// MARK: - Centralized Component Test Functions

/// Centralized function for testing component creation and basic functionality
/// Tests that a component can be created and has basic expected properties
/// 
/// - Parameters:
///   - componentName: Name of the component being tested
///   - createComponent: Function that creates the component to test
///   - testName: Name of the test for debugging
/// - Returns: True if component creation test passes
@MainActor
public func testComponentCreation<T>(
    componentName: String,
    createComponent: () -> T,
    testName: String = "ComponentCreationTest"
) -> Bool {
    // Test: Component can be created
    let component = createComponent()
    
    // Basic validation: Component is not nil (for reference types)
    if let optionalComponent = component as? AnyOptional, optionalComponent.isNil {
        print("❌ COMPONENT TEST: \(componentName) creation failed - component is nil")
        return false
    }
    
    print("✅ COMPONENT TEST: \(componentName) created successfully")
    return true
}

/// Centralized function for testing component with accessibility features
/// Tests that a component has proper accessibility support
/// 
/// - Parameters:
///   - componentName: Name of the component being tested
///   - createComponent: Function that creates the component to test
///   - expectedAccessibilityFeatures: Expected accessibility features
///   - testName: Name of the test for debugging
/// - Returns: True if component accessibility test passes
@MainActor
public func testComponentAccessibility<T: View>(
    componentName: String,
    createComponent: () -> T,
    expectedAccessibilityFeatures: [String] = ["accessibilityIdentifier", "accessibilityLabel"],
    testName: String = "ComponentAccessibilityTest"
) -> Bool {
    // Test: Component creation
    let component = createComponent()
    
    // Test: Accessibility identifier generation
    let accessibilityTestPassed = testAccessibilityIdentifierGeneration(
        component,
        componentName: componentName,
        testName: testName
    )
    
    if !accessibilityTestPassed {
        print("❌ ACCESSIBILITY TEST: \(componentName) failed accessibility identifier test")
        return false
    }
    
    print("✅ ACCESSIBILITY TEST: \(componentName) passed all accessibility tests")
    return true
}

// MARK: - Centralized Test Setup Functions

/// Centralized function for setting up test environment
/// Provides consistent test setup across all test files
/// 
/// - Parameters:
///   - enableAccessibility: Whether to enable accessibility features
///   - enableDebugLogging: Whether to enable debug logging
///   - namespace: Namespace for accessibility identifiers
@MainActor
public func setupTestEnvironment(
    enableAccessibility: Bool = true,
    enableDebugLogging: Bool = false,
    namespace: String = "SixLayer"
) {
    // Setup: Configure accessibility
    if enableAccessibility {
        let config = AccessibilityIdentifierConfig.shared
        config.enableAutoIDs = true
        config.namespace = namespace
        config.mode = .automatic
        config.enableDebugLogging = enableDebugLogging
    }
    
    // Setup: Configure test utilities
    TestSetupUtilities.shared.setupTestingEnvironment()
}

/// Centralized function for cleaning up test environment
/// Provides consistent test cleanup across all test files
@MainActor
public func cleanupTestEnvironment() {
    // Cleanup: Reset accessibility configuration
    let config = AccessibilityIdentifierConfig.shared
    config.resetToDefaults()
    
    // Cleanup: Reset test utilities
    TestSetupUtilities.shared.cleanupTestingEnvironment()
    
    // Cleanup: Reset platform detection
    RuntimeCapabilityDetection.setTestPlatform(nil)
}

// MARK: - Helper Types

/// Protocol for optional types to enable nil checking
private protocol AnyOptional {
    var isNil: Bool { get }
}

extension Optional: AnyOptional {
    var isNil: Bool { self == nil }
}

// MARK: - Usage Examples

/*
 
 EXAMPLE USAGE PATTERN:
 
 // In CollectionEmptyStateViewTests.swift:
 @Test func testCollectionEmptyStateViewAccessibility() async {
     await MainActor.run {
         // Setup
         setupTestEnvironment()
         
         // Test using centralized function
         let view = CollectionEmptyStateView(
             title: "Test Title",
             message: "Test Message",
             onCreateItem: {},
             customCreateView: nil
         )
         
         let testPassed = testComponentAccessibility(
             componentName: "CollectionEmptyStateView",
             createComponent: { view }
         )
         
         #expect(testPassed, "CollectionEmptyStateView should pass accessibility tests")
         
         // Cleanup
         cleanupTestEnvironment()
     }
 }
 
 // In PlatformLogicTests.swift:
 @Test func testPlatformCapabilityDetection() async {
     await MainActor.run {
         // Setup
         setupTestEnvironment()
         
         // Test using centralized function
         let expectedCapabilities = PlatformCapabilitiesTestSnapshot(
             supportsHapticFeedback: false,
             supportsHover: false,
             supportsTouch: true,
             supportsVoiceOver: true,
             supportsSwitchControl: true,
             supportsAssistiveTouch: true,
             minTouchTarget: 44.0,
             hoverDelay: 0.0
         )
         
         let testPassed = testPlatformCapabilityDetection(
             platform: .iOS,
             expectedCapabilities: expectedCapabilities
         )
         
         #expect(testPassed, "iOS platform capability detection should work correctly")
         
         // Cleanup
         cleanupTestEnvironment()
     }
 }
 
 */
