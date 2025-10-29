//
//  FieldHintsDRYTests.swift
//  SixLayerFrameworkTests
//
//  Tests for DRY behavior: hints loaded once, used everywhere
//

import Testing
@testable import SixLayerFramework

struct FieldHintsDRYTests {
    
    @Test func testFieldHintsAreDRY() {
        // Simulate calling loadHints multiple times
        // Should use cache after first load
        
        let loader = FileBasedDataHintsLoader()
        let firstLoad = loader.loadHints(for: "User")
        let secondLoad = loader.loadHints(for: "User")
        let thirdLoad = loader.loadHints(for: "User")
        
        // Each load returns same result (consistent)
        #expect(firstLoad == secondLoad)
        #expect(secondLoad == thirdLoad)
        
        // Note: Actual file system caching is tested in integration tests
    }
    
    @Test func testPresentationHintsWithModelName() async {
        let hints = await PresentationHints(
            dataType: .form,
            modelName: "User",
            registry: globalDataHintsRegistry
        )
        
        // Hints should be loaded (empty if no file exists)
        #expect(hints.fieldHints != nil)
    }
    
    @Test func testEnhancedPresentationHintsWithModelName() async {
        let hints = await EnhancedPresentationHints(
            dataType: .form,
            modelName: "User",
            registry: globalDataHintsRegistry
        )
        
        // Hints should be loaded (empty if no file exists)
        #expect(hints.fieldHints != nil)
    }
}


