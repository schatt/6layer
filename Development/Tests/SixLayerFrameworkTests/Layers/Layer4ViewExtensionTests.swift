import Testing
import SwiftUI
@testable import SixLayerFramework
#if !os(macOS)
import ViewInspector
#endif

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
        
        #expect(hasAccessibilityID, "platformFormField with label should generate accessibility identifiers")
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
        
        #expect(hasAccessibilityID, "platformFormField without label should generate accessibility identifiers")
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
        
        #expect(hasAccessibilityID, "platformFormFieldGroup with title should generate accessibility identifiers")
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
        
        #expect(hasAccessibilityID, "platformFormFieldGroup without title should generate accessibility identifiers")
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
        
        #expect(hasAccessibilityID, "platformValidationMessage error should generate accessibility identifiers")
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
            
            #expect(hasAccessibilityID, "platformValidationMessage \(type) should generate accessibility identifiers")
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
        
        #expect(hasAccessibilityID, "platformFormDivider should generate accessibility identifiers")
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
            
            #expect(hasAccessibilityID, "platformFormSpacing \(size) should generate accessibility identifiers")
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
        
        #expect(hasAccessibilityID, "platformNavigation should generate accessibility identifiers")
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
        
        #expect(hasAccessibilityID, "platformNavigationContainer should generate accessibility identifiers")
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
        
        #expect(hasAccessibilityID, "platformNavigationDestination should generate accessibility identifiers")
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
        
        #expect(hasAccessibilityID, "platformNavigationButton should generate accessibility identifiers")
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
        
        #expect(hasAccessibilityID, "platformNavigationTitle should generate accessibility identifiers")
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
            
            #expect(hasAccessibilityID, "platformNavigationTitleDisplayMode \(mode) should generate accessibility identifiers")
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
            
            #expect(hasAccessibilityID, "platformNavigationBarTitleDisplayMode \(mode) should generate accessibility identifiers")
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
        
        #expect(hasAccessibilityID, "platformBackground default should generate accessibility identifiers")
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
        
        #expect(hasAccessibilityID, "platformBackground custom color should generate accessibility identifiers")
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
        
        #expect(hasAccessibilityID, "platformPadding default should generate accessibility identifiers")
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
        
        #expect(hasAccessibilityID, "platformPadding edges should generate accessibility identifiers")
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
        
        #expect(hasAccessibilityID, "platformPadding value should generate accessibility identifiers")
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
        
        #expect(hasAccessibilityID, "platformReducedPadding should generate accessibility identifiers")
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
        
        #expect(hasAccessibilityID, "platformCornerRadius default should generate accessibility identifiers")
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
        
        #expect(hasAccessibilityID, "platformCornerRadius custom should generate accessibility identifiers")
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
        
        #expect(hasAccessibilityID, "platformShadow default should generate accessibility identifiers")
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
        
        #expect(hasAccessibilityID, "platformShadow custom should generate accessibility identifiers")
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
        
        #expect(hasAccessibilityID, "platformBorder default should generate accessibility identifiers")
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
        
        #expect(hasAccessibilityID, "platformBorder custom should generate accessibility identifiers")
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
        
        #expect(hasAccessibilityID, "platformFont default should generate accessibility identifiers")
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
        
        #expect(hasAccessibilityID, "platformFont custom should generate accessibility identifiers")
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
        
        #expect(hasAccessibilityID, "platformAnimation default should generate accessibility identifiers")
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
        
        #expect(hasAccessibilityID, "platformAnimation custom should generate accessibility identifiers")
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
        
        #expect(hasAccessibilityID, "platformMinFrame should generate accessibility identifiers")
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
        
        #expect(hasAccessibilityID, "platformMaxFrame should generate accessibility identifiers")
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
        
        #expect(hasAccessibilityID, "platformIdealFrame should generate accessibility identifiers")
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
        
        #expect(hasAccessibilityID, "platformAdaptiveFrame should generate accessibility identifiers")
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
        
        #expect(hasAccessibilityID, "platformFormStyle should generate accessibility identifiers")
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
        
        #expect(hasAccessibilityID, "platformContentSpacing should generate accessibility identifiers")
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
        
        #expect(hasAccessibilityID, "platformPhotoPicker_L4 should generate accessibility identifiers")
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
        
        #expect(hasAccessibilityID, "platformCameraInterface_L4 should generate accessibility identifiers")
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
            
            #expect(hasAccessibilityID, "platformPhotoDisplay_L4 \(style) should generate accessibility identifiers")
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
        
        #expect(hasAccessibilityID, "platformPhotoDisplay_L4 with nil image should generate accessibility identifiers")
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
        
        #expect(hasAccessibilityID, "platformOCRImplementation_L4 should generate accessibility identifiers")
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
        
        #expect(hasAccessibilityID, "platformTextExtraction_L4 should generate accessibility identifiers")
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
        
        #expect(hasAccessibilityID, "platformTextRecognition_L4 should generate accessibility identifiers")
    }
}

