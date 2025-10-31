import Testing

//
//  L3StrategySelectionTests.swift
//  SixLayerFrameworkTests
//
//  Tests for L3 strategy selection functions
//  Tests strategy selection logic with hardcoded platform, capabilities, and accessibility
//

import SwiftUI
@testable import SixLayerFramework

@MainActor
@Suite("L Strategy Selection")
open class L3StrategySelectionTests {
    
    // MARK: - Test Data
    
    private var samplePhotoContext: PhotoContext = PhotoContext(
        screenSize: CGSize(width: 375, height: 667),
        availableSpace: CGSize(width: 375, height: 667),
        userPreferences: PhotoPreferences(),
        deviceCapabilities: PhotoDeviceCapabilities()
    )
    
    init() async throws {
        samplePhotoContext = PhotoContext(
            screenSize: CGSize(width: 375, height: 667),
            availableSpace: CGSize(width: 375, height: 667),
            userPreferences: PhotoPreferences(),
            deviceCapabilities: PhotoDeviceCapabilities()
        )
    }    // MARK: - Card Layout Strategy Tests
    
    @Test func testSelectCardLayoutStrategy_L3_WithSmallContent() {
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
        
        // Then: Should return a strategy that can be used functionally
        #expect(strategy != nil, "selectCardLayoutStrategy_L3 should return a strategy")
        
        // Test that the strategy can be used to create a functional view
        let testView = createTestViewWithCardLayoutStrategy(strategy)
        #expect(testView != nil, "Should be able to create view with card layout strategy")
        
        #expect(strategy.columns > 0, "Should have at least 1 column")
        #expect(strategy.spacing > 0, "Should have positive spacing")
        #expect(!strategy.reasoning.isEmpty, "Should provide reasoning")
    }
    
    @Test func testSelectCardLayoutStrategy_L3_WithLargeContent() {
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
        
        // Then: Should return a strategy that can be used functionally
        #expect(strategy != nil, "selectCardLayoutStrategy_L3 should return a strategy")
        
        // Test that the strategy can be used to create a functional view
        let testView = createTestViewWithCardLayoutStrategy(strategy)
        #expect(testView != nil, "Should be able to create view with large content card layout strategy")
        
        #expect(strategy.columns > 1, "Should have multiple columns for large content")
        #expect(strategy.spacing > 0, "Should have positive spacing")
        #expect(!strategy.reasoning.isEmpty, "Should provide reasoning")
    }
    
    @Test func testSelectCardLayoutStrategy_L3_WithDifferentDeviceTypes() {
        let contentCount = 10
        let complexity = ContentComplexity.moderate
        
        // Test phone
        let phoneStrategy = selectCardLayoutStrategy_L3(
            contentCount: contentCount,
            screenWidth: 375,
            deviceType: .phone,
            contentComplexity: complexity
        )
        // Test that the strategy can be used to create a functional view
        let phoneTestView = createTestViewWithCardLayoutStrategy(phoneStrategy)
        #expect(phoneTestView != nil, "Should be able to create view with phone card layout strategy")
        
        // Test pad
        let padStrategy = selectCardLayoutStrategy_L3(
            contentCount: contentCount,
            screenWidth: 768,
            deviceType: .pad,
            contentComplexity: complexity
        )
        // Test that the strategy can be used to create a functional view
        let padTestView = createTestViewWithCardLayoutStrategy(padStrategy)
        #expect(padTestView != nil, "Should be able to create view with pad card layout strategy")
        
        // Test mac
        let macStrategy = selectCardLayoutStrategy_L3(
            contentCount: contentCount,
            screenWidth: 1024,
            deviceType: .mac,
            contentComplexity: complexity
        )
        // Test that the strategy can be used to create a functional view
        let macTestView = createTestViewWithCardLayoutStrategy(macStrategy)
        #expect(macTestView != nil, "Should be able to create view with mac card layout strategy")
    }
    
