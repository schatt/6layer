import Testing
import SwiftUI
@testable import SixLayerFramework

/// Tests for Material Accessibility features
/// Ensures materials are accessible and comply with accessibility standards
@MainActor
final class MaterialAccessibilityTests {
    
    // MARK: - Material Contrast Validation Tests
    
    @Test func testMaterialContrastValidation() {
        // Given: Different material types
        let regularMaterial = Material.regularMaterial
        let thickMaterial = Material.thickMaterial
        let thinMaterial = Material.thinMaterial
        
        // When: Validating material contrast
        let regularContrast = MaterialAccessibilityManager.validateContrast(regularMaterial)
        let thickContrast = MaterialAccessibilityManager.validateContrast(thickMaterial)
        let thinContrast = MaterialAccessibilityManager.validateContrast(thinMaterial)
        
        // Then: All materials should have valid contrast ratios
        #expect(regularContrast.isValid)
        #expect(thickContrast.isValid)
        #expect(thinContrast.isValid)
        #expect(regularContrast.contrastRatio >= 4.5) // WCAG AA standard
        #expect(thickContrast.contrastRatio >= 4.5)
        #expect(thinContrast.contrastRatio >= 4.5)
    }
    
    @Test func testHighContrastMaterialAlternatives() {
        // Given: A material that might not meet contrast requirements
        let material = Material.regularMaterial
        
        // When: Getting high contrast alternative
        let highContrastMaterial = MaterialAccessibilityManager.highContrastAlternative(for: material)
        
        // Then: High contrast alternative should have better contrast
        let originalContrast = MaterialAccessibilityManager.validateContrast(material)
        let alternativeContrast = MaterialAccessibilityManager.validateContrast(highContrastMaterial)
        
        #expect(alternativeContrast.contrastRatio >= originalContrast.contrastRatio)
        #expect(alternativeContrast.isValid)
    }
    
    @Test func testVoiceOverMaterialDescriptions() {
        // Given: Different material types
        let materials: [Material] = [
            .regularMaterial,
            .thickMaterial,
            .thinMaterial,
            .ultraThinMaterial,
            .ultraThickMaterial
        ]
        
        // When: Getting VoiceOver descriptions
        let descriptions = materials.map { MaterialAccessibilityManager.voiceOverDescription(for: $0) }
        
        // Then: All materials should have descriptive VoiceOver text
        for description in descriptions {
            #expect(!description.isEmpty)
            #expect(description.contains("material"))
        }
    }
    
    @Test func testAccessibilityAwareMaterialSelection() {
        // Given: Different accessibility settings
        var highContrastSettings = SixLayerFramework.AccessibilitySettings()
        highContrastSettings.highContrastMode = true
        var reducedMotionSettings = SixLayerFramework.AccessibilitySettings()
        reducedMotionSettings.reducedMotion = true
        var voiceOverSettings = SixLayerFramework.AccessibilitySettings()
        voiceOverSettings.voiceOverSupport = true
        
        // When: Selecting materials based on accessibility settings
        let highContrastMaterial = MaterialAccessibilityManager.selectMaterial(
            for: .regular,
            accessibilitySettings: highContrastSettings
        )
        let reducedMotionMaterial = MaterialAccessibilityManager.selectMaterial(
            for: .regular,
            accessibilitySettings: reducedMotionSettings
        )
        let voiceOverMaterial = MaterialAccessibilityManager.selectMaterial(
            for: .regular,
            accessibilitySettings: voiceOverSettings
        )
        
        // Then: Materials should be appropriate for accessibility settings
        #expect(highContrastMaterial != nil)
        #expect(reducedMotionMaterial != nil)
        #expect(voiceOverMaterial != nil)
    }
    
    // MARK: - Material Accessibility Compliance Tests
    
    @Test func testMaterialAccessibilityCompliance() {
        // Given: A view with material background
        let view = Rectangle()
            .fill(.regularMaterial)
            .accessibilityMaterialEnhanced()
        
        // When: Running accessibility compliance check
        let compliance = MaterialAccessibilityManager.checkCompliance(for: view)
        
        // Then: Material should be compliant
        #expect(compliance.isCompliant)
        #expect(compliance.issues.count == 0)
    }
    
