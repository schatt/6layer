# Complex Forms Best Practices for AI Agents

**SixLayer Framework v2.8.0+**

This document provides AI agents with best practices for handling complex forms using the SixLayer Framework. It covers when to use the framework, when to use SwiftUI directly, and how to combine both approaches effectively.

## 🎯 Core Principle

**The framework should make simple things simple, not make complex things possible.**

Use the SixLayer Framework for basic forms where it provides value. Use SwiftUI directly for complex forms where you need full control. Don't try to force everything through the framework.

## 📋 Decision Matrix

### ✅ Use SixLayer Framework When:
- **Simple forms** with basic field types (text, number, date, select, toggle)
- **Consistent layouts** across your app
- **Cross-platform consistency** is important
- **Rapid prototyping** of basic forms
- **Form structure** is more important than custom interactions

### ✅ Use SwiftUI Directly When:
- **Complex business logic** (calculations, conditional rendering)
- **Custom UI components** (photo pickers, custom calculators)
- **Platform-specific features** (camera, location services)
- **Complex state management** (multiple interdependent fields)
- **Custom interactions** (gestures, animations, custom layouts)

### ✅ Combine Both When:
- **Mixed complexity** - some sections are simple, others are complex
- **Gradual migration** - start with framework, add custom components
- **Learning curve** - use framework for basic parts while learning SwiftUI

## 🏗️ Approach 1: Composition Over Configuration

**Best for**: Forms with some complex sections mixed with simple ones

### Pattern
```swift
VStack {
    // Framework handles the basic form
    IntelligentFormView.generateForm(
        for: BasicFormData.self,
        initialData: data
    )
    
    // Custom components handle complex logic
    MPGCalculatorView(gallons: $gallons, totalCost: $totalCost)
    
    // More custom components as needed
    PhotoPickerView(selectedImage: $receiptImage)
}
.background(Color.platformBackground)  // 6-layer platform independence
.accentColor(.platformTint)  // 6-layer platform independence
```

### Example: Fuel Purchase Form
```swift
struct FuelPurchaseForm: View {
    @State private var basicData = BasicFormData()
    @State private var gallons: Double = 0
    @State private var totalCost: Double = 0
    @State private var receiptImage: UIImage?
    
    var body: some View {
        VStack {
            // Framework handles basic fields
            IntelligentFormView.generateForm(
                for: BasicFormData.self,
                initialData: basicData
            )
            
            // Custom components for complex logic
            if basicData.isFillUp {
                MPGCalculatorView(
                    gallons: $gallons,
                    totalCost: $totalCost
                )
            }
            
            // Custom photo picker
            PhotoPickerView(selectedImage: $receiptImage)
        }
        .background(Color.platformBackground)  // 6-layer platform independence
        .accentColor(.platformTint)  // 6-layer platform independence
    }
}
```

### Benefits
- ✅ **Simple** - no complex injection system
- ✅ **Clear** - obvious what's framework vs custom
- ✅ **Flexible** - can arrange components however you want
- ✅ **Testable** - each component is independent
- ✅ **Platform independent** - leverage 6-layer platform utilities

## 🏗️ Approach 2: Protocol-Based Custom Fields

**Best for**: When you want custom field types that integrate seamlessly with the framework

### Pattern
```swift
// 1. Define custom field type
protocol CustomFieldType {
    func createView(value: Binding<Any>, formState: FormStateManager) -> AnyView
}

// 2. Implement custom field
struct MPGCalculatorField: CustomFieldType {
    func createView(value: Binding<Any>, formState: FormStateManager) -> AnyView {
        AnyView(MPGCalculatorView(
            gallons: formState.binding(for: "gallons"),
            totalCost: formState.binding(for: "totalCost")
        ))
    }
}

// 3. Register with framework
let form = IntelligentFormView.generateForm(
    for: FuelPurchase.self,
    initialData: data,
    customFieldTypes: [
        "mpgCalculator": MPGCalculatorField()
    ]
)
```

### Example: Custom Field Registration
```swift
struct FuelPurchaseForm: View {
    @State private var data = FuelPurchase()
    
    private let customFieldTypes: [String: CustomFieldType] = [
        "mpgCalculator": MPGCalculatorField(),
        "photoPicker": PhotoPickerField(),
        "locationPicker": LocationPickerField()
    ]
    
    var body: some View {
        IntelligentFormView.generateForm(
            for: FuelPurchase.self,
            initialData: data,
            customFieldTypes: customFieldTypes
        )
    }
}
```

### Benefits
- ✅ **Framework integration** - custom fields work like built-in fields
- ✅ **Type-safe** - custom fields are properly typed
- ✅ **Consistent** - same API as built-in fields
- ✅ **Testable** - can test custom field types independently

