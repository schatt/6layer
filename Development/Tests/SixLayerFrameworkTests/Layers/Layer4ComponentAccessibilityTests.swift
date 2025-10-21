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

@MainActor
open class Layer4ComponentAccessibilityTests: BaseTestClass {
    
    // MARK: - Layer 4 Component Tests
    
    @Test func testPlatformPrimaryButtonStyleGeneratesAccessibilityIdentifiers() async {
        // Given: A test button
        let testButton = Button("Test Button") { }
        
        // When: Applying platform primary button style
        let styledButton = testButton.platformPrimaryButtonStyle()
        
        // Then: Should generate accessibility identifiers
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            styledButton,
            expectedPattern: "*.main.element.*",
            platform: .iOS,
            platform: .iOS,
            componentName: "PlatformPrimaryButtonStyle"
        )
        
        #expect(hasAccessibilityID, "Platform primary button style should generate accessibility identifiers")
    }
    
    @Test func testPlatformSecondaryButtonStyleGeneratesAccessibilityIdentifiers() async {
        // Given: A test button
        let testButton = Button("Test Button") { }
        
        // When: Applying platform secondary button style
        let styledButton = testButton.platformSecondaryButtonStyle()
        
        // Then: Should generate accessibility identifiers
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            styledButton,
            expectedPattern: "*.main.element.*",
            platform: .iOS,
            platform: .iOS,
            componentName: "PlatformSecondaryButtonStyle"
        )
        
        #expect(hasAccessibilityID, "Platform secondary button style should generate accessibility identifiers")
    }
    
    @Test func testPlatformFormFieldGeneratesAccessibilityIdentifiers() async {
        // Given: A test text field
        let testTextField = TextField("Placeholder", text: .constant(""))
        
        // When: Applying platform form field wrapper
        let formField = testTextField.platformFormField(label: "Test Field") {
            testTextField
        }
        
        // Then: Should generate accessibility identifiers
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            formField,
            expectedPattern: "*.main.element.*",
            platform: .iOS,
            platform: .iOS,
            componentName: "PlatformFormField"
        )
        
        #expect(hasAccessibilityID, "Platform form field should generate accessibility identifiers")
    }
    
    @Test func testPlatformListRowGeneratesAccessibilityIdentifiers() async {
        // Given: A test list row content
        let testContent = HStack {
            Text("Test Item")
            Spacer()
        }
        
        // When: Applying platform list row wrapper
        let listRow = testContent.platformListRow {
            testContent
        }
        
        // Then: Should generate accessibility identifiers
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            listRow,
            expectedPattern: "*.main.element.*",
            platform: .iOS,
            platform: .iOS,
            componentName: "PlatformListRow"
        )
        
        #expect(hasAccessibilityID, "Platform list row should generate accessibility identifiers")
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
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            styledCard,
            expectedPattern: "*.main.element.*",
            platform: .iOS,
            platform: .iOS,
            componentName: "PlatformCardStyle"
        )
        
        #expect(hasAccessibilityID, "Platform card style should generate accessibility identifiers")
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
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            sheet,
            expectedPattern: "*.main.element.*",
            platform: .iOS,
            platform: .iOS,
            componentName: "PlatformSheet"
        )
        
        #expect(hasAccessibilityID, "Platform sheet should generate accessibility identifiers")
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
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            navigation,
            expectedPattern: "*.main.element.*",
            platform: .iOS,
            platform: .iOS,
            componentName: "PlatformNavigation"
        )
        
        #expect(hasAccessibilityID, "Platform navigation should generate accessibility identifiers")
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
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            cardGrid,
            expectedPattern: "*.main.element.*",
            platform: .iOS,
            platform: .iOS,
            componentName: "PlatformCardGrid"
        )
        
        #expect(hasAccessibilityID, "Platform card grid should generate accessibility identifiers")
    }
    
    @Test func testPlatformBackgroundGeneratesAccessibilityIdentifiers() async {
        // Given: A test text view
        let testText = Text("Test Text")
        
        // When: Applying platform background
        let backgroundText = testText.platformBackground()
        
        // Then: Should generate accessibility identifiers
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            backgroundText,
            expectedPattern: "*.main.element.*",
            platform: .iOS,
            platform: .iOS,
            componentName: "PlatformBackground"
        )
        
        #expect(hasAccessibilityID, "Platform background should generate accessibility identifiers")
    }
}