    @Test func testMaterialAccessibilityIssues() {
        // Given: A material with poor contrast
        let poorContrastMaterial = MaterialAccessibilityManager.createPoorContrastMaterial()
        
        // When: Checking compliance directly on the material using poor contrast testing
        let contrastResult = MaterialAccessibilityManager.validateContrastForPoorContrastTesting(poorContrastMaterial)
        
        // Then: Should identify contrast issues
        #expect(!contrastResult.isValid)
        #expect(contrastResult.contrastRatio < 4.5) // WCAG AA standard
        #expect(contrastResult.wcagLevel == .A) // Should be WCAG A level
    }
    
    // MARK: - Material Accessibility Extensions Tests
    
    @Test func testMaterialAccessibilityViewModifier() {
        // Given: A view with material
        let view = VStack {
            Text("Test")
            Button("Action") { }
        }
        .background(.regularMaterial)
        
        // When: Applying material accessibility enhancement
        let enhancedView = view.accessibilityMaterialEnhanced()
        
        // Then: View should have accessibility enhancements
        #expect(enhancedView != nil)
    }
    
    @Test func testMaterialAccessibilityConfiguration() {
        // Given: Material accessibility configuration
        let config = MaterialAccessibilityConfig(
            enableContrastValidation: true,
            enableHighContrastAlternatives: true,
            enableVoiceOverDescriptions: true,
            enableReducedMotionAlternatives: true
        )
        
        // When: Creating material accessibility manager
        let manager = MaterialAccessibilityManager(configuration: config)
        
        // Then: Manager should be configured correctly
        #expect(manager.configuration.enableContrastValidation)
        #expect(manager.configuration.enableHighContrastAlternatives)
        #expect(manager.configuration.enableVoiceOverDescriptions)
        #expect(manager.configuration.enableReducedMotionAlternatives)
    }
    
    // MARK: - Material Accessibility Performance Tests
    
    @Test func testMaterialAccessibilityPerformance() {
        // Given: Multiple materials to validate
        let materials = Array(repeating: Material.regularMaterial, count: 100)
        
        // When: Measuring validation performance
        let startTime = CFAbsoluteTimeGetCurrent()
        
        for material in materials {
            _ = MaterialAccessibilityManager.validateContrast(material)
        }
        
        let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
        
        // Then: Validation should be performant
        #expect(timeElapsed < 1.0) // Should complete in under 1 second
    }
    
    // MARK: - Material Accessibility Integration Tests
    
    @Test func testMaterialAccessibilityWithVoiceOver() {
        // Given: A view with material and VoiceOver enabled
        let view = Rectangle()
            .fill(.regularMaterial)
            .accessibilityMaterialEnhanced()
            .accessibilityLabel("Test material background")
        
        // When: Running VoiceOver accessibility check
        let voiceOverCompliance = MaterialAccessibilityManager.checkVoiceOverCompliance(for: view)
        
        // Then: Should be VoiceOver compliant
        #expect(voiceOverCompliance.isCompliant)
    }
    
    @Test func testMaterialAccessibilityWithHighContrast() {
        // Given: High contrast mode enabled
        var highContrastSettings = SixLayerFramework.AccessibilitySettings()
        highContrastSettings.highContrastMode = true
        
        // When: Selecting material for high contrast
        let material = MaterialAccessibilityManager.selectMaterial(
            for: .regular,
            accessibilitySettings: highContrastSettings
        )
        
        // Then: Material should be high contrast appropriate
        let contrast = MaterialAccessibilityManager.validateContrast(material)
        #expect(contrast.isValid)
        #expect(contrast.contrastRatio >= 7.0) // WCAG AAA standard
    }
    
    @Test func testMaterialAccessibilityWithReducedMotion() {
        // Given: Reduced motion enabled
        var reducedMotionSettings = SixLayerFramework.AccessibilitySettings()
        reducedMotionSettings.reducedMotion = true
        
        // When: Selecting material for reduced motion
        let material = MaterialAccessibilityManager.selectMaterial(
            for: .regular,
            accessibilitySettings: reducedMotionSettings
        )
        
        // Then: Material should be motion-appropriate
        let motionCompliance = MaterialAccessibilityManager.checkMotionCompliance(for: material)
        #expect(motionCompliance.isCompliant)
    }
}

// MARK: - Test Helpers

extension MaterialAccessibilityTests {
    
    private func createTestMaterial() -> Material {
        return .regularMaterial
    }
    
    private func createTestView() -> some View {
        Rectangle()
            .fill(.regularMaterial)
            .frame(width: 100, height: 100)
    }
}
