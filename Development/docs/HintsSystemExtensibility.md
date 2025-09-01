# Hints System Extensibility Guide

## Overview

The SixLayer Framework's hints system is designed to be **highly extensible**, allowing framework users to create custom hint types that integrate seamlessly with the framework's intelligent decision-making engine. This guide explains how the system works and how to extend it.

## How the Hints System Works

### 1. **Core Architecture**

The hints system operates across all six layers of the framework:

```
Layer 1: Semantic Intent → Hints are created and passed to the framework
Layer 2: Layout Decision → Hints are analyzed to determine optimal layout
Layer 3: Strategy Selection → Hints guide platform-specific strategy selection
Layer 4: Component Implementation → Hints influence component creation
Layer 5: Platform Optimization → Hints guide platform-specific optimizations
Layer 6: Platform System → Hints influence final platform behavior
```

### 2. **Basic Hints Structure**

```swift
public struct PresentationHints: Sendable {
    public let dataType: DataTypeHint           // What type of data
    public let presentationPreference: PresentationPreference  // Preferred layout
    public let complexity: ContentComplexity    // Content complexity level
    public let context: PresentationContext     // Display context
    public let customPreferences: [String: String]  // Basic extensibility
}
```

### 3. **Enhanced Extensibility**

The framework provides an enhanced hints system that supports custom hint types:

```swift
public struct EnhancedPresentationHints: Sendable {
    // ... basic hints ...
    public let extensibleHints: [ExtensibleHint]  // Custom hint types
}
```

## Creating Custom Hint Types

### **Step 1: Define Your Custom Hint**

```swift
import SixLayerFramework

// Create a custom hint for your specific use case
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

### **Step 2: Use Your Custom Hints**

```swift
// Create enhanced hints with your custom hint
let hints = EnhancedPresentationHints(
    dataType: .collection,
    presentationPreference: .cards,
    complexity: .moderate,
    context: .dashboard,
    extensibleHints: [
        MyAppHint(
            showAdvancedFeatures: true,
            theme: "dark",
            customBehavior: "enhanced"
        )
    ]
)

// Use the hints with framework functions
platformPresentItemCollection_L1(
    items: myItems,
    hints: hints
)
```

## Advanced Extensibility Patterns

### **Pattern 1: Domain-Specific Hint Factories**

```swift
extension EnhancedPresentationHints {
    /// Create hints optimized for e-commerce product catalogs
    static func forEcommerceCatalog(
        category: String,
        showPricing: Bool = true,
        showReviews: Bool = true,
        layoutStyle: String = "grid"
    ) -> EnhancedPresentationHints {
        let ecommerceHint = CustomHint(
            hintType: "ecommerce.catalog",
            priority: .high,
            overridesDefault: false,
            customData: [
                "category": category,
                "showPricing": showPricing,
                "showReviews": showReviews,
                "layoutStyle": layoutStyle,
                "recommendedColumns": 3,
                "showWishlist": true,
                "quickViewEnabled": true,
                "filteringEnabled": true
            ]
        )
        
        return EnhancedPresentationHints(
            dataType: .collection,
            presentationPreference: .grid,
            complexity: .moderate,
            context: .browse,
            extensibleHints: [ecommerceHint]
        )
    }
}
```

### **Pattern 2: Behavior-Overriding Hints**

```swift
// Create hints that override framework defaults
let criticalHints = EnhancedPresentationHints(
    dataType: .numeric,
    presentationPreference: .chart,
    complexity: .complex,
    context: .dashboard,
    extensibleHints: [
        CustomHint(
            hintType: "financial.critical",
            priority: .critical,
            overridesDefault: true,  // This will override framework decisions
            customData: [
                "refreshRate": 5,        // 5-second refresh
                "realTimeUpdates": true,
                "showAlerts": true,
                "exportFormat": "csv",
                "drillDownEnabled": true
            ]
        )
    ]
)
```

### **Pattern 3: Context-Aware Hints**

```swift
extension EnhancedPresentationHints {
    /// Create context-aware hints for different user roles
    static func forUserRole(
        role: UserRole,
        dataType: DataTypeHint,
        context: PresentationContext
    ) -> EnhancedPresentationHints {
        let roleHint = CustomHint(
            hintType: "user.role.\(role.rawValue)",
            priority: .high,
            overridesDefault: false,
            customData: [
                "userRole": role.rawValue,
                "permissions": role.permissions,
                "preferredLayout": role.preferredLayout,
                "showAdvancedFeatures": role.canAccessAdvancedFeatures,
                "customizationLevel": role.customizationLevel
            ]
        )
        
        return EnhancedPresentationHints(
            dataType: dataType,
            presentationPreference: .automatic,
            complexity: .moderate,
            context: context,
            extensibleHints: [roleHint]
        )
    }
}

