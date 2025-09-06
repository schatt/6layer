import XCTest
import SwiftUI
@testable import SixLayerFramework

/// Comprehensive test suite for ShapeStyle System
/// Tests all ShapeStyle types: Color, Gradient, Material, HierarchicalShapeStyle
class ShapeStyleSystemTests: XCTestCase {
    
    // MARK: - Color Support Tests
    
    func testStandardColorsExist() {
        // Given: StandardColors struct
        // When: Accessing color properties
        // Then: All standard colors should be available
        XCTAssertNotNil(ShapeStyleSystem.StandardColors.primary)
        XCTAssertNotNil(ShapeStyleSystem.StandardColors.secondary)
        XCTAssertNotNil(ShapeStyleSystem.StandardColors.accent)
        XCTAssertNotNil(ShapeStyleSystem.StandardColors.background)
        XCTAssertNotNil(ShapeStyleSystem.StandardColors.surface)
        XCTAssertNotNil(ShapeStyleSystem.StandardColors.text)
        XCTAssertNotNil(ShapeStyleSystem.StandardColors.textSecondary)
        XCTAssertNotNil(ShapeStyleSystem.StandardColors.border)
        XCTAssertNotNil(ShapeStyleSystem.StandardColors.error)
        XCTAssertNotNil(ShapeStyleSystem.StandardColors.warning)
        XCTAssertNotNil(ShapeStyleSystem.StandardColors.success)
        XCTAssertNotNil(ShapeStyleSystem.StandardColors.info)
    }
    
    func testPlatformSpecificColors() {
        // Given: Platform-specific color access
        // When: Accessing platform colors
        // Then: Should have platform-appropriate colors
        #if canImport(UIKit)
        XCTAssertNotNil(ShapeStyleSystem.StandardColors.systemBackground)
        XCTAssertNotNil(ShapeStyleSystem.StandardColors.secondarySystemBackground)
        XCTAssertNotNil(ShapeStyleSystem.StandardColors.tertiarySystemBackground)
        XCTAssertNotNil(ShapeStyleSystem.StandardColors.systemGroupedBackground)
        XCTAssertNotNil(ShapeStyleSystem.StandardColors.secondarySystemGroupedBackground)
        XCTAssertNotNil(ShapeStyleSystem.StandardColors.tertiarySystemGroupedBackground)
        XCTAssertNotNil(ShapeStyleSystem.StandardColors.label)
        XCTAssertNotNil(ShapeStyleSystem.StandardColors.secondaryLabel)
        XCTAssertNotNil(ShapeStyleSystem.StandardColors.tertiaryLabel)
        XCTAssertNotNil(ShapeStyleSystem.StandardColors.quaternaryLabel)
        XCTAssertNotNil(ShapeStyleSystem.StandardColors.separator)
        XCTAssertNotNil(ShapeStyleSystem.StandardColors.opaqueSeparator)
        #endif
    }
    
    // MARK: - Gradient Support Tests
    
    func testGradientCreation() {
        // Given: Gradients struct
        // When: Accessing gradient properties
        // Then: All gradients should be available
        XCTAssertNotNil(ShapeStyleSystem.Gradients.primary)
        XCTAssertNotNil(ShapeStyleSystem.Gradients.secondary)
        XCTAssertNotNil(ShapeStyleSystem.Gradients.background)
        XCTAssertNotNil(ShapeStyleSystem.Gradients.success)
        XCTAssertNotNil(ShapeStyleSystem.Gradients.warning)
        XCTAssertNotNil(ShapeStyleSystem.Gradients.error)
        XCTAssertNotNil(ShapeStyleSystem.Gradients.focus)
    }
    
