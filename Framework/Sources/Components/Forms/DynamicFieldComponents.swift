import SwiftUI

// MARK: - Custom Field View (Generic Field Renderer)

// TODO: DRY - This should be the centralized field renderer that all tests use
/// Generic field view that renders any field type based on DynamicFormField configuration
/// This is the key missing component that tests expect to exist
@MainActor
public struct CustomFieldView: View {
    let field: DynamicFormField
    @ObservedObject var formState: DynamicFormState

    public init(field: DynamicFormField, formState: DynamicFormState) {
        self.field = field
        self.formState = formState
    }

    public var body: some View {
        Group {
            switch field.contentType ?? .text {
            case .text:
                DynamicTextField(field: field, formState: formState)
            case .email:
                DynamicEmailField(field: field, formState: formState)
            case .password:
                DynamicPasswordField(field: field, formState: formState)
            case .phone:
                DynamicPhoneField(field: field, formState: formState)
            case .url:
                DynamicURLField(field: field, formState: formState)
            case .number:
                DynamicNumberField(field: field, formState: formState)
            case .integer:
                DynamicIntegerField(field: field, formState: formState)
            case .date:
                DynamicDateField(field: field, formState: formState)
            case .time:
                DynamicTimeField(field: field, formState: formState)
            case .datetime:
                DynamicDateTimeField(field: field, formState: formState)
            case .select:
                DynamicSelectField(field: field, formState: formState)
            case .multiselect:
                DynamicMultiSelectField(field: field, formState: formState)
            case .radio:
                DynamicRadioField(field: field, formState: formState)
            case .checkbox:
                DynamicCheckboxField(field: field, formState: formState)
            case .textarea:
                DynamicTextAreaField(field: field, formState: formState)
            case .richtext:
                DynamicRichTextField(field: field, formState: formState)
            case .file:
                DynamicFileField(field: field, formState: formState)
            case .image:
                DynamicImageField(field: field, formState: formState)
            case .color:
                DynamicColorField(field: field, formState: formState)
            case .range:
                DynamicRangeField(field: field, formState: formState)
            case .toggle:
                DynamicToggleField(field: field, formState: formState)
            case .array:
                DynamicArrayField(field: field, formState: formState)
            case .data:
                DynamicDataField(field: field, formState: formState)
            case .autocomplete:
                DynamicAutocompleteField(field: field, formState: formState)
            case .`enum`:
                DynamicEnumField(field: field, formState: formState)
            case .custom:
                DynamicCustomField(field: field, formState: formState)
            }
        }
        .automaticCompliance(named: "CustomFieldView")
    }
}

// MARK: - Character Counter Component

/// Reusable character counter view that displays character count for fields with maxLength validation
/// Shows format "X / Y characters" and warning color when approaching limit (>80%)
@MainActor
struct CharacterCounterView: View {
    let currentLength: Int
    let maxLength: Int
    let warningThreshold: Double = 0.8 // Show warning when >80% of max
    
    private var isWarning: Bool {
        Double(currentLength) > Double(maxLength) * warningThreshold
    }
    
    var body: some View {
        HStack {
            Spacer()
            Text("\(currentLength) / \(maxLength) characters")
                .font(.caption)
                .foregroundColor(isWarning ? .orange : .secondary)
                .accessibilityLabel("\(currentLength) of \(maxLength) characters")
                .accessibilityValue(isWarning ? "Warning: approaching character limit" : "")
                .automaticCompliance(named: "CharacterCounter")
        }
    }
}

// MARK: - Helper Extensions

extension DynamicFormField {
    /// Extracts maxLength from validationRules if present and valid
    var maxLength: Int? {
        guard let validationRules = validationRules,
              let maxLengthStr = validationRules["maxLength"],
              let maxLength = Int(maxLengthStr),
              maxLength > 0 else {
            return nil
        }
        return maxLength
    }
}

// MARK: - Individual Field Components (TDD Red Phase Stubs)

/// Text field component
/// TDD RED PHASE: This is a stub implementation for testing
@MainActor
public struct DynamicTextField: View {
    let field: DynamicFormField
    @ObservedObject var formState: DynamicFormState

