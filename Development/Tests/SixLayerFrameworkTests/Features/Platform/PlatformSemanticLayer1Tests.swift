import Testing


import SwiftUI
@testable import SixLayerFramework
import ViewInspector

/// Tests for PlatformSemanticLayer1.swift
/// 
/// BUSINESS PURPOSE: Ensure all Layer 1 semantic presentation functions generate proper accessibility identifiers
/// TESTING SCOPE: All functions in PlatformSemanticLayer1.swift
/// METHODOLOGY: Test each function on both iOS and macOS platforms as required by mandatory testing guidelines
@MainActor
open class PlatformSemanticLayer1Tests {
    
    // MARK: - Test Setup
    
    init() async throws {
        await setupTestEnvironment()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
        config.enableAutoIDs = true
        config.namespace = "SixLayer"
        config.mode = .automatic
        config.enableDebugLogging = false
    }    // MARK: - platformPresentItemCollection_L1 Tests
    
    
    private func setupTestEnvironment() async {
        await AccessibilityTestUtilities.setupAccessibilityTestEnvironment()
    }
    
    private func cleanupTestEnvironment() async {
        await AccessibilityTestUtilities.cleanupAccessibilityTestEnvironment()
    }
    
@Test func testPlatformPresentItemCollectionL1GeneratesAccessibilityIdentifiersOnIOS() async {
        let testItems = [
            PlatformSemanticLayer1TestItem(id: "1", title: "Test Item 1", subtitle: "Subtitle 1"),
            PlatformSemanticLayer1TestItem(id: "2", title: "Test Item 2", subtitle: "Subtitle 2")
        ]
        let hints = PresentationHints(
            dataType: .generic,
            presentationPreference: .grid,
            complexity: .moderate,
            context: .list,
            customPreferences: [:]
        )
        
        let view = platformPresentItemCollection_L1(items: testItems, hints: hints)
        
        let hasAccessibilityID = testAccessibilityIdentifiersCrossPlatform(
            view, 
            expectedPattern: "SixLayer.main.element.*", 
            platform: .iOS,
            componentName: "platformPresentItemCollection_L1",
            testName: "PlatformTest"
        )
        
        #expect(hasAccessibilityID, "platformPresentItemCollection_L1 should generate accessibility identifiers on iOS")
    }
    
    @Test func testPlatformPresentItemCollectionL1GeneratesAccessibilityIdentifiersOnMacOS() async {
        let testItems = [
            PlatformSemanticLayer1TestItem(id: "1", title: "Test Item 1", subtitle: "Subtitle 1"),
            PlatformSemanticLayer1TestItem(id: "2", title: "Test Item 2", subtitle: "Subtitle 2")
        ]
        let hints = PresentationHints(
            dataType: .generic,
            presentationPreference: .grid,
            complexity: .moderate,
            context: .list,
            customPreferences: [:]
        )
        
        let view = platformPresentItemCollection_L1(items: testItems, hints: hints)
        
        let hasAccessibilityID = testAccessibilityIdentifiersCrossPlatform(
            view, 
            expectedPattern: "SixLayer.main.element.*", 
            platform: .macOS,
            componentName: "platformPresentItemCollection_L1",
            testName: "PlatformTest"
        )
        
        #expect(hasAccessibilityID, "platformPresentItemCollection_L1 should generate accessibility identifiers on macOS")
    }
    
    // MARK: - platformPresentNumericData_L1 Tests
    
    @Test func testPlatformPresentNumericDataL1GeneratesAccessibilityIdentifiersOnIOS() async {
        let testData = GenericNumericData(value: 123.45, label: "Test Value", unit: "units")
        let hints = PresentationHints(
            dataType: .numeric,
            presentationPreference: .card,
            complexity: .simple,
            context: .detail,
            customPreferences: [:]
        )
        
        let view = platformPresentNumericData_L1(data: testData, hints: hints)
        
        let hasAccessibilityID = testAccessibilityIdentifiersCrossPlatform(
            view, 
            expectedPattern: "SixLayer.main.element.*", 
            platform: .iOS,
            componentName: "platformPresentNumericData_L1",
            testName: "PlatformTest"
        )
        
        #expect(hasAccessibilityID, "platformPresentNumericData_L1 should generate accessibility identifiers on iOS")
    }
    
