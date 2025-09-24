//
//  PhotoSelectionL1Tests.swift
//  SixLayerFrameworkTests
//
//  Tests for photo selection L1 functions
//  Tests photo selection and gallery features
//

import XCTest
import SwiftUI
@testable import SixLayerFramework

@MainActor
final class PhotoSelectionL1Tests: XCTestCase {
    
    // MARK: - Test Data
    
    private var samplePhotoContext: PhotoContext = PhotoContext(
        screenSize: CGSize(width: 375, height: 667),
        availableSpace: CGSize(width: 375, height: 667),
        userPreferences: PhotoPreferences(),
        deviceCapabilities: PhotoDeviceCapabilities()
    )
    
    private var sampleHints: PresentationHints = PresentationHints()
    
    override func setUp() {
        super.setUp()
        samplePhotoContext = PhotoContext(
            screenSize: CGSize(width: 375, height: 667),
            availableSpace: CGSize(width: 375, height: 667),
            userPreferences: PhotoPreferences(),
            deviceCapabilities: PhotoDeviceCapabilities()
        )
        sampleHints = PresentationHints()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Photo Selection Tests
    
    func testPlatformPhotoSelection_L1() {
        // Given
        let purpose = PhotoPurpose.vehiclePhoto
        let context = samplePhotoContext
        
        // When
        let view = platformPhotoSelection_L1(
            purpose: purpose,
            context: context,
            onImageSelected: { _ in }
        )
        
        // Then
        XCTAssertNotNil(view, "platformPhotoSelection_L1 should return a view")
    }
    
    func testPlatformPhotoSelection_L1_WithDifferentPurpose() {
        // Given
        let purpose = PhotoPurpose.fuelReceipt
        let context = samplePhotoContext
        
        // When
        let view = platformPhotoSelection_L1(
            purpose: purpose,
            context: context,
            onImageSelected: { _ in }
        )
        
        // Then
        XCTAssertNotNil(view, "platformPhotoSelection_L1 with different purpose should return a view")
    }
    
    // MARK: - Different Photo Purposes
    
    func testPlatformPhotoSelection_L1_FuelReceipt() {
        // Given
        let purpose = PhotoPurpose.fuelReceipt
        let context = samplePhotoContext
        
        // When
        let view = platformPhotoSelection_L1(
            purpose: purpose,
            context: context,
            onImageSelected: { _ in }
        )
        
        // Then
        XCTAssertNotNil(view, "platformPhotoSelection_L1 for fuel receipt should return a view")
    }
    
    func testPlatformPhotoSelection_L1_PumpDisplay() {
        // Given
        let purpose = PhotoPurpose.pumpDisplay
        let context = samplePhotoContext
        
        // When
        let view = platformPhotoSelection_L1(
            purpose: purpose,
            context: context,
            onImageSelected: { _ in }
        )
        
        // Then
        XCTAssertNotNil(view, "platformPhotoSelection_L1 for pump display should return a view")
    }
    
    func testPlatformPhotoSelection_L1_Odometer() {
        // Given
        let purpose = PhotoPurpose.odometer
        let context = samplePhotoContext
        
        // When
        let view = platformPhotoSelection_L1(
            purpose: purpose,
            context: context,
            onImageSelected: { _ in }
        )
        
        // Then
        XCTAssertNotNil(view, "platformPhotoSelection_L1 for odometer should return a view")
    }
    
    func testPlatformPhotoSelection_L1_Maintenance() {
        // Given
        let purpose = PhotoPurpose.maintenance
        let context = samplePhotoContext
        
        // When
        let view = platformPhotoSelection_L1(
            purpose: purpose,
            context: context,
            onImageSelected: { _ in }
        )
        
        // Then
        XCTAssertNotNil(view, "platformPhotoSelection_L1 for maintenance should return a view")
    }
    
    func testPlatformPhotoSelection_L1_Expense() {
        // Given
        let purpose = PhotoPurpose.expense
        let context = samplePhotoContext
        
        // When
        let view = platformPhotoSelection_L1(
            purpose: purpose,
            context: context,
            onImageSelected: { _ in }
        )
        
        // Then
        XCTAssertNotNil(view, "platformPhotoSelection_L1 for expense should return a view")
    }
    
    func testPlatformPhotoSelection_L1_Profile() {
        // Given
        let purpose = PhotoPurpose.profile
        let context = samplePhotoContext
        
        // When
        let view = platformPhotoSelection_L1(
            purpose: purpose,
            context: context,
            onImageSelected: { _ in }
        )
        
        // Then
        XCTAssertNotNil(view, "platformPhotoSelection_L1 for profile should return a view")
    }
    
    func testPlatformPhotoSelection_L1_Document() {
        // Given
        let purpose = PhotoPurpose.document
        let context = samplePhotoContext
        
        // When
        let view = platformPhotoSelection_L1(
            purpose: purpose,
            context: context,
            onImageSelected: { _ in }
        )
        
        // Then
        XCTAssertNotNil(view, "platformPhotoSelection_L1 for document should return a view")
    }
    
    // MARK: - Edge Cases
    
    func testPlatformPhotoSelection_L1_WithEmptyContext() {
        // Given
        let purpose = PhotoPurpose.vehiclePhoto
        let context = PhotoContext(
            screenSize: CGSize.zero,
            availableSpace: CGSize.zero,
            userPreferences: PhotoPreferences(),
            deviceCapabilities: PhotoDeviceCapabilities()
        )
        
        // When
        let view = platformPhotoSelection_L1(
            purpose: purpose,
            context: context,
            onImageSelected: { _ in }
        )
        
        // Then
        XCTAssertNotNil(view, "platformPhotoSelection_L1 with empty context should return a view")
    }
    
    // MARK: - Performance Tests
    
    func testPlatformPhotoSelection_L1_Performance() {
        // Given
        let purpose = PhotoPurpose.vehiclePhoto
        let context = samplePhotoContext
        
        // When & Then
        measure {
            let view = platformPhotoSelection_L1(
                purpose: purpose,
                context: context,
                onImageSelected: { _ in }
            )
            XCTAssertNotNil(view)
        }
    }
}
