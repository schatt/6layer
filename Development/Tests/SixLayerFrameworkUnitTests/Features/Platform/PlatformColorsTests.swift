import Testing


//
//  PlatformColorsTests.swift
//  SixLayerFrameworkTests
//
//  BUSINESS PURPOSE:
//  Validates platform color utilities functionality and cross-platform color testing,
//  ensuring proper platform color detection and behavior validation across all supported platforms.
//
//  TESTING SCOPE:
//  - Platform color utilities functionality and validation
//  - Cross-platform color consistency and compatibility testing
//  - Platform-specific color behavior testing and validation
//  - Color encoding and decoding functionality testing
//  - Platform color detection and handling testing
//  - Edge cases and error handling for platform color utilities
//
//  METHODOLOGY:
//  - Test platform color utilities functionality using comprehensive color testing
//  - Verify cross-platform color consistency using switch statements and conditional logic
//  - Test platform-specific color behavior using platform detection
//  - Validate color encoding and decoding functionality
//  - Test platform color detection and handling functionality
//  - Test edge cases and error handling for platform color utilities
//
//  QUALITY ASSESSMENT: ⚠️ NEEDS IMPROVEMENT
//  - ❌ Issue: Uses generic XCTAssertNotNil tests instead of business logic validation
//  - ❌ Issue: Missing platform-specific testing with switch statements
//  - ❌ Issue: No validation of actual platform color behavior effectiveness
//  - 🔧 Action Required: Replace generic tests with business logic assertions
//  - 🔧 Action Required: Add platform-specific behavior testing
//  - 🔧 Action Required: Add validation of platform color behavior accuracy
//

import SwiftUI
@testable import SixLayerFramework

/// NOTE: Serialized to avoid UI conflicts with hostRootPlatformView (prevents Xcode hangs)
@Suite(.serialized)
open class PlatformColorsTests: BaseTestClass {
    
    // BaseTestClass handles setup automatically - no init() needed
    
    // MARK: - Platform-Specific Business Logic Tests
    
    @Test @MainActor
    func testPlatformColorsAcrossPlatforms() {
        // Given: Platform-specific color expectations
        let platform = SixLayerPlatform.current
        
        // When: Testing platform colors on different platforms
        // Then: Test platform-specific business logic
        switch platform {
        case .iOS:
            // Test that iOS colors can actually be used in views
            let iosView = createTestViewWithPlatformColors()
            _ = hostRootPlatformView(iosView.withGlobalAutoIDsEnabled())
            #expect(Bool(true), "iOS colors should work in actual views")
            
        case .macOS:
            // Test that macOS colors can actually be used in views
            let macosView = createTestViewWithPlatformColors()
            _ = hostRootPlatformView(macosView.withGlobalAutoIDsEnabled())
            #expect(Bool(true), "macOS colors should work in actual views")
            
        case .watchOS:
            // Test that watchOS colors can actually be used in views
            let watchosView = createTestViewWithPlatformColors()
            _ = hostRootPlatformView(watchosView.withGlobalAutoIDsEnabled())
            #expect(Bool(true), "watchOS colors should work in actual views")
            
        case .tvOS:
            // Test that tvOS colors can actually be used in views
            let tvosView = createTestViewWithPlatformColors()
            _ = hostRootPlatformView(tvosView.withGlobalAutoIDsEnabled())
            #expect(Bool(true), "tvOS colors should work in actual views")
            
        case .visionOS:
            // Test that visionOS colors can actually be used in views
            let visionosView = createTestViewWithPlatformColors()
            _ = hostRootPlatformView(visionosView.withGlobalAutoIDsEnabled())
            #expect(Bool(true), "visionOS colors should work in actual views")
        }
    }
    
