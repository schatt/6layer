# 🤖 AI Agent Guide for SixLayer Framework

*This document is specifically designed for AI agents (like Claude, GPT, etc.) to understand how to work with the SixLayer Framework's generic core + extensible business logic architecture.*

## 🎯 **Purpose of This Guide**

AI agents need to understand:
- **Framework Architecture**: Generic core with extensible business logic
- **How to Use Generic Functions**: Layer 1 functions with business-specific hints
- **Extensible Hints System**: CustomHint and EnhancedPresentationHints
- **Best Practices**: Combining generic framework with business needs
- **Apple HIG Compliance**: Automatic adherence to Apple's Human Interface Guidelines

## 🏗️ **Framework Architecture (Correct Understanding)**

### **Layer 1 Semantic Intent Philosophy (CRITICAL)**

The SixLayer Framework is built on a **6-layer architecture** where **Layer 1 (Semantic Intent)** is the most important principle:

**🎯 Core Principle: Apps express WHAT they want to present, not HOW to implement it.**

```
Layer 1: Semantic Intent → Layer 2: Layout Decision → Layer 3: Strategy Selection → Layer 4: Component Implementation → Layer 5: Platform Optimization → Layer 6: Platform System
```

### **Layer 1 Philosophy in Practice:**

#### **✅ CORRECT: Express Intent, Let Framework Decide Implementation**
```swift
// App says WHAT it wants to present
platformPresentItemCollection_L1(items: vehicles, hints: vehicleHints)
platformPresentFormData_L1(fields: formFields, hints: formHints)
platformPresentResponsiveCard_L1(content: cardContent, hints: cardHints)
```

#### **❌ WRONG: Mix 6layer Functions with SwiftUI Building Blocks**
```swift
// DON'T DO THIS - Breaks the abstraction
platformFormSection {
    VStack {  // ❌ Raw SwiftUI building block
        Text("Name")  // ❌ Raw SwiftUI building block
        TextField("Enter name", text: $name)  // ❌ Raw SwiftUI building block
    }
}

// DON'T DO THIS - App shouldn't know about SwiftUI implementation
platformScrollViewContainer {
    HStack {  // ❌ Raw SwiftUI building block
        Image(systemName: "car")  // ❌ Raw SwiftUI building block
        Text("Vehicle")  // ❌ Raw SwiftUI building block
    }
}
```

### **Why This Architecture Matters:**

1. **True Abstraction**: App code doesn't depend on SwiftUI implementation details
2. **Platform Independence**: Framework decides whether to use ScrollView, VStack, Form, etc.
3. **Future-Proof**: Can change underlying implementation without breaking app code
4. **Intelligent Layout**: Framework can make smart decisions about presentation strategy
5. **Consistent Behavior**: All apps get the same high-quality, accessible UI patterns

### **Generic Core + Extensible Business Logic**

The SixLayer Framework is **NOT** a business-specific framework. It's a **generic foundation** that becomes business-specific through the extensible hints system:

```
Generic Core (Framework) + Business-Specific Hints = Business-Specific Behavior
```

### **Key Architecture Principles:**

1. **Layer 1 Semantic Intent**: Apps express WHAT they want, not HOW to implement it
2. **Core Remains Generic**: Data types, functions, and logic are business-agnostic
3. **Business Logic Through Hints**: CustomHint system enables business-specific behavior
4. **Extensibility Without Modification**: Add business logic without changing framework code
5. **Reusable Across Domains**: Same framework works for vehicles, e-commerce, social media, etc.
6. **No SwiftUI Building Blocks**: Don't mix 6layer functions with raw SwiftUI components

## 📝 **How the Framework Actually Works**

### **1. Generic Core Functions (What Actually Exists):**
```swift
// ✅ THESE EXIST and are completely generic:

// Generic form presentation
public func platformPresentFormData_L1(
    fields: [GenericFormField],
    hints: PresentationHints
) -> some View

// Generic collection presentation
public func platformPresentItemCollection_L1<Item: Identifiable>(
    items: [Item],
    hints: PresentationHints
) -> some View

// Generic modal presentation
public func platformPresentModalForm_L1(
    formType: DataTypeHint,
    context: PresentationContext
) -> some View
```

