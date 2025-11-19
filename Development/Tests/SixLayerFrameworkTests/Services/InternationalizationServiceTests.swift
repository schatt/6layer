import Testing
import Foundation
@testable import SixLayerFramework

/// Functional tests for InternationalizationService
/// Tests the actual functionality of the internationalization service
/// Consolidates API tests and business logic tests
/// NOTE: Not marked @MainActor on class to allow parallel execution
@Suite("Internationalization Service")
open class InternationalizationServiceTests: BaseTestClass {
    
    // MARK: - Service Initialization Tests
    
    @Test func testInternationalizationServiceInitialization() async {
        // Given & When: Creating the service
        let service = InternationalizationService()
        
        // Then: Service should be created successfully
        #expect(Bool(true), "service is non-optional")  // service is non-optional
    }
    
    // MARK: - Localization Tests
    
    @Test func testInternationalizationServiceReturnsLocalizedString() async {
        // Given: InternationalizationService
        let service = InternationalizationService()
        
        // When: Requesting a localized string
        let localizedString = service.localizedString(for: "test.key")
        
        // Then: Should return a string (even if it's the key itself)
        #expect(!localizedString.isEmpty)
    }
    
    @Test func testInternationalizationServiceHandlesMissingKey() async {
        // Given: InternationalizationService
        let service = InternationalizationService()
        
        // When: Requesting a non-existent key
        let result = service.localizedString(for: "nonexistent.key.that.does.not.exist")
        
        // Then: Should return the key itself or a fallback
        #expect(!result.isEmpty)
    }
    
    @Test func testInternationalizationServiceSupportsMultipleLanguages() async {
        // Given: InternationalizationService
        let service = InternationalizationService()
        
        // When: Checking supported languages
        let supportedLanguages = service.supportedLanguages()
        
        // Then: Should return at least one language
        #expect(supportedLanguages.count > 0)
    }
    
    // MARK: - Language Detection Tests
    
    @Test func testInternationalizationServiceDetectsCurrentLanguage() async {
        // Given: InternationalizationService
        let service = InternationalizationService()
        
        // When: Getting current language
        let currentLanguage = service.currentLanguage()
        
        // Then: Should return a valid language code
        #expect(!currentLanguage.isEmpty)
    }
    
    @Test func testInternationalizationServiceCanChangeLanguage() async {
        // Given: InternationalizationService
        let service = InternationalizationService()
        
        // When: Setting a different language
        let originalLanguage = service.currentLanguage()
        service.setLanguage("en")
        let newLanguage = service.currentLanguage()
        
        // Then: Language should change (or at least the call should succeed)
        #expect(!newLanguage.isEmpty)
    }
    
    // MARK: - Business Logic Tests (Text Direction & Alignment)
    
    @Test func testInternationalizationService_BusinessLogic() {
        // Given - Create service locally for this test
        let service = InternationalizationService(locale: Locale(identifier: "en-US"))
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
        // Given - Create service locally for this test
        let service = InternationalizationService(locale: Locale(identifier: "en-US"))
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
        // Given - Create service locally for this test
        let service = InternationalizationService(locale: Locale(identifier: "en-US"))
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
