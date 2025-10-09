import XCTest
import SwiftUI
@testable import SixLayerFramework
import ViewInspector

/// Comprehensive Accessibility Tests for ALL SixLayer Components
/// 
/// BUSINESS PURPOSE: Ensure every SixLayer component generates proper accessibility identifiers
/// TESTING SCOPE: All public View components and functions in the framework
/// METHODOLOGY: Test each component on both iOS and macOS platforms as required by mandatory testing guidelines
@MainActor
final class AllComponentsAccessibilityTests: XCTestCase {
    
    // MARK: - Test Setup
    
    override func setUp() {
        super.setUp()
        setupTestEnvironment()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
        config.enableAutoIDs = true
        config.namespace = "SixLayer"
        config.mode = .automatic
        config.enableDebugLogging = false
    }
    
    override func tearDown() {
        super.tearDown()
        cleanupTestEnvironment()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
    }
    
    // MARK: - PlatformInteractionButton Tests
    
    func testPlatformInteractionButtonGeneratesAccessibilityIdentifiersOnIOS() async {
        let view = PlatformInteractionButton(style: .primary, action: {}) {
            Text("Test Button")
        }
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*platforminteractionbutton", 
            platform: .iOS,
            componentName: "PlatformInteractionButton"
        )
        
        XCTAssertTrue(hasAccessibilityID, "PlatformInteractionButton should generate accessibility identifiers on iOS")
    }
    
    func testPlatformInteractionButtonGeneratesAccessibilityIdentifiersOnMacOS() async {
        let view = PlatformInteractionButton(style: .primary, action: {}) {
            Text("Test Button")
        }
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*platforminteractionbutton", 
            platform: .macOS,
            componentName: "PlatformInteractionButton"
        )
        
        XCTAssertTrue(hasAccessibilityID, "PlatformInteractionButton should generate accessibility identifiers on macOS")
    }
    
    // MARK: - OCROverlayView Tests
    
    func testOCROverlayViewGeneratesAccessibilityIdentifiersOnIOS() async {
        let view = OCROverlayView(
            text: "Test OCR Text",
            confidence: 0.95,
            onTap: {}
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*ocroverlayview", 
            platform: .iOS,
            componentName: "OCROverlayView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "OCROverlayView should generate accessibility identifiers on iOS")
    }
    
    func testOCROverlayViewGeneratesAccessibilityIdentifiersOnMacOS() async {
        let view = OCROverlayView(
            text: "Test OCR Text",
            confidence: 0.95,
            onTap: {}
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*ocroverlayview", 
            platform: .macOS,
            componentName: "OCROverlayView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "OCROverlayView should generate accessibility identifiers on macOS")
    }
    
    // MARK: - ExpandableCardCollectionView Tests
    
    func testExpandableCardCollectionViewGeneratesAccessibilityIdentifiersOnIOS() async {
        let testItems = [
            ComponentTestItem(id: "item1", title: "Test Item 1"),
            ComponentTestItem(id: "item2", title: "Test Item 2")
        ]
        
        let view = ExpandableCardCollectionView(
            items: testItems,
            cardContent: { item in
                Text(item.title)
            }
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*expandablecardcollectionview", 
            platform: .iOS,
            componentName: "ExpandableCardCollectionView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "ExpandableCardCollectionView should generate accessibility identifiers on iOS")
    }
    
    func testExpandableCardCollectionViewGeneratesAccessibilityIdentifiersOnMacOS() async {
        let testItems = [
            ComponentTestItem(id: "item1", title: "Test Item 1"),
            ComponentTestItem(id: "item2", title: "Test Item 2")
        ]
        
        let view = ExpandableCardCollectionView(
            items: testItems,
            cardContent: { item in
                Text(item.title)
            }
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*expandablecardcollectionview", 
            platform: .macOS,
            componentName: "ExpandableCardCollectionView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "ExpandableCardCollectionView should generate accessibility identifiers on macOS")
    }
    
    // MARK: - GenericItemCollectionView Tests
    
    func testGenericItemCollectionViewGeneratesAccessibilityIdentifiersOnIOS() async {
        let testItems = [
            ComponentTestItem(id: "item1", title: "Test Item 1"),
            ComponentTestItem(id: "item2", title: "Test Item 2")
        ]
        let hints = PresentationHints(
            dataType: .generic,
            presentationPreference: .grid,
            complexity: .moderate,
            context: .list,
            customPreferences: [:]
        )
        
        let view = GenericItemCollectionView(
            items: testItems,
            hints: hints
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*genericitemcollectionview", 
            platform: .iOS,
            componentName: "GenericItemCollectionView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "GenericItemCollectionView should generate accessibility identifiers on iOS")
    }
    
    func testGenericItemCollectionViewGeneratesAccessibilityIdentifiersOnMacOS() async {
        let testItems = [
            ComponentTestItem(id: "item1", title: "Test Item 1"),
            ComponentTestItem(id: "item2", title: "Test Item 2")
        ]
        let hints = PresentationHints(
            dataType: .generic,
            presentationPreference: .grid,
            complexity: .moderate,
            context: .list,
            customPreferences: [:]
        )
        
        let view = GenericItemCollectionView(
            items: testItems,
            hints: hints
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*genericitemcollectionview", 
            platform: .macOS,
            componentName: "GenericItemCollectionView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "GenericItemCollectionView should generate accessibility identifiers on macOS")
    }
    
    // MARK: - GenericNumericDataView Tests
    
    func testGenericNumericDataViewGeneratesAccessibilityIdentifiersOnIOS() async {
        let testData = [
            GenericNumericData(value: 123.45, label: "Test Value 1", unit: "units"),
            GenericNumericData(value: 67.89, label: "Test Value 2", unit: "items")
        ]
        let hints = PresentationHints(
            dataType: .numeric,
            presentationPreference: .card,
            complexity: .moderate,
            context: .detail,
            customPreferences: [:]
        )
        
        let view = GenericNumericDataView(data: testData, hints: hints)
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*genericnumericdataview", 
            platform: .iOS,
            componentName: "GenericNumericDataView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "GenericNumericDataView should generate accessibility identifiers on iOS")
    }
    
    func testGenericNumericDataViewGeneratesAccessibilityIdentifiersOnMacOS() async {
        let testData = [
            GenericNumericData(value: 123.45, label: "Test Value 1", unit: "units"),
            GenericNumericData(value: 67.89, label: "Test Value 2", unit: "items")
        ]
        let hints = PresentationHints(
            dataType: .numeric,
            presentationPreference: .card,
            complexity: .moderate,
            context: .detail,
            customPreferences: [:]
        )
        
        let view = GenericNumericDataView(data: testData, hints: hints)
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*genericnumericdataview", 
            platform: .macOS,
            componentName: "GenericNumericDataView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "GenericNumericDataView should generate accessibility identifiers on macOS")
    }
    
    // MARK: - CustomNumericDataView Tests
    
    func testCustomNumericDataViewGeneratesAccessibilityIdentifiersOnIOS() async {
        let testData = [
            GenericNumericData(value: 123.45, label: "Test Value 1", unit: "units"),
            GenericNumericData(value: 67.89, label: "Test Value 2", unit: "items")
        ]
        let hints = PresentationHints(
            dataType: .numeric,
            presentationPreference: .card,
            complexity: .moderate,
            context: .detail,
            customPreferences: [:]
        )
        
        let view = CustomNumericDataView(
            data: testData,
            hints: hints,
            customDataView: { AnyView(Text("\($0.value)")) }
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*customnumericdataview", 
            platform: .iOS,
            componentName: "CustomNumericDataView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "CustomNumericDataView should generate accessibility identifiers on iOS")
    }
    
    func testCustomNumericDataViewGeneratesAccessibilityIdentifiersOnMacOS() async {
        let testData = [
            GenericNumericData(value: 123.45, label: "Test Value 1", unit: "units"),
            GenericNumericData(value: 67.89, label: "Test Value 2", unit: "items")
        ]
        let hints = PresentationHints(
            dataType: .numeric,
            presentationPreference: .card,
            complexity: .moderate,
            context: .detail,
            customPreferences: [:]
        )
        
        let view = CustomNumericDataView(
            data: testData,
            hints: hints,
            customDataView: { AnyView(Text("\($0.value)")) }
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*customnumericdataview", 
            platform: .macOS,
            componentName: "CustomNumericDataView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "CustomNumericDataView should generate accessibility identifiers on macOS")
    }
    
    // MARK: - ResponsiveCardView Tests
    
    func testResponsiveCardViewGeneratesAccessibilityIdentifiersOnIOS() async {
        let testData = ResponsiveCardData(
            title: "Test Card",
            subtitle: "Test Subtitle",
            icon: "doc.text",
            color: .blue,
            complexity: .moderate
        )
        
        let view = ResponsiveCardView(data: testData)
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*responsivecardview", 
            platform: .iOS,
            componentName: "ResponsiveCardView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "ResponsiveCardView should generate accessibility identifiers on iOS")
    }
    
    func testResponsiveCardViewGeneratesAccessibilityIdentifiersOnMacOS() async {
        let testData = ResponsiveCardData(
            title: "Test Card",
            subtitle: "Test Subtitle",
            icon: "doc.text",
            color: .blue,
            complexity: .moderate
        )
        
        let view = ResponsiveCardView(data: testData)
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*responsivecardview", 
            platform: .macOS,
            componentName: "ResponsiveCardView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "ResponsiveCardView should generate accessibility identifiers on macOS")
    }
    
    // MARK: - DynamicFormView Tests
    
    func testDynamicFormViewGeneratesAccessibilityIdentifiersOnIOS() async {
        let testField = DynamicFormField(
            id: "testField",
            contentType: .text,
            label: "Test Field",
            placeholder: "Enter text",
            isRequired: true,
            validationRules: []
        )
        let configuration = DynamicFormConfiguration(id: "testForm", title: "Test Form")
        
        let view = DynamicFormView(
            configuration: configuration,
            fields: [testField]
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*dynamicformview", 
            platform: .iOS,
            componentName: "DynamicFormView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "DynamicFormView should generate accessibility identifiers on iOS")
    }
    
    func testDynamicFormViewGeneratesAccessibilityIdentifiersOnMacOS() async {
        let testField = DynamicFormField(
            id: "testField",
            contentType: .text,
            label: "Test Field",
            placeholder: "Enter text",
            isRequired: true,
            validationRules: []
        )
        let configuration = DynamicFormConfiguration(id: "testForm", title: "Test Form")
        
        let view = DynamicFormView(
            configuration: configuration,
            fields: [testField]
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*dynamicformview", 
            platform: .macOS,
            componentName: "DynamicFormView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "DynamicFormView should generate accessibility identifiers on macOS")
    }
    
    // MARK: - GenericMediaView Tests
    
    func testGenericMediaViewGeneratesAccessibilityIdentifiersOnIOS() async {
        let testMedia = [
            GenericMediaItem(title: "Test Media 1", url: "https://example.com/1"),
            GenericMediaItem(title: "Test Media 2", url: "https://example.com/2")
        ]
        let hints = PresentationHints(
            dataType: .media,
            presentationPreference: .grid,
            complexity: .moderate,
            context: .gallery,
            customPreferences: [:]
        )
        
        let view = GenericMediaView(media: testMedia, hints: hints)
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*genericmediaview", 
            platform: .iOS,
            componentName: "GenericMediaView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "GenericMediaView should generate accessibility identifiers on iOS")
    }
    
    func testGenericMediaViewGeneratesAccessibilityIdentifiersOnMacOS() async {
        let testMedia = [
            GenericMediaItem(title: "Test Media 1", url: "https://example.com/1"),
            GenericMediaItem(title: "Test Media 2", url: "https://example.com/2")
        ]
        let hints = PresentationHints(
            dataType: .media,
            presentationPreference: .grid,
            complexity: .moderate,
            context: .gallery,
            customPreferences: [:]
        )
        
        let view = GenericMediaView(media: testMedia, hints: hints)
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*genericmediaview", 
            platform: .macOS,
            componentName: "GenericMediaView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "GenericMediaView should generate accessibility identifiers on macOS")
    }
    
    // MARK: - GenericSettingsView Tests
    
    func testGenericSettingsViewGeneratesAccessibilityIdentifiersOnIOS() async {
        let testSettings = [
            SettingsSectionData(
                title: "Test Section",
                items: [
                    SettingsItemData(
                        id: "testItem",
                        title: "Test Item",
                        type: .toggle,
                        value: true
                    )
                ]
            )
        ]
        let hints = PresentationHints(
            dataType: .settings,
            presentationPreference: .list,
            complexity: .simple,
            context: .settings,
            customPreferences: [:]
        )
        
        let view = GenericSettingsView(
            settings: testSettings,
            hints: hints
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*genericsettingsview", 
            platform: .iOS,
            componentName: "GenericSettingsView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "GenericSettingsView should generate accessibility identifiers on iOS")
    }
    
    func testGenericSettingsViewGeneratesAccessibilityIdentifiersOnMacOS() async {
        let testSettings = [
            SettingsSectionData(
                title: "Test Section",
                items: [
                    SettingsItemData(
                        id: "testItem",
                        title: "Test Item",
                        type: .toggle,
                        value: true
                    )
                ]
            )
        ]
        let hints = PresentationHints(
            dataType: .settings,
            presentationPreference: .list,
            complexity: .simple,
            context: .settings,
            customPreferences: [:]
        )
        
        let view = GenericSettingsView(
            settings: testSettings,
            hints: hints
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*genericsettingsview", 
            platform: .macOS,
            componentName: "GenericSettingsView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "GenericSettingsView should generate accessibility identifiers on macOS")
    }
    
    // MARK: - GenericContentView Tests
    
    func testGenericContentViewGeneratesAccessibilityIdentifiersOnIOS() async {
        let testContent = "Test Content"
        let hints = PresentationHints(
            dataType: .generic,
            presentationPreference: .card,
            complexity: .simple,
            context: .detail,
            customPreferences: [:]
        )
        
        let view = GenericContentView(content: testContent, hints: hints)
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*genericcontentview", 
            platform: .iOS,
            componentName: "GenericContentView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "GenericContentView should generate accessibility identifiers on iOS")
    }
    
    func testGenericContentViewGeneratesAccessibilityIdentifiersOnMacOS() async {
        let testContent = "Test Content"
        let hints = PresentationHints(
            dataType: .generic,
            presentationPreference: .card,
            complexity: .simple,
            context: .detail,
            customPreferences: [:]
        )
        
        let view = GenericContentView(content: testContent, hints: hints)
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*genericcontentview", 
            platform: .macOS,
            componentName: "GenericContentView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "GenericContentView should generate accessibility identifiers on macOS")
    }
    
    // MARK: - BasicValueView Tests
    
    func testBasicValueViewGeneratesAccessibilityIdentifiersOnIOS() async {
        let testValue = 42
        let hints = PresentationHints(
            dataType: .numeric,
            presentationPreference: .card,
            complexity: .simple,
            context: .detail,
            customPreferences: [:]
        )
        
        let view = BasicValueView(value: testValue, hints: hints)
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*basicvalueview", 
            platform: .iOS,
            componentName: "BasicValueView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "BasicValueView should generate accessibility identifiers on iOS")
    }
    
    func testBasicValueViewGeneratesAccessibilityIdentifiersOnMacOS() async {
        let testValue = 42
        let hints = PresentationHints(
            dataType: .numeric,
            presentationPreference: .card,
            complexity: .simple,
            context: .detail,
            customPreferences: [:]
        )
        
        let view = BasicValueView(value: testValue, hints: hints)
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*basicvalueview", 
            platform: .macOS,
            componentName: "BasicValueView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "BasicValueView should generate accessibility identifiers on macOS")
    }
    
    // MARK: - BasicArrayView Tests
    
    func testBasicArrayViewGeneratesAccessibilityIdentifiersOnIOS() async {
        let testArray = [1, 2, 3, 4, 5]
        let hints = PresentationHints(
            dataType: .generic,
            presentationPreference: .list,
            complexity: .simple,
            context: .list,
            customPreferences: [:]
        )
        
        let view = BasicArrayView(array: testArray, hints: hints)
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*basicarrayview", 
            platform: .iOS,
            componentName: "BasicArrayView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "BasicArrayView should generate accessibility identifiers on iOS")
    }
    
    func testBasicArrayViewGeneratesAccessibilityIdentifiersOnMacOS() async {
        let testArray = [1, 2, 3, 4, 5]
        let hints = PresentationHints(
            dataType: .generic,
            presentationPreference: .list,
            complexity: .simple,
            context: .list,
            customPreferences: [:]
        )
        
        let view = BasicArrayView(array: testArray, hints: hints)
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*basicarrayview", 
            platform: .macOS,
            componentName: "BasicArrayView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "BasicArrayView should generate accessibility identifiers on macOS")
    }
    
    // MARK: - OCRWithVisualCorrectionWrapper Tests
    
    func testOCRWithVisualCorrectionWrapperGeneratesAccessibilityIdentifiersOnIOS() async {
        let testImage = PlatformImage()
        let context = OCRContext(
            textRecognitionLevel: .accurate,
            languageCorrection: true,
            customWords: []
        )
        
        let view = OCRWithVisualCorrectionWrapper(
            image: testImage,
            context: context,
            onResult: { _ in }
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*ocrwithvisualcorrectionwrapper", 
            platform: .iOS,
            componentName: "OCRWithVisualCorrectionWrapper"
        )
        
        XCTAssertTrue(hasAccessibilityID, "OCRWithVisualCorrectionWrapper should generate accessibility identifiers on iOS")
    }
    
    func testOCRWithVisualCorrectionWrapperGeneratesAccessibilityIdentifiersOnMacOS() async {
        let testImage = PlatformImage()
        let context = OCRContext(
            textRecognitionLevel: .accurate,
            languageCorrection: true,
            customWords: []
        )
        
        let view = OCRWithVisualCorrectionWrapper(
            image: testImage,
            context: context,
            onResult: { _ in }
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*ocrwithvisualcorrectionwrapper", 
            platform: .macOS,
            componentName: "OCRWithVisualCorrectionWrapper"
        )
        
        XCTAssertTrue(hasAccessibilityID, "OCRWithVisualCorrectionWrapper should generate accessibility identifiers on macOS")
    }
    
    // MARK: - StructuredDataExtractionWrapper Tests
    
    func testStructuredDataExtractionWrapperGeneratesAccessibilityIdentifiersOnIOS() async {
        let testImage = PlatformImage()
        let context = OCRContext(
            textRecognitionLevel: .accurate,
            languageCorrection: true,
            customWords: []
        )
        
        let view = StructuredDataExtractionWrapper(
            image: testImage,
            context: context,
            onResult: { _ in }
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*structureddataextractionwrapper", 
            platform: .iOS,
            componentName: "StructuredDataExtractionWrapper"
        )
        
        XCTAssertTrue(hasAccessibilityID, "StructuredDataExtractionWrapper should generate accessibility identifiers on iOS")
    }
    
    func testStructuredDataExtractionWrapperGeneratesAccessibilityIdentifiersOnMacOS() async {
        let testImage = PlatformImage()
        let context = OCRContext(
            textRecognitionLevel: .accurate,
            languageCorrection: true,
            customWords: []
        )
        
        let view = StructuredDataExtractionWrapper(
            image: testImage,
            context: context,
            onResult: { _ in }
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*structureddataextractionwrapper", 
            platform: .macOS,
            componentName: "StructuredDataExtractionWrapper"
        )
        
        XCTAssertTrue(hasAccessibilityID, "StructuredDataExtractionWrapper should generate accessibility identifiers on macOS")
    }
}

// MARK: - Test Support Types

/// Test item for component accessibility testing
struct ComponentTestItem: Identifiable {
    let id: String
    let title: String
    
    init(id: String, title: String) {
        self.id = id
        self.title = title
    }
}