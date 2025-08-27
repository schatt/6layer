import XCTest
@testable import SixLayerFramework

final class CoreArchitectureTests: XCTestCase {
    
    // MARK: - Layer 1: Semantic Intent & Data Type Recognition Tests
    
    func testDataTypeHintCreation() throws {
        // Given
        let dataType = DataTypeHint.text
        let preference = PresentationPreference.card
        let complexity = ContentComplexity.simple
        let context = PresentationContext.detail
        
        // When
        let hints = EnhancedPresentationHints(
            dataType: dataType,
            presentationPreference: preference,
            complexity: complexity,
            context: context
        )
        
        // Then
        XCTAssertEqual(hints.dataType, dataType)
        XCTAssertEqual(hints.presentationPreference, preference)
        XCTAssertEqual(hints.complexity, complexity)
        XCTAssertEqual(hints.context, context)
        XCTAssertTrue(hints.extensibleHints.isEmpty)
    }
    
    func testContentComplexityEnumeration() throws {
        // Given & When
        let complexities = ContentComplexity.allCases
        
        // Then
        XCTAssertEqual(complexities.count, 4)
        XCTAssertTrue(complexities.contains(.simple))
        XCTAssertTrue(complexities.contains(.moderate))
        XCTAssertTrue(complexities.contains(.complex))
        XCTAssertTrue(complexities.contains(.veryComplex))
    }
    
    func testPresentationContextEnumeration() throws {
        // Given & When
        let contexts = PresentationContext.allCases
        
        // Then
        XCTAssertEqual(contexts.count, 6)
        XCTAssertTrue(contexts.contains(.list))
        XCTAssertTrue(contexts.contains(.detail))
        XCTAssertTrue(contexts.contains(.form))
        XCTAssertTrue(contexts.contains(.dashboard))
        XCTAssertTrue(contexts.contains(.modal))
        XCTAssertTrue(contexts.contains(.navigation))
    }
    
    func testDataTypeHintEnumeration() throws {
        // Given & When
        let dataTypes = DataTypeHint.allCases
        
        // Then
        XCTAssertEqual(dataTypes.count, 8)
        XCTAssertTrue(dataTypes.contains(.text))
        XCTAssertTrue(dataTypes.contains(.number))
        XCTAssertTrue(dataTypes.contains(.date))
        XCTAssertTrue(dataTypes.contains(.image))
        XCTAssertTrue(dataTypes.contains(.boolean))
        XCTAssertTrue(dataTypes.contains(.collection))
        XCTAssertTrue(dataTypes.contains(.hierarchical))
        XCTAssertTrue(dataTypes.contains(.custom))
    }
    
    func testPresentationPreferenceEnumeration() throws {
        // Given & When
        let preferences = PresentationPreference.allCases
        
        // Then
        XCTAssertEqual(preferences.count, 6)
        XCTAssertTrue(preferences.contains(.card))
        XCTAssertTrue(preferences.contains(.list))
        XCTAssertTrue(preferences.contains(.grid))
        XCTAssertTrue(preferences.contains(.form))
        XCTAssertTrue(preferences.contains(.detail))
        XCTAssertTrue(preferences.contains(.custom))
    }
    
    // MARK: - Layer 2: Layout Decision Engine Tests
    
    func testFormContentMetricsCreation() throws {
        // Given
        let complexity = ContentComplexity.moderate
        let preferredLayout = LayoutApproach.adaptive
        let sectionCount = 3
        let hasComplexContent = true
        
        // When
        let metrics = FormContentMetrics(
            estimatedComplexity: complexity,
            preferredLayout: preferredLayout,
            sectionCount: sectionCount,
            hasComplexContent: hasComplexContent
        )
        
        // Then
        XCTAssertEqual(metrics.estimatedComplexity, complexity)
        XCTAssertEqual(metrics.preferredLayout, preferredLayout)
        XCTAssertEqual(metrics.sectionCount, sectionCount)
        XCTAssertEqual(metrics.hasComplexContent, hasComplexContent)
    }
    
    func testFormContentMetricsDefaultValues() throws {
        // When
        let metrics = FormContentMetrics()
        
        // Then
        XCTAssertEqual(metrics.estimatedComplexity, .simple)
        XCTAssertEqual(metrics.preferredLayout, .adaptive)
        XCTAssertEqual(metrics.sectionCount, 1)
        XCTAssertFalse(metrics.hasComplexContent)
    }
    
