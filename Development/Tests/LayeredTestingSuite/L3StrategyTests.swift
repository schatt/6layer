//
//  L3StrategyTests.swift
//  SixLayerFramework
//
//  Layer 3 Testing: Strategy Selection Functions
//  Tests L3 functions that select optimal strategies based on content analysis
//

import XCTest
import SwiftUI
@testable import SixLayerFramework

class L3StrategyTests: XCTestCase {
    
    // MARK: - Test Data
    
    private var sampleTextTypes: [TextType] = []
    private var sampleDocumentType: DocumentType = .receipt
    private var samplePlatform: Platform = .iOS
    private var samplePhotoPurpose: PhotoPurpose = .document
    private var samplePhotoContext: PhotoContext = PhotoContext()
    private var sampleDeviceType: DeviceType = .phone
    private var sampleInteractionStyle: InteractionStyle = .interactive
    private var sampleContentDensity: ContentDensity = .balanced
    
    override func setUp() {
        super.setUp()
        sampleTextTypes = L3TestDataFactory.createSampleTextTypes()
        sampleDocumentType = L3TestDataFactory.createSampleDocumentType()
        samplePlatform = L3TestDataFactory.createSamplePlatform()
        samplePhotoPurpose = L3TestDataFactory.createSamplePhotoPurpose()
        samplePhotoContext = L3TestDataFactory.createSamplePhotoContext()
        sampleDeviceType = L3TestDataFactory.createSampleDeviceType()
        sampleInteractionStyle = L3TestDataFactory.createSampleInteractionStyle()
        sampleContentDensity = L3TestDataFactory.createSampleContentDensity()
    }
    
    override func tearDown() {
        sampleTextTypes = []
        sampleDocumentType = .receipt
        samplePlatform = .iOS
        samplePhotoPurpose = .document
        samplePhotoContext = PhotoContext()
        sampleDeviceType = .phone
        sampleInteractionStyle = .interactive
        sampleContentDensity = .balanced
        super.tearDown()
    }
    
    // MARK: - OCR Strategy Selection Functions
    
    func testPlatformOCRStrategy_L3() {
        // Given
        let textTypes = sampleTextTypes
        let platform = samplePlatform
        
        // When
        let strategy = platformOCRStrategy_L3(
            textTypes: textTypes,
            platform: platform
        )
        
        // Then
        XCTAssertNotNil(strategy, "OCR strategy should be created")
        XCTAssertEqual(strategy.supportedTextTypes, textTypes, "Strategy should support requested text types")
        XCTAssertFalse(strategy.supportedLanguages.isEmpty, "Strategy should support at least one language")
        XCTAssertGreaterThanOrEqual(strategy.estimatedProcessingTime, 0, "Processing time should be non-negative")
    }
    
    func testPlatformOCRStrategy_L3_NeuralEngineRequired() {
        // Given
        let textTypes: [TextType] = [.general, .price, .date, .number, .address, .email, .phone]
        let platform = Platform.iOS
        
        // When
        let strategy = platformOCRStrategy_L3(
            textTypes: textTypes,
            platform: platform
        )
        
        // Then
        XCTAssertNotNil(strategy, "OCR strategy should be created")
        XCTAssertTrue(strategy.requiresNeuralEngine, "Complex text types should require neural engine")
    }
    
    func testPlatformDocumentOCRStrategy_L3() {
        // Given
        let documentType = sampleDocumentType
        let platform = samplePlatform
        
        // When
        let strategy = platformDocumentOCRStrategy_L3(
            documentType: documentType,
            platform: platform
        )
        
        // Then
        XCTAssertNotNil(strategy, "Document OCR strategy should be created")
        XCTAssertFalse(strategy.supportedTextTypes.isEmpty, "Strategy should support text types for document")
        XCTAssertFalse(strategy.supportedLanguages.isEmpty, "Strategy should support at least one language")
        XCTAssertGreaterThanOrEqual(strategy.estimatedProcessingTime, 0, "Processing time should be non-negative")
    }
    