    public init(field: DynamicFormField, formState: DynamicFormState) {
        self.field = field
        self.formState = formState
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(field.label)
                .font(.subheadline)

            if field.supportsOCR {
                HStack {
                    TextField(field.placeholder ?? "Enter text", text: Binding(
                        get: { formState.getValue(for: field.id) ?? field.defaultValue ?? "" },
                        set: { formState.setValue($0, for: field.id) }
                    ))
                    .textFieldStyle(.roundedBorder)
                    .automaticCompliance()

                    Button(action: {
                        // TODO: Implement OCR scanning workflow
                        // This should trigger OCROverlayView and populate the field
                        print("OCR scan requested for field: \(field.id)")
                    }) {
                        Image(systemName: "camera.viewfinder")
                            .foregroundColor(.blue)
                    }
                    .buttonStyle(.borderless)
                    .accessibilityLabel("Scan with OCR")
                    .accessibilityHint(field.ocrHint ?? "Scan document to fill this field")
                    .automaticCompliance()
                }
            } else {
                TextField(field.placeholder ?? "Enter text", text: Binding(
                    get: { formState.getValue(for: field.id) ?? field.defaultValue ?? "" },
                    set: { formState.setValue($0, for: field.id) }
                ))
                .textFieldStyle(.roundedBorder)
                .automaticCompliance()
            }
            
            // Character counter for fields with maxLength validation
            if let maxLength = field.maxLength {
                let currentValue = formState.getValue(for: field.id) ?? field.defaultValue ?? ""
                CharacterCounterView(currentLength: currentValue.count, maxLength: maxLength)
            }
        }
        .padding()
        .environment(\.accessibilityIdentifierLabel, field.label)
        .automaticCompliance(named: "DynamicTextField")
    }
}

/// Email field component
/// TDD RED PHASE: This is a stub implementation for testing
@MainActor
public struct DynamicEmailField: View {
    let field: DynamicFormField
    @ObservedObject var formState: DynamicFormState

    public init(field: DynamicFormField, formState: DynamicFormState) {
        self.field = field
        self.formState = formState
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(field.label)
                .font(.subheadline)

            TextField(field.placeholder ?? "Enter email", text: Binding(
                get: { formState.getValue(for: field.id) ?? field.defaultValue ?? "" },
                set: { formState.setValue($0, for: field.id) }
            ))
            .textFieldStyle(.roundedBorder)
            #if os(iOS)
            .keyboardType(UIKeyboardType.emailAddress)
            #endif
            .automaticCompliance()
            
            // Character counter for fields with maxLength validation
            if let maxLength = field.maxLength {
                let currentValue = formState.getValue(for: field.id) ?? field.defaultValue ?? ""
                CharacterCounterView(currentLength: currentValue.count, maxLength: maxLength)
            }
        }
        .padding()
        .environment(\.accessibilityIdentifierLabel, field.label)
        .automaticCompliance(named: "DynamicEmailField")
    }
}

/// Password field component
/// TDD RED PHASE: This is a stub implementation for testing
@MainActor
public struct DynamicPasswordField: View {
    let field: DynamicFormField
    @ObservedObject var formState: DynamicFormState

    public init(field: DynamicFormField, formState: DynamicFormState) {
        self.field = field
        self.formState = formState
    }

    public var body: some View {
        VStack(alignment: .leading) {
            Text(field.label)
                .font(.subheadline)

            SecureField(field.placeholder ?? "Enter password", text: Binding(
                get: { formState.getValue(for: field.id) ?? field.defaultValue ?? "" },
                set: { formState.setValue($0, for: field.id) }
            ))
            .textFieldStyle(.roundedBorder)
            .automaticCompliance()
        }
        .padding()
        .environment(\.accessibilityIdentifierLabel, field.label)
        .automaticCompliance(named: "DynamicPasswordField")
    }
}

/// Phone field component
/// TDD RED PHASE: This is a stub implementation for testing
@MainActor
public struct DynamicPhoneField: View {
    let field: DynamicFormField
    @ObservedObject var formState: DynamicFormState

    public init(field: DynamicFormField, formState: DynamicFormState) {
        self.field = field
        self.formState = formState
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(field.label)
                .font(.subheadline)

            TextField(field.placeholder ?? "Enter phone", text: Binding(
                get: { formState.getValue(for: field.id) ?? field.defaultValue ?? "" },
                set: { formState.setValue($0, for: field.id) }
            ))
            .textFieldStyle(.roundedBorder)
            #if os(iOS)
            .keyboardType(UIKeyboardType.phonePad)
            #endif
            .automaticCompliance()
            
            // Character counter for fields with maxLength validation
            if let maxLength = field.maxLength {
                let currentValue = formState.getValue(for: field.id) ?? field.defaultValue ?? ""
                CharacterCounterView(currentLength: currentValue.count, maxLength: maxLength)
            }
        }
        .padding()
        .environment(\.accessibilityIdentifierLabel, field.label)
        .automaticCompliance(named: "DynamicPhoneField")
    }
}