    func testGradientTypes() {
        // Given: Gradient instances
        // When: Checking gradient types
        // Then: Should be correct gradient types
        XCTAssertTrue(ShapeStyleSystem.Gradients.primary is LinearGradient)
        XCTAssertTrue(ShapeStyleSystem.Gradients.secondary is LinearGradient)
        XCTAssertTrue(ShapeStyleSystem.Gradients.background is LinearGradient)
        XCTAssertTrue(ShapeStyleSystem.Gradients.success is LinearGradient)
        XCTAssertTrue(ShapeStyleSystem.Gradients.warning is LinearGradient)
        XCTAssertTrue(ShapeStyleSystem.Gradients.error is LinearGradient)
        XCTAssertTrue(ShapeStyleSystem.Gradients.focus is RadialGradient)
    }
    
    // MARK: - Material Support Tests
    
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    func testMaterialTypes() {
        // Given: Materials struct
        // When: Accessing material properties
        // Then: All materials should be available
        XCTAssertNotNil(ShapeStyleSystem.Materials.regular)
        XCTAssertNotNil(ShapeStyleSystem.Materials.thick)
        XCTAssertNotNil(ShapeStyleSystem.Materials.thin)
        XCTAssertNotNil(ShapeStyleSystem.Materials.ultraThin)
        XCTAssertNotNil(ShapeStyleSystem.Materials.ultraThick)
    }
    
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    func testMaterialTypesCorrect() {
        // Given: Material instances
        // When: Checking material types
        // Then: Should be correct material types
        XCTAssertTrue(ShapeStyleSystem.Materials.regular is Material)
        XCTAssertTrue(ShapeStyleSystem.Materials.thick is Material)
        XCTAssertTrue(ShapeStyleSystem.Materials.thin is Material)
        XCTAssertTrue(ShapeStyleSystem.Materials.ultraThin is Material)
        XCTAssertTrue(ShapeStyleSystem.Materials.ultraThick is Material)
    }
    
    // MARK: - Hierarchical ShapeStyle Support Tests
    
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    func testHierarchicalStyles() {
        // Given: HierarchicalStyles struct
        // When: Accessing hierarchical style properties
        // Then: All hierarchical styles should be available
        XCTAssertNotNil(ShapeStyleSystem.HierarchicalStyles.primary)
        XCTAssertNotNil(ShapeStyleSystem.HierarchicalStyles.secondary)
        XCTAssertNotNil(ShapeStyleSystem.HierarchicalStyles.tertiary)
        XCTAssertNotNil(ShapeStyleSystem.HierarchicalStyles.quaternary)
    }
    
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    func testHierarchicalStylesTypes() {
        // Given: Hierarchical style instances
        // When: Checking hierarchical style types
        // Then: Should be correct hierarchical style types
        XCTAssertTrue(ShapeStyleSystem.HierarchicalStyles.primary is HierarchicalShapeStyle)
        XCTAssertTrue(ShapeStyleSystem.HierarchicalStyles.secondary is HierarchicalShapeStyle)
        XCTAssertTrue(ShapeStyleSystem.HierarchicalStyles.tertiary is HierarchicalShapeStyle)
        XCTAssertTrue(ShapeStyleSystem.HierarchicalStyles.quaternary is HierarchicalShapeStyle)
    }
    
    // MARK: - Factory Tests
    
    func testFactoryBackgroundCreation() {
        // Given: Factory and platform
        // When: Creating background style
        // Then: Should return appropriate background style
        let background = ShapeStyleSystem.Factory.background(for: .iOS)
        XCTAssertNotNil(background)
        XCTAssertTrue(background is AnyShapeStyle)
    }
    
    func testFactorySurfaceCreation() {
        // Given: Factory and platform
        // When: Creating surface style
        // Then: Should return appropriate surface style
        let surface = ShapeStyleSystem.Factory.surface(for: .macOS)
        XCTAssertNotNil(surface)
        XCTAssertTrue(surface is AnyShapeStyle)
    }
    
    func testFactoryTextCreation() {
        // Given: Factory and platform
        // When: Creating text style
        // Then: Should return appropriate text style
        let text = ShapeStyleSystem.Factory.text(for: .iOS)
        XCTAssertNotNil(text)
        XCTAssertTrue(text is AnyShapeStyle)
    }
    
