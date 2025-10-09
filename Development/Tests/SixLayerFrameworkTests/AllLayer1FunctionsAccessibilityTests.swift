import XCTest
import SwiftUI
@testable import SixLayerFramework
import ViewInspector

/// Comprehensive Accessibility Tests for ALL Layer 1 Functions
/// 
/// BUSINESS PURPOSE: Ensure every Layer 1 function generates proper accessibility identifiers
/// TESTING SCOPE: All Layer 1 presentation functions with platform mocking as required by mandatory testing guidelines
/// METHODOLOGY: Test each function on both iOS and macOS platforms to verify accessibility identifier generation
@MainActor
final class AllLayer1FunctionsAccessibilityTests: XCTestCase {
    
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
    
    // MARK: - platformPresentItemCollection_L1 Tests
    
    func testPlatformPresentItemCollectionL1GeneratesAccessibilityIdentifiersOnIOS() async {
        let testItems = [
            Layer1TestItem(id: "1", title: "Test Item 1", subtitle: "Subtitle 1"),
            Layer1TestItem(id: "2", title: "Test Item 2", subtitle: "Subtitle 2")
        ]
        let hints = PresentationHints(
            dataType: .generic,
            presentationPreference: .grid,
            complexity: .moderate,
            context: .list,
            customPreferences: [:]
        )
        
        let view = platformPresentItemCollection_L1(items: testItems, hints: hints)
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*platformpresentitemcollection_l1", 
            platform: .iOS,
            componentName: "platformPresentItemCollection_L1"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformPresentItemCollection_L1 should generate accessibility identifiers on iOS")
    }
    
    func testPlatformPresentItemCollectionL1GeneratesAccessibilityIdentifiersOnMacOS() async {
        let testItems = [
            Layer1TestItem(id: "1", title: "Test Item 1", subtitle: "Subtitle 1"),
            Layer1TestItem(id: "2", title: "Test Item 2", subtitle: "Subtitle 2")
        ]
        let hints = PresentationHints(
            dataType: .generic,
            presentationPreference: .grid,
            complexity: .moderate,
            context: .list,
            customPreferences: [:]
        )
        
        let view = platformPresentItemCollection_L1(items: testItems, hints: hints)
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*platformpresentitemcollection_l1", 
            platform: .macOS,
            componentName: "platformPresentItemCollection_L1"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformPresentItemCollection_L1 should generate accessibility identifiers on macOS")
    }
    
    // MARK: - platformPresentNumericData_L1 Tests
    
    func testPlatformPresentNumericDataL1GeneratesAccessibilityIdentifiersOnIOS() async {
        let testData = GenericNumericData(value: 123.45, label: "Test Value", unit: "units")
        let hints = PresentationHints(
            dataType: .numeric,
            presentationPreference: .card,
            complexity: .simple,
            context: .detail,
            customPreferences: [:]
        )
        
        let view = platformPresentNumericData_L1(data: testData, hints: hints)
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*platformpresentnumericdata_l1", 
            platform: .iOS,
            componentName: "platformPresentNumericData_L1"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformPresentNumericData_L1 should generate accessibility identifiers on iOS")
    }
    
    func testPlatformPresentNumericDataL1GeneratesAccessibilityIdentifiersOnMacOS() async {
        let testData = GenericNumericData(value: 123.45, label: "Test Value", unit: "units")
        let hints = PresentationHints(
            dataType: .numeric,
            presentationPreference: .card,
            complexity: .simple,
            context: .detail,
            customPreferences: [:]
        )
        
        let view = platformPresentNumericData_L1(data: testData, hints: hints)
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*platformpresentnumericdata_l1", 
            platform: .macOS,
            componentName: "platformPresentNumericData_L1"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformPresentNumericData_L1 should generate accessibility identifiers on macOS")
    }
    
    // MARK: - platformPresentFormData_L1 Tests
    
    func testPlatformPresentFormDataL1GeneratesAccessibilityIdentifiersOnIOS() async {
        let testField = DynamicFormField(
            id: "testField",
            contentType: .text,
            label: "Test Field",
            placeholder: "Enter text",
            isRequired: true,
            validationRules: []
        )
        let hints = PresentationHints(
            dataType: .form,
            presentationPreference: .list,
            complexity: .moderate,
            context: .form,
            customPreferences: [:]
        )
        
        let view = platformPresentFormData_L1(field: testField, hints: hints)
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*platformpresentformdata_l1", 
            platform: .iOS,
            componentName: "platformPresentFormData_L1"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformPresentFormData_L1 should generate accessibility identifiers on iOS")
    }
    