### **2. Generic Data Types (What Actually Exists):**
```swift
// ✅ Core enums remain generic and business-agnostic:
public enum DataTypeHint: String, CaseIterable {
    case generic, text, number, date, image, boolean, collection
    case numeric, hierarchical, temporal, media, form, list, grid, chart
    case custom  // ← This enables business-specific types
}
```

### **3. Business Logic Through Extensible Hints (What Actually Exists):**
```swift
// ✅ Business-specific behavior through CustomHint system:

// Vehicle-specific hints
let vehicleHint = CustomHint(
    hintType: "vehicle.form",
    priority: .high,
    customData: [
        "showImagePicker": true,
        "requiredFields": ["make", "model", "year"],
        "layoutStyle": "sectioned",
        "validationMode": "strict"
    ]
)

// E-commerce specific hints
let ecommerceHint = CustomHint.forEcommerceProduct(
    category: "electronics",
    showPricing: true,
    showReviews: true,
    layoutStyle: "grid"
)

// Financial dashboard hints
let financialHint = CustomHint.forFinancialDashboard(
    timeRange: "1M",
    showCharts: true,
    refreshRate: 60
)
```

### **4. Business Configuration Through Custom Preferences:**
```swift
// ✅ Business-specific configuration:
let hints = PresentationHints(
    dataType: .form,
    presentationPreference: .form,
    complexity: .moderate,
    context: .create,
    customPreferences: [
        "businessType": "vehicle",
        "formStyle": "multiStep",
        "validationRules": "strict",
        "showProgress": "true"
    ]
)
```

## 🔧 **How to Actually Use the Framework**

### **1. Use Generic Functions with Business-Specific Hints:**
```swift
// ✅ CORRECT: Generic function + business hints
let vehicleHints = PresentationHints(
    dataType: .form,
    presentationPreference: .form,
    complexity: .moderate,
    context: .create,
    customPreferences: [
        "businessType": "vehicle",
        "formStyle": "multiStep"
    ]
)

let formView = platformPresentFormData_L1(
    fields: createVehicleFields(),
    hints: vehicleHints
)
```

### **2. Create Business-Specific Hints:**
```swift
// ✅ CORRECT: Extend the framework with business logic
extension CustomHint {
    static func forVehicleForm(
        showImagePicker: Bool = true,
        requiredFields: [String] = ["make", "model", "year"]
    ) -> CustomHint {
        return CustomHint(
            hintType: "vehicle.form",
            priority: .high,
            customData: [
                "showImagePicker": showImagePicker,
                "requiredFields": requiredFields,
                "layoutStyle": "sectioned",
                "validationMode": "strict"
            ]
        )
    }
}

// Usage:
let vehicleHint = CustomHint.forVehicleForm()
let enhancedHints = EnhancedPresentationHints(
    dataType: .form,
    presentationPreference: .form,
    complexity: .moderate,
    context: .create,
    extensibleHints: [vehicleHint]
)
```

### **3. Combine Generic Framework with Business Logic:**
```swift
// ✅ CORRECT: Build business functionality on generic foundation
struct VehicleFormView: View {
    var body: some View {
        // Use generic framework function
        platformPresentFormData_L1(
            fields: createVehicleFields(),
            hints: createVehicleHints()
        )
    }
    
    private func createVehicleFields() -> [GenericFormField] {
        // Convert business logic to generic fields
        return [
            GenericFormField(name: "Make", type: .text),
            GenericFormField(name: "Model", type: .text),
            GenericFormField(name: "Year", type: .number)
        ]
    }
    
    private func createVehicleHints() -> PresentationHints {
        // Business-specific configuration through hints
        return PresentationHints(
            dataType: .form,
            presentationPreference: .form,
            complexity: .moderate,
            context: .create,
            customPreferences: [
                "businessType": "vehicle",
                "formStyle": "multiStep"
            ]
        )
    }
}
```

## 🎨 **Custom View Extensibility**

### **How Developers Can Create Custom Views**

The framework provides **multiple extensibility points** for developers to create custom views:

#### **1. Custom Field Views in Forms:**
```swift
// Dev A creates a custom vehicle image picker
struct VehicleImagePicker: View {
    let fieldName: String
    let value: Any
    let fieldType: FieldType
    
    var body: some View {
        VStack {
            Text("Vehicle Image")
                .font(.headline)
            
            if let imageData = value as? Data {
                Image(uiImage: UIImage(data: imageData) ?? UIImage())
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
            }
            
            Button("Select Image") {
                // Custom image picker logic
            }
            .buttonStyle(.bordered)
        }
    }
}

// Dev A uses it with the framework
let customForm = IntelligentFormView.generateForm(
    for: Vehicle.self,
    initialData: sampleVehicle,
    customFieldView: { fieldName, value, fieldType in
        if fieldName == "image" {
            VehicleImagePicker(fieldName: fieldName, value: value, fieldType: fieldType)
        } else {
            // Fall back to default field view
            EmptyView() // Framework will use default
        }
    },
    onSubmit: { vehicle in
        // Handle submission
    }
)
```

#### **2. Custom Content Views in Navigation:**
```swift
// Dev A creates custom vehicle views
struct CustomVehicleItemView: View {
    let vehicle: Vehicle
    
    var body: some View {
        HStack {
            AsyncImage(url: vehicle.imageURL) { image in
                image.resizable()
            } placeholder: {
                Color.gray
            }
            .frame(width: 50, height: 50)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading) {
                Text(vehicle.make + " " + vehicle.model)
                    .font(.headline)
                Text("\(vehicle.year)")
                    .font(.caption)
                    .foregroundColor(.platformSecondaryLabel)
            }
            
            Spacer()
        }
        .padding()
    }
}

// Dev A uses them with the framework
let navigationView = platformPresentItemCollection_L1(
    items: vehicles,
    hints: PresentationHints(
        dataType: .collection,
        presentationPreference: .list,
        complexity: .moderate,
        context: .browse
    )
)
```

#### **3. Custom Container Views:**
```swift
// Dev A creates a custom multi-step form container
struct MultiStepFormContainer<Content: View>: View {
    @State private var currentStep = 0
    let totalSteps: Int
    let content: Content
    
    var body: some View {
        VStack {
            // Custom step indicator
            StepIndicator(currentStep: currentStep, totalSteps: totalSteps)
            
            // Custom content
            content
            
            // Custom navigation
            HStack {
                if currentStep > 0 {
                    Button("Previous") { currentStep -= 1 }
                }
                
                Spacer()
                
                if currentStep < totalSteps - 1 {
                    Button("Next") { currentStep += 1 }
                } else {
                    Button("Submit") { /* Handle submission */ }
                }
            }
            .padding()
        }
    }
}
```

#### **4. Custom Hints for View Behavior:**
```swift
// Dev A creates custom hints for specific behavior
let vehicleFormHints = CustomHint(
    hintType: "vehicle.form",
    priority: .high,
    customData: [
        "showImagePicker": true,
        "requiredFields": ["make", "model", "year"],
        "layoutStyle": "sectioned",
        "validationMode": "strict",
        "customContainer": "multiStep",
        "customFieldViews": ["image": "VehicleImagePicker"]
    ]
)

// Dev A combines hints with framework
let enhancedHints = EnhancedPresentationHints(
    dataType: .form,
    presentationPreference: .form,
    complexity: .complex,
    context: .create,
    extensibleHints: [vehicleFormHints]
)
```

### **Key Extensibility Points:**

1. **`customFieldView`** - Custom form field views
2. **`@ViewBuilder` parameters** - Custom content views in navigation
3. **Custom containers** - Custom form containers and layouts
4. **Custom hints** - Control view behavior through the hints system
5. **Extensible hints** - Add business-specific logic through CustomHint

## 🚫 **Common Mistakes to Avoid**

### **1. Mixing 6layer Functions with SwiftUI Building Blocks (CRITICAL ERROR):**
```swift
// ❌ WRONG: Breaks Layer 1 semantic intent philosophy
platformFormSection {
    VStack {  // ❌ Raw SwiftUI building block
        Text("Name")  // ❌ Raw SwiftUI building block
        TextField("Enter name", text: $name)  // ❌ Raw SwiftUI building block
    }
}

// ❌ WRONG: App shouldn't know about SwiftUI implementation
platformScrollViewContainer {
    HStack {  // ❌ Raw SwiftUI building block
        Image(systemName: "car")  // ❌ Raw SwiftUI building block
        Text("Vehicle")  // ❌ Raw SwiftUI building block
    }
}

// ✅ CORRECT: Express intent, let framework decide implementation
platformPresentFormData_L1(
    fields: createFormFields(),
    hints: createFormHints()
)

platformPresentItemCollection_L1(
    items: vehicles,
    hints: createVehicleHints()
)
```

