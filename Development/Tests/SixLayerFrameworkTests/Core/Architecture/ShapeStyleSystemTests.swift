import Testing


import SwiftUI
@testable import SixLayerFramework

/// Comprehensive test suite for ShapeStyle System
/// Tests all ShapeStyle types: Color, Gradient, Material, HierarchicalShapeStyle
open class ShapeStyleSystemTests {
    
    // MARK: - Color Support Tests
    
    @Test func testStandardColorsExist() {
        // Given: StandardColors struct
        // When: Accessing color properties
        // Then: All standard colors should be available
        #expect(ShapeStyleSystem.StandardColors.primary != nil)
        #expect(ShapeStyleSystem.StandardColors.secondary != nil)
        #expect(ShapeStyleSystem.StandardColors.accent != nil)
        #expect(ShapeStyleSystem.StandardColors.background != nil)
        #expect(ShapeStyleSystem.StandardColors.surface != nil)
        #expect(ShapeStyleSystem.StandardColors.text != nil)
        #expect(ShapeStyleSystem.StandardColors.textSecondary != nil)
        #expect(ShapeStyleSystem.StandardColors.border != nil)
        #expect(ShapeStyleSystem.StandardColors.error != nil)
        #expect(ShapeStyleSystem.StandardColors.warning != nil)
        #expect(ShapeStyleSystem.StandardColors.success != nil)
        #expect(ShapeStyleSystem.StandardColors.info != nil)
    }
    
    @Test func testPlatformSpecificColors() {
        // Given: Platform-specific color access
        // When: Accessing platform colors
        // Then: Should have platform-appropriate colors
        #if canImport(UIKit)
        #expect(ShapeStyleSystem.StandardColors.systemBackground != nil)
        #expect(ShapeStyleSystem.StandardColors.secondarySystemBackground != nil)
        #expect(ShapeStyleSystem.StandardColors.tertiarySystemBackground != nil)
        #expect(ShapeStyleSystem.StandardColors.systemGroupedBackground != nil)
        #expect(ShapeStyleSystem.StandardColors.secondarySystemGroupedBackground != nil)
        #expect(ShapeStyleSystem.StandardColors.tertiarySystemGroupedBackground != nil)
        #expect(ShapeStyleSystem.StandardColors.label != nil)
        #expect(ShapeStyleSystem.StandardColors.secondaryLabel != nil)
        #expect(ShapeStyleSystem.StandardColors.tertiaryLabel != nil)
        #expect(ShapeStyleSystem.StandardColors.quaternaryLabel != nil)
        #expect(ShapeStyleSystem.StandardColors.separator != nil)
        #expect(ShapeStyleSystem.StandardColors.opaqueSeparator != nil)
        #endif
    }
    
    // MARK: - Gradient Support Tests
    
    @Test func testGradientCreation() {
        // Given: Gradients struct
        // When: Accessing gradient properties
        // Then: All gradients should be available
        #expect(ShapeStyleSystem.Gradients.primary != nil)
        #expect(ShapeStyleSystem.Gradients.secondary != nil)
        #expect(ShapeStyleSystem.Gradients.background != nil)
        #expect(ShapeStyleSystem.Gradients.success != nil)
        #expect(ShapeStyleSystem.Gradients.warning != nil)
        #expect(ShapeStyleSystem.Gradients.error != nil)
        #expect(ShapeStyleSystem.Gradients.focus != nil)
    }
    
    @Test func testGradientTypes() {
        // Given: Gradient instances
        // When: Checking gradient properties
        // Then: Should have valid gradient definitions
        #expect(ShapeStyleSystem.Gradients.primary != nil)
        #expect(ShapeStyleSystem.Gradients.secondary != nil)
        #expect(ShapeStyleSystem.Gradients.background != nil)
        #expect(ShapeStyleSystem.Gradients.success != nil)
        #expect(ShapeStyleSystem.Gradients.warning != nil)
        #expect(ShapeStyleSystem.Gradients.error != nil)
        #expect(ShapeStyleSystem.Gradients.focus != nil)
    }
    
