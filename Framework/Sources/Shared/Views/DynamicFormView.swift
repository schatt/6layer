import SwiftUI

/// Main dynamic form view that renders forms based on configuration
public struct DynamicFormView: View {
    @StateObject private var formState: DynamicFormState
    private let configuration: DynamicFormConfiguration
    private let onSubmit: ([String: Any]) -> Void
    private let onCancel: (() -> Void)?
    
    public init(
        configuration: DynamicFormConfiguration,
        onSubmit: @escaping ([String: Any]) -> Void,
        onCancel: (() -> Void)? = nil
    ) {
        self.configuration = configuration
        self.onSubmit = onSubmit
        self.onCancel = onCancel
        self._formState = StateObject(wrappedValue: DynamicFormState(configuration: configuration))
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            // Form header
            DynamicFormHeader(configuration: configuration)
            
            // Form content
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(configuration.sections) { section in
                        DynamicFormSectionView(
                            section: section,
                            formState: formState
                        )
                    }
                }
                .padding()
            }
            
            // Form actions
            DynamicFormActions(
                formState: formState,
                configuration: configuration,
                onSubmit: handleSubmit,
                onCancel: handleCancel
            )
        }
        .navigationTitle(configuration.title)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.large)
        #endif
    }
    
    // MARK: - Action Handlers
    
    private func handleSubmit() {
        guard formState.isValid else { return }
        
        formState.isSubmitting = true
        
        // Simulate async submission
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            formState.isSubmitting = false
            onSubmit(formState.formData)
        }
    }
    
    private func handleCancel() {
        onCancel?()
    }
}

// MARK: - Form Header

/// Header section for dynamic forms
public struct DynamicFormHeader: View {
    let configuration: DynamicFormConfiguration
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(configuration.title)
                .font(.title)
                .fontWeight(.bold)
            
            if let description = configuration.description {
                Text(description)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.cardBackground)
    }
}

// MARK: - Form Section View

/// Individual section view for dynamic forms
public struct DynamicFormSectionView: View {
    let section: DynamicFormSection
    @ObservedObject var formState: DynamicFormState
    @State private var isCollapsed: Bool
    
    public init(section: DynamicFormSection, formState: DynamicFormState) {
        self.section = section
        self.formState = formState
        self._isCollapsed = State(initialValue: formState.isSectionCollapsed(section.id))
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Section header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(section.title)
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    if let description = section.description {
                        Text(description)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                if section.isCollapsible {
                    Button(action: toggleSection) {
                        Image(systemName: isCollapsed ? "chevron.down" : "chevron.up")
                            .foregroundColor(.accentColor)
                    }
                }
            }
            
            // Section fields
            if !isCollapsed {
                LazyVStack(spacing: 16) {
                    ForEach(section.fields) { field in
                        DynamicFormFieldView(
                            field: field,
                            formState: formState
                        )
                    }
                }
            }
        }
        .padding()
        .background(Color.secondaryBackground)
        .cornerRadius(12)
        .onChange(of: isCollapsed) { newValue in
            formState.toggleSection(section.id)
        }
    }
    
    private func toggleSection() {
        isCollapsed.toggle()
    }
}

// MARK: - Form Field View

/// Individual field view for dynamic forms
public struct DynamicFormFieldView: View {
    let field: DynamicFormField
    @ObservedObject var formState: DynamicFormState
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Field label with hover tooltip
            HStack {
                Text(field.label)
                    .font(.body)
                    .fontWeight(.medium)
                
                if field.isRequired {
                    Text("*")
                        .foregroundColor(.red)
                        .fontWeight(.bold)
                }
                
                Spacer()
            }
            .modifier(FieldHoverTooltipModifier(description: field.description))
            
            // Field input
            fieldInput
            
