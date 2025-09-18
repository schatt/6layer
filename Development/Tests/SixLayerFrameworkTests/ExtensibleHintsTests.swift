import XCTest
import SwiftUI
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
    
    // MARK: - L1 Function Integration Tests
    
    @MainActor
    func testPlatformPresentItemCollection_L1WithEnhancedHints() throws {
        // Given
        let customHint = CustomHint(
            hintType: "test.collection",
            priority: .high,
            overridesDefault: false,
            customData: [
                "layoutStyle": "grid",
                "recommendedColumns": 3,
                "spacing": "compact"
            ]
        )
        let enhancedHints = EnhancedPresentationHints(
            dataType: .collection,
            presentationPreference: .grid,
            complexity: .moderate,
            context: .browse,
            extensibleHints: [customHint]
        )
        let testItems = Array(0..<10).map { MockItem(id: $0) }
        
        // When
        let view = platformPresentItemCollection_L1(
            items: testItems,
            hints: enhancedHints
        )
        
        // Then
        XCTAssertNotNil(view, "Should create view with enhanced hints")
    }
    
    @MainActor
    func testPlatformPresentNumericData_L1WithEnhancedHints() throws {
        // Given
        let performanceHint = CustomHint(
            hintType: "performance",
            priority: .normal,
            overridesDefault: false,
            customData: [
                "refreshRate": 30,
                "realTimeUpdates": true
            ]
        )
        let enhancedHints = EnhancedPresentationHints(
            dataType: .numeric,
            presentationPreference: .chart,
            complexity: .complex,
            context: .dashboard,
            extensibleHints: [performanceHint]
        )
        let testData = [
            GenericNumericData(label: "Test 1", value: 100),
            GenericNumericData(label: "Test 2", value: 200)
        ]
        
        // When
        let view = platformPresentNumericData_L1(
            data: testData,
            hints: enhancedHints
        )
        
        // Then
        XCTAssertNotNil(view, "Should create view with enhanced hints")
    }
    
    @MainActor
    func testPlatformPresentFormData_L1WithEnhancedHints() throws {
        // Given
        let formHint = CustomHint(
            hintType: "form.custom",
            priority: .high,
            overridesDefault: true,
            customData: [
                "validationMode": "realTime",
                "fieldSpacing": "compact",
                "showProgress": true
            ]
        )
        let enhancedHints = EnhancedPresentationHints(
            dataType: .form,
            presentationPreference: .form,
            complexity: .moderate,
            context: .create,
            extensibleHints: [formHint]
        )
        let testFields = [
            GenericFormField(label: "Name", value: .constant(""), fieldType: .text),
            GenericFormField(label: "Email", value: .constant(""), fieldType: .email)
        ]
        
        // When
        let view = platformPresentFormData_L1(
            fields: testFields,
            hints: enhancedHints
        )
        
        // Then
        XCTAssertNotNil(view, "Should create view with enhanced hints")
    }
    
    @MainActor
    func testPlatformPresentMediaData_L1WithEnhancedHints() throws {
        // Given
        let mediaHint = CustomHint(
            hintType: "media.gallery",
            priority: .normal,
            overridesDefault: false,
            customData: [
                "lazyLoading": true,
                "zoomEnabled": true,
                "shareEnabled": true
            ]
        )
        let enhancedHints = EnhancedPresentationHints(
            dataType: .media,
            presentationPreference: .masonry,
            complexity: .moderate,
            context: .browse,
            extensibleHints: [mediaHint]
        )
        let testMedia = [
            GenericMediaItem(title: "Test 1", mediaType: .image),
            GenericMediaItem(title: "Test 2", mediaType: .image)
        ]
        
        // When
        let view = platformPresentMediaData_L1(
            media: testMedia,
            hints: enhancedHints
        )
        
        // Then
        XCTAssertNotNil(view, "Should create view with enhanced hints")
    }
    
    @MainActor
    func testPlatformPresentHierarchicalData_L1WithEnhancedHints() throws {
        // Given
        let hierarchyHint = CustomHint(
            hintType: "hierarchy.tree",
            priority: .normal,
            overridesDefault: false,
            customData: [
                "expandable": true,
                "showLevels": true,
                "indentation": "standard"
            ]
        )
        let enhancedHints = EnhancedPresentationHints(
            dataType: .hierarchical,
            presentationPreference: .list,
            complexity: .moderate,
            context: .browse,
            extensibleHints: [hierarchyHint]
        )
        let testItems = [
            GenericHierarchicalItem(title: "Root 1"),
            GenericHierarchicalItem(title: "Child 1")
        ]
        
        // When
        let view = platformPresentHierarchicalData_L1(
            items: testItems,
            hints: enhancedHints
        )
        
        // Then
        XCTAssertNotNil(view, "Should create view with enhanced hints")
    }
    
    @MainActor
    func testPlatformPresentTemporalData_L1WithEnhancedHints() throws {
        // Given
        let temporalHint = CustomHint(
            hintType: "temporal.schedule",
            priority: .normal,
            overridesDefault: false,
            customData: [
                "showTimeline": true,
                "groupByDay": true,
                "highlightToday": true
            ]
        )
        let enhancedHints = EnhancedPresentationHints(
            dataType: .temporal,
            presentationPreference: .list,
            complexity: .moderate,
            context: .dashboard,
            extensibleHints: [temporalHint]
        )
        let testItems = [
            GenericTemporalItem(title: "Event 1", date: Date()),
            GenericTemporalItem(title: "Event 2", date: Date())
        ]
        
        // When
        let view = platformPresentTemporalData_L1(
            items: testItems,
            hints: enhancedHints
        )
        
        // Then
        XCTAssertNotNil(view, "Should create view with enhanced hints")
    }
    
    @MainActor
    func testPlatformResponsiveCard_L1WithEnhancedHints() throws {
        // Given
        let cardHint = CustomHint(
            hintType: "card.responsive",
            priority: .high,
            overridesDefault: false,
            customData: [
                "cardStyle": "elevated",
                "cornerRadius": 12,
                "shadowDepth": 2
            ]
        )
        let enhancedHints = EnhancedPresentationHints(
            dataType: .collection,
            presentationPreference: .cards,
            complexity: .moderate,
            context: .dashboard,
            extensibleHints: [cardHint]
        )
        
        // When
        let view = platformResponsiveCard_L1(
            content: { 
                Text("Test Card")
            },
            hints: enhancedHints
        )
        
        // Then
        XCTAssertNotNil(view, "Should create view with enhanced hints")
    }
}