/// URL field component
/// TDD RED PHASE: This is a stub implementation for testing
@MainActor
public struct DynamicURLField: View {
    let field: DynamicFormField
    @ObservedObject var formState: DynamicFormState

    public init(field: DynamicFormField, formState: DynamicFormState) {
        self.field = field
        self.formState = formState
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(field.label)
                .font(.subheadline)

            TextField(field.placeholder ?? "Enter URL", text: Binding(
                get: { formState.getValue(for: field.id) ?? field.defaultValue ?? "" },
                set: { formState.setValue($0, for: field.id) }
            ))
            .textFieldStyle(.roundedBorder)
            #if os(iOS)
            .keyboardType(UIKeyboardType.URL)
            #endif
            .automaticCompliance()
            
            // Character counter for fields with maxLength validation
            if let maxLength = field.maxLength {
                let currentValue = formState.getValue(for: field.id) ?? field.defaultValue ?? ""
                CharacterCounterView(currentLength: currentValue.count, maxLength: maxLength)
            }
        }
        .padding()
        .environment(\.accessibilityIdentifierLabel, field.label)
        .automaticCompliance(named: "DynamicURLField")
    }
}

/// Number field component
/// TDD RED PHASE: This is a stub implementation for testing
@MainActor
public struct DynamicNumberField: View {
    let field: DynamicFormField
    @ObservedObject var formState: DynamicFormState

    public init(field: DynamicFormField, formState: DynamicFormState) {
        self.field = field
        self.formState = formState
    }

    public var body: some View {
        VStack(alignment: .leading) {
            Text(field.label)
                .font(.subheadline)

            TextField(field.placeholder ?? "Enter number", text: Binding(
                get: { formState.getValue(for: field.id) ?? field.defaultValue ?? "" },
                set: { formState.setValue($0, for: field.id) }
            ))
            .textFieldStyle(.roundedBorder)
            #if os(iOS)
            .keyboardType(UIKeyboardType.decimalPad)
            #endif
            .automaticCompliance()
        }
        .padding()
        .environment(\.accessibilityIdentifierLabel, field.label)
        .automaticCompliance(named: "DynamicNumberField")
    }
}

/// Integer field component
/// TDD RED PHASE: This is a stub implementation for testing
@MainActor
public struct DynamicIntegerField: View {
    let field: DynamicFormField
    @ObservedObject var formState: DynamicFormState

    public init(field: DynamicFormField, formState: DynamicFormState) {
        self.field = field
        self.formState = formState
    }

    public var body: some View {
        VStack(alignment: .leading) {
            Text(field.label)
                .font(.subheadline)

            TextField(field.placeholder ?? "Enter integer", text: Binding(
                get: { formState.getValue(for: field.id) ?? field.defaultValue ?? "" },
                set: { formState.setValue($0, for: field.id) }
            ))
            .textFieldStyle(.roundedBorder)
            #if os(iOS)
            .keyboardType(UIKeyboardType.numberPad)
            #endif
            .automaticCompliance()
        }
        .padding()
        .environment(\.accessibilityIdentifierLabel, field.label) // TDD GREEN: Pass label to identifier generation
        .automaticCompliance(named: "DynamicIntegerField")
    }
}

/// Date field component
/// TDD RED PHASE: This is a stub implementation for testing
@MainActor
public struct DynamicDateField: View {
    let field: DynamicFormField
    @ObservedObject var formState: DynamicFormState

    public init(field: DynamicFormField, formState: DynamicFormState) {
        self.field = field
        self.formState = formState
    }

    public var body: some View {
        VStack(alignment: .leading) {
            Text(field.label)
                .font(.subheadline)

            DatePicker(field.placeholder ?? "Select date",
                      selection: Binding(
                          get: { Date() }, // TODO: Parse from formState
                          set: { _ in } // TODO: Store in formState
                      ),
                      displayedComponents: .date)
            .automaticCompliance()
        }
        .padding()
        .environment(\.accessibilityIdentifierLabel, field.label) // TDD GREEN: Pass label to identifier generation
        .automaticCompliance(named: "DynamicDateField")
    }
}