## 🏗️ Approach 3: View Modifiers for Conditional Logic

**Best for**: Forms with simple conditional rendering

### Pattern
```swift
// Use SwiftUI's built-in conditional rendering
VStack {
    // Framework handles basic form
    IntelligentFormView.generateForm(for: FormData.self, initialData: data)
    
    // Simple conditional rendering
    if condition {
        CustomComponent()
    }
    
    if anotherCondition {
        AnotherCustomComponent()
    }
}
```

### Example: Conditional Form Sections
```swift
struct ExpenseForm: View {
    @State private var data = ExpenseData()
    @State private var showBudgetInfo = false
    
    var body: some View {
        VStack {
            // Basic form from framework
            IntelligentFormView.generateForm(
                for: ExpenseData.self,
                initialData: data
            )
            
            // Conditional sections
            if data.category.hasBudget {
                BudgetInformationView(
                    category: data.category,
                    amount: data.amount
                )
            }
            
            if data.requiresApproval {
                ApprovalWorkflowView(
                    amount: data.amount,
                    category: data.category
                )
            }
        }
    }
}
```

### Benefits
- ✅ **Uses SwiftUI's strengths** - conditional rendering is built-in
- ✅ **No complex state management** - SwiftUI handles it
- ✅ **Readable** - clear what's conditional
- ✅ **Debuggable** - can see the logic flow

## 🏗️ Approach 4: Focused Framework Extensions

**Best for**: When you need to add specific capabilities to the framework

### Pattern
```swift
// Add only what you actually need
struct FormSection {
    let title: String
    let fields: [GenericFormField]
}

// Add specific field types
enum FormFieldType {
    case text, number, date, select, toggle
    case photoPicker    // Just what you need
    case locationPicker // Just what you need
}

// Add simple conditional logic
struct ConditionalField {
    let field: GenericFormField
    let showWhen: (FormState) -> Bool
}
```

### Example: Section-Based Form
```swift
struct MaintenanceForm: View {
    @State private var data = MaintenanceData()
    
    private let sections = [
        FormSection(
            title: "Basic Information",
            fields: [
                .text("title", title: "Title"),
                .date("date", title: "Date"),
                .number("mileage", title: "Mileage")
            ]
        ),
        FormSection(
            title: "Details",
            fields: [
                .textarea("description", title: "Description"),
                .photoPicker("receipt", title: "Receipt Photo"),
                .locationPicker("location", title: "Service Location")
            ]
        )
    ]
    
    var body: some View {
        VStack {
            ForEach(sections, id: \.title) { section in
                VStack(alignment: .leading) {
                    Text(section.title)
                        .font(.headline)
                        .padding(.top)
                    
                    ForEach(section.fields, id: \.id) { field in
                        // Render field using framework
                        FieldView(field: field, data: $data)
                    }
                }
            }
        }
    }
}
```

### Benefits
- ✅ **Targeted** - only adds what's actually needed
- ✅ **Simple** - easy to implement and maintain
- ✅ **Focused** - framework stays focused on its core purpose
- ✅ **Incremental** - can add more features as needed

## 🏗️ Approach 5: Pure SwiftUI with 6-Layer Platform Independence

**Best for**: Very complex forms where the framework adds more complexity than value

### Pattern
```swift
// Use SwiftUI directly but leverage 6-layer platform independence
struct ComplexForm: View {
    @State private var data = ComplexFormData()
    
    var body: some View {
        Form {
            Section("Basic Information") {
                TextField("Title", text: $data.title)
                    .foregroundColor(.platformPrimaryLabel)  // 6-layer platform colors
                DatePicker("Date", selection: $data.date)
                Toggle("Is Required", isOn: $data.isRequired)
            }
            
            if data.isRequired {
                Section("Additional Details") {
                    TextField("Description", text: $data.description, axis: .vertical)
                        .foregroundColor(.platformSecondaryLabel)  // 6-layer platform colors
                    
                    // Custom components with platform independence
                    MPGCalculatorView(
                        gallons: $data.gallons,
                        totalCost: $data.totalCost
                    )
                }
            }
            
            Section("Attachments") {
                PhotoPickerView(selectedImage: $data.receiptImage)
                LocationPickerView(selectedLocation: $data.location)
            }
        }
        .background(Color.platformBackground)  // 6-layer platform colors
        .accentColor(.platformTint)  // 6-layer platform colors
    }
}
```

### Benefits
- ✅ **No framework complexity** - just SwiftUI
- ✅ **Full control** - can do exactly what you want
- ✅ **Easy to understand** - no abstraction layers
- ✅ **Easy to maintain** - standard SwiftUI patterns
- ✅ **Platform independence** - leverages 6-layer platform utilities

