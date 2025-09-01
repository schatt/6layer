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
        XCTAssertEqual(contexts.count, 11)
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
        XCTAssertEqual(dataTypes.count, 16)
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
        XCTAssertEqual(preferences.count, 15)
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
        let fieldCount = 5
        let complexity = ContentComplexity.moderate
        let preferredLayout = LayoutPreference.adaptive
        let sectionCount = 3
        let hasComplexContent = true
        
        // When
        let metrics = FormContentMetrics(
            fieldCount: fieldCount,
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
        let metrics = FormContentMetrics(fieldCount: 0)
        
        // Then
        XCTAssertEqual(metrics.estimatedComplexity, .simple)
        XCTAssertEqual(metrics.preferredLayout, .adaptive)
        XCTAssertEqual(metrics.sectionCount, 1)
        XCTAssertFalse(metrics.hasComplexContent)
    }
    
    func testFormContentMetricsEquatable() throws {
        // Given
        let metrics1 = FormContentMetrics(
            fieldCount: 3,
            estimatedComplexity: .moderate,
            preferredLayout: .grid,
            sectionCount: 2,
            hasComplexContent: true
        )
        let metrics2 = FormContentMetrics(
            fieldCount: 3,
            estimatedComplexity: .moderate,
            preferredLayout: .grid,
            sectionCount: 2,
            hasComplexContent: true
        )
        let metrics3 = FormContentMetrics(
            fieldCount: 2,
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
        let validation = ValidationStrategy.immediate
        
        // When
        let strategy = FormStrategy(
            containerType: containerType,
            fieldLayout: fieldLayout,
            validation: validation
        )
        
        // Then
        XCTAssertEqual(strategy.containerType, containerType)
        XCTAssertEqual(strategy.fieldLayout, fieldLayout)
        XCTAssertEqual(strategy.validation, validation)
    }
    
    func testFormStrategyDefaultValues() throws {
        // When
        let strategy = FormStrategy(
            containerType: .standard,
            fieldLayout: .vertical,
            validation: .deferred
        )
        
        // Then
        XCTAssertEqual(strategy.containerType, .standard)
        XCTAssertEqual(strategy.fieldLayout, .vertical)
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
        let title = "Test Image"
        let description = "A test image for testing"
        let type = MediaType.image
        let url = URL(string: "https://example.com/image.jpg")
        
        // When
        let media = GenericMediaItem(
            title: title,
            description: description,
            mediaType: type,
            url: url
        )
        
        // Then
        XCTAssertEqual(media.title, title)
        XCTAssertEqual(media.description, description)
        XCTAssertEqual(media.mediaType, type)
        XCTAssertEqual(media.url, url)
    }
    
    // MARK: - Layer 5: Platform Optimization Tests
    
    func testDeviceTypeCases() throws {
        // Given & When
        let deviceTypes = DeviceType.allCases
        
        // Then
        XCTAssertTrue(deviceTypes.contains(.phone))
        XCTAssertTrue(deviceTypes.contains(.pad))
        XCTAssertTrue(deviceTypes.contains(.mac))
        XCTAssertTrue(deviceTypes.contains(.tv))
        XCTAssertTrue(deviceTypes.contains(.watch))
    }
    
    func testPlatformCases() throws {
        // Given & When
        let platforms = Platform.allCases
        
        // Then
        XCTAssertTrue(platforms.contains(.iOS))
        XCTAssertTrue(platforms.contains(.macOS))
        XCTAssertTrue(platforms.contains(.tvOS))
        XCTAssertTrue(platforms.contains(.watchOS))
    }
    
    // MARK: - Layer 6: Platform System Integration Tests
    
    func testResponsiveBehaviorCreation() throws {
        // Given
        let type = ResponsiveType.adaptive
        let breakpoints: [CGFloat] = [320, 768, 1024, 1440]
        
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
        let behavior = ResponsiveBehavior(
            type: .fixed,
            breakpoints: [],
            adaptive: false
        )
        
        // Then
        XCTAssertEqual(behavior.type, .fixed)
        XCTAssertEqual(behavior.breakpoints, [])
        XCTAssertFalse(behavior.adaptive)
    }
}
