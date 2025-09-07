import SwiftUI

// MARK: - Layer 1: Semantic Intent - Data Type Recognition
// This layer is completely platform and project agnostic
// It recognizes data types and uses hints to guide presentation decisions

// MARK: - Hints System

/// Data type hints that guide generic functions
public enum DataTypeHint: String, CaseIterable, Sendable {
    case generic          // Unknown or mixed data types
    case text             // Text-based content
    case number           // Numeric content
    case date             // Date/time content
    case image            // Image content
    case boolean          // Boolean/true-false content
    case collection       // Generic collection of items
    case numeric          // Charts, graphs, statistics
    case hierarchical     // Tree structures, nested data
    case temporal         // Time-based data, schedules
    case media            // Images, videos, documents
    case form             // Form-based data entry
    case list             // List-based data
    case grid             // Grid-based data
    case chart            // Chart/graph data
    case navigation       // Navigation items (menus, links)
    case action           // Interactive elements (buttons, controls)
    case product          // Product information
    case user             // User profiles, accounts
    case transaction      // Financial transactions
    case communication    // Messages, notifications
    case location         // Geographic data
    case custom           // Custom data type
}

/// Presentation preference hints
public enum PresentationPreference: String, CaseIterable, Sendable {
    case automatic        // Let the system decide
    case compact         // Compact layout
    case card            // Card-based layout
    case cards           // Card-based layout (plural)
    case list            // List-based layout
    case grid            // Grid-based layout
    case coverFlow       // Cover flow layout
    case masonry         // Masonry/pinterest layout
    case table           // Table-based layout
    case chart           // Chart/graph layout
    case form            // Form-based layout
    case detail          // Detailed view layout
    case modal           // Modal presentation
    case navigation      // Navigation stack
    case custom          // Custom layout
}

/// Presentation context
public enum PresentationContext: String, CaseIterable, Sendable {
    case dashboard       // Overview/summary view
    case detail          // Detailed item view
    case summary         // Summary/compact view
    case edit            // Editing interface
    case create          // Creation interface
    case search          // Search results
    case browse          // Browsing interface
    case list            // List view context
    case form            // Form view context
    case modal           // Modal presentation context
    case navigation      // Navigation context
}

/// Comprehensive hints structure for guiding generic functions
public struct PresentationHints: Sendable {
    public let dataType: DataTypeHint
    public let presentationPreference: PresentationPreference
    public let complexity: ContentComplexity
    public let context: PresentationContext
    public let customPreferences: [String: String]
    
    public init(
        dataType: DataTypeHint,
        presentationPreference: PresentationPreference = .automatic,
        complexity: ContentComplexity = .moderate,
        context: PresentationContext = .dashboard,
        customPreferences: [String: String] = [:]
    ) {
        self.dataType = dataType
        self.presentationPreference = presentationPreference
        self.complexity = complexity
        self.context = context
        self.customPreferences = customPreferences
    }
}

// MARK: - Generic Data Presentation Functions

/// Generic function for presenting any collection of identifiable items
/// Uses hints to determine optimal presentation strategy
@MainActor
public func platformPresentItemCollection_L1<Item: Identifiable>(
    items: [Item],
    hints: PresentationHints
) -> some View {
    // Generic implementation that uses hints to guide decisions
    // This function doesn't know about specific business logic
    return GenericItemCollectionView(items: items, hints: hints)
}

/// Generic function for presenting numeric data
@MainActor
public func platformPresentNumericData_L1(
    data: [GenericNumericData],
    hints: PresentationHints
) -> some View {
    return GenericNumericDataView(data: data, hints: hints)
}

/// Generic function for presenting responsive cards
@MainActor
public func platformResponsiveCard_L1<Content: View>(
    @ViewBuilder content: () -> Content,
    hints: PresentationHints
) -> some View {
    // Use ResponsiveCardsView for card-based presentation
    return ResponsiveCardView(data: ResponsiveCardData(
        title: "Generic Card",
        subtitle: "Generated from Layer 1",
        icon: "doc.text",
        color: .blue,
        complexity: hints.complexity
    ))
}