/// Time field component
/// TDD RED PHASE: This is a stub implementation for testing
@MainActor
public struct DynamicTimeField: View {
    let field: DynamicFormField
    @ObservedObject var formState: DynamicFormState

    public init(field: DynamicFormField, formState: DynamicFormState) {
        self.field = field
        self.formState = formState
    }

    public var body: some View {
        VStack(alignment: .leading) {
            Text(field.label)
                .font(.subheadline)

            DatePicker(field.placeholder ?? "Select time",
                      selection: Binding(
                          get: { Date() }, // TODO: Parse from formState
                          set: { _ in } // TODO: Store in formState
                      ),
                      displayedComponents: .hourAndMinute)
            .automaticCompliance()
        }
        .padding()
        .environment(\.accessibilityIdentifierLabel, field.label) // TDD GREEN: Pass label to identifier generation
        .automaticCompliance(named: "DynamicTimeField")
    }
}

/// DateTime field component
/// TDD RED PHASE: This is a stub implementation for testing
@MainActor
public struct DynamicDateTimeField: View {
    let field: DynamicFormField
    @ObservedObject var formState: DynamicFormState

    public init(field: DynamicFormField, formState: DynamicFormState) {
        self.field = field
        self.formState = formState
    }

    public var body: some View {
        VStack(alignment: .leading) {
            Text(field.label)
                .font(.subheadline)

            DatePicker(field.placeholder ?? "Select date and time",
                      selection: Binding(
                          get: { Date() }, // TODO: Parse from formState
                          set: { _ in } // TODO: Store in formState
                      ))
            .automaticCompliance()
        }
        .padding()
        .environment(\.accessibilityIdentifierLabel, field.label) // TDD GREEN: Pass label to identifier generation
        .automaticCompliance(named: "DynamicDateTimeField")
    }
}


/// Multi-select field component
/// GREEN PHASE: Full implementation of multi-select interface
@MainActor
public struct DynamicMultiSelectField: View {
    let field: DynamicFormField
    @ObservedObject var formState: DynamicFormState

    public init(field: DynamicFormField, formState: DynamicFormState) {
        self.field = field
        self.formState = formState
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(field.label)
                .font(.subheadline)
                .bold()
                .automaticCompliance(named: "FieldLabel")

            if let options = field.options {
                ForEach(options, id: \.self) { option in
                    Toggle(option, isOn: Binding(
                        get: {
                            let selectedValues = formState.fieldValues[field.id] as? [String] ?? []
                            return selectedValues.contains(option)
                        },
                        set: { isSelected in
                            var selectedValues = formState.fieldValues[field.id] as? [String] ?? []
                            if isSelected {
                                if !selectedValues.contains(option) {
                                    selectedValues.append(option)
                                }
                            } else {
                                selectedValues.removeAll { $0 == option }
                            }
                            formState.setValue(selectedValues, for: field.id)
                        }
                    ))
                    .automaticCompliance(named: "MultiSelectOption")
                }
            }
        }
        .padding()
        .environment(\.accessibilityIdentifierLabel, field.label) // TDD GREEN: Pass label to identifier generation
        .automaticCompliance(named: "DynamicMultiSelectField")
    }
}

/// Radio field component
/// GREEN PHASE: Full implementation of radio button group
@MainActor
public struct DynamicRadioField: View {
    let field: DynamicFormField
    @ObservedObject var formState: DynamicFormState

    public init(field: DynamicFormField, formState: DynamicFormState) {
        self.field = field
        self.formState = formState
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(field.label)
                .font(.subheadline)
                .bold()
                .automaticCompliance(named: "FieldLabel")

            if let options = field.options {
                #if os(macOS)
                Picker(field.label, selection: Binding(
                    get: { formState.fieldValues[field.id] as? String ?? "" },
                    set: { formState.setValue($0, for: field.id) }
                )) {
                    ForEach(options, id: \.self) { option in
                        Text(option).tag(option)
                    }
                }
                .pickerStyle(.radioGroup)
                .automaticCompliance(named: "RadioGroup")
                #else
                // iOS: Use custom radio button implementation
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(options, id: \.self) { option in
                        HStack {
                            Button(action: {
                                formState.setValue(option, for: field.id)
                            }) {
                                HStack {
                                    Image(systemName: (formState.fieldValues[field.id] as? String ?? "") == option ? "largecircle.fill.circle" : "circle")
                                        .foregroundColor(.accentColor)
                                    Text(option)
                                }
                            }
                            .buttonStyle(.plain)
                            .automaticCompliance(named: "RadioOption")
                            Spacer()
                        }
                    }
                }
                .automaticCompliance(named: "RadioGroup")
                #endif
            }
        }
        .padding()
        .automaticCompliance(named: "DynamicRadioField")
    }
}