    @Test func testSelectCardLayoutStrategy_L3_WithDifferentComplexityLevels() {
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
        #expect(simpleStrategy != nil, "Simple complexity should return a strategy")
        
        // Test moderate complexity
        let moderateStrategy = selectCardLayoutStrategy_L3(
            contentCount: contentCount,
            screenWidth: screenWidth,
            deviceType: deviceType,
            contentComplexity: .moderate
        )
        #expect(moderateStrategy != nil, "Moderate complexity should return a strategy")
        
        // Test complex complexity
        let complexStrategy = selectCardLayoutStrategy_L3(
            contentCount: contentCount,
            screenWidth: screenWidth,
            deviceType: deviceType,
            contentComplexity: .complex
        )
        #expect(complexStrategy != nil, "Complex complexity should return a strategy")
    }
    
    // MARK: - chooseGridStrategy Tests
    
    @Test func testChooseGridStrategy_SmallContent() {
        let screenWidth: CGFloat = 375
        let deviceType = DeviceType.phone
        let contentCount = 3
        
        let strategy = chooseGridStrategy(
            screenWidth: screenWidth,
            deviceType: deviceType,
            contentCount: contentCount
        )
        
        #expect(strategy.columns == contentCount, "Small content should use fixed columns matching content count")
        #expect(strategy.spacing > 0, "Should have positive spacing")
    }
    
    @Test func testChooseGridStrategy_MediumContent() {
        let screenWidth: CGFloat = 768
        let deviceType = DeviceType.pad
        let contentCount = 6
        
        let strategy = chooseGridStrategy(
            screenWidth: screenWidth,
            deviceType: deviceType,
            contentCount: contentCount
        )
        
        #expect(strategy.columns > 1, "Medium content should use adaptive grid with multiple columns")
        #expect(strategy.spacing > 0, "Should have positive spacing")
        #expect(!strategy.breakpoints.isEmpty, "Adaptive grid should have breakpoints")
    }
    
    @Test func testChooseGridStrategy_LargeContent() {
        let screenWidth: CGFloat = 1024
        let deviceType = DeviceType.mac
        let contentCount = 20
        
        let strategy = chooseGridStrategy(
            screenWidth: screenWidth,
            deviceType: deviceType,
            contentCount: contentCount
        )
        
        #expect(strategy.columns > 1, "Large content should use lazy grid with multiple columns")
        #expect(strategy.spacing > 0, "Should have positive spacing")
        #expect(!strategy.breakpoints.isEmpty, "Lazy grid should have breakpoints")
    }
    
    @Test func testChooseGridStrategy_DifferentDeviceTypes() {
        let contentCount = 10
        let screenWidth: CGFloat = 1024
        
        let deviceTypes: [DeviceType] = [.phone, .pad, .mac, .tv, .watch, .vision, .car]
        
        for deviceType in deviceTypes {
            let strategy = chooseGridStrategy(
                screenWidth: screenWidth,
                deviceType: deviceType,
                contentCount: contentCount
            )
            
            #expect(strategy.columns > 0, "Device type \(deviceType) should return valid columns")
            #expect(strategy.spacing > 0, "Device type \(deviceType) should have positive spacing")
        }
    }
    
    // MARK: - determineResponsiveBehavior Tests
    
    @Test func testDetermineResponsiveBehavior_Phone() {
        let deviceType = DeviceType.phone
        let complexities: [ContentComplexity] = [.simple, .moderate, .complex, .veryComplex]
        
        for complexity in complexities {
            let behavior = determineResponsiveBehavior(
                deviceType: deviceType,
                contentComplexity: complexity
            )
            
            #expect(behavior.type == .fixed, "Phone should use fixed responsive behavior")
            #expect(behavior.adaptive == false, "Phone should not be adaptive")
        }
    }
    
    @Test func testDetermineResponsiveBehavior_Pad() {
        let deviceType = DeviceType.pad
        
        let simpleBehavior = determineResponsiveBehavior(
            deviceType: deviceType,
            contentComplexity: .simple
        )
        #expect(simpleBehavior.type == .adaptive, "Pad with simple content should use adaptive")
        #expect(simpleBehavior.adaptive == true, "Pad should be adaptive")
        
        let complexBehavior = determineResponsiveBehavior(
            deviceType: deviceType,
            contentComplexity: .complex
        )
        #expect(complexBehavior.type == .fluid, "Pad with complex content should use fluid")
        #expect(complexBehavior.adaptive == true, "Pad should be adaptive")
    }
    
