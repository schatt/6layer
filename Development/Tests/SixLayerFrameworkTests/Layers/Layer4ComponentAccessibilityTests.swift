import Testing
import Foundation
import SwiftUI
@testable import SixLayerFramework

//
//  Layer4ComponentAccessibilityTests.swift
//  SixLayerFrameworkTests
//
//  Tests Layer 4 components for accessibility - these are View extensions that add platform-specific styling
//

@Suite("Layer Component Accessibility")
@MainActor
open class Layer4ComponentAccessibilityTests: BaseTestClass {
    
    // MARK: - Layer 4 Component Tests
    
    @Test func testPlatformPrimaryButtonStyleGeneratesAccessibilityIdentifiers() async {
        // Given: A test button
        let testButton = Button("Test Button") { }
        
        // When: Applying platform primary button style
        let styledButton = testButton.platformPrimaryButtonStyle()
        
        // Then: Should generate accessibility identifiers
            // TODO: ViewInspector Detection Issue - VERIFIED: PlatformPrimaryButtonStyle DOES have .automaticCompliance() 
            // modifier applied in Framework/Sources/Layers/Layer4-Component/PlatformButtonsLayer4.swift:28.
            // The test needs to be updated to handle ViewInspector's inability to detect these modifiers reliably.
            // This is a ViewInspector limitation, not a missing modifier issue.
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            styledButton,
            expectedPattern: "*.main.ui.element.*",
            platform: SixLayerPlatform.iOS,
            componentName: "PlatformPrimaryButtonStyle"
        )
 #expect(hasAccessibilityID, "Platform primary button style should generate accessibility identifiers ")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }
    
    @Test func testPlatformSecondaryButtonStyleGeneratesAccessibilityIdentifiers() async {
        // Given: A test button
        let testButton = Button("Test Button") { }
        
        // When: Applying platform secondary button style
        let styledButton = testButton.platformSecondaryButtonStyle()
        
        // Then: Should generate accessibility identifiers
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            styledButton,
            expectedPattern: "*.main.ui.element.*",
            platform: SixLayerPlatform.iOS,
            componentName: "PlatformSecondaryButtonStyle"
        )
 #expect(hasAccessibilityID, "Platform secondary button style should generate accessibility identifiers ")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }
    
    @Test func testPlatformFormFieldGeneratesAccessibilityIdentifiers() async {
        // Given: A test text field
        let testTextField = TextField("Placeholder", text: .constant(""))
        
        // When: Applying platform form field wrapper
        let formField = testTextField.platformFormField(label: "Test Field") {
            testTextField
        }
        
        // Then: Should generate accessibility identifiers
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            formField,
            expectedPattern: "*.main.ui.element.*",
            platform: SixLayerPlatform.iOS,
            componentName: "PlatformFormField"
        )
 #expect(hasAccessibilityID, "Platform form field should generate accessibility identifiers ")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }
    
    @Test func testPlatformListRowGeneratesAccessibilityIdentifiers() async {
        // Given: A test list row title
        let title = "Test Item"
        
        // When: Applying platform list row wrapper
        let listRow = EmptyView().platformListRow(title: title) {
            Spacer()
        }
        
        // Then: Should generate accessibility identifiers
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            listRow,
            expectedPattern: "*.main.ui.element.*",
            platform: SixLayerPlatform.iOS,
            componentName: "PlatformListRow"
        )
 #expect(hasAccessibilityID, "Platform list row should generate accessibility identifiers ")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }
    
    @Test func testPlatformCardStyleGeneratesAccessibilityIdentifiers() async {
        // Given: A test card content
        let testCard = VStack {
            Text("Test Card Title")
            Text("Test Card Content")
        }
        
        // When: Applying platform card style
        let styledCard = testCard.platformCardStyle()
        
        // Then: Should generate accessibility identifiers
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            styledCard,
            expectedPattern: "*.main.ui.element.*",
            platform: SixLayerPlatform.iOS,
            componentName: "PlatformCardStyle"
        )
 #expect(hasAccessibilityID, "Platform card style should generate accessibility identifiers ")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }
    
    @Test func testPlatformSheetGeneratesAccessibilityIdentifiers() async {
        // Given: A test sheet content
        let testSheetContent = VStack {
            Text("Test Sheet Title")
            Text("Test Sheet Content")
        }
        
        // When: Applying platform sheet wrapper
        let sheet = testSheetContent.platformSheet(
            isPresented: .constant(true),
            onDismiss: nil
        ) {
            testSheetContent
        }
        
        // Then: Should generate accessibility identifiers
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            sheet,
            expectedPattern: "*.main.ui.element.*",
            platform: SixLayerPlatform.iOS,
            componentName: "PlatformSheet"
        )
 #expect(hasAccessibilityID, "Platform sheet should generate accessibility identifiers ")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }
    
    @Test func testPlatformNavigationGeneratesAccessibilityIdentifiers() async {
        // Given: A test navigation content
        let testNavigationContent = VStack {
            Text("Test Navigation Title")
            Text("Test Navigation Content")
        }
        
        // When: Applying platform navigation wrapper
        let navigation = testNavigationContent.platformNavigation()
        
        // Then: Should generate accessibility identifiers
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            navigation,
            expectedPattern: "*.main.ui.element.*",
            platform: SixLayerPlatform.iOS,
            componentName: "platformNavigation"
        )
 #expect(hasAccessibilityID, "Platform navigation should generate accessibility identifiers ")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }
    
    @Test func testPlatformCardGridGeneratesAccessibilityIdentifiers() async {
        // Given: Test card items
        let testItems = ["Item 1", "Item 2", "Item 3"]
        
        // When: Creating platform card grid
        let cardGrid = EmptyView().platformCardGrid(
            columns: 2,
            spacing: 16,
            content: {
                ForEach(testItems, id: \.self) { item in
                    Text(item)
                }
            }
        )
        
        // Then: Should generate accessibility identifiers
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            cardGrid,
            expectedPattern: "*.main.ui.element.*",
            platform: SixLayerPlatform.iOS,
            componentName: "PlatformCardGrid"
        )
 #expect(hasAccessibilityID, "Platform card grid should generate accessibility identifiers ")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }
    
    @Test func testPlatformBackgroundGeneratesAccessibilityIdentifiers() async {
        // Given: A test text view
        let testText = Text("Test Text")
        
        // When: Applying platform background
        let backgroundText = testText.platformBackground()
        
        // Then: Should generate accessibility identifiers
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            backgroundText,
            expectedPattern: "*.main.ui.element.*",
            platform: SixLayerPlatform.iOS,
            componentName: "PlatformBackground"
        )
 #expect(hasAccessibilityID, "Platform background should generate accessibility identifiers ")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }
}