//
//  EnhancedDeviceDetectionTests.swift
//  SixLayerFrameworkTests
//
//  Comprehensive tests for enhanced device capability detection system
//

import XCTest
import SwiftUI
@testable import SixLayerFramework

@MainActor
final class EnhancedDeviceDetectionTests: XCTestCase {
    
    // MARK: - iPhone Size Category Tests
    
    func testiPhoneSizeCategoryDetection() {
        // Given & When & Then
        XCTAssertEqual(iPhoneSizeCategory.from(screenSize: CGSize(width: 375, height: 667)), .standard)
        XCTAssertEqual(iPhoneSizeCategory.from(screenSize: CGSize(width: 414, height: 736)), .plus)
        XCTAssertEqual(iPhoneSizeCategory.from(screenSize: CGSize(width: 375, height: 812)), .mini)
        XCTAssertEqual(iPhoneSizeCategory.from(screenSize: CGSize(width: 414, height: 896)), .plus)
        XCTAssertEqual(iPhoneSizeCategory.from(screenSize: CGSize(width: 390, height: 844)), .standard)
        XCTAssertEqual(iPhoneSizeCategory.from(screenSize: CGSize(width: 428, height: 926)), .proMax)
        XCTAssertEqual(iPhoneSizeCategory.from(screenSize: CGSize(width: 393, height: 852)), .pro)
        XCTAssertEqual(iPhoneSizeCategory.from(screenSize: CGSize(width: 430, height: 932)), .proMax)
        XCTAssertEqual(iPhoneSizeCategory.from(screenSize: CGSize(width: 100, height: 100)), .unknown)
    }
    
    func testiPhoneSizeCategoryAllCases() {
        // Given & When
        let allCases = iPhoneSizeCategory.allCases
        
        // Then
        XCTAssertEqual(allCases.count, 6)
        XCTAssertTrue(allCases.contains(.mini))
        XCTAssertTrue(allCases.contains(.standard))
        XCTAssertTrue(allCases.contains(.plus))
        XCTAssertTrue(allCases.contains(.pro))
        XCTAssertTrue(allCases.contains(.proMax))
        XCTAssertTrue(allCases.contains(.unknown))
    }
    
    func testiPhoneSizeCategoryRawValues() {
        // Given & When & Then
        XCTAssertEqual(iPhoneSizeCategory.mini.rawValue, "mini")
        XCTAssertEqual(iPhoneSizeCategory.standard.rawValue, "standard")
        XCTAssertEqual(iPhoneSizeCategory.plus.rawValue, "plus")
        XCTAssertEqual(iPhoneSizeCategory.pro.rawValue, "pro")
        XCTAssertEqual(iPhoneSizeCategory.proMax.rawValue, "proMax")
        XCTAssertEqual(iPhoneSizeCategory.unknown.rawValue, "unknown")
    }
    
    // MARK: - iPad Size Category Tests
    
    func testiPadSizeCategoryDetection() {
        // Given & When & Then
        XCTAssertEqual(iPadSizeCategory.from(screenSize: CGSize(width: 768, height: 1024)), .standard)
        XCTAssertEqual(iPadSizeCategory.from(screenSize: CGSize(width: 834, height: 1112)), .pro)
        XCTAssertEqual(iPadSizeCategory.from(screenSize: CGSize(width: 1024, height: 1366)), .proMax)
        XCTAssertEqual(iPadSizeCategory.from(screenSize: CGSize(width: 834, height: 1194)), .mini)
        XCTAssertEqual(iPadSizeCategory.from(screenSize: CGSize(width: 100, height: 100)), .unknown)
    }
    
    func testiPadSizeCategoryAllCases() {
        // Given & When
        let allCases = iPadSizeCategory.allCases
        
        // Then
        XCTAssertEqual(allCases.count, 5)
        XCTAssertTrue(allCases.contains(.mini))
        XCTAssertTrue(allCases.contains(.standard))
        XCTAssertTrue(allCases.contains(.proMax))
        XCTAssertTrue(allCases.contains(.pro))
        XCTAssertTrue(allCases.contains(.unknown))
    }
    