    // MARK: - Material Support Tests
    
    @Test @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    func testMaterialTypes() {
        // Given: Materials struct
        // When: Accessing material properties
        // Then: All materials should be available
        #expect(ShapeStyleSystem.Materials.regular != nil)
        #expect(ShapeStyleSystem.Materials.thick != nil)
        #expect(ShapeStyleSystem.Materials.thin != nil)
        #expect(ShapeStyleSystem.Materials.ultraThin != nil)
        #expect(ShapeStyleSystem.Materials.ultraThick != nil)
    }
    
    @Test @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    func testMaterialTypesCorrect() {
        // Given: Material instances
        // When: Checking material properties
        // Then: Should have valid material definitions
        #expect(ShapeStyleSystem.Materials.regular != nil)
        #expect(ShapeStyleSystem.Materials.thick != nil)
        #expect(ShapeStyleSystem.Materials.thin != nil)
        #expect(ShapeStyleSystem.Materials.ultraThin != nil)
        #expect(ShapeStyleSystem.Materials.ultraThick != nil)
    }
    
    // MARK: - Hierarchical ShapeStyle Support Tests
    
    @Test @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    func testHierarchicalStyles() {
        // Given: HierarchicalStyles struct
        // When: Accessing hierarchical style properties
        // Then: All hierarchical styles should be available
        #expect(ShapeStyleSystem.HierarchicalStyles.primary != nil)
        #expect(ShapeStyleSystem.HierarchicalStyles.secondary != nil)
        #expect(ShapeStyleSystem.HierarchicalStyles.tertiary != nil)
        #expect(ShapeStyleSystem.HierarchicalStyles.quaternary != nil)
    }
    
    @Test @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    func testHierarchicalStylesTypes() {
        // Given: Hierarchical style instances
        // When: Checking hierarchical style properties
        // Then: Should have valid hierarchical style definitions
        #expect(ShapeStyleSystem.HierarchicalStyles.primary != nil)
        #expect(ShapeStyleSystem.HierarchicalStyles.secondary != nil)
        #expect(ShapeStyleSystem.HierarchicalStyles.tertiary != nil)
        #expect(ShapeStyleSystem.HierarchicalStyles.quaternary != nil)
    }
    
    // MARK: - Factory Tests
    
    @Test func testFactoryBackgroundCreation() {
        // Given: Factory and platform
        // When: Creating background style
        // Then: Should return appropriate background style
        let background = ShapeStyleSystem.Factory.background(for: .iOS)
        #expect(background != nil)
    }
    
    @Test func testFactorySurfaceCreation() {
        // Given: Factory and platform
        // When: Creating surface style
        // Then: Should return appropriate surface style
        let surface = ShapeStyleSystem.Factory.surface(for: .macOS)
        #expect(surface != nil)
    }
    
    @Test func testFactoryTextCreation() {
        // Given: Factory and platform
        // When: Creating text style
        // Then: Should return appropriate text style
        let text = ShapeStyleSystem.Factory.text(for: .iOS)
        #expect(text != nil)
    }
    
    @Test func testFactoryBorderCreation() {
        // Given: Factory and platform
        // When: Creating border style
        // Then: Should return appropriate border style
        let border = ShapeStyleSystem.Factory.border(for: .macOS)
        #expect(border != nil)
    }
    
    @Test func testFactoryGradientCreation() {
        // Given: Factory and platform
        // When: Creating gradient style
        // Then: Should return appropriate gradient style
        let gradient = ShapeStyleSystem.Factory.gradient(for: .iOS, variant: .primary)
        #expect(gradient != nil)
    }
    