            // Field errors
            if formState.hasErrors(for: field.id) {
                ForEach(formState.getErrors(for: field.id), id: \.self) { error in
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }
        }
    }
    
    @ViewBuilder
    private var fieldInput: some View {
        if let textContentType = field.textContentType {
            DynamicTextField(
                field: field,
                formState: formState
            )
        } else if let contentType = field.contentType {
            switch contentType {
        case .text, .email, .password, .phone, .url:
            DynamicTextField(
                field: field,
                formState: formState
            )
        case .number, .range:
            DynamicNumberField(
                field: field,
                formState: formState
            )
        case .integer:
            DynamicIntegerField(
                field: field,
                formState: formState
            )
        case .textarea:
            DynamicTextAreaField(
                field: field,
                formState: formState
            )
        case .select:
            DynamicSelectField(
                field: field,
                formState: formState
            )
        case .multiselect:
            DynamicMultiSelectField(
                field: field,
                formState: formState
            )
        case .radio:
            DynamicRadioField(
                field: field,
                formState: formState
            )
        case .checkbox:
            DynamicCheckboxField(
                field: field,
                formState: formState
            )
        case .toggle:
            DynamicToggleField(
                field: field,
                formState: formState
            )
        case .date:
            DatePickerField(
                field: field,
                formState: formState
            )
        case .time:
            TimePickerField(
                field: field,
                formState: formState
            )
        case .datetime:
            DateTimePickerField(
                field: field,
                formState: formState
            )
        case .color:
            DynamicColorField(
                field: field,
                formState: formState
            )
        case .file:
            EnhancedFileUploadField(
                field: field,
                formState: formState,
                allowedTypes: [.image, .pdf, .text, .audio, .video],
                maxFileSize: 50 * 1024 * 1024 // 50MB default
            )
        case .image:
            DynamicImageField(
                field: field,
                formState: formState
            )
        case .array:
            DynamicArrayField(
                field: field,
                formState: formState
            )
        case .data:
            DynamicDataField(
                field: field,
                formState: formState
            )
        case .`enum`:
            DynamicEnumField(
                field: field,
                formState: formState
            )
        case .richtext:
            RichTextEditorField(
                field: field,
                formState: formState
            )
        case .autocomplete:
            AutocompleteField(
                field: field,
                formState: formState,
                suggestions: field.options ?? []
            )
        case .custom:
            CustomFieldView(
                field: field,
                formState: formState
            )
        }
        } else {
            // Fallback for fields with neither textContentType nor contentType
            DynamicTextField(
                field: field,
                formState: formState
            )
        }
    }
}

// MARK: - Form Actions

/// Action buttons for dynamic forms
public struct DynamicFormActions: View {
    @ObservedObject var formState: DynamicFormState
    let configuration: DynamicFormConfiguration
    let onSubmit: () -> Void
    let onCancel: () -> Void
    
    public var body: some View {
        HStack(spacing: 16) {
            if let cancelButtonText = configuration.cancelButtonText {
                Button(cancelButtonText, action: onCancel)
                    .buttonStyle(.bordered)
            }
            
            Spacer()
            
            Button(configuration.submitButtonText, action: onSubmit)
                .buttonStyle(.borderedProminent)
                .disabled(!formState.isValid || formState.isSubmitting)
                .overlay(
                    Group {
                        if formState.isSubmitting {
                            ProgressView()
                                .scaleEffect(0.8)
                        }
                    }
                )
        }
        .padding()
        .background(Color.cardBackground)
    }
}

// MARK: - Field Type Implementations

/// Text input field for dynamic forms
public struct DynamicTextField: View {
    let field: DynamicFormField
    @ObservedObject var formState: DynamicFormState
    
    public var body: some View {
        TextField(
            field.placeholder ?? field.label,
            text: Binding(
                get: { formState.getValue(for: field.id) ?? "" },
                set: { formState.setValue($0, for: field.id) }
            )
        )
        .textFieldStyle(.roundedBorder)
        #if os(iOS)
        .keyboardType(keyboardType)
        #endif
        #if canImport(UIKit)
        .textContentType(textContentType?.uiTextContentType)
        #endif
    }
    
    private var textContentType: SixLayerTextContentType? {
        return field.textContentType
    }
    
    #if canImport(UIKit)
    private var keyboardType: UIKeyboardType {
        guard let textContentType = field.textContentType else {
            return .default
        }
        
        switch textContentType {
        case .emailAddress:
            return .emailAddress
        case .telephoneNumber:
            return .phonePad
        case .URL:
            return .URL
        case .oneTimeCode:
            return .numberPad
        case .creditCardNumber:
            return .numberPad
        case .postalCode:
            return .numberPad
        case .name, .username, .newPassword, .password, .fullStreetAddress, .jobTitle, .organizationName, .givenName, .familyName, .middleName, .namePrefix, .nameSuffix, .addressState, .countryName, .streetAddressLine1, .streetAddressLine2, .addressCity, .addressCityAndState, .sublocality, .location:
            return .default
        }
    }
    #endif
}

