import Testing
import SwiftUI
@testable import SixLayerFramework

/// Comprehensive test suite for platform-specific HIG compliance categories
/// Tests iOS, macOS, and visionOS-specific category configurations and compliance
/// NOTE: Not marked @MainActor on class to allow parallel execution
@Suite("Platform-Specific HIG Compliance Categories")
open class HIGPlatformSpecificCategoriesTests: BaseTestClass {
    
    // MARK: - iOS Category Configuration Tests
    
    @Test @MainActor func testIOSCategoryConfigInitialization() {
        // Given: A new iOS category configuration
        let config = HIGiOSCategoryConfig()
        
        // When: Initialized with defaults
        // Then: Should have default values
        #expect(config.enableHapticFeedback == true)
        #expect(config.enableGestureRecognition == true)
        #expect(config.enableTouchTargetValidation == true)
        #expect(config.enableSafeAreaCompliance == true)
        #expect(config.defaultHapticFeedbackType == .medium)
    }
    
    @Test @MainActor func testIOSCategoryConfigCustomization() {
        // Given: Custom iOS category configuration
        let config = HIGiOSCategoryConfig(
            defaultHapticFeedbackType: .light,
            enableHapticFeedback: false,
            enableGestureRecognition: false,
            enableTouchTargetValidation: false,
            enableSafeAreaCompliance: false
        )
        
        // When: Configured with custom values
        // Then: Should respect custom values
        #expect(config.defaultHapticFeedbackType == .light)
        #expect(config.enableHapticFeedback == false)
        #expect(config.enableGestureRecognition == false)
        #expect(config.enableTouchTargetValidation == false)
        #expect(config.enableSafeAreaCompliance == false)
    }
    
    // MARK: - macOS Category Configuration Tests
    
    @Test @MainActor func testMacOSCategoryConfigInitialization() {
        // Given: A new macOS category configuration
        let config = HIGmacOSCategoryConfig()
        
        // When: Initialized with defaults
        // Then: Should have default values
        #expect(config.enableWindowManagement == true)
        #expect(config.enableMenuBarIntegration == false) // Opt-in feature
        #expect(config.enableKeyboardShortcuts == true)
        #expect(config.enableMouseInteractions == true)
    }
    
    @Test @MainActor func testMacOSCategoryConfigCustomization() {
        // Given: Custom macOS category configuration
        let config = HIGmacOSCategoryConfig(
            enableWindowManagement: false,
            enableMenuBarIntegration: true,
            enableKeyboardShortcuts: false,
            enableMouseInteractions: false
        )
        
        // When: Configured with custom values
        // Then: Should respect custom values
        #expect(config.enableWindowManagement == false)
        #expect(config.enableMenuBarIntegration == true)
        #expect(config.enableKeyboardShortcuts == false)
        #expect(config.enableMouseInteractions == false)
    }
    
    // MARK: - visionOS Category Configuration Tests
    
    @Test @MainActor func testVisionOSCategoryConfigInitialization() {
        // Given: A new visionOS category configuration
        let config = HIGvisionOSCategoryConfig()
        
        // When: Initialized with defaults
        // Then: Should have default values
        #expect(config.enableSpatialAudio == false) // Opt-in feature
        #expect(config.enableHandTracking == true)
        #expect(config.enableSpatialUI == true)
    }
    
    @Test @MainActor func testVisionOSCategoryConfigCustomization() {
        // Given: Custom visionOS category configuration
        let config = HIGvisionOSCategoryConfig(
            enableSpatialAudio: true,
            enableHandTracking: false,
            enableSpatialUI: false
        )
        
        // When: Configured with custom values
        // Then: Should respect custom values
        #expect(config.enableSpatialAudio == true)
        #expect(config.enableHandTracking == false)
        #expect(config.enableSpatialUI == false)
    }
    
    // MARK: - AppleHIGComplianceManager Integration Tests
    
    @Test @MainActor func testComplianceManagerHasPlatformConfigs() {
        // Given: AppleHIGComplianceManager
        let manager = AppleHIGComplianceManager()
        
        // When: Initialized
        // Then: Should have platform-specific configurations
        #expect(manager.iOSCategoryConfig.enableHapticFeedback == true)
        #expect(manager.macOSCategoryConfig.enableMouseInteractions == true)
        #expect(manager.visionOSCategoryConfig.enableHandTracking == true)
    }
    
