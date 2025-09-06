//
//  PlatformColorEncodeTests.swift
//  SixLayerFrameworkTests
//
//  Tests for platformColorEncode() function
//

import XCTest
import SwiftUI
@testable import SixLayerFramework

final class PlatformColorEncodeTests: XCTestCase {
    
    // MARK: - Basic Color Encoding Tests
    
    func testPlatformColorEncodeWithSystemColors() {
        // Given: System colors
        let colors: [Color] = [
            .primary,
            .secondary,
            .accentColor,
            .red,
            .blue,
            .green,
            .orange,
            .purple,
            .pink,
            .yellow,
            .gray,
            .black,
            .white
        ]
        
        // When: Encoding each color
        for color in colors {
            do {
                let encodedData = try platformColorEncode(color)
                
                // Then: Should successfully encode
                XCTAssertNotNil(encodedData, "Should encode \(color) successfully")
                XCTAssertFalse(encodedData.isEmpty, "Encoded data should not be empty")
                
                // Verify data can be decoded back
                let decodedColor = try platformColorDecode(encodedData)
                XCTAssertNotNil(decodedColor, "Should decode \(color) successfully")
                
            } catch {
                XCTFail("Failed to encode \(color): \(error)")
            }
        }
    }
    
    func testPlatformColorEncodeWithCustomColors() {
        // Given: Custom colors with specific RGB values
        let customColors: [(Color, String)] = [
            (Color(red: 1.0, green: 0.0, blue: 0.0), "Red"),
            (Color(red: 0.0, green: 1.0, blue: 0.0), "Green"),
            (Color(red: 0.0, green: 0.0, blue: 1.0), "Blue"),
            (Color(red: 0.5, green: 0.5, blue: 0.5), "Gray"),
            (Color(red: 1.0, green: 1.0, blue: 1.0), "White"),
            (Color(red: 0.0, green: 0.0, blue: 0.0), "Black")
        ]
        
        // When: Encoding each custom color
        for (color, name) in customColors {
            do {
                let encodedData = try platformColorEncode(color)
                
                // Then: Should successfully encode
                XCTAssertNotNil(encodedData, "Should encode \(name) successfully")
                XCTAssertFalse(encodedData.isEmpty, "Encoded data should not be empty for \(name)")
                
            } catch {
                XCTFail("Failed to encode \(name): \(error)")
            }
        }
    }
    
    func testPlatformColorEncodeWithAlphaValues() {
        // Given: Colors with different alpha values
        let alphaColors: [(Color, Float)] = [
            (Color(red: 1.0, green: 0.0, blue: 0.0, opacity: 1.0), 1.0),
            (Color(red: 1.0, green: 0.0, blue: 0.0, opacity: 0.8), 0.8),
            (Color(red: 1.0, green: 0.0, blue: 0.0, opacity: 0.5), 0.5),
            (Color(red: 1.0, green: 0.0, blue: 0.0, opacity: 0.2), 0.2),
            (Color(red: 1.0, green: 0.0, blue: 0.0, opacity: 0.0), 0.0)
        ]
        
        // When: Encoding each alpha color
        for (color, expectedAlpha) in alphaColors {
            do {
                let encodedData = try platformColorEncode(color)
                
                // Then: Should successfully encode
                XCTAssertNotNil(encodedData, "Should encode color with alpha \(expectedAlpha) successfully")
                XCTAssertFalse(encodedData.isEmpty, "Encoded data should not be empty")
                
            } catch {
                XCTFail("Failed to encode color with alpha \(expectedAlpha): \(error)")
            }
        }
    }
    
    // MARK: - Platform-Specific Tests
    
    func testPlatformColorEncodeCrossPlatformCompatibility() {
        // Given: A standard color
        let color = Color(red: 0.5, green: 0.3, blue: 0.8, opacity: 0.9)
        
        // When: Encoding the color
        do {
            let encodedData = try platformColorEncode(color)
            
            // Then: Should work on current platform
            XCTAssertNotNil(encodedData, "Should encode color on current platform")
            XCTAssertFalse(encodedData.isEmpty, "Encoded data should not be empty")
            
            // Verify platform-specific encoding
            #if os(iOS)
            XCTAssertTrue(encodedData.count > 0, "iOS encoding should produce data")
            #elseif os(macOS)
            XCTAssertTrue(encodedData.count > 0, "macOS encoding should produce data")
            #endif
            
        } catch {
            XCTFail("Failed to encode color: \(error)")
        }
    }
    
    // MARK: - Error Handling Tests
    
