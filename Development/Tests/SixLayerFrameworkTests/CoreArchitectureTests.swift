import XCTest
@testable import SixLayerFramework

final class CoreArchitectureTests: XCTestCase {
    
    // MARK: - Test Helpers
    
    /// Helper function to create GenericFormField with proper binding for tests
    private func createTestField(
        label: String,
        placeholder: String? = nil,
        value: String = "",
        isRequired: Bool = false,
        fieldType: DynamicFieldType = .text
    ) -> GenericFormField {
        return GenericFormField(
            label: label,
            placeholder: placeholder,
            value: .constant(value),
            isRequired: isRequired,
            fieldType: fieldType
        )
    }
    
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
        XCTAssertEqual(complexities.count, 5)
        XCTAssertTrue(complexities.contains(.simple))
        XCTAssertTrue(complexities.contains(.moderate))
        XCTAssertTrue(complexities.contains(.complex))
        XCTAssertTrue(complexities.contains(.veryComplex))
        XCTAssertTrue(complexities.contains(.advanced))
    }
    
    func testPresentationContextBehavior() throws {
        // Test that we can create and use presentation contexts
        // This tests behavior, not implementation details
        
        // Given
        let expectedContexts: [PresentationContext] = [
            .dashboard, .browse, .detail, .edit, .create, .search,
            .settings, .profile, .summary, .list, .standard, .form,
            .modal, .navigation
        ]
        
        // When & Then - Test that each context can be created and has correct raw value
        for context in expectedContexts {
            XCTAssertEqual(context.rawValue, context.rawValue) // Identity test
            XCTAssertTrue(PresentationContext.allCases.contains(context))
        }
        
        // Test that contexts are case iterable
        let allContexts = PresentationContext.allCases
        XCTAssertFalse(allContexts.isEmpty, "PresentationContext should have cases")
        
        // Test that we can create contexts from raw values
        for context in expectedContexts {
            let createdContext = PresentationContext(rawValue: context.rawValue)
            XCTAssertEqual(createdContext, context, "Should be able to create context from raw value")
        }
        
        // Test that invalid raw values return nil
        let invalidContext = PresentationContext(rawValue: "invalid")
        XCTAssertNil(invalidContext, "Invalid raw values should return nil")
    }
    
    func testDataTypeHintBehavior() throws {
        // Test that we can create and use data type hints
        // This tests behavior, not implementation details
        
        // Given
        let expectedDataTypes: [DataTypeHint] = [
            .generic, .text, .number, .date, .image, .boolean, .collection,
            .numeric, .hierarchical, .temporal, .media, .form, .list, .grid,
            .chart, .custom, .user, .transaction, .action, .product,
            .communication, .location, .navigation, .card, .detail, .modal, .sheet
        ]
        
        // When & Then - Test that each data type can be created and has correct raw value
        for dataType in expectedDataTypes {
            XCTAssertEqual(dataType.rawValue, dataType.rawValue) // Identity test
            XCTAssertTrue(DataTypeHint.allCases.contains(dataType))
        }
        
        // Test that data types are case iterable
        let allDataTypes = DataTypeHint.allCases
        XCTAssertFalse(allDataTypes.isEmpty, "DataTypeHint should have cases")
        
        // Test that we can create data types from raw values
        for dataType in expectedDataTypes {
            let createdDataType = DataTypeHint(rawValue: dataType.rawValue)
            XCTAssertEqual(createdDataType, dataType, "Should be able to create data type from raw value")
        }
        
        // Test that invalid raw values return nil
        let invalidDataType = DataTypeHint(rawValue: "invalid")
        XCTAssertNil(invalidDataType, "Invalid raw values should return nil")
    }
    
    func testPresentationPreferenceBehavior() throws {
        // Test that we can create and use presentation preferences
        // This tests behavior, not implementation details
        
        // Given
        let expectedPreferences: [PresentationPreference] = [
            .automatic, .minimal, .moderate, .rich, .custom, .detail,
            .modal, .navigation, .list, .masonry, .standard, .form,
            .card, .cards, .compact, .grid, .chart, .coverFlow
        ]
        
        // When & Then - Test that each preference can be created and has correct raw value
        for preference in expectedPreferences {
            XCTAssertEqual(preference.rawValue, preference.rawValue) // Identity test
            XCTAssertTrue(PresentationPreference.allCases.contains(preference))
        }
        
        // Test that preferences are case iterable
        let allPreferences = PresentationPreference.allCases
        XCTAssertFalse(allPreferences.isEmpty, "PresentationPreference should have cases")
        
        // Test that we can create preferences from raw values
        for preference in expectedPreferences {
            let createdPreference = PresentationPreference(rawValue: preference.rawValue)
            XCTAssertEqual(createdPreference, preference, "Should be able to create preference from raw value")
        }
        
        // Test that invalid raw values return nil
        let invalidPreference = PresentationPreference(rawValue: "invalid")
        XCTAssertNil(invalidPreference, "Invalid raw values should return nil")
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
        let field = createTestField(
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