    // MARK: - Screen Size Class Tests
    
    func testScreenSizeClassDetection() {
        // Given & When & Then
        // Compact: Small phones, small tablets in portrait
        XCTAssertEqual(ScreenSizeClass.from(screenSize: CGSize(width: 320, height: 568)), .compact) // iPhone SE
        XCTAssertEqual(ScreenSizeClass.from(screenSize: CGSize(width: 375, height: 667)), .compact) // iPhone 8
        XCTAssertEqual(ScreenSizeClass.from(screenSize: CGSize(width: 414, height: 896)), .compact) // iPhone XR
        
        // Regular: Large phones, tablets, small laptops
        XCTAssertEqual(ScreenSizeClass.from(screenSize: CGSize(width: 768, height: 1024)), .regular) // iPad
        XCTAssertEqual(ScreenSizeClass.from(screenSize: CGSize(width: 1024, height: 1366)), .regular) // iPad Pro 11"
        
        // Large: Large tablets, laptops, desktops, TVs
        XCTAssertEqual(ScreenSizeClass.from(screenSize: CGSize(width: 1440, height: 900)), .large) // MacBook
        XCTAssertEqual(ScreenSizeClass.from(screenSize: CGSize(width: 1920, height: 1080)), .large) // Desktop/TV
    }
    
    func testScreenSizeClassAllCases() {
        // Given & When
        let allCases = ScreenSizeClass.allCases
        
        // Then
        XCTAssertEqual(allCases.count, 3)
        XCTAssertTrue(allCases.contains(.compact))
        XCTAssertTrue(allCases.contains(.regular))
        XCTAssertTrue(allCases.contains(.large))
    }
    
    // MARK: - Device Type Tests
    
    func testDeviceTypeDetection() {
        // Given & When & Then
        #if os(iOS)
        XCTAssertEqual(DeviceType.from(screenSize: CGSize(width: 375, height: 667)), .phone)
        XCTAssertEqual(DeviceType.from(screenSize: CGSize(width: 768, height: 1024)), .pad)
        #elseif os(macOS)
        XCTAssertEqual(DeviceType.from(screenSize: CGSize(width: 1440, height: 900)), .mac)
        #elseif os(watchOS)
        XCTAssertEqual(DeviceType.from(screenSize: CGSize(width: 162, height: 197)), .watch)
        #elseif os(tvOS)
        XCTAssertEqual(DeviceType.from(screenSize: CGSize(width: 1920, height: 1080)), .tv)
        #endif
    }
    
    func testDeviceTypeAllCases() {
        // Given & When
        let allCases = DeviceType.allCases
        
        // Then
        XCTAssertTrue(allCases.contains(.phone))
        XCTAssertTrue(allCases.contains(.pad))
        XCTAssertTrue(allCases.contains(.mac))
        XCTAssertTrue(allCases.contains(.watch))
        XCTAssertTrue(allCases.contains(.tv))
    }
    
    // MARK: - Device Capabilities Tests
    
    func testDeviceCapabilitiesInitialization() {
        // Given
        let screenSize = CGSize(width: 375, height: 667)
        let orientation = DeviceOrientation.portrait
        let memoryAvailable: Int64 = 1024 * 1024 * 1024 // 1GB
        
        // When
        let capabilities = DeviceCapabilities(
            screenSize: screenSize,
            orientation: orientation,
            memoryAvailable: memoryAvailable
        )
        
        // Then
        XCTAssertEqual(capabilities.screenSize, screenSize)
        XCTAssertEqual(capabilities.orientation, orientation)
        XCTAssertEqual(capabilities.memoryAvailable, memoryAvailable)
    }
    
    func testPlatformDeviceCapabilitiesStaticProperties() {
        // Given & When & Then
        // Test that static properties are accessible
        let deviceType = PlatformDeviceCapabilities.deviceType
        let supportsHaptic = PlatformDeviceCapabilities.supportsHapticFeedback
        let supportsKeyboard = PlatformDeviceCapabilities.supportsKeyboardShortcuts
        
        // Then
        XCTAssertNotNil(deviceType)
        #if os(iOS)
        XCTAssertTrue(supportsHaptic)
        XCTAssertFalse(supportsKeyboard)
        #elseif os(macOS)
        XCTAssertFalse(supportsHaptic)
        XCTAssertTrue(supportsKeyboard)
        #endif
    }
    