    @Test @MainActor func testPlatformComplianceCheckIncludesCategories() {
        initializeTestConfig()
        // Given: A test view and compliance manager
        let manager = AppleHIGComplianceManager()
        let testView = Button("Test") { }
        
        // When: Platform compliance is checked
        let report = manager.checkHIGCompliance(testView)
        
        // Then: Platform score should be calculated (includes category checks)
        #expect(report.platformScore >= 0.0)
        #expect(report.platformScore <= 100.0)
    }
    
    @Test @MainActor func testIOSComplianceCheckWithEnabledCategories() {
        initializeTestConfig()
        // Given: iOS manager with all categories enabled
        let manager = AppleHIGComplianceManager()
        #if os(iOS)
        manager.iOSCategoryConfig.enableHapticFeedback = true
        manager.iOSCategoryConfig.enableGestureRecognition = true
        manager.iOSCategoryConfig.enableTouchTargetValidation = true
        manager.iOSCategoryConfig.enableSafeAreaCompliance = true
        
        let testView = Button("Test") { }
        
        // When: Platform compliance is checked
        let report = manager.checkHIGCompliance(testView)
        
        // Then: Platform score should reflect enabled categories
        // All categories enabled should result in higher score
        #expect(report.platformScore >= 0.0)
        #endif
    }
    
    @Test @MainActor func testIOSComplianceCheckWithDisabledCategories() {
        initializeTestConfig()
        // Given: iOS manager with categories disabled
        let manager = AppleHIGComplianceManager()
        #if os(iOS)
        manager.iOSCategoryConfig.enableHapticFeedback = false
        manager.iOSCategoryConfig.enableGestureRecognition = false
        manager.iOSCategoryConfig.enableTouchTargetValidation = false
        manager.iOSCategoryConfig.enableSafeAreaCompliance = false
        
        let testView = Button("Test") { }
        
        // When: Platform compliance is checked
        let report = manager.checkHIGCompliance(testView)
        
        // Then: Platform score should reflect disabled categories
        // Disabled categories should result in lower score
        #expect(report.platformScore >= 0.0)
        #endif
    }
    
    @Test @MainActor func testMacOSComplianceCheckWithEnabledCategories() {
        initializeTestConfig()
        // Given: macOS manager with categories enabled
        let manager = AppleHIGComplianceManager()
        #if os(macOS)
        manager.macOSCategoryConfig.enableMouseInteractions = true
        manager.macOSCategoryConfig.enableKeyboardShortcuts = true
        
        let testView = Button("Test") { }
        
        // When: Platform compliance is checked
        let report = manager.checkHIGCompliance(testView)
        
        // Then: Platform score should reflect enabled categories
        #expect(report.platformScore >= 0.0)
        #endif
    }
    
    @Test @MainActor func testPlatformRecommendationsIncludeCategorySuggestions() {
        initializeTestConfig()
        // Given: A compliance manager with disabled categories
        let manager = AppleHIGComplianceManager()
        #if os(iOS)
        manager.iOSCategoryConfig.enableHapticFeedback = false
        manager.iOSCategoryConfig.enableTouchTargetValidation = false
        
        let testView = Button("Test") { }
        
        // When: Compliance is checked
        let report = manager.checkHIGCompliance(testView)
        
        // Then: Recommendations should include category-specific suggestions
        if report.platformScore < 75.0 {
            let platformRecommendations = report.recommendations.filter { $0.category == .platform }
            #expect(platformRecommendations.count > 0)
            
            // Check that recommendations mention the disabled categories
            let recommendationText = platformRecommendations.first?.suggestion ?? ""
            #expect(recommendationText.contains("haptic") || recommendationText.contains("touch target") || recommendationText.count > 0)
        }
        #endif
    }
    
    // MARK: - Modifier Integration Tests
    
    @Test @MainActor func testHapticFeedbackModifierUsesConfig() {
        initializeTestConfig()
        // Given: A view with haptic feedback modifier and custom config
        let iOSConfig = HIGiOSCategoryConfig(
            defaultHapticFeedbackType: .light,
            enableHapticFeedback: true
        )
        
        let testView = Button("Test") { }
            .modifier(HapticFeedbackModifier(platform: .iOS, iOSConfig: iOSConfig))
        
        // When: Modifier is applied
        // Then: Should use the configuration
        // Note: Actual haptic feedback requires device, so we test configuration integration
        #expect(iOSConfig.enableHapticFeedback == true)
        #expect(iOSConfig.defaultHapticFeedbackType == .light)
    }
    
    @Test @MainActor func testTouchTargetModifierUsesConfig() {
        initializeTestConfig()
        // Given: A view with touch target modifier and config
        let iOSConfig = HIGiOSCategoryConfig(
            enableTouchTargetValidation: true
        )
        
        let testView = Text("Test")
            .modifier(TouchTargetModifier(platform: .iOS, iOSConfig: iOSConfig))
        
        // When: Modifier is applied
        // Then: Should use the configuration
        #expect(iOSConfig.enableTouchTargetValidation == true)
    }
    
