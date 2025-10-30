import SwiftUI

// MARK: - Error Severity Types

/// Defensive enum for error severity to prevent string-based anti-patterns
public enum ErrorSeverity: String, CaseIterable {
    case info = "info"
    case warning = "warning"
    case error = "error"
    
    var displayName: String {
        return self.rawValue
    }
    
    var iconName: String {
        switch self {
        case .info: return "info.circle"
        case .warning: return "exclamationmark.triangle"
        case .error: return "xmark.circle"
        }
    }
    
    var color: Color {
        switch self {
        case .info: return .blue
        case .warning: return .orange
        case .error: return .red
        }
    }
}

// MARK: - Ordering Helpers

extension IntelligentFormView {
    /// Optional provider for external order rules (e.g., EnhancedHints/registry)
    public static var orderRulesProvider: ((DataAnalysisResult) -> FieldOrderRules?)?
    
    /// Default priority-based ordering: prefer common primary fields like "title" or "name" first.
    /// Falls back to stable name ordering; avoids alphabetic-by-type grouping.
    internal static func orderFieldsByPriority(_ fields: [DataField]) -> [DataField] {
        // If external rules exist, resolve first
        if let analysis = _currentAnalysisContext, let rules = orderRulesProvider?(analysis) {
            let names = fields.map { $0.name }
            let trait = activeTrait()
            let orderedNames = FieldOrderResolver.resolve(fields: names, rules: rules, activeTrait: trait)
            let byName = Dictionary(uniqueKeysWithValues: fields.map { ($0.name, $0) })
            return orderedNames.compactMap { byName[$0] } + names.filter { !orderedNames.contains($0) }.compactMap { byName[$0] }
        }
        
        return fields.sorted { lhs, rhs in
            let wl = defaultWeight(for: lhs.name)
            let wr = defaultWeight(for: rhs.name)
            if wl != wr { return wl > wr }
            return lhs.name < rhs.name
        }
    }
    
    private static func defaultWeight(for fieldName: String) -> Int {
        let n = fieldName.lowercased()
        if n == "title" { return 1_000 }
        if n == "name" { return 900 }
        if n.contains("title") { return 800 }
        if n.contains("summary") { return 700 }
        return 0
    }
    
    // MARK: - Trait/Context
    internal static func activeTrait() -> FieldTrait {
        // Simple heuristic: phones are compact, others regular
        switch SixLayerPlatform.deviceType {
        case .phone: return .compact
        default: return .regular
        }
    }
    
    // Store the latest analysis so the provider can use it without changing signatures widely
    @TaskLocal static var _currentAnalysisContext: DataAnalysisResult?
    
    // Wrap content generation to set the analysis context
    static func withAnalysisContext<T>(_ analysis: DataAnalysisResult, build: () -> T) -> T {
        return Self.$_currentAnalysisContext.withValue(analysis) { build() }
    }
}

// MARK: - Intelligent Form View

/// Intelligent form generation using our 6-layer platform architecture
/// This view analyzes data models and generates appropriate forms using platform extensions
@MainActor
public struct IntelligentFormView {
    
    // MARK: - Public API
    
