import SwiftUI
#if canImport(CoreData)
import CoreData
#endif
#if canImport(SwiftData)
import SwiftData
#endif

// MARK: - Dynamic Form View

/// Main dynamic form view component
/// GREEN PHASE: Full implementation of dynamic form rendering
/// 
/// **Entity Creation (New Object Creation)**:
/// If `modelName` is provided and hints are fully declarative, the form can automatically
/// create entities (Core Data or SwiftData) from collected form values on submit.
/// 
/// **How it works:**
/// 1. Form collects values as user types (existing behavior)
/// 2. On submit: If `modelName` is provided, creates entity from form values
/// 3. Calls `onEntityCreated` with the created entity (if provided)
/// 4. Always calls `onSubmit` with dictionary of values (backward compatible)
///
/// **Requirements:**
/// - **Core Data**: Works automatically when `modelName` is provided. Entity is created using
///   `NSEntityDescription.insertNewObject` and values are set via KVC.
/// - **SwiftData**: Requires `entityType` parameter to be provided for entity creation.
///   If not provided, only dictionary is returned (backward compatible).
@MainActor
public struct DynamicFormView: View {
    let configuration: DynamicFormConfiguration
    let onSubmit: ([String: Any]) -> Void
    let onEntityCreated: ((Any) -> Void)?
    let onError: ((Error) -> Void)?
    let entityType: Any.Type?
    @StateObject private var formState: DynamicFormState
    
    // Environment contexts
    #if canImport(CoreData)
    @Environment(\.managedObjectContext) private var managedObjectContext
    #endif
    
    #if canImport(SwiftData)
    @Environment(\.modelContext) private var modelContext
    #endif

    /// Initialize DynamicFormView
    /// - Parameters:
    ///   - configuration: Form configuration with fields and optional modelName
    ///   - onSubmit: Callback with dictionary of form values (always called)
    ///   - onEntityCreated: Optional callback with created entity (called if modelName provided and entity created)
    ///   - onError: Optional callback for errors (called if entity creation or save fails)
    ///   - entityType: Optional SwiftData entity type (required for SwiftData entity creation)
    public init(
        configuration: DynamicFormConfiguration,
        onSubmit: @escaping ([String: Any]) -> Void,
        onEntityCreated: ((Any) -> Void)? = nil,
        onError: ((Error) -> Void)? = nil,
        entityType: Any.Type? = nil
    ) {
        self.onSubmit = onSubmit
        self.onEntityCreated = onEntityCreated
        self.onError = onError
        self.entityType = entityType
        
        // Auto-load hints if modelName provided (Issue #71)
        let effectiveConfiguration = configuration.applyingHints()
        
        // Store effective configuration (with hints applied if applicable)
        self.configuration = effectiveConfiguration
        _formState = StateObject(wrappedValue: DynamicFormState(configuration: effectiveConfiguration))
    }

    public var body: some View {
        ScrollViewReader { proxy in
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

                // Validation summary - shows all errors at once
                if formState.hasValidationErrors {
                    FormValidationSummary(
                        formState: formState,
                        configuration: configuration,
                        onErrorTap: { fieldId in
                            // Scroll to the field with animation
                            withAnimation {
                                proxy.scrollTo(fieldId, anchor: .center)
                            }
                        }
                    )
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
                    handleSubmit()
                }) {
                    Text(configuration.submitButtonText)
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
    
    /// Handle form submission: validate, create entity if modelName provided, then call callbacks
    private func handleSubmit() {
        // Always call onSubmit with dictionary (backward compatible)
        onSubmit(formState.fieldValues)
        
        // If modelName is provided, try to create entity
        guard let modelName = configuration.modelName else { return }
        
        // Validate form before entity creation
        if !formState.isValid {
            let validationError = NSError(
                domain: "DynamicFormView",
                code: 1,
                userInfo: [
                    NSLocalizedDescriptionKey: "Form validation failed. Please fix errors before submitting.",
                    "fieldErrors": formState.fieldErrors
                ]
            )
            onError?(validationError)
            return
        }
        
        // Try to create Core Data entity
        #if canImport(CoreData)
        do {
            let entity = try createCoreDataEntity(entityName: modelName, values: formState.fieldValues)
            onEntityCreated?(entity)
            return
        } catch {
            onError?(error)
            return
        }
        #endif
        
        // Try to create SwiftData entity (requires entityType)
        #if canImport(SwiftData)
        if #available(macOS 14.0, iOS 17.0, *) {
            if let entityType = entityType {
                do {
                    let entity = try createSwiftDataEntity(entityType: entityType, values: formState.fieldValues)
                    onEntityCreated?(entity)
                    return
                } catch {
                    onError?(error)
                    return
                }
            }
        }
        #endif
    }
    
    #if canImport(CoreData)
    /// Create Core Data entity from form values
    /// DRY: Uses shared EntityCreationUtilities
    /// - Throws: Error if entity creation or save fails
    private func createCoreDataEntity(entityName: String, values: [String: Any]) throws -> NSManagedObject {
        let context = managedObjectContext
        
        // Load hints to get type information (for filtering hidden fields)
        let hintsLoader = FileBasedDataHintsLoader()
        let hintsResult = hintsLoader.loadHintsResult(for: entityName)
        let fieldHints = hintsResult.fieldHints
        
        // Use shared utility (now throws on error)
        return try EntityCreationUtilities.createCoreDataEntity(
            entityName: entityName,
            values: values,
            context: context,
            fieldHints: fieldHints
        )
    }
    #endif
    
    #if canImport(SwiftData)
    /// Create SwiftData entity from form values using Codable
    /// DRY: Uses shared EntityCreationUtilities
    /// - Throws: Error if entity creation or save fails
    @available(macOS 14.0, iOS 17.0, *)
    private func createSwiftDataEntity(entityType: Any.Type, values: [String: Any]) throws -> Any {
        let context = modelContext
        
        // Load hints to get type information (for filtering hidden fields)
        let hintsLoader = FileBasedDataHintsLoader()
        let hintsResult = hintsLoader.loadHintsResult(for: configuration.modelName ?? "")
        let fieldHints = hintsResult.fieldHints
        
        // Use shared utility (now throws on error)
        return try EntityCreationUtilities.createSwiftDataEntity(
            entityType: entityType,
            values: values,
            context: context,
            fieldHints: fieldHints
        )
    }
    #endif
}

// MARK: - Dynamic Form Section View

/// Section view for dynamic forms
/// REFACTOR: Now uses layoutStyle from section to apply proper field layout
/// GREEN PHASE: Implements collapsible sections using DisclosureGroup
@MainActor
public struct DynamicFormSectionView: View {
    let section: DynamicFormSection
    @ObservedObject var formState: DynamicFormState

