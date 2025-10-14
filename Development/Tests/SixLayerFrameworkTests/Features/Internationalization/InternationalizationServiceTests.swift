//
//  InternationalizationServiceTests.swift
//  SixLayerFrameworkTests
//
//  Tests for InternationalizationService.swift
//  Tests the internationalization service business logic
//

import XCTest
@testable import SixLayerFramework

final class InternationalizationServiceTests: XCTestCase {
    
    // MARK: - Test Data
    
    private var service: InternationalizationService!
    
    override func setUp() {
        super.setUp()
        service = InternationalizationService(locale: Locale(identifier: "en-US"))
    }
    
    override func tearDown() {
        service = nil
        super.tearDown()
    }
    
    // MARK: - Business Logic Tests
    
    func testInternationalizationService_BusinessLogic() {
        // Given
        let testText = "Hello World"
        
        // When
        let direction = service.textDirection(for: testText)
        let alignment = service.textAlignment(for: testText)
        let layoutDirection = service.getLayoutDirection()
        
        // Then: Test actual business logic
        XCTAssertEqual(direction, .leftToRight, "English text should be left-to-right")
        XCTAssertEqual(alignment, .leading, "English text should align leading")
        XCTAssertEqual(layoutDirection, .leftToRight, "English locale should be left-to-right")
    }
    
    func testInternationalizationService_RTL_BusinessLogic() {
        // Given
        let rtlService = InternationalizationService(locale: Locale(identifier: "ar-SA"))
        let arabicText = "مرحبا بالعالم"
        
        // When
        let direction = rtlService.textDirection(for: arabicText)
        let alignment = rtlService.textAlignment(for: arabicText)
        let layoutDirection = rtlService.getLayoutDirection()
        
        // Then: Test actual business logic
        XCTAssertEqual(direction, .rightToLeft, "Arabic text should be right-to-left")
        XCTAssertEqual(alignment, .trailing, "Arabic text should align trailing")
        XCTAssertEqual(layoutDirection, .rightToLeft, "Arabic locale should be right-to-left")
    }
    
    func testInternationalizationService_MixedText_BusinessLogic() {
        // Given
        let mixedText = "Hello مرحبا World"
        
        // When
        let direction = service.textDirection(for: mixedText)
        let alignment = service.textAlignment(for: mixedText)
        
        // Then: Test actual business logic
        // Mixed text should return .mixed for English locale
        XCTAssertEqual(direction, .mixed, "Mixed text should return .mixed for English locale")
        XCTAssertEqual(alignment, .leading, "Mixed text should align leading for English locale")
    }
    
    func testInternationalizationService_InvalidLocale_BusinessLogic() {
        // Given
        let invalidService = InternationalizationService(locale: Locale(identifier: "invalid-locale"))
        
        // When
        let layoutDirection = invalidService.getLayoutDirection()
        
        // Then: Test actual business logic
        // Should fallback to LTR for invalid locales
        XCTAssertEqual(layoutDirection, .leftToRight, "Invalid locale should fallback to left-to-right")
    }
    
    func testInternationalizationService_EmptyText_BusinessLogic() {
        // Given
        let emptyText = ""
        
        // When
        let direction = service.textDirection(for: emptyText)
        let alignment = service.textAlignment(for: emptyText)
        
        // Then: Test actual business logic
        // Empty text should default to LTR for English locale
        XCTAssertEqual(direction, .leftToRight, "Empty text should default to left-to-right for English locale")
        XCTAssertEqual(alignment, .leading, "Empty text should align leading for English locale")
    }
}