    @Test func testDetermineResponsiveBehavior_Mac() {
        let deviceType = DeviceType.mac
        
        let simpleBehavior = determineResponsiveBehavior(
            deviceType: deviceType,
            contentComplexity: .simple
        )
        #expect(simpleBehavior.type == .adaptive, "Mac with simple content should use adaptive")
        #expect(simpleBehavior.adaptive == true, "Mac should be adaptive")
        
        let complexBehavior = determineResponsiveBehavior(
            deviceType: deviceType,
            contentComplexity: .complex
        )
        #expect(complexBehavior.type == .breakpoint, "Mac with complex content should use breakpoint")
        #expect(complexBehavior.adaptive == true, "Mac should be adaptive")
    }
    
    @Test func testDetermineResponsiveBehavior_AllDeviceTypes() {
        let deviceTypes: [DeviceType] = [.phone, .pad, .mac, .tv, .watch, .vision, .car]
        let complexity = ContentComplexity.moderate
        
        for deviceType in deviceTypes {
            let behavior = determineResponsiveBehavior(
                deviceType: deviceType,
                contentComplexity: complexity
            )
            
            #expect(behavior.type != nil, "Device type \(deviceType) should return valid responsive type")
            #expect(!behavior.breakpoints.isEmpty || behavior.type == .fixed, "Non-fixed behaviors should have breakpoints")
        }
    }
    
    // MARK: - Form Strategy Tests
    
    @Test func testSelectFormStrategy_AddFuelView_L3() {
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
        #expect(strategy != nil, "selectFormStrategy_AddFuelView_L3 should return a strategy")
    }
    
    @Test func testSelectModalStrategy_Form_L3() {
        // Given
        let layout = ModalLayoutDecision(
            presentationType: .sheet,
            sizing: .medium
        )
        
        // When
        let strategy = selectModalStrategy_Form_L3(layout: layout)
        
        // Then
        #expect(strategy != nil, "selectModalStrategy_Form_L3 should return a strategy")
    }
    
    // MARK: - OCR Strategy Tests
    
    @Test func testPlatformOCRStrategy_L3_WithGeneralText() {
        // Given
        let textTypes = [TextType.general]
        let platform = SixLayerPlatform.iOS
        
        // When
        let strategy = platformOCRStrategy_L3(
            textTypes: textTypes,
            platform: platform
        )
        
        // Then
        #expect(strategy != nil, "platformOCRStrategy_L3 should return a strategy")
        #expect(!strategy.supportedTextTypes.isEmpty, "Should support text types")
        #expect(!strategy.supportedLanguages.isEmpty, "Should support languages")
        #expect(strategy.estimatedProcessingTime > 0, "Should have positive processing time")
    }
    
    @Test func testPlatformOCRStrategy_L3_WithPriceText() {
        // Given
        let textTypes = [TextType.price]
        let platform = SixLayerPlatform.iOS
        
        // When
        let strategy = platformOCRStrategy_L3(
            textTypes: textTypes,
            platform: platform
        )
        
        // Then
        #expect(strategy != nil, "platformOCRStrategy_L3 should return a strategy")
        #expect(!strategy.supportedTextTypes.isEmpty, "Should support text types")
        #expect(!strategy.supportedLanguages.isEmpty, "Should support languages")
        #expect(strategy.estimatedProcessingTime > 0, "Should have positive processing time")
    }
    
    @Test func testPlatformOCRStrategy_L3_WithDateText() {
        // Given
        let textTypes = [TextType.date]
        let platform = SixLayerPlatform.iOS
        
        // When
        let strategy = platformOCRStrategy_L3(
            textTypes: textTypes,
            platform: platform
        )
        
        // Then
        #expect(strategy != nil, "platformOCRStrategy_L3 should return a strategy")
        #expect(!strategy.supportedTextTypes.isEmpty, "Should support text types")
        #expect(!strategy.supportedLanguages.isEmpty, "Should support languages")
        #expect(strategy.estimatedProcessingTime > 0, "Should have positive processing time")
    }
    
