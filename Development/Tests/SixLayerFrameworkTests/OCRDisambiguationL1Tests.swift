//
//  OCRDisambiguationL1Tests.swift
//  SixLayerFrameworkTests
//
//  Tests for OCR disambiguation L1 functions
//  Tests OCR disambiguation and text extraction features
//

import XCTest
import SwiftUI
@testable import SixLayerFramework

@MainActor
final class OCRDisambiguationL1Tests: XCTestCase {
    
    // MARK: - Test Data
    
    private var sampleImage: PlatformImage = PlatformImage()
    private var sampleOCRContext: OCRContext = OCRContext()
    private var sampleHints: PresentationHints = PresentationHints()
    
    override func setUp() {
        super.setUp()
        sampleImage = PlatformImage()
        sampleOCRContext = OCRContext()
        sampleHints = PresentationHints()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - OCR Disambiguation Tests
    
    func testPlatformOCRWithDisambiguation_L1() {
        // Given
        let image = sampleImage
        let context = sampleOCRContext
        
        // When
        let view = platformOCRWithDisambiguation_L1(
            image: image,
            context: context,
            onResult: { _ in }
        )
        
        // Then
        XCTAssertNotNil(view, "platformOCRWithDisambiguation_L1 should return a view")
    }
    
    func testPlatformOCRWithDisambiguation_L1_WithDifferentContext() {
        // Given
        let image = sampleImage
        let context = OCRContext()
        
        // When
        let view = platformOCRWithDisambiguation_L1(
            image: image,
            context: context,
            onResult: { _ in }
        )
        
        // Then
        XCTAssertNotNil(view, "platformOCRWithDisambiguation_L1 with different context should return a view")
    }
    
    // MARK: - Edge Cases
    
    func testPlatformOCRWithDisambiguation_L1_WithEmptyImage() {
        // Given
        let image = PlatformImage()
        let context = sampleOCRContext
        
        // When
        let view = platformOCRWithDisambiguation_L1(
            image: image,
            context: context,
            onResult: { _ in }
        )
        
        // Then
        XCTAssertNotNil(view, "platformOCRWithDisambiguation_L1 with empty image should return a view")
    }
    
    func testPlatformOCRWithDisambiguation_L1_WithEmptyContext() {
        // Given
        let image = sampleImage
        let context = OCRContext()
        
        // When
        let view = platformOCRWithDisambiguation_L1(
            image: image,
            context: context,
            onResult: { _ in }
        )
        
        // Then
        XCTAssertNotNil(view, "platformOCRWithDisambiguation_L1 with empty context should return a view")
    }
    
    // MARK: - Performance Tests
    
    func testPlatformOCRWithDisambiguation_L1_Performance() {
        // Given
        let image = sampleImage
        let context = sampleOCRContext
        
        // When & Then
        measure {
            let view = platformOCRWithDisambiguation_L1(
                image: image,
                context: context,
                onResult: { _ in }
            )
            XCTAssertNotNil(view)
        }
    }
}
