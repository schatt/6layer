//
//  L2LayoutDecisionTests.swift
//  SixLayerFramework
//
//  Layer 2 Testing: Layout Decision Engine Functions
//  Tests L2 functions that analyze content and make layout decisions
//

import XCTest
import SwiftUI
@testable import SixLayerFramework

class L2LayoutDecisionTests: XCTestCase {
    
    // MARK: - Test Data
    
    private var sampleContent: [GenericDataItem] = []
    private var sampleHints: PresentationHints = PresentationHints()
    private var sampleOCRContext: OCRContext = OCRContext()
    private var samplePhotoContext: PhotoContext = PhotoContext()
    private var sampleContentComplexity: ContentComplexity = .moderate
    private var sampleDeviceType: DeviceType = .phone
    
    override func setUp() {
        super.setUp()
        sampleContent = L2TestDataFactory.createSampleContent()
        sampleHints = L2TestDataFactory.createSampleHints()
        sampleOCRContext = L2TestDataFactory.createSampleOCRContext()
        samplePhotoContext = L2TestDataFactory.createSamplePhotoContext()
        sampleContentComplexity = L2TestDataFactory.createSampleContentComplexity()
        sampleDeviceType = L2TestDataFactory.createSampleDeviceType()
    }
    
    override func tearDown() {
        sampleContent = []
        sampleHints = PresentationHints()
        sampleOCRContext = OCRContext()
        samplePhotoContext = PhotoContext()
        sampleContentComplexity = .moderate
        sampleDeviceType = .phone
        super.tearDown()
    }
    
    // MARK: - Card Layout Decision Functions
    
    func testDetermineIntelligentCardLayout_L2() {
        // Given
        let contentCount = sampleContent.count
        let screenWidth: CGFloat = 375.0
        let deviceType = sampleDeviceType
        let contentComplexity = sampleContentComplexity
        
        // When
        let layoutDecision = determineIntelligentCardLayout_L2(
            contentCount: contentCount,
            screenWidth: screenWidth,
            deviceType: deviceType,
            contentComplexity: contentComplexity
        )
        
        // Then
        XCTAssertNotNil(layoutDecision, "Layout decision should be created")
        XCTAssertGreaterThan(layoutDecision.columns, 0, "Should have at least 1 column")
        XCTAssertGreaterThan(layoutDecision.spacing, 0, "Spacing should be positive")
        XCTAssertGreaterThan(layoutDecision.cardWidth, 0, "Card width should be positive")
        XCTAssertGreaterThan(layoutDecision.cardHeight, 0, "Card height should be positive")
        XCTAssertGreaterThan(layoutDecision.padding, 0, "Padding should be positive")
        XCTAssertGreaterThan(layoutDecision.expansionScale, 1.0, "Expansion scale should be greater than 1.0")
        XCTAssertGreaterThan(layoutDecision.animationDuration, 0, "Animation duration should be positive")
    }
    
    func testDetermineIntelligentCardLayout_L2_PhoneDevice() {
        // Given
        let contentCount = 6
        let screenWidth: CGFloat = 375.0
        let deviceType = DeviceType.phone
        let contentComplexity = ContentComplexity.simple
        
        // When
        let layoutDecision = determineIntelligentCardLayout_L2(
            contentCount: contentCount,
            screenWidth: screenWidth,
            deviceType: deviceType,
            contentComplexity: contentComplexity
        )
        
        // Then
        XCTAssertEqual(layoutDecision.columns, 1, "Phone should use 1 column for 6 items")
        XCTAssertTrue(layoutDecision.cardWidth <= screenWidth - 32, "Card width should fit screen")
    }
    
    func testDetermineIntelligentCardLayout_L2_PadDevice() {
        // Given
        let contentCount = 8
        let screenWidth: CGFloat = 768.0
        let deviceType = DeviceType.pad
        let contentComplexity = ContentComplexity.complex
        
        // When
        let layoutDecision = determineIntelligentCardLayout_L2(
            contentCount: contentCount,
            screenWidth: screenWidth,
            deviceType: deviceType,
            contentComplexity: contentComplexity
        )
        
        // Then
        XCTAssertGreaterThanOrEqual(layoutDecision.columns, 2, "iPad should use at least 2 columns")
        XCTAssertLessThanOrEqual(layoutDecision.columns, 4, "iPad should use at most 4 columns")
    }
    
    // MARK: - OCR Layout Decision Functions
    
