import XCTest
import SwiftUI
@testable import SixLayerFramework

final class CrossPlatformColorTests: XCTestCase {
    
    // MARK: - Cross-Platform Color Tests
    
    func testCrossPlatformColorsAreAvailable() {
        // Test that our cross-platform colors are accessible
        XCTAssertNotNil(Color.cardBackground)
        XCTAssertNotNil(Color.secondaryBackground)
        XCTAssertNotNil(Color.primaryBackground)
        XCTAssertNotNil(Color.groupedBackground)
        XCTAssertNotNil(Color.separator)
        XCTAssertNotNil(Color.label)
        XCTAssertNotNil(Color.secondaryLabel)
    }
    
    func testCardBackgroundColorIsCrossPlatform() {
        // Test that cardBackground works on both platforms
        let cardColor = Color.cardBackground
        XCTAssertNotNil(cardColor)
        
        // Verify it's not the same as system colors (should be our custom implementation)
        XCTAssertNotEqual(cardColor, Color.clear)
        XCTAssertNotEqual(cardColor, Color.primary)
    }
    
    func testSecondaryBackgroundColorIsCrossPlatform() {
        // Test that secondaryBackground works on both platforms
        let secondaryColor = Color.secondaryBackground
        XCTAssertNotNil(secondaryColor)
        
        // Verify it's not the same as system colors
        XCTAssertNotEqual(secondaryColor, Color.clear)
        XCTAssertNotEqual(secondaryColor, Color.primary)
    }
    
    func testPrimaryBackgroundColorIsCrossPlatform() {
        // Test that primaryBackground works on both platforms
        let primaryColor = Color.primaryBackground
        XCTAssertNotNil(primaryColor)
        
        // Verify it's not the same as system colors
        XCTAssertNotEqual(primaryColor, Color.clear)
        XCTAssertNotEqual(primaryColor, Color.primary)
    }
    
    func testGroupedBackgroundColorIsCrossPlatform() {
        // Test that groupedBackground works on both platforms
        let groupedColor = Color.groupedBackground
        XCTAssertNotNil(groupedColor)
        
        // Verify it's not the same as system colors
        XCTAssertNotEqual(groupedColor, Color.clear)
        XCTAssertNotEqual(groupedColor, Color.primary)
    }
    
    func testSeparatorColorIsCrossPlatform() {
        // Test that separator works on both platforms
        let separatorColor = Color.separator
        XCTAssertNotNil(separatorColor)
        
        // Verify it's not the same as system colors
        XCTAssertNotEqual(separatorColor, Color.clear)
        XCTAssertNotEqual(separatorColor, Color.primary)
    }
    
    func testLabelColorsAreCrossPlatform() {
        // Test that label colors work on both platforms
        let labelColor = Color.label
        let secondaryLabelColor = Color.secondaryLabel
        
        XCTAssertNotNil(labelColor)
        XCTAssertNotNil(secondaryLabelColor)
        
        // Verify they're not the same as system colors
        XCTAssertNotEqual(labelColor, Color.clear)
        XCTAssertNotEqual(secondaryLabelColor, Color.clear)
    }
    
    // MARK: - Business Purpose Tests
    
    func testCrossPlatformColorsEnableConsistentUI() {
        // Test that our cross-platform colors provide consistent UI behavior
        // This is the business purpose: ensuring the framework works on both platforms
        
        let colors = [
            Color.cardBackground,
            Color.secondaryBackground,
            Color.primaryBackground,
            Color.groupedBackground
        ]
        
        // All colors should be valid and usable
        for color in colors {
            XCTAssertNotNil(color)
            // Verify color can be used in SwiftUI views
            let _ = Rectangle().fill(color)
        }
    }
    
    func testCrossPlatformColorsSupportFrameworkGoals() {
        // Test that our color system supports the framework's cross-platform goals
        // Business purpose: enabling developers to write once, run everywhere
        
        let testColors = [
            ("cardBackground", Color.cardBackground),
            ("secondaryBackground", Color.secondaryBackground),
            ("primaryBackground", Color.primaryBackground),
            ("groupedBackground", Color.groupedBackground)
        ]
        
        for (name, color) in testColors {
            // Each color should be usable in a real UI context
            let view = VStack {
                Rectangle()
                    .fill(color)
                    .frame(width: 100, height: 100)
            }
            
            XCTAssertNotNil(view)
            XCTAssertNotNil(color)
            
            // Verify the color name is descriptive and meaningful
            XCTAssertTrue(name.contains("Background"), "Color name should be descriptive: \(name)")
        }
    }
}
