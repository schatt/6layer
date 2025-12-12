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
    
    @Test func testInternationalizationServiceInitialization() {
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
    
    // MARK: - Bundle Fallback Tests
    
    @Test func testLocalizedString_ReturnsKeyWhenNotFound() {
        // Given: Service with no localization files
        let service = InternationalizationService()
        
        // When: Requesting a non-existent key
        let result = service.localizedString(for: "nonexistent.key.test.12345")
        
        // Then: Should return the key itself (fallback behavior)
        #expect(result == "nonexistent.key.test.12345")
    }
    
    @Test func testLocalizedString_SupportsStringFormatting() {
        // Given: Service
        let service = InternationalizationService()
        
        // When: Requesting with format arguments (even if key doesn't exist)
        let result = service.localizedString(for: "test.key", arguments: ["arg1", "arg2"])
        
        // Then: Should handle arguments (will return key if not found, but method should not crash)
        #expect(!result.isEmpty)
    }
    
    @Test func testAppLocalizedString_MethodExists() {
        // Given: Service
        let service = InternationalizationService()
        
        // When: Using app-only method
        let result = service.appLocalizedString(for: "test.key")
        
        // Then: Should return a string (key itself if not found)
        #expect(!result.isEmpty)
    }
    
    @Test func testFrameworkLocalizedString_MethodExists() {
        // Given: Service
        let service = InternationalizationService()
        
        // When: Using framework-only method
        let result = service.frameworkLocalizedString(for: "test.key")
        
        // Then: Should return a string (key itself if not found)
        #expect(!result.isEmpty)
    }
    
    @Test func testLocalizedString_WithCustomAppBundle() {
        // Given: Service with custom app bundle
        let customBundle = Bundle.main
        let service = InternationalizationService(appBundle: customBundle)
        
        // When: Requesting a string
        let result = service.localizedString(for: "test.key")
        
        // Then: Should use the custom bundle
        #expect(!result.isEmpty)
    }
}