enum UserRole: String, CaseIterable {
    case viewer, editor, admin, powerUser
    
    var permissions: [String] {
        switch self {
        case .viewer: return ["read"]
        case .editor: return ["read", "write"]
        case .admin: return ["read", "write", "delete"]
        case .powerUser: return ["read", "write", "delete", "configure"]
        }
    }
    
    var preferredLayout: String {
        switch self {
        case .viewer: return "simple"
        case .editor: return "standard"
        case .admin: return "advanced"
        case .powerUser: return "custom"
        }
    }
    
    var canAccessAdvancedFeatures: Bool {
        return self == .admin || self == .powerUser
    }
    
    var customizationLevel: String {
        switch self {
        case .viewer: return "none"
        case .editor: return "basic"
        case .admin: return "advanced"
        case .powerUser: return "full"
        }
    }
}
```

## Real-World Usage Examples

### **Example 1: E-commerce Product Catalog**

```swift
import SixLayerFramework

// Create custom hint for e-commerce products
class EcommerceProductHint: CustomHint {
    init(
        category: String,
        showPricing: Bool = true,
        showReviews: Bool = true,
        layoutStyle: String = "grid"
    ) {
        super.init(
            hintType: "ecommerce.product.\(category)",
            priority: .high,
            overridesDefault: false,
            customData: [
                "category": category,
                "showPricing": showPricing,
                "showReviews": showReviews,
                "layoutStyle": layoutStyle,
                "recommendedColumns": 3,
                "showWishlist": true,
                "quickViewEnabled": true,
                "filteringEnabled": true
            ]
        )
    }
}

// Use in your app
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
                    layoutStyle: "grid"
                )
            ]
        )
        
        return platformPresentItemCollection_L1(
            items: products,
            hints: hints
        )
    }
}
```

### **Example 2: Social Media Feed**

```swift
class SocialFeedHint: CustomHint {
    init(
        contentType: String,
        showInteractions: Bool = true,
        autoPlay: Bool = false
    ) {
        super.init(
            hintType: "social.feed.\(contentType)",
            priority: .normal,
            overridesDefault: false,
            customData: [
                "contentType": contentType,
                "showInteractions": showInteractions,
                "autoPlay": autoPlay,
                "infiniteScroll": true,
                "pullToRefresh": true,
                "showUserAvatars": true,
                "showTimestamps": true
            ]
        )
    }
}

// Use in your app
struct SocialFeedView: View {
    let posts: [Post]
    
    var body: some View {
        let hints = EnhancedPresentationHints(
            dataType: .collection,
            presentationPreference: .list,
            complexity: .moderate,
            context: .browse,
            extensibleHints: [
                SocialFeedHint(
                    contentType: "general",
                    showInteractions: true,
                    autoPlay: false
                )
            ]
        )
        
        return platformPresentItemCollection_L1(
            items: posts,
            hints: hints
        )
    }
}
```

### **Example 3: Financial Dashboard**

```swift
class FinancialDashboardHint: CustomHint {
    init(
        timeRange: String,
        showCharts: Bool = true,
        refreshRate: Int = 60
    ) {
        super.init(
            hintType: "financial.dashboard.\(timeRange)",
            priority: .critical,
            overridesDefault: true, // Financial data needs real-time updates
            customData: [
                "timeRange": timeRange,
                "showCharts": showCharts,
                "refreshRate": refreshRate,
                "realTimeUpdates": true,
                "exportEnabled": true,
                "drillDownEnabled": true
            ]
        )
    }
}

// Use in your app
struct FinancialDashboardView: View {
    let financialData: [FinancialData]
    