    /// Generate a form for creating new data with data binding integration
    public static func generateForm<T>(
        for dataType: T.Type,
        initialData: T? = nil,
        dataBinder: DataBinder<T>? = nil,
        inputHandlingManager: InputHandlingManager? = nil,
        @ViewBuilder customFieldView: @escaping (String, Any, FieldType) -> some View = { _, _, _ in EmptyView() },
        onSubmit: @escaping (T) -> Void = { _ in },
        onCancel: @escaping () -> Void = { }
    ) -> some View {
        // For now, require an initial instance for analysis
        // In a future version, we could implement type introspection
        guard let initialData = initialData else {
            // fatalError("IntelligentFormView.generateForm requires an initial instance for analysis. Please provide initialData.")
            return AnyView(EmptyView())
        }
        let analysis = DataIntrospectionEngine.analyze(initialData)
        let formStrategy = determineFormStrategy(analysis: analysis)
        
        return AnyView(withAnalysisContext(analysis) {
            Group {
            switch formStrategy.containerType {
            case .form:
                platformFormContainer_L4(
                    strategy: formStrategy,
                    content: {
                        generateFormContent(
                            analysis: analysis,
                            initialData: initialData,
                            dataBinder: dataBinder,
                            inputHandlingManager: inputHandlingManager,
                            customFieldView: customFieldView,
                            formStrategy: formStrategy
                        )
                    }
                )
                .overlay(
                    generateFormActions(
                        initialData: initialData,
                        onSubmit: onSubmit,
                        onCancel: onCancel
                    )
                )
                
            case .standard, .scrollView, .custom, .adaptive:
                platformFormContainer_L4(
                    strategy: formStrategy,
                    content: {
                        generateFormContent(
                            analysis: analysis,
                            initialData: initialData,
                            dataBinder: dataBinder,
                            inputHandlingManager: inputHandlingManager,
                            customFieldView: customFieldView,
                            formStrategy: formStrategy
                        )
                    }
                )
                .overlay(
                    generateFormActions(
                        initialData: initialData,
                        onSubmit: onSubmit,
                        onCancel: onCancel
                    )
                )
            }
            }
            .automaticAccessibilityIdentifiers()
        })
    }
    
    /// Generate a form for updating existing data with data binding integration
    public static func generateForm<T>(
        for data: T,
        dataBinder: DataBinder<T>? = nil,
        inputHandlingManager: InputHandlingManager? = nil,
        @ViewBuilder customFieldView: @escaping (String, Any, FieldType) -> some View = { _, _, _ in EmptyView() },
        onUpdate: @escaping (T) -> Void = { _ in },
        onCancel: @escaping () -> Void = { }
    ) -> some View {
        let analysis = DataIntrospectionEngine.analyze(data)
        let formStrategy = determineFormStrategy(analysis: analysis)
        
        return withAnalysisContext(analysis) {
            platformFormContainer_L4(
            strategy: formStrategy,
            content: {
                generateFormContent(
                    analysis: analysis,
                    initialData: data,
                    dataBinder: dataBinder,
                    inputHandlingManager: inputHandlingManager,
                    customFieldView: customFieldView,
                    formStrategy: formStrategy
                )
            }
            )
            .overlay(
                generateFormActions(
                    initialData: data,
                    onSubmit: { onUpdate($0) },
                    onCancel: onCancel
                )
            )
        }
    }
    
    // MARK: - Private Implementation
    
    /// Determine the best form strategy based on data analysis
    private static func determineFormStrategy(
        analysis: DataAnalysisResult
    ) -> FormStrategy {
        let containerType: FormContainerType
        let fieldLayout: FieldLayout
        let validation: ValidationStrategy
        
        // Analyze data characteristics to determine optimal strategy
        switch (analysis.complexity, analysis.fields.count) {
        case (.simple, 0...3):
            containerType = .form
            fieldLayout = .vertical
            validation = .immediate
        case (.simple, 4...7):
            containerType = .standard
            fieldLayout = .vertical
            validation = .deferred
        case (.moderate, _):
            containerType = .standard
            fieldLayout = .adaptive
            validation = .deferred
        case (.complex, _):
            containerType = .scrollView
            fieldLayout = .adaptive
            validation = .deferred
        case (.veryComplex, _):
            containerType = .custom
            fieldLayout = .adaptive
            validation = .deferred
        default:
            containerType = .adaptive
            fieldLayout = .adaptive
            validation = .deferred
        }
        
        return FormStrategy(
            containerType: containerType,
            fieldLayout: fieldLayout,
            validation: validation
        )
    }
    