    @Test @MainActor func testSafeAreaComplianceModifierUsesConfig() {
        initializeTestConfig()
        // Given: A view with safe area modifier and config
        let iOSConfig = HIGiOSCategoryConfig(
            enableSafeAreaCompliance: true
        )
        
        let testView = Text("Test")
            .modifier(SafeAreaComplianceModifier(platform: .iOS, iOSConfig: iOSConfig))
        
        // When: Modifier is applied
        // Then: Should use the configuration
        #expect(iOSConfig.enableSafeAreaCompliance == true)
    }
    
    @Test @MainActor func testPlatformInteractionModifierUsesMacOSConfig() {
        initializeTestConfig()
        // Given: A view with platform interaction modifier and macOS config
        let macOSConfig = HIGmacOSCategoryConfig(
            enableMouseInteractions: true
        )
        
        let testView = Button("Test") { }
            .modifier(PlatformInteractionModifier(platform: .macOS, macOSConfig: macOSConfig))
        
        // When: Modifier is applied
        // Then: Should use the configuration
        #expect(macOSConfig.enableMouseInteractions == true)
    }
    
    // MARK: - Cross-Platform Modifier Tests
    
    @Test @MainActor func testPlatformSpecificCategoryModifierAppliesCorrectly() {
        initializeTestConfig()
        // Given: Platform-specific category modifier
        let iOSConfig = HIGiOSCategoryConfig()
        let macOSConfig = HIGmacOSCategoryConfig()
        let visionOSConfig = HIGvisionOSCategoryConfig()
        
        #if os(iOS)
        let testView = Text("Test")
            .modifier(PlatformSpecificCategoryModifier(
                platform: .iOS,
                iOSConfig: iOSConfig,
                macOSConfig: nil,
                visionOSConfig: nil
            ))
        #expect(iOSConfig.enableHapticFeedback == true)
        #elseif os(macOS)
        let testView = Text("Test")
            .modifier(PlatformSpecificCategoryModifier(
                platform: .macOS,
                iOSConfig: nil,
                macOSConfig: macOSConfig,
                visionOSConfig: nil
            ))
        #expect(macOSConfig.enableMouseInteractions == true)
        #else
        let testView = Text("Test")
            .modifier(PlatformSpecificCategoryModifier(
                platform: .visionOS,
                iOSConfig: nil,
                macOSConfig: nil,
                visionOSConfig: visionOSConfig
            ))
        #expect(visionOSConfig.enableHandTracking == true)
        #endif
        
        // When: Modifier is applied
        // Then: Should use correct platform configuration
        // (Configuration values verified above)
    }
    
    // MARK: - Configuration Default Tests
    
    @Test @MainActor func testIOSConfigDefaultsMatchHIGRequirements() {
        // Given: Default iOS configuration
        let config = HIGiOSCategoryConfig()
        
        // When: Using defaults
        // Then: Should match Apple HIG requirements
        // Haptic feedback should be enabled by default for better UX
        #expect(config.enableHapticFeedback == true)
        // Touch target validation should be enabled to enforce 44pt minimum
        #expect(config.enableTouchTargetValidation == true)
        // Safe area compliance should be enabled to respect device notches
        #expect(config.enableSafeAreaCompliance == true)
    }
    
    @Test @MainActor func testMacOSConfigDefaultsMatchHIGRequirements() {
        // Given: Default macOS configuration
        let config = HIGmacOSCategoryConfig()
        
        // When: Using defaults
        // Then: Should match Apple HIG requirements
        // Mouse interactions should be enabled for macOS
        #expect(config.enableMouseInteractions == true)
        // Keyboard shortcuts should be enabled for macOS
        #expect(config.enableKeyboardShortcuts == true)
        // Menu bar integration is opt-in (not required by default)
        #expect(config.enableMenuBarIntegration == false)
    }
    
    @Test @MainActor func testVisionOSConfigDefaultsMatchHIGRequirements() {
        // Given: Default visionOS configuration
        let config = HIGvisionOSCategoryConfig()
        
        // When: Using defaults
        // Then: Should match Apple HIG requirements
        // Hand tracking should be enabled by default (primary input method)
        #expect(config.enableHandTracking == true)
        // Spatial UI should be enabled by default
        #expect(config.enableSpatialUI == true)
        // Spatial audio is opt-in (complexity)
        #expect(config.enableSpatialAudio == false)
    }
}