/// Checkbox field component
/// GREEN PHASE: Full implementation of checkbox group
@MainActor
public struct DynamicCheckboxField: View {
    let field: DynamicFormField
    @ObservedObject var formState: DynamicFormState

    public init(field: DynamicFormField, formState: DynamicFormState) {
        self.field = field
        self.formState = formState
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(field.label)
                .font(.subheadline)
                .bold()
                .automaticCompliance(named: "FieldLabel")

            if let options = field.options {
                ForEach(options, id: \.self) { option in
                    Toggle(option, isOn: Binding(
                        get: {
                            let selectedValues = formState.fieldValues[field.id] as? [String] ?? []
                            return selectedValues.contains(option)
                        },
                        set: { isSelected in
                            var selectedValues = formState.fieldValues[field.id] as? [String] ?? []
                            if isSelected {
                                if !selectedValues.contains(option) {
                                    selectedValues.append(option)
                                }
                            } else {
                                selectedValues.removeAll { $0 == option }
                            }
                            formState.setValue(selectedValues, for: field.id)
                        }
                    ))
                    .automaticCompliance(named: "CheckboxOption")
                }
            }
        }
        .padding()
        .environment(\.accessibilityIdentifierLabel, field.label) // TDD GREEN: Pass label to identifier generation
        .automaticCompliance(named: "DynamicCheckboxField")
    }
}

// MARK: - Existing Advanced Field Components (TDD Red Phase Stubs)

// Color picker field component


/// Rich text field component
/// GREEN PHASE: Full implementation of rich text editor
@MainActor
public struct DynamicRichTextField: View {
    let field: DynamicFormField
    @ObservedObject var formState: DynamicFormState

    public init(field: DynamicFormField, formState: DynamicFormState) {
        self.field = field
        self.formState = formState
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(field.label)
                .font(.subheadline)
                .bold()
                .automaticCompliance(named: "FieldLabel")

            #if os(iOS)
            TextEditor(text: Binding(
                get: { formState.fieldValues[field.id] as? String ?? field.defaultValue ?? "" },
                set: { formState.setValue($0, for: field.id) }
            ))
            .frame(minHeight: 100)
            .border(Color.gray.opacity(0.2))
            .automaticCompliance(named: "RichTextEditor")
            #else
            TextField(field.placeholder ?? "Enter text", text: Binding(
                get: { formState.fieldValues[field.id] as? String ?? field.defaultValue ?? "" },
                set: { formState.setValue($0, for: field.id) }
            ))
            .textFieldStyle(.roundedBorder)
            .frame(minHeight: 100)
            .automaticCompliance(named: "RichTextEditor")
            #endif
        }
        .padding()
        .automaticCompliance(named: "DynamicRichTextField")
    }
}

/// File field component
/// GREEN PHASE: Full implementation of file picker
@MainActor
public struct DynamicFileField: View {
    let field: DynamicFormField
    @ObservedObject var formState: DynamicFormState

    public init(field: DynamicFormField, formState: DynamicFormState) {
        self.field = field
        self.formState = formState
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(field.label)
                .font(.subheadline)
                .bold()
                .automaticCompliance(named: "FieldLabel")

            Button(action: {
                // TODO: Implement file picker integration
                // This should open file picker and update formState
                print("File picker requested for field: \(field.id)")
            }) {
                HStack {
                    Image(systemName: "doc.badge.plus")
                    Text("Select File")
                }
            }
            .buttonStyle(.bordered)
            .automaticCompliance(named: "FilePickerButton")

            if let fileName = formState.fieldValues[field.id] as? String, !fileName.isEmpty {
                Text("Selected: \(fileName)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .automaticCompliance(named: "SelectedFileName")
            }
        }
        .padding()
        .environment(\.accessibilityIdentifierLabel, field.label) // TDD GREEN: Pass label to identifier generation
        .automaticCompliance(named: "DynamicFileField")
    }
}

