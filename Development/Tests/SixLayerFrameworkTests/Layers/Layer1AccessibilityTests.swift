import Testing


import SwiftUI
@testable import SixLayerFramework
/// Layer 1 Accessibility Tests
/// 
/// BUSINESS PURPOSE: Test that Layer 1 functions generate proper accessibility identifiers
/// TESTING SCOPE: All Layer 1 presentation functions
/// METHODOLOGY: TDD Red Phase - tests should fail until accessibility identifiers are implemented
@Suite("Layer Accessibility")
@MainActor
open class Layer1AccessibilityTests {
    
    // MARK: - Helper Methods
    
    public func createTestItems() -> [Layer1TestItem] {
        return [
            Layer1TestItem(id: "user-1", title: "Alice", subtitle: "Developer"),
            Layer1TestItem(id: "user-2", title: "Bob", subtitle: "Designer")
        ]
    }
    
    public func createTestHints() -> PresentationHints {
        return PresentationHints(
            dataType: .generic,
            presentationPreference: .grid,
            complexity: .moderate,
            context: .list,
            customPreferences: [:]
        )
    }    // MARK: - Layer 1 Function Tests
    
    /// TDD RED PHASE: platformPresentItemCollection_L1 should generate accessibility identifiers
    /// THIS TEST SHOULD FAIL - proving that accessibility identifiers aren't actually generated
    @Test func testPlatformPresentItemCollectionL1GeneratesAccessibilityIdentifiers() async {
        // Given: Automatic IDs enabled
        AccessibilityIdentifierConfig.shared.enableAutoIDs = true
        
        // Create test data locally
        let testItems = createTestItems()
        let testHints = createTestHints()
        
        // When: Creating view using platformPresentItemCollection_L1
        let view = platformPresentItemCollection_L1(
            items: testItems,
            hints: testHints
        )
        
        // Then: View should be created
        // view is a non-optional View, so it exists if we reach here
        
        // TDD RED PHASE: Test accessibility identifiers across both platforms
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasSpecificAccessibilityID = testAccessibilityIdentifiersCrossPlatform(
            view, 
            expectedPattern: "*.main.ui.element.*", 
            componentName: "ItemCollection",
            testName: "platformPresentItemCollection_L1"
        )
 #expect(hasSpecificAccessibilityID, "platformPresentItemCollection_L1 should generate accessibility identifiers with current pattern ")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
        
        print("🔍 Testing platformPresentItemCollection_L1 accessibility identifier generation")
    }
    
    /// Test platformPresentItemCollection_L1 with EnhancedPresentationHints variant
    @Test func testPlatformPresentItemCollectionL1WithEnhancedHintsGeneratesAccessibilityIdentifiers() async {
        AccessibilityIdentifierConfig.shared.enableAutoIDs = true
        
        let testItems = createTestItems()
        let enhancedHints = EnhancedPresentationHints(
            dataType: .generic,
            presentationPreference: .automatic,
            complexity: .moderate,
            context: .list,
            customPreferences: [:],
            extensibleHints: []
        )
        
        let view = platformPresentItemCollection_L1(
            items: testItems,
            hints: enhancedHints
        )
        
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view, 
            expectedPattern: "SixLayer.*ui", 
            platform: SixLayerPlatform.iOS,
            componentName: "platformPresentItemCollection_L1"
        )
 #expect(hasAccessibilityID, "platformPresentItemCollection_L1 with EnhancedPresentationHints should generate accessibility identifiers ")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }
    
    /// Test platformPresentItemCollection_L1 with custom view variant
    @Test func testPlatformPresentItemCollectionL1WithCustomViewGeneratesAccessibilityIdentifiers() async {
        AccessibilityIdentifierConfig.shared.enableAutoIDs = true
        
        let testItems = createTestItems()
        let testHints = createTestHints()
        
        let view = platformPresentItemCollection_L1(
            items: testItems,
            hints: testHints,
            customItemView: { item in
                VStack {
                    Text(item.title)
                    Text(item.subtitle)
                }
            }
        )
        
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view, 
            expectedPattern: "SixLayer.*ui", 
            platform: SixLayerPlatform.iOS,
            componentName: "platformPresentItemCollection_L1"
        )
 #expect(hasAccessibilityID, "platformPresentItemCollection_L1 with custom view should generate accessibility identifiers ")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }
    