    @Test func testPlatformPresentNumericDataL1GeneratesAccessibilityIdentifiersOnMacOS() async {
        let testData = GenericNumericData(value: 123.45, label: "Test Value", unit: "units")
        let hints = PresentationHints(
            dataType: .numeric,
            presentationPreference: .card,
            complexity: .simple,
            context: .detail,
            customPreferences: [:]
        )
        
        let view = platformPresentNumericData_L1(data: testData, hints: hints)
        
        let hasAccessibilityID = testAccessibilityIdentifiersCrossPlatform(
            view, 
            expectedPattern: "SixLayer.main.element.*", 
            platform: .macOS,
            componentName: "platformPresentNumericData_L1",
            testName: "PlatformTest"
        )
        
        #expect(hasAccessibilityID, "platformPresentNumericData_L1 should generate accessibility identifiers on macOS")
    }
    
    // MARK: - platformPresentFormData_L1 Tests
    
    @Test func testPlatformPresentFormDataL1GeneratesAccessibilityIdentifiersOnIOS() async {
        let testField = DynamicFormField(
            id: "testField",
            contentType: .text,
            label: "Test Field",
            placeholder: "Enter text",
            isRequired: true,
            validationRules: [:]
        )
        let hints = PresentationHints(
            dataType: .form,
            presentationPreference: .list,
            complexity: .moderate,
            context: .form,
            customPreferences: [:]
        )
        
        let view = platformPresentFormData_L1(field: testField, hints: hints)
        
        let hasAccessibilityID = testAccessibilityIdentifiersCrossPlatform(
            view, 
            expectedPattern: "SixLayer.main.element.*", 
            platform: .iOS,
            componentName: "platformPresentFormData_L1",
            testName: "PlatformTest"
        )
        
        #expect(hasAccessibilityID, "platformPresentFormData_L1 should generate accessibility identifiers on iOS")
    }
    
    @Test func testPlatformPresentFormDataL1GeneratesAccessibilityIdentifiersOnMacOS() async {
        let testField = DynamicFormField(
            id: "testField",
            contentType: .text,
            label: "Test Field",
            placeholder: "Enter text",
            isRequired: true,
            validationRules: [:]
        )
        let hints = PresentationHints(
            dataType: .form,
            presentationPreference: .list,
            complexity: .moderate,
            context: .form,
            customPreferences: [:]
        )
        
        let view = platformPresentFormData_L1(field: testField, hints: hints)
        
        let hasAccessibilityID = testAccessibilityIdentifiersCrossPlatform(
            view, 
            expectedPattern: "SixLayer.main.element.*", 
            platform: .macOS,
            componentName: "platformPresentFormData_L1",
            testName: "PlatformTest"
        )
        
        #expect(hasAccessibilityID, "platformPresentFormData_L1 should generate accessibility identifiers on macOS")
    }
    
    // MARK: - platformPresentMediaData_L1 Tests
    
    @Test func testPlatformPresentMediaDataL1GeneratesAccessibilityIdentifiersOnIOS() async {
        let testMedia = GenericMediaItem(title: "Test Media", url: "https://example.com")
        let hints = PresentationHints(
            dataType: .media,
            presentationPreference: .grid,
            complexity: .simple,
            context: .gallery,
            customPreferences: [:]
        )
        
        let view = platformPresentMediaData_L1(media: testMedia, hints: hints)
        
        let hasAccessibilityID = testAccessibilityIdentifiersCrossPlatform(
            view, 
            expectedPattern: "SixLayer.main.element.*", 
            platform: .iOS,
            componentName: "platformPresentMediaData_L1",
            testName: "PlatformTest"
        )
        
        #expect(hasAccessibilityID, "platformPresentMediaData_L1 should generate accessibility identifiers on iOS")
    }
    
    @Test func testPlatformPresentMediaDataL1GeneratesAccessibilityIdentifiersOnMacOS() async {
        let testMedia = GenericMediaItem(title: "Test Media", url: "https://example.com")
        let hints = PresentationHints(
            dataType: .media,
            presentationPreference: .grid,
            complexity: .simple,
            context: .gallery,
            customPreferences: [:]
        )
        
        let view = platformPresentMediaData_L1(media: testMedia, hints: hints)
        
        let hasAccessibilityID = testAccessibilityIdentifiersCrossPlatform(
            view, 
            expectedPattern: "SixLayer.main.element.*", 
            platform: .macOS,
            componentName: "platformPresentMediaData_L1",
            testName: "PlatformTest"
        )
        
        #expect(hasAccessibilityID, "platformPresentMediaData_L1 should generate accessibility identifiers on macOS")
    }
    
    // MARK: - platformPresentSettings_L1 Tests
    
