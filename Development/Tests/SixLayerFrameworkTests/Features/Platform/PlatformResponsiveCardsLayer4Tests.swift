import XCTest
import SwiftUI
@testable import SixLayerFramework
import ViewInspector

// MARK: - Test Helper Types

struct PlatformResponsiveCardsTestItem: Identifiable {
    let id: String
    let title: String
    let subtitle: String
}

/// Tests for PlatformResponsiveCardsLayer4.swift
/// 
/// BUSINESS PURPOSE: Ensure Layer 4 responsive card components generate proper accessibility identifiers
/// TESTING SCOPE: All components in PlatformResponsiveCardsLayer4.swift
/// METHODOLOGY: Test each component on both iOS and macOS platforms as required by mandatory testing guidelines
@MainActor
final class PlatformResponsiveCardsLayer4Tests: XCTestCase {
    
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
    
    // MARK: - GenericItemCollectionView Tests
    
    func testGenericItemCollectionViewGeneratesAccessibilityIdentifiersOnIOS() async {
        let testItems = [
            PlatformResponsiveCardsLayer4TestItem(id: "item1", title: "Test Item 1"),
            PlatformResponsiveCardsLayer4TestItem(id: "item2", title: "Test Item 2")
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
            expectedPattern: "SixLayer.main.element.*", 
            platform: .iOS,
            componentName: "GenericItemCollectionView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "GenericItemCollectionView should generate accessibility identifiers on iOS")
    }
    
    func testGenericItemCollectionViewGeneratesAccessibilityIdentifiersOnMacOS() async {
        let testItems = [
            PlatformResponsiveCardsLayer4TestItem(id: "item1", title: "Test Item 1"),
            PlatformResponsiveCardsLayer4TestItem(id: "item2", title: "Test Item 2")
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
            expectedPattern: "SixLayer.main.element.*", 
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
            expectedPattern: "SixLayer.main.element.*", 
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
            expectedPattern: "SixLayer.main.element.*", 
            platform: .macOS,
            componentName: "GenericNumericDataView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "GenericNumericDataView should generate accessibility identifiers on macOS")
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
            expectedPattern: "SixLayer.main.element.*", 
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
            expectedPattern: "SixLayer.main.element.*", 
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
        
        let view = GenericSettingsView(
            settings: testSettings,
            hints: hints
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.main.element.*", 
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
        
        let view = GenericSettingsView(
            settings: testSettings,
            hints: hints
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.main.element.*", 
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
            expectedPattern: "SixLayer.main.element.*", 
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
            expectedPattern: "SixLayer.main.element.*", 
            platform: .macOS,
            componentName: "GenericContentView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "GenericContentView should generate accessibility identifiers on macOS")
    }
    
    // MARK: - GenericNumericDataView Tests
    
    func testBasicValueViewGeneratesAccessibilityIdentifiersOnIOS() async {
        let testValue = 42
        let hints = PresentationHints(
            dataType: .numeric,
            presentationPreference: .card,
            complexity: .simple,
            context: .detail,
            customPreferences: [:]
        )
        
        let view = GenericNumericDataView(
            data: [GenericNumericData(value: Double(testValue), label: "Test Value", unit: "units")],
            hints: hints
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.main.element.*", 
            platform: .iOS,
            componentName: "GenericNumericDataView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "GenericNumericDataView should generate accessibility identifiers on iOS")
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
        
        let view = GenericNumericDataView(
            data: [GenericNumericData(value: Double(testValue), label: "Test Value", unit: "units")],
            hints: hints
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.main.element.*", 
            platform: .macOS,
            componentName: "GenericNumericDataView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "GenericNumericDataView should generate accessibility identifiers on macOS")
    }
    
    // MARK: - GenericItemCollectionView Tests
    
    func testBasicArrayViewGeneratesAccessibilityIdentifiersOnIOS() async {
        let testArray = [1, 2, 3, 4, 5]
        let hints = PresentationHints(
            dataType: .generic,
            presentationPreference: .list,
            complexity: .simple,
            context: .list,
            customPreferences: [:]
        )
        
        let view = GenericItemCollectionView(
            items: testArray.map { PlatformResponsiveCardsTestItem(id: "\($0)", title: "Item \($0)", subtitle: "Subtitle \($0)") },
            hints: hints
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.main.element.*", 
            platform: .iOS,
            componentName: "GenericItemCollectionView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "GenericItemCollectionView should generate accessibility identifiers on iOS")
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
        
        let view = GenericItemCollectionView(
            items: testArray.map { PlatformResponsiveCardsTestItem(id: "\($0)", title: "Item \($0)", subtitle: "Subtitle \($0)") },
            hints: hints
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.main.element.*", 
            platform: .macOS,
            componentName: "GenericItemCollectionView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "GenericItemCollectionView should generate accessibility identifiers on macOS")
    }
}

// MARK: - Test Support Types

/// Test item for PlatformResponsiveCardsLayer4 testing
struct PlatformResponsiveCardsLayer4TestItem: Identifiable {
    let id: String
    let title: String
    
    init(id: String, title: String) {
        self.id = id
        self.title = title
    }
}