    /// Test platformPresentItemCollection_L1 with enhanced hints and custom view variant
    @Test func testPlatformPresentItemCollectionL1WithEnhancedHintsAndCustomViewGeneratesAccessibilityIdentifiers() async {
        AccessibilityIdentifierConfig.shared.enableAutoIDs = true
        
        let testItems = createTestItems()
        let enhancedHints = EnhancedPresentationHints(
            dataType: .generic,
            presentationPreference: .automatic,
            complexity: .moderate,
            context: .list,
            customPreferences: [:],
            extensibleHints: []
        )
        
        let view = platformPresentItemCollection_L1(
            items: testItems,
            hints: enhancedHints,
            customItemView: { item in
                VStack {
                    Text(item.title)
                    Text(item.subtitle)
                }
            }
        )
        
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view, 
            expectedPattern: "SixLayer.*ui", 
            platform: SixLayerPlatform.iOS,
            componentName: "platformPresentItemCollection_L1"
        )
 #expect(hasAccessibilityID, "platformPresentItemCollection_L1 with enhanced hints and custom view should generate accessibility identifiers ")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }
    
    /// Test platformPresentItemCollection_L1 with all custom views variant
    @Test func testPlatformPresentItemCollectionL1WithAllCustomViewsGeneratesAccessibilityIdentifiers() async {
        AccessibilityIdentifierConfig.shared.enableAutoIDs = true
        
        let testItems = createTestItems()
        let testHints = createTestHints()
        
        let view = platformPresentItemCollection_L1(
            items: testItems,
            hints: testHints,
            customItemView: { item in
                VStack {
                    Text(item.title)
                    Text(item.subtitle)
                }
            },
            customCreateView: {
                Text("Create")
            },
            customEditView: { item in
                Text("Edit \(item.title)")
            }
        )
        
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view, 
            expectedPattern: "SixLayer.*ui", 
            platform: SixLayerPlatform.iOS,
            componentName: "platformPresentItemCollection_L1"
        )
 #expect(hasAccessibilityID, "platformPresentItemCollection_L1 with all custom views should generate accessibility identifiers ")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }
    
    /// Test platformPresentFormData_L1 single-field variant (delegates to array version)
    @Test func testPlatformPresentFormDataL1SingleFieldGeneratesAccessibilityIdentifiers() async {
        AccessibilityIdentifierConfig.shared.enableAutoIDs = true
        
        let view = platformPresentFormData_L1(
            field: DynamicFormField(id: "test", contentType: .text, label: "Test Field"),
            hints: PresentationHints()
        )
        
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view, 
            expectedPattern: "SixLayer.*ui", 
            platform: SixLayerPlatform.iOS,
            componentName: "platformPresentFormData_L1"
        )
 #expect(hasAccessibilityID, "platformPresentFormData_L1 single-field variant should generate accessibility identifiers ")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }
    
    /// TDD RED PHASE: platformPresentFormData_L1 should generate accessibility identifiers
    /// THIS TEST SHOULD FAIL - proving that accessibility identifiers aren't actually generated
    @Test func testPlatformPresentFormDataL1GeneratesAccessibilityIdentifiers() async {
        // Given: Automatic IDs enabled
        AccessibilityIdentifierConfig.shared.enableAutoIDs = true
        
        // When: Creating view using platformPresentFormData_L1
        let view = platformPresentFormData_L1(
            field: DynamicFormField(id: "test", contentType: .text, label: "Test Field"),
            hints: PresentationHints()
        )
        
        // Then: View should be created
        // view is a non-optional View, so it exists if we reach here
        
        // TDD RED PHASE: Test accessibility identifiers across both platforms (platform-dependent behavior)
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasSpecificAccessibilityID = testAccessibilityIdentifiersCrossPlatform(
            view, 
            expectedPattern: "*.main.ui.element.*", 
            componentName: "FormField",
            testName: "platformPresentFormData_L1"
        )
 #expect(hasSpecificAccessibilityID, "platformPresentFormData_L1 should generate accessibility identifiers with new hierarchical naming ")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
        
        print("🔍 Testing platformPresentFormData_L1 accessibility identifier generation")
    }
    
