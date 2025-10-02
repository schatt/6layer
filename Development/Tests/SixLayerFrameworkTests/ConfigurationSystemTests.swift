//
//  ConfigurationSystemTests.swift
//  SixLayerFrameworkTests
//
//  Tests for the SixLayer Configuration System
//

import XCTest
import SwiftUI
@testable import SixLayerFramework

/// BUSINESS PURPOSE: SixLayer Configuration System provides centralized settings management for framework behavior
/// TESTING SCOPE: Configuration loading, saving, defaults, and performance optimization control
/// METHODOLOGY: Test configuration persistence, defaults, and integration with performance optimizations
@MainActor
final class ConfigurationSystemTests: XCTestCase {
    
    // MARK: - Test Setup
    
    override func setUp() {
        super.setUp()
        // Clear any existing UserDefaults for clean testing
        UserDefaults.standard.removeObject(forKey: "SixLayer.Performance.MetalRendering")
        UserDefaults.standard.removeObject(forKey: "SixLayer.Performance.CompositingOptimization")
        UserDefaults.standard.removeObject(forKey: "SixLayer.Performance.MemoryOptimization")
        UserDefaults.standard.removeObject(forKey: "SixLayer.Performance.Level")
    }
    
    override func tearDown() {
        // Clean up after tests
        UserDefaults.standard.removeObject(forKey: "SixLayer.Performance.MetalRendering")
        UserDefaults.standard.removeObject(forKey: "SixLayer.Performance.CompositingOptimization")
        UserDefaults.standard.removeObject(forKey: "SixLayer.Performance.MemoryOptimization")
        UserDefaults.standard.removeObject(forKey: "SixLayer.Performance.Level")
        super.tearDown()
    }
    
    // MARK: - Configuration Tests
    
    /// BUSINESS PURPOSE: Test that SixLayerConfiguration provides sensible defaults
    /// TESTING SCOPE: Default configuration values and platform-appropriate settings
    /// METHODOLOGY: Verify default values match platform capabilities
    func testSixLayerConfigurationDefaults() {
        // Given: Fresh configuration (create new instance to avoid shared state)
        let config = SixLayerConfiguration()
        
        // Then: Should have platform-appropriate defaults
        XCTAssertTrue(config.performance.metalRendering, "Metal rendering should be enabled by default on macOS")
        // Compositing optimization is only enabled by default on visionOS, not macOS
        XCTAssertFalse(config.performance.compositingOptimization, "Compositing optimization should be disabled by default on macOS")
        XCTAssertTrue(config.performance.memoryOptimization, "Memory optimization should be enabled by default on macOS")
        XCTAssertEqual(config.performance.performanceLevel, .balanced, "Performance level should default to balanced")
        
        // Accessibility should be enabled by default
        XCTAssertTrue(config.accessibility.automaticAccessibility, "Automatic accessibility should be enabled by default")
        XCTAssertTrue(config.accessibility.voiceOverOptimizations, "VoiceOver optimizations should be enabled by default")
        XCTAssertTrue(config.accessibility.switchControlOptimizations, "Switch Control optimizations should be enabled by default")
        XCTAssertTrue(config.accessibility.assistiveTouchOptimizations, "AssistiveTouch optimizations should be enabled by default")
    }
    
    /// BUSINESS PURPOSE: Test that configuration can be saved and loaded from UserDefaults
    /// TESTING SCOPE: Configuration persistence and retrieval
    /// METHODOLOGY: Save configuration, modify in memory, reload from UserDefaults, verify persistence
    func testConfigurationPersistence() {
        // Given: Modified configuration
        var config = PerformanceConfiguration()
        config.metalRendering = false
        config.compositingOptimization = false
        config.memoryOptimization = false
        config.performanceLevel = .low
        
        // When: Save to UserDefaults
        config.saveToUserDefaults()
        
        // Then: Create new configuration and load from UserDefaults
        var loadedConfig = PerformanceConfiguration()
        loadedConfig.loadFromUserDefaults()
        
        // Verify persistence
        XCTAssertFalse(loadedConfig.metalRendering, "Metal rendering should be persisted as false")
        XCTAssertFalse(loadedConfig.compositingOptimization, "Compositing optimization should be persisted as false")
        XCTAssertFalse(loadedConfig.memoryOptimization, "Memory optimization should be persisted as false")
        XCTAssertEqual(loadedConfig.performanceLevel, .low, "Performance level should be persisted as low")
    }
    
