#if canImport(Testing)

import Testing
import Foundation

#if os(iOS) || os(macOS)

//
//  LiquidGlassDesignSystemTests.swift
//  SixLayerFrameworkTests
//
//  Tests for Liquid Glass design system integration
//

@testable import SixLayerFramework

struct LiquidGlassDesignSystemTests {
    
    // MARK: - Material Tests
    
    @MainActor
    @Test func testLiquidGlassMaterialCreation() {
        // Check availability before testing
        guard #available(iOS 26.0, macOS 26.0, *) else {
            // Skip test on older platforms - this is expected behavior
            return
        }
        
        // Given
        let liquidGlassSystem = LiquidGlassDesignSystem.shared
        let material = liquidGlassSystem.createMaterial(.primary)
        
        // Then
        #expect(material.opacity == 0.8)
        #expect(material.blurRadius == 20.0)
        #expect(material.isTranslucent)
        #expect(material.reflectionIntensity == 0.3)
    }
    
    @MainActor
    @Test func testLiquidGlassMaterialVariants() {
        // Check availability before testing
        guard #available(iOS 26.0, macOS 26.0, *) else {
            return
        }
        
        // Given & When
        let liquidGlassSystem = LiquidGlassDesignSystem.shared
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
    
    @MainActor
    @Test func testLiquidGlassMaterialAdaptiveProperties() {
        // Check availability before testing
        guard #available(iOS 26.0, macOS 26.0, *) else {
            return
        }
        
        // Given
        let liquidGlassSystem = LiquidGlassDesignSystem.shared
        let material = liquidGlassSystem.createMaterial(.primary)
        
        // When
        let adaptiveMaterial = material.adaptive(for: .light)
        
        // Then
        #expect(adaptiveMaterial.opacity == 0.8)
        #expect(adaptiveMaterial.isTranslucent)
    }
    
    // MARK: - Dynamic Reflection Tests
    
    @MainActor
    @Test func testDynamicReflectionGeneration() {
        // Check availability before testing
        guard #available(iOS 26.0, macOS 26.0, *) else {
            return
        }
        
        // Given
        let liquidGlassSystem = LiquidGlassDesignSystem.shared
        let material = liquidGlassSystem.createMaterial(.primary)
        
        // When
        let reflection = material.generateReflection(for: CGSize(width: 100, height: 100))
        
        // Then
        #expect(reflection != nil)
        #expect(reflection.size == CGSize(width: 100, height: 100))
        #expect(reflection.isReflective == true)
    }
    
    @MainActor
    @Test func testReflectionIntensityScaling() {
        // Check availability before testing
        guard #available(iOS 26.0, macOS 26.0, *) else {
            return
        }
        
        // Given
        let liquidGlassSystem = LiquidGlassDesignSystem.shared
        let material = liquidGlassSystem.createMaterial(.primary)
        
        // When
        let reflection = material.generateReflection(for: CGSize(width: 200, height: 200))
        
        // Then
        #expect(reflection != nil)
        #expect(reflection.size == CGSize(width: 200, height: 200))
    }
    
    // MARK: - Floating Control Tests
    
    @MainActor
    @Test func testFloatingControlCreation() {
        // Check availability before testing
        guard #available(iOS 26.0, macOS 26.0, *) else {
            return
        }
        
        // Given & When
        let liquidGlassSystem = LiquidGlassDesignSystem.shared
        var control = FloatingControl(
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
    
    @MainActor
    @Test func testFloatingControlExpansion() {
        // Check availability before testing
        guard #available(iOS 26.0, macOS 26.0, *) else {
            return
        }
        
        // Given
        let liquidGlassSystem = LiquidGlassDesignSystem.shared
        var control = FloatingControl(
            type: .navigation,
            position: .top,
            material: liquidGlassSystem.createMaterial(.primary)
        )
        
        // When
        control.expand()
        
        // Then
        #expect(control.isExpanded)
    }
    
    @MainActor
    @Test func testFloatingControlCollapse() {
        // Check availability before testing
        guard #available(iOS 26.0, macOS 26.0, *) else {
            return
        }
        
        // Given
        let liquidGlassSystem = LiquidGlassDesignSystem.shared
        var control = FloatingControl(
            type: .navigation,
            position: .top,
            material: liquidGlassSystem.createMaterial(.primary)
        )
        control.expand()
        
        // When
        control.collapse()
        
        // Then
        #expect(!control.isExpanded)
    }
    
    // MARK: - Contextual Menu Tests
    
    @MainActor
    @Test func testContextualMenuCreation() {
        // Check availability before testing
        guard #available(iOS 26.0, macOS 26.0, *) else {
            return
        }
        
        // Given & When
        let liquidGlassSystem = LiquidGlassDesignSystem.shared
        var menu = ContextualMenu(
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
    
    @MainActor
    @Test func testContextualMenuShow() {
        // Check availability before testing
        guard #available(iOS 26.0, macOS 26.0, *) else {
            return
        }
        
        // Given
        let liquidGlassSystem = LiquidGlassDesignSystem.shared
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
    
    @MainActor
    @Test func testContextualMenuHide() {
        // Check availability before testing
        guard #available(iOS 26.0, macOS 26.0, *) else {
            return
        }
        
        // Given
        let liquidGlassSystem = LiquidGlassDesignSystem.shared
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
    
    // MARK: - Platform Compatibility Tests
    
    @MainActor
    @Test func testLiquidGlassMaterialPlatformCompatibility() {
        // Check availability before testing
        guard #available(iOS 26.0, macOS 26.0, *) else {
            return
        }
        
        // Given
        let liquidGlassSystem = LiquidGlassDesignSystem.shared
        let material = liquidGlassSystem.createMaterial(.primary)
        
        // When
        let iOSCompatible = material.isCompatible(with: .iOS)
        let macOSCompatible = material.isCompatible(with: .macOS)
        
        // Then
        #expect(iOSCompatible)
        #expect(macOSCompatible)
    }
    
    @MainActor
    @Test func testFloatingControlPlatformSupport() {
        // Check availability before testing
        guard #available(iOS 26.0, macOS 26.0, *) else {
            return
        }
        
        // Given
        let liquidGlassSystem = LiquidGlassDesignSystem.shared
        var control = FloatingControl(
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
    
    @MainActor
    @Test func testLiquidGlassMaterialPerformance() {
        // Check availability before testing
        guard #available(iOS 26.0, macOS 26.0, *) else {
            return
        }
        
        // Given
        let liquidGlassSystem = LiquidGlassDesignSystem.shared
        let material = liquidGlassSystem.createMaterial(.primary)
        
        // When
        let startTime = CFAbsoluteTimeGetCurrent()
        let reflection = material.generateReflection(for: CGSize(width: 1000, height: 1000))
        let endTime = CFAbsoluteTimeGetCurrent()
        
        // Then
        let executionTime = endTime - startTime
        #expect(executionTime < 1.0) // Should complete within 1 second
        #expect(reflection != nil)
    }
    
    @MainActor
    @Test func testFloatingControlPerformance() {
        // Check availability before testing
        guard #available(iOS 26.0, macOS 26.0, *) else {
            return
        }
        
        // Given
        let liquidGlassSystem = LiquidGlassDesignSystem.shared
        var control = FloatingControl(
            type: .navigation,
            position: .top,
            material: liquidGlassSystem.createMaterial(.primary)
        )
        
        // When
        let startTime = CFAbsoluteTimeGetCurrent()
        control.expand()
        control.collapse()
        let endTime = CFAbsoluteTimeGetCurrent()
        
        // Then
        let executionTime = endTime - startTime
        #expect(executionTime < 0.1) // Should complete within 100ms
    }
    
    // MARK: - Accessibility Tests
    
    @MainActor
    @Test func testLiquidGlassMaterialAccessibility() {
        // Check availability before testing
        guard #available(iOS 26.0, macOS 26.0, *) else {
            return
        }
        
        // Given
        let liquidGlassSystem = LiquidGlassDesignSystem.shared
        let material = liquidGlassSystem.createMaterial(.primary)
        
        // When
        let reflection = material.generateReflection(for: CGSize(width: 100, height: 100))
        
        // Then
        #expect(material.isTranslucent) // Should be accessible
        #expect(reflection != nil)
    }
    
    @MainActor
    @Test func testFloatingControlAccessibility() {
        // Check availability before testing
        guard #available(iOS 26.0, macOS 26.0, *) else {
            return
        }
        
        // Given
        let liquidGlassSystem = LiquidGlassDesignSystem.shared
        var control = FloatingControl(
            type: .navigation,
            position: .top,
            material: liquidGlassSystem.createMaterial(.primary)
        )
        
        // Then
        #expect(control.isExpandable) // Should be accessible
        #expect(control.material.isTranslucent)
    }
    
    // MARK: - System Integration Tests
    
    @MainActor
    @Test func testLiquidGlassSystemIntegration() {
        // Check availability before testing
        guard #available(iOS 26.0, macOS 26.0, *) else {
            return
        }
        
        // Given
        let liquidGlassSystem = LiquidGlassDesignSystem.shared
        let system = LiquidGlassDesignSystem()
        let material = liquidGlassSystem.createMaterial(.primary)
        var control = FloatingControl(
            type: .navigation,
            position: .top,
            material: material
        )
        var menu = ContextualMenu(
            items: [ContextualMenuItem(title: "Test", action: {})],
            material: liquidGlassSystem.createMaterial(.secondary)
        )
        
        // Then
        #expect(material != nil)
        #expect(control != nil)
        #expect(menu != nil)
        #expect(system.isLiquidGlassEnabled)
    }
    
    // MARK: - Fallback Behavior Tests
    
    @MainActor
    @Test func testLiquidGlassFallbackBehaviors() {
        // Check availability before testing
        guard #available(iOS 26.0, macOS 26.0, *) else {
            return
        }
        
        // Given & When
        let system = LiquidGlassDesignSystem()
        for feature in LiquidGlassFeature.allCases {
            let fallbackBehavior = system.getFallbackBehavior(for: feature)
            
            // Then
            #expect(fallbackBehavior != nil, "Feature \(feature.rawValue) should have a fallback behavior")
        }
    }
}

#endif

#endif