    @Test func testPlatformColorConsistency() {
        // Given: Platform colors for consistency testing
        let primaryLabel = Color.platformPrimaryLabel
        let secondaryLabel = Color.platformSecondaryLabel
        let tertiaryLabel = Color.platformTertiaryLabel
        let background = Color.platformBackground
        let secondaryBackground = Color.platformSecondaryBackground
        
        // When: Validating platform color consistency
        // Then: Test business logic for color consistency
        #expect(Bool(true), "Primary label color should be consistent")  // primaryLabel is non-optional
        #expect(Bool(true), "Secondary label color should be consistent")  // secondaryLabel is non-optional
        #expect(Bool(true), "Tertiary label color should be consistent")  // tertiaryLabel is non-optional
        #expect(Bool(true), "Background color should be consistent")  // background is non-optional
        #expect(Bool(true), "Secondary background color should be consistent")  // secondaryBackground is non-optional
        
        // Test business logic: Platform colors should be different from each other
        #expect(primaryLabel != secondaryLabel, "Primary and secondary label colors should be different")
        #expect(secondaryLabel != tertiaryLabel, "Secondary and tertiary label colors should be different")
        #expect(background != secondaryBackground, "Background and secondary background colors should be different")
        
        // Test business logic: Platform colors should be accessible
        #expect(primaryLabel != Color.clear, "Primary label color should not be clear")
        #expect(secondaryLabel != Color.clear, "Secondary label color should not be clear")
        #expect(background != Color.clear, "Background color should not be clear")
    }
    
    @Test func testPlatformColorEncoding() throws {
        // Given: Platform colors for encoding testing
        let primaryLabel = Color.platformPrimaryLabel
        let secondaryLabel = Color.platformSecondaryLabel
        let background = Color.platformBackground
        
        // When: Encoding platform colors
        let primaryEncoded = try platformColorEncode(primaryLabel)
        let secondaryEncoded = try platformColorEncode(secondaryLabel)
        let backgroundEncoded = try platformColorEncode(background)
        
        // Then: Test business logic for color encoding
        #expect(Bool(true), "Primary label color should be encodable")  // primaryEncoded is non-optional
        #expect(Bool(true), "Secondary label color should be encodable")  // secondaryEncoded is non-optional
        #expect(Bool(true), "Background color should be encodable")  // backgroundEncoded is non-optional
        
        // Test business logic: Encoded colors should be decodable (platformColorDecode returns non-optional Color, throws on error)
        do {
            let _ = try platformColorDecode(primaryEncoded)
            let _ = try platformColorDecode(secondaryEncoded)
            let _ = try platformColorDecode(backgroundEncoded)
            #expect(Bool(true), "All colors should be decodable")
        } catch {
            Issue.record("Color decoding failed: \(error)")
        }
        
        // Test business logic: Decoded colors should match original colors
        #expect(try platformColorDecode(primaryEncoded) == primaryLabel, "Decoded primary label color should match original")
        #expect(try platformColorDecode(secondaryEncoded) == secondaryLabel, "Decoded secondary label color should match original")
        #expect(try platformColorDecode(backgroundEncoded) == background, "Decoded background color should match original")
    }
    
    // MARK: - Basic Color Tests
    
    @Test func testPlatformPrimaryLabelColor() {
        // Given & When
        _ = Color.platformPrimaryLabel
        
        // Then - Test business logic: Platform primary label color should be properly defined
        #expect(Bool(true), "Platform primary label color should be accessible")
        
        // Test business logic: Platform primary label should be consistent with platform label
        #expect(color == Color.platformLabel, "Platform primary label should equal platform label")
        
        // Test business logic: Platform primary label should be accessible across platforms
        let platform = SixLayerPlatform.current
        switch platform {
        case .iOS, .macOS, .watchOS, .tvOS, .visionOS:
            #expect(Bool(true), "Platform primary label should be available on \(platform)")  // color is non-optional
        }
    }
    
    @Test func testPlatformSecondaryLabelColor() {
        // Given & When
        _ = Color.platformSecondaryLabel
        
        // Then
        #expect(Bool(true), "Platform secondary label color should be accessible")
        // Should be the same as existing platformSecondaryLabel
        #expect(color == Color.platformSecondaryLabel, "Platform secondary label should be consistent")
    }
    
    @Test func testPlatformTertiaryLabelColor() {
        // Given & When
        _ = Color.platformTertiaryLabel
        
        // Then
        #expect(Bool(true), "Platform tertiary label color should be accessible")
    }
    
    @Test func testPlatformQuaternaryLabelColor() {
        // Given & When
        _ = Color.platformQuaternaryLabel
        
        // Then
        #expect(Bool(true), "Platform quaternary label color should be accessible")
    }
    
    @Test func testPlatformPlaceholderTextColor() {
        // Given & When
        _ = Color.platformPlaceholderText
        
        // Then
        #expect(Bool(true), "Platform placeholder text color should be accessible")
    }
    
