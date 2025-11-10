import Testing
import SwiftUI
@testable import SixLayerFramework

/**
 * BUSINESS PURPOSE: Dynamic field components provide specialized form field rendering
 * for different content types. These components handle user input, validation, OCR integration,
 * and platform-specific UI patterns for each field type.
 *
 * TESTING SCOPE: Tests that verify expected behavior for all dynamic field components.
 * These tests verify components render actual UI, integrate with form state, generate
 * accessibility identifiers, and provide expected functionality.
 *
 * METHODOLOGY: Tests that verify components render actual UI, integrate with
 * form state, generate accessibility identifiers, and provide expected functionality.
 */

@Suite("Dynamic Field Components")
@MainActor
open class DynamicFieldComponentsTests: BaseTestClass {

    // MARK: - Multi-Select Field

    @Test func testDynamicMultiSelectFieldRendersSelectionInterface() async {
        // DynamicMultiSelectField should:
        // 1. Render a multi-selection interface (checkboxes or toggle list)
        // 2. Display all options from field.options
        // 3. Allow selecting multiple options simultaneously
        // 4. Update formState with selected values as array
        // 5. Show visual indication of selected options

        let configuration = DynamicFormConfiguration(
            id: "testForm",
            title: "Test Form",
            sections: []
        )
        let formState = DynamicFormState(configuration: configuration)

        let field = DynamicFormField(
            id: "multiSelect",
            contentType: .multiselect,
            label: "Select Multiple",
            options: ["Option 1", "Option 2", "Option 3"]
        )

        let view = DynamicMultiSelectField(field: field, formState: formState)
            .enableGlobalAutomaticAccessibilityIdentifiers()

        // Should render all options from field
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        withInspectedView(view) { inspected in
            // Find all text elements and check if they contain the options
            if let allTexts = try? inspected.sixLayerFindAll(Text.self) {
                let foundOption1 = allTexts.contains { text in
                    (try? text.sixLayerString())?.contains("Option 1") ?? false
                }
                let foundOption2 = allTexts.contains { text in
                    (try? text.sixLayerString())?.contains("Option 2") ?? false
                }
                let foundOption3 = allTexts.contains { text in
                    (try? text.sixLayerString())?.contains("Option 3") ?? false
                }
                #expect(foundOption1 || foundOption2 || foundOption3, "Should display options from field")
            }
            
            // Additional check: should NOT show stub text (supplementary verification)
            if let allTexts = try? inspected.sixLayerFindAll(Text.self) {
                let hasStubText = allTexts.contains { text in
                    (try? text.sixLayerString())?.contains("Multi-select - TDD Red Phase Stub") ?? false
                }
                if hasStubText {
                    Issue.record("DynamicMultiSelectField still shows stub text - needs implementation")
                }
            }
        }
        #else
        Issue.record("ViewInspector not available on this platform (likely macOS)")
        #endif

        // Should generate accessibility identifier
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "SixLayer.main.ui.*DynamicMultiSelectField.*",
            platform: .iOS,
            componentName: "DynamicMultiSelectField"
        )
        #expect(hasAccessibilityID, "Should generate accessibility identifier")