    func testPlatformReceiptOCRStrategy_L3() {
        // Given
        let platform = samplePlatform
        
        // When
        let strategy = platformReceiptOCRStrategy_L3(
            platform: platform
        )
        
        // Then
        XCTAssertNotNil(strategy, "Receipt OCR strategy should be created")
        XCTAssertTrue(strategy.supportedTextTypes.contains(.price), "Receipt strategy should support price text")
        XCTAssertTrue(strategy.supportedTextTypes.contains(.date), "Receipt strategy should support date text")
        XCTAssertTrue(strategy.supportedTextTypes.contains(.number), "Receipt strategy should support number text")
    }
    
    func testPlatformBusinessCardOCRStrategy_L3() {
        // Given
        let platform = samplePlatform
        
        // When
        let strategy = platformBusinessCardOCRStrategy_L3(
            platform: platform
        )
        
        // Then
        XCTAssertNotNil(strategy, "Business card OCR strategy should be created")
        XCTAssertTrue(strategy.supportedTextTypes.contains(.name), "Business card strategy should support name text")
        XCTAssertTrue(strategy.supportedTextTypes.contains(.email), "Business card strategy should support email text")
        XCTAssertTrue(strategy.supportedTextTypes.contains(.phone), "Business card strategy should support phone text")
    }
    
    func testPlatformInvoiceOCRStrategy_L3() {
        // Given
        let platform = samplePlatform
        
        // When
        let strategy = platformInvoiceOCRStrategy_L3(
            platform: platform
        )
        
        // Then
        XCTAssertNotNil(strategy, "Invoice OCR strategy should be created")
        XCTAssertTrue(strategy.supportedTextTypes.contains(.price), "Invoice strategy should support price text")
        XCTAssertTrue(strategy.supportedTextTypes.contains(.date), "Invoice strategy should support date text")
        XCTAssertTrue(strategy.supportedTextTypes.contains(.vendor), "Invoice strategy should support vendor text")
    }
    
    func testPlatformOptimalOCRStrategy_L3() {
        // Given
        let textTypes = sampleTextTypes
        let platform = samplePlatform
        
        // When
        let strategy = platformOptimalOCRStrategy_L3(
            textTypes: textTypes,
            platform: platform
        )
        
        // Then
        XCTAssertNotNil(strategy, "Optimal OCR strategy should be created")
        XCTAssertEqual(strategy.supportedTextTypes, textTypes, "Strategy should support requested text types")
        XCTAssertFalse(strategy.supportedLanguages.isEmpty, "Strategy should support at least one language")
    }
    
    func testPlatformBatchOCRStrategy_L3() {
        // Given
        let textTypes = sampleTextTypes
        let platform = samplePlatform
        
        // When
        let strategy = platformBatchOCRStrategy_L3(
            textTypes: textTypes,
            platform: platform
        )
        
        // Then
        XCTAssertNotNil(strategy, "Batch OCR strategy should be created")
        XCTAssertEqual(strategy.supportedTextTypes, textTypes, "Strategy should support requested text types")
        XCTAssertFalse(strategy.supportedLanguages.isEmpty, "Strategy should support at least one language")
    }
    
    // MARK: - Card Strategy Selection Functions
    
    func testSelectCardExpansionStrategy_L3() {
        // Given
        let contentCount = 10
        let screenWidth: CGFloat = 375.0
        let deviceType = sampleDeviceType
        let interactionStyle = sampleInteractionStyle
        let contentDensity = sampleContentDensity
        
        // When
        let strategy = selectCardExpansionStrategy_L3(
            contentCount: contentCount,
            screenWidth: screenWidth,
            deviceType: deviceType,
            interactionStyle: interactionStyle,
            contentDensity: contentDensity
        )
        
        // Then
        XCTAssertNotNil(strategy, "Card expansion strategy should be created")
        XCTAssertFalse(strategy.supportedStrategies.isEmpty, "Strategy should support at least one expansion method")
        XCTAssertGreaterThan(strategy.expansionScale, 1.0, "Expansion scale should be greater than 1.0")
        XCTAssertGreaterThanOrEqual(strategy.animationDuration, 0, "Animation duration should be non-negative")
    }
    