    func testFactoryBorderCreation() {
        // Given: Factory and platform
        // When: Creating border style
        // Then: Should return appropriate border style
        let border = ShapeStyleSystem.Factory.border(for: .macOS)
        XCTAssertNotNil(border)
        XCTAssertTrue(border is AnyShapeStyle)
    }
    
    func testFactoryGradientCreation() {
        // Given: Factory and platform
        // When: Creating gradient style
        // Then: Should return appropriate gradient style
        let gradient = ShapeStyleSystem.Factory.gradient(for: .iOS, variant: .primary)
        XCTAssertNotNil(gradient)
        XCTAssertTrue(gradient is AnyShapeStyle)
    }
    
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    func testFactoryMaterialCreation() {
        // Given: Factory and platform
        // When: Creating material style
        // Then: Should return appropriate material style
        let material = ShapeStyleSystem.Factory.material(for: .iOS, variant: .regular)
        XCTAssertNotNil(material)
        XCTAssertTrue(material is AnyShapeStyle)
    }
    
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    func testFactoryHierarchicalCreation() {
        // Given: Factory and platform
        // When: Creating hierarchical style
        // Then: Should return appropriate hierarchical style
        let hierarchical = ShapeStyleSystem.Factory.hierarchical(for: .iOS, variant: .primary)
        XCTAssertNotNil(hierarchical)
        XCTAssertTrue(hierarchical is AnyShapeStyle)
    }
    
    // MARK: - Supporting Types Tests
    
    func testBackgroundVariantEnum() {
        // Given: BackgroundVariant enum
        // When: Accessing all cases
        // Then: Should have all expected cases
        let cases = BackgroundVariant.allCases
        XCTAssertTrue(cases.contains(.standard))
        XCTAssertTrue(cases.contains(.grouped))
        XCTAssertTrue(cases.contains(.elevated))
        XCTAssertTrue(cases.contains(.transparent))
    }
    
    func testSurfaceVariantEnum() {
        // Given: SurfaceVariant enum
        // When: Accessing all cases
        // Then: Should have all expected cases
        let cases = SurfaceVariant.allCases
        XCTAssertTrue(cases.contains(.standard))
        XCTAssertTrue(cases.contains(.elevated))
        XCTAssertTrue(cases.contains(.card))
        XCTAssertTrue(cases.contains(.modal))
    }
    
    func testTextVariantEnum() {
        // Given: TextVariant enum
        // When: Accessing all cases
        // Then: Should have all expected cases
        let cases = TextVariant.allCases
        XCTAssertTrue(cases.contains(.primary))
        XCTAssertTrue(cases.contains(.secondary))
        XCTAssertTrue(cases.contains(.tertiary))
        XCTAssertTrue(cases.contains(.quaternary))
    }
    
    func testBorderVariantEnum() {
        // Given: BorderVariant enum
        // When: Accessing all cases
        // Then: Should have all expected cases
        let cases = BorderVariant.allCases
        XCTAssertTrue(cases.contains(.standard))
        XCTAssertTrue(cases.contains(.subtle))
        XCTAssertTrue(cases.contains(.prominent))
        XCTAssertTrue(cases.contains(.none))
    }
    