/// Generic function for presenting form data using our intelligent form system
@MainActor
public func platformPresentFormData_L1(
    fields: [GenericFormField],
    hints: PresentationHints
) -> some View {
    // Create a dynamic form from the provided fields
    return SimpleFormView(fields: fields, hints: hints)
}

/// Generic function for presenting modal forms
/// Uses hints to determine optimal modal presentation strategy
@MainActor
public func platformPresentModalForm_L1(
    formType: DataTypeHint,
    context: PresentationContext
) -> some View {
    // Create presentation hints for modal context
    let hints = PresentationHints(
        dataType: formType,
        presentationPreference: .modal,
        complexity: .moderate,
        context: context
    )
    
    // Create appropriate form fields based on the form type
    let fields = createFieldsForFormType(formType, context: context)
    
    // Return a modal form with the generated fields
    return ModalFormView(fields: fields, formType: formType, context: context, hints: hints)
}

/// Generic function for presenting media data
@MainActor
public func platformPresentMediaData_L1(
    media: [GenericMediaItem],
    hints: PresentationHints
) -> some View {
    return GenericMediaView(media: media, hints: hints)
}

/// Generic function for presenting hierarchical data
@MainActor
public func platformPresentHierarchicalData_L1(
    items: [GenericHierarchicalItem],
    hints: PresentationHints
) -> some View {
    return GenericHierarchicalView(items: items, hints: hints)
}

/// Generic function for presenting temporal data
@MainActor
public func platformPresentTemporalData_L1(
    items: [GenericTemporalItem],
    hints: PresentationHints
) -> some View {
    return GenericTemporalView(items: items, hints: hints)
}

// MARK: - Enhanced Presentation Hints Overloads

/// Generic function for presenting any collection of identifiable items with enhanced hints
/// Uses enhanced hints to determine optimal presentation strategy and process extensible hints
@MainActor
public func platformPresentItemCollection_L1<Item: Identifiable>(
    items: [Item],
    hints: EnhancedPresentationHints
) -> some View {
    // Convert enhanced hints to basic hints for backward compatibility
    let basicHints = PresentationHints(
        dataType: hints.dataType,
        presentationPreference: hints.presentationPreference,
        complexity: hints.complexity,
        context: hints.context,
        customPreferences: hints.customPreferences
    )
    
    // Process extensible hints and merge custom data
    let processedHints = processExtensibleHints(hints, into: basicHints)
    
    return GenericItemCollectionView(items: items, hints: processedHints)
        .environment(\.extensibleHints, hints.extensibleHints)
}

/// Generic function for presenting numeric data with enhanced hints
@MainActor
public func platformPresentNumericData_L1(
    data: [GenericNumericData],
    hints: EnhancedPresentationHints
) -> some View {
    let basicHints = PresentationHints(
        dataType: hints.dataType,
        presentationPreference: hints.presentationPreference,
        complexity: hints.complexity,
        context: hints.context,
        customPreferences: hints.customPreferences
    )
    
    let processedHints = processExtensibleHints(hints, into: basicHints)
    
    return GenericNumericDataView(data: data, hints: processedHints)
        .environment(\.extensibleHints, hints.extensibleHints)
}

/// Generic function for presenting responsive cards with enhanced hints
@MainActor
public func platformResponsiveCard_L1<Content: View>(
    @ViewBuilder content: () -> Content,
    hints: EnhancedPresentationHints
) -> some View {
    let basicHints = PresentationHints(
        dataType: hints.dataType,
        presentationPreference: hints.presentationPreference,
        complexity: hints.complexity,
        context: hints.context,
        customPreferences: hints.customPreferences
    )
    
    let processedHints = processExtensibleHints(hints, into: basicHints)
    
    return ResponsiveCardView(data: ResponsiveCardData(
        title: "Generic Card",
        subtitle: "Generated from Layer 1",
        icon: "doc.text",
        color: .blue,
        complexity: processedHints.complexity
    ))
    .environment(\.extensibleHints, hints.extensibleHints)
}

/// Generic function for presenting form data with enhanced hints
@MainActor
public func platformPresentFormData_L1(
    fields: [GenericFormField],
    hints: EnhancedPresentationHints
) -> some View {
    let basicHints = PresentationHints(
        dataType: hints.dataType,
        presentationPreference: hints.presentationPreference,
        complexity: hints.complexity,
        context: hints.context,
        customPreferences: hints.customPreferences
    )
    
    let processedHints = processExtensibleHints(hints, into: basicHints)
    
    return SimpleFormView(fields: fields, hints: processedHints)
        .environment(\.extensibleHints, hints.extensibleHints)
}