### **2. Expecting Business-Specific Functions:**
```swift
// ❌ WRONG: This function doesn't exist
let view = platformPresentVehicleForm_L1(data: vehicleData)

// ✅ CORRECT: Use generic function with business hints
let view = platformPresentFormData_L1(
    fields: convertVehicleToFields(vehicleData),
    hints: createVehicleHints()
)
```

### **3. Assuming Business Types Are Built-In:**
```swift
// ❌ WRONG: These cases don't exist in core enums
case vehicleCreation, expenseEntry, fuelFillup

// ✅ CORRECT: Use generic types with business hints
case form  // Generic type
// Business logic in hints:
customPreferences: ["businessType": "vehicle"]
```

### **4. Ignoring the Extensible Hints System:**
```swift
// ❌ WRONG: Trying to hardcode business logic
if businessType == "vehicle" { ... }

// ✅ CORRECT: Use the hints system
let hints = PresentationHints(...)
let customData = hints.customPreferences
if customData["businessType"] == "vehicle" { ... }
```

### **5. Using 6layer Functions as SwiftUI Modifiers:**
```swift
// ❌ WRONG: Treating 6layer functions as SwiftUI modifiers
Text("Hello")
    .platformFormSection {  // ❌ This breaks the architecture
        // content
    }

// ✅ CORRECT: Use 6layer functions as standalone view creators
platformPresentFormData_L1(
    fields: fields,
    hints: hints
)
```

## 📚 **What the Framework Actually Provides**

### **✅ What's Real and Working:**
1. **Generic Core Functions**: `platformPresentFormData_L1`, `platformPresentItemCollection_L1`
2. **Generic Data Types**: `DataTypeHint`, `PresentationPreference`, `PresentationContext`
3. **Extensible Hints System**: `CustomHint`, `EnhancedPresentationHints`
4. **Business Configuration**: `customPreferences`, `extensibleHints`
5. **Hint Processing**: `HintProcessingEngine` for intelligent decision making

### **✅ What's Extensible:**
1. **Business-Specific Behavior**: Through `CustomHint` system
2. **Business Configuration**: Through `customPreferences`
3. **Complex Business Logic**: Through `EnhancedPresentationHints`
4. **Domain-Specific Hints**: Through `CustomHint` extensions

## 🆕 **Cross-Platform Optimization Layer 6 (NEW in v1.6.7)**

### **Layer 6 Implementation:**
The framework now includes a complete **Cross-Platform Optimization Layer 6** that provides:

#### **1. Cross-Platform Optimization Manager:**
```swift
// ✅ NEW: Centralized optimization management
let optimizationManager = CrossPlatformOptimizationManager()
let optimizedView = optimizationManager.optimizeView(myView)
```

#### **2. Performance Benchmarking:**
```swift
// ✅ NEW: Cross-platform performance testing
let benchmark = PerformanceBenchmarking.benchmarkView(
    myView,
    benchmarkName: "Form Rendering",
    iterations: 100
)
```

#### **3. Platform-Specific UI Patterns:**
```swift
// ✅ NEW: Intelligent UI pattern selection
let patterns = PlatformUIPatterns(for: .iOS)
let navigationType = patterns.navigationPatterns.primaryNavigation // .tabBar
let interactionType = patterns.interactionPatterns.primaryInput // .touch
```

#### **4. Memory Management:**
```swift
// ✅ NEW: Advanced memory strategies
let settings = PlatformOptimizationSettings(for: .iOS)
settings.memoryStrategy = .adaptive
settings.performanceLevel = .high
```

#### **5. Cross-Platform Testing:**
```swift
// ✅ NEW: Test views across all platforms
let testResults = CrossPlatformTesting.testViewAcrossPlatforms(
    myView,
    testName: "Accessibility Compliance"
)
```