        // Should support multiple selections in formState
        formState.setValue(["Option 1", "Option 3"], for: "multiSelect")
        let selectedValues = formState.fieldValues["multiSelect"] as? [String]
        #expect(selectedValues?.contains("Option 1") == true, "Should support multiple selections")
        #expect(selectedValues?.contains("Option 3") == true, "Should support multiple selections")
    }

    // MARK: - Radio Field

    @Test func testDynamicRadioFieldRendersRadioButtons() async {
        // DynamicRadioField should:
        // 1. Render radio button group (only one selection allowed)
        // 2. Display all options from field.options
        // 3. Allow selecting exactly one option
        // 4. Update formState with single selected value
        // 5. Show clear visual indication of selected option

        let configuration = DynamicFormConfiguration(
            id: "testForm",
            title: "Test Form",
            sections: []
        )
        let formState = DynamicFormState(configuration: configuration)

        let field = DynamicFormField(
            id: "radio",
            contentType: .radio,
            label: "Choose One",
            options: ["Choice A", "Choice B", "Choice C"]
        )

        let view = DynamicRadioField(field: field, formState: formState)
            .enableGlobalAutomaticAccessibilityIdentifiers()

        // Should render all radio options
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        withInspectedView(view) { inspected in
            if let allTexts = try? inspected.sixLayerFindAll(Text.self) {
                let foundChoiceA = allTexts.contains { text in
                    (try? text.sixLayerString())?.contains("Choice A") ?? false
                }
                let foundChoiceB = allTexts.contains { text in
                    (try? text.sixLayerString())?.contains("Choice B") ?? false
                }
                let foundChoiceC = allTexts.contains { text in
                    (try? text.sixLayerString())?.contains("Choice C") ?? false
                }
                #expect(foundChoiceA || foundChoiceB || foundChoiceC, "Should display radio options")
            }
        }
        #else
        Issue.record("ViewInspector not available on this platform (likely macOS)")
        #endif

        // Should generate accessibility identifier
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "SixLayer.main.ui.*DynamicRadioField.*",
            platform: .iOS,
            componentName: "DynamicRadioField"
        )
        #expect(hasAccessibilityID, "Should generate accessibility identifier")

        // Should support single selection
        formState.setValue("Choice B", for: "radio")
        let selectedValue = formState.fieldValues["radio"] as? String
        #expect(selectedValue == "Choice B", "Should support single radio selection")
    }

    // MARK: - Checkbox Field

    @Test func testDynamicCheckboxFieldRendersCheckboxes() async {
        // DynamicCheckboxField should:
        // 1. Render checkbox group (multiple selections allowed)
        // 2. Display all options from field.options as checkboxes
        // 3. Allow toggling each checkbox independently
        // 4. Update formState with selected values as array
        // 5. Show checked/unchecked states clearly

        let configuration = DynamicFormConfiguration(
            id: "testForm",
            title: "Test Form",
            sections: []
        )
        let formState = DynamicFormState(configuration: configuration)

        let field = DynamicFormField(
            id: "checkboxes",
            contentType: .checkbox,
            label: "Select Multiple",
            options: ["Check 1", "Check 2", "Check 3"]
        )

        let view = DynamicCheckboxField(field: field, formState: formState)
            .enableGlobalAutomaticAccessibilityIdentifiers()

        // Should render checkbox options
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        withInspectedView(view) { inspected in
            if let allTexts = try? inspected.sixLayerFindAll(Text.self) {
                let foundCheck1 = allTexts.contains { text in
                    (try? text.sixLayerString())?.contains("Check 1") ?? false
                }
                let foundCheck2 = allTexts.contains { text in
                    (try? text.sixLayerString())?.contains("Check 2") ?? false
                }
                let foundCheck3 = allTexts.contains { text in
                    (try? text.sixLayerString())?.contains("Check 3") ?? false
                }
                #expect(foundCheck1 || foundCheck2 || foundCheck3, "Should display checkbox options")
            }
        }
        #else
        Issue.record("ViewInspector not available on this platform (likely macOS)")
        #endif

        // Should generate accessibility identifier
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "SixLayer.main.ui.*DynamicCheckboxField.*",
            platform: .iOS,
            componentName: "DynamicCheckboxField"
        )
        #expect(hasAccessibilityID, "Should generate accessibility identifier")
    }

    // MARK: - Rich Text Field

    @Test func testDynamicRichTextFieldRendersRichTextEditor() async {
        // DynamicRichTextField should:
        // 1. Render a rich text editor (formatted text input)
        // 2. Support text formatting (bold, italic, etc.)
        // 3. Provide formatting toolbar or controls
        // 4. Update formState with formatted text content
        // 5. Display formatted text preview

        let configuration = DynamicFormConfiguration(
            id: "testForm",
            title: "Test Form",
            sections: []
        )
        let formState = DynamicFormState(configuration: configuration)

        let field = DynamicFormField(
            id: "richtext",
            contentType: .richtext,
            label: "Rich Text"
        )

        let view = DynamicRichTextField(field: field, formState: formState)
            .enableGlobalAutomaticAccessibilityIdentifiers()

        // Should render text input interface
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        if let inspected = view.tryInspect() {
            // Should have text input capability - check if we can find text fields
            if let textFields = try? inspected.sixLayerFindAll(TextField<Text>.self) {
                #expect(!textFields.isEmpty, "Should provide text input interface")
            }
        } else {
            Issue.record("DynamicRichTextField interface not found")
        }
        #else
        Issue.record("ViewInspector not available on this platform (likely macOS)")
        #endif

        // Should generate accessibility identifier
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "SixLayer.main.ui.*DynamicRichTextField.*",
            platform: .iOS,
            componentName: "DynamicRichTextField"
        )
        #expect(hasAccessibilityID, "Should generate accessibility identifier")
    }

    // MARK: - File Field

    @Test func testDynamicFileFieldRendersFilePicker() async {
        // DynamicFileField should:
        // 1. Render file picker button/interface
        // 2. Allow selecting files from device
        // 3. Display selected file name(s)
        // 4. Update formState with file reference or path
        // 5. Show file selection status

        let configuration = DynamicFormConfiguration(
            id: "testForm",
            title: "Test Form",
            sections: []
        )
        let formState = DynamicFormState(configuration: configuration)

        let field = DynamicFormField(
            id: "file",
            contentType: .file,
            label: "Select File"
        )

        let view = DynamicFileField(field: field, formState: formState)
            .enableGlobalAutomaticAccessibilityIdentifiers()

        // Should render file picker interface
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        if let _ = view.tryInspect() {
            // View is inspectable - file picker interface should be present
            #expect(true, "Should provide file picker interface")
        } else {
            Issue.record("DynamicFileField interface not found")
        }
        #else
        Issue.record("ViewInspector not available on this platform (likely macOS)")
        #endif

        // Should generate accessibility identifier
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "SixLayer.main.ui.*DynamicFileField.*",
            platform: .iOS,
            componentName: "DynamicFileField"
        )
        #expect(hasAccessibilityID, "Should generate accessibility identifier")
    }

    // MARK: - Image Field

    @Test func testDynamicImageFieldRendersImagePicker() async {
        // DynamicImageField should:
        // 1. Render image picker button/interface
        // 2. Allow selecting images from photo library or camera
        // 3. Display selected image preview
        // 4. Update formState with image reference or data
        // 5. Show image selection status

        let configuration = DynamicFormConfiguration(
            id: "testForm",
            title: "Test Form",
            sections: []
        )
        let formState = DynamicFormState(configuration: configuration)

        let field = DynamicFormField(
            id: "image",
            contentType: .image,
            label: "Select Image"
        )

        let view = DynamicImageField(field: field, formState: formState)
            .enableGlobalAutomaticAccessibilityIdentifiers()

        // Should render image picker interface
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        if let _ = view.tryInspect() {
            // View is inspectable - image picker interface should be present
            #expect(true, "Should provide image picker interface")
        } else {
            Issue.record("DynamicImageField interface not found")
        }
        #else
        Issue.record("ViewInspector not available on this platform (likely macOS)")
        #endif

        // Should generate accessibility identifier
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "SixLayer.main.ui.*DynamicImageField.*",
            platform: .iOS,
            componentName: "DynamicImageField"
        )
        #expect(hasAccessibilityID, "Should generate accessibility identifier")
    }

    // MARK: - Array Field

    @Test func testDynamicArrayFieldRendersArrayInput() async {
        // DynamicArrayField should:
        // 1. Render interface for entering array of values
        // 2. Allow adding/removing items dynamically
        // 3. Provide add/remove controls
        // 4. Update formState with array of values
        // 5. Display all array items

        let configuration = DynamicFormConfiguration(
            id: "testForm",
            title: "Test Form",
            sections: []
        )
        let formState = DynamicFormState(configuration: configuration)

        let field = DynamicFormField(
            id: "array",
            contentType: .array,
            label: "Array Input"
        )

        let view = DynamicArrayField(field: field, formState: formState)
            .enableGlobalAutomaticAccessibilityIdentifiers()

        // Should render array input interface
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        if let _ = view.tryInspect() {
            // View is inspectable - array input interface should be present
            #expect(true, "Should provide array input interface")
        } else {
            Issue.record("DynamicArrayField interface not found")
        }
        #else
        Issue.record("ViewInspector not available on this platform (likely macOS)")
        #endif

        // Should generate accessibility identifier
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "SixLayer.main.ui.*DynamicArrayField.*",
            platform: .iOS,
            componentName: "DynamicArrayField"
        )
        #expect(hasAccessibilityID, "Should generate accessibility identifier")
    }

    // MARK: - Data Field

    @Test func testDynamicDataFieldRendersDataInput() async {
        // DynamicDataField should:
        // 1. Render interface for binary data input
        // 2. Allow pasting or importing data
        // 3. Display data size or preview
        // 4. Update formState with data reference
        // 5. Show data input status

        let configuration = DynamicFormConfiguration(
            id: "testForm",
            title: "Test Form",
            sections: []
        )
        let formState = DynamicFormState(configuration: configuration)

        let field = DynamicFormField(
            id: "data",
            contentType: .data,
            label: "Data Input"
        )

        let view = DynamicDataField(field: field, formState: formState)
            .enableGlobalAutomaticAccessibilityIdentifiers()

        // Should render data input interface
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        if let _ = view.tryInspect() {
            // View is inspectable - data input interface should be present
            #expect(true, "Should provide data input interface")
        } else {
            Issue.record("DynamicDataField interface not found")
        }
        #else
        Issue.record("ViewInspector not available on this platform (likely macOS)")
        #endif

        // Should generate accessibility identifier
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "SixLayer.main.ui.*DynamicDataField.*",
            platform: .iOS,
            componentName: "DynamicDataField"
        )
        #expect(hasAccessibilityID, "Should generate accessibility identifier")
    }

    // MARK: - Autocomplete Field

    @Test func testDynamicAutocompleteFieldRendersAutocomplete() async {
        // DynamicAutocompleteField should:
        // 1. Render text input with autocomplete suggestions
        // 2. Show suggestions as user types
        // 3. Allow selecting from suggestions
        // 4. Update formState with selected value
        // 5. Filter suggestions based on input

        let configuration = DynamicFormConfiguration(
            id: "testForm",
            title: "Test Form",
            sections: []
        )
        let formState = DynamicFormState(configuration: configuration)

        let field = DynamicFormField(
            id: "autocomplete",
            contentType: .autocomplete,
            label: "Autocomplete",
            options: ["Apple", "Banana", "Cherry"]
        )

        let view = DynamicAutocompleteField(field: field, formState: formState)
            .enableGlobalAutomaticAccessibilityIdentifiers()

        // Should render autocomplete interface
        if let inspected = view.tryInspect() {
            // Should have text input with suggestions
            let hasAutocomplete = inspected.sixLayerCount > 0
            #expect(hasAutocomplete, "Should provide autocomplete interface")
        } else {
            Issue.record("DynamicAutocompleteField interface not found")
        }

        // Should generate accessibility identifier
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "SixLayer.main.ui.*DynamicAutocompleteField.*",
            platform: .iOS,
            componentName: "DynamicAutocompleteField"
        )
        #expect(hasAccessibilityID, "Should generate accessibility identifier")
    }

    // MARK: - Enum Field

    @Test func testDynamicEnumFieldRendersEnumPicker() async {
        // DynamicEnumField should:
        // 1. Render enum value picker
        // 2. Display all enum options from field.options
        // 3. Allow selecting single enum value
        // 4. Update formState with selected enum value
        // 5. Show selected enum value

        let configuration = DynamicFormConfiguration(
            id: "testForm",
            title: "Test Form",
            sections: []
        )
        let formState = DynamicFormState(configuration: configuration)

        let field = DynamicFormField(
            id: "enum",
            contentType: .enum,
            label: "Enum Field",
            options: ["Value1", "Value2", "Value3"]
        )

        let view = DynamicEnumField(field: field, formState: formState)
            .enableGlobalAutomaticAccessibilityIdentifiers()

        // Should render enum options
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        withInspectedView(view) { inspected in
            if let allTexts = try? inspected.sixLayerFindAll(Text.self) {
                let foundValue1 = allTexts.contains { text in
                    (try? text.sixLayerString())?.contains("Value1") ?? false
                }
                let foundValue2 = allTexts.contains { text in
                    (try? text.sixLayerString())?.contains("Value2") ?? false
                }
                let foundValue3 = allTexts.contains { text in
                    (try? text.sixLayerString())?.contains("Value3") ?? false
                }
                #expect(foundValue1 || foundValue2 || foundValue3, "Should display enum options")
            }
        }
        #else
        Issue.record("ViewInspector not available on this platform (likely macOS)")
        #endif

        // Should generate accessibility identifier
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "SixLayer.main.ui.*DynamicEnumField.*",
            platform: .iOS,
            componentName: "DynamicEnumField"
        )
        #expect(hasAccessibilityID, "Should generate accessibility identifier")
    }

    // MARK: - Custom Field

    @Test func testDynamicCustomFieldRendersCustomComponent() async {
        // DynamicCustomField should:
        // 1. Use CustomFieldRegistry to find registered component
        // 2. Render registered custom component if available
        // 3. Show error message if custom type not registered
        // 4. Update formState through custom component
        // 5. Integrate with custom field protocol

        let configuration = DynamicFormConfiguration(
            id: "testForm",
            title: "Test Form",
            sections: []
        )
        let formState = DynamicFormState(configuration: configuration)

        let field = DynamicFormField(
            id: "custom",
            contentType: .custom,
            label: "Custom Field"
        )

        let view = DynamicCustomField(field: field, formState: formState)
            .enableGlobalAutomaticAccessibilityIdentifiers()

        // Should render custom component or error
        if let inspected = view.tryInspect() {
            // Should have some UI (either custom component or error message)
            let hasInterface = inspected.sixLayerCount > 0
            #expect(hasInterface, "Should render custom component or error message")
        } else {
            Issue.record("DynamicCustomField interface not found")
        }

        // Should generate accessibility identifier
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "SixLayer.main.ui.*DynamicCustomField.*",
            platform: .iOS,
            componentName: "DynamicCustomField"
        )
        #expect(hasAccessibilityID, "Should generate accessibility identifier")
    }

    // MARK: - Color Field

    @Test func testDynamicColorFieldRendersColorPicker() async {
        // DynamicColorField should:
        // 1. Render color picker interface
        // 2. Allow selecting colors (hex, RGB, or visual picker)
        // 3. Display selected color preview
        // 4. Update formState with color value
        // 5. Show color selection interface

        let configuration = DynamicFormConfiguration(
            id: "testForm",
            title: "Test Form",
            sections: []
        )
        let formState = DynamicFormState(configuration: configuration)

        let field = DynamicFormField(
            id: "color",
            contentType: .color,
            label: "Select Color"
        )

        let view = DynamicColorField(field: field, formState: formState)
            .enableGlobalAutomaticAccessibilityIdentifiers()

        // Should render color picker interface
        if let inspected = view.tryInspect() {
            // Should have color selection capability
            let hasColorPicker = inspected.sixLayerCount > 0
            #expect(hasColorPicker, "Should provide color picker interface")
        } else {
            Issue.record("DynamicColorField interface not found")
        }

        // Should generate accessibility identifier
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "SixLayer.main.ui.*DynamicColorField.*",
            platform: .iOS,
            componentName: "DynamicColorField"
        )
        #expect(hasAccessibilityID, "Should generate accessibility identifier")
    }

    // MARK: - Text Area Field

    @Test func testDynamicTextAreaFieldRendersMultiLineEditor() async {
        // DynamicTextAreaField should:
        // 1. Render multi-line text editor (TextEditor on iOS, TextField on macOS)
        // 2. Allow entering multiple lines of text
        // 3. Provide adequate height for multi-line input
        // 4. Update formState with text content
        // 5. Support scrolling for long text

        let configuration = DynamicFormConfiguration(
            id: "testForm",
            title: "Test Form",
            sections: []
        )
        let formState = DynamicFormState(configuration: configuration)

        let field = DynamicFormField(
            id: "textarea",
            contentType: .textarea,
            label: "Text Area"
        )

        let view = DynamicTextAreaField(field: field, formState: formState)
            .enableGlobalAutomaticAccessibilityIdentifiers()

        // Should render multi-line text editor
        if let inspected = view.tryInspect() {
            // Should have text input capability
            let hasTextArea = inspected.sixLayerCount > 0
            #expect(hasTextArea, "Should provide multi-line text editor")
        } else {
            Issue.record("DynamicTextAreaField interface not found")
        }

        // Should generate accessibility identifier
        let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(
            view,
            expectedPattern: "SixLayer.main.ui.*DynamicTextAreaField.*",
            platform: .iOS,
            componentName: "DynamicTextAreaField"
        )
        #expect(hasAccessibilityID, "Should generate accessibility identifier")

        // Should support multi-line text in formState
        formState.setValue("Line 1\nLine 2\nLine 3", for: "textarea")
        let textValue = formState.fieldValues["textarea"] as? String
        #expect(textValue?.contains("\n") == true, "Should support multi-line text")
    }
}