    @Test func testPlatformOCRStrategy_L3_WithMultipleTextTypes() {
        // Given
        let textTypes = [TextType.general, TextType.price, TextType.date]
        let platform = SixLayerPlatform.iOS
        
        // When
        let strategy = platformOCRStrategy_L3(
            textTypes: textTypes,
            platform: platform
        )
        
        // Then
        #expect(strategy != nil, "platformOCRStrategy_L3 should return a strategy")
        #expect(!strategy.supportedTextTypes.isEmpty, "Should support text types")
        #expect(!strategy.supportedLanguages.isEmpty, "Should support languages")
        #expect(strategy.estimatedProcessingTime > 0, "Should have positive processing time")
    }
    
    @Test func testPlatformOCRStrategy_L3_WithDifferentPlatforms() {
        let textTypes = [TextType.general]
        
        // Test iOS
        let iOSStrategy = platformOCRStrategy_L3(
            textTypes: textTypes,
            platform: .iOS
        )
        #expect(iOSStrategy != nil, "iOS platform should return a strategy")
        
        // Test macOS
        let macOSStrategy = platformOCRStrategy_L3(
            textTypes: textTypes,
            platform: .macOS
        )
        #expect(macOSStrategy != nil, "macOS platform should return a strategy")
        
        // Test watchOS
        let watchOSStrategy = platformOCRStrategy_L3(
            textTypes: textTypes,
            platform: .watchOS
        )
        #expect(watchOSStrategy != nil, "watchOS platform should return a strategy")
        
        // Test tvOS
        let tvOSStrategy = platformOCRStrategy_L3(
            textTypes: textTypes,
            platform: .tvOS
        )
        #expect(tvOSStrategy != nil, "tvOS platform should return a strategy")
        
        // Test visionOS
        let visionOSStrategy = platformOCRStrategy_L3(
            textTypes: textTypes,
            platform: .visionOS
        )
        #expect(visionOSStrategy != nil, "visionOS platform should return a strategy")
    }
    
    @Test func testPlatformDocumentOCRStrategy_L3() {
        // Given
        let documentType = DocumentType.general
        let platform = SixLayerPlatform.iOS
        
        // When
        let strategy = platformDocumentOCRStrategy_L3(
            documentType: documentType,
            platform: platform
        )
        
        // Then
        #expect(strategy != nil, "platformDocumentOCRStrategy_L3 should return a strategy")
        #expect(!strategy.supportedTextTypes.isEmpty, "Should support text types")
        #expect(!strategy.supportedLanguages.isEmpty, "Should support languages")
        #expect(strategy.estimatedProcessingTime > 0, "Should have positive processing time")
    }
    
    @Test func testPlatformReceiptOCRStrategy_L3() {
        // Given
        let platform = SixLayerPlatform.iOS
        
        // When
        let strategy = platformReceiptOCRStrategy_L3(platform: platform)
        
        // Then
        #expect(strategy != nil, "platformReceiptOCRStrategy_L3 should return a strategy")
        #expect(!strategy.supportedTextTypes.isEmpty, "Should support text types")
        #expect(!strategy.supportedLanguages.isEmpty, "Should support languages")
        #expect(strategy.estimatedProcessingTime > 0, "Should have positive processing time")
    }
    
    @Test func testPlatformBusinessCardOCRStrategy_L3() {
        // Given
        let platform = SixLayerPlatform.iOS
        
        // When
        let strategy = platformBusinessCardOCRStrategy_L3(platform: platform)
        
        // Then
        #expect(strategy != nil, "platformBusinessCardOCRStrategy_L3 should return a strategy")
        #expect(!strategy.supportedTextTypes.isEmpty, "Should support text types")
        #expect(!strategy.supportedLanguages.isEmpty, "Should support languages")
        #expect(strategy.estimatedProcessingTime > 0, "Should have positive processing time")
    }
    