### **Key Benefits of Layer 6:**
- **Performance Optimization**: Platform-specific performance tuning
- **Memory Management**: Intelligent memory allocation strategies
- **UI Pattern Adaptation**: Platform-appropriate navigation and interaction patterns
- **Cross-Platform Testing**: Comprehensive testing across all supported platforms
- **Performance Monitoring**: Real-time metrics and optimization recommendations

## 🎯 **Working with Developers**

### **Questions to Ask:**
- "What business logic do you need to implement?"
- "How can we use the generic framework functions with business-specific hints?"
- "What business configuration do you need?"
- "Should we create a custom hint for this business logic?"

### **Red Flags to Watch For:**
- Developer expects business-specific functions to exist
- Developer wants to hardcode business logic in framework
- Developer ignores the extensible hints system
- Developer assumes business types are built into core enums

### **Correct Approach:**
1. **Use Generic Functions**: Leverage what exists
2. **Create Business Hints**: Use `CustomHint` system
3. **Configure Through Preferences**: Use `customPreferences`
4. **Extend Without Modifying**: Add business logic through hints

## 🔍 **Debugging Common Issues**

### **Issue: "Function doesn't exist"**
```swift
// Problem: Developer tries to use business-specific function
platformPresentVehicleForm_L1(data: vehicleData)

// Solution: Use generic function with business hints
platformPresentFormData_L1(
    fields: convertVehicleToFields(vehicleData),
    hints: createVehicleHints()
)
```

### **Issue: "Expected business data types"**
```swift
// Problem: Developer expects business-specific enum cases
case vehicleCreation

// Solution: Use generic types with business hints
case form  // Generic type
// Business logic in hints:
customPreferences: ["businessType": "vehicle"]
```

### **Issue: "How to make it business-specific"**
```swift
// Problem: Developer wants business logic
// Solution: Use the extensible hints system
let businessHint = CustomHint(
    hintType: "your.business.type",
    customData: ["key": "value"]
)

let hints = EnhancedPresentationHints(
    dataType: .form,
    extensibleHints: [businessHint]
)
```

## 📖 **Resources for AI Agents**

### **Key Files to Reference:**
- `Framework/Sources/Shared/Views/Extensions/PlatformSemanticLayer1.swift` - Generic Layer 1 functions
- `Framework/Sources/Shared/Models/ExtensibleHints.swift` - Extensible hints system
- `Framework/Sources/Shared/Models/GenericTypes.swift` - Generic data types
- `Framework/Sources/Shared/Models/PlatformTypes.swift` - Platform detection

### **What to Understand:**
- The framework is **generic by design**
- Business logic is **added through extensibility**
- **CustomHint system** enables business-specific behavior
- **customPreferences** provide business configuration

## 🍎 **Apple HIG Compliance by Default**

### **Core Design Philosophy**
The SixLayer Framework automatically follows Apple's Human Interface Guidelines (HIG) and accessibility best practices, ensuring excellent user experiences without developer configuration.

**Principle**: *Make it impossible to build a bad UI with the framework, while making it easy to build a great one.*

### **What the Framework Automatically Provides**

#### **1. Automatic Accessibility**
```swift
// Developer writes:
Button("Save") { saveData() }

// Framework automatically adds:
// - VoiceOver support when enabled
// - Keyboard navigation support
// - High contrast support when needed
// - Dynamic type support
// - Proper accessibility labels and hints
```

#### **2. Platform-Specific Patterns**
```swift
// iOS automatically gets:
// - Navigation stacks and sheets
// - Haptic feedback
// - Touch-optimized interactions
// - SF Symbols and iOS design language

// macOS automatically gets:
// - Window-based navigation
// - Keyboard shortcuts
// - Mouse-optimized interactions
// - System colors and macOS design language
```

#### **3. Visual Design Consistency**
```swift
// Framework automatically applies:
// - Apple's 8pt grid system for spacing
// - System colors that adapt to light/dark mode
// - Platform-appropriate typography
// - Proper touch targets (44pt minimum on iOS)
// - Consistent corner radius and styling
```

