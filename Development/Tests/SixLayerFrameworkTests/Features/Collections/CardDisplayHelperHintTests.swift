import Testing
import SwiftUI
@testable import SixLayerFramework

/// Isolated tests for CardDisplayHelper hint-based configuration
/// 
/// BUSINESS PURPOSE: Ensure CardDisplayHelper can extract meaningful content from items using configurable hints
/// TESTING SCOPE: CardDisplayHelper hint system from CardDisplayable.swift
/// METHODOLOGY: Test hint-based extraction with different item types and hint configurations
@Suite("Card Display Helper Hint")
@MainActor
open class CardDisplayHelperHintTests: BaseTestClass {
    
    // MARK: - Test Data Structures
    
    /// Test item with custom property names
    struct CustomItem: Identifiable {
        let id = UUID()
        let customTitle: String
        let customSubtitle: String?
        let customIcon: String?
        let customColor: Color?
        
        init(title: String, subtitle: String? = nil, icon: String? = nil, color: Color? = nil) {
            self.customTitle = title
            self.customSubtitle = subtitle
            self.customIcon = icon
            self.customColor = color
        }
    }
    
    /// Test item with standard property names
    struct StandardItem: Identifiable {
        let id = UUID()
        let title: String
        let subtitle: String?
        let icon: String?
        let color: Color?
        
        init(title: String, subtitle: String? = nil, icon: String? = nil, color: Color? = nil) {
            self.title = title
            self.subtitle = subtitle
            self.icon = icon
            self.color = color
        }
    }
    
    // MARK: - Hint-Based Extraction Tests
    
    @Test func testExtractTitleWithCustomPropertyHint() async {
        // Given: Item with custom property names and hints specifying the property
        let item = CustomItem(title: "Custom Title", subtitle: "Custom Subtitle")
        let hints = PresentationHints(
            customPreferences: [
                "itemTitleProperty": "customTitle",
                "itemSubtitleProperty": "customSubtitle"
            ]
        )
        
        // When: Extract title using hints
        let extractedTitle = CardDisplayHelper.extractTitle(from: item, hints: hints)
        
        // Then: Should extract the correct title
        #expect(extractedTitle == "Custom Title", "Should extract title from custom property specified in hints")
    }
    
    @Test func testExtractSubtitleWithCustomPropertyHint() async {
        // Given: Item with custom property names and hints specifying the property
        let item = CustomItem(title: "Custom Title", subtitle: "Custom Subtitle")
        let hints = PresentationHints(
            customPreferences: [
                "itemTitleProperty": "customTitle",
                "itemSubtitleProperty": "customSubtitle"
            ]
        )
        
        // When: Extract subtitle using hints
        let extractedSubtitle = CardDisplayHelper.extractSubtitle(from: item, hints: hints)
        
        // Then: Should extract the correct subtitle
        #expect(extractedSubtitle == "Custom Subtitle", "Should extract subtitle from custom property specified in hints")
    }
    
    @Test func testExtractIconWithCustomPropertyHint() async {
        // Given: Item with custom icon property and hints specifying the property
        let item = CustomItem(title: "Test", icon: "custom.icon")
        let hints = PresentationHints(
            customPreferences: [
                "itemIconProperty": "customIcon"
            ]
        )
        
        // When: Extract icon using hints
        let extractedIcon = CardDisplayHelper.extractIcon(from: item, hints: hints)
        
        // Then: Should extract the correct icon
        #expect(extractedIcon == "custom.icon", "Should extract icon from custom property specified in hints")
    }
    
    @Test func testExtractColorWithCustomPropertyHint() async {
        // Given: Item with custom color property and hints specifying the property
        let item = CustomItem(title: "Test", color: .red)
        let hints = PresentationHints(
            customPreferences: [
                "itemColorProperty": "customColor"
            ]
        )
        
        // When: Extract color using hints
        let extractedColor = CardDisplayHelper.extractColor(from: item, hints: hints)
        
        // Then: Should extract the correct color
        #expect(extractedColor == .red, "Should extract color from custom property specified in hints")
    }
    
    @Test func testFallbackToReflectionWhenHintPropertyNotFound() async {
        // Given: Item with standard properties but hints pointing to non-existent property
        let item = StandardItem(title: "Standard Title", subtitle: "Standard Subtitle")
        let hints = PresentationHints(
            customPreferences: [
                "itemTitleProperty": "nonExistentProperty"
            ]
        )
        
        // When: Extract title using hints
        let extractedTitle = CardDisplayHelper.extractTitle(from: item, hints: hints)
        
        // Then: Should fall back to reflection and find the standard property
        #expect(extractedTitle == "Standard Title", "Should fall back to reflection when hint property not found")
    }
    
    @Test func testFallbackToReflectionWhenNoHintsProvided() async {
        // Given: Item with standard properties but no hints
        let item = StandardItem(title: "Standard Title", subtitle: "Standard Subtitle")
        let hints: PresentationHints? = nil
        
        // When: Extract title without hints
        let extractedTitle = CardDisplayHelper.extractTitle(from: item, hints: hints)
        
        // Then: Should use reflection to find standard properties
        #expect(extractedTitle == "Standard Title", "Should use reflection when no hints provided")
    }
    
    @Test func testCardDisplayableProtocolTakesPrecedenceOverHints() async {
        // Given: Item that conforms to CardDisplayable protocol
        let item = GenericDataItem(title: "Protocol Title", subtitle: "Protocol Subtitle")
        let hints = PresentationHints(
            customPreferences: [
                "itemTitleProperty": "title"  // This should be ignored since item conforms to CardDisplayable
            ]
        )
        
        // When: Extract title using hints
        let extractedTitle = CardDisplayHelper.extractTitle(from: item, hints: hints)
        
        // Then: Should use CardDisplayable protocol, not hints
        #expect(extractedTitle == "Protocol Title", "Should use CardDisplayable protocol over hints")
    }
    
    @Test func testEmptyHintPropertyIsIgnored() async {
        // Given: Item with custom properties but empty hint property
        let item = CustomItem(title: "Custom Title")
        let hints = PresentationHints(
            customPreferences: [
                "itemTitleProperty": ""  // Empty string should be ignored
            ]
        )
        
        // When: Extract title using hints
        let extractedTitle = CardDisplayHelper.extractTitle(from: item, hints: hints)
        
        // Then: Should fall back to reflection
        #expect(extractedTitle == "Custom Title", "Should ignore empty hint properties and fall back to reflection")
    }
}