    func testFormContentMetricsEquatable() throws {
        // Given
        let metrics1 = FormContentMetrics(
            estimatedComplexity: .moderate,
            preferredLayout: .grid,
            sectionCount: 2,
            hasComplexContent: true
        )
        let metrics2 = FormContentMetrics(
            estimatedComplexity: .moderate,
            preferredLayout: .grid,
            sectionCount: 2,
            hasComplexContent: true
        )
        let metrics3 = FormContentMetrics(
            estimatedComplexity: .complex,
            preferredLayout: .list,
            sectionCount: 1,
            hasComplexContent: false
        )
        
        // Then
        XCTAssertEqual(metrics1, metrics2)
        XCTAssertNotEqual(metrics1, metrics3)
    }
    
    // MARK: - Layer 3: Strategy Selection Tests
    
    func testFormStrategyCreation() throws {
        // Given
        let containerType = FormContainerType.adaptive
        let fieldLayout = FieldLayout.vertical
        let spacing = SpacingPreference.standard
        let validation = ValidationStrategy.immediate
        
        // When
        let strategy = FormStrategy(
            containerType: containerType,
            fieldLayout: fieldLayout,
            spacing: spacing,
            validation: validation
        )
        
        // Then
        XCTAssertEqual(strategy.containerType, containerType)
        XCTAssertEqual(strategy.fieldLayout, fieldLayout)
        XCTAssertEqual(strategy.spacing, spacing)
        XCTAssertEqual(strategy.validation, validation)
    }
    
    func testFormStrategyDefaultValues() throws {
        // When
        let strategy = FormStrategy()
        
        // Then
        XCTAssertEqual(strategy.containerType, .standard)
        XCTAssertEqual(strategy.fieldLayout, .vertical)
        XCTAssertEqual(strategy.spacing, .standard)
        XCTAssertEqual(strategy.validation, .deferred)
    }
    
    // MARK: - Layer 4: Component Implementation Tests
    
    func testGenericFormFieldCreation() throws {
        // Given
        let label = "Test Field"
        let value = "Test Value"
        let isRequired = true
        
        // When
        let field = GenericFormField(
            label: label,
            value: value,
            isRequired: isRequired
        )
        
        // Then
        XCTAssertEqual(field.label, label)
        XCTAssertEqual(field.value, value)
        XCTAssertEqual(field.isRequired, isRequired)
    }
    
    func testGenericMediaItemCreation() throws {
        // Given
        let url = "https://example.com/image.jpg"
        let type = MediaType.image
        let caption = "Test Image"
        
        // When
        let media = GenericMediaItem(
            url: url,
            type: type,
            caption: caption
        )
        
        // Then
        XCTAssertEqual(media.url, url)
        XCTAssertEqual(media.type, type)
        XCTAssertEqual(media.caption, caption)
    }
    
    // MARK: - Layer 5: Platform Optimization Tests
    
    func testDeviceTypeCurrent() throws {
        // Given & When
        let deviceType = DeviceType.current
        
        // Then
        XCTAssertTrue([DeviceType.phone, .tablet, .mac, .tv, .watch].contains(deviceType))
    }
    
    func testPlatformTypeCurrent() throws {
        // Given & When
        let platform = PlatformType.current
        
        // Then
        XCTAssertTrue([PlatformType.iOS, .macOS, .tvOS, .watchOS].contains(platform))
    }
    
    // MARK: - Layer 6: Platform System Integration Tests
    
    func testResponsiveBehaviorCreation() throws {
        // Given
        let type = ResponsiveType.adaptive
        let breakpoints = [320, 768, 1024, 1440]
        
        // When
        let behavior = ResponsiveBehavior(
            type: type,
            breakpoints: breakpoints
        )
        
        // Then
        XCTAssertEqual(behavior.type, type)
        XCTAssertEqual(behavior.breakpoints, breakpoints)
    }
    
    func testResponsiveBehaviorDefaultValues() throws {
        // When
        let behavior = ResponsiveBehavior()
        
        // Then
        XCTAssertEqual(behavior.type, .standard)
        XCTAssertEqual(behavior.breakpoints, [320, 768, 1024])
    }
}
