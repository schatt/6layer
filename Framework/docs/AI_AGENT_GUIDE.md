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

// Generic content presentation (for runtime-unknown content types)
public func platformPresentContent_L1(
    content: Any,
    hints: PresentationHints
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

## 🔍 **OCR Functionality Usage Guide**

### **OCR System Overview**
The SixLayer Framework includes a comprehensive OCR (Optical Character Recognition) system that follows the 6-layer architecture. OCR functionality is available through Layer 1 semantic functions that express intent rather than implementation details.

### **Core OCR Philosophy**
Just like other framework features, OCR follows the **Layer 1 Semantic Intent** principle:
- **Apps express WHAT they want to extract, not HOW to implement it**
- **Framework handles all Vision framework complexity internally**
- **Business logic goes through the hints system**

### **Available OCR Functions**

#### **1. Basic OCR with Visual Correction (Primary Function)**
```swift
// ✅ CORRECT: Express intent, let framework handle implementation
let ocrView = platformOCRWithVisualCorrection_L1(
    image: myImage,
    textTypes: [.price, .date, .generalText],
    language: .english,
    confidenceThreshold: 0.8
) { result in
    // Handle OCR result
    if result.isValid {
        print("Extracted text: \(result.extractedText)")
    }
}
```

#### **2. OCR with Disambiguation (Advanced Function)**
```swift
// ✅ CORRECT: Use disambiguation for complex text
let ocrView = platformOCRWithDisambiguation_L1(
    image: myImage,
    textTypes: [.price, .date],
    language: .english,
    confidenceThreshold: 0.7
) { result in
    // Handle disambiguated result
    if result.needsDisambiguation {
        // Show disambiguation options
        showDisambiguationOptions(result.candidates)
    }
}
```

#### **3. OCR with Context (Recommended for Complex Scenarios)**
```swift
// ✅ CORRECT: Use OCRContext for complex scenarios
let context = OCRContext(
    textTypes: [.price, .date, .number],
    language: .english,
    confidenceThreshold: 0.8,
    allowsEditing: true,
    documentType: .receipt
)

let ocrView = platformOCRWithVisualCorrection_L1(
    image: myImage,
    context: context
) { result in
    // Handle contextual OCR result
    processOCRResult(result)
}
```

### **OCR Text Types**
The framework supports intelligent text type detection:

```swift
public enum OCRTextType: String, CaseIterable {
    case generalText = "general"
    case price = "price"
    case date = "date"
    case number = "number"
    case email = "email"
    case phone = "phone"
    case url = "url"
    case address = "address"
    case name = "name"
    case custom = "custom"
}
```

### **OCR Languages**
```swift
public enum OCRLanguage: String, CaseIterable {
    case english = "en"
    case spanish = "es"
    case french = "fr"
    case german = "de"
    case italian = "it"
    case portuguese = "pt"
    case chinese = "zh"
    case japanese = "ja"
    case korean = "ko"
    case arabic = "ar"
    case russian = "ru"
    case custom = "custom"
}
```

### **OCR Document Types**
```swift
public enum OCRDocumentType: String, CaseIterable {
    case receipt = "receipt"
    case invoice = "invoice"
    case businessCard = "businessCard"
    case form = "form"
    case document = "document"
    case label = "label"
    case menu = "menu"
    case sign = "sign"
    case custom = "custom"
}
```

### **OCR Result Handling**

#### **Basic Result Processing**
```swift
let ocrView = platformOCRWithVisualCorrection_L1(
    image: myImage,
    textTypes: [.price, .date],
    language: .english
) { result in
    // Check if OCR was successful
    if result.isValid {
        // Access extracted text
        let extractedText = result.extractedText
        
        // Access confidence score
        let confidence = result.confidence
        
        // Access specific text types
        if let price = result.extractedTextByType[.price] {
            print("Price found: \(price)")
        }
        
        if let date = result.extractedTextByType[.date] {
            print("Date found: \(date)")
        }
    } else {
        // Handle OCR failure
        print("OCR failed: \(result.error?.localizedDescription ?? "Unknown error")")
    }
}
```

#### **Advanced Result Processing**
```swift
let ocrView = platformOCRWithVisualCorrection_L1(
    image: myImage,
    context: context
) { result in
    switch result.status {
    case .success:
        // Process successful OCR
        processSuccessfulOCR(result)
        
    case .partialSuccess:
        // Handle partial success
        processPartialOCR(result)
        
    case .needsDisambiguation:
        // Show disambiguation options
        showDisambiguationUI(result.candidates)
        
    case .failure:
        // Handle failure
        showOCRError(result.error)
    }
}
```

### **OCR Integration with Forms**

#### **OCR Input Fields**
```swift
// ✅ CORRECT: Use OCR as input method in forms
let formFields = [
    GenericFormField(
        name: "receiptAmount",
        type: .text,
        inputMethod: .ocr,
        ocrTextTypes: [.price],
        ocrLanguage: .english
    ),
    GenericFormField(
        name: "receiptDate",
        type: .date,
        inputMethod: .ocr,
        ocrTextTypes: [.date],
        ocrLanguage: .english
    )
]

let formView = platformPresentFormData_L1(
    fields: formFields,
    hints: createReceiptFormHints()
)
```

#### **OCR with Business Hints**
```swift
// ✅ CORRECT: Use business-specific OCR hints
let receiptHints = PresentationHints(
    dataType: .form,
    presentationPreference: .form,
    complexity: .moderate,
    context: .create,
    customPreferences: [
        "businessType": "expense",
        "ocrEnabled": "true",
        "ocrTextTypes": "price,date",
        "ocrLanguage": "english",
        "ocrConfidenceThreshold": "0.8"
    ]
)
```

### **OCR Error Handling**

#### **Common OCR Errors**
```swift
public enum OCRError: Error {
    case imageProcessingFailed
    case textRecognitionFailed
    case confidenceTooLow
    case unsupportedImageFormat
    case noTextFound
    case languageNotSupported
    case custom(String)
}
```

#### **Error Handling Best Practices**
```swift
let ocrView = platformOCRWithVisualCorrection_L1(
    image: myImage,
    textTypes: [.price, .date],
    language: .english
) { result in
    if let error = result.error {
        switch error {
        case .imageProcessingFailed:
            showError("Unable to process image. Please try a different image.")
            
        case .textRecognitionFailed:
            showError("Unable to recognize text. Please ensure the image is clear.")
            
        case .confidenceTooLow:
            showError("Text recognition confidence is low. Please try a clearer image.")
            
        case .noTextFound:
            showError("No text found in image. Please ensure the image contains text.")
            
        case .unsupportedImageFormat:
            showError("Unsupported image format. Please use JPEG or PNG.")
            
        case .languageNotSupported:
            showError("Language not supported. Please try a different language.")
            
        case .custom(let message):
            showError("OCR Error: \(message)")
        }
    }
}
```

### **OCR Performance Optimization**

#### **Image Preprocessing**
```swift
// ✅ CORRECT: Let framework handle image optimization
let ocrView = platformOCRWithVisualCorrection_L1(
    image: myImage,
    textTypes: [.price, .date],
    language: .english,
    confidenceThreshold: 0.8
) { result in
    // Framework automatically optimizes image for OCR
    processOCRResult(result)
}
```

#### **Batch OCR Processing**
```swift
// ✅ CORRECT: Process multiple images
let images = [image1, image2, image3]
let ocrResults: [OCRResult] = []

for image in images {
    let ocrView = platformOCRWithVisualCorrection_L1(
        image: image,
        textTypes: [.price, .date],
        language: .english
    ) { result in
        ocrResults.append(result)
    }
}
```

### **OCR Accessibility Integration**

#### **VoiceOver Support**
```swift
// ✅ CORRECT: OCR automatically includes accessibility
let ocrView = platformOCRWithVisualCorrection_L1(
    image: myImage,
    textTypes: [.price, .date],
    language: .english
) { result in
    // Framework automatically provides:
    // - VoiceOver announcements for OCR results
    // - Keyboard navigation support
    // - High contrast support
    // - Dynamic type support
    processOCRResult(result)
}
```

#### **Accessibility Hints**
```swift
// ✅ CORRECT: Use accessibility hints for OCR
let accessibilityHints = PresentationHints(
    dataType: .form,
    presentationPreference: .form,
    complexity: .moderate,
    context: .create,
    customPreferences: [
        "accessibilityEnabled": "true",
        "voiceOverAnnouncements": "true",
        "keyboardNavigation": "true",
        "highContrastSupport": "true"
    ]
)
```

### **OCR Testing**

#### **Unit Testing OCR Functions**
```swift
func testOCRWithVisualCorrection() {
    // Given
    let testImage = createTestImage()
    let expectation = XCTestExpectation(description: "OCR completion")
    
    // When
    let ocrView = platformOCRWithVisualCorrection_L1(
        image: testImage,
        textTypes: [.price, .date],
        language: .english
    ) { result in
        // Then
        XCTAssertTrue(result.isValid)
        XCTAssertGreaterThan(result.confidence, 0.8)
        expectation.fulfill()
    }
    
    wait(for: [expectation], timeout: 5.0)
}
```

#### **Integration Testing**
```swift
func testOCRIntegrationWithForm() {
    // Given
    let formFields = createOCRFormFields()
    let hints = createOCRFormHints()
    
    // When
    let formView = platformPresentFormData_L1(
        fields: formFields,
        hints: hints
    )
    
    // Then
    XCTAssertNotNil(formView)
    // Test OCR integration with form
}
```

### **Common OCR Mistakes to Avoid**

#### **❌ WRONG: Direct Vision Framework Usage**
```swift
// ❌ WRONG: Don't use Vision framework directly
import Vision

let request = VNRecognizeTextRequest { request, error in
    // Direct Vision framework usage
}

// ✅ CORRECT: Use framework's OCR functions
let ocrView = platformOCRWithVisualCorrection_L1(
    image: myImage,
    textTypes: [.price, .date],
    language: .english
) { result in
    // Handle result
}
```

#### **❌ WRONG: Hardcoded OCR Logic**
```swift
// ❌ WRONG: Don't hardcode OCR logic
if imageType == "receipt" {
    // Hardcoded receipt OCR logic
}

// ✅ CORRECT: Use hints system
let hints = PresentationHints(
    customPreferences: [
        "businessType": "receipt",
        "ocrTextTypes": "price,date"
    ]
)
```

#### **❌ WRONG: Manual Image Processing**
```swift
// ❌ WRONG: Don't manually process images
let processedImage = processImageForOCR(image)

// ✅ CORRECT: Let framework handle image processing
let ocrView = platformOCRWithVisualCorrection_L1(
    image: image,  // Framework handles processing
    textTypes: [.price, .date],
    language: .english
) { result in
    // Handle result
}
```

### **OCR Best Practices**

#### **1. Use Appropriate Text Types**
```swift
// ✅ CORRECT: Specify relevant text types
let ocrView = platformOCRWithVisualCorrection_L1(
    image: receiptImage,
    textTypes: [.price, .date],  // Only what you need
    language: .english
) { result in
    // Handle result
}
```

#### **2. Set Appropriate Confidence Thresholds**
```swift
// ✅ CORRECT: Use appropriate confidence levels
let ocrView = platformOCRWithVisualCorrection_L1(
    image: myImage,
    textTypes: [.price, .date],
    language: .english,
    confidenceThreshold: 0.8  // Adjust based on use case
) { result in
    // Handle result
}
```

#### **3. Use Context for Complex Scenarios**
```swift
// ✅ CORRECT: Use OCRContext for complex scenarios
let context = OCRContext(
    textTypes: [.price, .date, .number],
    language: .english,
    confidenceThreshold: 0.8,
    allowsEditing: true,
    documentType: .receipt
)

let ocrView = platformOCRWithVisualCorrection_L1(
    image: myImage,
    context: context
) { result in
    // Handle contextual result
}
```

#### **4. Integrate with Business Logic Through Hints**
```swift
// ✅ CORRECT: Use hints for business-specific OCR behavior
let businessHints = PresentationHints(
    dataType: .form,
    presentationPreference: .form,
    complexity: .moderate,
    context: .create,
    customPreferences: [
        "businessType": "expense",
        "ocrEnabled": "true",
        "ocrTextTypes": "price,date",
        "ocrLanguage": "english",
        "ocrConfidenceThreshold": "0.8",
        "ocrDocumentType": "receipt"
    ]
)
```

### **OCR Troubleshooting**

#### **Issue: "OCR not working"**
```swift
// Problem: OCR function not recognizing text
// Solution: Check image quality and text types
let ocrView = platformOCRWithVisualCorrection_L1(
    image: clearImage,  // Ensure image is clear
    textTypes: [.generalText],  // Start with general text
    language: .english,
    confidenceThreshold: 0.5  // Lower threshold for testing
) { result in
    if result.isValid {
        print("OCR working: \(result.extractedText)")
    } else {
        print("OCR failed: \(result.error?.localizedDescription ?? "Unknown error")")
    }
}
```

#### **Issue: "Low confidence results"**
```swift
// Problem: OCR results have low confidence
// Solution: Adjust confidence threshold and image quality
let ocrView = platformOCRWithVisualCorrection_L1(
    image: highQualityImage,  // Use high-quality image
    textTypes: [.price, .date],
    language: .english,
    confidenceThreshold: 0.6  // Lower threshold
) { result in
    // Handle result
}
```

#### **Issue: "Wrong text types detected"**
```swift
// Problem: OCR detecting wrong text types
// Solution: Use more specific text types
let ocrView = platformOCRWithVisualCorrection_L1(
    image: myImage,
    textTypes: [.price],  // More specific text type
    language: .english,
    confidenceThreshold: 0.8
) { result in
    // Handle result
}
```

---

## 📊 **DataFrame Analysis and Intelligence**

### **DataFrame System Overview**
The SixLayer Framework now includes comprehensive DataFrame analysis capabilities built on Apple's `TabularData` framework. This provides intelligent data analysis, pattern detection, and visualization recommendations following the Layer 1 Semantic Intent philosophy.

### **Core DataFrame Philosophy**
Just like other framework features, DataFrame analysis follows the **Layer 1 Semantic Intent** principle:
- **Apps express WHAT they want to analyze, not HOW to implement it**
- **Framework handles all TabularData complexity internally**
- **Business logic goes through the hints system**
- **Automatic visualization recommendations based on data patterns**

### **Available DataFrame Functions**

#### **1. Basic DataFrame Analysis (Primary Function)**
```swift
// ✅ CORRECT: Express intent, let framework handle analysis
let analysisView = platformAnalyzeDataFrame_L1(
    dataFrame: myDataFrame,
    hints: DataFrameAnalysisHints(
        focusArea: .comprehensive,
        analysisDepth: .detailed,
        includeVisualizations: true
    )
)
```

#### **2. Data Quality Assessment**
```swift
// ✅ CORRECT: Assess data quality with intelligent analysis
let qualityView = platformAssessDataQuality_L1(
    dataFrame: myDataFrame,
    hints: DataFrameAnalysisHints(
        focusArea: .dataQuality,
        analysisDepth: .standard
    )
)
```

#### **3. DataFrame Comparison**
```swift
// ✅ CORRECT: Compare multiple DataFrames
let comparisonView = platformCompareDataFrames_L1(
    dataFrames: [dataFrame1, dataFrame2, dataFrame3],
    hints: DataFrameAnalysisHints(
        focusArea: .comparative,
        analysisDepth: .detailed
    )
)
```

### **DataFrame Analysis Hints**
The framework provides intelligent hints for DataFrame analysis:

```swift
public struct DataFrameAnalysisHints {
    public let focusArea: DataFrameFocusArea
    public let analysisDepth: DataFrameAnalysisDepth
    public let includeVisualizations: Bool
    public let customAnalysisOptions: [String: Any]
}

public enum DataFrameFocusArea {
    case comprehensive      // Full analysis
    case dataQuality       // Focus on data quality issues
    case patterns          // Focus on pattern detection
    case statistical       // Focus on statistical analysis
    case comparative       // Focus on DataFrame comparison
    case visualization     // Focus on visualization recommendations
}

public enum DataFrameAnalysisDepth {
    case basic            // Quick analysis
    case standard         // Balanced analysis
    case detailed         // Comprehensive analysis
    case exhaustive       // Deep analysis with all features
}
```

### **DataFrame Analysis Capabilities**

#### **1. Automatic Column Type Detection**
```swift
// Framework automatically detects:
// - Numeric columns (Int, Double, Float)
// - Categorical columns (String with limited unique values)
// - Date/Time columns (Date, String with date patterns)
// - Boolean columns (Bool)
// - ID columns (String with ID patterns)
// - URL columns (String with URL patterns)
```

#### **2. Pattern Detection**
```swift
// Framework automatically detects:
// - Time series patterns
// - Categorical data patterns
// - Missing data patterns
// - Outlier patterns
// - Correlation patterns
```

#### **3. Statistical Analysis**
```swift
// Framework provides:
// - Descriptive statistics (mean, median, mode, std dev)
// - Distribution analysis
// - Correlation analysis
// - Trend analysis
// - Outlier detection
```

#### **4. Data Quality Assessment**
```swift
// Framework assesses:
// - Missing data percentage
// - Data completeness
// - Data consistency
// - Data accuracy indicators
// - Data freshness
```

#### **5. Visualization Recommendations**
```swift
// Framework recommends:
// - Line charts for time series data
// - Bar charts for categorical data
// - Scatter plots for correlation analysis
// - Tables for detailed data views
// - Custom visualizations based on data patterns
```

### **DataFrame Integration with Data Intelligence**

#### **1. DataIntrospection Integration**
```swift
// DataFrame analysis integrates with existing DataIntrospectionEngine
let introspection = DataIntrospectionEngine()
let analysis = DataFrameAnalysisEngine()

// Combined analysis provides:
// - Data structure understanding
// - Data quality assessment
// - Pattern recognition
// - Visualization recommendations
```

#### **2. DataPresentationIntelligence Integration**
```swift
// DataFrame analysis enhances DataPresentationIntelligence
let presentation = DataPresentationIntelligence()

// Enhanced capabilities:
// - Advanced statistical analysis
// - Pattern-based visualization recommendations
// - Data-driven presentation strategies
// - Intelligent chart selection
```

### **DataFrame Analysis Examples**

#### **1. Sales Data Analysis**
```swift
// Given: Sales DataFrame with columns: date, product, quantity, price, region
let salesHints = DataFrameAnalysisHints(
    focusArea: .comprehensive,
    analysisDepth: .detailed,
    includeVisualizations: true
)

let salesAnalysis = platformAnalyzeDataFrame_L1(
    dataFrame: salesDataFrame,
    hints: salesHints
)

// Framework automatically:
// - Detects time series pattern (date column)
// - Identifies categorical data (product, region)
// - Calculates sales trends and statistics
// - Recommends line charts for trends, bar charts for categories
```

#### **2. Customer Data Quality Assessment**
```swift
// Given: Customer DataFrame with potential data quality issues
let qualityHints = DataFrameAnalysisHints(
    focusArea: .dataQuality,
    analysisDepth: .standard
)

let qualityAssessment = platformAssessDataQuality_L1(
    dataFrame: customerDataFrame,
    hints: qualityHints
)

// Framework automatically:
// - Identifies missing data patterns
// - Detects data inconsistencies
// - Assesses data completeness
// - Provides quality improvement recommendations
```

#### **3. Multi-DataFrame Comparison**
```swift
// Given: Multiple DataFrames for comparison
let comparisonHints = DataFrameAnalysisHints(
    focusArea: .comparative,
    analysisDepth: .detailed
)

let comparison = platformCompareDataFrames_L1(
    dataFrames: [q1Data, q2Data, q3Data, q4Data],
    hints: comparisonHints
)

// Framework automatically:
// - Compares data structures
// - Identifies differences and similarities
// - Provides comparative statistics
// - Recommends comparative visualizations
```

### **DataFrame Analysis Best Practices**

#### **1. Use Appropriate Focus Areas**
```swift
// ✅ CORRECT: Choose focus area based on your needs
let hints = DataFrameAnalysisHints(
    focusArea: .dataQuality,  // For data cleaning tasks
    analysisDepth: .standard
)

// ✅ CORRECT: Use comprehensive for general analysis
let hints = DataFrameAnalysisHints(
    focusArea: .comprehensive,  // For general exploration
    analysisDepth: .detailed
)
```

#### **2. Leverage Custom Analysis Options**
```swift
// ✅ CORRECT: Use custom options for specific needs
let hints = DataFrameAnalysisHints(
    focusArea: .patterns,
    analysisDepth: .detailed,
    customAnalysisOptions: [
        "outlierThreshold": 2.0,
        "correlationThreshold": 0.7,
        "timeSeriesGranularity": "daily"
    ]
)
```

#### **3. Combine with Business Logic**
```swift
// ✅ CORRECT: Integrate with business-specific hints
let businessHints = CustomHint(
    hintType: "sales.analysis",
    customData: [
        "seasonalPatterns": true,
        "regionalAnalysis": true,
        "productCategories": ["electronics", "clothing", "books"]
    ]
)

let analysisHints = DataFrameAnalysisHints(
    focusArea: .comprehensive,
    analysisDepth: .detailed,
    customAnalysisOptions: businessHints.customData
)
```

### **DataFrame Analysis Performance**

#### **1. Large Dataset Handling**
```swift
// Framework automatically handles:
// - Large DataFrames (10,000+ rows)
// - Memory-efficient processing
// - Progressive analysis loading
// - Performance optimization
```

#### **2. Real-time Analysis**
```swift
// Framework provides:
// - Fast analysis for real-time updates
// - Incremental analysis for streaming data
// - Cached results for repeated analysis
// - Background processing for large datasets
```

### **DataFrame Analysis Accessibility**

#### **1. Automatic Accessibility**
```swift
// Framework automatically provides:
// - VoiceOver support for analysis results
// - Keyboard navigation for interactive elements
// - High contrast support for visualizations
// - Screen reader descriptions for charts
```

#### **2. Customizable Accessibility**
```swift
// Framework allows:
// - Custom accessibility labels
// - Alternative text for visualizations
// - VoiceOver descriptions for complex data
// - Accessibility hints for interactive elements
```

### **DataFrame Analysis Testing**

#### **1. Unit Testing**
```swift
// Test DataFrame analysis functions
func testDataFrameAnalysis() {
    let dataFrame = createTestDataFrame()
    let hints = DataFrameAnalysisHints(
        focusArea: .comprehensive,
        analysisDepth: .standard
    )
    
    let view = platformAnalyzeDataFrame_L1(
        dataFrame: dataFrame,
        hints: hints
    )
    
    XCTAssertNotNil(view)
}
```

#### **2. Integration Testing**
```swift
// Test DataFrame analysis integration
func testDataFrameIntegration() {
    let dataFrame = createSalesDataFrame()
    let hints = createSalesAnalysisHints()
    
    let analysis = DataFrameAnalysisEngine()
    let result = analysis.analyzeDataFrame(dataFrame, hints: hints)
    
    XCTAssertTrue(result.patterns.isTimeSeries)
    XCTAssertEqual(result.columnTypes.count, 5)
    XCTAssertFalse(result.visualizationRecommendations.isEmpty)
}
```

### **Common DataFrame Analysis Mistakes to Avoid**

#### **1. Using Raw TabularData Instead of Framework Functions**
```swift
// ❌ WRONG: Direct TabularData usage
let column = dataFrame.columns[0]
let values = column.compactMap { $0 }

// ✅ CORRECT: Use framework functions
let analysis = platformAnalyzeDataFrame_L1(
    dataFrame: dataFrame,
    hints: hints
)
```

#### **2. Ignoring Analysis Hints**
```swift
// ❌ WRONG: Not using hints for customization
let analysis = platformAnalyzeDataFrame_L1(
    dataFrame: dataFrame,
    hints: DataFrameAnalysisHints()  // Default hints only
)

// ✅ CORRECT: Use appropriate hints
let analysis = platformAnalyzeDataFrame_L1(
    dataFrame: dataFrame,
    hints: DataFrameAnalysisHints(
        focusArea: .dataQuality,
        analysisDepth: .detailed
    )
)
```

#### **3. Not Leveraging Integration Capabilities**
```swift
// ❌ WRONG: Using DataFrame analysis in isolation
let analysis = platformAnalyzeDataFrame_L1(dataFrame: df, hints: hints)

// ✅ CORRECT: Integrate with existing data intelligence
let introspection = DataIntrospectionEngine()
let analysis = platformAnalyzeDataFrame_L1(dataFrame: df, hints: hints)
// Framework automatically integrates with DataIntrospection
```

### **DataFrame Analysis Troubleshooting**

#### **1. Performance Issues**
```
Problem: DataFrame analysis is slow
Solution: Use appropriate analysisDepth (.basic for quick analysis)
         Consider using .dataQuality focus for large datasets
```

#### **2. Missing Visualizations**
```
Problem: No visualization recommendations
Solution: Set includeVisualizations: true in hints
         Ensure data has recognizable patterns
```

#### **3. Incorrect Column Type Detection**
```
Problem: Column types not detected correctly
Solution: Check data format and patterns
         Use customAnalysisOptions for specific type hints
```

## 🎯 **Generic Content Presentation (Runtime-Unknown Content)**

### **When to Use `platformPresentContent_L1`**

**⚠️ IMPORTANT**: This function is reserved for **rare cases** where content type is unknown at compile time. For known content types, use the specific functions:

- `platformPresentItemCollection_L1` for collections
- `platformPresentFormData_L1` for forms  
- `platformPresentMediaData_L1` for media
- etc.

### **Use Cases for `platformPresentContent_L1`**

#### **1. Dynamic API Responses**
```swift
// When API returns unknown content structure
let apiResponse: Any = [
    "type": "unknown",
    "data": [
        ["name": "Item 1", "value": 100],
        ["name": "Item 2", "value": 200]
    ]
]

let view = platformPresentContent_L1(
    content: apiResponse,
    hints: PresentationHints(
        dataType: .generic,
        presentationPreference: .automatic,
        complexity: .moderate,
        context: .dashboard
    )
)
```

#### **2. User-Generated Content**
```swift
// When users upload content of unknown type
let userContent: Any = [
    "title": "User Post",
    "content": "Some user content",
    "attachments": ["image1.jpg", "document.pdf"],
    "metadata": ["created": Date(), "likes": 42]
]

let view = platformPresentContent_L1(
    content: userContent,
    hints: PresentationHints(
        dataType: .generic,
        presentationPreference: .automatic,
        complexity: .moderate,
        context: .feed
    )
)
```

#### **3. Mixed Content Types**
```swift
// When content contains multiple unknown types
let mixedContent: Any = [
    "text": "Some text content",
    "image": "test-image",
    "data": ["key": "value"]
]

let view = platformPresentContent_L1(
    content: mixedContent,
    hints: PresentationHints(
        dataType: .generic,
        presentationPreference: .automatic,
        complexity: .moderate,
        context: .modal
    )
)
```

### **How It Works**

The function analyzes content type at runtime and delegates to appropriate specific functions:

1. **Known Types**: Delegates to specific functions (forms, collections, media, etc.)
2. **Unknown Types**: Uses fallback presentation with generic UI
3. **Mixed Content**: Attempts to convert to known types or uses fallback

### **Best Practices**

#### **✅ DO: Use for truly unknown content**
```swift
// Dynamic API responses
let view = platformPresentContent_L1(content: apiResponse, hints: hints)

// User-generated content
let view = platformPresentContent_L1(content: userContent, hints: hints)
```

#### **❌ DON'T: Use for known content types**
```swift
// ❌ WRONG: Use specific function for known types
let vehicles: [GenericVehicle] = getVehicles()
let view = platformPresentContent_L1(content: vehicles, hints: hints)

// ✅ CORRECT: Use specific function
let view = platformPresentItemCollection_L1(items: vehicles, hints: hints)
```

### **Performance Considerations**

- **Runtime Analysis**: Content type analysis happens at runtime
- **Delegation Overhead**: Slight overhead for type checking and delegation
- **Fallback UI**: Generic fallback UI for unknown content types
- **Use Sparingly**: Only use when content type is truly unknown at compile time

---

**Remember**: The SixLayer Framework is a **generic foundation** that becomes **business-specific** through the extensible hints system. Help developers understand this architecture and use it correctly.
