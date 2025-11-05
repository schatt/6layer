import SwiftUI

// MARK: - Dynamic Form View

/// Main dynamic form view component
/// GREEN PHASE: Full implementation of dynamic form rendering
@MainActor
public struct DynamicFormView: View {
    let configuration: DynamicFormConfiguration
    let onSubmit: ([String: Any]) -> Void
    @StateObject private var formState: DynamicFormState

    public init(
        configuration: DynamicFormConfiguration,
        onSubmit: @escaping ([String: Any]) -> Void
    ) {
        self.configuration = configuration
        self.onSubmit = onSubmit
        _formState = StateObject(wrappedValue: DynamicFormState(configuration: configuration))
    }

    public var body: some View {
        VStack(spacing: 20) {
            // Form title
            Text(configuration.title)
                .font(.headline)
                .automaticAccessibilityIdentifiers(named: "FormTitle")

            // Form description if present
            if let description = configuration.description {
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .automaticAccessibilityIdentifiers(named: "FormDescription")
            }

            // Show batch OCR button if any fields support OCR
            if !configuration.getOCREnabledFields().isEmpty {
                Button(action: {
                    // TODO: Implement batch OCR workflow
                    // This should trigger OCROverlayView and process all OCR-enabled fields
                    print("Batch OCR scan requested for \(configuration.getOCREnabledFields().count) fields")
                }) {
                    HStack {
                        Image(systemName: "doc.viewfinder")
                        Text("Scan Document")
                    }
                    .foregroundColor(.blue)
                }
                .buttonStyle(.bordered)
                .accessibilityLabel("Scan document to fill multiple fields")
                .accessibilityHint("Takes a photo and automatically fills all OCR-enabled fields")
                .automaticAccessibilityIdentifiers(named: "BatchOCRButton")
            }

            // Render form sections
            ForEach(configuration.sections) { section in
                DynamicFormSectionView(section: section, formState: formState)
            }

            Spacer()

            // Submit button
            Button(action: {
                // Submit the form (validation can be handled by individual fields or externally)
                onSubmit(formState.fieldValues)
            }) {
                Text("Submit")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .automaticAccessibilityIdentifiers(named: "SubmitButton")
        }
        .padding()
        .environment(\.accessibilityIdentifierLabel, configuration.title) // TDD GREEN: Pass label to identifier generation
        .automaticAccessibilityIdentifiers(named: "DynamicFormView")
    }
}

// MARK: - Dynamic Form Section View

/// Section view for dynamic forms
/// GREEN PHASE: Full implementation of dynamic section rendering
@MainActor
public struct DynamicFormSectionView: View {
    let section: DynamicFormSection
    @ObservedObject var formState: DynamicFormState

    public init(section: DynamicFormSection, formState: DynamicFormState) {
        self.section = section
        self.formState = formState
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Section title
            Text(section.title)
                .font(.title3)
                .bold()
                .automaticAccessibilityIdentifiers(named: "SectionTitle")

            // Section description if present
            if let description = section.description {
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .automaticAccessibilityIdentifiers(named: "SectionDescription")
            }

            // Render each field in the section
            ForEach(section.fields) { field in
                DynamicFormFieldView(field: field, formState: formState)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
        .environment(\.accessibilityIdentifierLabel, section.title) // TDD GREEN: Pass label to identifier generation
        .automaticAccessibilityIdentifiers(named: "DynamicFormSectionView")
    }
}

// MARK: - Dynamic Form Field View

/// Field view for dynamic forms
/// GREEN PHASE: Full implementation of dynamic field rendering
@MainActor
public struct DynamicFormFieldView: View {
    let field: DynamicFormField
    @ObservedObject var formState: DynamicFormState
    
    public init(field: DynamicFormField, formState: DynamicFormState) {
        self.field = field
        self.formState = formState
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Field label
            Text(field.label)
                .font(.subheadline)
                .bold()
                .automaticAccessibilityIdentifiers(named: "FieldLabel")

            // Field description if present
            if let description = field.description {
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .automaticAccessibilityIdentifiers(named: "FieldDescription")
            }

            // Field input based on type
            fieldInputView()

            // Validation errors
            if let errors = formState.fieldErrors[field.id], !errors.isEmpty {
                ForEach(errors, id: \.self) { error in
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                        .environment(\.accessibilityIdentifierLabel, error) // TDD GREEN: Pass error text to identifier generation
                        .automaticAccessibilityIdentifiers(named: "FieldError")
                }
            }
        }
        .environment(\.accessibilityIdentifierLabel, field.label) // TDD GREEN: Pass label to identifier generation
        .automaticAccessibilityIdentifiers(named: "DynamicFormFieldView")
    }