/// Number input field for dynamic forms
public struct DynamicNumberField: View {
    let field: DynamicFormField
    @ObservedObject var formState: DynamicFormState
    
    public var body: some View {
        TextField(
            field.placeholder ?? field.label,
            value: Binding(
                get: { formState.getValue(for: field.id) ?? 0 },
                set: { formState.setValue($0, for: field.id) }
            ),
            format: .number
        )
        .textFieldStyle(.roundedBorder)
        #if os(iOS)
        .keyboardType(.numberPad)
        #endif
    }
}

/// Text area field for dynamic forms
public struct DynamicTextAreaField: View {
    let field: DynamicFormField
    @ObservedObject var formState: DynamicFormState
    
    public var body: some View {
        TextEditor(text: Binding(
            get: { formState.getValue(for: field.id) ?? "" },
            set: { formState.setValue($0, for: field.id) }
        ))
        .frame(minHeight: 100)
        .padding(8)
        .background(Color.secondaryBackground)
        .cornerRadius(8)
    }
}

/// Select field for dynamic forms
public struct DynamicSelectField: View {
    let field: DynamicFormField
    @ObservedObject var formState: DynamicFormState
    
    public var body: some View {
        Picker(
            field.label,
            selection: Binding(
                get: { formState.getValue(for: field.id) ?? "" },
                set: { formState.setValue($0, for: field.id) }
            )
        ) {
            Text("Select an option").tag("")
            ForEach(field.options ?? [], id: \.self) { option in
                Text(option).tag(option)
            }
        }
        .pickerStyle(.menu)
    }
}

/// Multi-select field for dynamic forms
public struct DynamicMultiSelectField: View {
    let field: DynamicFormField
    @ObservedObject var formState: DynamicFormState
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(field.options ?? [], id: \.self) { option in
                HStack {
                    Toggle(option, isOn: Binding(
                        get: { 
                            let values: [String] = formState.getValue(for: field.id) ?? []
                            return values.contains(option)
                        },
                        set: { isSelected in
                            var values: [String] = formState.getValue(for: field.id) ?? []
                            if isSelected {
                                values.append(option)
                            } else {
                                values.removeAll { $0 == option }
                            }
                            formState.setValue(values, for: field.id)
                        }
                    ))
                }
            }
        }
    }
}

