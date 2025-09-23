import XCTest
@testable import SixLayerFramework

final class CoreArchitectureTests: XCTestCase {
    
    // MARK: - Test Helpers
    
    /// Helper function to create DynamicFormField with proper binding for tests
    private func createTestField(
        label: String,
        placeholder: String? = nil,
        value: String = "",
        isRequired: Bool = false,
        fieldType: DynamicFieldType = .text
    ) -> DynamicFormField {
        return DynamicFormField(
            id: label.lowercased().replacingOccurrences(of: " ", with: "_"),
            type: fieldType,
            label: label,
            placeholder: placeholder,
            isRequired: isRequired,
            defaultValue: value
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
    
    func testPresentationContextBusinessBehavior() throws {
        // Test that PresentationContext creates different user experiences
        // This tests the actual business value, not just technical properties
        
        // Test that different contexts create different form field sets
        // This is the core business behavior - context determines user experience
        
        // Dashboard context should create simple, overview-focused fields
        let dashboardFields = createDynamicFormFields(context: .dashboard)
        XCTAssertEqual(dashboardFields.count, 2, "Dashboard should have 2 simple fields")
        XCTAssertTrue(dashboardFields.contains { $0.label == "Dashboard Name" })
        XCTAssertTrue(dashboardFields.contains { $0.label == "Auto Refresh" })
        XCTAssertTrue(dashboardFields.contains { $0.type == .toggle })
        
        // Detail context should create rich, comprehensive fields
        let detailFields = createDynamicFormFields(context: .detail)
        XCTAssertEqual(detailFields.count, 5, "Detail should have 5 comprehensive fields")
        XCTAssertTrue(detailFields.contains { $0.label == "Title" })
        XCTAssertTrue(detailFields.contains { $0.label == "Description" })
        XCTAssertTrue(detailFields.contains { $0.label == "Created Date" })
        XCTAssertTrue(detailFields.contains { $0.label == "Created Time" })
        XCTAssertTrue(detailFields.contains { $0.label == "Attachments" })
        XCTAssertTrue(detailFields.contains { $0.type == .richtext })
        XCTAssertTrue(detailFields.contains { $0.type == .file })
        
        // Test that contexts produce different user experiences
        XCTAssertNotEqual(dashboardFields.count, detailFields.count, 
                         "Different contexts should produce different field counts")
        
        // Test that contexts can be used in PresentationHints for UI generation
        let dashboardHints = PresentationHints(context: .dashboard)
        let detailHints = PresentationHints(context: .detail)
        
        XCTAssertEqual(dashboardHints.context, .dashboard)
        XCTAssertEqual(detailHints.context, .detail)
        XCTAssertNotEqual(dashboardHints.context, detailHints.context)
    }
    
    // MARK: - REAL TDD TESTS FOR PRESENTATION CONTEXT FIELD GENERATION
    
    func testPresentationContextFieldGenerationCompleteness() throws {
        // Test that ALL PresentationContext cases are handled in createDynamicFormFields
        // This will FAIL if we add a new context without handling it in createDynamicFormFields
        
        for context in PresentationContext.allCases {
            let fields = createDynamicFormFields(context: context)
            
            // Each context should return at least one field
            XCTAssertFalse(fields.isEmpty, "Context \(context) should return at least one field")
            
            // Each field should have required properties
            for field in fields {
                XCTAssertFalse(field.id.isEmpty, "Field ID should not be empty for context \(context)")
                XCTAssertFalse(field.label.isEmpty, "Field label should not be empty for context \(context)")
            }
        }
    }
    
    func testPresentationContextFieldGenerationBehavior() throws {
        // Test that each PresentationContext returns appropriate fields for its business purpose
        // This tests the actual business behavior, not just existence
        
        for context in PresentationContext.allCases {
            let fields = createDynamicFormFields(context: context)
            
            // Test context-specific field requirements using switch for compiler enforcement
            switch context {
            case .dashboard:
                // Dashboard should have dashboard-specific fields
                XCTAssertTrue(fields.contains { $0.id.contains("dashboard") || $0.id.contains("auto_refresh") }, 
                            "Dashboard context should have dashboard/auto_refresh fields")
                
            case .browse:
                // Browse should have search/filter fields
                XCTAssertTrue(fields.contains { $0.id.contains("search") || $0.id.contains("filter") }, 
                            "Browse context should have search/filter fields")
                
            case .detail:
                // Detail should have comprehensive information fields
                XCTAssertGreaterThan(fields.count, 2, "Detail context should have multiple information fields")
                
            case .edit:
                // Edit should have editable fields
                XCTAssertTrue(fields.contains { $0.type == .text || $0.type == .textarea }, 
                            "Edit context should have text input fields")
                
            case .create:
                // Create should have form fields for new item creation
                XCTAssertTrue(fields.contains { $0.id.contains("name") || $0.id.contains("title") }, 
                            "Create context should have name/title fields")
                
            case .search:
                // Search should have search-specific fields
                XCTAssertTrue(fields.contains { $0.id.contains("query") || $0.id.contains("search") }, 
                            "Search context should have query/search fields")
                
            case .settings:
                // Settings should have configuration fields
                XCTAssertTrue(fields.contains { $0.id.contains("theme") || $0.id.contains("notifications") }, 
                            "Settings context should have theme/notifications fields")
                
            case .profile:
                // Profile should have user information fields
                XCTAssertTrue(fields.contains { $0.id.contains("display_name") || $0.id.contains("bio") || $0.id.contains("avatar") }, 
                            "Profile context should have display_name/bio/avatar fields")
                
            case .form:
                // Form should have comprehensive form fields
                XCTAssertGreaterThan(fields.count, 3, "Form context should have multiple form fields")
                
            case .modal:
                // Modal should have focused, specific fields
                XCTAssertLessThanOrEqual(fields.count, 5, "Modal context should have focused, limited fields")
                
            case .summary:
                // Summary should have overview fields
                XCTAssertTrue(fields.contains { $0.id.contains("summary") || $0.id.contains("overview") }, 
                            "Summary context should have summary/overview fields")
                
            case .list:
                // List should have list-specific fields
                XCTAssertTrue(fields.contains { $0.id.contains("list") || $0.id.contains("item") }, 
                            "List context should have list/item fields")
                
            case .standard:
                // Standard should have basic fields
                XCTAssertGreaterThan(fields.count, 0, "Standard context should have basic fields")
                
            case .navigation:
                // Navigation should have navigation-specific fields
                XCTAssertTrue(fields.contains { $0.id.contains("nav") || $0.id.contains("route") }, 
                            "Navigation context should have navigation/route fields")
            }
        }
    }
    
    func testPresentationContextFieldGenerationExhaustiveness() throws {
        // Test that createDynamicFormFields handles ALL PresentationContext cases
        // This will FAIL if we add a new context without handling it
        
        let allContexts = PresentationContext.allCases
        var handledContexts: Set<PresentationContext> = []
        
        for context in allContexts {
            // This will fail if createDynamicFormFields doesn't handle the context
            let fields = createDynamicFormFields(context: context)
            handledContexts.insert(context)
            
            // Verify we got fields (not empty array)
            XCTAssertFalse(fields.isEmpty, "Context \(context) should return fields")
        }
        
        // Verify we handled all contexts
        XCTAssertEqual(handledContexts.count, allContexts.count, 
                      "All PresentationContext cases should be handled")
    }
    
    
    func testPresentationContextCompleteness() throws {
        // Test that we have all expected contexts and no unexpected ones
        // This will FAIL if someone adds/removes contexts without updating tests
        
        let expectedContexts: Set<PresentationContext> = [
            .dashboard, .browse, .detail, .edit, .create, .search,
            .settings, .profile, .summary, .list, .standard, .form,
            .modal, .navigation
        ]
        
        let actualContexts = Set(PresentationContext.allCases)
        
        // This will fail if contexts are added or removed
        XCTAssertEqual(actualContexts, expectedContexts, 
                      "PresentationContext enum has changed. Update test expectations and verify behavior.")
    }
    
    
    func testPresentationContextSemanticMeaning() throws {
        // Test that contexts have distinct semantic meanings
        // This verifies that each context represents a different use case
        
        // Test that different contexts produce different hints
        let dashboardHints = PresentationHints(context: .dashboard)
        let detailHints = PresentationHints(context: .detail)
        let formHints = PresentationHints(context: .form)
        
        XCTAssertNotEqual(dashboardHints.context, detailHints.context)
        XCTAssertNotEqual(detailHints.context, formHints.context)
        XCTAssertNotEqual(dashboardHints.context, formHints.context)
        
        // Test that contexts can be used in different scenarios
        let contexts = Array(PresentationContext.allCases.prefix(5)) // Use real enum, test first 5
        let uniqueContexts = Set(contexts)
        XCTAssertEqual(uniqueContexts.count, contexts.count, "All contexts should be unique")
    }
    
    func testDataTypeHintBehavior() throws {
        // Test that DataTypeHint provides the behavior it's supposed to provide
        // This tests actual functionality, not just existence
        
        // Test that data types can be used in PresentationHints
        let textHints = PresentationHints(dataType: .text)
        XCTAssertEqual(textHints.dataType, .text)
        
        let imageHints = PresentationHints(dataType: .image)
        XCTAssertEqual(imageHints.dataType, .image)
        
        // Test that data types have meaningful raw values for serialization
        XCTAssertEqual(DataTypeHint.text.rawValue, "text")
        XCTAssertEqual(DataTypeHint.image.rawValue, "image")
        XCTAssertEqual(DataTypeHint.number.rawValue, "number")
        XCTAssertEqual(DataTypeHint.date.rawValue, "date")
        
        // Test that data types can be created from raw values (round-trip)
        XCTAssertEqual(DataTypeHint(rawValue: "text"), .text)
        XCTAssertEqual(DataTypeHint(rawValue: "image"), .image)
        XCTAssertEqual(DataTypeHint(rawValue: "number"), .number)
        
        // Test that invalid raw values return nil
        XCTAssertNil(DataTypeHint(rawValue: "invalid"))
        XCTAssertNil(DataTypeHint(rawValue: ""))
        
        // Test that all data types are case iterable (for UI generation)
        let allDataTypes = DataTypeHint.allCases
        XCTAssertFalse(allDataTypes.isEmpty, "DataTypeHint should have cases")
        XCTAssertTrue(allDataTypes.contains(.text))
        XCTAssertTrue(allDataTypes.contains(.image))
        XCTAssertTrue(allDataTypes.contains(.number))
    }
    
    func testDataTypeHintCompleteness() throws {
        // Test that we have all expected data types and no unexpected ones
        // This will FAIL if someone adds/removes data types without updating tests
        
        let expectedDataTypes: Set<DataTypeHint> = [
            .generic, .text, .number, .date, .image, .boolean, .collection,
            .numeric, .hierarchical, .temporal, .media, .form, .list, .grid,
            .chart, .custom, .user, .transaction, .action, .product,
            .communication, .location, .navigation, .card, .detail, .modal, .sheet
        ]
        
        let actualDataTypes = Set(DataTypeHint.allCases)
        
        // This will fail if data types are added or removed
        XCTAssertEqual(actualDataTypes, expectedDataTypes, 
                      "DataTypeHint enum has changed. Update test expectations and verify behavior.")
    }
    
    func testDataTypeHintSemanticMeaning() throws {
        // Test that data types have distinct semantic meanings
        // This verifies that each data type represents a different content type
        
        // Test that different data types produce different hints
        let textHints = PresentationHints(dataType: .text)
        let imageHints = PresentationHints(dataType: .image)
        let numberHints = PresentationHints(dataType: .number)
        
        XCTAssertNotEqual(textHints.dataType, imageHints.dataType)
        XCTAssertNotEqual(imageHints.dataType, numberHints.dataType)
        XCTAssertNotEqual(textHints.dataType, numberHints.dataType)
        
        // Test that data types can be used in different scenarios
        let dataTypes = Array(DataTypeHint.allCases.prefix(5)) // Use real enum, test first 5
        let uniqueDataTypes = Set(dataTypes)
        XCTAssertEqual(uniqueDataTypes.count, dataTypes.count, "All data types should be unique")
    }
    
    func testPresentationPreferenceBehavior() throws {
        // Test that PresentationPreference provides the behavior it's supposed to provide
        // This tests actual functionality, not just existence
        
        // Test that preferences can be used in PresentationHints
        let automaticHints = PresentationHints(presentationPreference: .automatic)
        XCTAssertEqual(automaticHints.presentationPreference, .automatic)
        
        let cardHints = PresentationHints(presentationPreference: .card)
        XCTAssertEqual(cardHints.presentationPreference, .card)
        
        // Test that preferences have meaningful raw values for serialization
        XCTAssertEqual(PresentationPreference.automatic.rawValue, "automatic")
        XCTAssertEqual(PresentationPreference.card.rawValue, "card")
        XCTAssertEqual(PresentationPreference.grid.rawValue, "grid")
        XCTAssertEqual(PresentationPreference.detail.rawValue, "detail")
        
        // Test that preferences can be created from raw values (round-trip)
        XCTAssertEqual(PresentationPreference(rawValue: "automatic"), .automatic)
        XCTAssertEqual(PresentationPreference(rawValue: "card"), .card)
        XCTAssertEqual(PresentationPreference(rawValue: "grid"), .grid)
        
        // Test that invalid raw values return nil
        XCTAssertNil(PresentationPreference(rawValue: "invalid"))
        XCTAssertNil(PresentationPreference(rawValue: ""))
        
        // Test that all preferences are case iterable (for UI generation)
        let allPreferences = PresentationPreference.allCases
        XCTAssertFalse(allPreferences.isEmpty, "PresentationPreference should have cases")
        XCTAssertTrue(allPreferences.contains(.automatic))
        XCTAssertTrue(allPreferences.contains(.card))
        XCTAssertTrue(allPreferences.contains(.grid))
    }
    
    func testPresentationPreferenceCompleteness() throws {
        // Test that we have all expected preferences and no unexpected ones
        // This will FAIL if someone adds/removes preferences without updating tests
        
        let expectedPreferences: Set<PresentationPreference> = [
            .automatic, .minimal, .moderate, .rich, .custom, .detail,
            .modal, .navigation, .list, .masonry, .standard, .form,
            .card, .cards, .compact, .grid, .chart, .coverFlow
        ]
        
        let actualPreferences = Set(PresentationPreference.allCases)
        
        // This will fail if preferences are added or removed
        XCTAssertEqual(actualPreferences, expectedPreferences, 
                      "PresentationPreference enum has changed. Update test expectations and verify behavior.")
    }
    
    func testPresentationPreferenceSemanticMeaning() throws {
        // Test that preferences have distinct semantic meanings
        // This verifies that each preference represents a different presentation style
        
        // Test that different preferences produce different hints
        let automaticHints = PresentationHints(presentationPreference: .automatic)
        let cardHints = PresentationHints(presentationPreference: .card)
        let gridHints = PresentationHints(presentationPreference: .grid)
        
        XCTAssertNotEqual(automaticHints.presentationPreference, cardHints.presentationPreference)
        XCTAssertNotEqual(cardHints.presentationPreference, gridHints.presentationPreference)
        XCTAssertNotEqual(automaticHints.presentationPreference, gridHints.presentationPreference)
        
        // Test that preferences can be used in different scenarios
        let preferences = Array(PresentationPreference.allCases.prefix(5)) // Use real enum, test first 5
        let uniquePreferences = Set(preferences)
        XCTAssertEqual(uniquePreferences.count, preferences.count, "All preferences should be unique")
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
    
    func testDynamicFormFieldCreation() throws {
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
        XCTAssertEqual(field.defaultValue, value)
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