/// Generic function for presenting media data with enhanced hints
@MainActor
public func platformPresentMediaData_L1(
    media: [GenericMediaItem],
    hints: EnhancedPresentationHints
) -> some View {
    let basicHints = PresentationHints(
        dataType: hints.dataType,
        presentationPreference: hints.presentationPreference,
        complexity: hints.complexity,
        context: hints.context,
        customPreferences: hints.customPreferences
    )
    
    let processedHints = processExtensibleHints(hints, into: basicHints)
    
    return GenericMediaView(media: media, hints: processedHints)
        .environment(\.extensibleHints, hints.extensibleHints)
}

/// Generic function for presenting hierarchical data with enhanced hints
@MainActor
public func platformPresentHierarchicalData_L1(
    items: [GenericHierarchicalItem],
    hints: EnhancedPresentationHints
) -> some View {
    let basicHints = PresentationHints(
        dataType: hints.dataType,
        presentationPreference: hints.presentationPreference,
        complexity: hints.complexity,
        context: hints.context,
        customPreferences: hints.customPreferences
    )
    
    let processedHints = processExtensibleHints(hints, into: basicHints)
    
    return GenericHierarchicalView(items: items, hints: processedHints)
        .environment(\.extensibleHints, hints.extensibleHints)
}

/// Generic function for presenting temporal data with enhanced hints
@MainActor
public func platformPresentTemporalData_L1(
    items: [GenericTemporalItem],
    hints: EnhancedPresentationHints
) -> some View {
    let basicHints = PresentationHints(
        dataType: hints.dataType,
        presentationPreference: hints.presentationPreference,
        complexity: hints.complexity,
        context: hints.context,
        customPreferences: hints.customPreferences
    )
    
    let processedHints = processExtensibleHints(hints, into: basicHints)
    
    return GenericTemporalView(items: items, hints: processedHints)
        .environment(\.extensibleHints, hints.extensibleHints)
}

// MARK: - Generic View Structures

/// Generic item collection view with intelligent presentation decisions
public struct GenericItemCollectionView<Item: Identifiable>: View {
    let items: [Item]
    let hints: PresentationHints
    
    public var body: some View {
        // Layer 1: Intelligent presentation decision based on hints and platform
        let presentationStrategy = determinePresentationStrategy()
        
        switch presentationStrategy {
        case .expandableCards:
            ExpandableCardCollectionView(items: items, hints: hints)
        case .coverFlow:
            CoverFlowCollectionView(items: items, hints: hints)
        case .grid:
            GridCollectionView(items: items, hints: hints)
        case .list:
            ListCollectionView(items: items, hints: hints)
        case .masonry:
            MasonryCollectionView(items: items, hints: hints)
        case .adaptive:
            AdaptiveCollectionView(items: items, hints: hints)
        }
    }
    
    /// Determine the optimal presentation strategy based on hints and platform
    private func determinePresentationStrategy() -> PresentationStrategy {
        let itemType = hints.customPreferences["itemType"] ?? "generic"
        let interactionStyle = hints.customPreferences["interactionStyle"] ?? "static"
        let _ = hints.customPreferences["layoutPreference"] ?? "automatic"
        
        // Platform-aware decision making
        let platform = Platform.current
        let deviceType = DeviceType.current
        
        // Feature cards with expandable interaction
        if itemType == "featureCards" && interactionStyle == "expandable" {
            switch platform {
            case .visionOS:
                return .coverFlow // Spatial interface prefers coverflow
            case .macOS:
                return .expandableCards // Desktop prefers hover-expandable cards
            case .iOS:
                return deviceType == .pad ? .expandableCards : .adaptive
            case .watchOS, .tvOS:
                return .list // Constrained interfaces prefer lists
            }
        }
        
        // Media content
        if hints.dataType == .media {
            switch platform {
            case .visionOS:
                return .coverFlow
            case .macOS, .iOS:
                return .masonry
            default:
                return .grid
            }
        }
        
        // Navigation items
        if hints.dataType == .navigation {
            switch deviceType {
            case .phone:
                return .list
            case .pad:
                return .grid
            case .mac:
                return .list
            default:
                return .list
            }
        }
        
        // Default based on presentation preference
        switch hints.presentationPreference {
        case .cards:
            return .expandableCards
        case .list:
            return .list
        case .grid:
            return .grid
        case .masonry:
            return .masonry
        case .coverFlow:
            return .coverFlow
        case .automatic:
            return .adaptive
        default:
            return .adaptive
        }
    }
}