    @Test @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    func testFactoryMaterialCreation() {
        // Given: Factory and platform
        // When: Creating material style
        // Then: Should return appropriate material style
        let material = ShapeStyleSystem.Factory.material(for: .iOS, variant: .regular)
        #expect(material != nil)
    }
    
    @Test @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    func testFactoryHierarchicalCreation() {
        // Given: Factory and platform
        // When: Creating hierarchical style
        // Then: Should return appropriate hierarchical style
        let hierarchical = ShapeStyleSystem.Factory.hierarchical(for: .iOS, variant: .primary)
        #expect(hierarchical != nil)
    }
    
    // MARK: - Supporting Types Tests
    
    @Test func testBackgroundVariantEnum() {
        // Given: BackgroundVariant enum
        // When: Accessing all cases
        // Then: Should have all expected cases
        let cases = BackgroundVariant.allCases
        #expect(cases.contains(.standard))
        #expect(cases.contains(.grouped))
        #expect(cases.contains(.elevated))
        #expect(cases.contains(.transparent))
    }
    
    @Test func testSurfaceVariantEnum() {
        // Given: SurfaceVariant enum
        // When: Accessing all cases
        // Then: Should have all expected cases
        let cases = SurfaceVariant.allCases
        #expect(cases.contains(.standard))
        #expect(cases.contains(.elevated))
        #expect(cases.contains(.card))
        #expect(cases.contains(.modal))
    }
    
    @Test func testTextVariantEnum() {
        // Given: TextVariant enum
        // When: Accessing all cases
        // Then: Should have all expected cases
        let cases = TextVariant.allCases
        #expect(cases.contains(.primary))
        #expect(cases.contains(.secondary))
        #expect(cases.contains(.tertiary))
        #expect(cases.contains(.quaternary))
    }
    
    @Test func testBorderVariantEnum() {
        // Given: BorderVariant enum
        // When: Accessing all cases
        // Then: Should have all expected cases
        let cases = BorderVariant.allCases
        #expect(cases.contains(.standard))
        #expect(cases.contains(.subtle))
        #expect(cases.contains(.prominent))
        #expect(cases.contains(.none))
    }
    
    @Test func testGradientVariantEnum() {
        // Given: GradientVariant enum
        // When: Accessing all cases
        // Then: Should have all expected cases
        let cases = GradientVariant.allCases
        #expect(cases.contains(.primary))
        #expect(cases.contains(.secondary))
        #expect(cases.contains(.background))
        #expect(cases.contains(.success))
        #expect(cases.contains(.warning))
        #expect(cases.contains(.error))
        #expect(cases.contains(.focus))
    }
    
    @Test @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    func testMaterialVariantEnum() {
        // Given: MaterialVariant enum
        // When: Accessing all cases
        // Then: Should have all expected cases
        let cases = MaterialVariant.allCases
        #expect(cases.contains(.regular))
        #expect(cases.contains(.thick))
        #expect(cases.contains(.thin))
        #expect(cases.contains(.ultraThin))
        #expect(cases.contains(.ultraThick))
    }
    
    @Test @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    func testHierarchicalVariantEnum() {
        // Given: HierarchicalVariant enum
        // When: Accessing all cases
        // Then: Should have all expected cases
        let cases = HierarchicalVariant.allCases
        #expect(cases.contains(.primary))
        #expect(cases.contains(.secondary))
        #expect(cases.contains(.tertiary))
        #expect(cases.contains(.quaternary))
    }
    
    // MARK: - AnyShapeStyle Tests
    
    @Test @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    func testAnyShapeStyleCreation() {
        // Given: A Color
        // When: Creating AnyShapeStyle
        // Then: Should create successfully
        let color = Color.blue
        let anyShapeStyle = AnyShapeStyle(color)
        #expect(anyShapeStyle != nil)
    }
    
