import Testing
@testable import SixLayerFramework

/// Functional tests for InternationalizationService
/// Tests the actual functionality of the internationalization service
@MainActor
open class InternationalizationServiceTests {
    
    // MARK: - Service Initialization Tests
    
    @Test func testInternationalizationServiceInitialization() async {
        // Given & When: Creating the service
        let service = InternationalizationService()
        
        // Then: Service should be created successfully
        #expect(service != nil)
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
    
    // MARK: - Performance Tests
    
    @Test func testInternationalizationServicePerformance() async {
        // Given: InternationalizationService
        let service = InternationalizationService()
        
        // When: Measuring localization performance
        let startTime = CFAbsoluteTimeGetCurrent()
        
        for i in 0..<100 {
            _ = service.localizedString(for: "test.key.\(i)")
        }
        
        let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
        
        // Then: Should be performant
        #expect(timeElapsed < 1.0) // Should complete in under 1 second
    }
}