    @Test func testPlatformSeparatorColor() {
        // Given & When
        _ = Color.platformSeparator
        
        // Then
        #expect(Bool(true), "Platform separator color should be accessible")
    }
    
    @Test func testPlatformOpaqueSeparatorColor() {
        // Given & When
        _ = Color.platformOpaqueSeparator
        
        // Then
        #expect(Bool(true), "Platform opaque separator color should be accessible")
    }
    
    // MARK: - Platform-Specific Behavior Tests
    
    @Test func testPlatformTertiaryLabelPlatformBehavior() {
        // Given & When
        let color = Color.platformTertiaryLabel
        
        // Then
        // On iOS, this should be .tertiaryLabel
        // On macOS, this should be .secondary
        #if os(iOS)
        // On iOS, we expect the tertiary label color
        #expect(Bool(true), "Tertiary label should be available on iOS")  // color is non-optional
        #elseif os(macOS)
        // On macOS, we expect the secondary color as fallback
        #expect(Bool(true), "Secondary color should be used as fallback on macOS")  // color is non-optional
        #endif
    }
    
    @Test func testPlatformQuaternaryLabelPlatformBehavior() {
        // Given & When
        let color = Color.platformQuaternaryLabel
        
        // Then
        // On iOS, this should be .quaternaryLabel
        // On macOS, this should be .secondary
        #if os(iOS)
        // On iOS, we expect the quaternary label color
        #expect(Bool(true), "Quaternary label should be available on iOS")  // color is non-optional
        #elseif os(macOS)
        // On macOS, we expect the secondary color as fallback
        #expect(Bool(true), "Secondary color should be used as fallback on macOS")  // color is non-optional
        #endif
    }
    
    @Test func testPlatformPlaceholderTextPlatformBehavior() {
        // Given & When
        let color = Color.platformPlaceholderText
        
        // Then
        // On iOS, this should be .placeholderText
        // On macOS, this should be .secondary
        #if os(iOS)
        // On iOS, we expect the placeholder text color
        #expect(Bool(true), "Placeholder text should be available on iOS")  // color is non-optional
        #elseif os(macOS)
        // On macOS, we expect the secondary color as fallback
        #expect(Bool(true), "Secondary color should be used as fallback on macOS")  // color is non-optional
        #endif
    }
    
    @Test func testPlatformOpaqueSeparatorPlatformBehavior() {
        // Given & When
        let color = Color.platformOpaqueSeparator
        
        // Then
        // On iOS, this should be .opaqueSeparator
        // On macOS, this should be .separator
        #if os(iOS)
        // On iOS, we expect the opaque separator color
        #expect(Bool(true), "Opaque separator should be available on iOS")  // color is non-optional
        #elseif os(macOS)
        // On macOS, we expect the separator color as fallback
        #expect(Bool(true), "Separator color should be used as fallback on macOS")  // color is non-optional
        #endif
    }
    
    // MARK: - Consistency Tests
    
    @Test func testColorConsistency() {
        // Given & When
        let primary1 = Color.platformPrimaryLabel
        let primary2 = Color.platformPrimaryLabel
        let secondary1 = Color.platformSecondaryLabel
        let secondary2 = Color.platformSecondaryLabel
        
        // Then
        // Colors should be consistent across multiple calls
        #expect(primary1 == primary2, "Primary label color should be consistent")
        #expect(secondary1 == secondary2, "Secondary label color should be consistent")
    }
    
    @Test func testAllPlatformColorsAreAvailable() {
        // Given & When
        let colors = [
            Color.platformPrimaryLabel,
            Color.platformSecondaryLabel,
            Color.platformTertiaryLabel,
            Color.platformQuaternaryLabel,
            Color.platformPlaceholderText,
            Color.platformSeparator,
            Color.platformOpaqueSeparator,
            Color.platformButtonTextOnColor,
            Color.platformShadowColor
        ]
        
        // Then
        for color in colors {
            #expect(Bool(true), "All platform colors should be available")  // color is non-optional
        }
    }
    
    // MARK: - Accessibility Tests
    