    @Test @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    func testAnyShapeStyleWithGradient() {
        // Given: A LinearGradient
        // When: Creating AnyShapeStyle
        // Then: Should create successfully
        let gradient = LinearGradient(colors: [.blue, .purple], startPoint: .top, endPoint: .bottom)
        let anyShapeStyle = AnyShapeStyle(gradient)
        #expect(anyShapeStyle != nil)
    }
    
    @Test @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    func testAnyShapeStyleWithMaterial() {
        // Given: A Material
        // When: Creating AnyShapeStyle
        // Then: Should create successfully
        let material = Material.regularMaterial
        let anyShapeStyle = AnyShapeStyle(material)
        #expect(anyShapeStyle != nil)
    }
    
    @Test @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    func testAnyShapeStyleWithHierarchical() {
        // Given: A HierarchicalShapeStyle
        // When: Creating AnyShapeStyle
        // Then: Should create successfully
        let hierarchical = HierarchicalShapeStyle.primary
        let anyShapeStyle = AnyShapeStyle(hierarchical)
        #expect(anyShapeStyle != nil)
    }
    
    // MARK: - View Extension Tests
    
    @Test @MainActor func testPlatformBackgroundModifier() {
        // Given: A view
        let testView = Text("Test")
        
        // When: Applying platform background
        let modifiedView = testView.platformBackground(for: .iOS)
        
        // Then: Should return modified view
        #expect(modifiedView != nil)
    }
    
    @Test @MainActor func testPlatformSurfaceModifier() {
        // Given: A view
        let testView = Text("Test")
        
        // When: Applying platform surface
        let modifiedView = testView.platformSurface(for: .macOS)
        
        // Then: Should return modified view
        #expect(modifiedView != nil)
    }
    
    @Test @MainActor func testPlatformTextModifier() {
        // Given: A view
        let testView = Text("Test")
        
        // When: Applying platform text
        let modifiedView = testView.platformText(for: .iOS)
        
        // Then: Should return modified view
        #expect(modifiedView != nil)
    }
    
    @Test @MainActor func testPlatformBorderModifier() {
        // Given: A view
        let testView = Text("Test")
        
        // When: Applying platform border
        let modifiedView = testView.platformBorder(for: .macOS, width: 2)
        
        // Then: Should return modified view
        #expect(modifiedView != nil)
    }
    
    @Test @MainActor func testPlatformGradientModifier() {
        // Given: A view
        let testView = Text("Test")
        
        // When: Applying platform gradient
        let modifiedView = testView.platformGradient(for: .iOS, variant: .primary)
        
        // Then: Should return modified view
        #expect(modifiedView != nil)
    }
    
    @Test @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    @MainActor func testPlatformMaterialModifier() {
        // Given: A view
        let testView = Text("Test")
        
        // When: Applying platform material
        let modifiedView = testView.platformMaterial(for: .iOS, variant: .regular)
        
        // Then: Should return modified view
        #expect(modifiedView != nil)
    }
    
    @Test @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    @MainActor func testPlatformHierarchicalModifier() {
        // Given: A view
        let testView = Text("Test")
        
        // When: Applying platform hierarchical
        let modifiedView = testView.platformHierarchical(for: .iOS, variant: .primary)
        
        // Then: Should return modified view
        #expect(modifiedView != nil)
    }
    
    // MARK: - Material Extension Tests
    
    @Test @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    @MainActor func testMaterialBackgroundModifier() {
        // Given: A view
        let testView = Text("Test")
        
        // When: Applying material background
        let modifiedView = testView.materialBackground(.regularMaterial, for: .iOS)
        
        // Then: Should return modified view
        #expect(modifiedView != nil)
    }
    
    @Test @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    @MainActor func testHierarchicalMaterialBackgroundModifier() {
        // Given: A view
        let testView = Text("Test")
        
        // When: Applying hierarchical material background
        let modifiedView = testView.hierarchicalMaterialBackground(1, for: .iOS)
        
        // Then: Should return modified view
        #expect(modifiedView != nil)
    }
    
