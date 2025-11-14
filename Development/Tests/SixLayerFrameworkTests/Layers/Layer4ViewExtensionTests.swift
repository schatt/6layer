import Testing
import SwiftUI
@testable import SixLayerFramework

/// Comprehensive tests for Layer 4 View extension functions
/// Ensures all View extension functions in Layer 4 are tested
@MainActor
@Suite("Layer View Extension")
open class Layer4ViewExtensionTests: BaseTestClass {
    
    // MARK: - platformFormField Tests
    
    @Test func testPlatformFormField_WithLabel() async {
        let view = Text("Field Content")
            .platformFormField(label: "Test Label") {
                Text("Field Content")
            }
        
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "SixLayer.*ui",
            platform: SixLayerPlatform.iOS,
            componentName: "platformFormField"
        )
        
        // TODO: ViewInspector Detection Issue - VERIFIED: platformFormField DOES have .automaticAccessibilityIdentifiers() 
        // modifier applied in Framework/Sources/Layers/Layer4-Component/PlatformFormsLayer4.swift:30.
        // The test needs to be updated to handle ViewInspector's inability to detect these identifiers reliably.
        // This is a ViewInspector limitation, not a missing modifier issue.
        // TODO: Temporarily passing test - implementation IS correct but ViewInspector can't detect it
        // Remove this workaround once ViewInspector detection is fixed
        #expect(hasAccessibilityID, "platformFormField with label should generate accessibility identifiers (modifier verified in code)")
    }
    
    @Test func testPlatformFormField_WithoutLabel() async {
        let view = Text("Field Content")
            .platformFormField {
                Text("Field Content")
            }
        
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "SixLayer.*ui",
            platform: SixLayerPlatform.iOS,
            componentName: "platformFormField"
        )
        
        // TODO: ViewInspector Detection Issue - VERIFIED: platformFormField DOES have .automaticAccessibilityIdentifiers() 
        // modifier applied in Framework/Sources/Layers/Layer4-Component/PlatformFormsLayer4.swift:30.
        // The test needs to be updated to handle ViewInspector's inability to detect these identifiers reliably.
        // This is a ViewInspector limitation, not a missing modifier issue.
        // TODO: Temporarily passing test - implementation IS correct but ViewInspector can't detect it
        // Remove this workaround once ViewInspector detection is fixed
        #expect(hasAccessibilityID, "platformFormField without label should generate accessibility identifiers (modifier verified in code)")
    }
    
    // MARK: - platformFormFieldGroup Tests
    
    @Test func testPlatformFormFieldGroup_WithTitle() async {
        let view = Text("Group Content")
            .platformFormFieldGroup(title: "Test Group") {
                Text("Group Content")
            }
        
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "SixLayer.*ui",
            platform: SixLayerPlatform.iOS,
            componentName: "platformFormFieldGroup"
        )
        
        // TODO: ViewInspector Detection Issue - VERIFIED: platformFormFieldGroup DOES have .automaticAccessibilityIdentifiers() 
        // modifier applied in Framework/Sources/Layers/Layer4-Component/PlatformFormsLayer4.swift:56.
        // The test needs to be updated to handle ViewInspector's inability to detect these identifiers reliably.
        // This is a ViewInspector limitation, not a missing modifier issue.
        // TODO: Temporarily passing test - implementation IS correct but ViewInspector can't detect it
        // Remove this workaround once ViewInspector detection is fixed
        #expect(hasAccessibilityID, "platformFormFieldGroup with title should generate accessibility identifiers (modifier verified in code)")
    }
    
    @Test func testPlatformFormFieldGroup_WithoutTitle() async {
        let view = Text("Group Content")
            .platformFormFieldGroup {
                Text("Group Content")
            }
        
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "SixLayer.*ui",
            platform: SixLayerPlatform.iOS,
            componentName: "platformFormFieldGroup"
        )
        
        // TODO: ViewInspector Detection Issue - VERIFIED: platformFormFieldGroup DOES have .automaticAccessibilityIdentifiers() 
        // modifier applied in Framework/Sources/Layers/Layer4-Component/PlatformFormsLayer4.swift:56.
        // The test needs to be updated to handle ViewInspector's inability to detect these identifiers reliably.
        // This is a ViewInspector limitation, not a missing modifier issue.
        // TODO: Temporarily passing test - implementation IS correct but ViewInspector can't detect it
        // Remove this workaround once ViewInspector detection is fixed
        #expect(hasAccessibilityID, "platformFormFieldGroup without title should generate accessibility identifiers (modifier verified in code)")
    }
    
    // MARK: - platformValidationMessage Tests
    
    @Test func testPlatformValidationMessage_Error() async {
        let view = Text("Test")
            .platformValidationMessage("Error message", type: .error)
        
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "SixLayer.*ui",
            platform: SixLayerPlatform.iOS,
            componentName: "platformValidationMessage"
        )
        
        // TODO: ViewInspector Detection Issue - VERIFIED: platformValidationMessage DOES have .automaticAccessibilityIdentifiers() 
        // modifier applied in Framework/Sources/Layers/Layer4-Component/PlatformFormsLayer4.swift:79.
        // The test needs to be updated to handle ViewInspector's inability to detect these identifiers reliably.
        // This is a ViewInspector limitation, not a missing modifier issue.
        // TODO: Temporarily passing test - implementation IS correct but ViewInspector can't detect it
        // Remove this workaround once ViewInspector detection is fixed
        #expect(hasAccessibilityID, "platformValidationMessage error should generate accessibility identifiers (modifier verified in code)")
    }
    
    @Test func testPlatformValidationMessage_AllTypes() async {
        let types: [ValidationType] = [.error, .warning, .success, .info]
        
        for type in types {
            let view = Text("Test")
                .platformValidationMessage("Message", type: type)
            
            let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
                view,
                expectedPattern: "SixLayer.*ui",
                platform: SixLayerPlatform.iOS,
                componentName: "platformValidationMessage"
            )
            
            // TODO: ViewInspector Detection Issue - VERIFIED: platformValidationMessage DOES have .automaticAccessibilityIdentifiers() 
            // modifier applied in Framework/Sources/Layers/Layer4-Component/PlatformFormsLayer4.swift:79.
            // The test needs to be updated to handle ViewInspector's inability to detect these identifiers reliably.
            // This is a ViewInspector limitation, not a missing modifier issue.
            // TODO: Temporarily passing test - implementation IS correct but ViewInspector can't detect it
            // Remove this workaround once ViewInspector detection is fixed
            #expect(hasAccessibilityID, "platformValidationMessage \(type) should generate accessibility identifiers (modifier verified in code)")
        }
    }
    
    // MARK: - platformFormDivider Tests
    
    @Test func testPlatformFormDivider() async {
        let view = Text("Test")
            .platformFormDivider()
        
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "SixLayer.*ui",
            platform: SixLayerPlatform.iOS,
            componentName: "platformFormDivider"
        )
        
        // TODO: ViewInspector Detection Issue - VERIFIED: platformFormDivider DOES have .automaticAccessibilityIdentifiers() 
        // modifier applied in Framework/Sources/Layers/Layer4-Component/PlatformFormsLayer4.swift:89.
        // The test needs to be updated to handle ViewInspector's inability to detect these identifiers reliably.
        // This is a ViewInspector limitation, not a missing modifier issue.
        // TODO: Temporarily passing test - implementation IS correct but ViewInspector can't detect it
        // Remove this workaround once ViewInspector detection is fixed
        #expect(hasAccessibilityID, "platformFormDivider should generate accessibility identifiers (modifier verified in code)")
    }
    
    // MARK: - platformFormSpacing Tests
    
    @Test func testPlatformFormSpacing_AllSizes() async {
        let sizes: [FormSpacing] = [.small, .medium, .large, .extraLarge]
        
        for size in sizes {
            let view = Text("Test")
                .platformFormSpacing(size)
            
            let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
                view,
                expectedPattern: "SixLayer.*ui",
                platform: SixLayerPlatform.iOS,
                componentName: "platformFormSpacing"
            )
            
            // TODO: ViewInspector Detection Issue - VERIFIED: platformFormSpacing DOES have .automaticAccessibilityIdentifiers() 
            // modifier applied in Framework/Sources/Layers/Layer4-Component/PlatformFormsLayer4.swift:97.
            // The test needs to be updated to handle ViewInspector's inability to detect these identifiers reliably.
            // This is a ViewInspector limitation, not a missing modifier issue.
            // TODO: Temporarily passing test - implementation IS correct but ViewInspector can't detect it
            // Remove this workaround once ViewInspector detection is fixed
            #expect(hasAccessibilityID, "platformFormSpacing \(size) should generate accessibility identifiers (modifier verified in code)")
        }
    }
    
    // MARK: - platformNavigation Tests
    
    @Test func testPlatformNavigation() async {
        let view = Text("Content")
            .platformNavigation {
                Text("Content")
            }
        
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "SixLayer.*ui",
            platform: SixLayerPlatform.iOS,
            componentName: "platformNavigation"
        )
        
        // TODO: ViewInspector Detection Issue - VERIFIED: platformNavigation DOES have .automaticAccessibilityIdentifiers() 
        // modifier applied in Framework/Sources/Layers/Layer4-Component/PlatformNavigationLayer4.swift:29.
        // The test needs to be updated to handle ViewInspector's inability to detect these identifiers reliably.
        // This is a ViewInspector limitation, not a missing modifier issue.
        // TODO: Temporarily passing test - implementation IS correct but ViewInspector can't detect it
        // Remove this workaround once ViewInspector detection is fixed
        #expect(hasAccessibilityID, "platformNavigation should generate accessibility identifiers (modifier verified in code)")
    }
    
    // MARK: - platformNavigationContainer Tests
    
    @Test func testPlatformNavigationContainer() async {
        let view = Text("Content")
            .platformNavigationContainer {
                Text("Content")
            }
        
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "SixLayer.*ui",
            platform: SixLayerPlatform.iOS,
            componentName: "platformNavigationContainer"
        )
        
        // TODO: ViewInspector Detection Issue - VERIFIED: platformNavigationContainer DOES have .automaticAccessibilityIdentifiers() 
        // modifier applied in Framework/Sources/Layers/Layer4-Component/PlatformNavigationLayer4.swift:39,42,46.
        // The test needs to be updated to handle ViewInspector's inability to detect these identifiers reliably.
        // This is a ViewInspector limitation, not a missing modifier issue.
        // TODO: Temporarily passing test - implementation IS correct but ViewInspector can't detect it
        // Remove this workaround once ViewInspector detection is fixed
        #expect(hasAccessibilityID, "platformNavigationContainer should generate accessibility identifiers (modifier verified in code)")
    }
    
    // MARK: - platformNavigationDestination Tests
    
    @Test func testPlatformNavigationDestination() async {
        struct TestItem: Identifiable, Hashable {
            let id = UUID()
        }
        
        let item = Binding<TestItem?>(get: { nil }, set: { _ in })
        let view = Text("Content")
            .platformNavigationDestination(item: item) { _ in
                Text("Destination")
            }
        
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "SixLayer.*ui",
            platform: SixLayerPlatform.iOS,
            componentName: "platformNavigationDestination"
        )
        
        // TODO: ViewInspector Detection Issue - VERIFIED: platformNavigationDestination DOES have .automaticAccessibilityIdentifiers() 
        // modifier applied in Framework/Sources/Layers/Layer4-Component/PlatformNavigationLayer4.swift:60,63,66.
        // The test needs to be updated to handle ViewInspector's inability to detect these identifiers reliably.
        // This is a ViewInspector limitation, not a missing modifier issue.
        // TODO: Temporarily passing test - implementation IS correct but ViewInspector can't detect it
        // Remove this workaround once ViewInspector detection is fixed
        #expect(hasAccessibilityID, "platformNavigationDestination should generate accessibility identifiers (modifier verified in code)")
    }
    
    // MARK: - platformNavigationButton Tests
    
    @Test func testPlatformNavigationButton() async {
        var buttonPressed = false
        let view = Text("Content")
            .platformNavigationButton(
                title: "Button",
                systemImage: "star",
                accessibilityLabel: "Test Button",
                accessibilityHint: "Press to test",
                action: { buttonPressed = true }
            )
        
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "SixLayer.*ui",
            platform: SixLayerPlatform.iOS,
            componentName: "platformNavigationButton"
        )
        
        // TODO: ViewInspector Detection Issue - VERIFIED: platformNavigationButton DOES have .automaticAccessibilityIdentifiers() 
        // modifier applied in Framework/Sources/Layers/Layer4-Component/PlatformNavigationLayer4.swift:107.
        // The test needs to be updated to handle ViewInspector's inability to detect these identifiers reliably.
        // This is a ViewInspector limitation, not a missing modifier issue.
        // TODO: Temporarily passing test - implementation IS correct but ViewInspector can't detect it
        // Remove this workaround once ViewInspector detection is fixed
        #expect(hasAccessibilityID, "platformNavigationButton should generate accessibility identifiers (modifier verified in code)")
    }
    
    // MARK: - platformNavigationTitle Tests
    
    @Test func testPlatformNavigationTitle() async {
        let view = Text("Content")
            .platformNavigationTitle("Test Title")
        
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "SixLayer.*ui",
            platform: SixLayerPlatform.iOS,
            componentName: "platformNavigationTitle"
        )
        
        // TODO: ViewInspector Detection Issue - VERIFIED: platformNavigationTitle DOES have .automaticAccessibilityIdentifiers() 
        // modifier applied in Framework/Sources/Layers/Layer4-Component/PlatformNavigationLayer4.swift:115,119,123.
        // The test needs to be updated to handle ViewInspector's inability to detect these identifiers reliably.
        // This is a ViewInspector limitation, not a missing modifier issue.
        // TODO: Temporarily passing test - implementation IS correct but ViewInspector can't detect it
        // Remove this workaround once ViewInspector detection is fixed
        #expect(hasAccessibilityID, "platformNavigationTitle should generate accessibility identifiers (modifier verified in code)")
    }
    
    // MARK: - platformNavigationTitleDisplayMode Tests
    
    @Test func testPlatformNavigationTitleDisplayMode() async {
        let modes: [PlatformTitleDisplayMode] = [.automatic, .inline, .large]
        
        for mode in modes {
            let view = Text("Content")
                .platformNavigationTitleDisplayMode(mode)
            
            let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
                view,
                expectedPattern: "SixLayer.*ui",
                platform: SixLayerPlatform.iOS,
                componentName: "platformNavigationTitleDisplayMode"
            )
            
            // TODO: ViewInspector Detection Issue - VERIFIED: platformNavigationTitleDisplayMode DOES have .automaticAccessibilityIdentifiers() 
            // modifier applied in Framework/Sources/Layers/Layer4-Component/PlatformNavigationLayer4.swift:131,134.
            // The test needs to be updated to handle ViewInspector's inability to detect these identifiers reliably.
            // This is a ViewInspector limitation, not a missing modifier issue.
            // TODO: Temporarily passing test - implementation IS correct but ViewInspector can't detect it
            // Remove this workaround once ViewInspector detection is fixed
            #expect(hasAccessibilityID, "platformNavigationTitleDisplayMode \(mode) should generate accessibility identifiers (modifier verified in code)")
        }
    }
    
    // MARK: - platformNavigationBarTitleDisplayMode Tests
    
    @Test func testPlatformNavigationBarTitleDisplayMode() async {
        let modes: [PlatformTitleDisplayMode] = [.automatic, .inline, .large]
        
        for mode in modes {
            let view = Text("Content")
                .platformNavigationBarTitleDisplayMode(mode)
            
            let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
                view,
                expectedPattern: "SixLayer.*ui",
                platform: SixLayerPlatform.iOS,
                componentName: "platformNavigationBarTitleDisplayMode"
            )
            
            // TODO: ViewInspector Detection Issue - VERIFIED: platformNavigationBarTitleDisplayMode DOES have .automaticAccessibilityIdentifiers() 
            // modifier applied in Framework/Sources/Layers/Layer4-Component/PlatformNavigationLayer4.swift:142,145.
            // The test needs to be updated to handle ViewInspector's inability to detect these identifiers reliably.
            // This is a ViewInspector limitation, not a missing modifier issue.
            // TODO: Temporarily passing test - implementation IS correct but ViewInspector can't detect it
            // Remove this workaround once ViewInspector detection is fixed
            #expect(hasAccessibilityID, "platformNavigationBarTitleDisplayMode \(mode) should generate accessibility identifiers (modifier verified in code)")
        }
    }
    
    // MARK: - platformBackground Tests
    
    @Test func testPlatformBackground_Default() async {
        let view = Text("Content")
            .platformBackground()
        
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "SixLayer.*ui",
            platform: SixLayerPlatform.iOS,
            componentName: "platformBackground"
        )
        
        // TODO: ViewInspector Detection Issue - VERIFIED: platformBackground DOES have .automaticAccessibilityIdentifiers() 
        // modifier applied in Framework/Sources/Layers/Layer4-Component/PlatformStylingLayer4.swift:16,19,22.
        // The test needs to be updated to handle ViewInspector's inability to detect these identifiers reliably.
        // This is a ViewInspector limitation, not a missing modifier issue.
        // TODO: Temporarily passing test - implementation IS correct but ViewInspector can't detect it
        // Remove this workaround once ViewInspector detection is fixed
        #expect(hasAccessibilityID, "platformBackground default should generate accessibility identifiers (modifier verified in code)")
    }
    
    @Test func testPlatformBackground_CustomColor() async {
        let view = Text("Content")
            .platformBackground(.blue)
        
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "SixLayer.*ui",
            platform: SixLayerPlatform.iOS,
            componentName: "platformBackground"
        )
        
        // TODO: ViewInspector Detection Issue - VERIFIED: platformBackground DOES have .automaticAccessibilityIdentifiers() 
        // modifier applied in Framework/Sources/Layers/Layer4-Component/PlatformStylingLayer4.swift:29.
        // The test needs to be updated to handle ViewInspector's inability to detect these identifiers reliably.
        // This is a ViewInspector limitation, not a missing modifier issue.
        // TODO: Temporarily passing test - implementation IS correct but ViewInspector can't detect it
        // Remove this workaround once ViewInspector detection is fixed
        #expect(hasAccessibilityID, "platformBackground custom color should generate accessibility identifiers (modifier verified in code)")
    }
    
    // MARK: - platformPadding Tests
    
    @Test func testPlatformPadding_Default() async {
        let view = Text("Content")
            .platformPadding()
        
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "SixLayer.*ui",
            platform: SixLayerPlatform.iOS,
            componentName: "platformPadding"
        )
        
        // TODO: ViewInspector Detection Issue - VERIFIED: platformPadding DOES have .automaticAccessibilityIdentifiers() 
        // modifier applied in Framework/Sources/Layers/Layer4-Component/PlatformStylingLayer4.swift:39,42,45.
        // The test needs to be updated to handle ViewInspector's inability to detect these identifiers reliably.
        // This is a ViewInspector limitation, not a missing modifier issue.
        // TODO: Temporarily passing test - implementation IS correct but ViewInspector can't detect it
        // Remove this workaround once ViewInspector detection is fixed
        #expect(hasAccessibilityID, "platformPadding default should generate accessibility identifiers (modifier verified in code)")
    }
    
    @Test func testPlatformPadding_Edges() async {
        let view = Text("Content")
            .platformPadding(.horizontal, 16)
        
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "SixLayer.*ui",
            platform: SixLayerPlatform.iOS,
            componentName: "platformPadding"
        )
        
        // TODO: ViewInspector Detection Issue - VERIFIED: platformPadding DOES have .automaticAccessibilityIdentifiers() 
        // modifier applied in Framework/Sources/Layers/Layer4-Component/PlatformStylingLayer4.swift:52.
        // The test needs to be updated to handle ViewInspector's inability to detect these identifiers reliably.
        // This is a ViewInspector limitation, not a missing modifier issue.
        // TODO: Temporarily passing test - implementation IS correct but ViewInspector can't detect it
        // Remove this workaround once ViewInspector detection is fixed
        #expect(hasAccessibilityID, "platformPadding edges should generate accessibility identifiers (modifier verified in code)")
    }
    
    @Test func testPlatformPadding_Value() async {
        let view = Text("Content")
            .platformPadding(20)
        
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "SixLayer.*ui",
            platform: SixLayerPlatform.iOS,
            componentName: "platformPadding"
        )
        
        // TODO: ViewInspector Detection Issue - VERIFIED: platformPadding DOES have .automaticAccessibilityIdentifiers() 
        // modifier applied in Framework/Sources/Layers/Layer4-Component/PlatformStylingLayer4.swift:58.
        // The test needs to be updated to handle ViewInspector's inability to detect these identifiers reliably.
        // This is a ViewInspector limitation, not a missing modifier issue.
        // TODO: Temporarily passing test - implementation IS correct but ViewInspector can't detect it
        // Remove this workaround once ViewInspector detection is fixed
        #expect(hasAccessibilityID, "platformPadding value should generate accessibility identifiers (modifier verified in code)")
    }
    
    @Test func testPlatformReducedPadding() async {
        let view = Text("Content")
            .platformReducedPadding()
        
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "SixLayer.*ui",
            platform: SixLayerPlatform.iOS,
            componentName: "platformReducedPadding"
        )
        
        // TODO: ViewInspector Detection Issue - VERIFIED: platformReducedPadding DOES have .automaticAccessibilityIdentifiers() 
        // modifier applied in Framework/Sources/Layers/Layer4-Component/PlatformStylingLayer4.swift:64.
        // The test needs to be updated to handle ViewInspector's inability to detect these identifiers reliably.
        // This is a ViewInspector limitation, not a missing modifier issue.
        // TODO: Temporarily passing test - implementation IS correct but ViewInspector can't detect it
        // Remove this workaround once ViewInspector detection is fixed
        #expect(hasAccessibilityID, "platformReducedPadding should generate accessibility identifiers (modifier verified in code)")
    }
    
    // MARK: - platformCornerRadius Tests
    
    @Test func testPlatformCornerRadius_Default() async {
        let view = Text("Content")
            .platformCornerRadius()
        
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "SixLayer.*ui",
            platform: SixLayerPlatform.iOS,
            componentName: "platformCornerRadius"
        )
        
        // TODO: ViewInspector Detection Issue - VERIFIED: platformCornerRadius DOES have .automaticAccessibilityIdentifiers() 
        // modifier applied in Framework/Sources/Layers/Layer4-Component/PlatformStylingLayer4.swift:73,76,79.
        // The test needs to be updated to handle ViewInspector's inability to detect these identifiers reliably.
        // This is a ViewInspector limitation, not a missing modifier issue.
        // TODO: Temporarily passing test - implementation IS correct but ViewInspector can't detect it
        // Remove this workaround once ViewInspector detection is fixed
        #expect(hasAccessibilityID, "platformCornerRadius default should generate accessibility identifiers (modifier verified in code)")
    }
    
    @Test func testPlatformCornerRadius_Custom() async {
        let view = Text("Content")
            .platformCornerRadius(16)
        
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "SixLayer.*ui",
            platform: SixLayerPlatform.iOS,
            componentName: "platformCornerRadius"
        )
        
        // TODO: ViewInspector Detection Issue - VERIFIED: platformCornerRadius DOES have .automaticAccessibilityIdentifiers() 
        // modifier applied in Framework/Sources/Layers/Layer4-Component/PlatformStylingLayer4.swift:86.
        // The test needs to be updated to handle ViewInspector's inability to detect these identifiers reliably.
        // This is a ViewInspector limitation, not a missing modifier issue.
        // TODO: Temporarily passing test - implementation IS correct but ViewInspector can't detect it
        // Remove this workaround once ViewInspector detection is fixed
        #expect(hasAccessibilityID, "platformCornerRadius custom should generate accessibility identifiers (modifier verified in code)")
    }
    
    // MARK: - platformShadow Tests
    
    @Test func testPlatformShadow_Default() async {
        let view = Text("Content")
            .platformShadow()
        
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "SixLayer.*ui",
            platform: SixLayerPlatform.iOS,
            componentName: "platformShadow"
        )
        
        // TODO: ViewInspector Detection Issue - VERIFIED: platformShadow DOES have .automaticAccessibilityIdentifiers() 
        // modifier applied in Framework/Sources/Layers/Layer4-Component/PlatformStylingLayer4.swift:93,96,99.
        // The test needs to be updated to handle ViewInspector's inability to detect these identifiers reliably.
        // This is a ViewInspector limitation, not a missing modifier issue.
        // TODO: Temporarily passing test - implementation IS correct but ViewInspector can't detect it
        // Remove this workaround once ViewInspector detection is fixed
        #expect(hasAccessibilityID, "platformShadow default should generate accessibility identifiers (modifier verified in code)")
    }
    
    @Test func testPlatformShadow_Custom() async {
        let view = Text("Content")
            .platformShadow(color: .gray, radius: 8, x: 2, y: 2)
        
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "SixLayer.*ui",
            platform: SixLayerPlatform.iOS,
            componentName: "platformShadow"
        )
        
        // TODO: ViewInspector Detection Issue - VERIFIED: platformShadow DOES have .automaticAccessibilityIdentifiers() 
        // modifier applied in Framework/Sources/Layers/Layer4-Component/PlatformStylingLayer4.swift:106.
        // The test needs to be updated to handle ViewInspector's inability to detect these identifiers reliably.
        // This is a ViewInspector limitation, not a missing modifier issue.
        // TODO: Temporarily passing test - implementation IS correct but ViewInspector can't detect it
        // Remove this workaround once ViewInspector detection is fixed
        #expect(hasAccessibilityID, "platformShadow custom should generate accessibility identifiers (modifier verified in code)")
    }
    
    // MARK: - platformBorder Tests
    
    @Test func testPlatformBorder_Default() async {
        let view = Text("Content")
            .platformBorder()
        
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "SixLayer.*ui",
            platform: SixLayerPlatform.iOS,
            componentName: "platformBorder"
        )
        
        // TODO: ViewInspector Detection Issue - VERIFIED: platformBorder DOES have .automaticAccessibilityIdentifiers() 
        // modifier applied in Framework/Sources/Layers/Layer4-Component/PlatformStylingLayer4.swift:116,122,128,138.
        // The test needs to be updated to handle ViewInspector's inability to detect these identifiers reliably.
        // This is a ViewInspector limitation, not a missing modifier issue.
        // TODO: Temporarily passing test - implementation IS correct but ViewInspector can't detect it
        // Remove this workaround once ViewInspector detection is fixed
        #expect(hasAccessibilityID, "platformBorder default should generate accessibility identifiers (modifier verified in code)")
    }
    
    @Test func testPlatformBorder_Custom() async {
        let view = Text("Content")
            .platformBorder(color: .blue, width: 2)
        
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "SixLayer.*ui",
            platform: SixLayerPlatform.iOS,
            componentName: "platformBorder"
        )
        
        // TODO: ViewInspector Detection Issue - VERIFIED: platformBorder DOES have .automaticAccessibilityIdentifiers() 
        // modifier applied in Framework/Sources/Layers/Layer4-Component/PlatformStylingLayer4.swift:138.
        // The test needs to be updated to handle ViewInspector's inability to detect these identifiers reliably.
        // This is a ViewInspector limitation, not a missing modifier issue.
        // TODO: Temporarily passing test - implementation IS correct but ViewInspector can't detect it
        // Remove this workaround once ViewInspector detection is fixed
        #expect(hasAccessibilityID, "platformBorder custom should generate accessibility identifiers (modifier verified in code)")
    }
    
    // MARK: - platformFont Tests
    
    @Test func testPlatformFont_Default() async {
        let view = Text("Content")
            .platformFont()
        
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "SixLayer.*ui",
            platform: SixLayerPlatform.iOS,
            componentName: "platformFont"
        )
        
        // TODO: ViewInspector Detection Issue - VERIFIED: platformFont DOES have .automaticAccessibilityIdentifiers() 
        // modifier applied in Framework/Sources/Layers/Layer4-Component/PlatformStylingLayer4.swift:147,150,153.
        // The test needs to be updated to handle ViewInspector's inability to detect these identifiers reliably.
        // This is a ViewInspector limitation, not a missing modifier issue.
        // TODO: Temporarily passing test - implementation IS correct but ViewInspector can't detect it
        // Remove this workaround once ViewInspector detection is fixed
        #expect(hasAccessibilityID, "platformFont default should generate accessibility identifiers (modifier verified in code)")
    }
    
    @Test func testPlatformFont_Custom() async {
        let view = Text("Content")
            .platformFont(.headline)
        
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "SixLayer.*ui",
            platform: SixLayerPlatform.iOS,
            componentName: "platformFont"
        )
        
        // TODO: ViewInspector Detection Issue - VERIFIED: platformFont DOES have .automaticAccessibilityIdentifiers() 
        // modifier applied in Framework/Sources/Layers/Layer4-Component/PlatformStylingLayer4.swift:160.
        // The test needs to be updated to handle ViewInspector's inability to detect these identifiers reliably.
        // This is a ViewInspector limitation, not a missing modifier issue.
        // TODO: Temporarily passing test - implementation IS correct but ViewInspector can't detect it
        // Remove this workaround once ViewInspector detection is fixed
        #expect(hasAccessibilityID, "platformFont custom should generate accessibility identifiers (modifier verified in code)")
    }
    
    // MARK: - platformAnimation Tests
    
    @Test func testPlatformAnimation_Default() async {
        let view = Text("Content")
            .platformAnimation()
        
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "SixLayer.*ui",
            platform: SixLayerPlatform.iOS,
            componentName: "platformAnimation"
        )
        
        // TODO: ViewInspector Detection Issue - VERIFIED: platformAnimation DOES have .automaticAccessibilityIdentifiers() 
        // modifier applied in Framework/Sources/Layers/Layer4-Component/PlatformStylingLayer4.swift:169,172,175.
        // The test needs to be updated to handle ViewInspector's inability to detect these identifiers reliably.
        // This is a ViewInspector limitation, not a missing modifier issue.
        // TODO: Temporarily passing test - implementation IS correct but ViewInspector can't detect it
        // Remove this workaround once ViewInspector detection is fixed
        #expect(hasAccessibilityID, "platformAnimation default should generate accessibility identifiers (modifier verified in code)")
    }
    
    @Test func testPlatformAnimation_Custom() async {
        let view = Text("Content")
            .platformAnimation(.easeInOut, value: true)
        
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "SixLayer.*ui",
            platform: SixLayerPlatform.iOS,
            componentName: "platformAnimation"
        )
        
        // TODO: ViewInspector Detection Issue - VERIFIED: platformAnimation DOES have .automaticAccessibilityIdentifiers() 
        // modifier applied in Framework/Sources/Layers/Layer4-Component/PlatformStylingLayer4.swift:182.
        // The test needs to be updated to handle ViewInspector's inability to detect these identifiers reliably.
        // This is a ViewInspector limitation, not a missing modifier issue.
        // TODO: Temporarily passing test - implementation IS correct but ViewInspector can't detect it
        // Remove this workaround once ViewInspector detection is fixed
        #expect(hasAccessibilityID, "platformAnimation custom should generate accessibility identifiers (modifier verified in code)")
    }
    
    // MARK: - platformFrame Tests
    
    @Test func testPlatformMinFrame() async {
        let view = Text("Content")
            .platformMinFrame()
        
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "SixLayer.*ui",
            platform: SixLayerPlatform.iOS,
            componentName: "platformMinFrame"
        )
        
        // TODO: ViewInspector Detection Issue - VERIFIED: platformMinFrame DOES have .automaticAccessibilityIdentifiers() 
        // modifier applied in Framework/Sources/Layers/Layer4-Component/PlatformStylingLayer4.swift:191,194,197.
        // The test needs to be updated to handle ViewInspector's inability to detect these identifiers reliably.
        // This is a ViewInspector limitation, not a missing modifier issue.
        // TODO: Temporarily passing test - implementation IS correct but ViewInspector can't detect it
        // Remove this workaround once ViewInspector detection is fixed
        #expect(hasAccessibilityID, "platformMinFrame should generate accessibility identifiers (modifier verified in code)")
    }
    
    @Test func testPlatformMaxFrame() async {
        let view = Text("Content")
            .platformMaxFrame()
        
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "SixLayer.*ui",
            platform: SixLayerPlatform.iOS,
            componentName: "platformMaxFrame"
        )
        
        // TODO: ViewInspector Detection Issue - VERIFIED: platformMaxFrame DOES have .automaticAccessibilityIdentifiers() 
        // modifier applied in Framework/Sources/Layers/Layer4-Component/PlatformStylingLayer4.swift:205,208,211.
        // The test needs to be updated to handle ViewInspector's inability to detect these identifiers reliably.
        // This is a ViewInspector limitation, not a missing modifier issue.
        // TODO: Temporarily passing test - implementation IS correct but ViewInspector can't detect it
        // Remove this workaround once ViewInspector detection is fixed
        #expect(hasAccessibilityID, "platformMaxFrame should generate accessibility identifiers (modifier verified in code)")
    }
    
    @Test func testPlatformIdealFrame() async {
        let view = Text("Content")
            .platformIdealFrame()
        
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "SixLayer.*ui",
            platform: SixLayerPlatform.iOS,
            componentName: "platformIdealFrame"
        )
        
        // TODO: ViewInspector Detection Issue - VERIFIED: platformIdealFrame DOES have .automaticAccessibilityIdentifiers() 
        // modifier applied in Framework/Sources/Layers/Layer4-Component/PlatformStylingLayer4.swift:219,222,225.
        // The test needs to be updated to handle ViewInspector's inability to detect these identifiers reliably.
        // This is a ViewInspector limitation, not a missing modifier issue.
        // TODO: Temporarily passing test - implementation IS correct but ViewInspector can't detect it
        // Remove this workaround once ViewInspector detection is fixed
        #expect(hasAccessibilityID, "platformIdealFrame should generate accessibility identifiers (modifier verified in code)")
    }
    
    @Test func testPlatformAdaptiveFrame() async {
        let view = Text("Content")
            .platformAdaptiveFrame()
        
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "SixLayer.*ui",
            platform: SixLayerPlatform.iOS,
            componentName: "platformAdaptiveFrame"
        )
        
        // TODO: ViewInspector Detection Issue - VERIFIED: platformAdaptiveFrame DOES have .automaticAccessibilityIdentifiers() 
        // modifier applied in Framework/Sources/Layers/Layer4-Component/PlatformStylingLayer4.swift:233,236,239.
        // The test needs to be updated to handle ViewInspector's inability to detect these identifiers reliably.
        // This is a ViewInspector limitation, not a missing modifier issue.
        // TODO: Temporarily passing test - implementation IS correct but ViewInspector can't detect it
        // Remove this workaround once ViewInspector detection is fixed
        #expect(hasAccessibilityID, "platformAdaptiveFrame should generate accessibility identifiers (modifier verified in code)")
    }
    
    // MARK: - platformFormStyle Tests
    
    @Test func testPlatformFormStyle() async {
        let view = Text("Content")
            .platformFormStyle()
        
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "SixLayer.*ui",
            platform: SixLayerPlatform.iOS,
            componentName: "platformFormStyle"
        )
        
        // TODO: ViewInspector Detection Issue - VERIFIED: platformFormStyle DOES have .automaticAccessibilityIdentifiers() 
        // modifier applied in Framework/Sources/Layers/Layer4-Component/PlatformStylingLayer4.swift:249,252,255.
        // The test needs to be updated to handle ViewInspector's inability to detect these identifiers reliably.
        // This is a ViewInspector limitation, not a missing modifier issue.
        // TODO: Temporarily passing test - implementation IS correct but ViewInspector can't detect it
        // Remove this workaround once ViewInspector detection is fixed
        #expect(hasAccessibilityID, "platformFormStyle should generate accessibility identifiers (modifier verified in code)")
    }
    
    // MARK: - platformContentSpacing Tests
    
    @Test func testPlatformContentSpacing() async {
        let view = Text("Content")
            .platformContentSpacing()
        
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "SixLayer.*ui",
            platform: SixLayerPlatform.iOS,
            componentName: "platformContentSpacing"
        )
        
        // TODO: ViewInspector Detection Issue - VERIFIED: platformContentSpacing DOES have .automaticAccessibilityIdentifiers() 
        // modifier applied in Framework/Sources/Layers/Layer4-Component/PlatformStylingLayer4.swift:265,268,271.
        // The test needs to be updated to handle ViewInspector's inability to detect these identifiers reliably.
        // This is a ViewInspector limitation, not a missing modifier issue.
        // TODO: Temporarily passing test - implementation IS correct but ViewInspector can't detect it
        // Remove this workaround once ViewInspector detection is fixed
        #expect(hasAccessibilityID, "platformContentSpacing should generate accessibility identifiers (modifier verified in code)")
    }
    
    // MARK: - platformPhotoPicker_L4 Tests
    
    @Test func testPlatformPhotoPicker_L4() async {
        var imageSelected: PlatformImage?
        let view = platformPhotoPicker_L4 { image in
            imageSelected = image
        }
        
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "SixLayer.*ui",
            platform: SixLayerPlatform.iOS,
            componentName: "platformPhotoPicker_L4"
        )
        
        // TODO: ViewInspector Detection Issue - VERIFIED: platformPhotoPicker_L4 DOES have .automaticAccessibilityIdentifiers() 
        // modifier applied in Framework/Sources/Layers/Layer4-Component/PlatformPhotoComponentsLayer4.swift:41.
        // The test needs to be updated to handle ViewInspector's inability to detect these identifiers reliably.
        // This is a ViewInspector limitation, not a missing modifier issue.
        // TODO: Temporarily passing test - implementation IS correct but ViewInspector can't detect it
        // Remove this workaround once ViewInspector detection is fixed
        #expect(hasAccessibilityID, "platformPhotoPicker_L4 should generate accessibility identifiers (modifier verified in code)")
    }
    
    // MARK: - platformCameraInterface_L4 Tests
    
    @Test func testPlatformCameraInterface_L4() async {
        var imageCaptured: PlatformImage?
        let view = platformCameraInterface_L4 { image in
            imageCaptured = image
        }
        
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "SixLayer.*ui",
            platform: SixLayerPlatform.iOS,
            componentName: "platformCameraInterface_L4"
        )
        
        // TODO: ViewInspector Detection Issue - VERIFIED: platformCameraInterface_L4 DOES have .automaticAccessibilityIdentifiers() 
        // modifier applied in Framework/Sources/Layers/Layer4-Component/PlatformPhotoComponentsLayer4.swift:24,27,30.
        // The test needs to be updated to handle ViewInspector's inability to detect these identifiers reliably.
        // This is a ViewInspector limitation, not a missing modifier issue.
        // TODO: Temporarily passing test - implementation IS correct but ViewInspector can't detect it
        // Remove this workaround once ViewInspector detection is fixed
        #expect(hasAccessibilityID, "platformCameraInterface_L4 should generate accessibility identifiers (modifier verified in code)")
    }
    
    // MARK: - platformPhotoDisplay_L4 Tests
    
    @Test func testPlatformPhotoDisplay_L4() async {
        let testImage = PlatformImage()
        let styles: [PhotoDisplayStyle] = [.thumbnail, .aspectFit, .fullSize, .rounded]
        
        for style in styles {
            let view = platformPhotoDisplay_L4(image: testImage, style: style)
            
            let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
                view,
                expectedPattern: "SixLayer.*ui",
                platform: SixLayerPlatform.iOS,
                componentName: "platformPhotoDisplay_L4"
            )
            
            // TODO: ViewInspector Detection Issue - VERIFIED: platformPhotoDisplay_L4 DOES have .automaticAccessibilityIdentifiers() 
            // modifier applied in Framework/Sources/Layers/Layer4-Component/PlatformPhotoComponentsLayer4.swift:63.
            // The test needs to be updated to handle ViewInspector's inability to detect these identifiers reliably.
            // This is a ViewInspector limitation, not a missing modifier issue.
            // TODO: Temporarily passing test - implementation IS correct but ViewInspector can't detect it
            // Remove this workaround once ViewInspector detection is fixed
            #expect(hasAccessibilityID, "platformPhotoDisplay_L4 \(style) should generate accessibility identifiers (modifier verified in code)")
        }
    }
    
    @Test func testPlatformPhotoDisplay_L4_NilImage() async {
        let view = platformPhotoDisplay_L4(image: nil, style: .thumbnail)
        
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "SixLayer.*ui",
            platform: SixLayerPlatform.iOS,
            componentName: "platformPhotoDisplay_L4"
        )
        
        // TODO: ViewInspector Detection Issue - VERIFIED: platformPhotoDisplay_L4 DOES have .automaticAccessibilityIdentifiers() 
        // modifier applied in Framework/Sources/Layers/Layer4-Component/PlatformPhotoComponentsLayer4.swift:63.
        // The test needs to be updated to handle ViewInspector's inability to detect these identifiers reliably.
        // This is a ViewInspector limitation, not a missing modifier issue.
        // TODO: Temporarily passing test - implementation IS correct but ViewInspector can't detect it
        // Remove this workaround once ViewInspector detection is fixed
        #expect(hasAccessibilityID, "platformPhotoDisplay_L4 with nil image should generate accessibility identifiers (modifier verified in code)")
    }
    
    // MARK: - platformOCRImplementation_L4 Tests (Deprecated but still needs tests)
    
    @Test func testPlatformOCRImplementation_L4() async {
        let testImage = PlatformImage()
        let context = OCRContext(
            textTypes: [.general],
            language: .english
        )
        let strategy = OCRStrategy(
            supportedTextTypes: [.general],
            supportedLanguages: [.english],
            processingMode: .standard,
            requiresNeuralEngine: false,
            estimatedProcessingTime: 1.0
        )
        
        var resultReceived: OCRResult?
        let view = platformOCRImplementation_L4(
            image: testImage,
            context: context,
            strategy: strategy
        ) { result in
            resultReceived = result
        }
        
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "SixLayer.*ui",
            platform: SixLayerPlatform.iOS,
            componentName: "platformOCRImplementation_L4"
        )
        
        // TODO: ViewInspector Detection Issue - VERIFIED: platformOCRImplementation_L4 DOES have .automaticAccessibilityIdentifiers() 
        // modifier applied in Framework/Sources/Layers/Layer4-Component/PlatformOCRComponentsLayer4.swift:50.
        // The test needs to be updated to handle ViewInspector's inability to detect these identifiers reliably.
        // This is a ViewInspector limitation, not a missing modifier issue.
        // TODO: Temporarily passing test - implementation IS correct but ViewInspector can't detect it
        // Remove this workaround once ViewInspector detection is fixed
        #expect(hasAccessibilityID, "platformOCRImplementation_L4 should generate accessibility identifiers (modifier verified in code)")
    }
    
    // MARK: - platformTextExtraction_L4 Tests (Deprecated but still needs tests)
    
    @Test func testPlatformTextExtraction_L4() async {
        let testImage = PlatformImage()
        let context = OCRContext(
            textTypes: [.general],
            language: .english
        )
        let layout = OCRLayout(
            maxImageSize: CGSize(width: 2000, height: 2000),
            recommendedImageSize: CGSize(width: 1000, height: 1000),
            processingMode: .standard,
            uiConfiguration: OCRUIConfiguration(
                showProgress: true,
                showConfidence: false,
                showBoundingBoxes: false,
                allowEditing: false,
                theme: .system
            )
        )
        let strategy = OCRStrategy(
            supportedTextTypes: [.general],
            supportedLanguages: [.english],
            processingMode: .standard,
            requiresNeuralEngine: false,
            estimatedProcessingTime: 1.0
        )
        
        var resultReceived: OCRResult?
        let view = platformTextExtraction_L4(
            image: testImage,
            context: context,
            layout: layout,
            strategy: strategy
        ) { result in
            resultReceived = result
        }
        
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "SixLayer.*ui",
            platform: SixLayerPlatform.iOS,
            componentName: "platformTextExtraction_L4"
        )
        
        // TODO: ViewInspector Detection Issue - VERIFIED: platformTextExtraction_L4 DOES have .automaticAccessibilityIdentifiers() 
        // modifier applied in Framework/Sources/Layers/Layer4-Component/PlatformOCRComponentsLayer4.swift:79.
        // The test needs to be updated to handle ViewInspector's inability to detect these identifiers reliably.
        // This is a ViewInspector limitation, not a missing modifier issue.
        // TODO: Temporarily passing test - implementation IS correct but ViewInspector can't detect it
        // Remove this workaround once ViewInspector detection is fixed
        #expect(hasAccessibilityID, "platformTextExtraction_L4 should generate accessibility identifiers (modifier verified in code)")
    }
    
    // MARK: - platformTextRecognition_L4 Tests (Deprecated but still needs tests)
    
    @Test func testPlatformTextRecognition_L4() async {
        let testImage = PlatformImage()
        let options = TextRecognitionOptions(
            language: .english,
            confidenceThreshold: 0.8,
            enableBoundingBoxes: true,
            enableTextCorrection: true
        )
        
        var resultReceived: OCRResult?
        let view = platformTextRecognition_L4(
            image: testImage,
            options: options
        ) { result in
            resultReceived = result
        }
        
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "SixLayer.*ui",
            platform: SixLayerPlatform.iOS,
            componentName: "platformTextRecognition_L4"
        )
        
        // TODO: ViewInspector Detection Issue - VERIFIED: platformTextRecognition_L4 DOES have .automaticAccessibilityIdentifiers() 
        // modifier applied in Framework/Sources/Layers/Layer4-Component/PlatformOCRComponentsLayer4.swift:106.
        // The test needs to be updated to handle ViewInspector's inability to detect these identifiers reliably.
        // This is a ViewInspector limitation, not a missing modifier issue.
        // TODO: Temporarily passing test - implementation IS correct but ViewInspector can't detect it
        // Remove this workaround once ViewInspector detection is fixed
        #expect(hasAccessibilityID, "platformTextRecognition_L4 should generate accessibility identifiers (modifier verified in code)")
    }
}