/// Radio field for dynamic forms
public struct DynamicRadioField: View {
    let field: DynamicFormField
    @ObservedObject var formState: DynamicFormState
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(field.options ?? [], id: \.self) { option in
                HStack {
                    Button(action: {
                        formState.setValue(option, for: field.id)
                    }) {
                        HStack {
                            Image(systemName: formState.getValue(for: field.id) == option ? "largecircle.fill.circle" : "circle")
                                .foregroundColor(.accentColor)
                            Text(option)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

/// Checkbox field for dynamic forms
public struct DynamicCheckboxField: View {
    let field: DynamicFormField
    @ObservedObject var formState: DynamicFormState
    
    public var body: some View {
        Toggle(field.label, isOn: Binding(
            get: { formState.getValue(for: field.id) ?? false },
            set: { formState.setValue($0, for: field.id) }
        ))
    }
}

/// Toggle field for dynamic forms
public struct DynamicToggleField: View {
    let field: DynamicFormField
    @ObservedObject var formState: DynamicFormState
    
    public var body: some View {
        Toggle(field.label, isOn: Binding(
            get: { formState.getValue(for: field.id) ?? false },
            set: { formState.setValue($0, for: field.id) }
        ))
    }
}

/// Date field for dynamic forms
public struct DynamicDateField: View {
    let field: DynamicFormField
    @ObservedObject var formState: DynamicFormState
    
    public var body: some View {
        DatePicker(
            field.label,
            selection: Binding(
                get: { formState.getValue(for: field.id) ?? Date() },
                set: { formState.setValue($0, for: field.id) }
            ),
            displayedComponents: .date
        )
    }
}

/// Time field for dynamic forms
public struct DynamicTimeField: View {
    let field: DynamicFormField
    @ObservedObject var formState: DynamicFormState
    
    public var body: some View {
        DatePicker(
            field.label,
            selection: Binding(
                get: { formState.getValue(for: field.id) ?? Date() },
                set: { formState.setValue($0, for: field.id) }
            ),
            displayedComponents: .hourAndMinute
        )
    }
}

/// Date-time field for dynamic forms
public struct DynamicDateTimeField: View {
    let field: DynamicFormField
    @ObservedObject var formState: DynamicFormState
    
    public var body: some View {
        DatePicker(
            field.label,
            selection: Binding(
                get: { formState.getValue(for: field.id) ?? Date() },
                set: { formState.setValue($0, for: field.id) }
            ),
            displayedComponents: [.date, .hourAndMinute]
        )
    }
}

/// Color field for dynamic forms
public struct DynamicColorField: View {
    let field: DynamicFormField
    @ObservedObject var formState: DynamicFormState
    
    public var body: some View {
        ColorPicker(
            field.label,
            selection: Binding(
                get: { formState.getValue(for: field.id) ?? Color.blue },
                set: { formState.setValue($0, for: field.id) }
            )
        )
    }
}

/// File field for dynamic forms
public struct DynamicFileField: View {
    let field: DynamicFormField
    @ObservedObject var formState: DynamicFormState
    
    public var body: some View {
        Button("Select File") {
            // File picker implementation would go here
            // For now, just set a placeholder value
            formState.setValue("file_selected", for: field.id)
        }
        .buttonStyle(.bordered)
    }
}

// MARK: - High Priority Native Type Fields

/// Integer field for dynamic forms with native Int support
public struct DynamicIntegerField: View {
    let field: DynamicFormField
    @ObservedObject var formState: DynamicFormState
    
    public var body: some View {
        TextField(
            field.placeholder ?? field.label,
            value: Binding(
                get: { formState.getValue(for: field.id) ?? 0 },
                set: { formState.setValue($0, for: field.id) }
            ),
            format: .number
        )
        .textFieldStyle(.roundedBorder)
        #if os(iOS)
        .keyboardType(.numberPad)
        #endif
    }
}

/// Image field for dynamic forms with native image support
public struct DynamicImageField: View {
    let field: DynamicFormField
    @ObservedObject var formState: DynamicFormState
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button("Select Image") {
                // Image picker implementation would go here
                // For now, create a mock image for testing
                let mockImage = MockImage(id: "test-image", data: "image-data".data(using: .utf8)!)
                formState.setValue(mockImage, for: field.id)
            }
            .buttonStyle(.bordered)
            
            // Display selected image if available
            if let image: MockImage = formState.getValue(for: field.id) {
                Text("Selected: \(image.id)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

/// URL field for dynamic forms with native URL support
public struct DynamicURLField: View {
    let field: DynamicFormField
    @ObservedObject var formState: DynamicFormState
    
    public var body: some View {
        TextField(
            field.placeholder ?? field.label,
            text: Binding(
                get: { 
                    if let url: MockURL = formState.getValue(for: field.id) {
                        return url.absoluteString
                    }
                    return ""
                },
                set: { 
                    formState.setValue(MockURL($0), for: field.id)
                }
            )
        )
        .textFieldStyle(.roundedBorder)
        #if os(iOS)
        .keyboardType(.URL)
        .textContentType(.URL)
        #endif
    }
}

// MARK: - Medium Priority Native Type Fields

/// Array field for dynamic forms with native array support
public struct DynamicArrayField: View {
    let field: DynamicFormField
    @ObservedObject var formState: DynamicFormState
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            TextField(
                field.placeholder ?? "Add item",
                text: .constant("") // This would be managed by a separate state
            )
            .textFieldStyle(.roundedBorder)
            .onSubmit {
                // Add item to array logic would go here
            }
            
            // Display current array items
            if let items: [String] = formState.getValue(for: field.id) {
                ForEach(items, id: \.self) { item in
                    HStack {
                        Text(item)
                        Spacer()
                        Button("Remove") {
                            // Remove item logic would go here
                        }
                        .buttonStyle(.bordered)
                    }
                }
            }
        }
    }
}

/// Data field for dynamic forms with native Data support
public struct DynamicDataField: View {
    let field: DynamicFormField
    @ObservedObject var formState: DynamicFormState
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button("Select Data File") {
                // Data file picker implementation would go here
                let testData = "Hello World".data(using: .utf8)!
                formState.setValue(testData, for: field.id)
            }
            .buttonStyle(.bordered)
            
            // Display data info if available
            if let data: Data = formState.getValue(for: field.id) {
                Text("Data size: \(data.count) bytes")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

// MARK: - Low Priority Native Type Fields

/// Enum field for dynamic forms with native enum support
public struct DynamicEnumField: View {
    let field: DynamicFormField
    @ObservedObject var formState: DynamicFormState
    
    public var body: some View {
        Picker(field.label, selection: Binding(
            get: { 
                // This would need to be more generic for different enum types
                // For now, return a default value
                return ""
            },
            set: { 
                // Set enum value logic would go here
                formState.setValue($0, for: field.id)
            }
        )) {
            ForEach(field.options ?? [], id: \.self) { option in
                Text(option).tag(option)
            }
        }
        .pickerStyle(.menu)
    }
}

// MARK: - Helper Functions

private func createPersonalInfoFields() -> [DynamicFormField] {
    var fields: [DynamicFormField] = [
        DynamicFormField(id: "firstName", contentType: .textarea, label: "First Name", isRequired: true),
        DynamicFormField(id: "lastName", contentType: .textarea, label: "Last Name", isRequired: true)
    ]
    
    fields.append(DynamicFormField(id: "email", textContentType: .emailAddress, label: "Email Address", isRequired: true))
    fields.append(DynamicFormField(id: "phone", textContentType: .telephoneNumber, label: "Phone Number"))
    
    return fields
}

// MARK: - Preview

#Preview {
    let configuration = DynamicFormConfiguration(
        id: "user-registration",
        title: "User Registration",
        description: "Complete your profile information",
        sections: [
            DynamicFormSection(
                id: "personal",
                title: "Personal Information",
                description: "Basic details about you",
                fields: createPersonalInfoFields()
            ),
            DynamicFormSection(
                id: "preferences",
                title: "Preferences",
                description: "Your choices",
                fields: [
                    DynamicFormField(id: "newsletter", contentType: .checkbox, label: "Subscribe to newsletter"),
                    DynamicFormField(id: "theme", contentType: .select, label: "Theme", options: ["Light", "Dark", "Auto"]),
                    DynamicFormField(id: "notifications", contentType: .toggle, label: "Enable notifications")
                ],
                isCollapsible: true
            )
        ]
    )

    NavigationView {
        DynamicFormView(
            configuration: configuration,
            onSubmit: { data in
                print("Form submitted with data: \(data)")
            },
            onCancel: {
                print("Form cancelled")
            }
        )
    }
}

// MARK: - Field Hover Tooltip Modifier

/// Modifier that adds hover tooltip support for form field descriptions
/// Follows Apple HIG guidelines for tooltip timing and accessibility
struct FieldHoverTooltipModifier: ViewModifier {
    let description: String?
    @State private var isHovering = false
    @State private var showTooltip = false
    @State private var hoverTimer: Timer?
    
    func body(content: Content) -> some View {
        content
            .onHover { hovering in
                isHovering = hovering
                
                if hovering && description != nil {
                    // Start timer for 0.5 second delay per HIG
                    hoverTimer?.invalidate()
                    hoverTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                        if isHovering {
                            showTooltip = true
                        }
                    }
                } else {
                    hoverTimer?.invalidate()
                    showTooltip = false
                }
            }
            .overlay(
                // Tooltip overlay
                Group {
                    if showTooltip, let description = description {
                        #if os(macOS)
                        // macOS: Show tooltip on hover
                        Text(description)
                            .font(.caption)
                            .padding(8)
                            .background(Color.black.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(6)
                            .offset(y: -40)
                            .transition(.opacity.combined(with: .scale))
                        #else
                        // iOS: No tooltip, rely on accessibility
                        EmptyView()
                        #endif
                    }
                }
                .animation(.easeInOut(duration: 0.2), value: showTooltip)
            )
            .accessibilityLabel(accessibilityLabel)
            .accessibilityHint(accessibilityHint ?? "")
    }
    
    private var accessibilityLabel: String {
        // Include description in accessibility label for screen readers
        if let description = description {
            return "\(description)"
        }
        return ""
    }
    
    private var accessibilityHint: String? {
        return description
    }
}
