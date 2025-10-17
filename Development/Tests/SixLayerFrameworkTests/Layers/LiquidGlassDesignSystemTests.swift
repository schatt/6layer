import Testing
import Foundation


//
//  LiquidGlassDesignSystemTests.swift
//  SixLayerFrameworkTests
//
//  Tests for Liquid Glass design system integration
//

@testable import SixLayerFramework

@available(iOS 26.0, macOS 26.0, *)
@MainActor
open class LiquidGlassDesignSystemTests {
    
    var liquidGlassSystem: LiquidGlassDesignSystem!
    
    init() async throws {
        liquidGlassSystem = LiquidGlassDesignSystem.shared
    }
    
    deinit {
        Task { [weak self] in
            await self?.cleanupTestEnvironment()
        }
    }
    
    // MARK: - Material Tests
    
    @Test func testLiquidGlassMaterialCreation() {
        // Given
        let material = liquidGlassSystem.createMaterial(.primary)
        
        // Then
        #expect(material.opacity == 0.8)
        #expect(material.blurRadius == 20.0)
        #expect(material.isTranslucent)
        #expect(material.reflectionIntensity == 0.3)
    }
    
    @Test func testLiquidGlassMaterialVariants() {
        // Given & When
        let primary = liquidGlassSystem.createMaterial(.primary)
        let secondary = liquidGlassSystem.createMaterial(.secondary)
        let tertiary = liquidGlassSystem.createMaterial(.tertiary)
        
        // Then
        #expect(primary.opacity > secondary.opacity)
        #expect(secondary.opacity > tertiary.opacity)
        #expect(primary.isTranslucent)
        #expect(secondary.isTranslucent)
        #expect(tertiary.isTranslucent)
    }
    
    @Test func testLiquidGlassMaterialAdaptiveProperties() {
        // Given
        let material = liquidGlassSystem.createMaterial(.primary)
        
        // When
        let adaptiveMaterial = material.adaptive(for: .light)
        
        // Then
        #expect(adaptiveMaterial.opacity == 0.8)
        #expect(adaptiveMaterial.isTranslucent)
    }
    
    // MARK: - Dynamic Reflection Tests
    
    @Test func testDynamicReflectionGeneration() {
        // Given
        let material = liquidGlassSystem.createMaterial(.primary)
        
        // When
        let reflection = material.generateReflection(for: CGSize(width: 100, height: 100))
        
        // Then
        #expect(reflection != nil)
        #expect(reflection.size == CGSize(width: 100, height: 100))
        #expect(reflection.isReflective)
    }
    
    @Test func testReflectionIntensityScaling() {
        // Given
        let material = liquidGlassSystem.createMaterial(.primary)
        
        // When
        let lowIntensity = material.reflection(intensity: 0.1)
        let highIntensity = material.reflection(intensity: 0.9)
        
        // Then
        #expect(lowIntensity.reflectionIntensity < highIntensity.reflectionIntensity)
        #expect(lowIntensity.reflectionIntensity == 0.1)
        #expect(highIntensity.reflectionIntensity == 0.9)
    }
    
    // MARK: - Floating Controls Tests
    
    @Test func testFloatingControlCreation() {
        // Given
        let control = FloatingControl(
            type: .navigation,
            position: .top,
            material: liquidGlassSystem.createMaterial(.primary)
        )
        
        // Then
        #expect(control.type == .navigation)
        #expect(control.position == .top)
        #expect(control.material.type == .primary)
        #expect(control.isExpandable)
        #expect(!control.isExpanded)
    }
    
    @Test func testFloatingControlExpansion() {
        // Given
        var control = FloatingControl(
            type: .navigation,
            position: .top,
            material: liquidGlassSystem.createMaterial(.primary)
        )
        
        // When
        control.expand()
        
        // Then
        #expect(control.isExpanded)
        #expect(control.isExpandable)
    }
    
    @Test func testFloatingControlContraction() {
        // Given
        var control = FloatingControl(
            type: .navigation,
            position: .top,
            material: liquidGlassSystem.createMaterial(.primary)
        )
        control.expand()
        
        // When
        control.contract()
        
        // Then
        #expect(!control.isExpanded)
        #expect(control.isExpandable)
    }
    
    // MARK: - Contextual Menus Tests
    
    @Test func testContextualMenuCreation() {
        // Given
        let menu = ContextualMenu(
            items: [
                ContextualMenuItem(title: "Edit", action: {}),
                ContextualMenuItem(title: "Delete", action: {})
            ],
            material: liquidGlassSystem.createMaterial(.secondary)
        )
        
        // Then
        #expect(menu.items.count == 2)
        #expect(menu.material.type == .secondary)
        #expect(menu.isVertical)
        #expect(!menu.isVisible)
    }
    
    @Test func testContextualMenuVisibility() {
        // Given
        var menu = ContextualMenu(
            items: [
                ContextualMenuItem(title: "Edit", action: {})
            ],
            material: liquidGlassSystem.createMaterial(.secondary)
        )
        
        // When
        menu.show()
        
        // Then
        #expect(menu.isVisible)
    }
    
