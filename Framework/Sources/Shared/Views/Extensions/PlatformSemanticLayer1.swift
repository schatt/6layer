import SwiftUI

// MARK: - Generic Data Presentation Functions

/// Generic function for presenting any collection of identifiable items
/// Uses hints to determine optimal presentation strategy
@MainActor
public func platformPresentItemCollection_L1<Item: Identifiable>(
    items: [Item],
    hints: PresentationHints,
    onCreateItem: (() -> Void)? = nil
) -> some View {
    // Generic implementation that uses hints to guide decisions
    // This function doesn't know about specific business logic
    return GenericItemCollectionView(items: items, hints: hints, onCreateItem: onCreateItem)
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

/// Generic function for presenting unknown content at runtime
/// 
/// **IMPORTANT**: This function is reserved for rare cases where the content type
/// is unknown at compile time (e.g., dynamic API responses, user-generated content,
/// or mixed content types). For known content types, use the specific functions:
/// - `platformPresentItemCollection_L1` for collections
/// - `platformPresentFormData_L1` for forms
/// - `platformPresentMediaData_L1` for media
/// - etc.
///
/// This function analyzes content type at runtime and delegates to appropriate
/// specific functions, with a fallback for truly unknown content types.
@MainActor
public func platformPresentContent_L1(
    content: Any,
    hints: PresentationHints
) -> some View {
    return GenericContentView(content: content, hints: hints)
}

// MARK: - Enhanced Presentation Hints Overloads

/// Generic function for presenting any collection of identifiable items with enhanced hints
/// Uses enhanced hints to determine optimal presentation strategy and process extensible hints
@MainActor
public func platformPresentItemCollection_L1<Item: Identifiable>(
    items: [Item],
    hints: EnhancedPresentationHints,
    onCreateItem: (() -> Void)? = nil
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
    
    return GenericItemCollectionView(items: items, hints: processedHints, onCreateItem: onCreateItem)
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
    let onCreateItem: (() -> Void)?
    
    public init(items: [Item], hints: PresentationHints, onCreateItem: (() -> Void)? = nil) {
        self.items = items
        self.hints = hints
        self.onCreateItem = onCreateItem
    }
    
    public var body: some View {
        // Handle empty collections with appropriate empty state
        if items.isEmpty {
            return AnyView(CollectionEmptyStateView(hints: hints, onCreateItem: onCreateItem))
        }
        
        // Layer 1: Intelligent presentation decision based on hints and platform
        let presentationStrategy = determinePresentationStrategy()
        
        switch presentationStrategy {
        case .expandableCards:
            return AnyView(ExpandableCardCollectionView(items: items, hints: hints, onCreateItem: onCreateItem))
        case .coverFlow:
            return AnyView(CoverFlowCollectionView(items: items, hints: hints, onCreateItem: onCreateItem))
        case .grid:
            return AnyView(GridCollectionView(items: items, hints: hints, onCreateItem: onCreateItem))
        case .list:
            return AnyView(ListCollectionView(items: items, hints: hints, onCreateItem: onCreateItem))
        case .masonry:
            return AnyView(MasonryCollectionView(items: items, hints: hints, onCreateItem: onCreateItem))
        case .adaptive:
            return AnyView(AdaptiveCollectionView(items: items, hints: hints, onCreateItem: onCreateItem))
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

/// Empty state view for collections with intelligent messaging based on context
public struct CollectionEmptyStateView: View {
    let hints: PresentationHints
    let onCreateItem: (() -> Void)?
    
    public init(hints: PresentationHints, onCreateItem: (() -> Void)? = nil) {
        self.hints = hints
        self.onCreateItem = onCreateItem
    }
    
    public var body: some View {
        VStack(spacing: 20) {
            // Icon based on data type and context
            Image(systemName: emptyStateIcon)
                .font(.system(size: 48))
                .foregroundColor(.secondary)
            
            VStack(spacing: 8) {
                Text(emptyStateTitle)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(emptyStateMessage)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            // Create action button if provided
            if let onCreateItem = onCreateItem {
                Button(action: onCreateItem) {
                    HStack(spacing: 8) {
                        Image(systemName: "plus.circle.fill")
                        Text(createButtonTitle)
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.accentColor)
                    .cornerRadius(8)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var emptyStateIcon: String {
        switch hints.dataType {
        case .media:
            return "photo.on.rectangle"
        case .navigation:
            return "list.bullet"
        case .form:
            return "doc.text"
        case .numeric:
            return "chart.bar"
        case .temporal:
            return "calendar"
        case .hierarchical:
            return "folder"
        case .collection:
            return "square.grid.2x2"
        case .generic:
            return "tray"
        case .text:
            return "text.alignleft"
        case .number:
            return "number"
        case .date:
            return "calendar"
        case .image:
            return "photo"
        case .boolean:
            return "checkmark.circle"
        case .list:
            return "list.bullet"
        case .grid:
            return "grid"
        case .chart:
            return "chart.bar"
        case .action:
            return "play.circle"
        case .product:
            return "bag"
        case .user:
            return "person"
        case .transaction:
            return "creditcard"
        case .communication:
            return "message"
        case .location:
            return "location"
        case .custom:
            return "gear"
        case .card:
            return "creditcard"
        case .detail:
            return "doc.text"
        case .modal:
            return "rectangle.portrait"
        case .sheet:
            return "rectangle.portrait"
        }
    }
    
    private var emptyStateTitle: String {
        switch hints.dataType {
        case .media:
            return "No Media Items"
        case .navigation:
            return "No Navigation Items"
        case .form:
            return "No Form Fields"
        case .numeric:
            return "No Data Available"
        case .temporal:
            return "No Events"
        case .hierarchical:
            return "No Items"
        case .collection:
            return "No Items"
        case .generic:
            return "No Items"
        case .text:
            return "No Text Content"
        case .number:
            return "No Numbers"
        case .date:
            return "No Dates"
        case .image:
            return "No Images"
        case .boolean:
            return "No Boolean Values"
        case .list:
            return "No List Items"
        case .grid:
            return "No Grid Items"
        case .chart:
            return "No Chart Data"
        case .action:
            return "No Actions"
        case .product:
            return "No Products"
        case .user:
            return "No Users"
        case .transaction:
            return "No Transactions"
        case .communication:
            return "No Messages"
        case .location:
            return "No Locations"
        case .custom:
            return "No Items"
        case .card:
            return "No Cards"
        case .detail:
            return "No Details"
        case .modal:
            return "No Modal Content"
        case .sheet:
            return "No Sheet Content"
        }
    }
    
    private var emptyStateMessage: String {
        let contextMessage = contextSpecificMessage
        let complexityMessage = complexitySpecificMessage
        
        if !contextMessage.isEmpty && !complexityMessage.isEmpty {
            return "\(contextMessage) \(complexityMessage)"
        } else if !contextMessage.isEmpty {
            return contextMessage
        } else if !complexityMessage.isEmpty {
            return complexityMessage
        } else {
            return "This collection is currently empty."
        }
    }
    
    private var contextSpecificMessage: String {
        switch hints.context {
        case .dashboard:
            return "Add some items to get started."
        case .detail:
            return "No additional items to display."
        case .summary:
            return "No summary data available."
        case .edit:
            return "No items to edit."
        case .create:
            return "Create your first item."
        case .search:
            return "Try adjusting your search criteria."
        case .browse:
            return "No items to browse."
        case .list:
            return "No items in this list."
        case .form:
            return "No form fields available."
        case .modal:
            return "Select an item to continue."
        case .navigation:
            return "No navigation items available."
        case .settings:
            return "No settings available."
        case .profile:
            return "No profile information available."
        }
    }
    
    private var complexitySpecificMessage: String {
        switch hints.complexity {
        case .simple:
            return "Keep it simple and focused."
        case .moderate:
            return "Consider organizing your content."
        case .complex:
            return "Use filters or categories to manage complexity."
        case .veryComplex:
            return "Use advanced filtering and organization tools."
        case .advanced:
            return "Use expert-level tools and configurations."
        }
    }
    
    private var createButtonTitle: String {
        switch hints.dataType {
        case .media:
            return "Add Media"
        case .navigation:
            return "Add Navigation Item"
        case .form:
            return "Add Form Field"
        case .numeric:
            return "Add Data"
        case .temporal:
            return "Add Event"
        case .hierarchical:
            return "Add Item"
        case .collection:
            return "Add Item"
        case .generic:
            return "Add Item"
        case .text:
            return "Add Text"
        case .number:
            return "Add Number"
        case .date:
            return "Add Date"
        case .image:
            return "Add Image"
        case .boolean:
            return "Add Boolean"
        case .list:
            return "Add List Item"
        case .grid:
            return "Add Grid Item"
        case .chart:
            return "Add Chart Data"
        case .action:
            return "Add Action"
        case .product:
            return "Add Product"
        case .user:
            return "Add User"
        case .transaction:
            return "Add Transaction"
        case .communication:
            return "Add Message"
        case .location:
            return "Add Location"
        case .custom:
            return "Add Item"
        case .card:
            return "Add Card"
        case .detail:
            return "Add Detail"
        case .modal:
            return "Add Modal"
        case .sheet:
            return "Add Sheet"
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
    let onSubmit: (([String: String]) -> Void)?
    let onReset: (() -> Void)?
    
    @State private var validationErrors: [String: String] = [:]
    @State private var isSubmitting = false
    
    public init(
        fields: [GenericFormField],
        hints: PresentationHints,
        onSubmit: (([String: String]) -> Void)? = nil,
        onReset: (() -> Void)? = nil
    ) {
        self.fields = fields
        self.hints = hints
        self.onSubmit = onSubmit
        self.onReset = onReset
    }
    
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
            GenericFormField(label: "Text Content", placeholder: "Enter text content", value: .constant(""), fieldType: .text)
        ]
    case .number:
        return [
            GenericFormField(label: "Numeric Value", placeholder: "Enter number", value: .constant(""), fieldType: .number)
        ]
    case .date:
        return [
            GenericFormField(label: "Date", placeholder: "Select date", value: .constant(""), fieldType: .date)
        ]
    case .boolean:
        return [
            GenericFormField(label: "Boolean Value", placeholder: "Toggle value", value: .constant(""), fieldType: .checkbox)
        ]
    case .collection:
        return [
            GenericFormField(label: "Collection Name", placeholder: "Enter collection name", value: .constant(""), fieldType: .text),
            GenericFormField(label: "Item Count", placeholder: "Enter item count", value: .constant(""), fieldType: .number)
        ]
    case .hierarchical:
        return [
            GenericFormField(label: "Root Name", placeholder: "Enter root name", value: .constant(""), fieldType: .text),
            GenericFormField(label: "Level Count", placeholder: "Enter hierarchy levels", value: .constant(""), fieldType: .number)
        ]
    case .temporal:
        return [
            GenericFormField(label: "Start Date", placeholder: "Select start date", value: .constant(""), fieldType: .date),
            GenericFormField(label: "Start Time", placeholder: "Select start time", value: .constant(""), fieldType: .time),
            GenericFormField(label: "End Date", placeholder: "Select end date", value: .constant(""), fieldType: .date),
            GenericFormField(label: "End Time", placeholder: "Select end time", value: .constant(""), fieldType: .time)
        ]
    case .media:
        return [
            GenericFormField(label: "Media Title", placeholder: "Enter media title", value: .constant(""), fieldType: .text),
            GenericFormField(label: "Media File", placeholder: "Upload media file", value: .constant(""), fieldType: .file),
            GenericFormField(label: "Media Type", placeholder: "Enter media type", value: .constant(""), fieldType: .text)
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
            GenericFormField(label: "Dashboard Name", placeholder: "Enter dashboard name", value: .constant(""), fieldType: .text),
            GenericFormField(label: "Auto Refresh", placeholder: "Enable auto refresh", value: .constant(""), fieldType: .checkbox)
        ]
    case .detail:
        return [
            GenericFormField(label: "Title", placeholder: "Enter title", value: .constant(""), fieldType: .text),
            GenericFormField(label: "Description", placeholder: "Enter description", value: .constant(""), fieldType: .richtext),
            GenericFormField(label: "Created Date", placeholder: "Select creation date", value: .constant(""), fieldType: .date),
            GenericFormField(label: "Created Time", placeholder: "Select creation time", value: .constant(""), fieldType: .time),
            GenericFormField(label: "Attachments", placeholder: "Upload attachments", value: .constant(""), fieldType: .file)
        ]
    case .form:
        return [
            GenericFormField(label: "Name", placeholder: "Enter name", value: .constant(""), fieldType: .text),
            GenericFormField(label: "Email", placeholder: "Enter email", value: .constant(""), fieldType: .email),
            GenericFormField(label: "Age", placeholder: "Enter age", value: .constant(""), fieldType: .number),
            GenericFormField(label: "Birth Date", placeholder: "Select birth date", value: .constant(""), fieldType: .date),
            GenericFormField(label: "Country", placeholder: "Select country", value: .constant(""), fieldType: .autocomplete),
            GenericFormField(label: "Bio", placeholder: "Enter bio", value: .constant(""), fieldType: .richtext),
            GenericFormField(label: "Profile Photo", placeholder: "Upload profile photo", value: .constant(""), fieldType: .file),
            GenericFormField(label: "Subscribe", placeholder: "Subscribe to updates", value: .constant(""), fieldType: .checkbox)
        ]
    case .list:
        return [
            GenericFormField(label: "List Name", placeholder: "Enter list name", value: .constant(""), fieldType: .text),
            GenericFormField(label: "Sort Order", placeholder: "Enter sort order", value: .constant(""), fieldType: .text)
        ]
    case .modal:
        return [
            GenericFormField(label: "Modal Title", placeholder: "Enter modal title", value: .constant(""), fieldType: .text),
            GenericFormField(label: "Modal Content", placeholder: "Enter modal content", value: .constant(""), fieldType: .textarea)
        ]
    default:
        return [
            GenericFormField(label: "Title", placeholder: "Enter title", value: .constant(""), fieldType: .text),
            GenericFormField(label: "Value", placeholder: "Enter value", value: .constant(""), fieldType: .text)
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

// MARK: - Generic Content View

/// Generic content view for runtime-unknown content types
/// 
/// **Use Case**: Only for cases where content type is unknown at compile time.
/// This view analyzes content type at runtime and delegates to appropriate
/// specific functions, with a fallback for truly unknown content types.
public struct GenericContentView: View {
    let content: Any
    let hints: PresentationHints
    
    public var body: some View {
        // Analyze content type and delegate to appropriate function
        if let formFields = content as? [GenericFormField] {
            // Delegate to form function
            return AnyView(platformPresentFormData_L1(fields: formFields, hints: hints))
        } else if let mediaItems = content as? [GenericMediaItem] {
            // Delegate to media function
            return AnyView(platformPresentMediaData_L1(media: mediaItems, hints: hints))
        } else if let numericData = content as? [GenericNumericData] {
            // Delegate to numeric function
            return AnyView(platformPresentNumericData_L1(data: numericData, hints: hints))
        } else if let hierarchicalItems = content as? [GenericHierarchicalItem] {
            // Delegate to hierarchical function
            return AnyView(platformPresentHierarchicalData_L1(items: hierarchicalItems, hints: hints))
        } else if let temporalItems = content as? [GenericTemporalItem] {
            // Delegate to temporal function
            return AnyView(platformPresentTemporalData_L1(items: temporalItems, hints: hints))
        } else if isIdentifiableArray(content) {
            // Handle any identifiable array by converting to GenericDataItem
            let items = convertToGenericDataItems(content)
            return AnyView(platformPresentItemCollection_L1(items: items, hints: hints))
        } else {
            // Fallback to generic presentation
            return AnyView(GenericFallbackView(content: content, hints: hints))
        }
    }
    
    /// Check if content is an array of identifiable items
    private func isIdentifiableArray(_ content: Any) -> Bool {
        // Check if it's an array and if the first element conforms to Identifiable
        if let array = content as? [Any], !array.isEmpty {
            return array.first is any Identifiable
        }
        return false
    }
    
    /// Convert any identifiable array to GenericDataItem array
    private func convertToGenericDataItems(_ content: Any) -> [GenericDataItem] {
        guard let array = content as? [Any] else { return [] }
        
        return array.compactMap { item in
            if let identifiable = item as? any Identifiable {
                // Try to extract title and subtitle from common properties
                let mirror = Mirror(reflecting: identifiable)
                var title = "Item"
                var subtitle: String? = nil
                var data: [String: Any] = [:]
                
                for child in mirror.children {
                    if let label = child.label {
                        data[label] = child.value
                        
                        // Common property mappings
                        if label == "name" || label == "title" {
                            if let stringValue = child.value as? String {
                                title = stringValue
                            }
                        } else if label == "description" || label == "subtitle" {
                            if let stringValue = child.value as? String {
                                subtitle = stringValue
                            }
                        }
                    }
                }
                
                return GenericDataItem(title: title, subtitle: subtitle, data: data)
            }
            return nil
        }
    }
}

/// Fallback view for unknown content types
private struct GenericFallbackView: View {
    let content: Any
    let hints: PresentationHints
    
    var body: some View {
        VStack {
            Image(systemName: "doc.text")
                .font(.largeTitle)
                .foregroundColor(.secondary)
            
            Text("Content")
                .font(.headline)
            
            Text("Type: \(String(describing: type(of: content)))")
                .font(.caption)
                .foregroundColor(.secondary)
            
            if let stringContent = content as? String {
                Text(stringContent)
                    .padding()
                    .background(Color.secondary.opacity(0.1))
                    .cornerRadius(8)
            } else if let dictContent = content as? [String: Any] {
                VStack(alignment: .leading) {
                    ForEach(Array(dictContent.keys.sorted()), id: \.self) { key in
                        HStack {
                            Text("\(key):")
                                .fontWeight(.medium)
                            Text("\(String(describing: dictContent[key] ?? "nil"))")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding()
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(8)
            } else {
                Text("Unknown content type")
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color.primary.opacity(0.05))
        .cornerRadius(12)
    }
}