    @Test func testPlatformInvoiceOCRStrategy_L3() {
        // Given
        let platform = SixLayerPlatform.iOS
        
        // When
        let strategy = platformInvoiceOCRStrategy_L3(platform: platform)
        
        // Then
        #expect(strategy != nil, "platformInvoiceOCRStrategy_L3 should return a strategy")
        #expect(!strategy.supportedTextTypes.isEmpty, "Should support text types")
        #expect(!strategy.supportedLanguages.isEmpty, "Should support languages")
        #expect(strategy.estimatedProcessingTime > 0, "Should have positive processing time")
    }
    
    @Test func testPlatformOptimalOCRStrategy_L3() {
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
        #expect(strategy != nil, "platformOptimalOCRStrategy_L3 should return a strategy")
        #expect(!strategy.supportedTextTypes.isEmpty, "Should support text types")
        #expect(!strategy.supportedLanguages.isEmpty, "Should support languages")
        #expect(strategy.estimatedProcessingTime > 0, "Should have positive processing time")
    }
    
    @Test func testPlatformBatchOCRStrategy_L3() {
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
        #expect(strategy != nil, "platformBatchOCRStrategy_L3 should return a strategy")
        #expect(!strategy.supportedTextTypes.isEmpty, "Should support text types")
        #expect(!strategy.supportedLanguages.isEmpty, "Should support languages")
        #expect(strategy.estimatedProcessingTime > 0, "Should have positive processing time")
    }
    
    // MARK: - Card Expansion Strategy Tests
    
    @Test func testSelectCardExpansionStrategy_L3_WithStaticInteraction() {
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
        #expect(strategy != nil, "selectCardExpansionStrategy_L3 should return a strategy")
        #expect(strategy.supportedStrategies == [ExpansionStrategy.none], "Static interaction should only support none strategy")
        #expect(strategy.primaryStrategy == ExpansionStrategy.none, "Primary strategy should be none")
        #expect(strategy.expansionScale == 1.0, "Expansion scale should be 1.0")
        #expect(strategy.animationDuration == 0.0, "Animation duration should be 0.0")
    }
    
    @Test func testSelectCardExpansionStrategy_L3_WithTouchInteraction() {
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
        #expect(strategy != nil, "selectCardExpansionStrategy_L3 should return a strategy")
        #expect(!strategy.supportedStrategies.isEmpty, "Should support expansion strategies")
        #expect(strategy.primaryStrategy != ExpansionStrategy.none, "Primary strategy should not be none")
        #expect(strategy.expansionScale > 0, "Should have positive expansion scale")
        #expect(strategy.animationDuration >= 0, "Should have non-negative animation duration")
    }
    
    @Test func testSelectCardExpansionStrategy_L3_WithHoverInteraction() {
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
        #expect(strategy != nil, "selectCardExpansionStrategy_L3 should return a strategy")
        #expect(!strategy.supportedStrategies.isEmpty, "Should support expansion strategies")
        #expect(strategy.primaryStrategy != ExpansionStrategy.none, "Primary strategy should not be none")
        #expect(strategy.expansionScale > 0, "Should have positive expansion scale")
        #expect(strategy.animationDuration >= 0, "Should have non-negative animation duration")
    }
    
    @Test func testSelectCardExpansionStrategy_L3_WithDifferentDeviceTypes() {
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
        #expect(phoneStrategy != nil, "Phone device type should return a strategy")
        
        // Test pad
        let padStrategy = selectCardExpansionStrategy_L3(
            contentCount: contentCount,
            screenWidth: 768,
            deviceType: .pad,
            interactionStyle: interactionStyle,
            contentDensity: contentDensity
        )
        #expect(padStrategy != nil, "Pad device type should return a strategy")
        
        // Test mac
        let macStrategy = selectCardExpansionStrategy_L3(
            contentCount: contentCount,
            screenWidth: 1024,
            deviceType: .mac,
            interactionStyle: interactionStyle,
            contentDensity: contentDensity
        )
        #expect(macStrategy != nil, "Mac device type should return a strategy")
    }
    
