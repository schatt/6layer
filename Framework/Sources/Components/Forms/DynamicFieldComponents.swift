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
            case .stepper:
                DynamicStepperField(field: field, formState: formState)
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
    
    /// Gets the current text value from formState, falling back to defaultValue
    /// - Parameter formState: The form state to retrieve the value from
    /// - Returns: The current text value or empty string
    @MainActor
    func currentTextValue(from formState: DynamicFormState) -> String {
        return formState.getValue(for: id) as String? ?? defaultValue ?? ""
    }
    
    /// Check if field is read-only based on displayHints or metadata
    /// Returns true if the field should be displayed as read-only (non-editable)
    var isReadOnly: Bool {
        // Check displayHints first (from metadata["isEditable"])
        if let displayHints = displayHints, !displayHints.isEditable {
            return true
        }
        // Check metadata["displayOnly"]
        if metadata?["displayOnly"] == "true" {
            return true
        }
        return false
    }
}

// MARK: - Character Counter Helper

@MainActor
extension DynamicFormField {
    /// Returns a character counter view if maxLength validation is set, nil otherwise
    /// - Parameter formState: The form state to get current value from
    /// - Returns: CharacterCounterView if maxLength is set, nil otherwise
    @ViewBuilder
    func characterCounterView(formState: DynamicFormState) -> some View {
        if let maxLength = maxLength {
            let currentValue = currentTextValue(from: formState)
            CharacterCounterView(currentLength: currentValue.count, maxLength: maxLength)
        }
    }
}

// MARK: - Text Field Helpers (DRY Refactoring)

@MainActor
extension DynamicFormField {
    /// Creates a binding for text field values that syncs with formState
    /// - Parameter formState: The form state to bind to
    /// - Returns: A binding that reads from and writes to formState
    func textBinding(formState: DynamicFormState) -> Binding<String> {
        Binding(
            get: { formState.getValue(for: id) as String? ?? defaultValue ?? "" },
            set: { formState.setValue($0, for: id) }
        )
    }
    
    /// Creates a standard field label view
    /// - Returns: A Text view with the field label
    @ViewBuilder
    func fieldLabel() -> some View {
        Text(label)
            .font(.subheadline)
    }
    
    /// Applies standard field container styling and modifiers
    /// - Parameters:
    ///   - content: The field content view
    ///   - componentName: The name for automatic compliance
    /// - Returns: A view with standard field styling applied
    func fieldContainer<Content: View>(
        @ViewBuilder content: () -> Content,
        componentName: String
    ) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            content()
        }
        .padding()
        .environment(\.accessibilityIdentifierLabel, label)
        .automaticCompliance(named: componentName)
    }
    
    /// Check if field should render as picker based on hints
    var shouldRenderAsPicker: Bool {
        guard let hints = displayHints else { return false }
        return hints.inputType == "picker" && hints.pickerOptions != nil && !(hints.pickerOptions?.isEmpty ?? true)
    }
    
    /// Get picker options from hints (preferred) or field.options (fallback)
    var pickerOptionsFromHints: [(value: String, label: String)] {
        // Prefer pickerOptions from displayHints (has labels)
        if let hints = displayHints,
           let pickerOptions = hints.pickerOptions,
           !pickerOptions.isEmpty {
            return pickerOptions.map { ($0.value, $0.label) }
        }
        // Fallback to field.options (simple string array)
        if let options = options {
            return options.map { ($0, $0) } // Use same value for both value and label
        }
        return []
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
        field.fieldContainer(content: {
            field.fieldLabel()

            // Check if field should render as picker based on hints
            if field.shouldRenderAsPicker {
                // Render picker when inputType == "picker" and pickerOptions exist
                let pickerOptions = field.pickerOptionsFromHints
                if !pickerOptions.isEmpty {
                    Picker(field.placeholder ?? "Select", selection: field.textBinding(formState: formState)) {
                        ForEach(pickerOptions, id: \.value) { option in
                            Text(option.label).tag(option.value)
                        }
                    }
                    .pickerStyle(.menu)
                    .automaticCompliance()
                } else {
                    // Fallback to text field if no options
                    TextField(field.placeholder ?? "Enter text", text: field.textBinding(formState: formState))
                        .textFieldStyle(.roundedBorder)
                        .automaticCompliance()
                }
            } else if field.supportsOCR || field.supportsBarcodeScanning {
                // Render text field with OCR and/or barcode scanning support
                HStack {
                    TextField(field.placeholder ?? "Enter text", text: field.textBinding(formState: formState))
                        .textFieldStyle(.roundedBorder)
                        .automaticCompliance()

                    // OCR button
                    if field.supportsOCR {
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
                    
                    // Barcode scanning button
                    if field.supportsBarcodeScanning {
                        Button(action: {
                            // TODO: Implement barcode scanning workflow
                            // This should trigger BarcodeOverlayView and populate the field
                            print("Barcode scan requested for field: \(field.id)")
                        }) {
                            Image(systemName: "barcode.viewfinder")
                                .foregroundColor(.green)
                        }
                        .buttonStyle(.borderless)
                        .accessibilityLabel("Scan barcode")
                        .accessibilityHint(field.barcodeHint ?? "Scan barcode to fill this field")
                        .automaticCompliance()
                    }
                }
            } else {
                // Default text field
                TextField(field.placeholder ?? "Enter text", text: field.textBinding(formState: formState))
                    .textFieldStyle(.roundedBorder)
                    .automaticCompliance()
            }
            
            // Character counter for fields with maxLength validation
            field.characterCounterView(formState: formState)
        }, componentName: "DynamicTextField")
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
        field.fieldContainer(content: {
            field.fieldLabel()

            TextField(field.placeholder ?? "Enter email", text: field.textBinding(formState: formState))
                .textFieldStyle(.roundedBorder)
                #if os(iOS)
                .keyboardType(UIKeyboardType.emailAddress)
                #endif
                .automaticCompliance()
            
            // Character counter for fields with maxLength validation
            field.characterCounterView(formState: formState)
        }, componentName: "DynamicEmailField")
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
        field.fieldContainer(content: {
            field.fieldLabel()

            SecureField(field.placeholder ?? "Enter password", text: field.textBinding(formState: formState))
                .textFieldStyle(.roundedBorder)
                .automaticCompliance()
            
            // Character counter for fields with maxLength validation
            field.characterCounterView(formState: formState)
        }, componentName: "DynamicPasswordField")
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
        field.fieldContainer(content: {
            field.fieldLabel()

            TextField(field.placeholder ?? "Enter phone", text: field.textBinding(formState: formState))
                .textFieldStyle(.roundedBorder)
                #if os(iOS)
                .keyboardType(UIKeyboardType.phonePad)
                #endif
                .automaticCompliance()
            
            // Character counter for fields with maxLength validation
            field.characterCounterView(formState: formState)
        }, componentName: "DynamicPhoneField")
    }
}