    @Test func testPlatformPresentSettingsL1GeneratesAccessibilityIdentifiersOnIOS() async {
        let testSettings = [
            SettingsSectionData(
                title: "Test Section",
                items: [
                    SettingsItemData(
                        key: "testItem",
                        title: "Test Item",
                        type: .toggle,
                        value: true
                    )
                ]
            )
        ]
        let hints = PresentationHints(
            dataType: .generic,
            presentationPreference: .list,
            complexity: .simple,
            context: .settings,
            customPreferences: [:]
        )
        
        let view = platformPresentSettings_L1(settings: testSettings, hints: hints)
        
        let hasAccessibilityID = testAccessibilityIdentifiersCrossPlatform(
            view, 
            expectedPattern: "SixLayer.main.element.*", 
            platform: .iOS,
            componentName: "platformPresentSettings_L1",
            testName: "PlatformTest"
        )
        
        #expect(hasAccessibilityID, "platformPresentSettings_L1 should generate accessibility identifiers on iOS")
    }
    
    @Test func testPlatformPresentSettingsL1GeneratesAccessibilityIdentifiersOnMacOS() async {
        let testSettings = [
            SettingsSectionData(
                title: "Test Section",
                items: [
                    SettingsItemData(
                        key: "testItem",
                        title: "Test Item",
                        type: .toggle,
                        value: true
                    )
                ]
            )
        ]
        let hints = PresentationHints(
            dataType: .generic,
            presentationPreference: .list,
            complexity: .simple,
            context: .settings,
            customPreferences: [:]
        )
        
        let view = platformPresentSettings_L1(settings: testSettings, hints: hints)
        
        let hasAccessibilityID = testAccessibilityIdentifiersCrossPlatform(
            view, 
            expectedPattern: "SixLayer.main.element.*", 
            platform: .macOS,
            componentName: "platformPresentSettings_L1",
            testName: "PlatformTest"
        )
        
        #expect(hasAccessibilityID, "platformPresentSettings_L1 should generate accessibility identifiers on macOS")
    }
    
    // MARK: - platformPresentContent_L1 Tests
    
    @Test func testPlatformPresentContentL1GeneratesAccessibilityIdentifiersOnIOS() async {
        let testContent = "Test Content"
        let hints = PresentationHints(
            dataType: .generic,
            presentationPreference: .card,
            complexity: .simple,
            context: .detail,
            customPreferences: [:]
        )
        
        let view = platformPresentContent_L1(content: testContent, hints: hints)
        
        let hasAccessibilityID = testAccessibilityIdentifiersCrossPlatform(
            view, 
            expectedPattern: "SixLayer.main.element.*", 
            platform: .iOS,
            componentName: "platformPresentContent_L1",
            testName: "PlatformTest"
        )
        
        #expect(hasAccessibilityID, "platformPresentContent_L1 should generate accessibility identifiers on iOS")
    }
    
    @Test func testPlatformPresentContentL1GeneratesAccessibilityIdentifiersOnMacOS() async {
        let testContent = "Test Content"
        let hints = PresentationHints(
            dataType: .generic,
            presentationPreference: .card,
            complexity: .simple,
            context: .detail,
            customPreferences: [:]
        )
        
        let view = platformPresentContent_L1(content: testContent, hints: hints)
        
        let hasAccessibilityID = testAccessibilityIdentifiersCrossPlatform(
            view, 
            expectedPattern: "SixLayer.main.element.*", 
            platform: .macOS,
            componentName: "platformPresentContent_L1",
            testName: "PlatformTest"
        )
        
        #expect(hasAccessibilityID, "platformPresentContent_L1 should generate accessibility identifiers on macOS")
    }
    
    // MARK: - platformPresentBasicValue_L1 Tests
    
    @Test func testPlatformPresentBasicValueL1GeneratesAccessibilityIdentifiersOnIOS() async {
        let testValue = 42
        let hints = PresentationHints(
            dataType: .numeric,
            presentationPreference: .card,
            complexity: .simple,
            context: .detail,
            customPreferences: [:]
        )
        
        let view = platformPresentBasicValue_L1(value: testValue, hints: hints)
        
        let hasAccessibilityID = testAccessibilityIdentifiersCrossPlatform(
            view, 
            expectedPattern: "SixLayer.main.element.*", 
            platform: .iOS,
            componentName: "platformPresentBasicValue_L1",
            testName: "PlatformTest"
        )
        
        #expect(hasAccessibilityID, "platformPresentBasicValue_L1 should generate accessibility identifiers on iOS")
    }
    