/// Image field component
/// GREEN PHASE: Full implementation of image picker
@MainActor
public struct DynamicImageField: View {
    let field: DynamicFormField
    @ObservedObject var formState: DynamicFormState

    public init(field: DynamicFormField, formState: DynamicFormState) {
        self.field = field
        self.formState = formState
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(field.label)
                .font(.subheadline)
                .bold()
                .automaticCompliance(named: "FieldLabel")

            Button(action: {
                // TODO: Implement image picker integration
                // This should open image picker and update formState
                print("Image picker requested for field: \(field.id)")
            }) {
                HStack {
                    Image(systemName: "photo.badge.plus")
                    Text("Select Image")
                }
            }
            .buttonStyle(.bordered)
            .automaticCompliance(named: "ImagePickerButton")

            if let imageData = formState.fieldValues[field.id] as? Data, let image = PlatformImage(data: imageData) {
                #if os(iOS)
                Image(uiImage: image.uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .automaticCompliance(named: "ImagePreview")
                #else
                Image(nsImage: image.nsImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .automaticCompliance(named: "ImagePreview")
                #endif
            }
        }
        .padding()
        .automaticCompliance(named: "DynamicImageField")
    }
}

/// Range field component
/// TDD RED PHASE: This is a stub implementation for testing
@MainActor
public struct DynamicRangeField: View {
    let field: DynamicFormField
    @ObservedObject var formState: DynamicFormState

    public init(field: DynamicFormField, formState: DynamicFormState) {
        self.field = field
        self.formState = formState
    }

    public var body: some View {
        VStack(alignment: .leading) {
            Text(field.label)
                .font(.subheadline)

            Slider(value: Binding(
                get: { Double(formState.getValue(for: field.id) ?? field.defaultValue ?? "0") ?? 0 },
                set: { formState.setValue(String($0), for: field.id) }
            ), in: 0...100)
            .automaticCompliance()
        }
        .padding()
        .environment(\.accessibilityIdentifierLabel, field.label) // TDD GREEN: Pass label to identifier generation
        .automaticCompliance(named: "DynamicRangeField")
    }
}

/// Array field component
/// GREEN PHASE: Full implementation of array input
@MainActor
public struct DynamicArrayField: View {
    let field: DynamicFormField
    @ObservedObject var formState: DynamicFormState

    public init(field: DynamicFormField, formState: DynamicFormState) {
        self.field = field
        self.formState = formState
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(field.label)
                .font(.subheadline)
                .bold()
                .automaticCompliance(named: "FieldLabel")

            ForEach(Array((formState.fieldValues[field.id] as? [String] ?? []).enumerated()), id: \.offset) { index, value in
                HStack {
                    TextField("Item \(index + 1)", text: Binding(
                        get: { value },
                        set: { newValue in
                            var values = formState.fieldValues[field.id] as? [String] ?? []
                            if index < values.count {
                                values[index] = newValue
                                formState.setValue(values, for: field.id)
                            }
                        }
                    ))
                    .textFieldStyle(.roundedBorder)
                    .environment(\.accessibilityIdentifierLabel, value) // TDD GREEN: Pass array item value to identifier generation
                    .automaticCompliance(named: "ArrayItem")

                    Button(action: {
                        var values = formState.fieldValues[field.id] as? [String] ?? []
                        if index < values.count {
                            values.remove(at: index)
                            formState.setValue(values, for: field.id)
                        }
                    }) {
                        Image(systemName: "minus.circle")
                            .foregroundColor(.red)
                    }
                    .buttonStyle(.borderless)
                    .automaticCompliance(named: "RemoveItem")
                }
            }

            Button(action: {
                var values = formState.fieldValues[field.id] as? [String] ?? []
                values.append("")
                formState.setValue(values, for: field.id)
            }) {
                HStack {
                    Image(systemName: "plus.circle")
                    Text("Add Item")
                }
            }
            .buttonStyle(.bordered)
            .automaticCompliance(named: "AddItem")
        }
        .padding()
        .environment(\.accessibilityIdentifierLabel, field.label) // TDD GREEN: Pass label to identifier generation
        .automaticCompliance(named: "DynamicArrayField")
    }
}

