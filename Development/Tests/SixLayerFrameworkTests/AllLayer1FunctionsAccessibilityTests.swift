import XCTest
import SwiftUI
@testable import SixLayerFramework
import ViewInspector

/// Comprehensive Accessibility Tests for ALL SixLayer Layer 1 Functions
/// 
/// BUSINESS PURPOSE: Ensure every Layer 1 function generates proper accessibility identifiers
/// TESTING SCOPE: All public Layer 1 presentation functions
/// METHODOLOGY: Test each Layer 1 function to verify accessibility identifier generation
@MainActor
final class AllLayer1FunctionsAccessibilityTests: XCTestCase {
    
    // MARK: - Test Setup
    
    private var testItems: [Layer1TestItem]!
    private var testHints: PresentationHints!
    
    override func setUp() {
        super.setUp()
        testItems = [
            Layer1TestItem(id: "user-1", title: "Alice", subtitle: "Developer"),
            Layer1TestItem(id: "user-2", title: "Bob", subtitle: "Designer")
        ]
        testHints = PresentationHints(
            dataType: .generic,
            presentationPreference: .grid,
            complexity: .moderate,
            context: .list,
            customPreferences: [:]
        )
        
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
        config.enableAutoIDs = true
        config.namespace = "SixLayer"
        config.mode = .automatic
        config.enableDebugLogging = false
    }
    
    override func tearDown() {
        testItems = nil
        testHints = nil
        super.tearDown()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
    }
    
    // MARK: - platformResponsiveCard_L1 Tests
    