    /// Generate the main form content using our platform extensions
    private static func generateFormContent<T>(
        analysis: DataAnalysisResult,
        initialData: T?,
        dataBinder: DataBinder<T>?,
        inputHandlingManager: InputHandlingManager?,
        customFieldView: @escaping (String, Any, FieldType) -> some View,
        formStrategy: FormStrategy
    ) -> some View {
        Group {
            switch formStrategy.fieldLayout {
            case .vertical:
                generateVerticalLayout(
                    analysis: analysis,
                    initialData: initialData,
                    dataBinder: dataBinder,
                    inputHandlingManager: inputHandlingManager,
                    customFieldView: customFieldView
                )
                
            case .horizontal:
                generateHorizontalLayout(
                    analysis: analysis,
                    initialData: initialData,
                    dataBinder: dataBinder,
                    inputHandlingManager: inputHandlingManager,
                    customFieldView: customFieldView
                )
                
            case .grid:
                generateGridLayout(
                    analysis: analysis,
                    initialData: initialData,
                    dataBinder: dataBinder,
                    inputHandlingManager: inputHandlingManager,
                    customFieldView: customFieldView
                )
                
            case .adaptive:
                generateAdaptiveLayout(
                    analysis: analysis,
                    initialData: initialData,
                    dataBinder: dataBinder,
                    inputHandlingManager: inputHandlingManager,
                    customFieldView: customFieldView,
                    formStrategy: formStrategy
                )
                
            case .compact, .standard, .spacious:
                generateVerticalLayout(
                    analysis: analysis,
                    initialData: initialData,
                    dataBinder: dataBinder,
                    inputHandlingManager: inputHandlingManager,
                    customFieldView: customFieldView
                )
            }
        }
    }
    
    /// Generate vertical field layout with intelligent grouping
    private static func generateVerticalLayout<T>(
        analysis: DataAnalysisResult,
        initialData: T?,
        dataBinder: DataBinder<T>?,
        inputHandlingManager: InputHandlingManager?,
        customFieldView: @escaping (String, Any, FieldType) -> some View
    ) -> some View {
        VStack(spacing: 16) {
            // Prefer explicit important fields first (e.g., title/name), avoid alphabetic-by-type
            let orderedFields = orderFieldsByPriority(analysis.fields)
            ForEach(orderedFields, id: \.name) { field in
                generateFieldView(
                    field: field,
                    initialData: initialData,
                    dataBinder: dataBinder,
                    inputHandlingManager: inputHandlingManager,
                    customFieldView: customFieldView
                )
            }
        }
    }
    