    /// TDD RED PHASE: platformPresentNumericData_L1 should generate accessibility identifiers
    /// THIS TEST SHOULD FAIL - proving that accessibility identifiers aren't actually generated
    @Test func testPlatformPresentNumericDataL1GeneratesAccessibilityIdentifiers() async {
        // Given: Automatic IDs enabled
        AccessibilityIdentifierConfig.shared.enableAutoIDs = true
        
        // When: Creating view using platformPresentNumericData_L1
        let view = platformPresentNumericData_L1(
            data: GenericNumericData(value: 123.45, label: "Test Value", unit: "units"),
            hints: PresentationHints()
        )
        
        // Then: View should be created
        // view is a non-optional View, so it exists if we reach here
        
        // TDD RED PHASE: Test accessibility identifiers (representative sampling on iOS)
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasSpecificAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view, 
            expectedPattern: "*.main.ui.element.*", 
            platform: SixLayerPlatform.iOS,
            componentName: "NumericData"
        )
 #expect(hasSpecificAccessibilityID, "platformPresentNumericData_L1 should generate accessibility identifiers with current pattern ")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
        
        print("🔍 Testing platformPresentNumericData_L1 accessibility identifier generation")
    }
    
    /// Test platformPresentNumericData_L1 with EnhancedPresentationHints variant
    @Test func testPlatformPresentNumericDataL1WithEnhancedHintsGeneratesAccessibilityIdentifiers() async {
        AccessibilityIdentifierConfig.shared.enableAutoIDs = true
        
        let enhancedHints = EnhancedPresentationHints(
            dataType: .numeric,
            presentationPreference: .automatic,
            complexity: .moderate,
            context: .list,
            customPreferences: [:],
            extensibleHints: []
        )
        
        let view = platformPresentNumericData_L1(
            data: [GenericNumericData(value: 123.45, label: "Test Value", unit: "units")],
            hints: enhancedHints
        )
        
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view, 
            expectedPattern: "SixLayer.*ui", 
            platform: SixLayerPlatform.iOS,
            componentName: "platformPresentNumericData_L1"
        )
 #expect(hasAccessibilityID, "platformPresentNumericData_L1 with EnhancedPresentationHints should generate accessibility identifiers ")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }
    
    /// Test platformPresentNumericData_L1 with custom view variant
    @Test func testPlatformPresentNumericDataL1WithCustomViewGeneratesAccessibilityIdentifiers() async {
        AccessibilityIdentifierConfig.shared.enableAutoIDs = true
        
        let view = platformPresentNumericData_L1(
            data: [GenericNumericData(value: 123.45, label: "Test Value", unit: "units")],
            hints: PresentationHints(),
            customDataView: { data in
                VStack {
                    Text(data.label)
                    Text("\(data.value) \(data.unit)")
                }
            }
        )
        
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view, 
            expectedPattern: "SixLayer.*ui", 
            platform: SixLayerPlatform.iOS,
            componentName: "platformPresentNumericData_L1"
        )
 #expect(hasAccessibilityID, "platformPresentNumericData_L1 with custom view should generate accessibility identifiers ")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }
    
    /// Test platformPresentNumericData_L1 with enhanced hints and custom view variant
    @Test func testPlatformPresentNumericDataL1WithEnhancedHintsAndCustomViewGeneratesAccessibilityIdentifiers() async {
        AccessibilityIdentifierConfig.shared.enableAutoIDs = true
        
        let enhancedHints = EnhancedPresentationHints(
            dataType: .numeric,
            presentationPreference: .automatic,
            complexity: .moderate,
            context: .list,
            customPreferences: [:],
            extensibleHints: []
        )
        
        let view = platformPresentNumericData_L1(
            data: [GenericNumericData(value: 123.45, label: "Test Value", unit: "units")],
            hints: enhancedHints,
            customDataView: { data in
                VStack {
                    Text(data.label)
                    Text("\(data.value) \(data.unit)")
                }
            }
        )
        
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view, 
            expectedPattern: "SixLayer.*ui", 
            platform: SixLayerPlatform.iOS,
            componentName: "platformPresentNumericData_L1"
        )
 #expect(hasAccessibilityID, "platformPresentNumericData_L1 with enhanced hints and custom view should generate accessibility identifiers ")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }
    
    /// Test platformPresentNumericData_L1 single-item variant (delegates to array version)
    @Test func testPlatformPresentNumericDataL1SingleItemGeneratesAccessibilityIdentifiers() async {
        AccessibilityIdentifierConfig.shared.enableAutoIDs = true
        
        let view = platformPresentNumericData_L1(
            data: GenericNumericData(value: 123.45, label: "Test Value", unit: "units"),
            hints: PresentationHints()
        )
        
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view, 
            expectedPattern: "SixLayer.*ui", 
            platform: SixLayerPlatform.iOS,
            componentName: "platformPresentNumericData_L1"
        )
 #expect(hasAccessibilityID, "platformPresentNumericData_L1 single-item variant should generate accessibility identifiers ")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }
    
    /// BUSINESS PURPOSE: Validates that platformPresentMediaData_L1 generates proper accessibility identifiers
    /// TESTING SCOPE: Verify accessibility identifier generation
    /// METHODOLOGY: Test that accessibility identifiers are properly generated
    @Test func testPlatformPresentMediaDataL1GeneratesAccessibilityIdentifiers() async {
        // Given: Automatic IDs enabled
        AccessibilityIdentifierConfig.shared.enableAutoIDs = true
        
        // When: Creating view using platformPresentMediaData_L1
        let view = platformPresentMediaData_L1(
            media: GenericMediaItem(title: "Test Media", url: "https://example.com"),
            hints: PresentationHints()
        )
        
        // Then: View should be created
        // view is a non-optional View, so it exists if we reach here
        
        // TDD GREEN PHASE: platformPresentMediaData_L1 should generate accessibility identifiers
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasSpecificAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view, 
            expectedPattern: "SixLayer.*ui", 
            platform: SixLayerPlatform.iOS,
            componentName: "platformPresentMediaData_L1"
        )
 #expect(hasSpecificAccessibilityID, "platformPresentMediaData_L1 should generate accessibility identifiers ")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
        
    }
    
    /// Test platformPresentMediaData_L1 with EnhancedPresentationHints variant
    @Test func testPlatformPresentMediaDataL1WithEnhancedHintsGeneratesAccessibilityIdentifiers() async {
        AccessibilityIdentifierConfig.shared.enableAutoIDs = true
        
        let enhancedHints = EnhancedPresentationHints(
            dataType: .media,
            presentationPreference: .automatic,
            complexity: .moderate,
            context: .list,
            customPreferences: [:],
            extensibleHints: []
        )
        
        let view = platformPresentMediaData_L1(
            media: GenericMediaItem(title: "Test Media", url: "https://example.com"),
            hints: enhancedHints
        )
        
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view, 
            expectedPattern: "SixLayer.*ui", 
            platform: SixLayerPlatform.iOS,
            componentName: "platformPresentMediaData_L1"
        )
 #expect(hasAccessibilityID, "platformPresentMediaData_L1 with EnhancedPresentationHints should generate accessibility identifiers ")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }
    
    /// Test platformPresentMediaData_L1 with custom view variant
    @Test func testPlatformPresentMediaDataL1WithCustomViewGeneratesAccessibilityIdentifiers() async {
        AccessibilityIdentifierConfig.shared.enableAutoIDs = true
        
        let view = platformPresentMediaData_L1(
            media: GenericMediaItem(title: "Test Media", url: "https://example.com"),
            hints: PresentationHints(),
            customMediaView: { media in
                VStack {
                    Text(media.title)
                    Text(media.url ?? "")
                }
            }
        )
        
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view, 
            expectedPattern: "SixLayer.*ui", 
            platform: SixLayerPlatform.iOS,
            componentName: "platformPresentMediaData_L1"
        )
 #expect(hasAccessibilityID, "platformPresentMediaData_L1 with custom view should generate accessibility identifiers ")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }
    
    /// Test platformPresentMediaData_L1 with enhanced hints and custom view variant
    @Test func testPlatformPresentMediaDataL1WithEnhancedHintsAndCustomViewGeneratesAccessibilityIdentifiers() async {
        AccessibilityIdentifierConfig.shared.enableAutoIDs = true
        
        let enhancedHints = EnhancedPresentationHints(
            dataType: .media,
            presentationPreference: .automatic,
            complexity: .moderate,
            context: .list,
            customPreferences: [:],
            extensibleHints: []
        )
        
        let view = platformPresentMediaData_L1(
            media: GenericMediaItem(title: "Test Media", url: "https://example.com"),
            hints: enhancedHints,
            customMediaView: { media in
                VStack {
                    Text(media.title)
                    Text(media.url ?? "")
                }
            }
        )
        
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view, 
            expectedPattern: "SixLayer.*ui", 
            platform: SixLayerPlatform.iOS,
            componentName: "platformPresentMediaData_L1"
        )
 #expect(hasAccessibilityID, "platformPresentMediaData_L1 with enhanced hints and custom view should generate accessibility identifiers ")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }
    
    /// Test platformPresentMediaData_L1 single-item variant (delegates to array version)
    @Test func testPlatformPresentMediaDataL1SingleItemGeneratesAccessibilityIdentifiers() async {
        AccessibilityIdentifierConfig.shared.enableAutoIDs = true
        
        let view = platformPresentMediaData_L1(
            media: GenericMediaItem(title: "Test Media", url: "https://example.com"),
            hints: PresentationHints()
        )
        
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view, 
            expectedPattern: "SixLayer.*ui", 
            platform: SixLayerPlatform.iOS,
            componentName: "platformPresentMediaData_L1"
        )
 #expect(hasAccessibilityID, "platformPresentMediaData_L1 single-item variant should generate accessibility identifiers ")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }
    
    /// BUSINESS PURPOSE: Validates that platformPresentSettings_L1 generates proper accessibility identifiers
    /// TESTING SCOPE: Verify accessibility identifier generation
    /// METHODOLOGY: Test that accessibility identifiers are properly generated
    @Test func testPlatformPresentSettingsL1GeneratesAccessibilityIdentifiers() async {
        // Given: Automatic IDs enabled
        AccessibilityIdentifierConfig.shared.enableAutoIDs = true
        
        // When: Creating view using platformPresentSettings_L1
        let view = platformPresentSettings_L1(
            settings: [
                SettingsSectionData(
                    title: "General",
                    items: [
                        SettingsItemData(key: "theme", title: "Theme", type: .toggle, value: "dark"),
                        SettingsItemData(key: "notifications", title: "Notifications", type: .toggle, value: "enabled")
                    ]
                )
            ],
            hints: PresentationHints()
        )
        
        // Then: View should be created (view is non-optional, so this just documents the expectation)
        // #expect(Bool(true), "platformPresentSettings_L1 should create a view")  // view is non-optional
        
        // TDD GREEN PHASE: platformPresentSettings_L1 should generate accessibility identifiers
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasSpecificAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view, 
            expectedPattern: "SixLayer.*ui", 
            platform: SixLayerPlatform.iOS,
            componentName: "platformPresentSettings_L1"
        )
 #expect(hasSpecificAccessibilityID, "platformPresentSettings_L1 should generate accessibility identifiers ")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
        
    }
    
    /// Test platformPresentSettings_L1 with custom view variant
    @Test func testPlatformPresentSettingsL1WithCustomViewGeneratesAccessibilityIdentifiers() async {
        AccessibilityIdentifierConfig.shared.enableAutoIDs = true
        
        let view = platformPresentSettings_L1(
            settings: [
                SettingsSectionData(
                    title: "General",
                    items: [
                        SettingsItemData(key: "theme", title: "Theme", type: .toggle, value: "dark")
                    ]
                )
            ],
            hints: PresentationHints(),
            customSettingView: { section in
                VStack {
                    Text(section.title)
                    ForEach(section.items, id: \.key) { item in
                        Text(item.title)
                    }
                }
            }
        )
        
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view, 
            expectedPattern: "SixLayer.*ui", 
            platform: SixLayerPlatform.iOS,
            componentName: "platformPresentSettings_L1"
        )
 #expect(hasAccessibilityID, "platformPresentSettings_L1 with custom view should generate accessibility identifiers ")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }
    
    /// Test platformPresentSettings_L1 with enhanced hints and custom view variant
    @Test func testPlatformPresentSettingsL1WithEnhancedHintsAndCustomViewGeneratesAccessibilityIdentifiers() async {
        AccessibilityIdentifierConfig.shared.enableAutoIDs = true
        
        let enhancedHints = EnhancedPresentationHints(
            dataType: .generic,
            presentationPreference: .automatic,
            complexity: .moderate,
            context: .list,
            customPreferences: [:],
            extensibleHints: []
        )
        
        let view = platformPresentSettings_L1(
            settings: [
                SettingsSectionData(
                    title: "General",
                    items: [
                        SettingsItemData(key: "theme", title: "Theme", type: .toggle, value: "dark")
                    ]
                )
            ],
            hints: enhancedHints,
            customSettingView: { section in
                VStack {
                    Text(section.title)
                    ForEach(section.items, id: \.key) { item in
                        Text(item.title)
                    }
                }
            }
        )
        
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view, 
            expectedPattern: "SixLayer.*ui", 
            platform: SixLayerPlatform.iOS,
            componentName: "platformPresentSettings_L1"
        )
 #expect(hasAccessibilityID, "platformPresentSettings_L1 with enhanced hints and custom view should generate accessibility identifiers ")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }
}

// MARK: - Test Support Types

public struct Layer1TestItem: Identifiable {
    public let id: String
    let title: String
    let subtitle: String
}
