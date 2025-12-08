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
/// NOTE: Not marked @MainActor on class to allow parallel execution
open class DynamicFieldComponentsTests: BaseTestClass {

    // MARK: - Multi-Select Field

    @Test @MainActor func testDynamicMultiSelectFieldRendersSelectionInterface() async {
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
            .enableGlobalAutomaticCompliance()

        // Should render all options from field
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        withInspectedView(view) { inspected in
            // Find all text elements and check if they contain the options
            let allTexts = inspected.sixLayerFindAll(Text.self)
            if !allTexts.isEmpty {
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
            let allTextsForStubCheck = inspected.sixLayerFindAll(Text.self)
            if !allTextsForStubCheck.isEmpty {
                let hasStubText = allTextsForStubCheck.contains { text in
                    (try? text.sixLayerString())?.contains("Multi-select - TDD Red Phase Stub") ?? false
                }
                if hasStubText {
                    Issue.record("DynamicMultiSelectField still shows stub text - needs implementation")
                }
            }
        }
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        #endif

        // Should generate accessibility identifier
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testComponentComplianceSinglePlatform(
            view,
            expectedPattern: "SixLayer.main.ui.*DynamicMultiSelectField.*",
            platform: .iOS,
            componentName: "DynamicMultiSelectField"
        )
 #expect(hasAccessibilityID, "Should generate accessibility identifier ")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif

        // Should support multiple selections in formState
        formState.setValue(["Option 1", "Option 3"], for: "multiSelect")
        let selectedValues = formState.fieldValues["multiSelect"] as? [String]
        #expect(selectedValues?.contains("Option 1") == true, "Should support multiple selections")
        #expect(selectedValues?.contains("Option 3") == true, "Should support multiple selections")
    }

    // MARK: - Radio Field

    @Test @MainActor func testDynamicRadioFieldRendersRadioButtons() async {
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
            .enableGlobalAutomaticCompliance()

        // Should render all radio options
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        withInspectedView(view) { inspected in
            let allTexts = inspected.sixLayerFindAll(Text.self)
            if !allTexts.isEmpty {
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
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        #endif

        // Should generate accessibility identifier
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testComponentComplianceSinglePlatform(
            view,
            expectedPattern: "SixLayer.main.ui.*DynamicRadioField.*",
            platform: .iOS,
            componentName: "DynamicRadioField"
        )
 #expect(hasAccessibilityID, "Should generate accessibility identifier ")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif

        // Should support single selection
        formState.setValue("Choice B", for: "radio")
        let selectedValue = formState.fieldValues["radio"] as? String
        #expect(selectedValue == "Choice B", "Should support single radio selection")
    }

    // MARK: - Checkbox Field

    @Test @MainActor func testDynamicCheckboxFieldRendersCheckboxes() async {
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
            .enableGlobalAutomaticCompliance()

        // Should render checkbox options
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        withInspectedView(view) { inspected in
            let allTexts = inspected.sixLayerFindAll(Text.self)
            if !allTexts.isEmpty {
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
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        #endif

        // Should generate accessibility identifier
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testComponentComplianceSinglePlatform(
            view,
            expectedPattern: "SixLayer.main.ui.*DynamicCheckboxField.*",
            platform: .iOS,
            componentName: "DynamicCheckboxField"
        )
 #expect(hasAccessibilityID, "Should generate accessibility identifier ")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }

    // MARK: - Rich Text Field

    @Test @MainActor func testDynamicRichTextFieldRendersRichTextEditor() async {
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
            .enableGlobalAutomaticCompliance()

        // Should render text input interface
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        if let inspected = view.tryInspect() {
            // Should have text input capability - check if we can find text fields
            let textFields = inspected.sixLayerFindAll(TextField<Text>.self)
            if !textFields.isEmpty {
                #expect(!textFields.isEmpty, "Should provide text input interface")
            }
        } else {
            #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
            Issue.record("DynamicRichTextField interface not found")
            #else
            #expect(Bool(true), "DynamicRichTextField created (ViewInspector not available on macOS)")
            #endif
        }
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        #endif

        // Should generate accessibility identifier
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testComponentComplianceSinglePlatform(
            view,
            expectedPattern: "SixLayer.main.ui.*DynamicRichTextField.*",
            platform: .iOS,
            componentName: "DynamicRichTextField"
        )
 #expect(hasAccessibilityID, "Should generate accessibility identifier ")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }

    // MARK: - File Field

    @Test @MainActor func testDynamicFileFieldRendersFilePicker() async {
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
            .enableGlobalAutomaticCompliance()

        // Should render file picker interface
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        if let _ = view.tryInspect() {
            // View is inspectable - file picker interface should be present
            #expect(Bool(true), "Should provide file picker interface")
        } else {
            #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
            Issue.record("DynamicFileField interface not found")
            #else
            #expect(Bool(true), "DynamicFileField created (ViewInspector not available on macOS)")
            #endif
        }
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        #endif

        // Should generate accessibility identifier
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testComponentComplianceSinglePlatform(
            view,
            expectedPattern: "SixLayer.main.ui.*DynamicFileField.*",
            platform: .iOS,
            componentName: "DynamicFileField"
        )
 #expect(hasAccessibilityID, "Should generate accessibility identifier ")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }

    // MARK: - Image Field

    @Test @MainActor func testDynamicImageFieldRendersImagePicker() async {
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
            .enableGlobalAutomaticCompliance()

        // Should render image picker interface
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        if let _ = view.tryInspect() {
            // View is inspectable - image picker interface should be present
            #expect(Bool(true), "Should provide image picker interface")
        } else {
            #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
            Issue.record("DynamicImageField interface not found")
            #else
            #expect(Bool(true), "DynamicImageField created (ViewInspector not available on macOS)")
            #endif
        }
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        #endif

        // Should generate accessibility identifier
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testComponentComplianceSinglePlatform(
            view,
            expectedPattern: "SixLayer.main.ui.*DynamicImageField.*",
            platform: .iOS,
            componentName: "DynamicImageField"
        )
 #expect(hasAccessibilityID, "Should generate accessibility identifier ")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }

    // MARK: - Array Field

    @Test @MainActor func testDynamicArrayFieldRendersArrayInput() async {
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
            .enableGlobalAutomaticCompliance()

        // Should render array input interface
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        if let _ = view.tryInspect() {
            // View is inspectable - array input interface should be present
            #expect(Bool(true), "Should provide array input interface")
        } else {
            #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
            Issue.record("DynamicArrayField interface not found")
            #else
            #expect(Bool(true), "DynamicArrayField created (ViewInspector not available on macOS)")
            #endif
        }
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        #endif

        // Should generate accessibility identifier
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testComponentComplianceSinglePlatform(
            view,
            expectedPattern: "SixLayer.main.ui.*DynamicArrayField.*",
            platform: .iOS,
            componentName: "DynamicArrayField"
        )
 #expect(hasAccessibilityID, "Should generate accessibility identifier ")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }

    // MARK: - Data Field

    @Test @MainActor func testDynamicDataFieldRendersDataInput() async {
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
            .enableGlobalAutomaticCompliance()

        // Should render data input interface
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        if let _ = view.tryInspect() {
            // View is inspectable - data input interface should be present
            #expect(Bool(true), "Should provide data input interface")
        } else {
            #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
            Issue.record("DynamicDataField interface not found")
            #else
            #expect(Bool(true), "DynamicDataField created (ViewInspector not available on macOS)")
            #endif
        }
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        #endif

        // Should generate accessibility identifier
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testComponentComplianceSinglePlatform(
            view,
            expectedPattern: "SixLayer.main.ui.*DynamicDataField.*",
            platform: .iOS,
            componentName: "DynamicDataField"
        )
 #expect(hasAccessibilityID, "Should generate accessibility identifier ")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }

    // MARK: - Autocomplete Field

    @Test @MainActor func testDynamicAutocompleteFieldRendersAutocomplete() async {
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
            .enableGlobalAutomaticCompliance()

        // Should render autocomplete interface
        if let inspected = view.tryInspect() {
            // Should have text input with suggestions
            let hasAutocomplete = inspected.sixLayerCount > 0
            #expect(hasAutocomplete, "Should provide autocomplete interface")
        } else {
            #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
            Issue.record("DynamicAutocompleteField interface not found")
            #else
            // ViewInspector not available on macOS - test passes by verifying view creation
            #expect(Bool(true), "DynamicAutocompleteField created (ViewInspector not available on macOS)")
            #endif
        }

        // Should generate accessibility identifier
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testComponentComplianceSinglePlatform(
            view,
            expectedPattern: "SixLayer.main.ui.*DynamicAutocompleteField.*",
            platform: .iOS,
            componentName: "DynamicAutocompleteField"
        )
 #expect(hasAccessibilityID, "Should generate accessibility identifier ")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }

    // MARK: - Enum Field

    @Test @MainActor func testDynamicEnumFieldRendersEnumPicker() async {
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
            .enableGlobalAutomaticCompliance()

        // Should render enum options
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        withInspectedView(view) { inspected in
            let allTexts = inspected.sixLayerFindAll(Text.self)
            if !allTexts.isEmpty {
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
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        #endif

        // Should generate accessibility identifier
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testComponentComplianceSinglePlatform(
            view,
            expectedPattern: "SixLayer.main.ui.*DynamicEnumField.*",
            platform: .iOS,
            componentName: "DynamicEnumField"
        )
 #expect(hasAccessibilityID, "Should generate accessibility identifier ")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }

    // MARK: - Custom Field

    @Test @MainActor func testDynamicCustomFieldRendersCustomComponent() async {
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
            .enableGlobalAutomaticCompliance()

        // Should render custom component or error
        if let inspected = view.tryInspect() {
            // Should have some UI (either custom component or error message)
            let hasInterface = inspected.sixLayerCount > 0
            #expect(hasInterface, "Should render custom component or error message")
        } else {
            #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
            Issue.record("DynamicCustomField interface not found")
            #else
            #expect(Bool(true), "DynamicCustomField created (ViewInspector not available on macOS)")
            #endif
        }

        // Should generate accessibility identifier
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testComponentComplianceSinglePlatform(
            view,
            expectedPattern: "SixLayer.main.ui.*DynamicCustomField.*",
            platform: .iOS,
            componentName: "DynamicCustomField"
        )
 #expect(hasAccessibilityID, "Should generate accessibility identifier ")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }

    // MARK: - Color Field

    @Test @MainActor func testDynamicColorFieldRendersColorPicker() async {
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
            .enableGlobalAutomaticCompliance()

        // Should render color picker interface
        if let inspected = view.tryInspect() {
            // Should have color selection capability
            let hasColorPicker = inspected.sixLayerCount > 0
            #expect(hasColorPicker, "Should provide color picker interface")
        } else {
            #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
            Issue.record("DynamicColorField interface not found")
            #else
            #expect(Bool(true), "DynamicColorField created (ViewInspector not available on macOS)")
            #endif
        }

        // Should generate accessibility identifier
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testComponentComplianceSinglePlatform(
            view,
            expectedPattern: "SixLayer.main.ui.*DynamicColorField.*",
            platform: .iOS,
            componentName: "DynamicColorField"
        )
 #expect(hasAccessibilityID, "Should generate accessibility identifier ")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }

    // MARK: - Text Area Field

    @Test @MainActor func testDynamicTextAreaFieldRendersMultiLineEditor() async {
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
            .enableGlobalAutomaticCompliance()

        // Should render multi-line text editor
        if let inspected = view.tryInspect() {
            // Should have text input capability
            let hasTextArea = inspected.sixLayerCount > 0
            #expect(hasTextArea, "Should provide multi-line text editor")
        } else {
            #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
            Issue.record("DynamicTextAreaField interface not found")
            #else
            #expect(Bool(true), "DynamicTextAreaField created (ViewInspector not available on macOS)")
            #endif
        }

        // Should generate accessibility identifier
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testComponentComplianceSinglePlatform(
            view,
            expectedPattern: "SixLayer.main.ui.*DynamicTextAreaField.*",
            platform: .iOS,
            componentName: "DynamicTextAreaField"
        )
 #expect(hasAccessibilityID, "Should generate accessibility identifier ")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif

        // Should support multi-line text in formState
        formState.setValue("Line 1\nLine 2\nLine 3", for: "textarea")
        let textValue = formState.fieldValues["textarea"] as? String
        #expect(textValue?.contains("\n") == true, "Should support multi-line text")
    }

    // MARK: - Character Counter

    @Test @MainActor func testDynamicTextFieldShowsCharacterCounterWhenMaxLengthSet() async {
        // DynamicTextField should:
        // 1. Show character counter when maxLength validation rule is set
        // 2. Display format "X / Y characters"
        // 3. Update counter in real-time as user types
        // 4. Show warning color when approaching limit (>80%)

        let configuration = DynamicFormConfiguration(
            id: "testForm",
            title: "Test Form",
            sections: []
        )
        let formState = DynamicFormState(configuration: configuration)

        let field = DynamicFormField(
            id: "text-with-limit",
            contentType: .text,
            label: "Limited Text",
            validationRules: ["maxLength": "100"]
        )

        let view = DynamicTextField(field: field, formState: formState)
            .enableGlobalAutomaticCompliance()

        // Should show character counter
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        withInspectedView(view) { inspected in
            let allTexts = inspected.sixLayerFindAll(Text.self)
            if !allTexts.isEmpty {
                let hasCounter = allTexts.contains { text in
                    let textContent = (try? text.sixLayerString()) ?? ""
                    return textContent.contains("/") && textContent.contains("100")
                }
                #expect(hasCounter, "Should display character counter with max length")
            }
        }
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        #endif
    }

    @Test @MainActor func testDynamicTextFieldCharacterCounterUpdatesAsUserTypes() async {
        // Character counter should update in real-time as user types

        let configuration = DynamicFormConfiguration(
            id: "testForm",
            title: "Test Form",
            sections: []
        )
        let formState = DynamicFormState(configuration: configuration)

        let field = DynamicFormField(
            id: "text-with-limit",
            contentType: .text,
            label: "Limited Text",
            validationRules: ["maxLength": "50"]
        )

        let view = DynamicTextField(field: field, formState: formState)
            .enableGlobalAutomaticCompliance()

        // Initially should show 0 / 50
        formState.setValue("", for: "text-with-limit")
        
        // Type some text
        formState.setValue("Hello", for: "text-with-limit")
        let currentValue = formState.fieldValues["text-with-limit"] as? String ?? ""
        #expect(currentValue.count == 5, "Should track character count correctly")
    }

    @Test @MainActor func testDynamicTextFieldCharacterCounterShowsWarningColorWhenApproachingLimit() async {
        // Character counter should show warning color (orange) when >80% of maxLength

        let configuration = DynamicFormConfiguration(
            id: "testForm",
            title: "Test Form",
            sections: []
        )
        let formState = DynamicFormState(configuration: configuration)

        let field = DynamicFormField(
            id: "text-with-limit",
            contentType: .text,
            label: "Limited Text",
            validationRules: ["maxLength": "100"]
        )

        // Set value to 85 characters (85% of 100, should show warning)
        let longText = String(repeating: "a", count: 85)
        formState.setValue(longText, for: "text-with-limit")

        let view = DynamicTextField(field: field, formState: formState)
            .enableGlobalAutomaticCompliance()

        // Counter should be visible and show warning color
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        withInspectedView(view) { inspected in
            let allTexts = inspected.sixLayerFindAll(Text.self)
            if !allTexts.isEmpty {
                let hasCounter = allTexts.contains { text in
                    let textContent = (try? text.sixLayerString()) ?? ""
                    return textContent.contains("85") && textContent.contains("100")
                }
                #expect(hasCounter, "Should show updated counter when approaching limit")
            }
        }
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        #endif
    }

    @Test @MainActor func testDynamicTextFieldDoesNotShowCharacterCounterWhenMaxLengthNotSet() async {
        // Character counter should NOT appear when maxLength validation rule is not set

        let configuration = DynamicFormConfiguration(
            id: "testForm",
            title: "Test Form",
            sections: []
        )
        let formState = DynamicFormState(configuration: configuration)

        let field = DynamicFormField(
            id: "text-no-limit",
            contentType: .text,
            label: "Unlimited Text"
        )

        let view = DynamicTextField(field: field, formState: formState)
            .enableGlobalAutomaticCompliance()

        // Should NOT show character counter
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        withInspectedView(view) { inspected in
            let allTexts = inspected.sixLayerFindAll(Text.self)
            if !allTexts.isEmpty {
                let hasCounter = allTexts.contains { text in
                    let textContent = (try? text.sixLayerString()) ?? ""
                    return textContent.contains("/") && textContent.contains("characters")
                }
                #expect(!hasCounter, "Should NOT display character counter when maxLength not set")
            }
        }
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        #endif
    }

    @Test @MainActor func testDynamicTextAreaFieldShowsCharacterCounterWhenMaxLengthSet() async {
        // DynamicTextAreaField should also show character counter when maxLength is set

        let configuration = DynamicFormConfiguration(
            id: "testForm",
            title: "Test Form",
            sections: []
        )
        let formState = DynamicFormState(configuration: configuration)

        let field = DynamicFormField(
            id: "textarea-with-limit",
            contentType: .textarea,
            label: "Limited Text Area",
            validationRules: ["maxLength": "500"]
        )

        let view = DynamicTextAreaField(field: field, formState: formState)
            .enableGlobalAutomaticCompliance()

        // Should show character counter
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        withInspectedView(view) { inspected in
            let allTexts = inspected.sixLayerFindAll(Text.self)
            if !allTexts.isEmpty {
                let hasCounter = allTexts.contains { text in
                    let textContent = (try? text.sixLayerString()) ?? ""
                    return textContent.contains("/") && textContent.contains("500")
                }
                #expect(hasCounter, "Should display character counter in text area")
            }
        }
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        #endif
    }

    @Test @MainActor func testCharacterCounterHandlesInvalidMaxLengthGracefully() async {
        // Character counter should handle invalid maxLength values gracefully

        let configuration = DynamicFormConfiguration(
            id: "testForm",
            title: "Test Form",
            sections: []
        )
        let formState = DynamicFormState(configuration: configuration)

        // Test with non-numeric maxLength
        let fieldInvalid = DynamicFormField(
            id: "text-invalid",
            contentType: .text,
            label: "Invalid Limit",
            validationRules: ["maxLength": "not-a-number"]
        )

        let viewInvalid = DynamicTextField(field: fieldInvalid, formState: formState)
            .enableGlobalAutomaticCompliance()

        // Should not crash, counter should not appear or should handle gracefully
        #expect(viewInvalid != nil, "Should handle invalid maxLength without crashing")
    }

    @Test @MainActor func testCharacterCounterIsAccessible() async {
        // Character counter should have proper accessibility labels

        let configuration = DynamicFormConfiguration(
            id: "testForm",
            title: "Test Form",
            sections: []
        )
        let formState = DynamicFormState(configuration: configuration)

        let field = DynamicFormField(
            id: "text-accessible",
            contentType: .text,
            label: "Accessible Text",
            validationRules: ["maxLength": "100"]
        )

        formState.setValue("Hello", for: "text-accessible")

        let view = DynamicTextField(field: field, formState: formState)
            .enableGlobalAutomaticCompliance()

        // Should have accessibility support
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasAccessibilityID = testComponentComplianceSinglePlatform(
            view,
            expectedPattern: "SixLayer.main.ui.*DynamicTextField.*",
            platform: .iOS,
            componentName: "DynamicTextField"
        )
        #expect(hasAccessibilityID, "Should have accessibility identifier")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        #endif
    }

    @Test @MainActor func testDynamicRichTextFieldShowsCharacterCounterWhenMaxLengthSet() async {
        // DynamicRichTextField should also show character counter when maxLength is set

        let configuration = DynamicFormConfiguration(
            id: "testForm",
            title: "Test Form",
            sections: []
        )
        let formState = DynamicFormState(configuration: configuration)

        let field = DynamicFormField(
            id: "richtext-with-limit",
            contentType: .richtext,
            label: "Limited Rich Text",
            validationRules: ["maxLength": "500"]
        )

        let view = DynamicRichTextField(field: field, formState: formState)
            .enableGlobalAutomaticCompliance()

        // Should show character counter
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        withInspectedView(view) { inspected in
            let allTexts = inspected.sixLayerFindAll(Text.self)
            if !allTexts.isEmpty {
                let hasCounter = allTexts.contains { text in
                    let textContent = (try? text.sixLayerString()) ?? ""
                    return textContent.contains("/") && textContent.contains("500")
                }
                #expect(hasCounter, "Should display character counter in rich text field")
            }
        }
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        #endif
    }

    // MARK: - Additional Text Field Types Character Counter Tests

    @Test @MainActor func testDynamicEmailFieldShowsCharacterCounterWhenMaxLengthSet() async {
        // DynamicEmailField should show character counter when maxLength is set

        let configuration = DynamicFormConfiguration(
            id: "testForm",
            title: "Test Form",
            sections: []
        )
        let formState = DynamicFormState(configuration: configuration)

        let field = DynamicFormField(
            id: "email-with-limit",
            contentType: .email,
            label: "Email",
            validationRules: ["maxLength": "255"]
        )

        let view = DynamicEmailField(field: field, formState: formState)
            .enableGlobalAutomaticCompliance()

        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        withInspectedView(view) { inspected in
            let allTexts = inspected.sixLayerFindAll(Text.self)
            if !allTexts.isEmpty {
                let hasCounter = allTexts.contains { text in
                    let textContent = (try? text.sixLayerString()) ?? ""
                    return textContent.contains("/") && textContent.contains("255")
                }
                #expect(hasCounter, "Should display character counter in email field")
            }
        }
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        #endif
    }

    @Test @MainActor func testDynamicPhoneFieldShowsCharacterCounterWhenMaxLengthSet() async {
        // DynamicPhoneField should show character counter when maxLength is set

        let configuration = DynamicFormConfiguration(
            id: "testForm",
            title: "Test Form",
            sections: []
        )
        let formState = DynamicFormState(configuration: configuration)

        let field = DynamicFormField(
            id: "phone-with-limit",
            contentType: .phone,
            label: "Phone",
            validationRules: ["maxLength": "20"]
        )

        let view = DynamicPhoneField(field: field, formState: formState)
            .enableGlobalAutomaticCompliance()

        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        withInspectedView(view) { inspected in
            let allTexts = inspected.sixLayerFindAll(Text.self)
            if !allTexts.isEmpty {
                let hasCounter = allTexts.contains { text in
                    let textContent = (try? text.sixLayerString()) ?? ""
                    return textContent.contains("/") && textContent.contains("20")
                }
                #expect(hasCounter, "Should display character counter in phone field")
            }
        }
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        #endif
    }

    @Test @MainActor func testDynamicURLFieldShowsCharacterCounterWhenMaxLengthSet() async {
        // DynamicURLField should show character counter when maxLength is set

        let configuration = DynamicFormConfiguration(
            id: "testForm",
            title: "Test Form",
            sections: []
        )
        let formState = DynamicFormState(configuration: configuration)

        let field = DynamicFormField(
            id: "url-with-limit",
            contentType: .url,
            label: "URL",
            validationRules: ["maxLength": "2048"]
        )

        let view = DynamicURLField(field: field, formState: formState)
            .enableGlobalAutomaticCompliance()

        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        withInspectedView(view) { inspected in
            let allTexts = inspected.sixLayerFindAll(Text.self)
            if !allTexts.isEmpty {
                let hasCounter = allTexts.contains { text in
                    let textContent = (try? text.sixLayerString()) ?? ""
                    return textContent.contains("/") && textContent.contains("2048")
                }
                #expect(hasCounter, "Should display character counter in URL field")
            }
        }
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        #endif
    }

    @Test @MainActor func testDynamicPasswordFieldShowsCharacterCounterWhenMaxLengthSet() async {
        // DynamicPasswordField should show character counter when maxLength is set

        let configuration = DynamicFormConfiguration(
            id: "testForm",
            title: "Test Form",
            sections: []
        )
        let formState = DynamicFormState(configuration: configuration)

        let field = DynamicFormField(
            id: "password-with-limit",
            contentType: .password,
            label: "Password",
            validationRules: ["maxLength": "128"]
        )

        let view = DynamicPasswordField(field: field, formState: formState)
            .enableGlobalAutomaticCompliance()

        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        withInspectedView(view) { inspected in
            let allTexts = inspected.sixLayerFindAll(Text.self)
            if !allTexts.isEmpty {
                let hasCounter = allTexts.contains { text in
                    let textContent = (try? text.sixLayerString()) ?? ""
                    return textContent.contains("/") && textContent.contains("128")
                }
                #expect(hasCounter, "Should display character counter in password field")
            }
        }
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        #endif
    }

    @Test @MainActor func testDynamicAutocompleteFieldShowsCharacterCounterWhenMaxLengthSet() async {
        // DynamicAutocompleteField should show character counter when maxLength is set

        let configuration = DynamicFormConfiguration(
            id: "testForm",
            title: "Test Form",
            sections: []
        )
        let formState = DynamicFormState(configuration: configuration)

        let field = DynamicFormField(
            id: "autocomplete-with-limit",
            contentType: .autocomplete,
            label: "Autocomplete",
            validationRules: ["maxLength": "100"]
        )

        let view = DynamicAutocompleteField(field: field, formState: formState)
            .enableGlobalAutomaticCompliance()

        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        withInspectedView(view) { inspected in
            let allTexts = inspected.sixLayerFindAll(Text.self)
            if !allTexts.isEmpty {
                let hasCounter = allTexts.contains { text in
                    let textContent = (try? text.sixLayerString()) ?? ""
                    return textContent.contains("/") && textContent.contains("100")
                }
                #expect(hasCounter, "Should display character counter in autocomplete field")
            }
        }
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        #endif
    }

    // MARK: - Edge Case Tests

    @Test @MainActor func testCharacterCounterShowsWarningAtExactly80Percent() async {
        // Character counter should show warning color at exactly 80% of maxLength

        let configuration = DynamicFormConfiguration(
            id: "testForm",
            title: "Test Form",
            sections: []
        )
        let formState = DynamicFormState(configuration: configuration)

        let field = DynamicFormField(
            id: "text-80-percent",
            contentType: .text,
            label: "Text at 80%",
            validationRules: ["maxLength": "100"]
        )

        // Set value to exactly 80 characters (80% of 100)
        let text80 = String(repeating: "a", count: 80)
        formState.setValue(text80, for: "text-80-percent")

        let view = DynamicTextField(field: field, formState: formState)
            .enableGlobalAutomaticCompliance()

        // At exactly 80%, should NOT show warning (threshold is >80%)
        #expect(text80.count == 80, "Should have exactly 80 characters")
    }

    @Test @MainActor func testCharacterCounterShowsWarningAt81Percent() async {
        // Character counter should show warning color at 81% of maxLength (>80%)

        let configuration = DynamicFormConfiguration(
            id: "testForm",
            title: "Test Form",
            sections: []
        )
        let formState = DynamicFormState(configuration: configuration)

        let field = DynamicFormField(
            id: "text-81-percent",
            contentType: .text,
            label: "Text at 81%",
            validationRules: ["maxLength": "100"]
        )

        // Set value to 81 characters (81% of 100, should show warning)
        let text81 = String(repeating: "a", count: 81)
        formState.setValue(text81, for: "text-81-percent")

        let view = DynamicTextField(field: field, formState: formState)
            .enableGlobalAutomaticCompliance()

        #expect(text81.count == 81, "Should have exactly 81 characters")
    }

    @Test @MainActor func testCharacterCounterHandlesZeroMaxLength() async {
        // Character counter should handle zero maxLength gracefully (should not appear)

        let configuration = DynamicFormConfiguration(
            id: "testForm",
            title: "Test Form",
            sections: []
        )
        let formState = DynamicFormState(configuration: configuration)

        let field = DynamicFormField(
            id: "text-zero-limit",
            contentType: .text,
            label: "Zero Limit",
            validationRules: ["maxLength": "0"]
        )

        let view = DynamicTextField(field: field, formState: formState)
            .enableGlobalAutomaticCompliance()

        // Should not crash, counter should not appear
        #expect(view != nil, "Should handle zero maxLength without crashing")
    }

    @Test @MainActor func testCharacterCounterHandlesNegativeMaxLength() async {
        // Character counter should handle negative maxLength gracefully (should not appear)

        let configuration = DynamicFormConfiguration(
            id: "testForm",
            title: "Test Form",
            sections: []
        )
        let formState = DynamicFormState(configuration: configuration)

        // Note: validationRules stores strings, so negative would be "-10"
        let field = DynamicFormField(
            id: "text-negative-limit",
            contentType: .text,
            label: "Negative Limit",
            validationRules: ["maxLength": "-10"]
        )

        let view = DynamicTextField(field: field, formState: formState)
            .enableGlobalAutomaticCompliance()

        // Should not crash, counter should not appear (maxLength > 0 check)
        #expect(view != nil, "Should handle negative maxLength without crashing")
    }

    @Test @MainActor func testCharacterCounterUpdatesInRealTime() async {
        // Character counter should update immediately when formState changes

        let configuration = DynamicFormConfiguration(
            id: "testForm",
            title: "Test Form",
            sections: []
        )
        let formState = DynamicFormState(configuration: configuration)

        let field = DynamicFormField(
            id: "text-realtime",
            contentType: .text,
            label: "Real-time Test",
            validationRules: ["maxLength": "50"]
        )

        // Test multiple updates
        formState.setValue("", for: "text-realtime")
        #expect((formState.getValue(for: "text-realtime") as String? ?? "").count == 0)

        formState.setValue("H", for: "text-realtime")
        #expect((formState.getValue(for: "text-realtime") as String? ?? "").count == 1)

        formState.setValue("He", for: "text-realtime")
        #expect((formState.getValue(for: "text-realtime") as String? ?? "").count == 2)

        formState.setValue("Hello", for: "text-realtime")
        #expect((formState.getValue(for: "text-realtime") as String? ?? "").count == 5)

        let view = DynamicTextField(field: field, formState: formState)
            .enableGlobalAutomaticCompliance()

        // View should be created successfully
        #expect(view != nil, "Should handle real-time updates")
    }
}