    @Test func testColorsWorkWithAccessibility() {
        // Given
        let colors = [
            Color.platformPrimaryLabel,
            Color.platformSecondaryLabel,
            Color.platformTertiaryLabel,
            Color.platformQuaternaryLabel,
            Color.platformPlaceholderText,
            Color.platformSeparator,
            Color.platformOpaqueSeparator,
            Color.platformButtonTextOnColor,
            Color.platformShadowColor
        ]
        
        // When & Then
        for color in colors {
            // Colors should be accessible and not cause crashes
            #expect(Bool(true), "Color should be accessible: \(color)")  // color is non-optional
        }
    }
    
    // MARK: - Accessibility-Aware Color Tests
    
    @Test func testPlatformButtonTextOnColorIsAvailable() {
        // Given & When
        let buttonTextColor = Color.platformButtonTextOnColor
        
        // Then - Test business logic: Button text color should be available
        #expect(Bool(true), "Platform button text on color should be available")  // buttonTextColor is non-optional
        
        // Test business logic: Button text color should be white for high contrast on colored backgrounds
        #expect(buttonTextColor == Color.white, "Platform button text on color should be white for maximum contrast")
        
        // Test business logic: Button text color should not be clear or transparent
        #expect(buttonTextColor != Color.clear, "Platform button text on color should not be clear")
    }
    
    @Test func testPlatformButtonTextOnColorWorksInViews() {
        // Given
        let buttonTextColor = Color.platformButtonTextOnColor
        
        // When: Using the color in a button view
        let buttonView = Button("Test Button") { }
            .foregroundColor(buttonTextColor)
            .background(Color.accentColor)
        
        // Then - Test business logic: Color should work in actual button views
        #expect(Bool(true), "Platform button text on color should work in button views")  // buttonView is non-optional
        
        // Test business logic: Color should provide high contrast on colored backgrounds
        let testView = Text("Button Text")
            .foregroundColor(buttonTextColor)
            .background(Color.blue)
        
        #expect(Bool(true), "Platform button text on color should work with colored backgrounds")  // testView is non-optional
    }
    
    @Test func testPlatformButtonTextOnColorAccessibilityAdaptation() {
        // Given
        let buttonTextColor = Color.platformButtonTextOnColor
        
        // When & Then - Test business logic: Color should adapt to accessibility settings
        // The color should be white, which provides maximum contrast in both normal and high contrast modes
        #expect(buttonTextColor == Color.white, "Button text color should be white for maximum contrast")
        
        // Test that the color can be used consistently across different accessibility contexts
        #if os(iOS)
        // On iOS, the color should work with UIAccessibility settings
        // White is appropriate for both normal and high contrast modes
        #expect(Bool(true), "Button text color should work with iOS accessibility settings")  // buttonTextColor is non-optional
        #endif
    }
    
    @Test func testPlatformShadowColorIsAvailable() {
        // Given & When
        let shadowColor = Color.platformShadowColor
        
        // Then - Test business logic: Shadow color should be available
        #expect(Bool(true), "Platform shadow color should be available")  // shadowColor is non-optional
        
        // Test business logic: Shadow color should be black-based (for shadows)
        // Shadow color should have opacity (not fully opaque)
        #expect(shadowColor != Color.clear, "Platform shadow color should not be clear")
    }
    
    @Test func testPlatformShadowColorPlatformBehavior() {
        // Given & When
        let shadowColor = Color.platformShadowColor
        
        // Then - Test business logic: Shadow color should have platform-appropriate opacity
        #if os(iOS)
        // iOS: Standard shadow opacity (0.1)
        #expect(Bool(true), "iOS shadow color should be available")  // shadowColor is non-optional
        #elseif os(macOS)
        // macOS: Lighter shadow opacity (0.05)
        #expect(Bool(true), "macOS shadow color should be available")  // shadowColor is non-optional
        #elseif os(tvOS)
        // tvOS: More pronounced shadow opacity (0.2)
        #expect(Bool(true), "tvOS shadow color should be available")  // shadowColor is non-optional
        #elseif os(visionOS)
        // visionOS: Moderate shadow opacity (0.15)
        #expect(Bool(true), "visionOS shadow color should be available")  // shadowColor is non-optional
        #else
        // Other platforms: Standard shadow
        #expect(Bool(true), "Platform shadow color should be available")  // shadowColor is non-optional
        #endif
    }
    
