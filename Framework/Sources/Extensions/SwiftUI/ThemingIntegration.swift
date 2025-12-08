import Foundation
import SwiftUI



// MARK: - Theming Integration
// Integration layer that applies theming to existing framework components

/// Themed wrapper for the SixLayer Framework
public struct ThemedFrameworkView<Content: View>: View {
    let content: Content
    @StateObject private var designSystem = VisualDesignSystem.shared
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    public var body: some View {
        content
            .environmentObject(designSystem)
            .environment(\.theme, designSystem.currentTheme)
            .environment(\.platformStyle, designSystem.platformStyle)
            .environment(\.colorSystem, ColorSystem(theme: designSystem.currentTheme, platform: designSystem.platformStyle))
            .environment(\.typographySystem, TypographySystem(platform: designSystem.platformStyle, accessibility: designSystem.accessibilitySettings))
            .environment(\.accessibilitySettings, designSystem.accessibilitySettings)
            .preferredColorScheme(designSystem.currentTheme == .dark ? .dark : .light)
            .automaticCompliance(named: "ThemedFrameworkView")
    }
}

/// Themed version of IntelligentFormView
public struct ThemedIntelligentFormView<DataType: Codable>: View {
    let dataType: DataType.Type
    let initialData: DataType?
    let customFieldView: (String, Any, Binding<Any>) -> AnyView
    let onSubmit: (DataType) -> Void
    let onCancel: () -> Void
    
    @Environment(\.colorSystem) private var colors
    @Environment(\.typographySystem) private var typography
    @Environment(\.platformStyle) private var platform
    
    public init(
        for dataType: DataType.Type,
        initialData: DataType? = nil,
        customFieldView: @escaping (String, Any, Binding<Any>) -> AnyView = { _, _, _ in AnyView(EmptyView()) },
        onSubmit: @escaping (DataType) -> Void,
        onCancel: @escaping () -> Void = {}
    ) {
        self.dataType = dataType
        self.initialData = initialData
        self.customFieldView = customFieldView
        self.onSubmit = onSubmit
        self.onCancel = onCancel
    }
    
    public var body: some View {
        // Delegate to IntelligentFormView for actual form generation
        // This ensures ThemedIntelligentFormView benefits from all IntelligentFormView features,
        // including type-only form generation, hints-first discovery, and entity creation
        IntelligentFormView.generateForm(
            for: dataType,
            initialData: initialData,
            customFieldView: { name, value, fieldType in
                // Convert IntelligentFormView's customFieldView signature to ThemedIntelligentFormView's
                // ThemedIntelligentFormView expects (String, Any, Binding<Any>)
                // IntelligentFormView provides (String, Any, FieldType)
                // We create a binding from the value for the themed view
                customFieldView(name, value, Binding.constant(value))
            },
            onSubmit: onSubmit,
            onCancel: onCancel
        )
        .themedCard()
    }
}