    func testPlatformOCRLayout_L2() {
        // Given
        let context = sampleOCRContext
        let capabilities: OCRDeviceCapabilities? = nil
        
        // When
        let layout = platformOCRLayout_L2(
            context: context,
            capabilities: capabilities
        )
        
        // Then
        XCTAssertNotNil(layout, "OCR layout should be created")
        XCTAssertGreaterThan(layout.maxImageSize.width, 0, "Max image width should be positive")
        XCTAssertGreaterThan(layout.maxImageSize.height, 0, "Max image height should be positive")
        XCTAssertGreaterThan(layout.recommendedImageSize.width, 0, "Recommended image width should be positive")
        XCTAssertGreaterThan(layout.recommendedImageSize.height, 0, "Recommended image height should be positive")
    }
    
    func testPlatformDocumentOCRLayout_L2() {
        // Given
        let documentType = DocumentType.receipt
        let context = sampleOCRContext
        let capabilities: OCRDeviceCapabilities? = nil
        
        // When
        let layout = platformDocumentOCRLayout_L2(
            documentType: documentType,
            context: context,
            capabilities: capabilities
        )
        
        // Then
        XCTAssertNotNil(layout, "Document OCR layout should be created")
        XCTAssertGreaterThan(layout.maxImageSize.width, 0, "Max image width should be positive")
        XCTAssertGreaterThan(layout.maxImageSize.height, 0, "Max image height should be positive")
    }
    
    func testPlatformReceiptOCRLayout_L2() {
        // Given
        let context = sampleOCRContext
        let capabilities: OCRDeviceCapabilities? = nil
        
        // When
        let layout = platformReceiptOCRLayout_L2(
            context: context,
            capabilities: capabilities
        )
        
        // Then
        XCTAssertNotNil(layout, "Receipt OCR layout should be created")
        XCTAssertGreaterThan(layout.maxImageSize.width, 0, "Max image width should be positive")
        XCTAssertGreaterThan(layout.maxImageSize.height, 0, "Max image height should be positive")
    }
    
    func testPlatformBusinessCardOCRLayout_L2() {
        // Given
        let context = sampleOCRContext
        let capabilities: OCRDeviceCapabilities? = nil
        
        // When
        let layout = platformBusinessCardOCRLayout_L2(
            context: context,
            capabilities: capabilities
        )
        
        // Then
        XCTAssertNotNil(layout, "Business card OCR layout should be created")
        XCTAssertGreaterThan(layout.maxImageSize.width, 0, "Max image width should be positive")
        XCTAssertGreaterThan(layout.maxImageSize.height, 0, "Max image height should be positive")
    }
    
    // MARK: - Photo Layout Decision Functions
    
    func testDetermineOptimalPhotoLayout_L2() {
        // Given
        let purpose = PhotoPurpose.document
        let context = samplePhotoContext
        
        // When
        let layout = determineOptimalPhotoLayout_L2(
            purpose: purpose,
            context: context
        )
        
        // Then
        XCTAssertGreaterThan(layout.width, 0, "Photo layout width should be positive")
        XCTAssertGreaterThan(layout.height, 0, "Photo layout height should be positive")
        XCTAssertLessThanOrEqual(layout.width, context.availableSpace.width, "Layout width should fit available space")
        XCTAssertLessThanOrEqual(layout.height, context.availableSpace.height, "Layout height should fit available space")
    }
    
    func testDetermineOptimalPhotoLayout_L2_VehiclePhoto() {
        // Given
        let purpose = PhotoPurpose.vehiclePhoto
        let context = samplePhotoContext
        
        // When
        let layout = determineOptimalPhotoLayout_L2(
            purpose: purpose,
            context: context
        )
        
        // Then
        XCTAssertGreaterThan(layout.width, 0, "Vehicle photo layout width should be positive")
        XCTAssertGreaterThan(layout.height, 0, "Vehicle photo layout height should be positive")
        // Vehicle photos should be wider than tall (landscape aspect ratio)
        XCTAssertGreaterThan(layout.width, layout.height, "Vehicle photo should be landscape")
    }
    
    func testDetermineOptimalPhotoLayout_L2_ReceiptPhoto() {
        // Given
        let purpose = PhotoPurpose.fuelReceipt
        let context = samplePhotoContext
        
        // When
        let layout = determineOptimalPhotoLayout_L2(
            purpose: purpose,
            context: context
        )
        
        // Then
        XCTAssertGreaterThan(layout.width, 0, "Receipt photo layout width should be positive")
        XCTAssertGreaterThan(layout.height, 0, "Receipt photo layout height should be positive")
        // Receipt photos should be taller than wide (portrait aspect ratio)
        XCTAssertGreaterThan(layout.height, layout.width, "Receipt photo should be portrait")
    }
    