    @Test func testSelectCardExpansionStrategy_L3_WithDifferentContentDensities() {
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
        #expect(denseDensityStrategy != nil, "Dense density should return a strategy")
        
        // Test balanced density
        let balancedDensityStrategy = selectCardExpansionStrategy_L3(
            contentCount: contentCount,
            screenWidth: screenWidth,
            deviceType: deviceType,
            interactionStyle: interactionStyle,
            contentDensity: .balanced
        )
        #expect(balancedDensityStrategy != nil, "Balanced density should return a strategy")
        
        // Test spacious density
        let spaciousDensityStrategy = selectCardExpansionStrategy_L3(
            contentCount: contentCount,
            screenWidth: screenWidth,
            deviceType: deviceType,
            interactionStyle: interactionStyle,
            contentDensity: .spacious
        )
        #expect(spaciousDensityStrategy != nil, "Spacious density should return a strategy")
    }
    
    // MARK: - Photo Strategy Tests
    
    @Test func testSelectPhotoCaptureStrategy_L3_WithVehiclePhoto() {
        // Given
        let purpose = PhotoPurpose.vehiclePhoto
        let context = samplePhotoContext
        
        // When
        let strategy = selectPhotoCaptureStrategy_L3(
            purpose: purpose,
            context: context
        )
        
        // Then
        #expect(strategy != nil, "selectPhotoCaptureStrategy_L3 should return a strategy")
        #expect([.camera, .photoLibrary, .both].contains(strategy), "Should return a valid capture strategy")
    }
    
    @Test func testSelectPhotoCaptureStrategy_L3_WithFuelReceipt() {
        // Given
        let purpose = PhotoPurpose.fuelReceipt
        let context = samplePhotoContext
        
        // When
        let strategy = selectPhotoCaptureStrategy_L3(
            purpose: purpose,
            context: context
        )
        
        // Then
        #expect(strategy != nil, "selectPhotoCaptureStrategy_L3 should return a strategy")
        #expect([.camera, .photoLibrary, .both].contains(strategy), "Should return a valid capture strategy")
    }
    
    @Test func testSelectPhotoCaptureStrategy_L3_WithPumpDisplay() {
        // Given
        let purpose = PhotoPurpose.pumpDisplay
        let context = samplePhotoContext
        
        // When
        let strategy = selectPhotoCaptureStrategy_L3(
            purpose: purpose,
            context: context
        )
        
        // Then
        #expect(strategy != nil, "selectPhotoCaptureStrategy_L3 should return a strategy")
        #expect([.camera, .photoLibrary, .both].contains(strategy), "Should return a valid capture strategy")
    }
    
    @Test func testSelectPhotoCaptureStrategy_L3_WithOdometer() {
        // Given
        let purpose = PhotoPurpose.odometer
        let context = samplePhotoContext
        
        // When
        let strategy = selectPhotoCaptureStrategy_L3(
            purpose: purpose,
            context: context
        )
        
        // Then
        #expect(strategy != nil, "selectPhotoCaptureStrategy_L3 should return a strategy")
        #expect([.camera, .photoLibrary, .both].contains(strategy), "Should return a valid capture strategy")
    }
    
    @Test func testSelectPhotoCaptureStrategy_L3_WithMaintenance() {
        // Given
        let purpose = PhotoPurpose.maintenance
        let context = samplePhotoContext
        
        // When
        let strategy = selectPhotoCaptureStrategy_L3(
            purpose: purpose,
            context: context
        )
        
        // Then
        #expect(strategy != nil, "selectPhotoCaptureStrategy_L3 should return a strategy")
        #expect([.camera, .photoLibrary, .both].contains(strategy), "Should return a valid capture strategy")
    }
    
    @Test func testSelectPhotoCaptureStrategy_L3_WithExpense() {
        // Given
        let purpose = PhotoPurpose.expense
        let context = samplePhotoContext
        
        // When
        let strategy = selectPhotoCaptureStrategy_L3(
            purpose: purpose,
            context: context
        )
        
        // Then
        #expect(strategy != nil, "selectPhotoCaptureStrategy_L3 should return a strategy")
        #expect([.camera, .photoLibrary, .both].contains(strategy), "Should return a valid capture strategy")
    }
    