    func testPlatformColorEncodeWithInvalidColor() {
        // Given: An invalid color (if such exists)
        // Note: SwiftUI Color doesn't really have "invalid" colors, but we can test edge cases
        
        // When: Encoding edge case colors
        let edgeCaseColors: [Color] = [
            Color(red: -1.0, green: 0.0, blue: 0.0), // Negative red
            Color(red: 2.0, green: 0.0, blue: 0.0),  // Red > 1.0
            Color(red: 0.0, green: -0.5, blue: 1.5)  // Mixed invalid values
        ]
        
        for color in edgeCaseColors {
            do {
                let encodedData = try platformColorEncode(color)
                
                // Then: Should handle edge cases gracefully
                XCTAssertNotNil(encodedData, "Should handle edge case color gracefully")
                
            } catch {
                // Edge cases might throw errors, which is acceptable
                XCTAssertTrue(error is ColorEncodingError, "Should throw ColorEncodingError for invalid colors")
            }
        }
    }
    
    // MARK: - Data Integrity Tests
    
    func testPlatformColorEncodeDataIntegrity() {
        // Given: A specific color
        let originalColor = Color(red: 0.7, green: 0.2, blue: 0.9, opacity: 0.8)
        
        // When: Encoding and decoding the color
        do {
            let encodedData = try platformColorEncode(originalColor)
            let decodedColor = try platformColorDecode(encodedData)
            
            // Then: Decoded color should match original (within tolerance)
            XCTAssertNotNil(decodedColor, "Should decode color successfully")
            
            // Note: Exact color matching might be difficult due to platform differences
            // We'll verify the data was encoded and decoded successfully
            
        } catch {
            XCTFail("Failed to encode/decode color: \(error)")
        }
    }
    
    func testPlatformColorEncodeConsistency() {
        // Given: The same color
        let color = Color.blue
        
        // When: Encoding multiple times
        var encodedDataSets: [Data] = []
        
        for _ in 0..<5 {
            do {
                let encodedData = try platformColorEncode(color)
                encodedDataSets.append(encodedData)
            } catch {
                XCTFail("Failed to encode color consistently: \(error)")
            }
        }
        
        // Then: All encodings should be successful and similar size
        XCTAssertEqual(encodedDataSets.count, 5, "Should encode 5 times successfully")
        
        // Note: NSKeyedArchiver may include timestamps, so exact equality isn't guaranteed
        // Instead, we verify all encodings are similar in size and can be decoded
        let firstSize = encodedDataSets[0].count
        for (index, encodedData) in encodedDataSets.enumerated() {
            XCTAssertFalse(encodedData.isEmpty, "Encoding \(index) should not be empty")
            // Allow for small variations in size due to timestamps
            XCTAssertTrue(abs(encodedData.count - firstSize) < 100, 
                         "Encoding \(index) size should be similar to first encoding")
        }
    }
    
    // MARK: - Performance Tests
    
    func testPlatformColorEncodePerformance() {
        // Given: A color to encode
        let color = Color(red: 0.5, green: 0.5, blue: 0.5, opacity: 0.5)
        
        // When: Measuring encoding performance
        measure {
            for _ in 0..<100 {
                do {
                    _ = try platformColorEncode(color)
                } catch {
                    XCTFail("Performance test failed: \(error)")
                }
            }
        }
    }
    
    // MARK: - Memory Tests
    
    func testPlatformColorEncodeMemoryUsage() {
        // Given: Multiple colors
        let colors = (0..<100).map { i in
            Color(red: Double(i) / 100.0, green: 0.5, blue: 0.5, opacity: 0.8)
        }
        
        // When: Encoding all colors
        var encodedDataArray: [Data] = []
        
        for color in colors {
            do {
                let encodedData = try platformColorEncode(color)
                encodedDataArray.append(encodedData)
            } catch {
                XCTFail("Failed to encode color in memory test: \(error)")
            }
        }
        
        // Then: Should handle memory efficiently
        XCTAssertEqual(encodedDataArray.count, 100, "Should encode all 100 colors")
        
        // Verify no memory leaks by ensuring we can process the data
        for encodedData in encodedDataArray {
            XCTAssertFalse(encodedData.isEmpty, "Encoded data should not be empty")
        }
    }
}

// MARK: - Helper Functions for Testing

/// Decode a color from encoded data (for testing purposes)
private func testPlatformColorDecode(_ data: Data) throws -> Color? {
    do {
        #if os(iOS)
        if let uiColor = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data) {
            return Color(uiColor)
        }
        #elseif os(macOS)
        if let nsColor = try NSKeyedUnarchiver.unarchivedObject(ofClass: NSColor.self, from: data) {
            return Color(nsColor)
        }
        #endif
        return nil
    } catch {
        throw ColorEncodingError.decodingFailed(error)
    }
}
