import XCTest
import SwiftUI
@testable import SixLayerFramework

final class OCRSemanticLayerTests: XCTestCase {
    
    // MARK: - Layer 1: Semantic OCR Functions Tests
    
    func testPlatformOCRIntent_L1() {
        // Given: Image and text types for OCR
        let image = createTestImage()
        let textTypes: [TextType] = [.price, .number, .date]
        
        // When: Creating semantic OCR intent
        let ocrIntent = platformOCRIntent_L1(
            image: image,
            textTypes: textTypes
        ) { result in
            // Then: OCR result should be processed
            XCTAssertNotNil(result)
        }
        
        // Then: OCR intent should be created
        XCTAssertNotNil(ocrIntent)
    }
    
    func testPlatformTextExtraction_L1() {
        // Given: Image and extraction context
        let image = createTestImage()
        let context = OCRContext(
            textTypes: [.price, .number],
            language: .english,
            confidenceThreshold: 0.8
        )
        
        // When: Creating text extraction intent
        let extractionIntent = platformTextExtraction_L1(
            image: image,
            context: context
        ) { result in
            // Then: Extraction result should be processed
            XCTAssertNotNil(result)
        }
        
        // Then: Extraction intent should be created
        XCTAssertNotNil(extractionIntent)
    }
    
    func testPlatformDocumentAnalysis_L1() {
        // Given: Image and document type
        let image = createTestImage()
        let documentType = DocumentType.receipt
        
        // When: Creating document analysis intent
        let analysisIntent = platformDocumentAnalysis_L1(
            image: image,
            documentType: documentType
        ) { result in
            // Then: Analysis result should be processed
            XCTAssertNotNil(result)
        }
        
        // Then: Analysis intent should be created
        XCTAssertNotNil(analysisIntent)
    }
    
    // MARK: - Layer 2: Layout Decision Tests
    
    func testPlatformOCRLayout_L2() {
        // Given: OCR context and device capabilities
        let context = OCRContext(
            textTypes: [.price, .number],
            language: .english,
            confidenceThreshold: 0.8
        )
        let capabilities = OCRDeviceCapabilities(
            hasVisionFramework: true,
            hasNeuralEngine: true,
            maxImageSize: CGSize(width: 4000, height: 4000)
        )
        
        // When: Determining OCR layout
        let layout = platformOCRLayout_L2(
            context: context,
            capabilities: capabilities
        )
        
        // Then: Layout should be determined
        XCTAssertNotNil(layout)
        XCTAssertTrue(layout.maxImageSize.width > 0)
        XCTAssertTrue(layout.maxImageSize.height > 0)
    }
    
    // MARK: - Layer 3: Strategy Selection Tests
    
    func testPlatformOCRStrategy_L3() {
        // Given: Text types and platform
        let textTypes: [TextType] = [.price, .number, .date]
        let platform = Platform.current
        
        // When: Selecting OCR strategy
        let strategy = platformOCRStrategy_L3(
            textTypes: textTypes,
            platform: platform
        )
        
        // Then: Strategy should be selected
        XCTAssertNotNil(strategy)
        XCTAssertTrue(strategy.supportedTextTypes.contains(.price))
        XCTAssertTrue(strategy.supportedTextTypes.contains(.number))
    }
    
    // MARK: - Layer 4: Component Implementation Tests
    
    func testPlatformOCRComponent_L4() {
        // Given: OCR configuration
        let configuration = OCRConfiguration(
            textTypes: [.price, .number],
            language: .english,
            confidenceThreshold: 0.8,
            allowsEditing: true
        )
        
        // When: Creating OCR component
        let component = platformOCRComponent_L4(
            configuration: configuration
        ) { result in
            // Then: OCR result should be processed
            XCTAssertNotNil(result)
        }
        
        // Then: Component should be created
        XCTAssertNotNil(component)
    }
    
    func testPlatformTextRecognition_L4() {
        // Given: Image and recognition options
        let image = createTestImage()
        let options = TextRecognitionOptions(
            textTypes: [.price, .number],
            language: .english,
            confidenceThreshold: 0.8
        )
        
        // When: Performing text recognition
        let recognition = platformTextRecognition_L4(
            image: image,
            options: options
        ) { result in
            // Then: Recognition result should be processed
            XCTAssertNotNil(result)
        }
        
        // Then: Recognition should be created
        XCTAssertNotNil(recognition)
    }
    
    // MARK: - Helper Methods
    
    private func createTestImage() -> PlatformImage {
        #if os(iOS)
        return PlatformImage(systemName: "doc.text") ?? PlatformImage()
        #elseif os(macOS)
        return PlatformImage(systemSymbolName: "doc.text") ?? PlatformImage()
        #else
        return PlatformImage()
        #endif
    }
}

// MARK: - OCR Result Validation Tests

extension OCRSemanticLayerTests {
    
    func testOCRResultValidation() {
        // Given: OCR result with various text types
        let result = OCRResult(
            extractedText: "Total: $25.99\nDate: 2024-01-15",
            confidence: 0.95,
            boundingBoxes: [
                CGRect(x: 0, y: 0, width: 100, height: 20),
                CGRect(x: 0, y: 25, width: 120, height: 20)
            ],
            textTypes: [
                .price: "$25.99",
                .date: "2024-01-15"
            ],
            processingTime: 0.5
        )
        
        // When: Validating result
        let isValid = result.isValid
        let hasPrice = result.textTypes[.price] != nil
        let hasDate = result.textTypes[.date] != nil
        
        // Then: Result should be valid
        XCTAssertTrue(isValid)
        XCTAssertTrue(hasPrice)
        XCTAssertTrue(hasDate)
        XCTAssertEqual(result.confidence, 0.95, accuracy: 0.01)
    }
    
    func testOCRResultFiltering() {
        // Given: OCR result with mixed confidence levels
        let result = OCRResult(
            extractedText: "High confidence text\nLow confidence text",
            confidence: 0.6,
            boundingBoxes: [],
            textTypes: [
                .price: "$25.99",
                .number: "123"
            ],
            processingTime: 0.3
        )
        
        // When: Filtering by confidence threshold
        let filteredResult = result.filtered(by: 0.8)
        
        // Then: Filtered result should have lower confidence
        XCTAssertLessThan(filteredResult.confidence, 0.8)
    }
}
