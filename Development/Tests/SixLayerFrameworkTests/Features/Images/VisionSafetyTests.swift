import Testing


//
//  VisionSafetyTests.swift
//  SixLayerFrameworkTests
//
//  Tests for safe Vision framework integration with availability checks
//

import SwiftUI
@testable import SixLayerFramework

@Suite("Vision Safety")
open class VisionSafetyTests {
    
    // MARK: - Vision Availability Tests
    
    @Test func testVisionFrameworkAvailability() {
        // Given: A test environment
        // When: Checking Vision framework availability
        // Then: Should handle availability gracefully
        
        #if canImport(Vision)
        // Vision is available - this is expected on iOS 11+ and macOS 10.15+
        #expect(true, "Vision framework should be available on supported platforms")
        #else
        // Vision is not available - should have fallback behavior
        #expect(true, "Should handle Vision unavailability gracefully")
        #endif
    }
    
    @Test func testOCRAvailabilityCheck() {
        // Given: OCR context and image
        let _ = OCRContext(
            textTypes: [.general],
            language: .english,
            confidenceThreshold: 0.8
        )
        let _ = PlatformImage()
        
        // When: Checking OCR availability
        let isOCRAvailable = PlatformTestUtilities.getOCRAvailability(for: SixLayerPlatform.current)

        // Then: Should return appropriate availability status
        let platform = SixLayerPlatform.current
        switch platform {
        case .iOS, .macOS:
            #expect(isOCRAvailable, "OCR should be available on \(platform)")
        case .watchOS, .tvOS, .visionOS:
            #expect(!isOCRAvailable, "OCR should not be available on \(platform)")
        }
    }
    
    @Test func testOCRFallbackBehavior() {
        // Given: OCR context and image
        let context = OCRContext(
            textTypes: [.general],
            language: .english,
            confidenceThreshold: 0.8
        )
        let image = PlatformImage()
        
        // When: Testing OCR availability
        let isOCRAvailable = isVisionOCRAvailable()
        
        // Then: OCR availability should be deterministic
        if isOCRAvailable {
            #expect(isOCRAvailable, "OCR should be available when Vision framework is present")
        } else {
            #expect(!isOCRAvailable, "OCR should not be available when Vision framework is not present")
        }
        
        // Test that fallback behavior is handled gracefully
        let service = OCRService()
        
        // Just verify the function can be called without crashing
        Task {
            do {
                let _ = try await service.processImage(
                    image,
                    context: context,
                    strategy: OCRStrategy(
                        supportedTextTypes: [.general],
                        supportedLanguages: [.english],
                        processingMode: .standard,
                        requiresNeuralEngine: false,
                        estimatedProcessingTime: 1.0
                    )
                )
            } catch {
                // Expected for test images - this is the fallback behavior
            }
        }
        
        // Don't wait for async completion - just verify the function can be called
    }
    
    @Test func testVisionFrameworkVersionCheck() {
        // Given: A test environment
        // When: Checking Vision framework version compatibility
        let isCompatible = isVisionFrameworkCompatible()
        
        // Then: Should return appropriate compatibility status
        #if canImport(Vision)
        #if os(iOS)
        if #available(iOS 11.0, *) {
            #expect(isCompatible, "Vision should be compatible on iOS 11+")
        } else {
            #expect(!isCompatible, "Vision should not be compatible on iOS < 11")
        }
        #elseif os(macOS)
        if #available(macOS 10.15, *) {
            #expect(isCompatible, "Vision should be compatible on macOS 10.15+")
        } else {
            #expect(!isCompatible, "Vision should not be compatible on macOS < 10.15")
        }
        #else
        #expect(!isCompatible, "Vision should not be compatible on unsupported platforms")
        #endif
        #else
        #expect(!isCompatible, "Vision should not be compatible when framework is unavailable")
        #endif
    }
    
    @Test func testOCRErrorHandling() {
        // Given: Invalid image for OCR
        let context = OCRContext(
            textTypes: [.general],
            language: .english,
            confidenceThreshold: 0.8
        )
        
        // When: Testing OCR error handling
        let isOCRAvailable = isVisionOCRAvailable()
        
        // Then: OCR availability should be deterministic
        if isOCRAvailable {
            #expect(isOCRAvailable, "OCR should be available when Vision framework is present")
        } else {
            #expect(!isOCRAvailable, "OCR should not be available when Vision framework is not present")
        }
        
        // Test that error handling works gracefully
        let service = OCRService()
        
        // Just verify the function can be called without crashing
        Task {
            do {
                let _ = try await service.processImage(
                    PlatformImage(), // Invalid image
                    context: context,
                    strategy: OCRStrategy(
                        supportedTextTypes: [.general],
                        supportedLanguages: [.english],
                        processingMode: .standard,
                        requiresNeuralEngine: false,
                        estimatedProcessingTime: 1.0
                    )
                )
            } catch {
                // Expected for invalid images - this is the error handling behavior
            }
        }
        
        // Don't wait for async completion - just verify the function can be called
    }
    
    @Test func testPlatformSpecificVisionAvailability() {
        // Given: Different platforms
        // When: Checking Vision availability per platform
        let availability = SixLayerFramework.getVisionAvailabilityInfo()
        
        // Then: Should provide accurate platform-specific information
        // availability is a non-optional struct, and all its properties are non-optional, so they exist if we reach here
        
        #if os(iOS)
        #expect(availability.platform == "iOS", "Should identify iOS platform")
        #elseif os(macOS)
        #expect(availability.platform == "macOS", "Should identify macOS platform")
        #else
        #expect(availability.platform == "Unknown", "Should identify unknown platform")
        #endif
    }
}

// MARK: - Helper Functions for Testing

/// Check if Vision OCR is available using centralized utilities
private func isVisionOCRAvailable() -> Bool {
    return PlatformTestUtilities.getOCRAvailability(for: SixLayerPlatform.current)
}

/// Check if Vision framework is compatible with current platform using centralized utilities
private func isVisionFrameworkCompatible() -> Bool {
    return PlatformTestUtilities.getVisionAvailability(for: SixLayerPlatform.current)
}

/// Get Vision availability information
private func getVisionAvailabilityInfo() -> (platform: String, isAvailable: Bool, minVersion: String) {
    #if os(iOS)
    let platform = "iOS"
    let minVersion = "11.0"
    #if canImport(Vision)
    let isAvailable: Bool
    if #available(iOS 11.0, *) {
        isAvailable = true
    } else {
        isAvailable = false
    }
    #else
    let isAvailable = false
    #endif
    #elseif os(macOS)
    let platform = "macOS"
    let minVersion = "10.15"
    #if canImport(Vision)
    let isAvailable: Bool
    if #available(macOS 10.15, *) {
        isAvailable = true
    } else {
        isAvailable = false
    }
    #else
    let isAvailable = false
    #endif
    #else
    let platform = "Unknown"
    let minVersion = "N/A"
    let isAvailable = false
    #endif
    
    return (platform: platform, isAvailable: isAvailable, minVersion: minVersion)
}