/// Themed version of GenericFormView
// MARK: - DEPRECATED: This struct uses GenericFormField which has been deprecated
// TODO: Replace with DynamicFormField equivalents
/*
public struct ThemedGenericFormView: View {
    let fields: [GenericFormField]
    let onSubmit: ([String: Any]) -> Void
    let onCancel: () -> Void
    
    @Environment(\.colorSystem) private var colors
    @Environment(\.typographySystem) private var typography
    @Environment(\.platformStyle) private var platform
    @State private var formData: [String: Any] = [:]
    
    public init(
        fields: [GenericFormField],
        onSubmit: @escaping ([String: Any]) -> Void,
        onCancel: @escaping () -> Void = {}
    ) {
        self.fields = fields
        self.onSubmit = onSubmit
        self.onCancel = onCancel
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Form")
                    .font(typography.title2)
                    .foregroundColor(colors.text)
                Spacer()
                Text("\(fields.count) fields")
                    .font(typography.caption1)
                    .foregroundColor(colors.textSecondary)
            }
            .padding(.horizontal)
            .padding(.top)
            .background(colors.surface)
            
            // Form content
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(fields, id: \.id) { field in
                        createFieldView(for: field)
                    }
                }
                .padding()
            }
            .background(colors.background)
            
            // Footer
            HStack {
                AdaptiveUIPatterns.AdaptiveButton(
                    "Cancel",
                    style: .outline,
                    size: .medium,
                    action: onCancel
                )
                
                Spacer()
                
                AdaptiveUIPatterns.AdaptiveButton(
                    "Submit",
                    style: .primary,
                    size: .medium,
                    action: { onSubmit(formData) }
                )
            }
            .padding()
            .background(colors.surface)
        }
        .themedCard()
        .automaticCompliance(named: "ThemedGenericFormView")
    }
    
    private func createFieldView(for field: GenericFormField) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(field.label)
                .font(typography.subheadline)
                .fontWeight(.medium)
                .foregroundColor(colors.text)
            
            switch field.fieldType {
            case .text:
                TextField(field.placeholder ?? "Enter text", text: Binding(
                    get: { formData[field.id.uuidString] as? String ?? "" },
                    set: { formData[field.id.uuidString] = $0 }
                ))
                .themedTextField()
                
            case .email:
                TextField(field.placeholder ?? "Enter email", text: Binding(
                    get: { formData[field.id.uuidString] as? String ?? "" },
                    set: { formData[field.id.uuidString] = $0 }
                ))
                .themedTextField()
                
            case .password:
                SecureField(field.placeholder ?? "Enter password", text: Binding(
                    get: { formData[field.id.uuidString] as? String ?? "" },
                    set: { formData[field.id.uuidString] = $0 }
                ))
                .themedTextField()
                
            case .number:
                TextField(field.placeholder ?? "Enter number", text: Binding(
                    get: { formData[field.id.uuidString] as? String ?? "" },
                    set: { formData[field.id.uuidString] = $0 }
                ))
                .themedTextField()
                
            case .date:
                DatePicker(field.placeholder ?? "Select date", selection: Binding(
                    get: { formData[field.id.uuidString] as? Date ?? Date() },
                    set: { formData[field.id.uuidString] = $0 }
                ))
                .datePickerStyle(.compact)
                
            case .select:
                Picker(field.placeholder ?? "Select option", selection: Binding(
                    get: { formData[field.id.uuidString] as? String ?? "" },
                    set: { formData[field.id.uuidString] = $0 }
                )) {
                    Text("Select an option").tag("")
                    ForEach(field.options, id: \.self) { option in
                        Text(option).tag(option)
                    }
                }
                .pickerStyle(.menu)
                .themedTextField()
                    
            case .textarea:
                TextEditor(text: Binding(
                    get: { formData[field.id.uuidString] as? String ?? "" },
                    set: { formData[field.id.uuidString] = $0 }
                ))
                .frame(minHeight: 100)
                .themedTextField()
                
            case .checkbox:
                Toggle(field.label, isOn: Binding(
                    get: { formData[field.id.uuidString] as? Bool ?? false },
                    set: { formData[field.id.uuidString] = $0 }
                ))
                
            case .radio:
                VStack(alignment: .leading) {
                    Text(field.label)
                        .font(typography.body)
                        .fontWeight(.medium)
                    
                    ForEach(field.options, id: \.self) { option in
                        HStack {
                            Button(action: {
                                formData[field.id.uuidString] = option
                            }) {
                                Image(systemName: (formData[field.id.uuidString] as? String ?? "") == option ? "largecircle.fill.circle" : "circle")
                                    .foregroundColor((formData[field.id.uuidString] as? String ?? "") == option ? .blue : .gray)
                            }
                            Text(option)
                        }
                    }
                }
            case .phone:
                TextField(field.placeholder ?? "Enter phone", text: Binding(
                    get: { formData[field.id.uuidString] as? String ?? "" },
                    set: { formData[field.id.uuidString] = $0 }
                ))
                .themedTextField()
            case .time:
                DatePicker(field.placeholder ?? "Select time", selection: Binding(
                    get: { formData[field.id.uuidString] as? Date ?? Date() },
                    set: { formData[field.id.uuidString] = $0 }
                ), displayedComponents: .hourAndMinute)
            case .datetime:
                DatePicker(field.placeholder ?? "Select date and time", selection: Binding(
                    get: { formData[field.id.uuidString] as? Date ?? Date() },
                    set: { formData[field.id.uuidString] = $0 }
                ), displayedComponents: [.date, .hourAndMinute])
            case .multiselect:
                Text("Multi-select field: \(field.label)")
                    .font(typography.body)
                    .foregroundColor(colors.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    .background(colors.surface)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            case .file:
                Text("File upload field: \(field.label)")
                    .font(typography.body)
                    .foregroundColor(colors.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    .background(colors.surface)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            case .url:
                TextField(field.placeholder ?? "Enter URL", text: Binding(
                    get: { formData[field.id.uuidString] as? String ?? "" },
                    set: { formData[field.id.uuidString] = $0 }
                ))
                .themedTextField()
            case .color:
                Text("Color picker field: \(field.label)")
                    .font(typography.body)
                    .foregroundColor(colors.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    .background(colors.surface)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            case .range:
                Text("Range field: \(field.label)")
                    .font(typography.body)
                    .foregroundColor(colors.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    .background(colors.surface)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            case .toggle:
                Toggle(field.placeholder ?? "Toggle", isOn: Binding(
                    get: { formData[field.id.uuidString] as? Bool ?? false },
                    set: { formData[field.id.uuidString] = $0 }
                ))
            case .richtext:
                Text("Rich text field: \(field.label)")
                    .font(typography.body)
                    .foregroundColor(colors.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    .background(colors.surface)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            case .autocomplete:
                Text("Autocomplete field: \(field.label)")
                    .font(typography.body)
                    .foregroundColor(colors.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    .background(colors.surface)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            case .integer:
                TextField(field.placeholder ?? "Enter integer", text: Binding(
                    get: { formData[field.id.uuidString] as? String ?? "" },
                    set: { formData[field.id.uuidString] = $0 }
                ))
                .themedTextField()
            case .image:
                Text("Image field: \(field.label)")
                    .font(typography.body)
                    .foregroundColor(colors.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    .background(colors.surface)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            case .array:
                Text("Array field: \(field.label)")
                    .font(typography.body)
                    .foregroundColor(colors.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    .background(colors.surface)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            case .data:
                Text("Data field: \(field.label)")
                    .font(typography.body)
                    .foregroundColor(colors.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    .background(colors.surface)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            case .`enum`:
                Picker(field.placeholder ?? "Select option", selection: Binding(
                    get: { formData[field.id.uuidString] as? String ?? "" },
                    set: { formData[field.id.uuidString] = $0 }
                )) {
                    Text("Select an option").tag("")
                    ForEach(field.options, id: \.self) { option in
                        Text(option).tag(option)
                    }
                }
                .pickerStyle(.menu)
                .themedTextField()
            case .custom:
                Text("Custom field: \(field.label)")
                    .font(typography.body)
                    .foregroundColor(colors.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    .background(colors.surface)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
    }
}
*/