    func testDetermineOptimalPhotoLayout_L2_OdometerPhoto() {
        // Given
        let purpose = PhotoPurpose.odometer
        let context = samplePhotoContext
        
        // When
        let layout = determineOptimalPhotoLayout_L2(
            purpose: purpose,
            context: context
        )
        
        // Then
        XCTAssertGreaterThan(layout.width, 0, "Odometer photo layout width should be positive")
        XCTAssertGreaterThan(layout.height, 0, "Odometer photo layout height should be positive")
        // Odometer photos should be roughly square
        let aspectRatio = layout.width / layout.height
        XCTAssertGreaterThan(aspectRatio, 0.8, "Odometer photo should be roughly square")
        XCTAssertLessThan(aspectRatio, 1.2, "Odometer photo should be roughly square")
    }
    
    func testDeterminePhotoCaptureStrategy_L2() {
        // Given
        let purpose = PhotoPurpose.document
        let context = samplePhotoContext
        
        // When
        let strategy = determinePhotoCaptureStrategy_L2(
            purpose: purpose,
            context: context
        )
        
        // Then
        XCTAssertTrue([PhotoCaptureStrategy.camera, .photoLibrary, .both].contains(strategy), "Strategy should be valid")
    }
    
    func testDeterminePhotoCaptureStrategy_L2_CameraOnly() {
        // Given
        let purpose = PhotoPurpose.vehiclePhoto
        let context = PhotoContext(
            screenSize: CGSize(width: 375, height: 667),
            availableSpace: CGSize(width: 375, height: 600),
            userPreferences: PhotoPreferences(preferredSource: .camera),
            deviceCapabilities: PhotoDeviceCapabilities(hasCamera: true, hasPhotoLibrary: false)
        )
        
        // When
        let strategy = determinePhotoCaptureStrategy_L2(
            purpose: purpose,
            context: context
        )
        
        // Then
        XCTAssertEqual(strategy, .camera, "Should use camera when only camera is available")
    }
    
    func testDeterminePhotoCaptureStrategy_L2_PhotoLibraryOnly() {
        // Given
        let purpose = PhotoPurpose.document
        let context = PhotoContext(
            screenSize: CGSize(width: 375, height: 667),
            availableSpace: CGSize(width: 375, height: 600),
            userPreferences: PhotoPreferences(preferredSource: .photoLibrary),
            deviceCapabilities: PhotoDeviceCapabilities(hasCamera: false, hasPhotoLibrary: true)
        )
        
        // When
        let strategy = determinePhotoCaptureStrategy_L2(
            purpose: purpose,
            context: context
        )
        
        // Then
        XCTAssertEqual(strategy, .photoLibrary, "Should use photo library when only photo library is available")
    }
    
    // MARK: - Layout Decision Validation
    
    func testLayoutDecisionConsistency() {
        // Given
        let contentCount = 10
        let screenWidth: CGFloat = 375.0
        let deviceType = DeviceType.phone
        let contentComplexity = ContentComplexity.moderate
        
        // When
        let layout1 = determineIntelligentCardLayout_L2(
            contentCount: contentCount,
            screenWidth: screenWidth,
            deviceType: deviceType,
            contentComplexity: contentComplexity
        )
        
        let layout2 = determineIntelligentCardLayout_L2(
            contentCount: contentCount,
            screenWidth: screenWidth,
            deviceType: deviceType,
            contentComplexity: contentComplexity
        )
        
        // Then
        XCTAssertEqual(layout1.columns, layout2.columns, "Layout decisions should be consistent")
        XCTAssertEqual(layout1.spacing, layout2.spacing, "Layout decisions should be consistent")
        XCTAssertEqual(layout1.cardWidth, layout2.cardWidth, "Layout decisions should be consistent")
        XCTAssertEqual(layout1.cardHeight, layout2.cardHeight, "Layout decisions should be consistent")
    }
    
    func testLayoutDecisionPerformance() {
        // Given
        let contentCount = 100
        let screenWidth: CGFloat = 1024.0
        let deviceType = DeviceType.pad
        let contentComplexity = ContentComplexity.complex
        
        // When
        let startTime = CFAbsoluteTimeGetCurrent()
        let layout = determineIntelligentCardLayout_L2(
            contentCount: contentCount,
            screenWidth: screenWidth,
            deviceType: deviceType,
            contentComplexity: contentComplexity
        )
        let endTime = CFAbsoluteTimeGetCurrent()
        
        // Then
        XCTAssertNotNil(layout, "Layout decision should be created")
        let executionTime = endTime - startTime
        XCTAssertLessThan(executionTime, 0.1, "Layout decision should be fast (< 100ms)")
    }
}








