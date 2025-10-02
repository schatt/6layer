//
//  L3StrategySelectionTests.swift
//  SixLayerFrameworkTests
//
//  Tests for L3 strategy selection functions
//  Tests strategy selection logic with hardcoded platform, capabilities, and accessibility
//

import XCTest
import SwiftUI
@testable import SixLayerFramework

@MainActor
final class L3StrategySelectionTests: XCTestCase {
    
    // MARK: - Test Data
    
    private var samplePhotoContext: PhotoContext = PhotoContext(
        screenSize: CGSize(width: 375, height: 667),
        availableSpace: CGSize(width: 375, height: 667),
        userPreferences: PhotoPreferences(),
        deviceCapabilities: PhotoDeviceCapabilities()
    )
    
    override func setUp() {
        super.setUp()
        samplePhotoContext = PhotoContext(
            screenSize: CGSize(width: 375, height: 667),
            availableSpace: CGSize(width: 375, height: 667),
            userPreferences: PhotoPreferences(),
            deviceCapabilities: PhotoDeviceCapabilities()
        )
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Card Layout Strategy Tests
    
    func testSelectCardLayoutStrategy_L3_WithSmallContent() {
        // Given
        let contentCount = 3
        let screenWidth: CGFloat = 375
        let deviceType = DeviceType.phone
        let complexity = ContentComplexity.simple
        
        // When
        let strategy = selectCardLayoutStrategy_L3(
            contentCount: contentCount,
            screenWidth: screenWidth,
            deviceType: deviceType,
            contentComplexity: complexity
        )
        
        // Then
        XCTAssertNotNil(strategy, "selectCardLayoutStrategy_L3 should return a strategy")
        XCTAssertGreaterThan(strategy.columns, 0, "Should have at least 1 column")
        XCTAssertGreaterThan(strategy.spacing, 0, "Should have positive spacing")
        XCTAssertFalse(strategy.reasoning.isEmpty, "Should provide reasoning")
    }
    
    func testSelectCardLayoutStrategy_L3_WithLargeContent() {
        // Given
        let contentCount = 20
        let screenWidth: CGFloat = 1024
        let deviceType = DeviceType.pad
        let complexity = ContentComplexity.complex
        
        // When
        let strategy = selectCardLayoutStrategy_L3(
            contentCount: contentCount,
            screenWidth: screenWidth,
            deviceType: deviceType,
            contentComplexity: complexity
        )
        
        // Then
        XCTAssertNotNil(strategy, "selectCardLayoutStrategy_L3 should return a strategy")
        XCTAssertGreaterThan(strategy.columns, 1, "Should have multiple columns for large content")
        XCTAssertGreaterThan(strategy.spacing, 0, "Should have positive spacing")
        XCTAssertFalse(strategy.reasoning.isEmpty, "Should provide reasoning")
    }
    
    func testSelectCardLayoutStrategy_L3_WithDifferentDeviceTypes() {
        let contentCount = 10
        let complexity = ContentComplexity.moderate
        
        // Test phone
        let phoneStrategy = selectCardLayoutStrategy_L3(
            contentCount: contentCount,
            screenWidth: 375,
            deviceType: .phone,
            contentComplexity: complexity
        )
        XCTAssertNotNil(phoneStrategy, "Phone device type should return a strategy")
        
        // Test pad
        let padStrategy = selectCardLayoutStrategy_L3(
            contentCount: contentCount,
            screenWidth: 768,
            deviceType: .pad,
            contentComplexity: complexity
        )
        XCTAssertNotNil(padStrategy, "Pad device type should return a strategy")
        
        // Test mac
        let macStrategy = selectCardLayoutStrategy_L3(
            contentCount: contentCount,
            screenWidth: 1024,
            deviceType: .mac,
            contentComplexity: complexity
        )
        XCTAssertNotNil(macStrategy, "Mac device type should return a strategy")
    }
    
    func testSelectCardLayoutStrategy_L3_WithDifferentComplexityLevels() {
        let contentCount = 10
        let screenWidth: CGFloat = 375
        let deviceType = DeviceType.phone
        
        // Test simple complexity
        let simpleStrategy = selectCardLayoutStrategy_L3(
            contentCount: contentCount,
            screenWidth: screenWidth,
            deviceType: deviceType,
            contentComplexity: .simple
        )
        XCTAssertNotNil(simpleStrategy, "Simple complexity should return a strategy")
        
        // Test moderate complexity
        let moderateStrategy = selectCardLayoutStrategy_L3(
            contentCount: contentCount,
            screenWidth: screenWidth,
            deviceType: deviceType,
            contentComplexity: .moderate
        )
        XCTAssertNotNil(moderateStrategy, "Moderate complexity should return a strategy")
        
        // Test complex complexity
        let complexStrategy = selectCardLayoutStrategy_L3(
            contentCount: contentCount,
            screenWidth: screenWidth,
            deviceType: deviceType,
            contentComplexity: .complex
        )
        XCTAssertNotNil(complexStrategy, "Complex complexity should return a strategy")
    }
    
    // MARK: - Form Strategy Tests
    
    func testSelectFormStrategy_AddFuelView_L3() {
        // Given
        let layout = FormLayoutDecision(
            containerType: .form,
            fieldLayout: .standard,
            spacing: .comfortable,
            validation: .realTime
        )
        
        // When
        let strategy = selectFormStrategy_AddFuelView_L3(layout: layout)
        
        // Then
        XCTAssertNotNil(strategy, "selectFormStrategy_AddFuelView_L3 should return a strategy")
    }
    
    func testSelectModalStrategy_Form_L3() {
        // Given
        let layout = ModalLayoutDecision(
            presentationType: .sheet,
            sizing: .medium
        )
        
        // When
        let strategy = selectModalStrategy_Form_L3(layout: layout)
        
        // Then
        XCTAssertNotNil(strategy, "selectModalStrategy_Form_L3 should return a strategy")
    }
    
    // MARK: - OCR Strategy Tests
    
    func testPlatformOCRStrategy_L3_WithGeneralText() {
        // Given
        let textTypes = [TextType.general]
        let platform = SixLayerPlatform.iOS
        
        // When
        let strategy = platformOCRStrategy_L3(
            textTypes: textTypes,
            platform: platform
        )
        
        // Then
        XCTAssertNotNil(strategy, "platformOCRStrategy_L3 should return a strategy")
        XCTAssertFalse(strategy.supportedTextTypes.isEmpty, "Should support text types")
        XCTAssertFalse(strategy.supportedLanguages.isEmpty, "Should support languages")
        XCTAssertGreaterThan(strategy.estimatedProcessingTime, 0, "Should have positive processing time")
    }
    
    func testPlatformOCRStrategy_L3_WithPriceText() {
        // Given
        let textTypes = [TextType.price]
        let platform = SixLayerPlatform.iOS
        
        // When
        let strategy = platformOCRStrategy_L3(
            textTypes: textTypes,
            platform: platform
        )
        
        // Then
        XCTAssertNotNil(strategy, "platformOCRStrategy_L3 should return a strategy")
        XCTAssertFalse(strategy.supportedTextTypes.isEmpty, "Should support text types")
        XCTAssertFalse(strategy.supportedLanguages.isEmpty, "Should support languages")
        XCTAssertGreaterThan(strategy.estimatedProcessingTime, 0, "Should have positive processing time")
    }
    
    func testPlatformOCRStrategy_L3_WithDateText() {
        // Given
        let textTypes = [TextType.date]
        let platform = SixLayerPlatform.iOS
        
        // When
        let strategy = platformOCRStrategy_L3(
            textTypes: textTypes,
            platform: platform
        )
        
        // Then
        XCTAssertNotNil(strategy, "platformOCRStrategy_L3 should return a strategy")
        XCTAssertFalse(strategy.supportedTextTypes.isEmpty, "Should support text types")
        XCTAssertFalse(strategy.supportedLanguages.isEmpty, "Should support languages")
        XCTAssertGreaterThan(strategy.estimatedProcessingTime, 0, "Should have positive processing time")
    }
    
    func testPlatformOCRStrategy_L3_WithMultipleTextTypes() {
        // Given
        let textTypes = [TextType.general, TextType.price, TextType.date]
        let platform = SixLayerPlatform.iOS
        
        // When
        let strategy = platformOCRStrategy_L3(
            textTypes: textTypes,
            platform: platform
        )
        
        // Then
        XCTAssertNotNil(strategy, "platformOCRStrategy_L3 should return a strategy")
        XCTAssertFalse(strategy.supportedTextTypes.isEmpty, "Should support text types")
        XCTAssertFalse(strategy.supportedLanguages.isEmpty, "Should support languages")
        XCTAssertGreaterThan(strategy.estimatedProcessingTime, 0, "Should have positive processing time")
    }
    
    func testPlatformOCRStrategy_L3_WithDifferentPlatforms() {
        let textTypes = [TextType.general]
        
        // Test iOS
        let iOSStrategy = platformOCRStrategy_L3(
            textTypes: textTypes,
            platform: .iOS
        )
        XCTAssertNotNil(iOSStrategy, "iOS platform should return a strategy")
        
        // Test macOS
        let macOSStrategy = platformOCRStrategy_L3(
            textTypes: textTypes,
            platform: .macOS
        )
        XCTAssertNotNil(macOSStrategy, "macOS platform should return a strategy")
        
        // Test watchOS
        let watchOSStrategy = platformOCRStrategy_L3(
            textTypes: textTypes,
            platform: .watchOS
        )
        XCTAssertNotNil(watchOSStrategy, "watchOS platform should return a strategy")
        
        // Test tvOS
        let tvOSStrategy = platformOCRStrategy_L3(
            textTypes: textTypes,
            platform: .tvOS
        )
        XCTAssertNotNil(tvOSStrategy, "tvOS platform should return a strategy")
        
        // Test visionOS
        let visionOSStrategy = platformOCRStrategy_L3(
            textTypes: textTypes,
            platform: .visionOS
        )
        XCTAssertNotNil(visionOSStrategy, "visionOS platform should return a strategy")
    }
    
    func testPlatformDocumentOCRStrategy_L3() {
        // Given
        let documentType = DocumentType.general
        let platform = SixLayerPlatform.iOS
        
        // When
        let strategy = platformDocumentOCRStrategy_L3(
            documentType: documentType,
            platform: platform
        )
        
        // Then
        XCTAssertNotNil(strategy, "platformDocumentOCRStrategy_L3 should return a strategy")
        XCTAssertFalse(strategy.supportedTextTypes.isEmpty, "Should support text types")
        XCTAssertFalse(strategy.supportedLanguages.isEmpty, "Should support languages")
        XCTAssertGreaterThan(strategy.estimatedProcessingTime, 0, "Should have positive processing time")
    }
    
    func testPlatformReceiptOCRStrategy_L3() {
        // Given
        let platform = SixLayerPlatform.iOS
        
        // When
        let strategy = platformReceiptOCRStrategy_L3(platform: platform)
        
        // Then
        XCTAssertNotNil(strategy, "platformReceiptOCRStrategy_L3 should return a strategy")
        XCTAssertFalse(strategy.supportedTextTypes.isEmpty, "Should support text types")
        XCTAssertFalse(strategy.supportedLanguages.isEmpty, "Should support languages")
        XCTAssertGreaterThan(strategy.estimatedProcessingTime, 0, "Should have positive processing time")
    }
    
    func testPlatformBusinessCardOCRStrategy_L3() {
        // Given
        let platform = SixLayerPlatform.iOS
        
        // When
        let strategy = platformBusinessCardOCRStrategy_L3(platform: platform)
        
        // Then
        XCTAssertNotNil(strategy, "platformBusinessCardOCRStrategy_L3 should return a strategy")
        XCTAssertFalse(strategy.supportedTextTypes.isEmpty, "Should support text types")
        XCTAssertFalse(strategy.supportedLanguages.isEmpty, "Should support languages")
        XCTAssertGreaterThan(strategy.estimatedProcessingTime, 0, "Should have positive processing time")
    }
    
    func testPlatformInvoiceOCRStrategy_L3() {
        // Given
        let platform = SixLayerPlatform.iOS
        
        // When
        let strategy = platformInvoiceOCRStrategy_L3(platform: platform)
        
        // Then
        XCTAssertNotNil(strategy, "platformInvoiceOCRStrategy_L3 should return a strategy")
        XCTAssertFalse(strategy.supportedTextTypes.isEmpty, "Should support text types")
        XCTAssertFalse(strategy.supportedLanguages.isEmpty, "Should support languages")
        XCTAssertGreaterThan(strategy.estimatedProcessingTime, 0, "Should have positive processing time")
    }
    
    func testPlatformOptimalOCRStrategy_L3() {
        // Given
        let textTypes = [TextType.general, TextType.price, TextType.date]
        let platform = SixLayerPlatform.iOS
        let confidenceThreshold: Float = 0.8
        
        // When
        let strategy = platformOptimalOCRStrategy_L3(
            textTypes: textTypes,
            confidenceThreshold: confidenceThreshold,
            platform: platform
        )
        
        // Then
        XCTAssertNotNil(strategy, "platformOptimalOCRStrategy_L3 should return a strategy")
        XCTAssertFalse(strategy.supportedTextTypes.isEmpty, "Should support text types")
        XCTAssertFalse(strategy.supportedLanguages.isEmpty, "Should support languages")
        XCTAssertGreaterThan(strategy.estimatedProcessingTime, 0, "Should have positive processing time")
    }
    
    func testPlatformBatchOCRStrategy_L3() {
        // Given
        let textTypes = [TextType.general, TextType.price, TextType.date]
        let platform = SixLayerPlatform.iOS
        
        // When
        let strategy = platformBatchOCRStrategy_L3(
            textTypes: textTypes,
            batchSize: 10,
            platform: platform
        )
        
        // Then
        XCTAssertNotNil(strategy, "platformBatchOCRStrategy_L3 should return a strategy")
        XCTAssertFalse(strategy.supportedTextTypes.isEmpty, "Should support text types")
        XCTAssertFalse(strategy.supportedLanguages.isEmpty, "Should support languages")
        XCTAssertGreaterThan(strategy.estimatedProcessingTime, 0, "Should have positive processing time")
    }
    
    // MARK: - Card Expansion Strategy Tests
    
    func testSelectCardExpansionStrategy_L3_WithStaticInteraction() {
        // Given
        let contentCount = 10
        let screenWidth: CGFloat = 375
        let deviceType = DeviceType.phone
        let interactionStyle = InteractionStyle.static
        let contentDensity = ContentDensity.dense
        
        // When
        let strategy = selectCardExpansionStrategy_L3(
            contentCount: contentCount,
            screenWidth: screenWidth,
            deviceType: deviceType,
            interactionStyle: interactionStyle,
            contentDensity: contentDensity
        )
        
        // Then
        XCTAssertNotNil(strategy, "selectCardExpansionStrategy_L3 should return a strategy")
        XCTAssertEqual(strategy.supportedStrategies, [ExpansionStrategy.none], "Static interaction should only support none strategy")
        XCTAssertEqual(strategy.primaryStrategy, ExpansionStrategy.none, "Primary strategy should be none")
        XCTAssertEqual(strategy.expansionScale, 1.0, "Expansion scale should be 1.0")
        XCTAssertEqual(strategy.animationDuration, 0.0, "Animation duration should be 0.0")
    }
    
    func testSelectCardExpansionStrategy_L3_WithTouchInteraction() {
        // Given
        let contentCount = 10
        let screenWidth: CGFloat = 375
        let deviceType = DeviceType.phone
        let interactionStyle = InteractionStyle.interactive
        let contentDensity = ContentDensity.balanced
        
        // When
        let strategy = selectCardExpansionStrategy_L3(
            contentCount: contentCount,
            screenWidth: screenWidth,
            deviceType: deviceType,
            interactionStyle: interactionStyle,
            contentDensity: contentDensity
        )
        
        // Then
        XCTAssertNotNil(strategy, "selectCardExpansionStrategy_L3 should return a strategy")
        XCTAssertFalse(strategy.supportedStrategies.isEmpty, "Should support expansion strategies")
        XCTAssertNotEqual(strategy.primaryStrategy, ExpansionStrategy.none, "Primary strategy should not be none")
        XCTAssertGreaterThan(strategy.expansionScale, 0, "Should have positive expansion scale")
        XCTAssertGreaterThanOrEqual(strategy.animationDuration, 0, "Should have non-negative animation duration")
    }
    
    func testSelectCardExpansionStrategy_L3_WithHoverInteraction() {
        // Given
        let contentCount = 10
        let screenWidth: CGFloat = 1024
        let deviceType = DeviceType.mac
        let interactionStyle = InteractionStyle.expandable
        let contentDensity = ContentDensity.spacious
        
        // When
        let strategy = selectCardExpansionStrategy_L3(
            contentCount: contentCount,
            screenWidth: screenWidth,
            deviceType: deviceType,
            interactionStyle: interactionStyle,
            contentDensity: contentDensity
        )
        
        // Then
        XCTAssertNotNil(strategy, "selectCardExpansionStrategy_L3 should return a strategy")
        XCTAssertFalse(strategy.supportedStrategies.isEmpty, "Should support expansion strategies")
        XCTAssertNotEqual(strategy.primaryStrategy, ExpansionStrategy.none, "Primary strategy should not be none")
        XCTAssertGreaterThan(strategy.expansionScale, 0, "Should have positive expansion scale")
        XCTAssertGreaterThanOrEqual(strategy.animationDuration, 0, "Should have non-negative animation duration")
    }
    
    func testSelectCardExpansionStrategy_L3_WithDifferentDeviceTypes() {
        let contentCount = 10
        let screenWidth: CGFloat = 375
        let interactionStyle = InteractionStyle.interactive
        let contentDensity = ContentDensity.balanced
        
        // Test phone
        let phoneStrategy = selectCardExpansionStrategy_L3(
            contentCount: contentCount,
            screenWidth: screenWidth,
            deviceType: .phone,
            interactionStyle: interactionStyle,
            contentDensity: contentDensity
        )
        XCTAssertNotNil(phoneStrategy, "Phone device type should return a strategy")
        
        // Test pad
        let padStrategy = selectCardExpansionStrategy_L3(
            contentCount: contentCount,
            screenWidth: 768,
            deviceType: .pad,
            interactionStyle: interactionStyle,
            contentDensity: contentDensity
        )
        XCTAssertNotNil(padStrategy, "Pad device type should return a strategy")
        
        // Test mac
        let macStrategy = selectCardExpansionStrategy_L3(
            contentCount: contentCount,
            screenWidth: 1024,
            deviceType: .mac,
            interactionStyle: interactionStyle,
            contentDensity: contentDensity
        )
        XCTAssertNotNil(macStrategy, "Mac device type should return a strategy")
    }
    
    func testSelectCardExpansionStrategy_L3_WithDifferentContentDensities() {
        let contentCount = 10
        let screenWidth: CGFloat = 375
        let deviceType = DeviceType.phone
        let interactionStyle = InteractionStyle.interactive
        
        // Test dense density
        let denseDensityStrategy = selectCardExpansionStrategy_L3(
            contentCount: contentCount,
            screenWidth: screenWidth,
            deviceType: deviceType,
            interactionStyle: interactionStyle,
            contentDensity: .dense
        )
        XCTAssertNotNil(denseDensityStrategy, "Dense density should return a strategy")
        
        // Test balanced density
        let balancedDensityStrategy = selectCardExpansionStrategy_L3(
            contentCount: contentCount,
            screenWidth: screenWidth,
            deviceType: deviceType,
            interactionStyle: interactionStyle,
            contentDensity: .balanced
        )
        XCTAssertNotNil(balancedDensityStrategy, "Balanced density should return a strategy")
        
        // Test spacious density
        let spaciousDensityStrategy = selectCardExpansionStrategy_L3(
            contentCount: contentCount,
            screenWidth: screenWidth,
            deviceType: deviceType,
            interactionStyle: interactionStyle,
            contentDensity: .spacious
        )
        XCTAssertNotNil(spaciousDensityStrategy, "Spacious density should return a strategy")
    }
    
    // MARK: - Photo Strategy Tests
    
    func testSelectPhotoCaptureStrategy_L3_WithVehiclePhoto() {
        // Given
        let purpose = PhotoPurpose.vehiclePhoto
        let context = samplePhotoContext
        
        // When
        let strategy = selectPhotoCaptureStrategy_L3(
            purpose: purpose,
            context: context
        )
        
        // Then
        XCTAssertNotNil(strategy, "selectPhotoCaptureStrategy_L3 should return a strategy")
        XCTAssertTrue([.camera, .photoLibrary, .both].contains(strategy), "Should return a valid capture strategy")
    }
    
    func testSelectPhotoCaptureStrategy_L3_WithFuelReceipt() {
        // Given
        let purpose = PhotoPurpose.fuelReceipt
        let context = samplePhotoContext
        
        // When
        let strategy = selectPhotoCaptureStrategy_L3(
            purpose: purpose,
            context: context
        )
        
        // Then
        XCTAssertNotNil(strategy, "selectPhotoCaptureStrategy_L3 should return a strategy")
        XCTAssertTrue([.camera, .photoLibrary, .both].contains(strategy), "Should return a valid capture strategy")
    }
    
    func testSelectPhotoCaptureStrategy_L3_WithPumpDisplay() {
        // Given
        let purpose = PhotoPurpose.pumpDisplay
        let context = samplePhotoContext
        
        // When
        let strategy = selectPhotoCaptureStrategy_L3(
            purpose: purpose,
            context: context
        )
        
        // Then
        XCTAssertNotNil(strategy, "selectPhotoCaptureStrategy_L3 should return a strategy")
        XCTAssertTrue([.camera, .photoLibrary, .both].contains(strategy), "Should return a valid capture strategy")
    }
    
    func testSelectPhotoCaptureStrategy_L3_WithOdometer() {
        // Given
        let purpose = PhotoPurpose.odometer
        let context = samplePhotoContext
        
        // When
        let strategy = selectPhotoCaptureStrategy_L3(
            purpose: purpose,
            context: context
        )
        
        // Then
        XCTAssertNotNil(strategy, "selectPhotoCaptureStrategy_L3 should return a strategy")
        XCTAssertTrue([.camera, .photoLibrary, .both].contains(strategy), "Should return a valid capture strategy")
    }
    
    func testSelectPhotoCaptureStrategy_L3_WithMaintenance() {
        // Given
        let purpose = PhotoPurpose.maintenance
        let context = samplePhotoContext
        
        // When
        let strategy = selectPhotoCaptureStrategy_L3(
            purpose: purpose,
            context: context
        )
        
        // Then
        XCTAssertNotNil(strategy, "selectPhotoCaptureStrategy_L3 should return a strategy")
        XCTAssertTrue([.camera, .photoLibrary, .both].contains(strategy), "Should return a valid capture strategy")
    }
    
    func testSelectPhotoCaptureStrategy_L3_WithExpense() {
        // Given
        let purpose = PhotoPurpose.expense
        let context = samplePhotoContext
        
        // When
        let strategy = selectPhotoCaptureStrategy_L3(
            purpose: purpose,
            context: context
        )
        
        // Then
        XCTAssertNotNil(strategy, "selectPhotoCaptureStrategy_L3 should return a strategy")
        XCTAssertTrue([.camera, .photoLibrary, .both].contains(strategy), "Should return a valid capture strategy")
    }
    
    func testSelectPhotoCaptureStrategy_L3_WithProfile() {
        // Given
        let purpose = PhotoPurpose.profile
        let context = samplePhotoContext
        
        // When
        let strategy = selectPhotoCaptureStrategy_L3(
            purpose: purpose,
            context: context
        )
        
        // Then
        XCTAssertNotNil(strategy, "selectPhotoCaptureStrategy_L3 should return a strategy")
        XCTAssertTrue([.camera, .photoLibrary, .both].contains(strategy), "Should return a valid capture strategy")
    }
    
    func testSelectPhotoCaptureStrategy_L3_WithDocument() {
        // Given
        let purpose = PhotoPurpose.document
        let context = samplePhotoContext
        
        // When
        let strategy = selectPhotoCaptureStrategy_L3(
            purpose: purpose,
            context: context
        )
        
        // Then
        XCTAssertNotNil(strategy, "selectPhotoCaptureStrategy_L3 should return a strategy")
        XCTAssertTrue([.camera, .photoLibrary, .both].contains(strategy), "Should return a valid capture strategy")
    }
    
    func testSelectPhotoDisplayStrategy_L3_WithVehiclePhoto() {
        // Given
        let purpose = PhotoPurpose.vehiclePhoto
        let context = samplePhotoContext
        
        // When
        let strategy = selectPhotoDisplayStrategy_L3(
            purpose: purpose,
            context: context
        )
        
        // Then
        XCTAssertNotNil(strategy, "selectPhotoDisplayStrategy_L3 should return a strategy")
        XCTAssertTrue([.thumbnail, .fullSize, .aspectFit, .aspectFill, .rounded].contains(strategy), "Should return a valid display strategy")
    }
    
    func testSelectPhotoDisplayStrategy_L3_WithFuelReceipt() {
        // Given
        let purpose = PhotoPurpose.fuelReceipt
        let context = samplePhotoContext
        
        // When
        let strategy = selectPhotoDisplayStrategy_L3(
            purpose: purpose,
            context: context
        )
        
        // Then
        XCTAssertNotNil(strategy, "selectPhotoDisplayStrategy_L3 should return a strategy")
        XCTAssertTrue([.thumbnail, .fullSize, .aspectFit, .aspectFill, .rounded].contains(strategy), "Should return a valid display strategy")
    }
    
    func testSelectPhotoDisplayStrategy_L3_WithPumpDisplay() {
        // Given
        let purpose = PhotoPurpose.pumpDisplay
        let context = samplePhotoContext
        
        // When
        let strategy = selectPhotoDisplayStrategy_L3(
            purpose: purpose,
            context: context
        )
        
        // Then
        XCTAssertNotNil(strategy, "selectPhotoDisplayStrategy_L3 should return a strategy")
        XCTAssertTrue([.thumbnail, .fullSize, .aspectFit, .aspectFill, .rounded].contains(strategy), "Should return a valid display strategy")
    }
    
    func testSelectPhotoDisplayStrategy_L3_WithOdometer() {
        // Given
        let purpose = PhotoPurpose.odometer
        let context = samplePhotoContext
        
        // When
        let strategy = selectPhotoDisplayStrategy_L3(
            purpose: purpose,
            context: context
        )
        
        // Then
        XCTAssertNotNil(strategy, "selectPhotoDisplayStrategy_L3 should return a strategy")
        XCTAssertTrue([.thumbnail, .fullSize, .aspectFit, .aspectFill, .rounded].contains(strategy), "Should return a valid display strategy")
    }
    
    func testSelectPhotoDisplayStrategy_L3_WithMaintenance() {
        // Given
        let purpose = PhotoPurpose.maintenance
        let context = samplePhotoContext
        
        // When
        let strategy = selectPhotoDisplayStrategy_L3(
            purpose: purpose,
            context: context
        )
        
        // Then
        XCTAssertNotNil(strategy, "selectPhotoDisplayStrategy_L3 should return a strategy")
        XCTAssertTrue([.thumbnail, .fullSize, .aspectFit, .aspectFill, .rounded].contains(strategy), "Should return a valid display strategy")
    }
    
    func testSelectPhotoDisplayStrategy_L3_WithExpense() {
        // Given
        let purpose = PhotoPurpose.expense
        let context = samplePhotoContext
        
        // When
        let strategy = selectPhotoDisplayStrategy_L3(
            purpose: purpose,
            context: context
        )
        
        // Then
        XCTAssertNotNil(strategy, "selectPhotoDisplayStrategy_L3 should return a strategy")
        XCTAssertTrue([.thumbnail, .fullSize, .aspectFit, .aspectFill, .rounded].contains(strategy), "Should return a valid display strategy")
    }
    
    func testSelectPhotoDisplayStrategy_L3_WithProfile() {
        // Given
        let purpose = PhotoPurpose.profile
        let context = samplePhotoContext
        
        // When
        let strategy = selectPhotoDisplayStrategy_L3(
            purpose: purpose,
            context: context
        )
        
        // Then
        XCTAssertNotNil(strategy, "selectPhotoDisplayStrategy_L3 should return a strategy")
        XCTAssertTrue([.thumbnail, .fullSize, .aspectFit, .aspectFill, .rounded].contains(strategy), "Should return a valid display strategy")
    }
    
    func testSelectPhotoDisplayStrategy_L3_WithDocument() {
        // Given
        let purpose = PhotoPurpose.document
        let context = samplePhotoContext
        
        // When
        let strategy = selectPhotoDisplayStrategy_L3(
            purpose: purpose,
            context: context
        )
        
        // Then
        XCTAssertNotNil(strategy, "selectPhotoDisplayStrategy_L3 should return a strategy")
        XCTAssertTrue([.thumbnail, .fullSize, .aspectFit, .aspectFill, .rounded].contains(strategy), "Should return a valid display strategy")
    }
    
    // MARK: - Performance Tests
    
    func testSelectCardLayoutStrategy_L3_Performance() {
        // Given
        let contentCount = 50
        let screenWidth: CGFloat = 1024
        let deviceType = DeviceType.pad
        let complexity = ContentComplexity.complex
        
        // When & Then
        measure {
            let strategy = selectCardLayoutStrategy_L3(
                contentCount: contentCount,
                screenWidth: screenWidth,
                deviceType: deviceType,
                contentComplexity: complexity
            )
            XCTAssertNotNil(strategy)
        }
    }
    
    func testPlatformOCRStrategy_L3_Performance() {
        // Given
        let textTypes = [TextType.general, TextType.price, TextType.date]
        let platform = SixLayerPlatform.iOS
        
        // When & Then
        measure {
            let strategy = platformOCRStrategy_L3(
                textTypes: textTypes,
                platform: platform
            )
            XCTAssertNotNil(strategy)
        }
    }
    
    func testSelectCardExpansionStrategy_L3_Performance() {
        // Given
        let contentCount = 50
        let screenWidth: CGFloat = 1024
        let deviceType = DeviceType.pad
        let interactionStyle = InteractionStyle.interactive
        let contentDensity = ContentDensity.spacious
        
        // When & Then
        measure {
            let strategy = selectCardExpansionStrategy_L3(
                contentCount: contentCount,
                screenWidth: screenWidth,
                deviceType: deviceType,
                interactionStyle: interactionStyle,
                contentDensity: contentDensity
            )
            XCTAssertNotNil(strategy)
        }
    }
}