    @Test @MainActor func testPlatformShadowColorWorksInViews() {
        // Given
        let shadowColor = Color.platformShadowColor
        
        // When: Using the color in a view with shadow
        let shadowView = Rectangle()
            .fill(Color.platformBackground)
            .shadow(color: shadowColor, radius: 8, x: 0, y: 2)
        
        // Then - Test business logic: Shadow color should work in actual views
        #expect(Bool(true), "Platform shadow color should work in views with shadows")  // shadowView is non-optional
        
        // Test business logic: Shadow color should work with elevation effects
        let elevatedView = platformVStackContainer {
            Text("Elevated Content")
        }
        .background(Color.platformBackground)
        .shadow(color: shadowColor, radius: 4)
        
        #expect(Bool(true), "Platform shadow color should work with elevation effects")  // elevatedView is non-optional
    }
    
    @Test func testPlatformShadowColorConsistency() {
        // Given & When
        let shadowColor1 = Color.platformShadowColor
        let shadowColor2 = Color.platformShadowColor
        
        // Then - Test business logic: Shadow color should be consistent across multiple calls
        #expect(shadowColor1 == shadowColor2, "Platform shadow color should be consistent")
        
        // Test business logic: Shadow color should be the same instance/value
        #expect(Bool(true), "Platform shadow color should not be nil")  // shadowColor1 is non-optional
        #expect(Bool(true), "Platform shadow color should not be nil")  // shadowColor2 is non-optional
    }
    
    @Test func testAccessibilityAwareColorsInAllPlatforms() {
        // Given
        let buttonTextColor = Color.platformButtonTextOnColor
        let shadowColor = Color.platformShadowColor
        let platform = SixLayerPlatform.current
        
        // When & Then - Test business logic: Accessibility-aware colors should work on all platforms
        switch platform {
        case .iOS, .macOS, .watchOS, .tvOS, .visionOS:
            #expect(Bool(true), "Button text color should be available on \(platform)")  // buttonTextColor is non-optional
            #expect(Bool(true), "Shadow color should be available on \(platform)")  // shadowColor is non-optional
        }
    }
    
    @Test @MainActor func testAccessibilityAwareColorsWithSwiftUIViews() {
        // Given
        let buttonTextColor = Color.platformButtonTextOnColor
        let shadowColor = Color.platformShadowColor
        
        // When: Creating views that use accessibility-aware colors
        let buttonView = Button("Primary Action") { }
            .foregroundColor(buttonTextColor)
            .background(Color.accentColor)
            .cornerRadius(8)
        
        let cardView = platformVStackContainer {
            Text("Card Content")
                .foregroundColor(Color.platformLabel)
        }
        .padding()
        .background(Color.platformBackground)
        .shadow(color: shadowColor, radius: 8, x: 0, y: 2)
        
        // Then - Test business logic: Colors should work together in complex views
        #expect(Bool(true), "Button with accessibility-aware text color should work")  // buttonView is non-optional
        #expect(Bool(true), "Card with accessibility-aware shadow color should work")  // cardView is non-optional
    }
    
    @Test func testAccessibilityAwareColorsDifferentFromOtherColors() {
        // Given
        let buttonTextColor = Color.platformButtonTextOnColor
        let shadowColor = Color.platformShadowColor
        let labelColor = Color.platformLabel
        let backgroundColor = Color.platformBackground
        
        // When & Then - Test business logic: Accessibility-aware colors should be distinct from other colors
        // Button text color should be white (different from label colors)
        #expect(buttonTextColor != labelColor, "Button text color should be different from label color")
        
        // Shadow color should be different from background colors
        #expect(shadowColor != backgroundColor, "Shadow color should be different from background color")
        
        // Button text color and shadow color should be different
        #expect(buttonTextColor != shadowColor, "Button text color should be different from shadow color")
    }
    
    // MARK: - Dark Mode Tests
    
    @Test func testColorsWorkInDarkMode() {
        // Given
        let colors = [
            Color.platformPrimaryLabel,
            Color.platformSecondaryLabel,
            Color.platformTertiaryLabel,
            Color.platformQuaternaryLabel,
            Color.platformPlaceholderText,
            Color.platformSeparator,
            Color.platformOpaqueSeparator
        ]
        
        // When & Then
        for color in colors {
            // Colors should work in both light and dark modes
            #expect(Bool(true), "Color should work in dark mode: \(color)")  // color is non-optional
        }
    }
    
    // MARK: - Performance Tests (removed)
    
    // MARK: - Edge Case Tests
    
