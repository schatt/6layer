import SwiftUI

// MARK: - Layer 1: Semantic Intent - Data Type Recognition
// This layer is completely platform and project agnostic
// It recognizes data types and uses hints to guide presentation decisions

// MARK: - Hints System

/// Data type hints that guide generic functions
public enum DataTypeHint: String, CaseIterable, Sendable {
    case generic          // Unknown or mixed data types
    case vehicle          // Vehicle-related data
    case fuelRecord       // Fuel consumption records
    case expense          // Financial expense records
    case maintenance      // Vehicle maintenance records
    case achievement      // User achievement records
    case location         // Location-based data
    case notification     // Notification data
    case userProfile      // User profile information
    case settings         // Application settings
    case media            // Images, videos, documents
    case numeric          // Charts, graphs, statistics
    case hierarchical     // Tree structures, nested data
    case temporal         // Time-based data, schedules
}

/// Presentation preference hints
public enum PresentationPreference: String, CaseIterable, Sendable {
    case automatic        // Let the system decide
    case cards           // Card-based layout
    case list            // List-based layout
    case grid            // Grid-based layout
    case coverFlow       // Cover flow layout
    case masonry         // Masonry/pinterest layout
    case table           // Table-based layout
    case chart           // Chart/graph layout
    case form            // Form-based layout
}

// ContentComplexity is defined in PlatformStrategySelectionLayer3.swift

/// Presentation context
public enum PresentationContext: String, CaseIterable, Sendable {
    case dashboard       // Overview/summary view
    case detail          // Detailed item view
    case summary         // Summary/compact view
    case edit            // Editing interface
    case create          // Creation interface
    case search          // Search results
    case browse          // Browsing interface
}

/// Comprehensive hints structure for guiding generic functions
public struct PresentationHints: Sendable {
    public let dataType: DataTypeHint
    public let presentationPreference: PresentationPreference
    public let complexity: ContentComplexity
    public let context: PresentationContext
    public let customPreferences: [String: String]  // Changed to String: String for Sendable
    
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

// ContentComplexity is defined in PlatformStrategySelectionLayer3.swift

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

// MARK: - Responsive Card Semantic Intent

/// Express intent for responsive card layout
/// Layer 1: Semantic Intent
@MainActor
public func platformResponsiveCard_L1<Content: View>(
    type: CardType,
    content: @escaping () -> Content
) -> some View {
    // Delegate to Layer 2 for layout decisions
    return ResponsiveCardContainer(type: type, content: content)
}

// Note: platformNavigationSplitContainer implementation moved to PlatformSpecificViewExtensions.swift
// to consolidate with existing platform-specific logic and avoid naming conflicts

/// Card type enumeration for semantic intent
public enum CardType: String, CaseIterable, Sendable {
    case dashboard    // Dashboard-style cards
    case detail       // Detail view cards
    case summary      // Summary information cards
    case action       // Action-oriented cards
    case media        // Media-rich cards
    case gallery      // Gallery/masonry layout
    case content      // General content cards
}

/// Container view that implements the responsive card architecture
private struct ResponsiveCardContainer<Content: View>: View {
    let type: CardType
    let content: () -> Content
    
    var body: some View {
        content()
            .environment(\.cardType, type)
    }
}

// MARK: - Environment Values

private struct CardTypeKey: EnvironmentKey {
    static let defaultValue: CardType = .dashboard
}

extension EnvironmentValues {
    var cardType: CardType {
        get { self[CardTypeKey.self] }
        set { self[CardTypeKey.self] = newValue }
    }
}

/// Generic function for presenting form fields
@MainActor
public func platformPresentFormFields_L1(
    fields: [GenericFormField],
    hints: PresentationHints
) -> some View {
    return GenericFormFieldsView(fields: fields, hints: hints)
}

/// Generic function for presenting hierarchical data
@MainActor
public func platformPresentHierarchicalData_L1(
    data: [GenericHierarchicalItem],
    hints: PresentationHints
) -> some View {
    return GenericHierarchicalDataView(data: data, hints: hints)
}

/// Generic function for presenting media collections
@MainActor
public func platformPresentMediaCollection_L1(
    media: [GenericMediaItem],
    hints: PresentationHints
) -> some View {
    return GenericMediaCollectionView(media: media, hints: hints)
}

/// Generic function for presenting temporal data
@MainActor
public func platformPresentTemporalData_L1(
    data: [GenericTemporalItem],
    hints: PresentationHints
) -> some View {
    return GenericTemporalDataView(data: data, hints: hints)
}

// MARK: - Project-Specific Hint Creators

/// CarManager-specific hint creators that provide domain knowledge
public extension PresentationHints {
    