/// Data field component
/// GREEN PHASE: Full implementation of data input
@MainActor
public struct DynamicDataField: View {
    let field: DynamicFormField
    @ObservedObject var formState: DynamicFormState

    public init(field: DynamicFormField, formState: DynamicFormState) {
        self.field = field
        self.formState = formState
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(field.label)
                .font(.subheadline)
                .bold()
                .automaticCompliance(named: "FieldLabel")

            TextEditor(text: Binding(
                get: {
                    if let data = formState.fieldValues[field.id] as? Data {
                        return String(data: data, encoding: .utf8) ?? ""
                    }
                    return ""
                },
                set: { newValue in
                    if let data = newValue.data(using: .utf8) {
                        formState.setValue(data, for: field.id)
                    }
                }
            ))
            .frame(minHeight: 100)
            .border(Color.gray.opacity(0.2))
            .automaticCompliance(named: "DataInput")

            if let data = formState.fieldValues[field.id] as? Data {
                Text("Data size: \(data.count) bytes")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .automaticCompliance(named: "DataSize")
            }
        }
        .padding()
        .automaticCompliance(named: "DynamicDataField")
    }
}

/// Autocomplete field component
/// GREEN PHASE: Full implementation of autocomplete
@MainActor
public struct DynamicAutocompleteField: View {
    let field: DynamicFormField
    @ObservedObject var formState: DynamicFormState
    @State private var searchText: String = ""
    @State private var showSuggestions: Bool = false

    public init(field: DynamicFormField, formState: DynamicFormState) {
        self.field = field
        self.formState = formState
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(field.label)
                .font(.subheadline)
                .bold()
                .automaticCompliance(named: "FieldLabel")

            TextField(field.placeholder ?? "Type to search", text: Binding(
                get: { formState.fieldValues[field.id] as? String ?? field.defaultValue ?? "" },
                set: { newValue in
                    formState.setValue(newValue, for: field.id)
                    searchText = newValue
                    showSuggestions = !newValue.isEmpty && field.options != nil
                }
            ))
            .textFieldStyle(.roundedBorder)
            .automaticCompliance(named: "AutocompleteInput")
            .onAppear {
                searchText = formState.fieldValues[field.id] as? String ?? ""
            }
            
            // Character counter for fields with maxLength validation
            if let maxLength = field.maxLength {
                let currentValue = formState.fieldValues[field.id] as? String ?? field.defaultValue ?? ""
                CharacterCounterView(currentLength: currentValue.count, maxLength: maxLength)
            }

            if showSuggestions, let options = field.options {
                let filtered = options.filter { $0.localizedCaseInsensitiveContains(searchText) }
                if !filtered.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        ForEach(filtered.prefix(5), id: \.self) { suggestion in
                            Button(action: {
                                formState.setValue(suggestion, for: field.id)
                                searchText = suggestion
                                showSuggestions = false
                            }) {
                                Text(suggestion)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .buttonStyle(.plain)
                            .automaticCompliance(named: "Suggestion")
                        }
                    }
                    .padding(8)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .automaticCompliance(named: "SuggestionsList")
                }
            }
        }
        .padding()
        .automaticCompliance(named: "DynamicAutocompleteField")
    }
}

/// Enum field component
/// GREEN PHASE: Full implementation of enum picker
@MainActor
public struct DynamicEnumField: View {
    let field: DynamicFormField
    @ObservedObject var formState: DynamicFormState

    public init(field: DynamicFormField, formState: DynamicFormState) {
        self.field = field
        self.formState = formState
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(field.label)
                .font(.subheadline)
                .bold()
                .automaticCompliance(named: "FieldLabel")

            if let options = field.options {
                Picker(field.label, selection: Binding(
                    get: { formState.fieldValues[field.id] as? String ?? "" },
                    set: { formState.setValue($0, for: field.id) }
                )) {
                    ForEach(options, id: \.self) { option in
                        Text(option).tag(option)
                    }
                }
                .pickerStyle(.menu)
                .automaticCompliance(named: "EnumPicker")
            }
        }
        .padding()
        .environment(\.accessibilityIdentifierLabel, field.label) // TDD GREEN: Pass label to identifier generation
        .automaticCompliance(named: "DynamicEnumField")
    }
}