/// Presentation strategies that Layer 1 can choose from
private enum PresentationStrategy {
    case expandableCards
    case coverFlow
    case grid
    case list
    case masonry
    case adaptive
}

/// Generic numeric data view
public struct GenericNumericDataView: View {
    let data: [GenericNumericData]
    let hints: PresentationHints
    
    public var body: some View {
        VStack {
            Text("Numeric Data")
                .font(.headline)
            Text("Data points: \(data.count)")
                .font(.caption)
        }
        .padding()
    }
}

/// Generic form view using our platform extensions
public struct GenericFormView: View {
    let fields: [GenericFormField]
    let hints: PresentationHints
    
    public var body: some View {
        // Use our platform form container from Layer 4
        platformFormContainer_L4(
            strategy: FormStrategy(
                containerType: .standard,
                fieldLayout: .vertical,
                validation: .deferred
            ),
            content: {
                ForEach(fields, id: \.id) { field in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(field.label)
                            .font(.body)
                            .fontWeight(.medium)
                            .foregroundColor(Color.platformLabel)
                        
                        // Use platform-specific field styling
                        TextField(field.placeholder ?? "Enter \(field.label)", text: .constant(""))
                            .textFieldStyle(.roundedBorder)
                            .background(Color.platformSecondaryBackground)
                    }
                    .padding(.vertical, 4)
                }
            }
        )
    }
}

/// Generic media view
public struct GenericMediaView: View {
    let media: [GenericMediaItem]
    let hints: PresentationHints
    
    public var body: some View {
        VStack {
            Text("Media Collection")
                .font(.headline)
            Text("Items: \(media.count)")
                .font(.caption)
        }
        .padding()
    }
}

/// Generic hierarchical view
public struct GenericHierarchicalView: View {
    let items: [GenericHierarchicalItem]
    let hints: PresentationHints
    
    public var body: some View {
        VStack {
            Text("Hierarchical Data")
                .font(.headline)
            Text("Root items: \(items.count)")
                .font(.caption)
        }
        .padding()
    }
}

/// Generic temporal view
public struct GenericTemporalView: View {
    let items: [GenericTemporalItem]
    let hints: PresentationHints
    
    public var body: some View {
        VStack {
            Text("Temporal Data")
                .font(.headline)
            Text("Events: \(items.count)")
                .font(.caption)
        }
        .padding()
    }
}

/// Modal form view for presenting forms in modal context
public struct ModalFormView: View {
    let fields: [GenericFormField]
    let formType: DataTypeHint
    let context: PresentationContext
    let hints: PresentationHints
    
    public var body: some View {
        VStack(spacing: 16) {
            // Modal header
            HStack {
                Text("Form: \(formType.rawValue.capitalized)")
                    .font(.headline)
                    .foregroundColor(.primary)
                Spacer()
                Button("Done") {
                    // TODO: Implement dismiss action
                }
                .buttonStyle(.bordered)
            }
            .padding(.horizontal)
            .padding(.top)
            
            // Form content
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(fields, id: \.id) { field in
                        createFieldView(for: field)
                    }
                }
                .padding(.horizontal)
            }
            