    var body: some View {
        let hints = EnhancedPresentationHints(
            dataType: .numeric,
            presentationPreference: .chart,
            complexity: .complex,
            context: .dashboard,
            extensibleHints: [
                FinancialDashboardHint(
                    timeRange: "daily",
                    showCharts: true,
                    refreshRate: 30 // 30-second refresh for financial data
                )
            ]
        )
        
        return platformPresentNumericData_L1(
            data: financialData,
            hints: hints
        )
    }
}
```

### **Example 4: Blog Post List**

```swift
class BlogPostHint: CustomHint {
    init(
        showExcerpts: Bool = true,
        showAuthor: Bool = true,
        showDate: Bool = true
    ) {
        super.init(
            hintType: "blog.posts",
            priority: .normal,
            overridesDefault: false,
            customData: [
                "showExcerpts": showExcerpts,
                "showAuthor": showAuthor,
                "showDate": showDate,
                "layoutStyle": "list",
                "recommendedColumns": 1,
                "showReadMore": true,
                "estimatedReadingTime": true
            ]
        )
    }
}

// Use in your app
struct BlogListView: View {
    let blogPosts: [BlogPost]
    
    var body: some View {
        let hints = EnhancedPresentationHints(
            dataType: .collection,
            presentationPreference: .list,
            complexity: .moderate,
            context: .browse,
            extensibleHints: [
                BlogPostHint(
                    showExcerpts: true,
                    showAuthor: true,
                    showDate: true
                )
            ]
        )
        
        return platformPresentItemCollection_L1(
            items: blogPosts,
            hints: hints
        )
    }
}
```

## Integrating Custom Hints with Framework Decisions

### **Automatic Integration**

The framework automatically processes your custom hints:

```swift
// Your hints are automatically considered in layout decisions
let layoutDecision = determineOptimalLayout_L2(
    items: myItems,
    hints: enhancedHints
)

// The framework will use your custom preferences
if let customColumns = enhancedHints.allCustomData["recommendedColumns"] as? Int {
    // Use your custom column count
}
```

### **Manual Hint Processing**

You can also manually process hints using the `HintProcessingEngine`:

```swift
// Extract specific preferences from your hints
let layoutPreferences = HintProcessingEngine.extractLayoutPreferences(
    from: enhancedHints
)

let performancePreferences = HintProcessingEngine.extractPerformancePreferences(
    from: enhancedHints
)

let accessibilityPreferences = HintProcessingEngine.extractAccessibilityPreferences(
    from: enhancedHints
)

// Use these preferences in your custom logic
if let refreshRate = performancePreferences["refreshRate"] as? Int {
    // Configure refresh rate based on hints
}
```

## Best Practices for Custom Hints

### **1. Naming Conventions**

```swift
// Use reverse domain notation for hint types
hintType: "com.mycompany.myapp.feature"

// Use descriptive names for custom data keys
customData: [
    "showAdvancedFeatures": true,      // ✅ Clear and descriptive
    "adv": true                        // ❌ Too cryptic
]
```

### **2. Priority Management**

```swift
// Use appropriate priority levels
.priority = .low      // For preferences that can be overridden
.priority = .normal   // For standard preferences
.priority = .high     // For important preferences
.priority = .critical // For preferences that must be respected
```

### **3. Data Types**

```swift
// Use appropriate Swift types for custom data
customData: [
    "count": 42,                    // ✅ Int
    "enabled": true,                // ✅ Bool
    "name": "example",              // ✅ String
    "options": ["a", "b", "c"],     // ✅ Array
    "config": ["key": "value"]      // ✅ Dictionary
]
```

### **4. Override Behavior**

```swift
// Only override defaults when absolutely necessary
overridesDefault: false  // ✅ Let framework make decisions
overridesDefault: true   // ❌ Only when you must override
```

## Example: Complete Custom Hint Implementation

```swift
import SixLayerFramework

// MARK: - Custom Hint for Task Management App

class TaskManagementHint: CustomHint {
    init(
        taskType: TaskType,
        showPriority: Bool = true,
        showDueDate: Bool = true,
        groupingStyle: GroupingStyle = .automatic
    ) {
        super.init(
            hintType: "taskmanagement.\(taskType.rawValue)",
            priority: .high,
            overridesDefault: false,
            customData: [
                "taskType": taskType.rawValue,
                "showPriority": showPriority,
                "showDueDate": showDueDate,
                "groupingStyle": groupingStyle.rawValue,
                "recommendedLayout": determineOptimalLayout(for: taskType),
                "showProgress": taskType.supportsProgress,
                "allowDragAndDrop": true,
                "quickActions": taskType.quickActions
            ]
        )
    }
    
