# 🤖 AI Agent Guide for SixLayer Framework

*This document is specifically designed for AI agents (like Claude, GPT, etc.) to understand how to work with the SixLayer Framework's generic core + extensible business logic architecture.*

## 🎯 **Purpose of This Guide**

AI agents need to understand:
- **Framework Architecture**: Generic core with extensible business logic
- **How to Use Generic Functions**: Layer 1 functions with business-specific hints
- **Extensible Hints System**: CustomHint and EnhancedPresentationHints
- **Best Practices**: Combining generic framework with business needs

## 🏗️ **Framework Architecture (Correct Understanding)**

### **Generic Core + Extensible Business Logic**

The SixLayer Framework is **NOT** a business-specific framework. It's a **generic foundation** that becomes business-specific through the extensible hints system:

```
Generic Core (Framework) + Business-Specific Hints = Business-Specific Behavior
```

### **Key Architecture Principles:**

1. **Core Remains Generic**: Data types, functions, and logic are business-agnostic
2. **Business Logic Through Hints**: CustomHint system enables business-specific behavior
3. **Extensibility Without Modification**: Add business logic without changing framework code
4. **Reusable Across Domains**: Same framework works for vehicles, e-commerce, social media, etc.

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
                    .foregroundColor(.secondary)
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

### **1. Expecting Business-Specific Functions:**
```swift
// ❌ WRONG: This function doesn't exist
let view = platformPresentVehicleForm_L1(data: vehicleData)

// ✅ CORRECT: Use generic function with business hints
let view = platformPresentFormData_L1(
    fields: convertVehicleToFields(vehicleData),
    hints: createVehicleHints()
)
```

### **2. Assuming Business Types Are Built-In:**
```swift
// ❌ WRONG: These cases don't exist in core enums
case vehicleCreation, expenseEntry, fuelFillup

// ✅ CORRECT: Use generic types with business hints
case form  // Generic type
// Business logic in hints:
customPreferences: ["businessType": "vehicle"]
```

### **3. Ignoring the Extensible Hints System:**
```swift
// ❌ WRONG: Trying to hardcode business logic
if businessType == "vehicle" { ... }

// ✅ CORRECT: Use the hints system
let hints = PresentationHints(...)
let customData = hints.customPreferences
if customData["businessType"] == "vehicle" { ... }
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

## 🎯 **Best Practices Summary**

1. **Always use generic functions** with business-specific hints
2. **Leverage the extensible hints system** for business logic
3. **Use customPreferences** for business configuration
4. **Create CustomHint extensions** for complex business behavior
5. **Keep framework generic** while enabling business functionality
6. **Build business logic on top** of the generic foundation

## 🤝 **Working with Developers**

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

---

**Remember**: The SixLayer Framework is a **generic foundation** that becomes **business-specific** through the extensible hints system. Help developers understand this architecture and use it correctly.