            Spacer()
        }
        .frame(minWidth: 400, minHeight: 300)
        .background(Color.platformBackground)
    }
    
    @ViewBuilder
    private func createFieldView(for field: GenericFormField) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(field.label)
                .font(.subheadline)
                .fontWeight(.medium)
            
            switch field.fieldType {
            case .text:
                TextField(field.placeholder ?? "Enter text", text: .constant(""))
                    .textFieldStyle(.roundedBorder)
            case .email:
                TextField(field.placeholder ?? "Enter email", text: .constant(""))
                    .textFieldStyle(.roundedBorder)

            case .password:
                SecureField(field.placeholder ?? "Enter password", text: .constant(""))
                    .textFieldStyle(.roundedBorder)
            case .number:
                TextField(field.placeholder ?? "Enter number", text: .constant(""))
                    .textFieldStyle(.roundedBorder)

            case .date:
                DatePicker(field.placeholder ?? "Select date", selection: .constant(Date()))
                    .datePickerStyle(.compact)
            case .select:
                Text("Select field: \(field.label)")
                    .foregroundColor(.secondary)
            case .textarea:
                TextEditor(text: .constant(""))
                    .frame(minHeight: 80)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
            case .checkbox:
                Toggle(field.placeholder ?? "Toggle", isOn: .constant(false))
            case .radio:
                Text("Radio field: \(field.label)")
                    .foregroundColor(.secondary)
            case .phone:
                TextField(field.placeholder ?? "Enter phone", text: .constant(""))
                    .textFieldStyle(.roundedBorder)
            case .time:
                DatePicker(field.placeholder ?? "Select time", selection: .constant(Date()), displayedComponents: .hourAndMinute)
                    .datePickerStyle(.compact)
            case .datetime:
                DatePicker(field.placeholder ?? "Select date and time", selection: .constant(Date()), displayedComponents: [.date, .hourAndMinute])
                    .datePickerStyle(.compact)
            case .multiselect:
                Text("Multi-select field: \(field.label)")
                    .foregroundColor(.secondary)
            case .file:
                Text("File upload field: \(field.label)")
                    .foregroundColor(.secondary)
            case .url:
                TextField(field.placeholder ?? "Enter URL", text: .constant(""))
                    .textFieldStyle(.roundedBorder)
            case .color:
                Text("Color picker field: \(field.label)")
                    .foregroundColor(.secondary)
            case .range:
                Text("Range field: \(field.label)")
                    .foregroundColor(.secondary)
            case .toggle:
                Toggle(field.placeholder ?? "Toggle", isOn: .constant(false))
            case .richtext:
                Text("Rich text field: \(field.label)")
                    .foregroundColor(.secondary)
            case .autocomplete:
                Text("Autocomplete field: \(field.label)")
                    .foregroundColor(.secondary)
            case .custom:
                Text("Custom field: \(field.label)")
                    .foregroundColor(.secondary)
            }
        }
    }
}

/// Simple form view that creates forms from generic form fields
public struct SimpleFormView: View {
    let fields: [GenericFormField]
    let hints: PresentationHints
    
    public var body: some View {
        VStack(spacing: 16) {
            // Form header
            HStack {
                Text("Dynamic Form")
                    .font(.headline)
                    .foregroundColor(.primary)
                Spacer()
                Text("\(fields.count) fields")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)
            
            // Form fields
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(fields, id: \.id) { field in
                        createFieldView(for: field)
                    }
                }
                .padding(.horizontal)
            }
            
            // Form actions
            HStack {
                Button("Reset") {
                    // TODO: Implement reset functionality
                }
                .buttonStyle(.bordered)
                
                Spacer()
                
                Button("Submit") {
                    // TODO: Implement submit functionality
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(.horizontal)
        }
        .padding()
        .background(Color.platformBackground)
    }
    
    @ViewBuilder
    private func createFieldView(for field: GenericFormField) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(field.label)
                .font(.subheadline)
                .fontWeight(.medium)
            