/// Themed version of ResponsiveCardView
public struct ThemedResponsiveCardView: View {
    let title: String
    let subtitle: String?
    let content: AnyView
    let action: (() -> Void)?
    
    @Environment(\.colorSystem) private var colors
    @Environment(\.typographySystem) private var typography
    @Environment(\.platformStyle) private var platform
    
    public init(
        title: String,
        subtitle: String? = nil,
        content: AnyView,
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.content = content
        self.action = action
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(typography.headline)
                    .foregroundColor(colors.text)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(typography.subheadline)
                        .foregroundColor(colors.textSecondary)
                }
            }
            
            // Content
            content
            
            // Action button
            if let action = action {
                AdaptiveUIPatterns.AdaptiveButton(
                    "View Details",
                    style: .outline,
                    size: .small,
                    action: action
                )
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        .padding()
        .themedCard()
        .automaticCompliance(named: "ThemedResponsiveCardView")
    }
}

/// Themed version of GenericItemCollectionView
public struct ThemedGenericItemCollectionView: View {
    let items: [Any]
    let title: String
    let onItemTap: (Any) -> Void
    
    @Environment(\.colorSystem) private var colors
    @Environment(\.typographySystem) private var typography
    @Environment(\.platformStyle) private var platform
    
    public init(
        items: [Any],
        title: String,
        onItemTap: @escaping (Any) -> Void
    ) {
        self.items = items
        self.title = title
        self.onItemTap = onItemTap
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                Text(title)
                    .font(typography.headline)
                    .foregroundColor(colors.text)
                Spacer()
                Text("\(items.count) items")
                    .font(typography.caption1)
                    .foregroundColor(colors.textSecondary)
            }
            