    func testSelectCardExpansionStrategy_L3_StaticInteraction() {
        // Given
        let contentCount = 10
        let screenWidth: CGFloat = 375.0
        let deviceType = sampleDeviceType
        let interactionStyle = InteractionStyle.static
        let contentDensity = sampleContentDensity
        
        // When
        let strategy = selectCardExpansionStrategy_L3(
            contentCount: contentCount,
            screenWidth: screenWidth,
            deviceType: deviceType,
            interactionStyle: interactionStyle,
            contentDensity: contentDensity
        )
        
        // Then
        XCTAssertNotNil(strategy, "Card expansion strategy should be created")
        XCTAssertEqual(strategy.primaryStrategy, .none, "Static interaction should have no expansion")
        XCTAssertEqual(strategy.expansionScale, 1.0, "Static interaction should have no expansion scale")
        XCTAssertEqual(strategy.animationDuration, 0.0, "Static interaction should have no animation")
    }
    
    func testSelectCardExpansionStrategy_L3_PhoneDevice() {
        // Given
        let contentCount = 6
        let screenWidth: CGFloat = 375.0
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
        XCTAssertNotNil(strategy, "Card expansion strategy should be created")
        XCTAssertTrue(strategy.supportedStrategies.contains(.contentReveal), "Phone should support content reveal")
        XCTAssertTrue(strategy.accessibilitySupport, "Strategy should support accessibility")
    }
    
    func testSelectCardExpansionStrategy_L3_PadDevice() {
        // Given
        let contentCount = 12
        let screenWidth: CGFloat = 768.0
        let deviceType = DeviceType.pad
        let interactionStyle = InteractionStyle.interactive
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
        XCTAssertNotNil(strategy, "Card expansion strategy should be created")
        XCTAssertTrue(strategy.supportedStrategies.contains(.hoverExpand), "iPad should support hover expansion")
        XCTAssertTrue(strategy.hapticFeedback, "iPad should support haptic feedback")
    }
    
    // MARK: - Photo Strategy Selection Functions
    
    func testSelectPhotoCaptureStrategy_L3() {
        // Given
        let purpose = samplePhotoPurpose
        let context = samplePhotoContext
        
        // When
        let strategy = selectPhotoCaptureStrategy_L3(
            purpose: purpose,
            context: context
        )
        
        // Then
        XCTAssertTrue([PhotoCaptureStrategy.camera, .photoLibrary, .both].contains(strategy), "Strategy should be valid")
    }
    
    func testSelectPhotoCaptureStrategy_L3_CameraOnly() {
        // Given
        let purpose = PhotoPurpose.vehiclePhoto
        let context = PhotoContext(
            screenSize: CGSize(width: 375, height: 667),
            availableSpace: CGSize(width: 375, height: 600),
            userPreferences: PhotoPreferences(preferredSource: .camera),
            deviceCapabilities: PhotoDeviceCapabilities(hasCamera: true, hasPhotoLibrary: false)
        )
        
        // When
        let strategy = selectPhotoCaptureStrategy_L3(
            purpose: purpose,
            context: context
        )
        
        // Then
        XCTAssertEqual(strategy, .camera, "Should use camera when only camera is available")
    }
    
    func testSelectPhotoCaptureStrategy_L3_PhotoLibraryOnly() {
        // Given
        let purpose = PhotoPurpose.document
        let context = PhotoContext(
            screenSize: CGSize(width: 375, height: 667),
            availableSpace: CGSize(width: 375, height: 600),
            userPreferences: PhotoPreferences(preferredSource: .photoLibrary),
            deviceCapabilities: PhotoDeviceCapabilities(hasCamera: false, hasPhotoLibrary: true)
        )
        
        // When
        let strategy = selectPhotoCaptureStrategy_L3(
            purpose: purpose,
            context: context
        )
        
        // Then
        XCTAssertEqual(strategy, .photoLibrary, "Should use photo library when only photo library is available")
    }
    
    func testSelectPhotoDisplayStrategy_L3() {
        // Given
        let purpose = samplePhotoPurpose
        let context = samplePhotoContext
        
        // When
        let strategy = selectPhotoDisplayStrategy_L3(
            purpose: purpose,
            context: context
        )
        
        // Then
        XCTAssertTrue([PhotoDisplayStrategy.thumbnail, .fullSize, .aspectFit, .aspectFill, .rounded].contains(strategy), "Strategy should be valid")
    }
    
