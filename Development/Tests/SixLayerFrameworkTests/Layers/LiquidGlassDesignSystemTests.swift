//
//  LiquidGlassDesignSystemTests.swift
//  SixLayerFrameworkTests
//
//  Tests for Liquid Glass design system integration
//

import XCTest
@testable import SixLayerFramework

@available(iOS 26.0, macOS 26.0, *)
@MainActor
final class LiquidGlassDesignSystemTests: XCTestCase {
    
    var liquidGlassSystem: LiquidGlassDesignSystem!
    
    override func setUp() {
        super.setUp()
        liquidGlassSystem = LiquidGlassDesignSystem.shared
    }
    
    override func tearDown() {
        liquidGlassSystem = nil
        super.tearDown()
    }
    
    // MARK: - Material Tests
    
    func testLiquidGlassMaterialCreation() {
        // Given
        let material = liquidGlassSystem.createMaterial(.primary)
        
        // Then
        XCTAssertEqual(material.opacity, 0.8, accuracy: 0.01)
        XCTAssertEqual(material.blurRadius, 20.0, accuracy: 0.01)
        XCTAssertTrue(material.isTranslucent)
        XCTAssertEqual(material.reflectionIntensity, 0.3, accuracy: 0.01)
    }
    
    func testLiquidGlassMaterialVariants() {
        // Given & When
        let primary = liquidGlassSystem.createMaterial(.primary)
        let secondary = liquidGlassSystem.createMaterial(.secondary)
        let tertiary = liquidGlassSystem.createMaterial(.tertiary)
        
        // Then
        XCTAssertGreaterThan(primary.opacity, secondary.opacity)
        XCTAssertGreaterThan(secondary.opacity, tertiary.opacity)
        XCTAssertTrue(primary.isTranslucent)
        XCTAssertTrue(secondary.isTranslucent)
        XCTAssertTrue(tertiary.isTranslucent)
    }
    
    func testLiquidGlassMaterialAdaptiveProperties() {
        // Given
        let material = liquidGlassSystem.createMaterial(.primary)
        
        // When
        let adaptiveMaterial = material.adaptive(for: .light)
        
        // Then
        XCTAssertEqual(adaptiveMaterial.opacity, 0.8, accuracy: 0.01)
        XCTAssertTrue(adaptiveMaterial.isTranslucent)
    }
    
    // MARK: - Dynamic Reflection Tests
    
    func testDynamicReflectionGeneration() {
        // Given
        let material = liquidGlassSystem.createMaterial(.primary)
        
        // When
        let reflection = material.generateReflection(for: CGSize(width: 100, height: 100))
        
        // Then
        XCTAssertNotNil(reflection)
        XCTAssertEqual(reflection.size, CGSize(width: 100, height: 100))
        XCTAssertTrue(reflection.isReflective)
    }
    
    func testReflectionIntensityScaling() {
        // Given
        let material = liquidGlassSystem.createMaterial(.primary)
        
        // When
        let lowIntensity = material.reflection(intensity: 0.1)
        let highIntensity = material.reflection(intensity: 0.9)
        
        // Then
        XCTAssertLessThan(lowIntensity.reflectionIntensity, highIntensity.reflectionIntensity)
        XCTAssertEqual(lowIntensity.reflectionIntensity, 0.1, accuracy: 0.01)
        XCTAssertEqual(highIntensity.reflectionIntensity, 0.9, accuracy: 0.01)
    }
    
    // MARK: - Floating Controls Tests
    
    func testFloatingControlCreation() {
        // Given
        let control = FloatingControl(
            type: .navigation,
            position: .top,
            material: liquidGlassSystem.createMaterial(.primary)
        )
        
        // Then
        XCTAssertEqual(control.type, .navigation)
        XCTAssertEqual(control.position, .top)
        XCTAssertEqual(control.material.type, .primary)
        XCTAssertTrue(control.isExpandable)
        XCTAssertFalse(control.isExpanded)
    }
    
    func testFloatingControlExpansion() {
        // Given
        var control = FloatingControl(
            type: .navigation,
            position: .top,
            material: liquidGlassSystem.createMaterial(.primary)
        )
        
        // When
        control.expand()
        
        // Then
        XCTAssertTrue(control.isExpanded)
        XCTAssertTrue(control.isExpandable)
    }
    
    func testFloatingControlContraction() {
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
        XCTAssertFalse(control.isExpanded)
        XCTAssertTrue(control.isExpandable)
    }
    
    // MARK: - Contextual Menus Tests
    
    func testContextualMenuCreation() {
        // Given
        let menu = ContextualMenu(
            items: [
                ContextualMenuItem(title: "Edit", action: {}),
                ContextualMenuItem(title: "Delete", action: {})
            ],
            material: liquidGlassSystem.createMaterial(.secondary)
        )
        
        // Then
        XCTAssertEqual(menu.items.count, 2)
        XCTAssertEqual(menu.material.type, .secondary)
        XCTAssertTrue(menu.isVertical)
        XCTAssertFalse(menu.isVisible)
    }
    