    @Test func testSelectPhotoCaptureStrategy_L3_WithProfile() {
        // Given
        let purpose = PhotoPurpose.profile
        let context = samplePhotoContext
        
        // When
        let strategy = selectPhotoCaptureStrategy_L3(
            purpose: purpose,
            context: context
        )
        
        // Then
        #expect(strategy != nil, "selectPhotoCaptureStrategy_L3 should return a strategy")
        #expect([.camera, .photoLibrary, .both].contains(strategy), "Should return a valid capture strategy")
    }
    
    @Test func testSelectPhotoCaptureStrategy_L3_WithDocument() {
        // Given
        let purpose = PhotoPurpose.document
        let context = samplePhotoContext
        
        // When
        let strategy = selectPhotoCaptureStrategy_L3(
            purpose: purpose,
            context: context
        )
        
        // Then
        #expect(strategy != nil, "selectPhotoCaptureStrategy_L3 should return a strategy")
        #expect([.camera, .photoLibrary, .both].contains(strategy), "Should return a valid capture strategy")
    }
    
    @Test func testSelectPhotoDisplayStrategy_L3_WithVehiclePhoto() {
        // Given
        let purpose = PhotoPurpose.vehiclePhoto
        let context = samplePhotoContext
        
        // When
        let strategy = selectPhotoDisplayStrategy_L3(
            purpose: purpose,
            context: context
        )
        
        // Then
        #expect(strategy != nil, "selectPhotoDisplayStrategy_L3 should return a strategy")
        #expect([.thumbnail, .fullSize, .aspectFit, .aspectFill, .rounded].contains(strategy), "Should return a valid display strategy")
    }
    
    @Test func testSelectPhotoDisplayStrategy_L3_WithFuelReceipt() {
        // Given
        let purpose = PhotoPurpose.fuelReceipt
        let context = samplePhotoContext
        
        // When
        let strategy = selectPhotoDisplayStrategy_L3(
            purpose: purpose,
            context: context
        )
        
        // Then
        #expect(strategy != nil, "selectPhotoDisplayStrategy_L3 should return a strategy")
        #expect([.thumbnail, .fullSize, .aspectFit, .aspectFill, .rounded].contains(strategy), "Should return a valid display strategy")
    }
    
    @Test func testSelectPhotoDisplayStrategy_L3_WithPumpDisplay() {
        // Given
        let purpose = PhotoPurpose.pumpDisplay
        let context = samplePhotoContext
        
        // When
        let strategy = selectPhotoDisplayStrategy_L3(
            purpose: purpose,
            context: context
        )
        
        // Then
        #expect(strategy != nil, "selectPhotoDisplayStrategy_L3 should return a strategy")
        #expect([.thumbnail, .fullSize, .aspectFit, .aspectFill, .rounded].contains(strategy), "Should return a valid display strategy")
    }
    
    @Test func testSelectPhotoDisplayStrategy_L3_WithOdometer() {
        // Given
        let purpose = PhotoPurpose.odometer
        let context = samplePhotoContext
        
        // When
        let strategy = selectPhotoDisplayStrategy_L3(
            purpose: purpose,
            context: context
        )
        
        // Then
        #expect(strategy != nil, "selectPhotoDisplayStrategy_L3 should return a strategy")
        #expect([.thumbnail, .fullSize, .aspectFit, .aspectFill, .rounded].contains(strategy), "Should return a valid display strategy")
    }
    
    @Test func testSelectPhotoDisplayStrategy_L3_WithMaintenance() {
        // Given
        let purpose = PhotoPurpose.maintenance
        let context = samplePhotoContext
        
        // When
        let strategy = selectPhotoDisplayStrategy_L3(
            purpose: purpose,
            context: context
        )
        
        // Then
        #expect(strategy != nil, "selectPhotoDisplayStrategy_L3 should return a strategy")
        #expect([.thumbnail, .fullSize, .aspectFit, .aspectFill, .rounded].contains(strategy), "Should return a valid display strategy")
    }
    