    /// Generate horizontal field layout (side-by-side fields)
    private static func generateHorizontalLayout<T>(
        analysis: DataAnalysisResult,
        initialData: T?,
        dataBinder: DataBinder<T>?,
        inputHandlingManager: InputHandlingManager?,
        customFieldView: @escaping (String, Any, FieldType) -> some View
    ) -> some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 16) {
            let orderedFields = orderFieldsByPriority(analysis.fields)
            ForEach(orderedFields, id: \.name) { field in
                generateFieldView(
                    field: field,
                    initialData: initialData,
                    dataBinder: dataBinder,
                    inputHandlingManager: inputHandlingManager,
                    customFieldView: customFieldView
                )
            }
        }
    }
    
    /// Generate grid field layout
    private static func generateGridLayout<T>(
        analysis: DataAnalysisResult,
        initialData: T?,
        dataBinder: DataBinder<T>?,
        inputHandlingManager: InputHandlingManager?,
        customFieldView: @escaping (String, Any, FieldType) -> some View
    ) -> some View {
        let columns = min(3, max(1, Int(sqrt(Double(analysis.fields.count)))))
        
        return LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: columns), spacing: 16) {
            let orderedFields = orderFieldsByPriority(analysis.fields)
            ForEach(orderedFields, id: \.name) { field in
                generateFieldView(
                    field: field,
                    initialData: initialData,
                    dataBinder: dataBinder,
                    inputHandlingManager: inputHandlingManager,
                    customFieldView: customFieldView
                )
            }
        }
    }
    
    /// Generate adaptive field layout based on content
    private static func generateAdaptiveLayout<T>(
        analysis: DataAnalysisResult,
        initialData: T?,
        dataBinder: DataBinder<T>?,
        inputHandlingManager: InputHandlingManager?,
        customFieldView: @escaping (String, Any, FieldType) -> some View,
        formStrategy: FormStrategy
    ) -> some View {
        if analysis.fields.count <= 4 {
            AnyView(generateVerticalLayout(
                analysis: analysis,
                initialData: initialData,
                dataBinder: dataBinder,
                inputHandlingManager: inputHandlingManager,
                customFieldView: customFieldView
            ))
        } else if analysis.fields.count <= 8 {
            AnyView(generateHorizontalLayout(
                analysis: analysis,
                initialData: initialData,
                dataBinder: dataBinder,
                inputHandlingManager: inputHandlingManager,
                customFieldView: customFieldView
            ))
        } else {
            AnyView(generateGridLayout(
                analysis: analysis,
                initialData: initialData,
                dataBinder: dataBinder,
                inputHandlingManager: inputHandlingManager,
                customFieldView: customFieldView
            ))
        }
    }
    
    /// Group fields by type for better organization
    private static func groupFieldsByType(_ fields: [DataField]) -> [FieldType: [DataField]] {
        var grouped: [FieldType: [DataField]] = [:]
        
        for field in fields {
            if grouped[field.type] == nil {
                grouped[field.type] = []
            }
            grouped[field.type]?.append(field)
        }
        
        return grouped
    }
    
    /// Get human-readable title for field type
    private static func getFieldTypeTitle(_ fieldType: FieldType) -> String {
        switch fieldType {
        case .string: return "Text Fields"
        case .number: return "Numeric Fields"
        case .boolean: return "Toggle Fields"
        case .date: return "Date Fields"
        case .url: return "URL Fields"
        case .uuid: return "Identifier Fields"
        case .image: return "Media Fields"
        case .document: return "Document Fields"
        case .relationship: return "Relationship Fields"
        case .hierarchical: return "Hierarchical Fields"
        case .custom: return "Custom Fields"
        }
    }
    
    /// Generate individual field view using our platform extensions
    private static func generateFieldView<T>(
        field: DataField,
        initialData: T?,
        dataBinder: DataBinder<T>?,
        inputHandlingManager: InputHandlingManager?,
        customFieldView: @escaping (String, Any, FieldType) -> some View
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            // Field label using platform colors
            Text(field.name.capitalized)
                .font(.body)
                .fontWeight(.medium)
                .foregroundColor(Color.platformLabel)
            
            // Field input
            // Use custom field view
            customFieldView(field.name, initialData != nil ? extractFieldValue(from: initialData!, fieldName: field.name) : getDefaultValue(for: field), field.type)
            
            // Field description if available
            if let description = getFieldDescription(for: field) {
                Text(description)
                    .font(.caption)
                    .foregroundColor(Color.platformSecondaryLabel)
            }
        }
        .padding(.vertical, 4)
    }
    
    /// Generate form action buttons using our platform extensions
    private static func generateFormActions<T>(
        initialData: T?,
        onSubmit: @escaping (T) -> Void,
        onCancel: @escaping () -> Void
    ) -> some View {
        VStack {
            Spacer()
            HStack(spacing: 12) {
                Button("Cancel") { onCancel() }
                    .buttonStyle(.bordered)
                    .foregroundColor(Color.platformLabel)

                Spacer()

                Button(initialData != nil ? "Update" : "Create") {
                    // For now, only submit when initial data is available; otherwise no-op
                    if let data = initialData {
                        onSubmit(data)
                    } else {
                        print("Warning: Submit attempted without initialData; ignoring")
                    }
                }
                    .buttonStyle(.borderedProminent)
                    .foregroundColor(Color.platformBackground)
            }
            .padding()
            .background(Color.platformSecondaryBackground)
            .cornerRadius(8)
        }
    }
    
    // MARK: - Helper Functions
    
    /// Extract field value from an object using reflection
    private static func extractFieldValue(from object: Any, fieldName: String) -> Any {
        let mirror = Mirror(reflecting: object)
        
        for child in mirror.children {
            if child.label == fieldName {
                return child.value
            }
        }
        
        return "N/A"
    }
    
    /// Get default value for a field
    private static func getDefaultValue(for field: DataField) -> Any {
        switch field.type {
        case .string:
            return ""
        case .number:
            return 0
        case .boolean:
            return false
        case .date:
            return Date()
        case .url:
            return URL(string: "https://example.com") ?? URL(string: "https://example.com")!
        case .uuid:
            return UUID()
        case .image, .document:
            return ""
        case .relationship, .hierarchical, .custom:
            return ""
        }
    }
    
    /// Get field description based on field characteristics
    private static func getFieldDescription(for field: DataField) -> String? {
        var descriptions: [String] = []
        
        if field.isOptional {
            descriptions.append("Optional")
        }
        
        if field.isArray {
            descriptions.append("Multiple values")
        }
        
        if field.hasDefaultValue {
            descriptions.append("Has default")
        }
        
        return descriptions.isEmpty ? nil : descriptions.joined(separator: " • ")
    }
}

