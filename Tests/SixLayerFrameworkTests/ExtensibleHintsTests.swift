import XCTest
@testable import SixLayerFramework

final class ExtensibleHintsTests: XCTestCase {
    
    // MARK: - ExtensibleHint Protocol Tests
    
    func testCustomHintCreation() throws {
        // Given
        let hintType = "test.custom"
        let priority = HintPriority.high
        let overridesDefault = true
        let customData: [String: Any] = ["key": "value", "number": 42]
        
        // When
        let hint = CustomHint(
            hintType: hintType,
            priority: priority,
            overridesDefault: overridesDefault,
            customData: customData
        )
        
        // Then
        XCTAssertEqual(hint.hintType, hintType)
        XCTAssertEqual(hint.priority, priority)
        XCTAssertEqual(hint.overridesDefault, overridesDefault)
        XCTAssertEqual(hint.customData.count, customData.count)
        XCTAssertEqual(hint.customData["key"] as? String, "value")
        XCTAssertEqual(hint.customData["number"] as? Int, 42)
    }
    
    func testHintPriorityComparison() throws {
        // Given
        let critical = HintPriority.critical
        let high = HintPriority.high
        let normal = HintPriority.normal
        let low = HintPriority.low
        
        // Then
        XCTAssertTrue(critical > high)
        XCTAssertTrue(high > normal)
        XCTAssertTrue(normal > low)
        XCTAssertTrue(critical > low)
        XCTAssertFalse(low > critical)
    }
    
    func testHintPriorityAllCases() throws {
        // Given & When
        let priorities = HintPriority.allCases
        
        // Then
        XCTAssertEqual(priorities.count, 4)
        XCTAssertTrue(priorities.contains(.critical))
        XCTAssertTrue(priorities.contains(.high))
        XCTAssertTrue(priorities.contains(.normal))
        XCTAssertTrue(priorities.contains(.low))
    }
    
    // MARK: - EnhancedPresentationHints Tests
    
    func testEnhancedPresentationHintsWithCustomHints() throws {
        // Given
        let customHint = CustomHint(
            hintType: "test.hint",
            priority: .high,
            overridesDefault: true,
            customData: ["test": true]
        )
        
        // When
        let hints = EnhancedPresentationHints(
            dataType: .text,
            presentationPreference: .card,
            complexity: .simple,
            context: .detail,
            customPreferences: ["theme": "dark"],
            extensibleHints: [customHint]
        )
        
        // Then
        XCTAssertEqual(hints.extensibleHints.count, 1)
        XCTAssertEqual(hints.customPreferences["theme"], "dark")
        XCTAssertTrue(hints.hasOverridingHints)
    }
    
    func testEnhancedPresentationHintsHintsMethod() throws {
        // Given
        let customHint = CustomHint(
            hintType: "test.hint",
            priority: .high,
            overridesDefault: false,
            customData: [:]
        )
        let hints = EnhancedPresentationHints(
            dataType: .text,
            presentationPreference: .card,
            complexity: .simple,
            context: .detail,
            extensibleHints: [customHint]
        )
        
        // When
        let extractedHints: [CustomHint] = hints.hints(ofType: CustomHint.self)
        
        // Then
        XCTAssertEqual(extractedHints.count, 1)
        XCTAssertEqual(extractedHints.first?.hintType, "test.hint")
    }
    
    func testEnhancedPresentationHintsHighestPriorityHint() throws {
        // Given
        let lowPriorityHint = CustomHint(
            hintType: "low.priority",
            priority: .low,
            overridesDefault: false,
            customData: [:]
        )
        let highPriorityHint = CustomHint(
            hintType: "high.priority",
            priority: .high,
            overridesDefault: false,
            customData: [:]
        )
        let hints = EnhancedPresentationHints(
            dataType: .text,
            presentationPreference: .card,
            complexity: .simple,
            context: .detail,
            extensibleHints: [lowPriorityHint, highPriorityHint]
        )
        
        // When
        let highestHint = hints.highestPriorityHint
        
        // Then
        XCTAssertNotNil(highestHint)
        XCTAssertEqual(highestHint?.hintType, "high.priority")
        XCTAssertEqual(highestHint?.priority, .high)
    }
    
    func testEnhancedPresentationHintsHasOverridingHints() throws {
        // Given
        let nonOverridingHint = CustomHint(
            hintType: "non.overriding",
            priority: .normal,
            overridesDefault: false,
            customData: [:]
        )
        let overridingHint = CustomHint(
            hintType: "overriding",
            priority: .high,
            overridesDefault: true,
            customData: [:]
        )
        
        // When
        let hintsWithoutOverriding = EnhancedPresentationHints(
            dataType: .text,
            presentationPreference: .card,
            complexity: .simple,
            context: .detail,
            extensibleHints: [nonOverridingHint]
        )
        let hintsWithOverriding = EnhancedPresentationHints(
            dataType: .text,
            presentationPreference: .card,
            complexity: .simple,
            context: .detail,
            extensibleHints: [overridingHint]
        )
        
        // Then
        XCTAssertFalse(hintsWithoutOverriding.hasOverridingHints)
        XCTAssertTrue(hintsWithOverriding.hasOverridingHints)
    }
    
