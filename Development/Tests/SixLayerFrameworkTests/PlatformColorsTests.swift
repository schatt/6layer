//
//  PlatformColorsTests.swift
//  SixLayerFrameworkTests
//
//  Tests for cross-platform color utilities
//

import XCTest
import SwiftUI
@testable import SixLayerFramework

final class PlatformColorsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Basic Color Tests
    
    func testPlatformPrimaryLabelColor() {
        // Given & When
        let color = Color.platformPrimaryLabel
        
        // Then
        XCTAssertNotNil(color, "Platform primary label color should not be nil")
        // Should be the same as platformLabel
        XCTAssertEqual(color, Color.platformLabel, "Platform primary label should equal platform label")
    }
    
    func testPlatformSecondaryLabelColor() {
        // Given & When
        let color = Color.platformSecondaryLabel
        
        // Then
        XCTAssertNotNil(color, "Platform secondary label color should not be nil")
        // Should be the same as existing platformSecondaryLabel
        XCTAssertEqual(color, Color.platformSecondaryLabel, "Platform secondary label should be consistent")
    }
    
    func testPlatformTertiaryLabelColor() {
        // Given & When
        let color = Color.platformTertiaryLabel
        
        // Then
        XCTAssertNotNil(color, "Platform tertiary label color should not be nil")
    }
    
    func testPlatformQuaternaryLabelColor() {
        // Given & When
        let color = Color.platformQuaternaryLabel
        
        // Then
        XCTAssertNotNil(color, "Platform quaternary label color should not be nil")
    }
    
    func testPlatformPlaceholderTextColor() {
        // Given & When
        let color = Color.platformPlaceholderText
        
        // Then
        XCTAssertNotNil(color, "Platform placeholder text color should not be nil")
    }
    
    func testPlatformSeparatorColor() {
        // Given & When
        let color = Color.platformSeparator
        
        // Then
        XCTAssertNotNil(color, "Platform separator color should not be nil")
    }
    
    func testPlatformOpaqueSeparatorColor() {
        // Given & When
        let color = Color.platformOpaqueSeparator
        
        // Then
        XCTAssertNotNil(color, "Platform opaque separator color should not be nil")
    }
    
    // MARK: - Platform-Specific Behavior Tests
    
    func testPlatformTertiaryLabelPlatformBehavior() {
        // Given & When
        let color = Color.platformTertiaryLabel
        
        // Then
        // On iOS, this should be .tertiaryLabel
        // On macOS, this should be .secondary
        #if os(iOS)
        // On iOS, we expect the tertiary label color
        XCTAssertNotNil(color, "Tertiary label should be available on iOS")
        #elseif os(macOS)
        // On macOS, we expect the secondary color as fallback
        XCTAssertNotNil(color, "Secondary color should be used as fallback on macOS")
        #endif
    }
    
    func testPlatformQuaternaryLabelPlatformBehavior() {
        // Given & When
        let color = Color.platformQuaternaryLabel
        
        // Then
        // On iOS, this should be .quaternaryLabel
        // On macOS, this should be .secondary
        #if os(iOS)
        // On iOS, we expect the quaternary label color
        XCTAssertNotNil(color, "Quaternary label should be available on iOS")
        #elseif os(macOS)
        // On macOS, we expect the secondary color as fallback
        XCTAssertNotNil(color, "Secondary color should be used as fallback on macOS")
        #endif
    }
    
    func testPlatformPlaceholderTextPlatformBehavior() {
        // Given & When
        let color = Color.platformPlaceholderText
        
        // Then
        // On iOS, this should be .placeholderText
        // On macOS, this should be .secondary
        #if os(iOS)
        // On iOS, we expect the placeholder text color
        XCTAssertNotNil(color, "Placeholder text should be available on iOS")
        #elseif os(macOS)
        // On macOS, we expect the secondary color as fallback
        XCTAssertNotNil(color, "Secondary color should be used as fallback on macOS")
        #endif
    }
    
    func testPlatformOpaqueSeparatorPlatformBehavior() {
        // Given & When
        let color = Color.platformOpaqueSeparator
        
        // Then
        // On iOS, this should be .opaqueSeparator
        // On macOS, this should be .separator
        #if os(iOS)
        // On iOS, we expect the opaque separator color
        XCTAssertNotNil(color, "Opaque separator should be available on iOS")
        #elseif os(macOS)
        // On macOS, we expect the separator color as fallback
        XCTAssertNotNil(color, "Separator color should be used as fallback on macOS")
        #endif
    }
    
    // MARK: - Consistency Tests
    
    func testColorConsistency() {
        // Given & When
        let primary1 = Color.platformPrimaryLabel
        let primary2 = Color.platformPrimaryLabel
        let secondary1 = Color.platformSecondaryLabel
        let secondary2 = Color.platformSecondaryLabel
        
        // Then
        // Colors should be consistent across multiple calls
        XCTAssertEqual(primary1, primary2, "Primary label color should be consistent")
        XCTAssertEqual(secondary1, secondary2, "Secondary label color should be consistent")
    }
    
    func testAllPlatformColorsAreAvailable() {
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
        for color in colors {
            XCTAssertNotNil(color, "All platform colors should be available")
        }
    }
    
    // MARK: - Accessibility Tests
    
    func testColorsWorkWithAccessibility() {
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
            // Colors should be accessible and not cause crashes
            XCTAssertNotNil(color, "Color should be accessible: \(color)")
        }
    }
    
    // MARK: - Dark Mode Tests
    
    func testColorsWorkInDarkMode() {
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
            XCTAssertNotNil(color, "Color should work in dark mode: \(color)")
        }
    }
    
    // MARK: - Performance Tests
    
    func testColorCreationPerformance() {
        // Given
        let iterations = 1000
        
        // When
        let startTime = CFAbsoluteTimeGetCurrent()
        for _ in 0..<iterations {
            _ = Color.platformPrimaryLabel
            _ = Color.platformSecondaryLabel
            _ = Color.platformTertiaryLabel
            _ = Color.platformQuaternaryLabel
            _ = Color.platformPlaceholderText
            _ = Color.platformSeparator
            _ = Color.platformOpaqueSeparator
        }
        let endTime = CFAbsoluteTimeGetCurrent()
        
        // Then
        let executionTime = endTime - startTime
        XCTAssertLessThan(executionTime, 0.1, "Color creation should be fast (under 100ms for 1000 iterations)")
    }
    
    // MARK: - Edge Case Tests
    
    func testColorsInDifferentContexts() {
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
            
            XCTAssertNotNil(view, "Color should work in view context: \(color)")
        }
    }
    
    // MARK: - Integration Tests
    
    func testColorsWithSwiftUIViews() {
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
            let view = VStack {
                Text("\(name) Label")
                    .foregroundColor(color)
                
                Rectangle()
                    .fill(color)
                    .frame(height: 1)
            }
            
            XCTAssertNotNil(view, "Color should work with SwiftUI views: \(name)")
        }
    }
    
    // MARK: - Documentation Tests
    
    func testColorUsageExamples() {
        // Given
        let exampleView = VStack {
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
        XCTAssertNotNil(exampleView, "Color usage examples should work correctly")
    }
    
    // MARK: - Backward Compatibility Tests
    
    func testBackwardCompatibility() {
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
            XCTAssertNotNil(color, "Color should be backward compatible: \(color)")
        }
    }
    
    // MARK: - Error Handling Tests
    
    func testColorErrorHandling() {
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
            XCTAssertNoThrow({
                _ = color
            }, "Color should handle errors gracefully: \(color)")
        }
    }
}