/// URL field component
/// Uses Link component for read-only/display URL fields, TextField for editable fields
@MainActor
public struct DynamicURLField: View {
    let field: DynamicFormField
    @ObservedObject var formState: DynamicFormState

    public init(field: DynamicFormField, formState: DynamicFormState) {
        self.field = field
        self.formState = formState
    }

    /// Get the current URL value from form state
    private var urlValue: String {
        (formState.getValue(for: field.id) as String?) ?? field.defaultValue ?? ""
    }

    /// Parse and validate URL, returning both the URL object and validity
    private var parsedURL: (url: URL?, isValid: Bool) {
        let value = urlValue
        guard !value.isEmpty else {
            return (nil, false)
        }
        if let url = URL(string: value) {
            return (url, true)
        }
        return (nil, false)
    }

    public var body: some View {
        field.fieldContainer(content: {
            field.fieldLabel()

            if field.isReadOnly {
                readOnlyURLView
            } else {
                editableURLView
            }
        }, componentName: "DynamicURLField")
    }
    
    /// Read-only display view: Link for valid URLs, Text for invalid/empty
    @ViewBuilder
    private var readOnlyURLView: some View {
        let (url, isValid) = parsedURL
        if isValid, let url = url {
            Link(urlValue, destination: url)
                .foregroundColor(.blue)
                .automaticCompliance()
        } else {
            Text(urlValue.isEmpty ? "—" : urlValue)
                .foregroundColor(.secondary)
                .automaticCompliance()
        }
    }
    