    func testPlatformPresentFormDataL1GeneratesAccessibilityIdentifiersOnMacOS() async {
        let testField = DynamicFormField(
            id: "testField",
            contentType: .text,
            label: "Test Field",
            placeholder: "Enter text",
            isRequired: true,
            validationRules: []
        )
        let hints = PresentationHints(
            dataType: .form,
            presentationPreference: .list,
            complexity: .moderate,
            context: .form,
            customPreferences: [:]
        )
        
        let view = platformPresentFormData_L1(field: testField, hints: hints)
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*platformpresentformdata_l1", 
            platform: .macOS,
            componentName: "platformPresentFormData_L1"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformPresentFormData_L1 should generate accessibility identifiers on macOS")
    }
    
    // MARK: - platformPresentMediaData_L1 Tests
    
    func testPlatformPresentMediaDataL1GeneratesAccessibilityIdentifiersOnIOS() async {
        let testMedia = GenericMediaItem(title: "Test Media", url: "https://example.com")
        let hints = PresentationHints(
            dataType: .media,
            presentationPreference: .grid,
            complexity: .simple,
            context: .gallery,
            customPreferences: [:]
        )
        
        let view = platformPresentMediaData_L1(media: testMedia, hints: hints)
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*platformpresentmediadata_l1", 
            platform: .iOS,
            componentName: "platformPresentMediaData_L1"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformPresentMediaData_L1 should generate accessibility identifiers on iOS")
    }
    
    func testPlatformPresentMediaDataL1GeneratesAccessibilityIdentifiersOnMacOS() async {
        let testMedia = GenericMediaItem(title: "Test Media", url: "https://example.com")
        let hints = PresentationHints(
            dataType: .media,
            presentationPreference: .grid,
            complexity: .simple,
            context: .gallery,
            customPreferences: [:]
        )
        
        let view = platformPresentMediaData_L1(media: testMedia, hints: hints)
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*platformpresentmediadata_l1", 
            platform: .macOS,
            componentName: "platformPresentMediaData_L1"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformPresentMediaData_L1 should generate accessibility identifiers on macOS")
    }
    
    // MARK: - platformPresentSettings_L1 Tests
    
    func testPlatformPresentSettingsL1GeneratesAccessibilityIdentifiersOnIOS() async {
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
        
        let view = platformPresentSettings_L1(settings: testSettings, hints: hints)
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*platformpresentsettings_l1", 
            platform: .iOS,
            componentName: "platformPresentSettings_L1"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformPresentSettings_L1 should generate accessibility identifiers on iOS")
    }
    
    func testPlatformPresentSettingsL1GeneratesAccessibilityIdentifiersOnMacOS() async {
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
        
        let view = platformPresentSettings_L1(settings: testSettings, hints: hints)
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*platformpresentsettings_l1", 
            platform: .macOS,
            componentName: "platformPresentSettings_L1"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformPresentSettings_L1 should generate accessibility identifiers on macOS")
    }
    
    // MARK: - platformPresentContent_L1 Tests
    
    func testPlatformPresentContentL1GeneratesAccessibilityIdentifiersOnIOS() async {
        let testContent = "Test Content"
        let hints = PresentationHints(
            dataType: .generic,
            presentationPreference: .card,
            complexity: .simple,
            context: .detail,
            customPreferences: [:]
        )
        
        let view = platformPresentContent_L1(content: testContent, hints: hints)
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*platformpresentcontent_l1", 
            platform: .iOS,
            componentName: "platformPresentContent_L1"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformPresentContent_L1 should generate accessibility identifiers on iOS")
    }
    
    func testPlatformPresentContentL1GeneratesAccessibilityIdentifiersOnMacOS() async {
        let testContent = "Test Content"
        let hints = PresentationHints(
            dataType: .generic,
            presentationPreference: .card,
            complexity: .simple,
            context: .detail,
            customPreferences: [:]
        )
        
        let view = platformPresentContent_L1(content: testContent, hints: hints)
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*platformpresentcontent_l1", 
            platform: .macOS,
            componentName: "platformPresentContent_L1"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformPresentContent_L1 should generate accessibility identifiers on macOS")
    }
    
