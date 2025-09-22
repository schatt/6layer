# Developer Extension Guide for 6layer Framework

## Overview

This guide explains how developers can extend the 6layer framework to integrate their custom views, business logic, and unique functionality while leveraging the framework's intelligent platform adaptation and performance optimization capabilities.

## Table of Contents

1. [Quick Start](#quick-start)
2. [Extension Mechanisms](#extension-mechanisms)
3. [Custom Hints System](#custom-hints-system)
4. [Integration Patterns](#integration-patterns)
5. [Best Practices](#best-practices)
6. [Examples](#examples)
7. [Troubleshooting](#troubleshooting)

## Quick Start

### 1. Import the Framework

```swift
import SixLayerFramework
```

### 2. Create Your Custom View

```swift
struct MyCustomView: View {
    let myData: [MyCustomItem]
    
    var body: some View {
        // Use framework functions to present your data
        platformPresentItemCollection_L1(
            items: myData,
            hints: PresentationHints(
                dataType: .collection,
                presentationPreference: .cards,
                complexity: .moderate,
                context: .dashboard
            )
        )
    }
}
```

### 3. The Framework Handles the Rest

- **Automatic Layout**: Framework analyzes your data and hints to determine optimal presentation
- **Platform Adaptation**: Views automatically adapt to iOS/macOS conventions
- **Performance Optimization**: Framework applies memory and rendering optimizations
- **Responsive Behavior**: Views respond to screen size and device capabilities

## Extension Mechanisms

### 1. Semantic Intent Extension (Layer 1)

Express **what** you want to achieve without worrying about implementation details:

```swift
// Present collections of items
platformPresentItemCollection_L1(items: items, hints: hints)

// Present numeric data
platformPresentNumericData_L1(data: data, hints: hints)

// Present forms
platformPresentFormData_L1(fields: fields, hints: hints)

// Present responsive cards
platformResponsiveCard_L1(content: { MyContent() }, hints: hints)
```

### 2. Custom Hints System

The most powerful extension mechanism - create custom hints that influence framework decisions:

```swift
class MyAppHint: CustomHint {
    init(
        showAdvancedFeatures: Bool = false,
        theme: String = "default",
        customBehavior: String = "standard"
    ) {
        super.init(
            hintType: "myapp.custom",
            priority: .high,
            overridesDefault: false,
            customData: [
                "showAdvancedFeatures": showAdvancedFeatures,
                "theme": theme,
                "customBehavior": customBehavior,
                "recommendedLayout": "adaptive",
                "animationStyle": "smooth"
            ]
        )
    }
}
```

### 3. Direct Component Usage (Layer 4)

Use framework components directly in your custom views:

```swift
struct MyCustomDashboard: View {
    var body: some View {
        platformCardGrid(columns: 3, spacing: 16) {
            ForEach(items) { item in
                MyCustomCard(item: item)
                    .platformCardStyle(
                        backgroundColor: .systemBackground,
                        cornerRadius: 12,
                        shadowRadius: 4
                    )
            }
        }
        .platformCardPadding()
    }
}
```

### 4. Progressive Enhancement

Combine multiple layers for advanced functionality:

```swift
struct MyComplexView: View {
    var body: some View {
        platformResponsiveCard_L1(
            content: { MyCustomContent() },
            hints: hints
        )
        .platformMemoryOptimization()        // Layer 5
        .platformRenderingOptimization()     // Layer 5
        #if os(macOS)
        .platformMacOSWindowResizing(resizable: true)  // Layer 6
        #endif
    }
}
```

## Custom Hints System

### Understanding Hints

Hints are the communication mechanism between your app and the framework:

```swift
public struct PresentationHints: Sendable {
    public let dataType: DataTypeHint           // What type of data
    public let presentationPreference: PresentationPreference  // Preferred layout
    public let complexity: ContentComplexity    // Content complexity level
    public let context: PresentationContext     // Display context
    public let customPreferences: [String: String]  // Basic extensibility
}
```

### Enhanced Hints for Advanced Extensibility

```swift
public struct EnhancedPresentationHints: Sendable {
    // ... basic hints ...
    public let extensibleHints: [ExtensibleHint]  // Custom hint types
}
```

### Creating Custom Hint Types

```swift
// 1. Inherit from CustomHint
class EcommerceProductHint: CustomHint {
    init(
        category: String,
        showPricing: Bool = true,
        showReviews: Bool = true,
        layoutStyle: String = "grid"
    ) {
        super.init(
            hintType: "ecommerce.product",
            priority: .high,
            overridesDefault: false,
            customData: [
                "category": category,
                "showPricing": showPricing,
                "showReviews": showReviews,
                "layoutStyle": layoutStyle,
                "recommendedColumns": 3,
                "showWishlist": true,
                "quickViewEnabled": true
            ]
        )
    }
}

// 2. Use in your views
let hints = EnhancedPresentationHints(
    dataType: .collection,
    presentationPreference: .automatic,
    complexity: .moderate,
    context: .browse,
    extensibleHints: [
        EcommerceProductHint(
            category: "electronics",
            showPricing: true,
            showReviews: true
        )
    ]
)
```

### Hint Priority Levels

```swift
.priority = .low      // Can be overridden by framework
.priority = .normal   // Standard preferences
.priority = .high     // Important preferences
.priority = .critical // Must be respected by framework
```

## Integration Patterns

### 1. Data Model Integration

Ensure your models conform to required protocols:

```swift
struct MyCustomItem: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let description: String
    let category: String
    
    // Framework will use these properties for layout decisions
    var estimatedComplexity: ContentComplexity {
        if description.count > 100 { return .complex }
        if description.count > 50 { return .moderate }
        return .simple
    }
}
```

### 2. Custom Hint Factories

Create reusable hint patterns for your app:

```swift
extension EnhancedPresentationHints {
    /// Create hints optimized for your app's dashboard
    static func forMyAppDashboard(
        section: String,
        showAdvancedMetrics: Bool = true,
        layoutStyle: String = "adaptive"
    ) -> EnhancedPresentationHints {
        let dashboardHint = CustomHint(
            hintType: "myapp.dashboard",
            priority: .high,
            overridesDefault: false,
            customData: [
                "section": section,
                "showAdvancedMetrics": showAdvancedMetrics,
                "layoutStyle": layoutStyle,
                "recommendedColumns": 2,
                "showQuickActions": true,
                "refreshInterval": 30
            ]
        )
        
        return EnhancedPresentationHints(
            dataType: .collection,
            presentationPreference: .automatic,
            complexity: .moderate,
            context: .dashboard,
            extensibleHints: [dashboardHint]
        )
    }
}
```

### 3. Conditional Framework Usage

Adapt framework usage based on your app's needs:

```swift
struct MyAdaptiveView: View {
    let useFramework: Bool
    let items: [MyItem]
    
    var body: some View {
        if useFramework {
            // Use framework for intelligent layout
            platformPresentItemCollection_L1(
                items: items,
                hints: EnhancedPresentationHints.forMyAppDashboard(
                    section: "main",
                    showAdvancedMetrics: true
                )
            )
        } else {
            // Fallback to custom implementation
            MyCustomLayout(items: items)
        }
    }
}
```

## Best Practices

### 1. Naming Conventions

```swift
// Use reverse domain notation for hint types
hintType: "com.mycompany.myapp.feature"

// Use descriptive names for custom data keys
customData: [
    "showAdvancedFeatures": true,      // ✅ Clear and descriptive
    "adv": true                        // ❌ Too cryptic
]
```

### 2. Hint Design

```swift
// ✅ Good: Provide meaningful guidance
customData: [
    "recommendedColumns": 3,
    "preferredAnimation": "smooth",
    "estimatedComplexity": "moderate"
]

// ❌ Avoid: Overly specific or rigid constraints
customData: [
    "forceColumns": 3,                 // Too rigid
    "exactWidth": 300                  // Too specific
]
```

### 3. Performance Considerations

```swift
// Use appropriate complexity levels
let hints = PresentationHints(
    dataType: .collection,
    presentationPreference: .automatic,
    complexity: .simple,  // Start simple, let framework optimize
    context: .dashboard
)

// Apply performance optimizations when needed
MyHeavyView()
    .platformMemoryOptimization()
    .platformRenderingOptimization()
```

### 4. Platform Awareness

```swift
// Let framework handle platform differences
let hints = PresentationHints(
    dataType: .collection,
    presentationPreference: .automatic,  // Let framework decide
    complexity: .moderate,
    context: .dashboard
)

// Or specify platform-specific preferences
#if os(iOS)
let platformHints = CustomHint(
    hintType: "ios.specific",
    customData: ["preferredSpacing": 16]
)
#elseif os(macOS)
let platformHints = CustomHint(
    hintType: "macos.specific",
    customData: ["preferredSpacing": 20]
)
#endif
```

## Examples

### Example 1: E-commerce Product Catalog

```swift
struct ProductCatalogView: View {
    let products: [Product]
    
    var body: some View {
        let hints = EnhancedPresentationHints(
            dataType: .collection,
            presentationPreference: .grid,
            complexity: .moderate,
            context: .browse,
            extensibleHints: [
                EcommerceProductHint(
                    category: "electronics",
                    showPricing: true,
                    showReviews: true,
                    layoutStyle: "masonry"
                )
            ]
        )
        
        return platformPresentItemCollection_L1(
            items: products,
            hints: hints
        )
        .navigationTitle("Products")
        .platformMemoryOptimization()
    }
}
```

### Example 2: Financial Dashboard

```swift
struct FinancialDashboardView: View {
    let financialData: [FinancialMetric]
    
    var body: some View {
        let hints = EnhancedPresentationHints.forMyAppDashboard(
            section: "financial",
            showAdvancedMetrics: true,
            layoutStyle: "adaptive"
        )
        
        return platformPresentItemCollection_L1(
            items: financialData,
            hints: hints
        )
        .platformRenderingOptimization()
    }
}
```

### Example 3: Custom Form with Framework Integration

```swift
struct CustomExpenseForm: View {
    @StateObject private var formState = DynamicFormState(configuration: formConfig)
    
    private let formConfig = DynamicFormConfiguration(
        sections: [
            DynamicFormSection(
                id: "expense",
                title: "Expense Details",
                fields: [
                    DynamicFormField(id: "amount", type: .number, label: "Amount"),
                    DynamicFormField(id: "description", type: .text, label: "Description"),
                    DynamicFormField(id: "category", type: .select, label: "Category", options: ["Travel", "Meals", "Office", "Other"])
                ]
            )
        ]
    )
    
    var body: some View {
        VStack(spacing: 20) {
            // Use framework for form presentation with native types
            DynamicFormView(
                configuration: formConfig,
                formState: formState
            )
            
            // Custom submit button
            Button("Submit Expense") {
                // Handle submission - access native types directly
                let amount: Double = formState.getValue(for: "amount") ?? 0.0
                let description: String = formState.getValue(for: "description") ?? ""
                let category: String = formState.getValue(for: "category") ?? ""
                
                // Process form data...
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}
```

**⚠️ Note**: The deprecated `GenericFormField` and `platformPresentFormData_L1` functions have been replaced with `DynamicFormField` and `DynamicFormView` for better type safety and native data type support.

## Troubleshooting

### Common Issues

#### 1. Hints Not Being Processed

```swift
// ✅ Ensure your hints conform to ExtensibleHint protocol
class MyHint: CustomHint {  // Inherit from CustomHint
    // ... implementation
}

// ❌ Don't create custom structs
struct MyHint {  // Won't work with framework
    // ... implementation
}
```

#### 2. Priority Conflicts

```swift
// ✅ Use appropriate priority levels
.priority = .normal  // For standard preferences
.priority = .high    // For important preferences

// ❌ Avoid overusing critical priority
.priority = .critical  // Only when absolutely necessary
```

#### 3. Data Type Mismatches

```swift
// ✅ Use appropriate Swift types
customData: [
    "count": 42,                    // Int
    "enabled": true,                // Bool
    "name": "example",              // String
    "options": ["a", "b", "c"],     // Array
    "config": ["key": "value"]      // Dictionary
]

// ❌ Avoid complex types
customData: [
    "callback": { /* closure */ },  // Won't serialize properly
    "view": MyView()                // Won't work
]
```

### Debugging Tips

```swift
// Check if your hints are being processed
print("Hint count: \(enhancedHints.extensibleHints.count)")
print("Highest priority: \(enhancedHints.highestPriorityHint?.hintType ?? "none")")
print("All custom data: \(enhancedHints.allCustomData)")

// Verify hint processing
let layoutPrefs = HintProcessingEngine.extractLayoutPreferences(from: enhancedHints)
print("Layout preferences: \(layoutPrefs)")
```

### Performance Issues

```swift
// If experiencing performance issues, check complexity levels
let hints = PresentationHints(
    dataType: .collection,
    presentationPreference: .automatic,
    complexity: .simple,  // Start with simple
    context: .dashboard
)

// Apply performance optimizations
MyView()
    .platformMemoryOptimization()
    .platformRenderingOptimization()
```

## Getting Help

### Documentation Resources

- **Architecture Overview**: [README_6LayerArchitecture.md](README_6LayerArchitecture.md)
- **Hints System**: [HintsSystemExtensibility.md](HintsSystemExtensibility.md)
- **Usage Examples**: [README_UsageExamples.md](README_UsageExamples.md)
- **Layer Details**: Individual layer README files

### Framework Functions

Key functions for extension:

- `platformPresentItemCollection_L1()` - Present collections
- `platformPresentNumericData_L1()` - Present numeric data
- `platformPresentFormData_L1()` - Present forms ⚠️ **DEPRECATED** - Use `DynamicFormView` instead
- `platformResponsiveCard_L1()` - Present responsive cards
- `platformCardGrid()` - Grid layout
- `platformCardStyle()` - Card styling
- `platformMemoryOptimization()` - Memory optimization
- `platformRenderingOptimization()` - Rendering optimization

**Form Functions (Recommended):**
- `DynamicFormView()` - Modern form presentation with native types
- `DynamicFormField()` - Form field configuration
- `DynamicFormState()` - Form state management

### Support

- Check the framework source code for implementation details
- Review the stub examples in the `Stubs/` directory
- Test your extensions thoroughly on both iOS and macOS
- Use the debugging tools to verify hint processing

## Conclusion

The 6layer framework provides powerful extension mechanisms that allow you to:

- **Focus on your business logic** while the framework handles platform adaptation
- **Create intelligent layouts** through the hints system
- **Optimize performance** automatically across all layers
- **Maintain consistency** across iOS and macOS platforms
- **Future-proof your code** with automatic framework updates

By following the patterns and best practices outlined in this guide, you can seamlessly integrate your custom views and functionality with the framework's intelligent decision-making engine.

Remember: Start simple with basic hints, then progressively enhance with custom hint types and advanced features as needed. The framework is designed to work with minimal configuration while providing powerful customization options for advanced use cases.