            // Items grid
            LazyVGrid(columns: gridColumns, spacing: 12) {
                ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                    Button(action: { onItemTap(item) }) {
                        VStack {
                            Text("Item \(index + 1)")
                                .font(typography.body)
                                .foregroundColor(colors.text)
                            Text("Tap to view")
                                .font(typography.caption1)
                                .foregroundColor(colors.textSecondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(colors.surface)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .padding()
        .themedCard()
        .automaticCompliance(named: "ThemedGenericItemCollectionView")
    }
    
    private var gridColumns: [GridItem] {
        switch platform {
        case .ios:
            return Array(repeating: GridItem(.flexible()), count: 2)
        case .macOS:
            return Array(repeating: GridItem(.flexible()), count: 3)
        case .watchOS:
            return Array(repeating: GridItem(.flexible()), count: 1)
        case .tvOS:
            return Array(repeating: GridItem(.flexible()), count: 4)
        case .visionOS:
            return Array(repeating: GridItem(.flexible()), count: 3)
        }
    }
}

/// Themed version of GenericNumericDataView
public struct ThemedGenericNumericDataView: View {
    let data: [Double]
    let title: String
    let unit: String?
    
    @Environment(\.colorSystem) private var colors
    @Environment(\.typographySystem) private var typography
    @Environment(\.platformStyle) private var platform
    
    public init(
        data: [Double],
        title: String,
        unit: String? = nil
    ) {
        self.data = data
        self.title = title
        self.unit = unit
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                Text(title)
                    .font(typography.headline)
                    .foregroundColor(colors.text)
                Spacer()
                if let unit = unit {
                    Text(unit)
                        .font(typography.caption1)
                        .foregroundColor(colors.textSecondary)
                }
            }
            
            // Data visualization
            VStack(spacing: 8) {
                if let maxValue = data.max() {
                    ForEach(Array(data.enumerated()), id: \.offset) { index, value in
                        HStack {
                            Text("\(index + 1)")
                                .font(typography.caption1)
                                .foregroundColor(colors.textSecondary)
                                .frame(width: 20, alignment: .leading)
                            
                            ThemedProgressBar(
                                progress: maxValue > 0 ? value / maxValue : 0,
                                variant: .primary
                            )
                            
                            Text(String(format: "%.1f", value))
                                .font(typography.caption1)
                                .foregroundColor(colors.text)
                                .frame(width: 40, alignment: .trailing)
                        }
                    }
                }
            }
        }
        .padding()
        .themedCard()
        .automaticCompliance(named: "ThemedGenericNumericDataView")
    }
}

// MARK: - View Extensions

public extension View {
    /// Wrap this view with the themed framework system
    func withThemedFramework() -> some View {
        ThemedFrameworkView {
            self
        }
    }
}