    // MARK: - Enhanced Device Capabilities Tests
    
    func testEnhancedDeviceCapabilitiesInitialization() {
        // Given
        let deviceType = DeviceType.phone
        let screenSize = CGSize(width: 375, height: 667)
        let orientation = DeviceOrientation.portrait
        let memoryAvailable: Int64 = 1024 * 1024 * 1024
        let iPhoneSize = iPhoneSizeCategory.standard
        let iPadSizeCategory: iPadSizeCategory? = nil
        let screenSizeClass = ScreenSizeClass.compact
        let supportsHapticFeedback = true
        let supportsKeyboardShortcuts = false
        let supportsContextMenus = true
        let supportsSplitView = false
        let supportsStageManager = false
        let pixelDensity: CGFloat = 2.0
        let safeAreaInsets = EdgeInsets(top: 44, leading: 0, bottom: 34, trailing: 0)
        
        // When
        let capabilities = EnhancedDeviceCapabilities(
            deviceType: deviceType,
            screenSize: screenSize,
            orientation: orientation,
            memoryAvailable: memoryAvailable,
            iPhoneSizeCategory: iPhoneSize,
            iPadSizeCategory: iPadSizeCategory,
            screenSizeClass: screenSizeClass,
            supportsHapticFeedback: supportsHapticFeedback,
            supportsKeyboardShortcuts: supportsKeyboardShortcuts,
            supportsContextMenus: supportsContextMenus,
            supportsSplitView: supportsSplitView,
            supportsStageManager: supportsStageManager,
            pixelDensity: pixelDensity,
            safeAreaInsets: safeAreaInsets
        )
        
        // Then
        XCTAssertEqual(capabilities.deviceType, deviceType)
        XCTAssertEqual(capabilities.screenSize, screenSize)
        XCTAssertEqual(capabilities.orientation, orientation)
        XCTAssertEqual(capabilities.memoryAvailable, memoryAvailable)
        XCTAssertEqual(capabilities.iPhoneSizeCategory, iPhoneSize)
        XCTAssertEqual(capabilities.iPadSizeCategory, iPadSizeCategory)
        XCTAssertEqual(capabilities.screenSizeClass, screenSizeClass)
        XCTAssertEqual(capabilities.supportsHapticFeedback, supportsHapticFeedback)
        XCTAssertEqual(capabilities.supportsKeyboardShortcuts, supportsKeyboardShortcuts)
        XCTAssertEqual(capabilities.supportsContextMenus, supportsContextMenus)
        XCTAssertEqual(capabilities.supportsSplitView, supportsSplitView)
        XCTAssertEqual(capabilities.supportsStageManager, supportsStageManager)
        XCTAssertEqual(capabilities.pixelDensity, pixelDensity)
        XCTAssertEqual(capabilities.safeAreaInsets, safeAreaInsets)
    }
    
    // MARK: - Device Detection Performance Tests
    
    func testDeviceDetectionPerformance() {
        // Given
        let screenSizes = [
            CGSize(width: 375, height: 667),  // iPhone SE
            CGSize(width: 414, height: 896),  // iPhone XR
            CGSize(width: 390, height: 844),  // iPhone 12
            CGSize(width: 428, height: 926),  // iPhone 12 Pro Max
            CGSize(width: 768, height: 1024), // iPad
            CGSize(width: 1024, height: 1366) // iPad Pro
        ]
        
        // When & Then
        measure {
            for screenSize in screenSizes {
                _ = iPhoneSizeCategory.from(screenSize: screenSize)
                _ = iPadSizeCategory.from(screenSize: screenSize)
                _ = ScreenSizeClass.from(screenSize: screenSize)
                _ = DeviceType.from(screenSize: screenSize)
            }
        }
    }
    
    // MARK: - Edge Case Tests
    