            switch field.fieldType {
            case .text:
                TextField(field.placeholder ?? "Enter text", text: .constant(""))
                    .textFieldStyle(.roundedBorder)
            case .email:
                TextField(field.placeholder ?? "Enter email", text: .constant(""))
                    .textFieldStyle(.roundedBorder)

            case .password:
                SecureField(field.placeholder ?? "Enter password", text: .constant(""))
                    .textFieldStyle(.roundedBorder)
            case .number:
                TextField(field.placeholder ?? "Enter number", text: .constant(""))
                    .textFieldStyle(.roundedBorder)

            case .date:
                DatePicker(field.placeholder ?? "Select date", selection: .constant(Date()))
                    .datePickerStyle(.compact)
            case .select:
                Text("Select field: \(field.label)")
                    .foregroundColor(.secondary)
            case .textarea:
                TextEditor(text: .constant(""))
                    .frame(minHeight: 80)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
            case .checkbox:
                Toggle(field.placeholder ?? "Toggle", isOn: .constant(false))
            case .radio:
                Text("Radio field: \(field.label)")
                    .foregroundColor(.secondary)
            case .phone:
                TextField(field.placeholder ?? "Enter phone", text: .constant(""))
                    .textFieldStyle(.roundedBorder)
            case .time:
                DatePicker(field.placeholder ?? "Select time", selection: .constant(Date()), displayedComponents: .hourAndMinute)
                    .datePickerStyle(.compact)
            case .datetime:
                DatePicker(field.placeholder ?? "Select date and time", selection: .constant(Date()), displayedComponents: [.date, .hourAndMinute])
                    .datePickerStyle(.compact)
            case .multiselect:
                Text("Multi-select field: \(field.label)")
                    .foregroundColor(.secondary)
            case .file:
                Text("File upload field: \(field.label)")
                    .foregroundColor(.secondary)
            case .url:
                TextField(field.placeholder ?? "Enter URL", text: .constant(""))
                    .textFieldStyle(.roundedBorder)
            case .color:
                Text("Color picker field: \(field.label)")
                    .foregroundColor(.secondary)
            case .range:
                Text("Range field: \(field.label)")
                    .foregroundColor(.secondary)
            case .toggle:
                Toggle(field.placeholder ?? "Toggle", isOn: .constant(false))
            case .richtext:
                Text("Rich text field: \(field.label)")
                    .foregroundColor(.secondary)
            case .autocomplete:
                Text("Autocomplete field: \(field.label)")
                    .foregroundColor(.secondary)
            case .custom:
                Text("Custom field: \(field.label)")
                    .foregroundColor(.secondary)
            }
        }
    }
}

// MARK: - Helper Functions

/// Create appropriate form fields based on the form type and context
private func createFieldsForFormType(_ formType: DataTypeHint, context: PresentationContext) -> [GenericFormField] {
    switch formType {
    case .form:
        return createGenericFormFields(context: context)
    case .text:
        return [
            GenericFormField(label: "Text Content", placeholder: "Enter text content", fieldType: .text)
        ]
    case .number:
        return [
            GenericFormField(label: "Numeric Value", placeholder: "Enter number", fieldType: .number)
        ]
    case .date:
        return [
            GenericFormField(label: "Date", placeholder: "Select date", fieldType: .date)
        ]
    case .boolean:
        return [
            GenericFormField(label: "Boolean Value", placeholder: "Toggle value", fieldType: .checkbox)
        ]
    case .collection:
        return [
            GenericFormField(label: "Collection Name", placeholder: "Enter collection name", fieldType: .text),
            GenericFormField(label: "Item Count", placeholder: "Enter item count", fieldType: .number)
        ]
    case .hierarchical:
        return [
            GenericFormField(label: "Root Name", placeholder: "Enter root name", fieldType: .text),
            GenericFormField(label: "Level Count", placeholder: "Enter hierarchy levels", fieldType: .number)
        ]
    case .temporal:
        return [
            GenericFormField(label: "Start Date", placeholder: "Select start date", fieldType: .date),
            GenericFormField(label: "Start Time", placeholder: "Select start time", fieldType: .time),
            GenericFormField(label: "End Date", placeholder: "Select end date", fieldType: .date),
            GenericFormField(label: "End Time", placeholder: "Select end time", fieldType: .time)
        ]
    case .media:
        return [
            GenericFormField(label: "Media Title", placeholder: "Enter media title", fieldType: .text),
            GenericFormField(label: "Media File", placeholder: "Upload media file", fieldType: .file),
            GenericFormField(label: "Media Type", placeholder: "Enter media type", fieldType: .text)
        ]
    default:
        return createGenericFormFields(context: context)
    }
}