    /// Editable input view: TextField with URL keyboard type
    @ViewBuilder
    private var editableURLView: some View {
        TextField(field.placeholder ?? "Enter URL", text: field.textBinding(formState: formState))
            .textFieldStyle(.roundedBorder)
            #if os(iOS)
            .keyboardType(UIKeyboardType.URL)
            #endif
            .automaticCompliance()
        
        // Character counter for fields with maxLength validation
        field.characterCounterView(formState: formState)
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
                get: { (formState.getValue(for: field.id) as String?) ?? field.defaultValue ?? "" },
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
                get: { (formState.getValue(for: field.id) as String?) ?? field.defaultValue ?? "" },
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

/// Stepper field component
/// Provides increment/decrement controls for numeric values
@MainActor
public struct DynamicStepperField: View {
    let field: DynamicFormField
    @ObservedObject var formState: DynamicFormState

    public init(field: DynamicFormField, formState: DynamicFormState) {
        self.field = field
        self.formState = formState
    }

    private var value: Binding<Double> {
        Binding(
            get: {
                if let value: Any = formState.getValue(for: field.id) {
                    if let doubleValue = value as? Double {
                        return doubleValue
                    } else if let stringValue = value as? String,
                              let parsed = Double(stringValue) {
                        return parsed
                    }
                }
                return Double(field.defaultValue ?? "0") ?? 0.0
            },
            set: { newValue in
                formState.setValue(String(newValue), for: field.id)
            }
        )
    }

    /// Get range from displayHints (preferred) or metadata (fallback)
    private var range: ClosedRange<Double> {
        // Prefer expectedRange from displayHints (has structured range)
        if let hints = field.displayHints,
           let expectedRange = hints.expectedRange {
            return expectedRange.min...expectedRange.max
        }
        // Fallback to metadata min/max keys
        let min = Double(field.metadata?["min"] ?? "0") ?? 0.0
        let max = Double(field.metadata?["max"] ?? "100") ?? 100.0
        return min...max
    }

    private var step: Double {
        Double(field.metadata?["step"] ?? "1") ?? 1.0
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(field.label)
                .font(.subheadline)
                .bold()

            Stepper(
                field.label,
                value: value,
                in: range,
                step: step
            )

            // Show current value - use appropriate format based on step size
            Text(step.truncatingRemainder(dividingBy: 1.0) == 0.0 
                 ? "\(Int(value.wrappedValue))" 
                 : String(format: "%.2f", value.wrappedValue))
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .environment(\.accessibilityIdentifierLabel, field.label)
        .automaticCompliance(named: "DynamicStepperField")
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
        field.fieldContainer(content: {
            Text(field.label)
                .font(.subheadline)
                .bold()
                .automaticCompliance(named: "FieldLabel")

            #if os(iOS)
            TextEditor(text: field.textBinding(formState: formState))
                .frame(minHeight: 100)
                .border(Color.gray.opacity(0.2))
                .automaticCompliance(named: "RichTextEditor")
            #else
            TextField(field.placeholder ?? "Enter text", text: field.textBinding(formState: formState))
                .textFieldStyle(.roundedBorder)
                .frame(minHeight: 100)
                .automaticCompliance(named: "RichTextEditor")
            #endif
            
            // Character counter for fields with maxLength validation
            field.characterCounterView(formState: formState)
        }, componentName: "DynamicRichTextField")
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
                get: { Double((formState.getValue(for: field.id) as String?) ?? field.defaultValue ?? "0") ?? 0 },
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
                get: { formState.getValue(for: field.id) as String? ?? field.defaultValue ?? "" },
                set: { newValue in
                    formState.setValue(newValue, for: field.id)
                    searchText = newValue
                    showSuggestions = !newValue.isEmpty && field.options != nil
                }
            ))
            .textFieldStyle(.roundedBorder)
            .automaticCompliance(named: "AutocompleteInput")
            .onAppear {
                searchText = formState.getValue(for: field.id) as String? ?? ""
            }
            
            // Character counter for fields with maxLength validation
            field.characterCounterView(formState: formState)

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

    /// Get picker options from hints (preferred) or field.options (fallback)
    private var pickerOptions: [(value: String, label: String)] {
        // Prefer pickerOptions from displayHints (has labels)
        if let hints = field.displayHints,
           let pickerOptions = hints.pickerOptions,
           !pickerOptions.isEmpty {
            return pickerOptions.map { ($0.value, $0.label) }
        }
        // Fallback to field.options (simple string array)
        if let options = field.options {
            return options.map { ($0, $0) } // Use same value for both value and label
        }
        return []
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(field.label)
                .font(.subheadline)
                .bold()
                .automaticCompliance(named: "FieldLabel")

            if !pickerOptions.isEmpty {
                Picker(field.label, selection: Binding(
                    get: { formState.fieldValues[field.id] as? String ?? "" },
                    set: { formState.setValue($0, for: field.id) }
                )) {
                    ForEach(pickerOptions, id: \.value) { option in
                        Text(option.label).tag(option.value)
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
        field.fieldContainer(content: {
            Text(field.label)
                .font(.subheadline)
                .bold()
                .automaticCompliance(named: "FieldLabel")
            
            #if os(iOS)
            TextEditor(text: field.textBinding(formState: formState))
                .frame(minHeight: 100)
                .border(Color.gray.opacity(0.2))
                .automaticCompliance(named: "TextArea")
            #else
            TextField(field.placeholder ?? "Enter text", text: field.textBinding(formState: formState), axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .lineLimit(5...10)
                .automaticCompliance(named: "TextArea")
            #endif
            
            // Character counter for fields with maxLength validation
            field.characterCounterView(formState: formState)
        }, componentName: "DynamicTextAreaField")
    }
}