    func testPlatformResponsiveCardL1GeneratesAccessibilityIdentifiers() async {
        let view = platformResponsiveCard_L1(
            content: AnyView(Text("Test Content")),
            hints: testHints!
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*platformresponsivecard", 
            componentName: "platformResponsiveCard_L1"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformResponsiveCard_L1 should generate accessibility identifiers")
    }
    
    // MARK: - platformPresentItemCollection_L1 Tests
    
    func testPlatformPresentItemCollectionL1GeneratesAccessibilityIdentifiers() async {
        let view = platformPresentItemCollection_L1<Layer1TestItem>(
            items: testItems!,
            hints: testHints!
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*platformpresentitemcollection", 
            componentName: "platformPresentItemCollection_L1"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformPresentItemCollection_L1 should generate accessibility identifiers")
    }
    
    // MARK: - platformPresentFormData_L1 Tests
    
    func testPlatformPresentFormDataL1GeneratesAccessibilityIdentifiers() async {
        let view = platformPresentFormData_L1(
            field: DynamicFormField(id: "test", contentType: .text, label: "Test Field"),
            hints: PresentationHints()
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*platformpresentformdata", 
            componentName: "platformPresentFormData_L1"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformPresentFormData_L1 should generate accessibility identifiers")
    }
    
    // MARK: - platformPresentNumericData_L1 Tests
    
    func testPlatformPresentNumericDataL1GeneratesAccessibilityIdentifiers() async {
        let view = platformPresentNumericData_L1(
            data: GenericNumericData(value: 123.45, label: "Test Value", unit: "units"),
            hints: PresentationHints()
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*platformpresentnumericdata", 
            componentName: "platformPresentNumericData_L1"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformPresentNumericData_L1 should generate accessibility identifiers")
    }
    
    // MARK: - platformPresentMediaData_L1 Tests
    
    func testPlatformPresentMediaDataL1GeneratesAccessibilityIdentifiers() async {
        let view = platformPresentMediaData_L1(
            media: GenericMediaItem(title: "Test Media", url: "https://example.com"),
            hints: PresentationHints()
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*platformpresentmediadata", 
            componentName: "platformPresentMediaData_L1"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformPresentMediaData_L1 should generate accessibility identifiers")
    }
    
    // MARK: - platformPresentSettings_L1 Tests
    
    func testPlatformPresentSettingsL1GeneratesAccessibilityIdentifiers() async {
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
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*platformpresentsettings", 
            componentName: "platformPresentSettings_L1"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformPresentSettings_L1 should generate accessibility identifiers")
    }
    
    // MARK: - platformPresentContent_L1 Tests
    
    func testPlatformPresentContentL1GeneratesAccessibilityIdentifiers() async {
        let view = platformPresentContent_L1(
            content: AnyView(Text("Test Content")),
            hints: PresentationHints()
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*platformpresentcontent", 
            componentName: "platformPresentContent_L1"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformPresentContent_L1 should generate accessibility identifiers")
    }
    
    // MARK: - platformPresentBasicValue_L1 Tests
    
    func testPlatformPresentBasicValueL1GeneratesAccessibilityIdentifiers() async {
        let view = platformPresentBasicValue_L1(
            value: "Test Value",
            hints: PresentationHints()
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*platformpresentbasicvalue", 
            componentName: "platformPresentBasicValue_L1"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformPresentBasicValue_L1 should generate accessibility identifiers")
    }
    
    // MARK: - platformPresentHierarchicalData_L1 Tests
    
    func testPlatformPresentHierarchicalDataL1GeneratesAccessibilityIdentifiers() async {
        let view = platformPresentHierarchicalData_L1(
            data: HierarchicalData(title: "Test Hierarchy", children: []),
            hints: PresentationHints()
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*platformpresenthierarchicaldata", 
            componentName: "platformPresentHierarchicalData_L1"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformPresentHierarchicalData_L1 should generate accessibility identifiers")
    }
    
    // MARK: - platformPresentTemporalData_L1 Tests
    
    func testPlatformPresentTemporalDataL1GeneratesAccessibilityIdentifiers() async {
        let view = platformPresentTemporalData_L1(
            data: TemporalData(title: "Test Temporal", timestamp: Date()),
            hints: PresentationHints()
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*platformpresenttemporaldata", 
            componentName: "platformPresentTemporalData_L1"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformPresentTemporalData_L1 should generate accessibility identifiers")
    }
    
    // MARK: - platformPresentNavigation_L1 Tests
    
    func testPlatformPresentNavigationL1GeneratesAccessibilityIdentifiers() async {
        let view = platformPresentNavigation_L1(
            items: [
                NavigationItem(id: "nav1", title: "Home", destination: AnyView(Text("Home"))),
                NavigationItem(id: "nav2", title: "Settings", destination: AnyView(Text("Settings")))
            ],
            hints: PresentationHints()
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*platformpresentnavigation", 
            componentName: "platformPresentNavigation_L1"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformPresentNavigation_L1 should generate accessibility identifiers")
    }
    
    // MARK: - platformPresentAction_L1 Tests
    
    func testPlatformPresentActionL1GeneratesAccessibilityIdentifiers() async {
        let view = platformPresentAction_L1(
            action: ActionData(title: "Test Action", action: {}),
            hints: PresentationHints()
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*platformpresentaction", 
            componentName: "platformPresentAction_L1"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformPresentAction_L1 should generate accessibility identifiers")
    }
    
    // MARK: - platformPresentFeedback_L1 Tests
    
    func testPlatformPresentFeedbackL1GeneratesAccessibilityIdentifiers() async {
        let view = platformPresentFeedback_L1(
            feedback: FeedbackData(message: "Test Feedback", type: .info),
            hints: PresentationHints()
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*platformpresentfeedback", 
            componentName: "platformPresentFeedback_L1"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformPresentFeedback_L1 should generate accessibility identifiers")
    }
    
    // MARK: - platformPresentError_L1 Tests
    
    func testPlatformPresentErrorL1GeneratesAccessibilityIdentifiers() async {
        let view = platformPresentError_L1(
            error: ErrorData(message: "Test Error", code: "TEST_ERROR"),
            hints: PresentationHints()
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*platformpresenterror", 
            componentName: "platformPresentError_L1"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformPresentError_L1 should generate accessibility identifiers")
    }
    
    // MARK: - platformPresentLoading_L1 Tests
    
    func testPlatformPresentLoadingL1GeneratesAccessibilityIdentifiers() async {
        let view = platformPresentLoading_L1(
            message: "Loading...",
            hints: PresentationHints()
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*platformpresentloading", 
            componentName: "platformPresentLoading_L1"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformPresentLoading_L1 should generate accessibility identifiers")
    }
    
    // MARK: - platformPresentEmpty_L1 Tests
    
    func testPlatformPresentEmptyL1GeneratesAccessibilityIdentifiers() async {
        let view = platformPresentEmpty_L1(
            message: "No data available",
            actionTitle: "Refresh",
            action: {},
            hints: PresentationHints()
        )
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.*element.*platformpresentempty", 
            componentName: "platformPresentEmpty_L1"
        )
        
        XCTAssertTrue(hasAccessibilityID, "platformPresentEmpty_L1 should generate accessibility identifiers")
    }
}

// MARK: - Test Support Types

struct Layer1TestItem: Identifiable {
    let id: String
    let title: String
    let subtitle: String
}

struct NavigationItem: Identifiable {
    let id: String
    let title: String
    let destination: AnyView
}

struct ActionData {
    let title: String
    let action: () -> Void
}

struct FeedbackData {
    let message: String
    let type: FeedbackType
}

enum FeedbackType {
    case info, warning, error, success
}

struct ErrorData {
    let message: String
    let code: String
}
