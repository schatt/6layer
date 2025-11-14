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
                .automaticCompliance(named: "FormTitle")

            // Form description if present
            if let description = configuration.description {
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .automaticCompliance(named: "FormDescription")
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
                .automaticCompliance(named: "BatchOCRButton")
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
            .automaticCompliance(named: "SubmitButton")
        }
        .padding()
        .environment(\.accessibilityIdentifierLabel, configuration.title) // TDD GREEN: Pass label to identifier generation
        .automaticCompliance(named: "DynamicFormView")
    }
}

// MARK: - Dynamic Form Section View

/// Section view for dynamic forms
/// REFACTOR: Now uses layoutStyle from section to apply proper field layout
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
                .automaticCompliance(named: "SectionTitle")

            // Section description if present
            if let description = section.description {
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .automaticCompliance(named: "SectionDescription")
            }

            // Render fields using section's layoutStyle (hint, not commandment - framework adapts)
            fieldLayoutView
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
        .environment(\.accessibilityIdentifierLabel, section.title)
        .automaticCompliance(named: "DynamicFormSectionView")
    }
    
    // MARK: - DRY: Field Layout Helper
    
    @ViewBuilder
    private var fieldLayoutView: some View {
        let layoutStyle = section.layoutStyle ?? .vertical // Default to vertical
        
        switch layoutStyle {
        case .vertical, .standard, .compact, .spacious:
            // Vertical stack (default)
            VStack(spacing: 16) {
                ForEach(section.fields) { field in
                    DynamicFormFieldView(field: field, formState: formState)
                }
            }
            
        case .horizontal:
            // Horizontal layout (2 columns)
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                ForEach(section.fields) { field in
                    DynamicFormFieldView(field: field, formState: formState)
                }
            }
            
        case .grid:
            // Grid layout (adaptive columns)
            let columns = min(3, max(1, Int(sqrt(Double(section.fields.count)))))
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: columns), spacing: 16) {
                ForEach(section.fields) { field in
                    DynamicFormFieldView(field: field, formState: formState)
                }
            }
            
        case .adaptive:
            // Adaptive: choose layout based on field count
            if section.fields.count <= 4 {
                VStack(spacing: 16) {
                    ForEach(section.fields) { field in
                        DynamicFormFieldView(field: field, formState: formState)
                    }
                }
            } else if section.fields.count <= 8 {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 16) {
                    ForEach(section.fields) { field in
                        DynamicFormFieldView(field: field, formState: formState)
                    }
                }
            } else {
                let columns = min(3, max(1, Int(sqrt(Double(section.fields.count)))))
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: columns), spacing: 16) {
                    ForEach(section.fields) { field in
                        DynamicFormFieldView(field: field, formState: formState)
                    }
                }
            }
        }
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
                .automaticCompliance(named: "FieldLabel")

            // Field description if present
            if let description = field.description {
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .automaticCompliance(named: "FieldDescription")
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
                        .automaticCompliance(named: "FieldError")
                }
            }
        }
        .environment(\.accessibilityIdentifierLabel, field.label) // TDD GREEN: Pass label to identifier generation
        .automaticCompliance(named: "DynamicFormFieldView")
    }

    @ViewBuilder
    private func fieldInputView() -> some View {
        // DRY: Use CustomFieldView to render all field types consistently
        // This ensures all field types (multiselect, richtext, file, image, array, data, autocomplete, enum, color, etc.)
        // are properly supported through the individual field components we implemented
        CustomFieldView(field: field, formState: formState)
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
                .automaticCompliance(named: "StepProgress")
            }
            
            // Current step content
            if wizardState.currentStepIndex < steps.count {
                let currentStep = steps[wizardState.currentStepIndex]
                content(currentStep, wizardState)
                    .automaticCompliance(named: "StepContent")
            }
            
            Spacer()
            
            // Navigation controls
            navigation(
                wizardState,
                { _ = wizardState.nextStep() },
                { _ = wizardState.previousStep() },
                { /* Finish action - can be handled by parent */ }
            )
            .automaticCompliance(named: "NavigationControls")
        }
        .padding()
        .onAppear {
            wizardState.setSteps(steps)
        }
        .automaticCompliance(named: "FormWizardView")
    }
}

// MARK: - Supporting Types (TDD Red Phase Stubs)
// Note: FormWizardStep and FormWizardState are defined in FormWizardTypes.swift