    /// Hints for vehicle collections
    static func forVehicles(
        items: [GenericVehicle],
        context: PresentationContext = .dashboard
    ) -> PresentationHints {
        let complexity: ContentComplexity = items.count > 10 ? .complex :
                                         items.count > 5 ? .moderate : .simple
        
        return PresentationHints(
            dataType: DataTypeHint.vehicle,
            presentationPreference: PresentationPreference.cards,  // Vehicles look better as cards
            complexity: complexity,
            context: context,
            customPreferences: [
                "showImages": "true",
                "showDetails": String(context == .detail),
                "compactMode": String(context == .summary)
            ]
        )
    }
    
    /// Hints for fuel record collections
    static func forFuelRecords(
        items: [GenericFuelRecord],
        context: PresentationContext = .dashboard
    ) -> PresentationHints {
        let complexity: ContentComplexity = items.count > 20 ? .complex :
                                         items.count > 10 ? .moderate : .simple
        
        return PresentationHints(
            dataType: DataTypeHint.fuelRecord,
            presentationPreference: PresentationPreference.list,  // Fuel records work well as lists
            complexity: complexity,
            context: context,
            customPreferences: [
                "showCharts": String(context == .dashboard),
                "groupByMonth": "true",
                "showEfficiency": "true"
            ]
        )
    }
    
    /// Hints for expense collections
    static func forExpenses(
        items: [GenericExpense],
        context: PresentationContext = .dashboard
    ) -> PresentationHints {
        let complexity: ContentComplexity = items.count > 15 ? .complex :
                                         items.count > 8 ? .moderate : .simple
        
        return PresentationHints(
            dataType: DataTypeHint.expense,
            presentationPreference: PresentationPreference.grid,  // Expenses work well in grids
            complexity: complexity,
            context: context,
            customPreferences: [
                "showCategories": "true",
                "showTotals": String(context == .dashboard),
                "groupByType": "true"
            ]
        )
    }
    
    /// Hints for maintenance collections
    static func forMaintenance(
        items: [GenericMaintenance],
        context: PresentationContext = .dashboard
    ) -> PresentationHints {
        let complexity: ContentComplexity = items.count > 12 ? .complex :
                                         items.count > 6 ? .moderate : .simple
        
        return PresentationHints(
            dataType: DataTypeHint.maintenance,
            presentationPreference: PresentationPreference.cards,  // Maintenance looks good as cards
            complexity: complexity,
            context: context,
            customPreferences: [
                "showDueDates": "true",
                "showStatus": "true",
                "groupByPriority": "true"
            ]
        )
    }
}

// MARK: - Generic View Implementations

/// Generic item collection view that uses hints to determine layout
private struct GenericItemCollectionView<Item: Identifiable>: View {
    let items: [Item]
    let hints: PresentationHints
    
    var body: some View {
        // This view will delegate to Layer 2 for layout decisions
        // based on the hints provided
        Text("Generic Item Collection - \(items.count) items")
            .onAppear {
                // Delegate to Layer 2 for layout decision
                let layoutDecision = determineOptimalLayout(for: hints)
                // Delegate to Layer 3 for platform strategy
                _ = selectPlatformStrategy(for: layoutDecision)
                // Delegate to Layer 4 for component building
                // (This will be implemented in the actual layer system)
            }
    }
    
    private func determineOptimalLayout(for hints: PresentationHints) -> GenericLayoutDecision {
        // This will call Layer 2 functions
        return GenericLayoutDecision() // Placeholder
    }
    
    private func selectPlatformStrategy(for decision: GenericLayoutDecision) -> GenericPlatformStrategy {
        // This will call Layer 3 functions
        return GenericPlatformStrategy() // Placeholder
    }
}

// MARK: - Generic Views for Other Data Types

private struct GenericNumericDataView: View {
    let data: [GenericNumericData]
    let hints: PresentationHints
    
    var body: some View {
        Text("Numeric Data View - \(data.count) items")
    }
}

private struct GenericFormFieldsView: View {
    let fields: [GenericFormField]
    let hints: PresentationHints
    
    var body: some View {
        Text("Form Fields View - \(fields.count) fields")
    }
}

private struct GenericHierarchicalDataView: View {
    let data: [GenericHierarchicalItem]
    let hints: PresentationHints
    
    var body: some View {
        Text("Hierarchical Data View - \(data.count) items")
    }
}

private struct GenericMediaCollectionView: View {
    let media: [GenericMediaItem]
    let hints: PresentationHints
    
    var body: some View {
        Text("Media Collection View - \(media.count) items")
    }
}

private struct GenericTemporalDataView: View {
    let data: [GenericTemporalItem]
    let hints: PresentationHints
    