    public init(section: DynamicFormSection, formState: DynamicFormState) {
        self.section = section
        self.formState = formState
    }
    
    /// Binding to section collapsed state from formState
    private var isExpanded: Binding<Bool> {
        Binding(
            get: { !formState.isSectionCollapsed(section.id) },
            set: { newValue in
                if newValue != !formState.isSectionCollapsed(section.id) {
                    formState.toggleSection(section.id)
                }
            }
        )
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if section.isCollapsible {
                // Use DisclosureGroup for collapsible sections
                DisclosureGroup(isExpanded: isExpanded) {
                    // Section description if present (shown when expanded)
                    if let description = section.description {
                        Text(description)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .automaticCompliance(named: "SectionDescription")
                    }
                    
                    // Render fields using section's layoutStyle
                    fieldLayoutView
                } label: {
                    // Section title as disclosure label
                    Text(section.title)
                        .font(.title3)
                        .bold()
                        .automaticCompliance(named: "SectionTitle")
                }
                .accessibilityLabel("\(section.title), \(isExpanded.wrappedValue ? "expanded" : "collapsed") section")
                .accessibilityHint("Double tap to \(isExpanded.wrappedValue ? "collapse" : "expand") this section")
            } else {
                // Non-collapsible sections render normally
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
            // Field label with required indicator
            HStack {
                Text(field.label)
                    .font(.subheadline)
                    .bold()
                if field.isRequired {
                    Text("*")
                        .foregroundColor(.red)
                        .fontWeight(.bold)
                }
            }
            .automaticCompliance(named: "FieldLabel")
            .accessibilityLabel(field.isRequired ? "\(field.label), required" : field.label)

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
        .id(field.id) // Add ID for ScrollViewReader scrolling
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

// MARK: - Form Validation Summary

/// Validation summary view showing all form errors at once
/// Issue #78: Add form validation summary view showing all errors at once
@MainActor
public struct FormValidationSummary: View {
    @ObservedObject var formState: DynamicFormState
    let configuration: DynamicFormConfiguration
    @State private var isExpanded = true
    let onErrorTap: ((String) -> Void)?
    
    public init(
        formState: DynamicFormState,
        configuration: DynamicFormConfiguration,
        onErrorTap: ((String) -> Void)? = nil
    ) {
        self.formState = formState
        self.configuration = configuration
        self.onErrorTap = onErrorTap
    }
    
    public var body: some View {
        let allErrors = formState.allErrors(with: configuration)
        let errorCount = formState.errorCount
        
        if !allErrors.isEmpty {
            DisclosureGroup(isExpanded: $isExpanded) {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(Array(allErrors.enumerated()), id: \.offset) { index, error in
                        Button(action: {
                            onErrorTap?(error.fieldId)
                        }) {
                            HStack(alignment: .top, spacing: 8) {
                                Image(systemName: "exclamationmark.circle.fill")
                                    .foregroundColor(.red)
                                    .font(.caption)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(error.fieldLabel)
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(.primary)
                                    
                                    Text(error.message)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                            }
                            .padding(.vertical, 4)
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel("\(error.fieldLabel): \(error.message)")
                        .accessibilityHint("Tap to navigate to this field")
                    }
                }
                .padding(.top, 8)
            } label: {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                    
                    Text("\(errorCount) validation error\(errorCount == 1 ? "" : "s")")
                        .font(.headline)
                        .foregroundColor(.primary)
                }
            }
            .padding()
            .background(Color.red.opacity(0.1))
            .cornerRadius(8)
            .automaticCompliance(named: "FormValidationSummary")
            .accessibilityLabel("Validation summary: \(errorCount) error\(errorCount == 1 ? "" : "s")")
            .accessibilityHint("Expand to see all validation errors")
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