    @ViewBuilder
    private func fieldInputView() -> some View {
        switch field.contentType {
        case .text:
            TextField(field.placeholder ?? "Enter text", text: Binding(
                get: { formState.fieldValues[field.id] as? String ?? "" },
                set: { formState.setValue($0, for: field.id) }
            ))
            .textFieldStyle(.roundedBorder)
            .automaticAccessibilityIdentifiers(named: "TextField")

        case .number, .integer:
            TextField(field.placeholder ?? "Enter number", text: Binding(
                get: { formState.fieldValues[field.id] as? String ?? "" },
                set: { formState.setValue($0, for: field.id) }
            ))
            .textFieldStyle(.roundedBorder)
            .automaticAccessibilityIdentifiers(named: "NumberField")

        case .email:
            TextField(field.placeholder ?? "Enter email", text: Binding(
                get: { formState.fieldValues[field.id] as? String ?? "" },
                set: { formState.setValue($0, for: field.id) }
            ))
            .textFieldStyle(.roundedBorder)
            .automaticAccessibilityIdentifiers(named: "EmailField")

        case .date, .time, .datetime:
            DatePicker(
                field.placeholder ?? "Select date/time",
                selection: Binding(
                    get: { (formState.fieldValues[field.id] as? Date) ?? Date() },
                    set: { formState.setValue($0, for: field.id) }
                ),
                displayedComponents: field.contentType == .date ? .date : field.contentType == .time ? .hourAndMinute : [.date, .hourAndMinute]
            )
            .automaticAccessibilityIdentifiers(named: "DateTimePicker")

        case .toggle:
            Toggle(field.label, isOn: Binding(
                get: { (formState.fieldValues[field.id] as? Bool) ?? false },
                set: { formState.setValue($0, for: field.id) }
            ))
            .automaticAccessibilityIdentifiers(named: "Toggle")

        case .checkbox:
            Toggle(field.label, isOn: Binding(
                get: { (formState.fieldValues[field.id] as? Bool) ?? false },
                set: { formState.setValue($0, for: field.id) }
            ))
            .automaticAccessibilityIdentifiers(named: "Checkbox")

        case .select:
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
                .automaticAccessibilityIdentifiers(named: "SelectField")
            } else {
                Text("No options available")
                    .foregroundColor(.red)
            }

        case .radio:
            if let options = field.options {
                Picker(field.label, selection: Binding(
                    get: { formState.fieldValues[field.id] as? String ?? "" },
                    set: { formState.setValue($0, for: field.id) }
                )) {
                    ForEach(options, id: \.self) { option in
                        Text(option).tag(option)
                    }
                }
                .pickerStyle(.radioGroup)
                .automaticAccessibilityIdentifiers(named: "RadioGroup")
            } else {
                Text("No options available")
                    .foregroundColor(.red)
            }

        case .textarea:
            #if os(iOS)
            TextEditor(text: Binding(
                get: { formState.fieldValues[field.id] as? String ?? "" },
                set: { formState.setValue($0, for: field.id) }
            ))
            .frame(minHeight: 100)
            .border(Color.gray.opacity(0.2))
            .automaticAccessibilityIdentifiers(named: "TextArea")
            #else
            TextField(field.placeholder ?? "Enter text", text: Binding(
                get: { formState.fieldValues[field.id] as? String ?? "" },
                set: { formState.setValue($0, for: field.id) }
            ))
            .textFieldStyle(.roundedBorder)
            .automaticAccessibilityIdentifiers(named: "TextArea")
            #endif

        case .custom:
            // Use custom field registry if available
            if let customComponent = CustomFieldRegistry.shared.createComponent(for: field, formState: formState) {
                AnyView(customComponent)
            } else {
                Text("Custom field not registered: \(field.contentType?.rawValue ?? "unknown")")
                    .foregroundColor(.red)
                    .automaticAccessibilityIdentifiers(named: "CustomFieldError")
            }

        default:
            Text("Unsupported field type: \(field.contentType?.rawValue ?? "nil")")
                .foregroundColor(.red)
                .automaticAccessibilityIdentifiers(named: "UnsupportedField")
        }
    }
}

// MARK: - Form Wizard View

/// Wizard-style form view
/// GREEN PHASE: Full implementation of multi-step wizard interface
@MainActor
public struct FormWizardView<Content: View, Navigation: View>: View {
    let steps: [FormWizardStep]
    let content: (FormWizardStep, FormWizardState) -> Content
    let navigation: (FormWizardState, @escaping () -> Void, @escaping () -> Void, @escaping () -> Void) -> Navigation
    
    @StateObject private var wizardState: FormWizardState
    
    public init(
        steps: [FormWizardStep],
        @ViewBuilder content: @escaping (FormWizardStep, FormWizardState) -> Content,
        @ViewBuilder navigation: @escaping (FormWizardState, @escaping () -> Void, @escaping () -> Void, @escaping () -> Void) -> Navigation
    ) {
        self.steps = steps
        self.content = content
        self.navigation = navigation
        _wizardState = StateObject(wrappedValue: FormWizardState())
    }
    
    public var body: some View {
        VStack(spacing: 20) {
            // Step progress indicator
            if steps.count > 1 {
                HStack {
                    ForEach(Array(steps.enumerated()), id: \.element.id) { index, step in
                        Circle()
                            .fill(index <= wizardState.currentStepIndex ? Color.blue : Color.gray.opacity(0.3))
                            .frame(width: 12, height: 12)
                        
                        if index < steps.count - 1 {
                            Rectangle()
                                .fill(index < wizardState.currentStepIndex ? Color.blue : Color.gray.opacity(0.3))
                                .frame(height: 2)
                        }
                    }
                }
                .padding()
                .automaticAccessibilityIdentifiers(named: "StepProgress")
            }
            
            // Current step content
            if wizardState.currentStepIndex < steps.count {
                let currentStep = steps[wizardState.currentStepIndex]
                content(currentStep, wizardState)
                    .automaticAccessibilityIdentifiers(named: "StepContent")
            }
            
            Spacer()
            
            // Navigation controls
            navigation(
                wizardState,
                { _ = wizardState.nextStep() },
                { _ = wizardState.previousStep() },
                { /* Finish action - can be handled by parent */ }
            )
            .automaticAccessibilityIdentifiers(named: "NavigationControls")
        }
        .padding()
        .onAppear {
            wizardState.setSteps(steps)
        }
        .automaticAccessibilityIdentifiers(named: "FormWizardView")
    }
}

// MARK: - Supporting Types (TDD Red Phase Stubs)
// Note: FormWizardStep and FormWizardState are defined in FormWizardTypes.swift