## 🎨 Leveraging 6-Layer Platform Independence in SwiftUI

**Important**: Even when using SwiftUI directly for complex forms, you should still leverage the 6-layer framework's platform-independent utilities. This ensures your custom forms work consistently across iOS and macOS.

### **Platform-Independent Colors**
```swift
// ✅ CORRECT: Use 6-layer platform colors
Text("Title")
    .foregroundColor(.platformPrimaryLabel)      // iOS: .primary, macOS: .primary
    .background(Color.platformBackground)        // iOS: .systemBackground, macOS: .windowBackgroundColor

Text("Subtitle")
    .foregroundColor(.platformSecondaryLabel)    // iOS: .secondary, macOS: .secondary
    .background(Color.platformSecondaryBackground) // iOS: .secondarySystemBackground, macOS: .controlBackgroundColor

Text("Optional")
    .foregroundColor(.platformTertiaryLabel)     // iOS: .tertiaryLabel, macOS: .secondary
    .background(Color.platformGroupedBackground) // iOS: .systemGroupedBackground, macOS: .controlBackgroundColor
```

### **Platform-Independent Separators**
```swift
// ✅ CORRECT: Use 6-layer platform separators
Divider()
    .background(Color.platformSeparator)         // iOS: .separator, macOS: .separatorColor

// For opaque separators
Rectangle()
    .fill(Color.platformOpaqueSeparator)         // iOS: .opaqueSeparator, macOS: .separatorColor
    .frame(height: 1)
```

### **Platform-Independent System Colors**
```swift
// ✅ CORRECT: Use 6-layer system colors
Button("Save") { saveData() }
    .foregroundColor(.platformTint)              // iOS: .systemBlue, macOS: .controlAccentColor

Button("Delete") { deleteData() }
    .foregroundColor(.platformDestructive)       // iOS: .systemRed, macOS: .systemRedColor

Text("Success")
    .foregroundColor(.platformSuccess)           // iOS: .systemGreen, macOS: .systemGreenColor

Text("Warning")
    .foregroundColor(.platformWarning)           // iOS: .systemOrange, macOS: .systemOrangeColor
```

### **Platform-Independent Accessibility**
```swift
// ✅ CORRECT: Use 6-layer accessibility utilities
Text("Form Title")
    .accessibilityLabel("Form Title")
    .accessibilityHint("Enter your information")
    .accessibilityAddTraits(.isHeader)

Button("Submit") { submitForm() }
    .accessibilityLabel("Submit Form")
    .accessibilityHint("Tap to submit your information")
    .accessibilityAddTraits(.isButton)
```

### **Platform-Independent Layout Decisions**
```swift
// ✅ CORRECT: Use 6-layer layout utilities
struct ComplexForm: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    var body: some View {
        VStack {
            // Use 6-layer layout decisions
            if horizontalSizeClass == .compact {
                // Compact layout for phones
                VStack {
                    // Form fields
                }
            } else {
                // Regular layout for tablets/desktop
                HStack {
                    VStack {
                        // Left column
                    }
                    VStack {
                        // Right column
                    }
                }
            }
        }
        .padding(.platformStandard)  // 6-layer platform padding
    }
}
```

### **Platform-Independent Window Detection**
```swift
// ✅ CORRECT: Use 6-layer window detection
struct ComplexForm: View {
    @StateObject private var windowDetection = UnifiedWindowDetection()
    
    var body: some View {
        VStack {
            // Form content
        }
        .onReceive(windowDetection.$windowSize) { size in
            // Adapt layout based on window size
            if size.width < 600 {
                // Compact layout
            } else {
                // Regular layout
            }
        }
    }
}
```

### **Platform-Independent Theming**
```swift
// ✅ CORRECT: Use 6-layer theming system
struct ComplexForm: View {
    @StateObject private var themeManager = VisualDesignSystem()
    
    var body: some View {
        VStack {
            // Form content
        }
        .environment(\.colorScheme, themeManager.currentTheme.colorScheme)
        .onReceive(themeManager.$currentTheme) { theme in
            // Adapt to theme changes
        }
    }
}
```

### **Benefits of Using 6-Layer Platform Independence**
- ✅ **Consistent appearance** across iOS and macOS
- ✅ **Automatic dark mode support** through platform colors
- ✅ **Accessibility compliance** through platform utilities
- ✅ **Future-proof** - updates with new platform features
- ✅ **Reduced maintenance** - no platform-specific code needed

## 🚫 Anti-Patterns to Avoid