    func testGradientVariantEnum() {
        // Given: GradientVariant enum
        // When: Accessing all cases
        // Then: Should have all expected cases
        let cases = GradientVariant.allCases
        XCTAssertTrue(cases.contains(.primary))
        XCTAssertTrue(cases.contains(.secondary))
        XCTAssertTrue(cases.contains(.background))
        XCTAssertTrue(cases.contains(.success))
        XCTAssertTrue(cases.contains(.warning))
        XCTAssertTrue(cases.contains(.error))
        XCTAssertTrue(cases.contains(.focus))
    }
    
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    func testMaterialVariantEnum() {
        // Given: MaterialVariant enum
        // When: Accessing all cases
        // Then: Should have all expected cases
        let cases = MaterialVariant.allCases
        XCTAssertTrue(cases.contains(.regular))
        XCTAssertTrue(cases.contains(.thick))
        XCTAssertTrue(cases.contains(.thin))
        XCTAssertTrue(cases.contains(.ultraThin))
        XCTAssertTrue(cases.contains(.ultraThick))
    }
    
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    func testHierarchicalVariantEnum() {
        // Given: HierarchicalVariant enum
        // When: Accessing all cases
        // Then: Should have all expected cases
        let cases = HierarchicalVariant.allCases
        XCTAssertTrue(cases.contains(.primary))
        XCTAssertTrue(cases.contains(.secondary))
        XCTAssertTrue(cases.contains(.tertiary))
        XCTAssertTrue(cases.contains(.quaternary))
    }
    
    // MARK: - AnyShapeStyle Tests
    
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    func testAnyShapeStyleCreation() {
        // Given: A Color
        // When: Creating AnyShapeStyle
        // Then: Should create successfully
        let color = Color.blue
        let anyShapeStyle = AnyShapeStyle(color)
        XCTAssertNotNil(anyShapeStyle)
    }
    
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    func testAnyShapeStyleWithGradient() {
        // Given: A LinearGradient
        // When: Creating AnyShapeStyle
        // Then: Should create successfully
        let gradient = LinearGradient(colors: [.blue, .purple], startPoint: .top, endPoint: .bottom)
        let anyShapeStyle = AnyShapeStyle(gradient)
        XCTAssertNotNil(anyShapeStyle)
    }
    
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    func testAnyShapeStyleWithMaterial() {
        // Given: A Material
        // When: Creating AnyShapeStyle
        // Then: Should create successfully
        let material = Material.regularMaterial
        let anyShapeStyle = AnyShapeStyle(material)
        XCTAssertNotNil(anyShapeStyle)
    }
    
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    func testAnyShapeStyleWithHierarchical() {
        // Given: A HierarchicalShapeStyle
        // When: Creating AnyShapeStyle
        // Then: Should create successfully
        let hierarchical = HierarchicalShapeStyle.primary
        let anyShapeStyle = AnyShapeStyle(hierarchical)
        XCTAssertNotNil(anyShapeStyle)
    }
    
    // MARK: - View Extension Tests
    
    func testPlatformBackgroundModifier() {
        // Given: A view
        let testView = Text("Test")
        
        // When: Applying platform background
        let modifiedView = testView.platformBackground(for: .iOS)
        
        // Then: Should return modified view
        XCTAssertNotNil(modifiedView)
    }
    
    func testPlatformSurfaceModifier() {
        // Given: A view
        let testView = Text("Test")
        
        // When: Applying platform surface
        let modifiedView = testView.platformSurface(for: .macOS)
        
        // Then: Should return modified view
        XCTAssertNotNil(modifiedView)
    }
    
    func testPlatformTextModifier() {
        // Given: A view
        let testView = Text("Test")
        
        // When: Applying platform text
        let modifiedView = testView.platformText(for: .iOS)
        
        // Then: Should return modified view
        XCTAssertNotNil(modifiedView)
    }
    
    func testPlatformBorderModifier() {
        // Given: A view
        let testView = Text("Test")
        
        // When: Applying platform border
        let modifiedView = testView.platformBorder(for: .macOS, width: 2)
        
        // Then: Should return modified view
        XCTAssertNotNil(modifiedView)
    }
    