    func testContextualMenuVisibility() {
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
        XCTAssertTrue(menu.isVisible)
    }
    
    func testContextualMenuHiding() {
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
        XCTAssertFalse(menu.isVisible)
    }
    
    // MARK: - Adaptive Wallpapers Tests
    
    func testAdaptiveWallpaperCreation() {
        // Given
        let wallpaper = AdaptiveWallpaper(
            baseImage: "test_wallpaper",
            elements: [
                AdaptiveElement(type: .time, position: .center),
                AdaptiveElement(type: .notifications, position: .top)
            ]
        )
        
        // Then
        XCTAssertEqual(wallpaper.baseImage, "test_wallpaper")
        XCTAssertEqual(wallpaper.elements.count, 2)
        XCTAssertTrue(wallpaper.isAdaptive)
    }
    
    func testAdaptiveElementPositioning() {
        // Given
        let timeElement = AdaptiveElement(type: .time, position: .center)
        let notificationElement = AdaptiveElement(type: .notifications, position: .top)
        
        // Then
        XCTAssertEqual(timeElement.type, .time)
        XCTAssertEqual(timeElement.position, .center)
        XCTAssertEqual(notificationElement.type, .notifications)
        XCTAssertEqual(notificationElement.position, .top)
    }
    
    // MARK: - Platform Compatibility Tests
    
    func testLiquidGlassMaterialPlatformCompatibility() {
        // Given
        let material = liquidGlassSystem.createMaterial(.primary)
        
        // When
        let iOSCompatible = material.isCompatible(with: .iOS)
        let macOSCompatible = material.isCompatible(with: .macOS)
        
        // Then
        XCTAssertTrue(iOSCompatible)
        XCTAssertTrue(macOSCompatible)
    }
    
    func testFloatingControlPlatformSupport() {
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
        XCTAssertTrue(iOSSupported)
        XCTAssertTrue(macOSSupported)
    }
    
    // MARK: - Performance Tests
    
    func testLiquidGlassMaterialPerformance() {
        // Given
        let material = liquidGlassSystem.createMaterial(.primary)
        
        // When
        let startTime = CFAbsoluteTimeGetCurrent()
        let _ = material.generateReflection(for: CGSize(width: 200, height: 200))
        let endTime = CFAbsoluteTimeGetCurrent()
        
        // Then
        let executionTime = endTime - startTime
        XCTAssertLessThan(executionTime, 0.1) // Should complete in under 100ms
    }
    
    func testFloatingControlAnimationPerformance() {
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
        XCTAssertLessThan(executionTime, 0.05) // Should complete in under 50ms
    }
    
    // MARK: - Accessibility Tests
    
    func testLiquidGlassMaterialAccessibility() {
        // Given
        let material = liquidGlassSystem.createMaterial(.primary)
        
        // When
        let accessibilityInfo = material.accessibilityInfo
        
        // Then
        XCTAssertTrue(accessibilityInfo.supportsVoiceOver)
        XCTAssertTrue(accessibilityInfo.supportsReduceMotion)
        XCTAssertTrue(accessibilityInfo.supportsHighContrast)
    }
    
    func testFloatingControlAccessibility() {
        // Given
        let control = FloatingControl(
            type: .navigation,
            position: .top,
            material: liquidGlassSystem.createMaterial(.primary)
        )
        
        // When
        let accessibilityInfo = control.accessibilityInfo
        
        // Then
        XCTAssertTrue(accessibilityInfo.supportsVoiceOver)
        XCTAssertTrue(accessibilityInfo.supportsSwitchControl ?? false)
        XCTAssertNotNil(accessibilityInfo.accessibilityLabel)
    }
    
    // MARK: - Integration Tests
    
    func testLiquidGlassSystemIntegration() {
        // Given
        let system = LiquidGlassDesignSystem.shared
        
        // When
        let material = system.createMaterial(.primary)
        let control = system.createFloatingControl(type: .navigation)
        let menu = system.createContextualMenu(items: [])
        
        // Then
        XCTAssertNotNil(material)
        XCTAssertNotNil(control)
        XCTAssertNotNil(menu)
        XCTAssertTrue(system.isLiquidGlassEnabled)
    }
    
    func testLiquidGlassSystemThemeAdaptation() {
        // Given
        let system = LiquidGlassDesignSystem.shared
        
        // When
        system.adaptToTheme(.light)
        let lightMaterial = system.createMaterial(.primary)
        
        system.adaptToTheme(.dark)
        let darkMaterial = system.createMaterial(.primary)
        
        // Then
        XCTAssertNotEqual(lightMaterial.opacity, darkMaterial.opacity)
        XCTAssertTrue(lightMaterial.isTranslucent)
        XCTAssertTrue(darkMaterial.isTranslucent)
    }
}