    @Test func testPlatformPresentBasicValueL1GeneratesAccessibilityIdentifiersOnMacOS() async {
        let testValue = 42
        let hints = PresentationHints(
            dataType: .numeric,
            presentationPreference: .card,
            complexity: .simple,
            context: .detail,
            customPreferences: [:]
        )
        
        let view = platformPresentBasicValue_L1(value: testValue, hints: hints)
        
        let hasAccessibilityID = testAccessibilityIdentifiersCrossPlatform(
            view, 
            expectedPattern: "SixLayer.main.element.*", 
            platform: .macOS,
            componentName: "platformPresentBasicValue_L1",
            testName: "PlatformTest"
        )
        
        #expect(hasAccessibilityID, "platformPresentBasicValue_L1 should generate accessibility identifiers on macOS")
    }
    
    // MARK: - platformPresentBasicArray_L1 Tests
    
    @Test func testPlatformPresentBasicArrayL1GeneratesAccessibilityIdentifiersOnIOS() async {
        let testArray = [1, 2, 3, 4, 5]
        let hints = PresentationHints(
            dataType: .generic,
            presentationPreference: .list,
            complexity: .simple,
            context: .list,
            customPreferences: [:]
        )
        
        let view = platformPresentBasicArray_L1(array: testArray, hints: hints)
        
        let hasAccessibilityID = testAccessibilityIdentifiersCrossPlatform(
            view, 
            expectedPattern: "SixLayer.main.element.*", 
            platform: .iOS,
            componentName: "platformPresentBasicArray_L1",
            testName: "PlatformTest"
        )
        
        #expect(hasAccessibilityID, "platformPresentBasicArray_L1 should generate accessibility identifiers on iOS")
    }
    
    @Test func testPlatformPresentBasicArrayL1GeneratesAccessibilityIdentifiersOnMacOS() async {
        let testArray = [1, 2, 3, 4, 5]
        let hints = PresentationHints(
            dataType: .generic,
            presentationPreference: .list,
            complexity: .simple,
            context: .list,
            customPreferences: [:]
        )
        
        let view = platformPresentBasicArray_L1(array: testArray, hints: hints)
        
        let hasAccessibilityID = testAccessibilityIdentifiersCrossPlatform(
            view, 
            expectedPattern: "SixLayer.main.element.*", 
            platform: .macOS,
            componentName: "platformPresentBasicArray_L1",
            testName: "PlatformTest"
        )
        
        #expect(hasAccessibilityID, "platformPresentBasicArray_L1 should generate accessibility identifiers on macOS")
    }
    
    // MARK: - platformResponsiveCard_L1 Tests
    
    @Test func testPlatformResponsiveCardL1GeneratesAccessibilityIdentifiersOnIOS() async {
        let hints = PresentationHints(
            dataType: .generic,
            presentationPreference: .card,
            complexity: .simple,
            context: .standard,
            customPreferences: [:]
        )
        
        let view = platformResponsiveCard_L1(content: {
            Text("Test Card Content")
        }, hints: hints)
        
        let hasAccessibilityID = testAccessibilityIdentifiersCrossPlatform(
            view, 
            expectedPattern: "SixLayer.main.element.*", 
            platform: .iOS,
            componentName: "platformResponsiveCard_L1",
            testName: "PlatformTest"
        )
        
        #expect(hasAccessibilityID, "platformResponsiveCard_L1 should generate accessibility identifiers on iOS")
    }
    
    @Test func testPlatformResponsiveCardL1GeneratesAccessibilityIdentifiersOnMacOS() async {
        let hints = PresentationHints(
            dataType: .generic,
            presentationPreference: .card,
            complexity: .simple,
            context: .standard,
            customPreferences: [:]
        )
        
        let view = platformResponsiveCard_L1(content: {
            Text("Test Card Content")
        }, hints: hints)
        
        let hasAccessibilityID = testAccessibilityIdentifiersCrossPlatform(
            view, 
            expectedPattern: "SixLayer.main.element.*", 
            platform: .macOS,
            componentName: "platformResponsiveCard_L1",
            testName: "PlatformTest"
        )
        
        #expect(hasAccessibilityID, "platformResponsiveCard_L1 should generate accessibility identifiers on macOS")
    }
}

// MARK: - Test Support Types

/// Test item for PlatformSemanticLayer1 testing
struct PlatformSemanticLayer1TestItem: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    
    init(id: String, title: String, subtitle: String) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
    }
}