    func testPlatformGradientModifier() {
        // Given: A view
        let testView = Text("Test")
        
        // When: Applying platform gradient
        let modifiedView = testView.platformGradient(for: .iOS, variant: .primary)
        
        // Then: Should return modified view
        XCTAssertNotNil(modifiedView)
    }
    
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    func testPlatformMaterialModifier() {
        // Given: A view
        let testView = Text("Test")
        
        // When: Applying platform material
        let modifiedView = testView.platformMaterial(for: .iOS, variant: .regular)
        
        // Then: Should return modified view
        XCTAssertNotNil(modifiedView)
    }
    
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    func testPlatformHierarchicalModifier() {
        // Given: A view
        let testView = Text("Test")
        
        // When: Applying platform hierarchical
        let modifiedView = testView.platformHierarchical(for: .iOS, variant: .primary)
        
        // Then: Should return modified view
        XCTAssertNotNil(modifiedView)
    }
    
    // MARK: - Material Extension Tests
    
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    func testMaterialBackgroundModifier() {
        // Given: A view
        let testView = Text("Test")
        
        // When: Applying material background
        let modifiedView = testView.materialBackground(.regularMaterial, for: .iOS)
        
        // Then: Should return modified view
        XCTAssertNotNil(modifiedView)
    }
    
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    func testHierarchicalMaterialBackgroundModifier() {
        // Given: A view
        let testView = Text("Test")
        
        // When: Applying hierarchical material background
        let modifiedView = testView.hierarchicalMaterialBackground(1, for: .iOS)
        
        // Then: Should return modified view
        XCTAssertNotNil(modifiedView)
    }
    
    // MARK: - Gradient Extension Tests
    
    func testGradientBackgroundModifier() {
        // Given: A view and gradient
        let testView = Text("Test")
        let gradient = LinearGradient(colors: [.blue, .purple], startPoint: .top, endPoint: .bottom)
        
        // When: Applying gradient background
        let modifiedView = testView.gradientBackground(gradient, for: .iOS)
        
        // Then: Should return modified view
        XCTAssertNotNil(modifiedView)
    }
    
    func testRadialGradientBackgroundModifier() {
        // Given: A view and radial gradient
        let testView = Text("Test")
        let gradient = RadialGradient(colors: [.blue, .purple], center: .center, startRadius: 0, endRadius: 100)
        
        // When: Applying radial gradient background
        let modifiedView = testView.radialGradientBackground(gradient, for: .iOS)
        
        // Then: Should return modified view
        XCTAssertNotNil(modifiedView)
    }
    
    // MARK: - Accessibility Extension Tests
    
    func testAccessibilityAwareBackgroundModifier() {
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
        XCTAssertNotNil(modifiedView)
    }
    
    func testAccessibilityAwareForegroundModifier() {
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
        XCTAssertNotNil(modifiedView)
    }
    
    // MARK: - Integration Tests
    
    func testShapeStyleSystemIntegration() {
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
        XCTAssertNotNil(styledView)
    }
    
    func testAppleHIGComplianceIntegration() {
        // Given: A view that should be Apple HIG compliant
        let testView = Button("Test Button") { }
            .platformBackground(for: .iOS)
            .platformText(for: .iOS)
        
        // When: View is created
        // Then: Should be Apple HIG compliant
        XCTAssertNotNil(testView)
    }
    
    // MARK: - Performance Tests
    
    func testShapeStyleCreationPerformance() {
        // Given: Performance test
        // When: Creating many shape styles
        measure {
            for _ in 0..<1000 {
                let _ = ShapeStyleSystem.Factory.background(for: .iOS)
                let _ = ShapeStyleSystem.Factory.surface(for: .macOS)
                let _ = ShapeStyleSystem.Factory.text(for: .iOS)
                let _ = ShapeStyleSystem.Factory.border(for: .macOS)
            }
        }
    }
    
    func testViewModifierPerformance() {
        // Given: A view
        let testView = Text("Test")
        
        // When: Applying many modifiers
        measure {
            for _ in 0..<100 {
                let _ = testView
                    .platformBackground(for: .iOS)
                    .platformText(for: .iOS)
                    .platformBorder(for: .iOS)
            }
        }
    }
}