### ❌ Don't: Over-Engineer the Framework
```swift
// DON'T: Try to make the framework handle everything
let form = ComplexFormBuilder()
    .addCustomComponent(MPGCalculatorView(), at: .afterField("totalCost"))
    .addConditionalLogic([...])
    .addDependencyEngine([...])
    .build()
```

### ❌ Don't: Force Complex Logic Through Framework
```swift
// DON'T: Try to make the framework handle complex business logic
struct ComplexBusinessLogic {
    func calculateMPG(gallons: Double, totalCost: Double) -> Double {
        // Complex calculation logic
    }
}
```

### ❌ Don't: Create Hybrid Abstractions
```swift
// DON'T: Create complex injection systems
struct CustomComponentSlot {
    let id: String
    let position: SlotPosition
    let component: AnyView
    let constraints: ComponentConstraints
}
```

## 🎯 When to Use Each Approach

### Use Composition (Approach 1) When:
- Form has mixed complexity
- You want to gradually migrate from framework to custom
- Some sections are simple, others are complex

### Use Protocol-Based Fields (Approach 2) When:
- You want custom field types that integrate with framework
- You need consistent field behavior across forms
- You want type-safe custom fields

### Use View Modifiers (Approach 3) When:
- You have simple conditional rendering
- You want to leverage SwiftUI's built-in features
- You don't need complex state management

### Use Focused Extensions (Approach 4) When:
- You need to add specific capabilities to framework
- You want to keep the framework focused
- You need incremental improvements

### Use Pure SwiftUI (Approach 5) When:
- Form is very complex
- Framework adds more complexity than value
- You need full control over the form

## 📚 Examples for Common Scenarios

### Scenario 1: Simple Form with One Complex Section
```swift
// Use Composition (Approach 1)
VStack {
    IntelligentFormView.generateForm(for: BasicData.self, initialData: data)
    
    if data.needsCalculation {
        MPGCalculatorView(gallons: $data.gallons, totalCost: $data.totalCost)
    }
}
```

### Scenario 2: Form with Custom Field Types
```swift
// Use Protocol-Based Fields (Approach 2)
IntelligentFormView.generateForm(
    for: FormData.self,
    initialData: data,
    customFieldTypes: [
        "photoPicker": PhotoPickerField(),
        "locationPicker": LocationPickerField()
    ]
)
```

### Scenario 3: Form with Conditional Sections
```swift
// Use View Modifiers (Approach 3)
VStack {
    IntelligentFormView.generateForm(for: FormData.self, initialData: data)
    
    if data.category.hasBudget {
        BudgetInformationView(category: data.category)
    }
    
    if data.requiresApproval {
        ApprovalWorkflowView(amount: data.amount)
    }
}
```

### Scenario 4: Very Complex Form
```swift
// Use Pure SwiftUI (Approach 5)
Form {
    Section("Basic Info") {
        TextField("Title", text: $data.title)
        DatePicker("Date", selection: $data.date)
    }
    
    Section("Complex Logic") {
        // Custom business logic components
        MPGCalculatorView(gallons: $data.gallons, totalCost: $data.totalCost)
        BudgetCalculatorView(category: $data.category, amount: $data.amount)
    }
    
    Section("Attachments") {
        PhotoPickerView(selectedImage: $data.receiptImage)
        LocationPickerView(selectedLocation: $data.location)
    }
}
```

## 🔧 Implementation Guidelines

### 1. Start Simple
- Begin with the simplest approach that works
- Add complexity only when needed
- Don't over-engineer from the start

### 2. Use the Right Tool
- Framework for simple, consistent forms
- SwiftUI for complex, custom forms
- Don't force everything through one approach

### 3. Keep Components Focused
- Each component should have a single responsibility
- Keep custom components independent
- Test components in isolation

### 4. Maintain Consistency
- Use consistent patterns across your app
- Document your approach
- Train your team on the chosen patterns

## 📖 Conclusion

The SixLayer Framework is excellent for simple forms and basic form structure. For complex forms, use SwiftUI directly or combine both approaches. Don't try to make the framework handle everything - that leads to over-engineering and complexity.

**Remember**: The framework should make simple things simple, not make complex things possible.

**Important**: Even when using SwiftUI directly for complex forms, always leverage the 6-layer framework's platform-independent utilities (colors, accessibility, theming, etc.) to ensure consistent cross-platform behavior.

---

**For AI Agents**: When helping users with complex forms, always consider these approaches and recommend the simplest one that meets their needs. Don't default to trying to extend the framework - often the best solution is to use SwiftUI directly or combine both approaches. Always remind developers to use 6-layer platform independence utilities even in custom SwiftUI code.
