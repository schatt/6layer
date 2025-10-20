import Testing


//
//  InternationalizationServiceTests.swift
//  SixLayerFrameworkTests
//
//  Tests for InternationalizationService.swift
//  Tests the internationalization service business logic
//

@testable import SixLayerFramework

open class InternationalizationServiceTests {
    
    // MARK: - Test Data
    
    private var service: InternationalizationService!
    
    init() async throws {
        service = InternationalizationService(locale: Locale(identifier: "en-US"))
    }    // MARK: - Business Logic Tests
    
    @Test func testInternationalizationService_BusinessLogic() {
        // Given
        let testText = "Hello World"
        
        // When
        let direction = service.textDirection(for: testText)
        let alignment = service.textAlignment(for: testText)
        let layoutDirection = service.getLayoutDirection()
        
        // Then: Test actual business logic
        #expect(direction == .leftToRight, "English text should be left-to-right")
        #expect(alignment == .leading, "English text should align leading")
        #expect(layoutDirection == .leftToRight, "English locale should be left-to-right")
    }
    
    @Test func testInternationalizationService_RTL_BusinessLogic() {
        // Given
        let rtlService = InternationalizationService(locale: Locale(identifier: "ar-SA"))
        let arabicText = "مرحبا بالعالم"
        
        // When
        let direction = rtlService.textDirection(for: arabicText)
        let alignment = rtlService.textAlignment(for: arabicText)
        let layoutDirection = rtlService.getLayoutDirection()
        
        // Then: Test actual business logic
        #expect(direction == .rightToLeft, "Arabic text should be right-to-left")
        #expect(alignment == .trailing, "Arabic text should align trailing")
        #expect(layoutDirection == .rightToLeft, "Arabic locale should be right-to-left")
    }
    
    @Test func testInternationalizationService_MixedText_BusinessLogic() {
        // Given
        let mixedText = "Hello مرحبا World"
        
        // When
        let direction = service.textDirection(for: mixedText)
        let alignment = service.textAlignment(for: mixedText)
        
        // Then: Test actual business logic
        // Mixed text should return .mixed for English locale
        #expect(direction == .mixed, "Mixed text should return .mixed for English locale")
        #expect(alignment == .leading, "Mixed text should align leading for English locale")
    }
    
    @Test func testInternationalizationService_InvalidLocale_BusinessLogic() {
        // Given
        let invalidService = InternationalizationService(locale: Locale(identifier: "invalid-locale"))
        
        // When
        let layoutDirection = invalidService.getLayoutDirection()
        
        // Then: Test actual business logic
        // Should fallback to LTR for invalid locales
        #expect(layoutDirection == .leftToRight, "Invalid locale should fallback to left-to-right")
    }
    
    @Test func testInternationalizationService_EmptyText_BusinessLogic() {
        // Given
        let emptyText = ""
        
        // When
        let direction = service.textDirection(for: emptyText)
        let alignment = service.textAlignment(for: emptyText)
        
        // Then: Test actual business logic
        // Empty text should default to LTR for English locale
        #expect(direction == .leftToRight, "Empty text should default to left-to-right for English locale")
        #expect(alignment == .leading, "Empty text should align leading for English locale")
    }
}