    @Test func testContextualMenuHiding() {
        // Given
        var menu = ContextualMenu(
            items: [
                ContextualMenuItem(title: "Edit", action: {})
            ],
            material: liquidGlassSystem.createMaterial(.secondary)
        )
        menu.show()
        
        // When
        menu.hide()
        
        // Then
        #expect(!menu.isVisible)
    }
    
    // MARK: - Adaptive Wallpapers Tests
    
    @Test func testAdaptiveWallpaperCreation() {
        // Given
        let wallpaper = AdaptiveWallpaper(
            baseImage: "test_wallpaper",
            elements: [
                AdaptiveElement(type: .time, position: .center),
                AdaptiveElement(type: .notifications, position: .top)
            ]
        )
        
        // Then
        #expect(wallpaper.baseImage == "test_wallpaper")
        #expect(wallpaper.elements.count == 2)
        #expect(wallpaper.isAdaptive)
    }
    
    @Test func testAdaptiveElementPositioning() {
        // Given
        let timeElement = AdaptiveElement(type: .time, position: .center)
        let notificationElement = AdaptiveElement(type: .notifications, position: .top)
        
        // Then
        #expect(timeElement.type == .time)
        #expect(timeElement.position == .center)
        #expect(notificationElement.type == .notifications)
        #expect(notificationElement.position == .top)
    }
    
    // MARK: - Platform Compatibility Tests
    
    @Test func testLiquidGlassMaterialPlatformCompatibility() {
        // Given
        let material = liquidGlassSystem.createMaterial(.primary)
        
        // When
        let iOSCompatible = material.isCompatible(with: .iOS)
        let macOSCompatible = material.isCompatible(with: .macOS)
        
        // Then
        #expect(iOSCompatible)
        #expect(macOSCompatible)
    }
    
    @Test func testFloatingControlPlatformSupport() {
        // Given
        let control = FloatingControl(
            type: .navigation,
            position: .top,
            material: liquidGlassSystem.createMaterial(.primary)
        )
        
        // When
        let iOSSupported = control.isSupported(on: .iOS)
        let macOSSupported = control.isSupported(on: .macOS)
        
        // Then
        #expect(iOSSupported)
        #expect(macOSSupported)
    }
    
    // MARK: - Performance Tests
    
    @Test func testLiquidGlassMaterialPerformance() {
        // Given
        let material = liquidGlassSystem.createMaterial(.primary)
        
        // When
        let startTime = CFAbsoluteTimeGetCurrent()
        let _ = material.generateReflection(for: CGSize(width: 200, height: 200))
        let endTime = CFAbsoluteTimeGetCurrent()
        
        // Then
        let executionTime = endTime - startTime
        #expect(executionTime < 0.1) // Should complete in under 100ms
    }
    
    @Test func testFloatingControlAnimationPerformance() {
        // Given
        var control = FloatingControl(
            type: .navigation,
            position: .top,
            material: liquidGlassSystem.createMaterial(.primary)
        )
        
        // When
        let startTime = CFAbsoluteTimeGetCurrent()
        control.expand()
        control.contract()
        let endTime = CFAbsoluteTimeGetCurrent()
        
        // Then
        let executionTime = endTime - startTime
        #expect(executionTime < 0.05) // Should complete in under 50ms
    }
    
    // MARK: - Accessibility Tests
    
    @Test func testLiquidGlassMaterialAccessibility() {
        // Given
        let material = liquidGlassSystem.createMaterial(.primary)
        
        // When
        let accessibilityInfo = material.accessibilityInfo
        
        // Then
        #expect(accessibilityInfo.supportsVoiceOver)
        #expect(accessibilityInfo.supportsReduceMotion)
        #expect(accessibilityInfo.supportsHighContrast)
    }
    
    @Test func testFloatingControlAccessibility() {
        // Given
        let control = FloatingControl(
            type: .navigation,
            position: .top,
            material: liquidGlassSystem.createMaterial(.primary)
        )
        
        // When
        let accessibilityInfo = control.accessibilityInfo
        
        // Then
        #expect(accessibilityInfo.supportsVoiceOver)
        #expect(accessibilityInfo.supportsSwitchControl ?? false)
        #expect(accessibilityInfo.accessibilityLabel != nil)
    }
    
    // MARK: - Integration Tests
    
    @Test func testLiquidGlassSystemIntegration() {
        // Given
        let system = LiquidGlassDesignSystem.shared
        
        // When
        let material = system.createMaterial(.primary)
        let control = system.createFloatingControl(type: .navigation)
        let menu = system.createContextualMenu(items: [])
        
        // Then
        #expect(material != nil)
        #expect(control != nil)
        #expect(menu != nil)
        #expect(system.isLiquidGlassEnabled)
    }
    
    @Test func testLiquidGlassSystemThemeAdaptation() {
        // Given
        let system = LiquidGlassDesignSystem.shared
        
        // When
        system.adaptToTheme(.light)
        let lightMaterial = system.createMaterial(.primary)
        
        system.adaptToTheme(.dark)
        let darkMaterial = system.createMaterial(.primary)
        
        // Then
        #expect(lightMaterial.opacity != darkMaterial.opacity)
        #expect(lightMaterial.isTranslucent)
        #expect(darkMaterial.isTranslucent)
    }
}