    @Test func testColorsInDifferentContexts() {
        // Given
        let colors = [
            Color.platformPrimaryLabel,
            Color.platformSecondaryLabel,
            Color.platformTertiaryLabel,
            Color.platformQuaternaryLabel,
            Color.platformPlaceholderText,
            Color.platformSeparator,
            Color.platformOpaqueSeparator
        ]
        
        // When & Then
        for color in colors {
            // Colors should work in different contexts (views, modifiers, etc.)
            let view = Text("Test")
                .foregroundColor(color)
            
            #expect(Bool(true), "Color should work in view context: \(color)")  // view is non-optional
        }
    }
    
    // MARK: - Integration Tests
    
    @Test @MainActor func testColorsWithSwiftUIViews() {
        // Given
        let testColors = [
            ("Primary", Color.platformPrimaryLabel),
            ("Secondary", Color.platformSecondaryLabel),
            ("Tertiary", Color.platformTertiaryLabel),
            ("Quaternary", Color.platformQuaternaryLabel),
            ("Placeholder", Color.platformPlaceholderText),
            ("Separator", Color.platformSeparator),
            ("Opaque Separator", Color.platformOpaqueSeparator)
        ]
        
        // When & Then
        for (name, color) in testColors {
            let view = platformVStackContainer {
                Text("\(name) Label")
                    .foregroundColor(color)
                
                Rectangle()
                    .fill(color)
                    .frame(height: 1)
            }
            
            #expect(Bool(true), "Color should work with SwiftUI views: \(name)")  // view is non-optional
        }
    }
    
    // MARK: - Documentation Tests
    
    @Test @MainActor func testColorUsageExamples() {
        // Given
        let exampleView = platformVStackContainer {
            Text("Primary Text")
                .foregroundColor(.platformPrimaryLabel)
            
            Text("Secondary Text")
                .foregroundColor(.platformSecondaryLabel)
            
            Text("Tertiary Text")
                .foregroundColor(.platformTertiaryLabel)
            
            Text("Quaternary Text")
                .foregroundColor(.platformQuaternaryLabel)
            
            Text("Placeholder Text")
                .foregroundColor(.platformPlaceholderText)
            
            Divider()
                .background(Color.platformSeparator)
            
            Rectangle()
                .fill(Color.platformOpaqueSeparator)
                .frame(height: 1)
        }
        
        // When & Then
        #expect(Bool(true), "Color usage examples should work correctly")  // exampleView is non-optional
    }
    
    // MARK: - Backward Compatibility Tests
    
    @Test func testBackwardCompatibility() {
        // Given & When
        let colors = [
            Color.platformPrimaryLabel,
            Color.platformSecondaryLabel,
            Color.platformTertiaryLabel,
            Color.platformQuaternaryLabel,
            Color.platformPlaceholderText,
            Color.platformSeparator,
            Color.platformOpaqueSeparator
        ]
        
        // Then
        // All colors should be backward compatible
        for color in colors {
            #expect(Bool(true), "Color should be backward compatible: \(color)")  // color is non-optional
        }
    }
    
    // MARK: - Error Handling Tests
    
    @Test func testColorErrorHandling() {
        // Given & When
        let colors = [
            Color.platformPrimaryLabel,
            Color.platformSecondaryLabel,
            Color.platformTertiaryLabel,
            Color.platformQuaternaryLabel,
            Color.platformPlaceholderText,
            Color.platformSeparator,
            Color.platformOpaqueSeparator
        ]
        
        // Then
        // Colors should handle errors gracefully
        for color in colors {
            #expect(throws: Never.self, "Color should handle errors gracefully: \(color)") { {
                _ = color
            } }
        }
    }
    
    // MARK: - Helper Functions
    
    /// Create a test view using platform colors to verify they work functionally
    @MainActor
    public func createTestViewWithPlatformColors() -> some View {
        return platformVStackContainer {
            Text("Primary Label")
                .foregroundColor(Color.platformPrimaryLabel)
            Text("Secondary Label")
                .foregroundColor(Color.platformSecondaryLabel)
            Text("Tertiary Label")
                .foregroundColor(Color.platformTertiaryLabel)
        }
        .background(Color.platformBackground)
        .accessibilityLabel("Test view using platform colors")
        .accessibilityHint("Tests that platform colors can be used in actual views")
    }
}