    // MARK: - platformPresentBasicValue_L1 Tests
    
    func testPlatformPresentBasicValueL1GeneratesAccessibilityIdentifiersOnIOS() async {
        let testValue = 42
        let hints = PresentationHints(
            dataType: .numeric,
            presentationPreference: .card,
            complexity: .simple,
            context: .detail,
            customPreferences: [:]
        )
        
        let view = platformPresentBasicValue_L1(value: testValue, hints: hints)
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*platformpresentbasicvalue_l1", 
            platform: .iOS,
            componentName: "platformPresentBasicValue_L1"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformPresentBasicValue_L1 should generate accessibility identifiers on iOS")
    }
    
    func testPlatformPresentBasicValueL1GeneratesAccessibilityIdentifiersOnMacOS() async {
        let testValue = 42
        let hints = PresentationHints(
            dataType: .numeric,
            presentationPreference: .card,
            complexity: .simple,
            context: .detail,
            customPreferences: [:]
        )
        
        let view = platformPresentBasicValue_L1(value: testValue, hints: hints)
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*platformpresentbasicvalue_l1", 
            platform: .macOS,
            componentName: "platformPresentBasicValue_L1"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformPresentBasicValue_L1 should generate accessibility identifiers on macOS")
    }
    
    // MARK: - platformPresentBasicArray_L1 Tests
    
    func testPlatformPresentBasicArrayL1GeneratesAccessibilityIdentifiersOnIOS() async {
        let testArray = [1, 2, 3, 4, 5]
        let hints = PresentationHints(
            dataType: .generic,
            presentationPreference: .list,
            complexity: .simple,
            context: .list,
            customPreferences: [:]
        )
        
        let view = platformPresentBasicArray_L1(array: testArray, hints: hints)
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*platformpresentbasicarray_l1", 
            platform: .iOS,
            componentName: "platformPresentBasicArray_L1"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformPresentBasicArray_L1 should generate accessibility identifiers on iOS")
    }
    
    func testPlatformPresentBasicArrayL1GeneratesAccessibilityIdentifiersOnMacOS() async {
        let testArray = [1, 2, 3, 4, 5]
        let hints = PresentationHints(
            dataType: .generic,
            presentationPreference: .list,
            complexity: .simple,
            context: .list,
            customPreferences: [:]
        )
        
        let view = platformPresentBasicArray_L1(array: testArray, hints: hints)
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*platformpresentbasicarray_l1", 
            platform: .macOS,
            componentName: "platformPresentBasicArray_L1"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformPresentBasicArray_L1 should generate accessibility identifiers on macOS")
    }
    
    // MARK: - platformResponsiveCard_L1 Tests
    
    func testPlatformResponsiveCardL1GeneratesAccessibilityIdentifiersOnIOS() async {
        let hints = PresentationHints(
            dataType: .generic,
            presentationPreference: .card,
            complexity: .simple,
            context: .card,
            customPreferences: [:]
        )
        
        let view = platformResponsiveCard_L1(content: {
            Text("Test Card Content")
        }, hints: hints)
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*platformresponsivecard_l1", 
            platform: .iOS,
            componentName: "platformResponsiveCard_L1"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformResponsiveCard_L1 should generate accessibility identifiers on iOS")
    }
    
    func testPlatformResponsiveCardL1GeneratesAccessibilityIdentifiersOnMacOS() async {
        let hints = PresentationHints(
            dataType: .generic,
            presentationPreference: .card,
            complexity: .simple,
            context: .card,
            customPreferences: [:]
        )
        
        let view = platformResponsiveCard_L1(content: {
            Text("Test Card Content")
        }, hints: hints)
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*platformresponsivecard_l1", 
            platform: .macOS,
            componentName: "platformResponsiveCard_L1"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformResponsiveCard_L1 should generate accessibility identifiers on macOS")
    }
    
    // MARK: - platformPresentLocalizedContent_L1 Tests
    
    func testPlatformPresentLocalizedContentL1GeneratesAccessibilityIdentifiersOnIOS() async {
        let hints = InternationalizationHints()
        
        let view = platformPresentLocalizedContent_L1(content: {
            Text("Test Localized Content")
        }, hints: hints)
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*platformpresentlocalizedcontent_l1", 
            platform: .iOS,
            componentName: "platformPresentLocalizedContent_L1"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformPresentLocalizedContent_L1 should generate accessibility identifiers on iOS")
    }
    