    private func determineOptimalLayout(for taskType: TaskType) -> String {
        switch taskType {
        case .simple: return "list"
        case .complex: return "cards"
        case .project: return "kanban"
        case .recurring: return "calendar"
        }
    }
}

enum TaskType: String, CaseIterable {
    case simple, complex, project, recurring
    
    var supportsProgress: Bool {
        return self == .complex || self == .project
    }
    
    var quickActions: [String] {
        switch self {
        case .simple: return ["complete", "edit"]
        case .complex: return ["complete", "edit", "delegate"]
        case .project: return ["complete", "edit", "delegate", "archive"]
        case .recurring: return ["complete", "edit", "reschedule"]
        }
    }
}

enum GroupingStyle: String, CaseIterable {
    case automatic, byPriority, byDueDate, byAssignee, byProject
}

// MARK: - Usage Example

extension EnhancedPresentationHints {
    static func forTaskList(
        taskType: TaskType,
        showPriority: Bool = true,
        showDueDate: Bool = true,
        groupingStyle: GroupingStyle = .automatic
    ) -> EnhancedPresentationHints {
        let taskHint = TaskManagementHint(
            taskType: taskType,
            showPriority: showPriority,
            showDueDate: showDueDate,
            groupingStyle: groupingStyle
        )
        
        return EnhancedPresentationHints(
            dataType: .collection,
            presentationPreference: .automatic, // Let the hint decide
            complexity: .moderate,
            context: .dashboard,
            extensibleHints: [taskHint]
        )
    }
}

// MARK: - Using the Custom Hints

struct TaskListView: View {
    let tasks: [Task]
    
    var body: some View {
        // Create hints for your task list
        let hints = EnhancedPresentationHints.forTaskList(
            taskType: .complex,
            showPriority: true,
            showDueDate: true,
            groupingStyle: .byPriority
        )
        
        // Use the framework with your custom hints
        return platformPresentItemCollection_L1(
            items: tasks,
            hints: hints
        )
    }
}
```

## Troubleshooting Custom Hints

### **Common Issues**

1. **Hints not being processed**: Ensure your hints conform to `ExtensibleHint` protocol
2. **Priority conflicts**: Use appropriate priority levels to avoid conflicts
3. **Data type mismatches**: Ensure custom data uses appropriate Swift types
4. **Override conflicts**: Be careful with `overridesDefault: true`

### **Debugging Tips**

```swift
// Check if your hints are being processed
print("Hint count: \(enhancedHints.extensibleHints.count)")
print("Highest priority: \(enhancedHints.highestPriorityHint?.hintType ?? "none")")
print("All custom data: \(enhancedHints.allCustomData)")

// Verify hint processing
let layoutPrefs = HintProcessingEngine.extractLayoutPreferences(from: enhancedHints)
print("Layout preferences: \(layoutPrefs)")
```

## Conclusion

The SixLayer Framework's hints system provides powerful extensibility while maintaining the framework's intelligent decision-making capabilities. By creating custom hints, you can:

- **Customize behavior** without modifying framework code
- **Integrate domain knowledge** into layout decisions
- **Override framework defaults** when necessary
- **Create reusable hint patterns** for your applications

The system is designed to be both simple for basic use cases and powerful for advanced customization needs.

## Quick Start Checklist

To get started with custom hints:

1. ✅ **Import the framework**: `import SixLayerFramework`
2. ✅ **Create your custom hint class**: Inherit from `CustomHint`
3. ✅ **Define your hint data**: Use the `customData` dictionary
4. ✅ **Set appropriate priority**: Choose from `.low`, `.normal`, `.high`, `.critical`
5. ✅ **Create enhanced hints**: Use `EnhancedPresentationHints` with your custom hints
6. ✅ **Pass to framework functions**: Use `platformPresentItemCollection_L1` etc.
7. ✅ **Test and iterate**: Adjust your hints based on results

Remember: Your custom hints are automatically processed by the framework and can influence layout decisions, performance optimizations, and accessibility features across all six layers!