#### **4. Interaction Patterns**
```swift
// Framework automatically provides:
// - Appropriate hover states on macOS
// - Touch feedback on iOS
// - Gesture recognition for each platform
// - Keyboard navigation support
// - VoiceOver announcements
```

### **How AI Agents Should Approach This**

#### **When Developers Ask About UI Quality:**
```
Developer: "How do I make this button accessible?"
AI Agent: "The framework automatically handles accessibility! When you use 
          Button("Save") { saveData() }, the framework automatically adds 
          VoiceOver support, keyboard navigation, and proper accessibility 
          labels. You don't need to configure anything - it just works."
```

#### **When Developers Want Platform-Specific Behavior:**
```
Developer: "How do I make this work differently on iOS vs macOS?"
AI Agent: "The framework automatically adapts! It detects the platform and 
          applies the appropriate Apple HIG patterns. iOS gets navigation 
          stacks and haptic feedback, macOS gets window-based navigation 
          and keyboard shortcuts. No configuration needed."
```

#### **When Developers Ask About Styling:**
```
Developer: "How do I make this look like a native Apple app?"
AI Agent: "It already does! The framework automatically follows Apple's 
          design guidelines - proper spacing, system colors, SF Symbols, 
          and platform-appropriate styling. Your app will look and feel 
          native without any extra work."
```

### **Key Benefits for Developers**
1. **Zero Configuration**: Apple-quality UI out of the box
2. **Automatic Accessibility**: No need to manually add accessibility features
3. **Platform Adaptation**: Automatically uses the right patterns for each platform
4. **Consistent Design**: Follows Apple's design guidelines automatically
5. **Future-Proof**: Updates with new Apple guidelines automatically

## 🎯 **Best Practices Summary**

### **Layer 1 Semantic Intent (MOST IMPORTANT):**
1. **Express WHAT you want to present, not HOW to implement it**
2. **Use Layer 1 functions** (`platformPresentFormData_L1`, `platformPresentItemCollection_L1`)
3. **Let the framework decide** the SwiftUI implementation (ScrollView, VStack, Form, etc.)
4. **Never mix 6layer functions with SwiftUI building blocks** (VStack, HStack, Text, etc.)

### **Framework Usage:**
5. **Always use generic functions** with business-specific hints
6. **Leverage the extensible hints system** for business logic
7. **Use customPreferences** for business configuration
8. **Create CustomHint extensions** for complex business behavior
9. **Keep framework generic** while enabling business functionality
10. **Build business logic on top** of the generic foundation
11. **Trust the framework's Apple HIG compliance** - it handles UI quality automatically

### **Architectural Principles:**
12. **App code should be SwiftUI-agnostic** - don't reference SwiftUI components directly
13. **Framework handles all implementation details** - ScrollView, VStack, Form, etc.
14. **Business logic goes in hints** - not in the app's view code
15. **Layer 1 functions are view creators** - not SwiftUI modifiers

## 🤝 **Working with Developers**

### **When Developers Mix 6layer Functions with SwiftUI Building Blocks (CRITICAL):**
```
Developer: "I'm using platformFormSection { VStack { Text("Name") } }"
AI Agent: "❌ This breaks the Layer 1 semantic intent philosophy! The 6layer 
          framework is designed so apps express WHAT they want to present, 
          not HOW to implement it. Don't mix 6layer functions with raw 
          SwiftUI building blocks like VStack, HStack, Text, etc.
          
          ✅ CORRECT approach:
          platformPresentFormData_L1(fields: formFields, hints: formHints)
          
          The framework will decide whether to use VStack, ScrollView, Form, 
          or other SwiftUI components based on your hints and context."
```

### **When Developers Ask for Business Functions:**
```
Developer: "I need platformPresentVehicleForm_L1"
AI Agent: "That function doesn't exist, but you can achieve the same result using 
          the generic platformPresentFormData_L1 with business-specific hints. 
          Let me show you how to use the CustomHint system."
```

### **When Developers Want Business Types:**
```
Developer: "I need case vehicleCreation in DataTypeHint"
AI Agent: "The framework keeps core types generic for reusability. Instead, 
          create business-specific behavior through CustomHint with 
          customData: ['businessType': 'vehicle']. This keeps the framework 
          generic while enabling your business logic."
```