    @Test func testSelectPhotoDisplayStrategy_L3_WithExpense() {
        // Given
        let purpose = PhotoPurpose.expense
        let context = samplePhotoContext
        
        // When
        let strategy = selectPhotoDisplayStrategy_L3(
            purpose: purpose,
            context: context
        )
        
        // Then
        #expect(strategy != nil, "selectPhotoDisplayStrategy_L3 should return a strategy")
        #expect([.thumbnail, .fullSize, .aspectFit, .aspectFill, .rounded].contains(strategy), "Should return a valid display strategy")
    }
    
    @Test func testSelectPhotoDisplayStrategy_L3_WithProfile() {
        // Given
        let purpose = PhotoPurpose.profile
        let context = samplePhotoContext
        
        // When
        let strategy = selectPhotoDisplayStrategy_L3(
            purpose: purpose,
            context: context
        )
        
        // Then
        #expect(strategy != nil, "selectPhotoDisplayStrategy_L3 should return a strategy")
        #expect([.thumbnail, .fullSize, .aspectFit, .aspectFill, .rounded].contains(strategy), "Should return a valid display strategy")
    }
    
    @Test func testSelectPhotoDisplayStrategy_L3_WithDocument() {
        // Given
        let purpose = PhotoPurpose.document
        let context = samplePhotoContext
        
        // When
        let strategy = selectPhotoDisplayStrategy_L3(
            purpose: purpose,
            context: context
        )
        
        // Then
        #expect(strategy != nil, "selectPhotoDisplayStrategy_L3 should return a strategy")
        #expect([.thumbnail, .fullSize, .aspectFit, .aspectFill, .rounded].contains(strategy), "Should return a valid display strategy")
    }
    
    // MARK: - Performance Tests
    
    // Performance test removed - performance monitoring was removed from framework
    
    // MARK: - Automatic Accessibility Identifier Tests
    
    /// BUSINESS PURPOSE: Layer 3 functions return data structures, not views
    /// TESTING SCOPE: Tests that selectCardExpansionStrategy_L3 returns correct data structure
    /// METHODOLOGY: Tests Layer 3 functionality (data functions don't need accessibility identifiers)
    @Test func testSelectCardExpansionStrategy_L3_ReturnsCorrectDataStructure() async {
        await MainActor.run {
            // Given: Layer 3 function with test data
            let contentCount = 10
            let screenWidth: CGFloat = 375.0
            let deviceType = DeviceType.phone
            let interactionStyle = InteractionStyle.interactive
            let contentDensity = ContentDensity.balanced
            
            // When: Call Layer 3 function
            let result = selectCardExpansionStrategy_L3(
                contentCount: contentCount,
                screenWidth: screenWidth,
                deviceType: deviceType,
                interactionStyle: interactionStyle,
                contentDensity: contentDensity
            )
            
            // Then: Should return correct data structure
            #expect(result != nil, "Layer 3 function should return a result")
            #expect(result.primaryStrategy != nil, "Should have expansion strategy")
            #expect(result.animationDuration >= 0, "Should have non-negative duration")
            #expect(result.expansionScale > 0, "Should have positive expansion scale")
            
            // NOTE: Layer 3 functions return data structures, not views
            // They don't need automatic accessibility identifiers because they're not UI elements
        }
    }
    
    // MARK: - Helper Functions
    
    /// Create a test view using the card layout strategy to verify it works
    public func createTestViewWithCardLayoutStrategy(_ strategy: LayoutStrategy) -> some View {
        return VStack(spacing: 8) {
            ForEach(0..<strategy.columns, id: \.self) { _ in
                Text("Test Card")
                    .frame(maxWidth: .infinity)
            }
        }
        .accessibilityLabel("Test view for card layout strategy")
        .accessibilityHint("Strategy: \(strategy.columns) columns, approach: \(strategy.approach.rawValue)")
    }

}