    func testPlatformPresentLocalizedContentL1GeneratesAccessibilityIdentifiersOnMacOS() async {
        let hints = InternationalizationHints()
        
        let view = platformPresentLocalizedContent_L1(content: {
            Text("Test Localized Content")
        }, hints: hints)
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*platformpresentlocalizedcontent_l1", 
            platform: .macOS,
            componentName: "platformPresentLocalizedContent_L1"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformPresentLocalizedContent_L1 should generate accessibility identifiers on macOS")
    }
    
    // MARK: - platformPresentLocalizedText_L1 Tests
    
    func testPlatformPresentLocalizedTextL1GeneratesAccessibilityIdentifiersOnIOS() async {
        let hints = InternationalizationHints()
        
        let view = platformPresentLocalizedText_L1(text: "Test Localized Text", hints: hints)
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*platformpresentlocalizedtext_l1", 
            platform: .iOS,
            componentName: "platformPresentLocalizedText_L1"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformPresentLocalizedText_L1 should generate accessibility identifiers on iOS")
    }
    
    func testPlatformPresentLocalizedTextL1GeneratesAccessibilityIdentifiersOnMacOS() async {
        let hints = InternationalizationHints()
        
        let view = platformPresentLocalizedText_L1(text: "Test Localized Text", hints: hints)
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*platformpresentlocalizedtext_l1", 
            platform: .macOS,
            componentName: "platformPresentLocalizedText_L1"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformPresentLocalizedText_L1 should generate accessibility identifiers on macOS")
    }
    
    // MARK: - platformOCRWithVisualCorrection_L1 Tests
    
    func testPlatformOCRWithVisualCorrectionL1GeneratesAccessibilityIdentifiersOnIOS() async {
        let testImage = PlatformImage()
        let context = OCRContext(
            textRecognitionLevel: .accurate,
            languageCorrection: true,
            customWords: []
        )
        
        let view = platformOCRWithVisualCorrection_L1(
            image: testImage,
            context: context,
            onResult: { _ in }
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*platformocrwithvisualcorrection_l1", 
            platform: .iOS,
            componentName: "platformOCRWithVisualCorrection_L1"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformOCRWithVisualCorrection_L1 should generate accessibility identifiers on iOS")
    }
    
    func testPlatformOCRWithVisualCorrectionL1GeneratesAccessibilityIdentifiersOnMacOS() async {
        let testImage = PlatformImage()
        let context = OCRContext(
            textRecognitionLevel: .accurate,
            languageCorrection: true,
            customWords: []
        )
        
        let view = platformOCRWithVisualCorrection_L1(
            image: testImage,
            context: context,
            onResult: { _ in }
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*platformocrwithvisualcorrection_l1", 
            platform: .macOS,
            componentName: "platformOCRWithVisualCorrection_L1"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformOCRWithVisualCorrection_L1 should generate accessibility identifiers on macOS")
    }
    
    // MARK: - platformExtractStructuredData_L1 Tests
    
    func testPlatformExtractStructuredDataL1GeneratesAccessibilityIdentifiersOnIOS() async {
        let testImage = PlatformImage()
        let context = OCRContext(
            textRecognitionLevel: .accurate,
            languageCorrection: true,
            customWords: []
        )
        
        let view = platformExtractStructuredData_L1(
            image: testImage,
            context: context,
            onResult: { _ in }
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*platformextractstructureddata_l1", 
            platform: .iOS,
            componentName: "platformExtractStructuredData_L1"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformExtractStructuredData_L1 should generate accessibility identifiers on iOS")
    }
    
    func testPlatformExtractStructuredDataL1GeneratesAccessibilityIdentifiersOnMacOS() async {
        let testImage = PlatformImage()
        let context = OCRContext(
            textRecognitionLevel: .accurate,
            languageCorrection: true,
            customWords: []
        )
        
        let view = platformExtractStructuredData_L1(
            image: testImage,
            context: context,
            onResult: { _ in }
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*platformextractstructureddata_l1", 
            platform: .macOS,
            componentName: "platformExtractStructuredData_L1"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformExtractStructuredData_L1 should generate accessibility identifiers on macOS")
    }
}

// MARK: - Test Support Types

/// Test item for Layer 1 accessibility testing
struct Layer1TestItem: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    
    init(id: String, title: String, subtitle: String) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
    }
}