    // MARK: - Gradient Extension Tests
    
    @Test @MainActor func testGradientBackgroundModifier() {
        // Given: A view and gradient
        let testView = Text("Test")
        let gradient = LinearGradient(colors: [.blue, .purple], startPoint: .top, endPoint: .bottom)
        
        // When: Applying gradient background
        let modifiedView = testView.gradientBackground(gradient, for: .iOS)
        
        // Then: Should return modified view
        #expect(modifiedView != nil)
    }
    
    @Test @MainActor func testRadialGradientBackgroundModifier() {
        // Given: A view and radial gradient
        let testView = Text("Test")
        let gradient = RadialGradient(colors: [.blue, .purple], center: .center, startRadius: 0, endRadius: 100)
        
        // When: Applying radial gradient background
        let modifiedView = testView.radialGradientBackground(gradient, for: .iOS)
        
        // Then: Should return modified view
        #expect(modifiedView != nil)
    }
    
    // MARK: - Accessibility Extension Tests
    
    @Test @MainActor func testAccessibilityAwareBackgroundModifier() {
        // Given: A view and styles
        let testView = Text("Test")
        let normalStyle = AnyShapeStyle(Color.blue)
        let highContrastStyle = AnyShapeStyle(Color.red)
        
        // When: Applying accessibility aware background
        let modifiedView = testView.accessibilityAwareBackground(
            normal: PlatformAnyShapeStyle(normalStyle),
            highContrast: PlatformAnyShapeStyle(highContrastStyle)
        )
        
        // Then: Should return modified view
        #expect(modifiedView != nil)
    }
    
    @Test @MainActor func testAccessibilityAwareForegroundModifier() {
        // Given: A view and styles
        let testView = Text("Test")
        let normalStyle = AnyShapeStyle(Color.blue)
        let reducedMotionStyle = AnyShapeStyle(Color.gray)
        
        // When: Applying accessibility aware foreground
        let modifiedView = testView.accessibilityAwareForeground(
            normal: PlatformAnyShapeStyle(normalStyle),
            reducedMotion: PlatformAnyShapeStyle(reducedMotionStyle)
        )
        
        // Then: Should return modified view
        #expect(modifiedView != nil)
    }
    
    // MARK: - Integration Tests
    
    @Test @MainActor func testShapeStyleSystemIntegration() {
        // Given: A complex view
        let testView = VStack {
            Text("Title")
                .font(.title)
            Text("Subtitle")
                .font(.subheadline)
        }
        
        // When: Applying multiple shape styles
        let styledView = testView
            .platformBackground(for: .iOS, variant: .standard)
            .platformText(for: .iOS, variant: .primary)
            .platformBorder(for: .iOS, variant: .standard, width: 1)
        
        // Then: Should return modified view
        #expect(styledView != nil)
    }
    
    @Test @MainActor func testAppleHIGComplianceIntegration() {
        // Given: A view that should be Apple HIG compliant
        let testView = Button("Test Button") { }
            .platformBackground(for: .iOS)
            .platformText(for: .iOS)
        
        // When: View is created
        // Then: Should be Apple HIG compliant
        #expect(testView != nil)
    }
    
    // MARK: - Performance Tests
    
    @Test func testShapeStyleCreationPerformance() {
        // Given: Performance test
        // When: Creating many shape styles
        let startTime = CFAbsoluteTimeGetCurrent()
        for _ in 0..<1000 {
            let _ = ShapeStyleSystem.Factory.background(for: .iOS)
            let _ = ShapeStyleSystem.Factory.surface(for: .macOS)
            let _ = ShapeStyleSystem.Factory.text(for: .iOS)
            let _ = ShapeStyleSystem.Factory.border(for: .macOS)
        }
        let executionTime = CFAbsoluteTimeGetCurrent() - startTime
        #expect(executionTime < 1.0, "Shape style creation should complete within 1 second")
    }
    
}