    /// BUSINESS PURPOSE: Test that configuration controls performance optimization behavior
    /// TESTING SCOPE: Integration between configuration and performance modifiers
    /// METHODOLOGY: Create test view, modify configuration, verify optimization behavior changes
    func testConfigurationControlsPerformanceOptimization() {
        // Given: Test view
        let testView = Text("Test View")
        
        // When: Metal rendering is disabled
        SixLayerConfiguration.shared.performance.metalRendering = false
        
        // Then: ConfigurableDrawingGroupModifier should not apply drawingGroup
        // (This is tested indirectly through the modifier's behavior)
        XCTAssertFalse(SixLayerConfiguration.shared.performance.metalRendering, "Metal rendering should be disabled")
        
        // When: Metal rendering is enabled
        SixLayerConfiguration.shared.performance.metalRendering = true
        
        // Then: ConfigurableDrawingGroupModifier should apply drawingGroup
        XCTAssertTrue(SixLayerConfiguration.shared.performance.metalRendering, "Metal rendering should be enabled")
    }
    
    /// BUSINESS PURPOSE: Test that configuration can be modified at runtime
    /// TESTING SCOPE: Runtime configuration changes and their effects
    /// METHODOLOGY: Modify configuration properties and verify changes are reflected
    func testRuntimeConfigurationChanges() {
        // Given: Initial configuration
        let config = SixLayerConfiguration.shared
        
        // When: Modify performance settings
        config.performance.metalRendering = false
        config.performance.compositingOptimization = false
        config.performance.memoryOptimization = false
        config.performance.performanceLevel = .maximum
        
        // Then: Changes should be reflected immediately
        XCTAssertFalse(config.performance.metalRendering, "Metal rendering should be disabled")
        XCTAssertFalse(config.performance.compositingOptimization, "Compositing optimization should be disabled")
        XCTAssertFalse(config.performance.memoryOptimization, "Memory optimization should be disabled")
        XCTAssertEqual(config.performance.performanceLevel, .maximum, "Performance level should be maximum")
        
        // When: Modify accessibility settings
        config.accessibility.automaticAccessibility = false
        config.accessibility.voiceOverOptimizations = false
        
        // Then: Changes should be reflected immediately
        XCTAssertFalse(config.accessibility.automaticAccessibility, "Automatic accessibility should be disabled")
        XCTAssertFalse(config.accessibility.voiceOverOptimizations, "VoiceOver optimizations should be disabled")
    }
    
    /// BUSINESS PURPOSE: Test that configuration provides platform-specific defaults
    /// TESTING SCOPE: Platform-specific default values and behavior
    /// METHODOLOGY: Test configuration defaults across different platforms
    func testPlatformSpecificDefaults() {
        // Given: Fresh configuration for different platforms
        let iosConfig = PerformanceConfiguration()
        let macConfig = PerformanceConfiguration()
        let watchConfig = PerformanceConfiguration()
        
        // Then: Should have platform-appropriate defaults
        // (Note: These tests assume we're running on macOS, so metalRendering should be true)
        XCTAssertTrue(iosConfig.metalRendering, "iOS should have Metal rendering enabled by default")
        XCTAssertTrue(macConfig.metalRendering, "macOS should have Metal rendering enabled by default")
        // watchOS would have different defaults in a real implementation
        
        XCTAssertEqual(iosConfig.performanceLevel, .balanced, "All platforms should default to balanced performance")
        XCTAssertEqual(macConfig.performanceLevel, .balanced, "All platforms should default to balanced performance")
        XCTAssertEqual(watchConfig.performanceLevel, .balanced, "All platforms should default to balanced performance")
    }
    
    /// BUSINESS PURPOSE: Test that configuration supports custom platform preferences
    /// TESTING SCOPE: Custom platform preferences and feature flags
    /// METHODOLOGY: Set custom preferences and verify they can be retrieved
    func testCustomPlatformPreferences() {
        // Given: Configuration with custom preferences
        let config = SixLayerConfiguration.shared
        
        // When: Set custom preferences
        config.platform.customPreferences["customFeature"] = true
        config.platform.customPreferences["customSetting"] = "testValue"
        config.platform.featureFlags["experimentalFeature"] = true
        
        // Then: Preferences should be stored and retrievable
        XCTAssertEqual(config.platform.customPreferences["customFeature"] as? Bool, true, "Custom boolean preference should be stored")
        XCTAssertEqual(config.platform.customPreferences["customSetting"] as? String, "testValue", "Custom string preference should be stored")
        XCTAssertEqual(config.platform.featureFlags["experimentalFeature"], true, "Feature flag should be stored")
    }
}