    var body: some View {
        Text("Temporal Data View - \(data.count) items")
    }
}

// MARK: - Placeholder Types (will be defined in other layers)

private struct GenericLayoutDecision {}
private struct GenericPlatformStrategy {}

// Generic data types for Layer 1 functions
public struct GenericNumericData {
    public let value: Double
    public let label: String
    
    public init(value: Double, label: String) {
        self.value = value
        self.label = label
    }
}

public struct GenericFormField {
    public let id: String
    public let label: String
    public let type: String
    
    public init(id: String, label: String, type: String) {
        self.id = id
        self.label = label
        self.type = type
    }
}

public struct GenericHierarchicalItem {
    public let id: String
    public let title: String
    public let children: [GenericHierarchicalItem]
    
    public init(id: String, title: String, children: [GenericHierarchicalItem] = []) {
        self.id = id
        self.title = title
        self.children = children
    }
}

public struct GenericMediaItem {
    public let id: String
    public let url: String
    public let type: String
    
    public init(id: String, url: String, type: String) {
        self.id = id
        self.url = url
        self.type = type
    }
}

public struct GenericTemporalItem {
    public let id: String
    public let date: Date
    public let title: String
    
    public init(id: String, date: Date, title: String) {
        self.id = id
        self.date = date
        self.title = title
    }
}

// Generic project-specific types
public struct GenericVehicle {
    public let id: String
    public let name: String
    public let make: String
    public let model: String
    
    public init(id: String, name: String, make: String, model: String) {
        self.id = id
        self.name = name
        self.make = make
        self.model = model
    }
}

public struct GenericFuelRecord {
    public let id: String
    public let date: Date
    public let gallons: Double
    public let cost: Double
    
    public init(id: String, date: Date, gallons: Double, cost: Double) {
        self.id = id
        self.date = date
        self.gallons = gallons
        self.cost = cost
    }
}

public struct GenericExpense {
    public let id: String
    public let date: Date
    public let amount: Double
    public let category: String
    
    public init(id: String, date: Date, amount: Double, category: String) {
        self.id = id
        self.date = date
        self.amount = amount
        self.category = category
    }
}

public struct GenericMaintenance {
    public let id: String
    public let date: Date
    public let type: String
    public let cost: Double
    
    public init(id: String, date: Date, type: String, cost: Double) {
        self.id = id
        self.date = date
        self.type = type
        self.cost = cost
    }
}

// MARK: - Migration Phase: Temporary Type-Specific Layer 1 Functions
// These functions provide immediate value during migration while building toward
// the full intelligent six-layer system. They will be consolidated into generic
// functions once the system is mature.

extension View {
    /// Temporary Layer 1 function for fuel purchase forms during migration
    /// This provides immediate domain-specific logic while building the intelligent system
    @MainActor
    func platformPresentFuelPurchaseForm_L1(
        vehicle: Any, // Generic vehicle type for now
        context: PresentationContext = .create
    ) -> some View {
        // Call the type-specific Layer 2 function
        let layout = determineOptimalFormLayout_AddFuelView_L2()
        let strategy = selectFormStrategy_AddFuelView_L3(layout: layout)
        return platformFormContainer_AddFuelView_L4(strategy: strategy)
    }

    /// Temporary Layer 1 function for Add Vehicle form presentation during migration
    /// Handles iOS Form rendering issues by choosing optimal container strategy
    @MainActor
    func platformPresentVehicleForm_L1<Content: View>(
        @ViewBuilder formContent: @escaping () -> Content
    ) -> some View {
        // Create hints for vehicle form presentation
        let hints = PresentationHints(
            dataType: .vehicle,
            presentationPreference: .form,
            complexity: .complex, // 15+ fields across 4 sections
            context: .create,
            customPreferences: [
                "hasImagePicker": "true",
                "hasDatePickers": "true", 
                "hasCurrencyFields": "true",
                "sectionCount": "4"
            ]
        )
        
        // Delegate to Layer 2 for content analysis (not platform detection!)
        let layout = determineOptimalFormLayout_VehicleForm_L2(hints: hints)
        let strategy = selectFormStrategy_VehicleForm_L3_TEMP(layout: layout) // Use temporary function during migration
        
        // Call Layer 4 to get the actual form container with the provided content
        return platformFormContainer_VehicleForm_L4(strategy: strategy, content: formContent)
    }

    /// Temporary Layer 1 function for modal form presentations during migration
    /// This handles sheet-based form presentations with proper sizing
    @MainActor
    func platformPresentModalForm_L1(
        formType: DataTypeHint,
        context: PresentationContext = .create
    ) -> some View {
        // Call the type-specific Layer 2 function
        let layout = determineOptimalModalLayout_Form_L2(formType: formType)
        let strategy = selectModalStrategy_Form_L3(layout: layout)
        return platformModalContainer_Form_L4(strategy: strategy)
    }
}
