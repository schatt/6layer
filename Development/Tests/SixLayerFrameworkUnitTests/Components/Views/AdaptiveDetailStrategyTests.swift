import Testing
@testable import SixLayerFramework

/// Unit tests for AdaptiveDetailStrategy decision logic
/// These are FAST - no view rendering, just pure logic testing
/// BUSINESS PURPOSE: Verify that device type → view strategy decisions are correct
@Suite("Adaptive Detail Strategy")
struct AdaptiveDetailStrategyTests {
    
    @Test func testPhoneDeviceTypeReturnsStandardStrategy() {
        // Given: Phone device type
        // When: We determine the adaptive strategy
        let strategy = IntelligentDetailView.determineAdaptiveDetailStrategy(for: .phone)
        
        // Then: Should return standard strategy (phones have limited screen space)
        #expect(strategy == .standard, "Phone should use standard detail view")
    }
    
    @Test func testPadDeviceTypeReturnsDetailedStrategy() {
        // Given: iPad device type
        // When: We determine the adaptive strategy
        let strategy = IntelligentDetailView.determineAdaptiveDetailStrategy(for: .pad)
        
        // Then: Should return detailed strategy (tablets have more screen space)
        #expect(strategy == .detailed, "iPad should use detailed detail view")
    }
    
    @Test func testMacDeviceTypeReturnsDetailedStrategy() {
        // Given: Mac device type
        // When: We determine the adaptive strategy
        let strategy = IntelligentDetailView.determineAdaptiveDetailStrategy(for: .mac)
        
        // Then: Should return detailed strategy (desktop has plenty of screen space)
        #expect(strategy == .detailed, "Mac should use detailed detail view")
    }
    
    @Test func testWatchDeviceTypeReturnsStandardStrategy() {
        // Given: Watch device type (default case)
        // When: We determine the adaptive strategy
        let strategy = IntelligentDetailView.determineAdaptiveDetailStrategy(for: .watch)
        
        // Then: Should return standard strategy (default fallback)
        #expect(strategy == .standard, "Watch should use standard detail view as default")
    }
    
    @Test func testTvDeviceTypeReturnsStandardStrategy() {
        // Given: TV device type (default case)
        // When: We determine the adaptive strategy
        let strategy = IntelligentDetailView.determineAdaptiveDetailStrategy(for: .tv)
        
        // Then: Should return standard strategy (default fallback)
        #expect(strategy == .standard, "TV should use standard detail view as default")
    }
    
    @Test func testAllDeviceTypesReturnValidStrategy() {
        // Test that every device type returns a valid strategy
        // This ensures the switch statement is exhaustive
        for deviceType in DeviceType.allCases {
            let strategy = IntelligentDetailView.determineAdaptiveDetailStrategy(for: deviceType)
            // Just verify it doesn't crash - the type system ensures it's valid
            #expect(strategy == .standard || strategy == .detailed, 
                   "\(deviceType) should return a valid strategy: \(strategy)")
        }
    }
}