    func testSelectPhotoDisplayStrategy_L3_VehiclePhoto() {
        // Given
        let purpose = PhotoPurpose.vehiclePhoto
        let context = PhotoContext(
            screenSize: CGSize(width: 375, height: 667),
            availableSpace: CGSize(width: 300, height: 200), // Good space utilization
            userPreferences: PhotoPreferences(),
            deviceCapabilities: PhotoDeviceCapabilities()
        )
        
        // When
        let strategy = selectPhotoDisplayStrategy_L3(
            purpose: purpose,
            context: context
        )
        
        // Then
        XCTAssertEqual(strategy, .aspectFit, "Vehicle photo should use aspect fit for good space utilization")
    }
    
    func testSelectPhotoDisplayStrategy_L3_ReceiptPhoto() {
        // Given
        let purpose = PhotoPurpose.fuelReceipt
        let context = PhotoContext(
            screenSize: CGSize(width: 375, height: 667),
            availableSpace: CGSize(width: 200, height: 300), // Good space utilization
            userPreferences: PhotoPreferences(),
            deviceCapabilities: PhotoDeviceCapabilities()
        )
        
        // When
        let strategy = selectPhotoDisplayStrategy_L3(
            purpose: purpose,
            context: context
        )
        
        // Then
        XCTAssertEqual(strategy, .fullSize, "Receipt photo should use full size for readability")
    }
    
    func testSelectPhotoDisplayStrategy_L3_ProfilePhoto() {
        // Given
        let purpose = PhotoPurpose.profile
        let context = samplePhotoContext
        
        // When
        let strategy = selectPhotoDisplayStrategy_L3(
            purpose: purpose,
            context: context
        )
        
        // Then
        XCTAssertEqual(strategy, .rounded, "Profile photo should use rounded display")
    }
    
    func testSelectPhotoDisplayStrategy_L3_MaintenancePhoto() {
        // Given
        let purpose = PhotoPurpose.maintenance
        let context = samplePhotoContext
        
        // When
        let strategy = selectPhotoDisplayStrategy_L3(
            purpose: purpose,
            context: context
        )
        
        // Then
        XCTAssertEqual(strategy, .thumbnail, "Maintenance photo should use thumbnail display")
    }
    
    // MARK: - Strategy Selection Validation
    
    func testStrategySelectionConsistency() {
        // Given
        let textTypes: [TextType] = [.general, .price, .date]
        let platform = Platform.iOS
        
        // When
        let strategy1 = platformOCRStrategy_L3(
            textTypes: textTypes,
            platform: platform
        )
        
        let strategy2 = platformOCRStrategy_L3(
            textTypes: textTypes,
            platform: platform
        )
        
        // Then
        XCTAssertEqual(strategy1.supportedTextTypes, strategy2.supportedTextTypes, "Strategies should be consistent")
        XCTAssertEqual(strategy1.supportedLanguages, strategy2.supportedLanguages, "Strategies should be consistent")
        XCTAssertEqual(strategy1.processingMode, strategy2.processingMode, "Strategies should be consistent")
    }
    
    func testStrategySelectionPerformance() {
        // Given
        let textTypes: [TextType] = [.general, .price, .date, .number, .address, .email, .phone]
        let platform = Platform.iOS
        
        // When
        let startTime = CFAbsoluteTimeGetCurrent()
        let strategy = platformOCRStrategy_L3(
            textTypes: textTypes,
            platform: platform
        )
        let endTime = CFAbsoluteTimeGetCurrent()
        
        // Then
        XCTAssertNotNil(strategy, "Strategy should be created")
        let executionTime = endTime - startTime
        XCTAssertLessThan(executionTime, 0.1, "Strategy selection should be fast (< 100ms)")
    }
    
    func testStrategySelectionEdgeCases() {
        // Given
        let emptyTextTypes: [TextType] = []
        let platform = Platform.iOS
        
        // When
        let strategy = platformOCRStrategy_L3(
            textTypes: emptyTextTypes,
            platform: platform
        )
        
        // Then
        XCTAssertNotNil(strategy, "Strategy should handle empty text types")
        XCTAssertTrue(strategy.supportedTextTypes.isEmpty, "Empty text types should result in empty supported types")
    }
}