    func testEnhancedPresentationHintsAllCustomData() throws {
        // Given
        let hint1 = CustomHint(
            hintType: "hint1",
            priority: .normal,
            overridesDefault: false,
            customData: ["key1": "value1", "key2": 100]
        )
        let hint2 = CustomHint(
            hintType: "hint2",
            priority: .normal,
            overridesDefault: false,
            customData: ["key3": "value3", "key4": 200]
        )
        let hints = EnhancedPresentationHints(
            dataType: .text,
            presentationPreference: .card,
            complexity: .simple,
            context: .detail,
            extensibleHints: [hint1, hint2]
        )
        
        // When
        let allData = hints.allCustomData
        
        // Then
        XCTAssertEqual(allData.count, 4)
        XCTAssertEqual(allData["key1"] as? String, "value1")
        XCTAssertEqual(allData["key2"] as? Int, 100)
        XCTAssertEqual(allData["key3"] as? String, "value3")
        XCTAssertEqual(allData["key4"] as? Int, 200)
    }
    
    // MARK: - HintProcessingEngine Tests
    
    func testHintProcessingEngineShouldOverrideFramework() throws {
        // Given
        let overridingHint = CustomHint(
            hintType: "overriding",
            priority: .critical,
            overridesDefault: true,
            customData: [:]
        )
        let hints = EnhancedPresentationHints(
            dataType: .text,
            presentationPreference: .card,
            complexity: .simple,
            context: .detail,
            extensibleHints: [overridingHint]
        )
        
        // When
        let shouldOverride = HintProcessingEngine.shouldOverrideFramework(
            hints: hints,
            for: "layout"
        )
        
        // Then
        XCTAssertTrue(shouldOverride)
    }
    
    func testHintProcessingEngineExtractLayoutPreferences() throws {
        // Given
        let layoutHint = CustomHint(
            hintType: "layout",
            priority: .normal,
            overridesDefault: false,
            customData: [
                "recommendedColumns": 3,
                "spacing": "compact",
                "layoutStyle": "grid"
            ]
        )
        let hints = EnhancedPresentationHints(
            dataType: .text,
            presentationPreference: .grid,
            complexity: .moderate,
            context: .list,
            extensibleHints: [layoutHint]
        )
        
        // When
        let layoutPrefs = HintProcessingEngine.extractLayoutPreferences(from: hints)
        
        // Then
        XCTAssertEqual(layoutPrefs["columns"] as? Int, 3)
        XCTAssertEqual(layoutPrefs["spacing"] as? String, "compact")
        XCTAssertEqual(layoutPrefs["layoutStyle"] as? String, "grid")
    }
    
    func testHintProcessingEngineExtractPerformancePreferences() throws {
        // Given
        let performanceHint = CustomHint(
            hintType: "performance",
            priority: .high,
            overridesDefault: false,
            customData: [
                "autoPlay": true,
                "refreshRate": 100,
                "infiniteScroll": true
            ]
        )
        let hints = EnhancedPresentationHints(
            dataType: .text,
            presentationPreference: .list,
            complexity: .complex,
            context: .dashboard,
            extensibleHints: [performanceHint]
        )
        
        // When
        let perfPrefs = HintProcessingEngine.extractPerformancePreferences(from: hints)
        
        // Then
        XCTAssertEqual(perfPrefs["autoPlay"] as? Bool, true)
        XCTAssertEqual(perfPrefs["refreshRate"] as? Int, 100)
        XCTAssertEqual(perfPrefs["infiniteScroll"] as? Bool, true)
    }
    
    func testHintProcessingEngineExtractAccessibilityPreferences() throws {
        // Given
        let accessibilityHint = CustomHint(
            hintType: "accessibility",
            priority: .critical,
            overridesDefault: true,
            customData: [
                "showInteractions": true,
                "drillDownEnabled": false,
                "accessibilityMode": true
            ]
        )
        let hints = EnhancedPresentationHints(
            dataType: .text,
            presentationPreference: .detail,
            complexity: .simple,
            context: .form,
            extensibleHints: [accessibilityHint]
        )
        
        // When
        let accessibilityPrefs = HintProcessingEngine.extractAccessibilityPreferences(from: hints)
        
        // Then
        XCTAssertEqual(accessibilityPrefs["showInteractions"] as? Bool, true)
        XCTAssertEqual(accessibilityPrefs["drillDownEnabled"] as? Bool, false)
        // Note: accessibilityMode is not extracted by the engine, only showInteractions and drillDownEnabled are
    }
}