/// Create generic form fields based on context
private func createGenericFormFields(context: PresentationContext) -> [GenericFormField] {
    switch context {
    case .dashboard:
        return [
            GenericFormField(label: "Dashboard Name", placeholder: "Enter dashboard name", fieldType: .text),
            GenericFormField(label: "Auto Refresh", placeholder: "Enable auto refresh", fieldType: .checkbox)
        ]
    case .detail:
        return [
            GenericFormField(label: "Title", placeholder: "Enter title", fieldType: .text),
            GenericFormField(label: "Description", placeholder: "Enter description", fieldType: .richtext),
            GenericFormField(label: "Created Date", placeholder: "Select creation date", fieldType: .date),
            GenericFormField(label: "Created Time", placeholder: "Select creation time", fieldType: .time),
            GenericFormField(label: "Attachments", placeholder: "Upload attachments", fieldType: .file)
        ]
    case .form:
        return [
            GenericFormField(label: "Name", placeholder: "Enter name", fieldType: .text),
            GenericFormField(label: "Email", placeholder: "Enter email", fieldType: .email),
            GenericFormField(label: "Age", placeholder: "Enter age", fieldType: .number),
            GenericFormField(label: "Birth Date", placeholder: "Select birth date", fieldType: .date),
            GenericFormField(label: "Country", placeholder: "Select country", fieldType: .autocomplete),
            GenericFormField(label: "Bio", placeholder: "Enter bio", fieldType: .richtext),
            GenericFormField(label: "Profile Photo", placeholder: "Upload profile photo", fieldType: .file),
            GenericFormField(label: "Subscribe", placeholder: "Subscribe to updates", fieldType: .checkbox)
        ]
    case .list:
        return [
            GenericFormField(label: "List Name", placeholder: "Enter list name", fieldType: .text),
            GenericFormField(label: "Sort Order", placeholder: "Enter sort order", fieldType: .text)
        ]
    case .modal:
        return [
            GenericFormField(label: "Modal Title", placeholder: "Enter modal title", fieldType: .text),
            GenericFormField(label: "Modal Content", placeholder: "Enter modal content", fieldType: .textarea)
        ]
    default:
        return [
            GenericFormField(label: "Title", placeholder: "Enter title", fieldType: .text),
            GenericFormField(label: "Value", placeholder: "Enter value", fieldType: .text)
        ]
    }
}

// MARK: - Platform Strategy Selection (Layer 3 Integration)

/// Select platform strategy based on hints
/// This delegates to Layer 3 for platform-specific strategy selection
private func selectPlatformStrategy(for hints: PresentationHints) -> String {
    // This is a placeholder that will be implemented in Layer 3
    return "platform_strategy_selected"
}

// MARK: - Enhanced Hints Processing

/// Process extensible hints and merge their custom data into basic hints
private func processExtensibleHints(
    _ enhancedHints: EnhancedPresentationHints,
    into basicHints: PresentationHints
) -> PresentationHints {
    // Merge custom data from extensible hints into custom preferences
    var mergedPreferences = basicHints.customPreferences
    
    // Add custom data from all extensible hints (higher priority hints override lower ones)
    let sortedHints = enhancedHints.extensibleHints.sorted { $0.priority > $1.priority }
    for hint in sortedHints {
        for (key, value) in hint.customData {
            // Convert Any to String for customPreferences
            if let stringValue = value as? String {
                mergedPreferences[key] = stringValue
            } else if let boolValue = value as? Bool {
                mergedPreferences[key] = String(boolValue)
            } else if let intValue = value as? Int {
                mergedPreferences[key] = String(intValue)
            } else if let doubleValue = value as? Double {
                mergedPreferences[key] = String(doubleValue)
            } else {
                mergedPreferences[key] = String(describing: value)
            }
        }
    }
    
    // Create new hints with merged preferences
    return PresentationHints(
        dataType: basicHints.dataType,
        presentationPreference: basicHints.presentationPreference,
        complexity: basicHints.complexity,
        context: basicHints.context,
        customPreferences: mergedPreferences
    )
}

// MARK: - Environment Keys

/// Environment key for passing extensible hints to child views
public struct ExtensibleHintsKey: EnvironmentKey {
    public static let defaultValue: [ExtensibleHint] = []
}

public extension EnvironmentValues {
    var extensibleHints: [ExtensibleHint] {
        get { self[ExtensibleHintsKey.self] }
        set { self[ExtensibleHintsKey.self] = newValue }
    }
}