// MARK: - Default Platform Field View

/// Default platform field view using our cross-platform system
@MainActor
private struct DefaultPlatformFieldView: View {
    
    let field: DataField
    let value: Any
    let onValueChange: (Any) -> Void
    
    // Computed property to get field errors
    private var fieldErrors: [String] {
        [] // No validation errors without FormStateManager
    }
    
    // Computed property to check if field is valid
    private var isValid: Bool {
        true // Always valid without FormStateManager
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            // Main field input
            fieldInputView
            
            // Error display
            if !fieldErrors.isEmpty {
                errorDisplayView
            }
        }
        .automaticAccessibilityIdentifiers()
    }
    
    @ViewBuilder
    private var fieldInputView: some View {
        switch field.type {
        case .string:
            TextField("Enter \(field.name)", text: Binding(
                get: { value as? String ?? "" },
                set: { onValueChange($0) }
            ))
            .textFieldStyle(.roundedBorder)
            .background(isValid ? Color.platformSecondaryBackground : Color.red.opacity(0.1))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isValid ? Color.clear : Color.red, lineWidth: 1)
            )

        case .number:
            HStack {
                TextField("Enter \(field.name)", value: Binding(
                    get: { value as? Double ?? 0.0 },
                    set: { onValueChange($0) }
                ), format: .number)
                .textFieldStyle(.roundedBorder)
                #if os(iOS)
                .keyboardType(.decimalPad)
                #endif
                .background(isValid ? Color.platformSecondaryBackground : Color.red.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isValid ? Color.clear : Color.red, lineWidth: 1)
                )

                Stepper("", value: Binding(
                    get: { value as? Double ?? 0.0 },
                    set: { onValueChange($0) }
                ), in: 0...1000)
            }

        case .boolean:
            Toggle(field.name.capitalized, isOn: Binding(
                get: { value as? Bool ?? false },
                set: { onValueChange($0) }
            ))

        case .date:
            DatePicker(
                field.name.capitalized,
                selection: Binding(
                    get: { value as? Date ?? Date() },
                    set: { onValueChange($0) }
                ),
                displayedComponents: [.date]
            )

        case .url:
            TextField("Enter URL", text: Binding(
                get: { value as? String ?? "" },
                set: { onValueChange($0) }
            ))
            .textFieldStyle(.roundedBorder)
            #if os(iOS)
            .keyboardType(.URL)
            .autocapitalization(.none)
            #endif
            .background(isValid ? Color.platformSecondaryBackground : Color.red.opacity(0.1))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isValid ? Color.clear : Color.red, lineWidth: 1)
            )

        case .uuid:
            TextField("Enter UUID", text: Binding(
                get: { value as? String ?? "" },
                set: { onValueChange($0) }
            ))
            .textFieldStyle(.roundedBorder)
            #if os(iOS)
            .autocapitalization(.none)
            #endif
            .background(isValid ? Color.platformSecondaryBackground : Color.red.opacity(0.1))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isValid ? Color.clear : Color.red, lineWidth: 1)
            )

        case .image, .document:
            Button("Select \(field.type.rawValue)") {
                // File picker implementation would go here
                onValueChange("")
            }
            .buttonStyle(.bordered)

        case .relationship, .hierarchical, .custom:
            TextField("Enter \(field.name)", text: Binding(
                get: { value as? String ?? "" },
                set: { onValueChange($0) }
            ))
            .textFieldStyle(.roundedBorder)
            .background(isValid ? Color.platformSecondaryBackground : Color.red.opacity(0.1))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isValid ? Color.clear : Color.red, lineWidth: 1)
            )
        }
    }
    
    @ViewBuilder
    private var errorDisplayView: some View {
        VStack(alignment: .leading, spacing: 2) {
            ForEach(Array(fieldErrors.enumerated()), id: \.offset) { index, error in
                HStack(alignment: .top, spacing: 4) {
                    Image(systemName: errorIcon(for: "error"))
                        .foregroundColor(errorColor(for: "error"))
                        .font(.caption)
                    
                    Text(error)
                        .font(.caption)
                        .foregroundColor(errorColor(for: "error"))
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .padding(.horizontal, 4)
    }
    
    private func errorIcon(for severity: String) -> String {
        guard let errorSeverity = ErrorSeverity(rawValue: severity) else {
            // Unknown severity - log for debugging but don't crash
            print("Warning: Unknown error severity '\(severity)', defaulting to info")
            return ErrorSeverity.info.iconName
        }
        return errorSeverity.iconName
    }
    
    private func errorColor(for severity: String) -> Color {
        guard let errorSeverity = ErrorSeverity(rawValue: severity) else {
            // Unknown severity - log for debugging but don't crash
            print("Warning: Unknown error severity '\(severity)', defaulting to info")
            return ErrorSeverity.info.color
        }
        return errorSeverity.color
    }
}

// MARK: - Convenience Extensions

public extension View {
    
    /// Apply intelligent form generation
    internal func platformIntelligentForm<T>(
        for dataType: T.Type,
        initialData: T? = nil,
        dataBinder: DataBinder<T>? = nil,
        inputHandlingManager: InputHandlingManager? = nil,
        @ViewBuilder customFieldView: @escaping (String, Any, FieldType) -> some View = { _, _, _ in EmptyView() },
        onSubmit: @escaping (T) -> Void = { _ in },
        onCancel: @escaping () -> Void = { }
    ) -> some View {
        IntelligentFormView.generateForm(
            for: dataType,
            initialData: initialData,
            dataBinder: dataBinder,
            inputHandlingManager: inputHandlingManager,
            customFieldView: customFieldView,
            onSubmit: onSubmit,
            onCancel: onCancel
        )
    }
    
    /// Apply intelligent form generation for existing data
    internal func platformIntelligentForm<T>(
        for data: T,
        dataBinder: DataBinder<T>? = nil,
        inputHandlingManager: InputHandlingManager? = nil,
        @ViewBuilder customFieldView: @escaping (String, Any, FieldType) -> some View = { _, _, _ in EmptyView() },
        onUpdate: @escaping (T) -> Void = { _ in },
        onCancel: @escaping () -> Void = { }
    ) -> some View {
        IntelligentFormView.generateForm(
            for: data,
            dataBinder: dataBinder,
            inputHandlingManager: inputHandlingManager,
            customFieldView: customFieldView,
            onUpdate: onUpdate,
            onCancel: onCancel
        )
    }
}
