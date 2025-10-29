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
        
        // Each load returns consistent keys and values for key attributes
        #expect(Set(firstLoad.keys) == Set(secondLoad.keys))
        #expect(Set(secondLoad.keys) == Set(thirdLoad.keys))
        
        for key in firstLoad.keys {
            let a = firstLoad[key]
            let b = secondLoad[key]
            let c = thirdLoad[key]
            #expect(a?.expectedLength == b?.expectedLength)
            #expect(b?.expectedLength == c?.expectedLength)
            #expect(a?.displayWidth == b?.displayWidth)
            #expect(b?.displayWidth == c?.displayWidth)
            #expect(a?.maxLength == b?.maxLength)
            #expect(b?.maxLength == c?.maxLength)
            #expect(a?.minLength == b?.minLength)
            #expect(b?.minLength == c?.minLength)
        }
        
        // Note: Actual file system caching is tested in integration tests
    }
    
    @Test func testPresentationHintsWithModelName() async {
        let hints = await PresentationHints(
            dataType: .form,
            modelName: "User",
            registry: globalDataHintsRegistry
        )
        
        // Access fieldHints (may be empty if no file exists)
        let _ = hints.fieldHints
    }
    
    @Test func testEnhancedPresentationHintsWithModelName() async {
        let hints = await EnhancedPresentationHints(
            dataType: .form,
            modelName: "User",
            registry: globalDataHintsRegistry
        )
        
        // Access fieldHints (may be empty if no file exists)
        let _ = hints.fieldHints
    }
}