### **When Developers Expect Business Logic:**
```
Developer: "How do I make this vehicle-specific?"
AI Agent: "Use the extensible hints system! Create a CustomHint with 
          hintType: 'vehicle.form' and customData for your business rules. 
          Then combine it with the generic framework functions."
```

### **When Developers Ask About SwiftUI Implementation:**
```
Developer: "How do I use ScrollView with 6layer?"
AI Agent: "❌ You shouldn't think about SwiftUI implementation details! The 
          6layer framework handles all SwiftUI components internally. 
          
          ✅ CORRECT approach:
          - Use platformPresentItemCollection_L1() for lists/collections
          - Use platformPresentFormData_L1() for forms
          - Let the framework decide whether to use ScrollView, VStack, Form, etc.
          
          The whole point of Layer 1 is that your app code should be 
          SwiftUI-agnostic. Express what you want to present, not how to present it."
```

## 🎨 **Cross-Platform Color Utilities**

### **Problem Solved**
When building cross-platform iOS/macOS apps, developers encounter platform-specific color APIs that don't exist on all platforms:
- `Color.tertiaryLabel` exists on iOS but not on macOS
- `Color.quaternaryLabel` exists on iOS but not on macOS
- This forces developers to use conditional compilation or fallback colors

### **Framework Solution**
The SixLayer Framework provides cross-platform color utilities that eliminate the need for platform-specific code:

```swift
// ❌ AVOID: Platform-specific color code
#if os(iOS)
.foregroundColor(.tertiaryLabel)
#elseif os(macOS)
.foregroundColor(.secondary)
#endif

// ✅ USE: Cross-platform color utilities
.foregroundColor(.platformTertiaryLabel)
```

### **Available Cross-Platform Colors**
```swift
// Label Colors
.platformPrimaryLabel      // iOS: .primary, macOS: .primary
.platformSecondaryLabel    // iOS: .secondary, macOS: .secondary
.platformTertiaryLabel     // iOS: .tertiaryLabel, macOS: .secondary
.platformQuaternaryLabel   // iOS: .quaternaryLabel, macOS: .secondary

// Text Colors
.platformPlaceholderText   // iOS: .placeholderText, macOS: .secondary

// Separator Colors
.platformSeparator         // iOS: .separator, macOS: .separatorColor
.platformOpaqueSeparator   // iOS: .opaqueSeparator, macOS: .separatorColor

// Background Colors
.platformBackground        // iOS: .systemBackground, macOS: .windowBackgroundColor
.platformSecondaryBackground // iOS: .secondarySystemBackground, macOS: .controlBackgroundColor
.platformGroupedBackground // iOS: .systemGroupedBackground, macOS: .controlBackgroundColor

// System Colors
.platformTint              // iOS: .systemBlue, macOS: .controlAccentColor
.platformDestructive       // iOS: .systemRed, macOS: .systemRedColor
.platformSuccess           // iOS: .systemGreen, macOS: .systemGreenColor
.platformWarning           // iOS: .systemOrange, macOS: .systemOrangeColor
.platformInfo              // iOS: .systemBlue, macOS: .systemBlueColor
```

### **Usage Examples**
```swift
// Form Labels
Text("Email Address")
    .foregroundColor(.platformPrimaryLabel)

Text("Optional field")
    .foregroundColor(.platformTertiaryLabel)

// Placeholder Text
TextField("Enter your name", text: $name)
    .foregroundColor(.platformPlaceholderText)

// Separators
Divider()
    .background(Color.platformSeparator)

// Backgrounds
VStack {
    // Content
}
.background(Color.platformBackground)
```

### **Benefits for AI Agents**
1. **Eliminates Conditional Compilation**: No more `#if os(iOS)` / `#elseif os(macOS)` for colors
2. **Prevents Runtime Crashes**: No more "unavailable on macOS" errors
3. **Improves Code Readability**: Clear, semantic color names
4. **Reduces Maintenance**: Centralized color mapping logic
5. **Better Accessibility**: Consistent color behavior across platforms

---

**Remember**: The SixLayer Framework is a **generic foundation** that becomes **business-specific** through the extensible hints system. Help developers understand this architecture and use it correctly.