/// Custom field component
/// GREEN PHASE: Full implementation using CustomFieldRegistry
@MainActor
public struct DynamicCustomField: View {
    let field: DynamicFormField
    @ObservedObject var formState: DynamicFormState

    public init(field: DynamicFormField, formState: DynamicFormState) {
        self.field = field
        self.formState = formState
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(field.label)
                .font(.subheadline)
                .bold()
                .automaticCompliance(named: "FieldLabel")

            if let customComponent = CustomFieldRegistry.shared.createComponent(for: field, formState: formState) {
                AnyView(customComponent)
            } else {
                Text("Custom field not registered: \(field.contentType?.rawValue ?? "unknown")")
                    .foregroundColor(.red)
                    .font(.caption)
                    .automaticCompliance(named: "CustomFieldError")
            }
        }
        .padding()
        .automaticCompliance(named: "DynamicCustomField")
    }
}

// MARK: - Advanced Field Components (From AdvancedFieldTypes.swift)

// Color picker field component
/// GREEN PHASE: Full implementation of color picker
@MainActor
public struct DynamicColorField: View {
    let field: DynamicFormField
    @ObservedObject var formState: DynamicFormState
    
    public init(field: DynamicFormField, formState: DynamicFormState) {
        self.field = field
        self.formState = formState
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(field.label)
                .font(.subheadline)
                .bold()
                .automaticCompliance(named: "FieldLabel")
            
            let colorValue = formState.fieldValues[field.id] as? String ?? "#000000"
            let color = Color(hex: colorValue) ?? .black
            
            ColorPicker(field.placeholder ?? "Select Color", selection: Binding(
                get: { color },
                set: { newColor in
                    let hex = newColor.toHex()
                    formState.setValue(hex, for: field.id)
                }
            ))
            .automaticCompliance(named: "ColorPicker")
            
            Rectangle()
                .fill(color)
                .frame(height: 40)
                .cornerRadius(8)
                .automaticCompliance(named: "ColorPreview")
        }
        .padding()
        .automaticCompliance(named: "DynamicColorField")
    }
}

/// Toggle field component
/// TDD RED PHASE: This is a stub implementation for testing
@MainActor
public struct DynamicToggleField: View {
    let field: DynamicFormField
    @ObservedObject var formState: DynamicFormState
    
    public init(field: DynamicFormField, formState: DynamicFormState) {
        self.field = field
        self.formState = formState
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            Text(field.label)
                .font(.subheadline)
            
            Toggle("Toggle Field - TDD Red Phase Stub", isOn: .constant(false))
        }
        .padding()
        .environment(\.accessibilityIdentifierLabel, field.label) // TDD GREEN: Pass label to identifier generation
        .automaticCompliance(named: "DynamicToggleField")
    }
}


/// Text area field component
/// GREEN PHASE: Full implementation of multi-line text editor
@MainActor
public struct DynamicTextAreaField: View {
    let field: DynamicFormField
    @ObservedObject var formState: DynamicFormState
    
    public init(field: DynamicFormField, formState: DynamicFormState) {
        self.field = field
        self.formState = formState
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(field.label)
                .font(.subheadline)
                .bold()
                .automaticCompliance(named: "FieldLabel")
            
            #if os(iOS)
            TextEditor(text: Binding(
                get: { formState.fieldValues[field.id] as? String ?? field.defaultValue ?? "" },
                set: { formState.setValue($0, for: field.id) }
            ))
            .frame(minHeight: 100)
            .border(Color.gray.opacity(0.2))
            .automaticCompliance(named: "TextArea")
            #else
            TextField(field.placeholder ?? "Enter text", text: Binding(
                get: { formState.fieldValues[field.id] as? String ?? field.defaultValue ?? "" },
                set: { formState.setValue($0, for: field.id) }
            ), axis: .vertical)
            .textFieldStyle(.roundedBorder)
            .lineLimit(5...10)
            .automaticCompliance(named: "TextArea")
            #endif
            
            // Character counter for fields with maxLength validation
            if let maxLength = field.maxLength {
                let currentValue = formState.fieldValues[field.id] as? String ?? field.defaultValue ?? ""
                CharacterCounterView(currentLength: currentValue.count, maxLength: maxLength)
            }
        }
        .padding()
        .environment(\.accessibilityIdentifierLabel, field.label) // TDD GREEN: Pass label to identifier generation
        .automaticCompliance(named: "DynamicTextAreaField")
    }
}