    func testEdgeCaseScreenSizes() {
        // Given & When & Then
        XCTAssertEqual(iPhoneSizeCategory.from(screenSize: CGSize(width: 0, height: 0)), .unknown)
        XCTAssertEqual(iPhoneSizeCategory.from(screenSize: CGSize(width: -100, height: -100)), .unknown)
        XCTAssertEqual(iPadSizeCategory.from(screenSize: CGSize(width: 0, height: 0)), .unknown)
        XCTAssertEqual(ScreenSizeClass.from(screenSize: CGSize(width: 0, height: 0)), .compact)
    }
    
    func testVeryLargeScreenSizes() {
        // Given & When & Then
        XCTAssertEqual(iPhoneSizeCategory.from(screenSize: CGSize(width: 2000, height: 2000)), .unknown)
        XCTAssertEqual(iPadSizeCategory.from(screenSize: CGSize(width: 2000, height: 2000)), .unknown)
        XCTAssertEqual(ScreenSizeClass.from(screenSize: CGSize(width: 2000, height: 2000)), .regular)
    }
    
    // MARK: - Platform-Specific Tests
    
    func testPlatformSpecificCapabilities() {
        // Given
        let capabilities = EnhancedDeviceCapabilities(
            deviceType: .phone,
            screenSize: CGSize(width: 375, height: 667),
            orientation: .portrait,
            memoryAvailable: 1024 * 1024 * 1024,
            iPhoneSizeCategory: .standard,
            iPadSizeCategory: nil,
            screenSizeClass: .compact,
            supportsHapticFeedback: true,
            supportsKeyboardShortcuts: false,
            supportsContextMenus: true,
            supportsSplitView: false,
            supportsStageManager: false,
            pixelDensity: 2.0,
            safeAreaInsets: EdgeInsets(top: 44, leading: 0, bottom: 34, trailing: 0)
        )
        
        // When & Then
        #if os(iOS)
        XCTAssertTrue(capabilities.supportsHapticFeedback)
        XCTAssertFalse(capabilities.supportsKeyboardShortcuts)
        #elseif os(macOS)
        XCTAssertFalse(capabilities.supportsHapticFeedback)
        XCTAssertTrue(capabilities.supportsKeyboardShortcuts)
        #endif
    }
    
    // MARK: - Memory Management Tests
    
    func testMemoryThresholdDetection() {
        // Given
        let lowMemory: Int64 = 512 * 1024 * 1024  // 512MB
        let highMemory: Int64 = 4 * 1024 * 1024 * 1024  // 4GB
        
        // When
        let lowMemoryCapabilities = DeviceCapabilities(
            screenSize: CGSize(width: 375, height: 667),
            orientation: .portrait,
            memoryAvailable: lowMemory
        )
        
        let highMemoryCapabilities = DeviceCapabilities(
            screenSize: CGSize(width: 375, height: 667),
            orientation: .portrait,
            memoryAvailable: highMemory
        )
        
        // Then
        XCTAssertLessThan(lowMemoryCapabilities.memoryAvailable, 1024 * 1024 * 1024)
        XCTAssertGreaterThan(highMemoryCapabilities.memoryAvailable, 1024 * 1024 * 1024)
    }
    
    // MARK: - Orientation Tests
    
    func testOrientationDetection() {
        // Given & When & Then
        XCTAssertEqual(DeviceOrientation.portrait, .portrait)
        XCTAssertEqual(DeviceOrientation.landscape, .landscape)
        XCTAssertEqual(DeviceOrientation.unknown, .unknown)
    }
    
    func testOrientationAllCases() {
        // Given & When
        let allCases = DeviceOrientation.allCases
        
        // Then
        XCTAssertEqual(allCases.count, 7)
        XCTAssertTrue(allCases.contains(.portrait))
        XCTAssertTrue(allCases.contains(.landscape))
        XCTAssertTrue(allCases.contains(.portraitUpsideDown))
        XCTAssertTrue(allCases.contains(.landscapeLeft))
        XCTAssertTrue(allCases.contains(.landscapeRight))
        XCTAssertTrue(allCases.contains(.flat))
        XCTAssertTrue(allCases.contains(.unknown))
    }
}
